#!/bin/bash

set -e

##
# This user script will be executed between configuration and starting daemons
# To enable it you must save it in your config directory as "user-patches.sh"
##
echo ">>>>>>>>>>>>>>>>>>>>>>>Applying patches<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"

# https://github.com/dovecot/core/blob/941668f5a0ca1733ceceae438092398bc08a7810/doc/example-config/dovecot-ldap.conf.ext#L47

printf '\ntls_ca_cert_file = %s\ntls_cert_file = %s\ntls_key_file = %s\ntls_require_cert = %s\n' \
    "${DOVECOT_TLS_CACERT_FILE}" \
    "${DOVECOT_TLS_CERT_FILE}" \
    "${DOVECOT_TLS_KEY_FILE}" \
    "${DOVECOT_TLS_VERIFY_CLIENT}" >> /etc/dovecot/dovecot-ldap.conf.ext

# Delete before set to localhost
sed -i '/^mydomain =/d' /etc/postfix/main.cf
sed -i '/^mydestination =/d' /etc/postfix/main.cf

# Delete this value to default as empty default
sed -i '/^smtpd_sasl_local_domain =/d' /etc/postfix/main.cf

printf '\nmydomain = %s\n' "localhost" >> /etc/postfix/main.cf
printf '\nmydestination = %s\n' "localhost" >> /etc/postfix/main.cf

sed -i '/^result_attribute =/d' /etc/postfix/ldap-domains.cf
printf '\nresult_attribute = %s\n' "mail, mailalias" >> /etc/postfix/ldap-domains.cf

sed -i '/^result_attribute =/d' /etc/postfix/ldap-aliases.cf
printf '\nresult_attribute = %s\n' "mail, mailalias" >> /etc/postfix/ldap-aliases.cf

echo ">>>>>>>>>>>>>>>>>>>>>>>Finished applying patches<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
