Pod::Spec.new do |s|
  s.name         = 'ScrollableViewController'
  s.version      = '0.0.2'
  s.license      =  {:type => 'MIT', :file => 'LICENSE'}
  s.homepage     = 'www.fr4ncis.net'
  s.authors      = {'Francesco Mattia' => 'francesco.mattia@gmail.com'}
  s.summary      = 'Twitter-like Scrollable view controller, subclasses UITabBarController'

# Source Info
  s.platform     =  :ios, '7.0'
  s.source  = { :git => "https://github.com/Fr4ncis/ScrollableViewController.git", :tag => "0.0.2" }
  s.source_files = ['ScrollableViewController/','ScrollableViewController/*.{h,m}']
  s.requires_arc = true
end
