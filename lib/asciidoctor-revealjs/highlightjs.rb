# frozen_string_literal: true
module Asciidoctor
  module Revealjs
    module SyntaxHighlighter
      # Override the built-in highlight.js syntax highlighter
      class HighlightJsAdapter < Asciidoctor::SyntaxHighlighter::Base
        register_for 'highlightjs', 'highlight.js'

        HIGHLIGHT_JS_VERSION = '10.5.0'

        def initialize *args
          super
          @name = @pre_class = 'highlightjs'
        end

        # Convert between highlight notation formats
        # In addition to Asciidoctor's linenum converter leveraging core's resolve_lines_to_highlight,
        # we also support reveal.js step-by-step highlights.
        # The steps are split using the | character
        # For example, this method makes "1..3|6,7" into "1,2,3|6,7"
        def _convert_highlight_to_revealjs node
          return node.attributes["highlight"].split("|").collect { |linenums|
            node.resolve_lines_to_highlight(node.content, linenums).join(",")
          }.join("|")
        end

        def format node, lang, opts
          super node, lang, (opts.merge transform: proc { |_, code|
            code['class'] = %(language-#{lang || 'none'} hljs)
            code['data-noescape'] = true

            if node.attributes.key?("highlight")
              code['data-line-numbers'] = self._convert_highlight_to_revealjs(node)
            elsif node.attributes.key?("linenums")
              code['data-line-numbers'] = ''
            end
          })
        end

        def docinfo? location
          location == :footer
        end

        def docinfo location, doc, opts
          if RUBY_ENGINE == 'opal' && JAVASCRIPT_PLATFORM == 'node'
            revealjsdir = (doc.attr :revealjsdir, 'node_modules/reveal.js')
          else
            revealjsdir = (doc.attr :revealjsdir, 'reveal.js')
          end
          if doc.attr? 'highlightjs-theme'
            theme_href = doc.attr 'highlightjs-theme'
          else
            theme_href = "#{revealjsdir}/plugin/highlight/monokai.css"
          end
          base_url = doc.attr 'highlightjsdir', %(#{opts[:cdn_base_url]}/highlight.js/#{HIGHLIGHT_JS_VERSION})
          %(<link rel="stylesheet" href="#{theme_href}"#{opts[:self_closing_tag_slash]}>
<script src="#{base_url}/highlight.min.js"></script>
#{(doc.attr? 'highlightjs-languages') ? ((doc.attr 'highlightjs-languages').split ',').map {|lang| %[<script src="#{base_url}/languages/#{lang.lstrip}.min.js"></script>\n] }.join : ''}
<script src="#{revealjsdir}/plugin/highlight/highlight.js"></script>
<script>Reveal.registerPlugin(RevealHighlight)</script>)
        end
      end
    end
  end
end
