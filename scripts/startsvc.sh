sudo chgrp -R cisco '/usr/local/apache/'$1'/'
sudo chown -R cisco '/usr/local/apache/'$1'/'
echo '***file:'$1.service''
sudo systemctl daemon-reload
systemctl enable ''$1'.service'
systemctl start $1

