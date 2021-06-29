FROM openjdk:18-jdk

COPY ./src /src
RUN chown -R 1000:1000 /src/runtimedemo
WORKDIR /src

USER 1000

RUN javac runtimedemo/*.java

CMD ["java","runtimedemo.Main"]
