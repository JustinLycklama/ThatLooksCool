platform :ios, '13.0'

source 'https://github.com/CocoaPods/Specs.git'

def required_pods
  use_frameworks!
  inhibit_all_warnings!

  pod 'RxSwift'
  pod 'RealmSwift'
  
end
  
def app_pods
  use_frameworks!
  inhibit_all_warnings!

  pod 'GoogleMaps',     '3.10.0'
  pod 'EasyNotificationBadge'
  
  pod 'Onboard'
  pod 'LicensePlist'
  
  pod 'Firebase/Analytics', '7.1.0'
  pod 'Firebase/Crashlytics', '7.1.0'
  
  pod 'Google-Mobile-Ads-SDK', '~> 7.65'
end

def ui_pods
  use_frameworks!
  
  pod 'ClassicClient',    :path => '../ClassicClientiOS/'
end

## Targets

target 'ThatLooksCool' do
    required_pods
    app_pods
    ui_pods
end

target 'TLCModel' do
    required_pods
    ui_pods
end

target 'TLCIntents' do
    required_pods
end

target 'TLCShareExtension' do
    required_pods
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
#      config.build_settings['EXCLUDED_ARCHS'] = 'arm64'
      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
      config.build_settings['EXCLUDED_ARCHS[sdk=watchsimulator*]'] = 'arm64'
      config.build_settings['EXCLUDED_ARCHS[sdk=appletvsimulator*]'] = 'arm64'
    end
  end
end

