#!/bin/sh

if [[ -z "${DOMAIN}" || -z "${EMAIL}" || -z "${LEGO_TLS_PORT}" ]]; then
  echo "Must define DOMAIN, EMAIL, and LEGO_TLS_PORT!"
  exit 1;
fi

if [[ ! -f /etc/nginx/ssl/${DOMAIN}/${DOMAIN}.crt ]]; then
  mkdir -p /etc/nginx/ssl/${DOMAIN}
  /opt/lego -d ${DOMAIN} --email ${EMAIL} --accept-tos --tls --tls.port :${LEGO_TLS_PORT} run --run-hook "./install_certs.sh && nginx -t"
  if [[ "$?" != "0" ]]; then
    exit 2;
  fi
fi



$(while :; do /opt/lego -d ${DOMAIN} --email ${EMAIL} --tls --tls.port :${LEGO_TLS_PORT} renew --days 45 --renew-hook "./install_certs.sh && nginx -t && nginx -s reload"; sleep "${RENEW_INTERVAL:-12h}"; done;) &


nginx -g "daemon off;"