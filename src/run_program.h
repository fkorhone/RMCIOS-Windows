/* Copyright (c) 2018 Frans Korhonen, Institute for Atmospheric and Earth System Research / Physics, Faculty of Science, University of Helsinki, Finland
 
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

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


