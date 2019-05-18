#!/bin/bash
#
# Create ansible user for Ansible automation and configuration management.
# 
# Set permissions on file to be executable:
#   chmod +x setup-remote-ansible-user.sh
# 
# Run as: 
#   ssh root@ansibleclient 'bash -s' < setup-remote-ansible-user.sh
#
# Check the result:
#   ssh ansible@ansibleclient


# Create ansible user
getentUser=$(/usr/bin/getent passwd ansible)
if [ -z "$getentUser" ]
then
echo "User ansible does not exist. Will Add..."
/usr/sbin/groupadd -g 2002 ansible
/usr/sbin/useradd -u 2002 -g 2002 -c "Ansible Automation Account" -s /bin/bash -m -d /home/ansible ansible
echo "ansible:Password1"'!' | /sbin/chpasswd
mkdir -p /home/ansible/.ssh
fi



echo "Setup the autorization keys..."
cat << 'EOF' >> /home/ansible/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD99kRqoEIUhtRBcnZBo5/E2ka7KR2qNV87ac47K6lG5wN0gGfv/U9894fFUxPpvNyYAkAmzihCgJIxzK3XHfYwFE8jrOwcU4s0P5yzhM/eRzwOBo+ddxD/2uPM5ZIeVzIKy9AAPM827EnMYGxeFqZZaWyypYlB+3m1eNs+VeegSqhrNU9og6TzY1H+khuwpCbHSNK3gWDbU4YbnkC8WbgccdUNkDnAo6Vhv3W74oTnE2WlxrvCoiPzsWad/kXu5BNvpiAGg2hAeLmgaGX3m6bOMFKFCn7+SNI8isl6XxfO9d3PSzhAUQ4LrzdfQzmyj4bJ47cCtFEfsapMJiiAMiLR ansible@thinkpad
EOF

chown -R ansible:ansible /home/ansible/.ssh
chmod 700 /home/ansible/.ssh
echo "Setup the autorization keys... Done!"




# Setup sudo access for Ansible
if [ ! -s /etc/sudoers.d/ansible ]
then
echo "User ansible sudoers does not exists, will add..."
cat << 'EOF' > /etc/sudoers.d/ansible
%ansible ALL=(ALL) NOPASSWD: ALL
EOF
chmod 400 /etc/sudoers.d/ansible
fi


# Disable login for ansible account except through SSH keys.
cat << 'EOF' >> /etc/ssh/sshd_config
Match User ansible
PasswordAuthentication no
AuthenticationMethods publickey


EOF


# Restart sshd
echo "Restarting the sshd service to activate the new settings..."
systemctl restart sshd


echo "Script complete..."
# End of script
