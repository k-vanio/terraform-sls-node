executeSls () {
   pwd
   sls remove --stage $1
}

cd api/
executeSls $1
cd ../stream-consumer/
executeSls $1
cd ../email-notification/
executeSls $1

cd ../terraform/environment/$1
pwd
terraform destroy -auto-approve 
