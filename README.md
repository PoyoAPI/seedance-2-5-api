# Seedance 2.5 API: runnable cURL and Node.js examples

[![PoYo model page](https://img.shields.io/badge/Try%20on%20PoYo-seedance--2--5--api-84cc16)](https://poyo.ai/models/seedance-2-5) [![API docs](https://img.shields.io/badge/API-docs-22d3ee)](https://docs.poyo.ai/api-manual/video-series/seedance-2.5) [![Check](https://github.com/PoyoAPI/seedance-2-5-api/actions/workflows/check.yml/badge.svg)](https://github.com/PoyoAPI/seedance-2-5-api/actions/workflows/check.yml)

Generate controllable 4-30 second videos with text, image, video, and audio references through PoYo's unified async API.

**Answer:** To use the Seedance 2.5 API, send a server-side request to `POST https://api.poyo.ai/api/generate/submit` with model `seedance-2.5` and a PoYo API key. The examples in this repository are runnable with Node.js 22+ or cURL.

Last verified against the live PoYo schema and pricing on **August 9, 2026**.

## Quickstart

1. Create a key in the [PoYo dashboard](https://poyo.ai/dashboard/api-key).
2. Copy `.env.example` to `.env` and replace the placeholder.
3. Run `node node/index.mjs`.

```dotenv
POYO_API_KEY=YOUR_POYO_API_KEY_HERE
POYO_BASE_URL=https://api.poyo.ai
```

The complete cURL request is in [curl/generate.md](curl/generate.md). The Node.js example submits the task and polls until `finished` or `failed`.

## Model IDs

- `seedance-2.5`

Use the exact IDs above. Product names and API model IDs are not always identical.

## Request fields

| Field | Requirement | Meaning |
| --- | --- | --- |
| prompt | required | Video description. |
| duration | required | Integer from 4 to 30 seconds. |
| resolution | required | 480p or 720p. |
| aspect_ratio | optional | auto, 21:9, 16:9, 4:3, 1:1, 3:4, or 9:16. |
| image_urls | optional | One or two images for first/last-frame generation. |
| reference_image_urls | optional | Up to 30 reference images. |
| reference_video_urls | optional | Up to 10 reference videos. |
| reference_audio_urls | optional | Up to 10 reference audio files. |
| generate_audio | optional | Boolean audio-generation switch. |

## Pricing snapshot

| Usage | Price |
| --- | --- |
| 480p, no reference video | $0.14 per output second |
| 480p, with reference video | $0.085 per billed second |
| 720p, no reference video | $0.315 per output second |
| 720p, with reference video | $0.19 per billed second |

Pricing can change. Confirm the current amount on the [model page](https://poyo.ai/models/seedance-2-5) before a production rollout.

## Best for

- longer narrative shots
- product and brand films
- character-consistent social video

## Important behavior

- Image-frame mode cannot be combined with multimodal reference inputs.
- Reference inputs are capped at 50 files in total.
- When reference video is used, billed duration includes output plus reference-video duration.
- Reference audio requires at least one reference image or video.

## Async production flow

```text
submit -> persist data.task_id -> poll during development -> receive callback_url webhook in production
```

Treat `finished` and `failed` as terminal states. Accept a webhook only for task IDs your system created, process it idempotently, and reconcile the final state through the status endpoint.

## Repository map

- [`curl/generate.md`](curl/generate.md) — copy-paste request
- [`node/index.mjs`](node/index.mjs) — dependency-free Node.js example
- [`docs/production-notes.md`](docs/production-notes.md) — limits and rollout checklist

## Links

- [Try Seedance 2.5 API on PoYo](https://poyo.ai/models/seedance-2-5)
- [API reference](https://docs.poyo.ai/api-manual/video-series/seedance-2.5)
- [All PoYo examples](https://github.com/PoyoAPI/poyo-examples)
- [PoYo model catalog](https://poyo.ai/models)

## License

MIT
