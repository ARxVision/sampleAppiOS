## Building the XCFramework

To build the `camera` XCFramework for both iOS devices and simulators, follow these steps:

1. Archive the framework for iOS devices:

    ```bash
    xcodebuild archive \                                                    
    -scheme camera \                                                                         
    -destination "generic/platform=iOS" \                                                      
    -archivePath "./build/ios_devices.xcarchive" \  
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES
    ```

2. Archive the framework for the iOS simulator:

    ```bash
    xcodebuild archive \                                                    
    -scheme camera \                                                                         
    -destination "generic/platform=iOS Simulator" \                                            
    -archivePath "./build/ios_simulator.xcarchive" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES
    ```

3. Create the XCFramework:

    ```bash
    xcodebuild -create-xcframework \                                        
    -framework "./build/ios_devices.xcarchive/Products/Library/Frameworks/camera.framework" \
    -framework "./build/ios_simulator.xcarchive/Products/Library/Frameworks/camera.framework" \
    -output "./build/camera.xcframework"
    ```

This will create a universal XCFramework that can be used in both iOS devices and simulators.
