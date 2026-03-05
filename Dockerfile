FROM eclipse-temurin:21-jdk-alpine AS builder

WORKDIR /build
RUN apk add --no-cache curl

ARG MC_VERSION=1.20.4
ARG BUILD=416

RUN curl -L \
  https://api.papermc.io/v2/projects/paper/versions/${MC_VERSION}/builds/${BUILD}/downloads/paper-${MC_VERSION}-${BUILD}.jar \
  -o server.jar

  
#---------STAGE 2------------

FROM eclipse-temurin:21-jre-alpine

WORKDIR /minecraft
COPY --from=builder /build/server.jar ./server.jar
RUN echo "eula=true" > eula.txt

EXPOSE 25565

ENV MEMORY=2G

STOPSIGNAL SIGTERM

# Start server
CMD ["sh","-c","java -XX:+UseG1GC -Xms${MEMORY} -Xmx${MEMORY} -jar server.jar nogui"]
