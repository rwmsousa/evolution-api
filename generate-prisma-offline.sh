#!/bin/bash

# Offline Prisma Client Generation Script
# Use this script when network access to Prisma binaries is restricted

echo "🔄 Attempting offline Prisma client generation..."

# Set environment variables to skip downloads and use local binaries
export PRISMA_SKIP_DOWNLOAD=true
export PRISMA_CLI_BINARY_TARGETS=native

# Check if we already have the required schema
if [ ! -f "prisma/postgresql-schema.prisma" ]; then
    echo "❌ PostgreSQL schema file not found"
    exit 1
fi

echo "📋 Using schema: prisma/postgresql-schema.prisma"

# Try to generate with existing binaries
if npx prisma generate --schema ./prisma/postgresql-schema.prisma 2>/dev/null; then
    echo "✅ Prisma client generated successfully (offline mode)"
    exit 0
fi

echo "⚠️  Offline generation failed. Creating minimal client stub..."

# Create a minimal client stub for development
cat > node_modules/.prisma/client/index.js << 'EOF'
// Minimal Prisma client stub for development
const { EventEmitter } = require('events');

class PrismaClient extends EventEmitter {
  constructor(options = {}) {
    super();
    this.options = options;
    console.log('Using minimal Prisma client stub - some features may be limited');
  }

  async $connect() {
    console.log('Prisma client stub: $connect called');
    return Promise.resolve();
  }

  async $disconnect() {
    console.log('Prisma client stub: $disconnect called');
    return Promise.resolve();
  }

  async $transaction(fn) {
    console.log('Prisma client stub: $transaction called');
    return fn(this);
  }

  // Add more stub methods as needed for your specific use case
}

module.exports = {
  PrismaClient,
};
EOF

# Update the default.js file to use our stub
cat > node_modules/.prisma/client/default.js << 'EOF'
// Default export for Prisma client stub
const { PrismaClient } = require('./index.js');
module.exports = { PrismaClient };
EOF

echo "✅ Minimal Prisma client stub created"
echo "⚠️  Note: This is a development workaround. For production, ensure proper Prisma client generation"
echo "📝 To generate the full client later, run: npm run db:generate"