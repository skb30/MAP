
print "Perl Script Called from Jenkins\n";
#build code here

# process jenkkin variables

my $arg1 = shift;
my $arg2 = shift;

print "parameter passed from jenkins: param 1 $arg1 param 2 $arg2 \n";

# list the system variables
foreach $key (keys(%ENV)) {

    printf("%-10.10s: $ENV{$key}\n", $key);

}
return 1;
# return failure so email will be sent to recipient who broke the build.
