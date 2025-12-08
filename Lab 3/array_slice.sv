module array_slice #(
parameter INPUT_WIDTH = 8,
parameter ACCUM_WIDTH = 32
)(
input logic CLK,
input logic signed [INPUT_WIDTH-1:0] W,
input logic signed [INPUT_WIDTH-1:0] X, 
input logic signed [ACCUM_WIDTH-1:0] Yin,
output logic signed [INPUT_WIDTH-1:0] Xout,
output logic signed [ACCUM_WIDTH-1:0] Yout
);

	logic signed [INPUT_WIDTH-1:0] x_reg;
	logic signed [2*INPUT_WIDTH-1:0] mult_res;
	logic signed [ACCUM_WIDTH-1:0] add_res;
	
	always_ff @(posedge CLK) begin
		x_reg <= X;
	end
	
	assign Xout = x_reg;
	
	assign mult_res = W * x_reg;
	
	assign add_res = $signed(mult_res) + Yin;
	
	always_ff @(posedge CLK) begin
		Yout <= add_res;
	end

endmodule 