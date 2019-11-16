#

# installing Perl Modules locally 
# see [*](https://metacpan.org/pod/local::lib)


# bootstrap : get local::lib tarball from CPAN
rootdir=$(pwd)
ver=2.000024
curl https://cpan.metacpan.org/authors/id/H/HA/HAARG/local-lib-${ver}.tar.gz | tar zxf -
cd local-lib-${ver}

perl Makefile.PL --bootstrap=$rootdir/_perl5
make test && make install

eval $(perl -I$rootdir/_perl5/lib/perl5 -Mlocal::lib=$rootdir/_perl5)
#eval $(perl -Mlocal::lib=--deactivate,~/perl5)
#perl -Mlocal::lib=--deactivate-all

cd $rootdir
rm -rf local-lib-${ver}


echo PERL5LIB: $PERL5LIB

