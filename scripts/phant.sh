cd /tmp
sudo apt update
sudo apt install -y  build-essential chrpath libssl-dev libxft-dev
sudo apt install -y  libfreetype6 libfreetype6-dev libfontconfig1 libfontconfig1-dev
wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2
sudo tar xvjf phantomjs-2.1.1-linux-x86_64.tar.bz2 -C /usr/local/share/
sudo ln -sf /usr/local/share/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin

