#!/bin/sh -x

cp ${LEGO_CERT_PATH} /etc/nginx/ssl/${LEGO_CERT_DOMAIN}/${LEGO_CERT_DOMAIN}.crt && \
cp ${LEGO_CERT_KEY_PATH} /etc/nginx/ssl/${LEGO_CERT_DOMAIN}/${LEGO_CERT_DOMAIN}.key && \
nginx -t && \
nginx -s reload
