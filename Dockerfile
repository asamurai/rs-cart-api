FROM node:12.20.0-alpine3.10 as build
LABEL Name="chart-api-build"
LABEL Version="0.0.1"

WORKDIR /opt/app

COPY *.json ./

RUN npm ci && npm cache clean --force

COPY ./src ./src

RUN npm run prebuild && npm run build


FROM node:12.20.0-alpine3.10
LABEL Name="chart-api-deploy"
LABEL Version="0.0.1"

WORKDIR /opt/app
EXPOSE 4000

COPY package*.json ./

RUN npm ci --production && npm cache clean --force

COPY --from=build /opt/app/dist ./dist

CMD [ "npm", "run", "start:prod" ]
