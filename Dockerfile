FROM nginx:alpine
WORKDIR /opt
COPY lego_nginx.sh install_certs.sh nginx_conf_append.txt /opt/
RUN wget $(curl -s https://api.github.com/repos/go-acme/lego/releases/latest | grep -o "http.*linux_amd64.tar.gz") && \
    tar xvzf lego*.tar.gz lego && \
    rm lego*.tar.gz && \
    cat nginx_conf_append.txt >> /etc/nginx/nginx.conf && \
    rm nginx_conf_append.txt && \
    chmod +x lego_nginx.sh install_certs.sh
CMD ./lego_nginx.sh