import SwiftUI
import Flutter

struct FlutterViewControllerRepresentable: UIViewControllerRepresentable {
    var actionType: String
    @Environment(FlutterDependencies.self) var flutterDependencies
    func makeUIViewController(context: Context) -> some UIViewController {
        
        var currentEngine: FlutterEngine

        if actionType == "ngVideo" {
            currentEngine = flutterDependencies.flutterVideoEngine
        } else if actionType == "ngPhoto" {
            currentEngine = flutterDependencies.flutterPhotoEngine
        } else {
            currentEngine = flutterDependencies.flutterPhotoEngine
        }
        
        let flutterViewController = FlutterViewControllerWrapper(
            engine: currentEngine,
            nibName: nil,
            bundle: nil)
        
              flutterViewController.actionType = actionType
        
        // receive selfie data
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
            if let navigationController = flutterViewController.navigationController {
                navigationController.popViewController(animated: true)
                self.flutterDependencies.flutterVideoEngine.viewController = nil
            }
        }
        
        // receive video data
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
            
            
            if let navigationController = flutterViewController.navigationController {
                navigationController.popViewController(animated: true)
                self.flutterDependencies.flutterPhotoEngine.viewController = nil
            }
        }
        
        return flutterViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

class FlutterViewControllerWrapper: FlutterViewController {
    var actionType: String?
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
        //TODO: reset
        }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //TODO: reset
    }
}

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 100) {
                NavigationLink("Run video screening service") {
                    FlutterViewControllerRepresentable(actionType: "ngVideo").id(UUID())
                }
                NavigationLink("Run photo screening service") {
                    FlutterViewControllerRepresentable(actionType: "ngPhoto").id(UUID())
                }
            }
        }
    }
}



#Preview {
    ContentView()
}
