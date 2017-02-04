platform :ios, '9.0'

# ignore all warnings from all pods
inhibit_all_warnings!
use_frameworks!

source 'https://github.com/CocoaPods/Specs.git'

target 'Astro' do
    pod "Astro", :path => "."

	target 'AstroTests' do
	  inherit! :search_paths

	  pod 'Quick', '~> 0.10'
	  pod 'Nimble', '~> 5.0'
	end
end
