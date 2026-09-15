# Dummy-Verifier für Lab 00.
# Prüft per HTTP-Probe gegen den Ziel-Container den Zielzustand.
FROM alpine:3.20

RUN apk add --no-cache curl jq

COPY check.sh /usr/local/bin/check.sh
RUN chmod +x /usr/local/bin/check.sh

ENV LAB_NUMBER=00 \
    LAB_SLUG=dummy \
    LAB_TOTAL=1 \
    TARGET_HOST=target \
    TARGET_PORT=80 \
    PROGRESS_DIR=/progress

VOLUME ["/progress"]

ENTRYPOINT ["/usr/local/bin/check.sh"]
