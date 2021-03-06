#!/bin/bash

# Uncomment the following line to debug this script
#set -x

# Where to put the generated files
DESTINATION_DIR=./dist
ASSETS_DIR=assets

# TODO: Replace with your own title's designation
TITLE="TITLE"

MAX_ROUNDS=10 # Set this higher if you ever create more than 10 drafts (I hope you don't :p)

# Load utilities
source ./build-utils.sh

# Load modules list
OLD_IFS=$IFS # save old IFS value
IFS=$'\r\n' GLOBIGNORE='*' command eval 'MODULES=($(cat ./modules.txt))'
IFS=$OLD_IFS # restore IFS

clean_assets() {
    echo "Cleaning the destination folder"
    rm -rf $DESTINATION_DIR/$ASSETS_DIR
}

copy_assets() {
    echo "Copying the assets to the destination folder"
    mkdir -p $DESTINATION_DIR/$ASSETS_DIR # copying the assets allows us to link to them easily
    syncOptions=(--archive --delete --exclude="node_modules/" --exclude="dist/")
    syncFiles $ASSETS_DIR $DESTINATION_DIR/$ASSETS_DIR/ "${syncOptions[@]}"
    unset syncOptions
}

#####################################################################
# Turn the crank on generating chapters of your title.
# - Will go into the folder of your chapter and prune code fragments to fit
# - Will build both an HTML preview as well as an FODT stylized copy for Packt
#####################################################################
build() {
    echo "Inspecting fragments in $1..."

    pushd $ASSETS_DIR/$1

	if [ "$(echo fragment*)" != 'fragment*' ]; then # Do any fragment*'s exist?
		for i in $(ls fragment*); do
			PROCESSED="processed_$i"
			echo "Converting $i into $PROCESSED"
			# TODO: Plug in any script you want to "trim"
			# my_script_to_convert < $i > $PROCESSED
		done
	fi;

	# Convert 1 into 01, 2 into 02, but leave index, foreword, etc. alone
	case $1 in
    	''|*[!0-9]*) 	PART_NAME=$1 ;;
    	*) 				PART_NAME=$(echo 00$1 | tail -c 3) ;;
	esac

	popd

    DOC="UNDEFINED"
    for draft_number in `seq ${MAX_ROUNDS} -1 1`
	do
		DOC="${TITLE}_${PART_NAME}_draft_${draft_number}"
		if [ -e ${DOC}.adoc ]; then
		    echo "Draft ${draft_number} detected for the following part: ${PART_NAME}. We will build that one!"
		    break;
        fi
	done

	if [ ! -f ${DOC}.adoc ]; then
		echo "Document not found: ${DOC}. Is the modules.txt file correct? If the file name correct?"
		echo "Fix that and try again, stopping the build"
		exit;
    fi


	echo "Building ${DESTINATION_DIR}/${DOC}.html..."
	asciidoctor --destination-dir ${DESTINATION_DIR} --attribute allow-uri-read ${DOC}.adoc

	echo "Building ${DESTINATION_DIR}/${DOC}.fodt..."
	#asciidoctor --destination-dir ${DESTINATION_DIR} --trace --template-engine slim --template-dir slim-templates --backend packt ${DOC}.adoc
	#Uncomment the line below to generated a well-formatted fodt file
	asciidoctor --destination-dir ${DESTINATION_DIR} --trace --template-engine slim --template-dir slim-templates --backend packt ${DOC}.adoc && xmllint -format $DESTINATION_DIR/${DOC}.fodt 2>&1 > /dev/null

}

buildHtmlOnly() {
	asciidoctor --destination-dir ${DESTINATION_DIR} --trace --attribute allow-uri-read $1
}

#####################################################################
# CLI
#####################################################################
if [ "$1" = "" ]; then
	echo
	echo "Usage: ./build.sh [all|(chapter number)|foreword|preface|index|clean_assets|copy_assets]"
	echo
	exit
elif [ "$1" = "all" ]; then
	echo
	echo "Building all chapters for your AWESOME book"
	echo
	
	clean_assets
	build "foreword"
	build "preface"

	for module in ${MODULES[@]}
	do
		build $module
	done
	
	build "index"
    copy_assets
	echo "Done!"

	exit
elif [ "$1" = "clean_assets" ]; then
    clean_assets
elif [ "$1" = "copy_assets" ]; then
    copy_assets
elif [ "$1" = "single_file" ]; then
	buildHtmlOnly $2
elif containsElement "$1" "${MODULES[@]}"; then
	echo
	echo "$1 is a valid module name. Building..."
	echo
	clean_assets
	build $1
	copy_assets
	
	echo "Done!"
else
	echo
	echo "'$1' is not a recognized option. Aborting."
	echo
    exit 1
fi;
