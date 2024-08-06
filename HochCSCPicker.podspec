#
#  Be sure to run `pod spec lint HochCSCPickerView.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

 
  #

  spec.name         = "HochCSCPicker"
  spec.version      = "1.0.0"
  spec.summary      = "HochCSCPickerView framework for swift."


  spec.description  = <<-DESC 
  HochCSCPickerView framework use for select country state city with filter.
                   DESC

  spec.homepage     = "https://github.com/khushalhoch23/HochCSCPicker"


  spec.license      = "MIT"


  spec.author             = { "khushalhoch23" => "138425672+khushalhoch23@users.noreply.github.com" }

  spec.source       = { :git => 'https://github.com/khushalhoch23/HochCSCPicker.git', :tag => spec.version.to_s }

  
  spec.platform     = :ios, '13.0'
  spec.source_files  = 'HochCSCPickerView/**/*.{h,m,swift}'
  spec.swift_version = '5.0'


end
