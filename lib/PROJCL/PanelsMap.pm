#!/bin/perl 
package PROJCL::PanelsMap;
##todo add error checking for panels not found and report error. 
%PROJCL = (
	'ASG-ESW' => { 
    	'panelTitle'                    => 'Program View',
        'panelID' 						=> 'VPITGMV', 
        'field_command' 				=> 'Command ===>',  
         'Test'  => {
         	'Setup Wizards...'				=> '*',
            'Run...'						=> '2',
            'Step...'						=> '3',	
            'Cancel'						=> '4',	
            'Break...'						=> '5',	
            'Stop...'						=> '6',
            'Go...'							=> '7',	
            'Move...'						=> '8',		
            'Add...'						=> '9',
            'Subtract...'					=> '10',	
            'Where...'						=> '11',	
            'Testpoints...'					=> '12',
            'ASG-Alliance Interface...'		=> '*3',
            'CICS Newcopy...'				=> '*4',
            'Dump'							=> '15',		      	
		   },
		   
		 'List'  => {
            'All...'									=> '1',	
            'Address stops'								=> '2',
            'AKR Members'				  			    => '3',
            'BackTrack History...'						=> '4',
            'Breakpoints'				       			=> '5',
		   },  
     }, 


	'ASG-ValidDate' => { 
    	'panelTitle' => 'ASG-ValidDate',
        'panelID' 						 => 'VNPPRIME', 
        'field_command' 				 => 'Command ===>',  
		'File'  => {
            'Open date...'		         => '1',	  	    
			'Close date'		 		 => '2', 
			'Open security...'   	     => '3', 
			'Close security'          	 => '4',
			'Exit'          			 => '5',
            },
        'Edit'  => {
            'Dates'		             	 => '1',
            'Security...'		         => '2',	  	    
            },   
        'View'  => {
            'Batch'		          		 => '1',	  	    
			'Cics'		 				 => '2', 
			'Ims'   	  		   		 => '3', 
			'Tso'          			 	 => '4',
            },
        'Options'  => {
            'Apply changes'		         => '1',	  	    
			'Verify entries...'		 	 => '2', 
			'Product parameters...'   	 => '3', 
			'Log...'          			 => '4',
            'PF keys...'		         => '5',	  	    
			'ValidDate Demo ...'		 => '6', 
			'ValidDate Verify Date interfaces...'   => '7', 
			'ValidDate Check SVC status..'          => '8',
            },
        'Help'  => {
            'Current screen'		     => '1',	  	    
			'Current message'		 	 => '2', 
			'All commands'   	  		 => '3', 
			'Specific command...'        => '4',
            'Specific message...'		 => '5',	  	    
			'Common abends'		 	     => '6', 
			'Table of contents...'   	 => '7', 
			'Index...'          	     => '8',
			'Action bar...'   	  		 => '9', 
			'About...'          	     => '10',
            },
	},
	'PRO/JCL Product Usage' => { 
    	'panelTitle' => 'PRO/JCL Product Usage',
        'panelID' 						=> 'D0SPUSE0', 
        'field_command' 				=> 'Command ===>',  
		'Sort'  => {
            'Userid'		             => '1',	  	    
			'Uses'		 				 => '2', 
			'Lastused'   	  		   	 => '3', 
			'Errors'          			 => '4',
            },
        'File'  => {
            'Exit'		             	 => '1',	  	    
            }   
	},
	'PRO/JCL Edit/View Run-Time Settings' => { 
    	'panelTitle' => 'PRO/JCL Edit/View Run-Time Settings',
        'panelID' 						=> 'D0SPRTS2', 
        'field_command' 				=> 'Command ===>',
		'Run-Time Options'				=> '1', 			         
		'Interfaces'                	=> '2',
		'Format Options'       			=> '3',     
		'JCL Listing Report'   			=> '4',     
		'RTS Report'               		=> '5', 
		'Enabled Tables'         		=> '6',   
		'Devices'            			=> '7',       
		'PROC Exclude'      			=> '8',        
		'DD Exclude'           			=> '9',     
		'DDnames'            			=> '10',       
		'Control Card'        			=> '11',      
		'Utility Alias'        			=> '12',     
		'Data set Preference'   		=> '13',    
		'User Utilities'        		=> '14',    
		'Control Card DSNs'     		=> '15',    
		'DFSMShsm MCDS'         		=> '16',    
		'IMS ACB Datasets'       		=> '17',   
		'Messages'             			=> '18',     
		'Return Codes'            		=> '19',  
		'Tape Out of Area Codes'   		=> '20', 
		'CA-Jobtrac'          			=> '21',      
		'Jesprocs'            			=> '22',      
		'Library Type'             		=> '23', 
		'Contention Permitted DSNs' 	=> '24',
		'DB2 Group Attach'       		=> '25',   
		'Trace'               			=> '26', 
        'Settings'  => {
        	'Confirmation Save Option'   => '1',
            },
		'File'  => {
            'Open'		 => '1',	  	    
			'New'		 => '2', 
			'Save'   	 => '3', 
			'Save As'    => '4',
			'Delete'	 => '5', 
			'Exit' 		 => '6',
            }
	},      
	'JJDirect Edit Macro Settings' => { 
    	'panelTitle' => 'PRO/JCL Edit/View Run-Time Settings',
        'panelID' 						=> 'D0JPDOPT', 
        'field_command' 				=> 'Command ===>',  
		'Settings'  => {
            'Scheduler'		             => '1',	  	    
			'Skeleton Processing'		 => '2', 
			'Extended Messages'   	     => '3', 
			'Alternate Userid'           => '4',
			'Selection Exit'	         => '5', 
			'First Control Card' 	     => '6',
			'Remote Machine Defs' 		 => '7',
            }
	},      
	'PRO/JCL Directed Execution' => { 
    	'panelTitle' => 'PRO/JCL Directed Execution',
        'panelID' 						=> 'D0JPDVAL', 
        'field_command' 				=> 'Command ===>',  
		'Settings'  => {
		   'RTS Member'                 => '1', 
		   'First Control Card'         => '2',  
		   'Scheduler'                  => '3',           
		   'BatchJCL'                   => '4',            
		   'TSOParms'                   => '5',            
		   'User Report Title'          => '6',   
		   'Skeleton Processing'        => '7', 
           'Extended Messages'          => '8',   
           'Selection List'             => '9',       
           'Alternate Userid'           => '10', 
           'Selection Exit'             => '11',      
           'Remote Machine Defs'        => '12',
           }
	},                  
           
             
   	'PRO/JCL Edit/View Run-Time Settings - default RTS' => { 
    	'panelTitle' => 'PRO/JCL Edit/View Run-Time Settings',
        'panelID' => 'D0SPREF1', 
        'field_command' 		=> 'Option ===>',
		'JCL'					=> '1', 			         
		'IDCAMS'               	=> '2',
		'JES2'       			=> '3',     
		'JES3'   				=> '4',     
		'Exit'               	=> '5', 
		
        'Settings'  => {
        	'Confirmation Save Option'   => '1',
            },
		'File'  => {
            'Open'		 => '1',	  	    
			'New'		 => '2', 
			'Save'   	 => '3', 
			'Save As'  	 => '4', 
			'Delete'     => '5',
			'Cancel'	 => '6', 
			'Exit' 		 => '7',
            }
	},   

  	'Edit Reformatter Settings' => { 
    	'panelTitle' => 'Edit Reformatter Settings',
        'panelID' => 'D0SPRTSD', 
        'field_command' 		=> 'Command ===>',
		'Run-Time Options'				=> '1', 			         
		'Interfaces'                	=> '2',
		'Format Options'       			=> '3',     
		'JCL Listing Report'   			=> '4',     
		'RTS Report'               		=> '5', 
		'Enabled Tables'         		=> '6',   
		'Devices'            			=> '7',       
		'PROC Exclude'      			=> '8',        
		'DD Exclude'           			=> '9',     
		'DDnames'            			=> '10',       
		'Control Card'        			=> '11',      
		'Utility Alias'        			=> '12',     
		'Data set Preference'   		=> '13',    
		'User Utilities'        		=> '14',    
		'Control Card DSNs'     		=> '15',    
		'DFSMShsm MCDS'         		=> '16',    
		'IMS ACB Datasets'       		=> '17',   
		'Messages'             			=> '18',     
		'Return Codes'            		=> '19',  
		'Tape Out of Area Codes'   		=> '20', 
		'CA-Jobtrac'          			=> '21',      
		'Jesprocs'            			=> '22',      
		'Library Type'             		=> '23', 
		'Contention Permitted DSNs' 	=> '24',
		'DB2 Group Attach'       		=> '25',   
		'Trace'               			=> '26', 
        'Settings'  => {
        	'Confirmation Save Option'   => '1',
            },
		'File'  => {
            'Open'		 => '1',	  	    
			'New'		 => '2', 
			'Save'   	 => '3', 
			'Delete'     => '4',
			'Cancel'	 => '5', 
			'Exit' 		 => '6',
            }
	},   

    'ASG-PRO/JCL Validation' => { 
    	'panelTitle' => 'ASG-PRO/JCL Validation',
        'panelID' => 'D0JPJVAL', 
        'field_command' => 'Command ===>',
        'Settings'  => {
        	'RTS Member'                 => '1', 
        	'Scheduler'                  => '2',
        	'Output Libraries'           => '3',
        	'BatchJCL'                   => '4',
            'TSOParms'                   => '5',
            'User Report Title'          => '6',
            'Options Report'             => '7',
            'Skeleton Processing'        => '8',
            'Extended Messages'          => '9', 
            'Selection List'             => '10',
            'Alternate Userid'           => '11',
            'Selection Exit'             => '12', 
            'Reset Between Members'      => '13',
            'First Control Card'         => '14', 
            },
		'File'  => {
            'Edit Input Library'		 => '1',	   
			'Browse Input Library'		 => '2', 
			'View Input Library'   		 => '3', 
			'Exit'                 		 => '4',
            }
    },
 
        'JJ Edit Macro Settings' => { 
    	'panelTitle' => 'JJ Edit Macro Settings',
        'panelID' => 'D0JPJOPT', 
        'field_command' => 'Command ===>',
        'Settings'  => {
        	'RTS Member'                 => '1',
        	'Scheduler'                  => '2',
        	'Skeleton Processing'        => '3',
            'Extended Messages'          => '4', 
            'Reformatter'                => '5',
            'Alternate Userid'           => '6',
            'Selection Exit'             => '7', 
            'First Control Card'         => '8', 
            },
    },
    
    'PRO/JCL Run-Time Options' => { 
    'panelTitle' => 'PRO/JCL Run-Time Options',
    'panelID' => 'D0SPRUN0', 
    'field_command' => 'Command ===>',
    'File'  => {
        'Exit'                      => '1',
        }
    },
   'Develop JCL Manipulation Programs ' => { 
    	'panelTitle' => 'Develop JCL Manipulation Programs ',
        'panelID' => 'D0JPJMP', 
        'field_command' => 'Command ===>',
        'Settings'  => {
        	'RTS Mbr'                    => '1',
        	'User Messages'              => '2',
        	'Scheduler'                  => '3',
        	'Output Libraries'           => '4',
            'TSOParms'                   => '5',
            'User Report Title'          => '6',
            'Options Report'             => '7',
            'Skeleton Processing'        => '8',
            'Extended Messages'          => '9', 
            'Selection Exit'             => '10', 
            'Reset Between Members'      => '11',
            'First Control Card Lib'     => '12', 
            },
		'File'  => {
            'Exit'		 => '1',	   
		 }
    },
     
    
    'PRO/JCL Messages' => { 
    'panelTitle' => 'PRO/JCL Messages',
    'panelID' => 'D0SPRUN3', 
    'field_command' => 'Command ===>',
    'File'  => {
        'Exit'                      => '1',
        }
    },
    'ISPF Command Shell' => { 
    	'panelTitle' => 'ISPF Command Shell',
        'panelID' => 'ISRTSO', 
        'field_command' => '===>',

    },
    
    'Data Set List Utility' => { 
    	'panelTitle' => 'Data Set List Utility',
        'panelID' => 'ISRUDLP', 
        'field_command' => '===>',

    },
    'ISPF Primary Option Menu' => { 
    	'panelTitle' => 'ISPF Primary Option Menu',
        'panelID' => 'ISP@MST1', 
        'field_command' 		=> 'Option ===>',
        'Settings'			 	=> '0',
        'View' 					=> '1',
        'Edit' 					=> '2',
        'Utilities' 			=> '3',
        'Foreground' 			=> '4',
        'Batch' 				=> '5',
        'Command' 				=> '6',
        'Dialog Test' 			=> '7',
        'LM Facility' 			=> '8',
        'IBM Products' 			=> '9',
        'SCLM' 					=> '10',
        'SDSF' 					=> 'S',
        'ASG Products' 			=> 'A',
        'DB2 / Other' 			=> 'D',
        'User Stuff' 			=> 'U',
        'z/OS User' 			=> 'OU',
        'z/OS System' 			=> 'OS',
        'Exit' 					=> 'x'
    }, 
    
    'SDSF PRIMARY OPTION MENU' => { 
    	'panelTitle' => 'SDSF PRIMARY OPTION MENU',
        'panelID' => 'ISFPCU41', 
        'field_command' 		=> 'COMMAND INPUT ===>',
        'Active users'          => 'DA',       
        'Input queue'           => 'I',  
        'Output queue'          => '0', 
        'Held output queue'     => 'H',
        'Status of jobs'        => 'ST',  
        'System log'            => 'LOG', 
        'Scheduling environments' => 'SE',
        'Exit SDSF  '             => 'END',
        'Health checker'          => 'CK',
        
       
    },  
    
    'Library Utility' => { 
    	'panelTitle' => 'Library Utility',
        'panelID' => 'ISRUDA1', 
        'field_command' => 'Option ===>', 
    },
         
    'ASG-PRO/JCL Main Menu' => {
    	'panelTitle' => 'ASG-PRO/JCL Main Menu', 
        'panelID' => 'D0JPMAI0', 
        'field_command' => 'Option ===>', 
        'File'  => {
        	'Exit'                  => '1', 
            },
        'Help'  => {
        	'Help'                  => '1', 
        	'About ASG-PRO/JCL'     => '2',
            },    

        'Validation'    => '1',
        'Reformatter'   => '2',
        'JMP Utility'   => '3',
        'Directed Execution'  => '4',
        'Machine Definitions' => '5',
        'EPASS'            => '6',
        'Validation - TWS' => '7',
        'Validation - ESP' => '8',
        'Administration'   => '9',
        'Exit'    => 'X', 

    },
   'ASG-PRO/JCL For TWS - JCL Validation' => { 
    	'panelTitle' => 'ASG-PRO/JCL For TWS - JCL Validation',
        'field_command'     => 'D0JPMENU', 
        'Application' 		=> 'Option ===>',
        'Application'       => '1', 
        'Current Plan'		=> '2',
        'Trial Plan' 		=> '3',
        'Exit' 				=> 'x', 
    },
    
  'ASG-PRO/JCL For ESP - JCL Validation' => { 
    	'panelTitle' => 'ASG-PRO/JCL For ESP - JCL Validation',
        'panelID' => 'D0JPESPM', 
        'field_command' 		=> 'Option ===>',
        'Event'			 	=> '1',
        'Schedule' 			=> '2',
        'Exit' 				=> 'x', 
    },
        
  'ASG-PRO/JCL Validation for ESP' => { 
    	'panelTitle' => 'ASG-PRO/JCL Validation for ESP',
        'panelID' => 'D0JPESP5', 
        'field_command' => 'Command ===>', 
        'ESP Subsystem'     =>' ',               
        'Schedule Range'    =>' ',
        'Start'             =>' ', 
        'End'               =>' ', 
        'RTS Member'        =>' ', 
        'First PROCLIB'     =>' ',  
        'Lib Type'          =>' ', 
        'JMP Library'       =>' ', 
        'JMP Name'          =>' ', 
     
    },
         
   'Specify ESP Criteria' => { 
    	'panelTitle' => 'Specify ESP Criteria',
        'panelID' => 'D0JPESP1', 
        'field_command' => 'Command ===>', 
        'ESP Subsystem'     =>  ' ',               
        'Event Prefix'      => ' ',
        'Descriptive Name'  => ' ', 
        'Schedule Time'     => ' ', 
        'Root Job(S)'       => ' ', 
        'RTS Member'        => 'qarts', 
        'First PROCLIB'     => ' ', 
        'Lib Type'          => ' ', 
        'JMP Library'       =>' ', 
        'JMP Name'          =>' ', 
     
    },
   
    
    'ASG-INFO/X Main Menu' => {
    	'panelTitle' => 'ASG-INFO/X Main Menu', 
        'panelID' => 'D0DPMAI0', 
        'field_command' => 'Option ===>', 
        'File'  => {
        	'Exit'          => '1', 
            },
        'Help'  => {
        	'Help'             => '1', 
        	'About ASG-INFO/X' => '2',
            },   
            
        'Query'               =>'1',           
        'Global XREF'         =>'2',        
        'DB2 XREF'            =>'3',           
        'Nodenames'           =>'4',           
        'Reports'             =>'5',            
        'Update'              =>'6',             
        'Folders and Text'    =>'7',   
        'Setup'               =>'8',		               
        'Machine Definitions' =>'9',
        'EPASS'               =>'10',              
        'RTS Member'          =>'11',         
        'Administration'      =>'12',      

    },

    'Edit INFO/X User Configuration' => {
    	'panelTitle' => 'Edit/View INFO/X User Configuration', 
        'panelID' => 'D0DPDIA2', 
        'field_command' => 'Command ===>', 
        'File'  => {
        	'Exit'                       => '1', 
            },      
                 
    },


    'Generate INFO/X Reports From JCL' => { 
    	'panelTitle' => 'Generate INFO/X Reports From JCL',
        'panelID' => 'D0DPRPT0', 
        'field_command' => 'Command ===>',
        'Settings'  => {
        	'RTS Mbr:'                 => '1', 
        	'Scheduler'                  => '2',
        	'Job Card'                   => '3',
            'TSOParms'                   => '4',
            'Selection List'             => '5', 
            'Selection Exit'             => '6', 
            'Reset Between Members'      => '7',
            'First Control Card Lib'     => '8', 
            },
		'File'  => {
            'Edit Input Library'		 => '1',	   
			'Browse Input Library'		 => '2', 
			'View Input Library'   		 => '3', 
			'Exit'                 		 => '4',
            },
         'Help'  => {
            'Help				'		 => '1',
            },	   
    },
    

    'INFO/X Generate & View Batch DB2 Reports' => { 
    	'panelTitle' => 'INFO/X Generate & View Batch DB2 Reports',
        'panelID' => 'D0DPXRF2', 
        'field_command' => 'Command ===>',
        'Settings'  => {
        	'RTS Mbr:'                                          => '1', 
        	'Set Confirmation Options'                          => '2',
        	'Print Setup'                                       => '3',
            'Allow blank entry on Component Name input fields:' => '4',
            'Job Card'                                          => '5', 
            },
		'File'  => {
            'Exit'		                                        => '1',	   
            },
         'Help'  => {
            'Help'                                              => '1',
            },	   
    },
    

    'INFO/X Generate & View Batch Query Reports' => { 
    	'panelTitle' => 'INFO/X Generate & View Batch Query Reports',
        'panelID' => 'D0DPXRF1', 
        'field_command' => 'Command ===>',
        'Settings'  => {
        	'RTS Mbr:'                                               => '1', 
        	'Set Confirmation Options'                               => '2',
        	'Print Setup'                                            => '3',
            'Allow blank entry on Component Name input fields:'      => '4',
            'Display Unreferenced Data Sets on Data Set List panel:' => '5',            
            'Job Card'                                               => '6', 
            },
		'File'  => {
            'Exit'		                                              => '1',	   
            },
         'Help'  => {
            'Help'                                                    => '1',
            },	   
    },



    'Query INFO/X Repository by Application' => { 
    	'panelTitle' => 'Query INFO/X Repository by Application',
        'panelID' => 'D0DPAPP0', 
        'field_command' => 'Command ===>',
      	'File'  => {
            'Print'		 => '1',	   
			'Exit'		 => '2', 
            },
        'Sort'  => {
        	'Application'      => '1', 
        	'Nodename'  	   => '2',
        	'Job Count'        => '3',
            'Description'      => '4',
            'Folder Name'      => '5',
            },
         'Settings'  => {
         	'RTS Mbr:'                       => '1',
            'Set confirmation options'		 => '2',
            'Print Setup...'                 => '3',
            },	   
               
         'Help'  => {
            'Help				'		 => '1',
            },	   
           
    },
    
    'INFO/X JOB List' => { 
    	'panelTitle' => 'INFO/X JOB List',
        'panelID' => 'D0DPENT0', 
        'field_command' => 'Command ===>',
      	'File'  => {
            'Print'		 => '1',	   
			'Exit'		 => '2', 
            },
        'Sort'  => {
        	'JOBname'    		  => '1', 
        	'TYPE'  	  		  => '2',
        	'JOB Lib Name'        => '3',
            'Description'      => '4',
            },
         'Help'  => {
            'Help				'		 => '1',
            },	   
           
    },
    
    'Generate INFO/X Reports from the Repository' => { 
    	'panelTitle' => 'Generate INFO/X Reports from the Repository',
        'panelID' => 'D0DPRPD0', 
        'field_command' => 'Command ===>',
        'Settings'  => {
        	'RTS Mbr:'                   => '1', 
        	'Job Card'                   => '2',
            'Selection List'             => '3', 
            },
		'File'  => {
            'Exit'                 		 => '1',
            },
         'Help'  => {
            'Help				'		 => '1',
            },	   
    },
    'INFO/X Generate & View Batch Query Reports' => { 
    	'panelTitle' => 'INFO/X Generate & View Batch Query Reports',
        'panelID' => 'D0DPXRF1', 
        'field_command' => 'Command ===>',
        'File'  => {
            'Exit'                 		 => '1',
            },
        'Settings'  => {
        	'RTS Mbr:'                   => '1', 
        	'Set Confirmation Options'   => '2',
        	'Print Setup'                => '3',
            'Allow blank entry on Component Name input fields:'             => '4', 
            'Display Unreferenced Data Sets on Data Set List panel:'        => '5', 
            'Job Card'                   => '6',
             },
         'Help'  => {
            'Help				'		 => '1',
            },	   
    },
    
    	'INFO/X Cross Reference for SITE' => { 
    	'panelTitle' => 'INFO/X Cross Reference for SITE',
        'panelID' => 'D0DPXRF0', 
        'field_command' => 'Command ===>',
        'File'  => {
        	'Exit'               => '1',
        	},
		'Settings' => {
            'RTS Mbr:'                      							    => '1',
            'Set confirmation options'      							    => '2',  
            'Print Setup...'	    										    => '3',  
            'Allow blank entry on Component Name input fields: YES'     	=> '4',
            'Display unreferenced data sets on Data Set List panel: YES'    => '5',         		  
	        },
         'Help'  => {
            'Help'		         => '1',
            },	   
    },    
    
   'INFO/X Job List' => { 
    	'panelTitle' => 'INFO/X Job List',
        'panelID' => 'D0DPXJB0', 
        'field_command' => 'Command ===>',
        'File'  => {
        	'Print'              => '1', 
        	'Exit'               => '2',
        	            },
		'Sort' => {
            'JOBname'           => '1',
            'Nodename'          => '2',  
            'Job Library'       => '3',  
            'Description'       => '4',
            'Type'           => '5',         		  
	        },
         'Help'  => {
            'Help'		         => '1',
            },	   
    },

   'INFO/X Job List2' => { 
    	'panelTitle' => 'INFO/X Job List',
        'panelID' => 'D0DPSJB0', 
        'field_command' => 'Command ===>',
        'File'  => {
        	'Print'              => '1', 
        	'Exit'               => '2',
        	            },
		'Sort' => {
            'JOBname'           => '1',
            'Nodename'          => '2',  
            'Job Library'       => '3',  
            'Description'       => '4',
            'Type'              => '5', 
            'Folder'            => '6',        		  
	        },
         'Help'  => {
            'Help'		         => '1',
            },	   
    },

    
    'INFO/X JOB =' => { 
    	'panelTitle' => 'INFO/X JOB =',
        'panelID' => 'D0DPENTJ', 
        'field_command' => 'Command ===>',
        'File'  => {
        	'Print'              => '1', 
        	'Exit'               => '2',
        	            },
		'Help'  => {
            'Help'		         => '1',
            },	   
    },
    
   'INFO/X Program List' => { 
    	'panelTitle' => 'INFO/X Program List',
        'panelID' => 'D0DPXPG0',  
        'field_command' => 'Command ===>',
        'File'  => {
        	'Print'              => '1', 
        	'Exit'               => '2',
        	            },
		'Sort' => {
            'Program Name'     => '1',
            'Uses'             => '2',
            'Load Library'     => '3',
             'Nodename'        => '4',     
             'Folder '         => '5',         		  
	        },
         'Help'  => {
            'Help'		         => '1',
            },	   
    },
        'INFO/X Program List2' => { 
    	'panelTitle' => 'INFO/X Program List2',
        'panelID' => 'D0DPSPG0',  
        'field_command' => 'Command ===>',
        'File'  => {
        	'Print'              => '1', 
        	'Exit'               => '2',
        	            },
		'Sort' => {
            'Program Name'     => '1',
            'Uses'             => '2',
            'Load Library'     => '3',
            'Nodename'        => '4',     
             'Folder '         => '5',         		  
	        },
         'Help'  => {
            'Help'		         => '1',
            },	   
    },   
     
   'INFO/X PROC List' => { 
    	'panelTitle' => 'INFO/X PROC List',
        'panelID' => 'D0DPXPR0', 
        'field_command' => 'Command ===>',
        'File'  => {
        	'Print'              => '1', 
        	'Exit'               => '2',
        	            },
		'Sort' => {
            'PROCname'          => '1',
            'Uses'              => '2',
            'Library Name'      => '3',
            'Nodename'          => '4',  
            'Description'       => '5',   
            'Folder '           => '6',         		  
	        },
         'Help'  => {
            'Help'		         => '1',
            },	   
    },
    
   'INFO/X PROC List2' => { 
    	'panelTitle' => 'INFO/X PROC List',
        'panelID' => 'D0DPSPR0', 
        'field_command' => 'Command ===>',
        'File'  => {
        	'Print'              => '1', 
        	'Exit'               => '2',
        	            },
		'Sort' => {
            'PROCname'          => '1',
            'Uses'              => '2',
            'Library Name'      => '3',
            'Nodename'          => '4',  
            'Description'       => '5',   
            'Folder'            => '6',         		  
	        },
         'Help'  => {
            'Help'		         => '1',
            },	   
    },
    
    
    'INFO/X SYSOUTS List' => { 
    	'panelTitle' => 'INFO/X SYSOUTS List',
        'panelID' => 'D0DPXSY0', 
        'field_command' => 'Command ===>',
        'File'  => {
        	'Print'              => '1', 
        	'Exit'               => '2',
        	            },
		'Sort' => {
            'SYSOUT Class'      => '1',
            'Uses'              => '2',
            'Nodename'          => '3',  
                		  
	        },
         'Help'  => {
            'Help'		         => '1',
            },	   
    },
    
    'INFO/X SYSOUTS' => { 
    	'panelTitle' => 'INFO/X SYSOUTS',
        'panelID' => 'D0DPXSY1',            
        'field_command' => 'Command ===>',
        'File'  => {
        	'Print'              => '1', 
        	'Exit'               => '2',
        	            },
		'Sort' => {
            'JOBname'   			=> '1',         
			'Program'				=> '2',         
			'DDname'				=> '3',          
			'Copy'					=> '4',            
			'Dest'					=> '5',            
			'JOB Library name' 		=> '6',
			'Description'           => '7',     
             },
         'Help'  => {
            'Help'		         => '1',
            },	   
    },
    'INFO/X Data Set List' => { 
    	'panelTitle' => 'INFO/X Data Set List',
        'panelID' => 'D0DPXDS0',  
        'field_command' => 'Command ===>',
        'File'  => {
        	'Print'              => '1', 
        	'Exit'               => '2', 
        	            },
		'Sort' => {
            'Data Set Name'     => '1',
            'Uses'              => '2',
            'Nodename'          => '3',  
                		  
	        },
         'Help'  => {
            'Help'		         => '1',
            },	   
    },
    'INFO/X Data Set XREF' => { 
    	'panelTitle' => 'INFO/X Data Set XREF',
        'panelID' => 'D0DPXDS1',  
        'field_command' => 'Command ===>',
        'File'  => {
        	'Print'              => '1', 
        	'Exit'               => '2', 
        	            },
		'Sort' => {
            'JOBname' 				=> '1',    
			'Stepname'				=> '2',
			'PROCname'				=> '3',   
			'PROCstep'				=> '4',	   
			'Program '				=> '5',		
			'DDname'				=> '6',     
			'IO'					=> '7',         
			'DSP'					=> '8',        
			'LRECL'					=> '9',      
			'RFM'					=> '10',        
			'Job Library'			=> '11',
             },
         'Help'  => {
            'Help'		         => '1',
            },	   
    },
          
          
   'INFO/X INCLUDE List' => { 
    	'panelTitle' => 'INFO/X INCLUDE List',
        'panelID' => 'D0DPXIN0', 
        'field_command' => 'Command ===>',
        'File'  => {
        	'Print'              => '1', 
        	'Exit'               => '2',
        	            },
		'Sort' => {
            'INCLUDE'              => '1',
            'Uses'                 => '2',
            'INCLUDE Library Name' => '3',
            'Nodename'             => '4',  
                		  
	        },
         'Help'  => {
            'Help'		         => '1',
            },	   
    },
    
    'INFO/X IMS PSB List' => { 
    	'panelTitle' => 'INFO/X IMS PSB List',
        'panelID' => 'D0DPXIM0', 
        'field_command' => 'Command ===>',
        'File'  => {
        	'Print'              => '1', 
        	'Exit'               => '2',
        	            },
		'Sort' => {
            'PSB Name'             => '1',
            'Uses'                 => '2',
            'Origin Library name'  => '3',
            'Nodename'             => '4',  
                		  
	        },
         'Help'  => {
            'Help'		         => '1',
            },	   
    },
    
     'INFO/X IMS PSB List2' => { 
    	'panelTitle' => 'INFO/X IMS PSB List',
        'panelID' => 'D0DPSIM0', 
        'field_command' => 'Command ===>',
        'File'  => {
        	'Print'              => '1', 
        	'Exit'               => '2',
        	            },
		'Sort' => {
            'PSB Name'             => '1',
            'Uses'                 => '2',
            'Origin Library name'  => '3',
            'Nodename'             => '4',  
                		  
	        },
         'Help'  => {
            'Help'		         => '1',
            },	   
    },
    
 
 
   
      'INFO/X IMS DBD List' => { 
    	'panelTitle' => 'INFO/X IMS DBD List',
        'panelID' => 'D0DPXIM4', 
        'field_command' => 'Command ===>',
        'File'  => {
        	'Print'              => '1', 
        	'Exit'               => '2',
        	            },
		'Sort' => {
            'DBD Name'             => '1',
            'Uses'                 => '2',
            'ACB Library'          => '3',
            'Nodename'             => '4',  
                		  
	        },
         'Help'  => {
            'Help'		         => '1',
            },	   
    },
                     
         'INFO/X CICS Group List' => { 
    	'panelTitle' => 'INFO/X CICS Group List',
        'panelID' => 'D0DPXCS0', 
        'field_command' => 'Command ===>',
        'File'  => {
        	'Print'              => '1', 
        	'Exit'               => '2',
        	            },
		'Sort' => {
            'CICS Group'           => '1',
            'Nodename'             => '2',
            'CSD File Name'        => '3',
                  		  
	        },
         'Help'  => {
            'Help'		         => '1',
            },	   
    },
        'INFO/X CICS Transaction List' => { 
    	'panelTitle' => 'INFO/X CICS Transaction List',
        'panelID' => 'D0DPXCS1', 
        'field_command' => 'Command ===>',
        'File'  => {
        	'Print'              => '1', 
        	'Exit'               => '2',
        	            },
		'Sort' => {
            'CICS transaction'           => '1',
            'Program'                    => '2',      
            'Group'                      => '3',        
            'Nodename'                   => '4',
            'Description'                => '5',
                  		  
	        },
         'Help'  => {
            'Help'		         => '1',
            },	   
    },

		'INFO/X Control Cards for JOB' => { 
    	'panelTitle' => 'INFO/X Control Cards for JOB',
        'panelID' => 'D0DPOLI9', 
        'field_command' => 'Command ===>',
        'File'  => {
        	'Print'              => '1', 
        	'Exit'               => '2',
            },
		
         'Help'  => {
            'Help'		         => '1',
            },	   
    },

     'INFO/X Update Job Information' => { 
    	'panelTitle' => 'INFO/X Update Job Information',
        'panelID' => 'D0DPRPU0', 
        'field_command' => 'Command ===>',
        'Settings'  => {
        	'RTS Mbr:'                 => '1', 
        	'Scheduler'                  => '2',
        	'Job Card'                   => '3',
            'TSOParms'                   => '4',
            'Selection List'             => '5', 
            'Selection Exit'             => '6',
            'Alternate Userid '          => '7', 
            'Reset Between Members'      => '8',
            'First Control Card Lib'     => '9', 
            },
		'File'  => {
            'Edit Input Library'		 => '1',	   
			'Browse Input Library'		 => '2', 
			'View Input Library'   		 => '3', 
			'Exit'                 		 => '4',
            },
         'Help'  => {
            'Help				'		 => '1',
            },	   
    },

     'INFO/X DB2 Package List' => { 
    	'panelTitle' => 'INFO/X DB2 Package List',
        'panelID' => 'D0DPXD40', 
        'field_command' => 'Command ===>',
		'File'  => {
            'Print'		 => '1',	   
			'Exit'		 => '2', 
            },
        'Sort'  => {
        	'Package'       => '1', 
        	'Collection ID' => '2',
        	'BindDate'      => '3',
            'BindTime'      => '4',
            'BoundBy'       => '5', 
            'Valid'         => '6',
            'Iso'           => '7', 
            'Exp'           => '8',
            'Contoken'      => '9', 
            'Version'       => '10',
            'SSID'          => '11', 
            },

         'Help'  => {
            'Help				'		 => '1',
            },	   
    },

     'INFO/X Package List for Plan' => { 
    	'panelTitle' => 'INFO/X Package List for Plan',
        'panelID' => 'D0DPXD34', 
        'field_command' => 'Command ===>',
		'File'  => {
            'Print'		 => '1',	   
			'Exit'		 => '2', 
            },
        'Sort'  => {
        	'Package'       => '1', 
        	'Collection ID' => '2',
        	'Contoken'      => '3', 
            'Version'       => '4',
             },

         'Help'  => {
            'Help				'		 => '1',
            },	   
    },


     'INFO/X DB2 Package List2' => { 
    	'panelTitle' => 'INFO/X DB2 Package List',
        'panelID' => 'D0DPSD40', 
        'field_command' => 'Command ===>',
		'File'  => {
            'Print'		 => '1',	   
			'Exit'		 => '2', 
            },
        'Sort'  => {
        	'Package'       => '1', 
        	'Collection ID' => '2',
        	'BindDate'      => '3',
            'BindTime'      => '4',
            'BoundBy'       => '5', 
            'Valid'         => '6',
            'Iso'           => '7', 
            'Exp'           => '8',
            'Contoken'      => '9', 
            'Version'       => '10',
            'SSID'          => '11', 
            },

         'Help'  => {
            'Help				'		 => '1',
            },	   
    },

     'INFO/X Table XREF' => { 
    	'panelTitle' => 'INFO/X Table XREF',
        'panelID' => 'D0DPXD21', 
        'field_command' => 'Command ===>',
		'File'  => {
            'Print'		 => '1',	   
			'Exit'		 => '2', 
            },
        'Sort'  => {
        	'Planname'      => '1', 
        	'Collection ID' => '2',
        	'Package'       => '3',
            'TCreator'      => '4',
            'ALT'           => '5', 
            'DEL'           => '6',
            'IND'           => '7', 
            'INS'           => '8',
            'SEL'           => '9', 
            'UPD'           => '10',
        	'Location'      => '11', 
        	'Grantor'       => '12',
        	'Date Granted'  => '13',
            'Time Granted'  => '14',           
            'SSID'          => '15', 
            },

         'Help'  => {
            'Help				'		 => '1',
            },	   
    },

     'INFO/X Table XREF2' => { 
    	'panelTitle' 		=> 'INFO/X Table XREF',
        'panelID'			=> 'D0DPSD21', 
        'field_command' 	=> 'Command ===>',
		'File'  => {
            'Print'		 	=> '1',	   
			'Exit'		 	=> '2', 
            },
        'Sort'  => {
        	'Planname'      => '1', 
        	'Collection ID' => '2',
        	'Package'       => '3',
            'TCreator'      => '4',
            'ALT'           => '5', 
            'DEL'           => '6',
            'IND'           => '7', 
            'INS'           => '8',
            'SEL'           => '9', 
            'UPD'           => '10',
        	'Location'      => '11', 
        	'Grantor'       => '12',
        	'Date Granted'  => '13',
            'Time Granted'  => '14',           
            'SSID'          => '15', 
            },

         'Help'  => {
            'Help'		 	=> '1',
            },	   
    },
    

     'INFO/X DB2 Tables/Views' => { 
    	'panelTitle' => 'INFO/X DB2 Tables/Views',
        'panelID' => 'D0DPXD20', 
        'field_command' => 'Command ===>',
		'File'  => {
            'Print'		 => '1',	   
			'Exit'		 => '2', 
            },
        'Sort'  => {
        	'Table/View'    => '1', 
        	'Type'          => '2',
        	'DBnamee'       => '3',
            'TSname'        => '4',
            'Creator'       => '5', 
            'Location'      => '6',
            'Cols'          => '7', 
            'Date Created'  => '8',
            'Date Updated'  => '9', 
            'SSID'          => '10', 
            },

         'Help'  => {
            'Help'		 => '1',
            },	   
    },


     'INFO/X DB2 Tables/Views2' => { 
    	'panelTitle' => 'INFO/X DB2 Tables/Views',
        'panelID' => 'D0DPSD20', 
        'field_command' => 'Command ===>',
		'File'  => {
            'Print'		 => '1',	   
			'Exit'		 => '2', 
            },
        'Sort'  => {
        	'Table/View'    => '1', 
        	'Type'          => '2',
        	'DBnamee'       => '3',
            'TSname'        => '4',
            'Creator'       => '5', 
            'Location'      => '6',
            'Cols'          => '7', 
            'Date Created'  => '8',
            'Date Updated'  => '9', 
            'SSID'          => '10', 
            },

         'Help'  => {
            'Help'		 => '1',
            },	   
    },

     'INFO/X IMS DBD List' => { 
    	'panelTitle' => 'INFO/X IMS DBD List',
        'panelID' => 'D0DPXIM4', 
        'field_command' => 'Command ===>',
		'File'  => {
            'Print'		 => '1',	   
			'Exit'		 => '2', 
            },
        'Sort'  => {
        	'DBD Name'    => '1', 
        	'Uses'        => '2',
        	'ACB Library' => '3',
            'Nodename'    => '4',
            },

         'Help'  => {
            'Help'		 => '1',
            },	   
    },


     'INFO/X DBD = DEDBDB' => { 
    	'panelTitle' => 'INFO/X DBD = DEDBDB',
        'panelID' => 'D0DPXIM7', 
        'field_command' => 'Command ===>',
		'File'  => {
            'Print'		 => '1',	   
			'Exit'		 => '2', 
            },
        'Sort'  => {
        	'JOBname'      => '1', 
        	'STEPname'     => '2',
        	'Program'      => '3',
            'PSBname'      => '4',
            'JOB Lib Name' => '5',
            },

         'Help'  => {
            'Help'		 => '1',
            },	   
    },

    'INFO/X DBD = DEDBDB2' => { 
    	'panelTitle' => 'INFO/X DBD = DEDBDB',
        'panelID' => 'D0DPSIM7', 
        'field_command' => 'Command ===>',
		'File'  => {
            'Print'		 => '1',	   
			'Exit'		 => '2', 
            },
        'Sort'  => {
        	'JOBname'      => '1', 
            'JOB Lib Name' => '2',
            },

         'Help'  => {
            'Help'		 => '1',
            },	   
    },
    	'Maintain INFO/X Folders and Enter User Text' => { 
    	'panelTitle' => 'Maintain INFO/X Folders and Enter User Text',
        'panelID' => 'D0DPFLD1', 
        'field_command' => 'Command ===>',
        
		'File'  => {
			'Print'                		 => '1',
            'Exit'                 		 => '2',
            },
            
        'Sort'  => {
        	'Name'     				 => '1', 
        	'Update'  			     => '2',
        	'Uses'     				 => '3',
            'Userid'   	 			 => '4',
            'Folder Description'     => '5',
            },
         'Settings'  => {
            'Set confirmation options'		 => '1',
            },	       
          'Help'  => {
            'Help				'		 => '1',
            },	   
    },
    
		'Setup and Maintain INFO/X Repository' => { 
    	'panelTitle' => 'Setup and Maintain INFO/X Repository',
        'panelID' => 'D0DPAPD0', 
        'field_command' => 'Command ===>',
        
		'File'  => {
            'Exit'                 		 => '1',
            },
         'Help'  => {
            'Help				'		 => '1',
            },	   
    },
        
    	'INFO/X Setup and Maintain Applications' => { 
    	'panelTitle' => 'INFO/X Setup and Maintain Applications',
        'panelID' => 'D0DPAPD1', 
        'field_command' => 'Command ===>',
        
		'File'  => {
            'Print'		 => '1',	   
			'Exit'		 => '2', 
            },
        'Sort'  => {
        	'Application'      => '1', 
        	'Criteria'  	   => '2',
        	'Description '     => '3',
            'Job Total'   	   => '4',
            },
         'Settings'  => {
            'Set confirmation options'		 => '1',
            },	   
               
         'Help'  => {
            'Help				'		 => '1',
            },	   
    },
        
		'INFO/X Application List' => { 
    	'panelTitle' => 'INFO/X Application List',
        'panelID' => 'D0DPAPP2', 
        'field_command' => 'Command ===>',
        
		'File'  => {
			'Print'              => '1',
            'Exit'               => '2',
            },
         'Sort'  => {
            'Application'		 => '1',
            'Nodename'           => '2',
            },	   
         'Help'  => {
            'Help'		         => '1',
            },	   
    },
    
    	'INFO/X Setup and Maintain Applications' => { 
    	'panelTitle' => 'INFO/X Setup and Maintain Applications',
        'panelID' => 'D0DPAPD1', 
        'field_command' => 'Command ===>',
        
		'File'  => {
            'Print'		 => '1',	   
			'Exit'		 => '2', 
            },
        'Sort'  => {
        	'Application'      => '1', 
        	'Criteria'  	   => '2',
        	'Description '     => '3',
            'Job Total'   	   => '4',
            },
         'Settings'  => {
            'Set confirmation options'		 => '1',
            },	   
               
         'Help'  => {
            'Help				'		 => '1',
            },	   
    },
        


	'INFO/X History Display' => { 
    	'panelTitle' => 'INFO/X History Display',
        'panelID' => 'D0DPSPH1', 
        'field_command' => 'Command ===>',
        
		'File'  => {
            'Print'		 => '1',	   
			'Exit'		 => '2', 
            },
        'Sort'  => {
        	'Date'     	 	   => '1', 
        	'Time'  		   => '2',
        	'UserID '          => '3',
            'JOBs Added'   	   => '4',
            'JOBs Updated'     => '5',
            'JOBs Deleted'     => '6',
            'Remarks'   	   => '7',
            'Version'   	   => '8',
            },
         'Settings'  => {
            'Set confirmation options'		 => '1',
            },	   
               
         'Help'  => {
            'Help				'		 => '1',
            },	   
    },  
                  
		'INFO/X Nodename List' => { 
    	'panelTitle' => 'INFO/X Nodename List',
        'panelID' => 'D0DPPLA0', 
        'field_command' => 'Command ===>',
        
		'File'  => {
			'Print'              => '1',
            'Exit'               => '2',
            },
         'Sort'  => {
            'Nodename'           => '1',
            'Description'        => '2',
            'Uses'               => '3',
             },
          'Settings'  => {
            'Set confirmation options'           => '1',  
            },	   
         'Help'  => {
            'Help'		         => '1',
            },	   
    },
    
		'INFO/X Entities Used by Nodename' => { 
    	'panelTitle' => 'INFO/X Entities Used by Nodename',
        'panelID' => 'D0DPPLA3', 
        'field_command' => 'Command ===>',
        
		'File'  => {
			'Print'              => '1',
            'Exit'               => '2',
            },
         'Sort'  => {
            'Type'           => '1',
            'Uses'           => '2',
            },	   
         'Help'  => {
            'Help'		         => '1',
            },	   
    },
    
		'INFO/X CICS Groups Used' => { 
    	'panelTitle' => 'INFO/X CICS Groups Used',
        'panelID' => 'D0DPPLAH', 
        'field_command' => 'Command ===>',
        
		'File'  => {
			'Print'              => '1',
            'Exit'               => '2',
            },
         'Sort'  => {
            'CICS GROUP Name'           => '1',
            'CSD File Name'             => '2',
            'GROUP Description'         => '3',
            },	   
         'Help'  => {
            'Help'		         => '1',
            },	   
    },    
    
		'INFO/X CICS Maps Used' => { 
    	'panelTitle' => 'INFO/X CICS Maps Used',
        'panelID' => 'D0DPPLAL', 
        'field_command' => 'Command ===>',
        
		'File'  => {
			'Print'              => '1',
            'Exit'               => '2',
            },
         'Sort'  => {
            'CICS Map'           =>   '1',
            'CSD File'             => '2',
            },	   
         'Help'  => {
            'Help'		         => '1',
            },	   
    },   
  
		'INFO/X CICS Transactions Used' => { 
    	'panelTitle' => 'INFO/X CICS Transactions Used',
        'panelID' => 'D0DPPLAI', 
        'field_command' => 'Command ===>',
        
		'File'  => {
			'Print'              => '1',
            'Exit'               => '2',
            },
         'Sort'  => {
            'Transaction'          => '1',
            'Program'              => '2',
            'Group'                => '3',
            'Description'          => '4',
                        
            },	   
         'Help'  => {
            'Help'		         => '1',
            },	   
    },        

		'INFO/X CSECTs Used ' => { 
    	'panelTitle' => 'INFO/X CSECTs Used ',
        'panelID' => 'D0DPPLAM', 
        'field_command' => 'Command ===>',
        
		'File'  => {
			'Print'              => '1',
            'Exit'               => '2',
            },
         'Sort'  => {
            'CSECT Name'          => '1',
            'Load Lib Name'       => '2',
             },	   
         'Help'  => {
            'Help'		         => '1',
            },	   
    },        
     

		'INFO/X Data Sets Used' => { 
    	'panelTitle' => 'INFO/X Data Sets Used',
        'panelID' => 'D0DPPLAG', 
        'field_command' => 'Command ===>',
        
		'File'  => {
			'Print'              => '1',
            'Exit'               => '2',
            },
         'Sort'  => {
            'Data Set/Sysout Name'          => '1',
             },	   
         'Help'  => {
            'Help'		         => '1',
            },	   
    },   
    
      
		'INFO/X IMS DBDs Used' => { 
    	'panelTitle' => 'INFO/X IMS DBDs Used',
        'panelID' => 'D0DPPLAK', 
        'field_command' => 'Command ===>',
        
		'File'  => {
			'Print'              => '1',
            'Exit'               => '2',
            },
         'Sort'  => {
            'DBD Name'        		    => '1',
            'ACB Lib Name'              => '2',
            'DBD Description'           => '3',
            
                        
            },	   
         'Help'  => {
            'Help'		         => '1',
            },	   
    },        
    
   
		'INFO/X IMS PSBs Used' => { 
    	'panelTitle' => 'INFO/X IMS PSBs Used',
        'panelID' => 'D0DPPLAJ', 
        'field_command' => 'Command ===>',
        
		'File'  => {
			'Print'              => '1',
            'Exit'               => '2',
            },
         'Sort'  => {
            'PSB Name'        		    => '1',
            'Origin Lib Name'           => '2',
            'PSB Description'           => '3',
            
                        
            },	   
         'Help'  => {
            'Help'		         => '1',
            },	   
    }, 
       
		'INFO/X JOBs Used' => { 
    	'panelTitle' => 'INFO/X JOBs Used',
        'panelID' => 'D0DPPLAD', 
        'field_command' => 'Command ===>',
        
		'File'  => {
			'Print'              => '1',
            'Exit'               => '2',
            },
         'Sort'  => {
            'JOB Name'        		    => '1',
            'JOB Lib Name'              => '2',
            'JOB Description'           => '3',
            
                        
            },	   
         'Help'  => {
            'Help'		         => '1',
            },	   
    },                    
		'INFO/X Programs Used' => { 
    	'panelTitle' => 'INFO/X Programs Used',
        'panelID' => 'D0DPPLAF', 
        'field_command' => 'Command ===>',
        
		'File'  => {
			'Print'              => '1',
            'Exit'               => '2',
            },
         'Sort'  => {
            'Program Name'        	     => '1',
            'Load Lib Name'              => '2',

                        
            },	   
         'Help'  => {
            'Help'		         => '1',
            },	   
    },  

		'INFO/X PROCs Used' => { 
    	'panelTitle' => 'INFO/X PROCs Used',
        'panelID' => 'D0DPPLAE', 
        'field_command' => 'Command ===>',
        
		'File'  => {
			'Print'              => '1',
            'Exit'               => '2',
            },
         'Sort'  => {
            'Proc Name'         	     => '1',
            'Proc Lib Name'              => '2',
            'Proc Description'           => '3',
                        
            },	   
         'Help'  => {
            'Help'		         => '1',
            },	   
    },                     
                                                
                         
    'JCL Management Solutions Menu' => { 
    	'panelTitle' => 'JCL Management Solutions Menu',
        'panelID' => 'D0SPMAI0', 
        'field_command' => 'Option ===>', 
        'ASG-INFO/X' => '1',
        'ASG-PRO/JCL' => '2',
        'Password' => '3',
        'System Info' => '4',
        'Exit' => 'X', 
         'File'  => {
        	'Exit'                       => '1', 
            },
        'Help'  => {
        	'Help'                                       => '1', 
        	'About ASG-PRO/JCL and ASG-INFO/X'           => '2',
        	}, 
    },  
    
    'Develop JCL Manipulation Programs' => { 
    	'panelTitle' => 'Develop JCL Manipulation Programs',
        'panelID' => 'D0JPJMP', 
        'field_command' => 'Command ===>', 
        'field_D1' => 'D1',
        
    },    
    
     'Validation Edit' => { 
        'panelID' => 'ISREDDE2', 
        'field_command' => 'Command ===>', 
    },

 	'Define Product Access and Default Settings' => {
 		'panelTitle' => 'Define Product Access and Default Settings',
        'panelID' => 'D0SPDIA1', 
        'field_command' => 'Command ===>',       		
 		'PRO/JCL Menus' => '1', 
 		'INFO/X Menus'  => '1',               
		'PRO/JCL RTS Members' => '2', 
		'INFO/X RTS Members' => '2',         
		'PRO/JCL Product Defaults' => '3',  
		'INFO/X Product Defaults'  => '3',   
		'PRO/JCL Reformatter Members' => '4',  
		'PRO/JCL Reformatter Defaults' => '5',
		'Product Usage' => '6',                
 	},     
        
);
%SMARTFILE = (
	'Primary Options '  => { 
		'tab_forward'   => '1',     # Tab forward to get on command line. 
    	'panelTitle'    => 'Primary Options',
        'panelID'       => 'PDSMENUS', 
        'field_command' => 'OPTION  ===>',
   	 	},  
	'Utilities' => { 
		'tab_forward'   => '1',     # Tab forward to get on command line.
		'LIBRARY'       => '1',
		'DATASET'       => '2',
		'COPY'          => '3',
		'DSLIST'        => '4',
		'VSAM'       	=> '5',
		'GLOBAL'        => '6',
		'VOLUMES'       => '7',
		'SYSTEM'        => '8', 
		'COMPARE'       => '9',   
    	'panelTitle'    => 'Utilities',
        'panelID'       => 'PDSM03', 
        'field_command' => 'OPTION  ===>',
   	 	},     
   	 	   
    'ISPF Command Shell' => { 
    	'panelTitle' => 'ISPF Command Shell',
        'panelID' => 'ISRTSO', 
        'field_command' => '===>',

    },
    'ISPF Primary Option Menu' => { 
    	'panelTitle' => 'ISPF Primary Option Menu',
        'panelID' => 'ISP@MST1', 
        'field_command' 		=> 'Option ===>',
        'Settings'			 	=> '0',
        'View' 					=> '1',
        'Edit' 					=> '2',
        'Utilities' 			=> '3',
        'Foreground' 			=> '4',
        'Batch' 				=> '5',
        'Command' 				=> '6',
        'Dialog Test' 			=> '7',
        'LM Facility' 			=> '8',
        'IBM Products' 			=> '9',
        'SCLM' 					=> '10',
        'SDSF' 					=> 'S',
        'ASG Products' 			=> 'A',
        'DB2 / Other' 			=> 'D',
        'User Stuff' 			=> 'U',
        'z/OS User' 			=> 'OU',
        'z/OS System' 			=> 'OS',
        'Exit' 					=> 'x'
    }, 
    
     'ASG-PRO/JCL For TWS - JCL Validation' => { 
    	'panelTitle' => 'ASG-PRO/JCL For TWS - JCL Validation',
        'panelID' => 'ISP@MST1', 
        'field_command' 	=> 'Option ===>',
        'Application'		=> '1',
        'Current Plan' 		=> '2',
        'Trial Plan' 		=> '3',
        'Exit' 			    => 'X',
        
    }, 
    
    'SDSF PRIMARY OPTION MENU' => { 
    	'panelTitle' => 'SDSF PRIMARY OPTION MENU',
        'panelID' => 'ISFPCU41', 
        'field_command' 		=> 'COMMAND INPUT ===>',
        'Active users'          => 'DA',       
        'Input queue'           => 'I',  
        'Output queue'          => '0', 
        'Held output queue'     => 'H',
        'Status of jobs'        => 'ST',  
        'System log'            => 'LOG', 
        'Scheduling environments' => 'SE',
        'Exit SDSF  '             => 'END',
        'Health checker'          => 'CK',
        
       
    },  
    
    'Library Utility' => { 
    	'panelTitle' => 'Library Utility',
        'panelID' => 'ISRUDA1', 
        'field_command' => 'Option ===>', 
    },

        
);

sub getPanelsMap {
	
	my $ref = \%PROJCL; 
	return $ref;
}


-1;