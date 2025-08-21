module Spartan6_tb();

reg [17:0] A, B, D;
reg [47:0] C;
reg [17:0] BCIN;
reg clk;
reg CARRYIN;
reg [7:0] opmode;
reg RSTA, RSTB, RSTM, RSTP, RSTC, RSTD, RSTopmode, RSTCARRYIN;
reg CEA, CEB, CEM, CEP, CEC, CED, CECARRYIN, CEopmode;
reg [47:0] PCIN;

wire [17:0] BCOUT;
wire [47:0] P, PCOUT;
wire [35:0] M;
wire CARRYOUT, CARRYOUTF;

reg [47:0] prev_P;      //For PATH3

    // Instantiate DUT
    Spartan6  dut (A, B, D,C,clk,CARRYIN,opmode,BCIN,
    RSTA, RSTB, RSTM,RSTP,RSTC,RSTD,RSTopmode,RSTCARRYIN,
    CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEopmode,
    PCIN,BCOUT,P,PCOUT,M,CARRYOUT,CARRYOUTF);
    
    initial begin
        clk = 0;
        forever 
        #1 clk = ~clk;
    end

    initial begin
        //Reset inputs
        A = 0; B = 0; C = 0; D = 0;
        BCIN = 0; CARRYIN = 0; PCIN = 0;
        opmode = 0;
        // Activate Resets
        RSTA = 1; RSTB = 1; RSTM = 1; RSTP = 1;
        RSTC = 1; RSTD = 1; RSTopmode = 1; RSTCARRYIN = 1;

        CEA = 1; CEB = 1; CEM = 1; CEP = 1;
        CEC = 1; CED = 1; CECARRYIN = 1; CEopmode = 1;
        @(negedge clk);
        //inputs randomization
        A = $random;    B = $random;    C = $random;    D   = $random;
        opmode    = $random;  BCIN     = $random;   
        CARRYIN   = $random;  PCIN     = $random; 
        @(negedge clk);

        if(BCOUT!=0 || P!=0 || PCOUT != 0 || M!=0 || CARRYOUT!=0 || CARRYOUTF!=0) begin
            $display("Error");
            $stop;
        end
        else
            $display("Reset is done");
        //Deactivate Resets
        RSTA = 0; RSTB = 0; RSTM = 0; RSTP = 0;
        RSTC = 0; RSTD = 0; RSTopmode = 0; RSTCARRYIN = 0;
        repeat(4) @(negedge clk);

        //PATH1
       $display("Verify DSP Path 1");
       opmode = 8'b11011101;
       A = 20; B = 10; C = 350; D = 25;
       BCIN = $random; CARRYIN = $random; PCIN = $random;
        repeat(4) @(negedge clk);

         if (BCOUT !='hf ||M !='h12c ||P !='h32 ||PCOUT !='h32 ||CARRYOUT !=0 ||CARRYOUTF !=0) begin
                $display("Error .... Expected values: BCOUT=%h, M=%h, P=%h,PCOUT=%h, CO=%b, COF=%b",
                         'hf, 'h12c, 'h32,'h32, 0, 0);
                $stop;
                end
            else 
                $display("Passed");
        
        //PATH2
        $display("Verify DSP Path 2");
        opmode = 8'b00010000;
        BCIN = $random; CARRYIN = $random; PCIN = $random;
        repeat(3) @(negedge clk);
        if (BCOUT !='h23 ||M !='h2bc ||P !=0 ||PCOUT !=0 ||CARRYOUT !=0 ||CARRYOUTF !=0) begin
            $display("Error .... Expected values: BCOUT=%h, M=%h, P=%h,PCOUT=%h, CO=%b, COF=%b",
                    'h23, 'h2bc, 0, 0, 0, 0);
            $stop;
        end
        else 
            $display("Passed");

        //PATH3
        @(negedge clk) prev_P = P;

        $display("Verify DSP Path 3");
        opmode = 8'b00001010;
        BCIN = $random; CARRYIN = $random; PCIN = $random;
        repeat(3) @(negedge clk);
        if (BCOUT !='ha ||M !='hc8 ||P !=prev_P ||PCOUT !=prev_P ||CARRYOUT !=0 || CARRYOUTF !=0) begin
            $display("Error .... Expected values: BCOUT=%h, M=%h, P=%h,PCOUT=%h, CO=%b, COF=%b",
                    'ha, 'hc8, prev_P, prev_P, 0, 0);
            $stop;
        end
        else 
            $display("Passed");

        //PATH4
        $display("Verify DSP Path 4");
        opmode = 8'b10100111;
        A = 5; B = 6; C = 350; D = 25; PCIN = 3000;
        BCIN = $random; CARRYIN = $random;
        repeat(3) @(negedge clk);
        if (BCOUT !='h6 ||M !='h1e || P !='hfe6fffec0bb1 ||PCOUT !='hfe6fffec0bb1 ||CARRYOUT !=1 ||CARRYOUTF !=1) begin
            $display("Error .... Expected values: BCOUT=%h, M=%h, P=%h,PCOUT=%h, CO=%b, COF=%b",
                    'h6, 'h1e, 'hfe6fffec0bb1, 'hfe6fffec0bb1, 1, 1);
            $stop;
        end
        else 
            $display("Passed");

     $stop;  
    end
endmodule