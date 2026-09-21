#!/usr/bin/env bash
# Alışveriş skill'i ön kontrolü.
# Tarayıcı otomasyonu ve web araması araçlarının kurulu olup olmadığına bakar.
# Hiçbir şey kurmaz, sadece durumu raporlar. Kurulum kararı kullanıcınındır.

set -uo pipefail

MCP_CIKTI=""
CLAUDE_VAR="hayir"

if command -v claude >/dev/null 2>&1; then
  CLAUDE_VAR="evet"
  MCP_CIKTI="$(claude mcp list 2>&1 || true)"
fi

eslesme() {
  printf '%s' "$MCP_CIKTI" | grep -qiE "$1"
}

bagli() {
  printf '%s' "$MCP_CIKTI" | grep -iE "$1" | grep -qi "connected"
}

echo "== ALISVERIS SKILL ON KONTROL =="
echo

if [ "$CLAUDE_VAR" = "hayir" ]; then
  echo "DURUM: claude CLI bulunamadi."
  echo "NOT: Arac listesini betikle okuyamiyorum. Kendi arac listene bak:"
  echo "     tarayici araci (playwright / chrome / computer) var mi kontrol et."
  echo "     Yoksa kullaniciya durumu soyle, ise baslama."
  exit 0
fi

# --- Tarayici otomasyonu (zorunlu) ---
TARAYICI="yok"
TARAYICI_AD=""
if eslesme "playwright"; then
  TARAYICI_AD="playwright"
  bagli "playwright" && TARAYICI="bagli" || TARAYICI="tanimli-ama-baglanmamis"
elif eslesme "claude-in-chrome|chrome-devtools|puppeteer"; then
  TARAYICI_AD="$(printf '%s' "$MCP_CIKTI" | grep -ioE 'claude-in-chrome|chrome-devtools|puppeteer' | head -1)"
  bagli "claude-in-chrome|chrome-devtools|puppeteer" && TARAYICI="bagli" || TARAYICI="tanimli-ama-baglanmamis"
fi

echo "TARAYICI (ZORUNLU): $TARAYICI ${TARAYICI_AD:+($TARAYICI_AD)}"
if [ "$TARAYICI" = "yok" ]; then
  echo "  Skill bu olmadan calisamaz. Onerilen kurulum:"
  echo "    claude mcp add playwright -s user -- npx @playwright/mcp@latest"
  echo "  Alternatif: Claude in Chrome eklentisi (site bazli izin ister)."
elif [ "$TARAYICI" = "tanimli-ama-baglanmamis" ]; then
  echo "  Tanimli ama baglanmamis. Claude Code'u yeniden baslatmak genelde cozer."
fi
echo

# --- Web aramasi (opsiyonel) ---
ARAMA="yok"
ARAMA_AD=""
if eslesme "tavily"; then
  ARAMA_AD="tavily"
  bagli "tavily" && ARAMA="bagli" || ARAMA="tanimli-ama-baglanmamis"
elif eslesme "brave-search|exa|perplexity"; then
  ARAMA_AD="$(printf '%s' "$MCP_CIKTI" | grep -ioE 'brave-search|exa|perplexity' | head -1)"
  bagli "brave-search|exa|perplexity" && ARAMA="bagli" || ARAMA="tanimli-ama-baglanmamis"
fi

echo "WEB ARAMASI (OPSIYONEL): $ARAMA ${ARAMA_AD:+($ARAMA_AD)}"
if [ "$ARAMA" = "yok" ]; then
  echo "  Yerlesik WebSearch varsa o yeterli, ek kuruluma gerek yok."
  echo "  Tavily istenirse (API anahtari gerekir, tavily.com uzerinden alinir):"
  echo "    claude mcp add tavily-search -s user -e TAVILY_API_KEY=ANAHTAR -- npx -y tavily-mcp"
fi
echo

# --- Sonuc ---
if [ "$TARAYICI" = "bagli" ]; then
  echo "SONUC: calisabilir"
else
  echo "SONUC: eksik-tarayici"
fi
