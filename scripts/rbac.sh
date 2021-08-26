mkdir -p /home/ec2-user/environment/workshop/
cp /tmp/devnet-controller-setup.zip /home/ec2-user/environment/workshop 
cd /home/ec2-user/environment/workshop
unzip /tmp/devnet-controller-setup.zip 
chmod +x *.sh
export appd_workshop_user=SBUser
./setupWorkshop.sh
source /home/ec2-user/environment/workshop/application.env
echo $APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY
