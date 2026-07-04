# Launch Checklist

This repo should not include runnable submit code until Seedance 2.5 is available on PoYo.

## Required Before Runnable Examples

- PoYo model page no longer marks Seedance 2.5 as coming soon
- Production model ID is confirmed
- Public API documentation is available
- Pricing is published
- Request schema is confirmed
- Status response schema is confirmed
- Webhook payload behavior is verified
- Supported input media types and limits are documented
- Example output files are available from official PoYo samples

## Required Example Updates

After availability is confirmed, this repo can add:

- `curl/generate.md`
- `node/index.mjs`
- `webhooks/express-webhook/`
- Request and response examples
- Prompt examples based on confirmed supported inputs
- Production notes based on real task behavior

## Safety Review Before Publishing Updates

Before pushing runnable examples, verify that public files do not contain:

- Real API keys
- Internal task IDs
- Dev, staging, or test API hosts
- Private media URLs
- User data or private prompts
- Local machine paths

Use `scripts/check.ps1` before every publish.
