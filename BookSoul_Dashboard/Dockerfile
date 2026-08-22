# syntax=docker/dockerfile:1
# Build a static Flutter Web bundle. Pass only public Supabase configuration.
FROM ghcr.io/cirruslabs/flutter:3.24.5 AS build
WORKDIR /app

ARG SUPABASE_URL
ARG SUPABASE_ANON_KEY
ARG CONTROL_PLANE_URL

COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .
RUN flutter build web --release \
  --dart-define=SUPABASE_URL=${SUPABASE_URL} \
  --dart-define=SUPABASE_ANON_KEY=${SUPABASE_ANON_KEY} \
  --dart-define=CONTROL_PLANE_URL=${CONTROL_PLANE_URL}

# Serve the generated SPA behind Dokploy/Traefik.
FROM nginx:1.27-alpine AS runtime
COPY deploy/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD wget -q -O /dev/null http://127.0.0.1/healthz || exit 1
