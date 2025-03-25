import SwiftUI
import Flutter

struct FlutterViewControllerRepresentable: UIViewControllerRepresentable {
    var actionType: String
    func makeUIViewController(context: Context) -> some UIViewController {
        
        let flutterEngine = FlutterEngine(name: UUID().uuidString) // Создаём новый движок
                flutterEngine.run(withEntrypoint: "main", initialRoute: getRoute())
                GeneratedPluginRegistrant.register(with: flutterEngine)
        
        
        let flutterViewController = FlutterViewControllerWrapper(
            engine: flutterEngine,
            nibName: nil,
            bundle: nil)
        
              flutterViewController.actionType = actionType
        
        // receive selfie data
        let selfieChannel = FlutterMethodChannel(name: "youth.sample.app/photofacescan", binaryMessenger: flutterViewController.binaryMessenger)
        
        selfieChannel.setMethodCallHandler { (call, result) in
            if call.method == "sendFaceData" {
                if let arguments = call.arguments as? [String: Any], let data = arguments["faceScanData"] as? String {
                    print("Received selfie data from Flutter: \(data)")
                    flutterViewController.engine.destroyContext()
                } else {
                    print("INVALID_ARGUMENT")
                }
            } else if call.method == "processingOfFaceData" {
                //here should be implementation of a loader on ios side
                print("EVENT: ---------------- photo data processing")
                if let navigationController = flutterViewController.navigationController {
                    navigationController.popToRootViewController(animated: true)
                    //self.flutterDependencies.flutterVideoEngine.viewController = nil
                }
            }
            else {
                print("FlutterMethodNotImplemented")
            }
        }
        
        // receive video data
        let videoChannel = FlutterMethodChannel(name: "youth.sample.app/videoscan", binaryMessenger: flutterViewController.binaryMessenger)
        
        videoChannel.setMethodCallHandler { (call, result) in
            if call.method == "sendVideoScanData" {
                if let arguments = call.arguments as? [String: Any], let data = arguments["videoScanData"] as? String {
                    print("Received video data from Flutter: \(data)")
                    flutterViewController.engine.destroyContext()
                } else {
                    print("INVALID_ARGUMENT")
                }
            } else if call.method == "processingOfVideoData" {
                print("EVENT: ---------------- video data processing")
                if let navigationController = flutterViewController.navigationController {
                    navigationController.popToRootViewController(animated: true)
                }
            }
            else {
                print("FlutterMethodNotImplemented")
            }
        }
        
        return flutterViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    private func getRoute() -> String {
        return actionType == "ngVideo" ? "/videoScreening" : "/selfieScreening"
    }
}

class FlutterViewControllerWrapper: FlutterViewController {
    var actionType: String?
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
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
