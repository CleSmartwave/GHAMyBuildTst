How to generate ExternalXCframeworks:
1. Open Terminal and execute:
git clone https://github.com/CleSmartwave/swph-mobile-ManuallyBuiltExternalDependencies.git
at your desired project folder
2. On Terminal, go to the project folder path: 
cd [project folder path]
3. Type in Terminal and execute,
carthage bootstrap --use-xcframeworks --platform ios
4. Type in Terminal and execute, 
carthage bootstrap --use-xcframeworks --no-use-binaries --platform ios
5. just ignore this error: 
*** Skipped building klarna-mobile-sdk due to the error:
Dependency "klarna-mobile-sdk" has no shared framework schemes for any of the platforms: iOS
6. You can now copy Braintree xcframework dependencies from ~/Carthage/Build folder to Mysale project ~/ExternalXCFrameworks folder
7. KlarnaMobileSDK.xcframework should also be copied from ~/Carthage/Checkouts/klarna-mobile-sdk/ios/XCFramework/full/universal/KlarnaMobileSDK.xcframework to Mysale project ~/ExternalXCFrameworks folder
