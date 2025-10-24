# Quick Start Guide

Get up and running in 5 minutes.

## Step 1: Install (2 minutes)

```bash
# Clone and enter directory
git clone <repo-url>
cd cursorkeyword

# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Download NLP model
python -m spacy download en_core_web_sm
```

## Step 2: Configure (1 minute)

```bash
# Copy environment file
cp .env.example .env

# Edit .env and add your SerpAPI key
# Get free key at: https://serpapi.com/users/sign_up
nano .env
```

Minimum config (add to `.env`):
```
SERPAPI_API_KEY=your_key_here
```

## Step 3: Initialize (30 seconds)

```bash
python cli.py init
```

## Step 4: Run First Project (2 minutes)

```bash
python cli.py create \
  --name "SEO Tools Research" \
  --seeds "seo tools,keyword research,rank tracking" \
  --geo US \
  --focus commercial
```

This will:
- ✅ Expand 3 seeds into 200-500 keywords
- ✅ Analyze SERP data and features
- ✅ Score difficulty and opportunity
- ✅ Cluster into topics
- ✅ Generate content briefs

## Step 5: View Results

```bash
# See summary report
python cli.py report 1

# Export to CSV
python cli.py export 1 --format csv --output results.csv

# Generate content calendar
python cli.py calendar 1 --weeks 12
```

## Next Steps

### Export to Google Sheets

1. Set up Google Service Account
2. Add credentials path to `.env`
3. Run: `python cli.py export 1 --format sheets`

### Export to Notion

1. Get Notion API key and database ID
2. Add to `.env`:
   ```
   NOTION_API_KEY=your_key
   NOTION_DATABASE_ID=your_db_id
   ```
3. Run: `python cli.py export 1 --format notion`

### Advanced Features

- **Competitor Analysis**: Extract keywords from competitor sites
- **Local SEO**: Geographic keyword expansion
- **Custom Clustering**: Adjust thresholds for your niche
- **WordPress Integration**: Export directly to WP drafts

See full documentation in `README.md`.

## Common Issues

**"Too many requests"**
→ Reduce rate limits in `.env`

**"No keywords found"**
→ Add more diverse seed keywords

**"Import errors"**
→ Reinstall dependencies: `pip install -r requirements.txt --force-reinstall`

## Support

- 📖 Full docs: See README.md
- 🐛 Issues: Open GitHub issue
- 💬 Questions: Check troubleshooting section in README

---

**You're ready!** Start researching keywords and planning content at scale.
