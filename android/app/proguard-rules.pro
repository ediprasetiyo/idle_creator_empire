# Flutter-specific rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Google Play Billing
-keep class com.android.vending.billing.** { *; }

# Google Mobile Ads SDK
-keep class com.google.android.gms.ads.** { *; }
-keep class com.google.ads.** { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Firebase Analytics
-keep class com.google.android.gms.measurement.** { *; }

# Firebase Crashlytics
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception
-keep class com.google.firebase.crashlytics.** { *; }

# Firebase Remote Config
-keep class com.google.firebase.remoteconfig.** { *; }

# Firebase Performance
-keep class com.google.firebase.perf.** { *; }

# Google Play Services
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Google Play Games Services
-keep class com.google.android.gms.games.** { *; }

# SharedPreferences
-keep class androidx.datastore.** { *; }

# Prevent stripping required enums
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep Parcelable implementations
-keepclassmembers class * implements android.os.Parcelable {
    static ** CREATOR;
}

# Keep Serializable classes
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Keep annotations
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes InnerClasses
-keepattributes EnclosingMethod

# Gson (used by Firebase)
-keepattributes Signature
-keep class com.google.gson.** { *; }
-keep class sun.misc.Unsafe { *; }

# Prevent R8 from removing model classes used in JSON
-keep class com.google.firebase.firestore.** { *; }

# Multidex
-keep class androidx.multidex.** { *; }
