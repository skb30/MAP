#!/bin/perl 
package ESW::PanelsMap;
##todo add error checking for panels not found and report error. 
%ESW = (

	'ASG-ESW - Testing/Debugging' => { 
    	'panelTitle'                    => 'ASG-Existing Systems Workbench - ASG-ESW',
        'panelID' 						=> 'VPIPRTME', 
        'field_command' 				=> 'Command ===>',  
		'File'  => {
            'Setup test environment'		             => '1',	  	    
			'Select Test Coverage'		 				 => '2', 
			'Open'   	  		   						 => '3', 
			'Close'          							 => '4',
			'Save'                    					 =>	'5',
			'Compile/Analyze'      						 => '6',
			'Analyze Archived Listing'					 => '7', 
			'AKR utility'          						 => '8',
			'Edit pseudo'          						 => '9',
			'Execute'              						 => '10',
			'Exit'                    					 => '11',
			
            },
        'View'  => {
            'Program source/object '				 	=> '1',	
			'Execution Counts'  						=> '2',
			'Execution Tracking'						=> '3',				
			'Memory Display'   							=> '4', 	
			'Qualify'           						=> '5',
			'ZoomData'    								=> '6',       
			'Keep'  									=> '7',            
			'Display'    								=> '8',       
			'Paragraph X-ref' 							=> '9',  
			'Reset'  									=> '10',           
			'Exclude' 									=> '11',          
			'Using'  									=> '12',           
			'Drop'    									=> '13',          
			'Toggle'  									=> '14',             
			'CICS Show'            		            	=> '15',	  	      	    
         },
         'Test'  => {
            'Module/Transaction'						=> '1',	
		   },
		   
		 'List'  => {
            'All...'									=> '1',	
            'Address stops'								=> '2',
            'AKR Members'				  			    => '3',
            'Memory'									=> '13',
            'Module directory...'				        => '14',
            'Profiles'						            => '15',
            'Test session tailoring'		            => '10',
            'TCA information'				            => '21',
            'Dump files...'					            => '22',
		   },  
		 'Options'  => {
            'Product parameters...'						=> '1',	
            'Product allocations...'					=> '2',
            'Log/list/punch...'						    => '3',
            'Script file allocations...'				=> '4',
            'PF keys...'						        => '5',
            'Modes...'						            => '6',
		   },
     }, 
     'ASG-Existing Systems Workbench - ASG-ESW' => { 
     	'panelTitle'                    => 'ASG-ESW - Testing/Debugging',
    	'panelTitle'                    => 'ASG-Existing Systems Workbench - ASG-ESW',
        'panelID' 						=> 'VSPESWR', 
        'field_command' 				=> 'Command ===>',  
		'File'  => {
            'Prepare Program'		             => '1',	  	    
			'Prepare Program from Listing'		 => '2', 
			'Define Application'   	  		   	 => '3', 
			'Manage AKR'          				 => '4',
			'List AKRs...'                    	 =>	'5',
			'Recent AKRs'      					 => '6',
			'Exit'					             => '7', 
			 },
        'Understand'  => {
            'Program'				 			=> '1',	
			'Application'  						=> '2',
			'Dump Analysis'						=> '3',				
	  	      	    
         },
         'Change'  => {
            'Program/Edit'				 		=> '1',	
			'Program/Edit Options'  			=> '2',
			'Program/View'						=> '3',	
			'Program/View Options'				=> '4',	
			'Conversion Set'  				    => '5',
			'ASG-Bridge'						=> '6',	
			'File Manipulation'					=> '7',							
	  	  },
	  	  'Test'  => {
            'Module/Transaction'				=> '1',	
		   },
		   'Document'  => {
            'Program'			 				=> '1',	
		   },
		   'Re-engineer'  => {
            'Program'			 				=> '1',	
		   },
		   'Measure'  => {
            'Portfolio'					 		=> '1',	
			'ASG-Estimate'  		 			=> '2',
			'Performance Measurement'			=> '3',	
		    },
		   'View'  => {
            'Prepare Program'				 	=> '1',	
			'Prepare Program from Listing'  	=> '2',
			'Define Application'				=> '3',				
			'Manage AKR'   						=> '4', 	
			'List AKRs...'           			=> '5',
			'Recent AKRs'    					=> '6',       
			'Understand Program '  				=> '7',            
			'Understand Application'    		=> '8',       
			'Dump Analysis' 					=> '9',  
			'Change Program'  					=> '10',           
			'Conversion Set' 					=> '11',          
			'ASG-Bridge'  						=> '12', 
			'File Manipulation'					=> '13',           
			'Test'    							=> '14',          
			'Document'  						=> '15',             
			'Re-engineer'            		   	=> '16',	
			'Portfolio' 						=> '17',
			'ASG-Estimate'  					=> '18',           
			'Performance Measurement'    		=> '19',          
			'About ASG-ESW'  					=> '20',             
		    }, 
         
     },   
);   
 

sub getPanelsMap {
	
	my $ref = \%ESW; 
	return $ref;
}