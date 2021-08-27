echo "before: $1"
before=$1
mkdir -p /home/ec2-user/environment/workshop/
cp /tmp/devnet-controller-setup.zip /home/ec2-user/environment/workshop 
#cd /home/ec2-user/environment/workshop
unzip /home/ec2-user/environment/workshop/devnet-controller-setup.zip 
chmod +x /home/ec2-user/environment/workshop/*.sh
export appd_workshop_user=SBUser
/home/ec2-user/environment/workshop/setupWorkshop.sh
. /home/ec2-user/environment/workshop/application.env
echo $APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY > /tmp/accesskey
after=echo "${before/accesskey/$APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY}"
echo "after: $after"
eval $after

