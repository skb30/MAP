#!/bin/perl 
package SMARTFILE::PanelsMap;
##todo add error checking for panels not found and report error. 
%panelsMap = (
	'Primary Options ' => { 
    	'panelTitle' 		=> 'Primary Options',
        'panelID' 			=> 'PDSMENUS', 
        'field_command' 	=> 'OPTION  ===>',		
   	 	},     
        
);
sub getPanelsMap {
	if ($debug) {
		print " Entering getPanelsMap \n";
	}
	return %panelsMap;
}
-1;