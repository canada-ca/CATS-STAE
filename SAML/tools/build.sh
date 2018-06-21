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

# Publish to HTML and PDF
if [[ -d ./publish ]] ; then
   rm -rf ./publish/*
else
   mkdir publish
fi
echo "Done"

echo -n "Producing HTML..."
docker run -v $(pwd):/documents/ asciidoctor/docker-asciidoctor \
   asciidoctor --source-dir ./src --destination-dir ./publish src/main.adoc

echo -n "Producing PDF..."
docker run --rm -v $(pwd):/documents/ asciidoctor/docker-asciidoctor \
   asciidoctor-pdf --source-dir ./src --destination-dir ./publish \
   -a pdf-stylesdir=./tools -a pdf-style=cats \
   src/main.adoc

echo "Done"
