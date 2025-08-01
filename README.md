# Tailwind CSS Application Docker Setup

This repository contains Docker configuration for running the Tailwind CSS application in both development and production environments.

## Files Overview

- `Dockerfile` - Production build with Nginx
- `Dockerfile.dev` - Development build with live reload
- `docker-compose.yml` - Orchestration for both environments
- `.dockerignore` - Files to exclude from Docker builds

## Quick Start

### Production Build & Run

```bash
# Build and run the production container
docker-compose up --build

# Or manually:
docker build -t tailwind-app .
docker run -p 3000:80 tailwind-app
```

The application will be available at `http://localhost:3000`

### Development with Live Reload

```bash
# Run development environment with live reload
docker-compose --profile dev up tailwind-dev --build
```

The development server will be available at `http://localhost:3001` with:

- Auto-reload on file changes
- Tailwind CSS watch mode
- Live server for instant updates

## Docker Commands

### Build Production Image

```bash
docker build -t tailwind-app .
```

### Run Production Container

```bash
docker run -d -p 3000:80 --name tailwind-app tailwind-app
```

### Build Development Image

```bash
docker build -f Dockerfile.dev -t tailwind-app-dev .
```

### Run Development Container

```bash
docker run -d -p 3001:3000 -v $(pwd)/src:/app/src:ro -v $(pwd)/dist:/app/dist --name tailwind-app-dev tailwind-app-dev
```

## Health Check

The production container includes a health check endpoint:

```bash
curl http://localhost:3000/health
```

## Environment Variables

- `NODE_ENV` - Set to `production` or `development`

## Volumes (Development)

In development mode, the following directories are mounted:

- `./src` - Source files (read-only)
- `./dist` - Built CSS output

## Ports

- Production: `3000:80` (Nginx)
- Development: `3001:3000` (Live Server)

## Troubleshooting

### Build Issues

- Ensure all dependencies are in `package.json`
- Check that `src/input.css` exists
- Verify Tailwind configuration

### Container Issues

- Check container logs: `docker logs <container-name>`
- Verify port availability
- Ensure proper file permissions

### Development Live Reload Not Working

- Check volume mounts are correct
- Verify file watcher limits (on Linux)
- Ensure ports are not blocked by firewall
