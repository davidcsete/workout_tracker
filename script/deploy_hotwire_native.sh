#!/bin/bash

# Hotwire Native Deployment Script
set -e

echo "🚀 Starting Hotwire Native deployment..."

# Check if Kamal is installed
if ! command -v kamal &> /dev/null; then
    echo "❌ Kamal is not installed. Installing..."
    gem install kamal
fi

# Check if config/deploy.yml exists and is configured
if [ ! -f "config/deploy.yml" ]; then
    echo "❌ config/deploy.yml not found. Please configure Kamal first."
    exit 1
fi

# Check if secrets file exists
if [ ! -f ".kamal/secrets" ]; then
    echo "❌ .kamal/secrets file not found. Please create it with your credentials."
    echo "Required secrets:"
    echo "  - KAMAL_REGISTRY_PASSWORD"
    echo "  - RAILS_MASTER_KEY"
    exit 1
fi

# Run bundle install to ensure all gems are available
echo "📦 Installing dependencies..."
bundle install

# Precompile assets
echo "🎨 Precompiling assets..."
RAILS_ENV=production bundle exec rails assets:precompile

# Deploy with Kamal
echo "🚢 Deploying with Kamal..."
if [ "$1" = "setup" ]; then
    echo "🔧 Running initial setup..."
    kamal setup
else
    echo "📤 Deploying updates..."
    kamal deploy
fi

echo "✅ Deployment complete!"
echo "🔗 Your app should be available at the configured domain"
echo "📱 Configure your Hotwire Native mobile app to use this backend"