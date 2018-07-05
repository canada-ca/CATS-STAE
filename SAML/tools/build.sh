#!/bin/bash

# Clone the latest Kantara saml2iop sources
echo -n "Obtaining the latest Kantara specifications..."
if [[ -d ./Kantara ]] ; then
   pushd ./Kantara > /dev/null
   git pull
   popd > /dev/null
else
   mkdir Kantara
   pushd ./Kantara > /dev/null
   git clone https://github.com/KantaraInitiative/SAMLprofiles.git
   popd > /dev/null
fi
echo "Done"

# Merge in CATS contraints
if [[ -d ./merged ]] ; then
   rm -rf ./merged/*
else
   mkdir merged
fi

echo -n "Merging in CATS constraints..."
pushd ./Kantara/SAMLProfiles/edit/saml2int  > /dev/null
FILES=$(find . -name '*requirements.adoc' -print)
popd > /dev/null

for FILE in $FILES ; do
   ./tools/merge.sh < ./Kantara/SAMLProfiles/edit/saml2int/$FILE \
                   > ./merged/$FILE
done

echo "Done"

# Publish to HTML and PDF
echo -n "Producing HTML..."
cp -R ./src/images ../docs
docker run --rm -v $(pwd)/..:/documents/ asciidoctor/docker-asciidoctor \
   asciidoctor --source-dir SAML/src --destination-dir docs \
   -o saml2cred.html SAML/src/main.adoc

echo -n "Producing PDF..."
docker run --rm -v $(pwd)/..:/documents/ asciidoctor/docker-asciidoctor \
   asciidoctor-pdf --source-dir SAML/src --destination-dir docs \
   -a pdf-stylesdir=./tools -a pdf-style=cats \
   -o saml2cred.pdf SAML/src/main.adoc

echo "Done"
