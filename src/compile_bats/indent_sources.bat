:: **********************************************************
:: This is script for calling autoindent scripts on sources.
:: **********************************************************

call_GNU_Indent.bat .\ c
call_GNU_Indent.bat .\ h
call_GNU_Indent.bat RMCIOS c
call_GNU_Indent.bat RMCIOS h
call_GNU_Indent.bat RMCIOS-interfaces c
call_GNU_Indent.bat RMCIOS-interfaces h
call_GNU_Indent.bat RMCIOS-base-module c
call_GNU_Indent.bat RMCIOS-base-module h
call_GNU_Indent.bat RMCIOS-std-module c
call_GNU_Indent.bat RMCIOS-std-module h
call_GNU_Indent.bat RMCIOS-Windows-module c
call_GNU_Indent.bat RMCIOS-Windows-module h

pause

