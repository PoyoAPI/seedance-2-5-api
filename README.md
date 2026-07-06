# Seedance 2.5 API Coming Soon Notes for PoYo

[![Model page](https://img.shields.io/badge/Model%20page-seedance--2--5-84cc16)](https://poyo.ai/models/seedance-2-5)
[![Status](https://img.shields.io/badge/Status-Coming%20Soon-f59e0b)](https://poyo.ai/models/seedance-2-5)
[![Main examples](https://img.shields.io/badge/Main%20examples-PoyoAPI%2Fpoyo--examples-0f172a?logo=github)](https://github.com/PoyoAPI/poyo-examples)

Seedance 2.5 is not generally available on PoYo yet.

This repo tracks coming-soon integration notes for Seedance 2.5, based on the current PoYo model page and expected public capabilities. It is not a runnable API example yet.

Use this repo to follow expected workflows, compare Seedance 2.5 with Seedance 2 and Seedance 2 Mini, and prepare your backend integration plan before launch.

[Try on PoYo](https://poyo.ai/models/seedance-2-5) | [Main Examples](https://github.com/PoyoAPI/poyo-examples) | [Seedance 2 Examples](https://github.com/PoyoAPI/seedance-2-api)

## Current Status

Seedance 2.5 is marked as `Coming Soon` on PoYo.

PoYo will add runnable examples only after the production API path, model ID, request schema, pricing, and output behavior are confirmed.

Do not use this repo as a live submit example yet.

## Expected Capabilities

Seedance 2.5 is expected to focus on longer and more controllable video generation workflows:

- Native 30-second single-segment video
- Up to 4K-oriented output workflows
- Up to 50 multimodal references
- Text, image, video, audio, style, and pre-viz references
- Region-level editing and stronger refinement controls
- Better character, motion, lighting, and long-scene continuity
- Improved continuation for longer narrative scenes

Final API behavior may change before public availability.

## Best Fit

Seedance 2.5 is expected to be useful for:

- Brand ads and commercial storytelling
- Social video, UGC, and short drama scenes
- E-commerce product showcases
- Film, TV, and storyboard pre-visualization
- Gaming cutscenes and virtual world previews
- Enterprise training and internal video workflows

## What To Use Today

For runnable PoYo video examples today, start here:

| Need | Use |
| --- | --- |
| Seedance production video workflows | [PoyoAPI/seedance-2-api](https://github.com/PoyoAPI/seedance-2-api) |
| Lower-cost Seedance drafts | `seedance-2-mini` in [PoyoAPI/seedance-2-api](https://github.com/PoyoAPI/seedance-2-api) |
| Fast multi-shot video drafts | [PoyoAPI/kling-3-0-turbo-api](https://github.com/PoyoAPI/kling-3-0-turbo-api) |
| Veo 3.1 video workflows | [PoyoAPI/veo-3-1-official-api](https://github.com/PoyoAPI/veo-3-1-official-api) |
| General async media examples | [PoyoAPI/poyo-examples](https://github.com/PoyoAPI/poyo-examples) |

## Expected PoYo Workflow

When Seedance 2.5 becomes available, it is expected to follow PoYo's async generation pattern:

```text
submit task -> store data.task_id -> poll while testing -> use callback_url in production
```

The exact request body is not published in this repo because the live API schema is not final.

## Repo Contents

| Path | What it covers |
| --- | --- |
| [`docs/expected-workflows.md`](docs/expected-workflows.md) | Expected Seedance 2.5 workflow areas before launch. |
| [`docs/migration-from-seedance-2.md`](docs/migration-from-seedance-2.md) | How to think about moving from Seedance 2 to Seedance 2.5 later. |
| [`docs/launch-checklist.md`](docs/launch-checklist.md) | Conditions required before this becomes a runnable API example. |

## Launch Checklist

This repo should become a runnable example only after:

- PoYo marks Seedance 2.5 as available
- Production model ID is confirmed
- API documentation is published
- Pricing is published
- Request and response schema are stable
- Status polling behavior is verified
- Webhook payload behavior is verified
- Example outputs are available from official PoYo model samples

## Security Notes

- Keep `POYO_API_KEY` on the server after launch.
- Do not expose API keys in browser code, mobile apps, screenshots, or public logs.
- Do not use dev, staging, or test API hosts in public examples.
- Do not publish private prompts, private media URLs, real user data, or internal task IDs.
- Use only documented production endpoints after launch.

## Run Checks

```bash
make check
```

On Windows:

```powershell
./scripts/check.ps1
```

## License

MIT
