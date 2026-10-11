$ErrorActionPreference = "Stop"
Write-Host "Nur Pusulasi - Windows kurulum adimlari" -ForegroundColor Cyan
if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
  throw "Flutter PATH üzerinde bulunamadı. Flutter kurulumunu ve PATH ayarını kontrol edin."
}
flutter --version
flutter create --platforms=android,web,ios .
if ($LASTEXITCODE -ne 0) { throw "flutter create başarısız oldu." }
flutter pub get
if ($LASTEXITCODE -ne 0) { throw "flutter pub get başarısız oldu." }
dart format lib
flutter analyze
Write-Host "Kurulum adımları tamamlandı. Analyze sonuçlarını kontrol edin." -ForegroundColor Green
