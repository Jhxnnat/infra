# builder
FROM node:20-alpine AS builder

WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .

# production:
FROM node:20-alpine AS production

WORKDIR /app
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY --from=builder /app/package.json ./
COPY --from=builder /app/server.js ./

RUN chown -R appuser:appgroup /app

ENV NODE_ENV=production
ENV PORT=3000
ENV APP_VERSION=2.0

USER appuser

EXPOSE 3000

CMD ["node", "server.js"]

