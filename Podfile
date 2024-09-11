# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'TVTEST' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'CocoaAsyncSocket'
#  pod 'Weak', '~> 1.0.0'
  pod "GCDWebServer", "~> 3.0"
  # Pods for TVTEST

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = "16.0"
    end
  end
end
