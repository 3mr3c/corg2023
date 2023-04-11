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
                I_temp[7:0] = I;
            end
            1: begin
                I_temp[15:8] = I;
            end
        endcase
    end
    
endmodule

//Part 2b

module RegFile (
    input CLK, [2:0] O1Sel, [2:0] O2Sel, [1:0] FunSel, [3:0] RSel,[3:0] TSel, [7:0] I, 
    output [7:0] O1, [7:0] O2
);
    wire [7:0] R1_Q;
    wire [7:0] R2_Q;
    wire [7:0] R3_Q;
    wire [7:0] R4_Q;
    
    wire [7:0] T1_Q;
    wire [7:0] T2_Q;
    wire [7:0] T3_Q;
    wire [7:0] T4_Q;
    
    n_bitRegister #(.N(8)) R1(.CLK(CLK),.E(~RSel[0]), .FunSel(FunSel), .I(I), .Q(R1_Q));
    n_bitRegister #(.N(8)) R2(.CLK(CLK),.E(~RSel[1]), .FunSel(FunSel), .I(I), .Q(R2_Q));
    n_bitRegister #(.N(8)) R3(.CLK(CLK),.E(~RSel[2]), .FunSel(FunSel), .I(I), .Q(R3_Q));
    n_bitRegister #(.N(8)) R4(.CLK(CLK),.E(~RSel[3]), .FunSel(FunSel), .I(I), .Q(R4_Q));
    
    n_bitRegister #(.N(8)) T1(.CLK(CLK),.E(~TSel[0]), .FunSel(FunSel), .I(I), .Q(T1_Q));
    n_bitRegister #(.N(8)) T2(.CLK(CLK),.E(~TSel[1]), .FunSel(FunSel), .I(I), .Q(T2_Q));
    n_bitRegister #(.N(8)) T3(.CLK(CLK),.E(~TSel[2]), .FunSel(FunSel), .I(I), .Q(T3_Q));
    n_bitRegister #(.N(8)) T4(.CLK(CLK),.E(~TSel[3]), .FunSel(FunSel), .I(I), .Q(T4_Q));

    //wire [3:0] R_En;

    reg [7:0] Out1_temp, Out2_temp;
    assign O1 = Out1_temp;
    assign O2 = Out2_temp;
    
    always@(O1Sel) begin
        case (O1Sel)
        0: begin
            Out1_temp = T1_Q;
        end
        1: begin
            Out1_temp = T2_Q;
        end
        2: begin
            Out1_temp = T3_Q;
        end
        3: begin
            Out1_temp = T4_Q;
        end
        4: begin
            Out1_temp = R1_Q;
        end
        5: begin
            Out1_temp = R2_Q;
        end
        6: begin
            Out1_temp = R3_Q;
        end
        7: begin
            Out1_temp = R4_Q;
        end
        default: begin
            Out1_temp = Out1_temp;
        end
        endcase
    end
    always@(O2Sel) begin
        case (O2Sel)
        0: begin
            Out2_temp = T1_Q;
        end
        1: begin
            Out2_temp = T2_Q;
        end
        2: begin
            Out2_temp = T3_Q;
        end
        3: begin
            Out2_temp = T4_Q;
        end
        4: begin
            Out2_temp = R1_Q;
        end
        5: begin
            Out2_temp = R2_Q;
        end
        6: begin
            Out2_temp = R3_Q;
        end
        7: begin
            Out2_temp = R4_Q;
        end
        default: begin
            Out2_temp = Out2_temp;
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
            PC_PREV_Q = PC_Q;
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
            PC_PREV_Q = PC_Q;
        end
        endcase
     end    
endmodule

//Part 3

module ALU (
    input CLK, [3:0] FunSel, input [7:0] A, [7:0] B, 
    output [7:0] OutALU, reg [3:0] OutFlag = 4'b0
);
    
    wire Cin;
    reg [7:0] ALU_result;
    assign Cin = OutFlag[2];
    assign OutALU = ALU_result;
    reg  enable_o;
    
    always @(*) begin 
    case (FunSel)
        4'b0000: begin
            ALU_result <= A;
            enable_o <= 0;
        end
        4'b0001: begin
            ALU_result <= B;
            enable_o <= 0;
        end
        4'b0010: begin
            ALU_result <= ~A;
            enable_o <= 0;
        end
        4'b0011: begin
            ALU_result <= ~B;
            enable_o <= 0;
        end
        4'b0100: begin
            ALU_result <= A + B;
            enable_o <= 1;
        end
        4'b0101: begin
            ALU_result <= A - B;
            enable_o <= 1;
        end
        4'b0110: begin
            ALU_result <= A - B;
            enable_o <= 1;
        end
        4'b0111: begin
            ALU_result <= A & B;
            enable_o <= 0;
        end
        4'b1000: begin
            ALU_result <= A | B;
            enable_o <= 0;
        end
        4'b1001: begin
            ALU_result <= A ^ B;
            enable_o <= 0;
        end
        4'b1010: begin
            OutFlag[2] <= A[7];
            ALU_result <= A << 1;
            enable_o <= 0;
        end
        4'b1011: begin
            OutFlag[2] <= A[0];
            ALU_result <= A >> 1;
            enable_o <= 0;
        end
        4'b1100: begin
            ALU_result <= A <<< 1;
            enable_o <= 0;
        end
        4'b1101: begin
            ALU_result <= A >>> 1;
            enable_o <= 1;
        end
        4'b1110: begin
            OutFlag[2] <= A[7];
            ALU_result[0] <= OutFlag[2];
            ALU_result[1] <= A[0];
            ALU_result[2] <= A[1];
            ALU_result[3] <= A[2];
            ALU_result[4] <= A[3];
            ALU_result[5] <= A[4];
            ALU_result[6] <= A[5];
            ALU_result[7] <= A[6];
            enable_o = 0;
            //ALU_result = {A[6:0], A[7]};
        end
        4'b1111: begin
            OutFlag[2] <= A[0];
            ALU_result[0] <= A[1];
            ALU_result[1] <= A[2];
            ALU_result[2] <= A[3];
            ALU_result[3] <= A[4];
            ALU_result[4] <= A[5];
            ALU_result[5] <= A[6];
            ALU_result[6] <= A[7];
            ALU_result[7] <= OutFlag[2];
            //ALU_result = { A[0], A[7:1]};

            enable_o = 0;
        end
    endcase
    end
    
    always @(negedge CLK) begin
        if(ALU_result == 0) begin
            OutFlag[3] = 1;
        end else begin
            OutFlag[3] = 0;
        end

        if(ALU_result[7] == 1) begin
            OutFlag[1] = 1;
        end else begin
            OutFlag[1] = 0;
        end
        
        if((A[7] == ~ALU_result[7]) && (enable_o)) begin
            OutFlag[0] = 1;
        end
    end
            
endmodule








