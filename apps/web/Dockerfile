FROM node:20-alpine

WORKDIR /app

# Install pnpm
RUN npm install -g pnpm

# Copy root workspace files
COPY pnpm-workspace.yaml package.json pnpm-lock.yaml ./

# Copy packages needed for web
COPY packages/ui ./packages/ui
COPY packages/design-system ./packages/design-system
COPY packages/utils ./packages/utils

# Copy web app
COPY apps/web ./apps/web

# Install dependencies
RUN pnpm install --frozen-lockfile

# Build web app
RUN cd apps/web && pnpm build

# Remove dev dependencies
RUN pnpm prune --prod

EXPOSE 3000

CMD ["pnpm", "-F", "web", "start"]
