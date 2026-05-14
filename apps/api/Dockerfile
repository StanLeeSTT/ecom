FROM node:20-alpine

WORKDIR /app

# Install pnpm
RUN npm install -g pnpm

# Copy root workspace files
COPY pnpm-workspace.yaml package.json pnpm-lock.yaml ./

# Copy packages needed for API
COPY packages/auth ./packages/auth
COPY packages/database ./packages/database
COPY packages/utils ./packages/utils
COPY packages/ai ./packages/ai
COPY packages/payments ./packages/payments
COPY packages/analytics ./packages/analytics
COPY packages/checkout ./packages/checkout
COPY packages/search ./packages/search
COPY packages/workflows ./packages/workflows
COPY packages/email ./packages/email

# Copy API app
COPY apps/api ./apps/api

# Install dependencies
RUN pnpm install --frozen-lockfile

# Build packages
RUN cd packages/auth && pnpm build
RUN cd packages/database && pnpm build
RUN cd packages/utils && pnpm build
RUN cd packages/ai && pnpm build
RUN cd packages/payments && pnpm build
RUN cd packages/analytics && pnpm build
RUN cd packages/checkout && pnpm build
RUN cd packages/search && pnpm build
RUN cd packages/workflows && pnpm build
RUN cd packages/email && pnpm build

# Build API
RUN cd apps/api && pnpm build

# Remove dev dependencies
RUN pnpm prune --prod

EXPOSE 3001

CMD ["node", "apps/api/dist/main.js"]
