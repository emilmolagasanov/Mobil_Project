# 🏪 MOURA STORE - Mağaza Yönetim Sistemi

MOURA STORE, küçük ve orta ölçekli mağazalar için geliştirilmiş, ürün ve personel yönetimini kolaylaştıran bir Flutter mobil uygulamasıdır.

## 📋 Özellikler

### 📦 Ürün Yönetimi
- **Ürün Takibi**: Ürün adı, kategori, miktar ve fiyat bilgilerini takip edin
- **Son Kullanma Tarihi Uyarıları**: Sona ermek üzere olan ürünler otomatik olarak uyarı verir
- **Kar Hesaplama**: Alan fiyatı ve satış fiyatı arasındaki farktan otomatik kar hesaplaması
- **Ürün Geçmişi**: Ürün giriş tarihleri ve detaylı ürün bilgileri

### 👨‍💼 Personel Yönetimi
- **Çalışan Takibi**: İsim, pozisyon, maaş ve işe alınma tarihini kaydedin
- **Maaş Takibi**: Ödeme tarihleri ve gelecek maaş ödemeleri otomatik takibi
- **Sigorta Yönetimi**: Çalışan sigorta türlerini takip edin
- **Çalışma Saatleri**: Personel çalışma saatlerini yönetin

### 🔐 Güvenlik
- **Giriş Ekranı**: Uygulamaya güvenli erişim için kullanıcı doğrulaması

## 🚀 Başlangıç

### Gereksinimler
- Flutter SDK 3.10.8+
- Dart 3.10.8+
- Android SDK (Android için)
- Xcode (iOS için, macOS kullanıyorsanız)

### Kurulum

1. **Depoyu klonlayın veya projeyi açın:**
```bash
cd mobil_project
```

2. **Bağımlılıkları yükleyin:**
```bash
flutter pub get
```

3. **Uygulamayı çalıştırın:**
```bash
flutter run
```

## 📱 Kullanılan Teknolojiler

- **Flutter**: Cross-platform mobil uygulama geliştirme
- **Material Design 3**: Modern ve tutarlı kullanıcı arayüzü
- **intl Package**: Uluslararasılaştırma ve tarih formatlaması
- **Dart**: Programlama dili

## 📁 Proje Yapısı

```
mobil_project/
├── lib/
│   ├── main.dart              # Ana uygulama dosyası
│   └── ...                    # Diğer ekranlar ve bileşenler
├── android/                   # Android proje dosyaları
├── ios/                       # iOS proje dosyaları
├── macos/                     # macOS proje dosyaları
├── linux/                     # Linux proje dosyaları
├── windows/                   # Windows proje dosyaları
├── web/                       # Web proje dosyaları
├── pubspec.yaml              # Proje bağımlılıkları
└── README.md                 # Bu dosya
```

## 💾 Veri Modelleri

### Product (Ürün)
- ID, Ad, Kategori
- Miktar
- Son Kullanma Tarihi, Varış Tarihi
- Alan Fiyatı, Satış Fiyatı
- Kar Hesaplama ve Vadesi Geçme Durumu

### Employee (Personel)
- ID, Ad, Pozisyon
- Maaş, Maaş Tarihi
- İşe Alınma Tarihi
- Sigorta Türü, Çalışma Saatleri
- Avatar Rengi

## 🎨 Tasarım

- **Renk Şeması**: Deep Orange (Koyu Turuncu) ana renk
- **Yazı Tipi**: Roboto
- **Material Design 3** kullanılarak modern ve duyarlı arayüz

## 📝 Lisans

Bu proje açık kaynaklı bir projedir.

## 👨‍💻 Geliştirici Notları

- Düzenli tarih ve zaman hesaplamaları için `intl` paketi kullanılmaktadır
- Ürün son kullanma tarihi kontrolü: 7 günden az kaldığında kritik uyarı
- Maaş ödemesi kontrolü: 3 günden az kaldığında ödeme gerekli
- Uygulama çoklu platform desteği sunmaktadır (Android, iOS, Web, Windows, macOS, Linux)

---

**MOURA STORE** - Mağazanız için eksiksiz çözüm!
