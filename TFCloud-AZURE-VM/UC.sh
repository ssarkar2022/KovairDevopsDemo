#! /bin/bash
#sudo yum update -y
apt-get update -y
apt-get upgrade -y
sudo useradd -m -p$(openssl passwd fsd9gK@g) ansible
#sudo usermod -aG wheel ansible
sudo usermod -aG sudo ansible
sudo sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/PasswordAuthentication no/#PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/#ChallengeResponseAuthentication no/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/GSSAPIAuthentication yes/#GSSAPIAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/GSSAPICleanupCredentials no/#GSSAPICleanupCredentials no/' /etc/ssh/sshd_config
sudo sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sudo systemctl restart sshd
sudo su
cd /home/ansible
sudo mkdir .ssh
cp /home/kovairadmin/authorized_keys /home/ansible/.ssh/authorized_keys
rm /home/kovairadmin/authorized_keys