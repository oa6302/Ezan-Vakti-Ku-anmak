#!/bin/sh
# hadis_sec.js'in kullandigi Turkce/Arapca baskilari indirir (fawazahmed0/hadith-api)
cd "$(dirname "$0")"
for e in tur-bukhari ara-bukhari tur-nawawi ara-nawawi; do
  curl -sL -o "$e.json" "https://cdn.jsdelivr.net/gh/fawazahmed0/hadith-api@1/editions/$e.json"
done
