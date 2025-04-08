import SwiftUI
import Flutter

struct FlutterViewControllerRepresentable: UIViewControllerRepresentable {
    var actionType: String
    
    func makeUIViewController(context: Context) -> some UIViewController {
        
        let flutterEngine = FlutterEngine(name: UUID().uuidString)
                flutterEngine.run(withEntrypoint: "main", initialRoute: getRoute())
                GeneratedPluginRegistrant.register(with: flutterEngine)
        
        
        let flutterViewController = FlutterViewControllerWrapper(
            engine: flutterEngine,
            nibName: nil,
            bundle: nil)
        
              flutterViewController.actionType = actionType
        
        // SELFIE --------------------- start
        let selfieChannel = FlutterMethodChannel(name: "youth.sample.app/photofacescan", binaryMessenger: flutterViewController.binaryMessenger)
        
        selfieChannel.setMethodCallHandler { (call, result) in
            if call.method == "sendFaceData" {
                if let arguments = call.arguments as? [String: Any], let data = arguments["faceScanData"] as? String {
                    print("SELFIE data from Flutter: \(data)")
                } else {
                    print("invalid argument")
                }
                flutterViewController.isDataProcessing = false
                flutterViewController.engine.destroyContext()
            } else if call.method == "userTapToCloseScreen" {
                flutterViewController.dismiss(animated: true, completion: nil)
                
            }
            else if call.method == "processingOfFaceData" {
                print("photo data processing")  //----------- here should be implementation of a loader on ios side
                flutterViewController.isDataProcessing = true
                flutterViewController.dismiss(animated: true, completion: nil)
            }
            else {
                print("FlutterMethodNotImplemented")
            }
        }
        // SELFIE --------------------- end
        
        
        // VIDEO --------------------- start
        let videoChannel = FlutterMethodChannel(name: "youth.sample.app/videoscan", binaryMessenger: flutterViewController.binaryMessenger)
        
        videoChannel.setMethodCallHandler { (call, result) in
            if call.method == "sendVideoScanData" {
                if let arguments = call.arguments as? [String: Any], let data = arguments["videoScanData"] as? String {
                    print("VIDEO data from Flutter: \(data)")
                } else {
                    print("INVALID_ARGUMENT")
                }
                flutterViewController.isDataProcessing = false
                flutterViewController.engine.destroyContext()
                
            } else if call.method == "userTapToCloseScreen" {
                flutterViewController.dismiss(animated: true, completion: nil)
                flutterViewController.engine.destroyContext()
                
            } else if call.method == "processingOfVideoData" {
                flutterViewController.isDataProcessing = true
                print("video data processing")  //----------- here should be implementation of a loader on ios side
                flutterViewController.dismiss(animated: true, completion: nil)
            }
            
            else {
                print("FlutterMethodNotImplemented")
            }
        }
        // VIDEO --------------------- end
        
        return flutterViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    private func getRoute() -> String {
        return actionType == "ngVideo" ? "/videoScreening" : "/selfieScreening"
    }
}

class FlutterViewControllerWrapper: FlutterViewController {
    var actionType: String?
    var isDataProcessing = false
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
        if !isDataProcessing {
                    print("destroying Flutter engine")
                    engine.destroyContext()
                }
        }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isDataProcessing = false
    }
}

struct ContentView: View {
    @State private var selectedActionType: String = ""

    var body: some View {
        VStack(spacing: 100) {
            Button("Run video screening service") {
                selectedActionType = "ngVideo"
            }

            Button("Run photo screening service") {
                selectedActionType = "ngPhoto"
            }
        }
        .fullScreenCover(isPresented: .constant(!selectedActionType.isEmpty), onDismiss: {
                selectedActionType = ""
            }) {
                FlutterViewControllerRepresentable(actionType: selectedActionType)
                    .id(UUID())
            }
    }
}
