#!/bin/sh
#CONFIG=${CONFIGURATION}
CONFIG=Release

# Step 1. Make sure the output directory exists
UNIVERSAL_OUTPUTFOLDER=${BUILD_DIR}/${CONFIG}-universal
mkdir -p "${UNIVERSAL_OUTPUTFOLDER}"

# Step 2. Build Device and Simulator versions
xcodebuild -target "${PROJECT_NAME}" ONLY_ACTIVE_ARCH=NO -configuration ${CONFIG} -sdk iphoneos  BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean build

xcodebuild -target "${PROJECT_NAME}" ONLY_ACTIVE_ARCH=NO -configuration ${CONFIG} -sdk iphonesimulator -arch x86_64 -arch i386 BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean build

# Step 3. Copy the framework structure to the universal folder. Subsequently copy the files of the swiftmodule (in Modules directory) of -iphonesimulator to the swiftmodule of universal framework directory.

cp -R "${BUILD_DIR}/${CONFIG}-iphoneos/${PROJECT_NAME}.framework" "${UNIVERSAL_OUTPUTFOLDER}/"

cp -R "${BUILD_DIR}/${CONFIG}-iphonesimulator/${PROJECT_NAME}.framework/Modules/${PROJECT_NAME}.swiftmodule/" "${UNIVERSAL_OUTPUTFOLDER}/${PROJECT_NAME}.framework/Modules/${PROJECT_NAME}.swiftmodule"

# Step 4. Create universal binary file using lipo and place the combined executable in the copied framework directory

lipo -create -output "${UNIVERSAL_OUTPUTFOLDER}/${PROJECT_NAME}.framework/${PROJECT_NAME}" "${BUILD_DIR}/${CONFIG}-iphonesimulator/${PROJECT_NAME}.framework/${PROJECT_NAME}" "${BUILD_DIR}/${CONFIG}-iphoneos/${PROJECT_NAME}.framework/${PROJECT_NAME}"
