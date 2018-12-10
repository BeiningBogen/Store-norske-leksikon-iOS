# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
use_frameworks!

# ignore all warnings from all pods
inhibit_all_warnings!

def downgrade_swift

    post_install do |installer|

        installer.pods_project.build_configurations.each do |config|
            config.build_settings.delete('CODE_SIGNING_ALLOWED')
            config.build_settings.delete('CODE_SIGNING_REQUIRED')
        end

        incompatiblePods = ['Cartography']
        installer.pods_project.targets.each do |target|
            if incompatiblePods.include? target.name
                target.build_configurations.each do |config|
                    config.build_settings['SWIFT_VERSION'] = '4.0'
#                    config.build_settings['CONFIGURATION_BUILD_DIR'] = '$PODS_CONFIGURATION_BUILD_DIR'
                end
            end
        end
    end
end

target 'Store-norske-leksikon-iOS' do
  pod "Cartography"
  pod "ReactiveSwift"
  pod "ReactiveCocoa"
  pod "Result"
  pod 'AMScrollingNavbar'
end

target 'Store-norske-leksikon-iOSTests' do
    inherit! :search_paths
    pod "Cartography"
    pod "ReactiveSwift"
    pod "ReactiveCocoa"
    pod "Result"
    
end

target 'Store-norske-leksikon-iOSFramework' do
    pod "Cartography"
    pod "ReactiveCocoa"
    pod "ReactiveSwift"
    pod "Result"
    pod 'AMScrollingNavbar'
    downgrade_swift
end

target 'Store-norske-leksikon-iOSApi' do
    pod "Cartography"
    pod "ReactiveCocoa"
    pod "ReactiveSwift"
    pod "Result"
end
