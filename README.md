How to use:
1) For Ubuntu (.sh)
Make the script executable: chmod +x vm_health_check.sh
Run: ./vm_health_check.sh or ./vm_health_check.sh explain
Behavior:

Declares VM as "Healthy" if CPU, Memory, and Disk usage are all ≤ 60%.
If any are > 60%, declares "Not Healthy".
With explain argument, prints the reason(s) for the health status.


2) For windows (.bat)
Save the Script:

Copy the above code into a file named vm_health_check.bat.
Open Command Prompt as Administrator:

Press Win + S, type cmd, right-click "Command Prompt" and select "Run as administrator".
Navigate to the Script Location:

Use cd to go to the folder where you saved vm_health_check.bat.
Run the Script:

To check health only:
Code
vm_health_check.bat
To check health with explanation:
Code
vm_health_check.bat explain
Note:

This script checks CPU, memory, and disk utilization (for the C: drive).
If any parameter is above 60%, it declares "Not Healthy", otherwise "Healthy".
Pass the explain argument to see reasons for the health status.
For drives other than C:, modify the script accordingly.
