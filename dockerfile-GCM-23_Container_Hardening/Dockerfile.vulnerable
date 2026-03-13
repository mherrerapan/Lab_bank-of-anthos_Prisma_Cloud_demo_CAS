FROM alpine:latest # VULNERABLE: Uses 'latest' tag
MAINTAINER devops@demo.com # VULNERABLE: MAINTAINER is deprecated
ADD app.py /app.py # VULNERABLE: ADD used instead of COPY
# VULNERABLE: No HEALTHCHECK defined
# VULNERABLE: No USER defined (runs as root)
CMD ["python", "/app.py"]