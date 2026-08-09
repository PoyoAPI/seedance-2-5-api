# Seedance 2.5 API production notes

## Confirmed contract

- Endpoint: `POST /api/generate/submit`
- Model ID: `seedance-2.5`
- Authentication: `Authorization: Bearer <POYO_API_KEY>`

## Input limits

| Field | Requirement | Constraint |
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

## Operational checklist

- Keep API keys in a server-side secret manager.
- Validate user input before calling the API.
- Persist `data.task_id` immediately after submission.
- Use five-second polling only for development; prefer `callback_url` in production.
- Make webhook processing idempotent and reconcile status before fulfilling an order.
- Copy output files to durable storage before provider URLs expire.
- Recheck the live model page before hard-coding prices.

## Failure handling

Treat non-2xx HTTP responses and non-success API `code` values as errors. Preserve the HTTP status, API code, request ID when present, and a redacted response body for debugging.

Schema: [PoYo API documentation](https://docs.poyo.ai/api-manual/video-series/seedance-2.5)

