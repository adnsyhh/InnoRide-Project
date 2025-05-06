plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin") // harus paling akhir
}

android {
    namespace = "com.example.mobile"

    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    dependencies {
        // ini biasanya sudah ada
        implementation ("org.jetbrains.kotlin:kotlin-stdlib-jdk7:1.8.22")

        // ✅ Tambahkan ini
        coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
    }

}

flutter {
    source = "../.."
}
