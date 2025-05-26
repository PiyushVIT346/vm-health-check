How to use:

Make the script executable: chmod +x vm_health_check.sh
Run: ./vm_health_check.sh or ./vm_health_check.sh explain
Behavior:

Declares VM as "Healthy" if CPU, Memory, and Disk usage are all ≤ 60%.
If any are > 60%, declares "Not Healthy".
With explain argument, prints the reason(s) for the health status.
