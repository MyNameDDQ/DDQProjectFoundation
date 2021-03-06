
Pod::Spec.new do |s|
  s.name         = 'DDQProjectFoundation'
  s.version      = '1.3.1'
  s.ios.deployment_target = '8.0'
  s.summary      = 'Easy Inherit'
  s.homepage     = 'https://github.com/MyNameDDQ/DDQProjectFoundation.git'
  s.license      = 'MIT'
  s.author       = { 'DDQ' => '869795924@qq.com' }
  s.source       = { :git => 'https://github.com/MyNameDDQ/DDQProjectFoundation.git', :tag => s.version }
  s.source_files = 'DDQProjectFoundation/*.{h,m}'
  #s.public_header_files = 'DDQProjectFoundation/DDQFoundationHeader.h'
  s.resource = 'DDQProjectFoundation/DDQFoundationSource.bundle'

  s.requires_arc = true
  s.dependency 'AFNetworking'
  s.dependency 'SDWebImage'
  s.dependency 'IQKeyboardManager'
  s.dependency 'Masonry'
  s.dependency 'MJRefresh'
  s.dependency 'MJExtension'
  s.dependency 'MBProgressHUD'
  s.dependency 'FMDB'
  s.dependency 'WebViewJavascriptBridge', '~> 4.1.5'

  s.subspec 'DDQFoundationDefine' do |define|

    define.source_files = 'DDQProjectFoundation/DDQFoundationDefine/*.h'
    define.public_header_files = 'DDQProjectFoundation/DDQFoundationDefine/*.h'

  end

  s.subspec 'DDQUIFoundation' do |ui|

    ui.source_files = 'DDQProjectFoundation/DDQUIFoundation/*.{h,m}'
    ui.public_header_files = 'DDQProjectFoundation/DDQUIFoundation/*.h'
    ui.dependency 'DDQProjectFoundation/DDQFoundationDefine'
    ui.dependency 'DDQProjectFoundation/DDQCategoryFoundation'
    ui.dependency 'DDQProjectFoundation/DDQModelFoundation'

  end

  s.subspec 'DDQCategoryFoundation' do |category|

    category.source_files = 'DDQProjectFoundation/DDQCategoryFoundation/*.{h,m}'
    category.public_header_files = 'DDQProjectFoundation/DDQCategoryFoundation/*.h'

  end

  s.subspec 'DDQControllerFoundation' do |controller|

    controller.source_files = 'DDQProjectFoundation/DDQControllerFoundation/*.{h,m}'
    controller.public_header_files = 'DDQProjectFoundation/DDQControllerFoundation/*.h'
    controller.dependency 'DDQProjectFoundation/DDQUIFoundation'
    controller.dependency 'DDQProjectFoundation/DDQCategoryFoundation'
    #controller.dependency 'DDQProjectFoundation/DDQFoundationDefine'

  end

  s.subspec 'DDQModelFoundation' do |model|

    model.source_files = 'DDQProjectFoundation/DDQModelFoundation/*.{h,m}'
    model.public_header_files = 'DDQProjectFoundation/DDQModelFoundation/*.h'
    
  end


end