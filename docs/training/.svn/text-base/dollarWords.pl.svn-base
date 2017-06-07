#!/bin/perl  -w

# A fun to write. 
# Calculate all the words in the english language that have a value of one dollar.

my 	%letters = (
		'a'         => '1',
		'b'         => '2',
		'c'         => '3',
		'd'         => '4',
		'e'         => '5',
		'f'         => '6',
		'g'         => '7',
		'h'         => '8',
		'i'         => '9',
		'j'         => '10',
		'k'         => '11',
		'l'         => '12',
		'm'         => '13',
		'n'         => '14',
		'o'         => '15',
		'p'         => '16',
		'q'         => '17',
		'r'         => '18',
		's'         => '19',
		't'         => '20',
		'u'         => '21',
		'v'         => '22',
		'w'         => '23',
		'x'         => '24',
		'y'         => '25',
		'z'         => '26',

	);

    open (WORDS, "<", "words.txt") or die $!;
    
    my $letter;
    my $value;
    my $totalWords = 0;
    $totalDollarWords = 0;
    
    foreach my $word (<WORDS>) {
    	$totalWords++;
    	chomp($word);
    	$value = 0;
    	
    	# skip words that have a spaces or tic marks
    	if ($word =~ m/\s+|'/ ) {
    		next;
    	}
    	# iterate thru all letters of the word totaling their value
    	for (my $i = 0; $i <= length($word)-1; $i++) {
			$letter = substr($word, $i, 1);
			$letter = lc($letter);
			$value += $letters{$letter};
		}
		
		# do we have a dollar?
		if ($value == 100) {
			print "$word\n";
			$totalDollarWords++;
		}
#		print "$word is worth $value\n";	
    }
   print "There were $totalDollarWords dollar words out of $totalWords words processed. \n";
