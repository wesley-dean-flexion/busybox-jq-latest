FROM busybox:latest
COPY jq /bin/
RUN chmod 755 /bin/jq
USER nobody
ENTRYPOINT [ "/bin/jq" ]
