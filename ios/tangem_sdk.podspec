#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint tangem_sdk.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'tangem_sdk'
  s.version          = '0.0.3'
  s.summary          = 'TangemSdk flutter plugin.'
  s.description      = <<-DESC
TangemSdk plugin for integration into flutter projects
                       DESC
  s.homepage         = 'https://tangem.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Tangem AG' => 'hello@tangem.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.ios.deployment_target = '13.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
  s.dependency 'TangemSdk', "~> 2.4.2"
end
