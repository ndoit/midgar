wget 'https://googledrive.com/host/0B0z8f6fHHVk9fktMb2xoNHZ6NXZoM3ZFOUhXR2gxeTl6dDl0RUpIZHd1V1N3NlJzeTY2Z1U/midgar.box'
vagrant box add midgar midgar.box
mkdir midgar
cp restart_services.sh ./midgar
cp Vagrantfile ./midgar
cp keys.sh ./midgar
cd ./midgar
vagrant up
git clone git@github.com:ndoit/fenrir.git