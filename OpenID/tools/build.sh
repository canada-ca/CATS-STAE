#!/bin/bash

# Publish to HTML and PDF
touch ./src/main.adoc
echo -n "Producing HTML..."
cp -R ./src/images ../docs
docker run --rm -v $(pwd)/..:/documents/ asciidoctor/docker-asciidoctor \
asciidoctor --source-dir OpenID/src --destination-dir docs \
-o oidc1.html OpenID/src/main.adoc

echo -n "Producing PDF..."
docker run --rm -v $(pwd)/..:/documents/ asciidoctor/docker-asciidoctor \
asciidoctor-pdf --source-dir OpenID/src --destination-dir docs \
-a pdf-stylesdir=./SAML/tools -a pdf-style=cats \
-o oidc1.pdf OpenID/src/main.adoc

echo "Done"
