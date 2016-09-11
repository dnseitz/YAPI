Pod::Spec.new do |spec|
  spec.name = "YAPI"
  spec.version = "0.1.0"
  spec.summary = "A Yelp API wrapper in swift"
  spec.homepage = "https://github.com/dnseitz/YAPI"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Daniel Seitz" => 'dnseitz@gmail.com' }

  spec.platform = :ios, "9.3"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/dnseitz/YAPI.git", tag: "v#{spec.version}", submodules: true }
  spec.source_files = "{YAPI,OAuthSwift}/**/*.{h,swift}"
end
