`include "APB_Master.v"
`include "APB_Slave.v"


`timescale 1ns/1ns

module APB_Protocol(
input PCLK, PRESETn, transfer, READ_WRITE,  // inputs
input [7:0] apb_write_paddr,
input [7:0] apb_write_data,
input [7:0] apb_read_paddr,
output PSLVERR,  // outputs
output [7:0] apb_read_data_out);

// Declare wires for signals used in communication between modules
wire [7:0] PWDATA, PRDATA;
wire [7:0] PADDR;
wire PREADY, PENABLE, PSEL, PWRITE;


// Connect PRDATA to the appropriate value based on READ_WRITE]
// If READ_WRITE is high, PRDATA is passed through
// If READ_WRITE is low, PRDATA is set to 8'dx dont care
assign PRDATA =  PRDATA ;

// Instantiate the masterx,slavex modules
apb_bridge masterx(
    apb_write_paddr,
    apb_read_paddr,
    apb_write_data,
    PRDATA,
    PRESETn,
    PCLK,
    READ_WRITE,
    transfer,
    PREADY,
    PSEL,
    PENABLE,
    PADDR,
    PWRITE,
    PWDATA,
    apb_read_data_out,
    PSLVERR
);

slave slavex(PCLK, PRESETn, PSEL, PENABLE, PWRITE, PADDR[7:0], PWDATA, PRDATA, PREADY);

endmodule

