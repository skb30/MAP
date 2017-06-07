#!/bin/perl 

# determine the percentage changed.
my $final     = 1000;
my $start     = 948.50;

  

main();
sub main {
	my $rate       = '5.43';
	my $final      = '1000';
	my $startPrice = '948.50';
	print "Your rate of return is:  %" . returnRate($startPrice, $final). " on a balance of \$$final with a starting price of: \$$startPrice\n";
	print "The starting price was: \$" . startPrice($rate, $final) . " and the ending balance is: \$$final with return rate of: \%$rate\n";
}
sub returnRate  {
	# calculate the return rate of an amount
	my $start     = shift;
	my $final     = shift;
	
	my $diff      = $final - $start;
    my $rate      = $diff / $start ;
    $rate         = $rate * 100; 
    
    $rate         = sprintf("%.2f", $rate);
    return $rate;
}
sub startPrice {
	# calculate the starting value of a account if you only know the rate and final balance.
	my $rate     = shift;
	my $final    = shift;
	my $percent  = $rate + 100; # convert to units of percent.
	my $start    = ($final / $percent) * 100;  # calulate starting principle. 
	
	$start = sprintf("%.2f", $start); 
	return $start;
}