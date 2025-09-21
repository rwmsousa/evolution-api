#!/bin/bash

# Evolution API Development Setup Script
# This script automates the setup process for running Evolution API in development

set -e

echo "🚀 Evolution API Development Setup"
echo "=================================="

# Check Node.js version
NODE_VERSION=$(node --version)
echo "✓ Node.js version: $NODE_VERSION"

if ! [[ "$NODE_VERSION" == v2* ]]; then
    echo "⚠️  Warning: Node.js 20+ is recommended for best compatibility"
fi

# Check if .env exists
if [ ! -f ".env" ]; then
    echo "📝 Creating .env file from template..."
    cp .env.example .env
    echo "✓ .env file created. Please review and update the configuration."
else
    echo "✓ .env file already exists"
fi

# Install dependencies
echo "📦 Installing dependencies..."
npm ci

# Generate Prisma client
echo "🗄️  Generating Prisma client..."
if npm run db:generate; then
    echo "✓ Prisma client generated successfully"
else
    echo "❌ Failed to generate Prisma client"
    echo "💡 This may be due to network restrictions. You can:"
    echo "   1. Check your internet connection"
    echo "   2. Try again later"
    echo "   3. Use a VPN if in a restricted environment"
    exit 1
fi

echo ""
echo "🎉 Setup completed successfully!"
echo ""
echo "Next steps:"
echo "1. Review and update your .env file with proper database credentials"
echo "2. Run database migrations (if needed): npm run db:deploy"
echo "3. Start the development server: npm run dev:server"
echo ""
echo "For more information, see DEVELOPMENT_SETUP.md"