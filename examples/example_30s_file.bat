RMCIOS %0 
pause
exit

create rtc_str filename
create rtc_timer trigger
create file output

create chain trigger filename console
link filename output setup

setup trigger 30
setup filename data/file%H%M%S.txt

# Create inital file at current time
write filename

