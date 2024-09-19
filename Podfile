# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
use_frameworks!

# ignore all warnings from all pods
inhibit_all_warnings!

target 'Store-norske-leksikon-iOS' do
  pod "Cartography"
  pod "ReactiveSwift"
  pod "ReactiveCocoa"
  pod "Result"
  pod "SDWebImage"

end

target 'SNLTests' do
  pod "Result"
  pod "ReactiveSwift"
end

target 'Store-norske-leksikon-iOSFramework' do
    pod "Cartography"
    pod "ReactiveCocoa"
    pod "ReactiveSwift"
    pod "Result"
    pod "SDWebImage"
end

target 'lex.dk' do
  pod "Cartography"
  pod 'lottie-ios', '~> 4.5'
  end

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
               end
          end
   end
end
