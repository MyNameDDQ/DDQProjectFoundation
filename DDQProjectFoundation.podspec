Pod::Spec.new do |s|
  s.name         = "DDQProjectFoundation"
  s.version      = "1.0.0"
  s.ios.deployment_target = '7.0'
  s.summary      = "Easy Inherit"
  s.homepage     = "https://github.com/MyNameDDQ/DDQProjectFoundation"
  s.license      = "MIT"
  s.author       = { "DDQ" => "869795924@qq.com" }
  s.source       = { :git => "https://github.com/MyNameDDQ/DDQProjectFoundation.git", :tag => s.version }
  s.source_files = "DDQProjectFoundation/*.{h,m}"
  s.requires_arc = true
  s.dependency 'AFNetworking'
  s.dependency 'SDWebImage'
  s.dependency 'IQKeyboardManager'
  s.dependency 'Masonry'
  s.dependency 'MJRefresh'
  s.dependency 'MJExtension'
  s.dependency 'MBProgressHUD'
  s.dependency 'WebViewJavascriptBridge'

end