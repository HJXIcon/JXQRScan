Pod::Spec.new do |s|

s.name         = "JXQRScan"
s.version      = "1.0.0"
s.summary      = "二维码扫描"

s.homepage     = "https://github.com/HJXIcon/JXQRScan"

s.license      = "MIT"

s.author       = { "HJXIcon" => "x1248399884@163.com" }

s.platform     = :ios
s.platform     = :ios, "8.0"


s.source       = { :git => "https://github.com/HJXIcon/JXQRScan.git", :tag => s.version}

s.source_files  = "JXQRScan/JXQRScan/**/*.{h,m}"

s.resource     = "JXQRScan/JXQRScan/JXQRScan.bundle"

s.requires_arc = true

end



