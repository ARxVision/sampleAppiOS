//
//  ContentView.swift
//  iOSFrameworkSampleApp
//
//  Created by Charles Leclercq on 23/10/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()  // Use @StateObject to initialize the ViewModel

    var body: some View {
        VStack {
//            Text("Connection State: \($viewModel.connectionStateText)")
            
            if let image = viewModel.receivedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                Text("No image received")
            }

            Button("Connect") {
                viewModel.connect()
            }

            Button("Disconnect") {
                viewModel.disconnect()
            }
        }
        .padding()
    }
}

extension ViewModel {
    var connectionStateText: String {
        switch connectionState {
        case .idle: return "Idle"
        case .connecting: return "Connecting..."
        case .connected: return "Connected"
        case .error(let message): return "Error: \(message)"
        }
    }
}
