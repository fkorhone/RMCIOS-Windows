from RMCIOS_API import *

CHFUNC = ctypes.CFUNCTYPE(None, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_void_p, ctypes.c_int, ctypes.c_void_p)

def float_param_to_python(context, paramtype, param, index):
    float_array_type = ctypes.c_float * (index + 1)
    floats = float_array_type.from_address(param)
    return floats[index]

def int_param_to_python(context, paramtype, param, index):
    int_array_type = ctypes.c_int * (index + 1)
    ints = int_array_type.from_address(param)
    return ints[index]

def buffer_param_to_python(context, paramtype, param, index):
    buffer_array_type = buffer_rmcios * (index + 1)
    buffers = buffer_array_type.from_address(param)
    buf = buffers[index]
    data_array_type = ctypes.c_char * buf.length
    data_array = data_array_type.from_address( ctypes.cast(buf.data,ctypes.c_void_p).value )
    return data_array.value.decode()

def binary_param_to_python(context, paramtype, param, index):
    buffer_array_type = buffer_rmcios * (index + 1)
    buffers = buffer_array_type.from_address(param)
    buf = buffers[index]
    data_array_type = ctypes.c_char * buf.length
    data_array = data_array_type.from_address( ctypes.cast(buf.data,ctypes.c_void_p).value )
    return data_array.value

def combo_param_to_python(context, paramtype, param, index):
    return None


conversion_functions = [None, 
                        int_param_to_python, 
                        float_param_to_python,
                        buffer_param_to_python,
                        None,
                        binary_param_to_python,
                        combo_param_to_python,
                        ]

# array to keep callback references alive. We don't want funcs to be garbage collected.
funcrefs = []

def param_to_python(context, paramtype, param, index):
    if paramtype >= len(conversion_functions):
        return None
    if conversion_functions[paramtype] == 0:
        return None
    pyparam = conversion_functions[paramtype](context, paramtype, param, index)
    return pyparam

def ch_func(data, context, id, function, paramtype, returnv, num_params, param):
      # Convert data pointer to python object
      cpobject = ctypes.cast(data, ctypes.POINTER(ctypes.py_object))
      python_object = cpobject.contents.value
      print(python_object)

      # Convert context pointer to python context object
      python_context = CONTEXT.from_address(context)
      python_context.c_context = context

      # convert prameters to python list with python objects
      pyparams = []
      for index in range(num_params):
        pyparams.append(param_to_python(python_context, paramtype, param, index))

      # Look for function to execute from python object:
      try:
        name = functions_rmcios[function]
        func = getattr(python_object, name)
        func(python_object, python_context, id, *pyparams)
      except:
        print("Error executing python object member function")
      
      return

def create_channel(context, name, data):
      x = CONTEXT.from_address(context)
      namebuffer = ctypes.create_string_buffer(name.encode())
     
      # Create c function pointer and convert it to generic c buffer (char *)
      channel = CHFUNC(ch_func)
      funcrefs.append(channel)
      func_as_c_buffer = ctypes.cast(ctypes.pointer(channel), ctypes.POINTER(ctypes.c_char))
     
      # Create c data pointer and convert it to generic c buffer (char *)
      pobject = ctypes.pointer(ctypes.py_object(data))
      ptr_as_c_buffer = ctypes.cast( ctypes.pointer(pobject), ctypes.POINTER(ctypes.c_char)) 
      
      # Create array of binary parameters  for channel execution:
      buffers_type= buffer_rmcios * 3
      buffers = buffers_type( (namebuffer, len(name), 0, len(name), 0),
                            ( func_as_c_buffer, ctypes.sizeof(channel), 0, ctypes.sizeof(channel), 0),
                            ( ptr_as_c_buffer, ctypes.sizeof(pobject), 0, ctypes.sizeof(pobject), 0))

      # Call channel context.create to create the new channel
      x.run_channel(x.data, context, x.create, create_rmcios, binary_rmcios, 0, 3, buffers)

def run_channel(context, channel, function, *args):
    #params = combo_rmcios() * len(args)
    len(args)
    pure_ints = True
    pure_floats = True
    pure_buffers = True

    for arg in args:
        if isinstance(arg, int):
            pure_floats = False
            pure_buffers = False

        if isinstance(arg, float):
            pure_ints = False
            pure_buffers = False

        if isinstance(arg, str):
            pure_ints = False
            pure_floats = False

        if isinstance(arg, (bytes, bytearray)):
            pure_ints = False
            pure_floats = False

    if(pure_ints):
        intargtype = ctypes.c_int * len(args)
        return context.run_channel(context.data, context.c_context, channel, function, int_rmcios, 0, len(args), intargtype(*args))

    if(pure_floats):
        floatargtype = ctypes.c_float * len(args)
        return context.run_channel(context.data, context.c_context, channel, function, float_rmcios, 0, len(args), floatargtype(*args))
    
    if(pure_buffers):
        buffersargtype= buffer_rmcios * len_args
        buffers=[]
        for arg in args:
            namebuffer = ctypes.create_string_buffer(arg.encode())
            buffers.append((namebuffer, len(arg), 0, len(arg), 0))
        return context.run_channel(context.data, context.c_context, channel, function, float_rmcios, 0, len(args), buffersargtype(buffers))

def help_channel(context, channel, *args):
    run_channel(context, channel, help_rmcios, *args)

def setup_channel(context, channel, *args):
    run_channel(context, channel, setup_rmcios, *args)

def read_channel(context, channel, *args):
    run_channel(context, channel, read_rmcios, *args)

def write_channel(context, channel, *args):
    run_channel(context, channel, write_rmcios, *args)
      
