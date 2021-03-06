package MakeMaker::Test::NoXS;

# Disable all XS loading.

use Carp;

require DynaLoader;
require XSLoader;

# Things like Cwd key on this to decide if they're running miniperl
delete $DynaLoader::{boot_DynaLoader};

if ($^O eq 'MSWin32') {
    require Win32;
    my $GetCwd = *{'Win32::GetCwd'}{CODE};
    my $SetChildShowWindow = *{'Win32::SetChildShowWindow'}{CODE};
    %{*main::Win32::{HASH}} = ();
    *{'Win32::GetCwd'} = $GetCwd;
    *{'Win32::SetChildShowWindow'} = $SetChildShowWindow;
}

# This isn't 100%.  Things like Win32.pm will crap out rather than
# just not load.  See ExtUtils::MM->_is_win95 for an example
no warnings 'redefine';
*DynaLoader::bootstrap = sub { confess "Tried to load XS for @_"; };
*XSLoader::load        = sub { confess "Tried to load XS for @_"; };

1;
