# installing perlmodules ...


rootdir=$(pwd)

if test -e /etc/environment; then
   source /etc/environment
else
   export PATH=/usr/local/bin:/usr/bin:/bin; 
fi
export PATH=${rootdir}/bin:$PATH

# perl's local lib
[ $SHLVL -eq 1 ] && eval $(perl -I$rootdir/_perl5/lib/perl5 -Mlocal::lib=$rootdir/_perl5)


export DICT=${cwd}/etc
perl -MCPAN -Mlocal::lib=$rootdir/_perl5 -e 'CPAN::install(YAML::Syck)'
perl -MCPAN -Mlocal::lib=$rootdir/_perl5 -e 'CPAN::install(MIME::Base32)'
perl -MCPAN -Mlocal::lib=$rootdir/_perl5 -e 'CPAN::install(Math::BigInt)'
perl -MCPAN -Mlocal::lib=$rootdir/_perl5 -e 'CPAN::install(Encode::Base58::BigInt)'

