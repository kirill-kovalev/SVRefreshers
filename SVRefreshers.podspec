#
#  Be sure to run `pod spec lint SVRefreshers.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#
Pod::Spec.new do |s|
  s.name                  = "SVRefreshers"
  s.version               = "0.0.1"
  s.summary               = "Example of creating own pod."
  s.homepage              = "https://github.com/kirill-kovalev/SVRefreshers"
  s.license               = { :type => 'MIT', :file => 'LICENSE' }
  s.author                = { "Kovalev Kirill" => "mail@kovalev-kirill.ru" }
  s.platform              = :ios, '11.0'
  s.source                = { :git => "git@github.com:kirill-kovalev/SVRefreshers.git", :tag => s.version.to_s }
  s.source_files          = ['ScrollViewRefreshers/*.{swift}','ScrollViewRefreshers/Views/*.{swift}']

  s.framework             = 'UIKit'
  s.requires_arc          = true
end
