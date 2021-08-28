echo "service name '$1'"
echo "service port '$2'"
echo "server port '$3'"
echo "app war '$4'"
echo "dbvm '$5'"

echo 'service name '$1''
echo 'service port '$2''
echo 'server port '$3''
echo 'app war '$4''
echo 'dbvm '$5''

mkdir -p '/usr/local/apache/'$1''
mkdir -p '/usr/local/apache/'$1'/conf'
cp -r /usr/local/apache/apache-tomcat-7/conf/* '/usr/local/apache/'$1'/conf'
mkdir -p '/usr/local/apache/'$1'/bin'
mkdir -p '/usr/local/apache/'$1'/logs'
mkdir -p '/usr/local/apache/'$1'/webapps'
mkdir -p '/usr/local/apache/'$1'/temp'
mkdir -p '/usr/local/apache/'$1'/work'
sudo chgrp -R cisco '/usr/local/apache/'$1'/'
sudo chown -R cisco '/usr/local/apache/'$1'/webapps'
sudo chown -R cisco '/usr/local/apache/'$1'/work'
sudo chown -R cisco '/usr/local/apache/'$1'/temp'
sudo chown -R cisco '/usr/local/apache/'$1'/logs' 
sudo chgrp -R cisco '/usr/local/apache'
sudo chown -R cisco '/usr/local/apache'




sed 's/svcport/'$2'/g' /tmp/server.xml > /tmp/output.file
sed 's/svcport/'$2'/g' /tmp/context.xml > /tmp/output4.file
sed 's/mysqlvm/'$5'/g' /tmp/output4.file > /tmp/output6.file
#cp /tmp/output4.file /tmp/context.xml
sed 's/svrport/'$3'/g' /tmp/output.file > /tmp/output1.file
#cp /tmp/output1.file /tmp/server.xml
sed 's/svcname/'$1'/g' /tmp/startup.sh > /tmp/output2.file
#cp /tmp/output2.file /tmp/startup.sh
sed 's/svcname/'$1'/g' /tmp/shutdown.sh > /tmp/output3.file
#cp /tmp/output3.file /tmp/shutdown.sh
sed 's/svcname/'$1'/g' /tmp/service > /tmp/output5.file
#cp /tmp/output5.file '/tmp/'$1'.service'


cp /tmp/output3.file '/usr/local/apache/'$1'/bin/shutdown.sh'
cp /tmp/output2.file '/usr/local/apache/'$1'/bin/startup.sh'
cp /tmp/output1.file '/usr/local/apache/'$1'/conf/server.xml'
cp /tmp/output6.file '/usr/local/apache/'$1'/conf/context.xml'
cp '/tmp/'$4'' '/usr/local/apache/'$1'/webapps'
#touch '/usr/local/apache/'$1'/logs/catalina.out'
#chmod 777 '/usr/local/apache/'$1'/logs/catalina.out'
chmod +x '/usr/local/apache/'$1'/bin/startup.sh'
chmod +x '/usr/local/apache/'$1'/bin/shutdown.sh'

echo '***starting service'
'/usr/local/apache/'$1'/bin/startup.sh'

cp '/tmp/output5.file' '/etc/systemd/system/'$1.service''
#echo '***file:'$1.service''
#sudo systemctl daemon-reload
#systemctl enable ''$1'.service' 
#systemctl start $1
 


