#/bin/bash
 
if [ -z "${1}" ]
then
	echo "PDF-Datei als ersten Parameter erwartet"
	exit 1
fi

n=0
maxjobs=3

 
# Basisnamen für später merken
pdfname=$(basename "${1}" .pdf)
pdfbase=$(basename "${1}" .pdf)
mkdir -p ./${pdfbase}/unpaper/ocr/ 
chmod -R 777 ./${pdfbase}/
filrange=""

if [ -n "${2}" ]
then
pdftoppmopts=""
case ${2} in
        all)
            ;;
        *)
			if [ -n "${3}" ]
			then
            pdftoppmopts="-f ${2} -l ${3}"
			else
			pdftoppmopts="-f ${2} -l ${2}"
			fi 
			;;
esac
# Extrahiere Bilder a
echo "############################################################################"
echo ""
echo "------------------------> Starting OCR-Script (OCR/Mono/250dpi)"
echo ""
echo "############################################################################"
echo ""
echo "-----------> Converting ${1} to PGM images with pdftoppm (default:250ppi)"
echo ""
echo "############################################################################"
echo "############################################################################"
pdftoppm -gray -r 300 $pdftoppmopts "${1}" "./${pdfbase}/${pdfbase}_temp"
fi

cd ${pdfbase}/
# Optimiere die Bilder
for image in ./${pdfbase}_temp*
do
	../img_ggray_ocr.sh "${image}" &
	if (( $(($((++n)) % $maxjobs)) == 0 )) ; then
        echo "Doing ${maxjobs} jobs!"
		wait # wait until all have finished (not optimal, but most times good enough)
    fi
done
wait
echo "------------------------------------------>All JOBS DONE"
# Fasse einzelne PDFs wieder zusammen
echo "MERGE PDFs"
pdftk unpaper/ocr/pdf_*.pdf output "../${pdfname}_ocr.pdf"
echo "Done!"

	#	while true; do
#	current_number=$(ps -C img_gray_ocr --no-headers | wc -l)
#	if [[ $current_number -lt $maxjobs ]] ; then
#	print "Starting new job"
##	break
#	else
#	echo "-->Waiting: $maxjobs RUNNING"
#	sleep 10
#	fi
#	done

# Lösche temporäre Dateien
#read -p "Sollen die temporären Daten gelöscht werden?: (yes?)" check
 
#if [ $check = "yes"]
# then
#    rm pdf_${pdfbase}_temp-*.pdf ${pdfbase}_temp-*
#fi
