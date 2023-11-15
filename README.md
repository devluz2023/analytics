# Config ssh
1. generate key on local machine
`ssh-keygen -t rsa -b 4096  -f ~/.ssh/azure-key -C "your@email"`

# move the key to folder ssh 
1. ` mv terraform-aws ~/.ssh/`

# To run Terraform
1. Log in to azure account
`az login`
2. Test if has alaready any cluster
`az aks list`
3. verify if terraform is installed
`terraform version`
4. get subscription id
`az account list --output table`
5. set subscription id
`az account set --subscription="SUBSCRIPTION_ID"`
6. create an service principal
`az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/SUBSCRIPTION_ID"`
6. copy the output in setenviroment.sh file and execute the script
`cmod +x setenviroment.sh`
`source setenvioroment.sh`
7. export kubeconfig variable
`export KUBECONFIG=../terraform/kubeconfig`

# To config Kubernetes
1. create namespace
`kubectl apply -f namespace`
3. apply deployment
`kubectl apply -f deployment`
3. to get pods
`kubectl get pods -n app-backend`
# To config Grafana

# To Config Azure pipeline



# ansible
ansible-playbook -i inventory.ini playbook.yml

ansible-playbook -i inventory.ini -k ./azure-key.cer ansible/install_mssql.yml

ansible-playbook -i inventory.ini -k azure-key.cer /ansible/mssql.yml


`ssh -i azure-key.cer  adminuser@20.127.114.37`



# terraform
terraform apply -auto-approve
# shell script




# to do
1. gerar chave automaticamente
2. copiar os arquivos automaticamente
3. instalar ansible remotamente
4. subir infra via azure pileine
5. destrutira infra via azure piline