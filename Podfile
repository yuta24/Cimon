# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

plugin 'cocoapods-binary'
enable_bitcode_for_prebuilt_frameworks!

target 'App' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  use_frameworks!

  # Pods for App

  target 'AppTests' do
    inherit! :search_paths
    # Pods for testing
  end

end

target 'Cimon' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Cimon
  pod 'Firebase/Core', :binary => true
  pod 'Fabric', '~> 1.10.1', :binary => true
  pod 'Crashlytics', '~> 3.13.1', :binary => true

  target 'CimonTests' do
    inherit! :search_paths
    # Pods for testing
  end

end

target 'Domain' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  use_frameworks!

  # Pods for Domain

  target 'DomainTests' do
    inherit! :search_paths
    # Pods for testing
  end

end

target 'Shared' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  use_frameworks!

  # Pods for Shared

  target 'SharedTests' do
    inherit! :search_paths
    # Pods for testing
  end

end
