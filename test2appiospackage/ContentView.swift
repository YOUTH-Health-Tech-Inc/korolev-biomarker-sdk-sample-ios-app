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
    var didSendStyles = false
    var didSendStylesVideo = false
   
    
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
        
        if actionType == "ngPhoto" && !didSendStyles {
                sendSelfieStyles()
                didSendStyles = true
            }
        if actionType == "ngVideo" && !didSendStylesVideo {
            sendVideoStyles()
                didSendStylesVideo = true
            }
    }
    
    private func sendSelfieStyles() {
            let selfieChannel = FlutterMethodChannel(
                name: "youth.sample.app/photofacescan",
                binaryMessenger: binaryMessenger
            )
        
        //please use valid hex colors with 6 or 8 signs
        //please use size in format '${value}px'
        //please use size in format '${value}px'

            let styles: [String: String] = [
                "selfie-bg-color": "#F6A5C0",
                "selfie-btn-left-text-color": "#4D9A1D",
                "selfie-btn-left-color": "#8E44AD",
                "selfie-btn-left-border-color": "#F39C12",
                "selfie-btn-left-corner-radius": "20px",
                "selfie-btn-right-text-color": "#16A085",
                "selfie-btn-right-color": "#D35400",
                "selfie-btn-right-border-color": "#2ECC71",
                "selfie-btn-right-corner-radius": "20px"
            ]

            selfieChannel.invokeMethod("updateSelfieStyles", arguments: styles) { result in
                if let error = result as? FlutterError {
                    print("FlutterError: \(error.message ?? "")")
                } else if FlutterMethodNotImplemented.isEqual(result) {
                    print("Method not implemented in Flutter.")
                } else {
                    print("Selfie styles sent successfully.")
                }
            }
        }
    
    private func sendVideoStyles() {
            let videoChannel = FlutterMethodChannel(
                name: "youth.sample.app/videoscan",
                binaryMessenger: binaryMessenger
            )

        //please use valid hex colors with 6 or 8 signs
        //please use size in format '${value}px'
        //you can use standart IOS fonts and google fonts
        //use valid numeric values between 100 and 900
        //only valid values such as normal, italic etc. are supported
        
            let styles: [String: String] = [
                "video-top-info-bg-color": "#FF1493",
                "video-bottom-info-bg-color": "#FFFF00",
                "video-top-info-text-color": "#00FFFF",
                "video-bottom-info-text-color": "#0000FF",
                "video-loading-screen-bg-color": "#800000",
                "video-loading-screen-text-color": "#000000",
                "video-loading-screen-text": "ANY_TEXT_YOU_WANT",
                "video-loading-screen-text-size": "31px",
                "video-text-font": "San Francisco",
                "video-text-font-weight": "600",
                "video-text-font-style": "normal"
            ]

            videoChannel.invokeMethod("updateVideoStyles", arguments: styles) { result in
                if let error = result as? FlutterError {
                    print("FlutterError: \(error.message ?? "")")
                } else if FlutterMethodNotImplemented.isEqual(result) {
                    print("Method not implemented in Flutter.")
                } else {
                    print("Video styles sent successfully.")
                }
            }
        }
}

struct ContentView: View {
    @State private var selectedActionType: String = ""
    @State private var showVoiceScreening = false

    var body: some View {
           NavigationStack {
               VStack(spacing: 120) {
                   Button("Run VIDEO screening service") {
                       selectedActionType = "ngVideo"
                   }
                   .font(.system(size: 24))

                   Button("Run PHOTO screening service") {
                       selectedActionType = "ngPhoto"
                   }
                   .font(.system(size: 24))

                   Button("Run VOICE screening service") {
                       showVoiceScreening = true
                   }
                   .font(.system(size: 24))
               }
               .padding()
           }
        .fullScreenCover(isPresented: .constant(!selectedActionType.isEmpty), onDismiss: {
            selectedActionType = ""
        }) {
            FlutterViewControllerRepresentable(actionType: selectedActionType)
                .id(UUID())
        }
        .fullScreenCover(isPresented: $showVoiceScreening) {
                VoiceView()
        }
    }
}
