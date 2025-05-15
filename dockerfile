FROM node:18-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY tsconfig.json ./
COPY src/ ./src/

RUN npm run build
RUN mkdir -p /app/dist/schema && \
cp src/schema/schema.graphql /app/dist/schema/
EXPOSE 4000

CMD ["node", "dist/index.js"]