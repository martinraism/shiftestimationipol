mkdir surveyshift_1
cp -r src/* surveyshift_1/
tar -cvz --exclude='refreshsrc.sh' --exclude='.gitignore' --exclude='surveyshift_1.tar.gz' --exclude='refreshOld.sh' --exclude='refresh.sh' --exclude='.git' --exclude='junk' --exclude='*.js' --exclude='*.asv' --exclude='*.png' --exclude='._*' --exclude='*.dll' --exclude='*.mexa64' --exclude='*.mexw64' --exclude='*.so' --exclude='*.mexmaci64' --exclude='*.dylib' -f surveyshift_1.tar.gz surveyshift_1
rm -rf surveyshift_1
rsync -avz -e ssh ./surveyshift_1.tar.gz purple:~/public_html --exclude=desktop.ini
rm surveyshift_1.tar.gz

