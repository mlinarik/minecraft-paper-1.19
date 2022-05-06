#Parent Image
FROM openjdk:17-jdk-slim-buster as base

#Builder
FROM base as paper-builder

RUN apt-get update -y && apt-get install wget -y && \
   mkdir /mcdata && mkdir /temp  && mkdir /plugins && \
   wget -c https://papermc.io/api/v2/projects/paper/versions/1.18.2/builds/323/downloads/paper-1.18.2-323.jar -O /temp/server.jar && \
   touch /temp/eula.txt && echo "eula=true" > /temp/eula.txt

#Runtime
FROM openjdk:17-jdk-slim-buster as runtime

RUN apt-get update -y && \
   apt-get upgrade -y && \
   apt-get clean all && \
   mkdir /temp && \
   mkdir /mcdata && \
   mkdir /mcdata/plugins && \
   chown 11000 /mcdata && \
   chown 11000 /temp

COPY --from=paper-builder /temp /temp

WORKDIR /mcdata

EXPOSE 25565

USER 11000

CMD mv /temp/*.* /mcdata && java -Xms4G -jar server.jar nogui
