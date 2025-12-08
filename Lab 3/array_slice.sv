module array_slice #(
parameter IPNUT_WIDTH = 8,
parameter ACCUM_WIDTH = 32
)(
input logic CLK,
input logic [IPNUT_WIDTH-1:0] W,
input logic [IPNUT_WIDTH-1:0] X, 
input logic [ACCUM_WIDTH-1:0] Yin,
output logic [IPNUT_WIDTH-1:0] Xout,
output logic [ACCUM_WIDTH-1:0] Yout
);

	logic [IPNUT_WIDTH-1:0] x_reg;
	logic [2*IPNUT_WIDTH-1:0] mult_res;
	logic [ACCUM_WIDTH-1:0] add_res;
	
	always_ff @(posedge CLK) begin
		x_reg <= X;
	end
	
	assign Xout = x_reg;
	
	assign mult_result = W * x_reg;
	
	assign add_result = $signed(mult_result) + Yin;
	
	always_ff @(posedge CLK) begin
		Yout <= add_res;
	end

endmodule 