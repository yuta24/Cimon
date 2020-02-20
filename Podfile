# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

plugin 'cocoapods-binary'
enable_bitcode_for_prebuilt_frameworks!

target 'Cimon' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Cimon
  pod 'Firebase/Core', :binary => true
  pod 'Firebase/Analytics', :binary => true
  pod 'Fabric', '~> 1.10.2', :binary => true
  pod 'Crashlytics', '~> 3.13.4', :binary => true

  target 'CimonTests' do
    inherit! :search_paths
    # Pods for testing
  end

end
