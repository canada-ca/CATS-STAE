#!/bin/bash

# Clone the latest Kantara saml2iop sources
echo -n "Obtaining the latest Kantara specifications..."
if [[ -d ./Kantara ]] ; then
   pushd ./Kantara/SAMLProfiles > /dev/null
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

pushd ./Kantara/SAMLProfiles/edit/saml2int  > /dev/null
FILES=$(find . -name '*requirements.adoc' -print)
popd > /dev/null

for spec in cred id ; do
    echo "Producing ${spec}auth..."

    pushd ./src/${spec}auth > /dev/null

    echo -n "Merging in CATS constraints..."
    if [[ -d ../../merged ]] ; then
    rm -rf ../merged/*
    else
    mkdir ../../merged
    fi

    for FILE in $FILES ; do
    ../../tools/merge.sh < ../../Kantara/SAMLProfiles/edit/saml2int/$FILE \
                    > ../../merged/$FILE
    done

    popd > /dev/null

    echo "Done"

    # Publish to HTML and PDF
    touch ./src/${spec}auth/main.adoc
    echo -n "Producing HTML..."
    cp -R ./src/${spec}auth/images ../docs
    docker run --rm -v $(pwd)/..:/documents/ asciidoctor/docker-asciidoctor \
    asciidoctor --source-dir SAML/src/${spec}auth --destination-dir docs \
    -o saml2${spec}.html SAML/src/${spec}auth/main.adoc

    echo -n "Producing PDF..."
    docker run --rm -v $(pwd)/..:/documents/ asciidoctor/docker-asciidoctor \
    asciidoctor-pdf --source-dir SAML/src/${spec}auth --destination-dir docs \
    -a pdf-stylesdir=./SAML/tools -a pdf-style=cats \
    -o saml2${spec}.pdf SAML/src/${spec}auth/main.adoc

    echo "Done"
done