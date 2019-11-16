# installing perlmodules ...

rootdir=$(pwd)
perl -MCPAN -Mlocal::lib=$rootdir/_perl5 -e 'CPAN::install(YAML::Syck)'
perl -MCPAN -Mlocal::lib=$rootdir/_perl5 -e 'CPAN::install(MIME::Base32)'
perl -MCPAN -Mlocal::lib=$rootdir/_perl5 -e 'CPAN::install(Math::BigInt)'
perl -MCPAN -Mlocal::lib=$rootdir/_perl5 -e 'CPAN::install(Encode::Base58::BigInt)'

