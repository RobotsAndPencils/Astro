def workspace
  return 'Astro.xcworkspace'
end

def configuration
  return 'Debug'
end

def targets
  return [
    :ios,
    # :tvos # Note: we're omiting this until Circle supports testing on tvOS simulators.
  ]
end

def schemes
  return {
    ios: 'Astro',
    tvos: 'Astro'
  }
end

def sdks
  return {
    ios: 'iphonesimulator',
    tvos: 'appletvsimulator9.2'
  }
end

def devices
  return {
    ios: "platform='iOS Simulator',OS='9.3',name='iPhone 6s'",
    tvos: "name='Apple TV 1080p'"
  }
end

def xcodebuild_astro(tasks, platform, xcpretty_args: '')
  sdk = sdks[platform]
  scheme = schemes[platform]
  destination = devices[platform]

  sh "set -o pipefail && xcodebuild CODE_SIGNING_REQUIRED=NO CODE_SIGN_IDENTITY=  PROVISIONING_PROFILE=  -workspace '#{workspace}' -scheme '#{scheme}' -sdk #{sdk} -destination #{destination} #{tasks} | xcpretty -c #{xcpretty_args}"
end

desc 'Build the Astro framework.'
task :build do
  xcodebuild_astro 'build', :ios
end

desc 'Clean build directory.'
task :clean do
  xcodebuild_astro 'clean', :ios
end

desc 'Build, then run tests.'
task :test do
  targets.map { |platform| xcodebuild_astro 'build test', platform, xcpretty_args: '--test' }
  sh "killall Simulator"
end

desc 'Release a version, specified as an argument.'
task :release, :version do |task, args|
  version = args[:version]
  abort "You must specify a version in semver format." if version.nil? || version.scan(/\d+\.\d+\.\d+/).length == 0

  puts "Updating podspec."
  filename = "Astro.podspec"
  contents = File.read(filename)
  contents.gsub!(/s\.version\s*=\s"\d+\.\d+\.\d+"/, "s.version      = \"#{version}\"")
  File.open(filename, 'w') { |file| file.puts contents }

  puts "Comitting, tagging, and pushing."
  message = "Releasing version #{version}."
  sh "git commit -am '#{message}'"
  sh "git tag #{version} -m '#{message}'"
  sh "git push --follow-tags"

  puts "Pushing to Astro.podspec"
  sh "pod trunk push Astro.podspec"

  puts "Pushing as a GitHub Release."
  require 'octokit'
  Octokit::Client.new(netrc: true).
    create_release('RobotsAndPencils/Astro',
                   version,
                   name: version)
end
