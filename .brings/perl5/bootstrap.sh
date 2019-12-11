#

# installing Perl Modules locally 
# see [*](https://metacpan.org/pod/local::lib)


# bootstrap : get local::lib tarball from CPAN
rootdir=${BRNG_HOME:-$HOME/.brings}

cwd=$(pwd)

ver=2.000024
curl https://cpan.metacpan.org/authors/id/H/HA/HAARG/local-lib-${ver}.tar.gz | tar zxf -
cd local-lib-${ver}

perl Makefile.PL --bootstrap=$rootdir/perl5
make test && make install

eval $(perl -I$rootdir/perl5/lib/perl5 -Mlocal::lib=$rootdir/perl5)
#eval $(perl -Mlocal::lib=--deactivate,~/perl5)
#perl -Mlocal::lib=--deactivate-all

cd $cwd
rm -rf local-lib-${ver}


echo PERL5LIB: $PERL5LIB

if false; then
export LC_TIME=en_US.UTF-8
sudo locale-gen en_US.UTF-8
fi
