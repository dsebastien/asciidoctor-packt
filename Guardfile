require 'asciidoctor'
require 'erb'

DESTINATION_DIR="./dist"

guard 'shell' do
  watch(/^.*\.adoc$/) {|m|
  	puts "Looking at " << m[0]
  	puts "Time to rebuild " << m[0]
	system("bash build.sh clean_assets")
	system("bash build.sh copy_assets")
  	Asciidoctor.convert_file(
		m[0],
		:to_dir => DESTINATION_DIR,
		:safe => Asciidoctor::SafeMode::UNSAFE,
		:attributes => {
			'allow-uri-read' => '',
			'copycss' => ''
		}
	)
  }
end

# TODO:  If you want to convert 1/fragment_01.txt (etc.) into 1/processed_fragment_01.txt, plugin your custom script.
#guard 'shell' do
#  watch(/^(.*)\/(fragment_.*\.txt)$/) {|m|
#    puts "Time to rebuild #{m[1]}/#{m[2]}"
     #system("my_script_to_convert < #{m[1]}/#{m[2]} > #{m[1]}/processed_#{m[2]}")
#  }
#end
