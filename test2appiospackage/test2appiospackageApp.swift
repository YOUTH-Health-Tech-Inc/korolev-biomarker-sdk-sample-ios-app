import SwiftUI
import Flutter

@main
struct test2appiospackageApp: App {
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
    
 init() {
     flutterVideoEngine.run(withEntrypoint: "main", initialRoute: "/videoScreening")
     flutterPhotoEngine.run(withEntrypoint: "main", initialRoute: "/selfieScreening")
     GeneratedPluginRegistrant.register(with: self.flutterVideoEngine);
     GeneratedPluginRegistrant.register(with: self.flutterPhotoEngine);
 }
}
