# Google OAuth Setup Guide

## 1. Create Google OAuth Credentials

1. Go to the [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable the Google+ API:
   - Go to "APIs & Services" > "Library"
   - Search for "Google+ API" and enable it
4. Create OAuth 2.0 credentials:
   - Go to "APIs & Services" > "Credentials"
   - Click "Create Credentials" > "OAuth 2.0 Client IDs"
   - Choose "Web application"
   - Add authorized redirect URIs:
     - For development: `http://localhost:3000/users/auth/google_oauth2/callback`
     - For production: `https://workout-cooker.fly.dev/users/auth/google_oauth2/callback`
   - **IMPORTANT**: Make sure the redirect URI exactly matches your server URL

## 2. Configure Environment Variables

Add your Google OAuth credentials to your `.env` file:

```
GOOGLE_CLIENT_ID=your_actual_google_client_id_here
GOOGLE_CLIENT_SECRET=your_actual_google_client_secret_here
```

## 3. Set Production Environment Variables (Fly.io)

For production deployment on Fly.io, set the secrets:

```bash
fly secrets set GOOGLE_CLIENT_ID='your_google_client_id'
fly secrets set GOOGLE_CLIENT_SECRET='your_google_client_secret'
```

## 4. Test the Integration

### Development
1. Start your Rails server: `rails server`
2. Visit the login page
3. Click "Continue with Google"
4. Complete the OAuth flow

### Production
1. Visit https://workout-cooker.fly.dev
2. Click "Continue with Google"
3. Complete the OAuth flow

## Features Added

- ✅ Google OAuth login button on login page
- ✅ Google OAuth login button on registration page
- ✅ Automatic user creation from Google account
- ✅ Username generation from email
- ✅ Secure password handling for OAuth users
- ✅ Proper error handling and redirects

## Troubleshooting

### "Missing required parameter: client_id" Error
1. **Check environment variables are loaded**: Run `rails runner "puts ENV['GOOGLE_CLIENT_ID']"` - should show your client ID
2. **Restart Rails server**: Environment variables are loaded at startup
3. **Verify .env file**: Make sure `dotenv-rails` gem is installed and `.env` file exists
4. **Check Google Console**: Ensure redirect URI matches exactly: `http://localhost:3000/users/auth/google_oauth2/callback`

### "redirect_uri_mismatch" Error
- In Google Cloud Console, add the exact redirect URI for your environment
- Development: `http://localhost:3000/users/auth/google_oauth2/callback`
- Make sure there are no trailing slashes or extra characters

### OAuth Button Not Working
- Check that `data: { turbo: false }` is set on the OAuth link
- Verify routes are configured correctly: `rails routes | grep omniauth`

## Security Notes

- OAuth users get a random password generated automatically
- Email and password validation is bypassed for OAuth users
- Unique index on provider + uid for security
- CSRF protection enabled for OAuth requests
