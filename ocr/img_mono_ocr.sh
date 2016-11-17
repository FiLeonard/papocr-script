#/bin/bash
 
if [ -z ${1} ]
then
	echo "PNM-Image is expected as arg"
	exit 1
fi
	mkdir -p unpaper/ocr/
	chmod -R 777 ./
	imgbase=$(basename "$1")
	echo "----------> USING UNPAPER ON ${imgbase}"
	unpaper --layout double \
		-ni 4 --blurfilter-intensity 0.01 \
		--blackfilter-intensity 20 --blackfilter-scan-depth 500,500 --blackfilter-scan-size 20,20 --blackfilter-scan-step 5,5 --blackfilter-scan-threshold 0.95 \
		--black-threshold 0.15 \
		--deskew-scan-direction left,right --deskew-scan-range 6.0 --deskew-scan-step 0.05 --deskew-scan-size 1500 --deskew-scan-deviation 3.0 \
		--mask-scan-size 40,40 --mask-scan-threshold 0.08 --mask-scan-direction h --mask-scan-step 5,5 \
		-mw 50,50 \
		-Bn v,h -Bp 3,3 -Bt 5 \
		--pre-border 70,50,50,50 \
		--overwrite --output-pages 2 \
		"${imgbase}" "unpaper/${imgbase}-%02d.pbm"
	# --no-border-scan --no-mask-scan --no-blackfilter --no-mask-scan --no-noisefilter --no-blurfilter
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

