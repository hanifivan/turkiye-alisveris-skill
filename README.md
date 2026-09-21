# turkiye-alisveris-skill

Türkiye pazaryerleri için bir satın alma kararı skill'i. Claude Code, Cursor ve Agent Skills formatını destekleyen diğer araçlarda çalışır.

Ürün linklerini tarayıcıyla tek tek açar, fiyatı ve stoğu canlı sayfadan doğrular, kategoriye özgü kriterleri uygular ve gerekçeli bir öneri üretir. Fiyat karşılaştırma aracı değil, **karar aracı**.

## Neden

Alışveriş kararlarında hatalar hep aynı üç yerden geliyor:

1. **Etiket fiyatına bakmak.** Sepet indirimi, kargo ve taksit farkı sıralamayı tersine çevirebiliyor. Karar, eline geçene kadarki toplam maliyete göre verilmeli.
2. **Sayfayı açmadan konuşmak.** Arama sonucu özetlerindeki fiyat bayat oluyor, kısaltılmış link başka bir varyanta gidiyor.
3. **Yanlış segmenti önermek.** Ürün doğru, beden yanlış. Bu en sık yapılan ve en pahalı hata.

Skill bu üçünü kapatmak için kuruldu. Uydurma bir kontrol listesi değil, gerçek oturumlarda çarpılan duvarlardan çıktı.

## Gereksinimler

**Tarayıcı otomasyonu zorunlu.** Skill'in tamamı canlı ürün sayfası okumaya dayanıyor. Şunlardan biri kurulu olmalı:

- [Playwright MCP](https://github.com/microsoft/playwright-mcp), ya da
- Claude in Chrome eklentisi, ya da eşdeğeri bir tarayıcı aracı

Tarayıcı aracı yoksa skill işe başlamaz, durumu söyleyip durur. Bu bilinçli bir tercih: arama sonucu özetlerinden fiyat üretmek, skill'in engellemek için var olduğu hatanın ta kendisi.

**Web araması opsiyonel.** WebSearch, [Tavily MCP](https://github.com/tavily-ai/tavily-mcp) ya da eşdeğeri. Link verilmemişken aday ürün bulmak için işe yarar. Yoksa skill pazaryerinin kendi arama sayfasını tarayıcıyla açar. Aday listesi çıkarmak dışında kullanılmaz, fiyat ve stok her zaman ürünün kendi sayfasından doğrulanır.

**API anahtarı gerekmiyor.** Skill'in kendisi hiçbir servise bağlanmıyor. Tavily kullanacaksan onun kendi anahtarı gerekir, ama zorunlu değil.

Claude in Chrome kullanıyorsan her alan adı için ayrı izin vermen gerekiyor. İzin verilmeyen siteyi skill atlar ve raporda belirtir, tahminle doldurmaz.

## Kurulum

```bash
git clone https://github.com/hanifivan/turkiye-alisveris-skill.git
cp -R turkiye-alisveris-skill/skills/alisveris ~/.claude/skills/
```

Proje bazlı kurmak istersen `~/.claude/skills/` yerine projenin `.claude/skills/` dizinine kopyala.

## Kullanım

Skill kendiliğinden tetikleniyor, ayrı bir komut yazman gerekmiyor. Bir ürün linki paylaşıp "şuna bir bak" demen ya da "şu bütçeye şunu arıyorum" demen yeterli.

```
https://ty.gl/xxxxx bunu inceler misin
```

```
11 yaşında bir çocuğa 5 bin TL bütçeyle salon için basketbol ayakkabısı arıyorum
```

Skill önce eksik kriterleri tek blokta sorar (beden, kim kullanacak, fiyat aralığı, marka tercihi, kullanım yeri, olmazsa olmaz), sonra ilanları açıp doğrular ve raporu yazar.

## Nasıl karar veriyor

**Önce eleme, sonra sıralama.** Uyan beden yoksa, stok yoksa ya da olmazsa olmaz bir koşul karşılanmıyorsa ilan aday bile değil, en başta düşüyor. Bu ayrım önemli, çünkü aksi halde beden tutmayan bir ürün fiyatı iyi diye listenin başına çıkıyor.

**Yorum güvenilirliği işaretleniyor.** 20'nin altındaki yorum sayısı "zayıf sinyal", 5'in altı "yok sayılır". 3 kişinin verdiği 5.0, 1400 kişinin verdiği 4.5'ten zayıf bir sinyaldir ve rapor bunu açıkça söyler.

**Toplam maliyet üzerinden sıralama.** Sepet fiyatı artı kargo artı varsa gümrük ve taksit farkı. Her fiyatın yanına tarih yazılır, çünkü bu siteler günlük fiyat değiştiriyor.

**Sahte aciliyet karar gerekçesi yapılmıyor.** "Son 2 ürün" ve "son 10 günün en düşük fiyatı" bilgi olarak aktarılır, gerekçe olarak kullanılmaz.

## Kapsam

Site bazlı pratik bilgiler `skills/alisveris/references/siteler.md` dosyasında:

| Site | Kapsanan |
|---|---|
| Trendyol | ty.gl kısa link davranışı, üç katmanlı fiyat yapısı, beden ve stok okuma, yanıltıcı breadcrumb |
| Hepsiburada | ürün kodu, yorum sayısı, satıcı alanları |
| Amazon TR | amzn.eu kısa link, boş gelen özellik listesi, makine çevirisi başlıklar, kesirli EU numaraları |
| adidas.com.tr | kategori ve outlet adresleri, çalışmayan site içi arama, `K` ile biten çocuk sürümleri |
| nike.com/tr | kategori adresleri, `₺` işareti, sessiz yönlendirme tuzağı, GS/PS/TD çocuk kısaltmaları |

Kategori kontrol listeleri:

- `references/ayakkabi-giyim.md`: beden ve kalıp, kullanım zemini, dış taban, topuk sağlamlığı, yastıklama, kumaş bileşimi
- `references/elektronik.md`: garanti tipi, bölge modeli, IMEI, yenilenmiş ürün, model kodu, enerji sınıfı
- `references/ev-mobilya.md`: ölçü ve taşıma yolu, gövde malzemesi, montaj ve kata çıkarma, iade kısıtları

## Bilinen sınırlar

Kapsamdaki beş sitenin dışında da çalışır, ama o sitelerin tuzaklarını bilmez, çekirdek akışla ilerler.

`siteler.md` içindeki seçiciler ve adresler zamanla bayatlar. Bir şey tutmazsa dosyayı güncelle, amaç zaten sahada öğrenileni biriktirmek.

Skill satın alma işlemi yapmaz. Sepete eklemez, sipariş vermez, forma bilgi girmez. Sadece karar verir.

Fiyat örnekleri dosyalarda tarihiyle birlikte duruyor. Örnek olarak yazıldılar, güncel fiyat değiller.

## Katkı

Bir sitede yeni bir tuzak bulursan `siteler.md` dosyasına ekleyip pull request aç. Yeni bir kategori kontrol listesi de aynı şekilde, `references/` altına.

Metinlerde em dash kullanılmıyor ve Türkçe karakterler ASCII'ye düşürülmüyor, bu ikisine dikkat et.

## Lisans

MIT. Ayrıntı için `LICENSE` dosyasına bak.
