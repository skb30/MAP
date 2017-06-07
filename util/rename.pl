#!/usr/local/bin/perl
# This script can be used to do a mass rename of files in a folder 
#
# The first argument is the regex substation expression for the rename 
# The second argument is the file filter mask. 
#
# Usage: rename perlexpr [files]
#
#    Make all the files in the directory end with .html instead of .txt.
#
#        rename 's/txt$/html/' *
#
#    Change all the files prefixed with the text mah and suffixed with .new to be suffixed with .old instead.
#
#        rename 's/new$/old/' mah*.new
#
#    Hide every file in the directory by prefixing the filename with a .
#
#        rename 's/(.+)/\.$1/' *



use File::Glob qw(:glob);
($regexp = shift @ARGV) || die "Usage:  rename perlexpr [filenames]\n";

if (!@ARGV) {
   @ARGV = <STDIN>;
   chomp(@ARGV);
}

foreach $_ (bsd_glob(@ARGV, GLOB_NOCASE)) {
   $old_name = $_;
   #print "$regexp\n";
   
   eval $regexp;
   die $@ if $@;
  rename($old_name, $_) unless $old_name eq $_;
}

exit(0);