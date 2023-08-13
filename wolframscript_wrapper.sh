# env/bin/bash

cd /tmp

TEMP=`getopt -o c:f: --long code:,format: -- "$@"`
eval set -- "$TEMP"

while true ; do
    case "$1" in
        -c|--code)
            code=$2;
            shift 2;;
        -f|--format)
            case "$2" in
                "plaintex"|"tex") format=$2 ; shift 2 ;;
                               *) format="plaintex" ; shift 2 ;;
            esac ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done

if [[ "$format" == "plaintex" ]]
then
    echo $(wolframscript -c "$code")
else
    base_file_name=$(date +%s)

    content=$(wolframscript -c "$code" -format TeX)
    match="documentclass{article}"
    replace="documentclass[border=2pt,varwidth]{standalone}"
    content=${content/"$match"/"$replace"}
    content="%${content#*%}"

    echo "$content" > "$base_file_name.tex"
    pdflatex "$base_file_name.tex" > /dev/null
    convert -density 300 $base_file_name.pdf -quality 90 -background white -alpha remove -alpha off "$base_file_name.png" > /dev/null
    echo "$base_file_name.png"
fi
