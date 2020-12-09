Pod::Spec.new do |s|
s.name        = 'DTool'
s.version     = '3.0.0'
s.authors     = { 'CYC666' => '13705038428@163.com' }
s.homepage    = 'https://github.com/CYC666/DTool'
s.summary     = 'a tool'
s.source      = { :git => 'https://github.com/CYC666/DTool.git', :tag => s.version }
s.license     = { :type => "MIT", :file => "LICENSE" }

s.platform = :ios, '11.0'
s.requires_arc = true
s.source_files = 'DTool'
s.public_header_files = 'DTool/*.h'

s.ios.deployment_target = '7.0'


end
