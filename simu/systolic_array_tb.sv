module systolic_array_tb;
parameter DATAWIDTH = 16;
parameter N_SIZE = 7; //change and test

logic clk, rst_n;
logic valid_in;
logic  [DATAWIDTH-1:0] matrix_a_in [N_SIZE-1:0];
logic  [DATAWIDTH-1:0] matrix_b_in [N_SIZE-1:0];
logic valid_out;
logic  [(2*DATAWIDTH)-1:0] matrix_c_out [N_SIZE-1:0];

systolic_array #(
    .DATAWIDTH(DATAWIDTH),
    .N_SIZE(N_SIZE)
) dut (
    .clk(clk),
    .rst_n(rst_n),
    .valid_in(valid_in),
    .matrix_a_in(matrix_a_in),
    .matrix_b_in(matrix_b_in),
    .valid_out(valid_out),
    .matrix_c_out(matrix_c_out)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    $dumpfile("waveforms.vcd");
    $dumpvars(0, systolic_array_tb);
end
// File logging
integer log_file;
initial begin
    log_file = $fopen("file.log");
    $fdisplay(log_file, "Systolic Array Testbench Log");
    $fdisplay(log_file, "===========================");
    $fdisplay(log_file, "Matrix Size: %0dx%0d", N_SIZE, N_SIZE);
    $fdisplay(log_file, "Data Width: %0d bits", DATAWIDTH);
end
//fn to disp array

function automatic string array_to_string(input logic [2*DATAWIDTH-1:0] arr []);
  automatic string s;
    s = "";
    for (int i = 0; i < N_SIZE; i++) begin
        if (i > 0) s = {s, ", "};
        s = {s, $sformatf("%0d", arr[i])};
    end
    return s;
endfunction

//monitor
string c_str;
always @(posedge clk) begin    
    if (valid_out) begin
         c_str = array_to_string(matrix_c_out);
        $display("[%0t] OUTPUT: valid_out = %b, C = [%s]", 
                 $time, valid_out, c_str);
        $fdisplay(log_file, "[%0t] OUTPUT: valid_out = %b, C = [%s]", 
                  $time, valid_out, c_str);
    end
end

// Reset task
task reset_dut();
    rst_n = 0;
    valid_in = 0;
    for (int i = 0; i < N_SIZE; i++) begin
        matrix_a_in[i] = 0;
        matrix_b_in[i] = 0;
    end
    #20 rst_n = 1;
    $display("[%0t] SYSTEM RESET RELEASED", $time);
    $fdisplay(log_file, "[%0t] SYSTEM RESET RELEASED", $time);
    #10;
endtask

// Task to feed matrix inputs
task feed_matrix(
    input logic [DATAWIDTH-1:0] a_vals [][],
    input logic [DATAWIDTH-1:0] b_vals [][]
);
    for (int col = 0; col < N_SIZE; col++) begin
        for (int i = 0; i < N_SIZE; i++) begin
            matrix_a_in[i] = a_vals[i][col];
        end
        for (int j = 0; j < N_SIZE; j++) begin
            matrix_b_in[j] = b_vals[col][j];
        end
        valid_in = 1;
        #10;
    end
    valid_in = 0;
endtask

// Main test sequence
initial begin
  /*
 // Test 1: 2x2 matrices (ACTIVE)
      // Test matrix: [[1,2],[3,4]] * [[5,6],[7,8]]
     logic [DATAWIDTH-1:0] a_2x2 [2][2] = '{'{1, 2}, '{3, 4}};
     logic [DATAWIDTH-1:0] b_2x2 [2][2] = '{'{5, 6}, '{7, 8}};
    
    reset_dut();
    feed_matrix(a_2x2, b_2x2);
    
    // Wait for results
    #300;

    
    // =================================================================
    // Test 2: 3x3 matrices (COMMENTED OUT)
    // =================================================================
    
    
    // Test matrix: [[1,2,3],[4,5,6],[7,8,9]] * [[9,8,7],[6,5,4],[3,2,1]]
    logic [DATAWIDTH-1:0] a_3x3 [3][3] = '{'{1,2,3}, '{4,5,6}, '{7,8,9}};
    logic [DATAWIDTH-1:0] b_3x3 [3][3] = '{'{9,8,7}, '{6,5,4}, '{3,2,1}};
    reset_dut();
    feed_matrix(a_3x3, b_3x3);
    // Wait for results
    #400;
    
    // =================================================================
    // Test 3: 5x5 matrices (COMMENTED OUT)
    // =================================================================
    
    
    // Test matrix: 
    logic [DATAWIDTH-1:0] a_5x5 [5][5]= '{'{0,1,3,0,2}, '{1,9,0,4,5}, '{0,1,7,8,9},'{0,0,0,1,9},'{1,1,7,5,6}};
    logic [DATAWIDTH-1:0] b_5x5 [5][5]='{'{0,1,2,1,0}, '{1,9,3,2,0}, '{0,1,7,3,9},'{0,2,0,1,6},'{1,1,0,0,3}};

    reset_dut();
    feed_matrix(a_5x5, b_5x5);
    
    // Wait for results
    #500;
    */
    // =================================================================
    // Test 4: 7x7 matrices (COMMENTED OUT)
    // =================================================================
    
    
    // Test matrix: All elements = 1 (result should be 7 in each position)
    logic [DATAWIDTH-1:0] a_7x7 [7][7];
    logic [DATAWIDTH-1:0] b_7x7 [7][7];
    for (int i = 0; i < 7; i++) begin
        for (int j = 0; j < 7; j++) begin
            a_7x7[i][j] = 1;
            b_7x7[i][j] = 1;
        end
    end
    reset_dut();
    feed_matrix(a_7x7, b_7x7);
    
    // Wait for results
    #700;

    $fclose(log_file);
    $finish;
end

endmodule