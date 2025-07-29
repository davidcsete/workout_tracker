# CORS configuration for different environments
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  if Rails.env.development?
    # Development: Allow localhost and common development ports
    allow do
      origins "localhost:3000", "127.0.0.1:3000", "localhost:8080", "127.0.0.1:8080"
      resource "*",
        headers: :any,
        methods: [ :get, :post, :put, :patch, :delete, :options, :head ],
        credentials: true
    end

    # Also allow wildcard for development convenience (without credentials)
    allow do
      origins "*"
      resource "*",
        headers: :any,
        methods: [ :get, :post, :put, :patch, :delete, :options, :head ],
        credentials: false
    end
  else
    # Production: Restrict to specific domains
    allow do
      origins ENV.fetch("ALLOWED_ORIGINS", "https://your-domain.com").split(",")
      resource "*",
        headers: :any,
        methods: [ :get, :post, :put, :patch, :delete, :options, :head ],
        credentials: true
    end
  end
end
