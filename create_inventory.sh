[ -f /home/kovair/employee_portal/Ansible-Deployment/inventory/devops_demo ] && echo "File exist" || echo "File does not exist" && rm -rf /home/kovair/employee_portal/Ansible-Deployment/inventory/devops_demo

cd /home/kovair/employee_portal/TFCloud-AZURE-VM
VM_Types=('AppServer')

for vm_type in "${VM_Types[@]}"
do
echo "$vm_type"
ip=$(terraform output $vm_type | /home/kovair/jq-linux64 -r)
printf "[$vm_type]\n$ip ansible_become_pass='{{ sudo_pass }}'\n\n" >> /home/kovair/employee_portal/Ansible-Deployment/inventory/devops_demo
done
