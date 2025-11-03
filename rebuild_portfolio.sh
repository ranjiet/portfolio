cd ~/code/portfolio

# folders
mkdir -p .github/workflows crm home-automation tools assets/img assets/pdfs

# .gitignore
cat > .gitignore <<'EOF'
# local scratch
staging/

# Obsidian metadata
.obsidian/

# OS cruft
.DS_Store
Thumbs.db

# logs/temp
*.log
*.tmp
*.swp
EOF

# _config.yml (GitHub Pages + Just the Docs)
cat > _config.yml <<'YAML'
title: RJ’s Bridge Logic
description: CRM/RevOps + Home Automation
theme: just-the-docs
url: https://rjsbridgelogic.org
baseurl: ""
search_enabled: true
aux_links:
  View on GitHub: https://github.com/ranjiet/portfolio
YAML

# index.md (homepage)
cat > index.md <<'MD'
---
layout: default
title: Home
nav_order: 1
---

# RJ’s Bridge Logic

Welcome! Explore my work:

- **CRM & RevOps** → [Start here](crm/)
- **Home Automation** → [Start here](home-automation/)
- **Tools & Scripts** → [Start here](tools/)
MD

# Section landing pages
cat > crm/index.md <<'MD'
---
layout: default
title: CRM & RevOps
nav_order: 10
has_children: true
---

# CRM & RevOps
MD

cat > home-automation/index.md <<'MD'
---
layout: default
title: Home Automation
nav_order: 20
has_children: true
---

# Home Automation
MD

cat > tools/index.md <<'MD'
---
layout: default
title: Tools & Scripts
nav_order: 30
---

# Tools & Scripts
MD

# GitHub Pages workflow
cat > .github/workflows/pages.yml <<'YAML'
name: Build & Deploy GitHub Pages
on:
  push: { branches: [ "main" ] }
  workflow_dispatch: {}
permissions: { contents: read, pages: write, id-token: write }
concurrency: { group: "pages", cancel-in-progress: true }
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: ruby/setup-ruby@v1
        with: { ruby-version: '3.3' }
      - run: gem install bundler jekyll just-the-docs
      - run: jekyll build --trace
      - uses: actions/upload-pages-artifact@v3
        with: { path: ./_site }
  deploy:
    needs: build
    runs-on: ubuntu-latest
    environment: { name: github-pages, url: ${{ steps.deployment.outputs.page_url }} }
    steps:
      - id: deployment
        uses: actions/deploy-pages@v4
YAML
