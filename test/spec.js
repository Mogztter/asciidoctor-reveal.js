var asciidoctor = require('asciidoctor.js')();
require('asciidoctor-template.js'); // Asciidoctor Template
require('../build/asciidoctor-revealjs.js'); // Asciidoctor Reveal.js
var assert = require('assert');

describe('Rendering', function () {

  it('should produce a Reveal.js presententation when backend=revealjs', function () {
    var options = {safe: 'safe', backend: 'revealjs'};
    var content = `= Title\n\n\
== Slide 1\n\n\
Content 1\n\n\
== Slide 2\n\n\
Content 2`;
    var html = asciidoctor.convert(content, options);
    assert.equal(html, `<div class="sect1">\n\
<h2 id="_slide_1">Slide 1</h2>\n\
<div class="sectionbody">\n\
<div class="paragraph">\n\
<p>Content 1</p>\n\
</div>\n\
</div>\n\
</div>\n\
<div class="sect1">\n\
<h2 id="_slide_2">Slide 2</h2>\n\
<div class="sectionbody">\n\
<div class="paragraph">\n\
<p>Content 2</p>\n\
</div>\n\
</div>\n\
</div>`);
  });

  it('should produce a Reveal.js presententation containing audio block', function () {
    var options = {safe: 'safe', backend: 'revealjs', to_file: false};
    var html = asciidoctor.convertFile('./test/audio.adoc', options);
    assert.equal(html, `<div class="sect1">\n\
<h2 id="_default">Default</h2>\n\
<div class="sectionbody">\n\
<div class="audioblock">\n\
<div class="content">\n\
<audio src="ocean_waves.mp3" controls>\n\
Your browser does not support the audio tag.\n\
</audio>\n\
</div>\n\
</div>\n\
</div>\n\
</div>\n\
<div class="sect1">\n\
<h2 id="_autoplay_and_loop">Autoplay and loop</h2>\n\
<div class="sectionbody">\n\
<div class="audioblock">\n\
<div class="content">\n\
<audio src="ocean_waves.mp3" autoplay controls loop>\n\
Your browser does not support the audio tag.\n\
</audio>\n\
</div>\n\
</div>\n\
</div>\n\
</div>`);
  });
});
