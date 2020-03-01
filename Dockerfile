FROM node:latest as builder
RUN apk --no-cache add --virtual native-deps \
  g++ gcc libgcc libstdc++ linux-headers autoconf automake make nasm python git && \
  npm install --quiet node-gyp -g
RUN npm install --quiet node-gyp -g
RUN git clone https://github.com/nodejs/node && \
    cd node && \
    ./configure --fully-static --enable-static && \
    make

FROM scratch
COPY --from=builder /node/out/Release/node /node
