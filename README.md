1. Clone repo
    ```git clone https://github.com/womimc/root```
2. Go into repo
    ```cd root```
3. Install ubuntu
    ```bash root.sh```
4. *Install base packages
    ```apt update && apt install wget curl neofetch git node-js npm python3 python3-pip pipx build-essential software-properties-common ca-certificates gnupg lsb-release ufw htop net-tools npam unzip zip tar tmux vim nano bash-completion man-db lsof tree jq -y```


## FIXES
1. ERROR: ld.so: object '/usr/lib/librtldloader.so' cannot be loaded as audit interface: cannot open shared object file; ignored.
   - `apt update && apt upgrade -y && unset LD_AUDIT`
2. sudo: unable to resolve host
   - `x=$(hostname) && echo "$x" > /etc/hostname && echo "127.0.0.1   $x" >> /etc/hosts`
3. System has not been booted with systemd as init system (PID 1). Can't operate.
   Failed to connect to bus: Host is down
   - `service [service name] (start/stop/restart)`
4. bash: /usr/lib/command-not-found: No such file or directory
   - `apt update && apt install command-not-found -y && apt update`
