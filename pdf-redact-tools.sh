function pdf_split(){
    for file in "$@"; do
        if [ "${file##*.}" != "pdf" ]; then
            echo "Skip $file because it's not PDF file";
            continue
        fi;
        pages=$(pdfinfo "$file" | grep "Pages" | awk '{print $2}')
        echo "Detect $pages in $file";
        filename="${file%.*}";
        unset Outfile;
        for i in $(seq 1 "$pages"); do
            pdftk "$file" cat "$i" output "$filename-$i.pdf";
            Outfile[$i]="$filename-$i.pdf";
        done;
    done;
};

function pdf_redact(){
    for file in "$@"; do
        if [ "${file##*.}" != "pdf" ]; then
            echo "Skip $file because it's not PDF file";
            continue
        fi;
        pages=$(pdfinfo "$file" | grep "Pages" | awk '{print $2}')
        echo "Detect $pages in $file";
        filename="${file%.*}";
        unset Outfile;
        for i in $(seq 1 "$pages"); do
            pdftk "$file" cat "$i" output "$filename-$i.pdf";
            Outfile[$i]="$filename-$i.pdf";
        done;
        gimp "${Outfile[@]}";
        pdftk "${Outfile[@]}" cat output "$filename-anon.pdf";
        rm "${Outfile[@]}";

	read -p "Do you want open output file? " -n 1 -r
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
    		evince "$filename-anon.pdf";
	fi

	read -p "Do you want upload output file to Scribd.com? " -n 1 -r
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
	    scribd_up "$filename-anon.pdf";
	fi
    done;
};
