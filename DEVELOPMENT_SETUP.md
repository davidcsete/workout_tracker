# Development Setup Guide

## Prerequisites
- Docker and Docker Compose installed
- Ruby 3.4.3 installed
- Rails 8.0.2

## Quick Start

### 1. Start the Database
```bash
docker-compose up -d db
```

### 2. Set up the Database
```bash
rails db:create
rails db:migrate
rails db:seed
```

### 3. Start the Rails Server
```bash
rails server
```

### 4. Visit the Application
Open http://localhost:3000 in your browser

## Environment Configuration

### Environment-Specific Files
- **Development**: Uses `.env.development` (no DATABASE_URL - uses database.yml)
- **Production**: Uses `.env.production` (includes DATABASE_URL)
- **Fallback**: Uses `.env` for shared variables

### Key Point
- `DATABASE_URL` environment variable overrides database.yml configuration
- For local development, we keep DATABASE_URL out of the environment
- This allows database.yml to handle local Docker PostgreSQL connection

## Docker Services

- **Database**: PostgreSQL 16 running on port 5432
- **Web**: Rails app (when using docker-compose)
- **Ollama**: AI service on port 11434

## Useful Commands

```bash
# Stop all services
docker-compose down

# View database logs
docker-compose logs db

# Reset database
rails db:drop db:create db:migrate db:seed

# Check database connection
rails runner "puts ActiveRecord::Base.connection.active?"
```

## Troubleshooting

### Database Connection Issues
1. Make sure Docker container is running: `docker ps`
2. Check if DATABASE_URL is commented out in `.env`
3. Verify PostgreSQL version compatibility

### Google OAuth Issues
1. Restart Rails server after changing environment variables
2. Check redirect URI in Google Cloud Console
3. Verify environment variables are loaded: `rails runner "puts ENV['GOOGLE_CLIENT_ID']"`