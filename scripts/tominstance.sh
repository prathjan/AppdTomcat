echo "service name '$1'"
echo "service port '$2'"
echo "server port '$3'"
echo "app war '$4'"

echo 'service name '$1''
echo 'service port '$2''
echo 'server port '$3''
echo 'app war '$4''

mkdir -p '/usr/local/apache/'$1''
mkdir -p '/usr/local/apache/'$1'/conf'
mkdir -p '/usr/local/apache/'$1'/bin'
mkdir -p '/usr/local/apache/'$1'/logs'
mkdir -p '/usr/local/apache/'$1'/webapps'
sed 's/svcport/'$2'/g' /tmp/server.xml > /tmp/output.file
sed 's/svcport/'$2'/g' /tmp/context.xml > /tmp/output4.file
cp /tmp/output4.file /tmp/context.xml
sed 's/svrport/'$3'/g' /tmp/output.file > /tmp/output1.file
cp /tmp/output1.file /tmp/server.xml
sed 's/svcname/'$1'/g' /tmp/startup.sh > /tmp/output2.file
cp /tmp/output2.file /tmp/startup.sh
sed 's/svcname/'$1'/g' /tmp/shutdown.sh > /tmp/output3.file
cp /tmp/output3.file /tmp/shutdown.sh
sed 's/svcname/'$1'/g' /tmp/service > /tmp/output5.file
cp /tmp/output5.file '/tmp/'$1'.service'


cp /tmp/shutdown.sh '/usr/local/apache/'$1'/bin'
cp /tmp/startup.sh '/usr/local/apache/'$1'/bin'
cp /tmp/server.xml '/usr/local/apache/'$1'/conf'
cp /tmp/context.xml '/usr/local/apache/'$1'/conf'
cp '/tmp/'$4'' '/usr/local/apache/'$1'/webapps'
touch '/usr/local/apache/'$1'/logs/catalina.out'
chmod +x '/usr/local/apache/'$1'/bin/startup.sh'
chmod +x '/usr/local/apache/'$1'/bin/shutdown.sh'
cp '/tmp/'$1'.service' '/etc/systemd/system/'$1''
sudo systemctl start '/etc/systemd/system/'$1''

