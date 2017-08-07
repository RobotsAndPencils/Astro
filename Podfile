platform :ios, '9.0'

# ignore all warnings from all pods
inhibit_all_warnings!
use_frameworks!

source 'https://github.com/CocoaPods/Specs.git'

target 'Astro' do
    pod "Astro", :path => "."

    # Debugging / Analysis
    pod 'SwiftLint', '~> 0.20'

	target 'AstroTests' do
	  inherit! :search_paths

	  pod 'Quick', '~> 1.1'
	  pod 'Nimble', '~> 7.0', :inhibit_warnings => true
	end
end
