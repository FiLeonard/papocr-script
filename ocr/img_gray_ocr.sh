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
	/usr/bin/convert "${imgbase}" -brightness-contrast 0x65 "imk_${imgbase}"
	echo "----------> USING UNPAPER ON imk_${imgbase}"
	unpaper --layout double \
		-ni 3 --blurfilter-intensity 0.01 \
		--blackfilter-intensity 15 --blackfilter-scan-depth 500,500 --blackfilter-scan-size 20,20 --blackfilter-scan-step 5,5 --blackfilter-scan-threshold 0.95 \
		--black-threshold 0.12 \
		--deskew-scan-direction left,right --deskew-scan-range 6.0 --deskew-scan-step 0.05 --deskew-scan-size 2000 --deskew-scan-deviation 3.0 \
		--mask-scan-size 100,100 --mask-scan-threshold 0.1 --mask-scan-direction h --mask-scan-step 5,5 \
		-mw 0,0 \
		-Bn v,h -Bp 3,3 -Bt 4 \
		--pre-border 30,70,30,30 \
		--output-pages 2 --overwrite -t pbm \
		"imk_${imgbase}" "unpaper/${imgbase}-%02d.pbm"
	rm "imk_${imgbase}"
	# --no-border-scan --no-mask-scan --no-blackfilter --overwrite -t pbm --no-noisefilter --no-blurfilter--no-mask-scan
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

