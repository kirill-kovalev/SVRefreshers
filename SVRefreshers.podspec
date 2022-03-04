#
# Be sure to run `pod lib lint SVRefreshers.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SVRefreshers'
  s.version          = '0.1.1'
  s.summary          = 'A short description of SVRefreshers.'

  s.homepage         = 'https://github.com/kirill-kovalev/SVRefreshers'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Kirill Kovalev' => 'kirilkovalev@yandex.ru' }
  s.source           = { :git => 'https://github.com/kirill-kovalev/SVRefreshers.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.swift_version = '5.0'

  s.source_files = 'SVRefreshers/**/*'

  s.frameworks = 'UIKit'
  s.requires_arc     = true;
end
