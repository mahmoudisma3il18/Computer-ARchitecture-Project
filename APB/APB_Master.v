`timescale 1ns/1ns

module apb_bridge(
input [7:0]apb_write_paddr,apb_read_paddr,        // Adresses for read and write operation
input [7:0] apb_write_data,PRDATA,                // Data for write operation, read data from slave
input PRESETn,PCLK,READ_WRITE,transfer,PREADY,    // Reset, clock, read/write, transfer, ready signal
output PSEL,                                      // Select signal for slave
output reg PENABLE,                               // Enable, address, write/read, write data, read data, error signals
output reg [7:0]PADDR,
output reg PWRITE,
output reg [7:0]PWDATA,apb_read_data_out,
output PSLVERR ); 

   

reg [2:0] state, next_state;                     // State and next state variables

reg invalid_setup_error,                        // Error flags
      setup_error,
      invalid_read_paddr,
      invalid_write_paddr,
      invalid_write_data ;
  
localparam IDLE = 3'b001, SETUP = 3'b010, ENABLE = 3'b100 ; // Constant values for state machine



always @(posedge PCLK) // APB Works on rising edge
begin
    if (!PRESETn) // Active Low
        state <= IDLE;
    else
        state <= next_state; 
end



always @(state, transfer, PREADY)
begin
    if (!PRESETn) // Active Low
        next_state = IDLE;
    else
    begin
        PWRITE = ~READ_WRITE;  // Invert read/write signal  , PWRITE=1 indicates APB write access(Master to slave) PWRITE=0 indicates APB read access(Slave to master)
        case (state)
            IDLE:
                begin
                    PENABLE = 0;  // Disable enable signal
                    if (!transfer)
                        next_state = IDLE;  // Stay in IDLE if transfer is not valid
                    else
                        next_state = SETUP;  // Go to SETUP state if transfer is valid
                end
            SETUP:
                begin
                    PENABLE = 0;  // Disable enable signal
                    if (READ_WRITE)
                        PADDR = apb_read_paddr;  // Set adress for read operation
                    else
                    begin
                        PADDR = apb_write_paddr;  // Set adress for write operation
                        PWDATA = apb_write_data;
                    end
                    if (transfer && !PSLVERR)  // Check if transfer is valid and there is no error
                        next_state = ENABLE;    // Go to ENABLE state
                    else
                        next_state = IDLE;
                end
            ENABLE:
                begin
                    if (PSEL)
                        PENABLE = 1;
                    if (transfer & !PSLVERR)
                    begin
                        if (PREADY)
                        begin
                            if (!READ_WRITE)
                                next_state = SETUP;
                            else
                            begin
                                next_state = SETUP;
                                apb_read_data_out = PRDATA;
                            end
                        end
                        else
                            next_state = ENABLE;
                    end
                    else
                        next_state = IDLE;
                end
            default:
                next_state = IDLE;
        endcase
    end
end


 
assign {PSEL} = ((state != IDLE) ? 1'd1 : 1'd0);

  // PSLVERR LOGIC
  
always @(*)
begin
    if (!PRESETn)  // Check if reset is active
    begin        
        setup_error = 0;   // Reset errors
        invalid_read_paddr = 0;
        invalid_write_paddr = 0;
        invalid_write_paddr = 0;
    end
    else
    begin
        if (state == IDLE && next_state == ENABLE) // Check if there is a setup error when moving from IDLE to ENABLE state
            setup_error = 1;
        else
            setup_error = 0;
        if ((apb_write_data === 8'dx) && (!READ_WRITE) && (state == SETUP || state == ENABLE))  // Check if there is an invalid write data when in SETUP or ENABLE state and not in read mode
            invalid_write_data = 1;
        else
            invalid_write_data = 0;
        if ((apb_read_paddr === 8'dx) && READ_WRITE && (state == SETUP || state == ENABLE))     // Check if there is an invalid read address when in SETUP or ENABLE state and in read mode
            invalid_read_paddr = 1;
        else
            invalid_read_paddr = 0;
        if ((apb_write_paddr === 8'dx) && (!READ_WRITE) && (state == SETUP || state == ENABLE)) // Check if there is an invalid write address when in SETUP or ENABLE state and not in read mode
            invalid_write_paddr = 1;
        else
            invalid_write_paddr = 0;
        if (state == SETUP)
        begin
            if (PWRITE)  // Check if there is a setup error when in SETUP state
            begin
                if (PADDR == apb_write_paddr && PWDATA == apb_write_data)  // Check if write address and data match expected values
                    setup_error = 1'b0;
                else
                    setup_error = 1'b1;
            end
            else
            begin
                if (PADDR == apb_read_paddr)   // Check if read address matches expected value
                    setup_error = 1'b0;
                else
                    setup_error = 1'b1;
            end
        end
        else
            setup_error = 1'b0; // Reset setup error when not in SETUP state
    end
    invalid_setup_error = setup_error || invalid_read_paddr || invalid_write_data || invalid_write_paddr;  // Assign invalid setup error to PSLVERR
end
assign PSLVERR = invalid_setup_error;

endmodule

