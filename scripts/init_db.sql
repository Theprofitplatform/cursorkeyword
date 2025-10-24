-- Database Initialization Script for PostgreSQL
-- Used by docker-compose.yml during first startup
-- For SQLite, this is handled by SQLAlchemy in database.py

-- Enable extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";  -- For text search optimization

-- Set timezone
SET timezone = 'UTC';

-- Create application user (if not exists)
-- Docker compose already creates the user, but this is for manual setup
DO
$$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_user WHERE usename = 'keyword_user') THEN
    CREATE USER keyword_user WITH PASSWORD 'keyword_pass';
  END IF;
END
$$;

-- Create database (if not exists)
-- Docker compose handles this, but included for completeness
SELECT 'CREATE DATABASE keyword_research'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'keyword_research')\gexec

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE keyword_research TO keyword_user;

-- Connect to the application database
\c keyword_research

-- Grant schema privileges
GRANT ALL ON SCHEMA public TO keyword_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO keyword_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO keyword_user;

-- Set default privileges for future tables
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO keyword_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO keyword_user;

-- Performance tuning
-- Adjust these based on your server resources

-- Connection settings
ALTER SYSTEM SET max_connections = 100;
ALTER SYSTEM SET shared_buffers = '256MB';
ALTER SYSTEM SET effective_cache_size = '1GB';
ALTER SYSTEM SET maintenance_work_mem = '64MB';
ALTER SYSTEM SET checkpoint_completion_target = 0.9;
ALTER SYSTEM SET wal_buffers = '16MB';
ALTER SYSTEM SET default_statistics_target = 100;
ALTER SYSTEM SET random_page_cost = 1.1;
ALTER SYSTEM SET effective_io_concurrency = 200;
ALTER SYSTEM SET work_mem = '4MB';
ALTER SYSTEM SET min_wal_size = '1GB';
ALTER SYSTEM SET max_wal_size = '4GB';

-- Reload configuration
SELECT pg_reload_conf();

-- Create indexes for common queries (after tables are created)
-- These will be created automatically by SQLAlchemy, but listed here for reference
-- 
-- CREATE INDEX IF NOT EXISTS idx_keywords_project_opportunity ON keywords(project_id, opportunity DESC);
-- CREATE INDEX IF NOT EXISTS idx_keywords_project_intent ON keywords(project_id, intent);
-- CREATE INDEX IF NOT EXISTS idx_keywords_lemma ON keywords(lemma);
-- CREATE INDEX IF NOT EXISTS idx_keywords_difficulty ON keywords(difficulty);
-- CREATE INDEX IF NOT EXISTS idx_serp_snapshots_query_geo ON serp_snapshots(query, geo, language);
-- CREATE INDEX IF NOT EXISTS idx_audit_logs_project ON audit_logs(project_id);
-- CREATE INDEX IF NOT EXISTS idx_audit_logs_provider ON audit_logs(provider);
-- CREATE INDEX IF NOT EXISTS idx_audit_logs_timestamp ON audit_logs(timestamp);
-- CREATE INDEX IF NOT EXISTS idx_cache_key ON cache(key);

-- Text search optimization
-- CREATE INDEX IF NOT EXISTS idx_keywords_text_trgm ON keywords USING gin(text gin_trgm_ops);

-- Enable query logging for debugging (disable in production)
-- ALTER SYSTEM SET log_statement = 'all';
-- ALTER SYSTEM SET log_duration = on;
-- ALTER SYSTEM SET log_min_duration_statement = 1000;  -- Log queries taking >1s

-- Create view for top opportunities (optional, created by application if needed)
-- CREATE OR REPLACE VIEW vw_opportunities_top20 AS
-- SELECT 
--   k.id,
--   k.text as keyword,
--   k.intent,
--   k.search_volume,
--   k.difficulty,
--   k.opportunity_score,
--   k.topic_label,
--   k.page_label,
--   k.is_pillar
-- FROM keywords k
-- WHERE k.opportunity_score > 50
-- ORDER BY k.opportunity_score DESC
-- LIMIT 20;

-- Maintenance tasks (run periodically)
-- VACUUM ANALYZE;  -- Run weekly
-- REINDEX DATABASE keyword_research;  -- Run monthly

-- Backup recommendations
-- pg_dump -U keyword_user -F c -b -v -f backup.dump keyword_research
-- Restore: pg_restore -U keyword_user -d keyword_research -v backup.dump

COMMIT;
