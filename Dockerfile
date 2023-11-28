FROM alpine:3.18.4

RUN apk add ansible aws-cli bash curl git openssl openssh-client terraform
RUN adduser -s /bin/sh -D -h /home/infra infra -s /bin/bash

COPY entrypoint.sh /bin/entrypoint.sh
RUN chmod +x /bin/entrypoint.sh

USER infra
WORKDIR /home/infra

ENTRYPOINT ["/bin/entrypoint.sh"]

CMD [ "/bin/bash" ]