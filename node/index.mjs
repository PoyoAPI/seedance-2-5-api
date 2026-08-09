import { existsSync, readFileSync } from "node:fs";
import { resolve } from "node:path";

for (const envPath of [resolve(process.cwd(), ".env"), resolve(process.cwd(), "../.env")]) {
  if (!existsSync(envPath)) continue;
  for (const line of readFileSync(envPath, "utf8").split(/\r?\n/)) {
    const trimmed = line.trim();
    if (!trimmed || trimmed.startsWith("#")) continue;
    const index = trimmed.indexOf("=");
    if (index < 0) continue;
    const key = trimmed.slice(0, index).trim();
    const value = trimmed.slice(index + 1).trim();
    if (!process.env[key]) process.env[key] = value;
  }
}

const apiKey = process.env.POYO_API_KEY;
const baseUrl = process.env.POYO_BASE_URL || "https://api.poyo.ai";
if (!apiKey || apiKey === "YOUR_POYO_API_KEY_HERE") {
  console.error("Set POYO_API_KEY in your environment or repo-root .env file.");
  process.exit(1);
}

async function requestJson(path, options) {
  const response = await fetch(`${baseUrl}${path}`, options);
  const text = await response.text();
  let body = {};
  if (text) {
    try { body = JSON.parse(text); } catch { body = { raw: text }; }
  }
  const apiCode = Number(body?.code);
  const hasApiError = Number.isFinite(apiCode) && apiCode !== 0 && apiCode !== 200;
  if (!response.ok || hasApiError) {
    throw new Error(`PoYo request failed: ${JSON.stringify({ http_status: response.status, api_code: body?.code, body }, null, 2)}`);
  }
  return body;
}

const payload = {
  "model": "seedance-2.5",
  "input": {
    "prompt": "A cinematic tracking shot through a neon-lit night market after rain, natural crowd motion, reflections on the pavement",
    "duration": 8,
    "resolution": "720p",
    "aspect_ratio": "16:9",
    "generate_audio": false
  }
};

if (process.env.POYO_CALLBACK_URL) payload.callback_url = process.env.POYO_CALLBACK_URL;

const submitted = await requestJson("/api/generate/submit", {
  method: "POST",
  headers: { Authorization: `Bearer ${apiKey}`, "Content-Type": "application/json" },
  body: JSON.stringify(payload),
});
const taskId = submitted.data?.task_id;
if (!taskId) throw new Error(`Missing data.task_id: ${JSON.stringify(submitted)}`);
console.log(`submitted task: ${taskId}`);

for (let attempt = 1; attempt <= 60; attempt += 1) {
  const result = await requestJson(`/api/generate/status/${taskId}`, {
    headers: { Authorization: `Bearer ${apiKey}` },
  });
  const status = result.data?.status;
  console.log(`poll ${attempt}: ${status || "unknown"}`);
  if (status === "finished" || status === "failed") {
    console.log(JSON.stringify(result, null, 2));
    process.exit(status === "finished" ? 0 : 1);
  }
  await new Promise((resolveSleep) => setTimeout(resolveSleep, 5000));
}
throw new Error(`Timed out waiting for task ${taskId}`);

