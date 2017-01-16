# vmlab
A simple way to manage and control virtual machines.

# Features
- Uses the virtualization capabilities present in the kernel
- Works fine on just a single laptop
- Works fine on multiple nodes with shared storage
- Simple design tries to conform to Unix philosophy
- Builds on proven, standard tools 
  - posix shell
  - ssh key-based auth
  - rsync over ssh
  - vnc over tls, with x509 auth
  - qemu
  - git repo containing json text files

# Dependencies
- Intel or AMD cpu supporting vt-x
- Kernel supporting kvm
- Bash (to be replaced with ash 0.4.0)
- Openssh
- Openssl
- Rsync
- Git
- Qemu
- Jshon
- Jansson
- Socat (to be replaced with nc)

Note: If you want to run this on AMD processors, make sure to find and replace the kvm-intel module name. This is probably trivial but I haven't tested it yet.

# Design
- Nodes sync metadata via rsync over ssh
- Metadata is JSON, in text files, in a git repository
- A central console uses ssh to control the nodes
- It's just shell. No messing with $trendyLang or $crustyLang
- Security features are worth the slight increase in complexity (SPKI and x509)

# Installation
- Download the source
  - git clone https://github.com/nomasters/vmlab/vmlab.git
- Generate a package for your platform
  - mkSlackpkg.sh for Slackware
  - mkDeb.sh for Debian, Kali, Ubuntu, etc.
- Install the package
  - slackpkg install vmlab-<version>_nomasters.txz for Slackware
  - dpkg --install vmlab-<version>_nomasters.deb for Debian and Ubuntu
- Create a user
  - grep -e "^vmlab:" /etc/passwd >/dev/null || umask=600 adduser -g nobody -h /dev/null -s /bin/false vmlab
- Mount shared storage (or just populate /vlab-iso with your iso collection, if you don't need multiple hypervising hosts)
  - Add nfs (or whatever you want) mounts to /etc/fstab and mount them
    - echo -e "/vmlab-iso nfs@$nfsHost ro 0 0\n/vmlab-tmpl nfs@$nfsHost ro 0 0\n/vmlab-data nfs@$nfsHost defaults 0 0" >> /etc/fstab
    - mount -a
- Create a guest
  - vmlab DarkStarVm conf -m 512M -s 20G -o slackware64-14.2
  - vmlab DarkStarVm create
  - vmlab DarkStarVm boot
- Confirm the guest is running
  - vmlab status
    - make a note of the port number output by 'vmlab status'
- Access the guest
  - vncviewer <hypervisor_ip_address>:<guest_port_number>
- Profit

# Todo
- Adapt to support FreeBSD's kvm
- Replace all Bash with Posix shell (ash 0.4.0) for speed and portability
  - This is possible since Jshon removes the need for Bash regex support
- Replace configuration file format with JSON
  - Node metadata updates will be fast
    - Rsync fragments of JSON text files over ssh
- Add configuration support for AMD
- Add a minimalist ruby web interface
  - Ruby supports JSON
  - Dancer, Sinatra, and similar minimalist frameworks
- Add package build scripts for other platforms
  - mkFbsd.sh for FreeBSD
  - mkPkg.sh for Arch Linux
  - mkRpm.sh for CentOS, RHEL, SUSE, etc.
  - mkFlat.sh for Fedora
