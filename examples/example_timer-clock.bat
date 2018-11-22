RMCIOS %0 
pause
exit

create timer t
create clock elapse
create string s

link t s
link t elapse
link elapse console
link s console

setup s "\nElapsed: "
setup t 5

