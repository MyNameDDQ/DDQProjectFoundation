Pod::Spec.new do |s|
  s.name         = 'DDQProjectFoundation'
  s.version      = '1.1.3'
  s.ios.deployment_target = '8.0'
  s.summary      = 'Easy Inherit'
  s.homepage     = 'https://github.com/MyNameDDQ/DDQProjectFoundation'
  s.license      = 'MIT'
  s.author       = { 'DDQ' => '869795924@qq.com' }
  s.source       = { :git => 'https://github.com/MyNameDDQ/DDQProjectFoundation.git', :tag => s.version }
  s.requires_arc = true
  s.dependency 'AFNetworking'
  s.dependency 'SDWebImage'
  s.dependency 'IQKeyboardManager'
  s.dependency 'Masonry'
  s.dependency 'MJRefresh'
  s.dependency 'MJExtension'
  s.dependency 'MBProgressHUD'
  s.dependency 'WebViewJavascriptBridge', '~> 4.1.5'

  s.subspec 'DDQUIFoundation' do |ui|
     ui.source_files = 'DDQProjectFoundation/DDQUIFoundation/DDQFoundation{TableView,TableViewLayout}.{h,m}'
  end
end