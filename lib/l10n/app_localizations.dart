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
