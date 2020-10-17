#!/bin/sh

if [[ -z "${DOMAIN}" || -z "${EMAIL}" ]]; then
  echo "Must define DOMAIN, EMAIL!"
  exit 1;
fi

if [[ ! -f /etc/nginx/ssl/${DOMAIN}/${DOMAIN}.crt ]]; then
  mkdir -p /etc/nginx/ssl/${DOMAIN}
  /opt/lego --dns cloudflare --domains '${DOMAIN}' --domains '*.${DOMAIN}' --email ${EMAIL} --accept-tos run --run-hook "./install_certs.sh && nginx -t"
  if [[ "$?" != "0" ]]; then
    exit 2;
  fi
fi



$(while :; do /opt/lego --dns cloudflare --domains '${DOMAIN}' --domains '*.${DOMAIN}' --email ${EMAIL} renew --days 45 --renew-hook "./install_certs.sh && nginx -t && nginx -s reload"; sleep "${RENEW_INTERVAL:-12h}"; done;) &


nginx -g "daemon off;"
