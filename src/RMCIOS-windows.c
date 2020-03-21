/* 
RMCIOS - Reactive Multipurpose Control Input Output System
Copyright (c) 2018 Frans Korhonen

RMCIOS was originally developed at Institute for Atmospheric 
and Earth System Research / Physics, Faculty of Science, 
University of Helsinki, Finland

Assistance, experience and feedback from following persons have been 
critical for development of RMCIOS: Erkki Siivola, Juha Kangasluoma, 
Lauri Ahonen, Ella Häkkinen, Pasi Aalto, Joonas Enroth, Runlong Cai, 
Markku Kulmala and Tuukka Petäjä.

This file is part of RMCIOS. This notice was encoded using utf-8.

RMCIOS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

RMCIOS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public Licenses
along with RMCIOS.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
 * Changelog: (date,who,description)
 */

#include "RMCIOS-system.h"

#include <stdio.h>
#include <windows.h>
#include <dirent.h>

/// @brief execute a script of commands from file:
/// 
/// @param fconf FILE that contain the data
/// @param fresult file for output or NULL
///
/// @snippet examples.c execute_file
void execute_file (const struct context_rmcios *context, FILE * fconf,
                   FILE * fresult);

void execute_str (const struct context_rmcios *context, const char *input,
                  char *output, unsigned int max_output_len);

typedef void (__cdecl * f_init_channels) (const struct context_rmcios *
                                          context);

int stdin_linked_channel = 0;
int stdin_id = 0;
HANDLE hStdin, hStdout;
DWORD dwRead, dwWritten;

// Channel for setting stdinput destination. And writing to stdout
void stdio_class_func (void *this,
                        const struct context_rmcios *context, int id,
                        enum function_rmcios function,
                        enum type_rmcios paramtype,
                        struct combo_rmcios *returnv,
                        int num_params, const union param_rmcios param)
{
   int plen;
   const char *s;
   switch (function)
   {
   case write_rmcios:
      if (num_params < 1)
         break;
      // Determine the needed buffer size
      plen = param_string_alloc_size (context, paramtype, param, 0);
      {
         char buffer[plen];     // allocate buffer
         s = param_to_string (context, paramtype, param, 0, plen, buffer);
         WriteFile (hStdout, s, strlen (s), &dwWritten, NULL);
      }
      break;
   }
}


///////////////////////////////////////////////////////////////////////////////////
// Channel for printf                                                            //
///////////////////////////////////////////////////////////////////////////////////
void stdout_func (void *data,
                        const struct context_rmcios *context, int id,
                        enum function_rmcios function,
                        enum type_rmcios paramtype,
                        struct combo_rmcios *returnv,
                        int num_params, const union param_rmcios param)
{
   switch (function)
   {
   case write_rmcios:
      if (num_params < 1)
         break;
      int blen = param_string_alloc_size (context, paramtype, param, 0);
      {
         char buffer[blen];
         const char *str;
         str = param_to_string (context, paramtype, param, 0, blen, buffer);
         puts (str);
      }
      break;
   }
}

// Channel function for allocating and freeing memory
void mem_func (void *data,
               const struct context_rmcios *context, int id,
               enum function_rmcios function,
               enum type_rmcios paramtype,
               struct combo_rmcios *returnv,
               int num_params, const union param_rmcios param)

{
   switch (function)
   {
   case help_rmcios:
      // MEMORY INTERFACE: 
      return_string (context, returnv,
                     " read mem \r\n -read ammount of free memory\r\n"
                     " write mem \r\n -read memory allocation block size\r\n"
                     " write mem n_bytes \r\n Allocate n bytes of memory\r\n"
                     "   -Returns address of the allocated memory\r\n"
                     "   -On n_bytes < 0 allocates complete allocation blocks\r\n"
                     "   -returns 0 length on failure\r\n"
                     " write mem (empty) addr(buffer/id)  \r\n"
                     "  -free memory pointed by addr in buffer\r\n"
                     );
      break;
   case read_rmcios:
      if (num_params == 0)      // read ammount of free memory
         if (num_params > 0)    //read memory block by remote access id
            if (num_params > 1) // +size bytes to read
               if (num_params > 2)      // +offset to start reading from\r\n");
                  break;

   case write_rmcios:
      if (num_params == 0)
      {
      } // Read memory allocation block size
      if (num_params == 1)      // Allocate n bytes of memory
      {
         int size = param_to_integer (context, paramtype,
                                      (const union param_rmcios)
                                      param, 0);
         void *ptr = malloc (size);
         return_binary (context, returnv, (char *) &ptr,
                        sizeof (ptr));
      }
      if (num_params > 1)
      {
      } // Write data to memory by access id
      if (num_params > 2)
      {
      } // +max size in bytes
      if (num_params > 3)
      {
      } // +starting at offset
      if (num_params == 2)      // Free 
      {
         if (param_to_integer
             (context, paramtype, (const union param_rmcios) param, 0) == 0)
         {
            char *ptr = NULL;
            param_to_binary (context, paramtype, param, 1,
                             sizeof (ptr), (char *) &ptr);
            if (ptr != NULL)
               free (ptr);
         }
      }
      break;
   }
}

// Linked list of buffered data
struct buffer_queue
{
   char *data;                  // Pointer to buffer that contains data
   int length;                  // Length of data in the buffer
   int size;                    // Size of the buffer
   struct buffer_queue *next;   // Pointer to next item in the list
};

void execute_str (const struct context_rmcios *context, const char *input,
                  char *output, unsigned int max_output_len)
{
   struct buffer_rmcios return_buff;
   return_buff.data = output;
   // length of data currently in buffer
   return_buff.length = 0;      
   return_buff.size = 0;
   struct combo_rmcios rvalue= {
      .paramtype = buffer_rmcios,
      .num_params = 1,
      .param = &return_buff
   };
   if (max_output_len > 0)
      // leave space for NULL
      return_buff.size = max_output_len - 1;  
   execute (context, input, &rvalue); 
   // Execute output to buffer
   if (return_buff.size > 0 && return_buff.data != NULL)
      // add NULL termination char
      return_buff.data[return_buff.length] = 0; 
}
// data_handle_name,MAX_CLASSES,MAX_CHANNELS
CREATE_STATIC_CHANNEL_SYSTEM_DATA (ch_sys_dat, 100, 500);  

int main (int argc, char *argv[])
{
   // Command line parameters:
   const char *init_filename;
   init_filename = "conf.ini";
   if (argc > 1)
      init_filename = argv[1];

   // Get stdout handle (can be redirected)
   hStdout = GetStdHandle (STD_OUTPUT_HANDLE);  

   if (argc > 2 && strcmp ("help", argv[1]) == 0)
      // set stdout to console
      freopen ("NULL", "w+", stdout);   
   else
      // set stdout to console
      freopen ("CONOUT$", "w+", stdout);       

   printf ("\nRMCIOS - Reactive Multipurpose Control Input Output Systen\n["
           VERSION_STR "] \n");
   printf ("Copyright (c) 2018 Frans Korhonen\n");
   printf ("\nInitializing system:\r\n");
   ////////////////////////////////////////////////////////////////////////
   // Init channel system
   ////////////////////////////////////////////////////////////////////////
   const struct context_rmcios *context;
  
   // init channel api system
   set_channel_system_data ((struct ch_system_data *) &ch_sys_dat);     
   context = get_rmios_context ();

   //////////////////////////////////////////////////////////////////////
   // Load DLL modules :
   //////////////////////////////////////////////////////////////////////
   DIR *d;
   struct dirent *dir;
   char mname[1024];
   int mlen;

   // Dont show dialog boxes when dlls fail to load:
   UINT oldMode = SetErrorMode(0);
   SetErrorMode(oldMode | SEM_FAILCRITICALERRORS | SEM_NOOPENFILEERRORBOX);

   // Get the actual program executable position
   mlen = GetModuleFileNameA (NULL,     // _In_opt_ HMODULE hModule,
                              mname,    // _Out_    LPTSTR  lpFilename,
                              sizeof (mname));  //_In_     DWORD   nSize
   if (mlen == 0)
      printf ("ERROR! Could not get program path!"
              " Program path possibly too long...\n");

   int i;
   for (i = mlen - 2; i > 0; i--)  // Remove the executable name
   {
      if (mname[i] == '\\' || mname[i] == '/')
      {
         mname[i + 1] = 0;
         break;
      }
   }
   strcat (mname, "modules");

   d = opendir (mname);
   int slen;
   char dll_name[255];
   if (d)
   {
      printf ("Loading modules:\r\n");
      while ((dir = readdir (d)) != NULL)
      {
         slen = strlen (dir->d_name);
         if (slen > 4 &&
             dir->d_name[slen - 4] == '.' &&
             dir->d_name[slen - 3] == 'd' &&
             dir->d_name[slen - 2] == 'l' && 
             dir->d_name[slen - 1] == 'l')
         // It's a .dll
         {
            strcpy (dll_name, "modules/");
            strcat (dll_name, dir->d_name);
            printf ("\r\n%s: ", dll_name);

            HINSTANCE hGetProcIDDLL = LoadLibrary (dll_name);
            if (!hGetProcIDDLL)
               printf ("could not load the dynamic library\r\n");
            f_init_channels dll_init =
               (f_init_channels) GetProcAddress (hGetProcIDDLL,
                                                 "init_channels");
            if (dll_init == NULL)
               printf
                  ("could not load \"init_channels\" function from %s.\r\n",
                   dll_name);
            else
            {
               // initialize the module
               dll_init (context);      
            }
         }
      }
      closedir (d);
   }

   printf ("\r\nModules processed.\r\n\r\n");

   //////////////////////////////////////////////////////////////////////////
   // stdio channel
   //////////////////////////////////////////////////////////////////////////
   stdin_id =
      create_channel_str (context, "stdio", (class_rmcios) stdio_class_func,
                          NULL);
   execute_str (context, "link stdio control", NULL, 0);

   stdin_linked_channel = linked_channels (context, stdin_id);

   /////////////////////////////////////////////////////
   // channel help readout
   /////////////////////////////////////////////////////
   if (argc > 2 && strcmp ("help", argv[1]) == 0)
   {
      init_filename = argv[1];

      if (stdin_linked_channel != 0)
      {
         write_str (context, stdin_linked_channel, "help ", stdin_id);
         write_str (context, stdin_linked_channel, argv[2], stdin_id);
         write_str (context, stdin_linked_channel, "\n", stdin_id);
      }
      return 1;
   }

   ///////////////////////////////////////////////////////////////////////
   // initial configuration 
   ///////////////////////////////////////////////////////////////////////
   FILE *fconf;
   fconf = fopen (init_filename, "r");
   if (fconf != NULL)
   {
       const char *command="read as control file \"" ;
       char buffer[strlen(init_filename)+strlen(command)+1] ;
       buffer[0]=0;
       strcat(buffer,command) ;
       strcat(buffer,init_filename) ;
       strcat(buffer,"\"") ;
       char *s=buffer;
       while(*s!=0)
       {
         if(*s=='\\') *s='/' ; // Replace windows \ into /
         s++ ;
       }
       execute_str (context, buffer, NULL, 0);
       
       fclose (fconf);
   }
   else
      printf ("Could not open initial configuration: %s\n", init_filename);

   //////////////////////////////////////////////////////////////////////
   // configuration logging (conf.log)
   //////////////////////////////////////////////////////////////////////
   char c;
   printf ("Logging configuration: conf.log\r\n");
   // Log the configuration
   FILE *conflog = fopen ("conf.log", "a");     
   if (conflog != NULL)
   {
      char buffer[256];
      buffer[0] = 0;
      read_str (context, channel_enum (context, "rtc_str"), buffer, 256);
      fprintf (conflog,
               "\n\n# RESTART at %s #############################\n", buffer);

      // Local filesystem
      fconf = fopen (init_filename, "r");      
      // Log the configuration
      if (fconf != NULL)
      {
         fprintf (conflog, "# Config from /local/conf.ini:\n");
         while ((c = fgetc (fconf)) != EOF)
            fputc (c, conflog);
         fclose (fconf);
      }
      else
         printf ("Could not open for reading: %s\r\n", init_filename);
      // Log the configuration
      fclose (conflog); 
   }
   else
      printf ("Could not open for appending: conf.log \r\n");

   printf ("\r\nSystem initialized!\r\n");

   /////////////////////////////////////////////////////////////////////////
   // reception loop
   /////////////////////////////////////////////////////////////////////////
   char s[2];
   s[1] = 0;
   while (1)
   {
      s[0] = getchar ();
      s[1] = 0;
      if (stdin_linked_channel != 0)
         write_str (context, stdin_linked_channel, s, stdin_id);
   }
}
