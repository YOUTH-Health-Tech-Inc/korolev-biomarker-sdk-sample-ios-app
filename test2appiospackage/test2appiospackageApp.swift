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
 let flutterEngine = FlutterEngine(name: "my flutter engine")
    
 init() {
   flutterEngine.run()
     GeneratedPluginRegistrant.register(with: self.flutterEngine);
 }
}
