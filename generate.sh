#!/bin/sh

if [ ! ${#} -eq 2 ]; then
	echo "Generate bib numbers from start number and to end"
	echo "./generate.sh START END"
	exit 1
fi

START=$1
END=$2

NUM=${START}

INKSCAPE_VER=$(inkscape --version | cut -d " " -f 2 | cut -d "." -f 1)

if [ ! -d export ]; then
	mkdir export
fi

while [ $NUM -lt $END ]
do
	cp template.svg conv${NUM}_$((${NUM}+1)).svg
	REPLACE_STR1="s/999/${NUM}/g"
	REPLACE_STR2="s/888/$((${NUM}+1))/g"
	sed -i `printf ${REPLACE_STR1}` conv${NUM}_$((${NUM}+1)).svg
	sed -i ${REPLACE_STR2} conv${NUM}_$((${NUM}+1)).svg
	echo "Numbers ${NUM} and $((${NUM}+1)) generated"
	NUM=$((${NUM}+2))
done

FILES=$(find conv*.svg)

for file in $FILES
do
	NUM_GEN=$((${NUM_GEN}+2))
	(
	echo $file
	if [ $INKSCAPE_VER -eq 0 ]; then
		inkscape --file=${file} --without-gui --export-text-to-path --export-area-page --export-pdf-version=1.5 --export-pdf=export/${file}.pdf 2>&1 > /dev/null
	else
		inkscape --export-text-to-path --export-filename=export/${file}.pdf ${file} 2>&1 > /dev/null
	fi
	rm $file
	)&
	if [ `expr $NUM_GEN % 10` -eq 0 ]; then 
		wait 
	fi
done
wait
