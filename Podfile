platform :ios, '11.0'

# ignore all warnings from all pods
inhibit_all_warnings!
use_frameworks!

source 'https://github.com/CocoaPods/Specs.git'

target 'Astro' do
    pod "Astro", :path => "."

    # Debugging / Analysis
    pod 'SwiftLint', '~> 0.32.0'

	target 'AstroTests' do
	  inherit! :search_paths

	  pod 'Quick', '~> 2.1.0'
	  pod 'Nimble', '~> 8.0.1'
	end
end
