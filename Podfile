platform :ios, '11.0'

# ignore all warnings from all pods
inhibit_all_warnings!
use_frameworks!

source 'https://github.com/CocoaPods/Specs.git'

target 'Astro' do
    pod "Astro", :path => "."

    # Debugging / Analysis
    pod 'SwiftLint', '~> 0.30.1'

	target 'AstroTests' do
	  inherit! :search_paths

	  pod 'Quick', '~> 1.3.4'
	  pod 'Nimble', '~> 7.3.4', :inhibit_warnings => true
	end
end
