"""
Günün ipucu API — mobil uygulama POST /tips/daily çağırır.
OpenAI anahtarı yalnızca backend/.env dosyasında tutulur.
"""

from __future__ import annotations

import os
from typing import Any

from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from openai import OpenAI
from pydantic import BaseModel, Field

load_dotenv()

app = FastAPI(title="Bitirme Plant API", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


class TipContext(BaseModel):
    recent_scan_count: int = Field(ge=0)
    dominant_species_label: str | None = None
    dominant_disease_key: str | None = None
    disease_counts: dict[str, int] = Field(default_factory=dict)
    species_counts: dict[str, int] = Field(default_factory=dict)
    average_health_score: int = Field(ge=0, le=100)
    distinct_disease_count: int = Field(ge=0)


class DailyTipRequest(BaseModel):
    locale: str = "tr"
    context: TipContext


class DailyTipResponse(BaseModel):
    tip: str


def _client() -> OpenAI:
    api_key = os.getenv("OPENAI_API_KEY", "").strip()
    if not api_key:
        raise HTTPException(
            status_code=503,
            detail="OPENAI_API_KEY is not configured on the server.",
        )
    return OpenAI(api_key=api_key)


def _build_messages(locale: str, ctx: TipContext) -> list[dict[str, str]]:
    lang = "Turkish" if locale.lower().startswith("tr") else "English"
    context_blob: dict[str, Any] = ctx.model_dump()
    system = (
        "You are a concise home gardening assistant for a mobile plant health app. "
        f"Reply in {lang} only. "
        "Give one practical tip in 2-3 short sentences (max 280 characters). "
        "Base advice on the scan statistics provided. "
        "Do not mention AI, models, or JSON. No bullet lists."
    )
    user = (
        "User's last 5 days of plant scans (summary):\n"
        f"{context_blob}\n\n"
        "Write today's personalized care tip."
    )
    return [
        {"role": "system", "content": system},
        {"role": "user", "content": user},
    ]


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}


@app.post("/tips/daily", response_model=DailyTipResponse)
def tips_daily(body: DailyTipRequest) -> DailyTipResponse:
    model = os.getenv("OPENAI_MODEL", "gpt-4o-mini").strip() or "gpt-4o-mini"
    client = _client()
    try:
        completion = client.chat.completions.create(
            model=model,
            messages=_build_messages(body.locale, body.context),
            max_tokens=180,
            temperature=0.7,
        )
    except Exception as exc:  # noqa: BLE001
        raise HTTPException(status_code=502, detail=f"OpenAI request failed: {exc}") from exc

    text = (completion.choices[0].message.content or "").strip()
    if not text:
        raise HTTPException(status_code=502, detail="Empty response from OpenAI.")
    return DailyTipResponse(tip=text)
