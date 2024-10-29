module FFT (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [18:0] real_in [0:7],
    input wire [18:0] imag_in [0:7],
    output reg [18:0] real_out [0:7],
    output reg [18:0] imag_out [0:7],
    output reg done
);
    localparam W0R =  19'b0100000000000000000;
    localparam W0I =  19'b0000000000000000000;
    localparam W1R =  19'b0010110101000001001;
    localparam W1I = -19'b0010110101000001001;
    localparam W2R =  19'b0000000000000000000;
    localparam W2I = -19'b0100000000000000000;
    localparam W3R = -19'b0010110101000001001;
    localparam W3I = -19'b0010110101000001001;
    reg [18:0] real_temp [0:7];
    reg [18:0] imag_temp [0:7];
    reg [2:0] stage;
    reg [2:0] count;
    function [37:0] complex_mult;
        input [18:0] ar, ai, br, bi;
        reg [37:0] res_r, res_i;
        begin
            res_r = (ar * br - ai * bi) >>> 17;
            res_i = (ar * bi + ai * br) >>> 17;
            complex_mult = {res_r[18:0], res_i[18:0]};
        end
    endfunction
    task butterfly;
        input [18:0] ar, ai, br, bi, wr, wi;
        output [18:0] ar_out, ai_out, br_out, bi_out;
        reg [37:0] temp;
        begin
            temp = complex_mult(br, bi, wr, wi);
            ar_out = ar + temp[37:19];
            ai_out = ai + temp[18:0];
            br_out = ar - temp[37:19];
            bi_out = ai - temp[18:0];
        end
    endtask
    always @(posedge clk ) begin
        if (reset) begin
            stage <= 0;
            count <= 0;
            done <= 0;
        end else if (start) begin
            case (stage)
                0: begin
                    for (int i = 0; i < 8; i = i + 1) begin
                        real_temp[i] <= real_in[i];
                        imag_temp[i] <= imag_in[i];
                    end
                    stage <= 1;
                    count <= 0;
                end
                1: begin
                    butterfly(real_temp[count], imag_temp[count], 
                              real_temp[count+4], imag_temp[count+4], 
                              W0R, W0I,
                              real_temp[count], imag_temp[count],
                              real_temp[count+4], imag_temp[count+4]);
                    count <= count + 1;
                    if (count == 3) begin
                        stage <= 2;
                        count <= 0;
                    end
                end
                2: begin
                    case (count)
                        0, 1: butterfly(real_temp[count], imag_temp[count], 
                                        real_temp[count+2], imag_temp[count+2], 
                                        W0R, W0I,
                                        real_temp[count], imag_temp[count],
                                        real_temp[count+2], imag_temp[count+2]);
                        2, 3: butterfly(real_temp[count], imag_temp[count], 
                                        real_temp[count+2], imag_temp[count+2], 
                                        W2R, W2I,
                                        real_temp[count], imag_temp[count],
                                        real_temp[count+2], imag_temp[count+2]);
                    endcase
                    count <= count + 1;
                    if (count == 3) begin
                        stage <= 3;
                        count <= 0;
                    end
                end
                3: begin
                    case (count)
                        0: butterfly(real_temp[0], imag_temp[0], real_temp[1], imag_temp[1], W0R, W0I,
                                     real_temp[0], imag_temp[0], real_temp[1], imag_temp[1]);
                        1: butterfly(real_temp[2], imag_temp[2], real_temp[3], imag_temp[3], W2R, W2I,
                                     real_temp[2], imag_temp[2], real_temp[3], imag_temp[3]);
                        2: butterfly(real_temp[4], imag_temp[4], real_temp[5], imag_temp[5], W1R, W1I,
                                     real_temp[4], imag_temp[4], real_temp[5], imag_temp[5]);
                        3: butterfly(real_temp[6], imag_temp[6], real_temp[7], imag_temp[7], W3R, W3I,
                                     real_temp[6], imag_temp[6], real_temp[7], imag_temp[7]);
                    endcase
                    count <= count + 1;
                    if (count == 3) begin
                        stage <= 4;
                    end
                end
                4: begin
                    for (int i = 0; i < 8; i = i + 1) begin
                        real_out[i] <= real_temp[i];
                        imag_out[i] <= imag_temp[i];
                    end
                    done <= 1;
                    stage <= 0;
                end
            endcase
        end
    end
endmodule