setup-remote-ansible-user.sh

Create ansible user remotely for Ansible automation and configuration management.

Steps doen by script:
- Add account ansible on remote server.
- Create .ssh directory for ansible user.
- Copy public key to authorized_keys on remote server.
- Add ansible user to sudoer's group on remote server.
- Turn off password login for ansible user on remote server.
- Restart SSH daemon service to activate changes.

Set permissions on file to be executable:
  chmod +x setup-remote-ansible-user.sh
 
Run as: 
  ssh root@ansibleclient 'bash -s' < setup-remote-ansible-user.sh

Check the result:
   ssh ansible@ansibleclient

