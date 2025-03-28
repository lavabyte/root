1. Clone repo
    ```git clone https://github.com/womimc/root```
2. Go into repo
    ```cd root```
3. Install ubuntu
    ```bash root.sh```


## FIXES
1. ERROR: ld.so: object '/usr/lib/librtldloader.so' cannot be loaded as audit interface: cannot open shared object file; ignored.
   - ```apt update && apt upgrade -y && unset LD_AUDIT```
2. sudo: unable to resolve host
   - ```x=$(hostname) && echo "$x" > /etc/hostname && echo "127.0.0.1   $x" >> /etc/hosts```
3. System has not been booted with systemd as init system (PID 1). Can't operate.
   Failed to connect to bus: Host is down
   - ```service [service name] (start/stop/restart)```
