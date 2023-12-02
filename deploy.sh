cd terraform/environment/$1

terraform init && terraform apply -auto-approve

cd ../../../
pwd

executeSls () {
   pwd
   sls deploy --stage $1
}

cd api/
executeSls $1
cd ../stream-consumer/
executeSls $1
cd ../email-notification/
executeSls $1
