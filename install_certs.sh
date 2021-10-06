#!/bin/sh -x

cp ${LEGO_CERT_PATH} /etc/nginx/ssl/${LEGO_CERT_DOMAIN}/${DOMAIN}.crt && \
cp ${LEGO_CERT_KEY_PATH} /etc/nginx/ssl/${LEGO_CERT_DOMAIN}/${DOMAIN}.key && \
nginx -t && \
nginx -s reload
