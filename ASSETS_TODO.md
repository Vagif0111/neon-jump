# 🎨 Asset TODO Listesi — Neon Jump

Bu projede internet erişimim olmadığı için gerçek sprite/ses dosyalarını
indiremedim. Bunun yerine **kod ile çizilen placeholder görseller**
(gradyanlı dikdörtgen oyuncu, üçgen diken, yıldızlı arka plan) kullandım.
Oyun bu haliyle **tamamen çalışır ve derlenebilir durumda** — ses/görsel
dosyaları eksik olsa bile `AudioManager` hatasız şekilde sessiz kalır.

Profesyonel görünüm için aşağıdaki dosyaları indirip belirtilen yollara
koymanız yeterli; kod tarafında hiçbir değişiklik gerekmez.

## Gerekli Dosyalar

| Dosya Yolu | Ne olmalı | Önerilen Kaynak |
|---|---|---|
| `assets/images/player.png` | 32x32 veya 48x48 px, şeffaf arkaplanlı tek kare karakter sprite'ı | **Kenney.nl — "Pixel Platformer"** veya **"Abstract Platformer"** paketi (CC0) |
| `assets/images/obstacle.png` | Diken/testere şeklinde 32x32 px engel sprite'ı | **Kenney.nl — "Pixel Platformer"** içindeki `spikes.png` |
| `assets/images/background.png` | Yatayda tekrarlanabilir (tileable) gökyüzü/şehir silüeti, geniş çözünürlük (ör. 1024x600) | **Kenney.nl — "Background Elements"** veya **itch.io** üzerinde "free parallax background CC0" araması |
| `assets/audio/jump.mp3` | Kısa (0.2-0.4 sn) "zıplama" sesi | **Kenney.nl — "Interface Sounds"** paketi |
| `assets/audio/hit.mp3` | Kısa "çarpışma / oyun bitti" sesi | **Kenney.nl — "Interface Sounds"** veya **"RPG Audio"** paketi |
| `assets/audio/tap.mp3` | Kısa UI tıklama sesi (buton tıklamaları için, opsiyonel) | **Kenney.nl — "Interface Sounds"** paketi |
| `android/app/src/main/res/mipmap-*/ic_launcher.png` | Uygulama ikonu (adaptive icon önerilir) | Kendi tasarımınız veya `flutter_launcher_icons` paketiyle otomatik üretim |

> **Not:** Şu an `ic_launcher.png` dosyaları kod ile üretilen basit bir
> "NJ" logosu placeholder'ıdır — Play Store'a çıkmadan önce gerçek bir
> logo ile değiştirilmesi önerilir.

## Nereden İndirilir?

1. **kenney.nl/assets** → istediğiniz paketi seçip "Download" deyin.
   Kenney'nin **tüm** asset'leri **CC0 (Creative Commons Zero)**
   lisanslıdır → ticari kullanım dahil, atıf gerekmeden serbestçe
   kullanılabilir.
2. **itch.io/game-assets/free** → filtrelerden "CC0" veya
   "Commercial use allowed" seçeneğini işaretleyin.
3. **opengameart.org** → her asset'in lisansı sayfasında ayrı ayrı
   yazar; **CC0** veya **CC-BY** (atıf gerektirir, atıf metnini
   README'ye eklemeniz gerekir) olanları tercih edin. **CC-BY-NC**
   (ticari olmayan) ve **GPL** lisanslı sprite/sesleri Play Store'a
   koyacağınız bir oyunda **kullanmayın**.

## Entegrasyon

Sprite'ları indirdikten sonra:

```dart
// player.dart içindeki render() metodunu SpriteComponent'e çevirmek için:
class Player extends SpriteComponent with ... {
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('player.png');
    // ... geri kalan hitbox kodu aynı kalır
  }
}
```

Aynı mantık `obstacle.dart` ve arka plan için de geçerli — `render()`
içindeki `canvas.draw...` çağrılarını `Sprite.load()` + `sprite.render(canvas)`
ile değiştirmeniz yeterli.
