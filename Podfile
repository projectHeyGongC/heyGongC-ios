# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'

# [Xcodeproj] Generated duplicate UUIDs 제거
install!'cocoapods',:deterministic_uuids=>false

# 타깃 워닝 제거
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
# 타깃 워닝 제거 (END)

def common_pods
  # Comment the next line if you don't want to use dynamic frameworks
  # Pods for Quantec
  use_frameworks!
  inhibit_all_warnings!
  
  pod 'Toast-Swift', '~> 5.0.1'
  pod 'SnapKit', '~> 5.6.0'
  
  # ReactiveX
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxOptional'
  pod 'RxGesture'
  pod 'RxDataSources'
  pod 'Then'
  
  # Moya
  pod 'Moya'
  pod 'Moya/RxSwift'
  pod 'Moya/ReactiveSwift'
  pod 'Moya/Combine'
  
  # Firebase
  pod 'Firebase/Messaging'
  pod 'Firebase/Analytics'
  
  # Utils
  pod 'SwiftyUserDefaults', '~> 5.0'
  pod 'lottie-ios'
  pod 'Action'
  pod 'FSCalendar'
  pod 'TAKUUID'
  pod 'SwiftKeychainWrapper'
  pod 'Kingfisher'
  pod 'Charts'
  
  # Login
  pod 'GoogleSignIn'
  
end

target 'heyGongC' do
  common_pods
end

target 'heyGongCTests' do
  inherit! :search_paths
  # Pods for testing
end

target 'heyGongCUITests' do
  # Pods for testing
end
