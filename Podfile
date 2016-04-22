platform :ios, '8.0'

# ignore all warnings from all pods
inhibit_all_warnings!
use_frameworks!

source 'https://github.com/CocoaPods/Specs.git'
#pod 'ExternalPodDependency'

source 'git@github.com:RobotsAndPencils/RNPPrivateSpecs.git'
#pod 'RobotsAndPencilsPodDependency'

target 'AstroTests', :exclusive => true do
  link_with "Astro"
  pod "Astro", :path => "."

  pod 'Quick'
  pod 'Nimble'
  pod 'Nocilla'
end
