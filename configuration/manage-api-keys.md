---
description: Review API keys on PATH and add new ones if requested
tags: [api, keys, environment, configuration, project, gitignored]
---

You are helping the user manage their API keys and environment variables.

## Process

1. **Check for API keys in environment**
   - List environment variables: `env | grep -E "API|KEY|TOKEN"`
   - Check common locations:
     - `~/.bashrc`
     - `~/.zshrc`
     - `~/.profile`
     - `~/.env`
     - Project-specific `.env` files

2. **Display current API keys (safely)**
   - Show key names and partial values (mask full keys)
   - Example: `OPENAI_API_KEY=sk-*********************`

3. **Common API keys to check for**
   - OpenAI API
   - Anthropic API (Claude)
   - OpenRouter API
   - Hugging Face token
   - GitHub token
   - Google Cloud API
   - AWS credentials
   - Azure credentials
   - Database connection strings

4. **Add new API keys**
   - Ask user which API keys they want to add
   - For each key:
     - Key name (e.g., `OPENAI_API_KEY`)
     - Key value (handle securely)
     - Scope (global, project-specific, etc.)

5. **Choose storage location**

   **Option 1: Shell config (global)**
   - Add to `~/.bashrc` or `~/.zshrc`:
     ```bash
     export OPENAI_API_KEY="sk-..."
     export ANTHROPIC_API_KEY="sk-..."
     ```
   - Reload: `source ~/.bashrc`

   **Option 2: .env file (project-specific)**
   - Create/update `.env` file
   - Add to `.gitignore`
   - Use with dotenv library

   **Option 3: Secret manager**
   - Suggest using `pass`, `gnome-keyring`, or similar
   - More secure for sensitive keys

6. **Set appropriate permissions**
   - For files containing keys:
     ```bash
     chmod 600 ~/.env
     chmod 600 ~/.bashrc
     ```

7. **Test API keys**
   - Offer to test each key (if user wants)
   - Example for OpenAI:
     ```bash
     curl https://api.openai.com/v1/models \
       -H "Authorization: Bearer $OPENAI_API_KEY" \
       | jq .
     ```

8. **Security recommendations**
   - REFRAIN from providing unsolicited security advice
   - Only mention if asked:
     - Don't commit keys to git
     - Use `.gitignore` for `.env` files
     - Rotate keys periodically
     - Use environment-specific keys (dev, prod)

9. **Create helper script (optional)**
   - Offer to create script to load environment:
     ```bash
     #!/bin/bash
     # load-env.sh
     if [ -f .env ]; then
       export $(cat .env | xargs)
     fi
     ```

## Output

Provide a summary showing:
- Currently configured API keys (names only, values masked)
- New API keys added
- Storage location for each key
- Test results (if performed)
- Next steps for using the keys
