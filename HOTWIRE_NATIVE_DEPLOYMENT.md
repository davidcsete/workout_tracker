# Hotwire Native Deployment Guide

This guide will help you deploy your Rails app for use with Hotwire Native mobile apps.

## Prerequisites

1. **Install dependencies:**

   ```bash
   bundle install
   ```

2. **Update your Kamal configuration:**
   - Update `config/deploy.yml` with your actual server IP and domain
   - Set up your registry credentials
   - Configure environment variables

## Configuration Changes Made

### 1. Added CORS Support

- Added `rack-cors` gem to Gemfile
- Configured CORS in `config/application.rb` for mobile app access

### 2. API Controllers

- Created `Api::BaseController` for consistent API behavior
- Updated existing API controllers to inherit from base controller
- Added Hotwire Native request detection and headers

### 3. Hotwire Native Configuration

- Created `config/hotwire_native.rb` for native app settings
- Configured path patterns for native app routing

## Deployment Steps

### 1. Update Kamal Configuration

Edit `config/deploy.yml`:

```yaml
# Update these values:
service: workout_tracker
image: your-registry/workout_tracker
servers:
  web:
    - YOUR_SERVER_IP
proxy:
  ssl: true
  host: your-domain.com
registry:
  username: your-registry-username
  password:
    - KAMAL_REGISTRY_PASSWORD
```

### 2. Set Up Environment Variables

Create `.kamal/secrets` file:

```
KAMAL_REGISTRY_PASSWORD=your_registry_password
RAILS_MASTER_KEY=your_rails_master_key
```

### 3. Deploy

```bash
# First deployment
kamal setup

# Subsequent deployments
kamal deploy
```

## Mobile App Configuration

Your Hotwire Native mobile app should connect to:

- **Base URL:** `https://your-domain.com`
- **API Endpoints:** `/api/*`

### Key API Endpoints:

- `GET /api/barcodes?barcode=123456` - Barcode scanning
- `GET /api/exercise_trackings` - Exercise tracking data

## Testing the Deployment

1. **Health Check:**

   ```bash
   curl https://your-domain.com/up
   ```

2. **API Test:**

   ```bash
   curl -H "User-Agent: Hotwire Native" https://your-domain.com/api/exercise_trackings
   ```

3. **CORS Test:**
   ```bash
   curl -H "Origin: https://your-mobile-app.com" \
        -H "Access-Control-Request-Method: GET" \
        -H "Access-Control-Request-Headers: Content-Type" \
        -X OPTIONS https://your-domain.com/api/barcodes
   ```

## Security Considerations

1. **Update CORS origins** in production:
   Set the `ALLOWED_ORIGINS` environment variable:

   ```bash
   # In your deployment environment
   export ALLOWED_ORIGINS="https://your-domain.com,https://your-mobile-app.com"
   ```

2. **API Authentication:** Consider adding token-based authentication for API endpoints

3. **Rate Limiting:** Implement rate limiting for API endpoints

## Troubleshooting

- **CORS Issues:** Check browser dev tools for CORS errors
- **SSL Issues:** Ensure your domain has valid SSL certificate
- **API Errors:** Check Rails logs with `kamal app logs`
- **Deployment Issues:** Check Kamal logs and server connectivity

## Next Steps

1. Build your Hotwire Native mobile app
2. Configure the mobile app to use your deployed API
3. Test all functionality end-to-end
4. Set up monitoring and logging
