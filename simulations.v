`timescale 1ns / 1ps

//PART 1

module Register_Test();
    reg En;
    reg CLK;
    reg [1:0] FunSel;
    reg [7:0] I;
    
    wire [7:0] Q;

    reg [1:0] e = 1'b0;
    reg [1:0] f = 2'b00;
     
    reg [7:0] i = 8'b00000000;
     
    n_bitRegister #(.N(8)) R1(.E(En),.CLK(CLK), .FunSel(FunSel), .I(I), .Q(Q));
    always #1 CLK = ~CLK;
    always #100 En = ~En;
    
    initial begin
    I = 8'b10101010;
    En = 1;
    CLK = 0;   
    forever
        begin 
        #5
        for(f = 0; f<3'b100; f = f+1) begin
        #10
        FunSel = f;
        $display("FunSel1:%0d ", f );
        end
        $finish;  
        end
    end
  
endmodule

//PART 2

//Part 2a

module IR_Test();
    reg CLK;
    reg E;
    reg LH;

    reg [1:0] FunSelect;
    reg [7:0] Input;
    
    wire [15:0] Out;
    
    integer i;
    
    IR Ir(.LH(LH),.En(E),.FunSel(FunSelect),.I(Input),.CLK(CLK), .IRout(Out));
    always #5 CLK = ~CLK;
    always #50 E = ~E;
    always #100 LH = ~LH;
    
    initial begin
         Input = 8'b10101010;
         E = 1;
         CLK = 0;
         LH=0;
         forever begin
            #5
            for(i=0; i < 4; i = i + 1) begin
                #10
                FunSelect = i;
                $display("FunSelect: %0d",i);
            end
         end    
    end
endmodule

//Part 2b

module RegFile_Test();
    reg CLK;
    reg [1:0] FunSelect;
    reg [7:0] Input;
    reg [2:0] Out1Select;
    reg [2:0] Out2Select;
    reg [3:0] RSelect;
    reg [3:0] TSelect;
    
    wire [7:0] Output1;
    wire [7:0] Output2;
    
    integer a,j,k;
    RegFile file(.O1Sel(Out1Select),.O2Sel(Out2Select),.FunSel(FunSelect),.RSel(RSelect),.TSel(TSelect),.I(Input),.CLK(CLK),.O1(Output1),.O2(Output2));
    always #1 CLK = ~CLK;
    
     initial begin
     #5
     Input = 8'b10101010;
     CLK = 0;
     for(a=0;a<16;a=a+1) begin
        RSelect = a;
        $display("RegisterSelect: %0d",a);
        for(j=0;j<4;j=j+1) begin
            #10
            FunSelect = j;
            $display("FunSelect: %0d ", j);
            for(k = 0; k < 4; k = k+1)begin
                #5
                Out1Select = k;
                Out2Select = k;
                $display("Out1 and Out2 Select: %0d",k);
            end
        end
     end     
     end
endmodule

//Part 2c

module ARF_Test();
    reg CLK;
    reg [1:0] OutASel;
    reg [1:0] OutBSel; 
    reg [1:0] FunSel; 
    reg [3:0] RegSel; 
    reg [7:0] I;
    wire [7:0] OutA;
    wire [7:0] OutB;

    integer a, j, k;
    ARF arf(.CLK(CLK), .OutASel(OutASel), .OutBSel(OutBSel), .FunSel(FunSel), .RegSel(RegSel), .I(I), .OutA(OutA), .OutB(OutB));
    always #1 CLK = ~CLK;
    
    initial 
    begin
        #5
        I = 8'b10101010;
        CLK = 0;
        for(a=0; a<8; a=a+1)
        begin
            RegSel = a;
            $display("RegisterSelect: %0d", a);
            for(j=0; j < 4; j = j+1) begin
                #10
                FunSel = j;
                $display("FunSel: %0d ", j);
                for(k = 0; k < 4; k = k+1)begin
                    #5
                    OutASel = k;
                    OutBSel = k;
                    $display("Out1 and Out2 Select: %0d", k);
                end
            end
        end     
    end
  
endmodule

//PART 3

module ALU_test();
    reg CLK;
    reg [3:0] FunSel;
    reg [7:0] A;
    reg [7:0] B;
    wire [7:0] OutALU;
    wire [3:0] OutFlag = 4'b0;

    integer a, b, j, k;
    ALU alu(.CLK(CLK), .FunSel(FunSel), .A(A), .B(B), .OutALU(OutALU), .OutFlag(OutFlag));
    always #1 CLK = ~CLK;
    
    initial
    begin
        #5
        A = 8'b01010101;
        B = 8'b01010101;
        CLK = 0;
        for(a=0; a < 256; a=a+1)
        begin
            #10
            A = a;
            $display("A: %0d ", a);
            for(b=0; b < 256; b=b+1)
            begin
                #10
                B = b;
                $display("B: %0d ", b);
                for(j=0; j < 4; j = j+1) 
                begin
                    #10
                    FunSel = j;
                    $display("FunSel: %0d ", j);
                end
            end
        end     
    end
endmodule

`timescale 1ns / 1ps

module Project1Test();
    //Input Registers of ALUSystem
    reg[2:0] RF_O1Sel; 
    reg[2:0] RF_O2Sel; 
    reg[1:0] RF_FunSel;
    reg[3:0] RF_RSel;
    reg[3:0] RF_TSel;
    reg[3:0] ALU_FunSel;
    reg[1:0] ARF_OutASel; 
    reg[1:0] ARF_OutBSel; 
    reg[1:0] ARF_FunSel;
    reg[3:0] ARF_RegSel;
    reg      IR_LH;
    reg      IR_Enable;
    reg[1:0]      IR_Funsel;
    reg      Mem_WR;
    reg      Mem_CS;
    reg[1:0] MuxASel;
    reg[1:0] MuxBSel;
    reg MuxCSel;
    reg      Clock;
    
    //Test Bench Connection of ALU System
    ALUSystem _ALUSystem(
        .RF_O1Sel(RF_O1Sel), 
        .RF_O2Sel(RF_O2Sel), 
        .RF_FunSel(RF_FunSel),                                                  
        .RF_RSel(RF_RSel),  
        .RF_TSel(RF_TSel),
        .ALU_FunSel(ALU_FunSel),
        .ARF_OutASel(ARF_OutASel), 
        .ARF_OutBSel(ARF_OutBSel), 
        .ARF_FunSel(ARF_FunSel),
        .ARF_RegSel(ARF_RegSel),
        .IR_LH(IR_LH),
        .IR_Enable(IR_Enable),
        .IR_Funsel(IR_Funsel),
        .Mem_WR(Mem_WR),
        .Mem_CS(Mem_CS),
        .MuxASel(MuxASel),
        .MuxBSel(MuxBSel),
        .MuxCSel(MuxCSel),
        .Clock(Clock)
        );
    
    //Test Vector Variables
    reg [41:0] VectorNum, Errors, TotalLine; 
    reg [41:0] TestVectors[3:0];
    reg Reset, Operation;
    initial begin
        Reset = 0;
    end
    //Clock Signal Generation
    always 
    begin
        Clock = 1; #5; Clock = 0; #5; // 10ns period
    end
    
    //Read Test Bench Values
    initial begin
        $readmemb("TestBench.mem", TestVectors); // Read vectors
        VectorNum = 0; Errors = 0; TotalLine=0; Reset=0;// Initialize
    end
    
    // Apply test vectors on rising edge of clock
    always @(posedge Clock)
    begin
        #1; 
        {Operation, RF_O1Sel, RF_O2Sel, RF_FunSel, 
        RF_RSel, RF_TSel, ALU_FunSel, ARF_OutASel, ARF_OutBSel, 
        ARF_FunSel, ARF_RegSel, IR_LH, IR_Enable, IR_Funsel, 
        Mem_WR, Mem_CS, MuxASel, MuxBSel, MuxCSel} = TestVectors[VectorNum];
    end
    
    // Check results on falling edge of clk
    always @(negedge Clock)
        if (~Reset) // skip during reset
        begin
            $display("Input Values:");
            $display("Operation: %d", Operation);
            $display("Register File: O1Sel: %d, O2Sel: %d, FunSel: %d, RSel: %d, TSel: %d", RF_O1Sel, RF_O2Sel, RF_FunSel, RF_RSel, RF_TSel);            
            $display("ALU FunSel: %d", ALU_FunSel);
            $display("Addres Register File: OutASel: %d, OutBSel: %d, FunSel: %d, Regsel: %d", ARF_OutASel, ARF_OutBSel, ARF_FunSel, ARF_RegSel);            
            $display("Instruction Register: LH: %d, Enable: %d, FunSel: %d", IR_LH, IR_Enable, IR_Funsel);            
            $display("Memory: WR: %d, CS: %d", Mem_WR, Mem_CS);
            $display("MuxASel: %d, MuxBSel: %d, MuxCSel: %d", MuxASel, MuxBSel, MuxCSel);
            
            $display("");
            $display("Output Values:");
            $display("Register File: AOut: %d, BOut: %d", _ALUSystem.AOut, _ALUSystem.BOut);            
            $display("ALUOut: %d, ALUOutFlag: %d, ALUOutFlags: Z:%d, C:%d, N:%d, O:%d,", _ALUSystem.ALUOut, _ALUSystem.ALUOutFlag, _ALUSystem.ALUOutFlag[3],_ALUSystem.ALUOutFlag[2],_ALUSystem.ALUOutFlag[1],_ALUSystem.ALUOutFlag[0]);
            $display("Address Register File: AOut: %d, BOut (Address): %d", _ALUSystem.AOut, _ALUSystem.Address);            
            $display("Memory Out: %d", _ALUSystem.MemoryOut);            
            $display("Instruction Register: IROut: %d", _ALUSystem.IROut);            
            $display("MuxAOut: %d, MuxBOut: %d, MuxCOut: %d", _ALUSystem.MuxAOut, _ALUSystem.MuxBOut, _ALUSystem.MuxCOut);
            
            // increment array index and read next testvector
            VectorNum = VectorNum + 1;
            if (TestVectors[VectorNum] === 42'bx)
            begin
                $display("%d tests completed.",
                VectorNum);
                $finish; // End simulation
            end
        end
endmodule

module Project2Test();
    reg Clock, Reset;
    reg [7:0] T;
    always 
    begin
        Clock = 1; #5; Clock = 0; #5; // 10ns period
    end
    CPUSystem _CPUSystem( 
            .Clock(Clock),
            .Reset(Reset),
            .T(T)    
        );
endmodule

module top_test();
  reg Clock;
  reg reset;

      top_system top( Clock, reset);
      always begin
         #10; Clock = ~Clock;
      end
      initial begin 

         Clock = 1;
          reset = 1; #101;
         reset = 0; #100;

         #2 $finish;
     end
endmodule
