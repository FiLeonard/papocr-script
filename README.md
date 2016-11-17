# paperocr-script

ocr-Bash script utilizing imagemagick, unpaper, pdftk and tesseract. Used for convenient research. Splits double paged scans. Probably needs adjustments. Right now, you have to delete every temporary file afterwards. Rerunning the script without arguments will only redo those files which still are in the first subdirectory: the pgm  or pbm files. So you may do a first run and then delete those pgm or pbm files, which were processed just fine and then rerun it with different values. Check out unpaper manpages espacially.
