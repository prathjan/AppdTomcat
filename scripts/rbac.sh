apt install dos2unix -y
mkdir -p /home/ec2-user/environment/workshop/
cp /tmp/devnet-controller-setup.zip /home/ec2-user/environment/workshop 
#cd /home/ec2-user/environment/workshop
unzip /home/ec2-user/environment/workshop/devnet-controller-setup.zip -d /home/ec2-user/environment/workshop
chmod +x /home/ec2-user/environment/workshop/*.sh
export appd_workshop_user=SBUser
/home/ec2-user/environment/workshop/setupWorkshop.sh
dos2unix /home/ec2-user/environment/workshop/application.env
. /home/ec2-user/environment/workshop/application.env
echo $APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY > /tmp/accesskey

