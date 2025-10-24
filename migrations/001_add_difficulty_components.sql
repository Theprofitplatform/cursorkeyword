-- Migration: Add difficulty component columns and checkpoint fields
-- Date: 2024-10-24
-- Description: Adds breakdown columns for difficulty scoring and checkpoint fields for resume functionality

-- Add difficulty component columns to keywords table
ALTER TABLE keywords ADD COLUMN difficulty_serp_strength REAL;
ALTER TABLE keywords ADD COLUMN difficulty_competition REAL;
ALTER TABLE keywords ADD COLUMN difficulty_serp_crowding REAL;
ALTER TABLE keywords ADD COLUMN difficulty_content_depth REAL;

-- Add checkpoint fields to projects table
ALTER TABLE projects ADD COLUMN last_checkpoint VARCHAR(50);
ALTER TABLE projects ADD COLUMN checkpoint_timestamp DATETIME;
ALTER TABLE projects ADD COLUMN checkpoint_data TEXT;  -- JSON blob

-- Add comments for documentation
COMMENT ON COLUMN keywords.difficulty_serp_strength IS 'SERP strength component (0-1): homepage ratio, brands';
COMMENT ON COLUMN keywords.difficulty_competition IS 'Competition component (0-1): allintitle ratio';
COMMENT ON COLUMN keywords.difficulty_serp_crowding IS 'Crowding component (0-1): ads + SERP features';
COMMENT ON COLUMN keywords.difficulty_content_depth IS 'Content depth component (0-1): word count proxy';

COMMENT ON COLUMN projects.last_checkpoint IS 'Last completed pipeline stage';
COMMENT ON COLUMN projects.checkpoint_timestamp IS 'When checkpoint was saved';
COMMENT ON COLUMN projects.checkpoint_data IS 'Additional checkpoint state (JSON)';
