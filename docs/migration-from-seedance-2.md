# Migration Notes From Seedance 2

Use [PoyoAPI/seedance-2-api](https://github.com/PoyoAPI/seedance-2-api) for runnable Seedance examples today.

This document is a planning guide for teams that may later evaluate Seedance 2.5.

## Keep Seedance 2 Running

Do not replace a working Seedance 2 integration with Seedance 2.5 assumptions before launch.

Keep your current integration stable:

- Submit generation tasks from the server
- Store `data.task_id`
- Poll status during testing
- Use `callback_url` webhooks in production
- Retrieve output files after `finished`
- Treat `failed` as a normal terminal state

## Prepare For Longer Outputs

Seedance 2.5 is expected to support longer single-segment clips. Product code should avoid assumptions that every video generation result is short.

Review these areas before migration:

- Task timeout policy
- Webhook retry behavior
- File download and storage limits
- Preview player duration handling
- Moderation and review workflow

## Prepare For More References

If your product already accepts image, video, or audio references, design your server-side data model so it can store reference roles and ordering.

Do not assume final Seedance 2.5 limits or formats until PoYo publishes the production API docs.

## Decide When To Upgrade

Seedance 2.5 should be evaluated when you need:

- Longer coherent scenes
- More reference control
- Higher-resolution workflows
- Better long-scene identity consistency
- Region-level refinement

For short draft loops, Seedance 2 and Seedance 2 Mini may remain the better production choice.
