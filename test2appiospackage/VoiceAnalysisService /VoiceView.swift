import SwiftUI
import Sonde_SDK
import AVFoundation

struct VoiceView: View {
    @StateObject private var viewModel = VoiceViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.black.opacity(0.95)
                .ignoresSafeArea()

            VStack {
                Spacer() // Центрирование по вертикали

                VStack(spacing: 40) { // увеличенный отступ между элементами
                    Text("Please say: «Ahaaaaa» for 6 sec")
                        .font(.system(size: 24, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .center)

                    if viewModel.isRecording {
                        ProgressView("Recording...")
                            .tint(.white)
                            .scaleEffect(2)
                    } else {
                        Button("Start recording") {
                            viewModel.requestPermissionAndStart()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                    }

                    if let score = viewModel.score {
                        Text("Result: \(score)/100")
                            .font(.title)
                            .foregroundColor(.green)
                    }

                    if let error = viewModel.errorMessage {
                        Text("Error: \(error)")
                            .foregroundColor(.red)
                    }
                }
                .padding()

                Spacer()
            }

            Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 20, weight: .bold))
                    .padding()
                    .foregroundColor(.white)
            }
        }
    }
}
