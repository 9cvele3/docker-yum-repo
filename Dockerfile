# build stage
FROM golang:1.18 as builder

WORKDIR /go/src/github.com/dgutierrez1287/docker-yum-repo

COPY src/* ./

RUN GOOS=linux go build -x -o repoScanner .

# application image
FROM centos:7
LABEL maintainer="Diego Gutierrez <dgutierrez1287@gmail.com>"

RUN yum -y install epel-release && \
    yum -y update && \
    yum -y install supervisor createrepo yum-utils nginx && \
    yum clean all

RUN mkdir /repo && \
    chmod 777 /repo && \
    mkdir -p /logs

COPY nginx.conf /etc/nginx/nginx.conf
COPY supervisord.conf /etc/supervisord.conf
COPY --from=builder /go/src/github.com/dgutierrez1287/docker-yum-repo/repoScanner /root/

RUN chmod 700 /root/repoScanner

EXPOSE 80
VOLUME /repo /logs

ENV DEBUG false
ENV LINUX_HOST true
ENV SERVE_FILES true

COPY entrypoint.sh /root/entrypoint.sh
RUN chmod 700 /root/entrypoint.sh
ENTRYPOINT ["/root/entrypoint.sh"]




