platform :ios, '9.0'

# ignore all warnings from all pods
inhibit_all_warnings!
use_frameworks!

source 'https://github.com/CocoaPods/Specs.git'

target 'Astro' do
    pod "Astro", :path => "."
    pod 'Alamofire', '~> 4.0'
    pod 'Freddy', '~> 3.0'
    pod 'SwiftTask', :git => 'https://github.com/ReactKit/SwiftTask', :branch => 'swift/3.0'

	target 'AstroTests' do
	  inherit! :search_paths

	  pod 'Quick', '~> 0.10'
	  pod 'Nimble', '~> 5.0'
      pod 'Nocilla', :git => 'git@github.com:RobotsAndPencils/Nocilla.git', :branch => 'swift/3.0'
	end
end
