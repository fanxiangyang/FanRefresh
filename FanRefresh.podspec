#
#  Be sure to run `pod spec lint FanKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "FanRefresh"
  s.version      = "0.0.1"
  s.summary      = "A swift Refresh control ."
  s.description  = <<-DESC
            一个swift 的刷新控件，下拉刷新，上拉加载
                   DESC

  s.homepage     = "https://github.com/fanxiangyang/FanRefresh"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "fanxiangyang" => "fanxiangyang_heda@163.com" }
  # s.social_media_url   = "http://twitter.com/fanxiangyang"

  s.platform     = :ios, "8.0"

  s.ios.deployment_target = "8.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/fanxiangyang/FanRefresh.git", :tag => s.version.to_s }

  # s.source_files  = "Classes/FanKit.h","Classes/FanKitHead.h"
  #s.exclude_files = "Classes/Exclude"

  # s.public_header_files = "Classes/FanKit.h","Classes/FanKitHead.h"

  # s.resources  = "icon.png"
  s.resources = "Classes/Refresh/FanRefresh.bundle"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"

  #s.frameworks = "UIKit", "QuartzCore"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

  s.subspec 'Refresh' do |ss|
    ss.source_files  = "Classes/Refresh/*.swift"
    ss.frameworks = "UIKit", "Foundation"
  end

  s.subspec 'Header' do |ss|
    ss.source_files = 'Classes/Header/*.swift'
    ss.frameworks = "UIKit","Foundation"
  end

  s.subspec 'Footer' do |ss|
    ss.source_files = 'Classes/Footer/*.swift'
    ss.frameworks = "UIKit","Foundation"
  end

end




