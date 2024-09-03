#!/bin/sh
cat << EOF
networks:
  traefik_default:
    external: true

volumes:
  data:

services:
  deployment:
    image: $APP_DEPLOY_IMAGE
    container_name: $APP_DEPLOY_NAME
      - data:/data
    networks:
      - traefik_default
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.$APP_DEPLOY_NAME.rule=Host(\`$APP_URL\`)"
      - "traefik.http.routers.$APP_DEPLOY_NAME.entrypoints=websecure"
      - "traefik.http.routers.$APP_DEPLOY_NAME.tls=true"
      - "traefik.http.routers.$APP_DEPLOY_NAME.tls.certresolver=leresolver"
      - "traefik.http.services.$APP_DEPLOY_NAME.loadbalancer.server.port=$APP_PORT"
    restart: unless-stopped
    healthcheck:
      ## In production the healthcheck section should be commented.
      disable: true
    environment:
      - TZ=Europe/Berlin

EOF
