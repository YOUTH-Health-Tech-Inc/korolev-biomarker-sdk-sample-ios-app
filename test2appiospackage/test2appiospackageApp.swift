import SwiftUI
import Flutter

@main
struct test2appiospackageApp: App {
    @UIApplicationDelegateAdaptor(AppDelegateCustom.self) var appDelegate
    @State var flutterDependencies = FlutterDependencies()
    
       var body: some Scene {
         WindowGroup {
             ContentView()
             .environment(flutterDependencies)
         }
       }
}

@Observable
class FlutterDependencies {
 let flutterVideoEngine = FlutterEngine(name: "flutterVideoEngine")
    let flutterPhotoEngine = FlutterEngine(name: "flutterPhotoEngine")
    let flutterVoiceEngine = FlutterEngine(name: "flutterVoiceEngine")
    
 init() {
     flutterVideoEngine.run(withEntrypoint: "main", initialRoute: "/videoScreening")
     flutterPhotoEngine.run(withEntrypoint: "main", initialRoute: "/selfieScreening")
     flutterVoiceEngine.run(withEntrypoint: "main", initialRoute: "/voiceScreening")
     GeneratedPluginRegistrant.register(with: self.flutterVideoEngine);
     GeneratedPluginRegistrant.register(with: self.flutterPhotoEngine);
     GeneratedPluginRegistrant.register(with: self.flutterVoiceEngine);
 }
}
