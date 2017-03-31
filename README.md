# OS-SSL
SSL/TLS for Openstack dashboard

In Openstack, Overcloud uses unencrypted endpoints for the services. This scripts
generates the SSL/TLS certificates to be loaded in overcloud for secure communication 
with public APIs.

Steps:

    1)First clone the repository on undercloud VM

        git clone https://github.com/raonadeem/OS-SSL.git

    2)Run the script and it will generate certificates in /home/stack/ssl_cert

	./OS-SSL
