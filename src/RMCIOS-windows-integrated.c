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
 *
 */

#include "channel_system.h"

#include <stdio.h>
#include <windows.h>
#include <dirent.h>
typedef void (__cdecl * f_set_channel_api) (struct channel_api_functions *
                                            funcs);
typedef void (__cdecl * f_init_channels) ();

int stdin_linked_channel = 0;
int stdin_id = 0;
HANDLE hStdin, hStdout;
DWORD dwRead, dwWritten;

// Channel for setting stdinput destination. And writing to stdout
void stdio_class_func (void *this, int function, int paramtype, void *returnv,
                       int num_params, const void *param)
{
   int plen;
   const char *s;
   switch (function)
   {
   case write_:
      if (num_params < 1)
         break;
      // Determine the needed buffer size
      plen = param_string_alloc_size (paramtype, param, 0);
      {
         char buffer[plen];     // allocate buffer
         s = param_to_string (paramtype, param, 0, plen, buffer);
         WriteFile (hStdout, s, strlen (s), &dwWritten, NULL);
      }
      break;
   case link_:
      if (num_params < 1)
         break;
      stdin_linked_channel = param_to_int (paramtype, param, 0);
      break;

   }
}

int main (int argc, char *argv[])
{
   // Command line parameters:
   const char *init_filename;
   init_filename = "conf.ini";
   if (argc > 1)
      init_filename = argv[1];

   hStdout = GetStdHandle (STD_OUTPUT_HANDLE);  // Get stdout handle (can be redirected)
   //hStdin = GetStdHandle(STD_INPUT_HANDLE);  // Get stin handle (can be redirected)

   if (argc > 2 && strcmp ("help", argv[1]) == 0)
      freopen ("NULL", "w+", stdout);   // set stdout to console
   else
      freopen ("CONOUT$", "w+", stdout);        // set stdout to console

   printf ("\nChannel System [" VERSION_STR "] \r\n");
   printf ("Copyright (c) 2016 Frans Korhonen / University of Helsinki. \r\n");
   printf ("\nInitializing system:\r\n");
   /////////////////////////////////////////////////////////////////////////////////////
   // Init channel system
   /////////////////////////////////////////////////////////////////////////////////////
   CREATE_STATIC_CHANNEL_SYSTEM_DATA (ch_sys_dat, 100, 500);    // data_handle_name,MAX_CLASSES,MAX_CHANNELS
   set_channel_api (get_channel_api_functions ());      // Set channel api interface functions
   set_channel_system_data ((struct ch_system_data *) &ch_sys_dat);     // init channel api system

   printf ("Loading modules:\r\n");

   init_std_channels ();
   init_windows_channels ();
   init_windows_gui_channels ();
   init_serial_channels ();
   init_socket_channels ();

   printf ("\r\nModules processed.\r\n\r\n");

   ///////////////////////////////////////////////////////////////////////////////////////
   // stdio channel
   //////////////////////////////////////////////////////////////////////////////////////
   stdin_id =
      create_channel_str ("stdio", (channel_func) stdio_class_func, NULL);
   execute_str ("link stdio control", NULL, 0);

   //////////////////////////////////////////////////
   // channel help readout
   /////////////////////////////////////////////////////
   if (argc > 2 && strcmp ("help", argv[1]) == 0)
   {
      init_filename = argv[1];

      if (stdin_linked_channel != 0)
      {
         write_str (stdin_linked_channel, "help ", stdin_id);
         write_str (stdin_linked_channel, argv[2], stdin_id);
         write_str (stdin_linked_channel, "\n", stdin_id);
      }
      return 1;
   }
   ///////////////////////////////////////////////////////////////////////////////////////
   // initial configuration 
   /////////////////////////////////////////////////////////////////////////////////////////
   FILE *fconf;
   printf ("Executing: %s\r\n", init_filename);
   fconf = fopen (init_filename, "r");
   if (fconf != NULL)
   {
      //execute_file(fconf,stdout) ;
      execute_file (fconf, 0);
      fclose (fconf);
   }
   else
      printf ("Could not open initial configuration: %s\n", init_filename);

   ///////////////////////////////////////////////////////////////////////////////////////
   // configuration logging (conf.log)
   ///////////////////////////////////////////////////////////////////////////////////////
   char c;
   printf ("Logging configuration: conf.log\r\n");
   FILE *conflog = fopen ("conf.log", "a");     // Log the configuration
   if (conflog != NULL)
   {
      char buffer[256];
      buffer[0] = 0;
      //time_t seconds=time(NULL)+timezone_offset  ;
      //
      read_str (channel_enum ("rtc_str"), buffer, 256);
      fprintf (conflog,
               "\n\n# RESTART at %s #############################\n", buffer);

      // Local filesystem
      fconf = fopen (init_filename, "r");       // Log the configuration
      if (fconf != NULL)
      {
         fprintf (conflog, "# Config from /local/conf.ini:\n");
         while ((c = fgetc (fconf)) != EOF)
            fputc (c, conflog);
         fclose (fconf);
      }
      else
         printf ("Could not open for reading: %s\r\n", init_filename);
      fclose (conflog); // Log the configuration
   }
   else
      printf ("Could not open for appending: conf.log \r\n");

   printf ("\r\nSystem initialized!\r\n");

   //////////////////////////////////////////////////////////////////////////////////////
   // reception loop
   //////////////////////////////////////////////////////////////////////////////////////
   char s[2];
   s[1] = 0;
   while (1)
   {
      s[0] = getchar ();
      s[1] = 0;
      if (stdin_linked_channel != 0)
         write_str (stdin_linked_channel, s, stdin_id);
   }
}
