FROM node:18-alpine

WORKDIR /app

# Copy package.json from src folder
COPY src/package*.json ./

RUN npm install

# Copy full source code
COPY src/ .

EXPOSE 3002

CMD ["npm", "start"]
