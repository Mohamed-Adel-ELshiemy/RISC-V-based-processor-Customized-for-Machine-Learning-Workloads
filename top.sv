// Top level wrapper for RI5CY

// Copyright (C) 2017 Embecosm Limited <www.embecosm.com>

// Contributor: Jeremy Bennett <jeremy.bennett@embecosm.com>

// This program is free software: you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation, either version 3 of the License, or (at your option)
// any later version.

// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of  MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
// more details.

// You should have received a copy of the GNU General Public License along with
// this program.  If not, see <http://www.gnu.org/licenses/>.


// This instantiates memory and (eventually) a debug interface for the core.

module top
#(
  parameter INSTR_RDATA_WIDTH = 32	,
  parameter ADDR_WIDTH = 32			,		// Consistent with PicoRV32
  parameter BOOT_ADDR  = 'h0				// Consistent with Pulpino
  )
(
  // Clock and Reset
	input  logic                clk_i	,
	input  logic                rstn_i	,
/* 	 // Interrupt inputs
	input  logic	[31:0] 		irq_i	, // level sensitive IR lines
	
	// Debug Interface
	input  logic       			debug_req_i		,
	output logic       			debug_gnt_o		,
	output logic       			debug_rvalid_o	,
	input  logic 	[14:0]		debug_addr_i	,
	input  logic       			debug_we_i		,
	input  logic 	[31:0]		debug_wdata_i	,
	output logic 	[31:0]		debug_rdata_o	,
	output logic       			debug_halted_o	,
 */

 // CPU Control Signals
//	input  logic            fetch_enable_i		,
	output logic            core_busy_o
 
 );
 // instruction memory 
	wire 	              		instr_req_o		;
	wire 	              		instr_gnt_i		;
	wire 	              		instr_rvalid_i	;
	wire	[ADDR_WIDTH-1:0] 	instr_addr_o	;
	wire 	[31:0] 	      		instr_rdata_i	;

// data memory 
	wire 		  				data_req_o		;
	wire 		  				data_gnt_i		;
	wire 		  				data_rvalid_i	;
	wire	[ADDR_WIDTH-1:0]	data_addr_o		;
	wire 		  				data_we_o		;
	wire 	[3:0] 		 	 	data_be_o		;	
	wire 	[31:0] 	  			data_rdata_i	;
	wire 	[31:0] 	  			data_wdata_o	;
  // Interrupt inputs
	logic [31:0] irq_i;
 // Debug Interface
	logic        				debug_req_i		;
	logic        				debug_gnt_o		;
	logic        				debug_rvalid_o	;
	logic 	[14:0] 				debug_addr_i	;
	logic        				debug_we_i		;
	logic 	[31:0] 				debug_wdata_i	;
	logic 	[31:0] 				debug_rdata_o	;
	logic        				debug_halted_o	;


   // Instantiate the core

   riscv_core
     #(
       .INSTR_RDATA_WIDTH (INSTR_RDATA_WIDTH)
       )
   riscv_core_i
     (
      .clk_i               ( clk_i          	),
      .rst_ni              ( rstn_i         	),
	
      .clock_en_i          ( '0             	),
      .test_en_i           ( '0             	),
	
      .boot_addr_i         ( BOOT_ADDR      	),
      .core_id_i           ( 4'h0           	),
      .cluster_id_i        ( 6'h0           	),

      .instr_addr_o        ( instr_addr_o     	),
      .instr_req_o         ( instr_req_o      	),
      .instr_rdata_i       ( instr_rdata_i    	),
      .instr_gnt_i         ( instr_gnt_i      	),
      .instr_rvalid_i      ( instr_rvalid_i   	),
	
      .data_addr_o         ( data_addr_o      	),
      .data_wdata_o        ( data_wdata_o     	),
      .data_we_o           ( data_we_o        	),
      .data_req_o          ( data_req_o       	),
      .data_be_o           ( data_be_o        	),
      .data_rdata_i        ( data_rdata_i     	),
      .data_gnt_i          ( data_gnt_i       	),
      .data_rvalid_i       ( data_rvalid_i    	),
      .data_err_i          ( 1'b0           	),
	
      .irq_i               ( irq_i          	),
	
      .debug_req_i         ( debug_req_i    	),
      .debug_gnt_o         ( debug_gnt_o    	),
      .debug_rvalid_o      ( debug_rvalid_o 	),
      .debug_addr_i        ( debug_addr_i   	),
      .debug_we_i          ( debug_we_i     	),
      .debug_wdata_i       ( debug_wdata_i  	),
      .debug_rdata_o       ( debug_rdata_o  	),
      .debug_halted_o      ( debug_halted_o 	),
      .debug_halt_i        ( 1'b0           	),	// Not used in single core
      .debug_resume_i      ( 1'b0           	),	// Not used in single core
	
//      .fetch_enable_i      ( fetch_enable_i 	),
      .core_busy_o         ( core_busy_o    	),
	
      .ext_perf_counters_i ( 1'b0               	)
      );

//   //instantiation of data_memory
//  data_mem data_memory(
//                        .clk			(clk_i			),
//                        .rst			(rstn_i			),
//                        .data_req_i		(data_req_o		),
//                        .data_gnt_o		(data_gnt_i		),
//                        .data_rvalid_o	(data_rvalid_i	), 
//                        .we				(data_we_o		),
//				        .a				(data_addr_o	),
//				        .data_be_i		(data_be_o		), 
//				        .wd				(data_wdata_o	),
//				        .rd				(data_rdata_i	)
//				       );


//instantiation of data_memory
/////////////////////////////////////////////////////////////////////////////////////////////////////

xilinx_bram #(
    .NB_COL(4),                           // Specify number of columns (number of bytes)
    .COL_WIDTH(8),                        // Specify column width (byte width, typically 8 or 9)
    .RAM_DEPTH(1024),                     // Specify RAM depth (number of entries)
    .RAM_PERFORMANCE("LOW_LATENCY"),      // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
    .INIT_FILE("")                        // Specify name/location of RAM initialization file if using one (leave blank if not)
  ) xilinx_bram_uut(
    .addra(data_addr_o[9:0]),             // Address bus, width determined from RAM_DEPTH
    .dina(data_wdata_o),                  // RAM input data
    .data_req_i(data_req_o),
    .data_gnt_o(data_gnt_i),
    .data_rvalid_o(data_rvalid_i),
    .clka(clk_i),                         // Clock
    .wea(data_be_o),                      // Byte-write enable
    .ena(data_we_o),                      // RAM Enable, for additional power savings, disable port when not in use
    .douta(data_rdata_i)                  // RAM output data
  );


/////////////////////////////////////////////////////////////////////////////////////////////////////




  //instantiation of instruction_memory				       
  instruction_mem instruction_memory( 
                         .instr_req_i	(instr_req_o		),
                         .instr_gnt_o	(instr_gnt_i		),
                         .instr_rvalid_o(instr_rvalid_i		),
                         .a				(instr_addr_o[12:2]	),                      
				         .rd			(instr_rdata_i		)
					      );	
endmodule	// top
