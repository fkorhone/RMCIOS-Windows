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

/* 2015 Frans Korhonen. University of Helsinki. 
 * Changelog: (date,who,description)
 */

#include <windows.h>
#include <tchar.h>
#include <stdio.h>

#include <conio.h>

struct child_data
{
   HANDLE stdin_rd;
   HANDLE stdin_wr;
   HANDLE stdout_rd;
   HANDLE stdout_wr;
   HANDLE hProcess;
   int delimiter;
   unsigned int timeout;
   char *rx_buffer;
   unsigned int rx_buffer_len;
   unsigned int rx_index;
} *default_child = 0;


void *__declspec (dllexport)
     __cdecl start_program (void *program, const char *work_dir,
                            char *program_command)
{
   struct child_data *p = (struct child_data *) program;
   if (p == 0)
      p = default_child;

   SECURITY_ATTRIBUTES saAttr;
   PROCESS_INFORMATION piProcInfo;
   STARTUPINFO siStartInfo;
   DWORD exitCode;

   chdir (work_dir);    // Set the workingdir
   //freopen("read_program.log", "a", stdout);


   if (p != 0)  // program structure already created
   {
      GetExitCodeProcess (p->hProcess, &exitCode);
      if (exitCode == STILL_ACTIVE)
         return p;      // program still running. Return existing id
   }
   else // Allocate new child program structure
   {
      //printf("allocating new!\n") ;
      p = malloc (sizeof (struct child_data));
      p->stdin_rd = NULL;
      p->stdin_wr = NULL;
      p->stdout_rd = NULL;
      p->stdout_wr = NULL;
      p->delimiter = '\n';
      p->timeout = 500;
      p->rx_buffer = malloc (1024);
      p->rx_buffer_len = 1024;
      p->rx_index = 0;

      default_child = p;

      // Set the bInheritHandle flag so pipe handles are inherited. 
      saAttr.nLength = sizeof (SECURITY_ATTRIBUTES);
      saAttr.bInheritHandle = TRUE;
      saAttr.lpSecurityDescriptor = NULL;

      // Create a pipe for the child process's STDOUT. 
      CreatePipe (&p->stdout_rd, &p->stdout_wr, &saAttr, 0);
      // Ensure the read handle to the pipe for STDOUT is not inherited.
      SetHandleInformation (p->stdout_rd, HANDLE_FLAG_INHERIT, 0);

      // Create a pipe for the child process's STDIN. 
      CreatePipe (&p->stdin_rd, &p->stdin_wr, &saAttr, 0);

      // Ensure the write handle to the pipe for STDIN is not inherited. 
      SetHandleInformation (p->stdin_wr, HANDLE_FLAG_INHERIT, 0);
   }

   BOOL bSuccess = FALSE;
   // Set up members of the PROCESS_INFORMATION structure. 
   ZeroMemory (&piProcInfo, sizeof (PROCESS_INFORMATION));

   // Set up members of the STARTUPINFO structure. 
   // This structure specifies the STDIN and STDOUT handles for redirection.
   ZeroMemory (&siStartInfo, sizeof (STARTUPINFO));
   siStartInfo.cb = sizeof (STARTUPINFO);
   siStartInfo.hStdError = p->stdout_wr;
   siStartInfo.hStdOutput = p->stdout_wr;
   siStartInfo.hStdInput = p->stdin_rd;
   siStartInfo.dwFlags |= STARTF_USESTDHANDLES;


   bSuccess = CreateProcess (NULL, program_command,     // command line 
                             NULL,      // process security attributes 
                             NULL,      // primary thread security attributes 
                             TRUE,      // handles are inherited 
                             0, // creation flags 
                             NULL,      // use parent's environment 
                             NULL,      // use parent's current directory 
                             &siStartInfo,      // STARTUPINFO pointer 
                             &piProcInfo);      // receives PROCESS_INFORMATION 

   // If an error occurs, exit the application. 
   if (!bSuccess)
      printf ("Error:CreateProcess\n");
   else
   {
      // Close handles to the child process primary thread. Thread hanlde is left open for later use
      // Some applications might keep these handles to monitor the status
      // of the child process, for example. 
      //CloseHandle(piProcInfo.hProcess);
      p->hProcess = piProcInfo.hProcess;
      CloseHandle (piProcInfo.hThread);
   }
   return (void *) p;
}

void __declspec (dllexport)
     __cdecl terminate_program (void *child)
{
   struct child_data *p = (struct child_data *) child;
   if (p == 0)
      p = default_child;

   DWORD exitCode;
   GetExitCodeProcess (p->hProcess, &exitCode);
   if (exitCode == STILL_ACTIVE)        // make sure process is running
   {
      TerminateProcess (p->hProcess, 0);
      CloseHandle (p->hProcess);        // Close process handle
   }
}

int __declspec (dllexport)
     __cdecl write_program (void *child, char *buffer, unsigned int buffer_len)
{
   struct child_data *p = (struct child_data *) child;
   if (p == 0)
      p = default_child;

   DWORD dwWritten = 0;
   DWORD exitCode;
   GetExitCodeProcess (p->hProcess, &exitCode);
   if (exitCode == STILL_ACTIVE)        // make sure process is running)
   {
      if (WriteFile (p->stdin_wr, buffer, buffer_len, &dwWritten, NULL) < 1)
         return 0;
   }
   return dwWritten;
}

int __declspec (dllexport)
     __cdecl read_program (void *child, char *buffer, unsigned int buffer_len)
{
   //freopen("read_program.log", "a+", stdout);
   struct child_data *p = (struct child_data *) child;
   if (p == 0)
      p = default_child;
   DWORD dwRead = 0;
   DWORD total_available_bytes;
   int i, j;

   DWORD start_tick;
   start_tick = GetTickCount ();

   DWORD exitCode = 9999;
   GetExitCodeProcess (p->hProcess, &exitCode);
   if (exitCode == STILL_ACTIVE)        // make sure process is running
   {
      do
      {
         if (PeekNamedPipe
             (p->stdout_rd, 0, 0, 0, &total_available_bytes, 0) != 0
             && total_available_bytes > 0)
         {

            if ((p->rx_buffer_len - p->rx_index) - 1 < 1)       // buffer_overflow
            {
               printf ("Error: Rx Buffer overflow\n");
               p->rx_index = 0;
               return 0;
            }
            if (ReadFile
                (p->stdout_rd, p->rx_buffer + p->rx_index,
                 p->rx_buffer_len - p->rx_index - 1, &dwRead, 0) == 0)
            {
               printf ("Error: ReadFile error\n");
               return 0;
            }
            // Add NULL-terminator to the end of rx buffer
            p->rx_buffer[p->rx_index + dwRead] = 0;

            for (i = 0; i < p->rx_index + dwRead; i++)  // check for delimiter in received data:
            {
               if (p->rx_buffer[i] == p->delimiter)     // look for delimiter character
               {
                  if (i >= buffer_len - 1)
                     i = buffer_len - 2;        // buffer overflow 
                  buffer[i + 1] = 0;    // set 0 to end of input
                  memcpy (buffer, p->rx_buffer, i + 1); // copy stuff before delimiter to output

                  for (j = 0; j < dwRead - (i + 1); j++)
                     p->rx_buffer[j] = p->rx_buffer[i + j + 1]; // copy remains to start of receive buffer

                  //memmmove(p->rx_buffer, p->rx_buffer+p->rx_index+i+1, dwRead-(i+1) ) ; 

                  p->rx_index = dwRead - (i + 1);       // update reception index
                  return p->rx_index + i + 1;
               }
            }
            p->rx_index += dwRead;
         }
         else
            Sleep (10);
      }
      while (p->timeout != 0 && (GetTickCount () - start_tick) < p->timeout);
   }
   return 0;
}

void __declspec (dllexport)
     __cdecl clear_buffer (void *child)
{
   //freopen("read_program.log", "a+", stdout);
   struct child_data *p = (struct child_data *) child;
   if (p == 0)
      p = default_child;
   DWORD dwRead = 0;
   char buffer[2048];
   DWORD exitCode;


   GetExitCodeProcess (p->hProcess, &exitCode);
   if (exitCode == STILL_ACTIVE)        // make sure process is running
   {
      DWORD total_available_bytes;
      while (PeekNamedPipe
             (p->stdout_rd, 0, 0, 0, &total_available_bytes, 0) != 0
             && total_available_bytes > 0)
      {
         ReadFile (p->stdout_rd, buffer, 2048, &dwRead, 0);
      }
   }
   p->rx_index = 0;
}
