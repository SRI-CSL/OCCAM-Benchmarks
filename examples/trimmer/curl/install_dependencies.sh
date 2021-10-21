# Install dependencies
sudo apt-get update
sudo apt-get install -y libssl-dev

mkdir -p build
cd build
# needs SSL 1.0.2g
wget https://www.openssl.org/source/openssl-1.0.2g.tar.gz
tar xvfz openssl-1.0.2g.tar.gz
cd openssl-1.0.2g
./config --prefix=/usr/local shared
make install
cd ../..
