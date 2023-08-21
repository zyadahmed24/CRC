module CRC (
    input wire DATA,
    input wire ACTIVE,
    input wire CLK,
    input wire RST,
    output reg CRC,
    output reg Valid
);

///////////// Declarations /////////////

//Parameters.
parameter [7:0] SEED = 'hD8;
parameter [7:0] TABS = 'b01000100;

//LFSR declaration.
reg [7:0] LFSR;

//Counter.
reg [3:0] counter;
reg flag;

//Counter.
integer i;


///////////// LFSR Logic /////////////

assign FB = DATA ^ LFSR[0];

always @(posedge CLK or posedge RST)
begin
    if(RST)
    begin
        LFSR <= SEED;
        Valid <= 'b0;
        CRC <= 'b0;
        counter <= 'd0;
        flag <= 0;
    end
    else if (ACTIVE)
    begin
        flag <= 'b1;
        Valid <= 'b0;
        CRC <= 'b0;
        counter <= 'b0;
        LFSR[7] <= FB;
        for(i=0;i<=6;i=i+1)
        begin
            if(!TABS[i])
                LFSR[i] <= LFSR[i+1];
            else
                LFSR[i] <= LFSR[i+1] ^ FB;
        end
    end
    else
    begin
        if(flag == 'b1)
        begin
            counter <= counter + 1;
            if(counter[3] != 'b1)
            begin
                Valid <= 'b1;
                {LFSR [6:0] , CRC} <= LFSR;
            end
            else
            begin
                Valid <= 'b0;
                CRC <= 'b0;
                flag <= 'b0;
            end
        end
    end
end

endmodule