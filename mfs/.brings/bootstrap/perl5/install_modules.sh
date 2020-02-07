# installing perlmodules ...

rootdir=${BRNG_HOME:-$HOME/.brings}

if test -e /etc/environment; then
   . /etc/environment
else
   export PATH=/usr/local/bin:/usr/bin:/bin; 
fi
export PATH="${rootdir}/bin:$PATH"
export PERL5LIB=${PERL5LIB:-$BRNG_HOME/perl5/lib/perl5}

# perl's local lib
eval $(perl -I$PERL5LIB -Mlocal::lib=${PERL5LIB%/lib/perl5})

perl -MCPAN -Mlocal::lib=${PERL5LIB%/lib/perl5} -e 'CPAN::install(YAML::Syck)'
perl -MCPAN -Mlocal::lib=${PERL5LIB%/lib/perl5} -e 'CPAN::install(MIME::Base32)'
perl -MCPAN -Mlocal::lib=${PERL5LIB%/lib/perl5} -e 'CPAN::install(Math::BigInt)'
perl -MCPAN -Mlocal::lib=${PERL5LIB%/lib/perl5} -e 'CPAN::install(Encode::Base58::BigInt)'
perl -MCPAN -Mlocal::lib=${PERL5LIB%/lib/perl5} -e 'CPAN::install(JSON)'
perl -MCPAN -Mlocal::lib=${PERL5LIB%/lib/perl5} -e 'CPAN::install(Crypt::Digest)'
perl -MCPAN -Mlocal::lib=${PERL5LIB%/lib/perl5} -e 'CPAN::install(LWP::UserAgent)'
perl -MCPAN -Mlocal::lib=${PERL5LIB%/lib/perl5} -e 'CPAN::install(LWP::Protocol::https)'
perl -MCPAN -Mlocal::lib=${PERL5LIB%/lib/perl5} -e 'CPAN::install(Text::Diff)'
perl -MCPAN -Mlocal::lib=${PERL5LIB%/lib/perl5} -e 'CPAN::install(Text::Patch)'
perl -MCPAN -Mlocal::lib=${PERL5LIB%/lib/perl5} -e 'CPAN::install(Text::Diff3)'
