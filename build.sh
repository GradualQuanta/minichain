#

cd docs
find . -maxdepth 1 -name "*~1" -delete -print
find . -name "*.swp" -delete -print
jekyll build
xdg-open _site/
