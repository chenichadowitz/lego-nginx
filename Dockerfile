FROM nginx:alpine
WORKDIR /opt
COPY lego_nginx_dns.sh install_certs.sh first_time_install_certs.sh /opt/
RUN wget $(curl -s https://api.github.com/repos/go-acme/lego/releases/latest | grep -o "http.*linux_amd64.tar.gz") && \
    tar xvzf lego*.tar.gz lego && \
    rm lego*.tar.gz && \
    chmod +x lego_nginx_dns.sh install_certs.sh first_time_install_certs.sh && \
    rm /var/log/nginx/access.log /var/log/nginx/error.log && \
    touch /var/log/nginx/access.log /var/log/nginx/error.log
CMD ./lego_nginx_dns.sh
