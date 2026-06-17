FROM node:10.24.1

WORKDIR /home/yapi

COPY package.json package-lock.json ./

RUN npm config set registry https://registry.npmmirror.com && \
    npm config set sass_binary_site https://npmmirror.com/mirrors/node-sass/ && \
    npm install

COPY . .

RUN npm run build-client && \
    rm -rf node_modules && \
    npm install --production

RUN sed -i "s/\"servername\": \"127.0.0.1\"/\"servername\": \"mongo\"/g" config.json

EXPOSE 3000

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]