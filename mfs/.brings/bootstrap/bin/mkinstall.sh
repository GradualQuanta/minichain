#

cwd=$(pwd)
# update install templage
sed -i -e "s/PROJDIR=.*$/PROJDIR=$(pwd)" install.sh

