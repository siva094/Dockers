FROM node:10-alpine as builder
RUN apk --no-cache add --virtual native-deps \
  g++ gcc libgcc libstdc++ linux-headers autoconf automake make nasm python git && \
  npm install --quiet node-gyp -g
RUN npm install --quiet node-gyp -g
RUN git clone https://github.com/nodejs/node && \
    cd node && \
    ./configure --fully-static --enable-static && \
    make

FROM alpine/git as codecheckout
WORKDIR /app
RUN git clone https://github.com/siva094/node.git

FROM node:10-alpine as sourcecode
WORKDIR /app
COPY --from=codecheckout /app/node/ ./
#COPY package.json package-lock.json app.js views/ ./
RUN npm install --prod

FROM scratch
COPY --from=builder /node/out/Release/node /bin
COPY --from=sourcecode /app ./
EXPOSE 8080
ENTRYPOINT ["node", "app.js"]
