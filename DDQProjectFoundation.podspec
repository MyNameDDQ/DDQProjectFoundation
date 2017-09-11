Pod::Spec.new do |s|
  s.name         = 'DDQProjectFoundation'
  s.version      = '1.1.7'
  s.ios.deployment_target = '8.0'
  s.summary      = 'Easy Inherit'
  s.homepage     = 'https://github.com/MyNameDDQ/DDQProjectFoundation'
  s.license      = 'MIT'
  s.author       = { 'DDQ' => '869795924@qq.com' }
  s.source       = { :git => 'https://github.com/MyNameDDQ/DDQProjectFoundation.git', :tag => s.version }
  s.source_files = 'DDQProjectFoundation/*.{h,m}'

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

     ui.source_files = 'DDQProjectFoundation/DDQUIFoundation/*.{h,m}'

  end

  s.subspec 'DDQCategoryFoundation' do |cat|

    cat.source_files = 'DDQProjectFoundation/DDQCategoryFoundation/*.{h,m}'

  end

end