Pod::Spec.new do |s|
  s.name         = "TimeIntervals"
  s.version      = "0.2.0"
  s.summary      = "Type-safe time calculations for Swift."
  s.description  = <<-DESC
    Type-safe time calculations for Swift, powered by generics.
  DESC
  s.homepage     = "https://github.com/dreymonde/Time"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Oleg Dreyman" => "dreymonde@me.com" }
  s.social_media_url   = "https://twitter.com/olegdreyman"
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/dreymonde/Time.git", :tag => s.version.to_s }
  s.source_files  = "Sources/**/*"
  s.frameworks  = "Foundation"
end
