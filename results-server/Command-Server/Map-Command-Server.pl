#Socket listens on port 5000
use IO::Socket;

$| = 1;

$socket = new IO::Socket::INET (
                                  LocalHost => '10.18.0.50',
                                  LocalPort => '5000',
                                  Proto => 'tcp',
                                  Listen => 5,
                                  Reuse => 1
                               );
                                
die "Couldn't open socket" unless $socket;

print "\nMAP Server Waiting for commands on port 5000\n";

while(1) {
	$client_socket = "";
	$client_socket = $socket->accept();
	
	$peer_address = $client_socket->peerhost();
	$peer_port = $client_socket->peerport();
	
	print "\n Connection from ( $peer_address , $peer_port ) ";
		 	 	 	 
		    
	$client_socket->recv($recieved_data,1024);
		    
	if ( $recieved_data eq 'q' or $recieved_data eq 'Q'){
		close $client_socket;
		last;
	}

	else {
		$output = `$recieved_data`;
		$send_data = "$recieved_data\nCompleted with RC = $?\n$output";
		$client_socket->send ($send_data);
		close $client_socket;

	}
	
	
}
