
module SystolicArray_tb;

	parameter INPUT_WIDTH = 8;
   parameter ACCUM_WIDTH = 32;
	parameter CLK_PERIOD = 10; 

	logic                           CLK;
   logic signed [INPUT_WIDTH-1:0]  W0, W1, W2;
   logic signed [INPUT_WIDTH-1:0]  X_in;
   logic signed [ACCUM_WIDTH-1:0]  Yprev;
   logic signed [ACCUM_WIDTH-1:0]  Y0_out, Y1_out, Y2_out;
	
	SystolicArray #(
		.INPUT_WIDTH(INPUT_WIDTH),
		.ACCUM_WIDTH(ACCUM_WIDTH)
    ) dut (
        .CLK(CLK),
        .W0(W0),
        .W1(W1),
        .W2(W2),
        .X_in(X_in),
        .Yprev(Yprev),
        .Y0_out(Y0_out),
        .Y1_out(Y1_out),
        .Y2_out(Y2_out)
    );
	 
	initial begin
		CLK = 0;
		forever #(CLK_PERIOD/2) CLK = ~CLK;
	end
	 
	task display_state;
		input string label;
		begin
				$display("[%0t] %s | W=[%0d,%0d,%0d] X_in=%0d Yprev=%0d | Y0=%0d Y1=%0d Y2=%0d", 
                     $time, label, W0, W1, W2, X_in, Yprev, Y0_out, Y1_out, Y2_out);
			end
		endtask
	 
		initial begin 
		$display("Systolic Array Testbench");
		$display("INPUT_WIDTH=%0d, ACCUM_WIDTH=%0d", INPUT_WIDTH, ACCUM_WIDTH);
	 
		W0 = 0;
		W1 = 0;
		W2 = 0;
		X_in = 0;
		Yprev = 0;
	 
		repeat(3) @(posedge CLK);
	
		//TEST #1\\ 
		W0 = 8'sd2;
		W1 = 8'sd3;
		W2 = 8'sd4;
		Yprev = 32'sd0;
	 
		@(posedge CLK);
		display_state("INIT");
        
		X_in = 8'sd1;
		@(posedge CLK);
		display_state("X=1 ");
        
		X_in = 8'sd2;
		@(posedge CLK);
		display_state("X=2 ");
        
		X_in = 8'sd3;
		@(posedge CLK);
		display_state("X=3 ");
        
		X_in = 8'sd4;
		@(posedge CLK);
		display_state("X=4 ");
        
		X_in = 8'sd0;
			repeat(5) begin
			@(posedge CLK);
				display_state("PROP");
			end
	  
	  
	  //TEST #2\\ 
		Yprev = 32'sd100;  // Set accumulator offset
        
		@(posedge CLK);
		display_state("INIT");
        
		X_in = 8'sd5;
		@(posedge CLK);
		display_state("X=5 ");
        
		X_in = 8'sd10;
		@(posedge CLK);
		display_state("X=10");
        
		X_in = 8'sd0;
		repeat(5) begin
			@(posedge CLK);
         display_state("PROP");
		end

	  //TEST #3\\ 
		Yprev = 32'sd0;
        
      @(posedge CLK);
      display_state("INIT");
        
      X_in = 8'sd1;   // Stream 1
      @(posedge CLK);
      display_state("S1:1 ");
        
      X_in = 8'sd10;  // Stream 2
      @(posedge CLK);
      display_state("S2:10");
        
      X_in = 8'sd2;   // Stream 1
      @(posedge CLK);
      display_state("S1:2 ");
        
      X_in = 8'sd20;  // Stream 2
      @(posedge CLK);
      display_state("S2:20");
        
      X_in = 8'sd3;   // Stream 1
      @(posedge CLK);
      display_state("S1:3 ");
        
      X_in = 8'sd30;  // Stream 2
      @(posedge CLK);
      display_state("S2:30");
        
      X_in = 8'sd0;
      repeat(6) begin
          @(posedge CLK);
          display_state("PROP");
      end
		
		//Validation of Negative Arithmetic 
		W0 = -8'sd2;   
		W1 = 8'sd3;   
		W2 = -8'sd1;   
		Yprev = -32'sd10;  
	
		@(posedge CLK);
		display_state("INIT");

		X_in = -8'sd5;  
		@(posedge CLK);
		display_state("X=-5");

		X_in = 8'sd4;   
		@(posedge CLK);
		display_state("X=4 ");

		X_in = 8'sd0;
		repeat(5) begin
			@(posedge CLK);
			display_state("PROP");
		end
		
        $display("All test cases completed");
		
        repeat(3) @(posedge CLK);
        $stop;
    end

endmodule