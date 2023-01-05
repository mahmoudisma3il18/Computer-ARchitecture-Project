`timescale 1ns/1ns

module slave(
input PCLK, PRESETn,
input PSEL, PENABLE, PWRITE,
input [7:0] PADDR, PWDATA,
output [7:0] PRDATA,
output reg PREADY);
// Declare registers to hold the address and data
reg [7:0] reg_addr;
reg [7:0] mem [0:255];

// Assign the value at the specified address to PRDATA1
assign PRDATA = mem[reg_addr];

always @(*)
begin
    // If PRESETn is low, set PREADY to 0
    if (!PRESETn)
        PREADY = 0;
    else
    begin
        // If PSEL is high and PENABLE and PWRITE are low, set PREADY to 0
        if (PSEL && !PENABLE && !PWRITE)
            PREADY = 0;
        // If PSEL is high and PENABLE is high and PWRITE is low, set PREADY to 1 and set the address to the value on PADDR
        else if (PSEL && PENABLE && !PWRITE)
        begin
            PREADY = 1;
            reg_addr = PADDR;
        end
        // If PSEL is high and PENABLE is low and PWRITE is high, set PREADY to 0
        else if (PSEL && !PENABLE && PWRITE)
            PREADY = 0;
        // If PSEL is high and PENABLE and PWRITE are high, set PREADY to 1 and write the value on PWDATA to the address specified by PADDR
        else if (PSEL && PENABLE && PWRITE)
        begin
            PREADY = 1;
            mem[PADDR] = PWDATA;
        end
        // Otherwise, set PREADY to 0
        else
            PREADY = 0;
    end
 end  
    
endmodule

