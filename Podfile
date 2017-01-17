# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

def shared_pods
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for WhatsTheMove
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Database'
  pod 'Firebase/Messaging'
  pod 'FSCalendar'
  pod 'GoogleSignIn'
  pod 'FBSDKCoreKit'
  pod 'FBSDKLoginKit'
  pod 'FBSDKShareKit'
#  pod 'LocationPicker'
end

target 'WhatsTheMove' do 
  inherit! :search_paths
  # Pods for testing
  shared_pods
end

target 'WhatsTheMoveTests' do
  inherit! :search_paths
  shared_pods
end

target 'WhatsTheMoveUITests' do 
  inherit! :search_paths
  # Pods for testing
end

