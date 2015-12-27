# allows to add DEPLOYMENTFOLDERS and links to the V-Play library and QtCreator auto-completion
CONFIG += v-play

qmlFolder.source = qml
DEPLOYMENTFOLDERS += qmlFolder # comment for publishing

assetsFolder.source = assets
DEPLOYMENTFOLDERS += assetsFolder

# Add more folders to ship with the application here

RESOURCES += #    resources.qrc # uncomment for publishing

# NOTE: for PUBLISHING, perform the following steps:
# 1. comment the DEPLOYMENTFOLDERS += qmlFolder line above, to avoid shipping your qml files with the application (instead they get compiled to the app binary)
# 2. uncomment the resources.qrc file inclusion and add any qml subfolders to the .qrc file; this compiles your qml files and js files to the app binary and protects your source code
# 3. change the setMainQmlFile() call in main.cpp to the one starting with "qrc:/" - this loads the qml files from the resources
# for more details see the "Deployment Guides" in the V-Play Documentation

# during development, use the qmlFolder deployment because you then get shorter compilation times (the qml files do not need to be compiled to the binary but are just copied)
# also, for quickest deployment on Desktop disable the "Shadow Build" option in Projects/Builds - you can then select "Run Without Deployment" from the Build menu in Qt Creator if you only changed QML files; this speeds up application start, because your app is not copied & re-compiled but just re-interpreted


# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp

android {
    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
    OTHER_FILES += android/AndroidManifest.xml
}

ios {
    QMAKE_INFO_PLIST = ios/Project-Info.plist
    OTHER_FILES += $$QMAKE_INFO_PLIST

    QMAKE_TARGET_BUNDLE_PREFIX = "net.vplay.demos"
    TARGET = DoodleJump

    # AdMob framework
    LIBS += -F$$PWD/ios
    LIBS += -framework GoogleMobileAds

    # Minimum iOS deployment target must be 6.0 for using the AdMob SDK
    QMAKE_IOS_DEPLOYMENT_TARGET = 6.0

    # Chartboost framework
    LIBS += -framework Chartboost

    # AdMob dependencies
    LIBS += -framework GoogleMobileAds
    LIBS += -framework AdSupport
    LIBS += -framework AudioToolbox
    LIBS += -framework AVFoundation
    LIBS += -framework CoreGraphics
    LIBS += -framework CoreMedia
    LIBS += -framework CoreTelephony
    LIBS += -framework EventKit
    LIBS += -framework EventKitUI
    LIBS += -framework MessageUI
    LIBS += -framework StoreKit
    LIBS += -framework SystemConfiguration

    # use sensors
    QTPLUGIN += qtsensors_ios
}

DISTFILES += \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat

