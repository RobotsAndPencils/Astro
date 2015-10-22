platform :ios, '8.0'

# ignore all warnings from all pods
inhibit_all_warnings!
use_frameworks!

source 'https://github.com/CocoaPods/Specs.git'
#pod 'ExternalPodDependency'

source 'https://github.com/RobotsAndPencils/Astro'
#pod 'RobotsAndPencilsPodDependency'

target 'AstroTests', :exclusive => true do
  pod "Astro", :path => "."

  pod 'Quick'
  pod 'Nimble'
end
