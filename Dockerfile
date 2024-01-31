# 1
FROM swift:focal
# FROM --platform=linux/arm64 swift:5.9
ARG TARGETPLATFORM
RUN echo "I'm building for $TARGETPLATFORM"

WORKDIR /app
COPY . .

# 2 - Remove when using PostgreSQL
# RUN apt-get update && apt-get install libsqlite3-dev

# 3
RUN swift package clean
RUN swift build

# 4
RUN mkdir /app/bin
RUN mv `swift build --show-bin-path` /app/bin

# 5
EXPOSE 3000
ENTRYPOINT ./bin/debug/Run serve --env local --hostname 0.0.0.0
