module Spartan6(A,B,D,C,clk,CARRYIN,opmode,BCIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTopmode,RSTCARRYIN,
CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEopmode,PCIN,BCOUT,P,PCOUT,M,CARRYOUT,CARRYOUTF);

parameter A0REG=0;          // For piplining  
parameter A1REG=1;          // For piplining  
parameter B0REG=0;          // For piplining  
parameter B1REG=1;          // For piplining  
parameter CREG=1;           // For piplining  
parameter DREG=1;           // For piplining  
parameter MREG=1;           // For piplining  
parameter PREG=1;           // For piplining  
parameter CARRYINREG=1;     // For piplining 
parameter CARRYOUTREG=1;    // For piplining 
parameter OPMODEREG=1;      // For piplining 
parameter CARRYINSEL="OPMODE5";     // For Carryin selection
parameter B_INPUT="DIRECT";         // Direct for B and cascade for BCIN
parameter RSTTYPE="SYNC";           // If resets could be sync or async

input  [17:0] A,B,D;     // Inputs
input  [47:0] C;         // Inputs
input  [17:0] BCIN;      // Dedicated BCIN
input   clk;
input   CARRYIN;
input  [7:0] opmode;
input   RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTopmode,RSTCARRYIN;   // Resets
input   CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEopmode;           // Clock enables
input  [47:0] PCIN;
output [17:0] BCOUT;
output [47:0] P;
output [47:0] PCOUT;
output [35:0] M;        // Multiplier data output
output  CARRYOUT;
output  CARRYOUTF;

//OUTPUTS OF MUXS
wire [17:0] D_pipe, B0_pipe, B1_pipe, A0_pipe, A1_pipe, opmode_pipe;   
wire [47:0] C_pipe;             
wire [17:0] B1_INPUT;           ///output of MUX after the pre adder
reg  [47:0] X_out, Z_out;        ///outputs of MUXs X and Z
//OUTPUTS OF FFs
reg  [47:0] C_reg, P_reg ;              
reg  [17:0] D_reg, B0_reg, B1_reg, A0_reg, A1_reg; 
reg  [7:0]  opmode_reg;         
reg  [35:0] M_reg;              
reg   CYI_reg,CYO_reg;          ///OUTPUT OF CYI FF AND CYO FF

reg  [17:0] preAdder_result;     ///OUTPUT of PRE-ADDER/SUBTRACTOR
reg  [35:0] mult_out;            ///OUTPUT of MULTIPLIER
reg  [47:0] concatenated;        ///D:A:B CONCATENATED
wire [47:0] postAdder_result;    ///OUTPUT of POST-ADDER/SUBTRACTOR
wire  carryout;                  ///CARRYOUT of POST-ADDER/SUBTRACTOR
wire  CIN;                       ///CARRYIN for POST-ADDER/SUBTRACTOR

wire [17:0] B_in;
assign B_in = (B_INPUT=="CASCADE") ? BCIN : B;

wire carryin_input;
assign  carryin_input = (CARRYINSEL=="CARRYIN") ? CARRYIN : opmode_pipe[5];

// Generate block for reset logic
generate
    if(RSTTYPE=="ASYNC")begin
            always @(posedge clk or posedge RSTD) begin
                if(RSTD)
                    D_reg <= 18'b0; 
                else if(CED)
                    D_reg <= D; 
            end

            always @(posedge clk or posedge RSTB) begin
                if(RSTB) 
                B0_reg <= 18'b0;
                else if (CEB) 
                B0_reg <= B_in;
            end
            
            always @(posedge clk or posedge RSTB) begin
                if(RSTB) 
                B1_reg <= 18'b0;
                else if (CEB) 
                B1_reg <= B1_INPUT;   
            end
          
            always @(posedge clk or posedge RSTC) begin
                if(RSTC)
                    C_reg <= 48'b0; 
                else if (CEC) 
                    C_reg <= C;
            end

            always @(posedge clk or posedge RSTA) begin
                if(RSTA)
                    A0_reg <= 18'b0;                 
                else if(CEA)
                    A0_reg<= A; 
            end

            always @(posedge clk or posedge RSTA) begin
                if(RSTA)
                    A1_reg <= 18'b0; 
                else if(CEA)
                    A1_reg <= A0_pipe;
            end

            always @(posedge clk or posedge RSTopmode) begin
                if(RSTopmode)
                    opmode_reg <= 8'b0; 
                else if (CEopmode) 
                    opmode_reg <= opmode;
            end

            always @(posedge clk or posedge RSTM) begin
            if(RSTM)
                M_reg <= 36'b0; 
            else if (CEM) 
                M_reg <= mult_out;
            end

            always @(posedge clk or posedge RSTCARRYIN) begin
                if(RSTCARRYIN) 
                CYI_reg <= 1'b0;
                else if (CECARRYIN) 
                CYI_reg <= carryin_input;
            end

            always @(posedge clk or posedge RSTP) begin
                if(RSTP)
                    P_reg <= 48'b0; 
                else if(CEP)
                    P_reg <= postAdder_result; 
            end

            always @(posedge clk or posedge RSTCARRYIN) begin
                if(RSTCARRYIN) 
                CYO_reg <= 1'b0;
                else if (CECARRYIN) 
                CYO_reg <= carryout;
            end
    end

    else begin  ///synchronous rst 
     always @(posedge clk) begin
            //D
            if(RSTD)
                D_reg <= 18'b0; 
            else if(CED)
                D_reg <= D; 
            //B0
            if(RSTB) 
                B0_reg<=18'b0;
            else if (CEB) 
                B0_reg<=B_in;
            //B1
            if(RSTB) 
                B1_reg<=18'b0;
            else if (CEB) 
                B1_reg<=B1_INPUT;
            //C
            if(RSTC)
                C_reg <= 48'b0; 
            else if (CEC) 
                C_reg <= C;
            //A0
            if(RSTA)
                A0_reg <= 18'b0; 
            else if(CEA)
                A0_reg<= A;
            //A1
            if(RSTA)
                A1_reg <= 18'b0; 
            else if(CEA)
                A1_reg <= A0_pipe;
            //OPMODE
            if(RSTopmode)
                opmode_reg <= 8'b0; 
            else if (CEopmode) 
                opmode_reg <= opmode;
            ///M    (multiplier output)    
            if(RSTM)
                M_reg <= 36'b0; 
            else if (CEM) 
                M_reg <= mult_out;
            ///CARRY INPUT CASCADE 
            if(RSTCARRYIN) 
                CYI_reg <= 1'b0;
            else if (CECARRYIN) 
                CYI_reg <= carryin_input;
            ///P OUTPUT
            if(RSTP)
                P_reg <= 48'b0; 
            else if(CEP)
                P_reg <= postAdder_result;
            ///CARRY OUTPUT CASCADE 
            if(RSTCARRYIN) 
                CYO_reg <= 1'b0;
            else if (CECARRYIN) 
                CYO_reg <= carryout;
     end
    end
    endgenerate

    always @(*) begin
        preAdder_result = (opmode_pipe[6])? D_pipe - B0_pipe : D_pipe + B0_pipe;
        mult_out        = B1_pipe * A1_pipe;
        concatenated    = {D_pipe[11:0],A1_pipe,B1_pipe};

        case (opmode_pipe[1:0])
        2'b00: X_out = 48'b0;
        2'b01: X_out = {12'b0,M};
        2'b10: X_out = PCOUT;
        2'b11: X_out = concatenated;
            default: X_out = 48'b0;
        endcase

        case (opmode_pipe[3:2])
        2'b00: Z_out = 48'b0;
        2'b01: Z_out = PCIN;
        2'b10: Z_out = PCOUT;
        2'b11: Z_out = C_pipe;
            default: Z_out = 48'b0;
        endcase
    end

            assign B1_INPUT    = (opmode_pipe[4]) ? preAdder_result : B0_pipe;

            assign D_pipe      = (DREG)  ? D_reg  : D;
            assign B0_pipe     = (B0REG) ? B0_reg : B_in;
            assign B1_pipe     = (B1REG) ? B1_reg : B1_INPUT;
            assign BCOUT       = B1_pipe;
            assign C_pipe      = (CREG)  ? C_reg  : C;
            assign A0_pipe     = (A0REG) ? A0_reg : A;
            assign A1_pipe     = (A1REG) ? A1_reg : A0_pipe;
            assign opmode_pipe = (OPMODEREG) ? opmode_reg : opmode;
            assign M           = (MREG)  ? M_reg  : mult_out;
            assign CIN         = (CARRYINREG) ? CYI_reg : carryin_input;
            assign {carryout,postAdder_result} = (opmode_pipe[7])  ?
                                                 Z_out-(X_out+CIN) :
                                                 Z_out+X_out+CIN   ;

            assign P           = (PREG)  ? P_reg  : postAdder_result;
            assign CARRYOUT    = (CARRYINREG) ? CYO_reg : carryout;
            assign CARRYOUTF   = CARRYOUT;
            assign PCOUT       = P;

endmodule