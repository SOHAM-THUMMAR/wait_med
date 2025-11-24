plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services") // Google Services plugin
    id("dev.flutter.flutter-gradle-plugin") // Flutter plugin last
}

android {
    namespace = "com.example.wait_med"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    // REQUIRED for flutter_local_notifications + geofence_service
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true   // <-- FIXED for Kotlin DSL
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.wait_med"
        minSdk = flutter.minSdkVersion        // ⚠️ Required for geofencing + notifications
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Firebase BOM (keeps Firebase versions aligned automatically)
    implementation(platform("com.google.firebase:firebase-bom:33.4.0"))

    // Firebase libraries
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.firebase:firebase-firestore")

    // REQUIRED for flutter_local_notifications + GeofenceService
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.3")
}
