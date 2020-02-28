RMCIOS %0 
pause
exit

create nidev ni
create niai ai0

# setup parameters: physical_device sample_rate samples
setup ni dev2 1000 10 
setup ai0 ni ai0

# do one analog measurement for all analog channels (IN this example does average of 10 samples with sample rate of 1000hz)
write ni

# you can read latest analog value:
read ao0
