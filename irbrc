require 'rubygems' unless defined? Gem
require 'irb/completion'

# http://blog.nicksieger.com/articles/2006/04/23/tweaking-irb
# IRB Completion
ARGV.concat [ "--readline", "--prompt-mode", "simple"]

# Wirble
begin
	require 'wirble'

	Wirble.init
	Wirble.colorize
rescue LoadError => err
	$stderr.puts "Couldn't load Wirble: #{err}"
end
