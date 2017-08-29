unless RUBY_ENGINE == 'opal'
  # This helper file borrows from the Bespoke converter
  # https://github.com/asciidoctor/asciidoctor-bespoke
  require 'asciidoctor'

  # Needed only in compile-time.
  require 'slim-htag' if defined? Slim

  if Gem::Version.new(Asciidoctor::VERSION) <= Gem::Version.new('1.5.3')
    fail 'asciidoctor: FAILED: reveal.js backend needs Asciidoctor >=1.5.4!'
  end
end

# This module gets mixed in to every node (the context of the template) at the
# time the node is being converted. The properties and methods in this module
# effectively become direct members of the template.
module Slim::Helpers

  EOL = %(\n)
  SliceHintRx = /  +/

  def slice_text str, active = nil
    if (active || (active.nil? && (option? :slice))) && (str.include? '  ')
      (str.split SliceHintRx).map {|line| %(<span class="line">#{line}</span>) }.join EOL
    else
      str
    end
  end

  def to_boolean val
    val && val != 'false' && val.to_s != '0' || false
  end

  ##
  # This function is from the asciidictor-html5s project
  # https://github.com/jirutka/asciidoctor-html5s/blob/a71db48a1dd5196b668b3a3d93693c5d877c5bf3/data/templates/helpers.rb#L84-L108
  #
  # Creates an HTML tag with the given name and optionally attributes. Can take
  # a block that will run between the opening and closing tags.
  #
  # @param name [#to_s] the name of the tag.
  # @param attributes [Hash] (default: {})
  # @param content [#to_s] the content; +nil+ to call the block. (default: nil).
  # @yield The block of Slim/HTML code within the tag (optional).
  # @return [String] a rendered HTML element.
  #
  def html_tag(name, attributes = {}, content = nil)
    attrs = attributes.inject([]) do |attrs, (k, v)|
      next attrs if !v || v.nil_or_empty?
      v = v.compact.join(' ') if v.is_a? Array
      attrs << (v == true ? k : %(#{k}="#{v}"))
    end
    attrs_str = attrs.empty? ? '' : attrs.join(' ').prepend(' ')


    if VOID_ELEMENTS.include? name.to_s
      %(<#{name}#{attrs_str}>)
    else
      content ||= yield if block_given?
      %(<#{name}#{attrs_str}>#{content}</#{name}>)
    end
  end

end

# More custom functions can be added in another namespace if required
#module Helpers
#end
