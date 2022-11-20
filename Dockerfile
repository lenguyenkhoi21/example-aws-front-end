FROM node:alpine AS deps
WORKDIR /app
COPY package.json yarn.lock ./
RUN ["yarn","install","--frozen-lockfile"]

FROM node:alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY --from=deps /app/package.json ./package.json
COPY --from=deps /app/yarn.lock ./yarn.lock
COPY . .
RUN ["yarn","build"]

FROM nginx:alpine as runner
WORKDIR /usr/share/nginx/html
RUN ["rm","-rf"]
COPY --from=builder /app/build ./



