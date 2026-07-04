# Expected Workflows

Seedance 2.5 is a coming-soon model on PoYo. The notes below describe expected workflow areas, not a confirmed request schema.

## Long Single-Segment Scenes

Seedance 2.5 is expected to target native 30-second single-segment clips. That matters when a team wants one coherent scene arc instead of stitching several short clips together.

Useful planning questions:

- What is the beginning, middle, and end of the scene?
- Which subject must remain consistent for the full shot?
- Which camera movement should stay stable across the whole clip?
- What should not change between frames?

## Multimodal Reference Direction

Seedance 2.5 is expected to support larger multimodal reference sets than Seedance 2.0.

Prepare references around clear roles:

- Product or character identity
- Style and lighting
- Motion or pacing
- Audio cues
- Environment and props
- Brand-safe visual constraints

## Region-Level Refinement

Region editing is expected to help teams refine part of a scene while preserving broader identity, lighting, and style.

Before launch, avoid building production UX that assumes exact mask formats, coordinate systems, or region payloads. Wait for the final PoYo API documentation.

## Production Async Pattern

When available, Seedance 2.5 is expected to follow PoYo's async generation pattern:

```text
submit task -> store data.task_id -> poll while testing -> use callback_url in production
```

Do not hard-code a request body before the production schema is confirmed.
