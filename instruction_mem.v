//`timescale 1ns/1ns

module instruction_mem (
						input 		[10:0] 	a			,
                        input        	    instr_req_i	,
                        output	reg        	instr_gnt_o	,	instr_rvalid_o	,
						output 	reg	[31:0]	rd
						);
(* ram_style = "distributed" *)				 
reg [31:0] RAM [0:2047];

initial
	begin
		$readmemh ("C:/Users/NU/Desktop/Newcastle Riscy/test.txt",RAM);
	end

always @(*)
begin 
    if(instr_req_i)
        begin
            if (a < 11'd2047)
            begin
                instr_rvalid_o  = 1'b1  ;    
                rd              = RAM[a];
                instr_gnt_o     = 1'b1  ;
            end          
        end
    else 
        begin
            instr_gnt_o    	= 1'b0	;
            instr_rvalid_o 	= 1'b0	;
            rd 				= 32'b0	;
        end
end

endmodule