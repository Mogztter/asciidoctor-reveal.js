#!/bin/bash
set -e
set -x

REVEALJS_DIR=/home/guillaume/workspace/opensource/asciidoctor/asciidoctor-reveal.js
NEO4J_DIR=/home/guillaume/workspace/neo4j/neo4j-training

bundle exec "$REVEALJS_DIR/bin/asciidoctor-revealjs" \
 "$NEO4J_DIR/docs/presentations/04_IntroductionToCypher.adoc" \
 -r "$NEO4J_DIR/resources/ext/rouge_cypher_lexer.rb" \
 -r "$NEO4J_DIR/resources/ext/rouge_neo_theme.rb" \
 -r "$NEO4J_DIR/resources/ext/rouge_neo_forest_theme.rb" \
 -r "$NEO4J_DIR/resources/ext/inline_code_rouge_highlighter.rb" \
 --trace

cp "$NEO4J_DIR/docs/presentations/04_IntroductionToCypher.html" "$NEO4J_DIR/build/gradle/slides/04_IntroductionToCypher.html"
cp "$NEO4J_DIR/resources/themes/reveal.css" "$NEO4J_DIR/build/gradle/slides/themes/reveal.css"
cp "$NEO4J_DIR"/resources/img/* "$NEO4J_DIR/build/gradle/slides/img"
