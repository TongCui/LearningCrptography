platform :ios, '10.0'
use_frameworks!

projectname = Dir.entries('.').find {|x| x.end_with? "xcodeproj"}.split(".").first


target projectname do
  pod 'RxSwift',    '~> 3.0'
  pod 'RxCocoa',    '~> 3.0'
end
