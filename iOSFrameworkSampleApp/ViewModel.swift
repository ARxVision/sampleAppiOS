//
//  ViewModel.swift
//  iOSFrameworkSampleApp
//
//  Created by Charles Leclercq on 23/10/2024.
//

import SwiftUI
import Combine
import camera  // Import your camera framework

enum ConnectionState {
    case idle
    case connecting
    case connected
    case error(String)
}

enum ButtonState {
    case idle
    case pressed
}

class ViewModel: ObservableObject, ArxHeadsetApi {
    @Published var connectionState: ConnectionState = .idle
    @Published var receivedImage: UIImage?
    @Published var imuData: ImuData?
    @Published var buttonStates: [ArxButton: ButtonState] = [:]
    
    private var headsetHandler: ArxHeadsetHandler?
    private var cancellables = Set<AnyCancellable>()
    
    // Track whether recognition is allowed
    private var isRecognitionAllowed = false
    
    init() {
        // Initialize ArxHeadsetHandler with the ViewModel as the delegate
        self.headsetHandler = ArxHeadsetHandler(delegate: self)
        
        // Initialize button states
        for button in ArxButton.allCases {
            buttonStates[button] = .idle
        }
    }
    
    func connect() {
        // Connect the headset
        headsetHandler?.connect()
        connectionState = .connecting
    }
    
    func disconnect() {
        // Disconnect the headset
        headsetHandler?.disconnect()
        connectionState = .idle
    }
    
    // MARK: - ArxHeadsetApi Protocol Methods

    func onDeviceConnectionError(error: Error) {
        DispatchQueue.main.async {
            self.connectionState = .error("Headset Disconnected: \(error.localizedDescription)")
        }
    }
    
    func onDevicePhotoReceived(image: UIImage, frameDescriptor: Resolution) {
        if isRecognitionAllowed {
            isRecognitionAllowed = false
            // You can implement your own image recognition logic here
        }
        
        DispatchQueue.main.async {
            self.receivedImage = image
        }
    }
    
    func onButtonClicked(button: ArxButton, isLongPress: Bool) {
        DispatchQueue.main.async {
            switch button {
            case .square:
                print("Square button clicked - triggering audio input")
            case .triangle:
                print("Triangle button clicked - triggering audio input")
            case .circle:
                print("Circle button clicked - triggering audio input")
                // Implement audio input (e.g., start speech recognition)
            default:
                print("\(button.description) Button Clicked")
            }
            
            self.buttonStates[button] = .pressed
            
            // Reset button state after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.buttonStates[button] = .idle
            }
        }
    }
    
    func onDisconnect() {
        DispatchQueue.main.async {
            self.connectionState = .idle
        }
    }
    
    func onImuDataUpdate(imuData: ImuData) {
        DispatchQueue.main.async {
            self.imuData = imuData
        }
    }
    
    func onConnected() {
        DispatchQueue.main.async {
            self.connectionState = .connected
        }
    }
}
