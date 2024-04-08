#!/bin/sh
# SPDX-License-Identifier: MIT

# set -x

# load config file for default tls parameters
if [ -f  ${SCRIPT_ROOT_PATH}/conf/tls_lib.conf ]; then
   printf "$0: include default tls parameters from ${SCRIPT_ROOT_PATH}\n"
   . ${SCRIPT_ROOT_PATH}/conf/tls_lib.conf
else
   printf "$0: tls lib default parameters not found - exit\n"
   exit 1
fi

# check if script root path is set from main script
if [ ! -z ${SCRIPT_ROOT_PATH} ]; then
	printf "$0: script root path set - use ${SCRIPT_ROOT_PATH} for include\n"
else
	printf "$0: script rootpath ${SCRIPT_ROOT_PATH} not found\n"
	exit 1
fi

# include external libs from git module
if [ -f  ${SCRIPT_ROOT_PATH}/standard_lib.sh ]; then
   printf "$0: include script from ${SCRIPT_ROOT_PATH}\n"
   . ${SCRIPT_ROOT_PATH}/standard_lib.sh
else
   printf "$0: standardlib not found - exit\n"
   exit 1
fi


# inspect ssl cert
# $1 certification name
openssl_incpect() {

   # inspect TCER
   log -info "inspect certificates"
   openssl x509 -in $1 -noout -text   

}

# convet certificates
# $1 input cert
# $2 output format
openssl_x509_convert() {
   log -info "convert certificates"
}

# create x509 ecdsa cert from parameterfile
openssl_x509_ecdsa_curves() {

   log -info "ec param list curve"
   openssl ecparam -list_curves

}

# certificate with elliptic curve from parameterfile
openssl_x509_ecdsa() {

   # generate the root ca certificate and key
   log -info "generate root ca key"
   openssl ecparam -name prime256v1 -genkey -noout -out ${ROOTCA_NAME}.key

   # generate server private key
   log -info "generate server private key"
   openssl ecparam -name prime256v1 -genkey -noout -out ${SERVER_CERT_NAME}.key

   # generate server public key
   log -info "generate public client key"
   openssl ec -in ${SERVER_CERT_NAME}.key -pubout -out ${CLIENT_CERT_NAME}.key

   # create self sined certificate
   log -info "generate self signed cerificate request"
   openssl req -new -x509 -key ${SERVER_CERT_NAME}.key -subj ${SERVER_CERT_ATTRIBUTES} -out ${SERVER_CERT_NAME}.pem -days ${CERT_DURATION}

   # convert pem to pfx
   log -info "export cert to pfx"
   openssl pkcs12 -export -inkey ${SERVER_CERT_NAME}.key -in ${SERVER_CERT_NAME}.pem -out ${SERVER_CERT_NAME}.pfx

   # finished
   log -info "cert generate finished"

}


# certificate rsa - for tls/mqtt/opcua from parameterfile
openssl_x509_rsa() {

   #ca private key
   log -info "generate ca private key"
   openssl genrsa -out ${ROOTCA_NAME}.key 2048

   # generate root ca
   log -info "generate x.509 root certificate and sign"
   openssl req -x509 -new -nodes -key ${ROOTCA_NAME}.key -sha256 -subj ${ROOTCA_ATTRIBUTES} -days ${CERT_DURATION} -out ${ROOTCA_NAME}.pem

   # generate server key
   log -info "generate server private key"
   openssl genrsa -out ${SERVER_CERT_NAME}.key 2048

   # generate server csr signing request
   log -info "generate server singning request"
   openssl req -out ${SERVER_CERT_NAME}.csr -key ${SERVER_CERT_NAME}.key -subj ${SERVER_CERT_ATTRIBUTES} -new

   # sign server certificate
   log -info "sign server private certificate"
   openssl x509 -req -in ${SERVER_CERT_NAME}.csr -CA ${ROOTCA_NAME}.pem -CAkey ${ROOTCA_NAME}.key -CAcreateserial -out ${SERVER_CERT_NAME}.crt -days ${CERT_DURATION} -sha256

   # generate client key
   log -info "generate client key"
   openssl genrsa -out ${CLIENT_CERT_NAME}.key 2048

   # generate client csr signing request
   log -info "generate client singning request"
   openssl req -out ${CLIENT_CERT_NAME}.csr -key ${CLIENT_CERT_NAME}.key -subj ${CLIENT_CERT_ATTRIBUTES} -new

   # sign client certificate
   log -info "sign client private certificate"
   openssl x509 -req -in ${CLIENT_CERT_NAME}.csr -CA ${ROOTCA_NAME}.pem -CAkey ${ROOTCA_NAME}.key -CAcreateserial -out ${CLIENT_CERT_NAME}.crt -days ${CERT_DURATION} -sha256

   # convert certificates to pfx - with no password use -keypbe NONE -certpbe NONE
   # private and public pfx with password
   openssl pkcs12 -export -inkey ${SERVER_CERT_NAME}.key -in ${SERVER_CERT_NAME}.crt -out ${SERVER_CERT_NAME}.pfx
   openssl pkcs12 -export -inkey ${CLIENT_CERT_NAME}.key -in ${CLIENT_CERT_NAME}.crt -out ${CLIENT_CERT_NAME}.pfx

   # finished
   log -info "cert generate finished"

}

# remove all cert folders
openssl_remove_data() {

   log -info "remove all cert data"
   rm -rf ./certdata_*
}