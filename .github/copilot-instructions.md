# AI Coding Agent Instructions for Police

## Project Overview
Rails 8 API-only application for managing officer records. Single resource (Officer) with CRUD endpoints. Built with SQLite, Solid Stack (cache, queue, cable), and Docker deployment via Kamal.

## Architecture & Key Patterns

### API Structure
- **API-only Rails app** (`config/application.rb`: `config.api_only = true`)
- Single RESTful resource: `Officer` with fields: `name`, `bn` (badge number), `incident` (text)
- Dual routes: Traditional `/officers` + versioned `/api/v1/officers`
- CORS enabled for all origins in ../config/initializers/cors.rb

### Data Layer
- **Model**: ../app/models/officer.rb (minimal, inherits from ApplicationRecord)
- **Database**: SQLite in development, single table `officers` with timestamps
- **Migrations**: Use `bin/rails generate model Officer name:string bn:string incident:text` pattern
- **Schema**: ../db/schema.rb auto-generated from migrations (do not edit directly)

### Controller Layer
- ../app/controllers/officers_controller.rb handles all 7 RESTful actions
- Pattern: `before_action :set_officer` for show/update/destroy
- JSON responses with `render json:`, `status: :created`, `:unprocessable_content` for errors
- Error handling: Returns `@officer.errors` for validation failures

### Testing
- **Framework**: Rails minitest with parallel execution (`parallelize(workers: :number_of_processors)`)
- **Test structure**: ../test/controllers/officers_controller_test.rb uses ActionDispatch::IntegrationTest
- **Fixtures**: ../test/fixtures/officers.yml auto-loaded for all tests
- **Assertions**: `assert_difference`, `assert_response`, pass `as: :json` for API tests

## Development Workflows

### Running the Application
- **Start server**: `rails s` (default port 3000) or `rails s -p 8082` for alternate port
- **Full dev setup**: `bin/dev` (starts with Thruster for HTTP asset caching)
- **Interactive console**: `rails c`

### Database Operations
- **Create/migrate**: `bin/rails db:create db:migrate`
- **Reset schema**: `bin/rails db:reset` (caution: destroys data)
- **Load schema**: `bin/rails db:schema:load` (faster for fresh setup)
- **Generate migration**: `bin/rails generate migration AddFieldToOfficers field_name:type`

### Testing & Quality
- **Run tests**: `bin/rails test` (runs all tests in parallel)
- **Run specific test**: `bin/rails test test/models/officer_test.rb`
- **Security scan**: `bin/brakeman` (static analysis for vulnerabilities)
- **Style check**: `bin/rubocop` (Omakase Rails style enforcement)

### Deployment
- **Container**: `docker build -t police .` (Ruby 3.4.3, SQLite3 included)
- **Deploy**: `bin/kamal` (production deployment orchestration)
- **Deploy config**: ../config/deploy.yml - configure servers, registry, SSL/proxy
- **Credentials**: Use `RAILS_MASTER_KEY` env var for production secrets

## Project-Specific Conventions

### JSON API Responses
- All controllers use `render json:` with appropriate HTTP status codes
- Status codes: `:created` (201), `:unprocessable_content` (422), `:success` (200)
- Error responses return `@officer.errors` hash (auto-serialized to JSON)

### Rack CORS Configuration
- Currently allows all origins (`origins "*"`) and all methods/headers
- Update ../config/initializers/cors.rb to restrict for production security

### Environment Configuration
- **Development**: Eager loading disabled, caching optional (toggle via `rails dev:cache`), localhost mailer
- **Production**: Uses Solid Stack for cache/queue/cable (database-backed), asset caching via Thruster
- **Test**: Parallel test execution, all fixtures preloaded

### Database-Backed Infrastructure
- No external services required: cache, queue, and WebSocket cable all use database
- ../config/cable.yml, ../config/cache.yml, ../config/queue.yml configured for Solid adapters
- Schema includes `cable_schema.rb`, `cache_schema.rb`, `queue_schema.rb`

## Common Tasks

| Task | Command | Notes |
|------|---------|-------|
| Add Officer field | `bin/rails g migration` + update model/tests | Always test with fixtures |
| Debug API response | `rails c` + `Officer.all` or test endpoint with `bin/rails test` | Use `as: :json` in tests |
| Check for vulns | `bin/brakeman -q` | Runs in dev environment only |
| Prepare deployment | Update ../config/deploy.yml, set `RAILS_MASTER_KEY` | Test with Docker locally first |

## External Dependencies & Integration Points
- **No external APIs** currently integrated (Solid Stack is self-contained)
- **Docker-based deployment** requires registry credentials (config/deploy.yml)
- **CORS** currently permissive; tighten before production
- **Rack middleware chain**: CORS inserted before other middleware

## When Adding Features
1. Create migration + model validation if needed
2. Update controller with new action or parameter handling
3. Add test coverage in ActionDispatch::IntegrationTest or minitest
4. Test with `bin/rails test`
5. Check style: `bin/rubocop -a` (auto-fix common issues)
6. Verify security: `bin/brakeman -q`
