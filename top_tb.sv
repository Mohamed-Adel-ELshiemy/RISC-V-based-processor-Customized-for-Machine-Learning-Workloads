`timescale 1ns/1ns

module top_tb();
// parameters 
//  parameter INSTR_RDATA_WIDTH = 32	;
//  parameter ADDR_WIDTH = 32			;		// Consistent with PicoRV32
//  parameter BOOT_ADDR  = 'h0		;
// port of  Clock and Reset
	  // Clock and Reset
	logic                   		clk_i		;
	logic                   		rstn_i		;
	
	// Debug Interface
//	logic       			debug_req_i		;
//	logic       			debug_gnt_o		;
//	logic       			debug_rvalid_o	;
//	logic 	[14:0]			debug_addr_i	;
//	logic       			debug_we_i		;
//	logic 	[31:0]			debug_wdata_i	;
//	logic 	[31:0]			debug_rdata_o	;
//	logic       			debug_halted_o	;
	

 // CPU Control Signals
//	logic                   	fetch_enable_i	;
	logic                   	core_busy_o		;
	
// Instantiate the top 
 
	top 
	DUT (
		.clk_i			(clk_i			) ,
		.rstn_i			(rstn_i			) ,
/* 		.debug_req_i	(debug_req_i	) ,
		.debug_gnt_o	(debug_gnt_o	) ,
		.debug_rvalid_o	(debug_rvalid_o	) ,
		.debug_addr_i	(debug_addr_i	) ,
		.debug_we_i		(debug_we_i		) ,
		.debug_wdata_i	(debug_wdata_i	) ,
		.debug_rdata_o	(debug_rdata_o	) ,
		.debug_halted_o	(debug_halted_o	) , */
//		.fetch_enable_i	(fetch_enable_i	) ,
		.core_busy_o	(core_busy_o	)
		);
// generate clock to sequence tests
always
	begin
		clk_i = 1; # 5; clk_i = 0; # 5;
	end
// initialize test
initial
    begin
//        rstn_i 			= 1 ; 
//		fetch_enable_i  = 0 ;
//        #30
         rstn_i = 0;
        #10
        rstn_i = 1;
//		#40
//		fetch_enable_i = 1 ;
//		#30
//		fetch_enable_i = 0 ;
//		#40
//		debug_req_i = 1 ;
//		debug_we_i	= 1 ;
		
		#30
		
		#1300;
		$stop;
    end 


endmodule 