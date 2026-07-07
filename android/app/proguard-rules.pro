# Flutter Template ProGuard Rules

# Keep Flutter classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep Dio classes
-keep class dio.** { *; }
-dontwarn dio.**

# Keep Retrofit classes
-keep class retrofit2.** { *; }
-dontwarn retrofit2.**

# Keep OkHttp classes
-keep class okhttp3.** { *; }
-dontwarn okhttp3.**

# Keep Gson classes
-keep class com.google.gson.** { *; }
-dontwarn com.google.gson.**

# Keep model classes (DTOs and Entities)
-keep class **.*Dto { *; }
-keep class **.*Entity { *; }
-keep class **.*Model { *; }
-keep class **.*Response { *; }
-keep class **.*Request { *; }

# Keep classes with @JsonSerializable annotation
-keep @com.google.gson.annotations.SerializedName class * { *; }
-keep class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Keep Freezed generated classes
-keep class **.freezed.dart { *; }
-keep class **.*$* { *; }

# Keep Injectable classes
-keep @injectable.annotation.* class * { *; }
-keep class * {
    @injectable.annotation.* <methods>;
}

# Keep BLoC classes
-keep class **.*Bloc { *; }
-keep class **.*Cubit { *; }
-keep class **.*Event { *; }
-keep class **.*State { *; }

# Keep Repository classes
-keep class **.*Repository { *; }
-keep class **.*DataSource { *; }
-keep class **.*UseCase { *; }

# Keep enum classes
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep Parcelable classes
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Remove logging in release builds
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
}

# General optimizations
-optimizationpasses 5
-dontusemixedcaseclassnames
-dontskipnonpubliclibraryclasses
-dontpreverify
-verbose
