FROM amazon/aws-cli
ARG TARGETARCH

# Install pg_dump
ARG POSTGRES_VERSION
RUN amazon-linux-extras enable postgresql${POSTGRES_VERSION}
RUN yum install -y postgresql tar gzip
RUN yum clean all

# install go-cron
RUN curl -L https://github.com/ivoronin/go-cron/releases/download/v0.0.5/go-cron_0.0.5_linux_${TARGETARCH}.tar.gz -O
RUN tar xvf go-cron_0.0.5_linux_${TARGETARCH}.tar.gz
RUN rm go-cron_0.0.5_linux_${TARGETARCH}.tar.gz
RUN mv go-cron /usr/local/bin/go-cron
RUN chmod u+x /usr/local/bin/go-cron

ENV POSTGRES_DATABASE ''
ENV POSTGRES_HOST ''
ENV POSTGRES_PORT 5432
ENV POSTGRES_USER ''
ENV POSTGRES_PASSWORD ''
ENV PGDUMP_EXTRA_OPTS ''
ENV AWS_ACCESS_KEY_ID ''
ENV AWS_SECRET_ACCESS_KEY ''
ENV S3_BUCKET ''
ENV AWS_REGION 'us-west-1'
ENV S3_PATH 'backup'
ENV S3_ENDPOINT ''
ENV S3_S3V4 'no'
ENV SCHEDULE ''
ENV PASSPHRASE ''
ENV BACKUP_KEEP_DAYS ''

ADD src/run.sh run.sh
ADD src/backup.sh backup.sh
ADD src/restore.sh restore.sh

CMD ["sh", "run.sh"]
