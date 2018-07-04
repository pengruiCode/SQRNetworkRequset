Pod::Spec.new do |s|

  s.name         = "SQRNetworkRequset"
  s.version      = "0.1.2"
  s.summary  	 = '网络请求'
  s.homepage     = "https://github.com/pengruiCode/SQRNetworkRequset.git"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = {'pengrui' => 'pengruiCode@163.com'}
  s.source       = { :git => 'https://github.com/pengruiCode/SQRNetworkRequset.git', :tag => s.version}
  s.platform 	 = :ios, "8.0"
  s.source_files = "SQRNetworkRequset/**/*.{h,m}"
  s.resource     = "SQRNetworkRequset/LoginLoseEfficacyView.xib"
  s.requires_arc = true
  s.description  = <<-DESC
			简易网络请求，依赖YYCaache实现缓存
                   DESC
  s.subspec "YYCache" do |ss|
     ss.dependency "YYCache"
  end

  s.subspec "AFNetworking" do |ss|
     ss.dependency "AFNetworking"
  end

  s.subspec "SQRBaseDefineWithFunction" do |ss|
     ss.dependency "SQRBaseDefineWithFunction"
  end

 end