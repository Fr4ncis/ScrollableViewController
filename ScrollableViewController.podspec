Pod::Spec.new do |s|
  s.name         = 'ScrollableViewController'
  s.version      = '0.0.1'
  s.license      =  {:type => 'MIT'}
  s.homepage     = 'www.fr4ncis.net'
  s.authors      = {'Francesco Mattia' => 'francesco.mattia@gmail.com'}
  s.summary      = 'Twitter-like Scrollable view controller, subclasses UITabBarController'

# Source Info
  s.platform     =  :ios, '7.0'
  s.source       =  {:path => './ScrollableViewController/'}
  s.source_files = ['ScrollableViewControllerDemo/ScrollableViewController/ScrollableViewController.{h,m}','ScrollableViewControllerDemo/ScrollableViewController/PageControl.{h,m}']
  s.requires_arc = true
end
