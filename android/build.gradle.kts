// android/build.gradle.kts (PROJECT LEVEL)

buildscript {
    // You might have ext.kotlin_version here or similar
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Use your project's Android Gradle Plugin (AGP) version
        classpath("com.android.tools.build:gradle:8.2.2") // Or whatever version your project uses, e.g., 7.x.x, 8.x.x
        // Use your project's Kotlin Gradle Plugin version
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.22") // Or whatever version, e.g., 1.8.x, 1.9.x
        
        // THIS IS THE CORRECTED LINE FOR GOOGLE SERVICES PLUGIN CLASSPATH
        classpath("com.google.gms:google-services:4.4.2") // Using version 4.4.2 as per previous error
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}