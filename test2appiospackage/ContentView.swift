import SwiftUI
import Flutter

struct FlutterViewControllerRepresentable: UIViewControllerRepresentable {
  @Environment(FlutterDependencies.self) var flutterDependencies
    
    func makeUIViewController(context: Context) -> some UIViewController {
            let flutterViewController = FlutterViewController(
                engine: flutterDependencies.flutterEngine,
                nibName: nil,
                bundle: nil)
            
            let methodChannel = FlutterMethodChannel(name: "youth.sample.app/photofacescan", binaryMessenger: flutterViewController.binaryMessenger)
            
            methodChannel.setMethodCallHandler { (call, result) in
                if call.method == "sendFaceData" {
                    if let arguments = call.arguments as? [String: Any], let data = arguments["faceScanData"] as? String {
                        
                        print("Received data from Flutter: \(data)")
                        
                     result("Data received on iOS: \(data)")
                    } else {
                        result(FlutterError(code: "INVALID_ARGUMENT", message: "Data not found", details: nil))
                        print("INVALID_ARGUMENT")
                    }
                } else {
                    result(FlutterMethodNotImplemented)
                    print("FlutterMethodNotImplemented")
                }
            }
            
            return flutterViewController
        }
  
  
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

struct ContentView: View {
  var body: some View {
    NavigationStack {
      NavigationLink("My Flutter Feature") {
        FlutterViewControllerRepresentable()
      }
    }
  }
}

#Preview {
    ContentView()
}
