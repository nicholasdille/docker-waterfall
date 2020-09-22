ARG JAVA_VERSION=11

FROM alpine AS tools
RUN apk add --update-cache --no-cache \
        curl \
        jq

FROM tools AS waterfall
ARG WATERFALL_VERSION=latest
RUN if test -z "${WATERFALL_VERSION}" || test "${WATERFALL_VERSION}" == "latest" || test "${WATERFALL_VERSION}" == "master"; then \
        echo "### Fetching latest version"; \
        WATERFALL_VERSION=$(\
            curl --silent --location https://papermc.io/api/v1/waterfall/ | \
            jq --raw-output '.versions[0]' \
        ); \
    fi && \
    echo "### Using version <${WATERFALL_VERSION}>" && \
    WATERFALL_VERSION_PATCH=$(\
        curl --silent --location https://papermc.io/api/v1/waterfall/${WATERFALL_VERSION}/ | \
        jq --raw-output '.builds.latest' \
    ) && \
    echo "### Using patch <${WATERFALL_VERSION_PATCH}>" && \
    curl --silent --location --fail --output /waterfall.jar https://papermc.io/api/v1/waterfall/${WATERFALL_VERSION}/${WATERFALL_VERSION_PATCH}/download

FROM openjdk:${JAVA_VERSION}-jre
RUN useradd --create-home --shell /bin/bash minecraft \
 && mkdir -p /opt/waterfall /var/opt/waterfall \
 && chown -R minecraft /var/opt/waterfall/
COPY --from=waterfall /waterfall.jar /opt/waterfall/
USER minecraft
WORKDIR /var/opt/waterfall
VOLUME /var/opt/waterfall
EXPOSE 25565
ENV JAVA_MEM_START=256M \
    JAVA_MEM_MAX=768M
CMD java -Xms${JAVA_MEM_START} -Xmx${JAVA_MEM_MAX} -jar /opt/waterfall/waterfall.jar
