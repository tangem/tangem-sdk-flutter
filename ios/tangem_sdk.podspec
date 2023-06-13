#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint tangem_sdk.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'tangem_sdk'
  s.version          = '0.8.0'
  s.summary          = 'TangemSdk flutter plugin.'
  s.description      = <<-DESC
TangemSdk plugin for integration into flutter projects
                       DESC
  s.homepage         = 'https://tangem.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
  s.dependency 'TangemSdk', '~> 3.8.0'
end
