ARG JAVA_VERSION=11

FROM alpine AS waterfall
ARG WATERFALL_VERSION=latest
RUN apk add --update-cache --no-cache \
        curl \
        jq
RUN if test "${WATERFALL_VERSION}" = "latest"; then \
        WATERFALL_VERSION=$(curl --silent https://papermc.io/api/v1/waterfall/ | jq --raw-output '.versions[0]'); \
    fi && \
    curl --silent --location --fail --output waterfall.jar https://papermc.io/api/v1/waterfall/${WATERFALL_VERSION}/latest/download

FROM openjdk:${JAVA_VERSION}-jre
RUN useradd --create-home --shell /bin/bash minecraft \
 && mkdir -p /opt/waterfall /var/opt/waterfall \
 && chown -R minecraft /var/opt/waterfall/
COPY --from=waterfall /waterfall.jar /opt/waterfall/
USER minecraft
WORKDIR /var/opt/waterfall
VOLUME /var/opt/waterfall
EXPOSE 25565
ENTRYPOINT [ "java" ]
CMD [ "-Xms128M", "-Xmx256M", "-jar", "/opt/waterfall/waterfall.jar" ]
