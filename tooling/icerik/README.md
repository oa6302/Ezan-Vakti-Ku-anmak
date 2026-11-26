# Günlük içerik üreticileri
- Ayet (365): `node ayet_cek.js ../../assets/content/gunluk_ayetler.json` — liste `ayet_listesi.js`, metin api.quran.com (Uthmani + Diyanet meali, çeviri 77).
- Hadis (365): `sh hadis_indir.sh && node hadis_sec.js ../../assets/content/gunluk_hadisler.json` — Nevevî Kırk Hadis + Buhârî seçili kitaplar; numara kaynaktan.
İndirilen `*.json` dosyaları git'e girmez.
