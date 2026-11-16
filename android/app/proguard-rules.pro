# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Drift & SQLite Native Bindings
-keep class com.simonbinder.sqlite3.** { *; }
-keep class org.sqlite.** { *; }
-keepclassmembers class * extends androidx.room.RoomDatabase { *; }
-dontwarn com.simonbinder.sqlite3.**

# Receive Sharing Intent
-keep class com.kasem.receive_sharing_intent.** { *; }
