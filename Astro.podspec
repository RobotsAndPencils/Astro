#
# Be sure to run `pod lib lint Astro.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Astro"
  s.version      = "6.0.0"
  s.summary          = "A RoboPod containing a small collection of utilities for project reuse"
  s.homepage         = "https://RobotsAndPencils.com"
  s.license      = {
    :type => 'MIT',
    :text => <<-LICENSE
Copyright (c) 2015 Robots and Pencils, Inc. All rights reserved.
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
Neither the name of the Robots and Pencils, Inc. nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission. 
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
    LICENSE
  }
  s.authors           = { 
    "Chad Sykes" => "Chad.Sykes@RobotsAndPencils.com",
    "Colin Gislason" => "Colin.Gislason@RobotsAndPencils.com",
    "Dominic Pepin" => "Dominic.Pepin@RobotsAndPencils.com", 
    "Michael Beaureguard" => "Michael.Beauregard@RobotsAndPencils.com",
    "Stephen Gazzard" => "Stephen.Gazzard@RobotsAndPencils.com"  
  }
  s.source           = { :git => "https://github.com/RobotsAndPencils/Astro.git", :tag => s.version.to_s }

  s.platform     = :ios, '11.0'
  s.requires_arc = true
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.2' }
  
  s.subspec 'Logging' do | log |
    log.source_files = 'Astro/Logging/**/*.swift'
  end

  s.subspec 'Security' do | security |
    security.source_files = 'Astro/Security/**/*.swift'
    security.dependency 'Astro/Logging'
  end

  s.subspec 'UI' do | ui |
    ui.source_files = 'Astro/UI/**/*.swift'
    ui.frameworks = 'UIKit'
  end

  s.subspec 'Utils' do | utils |
    utils.source_files = 'Astro/Utils/**/*.swift'
  end

end
