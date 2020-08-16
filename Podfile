# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

plugin 'cocoapods-binary'
enable_bitcode_for_prebuilt_frameworks!
keep_source_code_for_prebuilt_frameworks!

target 'Cimon' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Cimon
  pod 'Firebase/Analytics', :binary => true
  pod 'Firebase/Crashlytics', :binary => true

  target 'CimonTests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
    end
  end
end
