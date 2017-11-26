Pod::Spec.new do |s|
  s.name             = 'Qwolm'
  s.version          = '0.1.0'
  s.summary          = 'Queue where only last matters.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A simple utility for handling cases when:
- new calls of a long-running task may arrive before it is completed;
- only the result of the last call matters.
                       DESC

  s.homepage         = 'https://github.com/wacumov/Qwolm'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Mikhail Akopov' => 'mikhail.akopov@aol.com' }
  s.source           = { :git => 'https://github.com/wacumov/Qwolm.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.3'

  s.source_files = 'Qwolm/Classes/**/*'
end
