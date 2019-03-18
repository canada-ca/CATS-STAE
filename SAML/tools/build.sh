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
    ../../tools/merge.sh < ../../Kantara/SAMLprofiles/edit/saml2int/$FILE \
                    > ../../merged/$(cut -d "." -f2 <<< $FILE)-en.adoc
    done

    popd > /dev/null

    if [[ "$spec" = "id" ]] ; then # remove non-applicable sections
      sed -i '/^==== Usability/,/^=== Metadata and Trust Management/{/^=== Metadata and Trust Management/b;d}' ./merged/sp_requirements-en.adoc
      sed -i '/^=== Single Logout/,/^=== Metadata and Trust Management/{/^=== Metadata and Trust Management/b;d}' ./merged/idp_requirements-en.adoc
    fi

    echo "Done"

    # Publish to HTML and PDF
    touch ./src/${spec}auth/main.adoc
    echo -n "Producing HTML..."
    cp -R ./src/${spec}auth/images ../docs
    docker run --rm -v $(pwd)/..:/documents/ asciidoctor/docker-asciidoctor \
    asciidoctor --source-dir SAML/src/${spec}auth --destination-dir docs \
    -o saml2${spec}-en.html SAML/src/${spec}auth/main-en.adoc

    echo -n "Producing PDF..."
    docker run --rm -v $(pwd)/..:/documents/ asciidoctor/docker-asciidoctor \
    asciidoctor-pdf --source-dir SAML/src/${spec}auth --destination-dir docs \
    -a pdf-stylesdir=./SAML/tools -a pdf-style=cats \
    -o saml2${spec}-en.pdf SAML/src/${spec}auth/main-en.adoc

    echo "Done"
done