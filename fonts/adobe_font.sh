#!/bin/bash
mkdir /tmp/adodefont
cd /tmp/adodefont
wget http://downloads.sourceforge.net/project/sourcecodepro.adobe/SourceCodePro_FontsOnly-1.009.zip
unzip SourceCodePro_FontsOnly-1.009.zip
mkdir -p ~/.fonts
cp SourceCodePro_FontsOnly-1.009/*.otf ~/.fonts
fc-cache -f -v
