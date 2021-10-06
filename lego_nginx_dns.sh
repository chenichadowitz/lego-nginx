#!/bin/sh

if [[ -z "${DOMAIN}" || -z "${EMAIL}" ]]; then
  echo "Must define DOMAIN, EMAIL!"
  exit 1;
fi

lego_renew=" --dns cloudflare --domains=${DOMAIN} --domains=*.${DOMAIN} --email=${EMAIL} renew --days=45 --renew-hook=/opt/install_certs.sh"                                                                
/opt/lego ${lego_renew}
exit_code=$?
echo "exit code ${exit_code}"

if [[ ! -f /etc/nginx/ssl/${DOMAIN}/${DOMAIN}.crt || ${exit_code} -ne 0 ]]; then
  mkdir -p /etc/nginx/ssl/${DOMAIN}
  /opt/lego --dns cloudflare --domains=${DOMAIN} --domains=*.${DOMAIN} --email=${EMAIL} --accept-tos run --run-hook="/opt/first_time_install_certs.sh"                                                                
  if [[ "$?" != "0" ]]; then
    exit 2;
  fi
fi



$(while :; do sleep "${RENEW_INTERVAL:-12h}" && /opt/lego ${lego_renew}; done;) &


nginx -g "daemon off;"
