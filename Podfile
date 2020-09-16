platform :ios, '10.0'

source 'https://github.com/CocoaPods/Specs.git'

def required_pods
  use_frameworks!
  inhibit_all_warnings!

  pod 'RealmSwift',     '~> 5.3'
end

def app_pods
  use_frameworks!
  inhibit_all_warnings!

  pod 'GoogleMaps',     '3.10.0'
  pod 'GooglePlaces',   '3.10.0'
  
  pod 'ClassicClient',    :path => '../ClassicClientiOS/'

end

target 'ThatLooksCool' do
    required_pods
    app_pods
end

target 'TLCModel' do
    required_pods
end

target 'TLCIntents' do
    required_pods
end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
    end
  end
end

