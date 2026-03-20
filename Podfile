platform :ios, '14.0'
use_frameworks!

target 'MyGitHub' do
  pod 'Alamofire', '~> 5.8'
  pod 'Kingfisher', '~> 7.0'
  pod 'SnapKit', '~> 5.6'
  pod 'SwiftyJSON', '~> 5.0'
  pod 'KeychainSwift'
  pod 'SVProgressHUD'
  pod 'MJRefresh', '~> 3.7'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
    end
  end
end
