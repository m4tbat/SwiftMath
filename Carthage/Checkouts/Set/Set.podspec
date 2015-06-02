Pod::Spec.new do |s|
  s.name         = "Set"
  s.version      = "1.2"
  s.summary      = "An implementation of a Dictionary-backed Set in Swift."
  s.homepage     = "https://github.com/robrix/Set"
  s.authors      = { "Rob Rix" => "rob.rix@github.com", "Adam Sharp" => "adsharp@me.com", "Ingmar Stein" => "IngmarStein@gmail.com" }
  s.source       = { :git => "https://github.com/robrix/Set.git", :tag => "1.2" }
  s.ios.deployment_target = "7.0"
  s.osx.deployment_target = "10.9"
  s.source_files = "Set/*.swift"
  s.requires_arc = true
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.description  = <<-DESC
This is a Swift microframework which implements a Dictionary-backed Set.
DESC
end
