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

#ifndef run_program_h
#define run_program_h

#define DLL_EXPORT __declspec(dllexport) __cdecl

// Starts program with command from work_dir. Returns pointerhandle.
void * __declspec(dllexport) __cdecl start_program(const char *work_dir, char *program_command) ;

// Terminates program according to pointerhandle.
void __declspec(dllexport) __cdecl terminate_program(void *program) ;

// Read data from program piped stdout. Return ammount of bytes read.
int __declspec(dllexport) __cdecl read_program(void *program, char *buffer,unsigned int buffer_len) ;

// Write data to program piped stdin. Return bytes written.
int __declspec(dllexport) __cdecl write_program(void *program, char *buffer,unsigned int buffer_len) ;

// Clear piped stdout data.
void __declspec(dllexport) __cdecl clear_buffer(void *program) ;

#endif 


