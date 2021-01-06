#
# Be sure to run `pod lib lint CTStorage.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'CTStorage'
    s.version          = '0.2.9'
    s.summary          = '基于Realm数据库封装的数据存储库.'
    
    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!
    
    s.description      = <<-DESC
    基于Realm数据库封装的数据存储库.
    DESC
    
    s.homepage         = 'https://github.com/ours-curiosity/CTStorage'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'ghostlordstar' => 'heshanzhang@outlook.com' }
    s.source           = { :git => 'https://github.com/ours-curiosity/CTStorage.git', :tag => s.version.to_s }
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
    
    s.ios.deployment_target = '10.0'
    s.swift_version = '5.0'
    
    s.source_files = 'CTStorage/Classes/**/*'
    
    # s.resource_bundles = {
    #   'CTStorage' => ['CTStorage/Assets/*.png']
    # }
    
    # s.public_header_files = 'Pod/Classes/**/*.h'
    # s.frameworks = 'UIKit', 'MapKit'
    s.dependency 'Realm'
    s.dependency 'RealmSwift'
end
