import SwiftUI
import Flutter

struct FlutterViewControllerRepresentable: UIViewControllerRepresentable {
  @Environment(FlutterDependencies.self) var flutterDependencies
    
    func makeUIViewController(context: Context) -> some UIViewController {
            let flutterViewController = FlutterViewController(
                engine: flutterDependencies.flutterEngine,
                nibName: nil,
                bundle: nil)
            
            let selfieChannel = FlutterMethodChannel(name: "youth.sample.app/photofacescan", binaryMessenger: flutterViewController.binaryMessenger)
            
                selfieChannel.setMethodCallHandler { (call, result) in
                if call.method == "sendFaceData" {
                    if let arguments = call.arguments as? [String: Any], let data = arguments["faceScanData"] as? String {
                        print("Received selfie data from Flutter: \(data)")
                    } else {
                        print("INVALID_ARGUMENT")
                    }
                } else {
                    print("FlutterMethodNotImplemented")
                }
            }
        
        let videoChannel = FlutterMethodChannel(name: "youth.sample.app/videoscan", binaryMessenger: flutterViewController.binaryMessenger)
        
        videoChannel.setMethodCallHandler { (call, result) in
            if call.method == "sendVideoScanData" {
                if let arguments = call.arguments as? [String: Any], let data = arguments["videoScanData"] as? String {
                    print("Received video data from Flutter: \(data)")
                } else {
                    print("INVALID_ARGUMENT")
                }
            } else {
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
