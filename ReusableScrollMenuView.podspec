#
# Be sure to run `pod lib lint ReusableScrollMenuView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ReusableScrollMenuView'
  s.version          = '0.1.0'
  s.summary          = 'Horizontal scrollable menu for UITableView header.'
  s.description      = 'Horizontal scrollable menu for UITableView header. Customizable, Flexable, etc...'
  s.homepage         = 'https://github.com/deholic/ReusableScrollMenuView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'KIM EUIGYOM' => 'deholexp@gmail.com' }
  s.source           = { :git => 'https://github.com/deholic/ReusableScrollMenuView.git', :tag => s.version.to_s }
  s.ios.deployment_target = '10.0'
  s.source_files     = 'ReusableScrollMenuView/Classes/**/*'
  s.swift_version    = '5.0'
  s.frameworks       = 'UIKit'
  
  s.dependency 'SnapKit'
end
