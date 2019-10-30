#!/bin/bash

# Clone the latest Kantara saml2iop sources
echo -n "Obtaining the latest Kantara specifications..."
if [[ -d ./Kantara ]] ; then
   pushd ./Kantara/SAMLprofiles > /dev/null
   git pull
   popd > /dev/null
else
   mkdir Kantara
   pushd ./Kantara > /dev/null
   git clone https://github.com/KantaraInitiative/SAMLprofiles.git
   popd > /dev/null
fi
echo "Done"

# Enumerate the upstream requirements files

pushd ./Kantara/SAMLprofiles/edit/saml2int  > /dev/null
FILES=$(find . -name '*requirements.adoc' -print)
popd > /dev/null

echo -n "Merging in CATS constraints..."
if [[ -d ./merged ]] ; then
rm -rf ./merged/*
else
mkdir ./merged
fi

for FILE in $FILES ; do
./tools/merge.sh < ./Kantara/SAMLprofiles/edit/saml2int/$FILE \
                > ./merged/$(cut -d "." -f2 <<< $FILE)-en.adoc
done

echo "Done"

# Publish to HTML and PDF
touch ./src/main-en.adoc
echo -n "Producing HTML..."
cp -R ./src/images ../docs
docker run --rm -v $(pwd)/..:/documents/ asciidoctor/docker-asciidoctor \
asciidoctor --source-dir SAML/src/ --destination-dir docs \
-o saml2-en.html SAML/src//main-en.adoc

echo -n "Producing PDF..."
docker run --rm -v $(pwd)/..:/documents/ asciidoctor/docker-asciidoctor \
asciidoctor-pdf --source-dir SAML/src/ --destination-dir docs \
-a pdf-stylesdir=./SAML/tools -a pdf-style=cats \
-o saml2-en.pdf SAML/src/main-en.adoc

echo "Done"
