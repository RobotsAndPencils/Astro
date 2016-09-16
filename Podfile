platform :ios, '8.0'

# ignore all warnings from all pods
inhibit_all_warnings!
use_frameworks!

source 'https://github.com/CocoaPods/Specs.git'

target 'Astro' do
    pod "Astro", :path => "."
    pod 'Alamofire', '~> 3.5'
    pod 'Freddy', '~> 2.1'
    pod 'SwiftTask', '~> 5.0'

	target 'AstroTests' do
	  inherit! :search_paths

	  pod 'Quick', '~> 0.9'
	  pod 'Nimble', '~> 4.1'
	  pod 'Nocilla', '~> 0.11'
	end
end
