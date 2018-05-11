mkdir shift_1
cp -r src/* shift_1/
tar -cvz --exclude='.gitignore' --exclude='shift_1.tar.gz' --exclude='refreshOld.sh' --exclude='refresh.sh' --exclude='.git' --exclude='junk' --exclude='*.js' --exclude='*.asv' --exclude='*.png' --exclude='._*' --exclude='*.dll' --exclude='*.mexa64' --exclude='*.mexw64' --exclude='*.so' --exclude='*.mexmaci64' --exclude='*.dylib' -f shift_1.tar.gz shift_1
rm -rf shift_1
rsync -avz -e ssh ./shift_1.tar.gz purple:~/public_html --exclude=desktop.ini
rm shift_1.tar.gz

