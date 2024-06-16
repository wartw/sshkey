yum install -y gcc make perl wget perl-IPC-Cmd ssmtp
wget https://www.openssl.org/source/openssl-3.3.1.tar.gz
tar -xf openssl-3.3.1.tar.gz
cd openssl-3.3.1
./config --prefix=/usr/local/openssl --openssldir=/usr/local/openssl
make
make install
echo "/usr/local/openssl/lib" > /etc/ld.so.conf.d/openssl.conf
ldconfig
make
make install
echo "/usr/local/openssl/lib" > /etc/ld.so.conf.d/openssl.conf
ldconfig
ln -s /usr/local/openssl/lib/libssl.so.3 /usr/lib/libssl.so.3
ln -s /usr/local/openssl/lib64/libssl.so.3 /usr/lib64/libssl.so.3
ln -s /usr/local/openssl/lib/libcrypto.so.3 /usr/lib/libcrypto.so.3
ln -s /usr/local/openssl/lib64/libcrypto.so.3 /usr/lib64/libcrypto.so.3
mv /usr/bin/openssl /usr/bin/openssl.old
ln -s /usr/local/openssl/bin/openssl /usr/bin/openssl
ln -s /usr/local/openssl/include/openssl /usr/include/openssl
openssl version
