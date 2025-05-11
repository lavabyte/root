1. Clone repo
    ```bash
    git clone https://github.com/womimc/root
    ```
2. Go into repo
    ```bash
   cd root
    ```
3. Install ubuntu
    ```bash
   bash root.sh
    ```
    *1-3 in one command:
   ```bash
   git clone https://github.com/womimc/root && cd root && bash root.sh
    ```
5. *Install base packages
    ```bash
   apt update && apt install wget curl neofetch git nodejs npm python3 python3-pip pipx unzip zip tar tmux tmate nano bash-completion man-db -y```

## Making VM on it
1. Get minimal ubuntu 24.04 image: `wget -O ubuntu24.img https://cloud-images.ubuntu.com/minimal/releases/noble/release/ubuntu-24.04-minimal-cloudimg-amd64.img`
2. Install requirements: `apt update && apt install qemu-system-x86 qemu-utils genisoimage -y`
3. Make user-data.yaml file with login and password: `printf "#cloud-config\nusers:\n  - default\n  - name: ubuntu\n    sudo: ALL=(ALL) NOPASSWD:ALL\n    groups: users, admin\n    shell: /bin/bash\n    plain_text_passwd: 'ubuntu'\n    lock_passwd: false\nchpasswd:\n  expire: false\nssh_pwauth: true\n" > user-data.yaml`
4. Generate ISO from user-data.yaml: `genisoimage -output user-data.iso -volid cidata -joliet -rock user-data.yaml`
5. Run machine and enter it: `qemu-system-x86_64 -m 2048 -smp 2 -drive file=ubuntu24.img,format=qcow2 -drive file=user-data.iso,format=raw -net nic -net user -nographic`
   - To kill machine press CTRL + A, then X


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
