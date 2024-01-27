FROM docker.io/swift:5.9 as build

WORKDIR /usr/src/app

COPY Package.swift Package.resolved ./
COPY Sources Sources
COPY Tests Tests
RUN swift build --configuration release
RUN swift test --configuration release


FROM docker.io/swift:5.9-slim

# Copy the build executable target (named in Package.swift)
COPY --from=build /usr/src/app/.build/release/server .
CMD ./server $PORT
