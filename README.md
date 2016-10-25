# akamai-spoof-tool
####This tool is a simple shell script for people who are frequently spoofing to Akamai's Staging network to test changes.

####Supported and tested operating systems:
* Mac OS Sierra

WARNING: This file directly modifies your computer's host file.  If you do not know what this means, it's probably best you don't use this tool.

####Directions:
  
1. Modify the sites.txt file to include the sites that use Akamai that you'd like to spoof
2. From the command line, navigate to the directory where the sites.txt and the spoof.sh file exists, and run the following command to put the spoof entries in your host file:

  ```
  sudo ./spoof.sh
  ```
  
3. To remove the spoofed entries from your host file, simply pass in a "-d" to the command:

  ```
  sudo ./spoof.sh -d
  ```

DNS is automatically flushed at the end of the script.

If something went wrong, a backup of your hosts file from before the last time the command was run can be found at: `/etc/hosts.backup`

Suggestions for improvement welcome!

