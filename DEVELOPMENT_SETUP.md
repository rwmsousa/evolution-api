# Evolution API Development Setup Guide

This guide addresses common setup issues when running Evolution API in development mode.

## Issues Fixed

### 1. Baileys Crypto Error
**Error:** `TypeError: Cannot destructure property 'subtle' of 'globalThis.crypto' as it is undefined.`

**Solution:** Added `NODE_OPTIONS=--experimental-global-webcrypto` to the npm scripts in `package.json`:

```json
{
  "scripts": {
    "start": "NODE_OPTIONS=--experimental-global-webcrypto tsx ./src/main.ts",
    "start:prod": "NODE_OPTIONS=--experimental-global-webcrypto node dist/main",
    "dev:server": "NODE_OPTIONS=--experimental-global-webcrypto tsx watch ./src/main.ts"
  }
}
```

This enables the Web Crypto API in Node.js, which is required by the Baileys package for WhatsApp functionality.

**Note:** Node.js 20+ has this enabled by default, but the flag ensures compatibility across different environments and versions.

### 2. Prisma Client Initialization Error
**Error:** `@prisma/client did not initialize yet. Please run "prisma generate" and try to import it again.`

**Solution:** Generate the Prisma client before running the server:

```bash
# For PostgreSQL (default)
npm run db:generate

# Or directly with npx
npx prisma generate --schema ./prisma/postgresql-schema.prisma

# For MySQL
DATABASE_PROVIDER=mysql npm run db:generate
```

**Network-restricted environments:** If you can't download Prisma binaries due to network restrictions, use the offline script:

```bash
./generate-prisma-offline.sh
```

This creates a minimal Prisma client stub that allows the server to start for development purposes.

## Quick Setup Scripts

### Automated Setup
```bash
./setup-dev.sh
```

### Manual Setup Steps

1. **Install dependencies:**
   ```bash
   npm ci
   ```

2. **Create .env file:**
   ```bash
   cp .env.example .env
   ```
   
   Update the database connection URI and other required variables.

3. **Generate Prisma client:**
   ```bash
   npm run db:generate
   # OR for offline environments:
   ./generate-prisma-offline.sh
   ```

4. **Run database migrations (if needed):**
   ```bash
   npm run db:deploy
   ```

5. **Start the development server:**
   ```bash
   npm run dev:server
   ```

## Environment Variables

Key environment variables to configure:

```env
DATABASE_PROVIDER=postgresql
DATABASE_CONNECTION_URI='postgresql://user:pass@localhost:5432/evolution_db?schema=evolution_api'
AUTHENTICATION_API_KEY=your-api-key-here
CACHE_REDIS_ENABLED=false
TELEMETRY_ENABLED=false
```

## Troubleshooting

### Network Issues with Prisma
If you encounter network issues when generating Prisma client (common in restricted environments):

1. Use the offline script: `./generate-prisma-offline.sh`
2. Ensure you have internet access to download Prisma binaries for production
3. Try using a VPN or different network
4. For production deployment, pre-generate the client on a machine with internet access

### Crypto Issues
If you still encounter crypto issues:

1. Ensure Node.js 20+ is being used
2. Verify the `NODE_OPTIONS=--experimental-global-webcrypto` flag is set
3. Check if your environment has any crypto restrictions

### Node.js Version
- **Minimum:** Node.js 18+
- **Recommended:** Node.js 20+ for best compatibility with the Web Crypto API

### Development vs Production
- Development: Uses `tsx watch` for hot reload
- Production: Uses compiled JavaScript from `dist/` folder

## Scripts Overview

- `npm run dev:server` - Development server with hot reload and crypto flags
- `npm run start` - Production-like start with tsx and crypto flags
- `npm run start:prod` - Production start with compiled code and crypto flags
- `npm run build` - Build the application
- `npm run db:generate` - Generate Prisma client
- `npm run db:deploy` - Deploy database migrations
- `./setup-dev.sh` - Automated development setup
- `./generate-prisma-offline.sh` - Offline Prisma client generation

## File Changes Summary

### Modified Files:
1. **package.json** - Updated scripts with `NODE_OPTIONS=--experimental-global-webcrypto`
2. **DEVELOPMENT_SETUP.md** - This documentation file
3. **setup-dev.sh** - Automated setup script
4. **generate-prisma-offline.sh** - Offline Prisma client generation script