plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.linguai.linguai"
    compileSdk = 34
    buildToolsVersion = "34.0.0"
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.linguai.linguai"
        minSdk = 21
        targetSdk = 34
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        debug {
            // Google's official test application ID is used only in debug builds.
            manifestPlaceholders["admobAppId"] = "ca-app-pub-3940256099942544~3347511713"
        }
        release {
            // The store signing configuration is intentionally supplied by the
            // release pipeline so private keystore credentials never enter source control.
            signingConfig = signingConfigs.getByName("debug")
            manifestPlaceholders["admobAppId"] = providers.gradleProperty("ADMOB_ANDROID_APP_ID").orNull ?: "ca-app-pub-3940256099942544~3347511713"
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}
