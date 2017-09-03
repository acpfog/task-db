FROM ubuntu:16.04
MAINTAINER Volodymyr Larkin "vlarkin@gmail.com"

RUN apt-get update
RUN apt-get -y install postgresql-9.5 postgresql-client-9.5
COPY db_init.sql /tmp/

USER postgres
RUN /etc/init.d/postgresql start && psql -f /tmp/db_init.sql

USER root
RUN rm -f /tmp/db_init.sql
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.5/main/pg_hba.conf
RUN echo "listen_addresses='*'" >> /etc/postgresql/9.5/main/postgresql.conf
EXPOSE 5432

USER postgres
CMD ["/usr/lib/postgresql/9.5/bin/postgres", "-D", "/var/lib/postgresql/9.5/main", "-c", "config_file=/etc/postgresql/9.5/main/postgresql.conf"]
