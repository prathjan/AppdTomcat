echo '***file:'$1.service''
sudo systemctl daemon-reload
systemctl enable ''$1'.service'
systemctl start $1

