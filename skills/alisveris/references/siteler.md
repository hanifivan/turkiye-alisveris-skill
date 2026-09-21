# Site bazlı pratik bilgiler

Bu dosya sahada öğrenilenleri tutar. Bir sitede yeni bir tuzak ya da işe yarayan bir yöntem bulursan buraya ekle, böylece bir sonraki sefer aynı duvara çarpılmaz.

## Genel kural

Metin çıkarma araçları (Tavily extract, basit fetch) bu sitelerin çoğunda **çerez onay metnini** döndürür, ürün bilgisini değil. Vakit kaybetme, doğrudan tarayıcıyla aç. Tarayıcıda da `body.innerText` üzerinden düzenli ifadeyle çekmek, DOM seçicilerine güvenmekten daha dayanıklıdır, çünkü sınıf isimleri sık değişir.

## Trendyol

**Kısa link:** `ty.gl/...` biçimindeki link `trendyol.com/<marka>/<slug>-p-<urunId>` adresine gider. Yönlendirme sonrası URL'deki `merchantId` hangi satıcının ilanı olduğunu söyler, rapora yazmaya değer.

**Fiyat:** Sayfada üç fiyat birden olabilir: Trendyol Plus üyesine özel sepet fiyatı, normal sepet fiyatı ve liste fiyatı. Üçünü de gördüysen üçünü de yaz, hangisinin kime uygulandığını belirt. `body.innerText` içinde `Beden` kelimesinin etrafındaki 400 karakterlik pencere genelde fiyat bloğunun tamamını içerir.

**Beden ve stok:** Bedenler radio düğmesi olarak duruyor, sayfa kaynağında `Beden:` ifadesinden sonra listeleniyor. Tek beden kalmış ilanlar sık. "Tükeniyor!" rozeti ayrı bir alanda. Bunu mutlaka kontrol et, Trendyol'da bir modelin ilanı dururken bedenlerin çoğu tükenmiş olabiliyor.

**Puan:** `4.8` ve `24 Değerlendirme` biçiminde ayrı ayrı geçiyor. İkisini birlikte al, puanı tek başına alma.

**Satıcı:** "Bu ürün X tarafından gönderilecektir" cümlesi sayfada geçiyor.

**Kategori:** Breadcrumb bazen yanıltıcı. Unisex bir ürün "Kadın Basketbol Ayakkabısı" altında listelenebiliyor. Ürün adına ve özelliklere bak, breadcrumb'a değil.

**Görseller:** Galeri görselleri tembel yükleniyor. `alt` niteliğinde ürün adı geçen `img` etiketlerini filtrele. `mnresize/420/620/` yerine `mnresize/620/920/` yazarak daha büyük sürümü alabilirsin, taban desenine bakacaksan işe yarar.

## Amazon TR

**Kısa link:** `amzn.eu/d/...` linki `amazon.com.tr/dp/<ASIN>` adresine gider. URL'de `th=1&psc=1` varsa belirli bir varyant seçilidir.

**Açıklama:** `#feature-bullets` çoğu moda ürününde boş geliyor. Onun yerine `body.innerText` içinde "Ürün Açıklaması" ve "Ürün Bilgileri" başlıklarından sonrasını oku. Teknik özellikler `#productDetails_techSpec_section_1` tablosunda.

**Puan:** `4,5` ve parantez içinde yorum sayısı (`(1.411)`) biçiminde. Virgüllü ondalık kullanıyor, ayrıştırırken dikkat.

**Bedenler:** `#variation_size_name` altındaki düğmelerde. Adidas ve Nike'ta `41 1/3 EU` gibi kesirli numaralar çıkıyor, bunlar gerçek numaralar, yazım hatası değil.

**Çeviri:** Ürün başlıkları makine çevirisi olabiliyor ve saçmalayabiliyor ("Orta Taban (Futbol Dışı)" gibi). Başlığa değil, özellik tablosuna ve açıklamaya güven.

**Satıcı ve gönderici:** Amazon'un kendisi mi yoksa üçüncü taraf satıcı mı, iade ve garanti açısından fark eder, kontrol et.

## adidas.com.tr

URL yapısı `adidas.com.tr/tr/<slug>/<URUN_KODU>.html` biçiminde, ürün kodu `JS2182` gibi. Site içi arama adresi (`/arama?q=`) 301 verip 404'e düşüyor, oradan arama yapmaya çalışma. Ürünü bulmak için genel web araması kullan, sonra çıkan ürün sayfasını tarayıcıda aç.

Kategori adresleri çalışıyor ve ürün kartları `[data-testid="plp-product-card"]` seçicisiyle geliyor:

- Basketbol: `/tr/ayakkabi-basketbol`
- Outlet ana sayfa: `/tr/outlet`
- Ayakkabı outlet: `/tr/ayakkabi-outlet`
- Çocuk ayakkabı outlet: `/tr/cocuk-ayakkabi-outlet`
- Fiyat filtresi adrese eklenebiliyor: `?price_max=2999&price_min=1`

Çocuk sürümlerinin model adı `K` ile biter (`Ownthegame 3.0 K`). Yetişkin sürümünden ucuzdur ve beden aralığı küçüktür.

**Önemli:** Markanın kendi sitesi pazaryerinden ucuz olmak zorunda değil, çoğu zaman tersi. 21 Eylül 2026'da adidas kendi sitesinde Own the Game 3'ü 4.449 TL'ye satarken aynı model Amazon TR'de 2.037 TL'ydi. Outlet indirimleri de %5 ile %35 arasında kalıyor ve outlet'te basketbol ayakkabısı çoğu zaman hiç bulunmuyor, "Court" isimli çıkanlar (VL Court, Grand Court) günlük sneaker, basketbol değil. Önce pazaryerine bak, outlet'i doğrulama amaçlı kullan.

## Nike

Türkiye sitesi `nike.com/tr`. Ürün kartları `[data-testid="product-card"]` seçicisinde, fiyatlar `TL` değil `₺` işaretiyle yazılıyor, düzenli ifade yazarken buna dikkat.

- Erkek basketbol: `/tr/w/erkek-basketbol-ayakkabilar-3glsmznik1zy7ok`
- İndirimli ürünler: `/tr/w/seri-sonu-3yaep` (`/w/indirim-3yaep` buraya yönleniyor)

Kategori adresleri uzun kod ekleriyle çalışıyor, uydurma slug yazarsan sessizce genel kategoriye yönlendiriyor ve yanlış sayfayı incelediğini fark etmeyebilirsin, açtıktan sonra gerçek URL'yi kontrol et.

Nike'ın fiyat tabanı yüksek. 21 Eylül 2026'da tam fiyatlı en ucuz basketbol ayakkabısı 4.499 TL, indirim bölümündeki en ucuz basketbol modeli %29 indirimle 4.299 TL'ydi. Giriş seviyesi bütçelerde Nike genelde elenir.

Çocuk ürünleri `GS` (grade school), `PS` (preschool) ve `TD` (toddler) kısaltmalarıyla ayrılır, `GS` kabaca 35 ile 40 numara arasıdır ve 11 ile 14 yaş grubuna denk gelir.

## Hepsiburada

Ürün kodu `pm-HBC...` biçiminde URL'de geçiyor. Yorum sayısı "Tüm Değerlendirmeler (21)" biçiminde. Satıcı ve "Yarın Kapında" gibi teslimat rozetleri ayrı alanlarda. Trendyol'la aynı mantık geçerli, aynı ürünün farklı satıcılarda farklı fiyatı var.

## Fiyat karşılaştırma siteleri

`epey.com`, `cimri.com` gibi siteler bir modelin hangi mağazalarda olduğunu görmek için hızlıdır, ama gösterdikleri fiyat gecikmeli olabilir. Aday listesi çıkarmak için kullan, fiyatı oradan alma, mağazanın kendi sayfasından doğrula.
