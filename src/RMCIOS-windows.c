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
#include "std-context.h"

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
   struct buffer_rmcios return_buff = {0};
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
#define CLASSES 100 
#define CHANNELS 500
char ch_sys_data[(1<<16)];

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
   // Setup channel system
   ////////////////////////////////////////////////////////////////////////
   const struct context_rmcios context;
  
   // init channel api system
   setup_channel_system_data (&context, sizeof(ch_sys_data), ch_sys_data, CLASSES, CHANNELS);     
   setup_std_context(&context);
   setup_rmcios_context (&context);

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
               dll_init (&context);      
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
      create_channel_str (&context, "stdio", (class_rmcios) stdio_class_func,
                          NULL);
   execute_str (&context, "link stdio control", NULL, 0);

   stdin_linked_channel = linked_channels (&context, stdin_id);

   /////////////////////////////////////////////////////
   // channel help readout
   /////////////////////////////////////////////////////
   if (argc > 2 && strcmp ("help", argv[1]) == 0)
   {
      init_filename = argv[1];

      if (stdin_linked_channel != 0)
      {
         write_str (&context, stdin_linked_channel, "help ", stdin_id);
         write_str (&context, stdin_linked_channel, argv[2], stdin_id);
         write_str (&context, stdin_linked_channel, "\n", stdin_id);
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
       execute_str (&context, buffer, NULL, 0);
       
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
      read_str (&context, channel_enum (&context, "rtc_str"), buffer, 256);
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
         write_str (&context, context.control, s, stdin_id);
   }
}
