---
name: alisveris
description: Bir satın alma kararını yapılandırılmış biçimde yürütür. Kullanıcının verdiği ürün linklerini (Trendyol, Hepsiburada, Amazon TR, adidas ve Nike outlet, N11, Boyner, FLO ve benzeri) tarayıcıyla tek tek açar, fiyatı, kargoyu, stok ve beden durumunu, satıcıyı, puanı ve yorum sayısını canlı sayfadan doğrular, eline geçen toplam maliyeti hesaplar, kategoriye özgü kriterleri uygular ve karşılaştırma tablosuyla gerekçeli bir öneri verir. Kullanıcı bir ürün linki paylaşıp "incele", "değerlendir", "bak", "bu mu alsam", "hangisi daha iyi", "karşılaştır", "uygun mu", "fiyatı iyi mi" dediğinde ya da "şu bütçeye şunu arıyorum", "ne alsam", "önerir misin" gibi bir satın alma niyeti belirttiğinde, açıkça "skill" demese bile devreye al. Tek bir link paylaşılmış olsa da kullan. Em dash yasağı ve Türkçe karakter kuralı bu skill'in ayrılmaz parçasıdır.
---

# Alışveriş kararı

Bu skill bir ürünü övmek ya da yermek için değil, **karar vermek** için var. Sonuç her zaman şu üçünü içerir: hangi ürün, neden o, ve neyi bilmeden karar veremeyiz.

## Neden yapılandırılmış bir akış gerekiyor

Alışveriş kararlarında hatalar hep aynı üç yerden geliyor:

1. **Etiket fiyatına bakmak.** Sepette uygulanan indirim, kargo, taksit farkı ve iade masrafı sıralamayı tersine çevirebiliyor. Karar, eline geçene kadarki toplam maliyete göre verilir.
2. **Sayfayı açmadan konuşmak.** Arama sonucu özetlerindeki fiyat bayat olur, hafızadaki fiyat yanlıştır, kısaltılmış link başka bir varyanta gider. Her ilan kendi canlı sayfasında doğrulanır.
3. **Yanlış segmenti önermek.** Ürün doğru, beden yanlış. Yetişkin kalıbı çocuğa, 110V cihaz Türkiye'ye, ithalatçı garantisi olmayan telefon uzun vadeye uymaz. Bu hata en sık yapılan ve en pahalı olandır.

Aşağıdaki akış bu üçünü kapatmak için kurulmuştur.

## Gerekli araçlar

**Tarayıcı otomasyonu zorunludur.** Playwright MCP, Claude in Chrome ya da eşdeğeri bir araç. Bu skill'in tamamı canlı sayfa okumaya dayanıyor, tarayıcı olmadan yapabileceği hiçbir şey yok.

Oturumda tarayıcı aracı yoksa **işe başlama.** Kullanıcıya tek cümleyle durumu söyle ve ne kurması gerektiğini belirt. Arama sonucu özetlerinden, hafızandan ya da basit bir sayfa çekme aracından fiyat üretip rapor yazma. Bu, skill'in engellemek için var olduğu hatanın ta kendisidir ve kullanıcı yanlış bilgiyle alışveriş yapar.

Web araması (WebSearch, Tavily ya da eşdeğeri) **opsiyoneldir**. Link verilmemiş ve aday ürün bulman gerektiğinde işe yarar. Yoksa da çalışırsın, o zaman pazaryerinin kendi arama sayfasını tarayıcıyla açarsın. Web araması yalnızca **aday listesi** çıkarmak için kullanılır, fiyat ve stok her zaman ürünün kendi sayfasından doğrulanır.

Ayrıca: Claude in Chrome kullanılıyorsa her alan adı için ayrı izin isteniyor. Kullanıcı bir siteye izin vermediyse o siteyi atla ve raporda "bu site kontrol edilemedi" diye belirt, tahminle doldurma.

## Akış

### 1. Kriterleri topla (tek seferde, yapılandırılmış biçimde)

Arama kriterleri baştan netleşmezse iş iki kat uzuyor: yanlış segmentte ürün taranıyor, sonra baştan başlanıyor. Bunu önlemek için eksik olanları **tek bir soru bloğunda** sor, teker teker sorup akışı bölme.

Sorulacak çekirdek küme şu. Kullanıcının zaten söylediğini tekrar sorma, sadece boş kalanları sor:

| Kriter | Neden kararı değiştirir |
|---|---|
| **Beden veya ölçü** | Uymayan beden ilanı baştan eler. Ayakkabıda numara, giyimde beden, mobilyada santim. |
| **Kim kullanacak** | Kadın, erkek, unisex, çocuk. Kalıp ve beden aralığı buna göre değişir, aynı modelin çocuk sürümü genelde daha ucuzdur. |
| **Fiyat aralığı** | Tavan yoksa hangi segmentte arama yapılacağı belirsiz kalır. Alt sınır da işe yarar, çok ucuz olanı elemek için. |
| **Marka tercihi** | Belirli bir marka isteniyor mu, yoksa açık mı, istenmeyen marka var mı. |
| **Kullanım yeri ve sıklığı** | Salon mu dış mekan mı, günlük mü ara sıra mı, amatör mü düzenli mi. Teknik kriterleri bu belirler. |
| **Olmazsa olmaz** | Renk, kargo süresi, iade kolaylığı, garanti, ikinci el kabul edilir mi. |

Kullanıcıya tek tek yazdırmak yerine, aracın yapılandırılmış soru sorma imkanı varsa onu kullan ve seçenekleri hazır sun. Cevap vermek böyle çok daha hızlı olur.

Bir kriter kararı değiştirmiyorsa sorma. Üç ilanın üçü de aynı modelse "nerede kullanacaksın" sorusu boşa gider. Ama bir ilan salon tabanlı diğeri sokak tabanlıysa o soru kararın kendisidir.

**Bütçe değişirse aday havuzu da değişir.** Kullanıcı sonradan tavanı yükseltirse eski adaylara yenilerini eklemekle yetinme, aramayı yeni aralıkta baştan yap. Üst segmentte bambaşka modeller açılır ve eski liste artık doğru listeyi temsil etmez.

Kriterler eksikken de çalışmaya devam et. Eksik bilgiyi varsayım olarak yaz, raporun sonunda "şunu bilseydim şöyle değişirdi" diye açıkça belirt. Hiçbir şey teslim etmeden beklemek en kötü seçenek.

### 2. Her ilanı kendi sayfasında aç

Tarayıcıyı kullan. Bu bir tercih değil, zorunluluk: Trendyol ve benzeri siteler metin çıkarma araçlarına çerez duvarı döndürüyor, arama sonucu özetleri eski fiyat gösteriyor.

Her ilan için şunları çek ve hiçbirini tahmin etme, sayfada göremediğini "yok" diye işaretle:

| Alan | Neden |
|---|---|
| Sepet fiyatı ve liste fiyatı | İkisi farklıysa ikisini de yaz, sıralamayı sepet fiyatına göre yap |
| Kargo ücreti ve süresi | Toplam maliyetin parçası |
| Stok durumu | "Tükeniyor", "son 1 ürün" uyarıları kararı aciliyetlendirir ya da adayı eler |
| **Mevcut bedenler veya varyantlar** | Kullanıcıya uyan beden yoksa o ilan aday bile değildir, en başta ele |
| Satıcı | Pazaryerinde satıcı, ürünün kendisi kadar önemli |
| Puan **ve yorum sayısı** | Puan tek başına anlamsız |
| Garanti ve iade koşulları | Özellikle elektronikte |

Site bazlı pratik bilgiler, kısa link davranışları ve işe yarayan seçiciler için `references/siteler.md` dosyasını oku.

### 3. Yorum güvenilirliğini işaretle

Yorum sayısı düşükken yüksek puan bilgi değil gürültüdür. 3 kişinin verdiği 5.0, 1400 kişinin verdiği 4.5'ten zayıf bir sinyaldir ve raporda bu açıkça söylenir.

Kaba bir eşik olarak 20'nin altındaki yorum sayısını "zayıf sinyal", 5'in altını "yok sayılır" kabul et. Aynı ürünün başka ilanlarında daha kalabalık bir yorum havuzu varsa oradan oku, ama fiyatı ve stoğu kullanıcının verdiği ilandan al, ikisini karıştırma.

### 4. Toplam maliyeti hesapla

Eline geçene kadarki maliyet: sepet fiyatı + kargo + (varsa) gümrük ve taksit farkı. Aynı ürün birden fazla yerdeyse bu rakama göre sırala, etikete göre değil. Rakamları yazarken her fiyatın yanına **tarih** koy, çünkü bu siteler günlük fiyat değiştiriyor ve rapor bir hafta sonra okunduğunda yanıltmasın.

### 5. Kategori kriterlerini uygula

Ürün tipine göre ilgili dosyayı oku, hepsini birden okuma:

- Ayakkabı, giyim, spor malzemesi: `references/ayakkabi-giyim.md`
- Telefon, bilgisayar, beyaz eşya, küçük ev aleti: `references/elektronik.md`
- Mobilya, ev tekstili, dekorasyon: `references/ev-mobilya.md`

Kategori listede yoksa çekirdek akışla devam et ve raporda "bu kategoriye özgü kontrol listesi henüz yok" de. Uydurma kriter üretme.

### 6. Ele ve sırala

Önce eleme, sonra sıralama. Eleme gerekçeleri kesindir ve tartışılmaz:

- Kullanıcıya uyan beden veya varyant yok
- Stokta yok
- Olmazsa olmaz bir koşulu karşılamıyor (garanti yok, kargo süresi tutmuyor)

Kalanları toplam maliyet ve kategori kriterleriyle sırala. Marka itibarı tek başına sıralama gerekçesi değildir, pahalı olması da kaliteli olduğu anlamına gelmez. Neyin karşılığında ne kadar fazla ödendiğini somut yaz.

### 7. Raporu yaz

Şu yapıyı kullan:

```
[Tek cümlelik sonuç: hangisi ve neden]

[Her ürün için kısa bir paragraf: fiyat, güçlü yan, zayıf yan, kime uyar]

[Eleme varsa: hangisi neden elendi]

[Eksik bilgi: neyi bilmiyoruz, bilseydik ne değişirdi]
```

Tablo, yalnızca üç ve üzeri ürün karşılaştırılıyorsa ve karşılaştırılan alanlar gerçekten paralelse kullanılır. İki ürün için düz paragraf daha okunur.

Kullanıcı satın alma işlemi istemedikçe sepete ekleme, sipariş verme, hiçbir forma bilgi girme. Bu skill karar verir, alışveriş yapmaz.

## Sık düşülen tuzaklar

**Segment kayması.** Ürün adı doğru, hedef kitlesi yanlış. Yetişkin bedenli bir modeli çocuğa önermek, TR fişi olmayan cihazı Türkiye'ye önermek gibi. Beden aralığına ve ürünün hangi segment için üretildiğine bak, çoğu markanın aynı modelin çocuk (K, Junior, Kids) sürümü vardır ve genelde daha ucuzdur.

**Kısa link tuzağı.** Paylaşılan kısa link (ty.gl, amzn.eu) çoğu zaman belirli bir renk ve beden varyantına gider. Açtıktan sonra gerçek URL'ye bak, hangi varyantta olduğunu rapora yaz.

**Aynı modelin farklı ilanları.** Pazaryerlerinde aynı ürün onlarca ilanda olur, fiyatları ve stokları farklıdır. Kullanıcının verdiği ilanı esas al, ama belirgin şekilde daha ucuz ve güvenilir bir alternatif varsa tek cümleyle söyle.

**Sahte aciliyet.** "Son 2 ürün", "son 10 günün en düşük fiyatı" gibi ibareler çoğu zaman pazarlama unsurudur. Bilgi olarak aktar, karar gerekçesi yapma.

**Outlet ve indirim.** Markanın kendi outlet sitesi (adidas, Nike, Puma) pazaryerinden ucuz olabilir ama beden aralığı dar ve iade koşulları farklıdır. Fiyat farkı anlamlıysa kontrol et, değilse uğraşma.

## Dil kuralları

Rapor Türkçe yazılır, Türkçe karakterler tam kullanılır (ğüşıİöç), ASCII'ye düşürülmez. Em dash kullanılmaz, tek bile olsa. Madde işareti yalnızca gerçekten paralel öğelerde kullanılır. Ölçülü ve net yaz, ürün açıklamalarındaki pazarlama dilini rapora taşıma.
