import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('tr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ezan Vakti Kuşanmak'**
  String get appTitle;

  /// No description provided for @appSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Namazla huzura, ibadetle huşuya'**
  String get appSubtitle;

  /// No description provided for @greetingMorning.
  ///
  /// In tr, this message translates to:
  /// **'Hayırlı sabahlar'**
  String get greetingMorning;

  /// No description provided for @greetingDay.
  ///
  /// In tr, this message translates to:
  /// **'Hayırlı gündüzler'**
  String get greetingDay;

  /// No description provided for @greetingEvening.
  ///
  /// In tr, this message translates to:
  /// **'Hayırlı akşamlar'**
  String get greetingEvening;

  /// No description provided for @userDefault.
  ///
  /// In tr, this message translates to:
  /// **'Değerli Kullanıcı'**
  String get userDefault;

  /// No description provided for @blessing.
  ///
  /// In tr, this message translates to:
  /// **'Rabbimizin rahmeti ve bereketi üzerinize olsun.'**
  String get blessing;

  /// No description provided for @nextPrayer.
  ///
  /// In tr, this message translates to:
  /// **'Sonraki Namaz'**
  String get nextPrayer;

  /// No description provided for @remainingTime.
  ///
  /// In tr, this message translates to:
  /// **'Kalan Süre'**
  String get remainingTime;

  /// No description provided for @prayerTimesToday.
  ///
  /// In tr, this message translates to:
  /// **'Bugünün Namaz Vakitleri'**
  String get prayerTimesToday;

  /// No description provided for @sunrise.
  ///
  /// In tr, this message translates to:
  /// **'Güneş Doğuşu'**
  String get sunrise;

  /// No description provided for @imsak.
  ///
  /// In tr, this message translates to:
  /// **'İmsak'**
  String get imsak;

  /// No description provided for @sun.
  ///
  /// In tr, this message translates to:
  /// **'Güneş'**
  String get sun;

  /// No description provided for @dhuhr.
  ///
  /// In tr, this message translates to:
  /// **'Öğle'**
  String get dhuhr;

  /// No description provided for @asr.
  ///
  /// In tr, this message translates to:
  /// **'İkindi'**
  String get asr;

  /// No description provided for @maghrib.
  ///
  /// In tr, this message translates to:
  /// **'Akşam'**
  String get maghrib;

  /// No description provided for @isha.
  ///
  /// In tr, this message translates to:
  /// **'Yatsı'**
  String get isha;

  /// No description provided for @fajr.
  ///
  /// In tr, this message translates to:
  /// **'Sabah'**
  String get fajr;

  /// No description provided for @tabHome.
  ///
  /// In tr, this message translates to:
  /// **'Ana Sayfa'**
  String get tabHome;

  /// No description provided for @tabTimes.
  ///
  /// In tr, this message translates to:
  /// **'Vakitler'**
  String get tabTimes;

  /// No description provided for @tabMyPrayer.
  ///
  /// In tr, this message translates to:
  /// **'Namazım'**
  String get tabMyPrayer;

  /// No description provided for @tabLibrary.
  ///
  /// In tr, this message translates to:
  /// **'Kütüphane'**
  String get tabLibrary;

  /// No description provided for @tabMore.
  ///
  /// In tr, this message translates to:
  /// **'Daha Fazla'**
  String get tabMore;

  /// No description provided for @quickAccess.
  ///
  /// In tr, this message translates to:
  /// **'Hızlı Erişim'**
  String get quickAccess;

  /// No description provided for @seeAll.
  ///
  /// In tr, this message translates to:
  /// **'Tümünü Gör'**
  String get seeAll;

  /// No description provided for @qibla.
  ///
  /// In tr, this message translates to:
  /// **'Kıble'**
  String get qibla;

  /// No description provided for @qiblaFindDirection.
  ///
  /// In tr, this message translates to:
  /// **'Yönünü bul'**
  String get qiblaFindDirection;

  /// No description provided for @learnPrayer.
  ///
  /// In tr, this message translates to:
  /// **'Namaz Öğren'**
  String get learnPrayer;

  /// No description provided for @learnStepByStep.
  ///
  /// In tr, this message translates to:
  /// **'Adım adım rehber'**
  String get learnStepByStep;

  /// No description provided for @prayerTracker.
  ///
  /// In tr, this message translates to:
  /// **'Namaz Takibi'**
  String get prayerTracker;

  /// No description provided for @library.
  ///
  /// In tr, this message translates to:
  /// **'Kütüphane'**
  String get library;

  /// No description provided for @libraryDesc.
  ///
  /// In tr, this message translates to:
  /// **'Kur\'an, dua, hadis'**
  String get libraryDesc;

  /// No description provided for @tesbih.
  ///
  /// In tr, this message translates to:
  /// **'Tesbih'**
  String get tesbih;

  /// No description provided for @tesbihCounter.
  ///
  /// In tr, this message translates to:
  /// **'Zikir sayacı'**
  String get tesbihCounter;

  /// No description provided for @gratitudeJournal.
  ///
  /// In tr, this message translates to:
  /// **'Şükür Defteri'**
  String get gratitudeJournal;

  /// No description provided for @gratitudeDesc.
  ///
  /// In tr, this message translates to:
  /// **'Günlük notlar'**
  String get gratitudeDesc;

  /// No description provided for @verseOfDay.
  ///
  /// In tr, this message translates to:
  /// **'Günün Ayeti'**
  String get verseOfDay;

  /// No description provided for @hadithOfDay.
  ///
  /// In tr, this message translates to:
  /// **'Günün Hadisi'**
  String get hadithOfDay;

  /// No description provided for @reflectionOfDay.
  ///
  /// In tr, this message translates to:
  /// **'Günün Tefekkürü'**
  String get reflectionOfDay;

  /// No description provided for @duaOfDay.
  ///
  /// In tr, this message translates to:
  /// **'Günün Duası'**
  String get duaOfDay;

  /// No description provided for @vecize.
  ///
  /// In tr, this message translates to:
  /// **'Vecize'**
  String get vecize;

  /// No description provided for @risale.
  ///
  /// In tr, this message translates to:
  /// **'Risale-i Nur'**
  String get risale;

  /// No description provided for @dailyGoals.
  ///
  /// In tr, this message translates to:
  /// **'Günlük Hedefler'**
  String get dailyGoals;

  /// No description provided for @progress.
  ///
  /// In tr, this message translates to:
  /// **'İlerleme'**
  String get progress;

  /// No description provided for @completed.
  ///
  /// In tr, this message translates to:
  /// **'Tamamlandı'**
  String get completed;

  /// No description provided for @pending.
  ///
  /// In tr, this message translates to:
  /// **'Bekliyor'**
  String get pending;

  /// No description provided for @notifications.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimler'**
  String get notifications;

  /// No description provided for @notificationSettings.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim Ayarları'**
  String get notificationSettings;

  /// No description provided for @city.
  ///
  /// In tr, this message translates to:
  /// **'Şehir'**
  String get city;

  /// No description provided for @selectCity.
  ///
  /// In tr, this message translates to:
  /// **'Şehir Seç'**
  String get selectCity;

  /// No description provided for @searchCity.
  ///
  /// In tr, this message translates to:
  /// **'Şehir ara...'**
  String get searchCity;

  /// No description provided for @settings.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In tr, this message translates to:
  /// **'Dil'**
  String get language;

  /// No description provided for @languageTr.
  ///
  /// In tr, this message translates to:
  /// **'Türkçe'**
  String get languageTr;

  /// No description provided for @languageEn.
  ///
  /// In tr, this message translates to:
  /// **'English'**
  String get languageEn;

  /// No description provided for @languageAr.
  ///
  /// In tr, this message translates to:
  /// **'العربية'**
  String get languageAr;

  /// No description provided for @fontStyle.
  ///
  /// In tr, this message translates to:
  /// **'Yazı Stili'**
  String get fontStyle;

  /// No description provided for @fontRika.
  ///
  /// In tr, this message translates to:
  /// **'Rika (El yazısı)'**
  String get fontRika;

  /// No description provided for @fontMatbu.
  ///
  /// In tr, this message translates to:
  /// **'Matbu (Basılı)'**
  String get fontMatbu;

  /// No description provided for @adminLogin.
  ///
  /// In tr, this message translates to:
  /// **'Admin Girişi'**
  String get adminLogin;

  /// No description provided for @adminLoginDesc.
  ///
  /// In tr, this message translates to:
  /// **'İçerik ekle, düzenle, sil'**
  String get adminLoginDesc;

  /// No description provided for @adminPanel.
  ///
  /// In tr, this message translates to:
  /// **'Admin Panel'**
  String get adminPanel;

  /// No description provided for @adminNewContent.
  ///
  /// In tr, this message translates to:
  /// **'Yeni İçerik'**
  String get adminNewContent;

  /// No description provided for @adminEditContent.
  ///
  /// In tr, this message translates to:
  /// **'İçeriği Düzenle'**
  String get adminEditContent;

  /// No description provided for @adminSave.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get adminSave;

  /// No description provided for @adminDelete.
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get adminDelete;

  /// No description provided for @adminSearch.
  ///
  /// In tr, this message translates to:
  /// **'Ara...'**
  String get adminSearch;

  /// No description provided for @categoryVerse.
  ///
  /// In tr, this message translates to:
  /// **'Ayet'**
  String get categoryVerse;

  /// No description provided for @categoryHadith.
  ///
  /// In tr, this message translates to:
  /// **'Hadis'**
  String get categoryHadith;

  /// No description provided for @categoryDua.
  ///
  /// In tr, this message translates to:
  /// **'Dua'**
  String get categoryDua;

  /// No description provided for @categoryVecize.
  ///
  /// In tr, this message translates to:
  /// **'Vecize'**
  String get categoryVecize;

  /// No description provided for @categoryRisale.
  ///
  /// In tr, this message translates to:
  /// **'Risale'**
  String get categoryRisale;

  /// No description provided for @categoryKissa.
  ///
  /// In tr, this message translates to:
  /// **'Kıssa'**
  String get categoryKissa;

  /// No description provided for @categoryZikir.
  ///
  /// In tr, this message translates to:
  /// **'Zikir'**
  String get categoryZikir;

  /// No description provided for @categoryAll.
  ///
  /// In tr, this message translates to:
  /// **'Tümü'**
  String get categoryAll;

  /// No description provided for @title.
  ///
  /// In tr, this message translates to:
  /// **'Başlık'**
  String get title;

  /// No description provided for @content.
  ///
  /// In tr, this message translates to:
  /// **'Metin'**
  String get content;

  /// No description provided for @source.
  ///
  /// In tr, this message translates to:
  /// **'Kaynak'**
  String get source;

  /// No description provided for @reflection.
  ///
  /// In tr, this message translates to:
  /// **'Tefekkür'**
  String get reflection;

  /// No description provided for @tags.
  ///
  /// In tr, this message translates to:
  /// **'Etiketler'**
  String get tags;

  /// No description provided for @favorite.
  ///
  /// In tr, this message translates to:
  /// **'Favorilere Ekle'**
  String get favorite;

  /// No description provided for @share.
  ///
  /// In tr, this message translates to:
  /// **'Paylaş'**
  String get share;

  /// No description provided for @tabQibla.
  ///
  /// In tr, this message translates to:
  /// **'Pusula'**
  String get tabQibla;

  /// No description provided for @tabTrack.
  ///
  /// In tr, this message translates to:
  /// **'Takip'**
  String get tabTrack;

  /// No description provided for @khushuTitle.
  ///
  /// In tr, this message translates to:
  /// **'Huşu Takibi'**
  String get khushuTitle;

  /// No description provided for @khushuDesc.
  ///
  /// In tr, this message translates to:
  /// **'Kalp huzurunu fark et'**
  String get khushuDesc;

  /// No description provided for @moodTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ruh Halin'**
  String get moodTitle;

  /// No description provided for @moodDesc.
  ///
  /// In tr, this message translates to:
  /// **'Kalbin ne söylüyorsa'**
  String get moodDesc;

  /// No description provided for @journeyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Manevi Yolculuk'**
  String get journeyTitle;

  /// No description provided for @journeyDesc.
  ///
  /// In tr, this message translates to:
  /// **'Isı haritası · Seri · Seviye'**
  String get journeyDesc;

  /// No description provided for @gratitudeJournalDesc.
  ///
  /// In tr, this message translates to:
  /// **'Nimeti fark et, kalbi besle'**
  String get gratitudeJournalDesc;

  /// No description provided for @languageStyleTitle.
  ///
  /// In tr, this message translates to:
  /// **'Dil ve Yazı Stili'**
  String get languageStyleTitle;

  /// No description provided for @notificationDesc.
  ///
  /// In tr, this message translates to:
  /// **'Vakit hatırlatmaları'**
  String get notificationDesc;

  /// No description provided for @assistantTitle.
  ///
  /// In tr, this message translates to:
  /// **'Akıllı Asistan'**
  String get assistantTitle;

  /// No description provided for @assistantDesc.
  ///
  /// In tr, this message translates to:
  /// **'Kaynaklı soru-cevap'**
  String get assistantDesc;

  /// No description provided for @adminPanelDesc.
  ///
  /// In tr, this message translates to:
  /// **'İçerik havuzlarını yönet'**
  String get adminPanelDesc;

  /// No description provided for @aboutTitle.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama Hakkında'**
  String get aboutTitle;

  /// No description provided for @aboutVersion.
  ///
  /// In tr, this message translates to:
  /// **'Sürüm {version}'**
  String aboutVersion(String version);

  /// No description provided for @aboutBody.
  ///
  /// In tr, this message translates to:
  /// **'Namaz merkezli ibadet rehberi. Tüm veriler cihazınızda saklanır.'**
  String get aboutBody;

  /// No description provided for @uiYoneticiGirisi.
  ///
  /// In tr, this message translates to:
  /// **'Yönetici Girişi'**
  String get uiYoneticiGirisi;

  /// No description provided for @uiIcerikYonetimi.
  ///
  /// In tr, this message translates to:
  /// **'İçerik Yönetimi'**
  String get uiIcerikYonetimi;

  /// No description provided for @uiYoneticiPinKodunuGirin.
  ///
  /// In tr, this message translates to:
  /// **'Yönetici PIN kodunu girin. Bu PIN cihaz içi basit bir engeldir; güvenli kimlik doğrulama yerine geçmez.'**
  String get uiYoneticiPinKodunuGirin;

  /// No description provided for @uiYoneticiPin.
  ///
  /// In tr, this message translates to:
  /// **'Yönetici PIN'**
  String get uiYoneticiPin;

  /// No description provided for @uiYonetimPaneliniAc.
  ///
  /// In tr, this message translates to:
  /// **'Yönetim panelini aç'**
  String get uiYonetimPaneliniAc;

  /// No description provided for @uiBaslikVeEnAz.
  ///
  /// In tr, this message translates to:
  /// **'Başlık ve en az bir içerik alanı doldurulmalıdır.'**
  String get uiBaslikVeEnAz;

  /// No description provided for @uiDogrulamadanYayinla.
  ///
  /// In tr, this message translates to:
  /// **'Doğrulamadan yayınla?'**
  String get uiDogrulamadanYayinla;

  /// No description provided for @uiBuIcerikDogrulandiOlarak.
  ///
  /// In tr, this message translates to:
  /// **'Bu içerik \"doğrulandı\" olarak işaretlenmemiş. Yine de yayınlansın mı?'**
  String get uiBuIcerikDogrulandiOlarak;

  /// No description provided for @uiIptal.
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get uiIptal;

  /// No description provided for @uiYayinla.
  ///
  /// In tr, this message translates to:
  /// **'Yayınla'**
  String get uiYayinla;

  /// No description provided for @uiSilinsinMi.
  ///
  /// In tr, this message translates to:
  /// **'Silinsin mi?'**
  String get uiSilinsinMi;

  /// No description provided for @uiIcerikTuru.
  ///
  /// In tr, this message translates to:
  /// **'İçerik Türü'**
  String get uiIcerikTuru;

  /// No description provided for @uiYayinDurumu.
  ///
  /// In tr, this message translates to:
  /// **'Yayın Durumu'**
  String get uiYayinDurumu;

  /// No description provided for @uiKaynakTuru.
  ///
  /// In tr, this message translates to:
  /// **'Kaynak Türü'**
  String get uiKaynakTuru;

  /// No description provided for @uiDiyanetBuhariMuslimGibi.
  ///
  /// In tr, this message translates to:
  /// **'Diyanet, Buhârî, Müslim gibi güvenilir kaynaktan kontrol edildi'**
  String get uiDiyanetBuhariMuslimGibi;

  /// No description provided for @uiKaydet.
  ///
  /// In tr, this message translates to:
  /// **'KAYDET'**
  String get uiKaydet;

  /// No description provided for @uiOneriler.
  ///
  /// In tr, this message translates to:
  /// **'Öneriler'**
  String get uiOneriler;

  /// No description provided for @uiEkle.
  ///
  /// In tr, this message translates to:
  /// **'EKLE'**
  String get uiEkle;

  /// No description provided for @uiIcerikYonetimi2.
  ///
  /// In tr, this message translates to:
  /// **'İçerik Yönetimi'**
  String get uiIcerikYonetimi2;

  /// No description provided for @uiTopluIslemler.
  ///
  /// In tr, this message translates to:
  /// **'Toplu işlemler'**
  String get uiTopluIslemler;

  /// No description provided for @uiAktifSekmedekiTumunuYayinla.
  ///
  /// In tr, this message translates to:
  /// **'Aktif sekmedeki tümünü yayınla'**
  String get uiAktifSekmedekiTumunuYayinla;

  /// No description provided for @uiFiltrelenmisleriYayinla.
  ///
  /// In tr, this message translates to:
  /// **'Filtrelenmişleri yayınla'**
  String get uiFiltrelenmisleriYayinla;

  /// No description provided for @uiFiltrelenmisleriSil.
  ///
  /// In tr, this message translates to:
  /// **'Filtrelenmişleri sil'**
  String get uiFiltrelenmisleriSil;

  /// No description provided for @uiAnaSayfadaKontrolEt.
  ///
  /// In tr, this message translates to:
  /// **'Ana sayfada kontrol et'**
  String get uiAnaSayfadaKontrolEt;

  /// No description provided for @uiYedekAlJson.
  ///
  /// In tr, this message translates to:
  /// **'Yedek al (JSON)'**
  String get uiYedekAlJson;

  /// No description provided for @uiYedektenYukleJson.
  ///
  /// In tr, this message translates to:
  /// **'Yedekten yükle (JSON)'**
  String get uiYedektenYukleJson;

  /// No description provided for @uiYeniEkle.
  ///
  /// In tr, this message translates to:
  /// **'YENİ EKLE'**
  String get uiYeniEkle;

  /// No description provided for @uiBaslikIcerikKaynakVeya.
  ///
  /// In tr, this message translates to:
  /// **'Başlık, içerik, kaynak veya kategori ara...'**
  String get uiBaslikIcerikKaynakVeya;

  /// No description provided for @uiSiralama.
  ///
  /// In tr, this message translates to:
  /// **'Sıralama'**
  String get uiSiralama;

  /// No description provided for @uiIptal2.
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get uiIptal2;

  /// No description provided for @uiYayinla2.
  ///
  /// In tr, this message translates to:
  /// **'Yayınla'**
  String get uiYayinla2;

  /// No description provided for @ui365GunlukKayitlarKorunuyor.
  ///
  /// In tr, this message translates to:
  /// **'365 günlük kayıtlar korunuyor; silme işlemi engellendi.'**
  String get ui365GunlukKayitlarKorunuyor;

  /// No description provided for @uiSilinecekIcerikYok.
  ///
  /// In tr, this message translates to:
  /// **'Silinecek içerik yok.'**
  String get uiSilinecekIcerikYok;

  /// No description provided for @uiFiltrelenmisleriSil2.
  ///
  /// In tr, this message translates to:
  /// **'Filtrelenmişleri sil?'**
  String get uiFiltrelenmisleriSil2;

  /// No description provided for @uiYedektenYukle.
  ///
  /// In tr, this message translates to:
  /// **'Yedekten yükle'**
  String get uiYedektenYukle;

  /// No description provided for @uiJsonYedeginiAsagiyaYapistirin.
  ///
  /// In tr, this message translates to:
  /// **'JSON yedeğini aşağıya yapıştırın. \"Birleştir\" varsa günceller, yoksa ekler. \"Üzerine yaz\" mevcut havuzu siler.'**
  String get uiJsonYedeginiAsagiyaYapistirin;

  /// No description provided for @uiUzerineYaz.
  ///
  /// In tr, this message translates to:
  /// **'Üzerine Yaz'**
  String get uiUzerineYaz;

  /// No description provided for @uiBirlestir.
  ///
  /// In tr, this message translates to:
  /// **'Birleştir'**
  String get uiBirlestir;

  /// No description provided for @uiFiltreleriTemizle.
  ///
  /// In tr, this message translates to:
  /// **'Filtreleri temizle'**
  String get uiFiltreleriTemizle;

  /// No description provided for @uiGunlukKayitlarSilinemezDuzenlemeye.
  ///
  /// In tr, this message translates to:
  /// **'Günlük kayıtlar silinemez; düzenlemeye devam edebilirsiniz.'**
  String get uiGunlukKayitlarSilinemezDuzenlemeye;

  /// No description provided for @uiSilindi.
  ///
  /// In tr, this message translates to:
  /// **'Silindi'**
  String get uiSilindi;

  /// No description provided for @uiKaynakliRehber.
  ///
  /// In tr, this message translates to:
  /// **'Kaynaklı Rehber'**
  String get uiKaynakliRehber;

  /// No description provided for @uiSorunuIceriklerArasindaAra.
  ///
  /// In tr, this message translates to:
  /// **'Sorunu içerikler arasında ara.'**
  String get uiSorunuIceriklerArasindaAra;

  /// No description provided for @uiOrnSabirSukurAbdest.
  ///
  /// In tr, this message translates to:
  /// **'Örn. sabır, şükür, abdest...'**
  String get uiOrnSabirSukurAbdest;

  /// No description provided for @uiOrnekSorular.
  ///
  /// In tr, this message translates to:
  /// **'Örnek Sorular'**
  String get uiOrnekSorular;

  /// No description provided for @uiFarkliKelimelerleDeneVeya.
  ///
  /// In tr, this message translates to:
  /// **'Farklı kelimelerle dene veya mevcut içerikleri gözden geçir.'**
  String get uiFarkliKelimelerleDeneVeya;

  /// No description provided for @uiZikirAdi.
  ///
  /// In tr, this message translates to:
  /// **'Zikir Adı'**
  String get uiZikirAdi;

  /// No description provided for @uiOrnSubhNallah.
  ///
  /// In tr, this message translates to:
  /// **'Örn: Sübhânallah'**
  String get uiOrnSubhNallah;

  /// No description provided for @uiHedefSayi.
  ///
  /// In tr, this message translates to:
  /// **'Hedef Sayı'**
  String get uiHedefSayi;

  /// No description provided for @uiSayaclariSifirla.
  ///
  /// In tr, this message translates to:
  /// **'Sayaçları Sıfırla'**
  String get uiSayaclariSifirla;

  /// No description provided for @uiSifirla.
  ///
  /// In tr, this message translates to:
  /// **'Sıfırla'**
  String get uiSifirla;

  /// No description provided for @uiZikriSil.
  ///
  /// In tr, this message translates to:
  /// **'Zikri Sil'**
  String get uiZikriSil;

  /// No description provided for @uiHenuzBirZikirEklenmemis.
  ///
  /// In tr, this message translates to:
  /// **'Henüz bir zikir eklenmemiş.'**
  String get uiHenuzBirZikirEklenmemis;

  /// No description provided for @uiZikirEkle.
  ///
  /// In tr, this message translates to:
  /// **'Zikir Ekle'**
  String get uiZikirEkle;

  /// No description provided for @uiZincirAdimi.
  ///
  /// In tr, this message translates to:
  /// **'Zincir Adımı'**
  String get uiZincirAdimi;

  /// No description provided for @uiToplamCekilen.
  ///
  /// In tr, this message translates to:
  /// **'Toplam Çekilen'**
  String get uiToplamCekilen;

  /// No description provided for @uiTamamlananZincirTuru.
  ///
  /// In tr, this message translates to:
  /// **'Tamamlanan Zincir Turu'**
  String get uiTamamlananZincirTuru;

  /// No description provided for @uiHedefIlerlemesi.
  ///
  /// In tr, this message translates to:
  /// **'Hedef İlerlemesi'**
  String get uiHedefIlerlemesi;

  /// No description provided for @uiDokun.
  ///
  /// In tr, this message translates to:
  /// **'DOKUN'**
  String get uiDokun;

  /// No description provided for @uiZincirAdimlari.
  ///
  /// In tr, this message translates to:
  /// **'Zincir Adımları'**
  String get uiZincirAdimlari;

  /// No description provided for @uiYeniEkle2.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Ekle'**
  String get uiYeniEkle2;

  /// No description provided for @uiDuzenle.
  ///
  /// In tr, this message translates to:
  /// **'Düzenle'**
  String get uiDuzenle;

  /// No description provided for @uiHenuzDersEklenmemis.
  ///
  /// In tr, this message translates to:
  /// **'Henüz ders eklenmemiş.'**
  String get uiHenuzDersEklenmemis;

  /// No description provided for @uiHerTamamlananAdimBir.
  ///
  /// In tr, this message translates to:
  /// **'Her tamamlanan adım bir kutlama'**
  String get uiHerTamamlananAdimBir;

  /// No description provided for @uiCocukEkle.
  ///
  /// In tr, this message translates to:
  /// **'Çocuk Ekle'**
  String get uiCocukEkle;

  /// No description provided for @uiIsim.
  ///
  /// In tr, this message translates to:
  /// **'İsim'**
  String get uiIsim;

  /// No description provided for @uiYas.
  ///
  /// In tr, this message translates to:
  /// **'Yaş'**
  String get uiYas;

  /// No description provided for @uiEkle2.
  ///
  /// In tr, this message translates to:
  /// **'Ekle'**
  String get uiEkle2;

  /// No description provided for @uiBuCocugunTumIlerleme.
  ///
  /// In tr, this message translates to:
  /// **'Bu çocuğun tüm ilerleme kayıtları silinecek.'**
  String get uiBuCocugunTumIlerleme;

  /// No description provided for @uiAileModu.
  ///
  /// In tr, this message translates to:
  /// **'Aile Modu'**
  String get uiAileModu;

  /// No description provided for @uiCocuklarim.
  ///
  /// In tr, this message translates to:
  /// **'Çocuklarım'**
  String get uiCocuklarim;

  /// No description provided for @uiAileceOgrenelim.
  ///
  /// In tr, this message translates to:
  /// **'Ailece Öğrenelim'**
  String get uiAileceOgrenelim;

  /// No description provided for @uiCocuklariniNamazlaTanistir.
  ///
  /// In tr, this message translates to:
  /// **'Çocuklarını namazla tanıştır.'**
  String get uiCocuklariniNamazlaTanistir;

  /// No description provided for @uiHenuzCocukEklenmedi.
  ///
  /// In tr, this message translates to:
  /// **'Henüz çocuk eklenmedi'**
  String get uiHenuzCocukEklenmedi;

  /// No description provided for @uiCocugunuEkleAdimAdim.
  ///
  /// In tr, this message translates to:
  /// **'Çocuğunu ekle, adım adım namaz öğrenmesini takip et. 9 basit adım.'**
  String get uiCocugunuEkleAdimAdim;

  /// No description provided for @uiSabahNamaziniKil.
  ///
  /// In tr, this message translates to:
  /// **'Sabah namazını kıl'**
  String get uiSabahNamaziniKil;

  /// No description provided for @uiOgleNamaziniKil.
  ///
  /// In tr, this message translates to:
  /// **'Öğle namazını kıl'**
  String get uiOgleNamaziniKil;

  /// No description provided for @uiIkindiNamaziniKil.
  ///
  /// In tr, this message translates to:
  /// **'İkindi namazını kıl'**
  String get uiIkindiNamaziniKil;

  /// No description provided for @uiAksamNamaziniKil.
  ///
  /// In tr, this message translates to:
  /// **'Akşam namazını kıl'**
  String get uiAksamNamaziniKil;

  /// No description provided for @uiYatsiNamaziniKil.
  ///
  /// In tr, this message translates to:
  /// **'Yatsı namazını kıl'**
  String get uiYatsiNamaziniKil;

  /// No description provided for @uiGunlukKurAnOkumasi.
  ///
  /// In tr, this message translates to:
  /// **'Günlük Kur\'an okuması yap'**
  String get uiGunlukKurAnOkumasi;

  /// No description provided for @uiYeniHedefEkle.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Hedef Ekle'**
  String get uiYeniHedefEkle;

  /// No description provided for @uiOrn10SayfaKitap.
  ///
  /// In tr, this message translates to:
  /// **'Örn: 10 sayfa kitap oku'**
  String get uiOrn10SayfaKitap;

  /// No description provided for @uiBugunkuManevYolculugun.
  ///
  /// In tr, this message translates to:
  /// **'Bugünkü manevî yolculuğun'**
  String get uiBugunkuManevYolculugun;

  /// No description provided for @uiBugununHedefleri.
  ///
  /// In tr, this message translates to:
  /// **'Bugünün Hedefleri'**
  String get uiBugununHedefleri;

  /// No description provided for @uiSukurNotunuzBasariylaKaydedildi.
  ///
  /// In tr, this message translates to:
  /// **'Şükür notunuz başarıyla kaydedildi.'**
  String get uiSukurNotunuzBasariylaKaydedildi;

  /// No description provided for @ui365GunlukSukurRehberi.
  ///
  /// In tr, this message translates to:
  /// **'365 Günlük Şükür Rehberi'**
  String get ui365GunlukSukurRehberi;

  /// No description provided for @uiOneriVeyaKaynakAra.
  ///
  /// In tr, this message translates to:
  /// **'Öneri veya kaynak ara...'**
  String get uiOneriVeyaKaynakAra;

  /// No description provided for @uiGununManeviOnerisi.
  ///
  /// In tr, this message translates to:
  /// **'Günün Manevi Önerisi'**
  String get uiGununManeviOnerisi;

  /// No description provided for @uiBunuYaz.
  ///
  /// In tr, this message translates to:
  /// **'Bunu Yaz'**
  String get uiBunuYaz;

  /// No description provided for @uiBugunNeIcinSukrediyorsun.
  ///
  /// In tr, this message translates to:
  /// **'Bugün ne için şükrediyorsun?'**
  String get uiBugunNeIcinSukrediyorsun;

  /// No description provided for @uiSectiginOneriyiBurayaDokebilir.
  ///
  /// In tr, this message translates to:
  /// **'Seçtiğin öneriyi buraya dökebilir veya kendi cümlelerini yazabilirsin...'**
  String get uiSectiginOneriyiBurayaDokebilir;

  /// No description provided for @uiSukruKaydet.
  ///
  /// In tr, this message translates to:
  /// **'Şükrü Kaydet'**
  String get uiSukruKaydet;

  /// No description provided for @uiGecmisSukurlerin.
  ///
  /// In tr, this message translates to:
  /// **'Geçmiş Şükürlerin'**
  String get uiGecmisSukurlerin;

  /// No description provided for @uiHenuzBirSukurNotu.
  ///
  /// In tr, this message translates to:
  /// **'Henüz bir şükür notu yazmadın.\nİlk notunu oluşturmak için yukarıdaki alanı kullanabilirsin.'**
  String get uiHenuzBirSukurNotu;

  /// No description provided for @uiNotuSil.
  ///
  /// In tr, this message translates to:
  /// **'Notu Sil'**
  String get uiNotuSil;

  /// No description provided for @uiBuSukurNotunuSilmek.
  ///
  /// In tr, this message translates to:
  /// **'Bu şükür notunu silmek istediğinize emin misiniz?'**
  String get uiBuSukurNotunuSilmek;

  /// No description provided for @uiKisiselManeviPusula.
  ///
  /// In tr, this message translates to:
  /// **'Kişisel Manevi Pusula'**
  String get uiKisiselManeviPusula;

  /// No description provided for @uiBirNimetIcinSukret.
  ///
  /// In tr, this message translates to:
  /// **'Bir nimet için şükret ve kaydet'**
  String get uiBirNimetIcinSukret;

  /// No description provided for @uiOkumaPlanim.
  ///
  /// In tr, this message translates to:
  /// **'Okuma Planım'**
  String get uiOkumaPlanim;

  /// No description provided for @uiKucukAdimlarDuzenliBir.
  ///
  /// In tr, this message translates to:
  /// **'Küçük adımlar, düzenli bir gelişim'**
  String get uiKucukAdimlarDuzenliBir;

  /// No description provided for @uiHaftalikIlerleme.
  ///
  /// In tr, this message translates to:
  /// **'Haftalık İlerleme'**
  String get uiHaftalikIlerleme;

  /// No description provided for @uiIlerlemeniGoruntule.
  ///
  /// In tr, this message translates to:
  /// **'İlerlemeni görüntüle'**
  String get uiIlerlemeniGoruntule;

  /// No description provided for @uiYeniOkumaPlaniEkle.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Okuma Planı Ekle'**
  String get uiYeniOkumaPlaniEkle;

  /// No description provided for @uiToplamSayfaSayisi.
  ///
  /// In tr, this message translates to:
  /// **'Toplam Sayfa Sayısı'**
  String get uiToplamSayfaSayisi;

  /// No description provided for @uiKitapTuru.
  ///
  /// In tr, this message translates to:
  /// **'Kitap Türü'**
  String get uiKitapTuru;

  /// No description provided for @uiKaldiginYerOnemliBir.
  ///
  /// In tr, this message translates to:
  /// **'Kaldığın yer, önemli bir cümle veya çıkarım...'**
  String get uiKaldiginYerOnemliBir;

  /// No description provided for @uiHenuzBirOkumaPlanin.
  ///
  /// In tr, this message translates to:
  /// **'Henüz bir okuma planın yok.'**
  String get uiHenuzBirOkumaPlanin;

  /// No description provided for @uiKucukAdimlarDuzenliBir2.
  ///
  /// In tr, this message translates to:
  /// **'Küçük adımlar, düzenli bir gelişim getirir.'**
  String get uiKucukAdimlarDuzenliBir2;

  /// No description provided for @uiIlkKitabiniEkle.
  ///
  /// In tr, this message translates to:
  /// **'İlk Kitabını Ekle'**
  String get uiIlkKitabiniEkle;

  /// No description provided for @ui5Sayfa.
  ///
  /// In tr, this message translates to:
  /// **'-5 Sayfa'**
  String get ui5Sayfa;

  /// No description provided for @ui10Sayfa.
  ///
  /// In tr, this message translates to:
  /// **'+10 Sayfa'**
  String get ui10Sayfa;

  /// No description provided for @uiYeniKitap.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Kitap'**
  String get uiYeniKitap;

  /// No description provided for @uiManeviYolculukOzetin.
  ///
  /// In tr, this message translates to:
  /// **'Manevi Yolculuk Özetin'**
  String get uiManeviYolculukOzetin;

  /// No description provided for @uiKucukAdimlarDuzenliBir3.
  ///
  /// In tr, this message translates to:
  /// **'Küçük adımlar, düzenli bir gelişim.'**
  String get uiKucukAdimlarDuzenliBir3;

  /// No description provided for @uiBuHaftaninVerileri.
  ///
  /// In tr, this message translates to:
  /// **'Bu Haftanın Verileri'**
  String get uiBuHaftaninVerileri;

  /// No description provided for @uiDevamEt.
  ///
  /// In tr, this message translates to:
  /// **'Devam Et!'**
  String get uiDevamEt;

  /// No description provided for @uiHarikaGidiyorsun.
  ///
  /// In tr, this message translates to:
  /// **'Harika gidiyorsun'**
  String get uiHarikaGidiyorsun;

  /// No description provided for @uiVerilerinizDigerModullerdekiHedefler.
  ///
  /// In tr, this message translates to:
  /// **'Verileriniz diğer modüllerdeki (Hedefler, Şükür, Okuma) gerçek kayıtlarınızdan anlık olarak hesaplanmaktadır.'**
  String get uiVerilerinizDigerModullerdekiHedefler;

  /// No description provided for @uiSesliEzberKontrolu.
  ///
  /// In tr, this message translates to:
  /// **'Sesli Ezber Kontrolü'**
  String get uiSesliEzberKontrolu;

  /// No description provided for @uiEzberiniTestEt.
  ///
  /// In tr, this message translates to:
  /// **'Ezberini Test Et'**
  String get uiEzberiniTestEt;

  /// No description provided for @uiSureyiSesliOkuEslesme.
  ///
  /// In tr, this message translates to:
  /// **'Sureyi sesli oku, eşleşme oranını gör.'**
  String get uiSureyiSesliOkuEslesme;

  /// No description provided for @uiKarsilastir.
  ///
  /// In tr, this message translates to:
  /// **'Karşılaştır'**
  String get uiKarsilastir;

  /// No description provided for @uiDuyulanMetin.
  ///
  /// In tr, this message translates to:
  /// **'Duyulan Metin'**
  String get uiDuyulanMetin;

  /// No description provided for @uiBuKarsilastirmaSesTanima.
  ///
  /// In tr, this message translates to:
  /// **'Bu karşılaştırma ses tanıma temellidir, kesin değildir. Kaynağından tekrar okuyarak doğrula.'**
  String get uiBuKarsilastirmaSesTanima;

  /// No description provided for @uiEzberiniSaglamlastirmakIcinGunde.
  ///
  /// In tr, this message translates to:
  /// **'Ezberini sağlamlaştırmak için günde 3-5 kez, yavaş ve tane tane oku.'**
  String get uiEzberiniSaglamlastirmakIcinGunde;

  /// No description provided for @uiHicriYasamCizgisi.
  ///
  /// In tr, this message translates to:
  /// **'Hicrî Yaşam Çizgisi'**
  String get uiHicriYasamCizgisi;

  /// No description provided for @uiDogumTarihiniGir.
  ///
  /// In tr, this message translates to:
  /// **'Doğum Tarihini Gir'**
  String get uiDogumTarihiniGir;

  /// No description provided for @uiHicriTakvimdeKacGun.
  ///
  /// In tr, this message translates to:
  /// **'Hicrî takvimde kaç gün, kaç Ramazan, kaç cuma yaşadığını göreceksin.'**
  String get uiHicriTakvimdeKacGun;

  /// No description provided for @uiTarihSec.
  ///
  /// In tr, this message translates to:
  /// **'Tarih Seç'**
  String get uiTarihSec;

  /// No description provided for @uiYasamCizgin.
  ///
  /// In tr, this message translates to:
  /// **'Yaşam Çizgin'**
  String get uiYasamCizgin;

  /// No description provided for @uiDegistir.
  ///
  /// In tr, this message translates to:
  /// **'Değiştir'**
  String get uiDegistir;

  /// No description provided for @uiPeygamberimizinSAV.
  ///
  /// In tr, this message translates to:
  /// **'PEYGAMBERİMİZİN (S.A.V.) SÜNNETİ'**
  String get uiPeygamberimizinSAV;

  /// No description provided for @uiHadisISerif.
  ///
  /// In tr, this message translates to:
  /// **'HADİS-İ ŞERİF'**
  String get uiHadisISerif;

  /// No description provided for @uiNamazMumininNMiracidir.
  ///
  /// In tr, this message translates to:
  /// **'\"Namaz, müminin\n   miracıdır.\"'**
  String get uiNamazMumininNMiracidir;

  /// No description provided for @uiTirmiziSalat1.
  ///
  /// In tr, this message translates to:
  /// **'(Tirmizî, Salât, 1)'**
  String get uiTirmiziSalat1;

  /// No description provided for @uiKisaTefsir.
  ///
  /// In tr, this message translates to:
  /// **'KISA TEFSİR'**
  String get uiKisaTefsir;

  /// No description provided for @uiIcerikHavuzu.
  ///
  /// In tr, this message translates to:
  /// **'İçerik havuzu'**
  String get uiIcerikHavuzu;

  /// No description provided for @uiFavorilerim.
  ///
  /// In tr, this message translates to:
  /// **'Favorilerim'**
  String get uiFavorilerim;

  /// No description provided for @uiGununKissasi.
  ///
  /// In tr, this message translates to:
  /// **'GÜNÜN KISSASI'**
  String get uiGununKissasi;

  /// No description provided for @uiHerKissadaBirHikmet.
  ///
  /// In tr, this message translates to:
  /// **'Her kıssada bir hikmet'**
  String get uiHerKissadaBirHikmet;

  /// No description provided for @uiKissadanHisse.
  ///
  /// In tr, this message translates to:
  /// **'KISSADAN HİSSE'**
  String get uiKissadanHisse;

  /// No description provided for @uiGecmisinHadisesindenBugununIman.
  ///
  /// In tr, this message translates to:
  /// **'Geçmişin hadisesinden bugünün imanî derslerine...'**
  String get uiGecmisinHadisesindenBugununIman;

  /// No description provided for @uiNamazVakitleriYukleniyor.
  ///
  /// In tr, this message translates to:
  /// **'Namaz vakitleri yükleniyor...'**
  String get uiNamazVakitleriYukleniyor;

  /// No description provided for @uiRisaleINur.
  ///
  /// In tr, this message translates to:
  /// **'RİSALE-İ NUR'**
  String get uiRisaleINur;

  /// No description provided for @uiRisaleINurDan.
  ///
  /// In tr, this message translates to:
  /// **'Risale-i Nur’dan ilhamla'**
  String get uiRisaleINurDan;

  /// No description provided for @ui5DkOkuma.
  ///
  /// In tr, this message translates to:
  /// **'5 dk okuma'**
  String get ui5DkOkuma;

  /// No description provided for @uiGununImanKufurMuv.
  ///
  /// In tr, this message translates to:
  /// **'GÜNÜN İMAN-KÜFÜR MUVÂZENESİ'**
  String get uiGununImanKufurMuv;

  /// No description provided for @uiYolculukSeviyesi.
  ///
  /// In tr, this message translates to:
  /// **'Yolculuk Seviyesi'**
  String get uiYolculukSeviyesi;

  /// No description provided for @uiSon30Gun.
  ///
  /// In tr, this message translates to:
  /// **'Son 30 Gün'**
  String get uiSon30Gun;

  /// No description provided for @uiSonrakiHedef.
  ///
  /// In tr, this message translates to:
  /// **'Sonraki Hedef'**
  String get uiSonrakiHedef;

  /// No description provided for @uiYillikIsiHaritasi.
  ///
  /// In tr, this message translates to:
  /// **'Yıllık Isı Haritası'**
  String get uiYillikIsiHaritasi;

  /// No description provided for @uiHerKareBirGunu.
  ///
  /// In tr, this message translates to:
  /// **'Her kare bir günü gösterir. Koyu kare = o gün daha çok vakit kaydedildi.'**
  String get uiHerKareBirGunu;

  /// No description provided for @uiKandilOzelGunler.
  ///
  /// In tr, this message translates to:
  /// **'Kandil & Özel Günler'**
  String get uiKandilOzelGunler;

  /// No description provided for @uiYaklasanGunler.
  ///
  /// In tr, this message translates to:
  /// **'Yaklaşan Günler'**
  String get uiYaklasanGunler;

  /// No description provided for @uiHusuKaydiEklendi.
  ///
  /// In tr, this message translates to:
  /// **'Huşu kaydı eklendi'**
  String get uiHusuKaydiEklendi;

  /// No description provided for @uiKalpHuzuru.
  ///
  /// In tr, this message translates to:
  /// **'Kalp Huzuru'**
  String get uiKalpHuzuru;

  /// No description provided for @uiNamazdaKalbinNeredeydiYargilamadan.
  ///
  /// In tr, this message translates to:
  /// **'Namazda kalbin neredeydi? Yargılamadan fark et.'**
  String get uiNamazdaKalbinNeredeydiYargilamadan;

  /// No description provided for @uiBuNamazdaHusuSeviyen.
  ///
  /// In tr, this message translates to:
  /// **'Bu namazda huşu seviyen?'**
  String get uiBuNamazdaHusuSeviyen;

  /// No description provided for @ui1Daginik5Derin.
  ///
  /// In tr, this message translates to:
  /// **'1 = dağınık, 5 = derin'**
  String get ui1Daginik5Derin;

  /// No description provided for @uiHaftalikHusu.
  ///
  /// In tr, this message translates to:
  /// **'Haftalık Huşu'**
  String get uiHaftalikHusu;

  /// No description provided for @uiSon7GundeOrtalama.
  ///
  /// In tr, this message translates to:
  /// **'Son 7 günde ortalama huşu seviyen'**
  String get uiSon7GundeOrtalama;

  /// No description provided for @uiHusuDagilimi.
  ///
  /// In tr, this message translates to:
  /// **'Huşu Dağılımı'**
  String get uiHusuDagilimi;

  /// No description provided for @uiHenuzKayitYok.
  ///
  /// In tr, this message translates to:
  /// **'Henüz kayıt yok'**
  String get uiHenuzKayitYok;

  /// No description provided for @uiHusuPuaniKisiselFarkindalik.
  ///
  /// In tr, this message translates to:
  /// **'Huşu puanı kişisel farkındalık içindir. Namazın kabulü Allah\'a aittir; düşük puan utanç değil, gelişim fırsatıdır.'**
  String get uiHusuPuaniKisiselFarkindalik;

  /// No description provided for @uiKissaKutuphanesi.
  ///
  /// In tr, this message translates to:
  /// **'Kıssa Kütüphanesi'**
  String get uiKissaKutuphanesi;

  /// No description provided for @uiKissaKonuVeyaKaynak.
  ///
  /// In tr, this message translates to:
  /// **'Kıssa, konu veya kaynak ara...'**
  String get uiKissaKonuVeyaKaynak;

  /// No description provided for @uiAramanizlaEslesenKissaBulunamadi.
  ///
  /// In tr, this message translates to:
  /// **'Aramanızla eşleşen kıssa bulunamadı.'**
  String get uiAramanizlaEslesenKissaBulunamadi;

  /// No description provided for @uiKissaVeHikmet.
  ///
  /// In tr, this message translates to:
  /// **'Kıssa ve Hikmet'**
  String get uiKissaVeHikmet;

  /// No description provided for @uiHikYeninAkisi.
  ///
  /// In tr, this message translates to:
  /// **'Hikâyenin akışı'**
  String get uiHikYeninAkisi;

  /// No description provided for @uiKonular.
  ///
  /// In tr, this message translates to:
  /// **'Konular'**
  String get uiKonular;

  /// No description provided for @uiZamanimizaBakanYonu.
  ///
  /// In tr, this message translates to:
  /// **'Zamanımıza Bakan Yönü'**
  String get uiZamanimizaBakanYonu;

  /// No description provided for @uiKissaninZamanimizaBakanYonu.
  ///
  /// In tr, this message translates to:
  /// **'KISSANIN ZAMANIMIZA BAKAN YÖNÜ'**
  String get uiKissaninZamanimizaBakanYonu;

  /// No description provided for @uiKendimizeSoralim.
  ///
  /// In tr, this message translates to:
  /// **'Kendimize soralım'**
  String get uiKendimizeSoralim;

  /// No description provided for @uiKissayiGorselOlarakPaylas.
  ///
  /// In tr, this message translates to:
  /// **'Kıssayı görsel olarak paylaş'**
  String get uiKissayiGorselOlarakPaylas;

  /// No description provided for @uiGorselleriGaleriyeKaydet.
  ///
  /// In tr, this message translates to:
  /// **'Görselleri galeriye kaydet'**
  String get uiGorselleriGaleriyeKaydet;

  /// No description provided for @uiIcerikYuklenemedi.
  ///
  /// In tr, this message translates to:
  /// **'İçerik yüklenemedi'**
  String get uiIcerikYuklenemedi;

  /// No description provided for @uiNamaziOgreniyorum.
  ///
  /// In tr, this message translates to:
  /// **'Namazı Öğreniyorum'**
  String get uiNamaziOgreniyorum;

  /// No description provided for @uiAdimAdimRehberKaynakli.
  ///
  /// In tr, this message translates to:
  /// **'Adım adım rehber, kaynaklı içerik'**
  String get uiAdimAdimRehberKaynakli;

  /// No description provided for @uiRuhHaliIcerigiEklenmemis.
  ///
  /// In tr, this message translates to:
  /// **'Ruh hâli içeriği eklenmemiş.'**
  String get uiRuhHaliIcerigiEklenmemis;

  /// No description provided for @uiSuAnNasilHissediyorsun.
  ///
  /// In tr, this message translates to:
  /// **'Şu an nasıl hissediyorsun?'**
  String get uiSuAnNasilHissediyorsun;

  /// No description provided for @uiSanaUygunAyetHadis.
  ///
  /// In tr, this message translates to:
  /// **'Sana uygun ayet, hadis ve dua önerelim.'**
  String get uiSanaUygunAyetHadis;

  /// No description provided for @uiRuhHalineGore.
  ///
  /// In tr, this message translates to:
  /// **'Ruh Hâline Göre'**
  String get uiRuhHalineGore;

  /// No description provided for @uiKalbinNeSoyluyorsaOna.
  ///
  /// In tr, this message translates to:
  /// **'Kalbin ne söylüyorsa, ona uygun rehberlik.'**
  String get uiKalbinNeSoyluyorsaOna;

  /// No description provided for @uiBaskaRuhHali.
  ///
  /// In tr, this message translates to:
  /// **'Başka ruh hâli'**
  String get uiBaskaRuhHali;

  /// No description provided for @uiBuOnerilerKisiselRehberlik.
  ///
  /// In tr, this message translates to:
  /// **'Bu öneriler kişisel rehberlik amaçlıdır. Dinî hüküm gerektiren konularda ehil bir âlime danışınız.'**
  String get uiBuOnerilerKisiselRehberlik;

  /// No description provided for @uiBildirimVeHatirlatmaMerkezi.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim ve hatırlatma merkezi'**
  String get uiBildirimVeHatirlatmaMerkezi;

  /// No description provided for @uiUygulamaBildirimleri.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama bildirimleri'**
  String get uiUygulamaBildirimleri;

  /// No description provided for @uiTamEzan.
  ///
  /// In tr, this message translates to:
  /// **'Tam ezan'**
  String get uiTamEzan;

  /// No description provided for @uiTamEzanSesDosyasi.
  ///
  /// In tr, this message translates to:
  /// **'Tam ezan ses dosyası ve Android ses oynatma yapılandırması gerekir.'**
  String get uiTamEzanSesDosyasi;

  /// No description provided for @uiKisaBildirimTonu.
  ///
  /// In tr, this message translates to:
  /// **'Kısa bildirim tonu'**
  String get uiKisaBildirimTonu;

  /// No description provided for @uiCihazinBildirimSesiKullanilabilir.
  ///
  /// In tr, this message translates to:
  /// **'Cihazın bildirim sesi kullanılabilir; gerçek ses davranışı Android kanalına bağlıdır.'**
  String get uiCihazinBildirimSesiKullanilabilir;

  /// No description provided for @uiBuSecimSuAnda.
  ///
  /// In tr, this message translates to:
  /// **'Bu seçim şu anda kaydedilir. Tam ezanın gerçekten çalması için ses dosyası ve ayrı Android ses kanalı ayrıca bağlanmalıdır.'**
  String get uiBuSecimSuAnda;

  /// No description provided for @uiDuaVeZikir.
  ///
  /// In tr, this message translates to:
  /// **'Dua ve zikir'**
  String get uiDuaVeZikir;

  /// No description provided for @uiGunlukManeviHatirlatma.
  ///
  /// In tr, this message translates to:
  /// **'Günlük manevi hatırlatma'**
  String get uiGunlukManeviHatirlatma;

  /// No description provided for @uiKurAnOkuma.
  ///
  /// In tr, this message translates to:
  /// **'Kur’an okuma'**
  String get uiKurAnOkuma;

  /// No description provided for @uiGunlukOkumaVakti.
  ///
  /// In tr, this message translates to:
  /// **'Günlük okuma vakti'**
  String get uiGunlukOkumaVakti;

  /// No description provided for @uiHatirlatmalarinCalismasiIcinUstteki.
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatmaların çalışması için üstteki uygulama bildirimleri açık olmalıdır.'**
  String get uiHatirlatmalarinCalismasiIcinUstteki;

  /// No description provided for @uiTestBildirimi.
  ///
  /// In tr, this message translates to:
  /// **'Test bildirimi'**
  String get uiTestBildirimi;

  /// No description provided for @uiBildirimIzniniVeTemel.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim iznini ve temel bildirimi kontrol edin.'**
  String get uiBildirimIzniniVeTemel;

  /// No description provided for @uiDene.
  ///
  /// In tr, this message translates to:
  /// **'Dene'**
  String get uiDene;

  /// No description provided for @uiBilmenizGerekenler.
  ///
  /// In tr, this message translates to:
  /// **'Bilmeniz gerekenler'**
  String get uiBilmenizGerekenler;

  /// No description provided for @uiTumunuSil.
  ///
  /// In tr, this message translates to:
  /// **'Tümünü sil'**
  String get uiTumunuSil;

  /// No description provided for @uiHenuzFavoriEklenmedi.
  ///
  /// In tr, this message translates to:
  /// **'Henüz favori eklenmedi'**
  String get uiHenuzFavoriEklenmedi;

  /// No description provided for @uiKartlardakiIkonunaDokunarakNicerikleri.
  ///
  /// In tr, this message translates to:
  /// **'Kartlardaki  📌  ikonuna dokunarak\niçerikleri buraya kaydedebilirsin.'**
  String get uiKartlardakiIkonunaDokunarakNicerikleri;

  /// No description provided for @uiSonucBulunamadi.
  ///
  /// In tr, this message translates to:
  /// **'Sonuç bulunamadı.'**
  String get uiSonucBulunamadi;

  /// No description provided for @uiFavorilerdeAra.
  ///
  /// In tr, this message translates to:
  /// **'Favorilerde ara...'**
  String get uiFavorilerdeAra;

  /// No description provided for @uiKaydetmekIcin.
  ///
  /// In tr, this message translates to:
  /// **'Kaydetmek için 📌'**
  String get uiKaydetmekIcin;

  /// No description provided for @uiFavoridenCikar.
  ///
  /// In tr, this message translates to:
  /// **'Favoriden çıkar'**
  String get uiFavoridenCikar;

  /// No description provided for @uiFavoridenCikarildi.
  ///
  /// In tr, this message translates to:
  /// **'Favoriden çıkarıldı'**
  String get uiFavoridenCikarildi;

  /// No description provided for @uiTumFavorilerSilinsinMi.
  ///
  /// In tr, this message translates to:
  /// **'Tüm favoriler silinsin mi?'**
  String get uiTumFavorilerSilinsinMi;

  /// No description provided for @uiTumFavorilerSilindi.
  ///
  /// In tr, this message translates to:
  /// **'Tüm favoriler silindi'**
  String get uiTumFavorilerSilindi;

  /// No description provided for @uiKiblePusulasi.
  ///
  /// In tr, this message translates to:
  /// **'Kıble Pusulası'**
  String get uiKiblePusulasi;

  /// No description provided for @uiHarita.
  ///
  /// In tr, this message translates to:
  /// **'Harita'**
  String get uiHarita;

  /// No description provided for @uiKBe.
  ///
  /// In tr, this message translates to:
  /// **'Kâbe'**
  String get uiKBe;

  /// No description provided for @uiKirmiziCizgiKonumunuzIle.
  ///
  /// In tr, this message translates to:
  /// **'Kırmızı çizgi konumunuz ile Kâbe arasındaki yönü gösterir.'**
  String get uiKirmiziCizgiKonumunuzIle;

  /// No description provided for @uiKonumum.
  ///
  /// In tr, this message translates to:
  /// **'Konumum'**
  String get uiKonumum;

  /// No description provided for @uiSehirSec.
  ///
  /// In tr, this message translates to:
  /// **'Şehir seç'**
  String get uiSehirSec;

  /// No description provided for @uiPusulaSensoruBulunamadi.
  ///
  /// In tr, this message translates to:
  /// **'Pusula sensörü bulunamadı'**
  String get uiPusulaSensoruBulunamadi;

  /// No description provided for @uiYaziBoyutu.
  ///
  /// In tr, this message translates to:
  /// **'Yazı boyutu'**
  String get uiYaziBoyutu;

  /// No description provided for @uiKucult.
  ///
  /// In tr, this message translates to:
  /// **'Küçült'**
  String get uiKucult;

  /// No description provided for @uiBuyut.
  ///
  /// In tr, this message translates to:
  /// **'Büyüt'**
  String get uiBuyut;

  /// No description provided for @uiArapca.
  ///
  /// In tr, this message translates to:
  /// **'ARAPÇA'**
  String get uiArapca;

  /// No description provided for @uiOkunus.
  ///
  /// In tr, this message translates to:
  /// **'OKUNUŞ'**
  String get uiOkunus;

  /// No description provided for @uiMeal.
  ///
  /// In tr, this message translates to:
  /// **'MEAL'**
  String get uiMeal;

  /// No description provided for @uiTekrarDene.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar Dene'**
  String get uiTekrarDene;

  /// No description provided for @uiKuraniKerim.
  ///
  /// In tr, this message translates to:
  /// **'Kur\'ân-ı Kerîm'**
  String get uiKuraniKerim;

  /// No description provided for @uiKurAnKutuphanesi.
  ///
  /// In tr, this message translates to:
  /// **'Kur\'an Kütüphanesi'**
  String get uiKurAnKutuphanesi;

  /// No description provided for @uiTamKurAnI.
  ///
  /// In tr, this message translates to:
  /// **'Tam Kur\'ân-ı Kerîm'**
  String get uiTamKurAnI;

  /// No description provided for @ui114SureArapcaDiyanet.
  ///
  /// In tr, this message translates to:
  /// **'114 sure - Arapça + Diyanet Meali'**
  String get ui114SureArapcaDiyanet;

  /// No description provided for @uiKurAnIKerim.
  ///
  /// In tr, this message translates to:
  /// **'Kur\'an-ı Kerim'**
  String get uiKurAnIKerim;

  /// No description provided for @uiKisaSurelerArapcaOkunus.
  ///
  /// In tr, this message translates to:
  /// **'Kısa sureler · Arapça · Okunuş · Meal'**
  String get uiKisaSurelerArapcaOkunus;

  /// No description provided for @uiWidgetFotografiGuncellendi.
  ///
  /// In tr, this message translates to:
  /// **'Widget fotoğrafı güncellendi.'**
  String get uiWidgetFotografiGuncellendi;

  /// No description provided for @uiVarsayilanArkaPlanaDonuldu.
  ///
  /// In tr, this message translates to:
  /// **'Varsayılan arka plana dönüldü.'**
  String get uiVarsayilanArkaPlanaDonuldu;

  /// No description provided for @uiFotografOnizlemesiAcilamadi.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf önizlemesi açılamadı'**
  String get uiFotografOnizlemesiAcilamadi;

  /// No description provided for @uiGaleridenFotografSec.
  ///
  /// In tr, this message translates to:
  /// **'Galeriden fotoğraf seç'**
  String get uiGaleridenFotografSec;

  /// No description provided for @uiVarsayilanArkaPlanaDon.
  ///
  /// In tr, this message translates to:
  /// **'Varsayılan arka plana dön'**
  String get uiVarsayilanArkaPlanaDon;

  /// No description provided for @uiArapAVeOsmanl.
  ///
  /// In tr, this message translates to:
  /// **'Arapça ve Osmanlıca metinler için yazı stili'**
  String get uiArapAVeOsmanl;

  /// No description provided for @uiNZleme.
  ///
  /// In tr, this message translates to:
  /// **'ÖNİZLEME'**
  String get uiNZleme;

  /// No description provided for @uiRahmNVeRah.
  ///
  /// In tr, this message translates to:
  /// **'Rahmân ve Rahîm olan Allah\'ın adıyla'**
  String get uiRahmNVeRah;

  /// No description provided for @uiIndir.
  ///
  /// In tr, this message translates to:
  /// **'İndir'**
  String get uiIndir;

  /// No description provided for @ui365GunlukKayitlarSilinemez.
  ///
  /// In tr, this message translates to:
  /// **'365 günlük kayıtlar silinemez; yalnızca düzenlenebilir.'**
  String get ui365GunlukKayitlarSilinemez;

  /// No description provided for @uiKartGoruntusuAlinamadi.
  ///
  /// In tr, this message translates to:
  /// **'Kart görüntüsü alınamadı.'**
  String get uiKartGoruntusuAlinamadi;

  /// No description provided for @uiGaleriyeKaydedildi.
  ///
  /// In tr, this message translates to:
  /// **'📥 Galeriye kaydedildi'**
  String get uiGaleriyeKaydedildi;

  /// No description provided for @uiAdminModuAktif.
  ///
  /// In tr, this message translates to:
  /// **'ADMİN MODU AKTİF'**
  String get uiAdminModuAktif;

  /// No description provided for @uiKartlarinSagUstundekiKalem.
  ///
  /// In tr, this message translates to:
  /// **'Kartların sağ üstündeki kalem ikonundan düzenleyebilirsiniz'**
  String get uiKartlarinSagUstundekiKalem;

  /// No description provided for @uiAdminModundanCik.
  ///
  /// In tr, this message translates to:
  /// **'Admin modundan çık?'**
  String get uiAdminModundanCik;

  /// No description provided for @uiDuzenlemeButonlariGizlenecek.
  ///
  /// In tr, this message translates to:
  /// **'Düzenleme butonları gizlenecek.'**
  String get uiDuzenlemeButonlariGizlenecek;

  /// No description provided for @uiCikis.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış'**
  String get uiCikis;

  /// No description provided for @uiCikis2.
  ///
  /// In tr, this message translates to:
  /// **'ÇIKIŞ'**
  String get uiCikis2;

  /// No description provided for @uiKonumSec.
  ///
  /// In tr, this message translates to:
  /// **'Konum Seç'**
  String get uiKonumSec;

  /// No description provided for @uiGpsIleKonumBul.
  ///
  /// In tr, this message translates to:
  /// **'GPS ile Konum Bul'**
  String get uiGpsIleKonumBul;

  /// No description provided for @uiManuelSec.
  ///
  /// In tr, this message translates to:
  /// **'Manuel Seç'**
  String get uiManuelSec;

  /// No description provided for @uiIlAra.
  ///
  /// In tr, this message translates to:
  /// **'İl ara...'**
  String get uiIlAra;

  /// No description provided for @uiIlceAra.
  ///
  /// In tr, this message translates to:
  /// **'İlçe ara...'**
  String get uiIlceAra;

  /// No description provided for @uiFKaliciOlarakSilinecek.
  ///
  /// In tr, this message translates to:
  /// **'\"{a0}\" kalıcı olarak silinecek.'**
  String uiFKaliciOlarakSilinecek(Object a0);

  /// No description provided for @uiFOneri.
  ///
  /// In tr, this message translates to:
  /// **'Öneri #{a0}'**
  String uiFOneri(Object a0);

  /// No description provided for @uiFYayinlanacakIcerikYok.
  ///
  /// In tr, this message translates to:
  /// **'Yayınlanacak içerik yok ({a0}).'**
  String uiFYayinlanacakIcerikYok(Object a0);

  /// No description provided for @uiFYayinla.
  ///
  /// In tr, this message translates to:
  /// **'{a0} yayınla?'**
  String uiFYayinla(Object a0);

  /// No description provided for @uiFIcerikYayinlanacakVeAna.
  ///
  /// In tr, this message translates to:
  /// **'{a0} içerik yayınlanacak ve ana sayfada görünecek.'**
  String uiFIcerikYayinlanacakVeAna(Object a0);

  /// No description provided for @uiFIcerikYayinlandi.
  ///
  /// In tr, this message translates to:
  /// **'{a0} içerik yayınlandı'**
  String uiFIcerikYayinlandi(Object a0);

  /// No description provided for @uiFIcerikKaliciOlarakSilinecek.
  ///
  /// In tr, this message translates to:
  /// **'{a0} içerik kalıcı olarak silinecek. Geri alınamaz!'**
  String uiFIcerikKaliciOlarakSilinecek(Object a0);

  /// No description provided for @uiFIcerikSilindi.
  ///
  /// In tr, this message translates to:
  /// **'{a0} içerik silindi'**
  String uiFIcerikSilindi(Object a0);

  /// No description provided for @uiFYedekPanoyaKopyalandiKb.
  ///
  /// In tr, this message translates to:
  /// **'Yedek panoya kopyalandı ({a0} KB).'**
  String uiFYedekPanoyaKopyalandiKb(Object a0);

  /// No description provided for @uiFHata.
  ///
  /// In tr, this message translates to:
  /// **'Hata: {a0}'**
  String uiFHata(Object a0);

  /// No description provided for @uiFOgeEdildi.
  ///
  /// In tr, this message translates to:
  /// **'{a0} öğe {a1} edildi'**
  String uiFOgeEdildi(Object a0, Object a1);

  /// No description provided for @uiFGecersizJson.
  ///
  /// In tr, this message translates to:
  /// **'Geçersiz JSON: {a0}'**
  String uiFGecersizJson(Object a0);

  /// No description provided for @uiFSilinecek.
  ///
  /// In tr, this message translates to:
  /// **'\"{a0}\" silinecek.'**
  String uiFSilinecek(Object a0);

  /// No description provided for @uiFIcinSonucBulunamadi.
  ///
  /// In tr, this message translates to:
  /// **'\"{a0}\" için sonuç bulunamadı'**
  String uiFIcinSonucBulunamadi(Object a0);

  /// No description provided for @uiFSonucBulundu.
  ///
  /// In tr, this message translates to:
  /// **'{a0} sonuç bulundu'**
  String uiFSonucBulundu(Object a0);

  /// No description provided for @uiFPuan.
  ///
  /// In tr, this message translates to:
  /// **'{a0} puan'**
  String uiFPuan(Object a0);

  /// No description provided for @uiFZikriniSilmekIstediginizeEmin.
  ///
  /// In tr, this message translates to:
  /// **'\"{a0}\" zikrini silmek istediğinize emin misiniz?'**
  String uiFZikriniSilmekIstediginizeEmin(Object a0);

  /// No description provided for @uiFAdet.
  ///
  /// In tr, this message translates to:
  /// **'{a0} adet'**
  String uiFAdet(Object a0);

  /// No description provided for @uiFAdiminiTamamladi.
  ///
  /// In tr, this message translates to:
  /// **'{a0} {a1} \"{a2}\" adımını tamamladı!'**
  String uiFAdiminiTamamladi(Object a0, Object a1, Object a2);

  /// No description provided for @uiFAdimTamamlandi.
  ///
  /// In tr, this message translates to:
  /// **'{a0} / {a1} adım tamamlandı'**
  String uiFAdimTamamlandi(Object a0, Object a1);

  /// No description provided for @uiFSilinsinMi.
  ///
  /// In tr, this message translates to:
  /// **'{a0} silinsin mi?'**
  String uiFSilinsinMi(Object a0);

  /// No description provided for @uiFYas.
  ///
  /// In tr, this message translates to:
  /// **'{a0} yaş'**
  String uiFYas(Object a0);

  /// No description provided for @uiFTamamlandi.
  ///
  /// In tr, this message translates to:
  /// **'{a0} / {a1} Tamamlandı'**
  String uiFTamamlandi(Object a0, Object a1);

  /// No description provided for @uiFNotlar.
  ///
  /// In tr, this message translates to:
  /// **'{a0} - Notlar'**
  String uiFNotlar(Object a0);

  /// No description provided for @uiFSayfa.
  ///
  /// In tr, this message translates to:
  /// **'{a0} / {a1} Sayfa'**
  String uiFSayfa(Object a0, Object a1);

  /// No description provided for @uiFSonOkuma.
  ///
  /// In tr, this message translates to:
  /// **'Son okuma: {a0}.{a1}.{a2}'**
  String uiFSonOkuma(Object a0, Object a1, Object a2);

  /// No description provided for @uiFHedefKelimeler.
  ///
  /// In tr, this message translates to:
  /// **'{a0} · Hedef Kelimeler'**
  String uiFHedefKelimeler(Object a0);

  /// No description provided for @uiFKelime.
  ///
  /// In tr, this message translates to:
  /// **'{a0} kelime'**
  String uiFKelime(Object a0);

  /// No description provided for @uiFTahminiRamazanDahaYasayabilirsin.
  ///
  /// In tr, this message translates to:
  /// **'Tahminen {a0} Ramazan daha yaşayabilirsin (75 yaş varsayımı).'**
  String uiFTahminiRamazanDahaYasayabilirsin(Object a0);

  /// No description provided for @uiFVakitleriYukleniyor.
  ///
  /// In tr, this message translates to:
  /// **'{a0} vakitleri yükleniyor...'**
  String uiFVakitleriYukleniyor(Object a0);

  /// No description provided for @uiFNamazi.
  ///
  /// In tr, this message translates to:
  /// **'{a0} Namazı'**
  String uiFNamazi(Object a0);

  /// No description provided for @uiFKaldi.
  ///
  /// In tr, this message translates to:
  /// **'{a0} kaldı'**
  String uiFKaldi(Object a0);

  /// No description provided for @uiFKaynak.
  ///
  /// In tr, this message translates to:
  /// **'Kaynak: {a0}'**
  String uiFKaynak(Object a0);

  /// No description provided for @uiFGunes.
  ///
  /// In tr, this message translates to:
  /// **'Güneş {a0}'**
  String uiFGunes(Object a0);

  /// No description provided for @uiFVakit.
  ///
  /// In tr, this message translates to:
  /// **'{a0} vakit'**
  String uiFVakit(Object a0);

  /// No description provided for @uiFSonrakiSeviyeye.
  ///
  /// In tr, this message translates to:
  /// **'%{a0} · Sonraki seviyeye'**
  String uiFSonrakiSeviyeye(Object a0);

  /// No description provided for @uiFGun.
  ///
  /// In tr, this message translates to:
  /// **'{a0} gün'**
  String uiFGun(Object a0);

  /// No description provided for @uiFKissaBulundu.
  ///
  /// In tr, this message translates to:
  /// **'{a0} kıssa bulundu'**
  String uiFKissaBulundu(Object a0);

  /// No description provided for @uiFAdim.
  ///
  /// In tr, this message translates to:
  /// **'{a0} adım'**
  String uiFAdim(Object a0);

  /// No description provided for @uiFOneri2.
  ///
  /// In tr, this message translates to:
  /// **'{a0} öneri'**
  String uiFOneri2(Object a0);

  /// No description provided for @uiFSehir.
  ///
  /// In tr, this message translates to:
  /// **'Şehir: {a0}'**
  String uiFSehir(Object a0);

  /// No description provided for @uiFSonPlanlama.
  ///
  /// In tr, this message translates to:
  /// **'Son planlama: {a0}'**
  String uiFSonPlanlama(Object a0);

  /// No description provided for @uiFFavori.
  ///
  /// In tr, this message translates to:
  /// **'{a0} favori'**
  String uiFFavori(Object a0);

  /// No description provided for @uiFFavoriKaliciOlarakSilinecek.
  ///
  /// In tr, this message translates to:
  /// **'{a0} favori kalıcı olarak silinecek.'**
  String uiFFavoriKaliciOlarakSilinecek(Object a0);

  /// No description provided for @uiFAyet.
  ///
  /// In tr, this message translates to:
  /// **'{a0} - {a1} ayet'**
  String uiFAyet(Object a0, Object a1);

  /// No description provided for @uiFAyet2.
  ///
  /// In tr, this message translates to:
  /// **'{a0} ayet - {a1}'**
  String uiFAyet2(Object a0, Object a1);

  /// No description provided for @uiFSure.
  ///
  /// In tr, this message translates to:
  /// **'{a0} sure'**
  String uiFSure(Object a0);

  /// No description provided for @uiFYet.
  ///
  /// In tr, this message translates to:
  /// **'{a0} âyet · {a1}'**
  String uiFYet(Object a0, Object a1);

  /// No description provided for @uiFFotografSecilemedi.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf seçilemedi: {a0}'**
  String uiFFotografSecilemedi(Object a0);

  /// No description provided for @uiFIslemBasarisiz.
  ///
  /// In tr, this message translates to:
  /// **'İşlem başarısız: {a0}'**
  String uiFIslemBasarisiz(Object a0);

  /// No description provided for @uiFKaliciOlarakSilinecek2.
  ///
  /// In tr, this message translates to:
  /// **'\"{a0}\" kalıcı olarak silinecek.'**
  String uiFKaliciOlarakSilinecek2(Object a0);

  /// No description provided for @uiFIlceleri.
  ///
  /// In tr, this message translates to:
  /// **'{a0} İlçeleri'**
  String uiFIlceleri(Object a0);

  /// No description provided for @uiHicriYolculuk.
  ///
  /// In tr, this message translates to:
  /// **'Hicrî Yolculuk'**
  String get uiHicriYolculuk;

  /// No description provided for @uiMiladiZamaniHicriBakisla.
  ///
  /// In tr, this message translates to:
  /// **'Milâdî zamanı hicrî bakışla gör.'**
  String get uiMiladiZamaniHicriBakisla;

  /// No description provided for @uiBugunHicri.
  ///
  /// In tr, this message translates to:
  /// **'BUGÜN (HİCRÎ)'**
  String get uiBugunHicri;

  /// No description provided for @uiOnemliHicriGunler.
  ///
  /// In tr, this message translates to:
  /// **'Önemli Hicrî Günler'**
  String get uiOnemliHicriGunler;

  /// No description provided for @uiHicriTarihlerYaklasikHesaplanir.
  ///
  /// In tr, this message translates to:
  /// **'Hicrî tarihler yaklaşık hesaplanır. Resmî kandil ve bayram tarihleri için Diyanet İşleri Başkanlığı takvimini esas alınız.'**
  String get uiHicriTarihlerYaklasikHesaplanir;

  /// No description provided for @uiAz.
  ///
  /// In tr, this message translates to:
  /// **'Az'**
  String get uiAz;

  /// No description provided for @uiCok.
  ///
  /// In tr, this message translates to:
  /// **'Çok'**
  String get uiCok;

  /// No description provided for @uiMubarekGunler.
  ///
  /// In tr, this message translates to:
  /// **'Mübarek Günler'**
  String get uiMubarekGunler;

  /// No description provided for @uiKandilBayramVeOzel.
  ///
  /// In tr, this message translates to:
  /// **'Kandil, bayram ve özel geceler.'**
  String get uiKandilBayramVeOzel;

  /// No description provided for @uiSiradaki.
  ///
  /// In tr, this message translates to:
  /// **'SIRADAKİ'**
  String get uiSiradaki;

  /// No description provided for @uiYaklasanOzelGunBulunamadi.
  ///
  /// In tr, this message translates to:
  /// **'Yaklaşan özel gün bulunamadı'**
  String get uiYaklasanOzelGunBulunamadi;

  /// No description provided for @uiTarihlerYaklasikHesaplanirKesin.
  ///
  /// In tr, this message translates to:
  /// **'Tarihler yaklaşık hesaplanır. Kesin tarihler için Diyanet İşleri Başkanlığı takvimini esas alınız.'**
  String get uiTarihlerYaklasikHesaplanirKesin;

  /// No description provided for @uiMezhebeGoreFarklilikGosteren.
  ///
  /// In tr, this message translates to:
  /// **'Mezhebe göre farklılık gösteren konularda kendi mezhebinizin görüşüne veya güvendiğiniz bir âlime danışınız.'**
  String get uiMezhebeGoreFarklilikGosteren;

  /// No description provided for @uiKibleAcisiKBe.
  ///
  /// In tr, this message translates to:
  /// **'Kıble açısı, Kâbe koordinatları (21.42°N, 39.83°E) ile konumunuz arasındaki büyük daire hesabıyla bulunur.'**
  String get uiKibleAcisiKBe;

  /// No description provided for @uiTefekkurHazirlaniyor.
  ///
  /// In tr, this message translates to:
  /// **'Bu kıssanın daha geniş tefekkür metni hazırlanıyor. Mevcut kıssadan hisseyi burada okuyabilirsin.'**
  String get uiTefekkurHazirlaniyor;

  /// No description provided for @uiTefekkurSoru.
  ///
  /// In tr, this message translates to:
  /// **'Bu kıssanın ışığında bugün hangi davranışımı güzelleştirebilirim?'**
  String get uiTefekkurSoru;

  /// No description provided for @uiTefekkurNot.
  ///
  /// In tr, this message translates to:
  /// **'Bu tefekkür, kıssadan çıkarılan güncel dersleri yorumlar; doğrudan ayet meali değildir.'**
  String get uiTefekkurNot;

  /// No description provided for @uiPusulaSensorYok.
  ///
  /// In tr, this message translates to:
  /// **'Bu cihazda manyetik pusula sensörü yok veya izin verilmedi.\n\nKıble açısı hesaplandı, ancak cihaz yönü gösterilemiyor.'**
  String get uiPusulaSensorYok;

  /// No description provided for @uiBildirimNotlari.
  ///
  /// In tr, this message translates to:
  /// **'• Hatırlatma saatleri cihazın yerel saatine göre ayarlanır.\n• Pil tasarrufu bazı telefonlarda bildirimleri geciktirebilir.\n• Android bildirim sesleri kanal ayarlarından etkilenir.\n• Bu ekran tek başına tam ezan sesini etkinleştirmez.'**
  String get uiBildirimNotlari;

  /// No description provided for @uiKissaHakikatleriKesfet.
  ///
  /// In tr, this message translates to:
  /// **'Bu kıssanın hayatımıza bakan derin hakikatlerini keşfet'**
  String get uiKissaHakikatleriKesfet;

  /// No description provided for @uiSayaclarSifirlanacak.
  ///
  /// In tr, this message translates to:
  /// **'Mevcut ilerleme, toplam sayaç ve tamamlanan zincir turları sıfırlanacak. Zikir listeniz korunacaktır.'**
  String get uiSayaclarSifirlanacak;

  /// No description provided for @uiKissaDevaminiOku.
  ///
  /// In tr, this message translates to:
  /// **'Kıssanın devamını oku'**
  String get uiKissaDevaminiOku;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
