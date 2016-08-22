platform :ios, '8.0'

# ignore all warnings from all pods
inhibit_all_warnings!
use_frameworks!

source 'https://github.com/CocoaPods/Specs.git'

target 'Astro' do
    pod "Astro", :path => "."

	target 'AstroTests' do
	  inherit! :search_paths

	  pod 'Quick', '~> 0.9'
	  pod 'Nimble', '~> 3.2'
	  pod 'Nocilla', '~> 0.10'
	end
end
