# Idle Creator Empire — Release Checklist

## Pre-Release

### Code
- [ ] All features implemented and tested
- [ ] No `debugPrint` or `print` statements in production code
- [ ] No hardcoded test Ad Unit IDs in production (update `AdConfig`)
- [ ] IAP product IDs match Google Play Console entries
- [ ] Firebase project configured (google-services.json in android/app/)
- [ ] Crashlytics enabled and receiving test crashes
- [ ] Analytics events firing correctly
- [ ] Remote Config defaults match server values
- [ ] Cloud save backend deployed and tested

### Configuration
- [ ] `AdConfig.testMode` set to `false`
- [ ] Ad Unit IDs populated in `AdConfig` (banner, interstitial, rewarded, appOpen, native)
- [ ] IAP product IDs verified against Play Console
- [ ] App version updated in `pubspec.yaml` and `GameConstants.appVersion`
- [ ] `android/app/build.gradle` — `minSdkVersion`, `targetSdkVersion`, `versionCode`, `versionName`

### Android Build
- [ ] Keystore generated and stored securely
- [ ] `android/key.properties` created from template (NOT committed to git)
- [ ] `key.properties` added to `.gitignore`
- [ ] ProGuard rules configured (`android/app/proguard-rules.pro`)
- [ ] R8 shrinking enabled in release build
- [ ] `google-services.json` placed in `android/app/`
- [ ] `AndroidManifest.xml` — internet permission, AdMob app ID meta-data
- [ ] App signing configured in Play Console (Google Play App Signing recommended)

### Testing
- [ ] Fresh install test (no saved data)
- [ ] Upgrade install test (existing save data preserved)
- [ ] Offline mode (no network) — game plays without crashes
- [ ] All 8 career paths selectable and functional
- [ ] Tap income works correctly
- [ ] Auto income from upgrades works
- [ ] All upgrades purchasable and functional
- [ ] Prestige system: reset, points, upgrades
- [ ] Daily rewards: streak tracking, claim, reset
- [ ] Lucky wheel: spin, cooldown, rewards
- [ ] Missions: daily generation, progress, claim
- [ ] Achievements: all types unlock correctly
- [ ] Boost system: activation, duration, stacking
- [ ] Level up: XP scaling, rank progression
- [ ] Export/Import save data
- [ ] Settings toggles persist (sound, music, haptic)
- [ ] IAP: all 6 products purchase and deliver correctly
- [ ] IAP: restore purchases works
- [ ] Ads: banner displays, interstitial shows, rewarded gives reward
- [ ] Ads: frequency cap (max 3 interstitials/hour)
- [ ] Ads: remove ads IAP hides all ads
- [ ] Cloud save: sync, download, conflict resolution
- [ ] Leaderboard: displays entries, pull-to-refresh
- [ ] Accessibility: TalkBack reads all interactive elements
- [ ] Large font mode: no text clipping or overflow
- [ ] Memory: no leaks during extended play sessions
- [ ] Performance: smooth 60fps during tapping and animations

### Privacy & Compliance
- [ ] Privacy policy URL added to Play Console
- [ ] Ad consent dialog (GDPR/UMP) tested for EU users
- [ ] Data safety form completed in Play Console
- [ ] Content rating questionnaire completed
- [ ] App categorized correctly (Games > Simulation)

## Build & Deploy

### Generate Release Build
```bash
flutter clean
flutter pub get
flutter build appbundle --release
```

### Verify APK/AAB
- [ ] AAB generated at `build/app/outputs/bundle/release/app-release.aab`
- [ ] AAB size reasonable (< 50MB before expansion)
- [ ] Test release build on physical device

### Play Console Upload
- [ ] Upload AAB to internal testing track first
- [ ] Test with internal testers (minimum 48 hours)
- [ ] Promote to closed testing / open testing
- [ ] Fix any pre-launch report issues
- [ ] Create store listing (screenshots, description, feature graphic)
- [ ] Set pricing (Free with IAP)
- [ ] Configure countries/regions for distribution
- [ ] Promote to production

## Post-Release
- [ ] Monitor Crashlytics for new crashes
- [ ] Monitor analytics for unexpected patterns
- [ ] Verify IAP revenue in Play Console
- [ ] Verify ad revenue in AdMob dashboard
- [ ] Respond to initial user reviews
- [ ] Plan patch release for any critical issues
