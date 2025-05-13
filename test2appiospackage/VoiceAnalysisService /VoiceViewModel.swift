import Foundation
import Sonde_SDK
import AVFoundation

@MainActor
class VoiceViewModel: ObservableObject {
    @Published var score: Int?
    @Published var isRecording = false
    @Published var showPermissionAlert = false
    @Published var errorMessage: String?

    private var recorder: AudioRecorder?

    func requestPermissionAndStart() {
        let permission = AVAudioSession.sharedInstance().recordPermission

        switch permission {
        case .denied:
            showPermissionAlert = true

        case .granted:
            startRecording()

        default:
            if #available(iOS 17.0, *) {
                AVAudioApplication.requestRecordPermission(completionHandler: { [weak self] granted in
                    DispatchQueue.main.async {
                        if granted {
                            self?.startRecording()
                        } else {
                            self?.showPermissionAlert = true
                        }
                    }
                })
            } else {
                AVAudioSession.sharedInstance().requestRecordPermission { [weak self] granted in
                    DispatchQueue.main.async {
                        if granted {
                            self?.startRecording()
                        } else {
                            self?.showPermissionAlert = true
                        }
                    }
                }
            }
        }
    }


    private func startRecording() {
        isRecording = true
        recorder = AudioRecorder(
            lengthInSec: 6,
            errorHandler: { [weak self] error in
                DispatchQueue.main.async {
                    self?.errorMessage = "Recording error: \(error.localizedDescription)"
                    self?.isRecording = false
                }
            },
            recordingHandler: { _, _ in },
            recordingFinishedHandler: { [weak self] filePath in
                print("File: \(filePath)")
                self?.scoreAudio(filePath: filePath)
            }
        )
        recorder?.startRecording()
    }

    private func scoreAudio(filePath: String) {
        let metadata = MetaData(
            gender: .male,
            yearOfBirth: "1990",
            partnerId: "custom-user-1234"
        )

        let inferenceEngine = InferenceEngine(metaData: metadata)
        inferenceEngine.inferScore(
            audioFilePath: filePath,
            healthCheckType: .RESPIRATORY_SYMPTOMS_RISK
        ) { [weak self] result in
            DispatchQueue.main.async {
                let finalScore = result
                self?.score = Int(finalScore.score)
                self?.isRecording = false
            }
        } error: { [weak self] error in
            DispatchQueue.main.async {
                self?.errorMessage = "Analysis error: \(error.localizedDescription)"
                self?.isRecording = false
            }
        }
    }
}
