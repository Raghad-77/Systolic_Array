module systolic_array #(parameter DATAWIDTH=16, N_SIZE=5) (
    input clk,
    input rst_n,
    input valid_in,
    input  [DATAWIDTH-1:0]matrix_a_in[N_SIZE-1:0], //column of A
    input  [DATAWIDTH-1:0]matrix_b_in[N_SIZE-1:0], //row of B
    output reg valid_out,
    output reg [(2*DATAWIDTH)-1:0]matrix_c_out[N_SIZE-1:0]
);

wire [DATAWIDTH-1:0] a_in  [0:N_SIZE-1][0:N_SIZE-1];
wire [DATAWIDTH-1:0] b_in  [0:N_SIZE-1][0:N_SIZE-1];
wire [DATAWIDTH-1:0] a_out [0:N_SIZE-1][0:N_SIZE-1];
wire [DATAWIDTH-1:0] b_out [0:N_SIZE-1][0:N_SIZE-1];
wire [(2*DATAWIDTH)-1:0] accum [0:N_SIZE-1][0:N_SIZE-1];
reg clear;
genvar i, j; 

generate
    for (i = 0; i < N_SIZE; i=i+1) 
    begin : row
        for (j = 0; j < N_SIZE; j=j+1) 
        begin : col
            // Boundary connections:
            assign a_in[i][j] = (j == 0) ? matrix_a_in[i]:a_out[i][j-1];
            assign b_in[i][j] = (i == 0) ? matrix_b_in[j]:b_out[i-1][j];
            
            // PE Instantiation
            PE #(.DATAWIDTH(DATAWIDTH)) pe (
            .clk(clk),
            .rst_n(rst_n),
            .clear(clear),
            .a_in(a_in[i][j]),
            .b_in(b_in[i][j]),
            .a_out(a_out[i][j]),
            .b_out(b_out[i][j]),
            .accum(accum[i][j]));
        end
    end
endgenerate

// Control reg
reg [31:0]cycle_count;
reg [2*N_SIZE-1:0] shift_reg;
reg [31:0] read_row;
always @(posedge clk) begin
    if (!rst_n) begin
        shift_reg<=0;
        cycle_count<= 0;
        valid_out<= 0;
        clear<=1;
        read_row<=0;

        for (int i=0; i<N_SIZE; i++) 
        begin
            matrix_c_out[i] <= 0;
        end

    end else 
    begin
        shift_reg <= {shift_reg[2*N_SIZE-2:0], valid_in};
        // Generate valid_out at correct cycles (2N-1 to 3N-2)
        valid_out<=(cycle_count>=2*N_SIZE-1) && (cycle_count < 3*N_SIZE);
 clear <= (cycle_count < N_SIZE-1);
       if (valid_out && read_row < N_SIZE) begin
                matrix_c_out <= accum[read_row];
                read_row <= read_row + 1;
            
        end
        
        cycle_count <= cycle_count + 1;
            
    end
end
endmodule



module PE#(parameter DATAWIDTH=16) ( 
  input  wire clk, rst_n,clear,
  input  wire [DATAWIDTH-1:0]a_in, b_in,    // Inputs from left/top
  output reg [DATAWIDTH-1:0]a_out, b_out,  // Outputs to right/bottom
  output reg [2*DATAWIDTH-1:0] accum          //result
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      a_out  <= 0;
      b_out  <= 0;
      accum  <= 0;
    end 
    else begin
      a_out <= a_in;        // Shift A right
      b_out <= b_in;        // Shift B down
 if (clear)
        accum <= 0;
      else
        accum <= accum + (a_in * b_in);
    end
    end
endmodule