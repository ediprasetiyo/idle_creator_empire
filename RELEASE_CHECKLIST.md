# Idle Creator Empire — Release Checklist (v1.2.0)

## Pre-Release

### Code Quality
- [x] All features implemented (30+ upgrades, prestige, wheel, daily rewards, missions, achievements, boosts, IAP, ads, cloud save, leaderboard, tutorial)
- [x] No `debugPrint` or `print` statements in production code
- [x] No hardcoded test Ad Unit IDs in production (update `AdConfig`)
- [x] Localization: English and Bahasa Indonesia supported
- [x] Tutorial onboarding for new players
- [x] Legal pages: Privacy Policy, Terms of Service, Data Deletion, Licenses
- [ ] IAP product IDs match Google Play Console entries
- [ ] Firebase project configured (google-services.json in android/app/)
- [ ] Crashlytics enabled and receiving test crashes
- [ ] Analytics events firing correctly
- [ ] Remote Config defaults match server values
- [ ] Cloud save backend deployed and tested

### SDK Integration Points
The following services use integration-ready stubs. Each must be wired to actual SDKs before release:
- [ ] Google AdMob (`lib/services/ad_service.dart`) — uncomment SDK calls, add `google_mobile_ads` package
- [ ] Firebase Analytics (`lib/services/analytics_service.dart`) — add `firebase_analytics` package
- [ ] Firebase Crashlytics (`lib/services/crash_service.dart`) — add `firebase_crashlytics` package
- [ ] Firebase Remote Config (`lib/services/remote_config_service.dart`) — add `firebase_remote_config` package
- [ ] Cloud Firestore for saves (`lib/services/cloud_save_service.dart`) — add `cloud_firestore` package
- [ ] Google Play Billing (`lib/services/iap_service.dart`) — add `in_app_purchase` package
- [ ] Audio playback (`lib/services/audio_service.dart`) — add `audioplayers` package, place sound files in assets/sounds/
- [ ] Push Notifications (`lib/services/notification_service.dart`) — add `flutter_local_notifications` package
- [ ] Performance Monitoring (`lib/services/performance_service.dart`) — add `firebase_performance` package
- [ ] Game Services Leaderboard (`lib/services/leaderboard_service.dart`) — add Play Games Services
- [ ] Achievement sync (`lib/services/achievement_sync_service.dart`) — add Play Games Services

### Configuration
- [ ] `AdConfig.testMode` set to `false`
- [ ] Ad Unit IDs populated in `AdConfig` (banner, interstitial, rewarded, appOpen, native)
- [ ] IAP product IDs verified against Play Console
- [x] App version set to 1.2.0+3 in `pubspec.yaml`
- [x] `GameConstants.appVersion` matches pubspec version
- [ ] `android/app/build.gradle` — `minSdkVersion`, `targetSdkVersion`, `versionCode`, `versionName`

### Android Build
- [ ] Keystore generated: `keytool -genkey -v -keystore idle-creator-empire.jks -keyalg RSA -keysize 2048 -validity 10000 -alias release`
- [ ] `android/key.properties` created from `android/key.properties.template` (NOT committed to git)
- [ ] `key.properties` added to `.gitignore`
- [x] ProGuard rules configured (`android/app/proguard-rules.pro`)
- [ ] R8 shrinking enabled in release build
- [ ] `google-services.json` placed in `android/app/`
- [ ] `AndroidManifest.xml` — internet permission, AdMob app ID meta-data
- [ ] App signing configured in Play Console (Google Play App Signing recommended)

### Testing
- [ ] Fresh install test (no saved data — tutorial should appear)
- [ ] Upgrade install test (existing save data preserved, tutorial skipped)
- [ ] Offline mode (no network) — game plays without crashes
- [ ] All 8 career paths selectable and functional
- [ ] Tap income works correctly
- [ ] Auto income from upgrades works (1s tick)
- [ ] All 30 upgrades purchasable and functional across 6 categories
- [ ] Prestige system: reset, points earned, 5 prestige upgrades
- [ ] Daily rewards: 30-day streak, claim, reset on break
- [ ] Lucky wheel: spin animation, cooldown, 8 reward types
- [ ] Missions: 5 daily missions, scaling rewards, claim
- [ ] Achievements: all 50 types unlock correctly
- [ ] Boost system: 4 boost types, duration, stacking with VIP
- [ ] Level up: XP curve `80 * level * 1.35`, rank progression through 10 ranks
- [ ] Export/Import save data (Base64/JSON)
- [ ] Settings toggles persist (sound, music, haptic)
- [ ] IAP: all 6 products purchase and deliver correctly
- [ ] IAP: restore purchases works
- [ ] Ads: banner displays, interstitial shows (max 3/hour), rewarded gives reward
- [ ] Ads: remove ads IAP hides all ads, VIP hides ads
- [ ] Cloud save: sync, download, conflict resolution (keepLocal/keepCloud/keepNewer)
- [ ] Leaderboard: 5 categories, pull-to-refresh
- [ ] Tutorial: all 10 steps display, skip works, state persists across restart
- [ ] Localization: EN and ID languages display correctly
- [ ] Legal pages: Privacy, Terms, Data Deletion accessible from Settings
- [ ] Licenses page shows Flutter/package licenses
- [ ] Accessibility: TalkBack reads all interactive elements (Semantics labels)
- [ ] Text scaling: clamped 0.8-1.4x, no text clipping or overflow
- [ ] Memory: no leaks during extended play sessions (RepaintBoundary on hot widgets)
- [ ] Performance: smooth 60fps during tapping and animations

### Privacy & Compliance
- [ ] Privacy policy URL added to Play Console
- [ ] Privacy policy accessible in-app (Settings > Privacy Policy)
- [ ] Terms of service accessible in-app (Settings > Terms of Service)
- [ ] Data deletion instructions in-app (Settings > Data Deletion)
- [ ] Ad consent dialog (GDPR/UMP) tested for EU users
- [ ] Data safety form completed in Play Console
- [ ] Content rating questionnaire completed
- [ ] App categorized correctly (Games > Casual)
- [ ] COPPA compliance for children under 13

### Store Listing
- [x] English store listing prepared (`store_listing_en.txt`)
- [x] Bahasa Indonesia store listing prepared (`store_listing_id.txt`)
- [ ] App icon (512x512 PNG, high-res)
- [ ] Feature graphic (1024x500 PNG)
- [ ] Screenshots: phone (minimum 2, recommended 8)
- [ ] Screenshots: 7-inch tablet (optional but recommended)
- [ ] Screenshots: 10-inch tablet (optional but recommended)
- [ ] Short description (80 chars max) uploaded
- [ ] Full description uploaded
- [ ] What's New text uploaded

## Build & Deploy

### Generate Release Build
```bash
# Clean and get dependencies
flutter clean
flutter pub get

# Run analysis
flutter analyze

# Build release AAB
flutter build appbundle --release
```

### Verify AAB
- [ ] AAB generated at `build/app/outputs/bundle/release/app-release.aab`
- [ ] AAB size reasonable (< 50MB before expansion)
- [ ] Test release build on physical device
- [ ] Verify portrait-only orientation lock works
- [ ] Verify dark theme renders correctly on various devices

### Play Console Upload
- [ ] Upload AAB to internal testing track first
- [ ] Test with internal testers (minimum 48 hours)
- [ ] Promote to closed testing / open testing
- [ ] Fix any pre-launch report issues
- [ ] Set pricing: Free with in-app purchases
- [ ] Configure countries/regions for distribution
- [ ] Promote to production

## Post-Release
- [ ] Monitor Crashlytics for new crashes
- [ ] Monitor analytics for unexpected patterns
- [ ] Verify IAP revenue in Play Console
- [ ] Verify ad revenue in AdMob dashboard
- [ ] Respond to initial user reviews
- [ ] Plan patch release for any critical issues
- [ ] Monitor retention and engagement metrics
- [ ] Collect feedback for v1.3.0 roadmap
