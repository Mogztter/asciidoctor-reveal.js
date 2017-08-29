#!/usr/bin/env rake

require 'asciidoctor'
require 'asciidoctor/doctest'
require 'colorize'
require 'thread_safe'
require 'tilt'

CONVERTER_FILE = 'lib/asciidoctor-revealjs/converter.rb'
# TODO if this experiment works, move everything under templates, no more slim/
TEMPLATES_DIR = 'templates/slim'

namespace :build do

  file CONVERTER_FILE, [:mode] => FileList["#{TEMPLATES_DIR}/*"] do |t, args|
    #require 'asciidoctor-templates-compiler'
    require_relative 'lib/asciidoctor-templates-compiler'
    require 'slim-htag'

    File.open(CONVERTER_FILE, 'w') do |file|
      $stderr.puts "Generating #{file.path}."
      Asciidoctor::TemplatesCompiler::RevealjsSlim.compile_converter(
          templates_dir: TEMPLATES_DIR,
          class_name: 'Asciidoctor::Revealjs::Converter',
          register_for: ['revealjs'],
          backend_info: {
            basebackend: 'html',
            outfilesuffix: '.html',
            filetype: 'html',
          },
          pretty: (args[:mode] == :pretty),
          output: file)
    end
  end

  namespace :converter do
    desc 'Compile Slim templates and generate converter.rb (pretty mode)'
    task :pretty do
      Rake::Task[CONVERTER_FILE].invoke(:pretty)
    end

    desc 'Compile Slim templates and generate converter.rb (fast mode)'
    task :fast do
      Rake::Task[CONVERTER_FILE].invoke
    end
  end

  task :converter => 'converter:pretty'
end

task :build => 'build:converter:pretty'

task :clean do
  rm_rf CONVERTER_FILE
end

DocTest::RakeTasks.new do |t|
  t.output_examples :html, path: 'test/output/slim'
  t.input_examples :asciidoc, path: [ *DocTest.examples_path, 'examples' ]
  t.converter = DocTest::HTML::Converter
  t.converter_opts = { template_dirs: 'templates/slim' }
end

namespace :examples do
  desc 'Converts all the test slides into fully working examples that you can look in a browser'
  # converted slides will be put in examples/ directory
  task :convert do
    Dir.glob('examples/*.adoc') do |_file|
      print "Converting file #{_file}... "
      out = Asciidoctor.convert_file _file,
        :safe => 'safe',
        :backend => 'revealjs',
        :base_dir => 'examples',
        :template_dir => 'templates/slim'
      if out.instance_of? Asciidoctor::Document
        puts "✔️".green
      else
        puts "✖️".red
      end
    end
  end
end

# When no task specified, run test.
task :default => :doctest
