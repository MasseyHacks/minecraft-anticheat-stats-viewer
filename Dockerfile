FROM node:12
WORKDIR /usr/src/app
ENV NUXT_HOST 0.0.0.0
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build
EXPOSE 3000
CMD ["npm", "start"]
