#Parent Image
FROM openjdk:17-jdk-slim-buster as base

#Builder
FROM base as builder
RUN apt-get update -y && apt-get install wget -y && \
   mkdir /mcdata && mkdir /temp

RUN wget -c https://api.papermc.io/v2/projects/paper/versions/1.19/builds/29/downloads/paper-1.19-29.jar -O /temp/server.jar && \
   touch /temp/eula.txt && echo "eula=true" > /temp/eula.txt

#Build process 2
FROM openjdk:17-jdk-slim as builder2

RUN apt-get update -y && \
   apt-get upgrade -y && \
   apt-get clean && \
   mkdir /temp && \
   mkdir /mcdata

COPY --from=builder /temp /temp

WORKDIR /mcdata

EXPOSE 25565

USER 1001

CMD mv /temp/*.* /mcdata && java -Xms4G -jar server.jar nogui
