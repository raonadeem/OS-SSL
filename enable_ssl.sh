#!/bin/bash
# this script will generate the certificates and modify
# the yaml files to enable ssl in public API.
index_file="/etc/pki/CA/index.txt"
serial_file="/etc/pki/CA/serial"
ssl_dir="/home/stack/ssl_cert"
cert_count=1000

total_certs=$(ls /etc/pki/CA/newcerts/ |wc -l)
new_count=$(($total_certs + cert_count))
rm -rf $ssl_dir
mkdir $ssl_dir ; cd $ssl_dir
# Initializing the signing host
if [ -f "$index_file" ]
then
    echo "File $file_index already exists."
else
    sudo touch /etc/pki/CA/index.txt
fi
if [ -f "$serial_file" ]
then
    echo "File Already exists"
else
    sudo touch /etc/pki/CA/serial
fi
sudo chmod 646 $serial_file
sudo echo "$new_count" > $serial_file
sudo chmod 644 $serial_file

# # Creating a certificate authority
openssl genrsa -out ca.key.pem 4096
# #openssl req  -key ca.key.pem -new -x509 -days 7300 -extensions v3_ca -out ca.crt.pem
openssl req  -key ca.key.pem -new -x509 -days 7300 -extensions v3_ca -out ca.crt.pem -subj '/CN=SAHABA/O=DETASAD/C=SA/ST=Riyadh/L=Riyadh/OU=sahaba/'

# # Adding the certificate authority to clients
sudo cp ca.crt.pem /etc/pki/ca-trust/source/anchors/
sudo update-ca-trust extract

# # Creating an SSL/TLS key and certificate signing request
openssl genrsa -out server.key.pem 2048
cp /etc/pki/tls/openssl.cnf .
openssl req -config openssl.cnf -key server.key.pem -new -out server.csr.pem -subj '/CN=SAHABA/O=DETASAD/C=SA/ST=Riyadh/L=Riyadh/OU=sahaba/'

# #Creating the SSL/TLS certificate
sudo openssl ca -config openssl.cnf -extensions v3_req -days 3650 -in server.csr.pem -out server.crt.pem -cert ca.crt.pem -keyfile ca.key.pem -batch
