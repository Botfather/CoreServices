#
#  Be sure to run `pod spec lint WebserviceManager.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name            = "CoreServices"
  s.version         = "1.0"
  s.summary         = "CoreServices manager in Objective-C"

  s.description     = <<-DESC
Embed this as a local pod in project. Define the end points in Endpoints.json file.
                   DESC

  s.license         = "Commerical"

  s.homepage        = "botfather.github.io"

  s.author          = { "Tushar Mohan" => "mohan.tushar@outlook.com" }

  s.platform        = :ios, "9.0"
  s.source          = { :path => "." }
  s.source_files    = "**/*.{h,m}"
  s.resource        = "**/*.{json}"
end
