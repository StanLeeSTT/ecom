FROM node:20-alpine

WORKDIR /app

# Install pnpm
RUN npm install -g pnpm

# Copy root workspace files
COPY pnpm-workspace.yaml package.json pnpm-lock.yaml ./

# Copy packages needed for storefront
COPY packages/ui ./packages/ui
COPY packages/design-system ./packages/design-system
COPY packages/utils ./packages/utils

# Copy storefront app
COPY apps/storefront ./apps/storefront

# Install dependencies
RUN pnpm install --frozen-lockfile

# Build storefront app
RUN cd apps/storefront && pnpm build

# Remove dev dependencies
RUN pnpm prune --prod

EXPOSE 3002

CMD ["pnpm", "-F", "storefront", "start"]
