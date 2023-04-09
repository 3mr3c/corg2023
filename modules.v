// Part 1

module n_bitRegister #(parameter N = 8) (
    input CLK, E, [1:0] FunSel, [N-1:0] I,
    output [N-1:0] Q
);

    reg [N-1:0] Q_temp;
    assign Q = Q_temp;
    always @( posedge CLK ) begin
    if(E) begin
        case (FunSel)
        0: begin
            Q_temp = 0;
        end
        1: begin
            Q_temp = I;
        end
        2: begin
            Q_temp = Q - 1;
        end
        3: begin
            Q_temp = Q + 1;
        end
        default: begin
            Q_temp = Q_temp;
        end
        endcase
    end else begin
    
        Q_temp = Q;
    end
    end
    
endmodule

//Part 2

//Part 2a

module IR (
    input CLK, LH, En, [1:0] FunSel, [7:0] I,
    output [15:0] IRout
);
    reg [15:0] I_temp; //reg
    wire [15:0] IR_Q;
    
    n_bitRegister #(.N(16)) IR(.CLK(CLK),.E(En), .FunSel(FunSel), .I(I_temp), .Q(IR_Q));
    
    assign IRout = IR_Q;

    always @(LH) begin
        case (LH)
            0: begin
                I_temp[15:8] = I;
            end
            1: begin
                I_temp[7:0] = I;
            end
        endcase
    end
    
endmodule

//Part 2c
module ARF (
    input CLK, [1:0] OutASel, [1:0] OutBSel, [1:0] FunSel, [3:0] RegSel, [7:0] I,
    output [7:0] OutA, [7:0] OutB
);

    wire [7:0] PC_Q;
    wire [7:0] AR_Q;
    wire [7:0] SP_Q;
    wire [7:0] PC_PREV_Q;
    
    n_bitRegister #(.N(8)) PC(.CLK(CLK),.E(~RegSel[0]), .FunSel(FunSel), .I(I), .Q(PC_Q));
    n_bitRegister #(.N(8)) AR(.CLK(CLK),.E(~RegSel[1]), .FunSel(FunSel), .I(I), .Q(AR_Q));
    n_bitRegister #(.N(8)) SP(.CLK(CLK),.E(~RegSel[2]), .FunSel(FunSel), .I(I), .Q(SP_Q));
    n_bitRegister #(.N(8)) PCPAST(.CLK(CLK),.E(~RegSel[0]), .FunSel(FunSel), .I(I), .Q(PC_PREV_Q));


    reg [7:0] OutA_temp, OutB_temp;
    assign OutA = OutA_temp;
    assign OutB = OutB_temp;

    always@(OutASel) begin
        case (OutASel)
        0: begin
            OutA_temp = AR_Q;
        end
        1: begin
            OutA_temp = SP_Q;
        end
        2: begin
            OutA_temp = PC_PREV_Q;
        end
        3: begin
            OutA_temp = PC_Q;
            PC_PREV_Q = PC_Q;
        end
        default: begin
            OutA_temp = OutA_temp;
        end
        endcase
    end

    always@(OutBSel) begin
        case (OutBSel)
        0: begin
            OutB_temp = AR_Q;
        end
        1: begin
            OutB_temp = SP_Q;
        end
        2: begin
            OutB_temp = PC_PREV_Q;
        end
        3: begin
            OutB_temp = PC_Q;
            PC_PREV_Q = PC_Q;
        end
        default: begin
            OutB_temp = OutB_temp;
        end
        endcase
     end    
endmodule


module RegFile (
    input CLK, [1:0] OutASel, [1:0] OutBSel, [1:0] FunSel, [3:0] RegSel, [7:0] I, 
    output [7:0] OutA, [7:0] OutB
);
    wire [7:0] R1_Q;
    wire [7:0] R2_Q;
    wire [7:0] R3_Q;
    wire [7:0] R4_Q;
    n_bitRegister #(.N(8)) R1(.CLK(CLK),.E(~RegSel[0]), .FunSel(FunSel), .I(I), .Q(R1_Q));
    n_bitRegister #(.N(8)) R2(.CLK(CLK),.E(~RegSel[1]), .FunSel(FunSel), .I(I), .Q(R2_Q));
    n_bitRegister #(.N(8)) R3(.CLK(CLK),.E(~RegSel[2]), .FunSel(FunSel), .I(I), .Q(R3_Q));
    n_bitRegister #(.N(8)) R4(.CLK(CLK),.E(~RegSel[3]), .FunSel(FunSel), .I(I), .Q(R4_Q));

    //wire [3:0] R_En;

    reg [7:0] OutA_temp, OutB_temp;
    assign OutA = OutA_temp;
    assign OutB = OutB_temp;
    always@(OutASel) begin
        case (OutASel)
        0: begin
            OutA_temp = R1_Q;
        end
        1: begin
            OutA_temp = R2_Q;
        end
        2: begin
            OutA_temp = R3_Q;
        end
        3: begin
            OutA_temp = R4_Q;
        end
        default: begin
            OutA_temp = OutA_temp;
        end
        endcase
    end
    always@(OutBSel) begin
        case (OutBSel)
        0: begin
            OutB_temp = R1_Q;
        end
        1: begin
            OutB_temp = R2_Q;
        end
        2: begin
            OutB_temp = R3_Q;
        end
        3: begin
            OutB_temp = R4_Q;
        end
        default: begin
            OutB_temp = OutB_temp;
        end
        endcase
    end

endmodule
