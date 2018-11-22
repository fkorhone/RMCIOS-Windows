RMCIOS %0 
pause
exit

create rtc_timer t
create rtc_str st
create string s
setup s "\nTrigger:"
setup t 30
link t s
link t st
link st console
link s console

