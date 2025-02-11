# Instructions for Integrating Youth SDK into Your Native iOS App

### Description

Current SDK version: **0.1.0**  
The SDK includes a selfie analysis service and biomarker generation for your native iOS app.

## Steps for Connecting Our Swift SDK to Your Project

### 1. Add Dependency in Xcode

1. In Xcode, go to **File -> Add Package Dependencies**.
2. Paste the Git URL into the appropriate field:
github.com/YOUTH-Health-Tech-Inc/korolev-biomarker-sdk-swift.git

3. Click **Add Package** to add the dependency.

### 2. Add the Dependency to Your Project Settings

1. Go to your app settings in Xcode.
2. Under **Targets**, select **Build phases**.
3. In **Link Binary with Libraries**, click the **+** dropdown to add the dependency for our Swift package.

### 3. Copy Generated Files

1. Copy the `GeneratedPluginRegistrant.h` and `GeneratedPluginRegistrant.m` files, which are provided in this sample app, into your app’s directory.
2. Xcode will then offer to add a **<your-projectname>-Bridging-Header** file — accept this prompt.

### 4. Update the Bridging-Header File

In the **Bridging-Header** file, add the following line:
#import "GeneratedPluginRegistrant.h"

### 5. Update Build Settings
Go to Build settings -> Under Swift Compiler — General -> find Objective-C Bridging Header ->
add the path to the GeneratedPluginRegistrant.h file.
### 6. Update Info.plist
Create or open your Info.plist file.
Add the Bonjour services dependency with the following value: _dartVmService._tcp
