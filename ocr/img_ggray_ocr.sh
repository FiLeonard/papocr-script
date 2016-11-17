#/bin/bash
 
if [ -z ${1} ]
then
	echo "PNM-Image is expected as arg"
	exit 1
fi
	mkdir -p unpaper/ocr/
	chmod -R 777 ./
	imgbase=$(basename "$1")
	echo "----------> USING Imagemagick ON ${imgbase} PRODUCING imk_${imgbase}"
	/usr/bin/convert "${imgbase}" -brightness-contrast 0x30 "imk_${imgbase}"
	echo "----------> USING UNPAPER ON imk_${imgbase}"
	unpaper --layout double \
		-ni 0 --blurfilter-intensity 0.01 \
		--blackfilter-intensity 40 --blackfilter-scan-depth 500,500 --blackfilter-scan-size 20,20 --blackfilter-scan-step 5,5 --blackfilter-scan-threshold 0.95 \
		--black-threshold 0.17 \
		--deskew-scan-direction left,right --deskew-scan-range 6.0 --deskew-scan-step 0.1 --deskew-scan-size 1500 --deskew-scan-deviation 3.0 \
		--mask-scan-size 90,90 --mask-scan-threshold 0.05 --mask-scan-direction h --mask-scan-step 15,15 \
		-mw 0,0 \
		-Bn v,h -Bp 3,3 -Bt 4 \
		--pre-border 0,0,0,0 \
		--output-pages 2 --overwrite\
		--no-blackfilter --no-noisefilter --no-blurfilter --no-grayfilter --no-mask-scan --no-border-scan \
		"imk_${imgbase}" "unpaper/${imgbase}-%02d.pgm"
	rm "imk_${imgbase}"
	#  --no-blackfilter --no-noisefilter --no-blurfilter--no-mask-scan --no-noisefilter --no-blurfilter
	for unimg in unpaper/${imgbase}*
	do
		unimgbase=$(basename "${unimg}")
		echo  "----------> USING TESSERACT ON ${unimg}"
		tesseract -l eng "${unimg}" "./unpaper/ocr/pdf_${unimgbase}" pdf
	done
	#wait
	chmod -R 777 ./
	echo "-------------------------------------> ${imgbase} is done"
	echo ""
	echo "############################################################################"

