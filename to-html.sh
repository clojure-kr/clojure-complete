mkdir -p public
asciidoctor -R . -D public -a stylesheet=my-asciidoctor.css clojure-complete-html.adoc **/*.adoc
mv public/clojure-complete-html.html public/index.html
cp asciidoctor.css public
#asciidoctor clojure-complete-html.adoc **/*.adoc
#mv clojure-complete-html.html index.html
