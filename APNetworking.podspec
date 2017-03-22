
Pod::Spec.new do |s|
  s.name         = "APNetworking"
  s.version      = "1.0.0"
  s.summary      = "A convenient way to make Rest API calls."
  s.description  = <<-DESC
  A convenient way to make Rest API calls and parse data from JSON responses.
                   DESC

  s.homepage     = "https://github.com/paleksandrs/APNetworking"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       =   "Aleksandrs Proskurins"
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/paleksandrs/APNetworking.git", :tag => "1.0.0" }
  s.source_files =  "APNetworking/*.swift"
end
