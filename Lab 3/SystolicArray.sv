module SystolicArray #(
	parameter INPUT_WIDTH = 8,
	parameter ACCUM_WIDTH = 32,
	parameter NUM_SLICES = 3
)(
	input logic CLK,
	input logic signed [INPUT_WIDTH-1:0] W0,
	input logic signed [INPUT_WIDTH-1:0] W1,
	input logic signed [INPUT_WIDTH-1:0] W2,
	
	input logic signed [INPUT_WIDTH-1:0] X_in,
	
	input logic signed [ACCUM_WIDTH-1:0] Yprev, 
	
	output logic signed [ACCUM_WIDTH-1:0] Y0_out,
	output logic signed [ACCUM_WIDTH-1:0] Y1_out,
	output logic signed [ACCUM_WIDTH-1:0] Y2_out
);

	logic signed [INPUT_WIDTH-1:0] X0_to_X1;
	logic signed [INPUT_WIDTH-1:0] X1_to_X2;


	array_slice #(
		.INPUT_WIDTH(INPUT_WIDTH),
		.ACCUM_WIDTH(ACCUM_WIDTH)
	) slice0 (
		.CLK(CLK),
		.W(W0),
		.X(X_in),
		.Yin(Yprev),
		.Xout(X0_to_X1),
		.Yout(Y0_out)
	);


	array_slice #(
		.INPUT_WIDTH(INPUT_WIDTH),
		.ACCUM_WIDTH(ACCUM_WIDTH)
	) slice1 (
		.CLK(CLK),
		.W(W1),
		.X(X0_to_X1),
		.Yin(Y0_out),
		.Xout(X1_to_X2),
		.Yout(Y1_out)
	);


	array_slice #(
		.INPUT_WIDTH(INPUT_WIDTH),
		.ACCUM_WIDTH(ACCUM_WIDTH)
	) slice2 (
		.CLK(CLK),
		.W(W2),
		.X(X1_to_X2),
		.Yin(Y1_out),
		.Xout(),
		.Yout(Y2_out)
	);

endmodule