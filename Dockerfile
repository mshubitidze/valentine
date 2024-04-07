FROM node:lts-slim
RUN mkdir -p /opt/app
WORKDIR /opt/app
COPY . .
EXPOSE 3000
RUN npm install
RUN npm run build
CMD [ "npm", "start"]