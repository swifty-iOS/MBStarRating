
Pod::Spec.new do |s|
  s.name         = "MBStarRating"
  s.version      = "1.0"
  s.summary      = "MBStarRating help you to creat Horizontal Picker View similar ot UIPcikerView"
  s.homepage     = "https://github.com/swifty-iOS/MBStarRating"
  s.license      = "MIT"
  s.author       = { "Swifty-iOS" => "manishej004@gmail.com" }
  s.ios.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/swifty-iOS/MBStarRating.git", :tag =>s.version }
  s.source_files  = "Source/*.swift"
end