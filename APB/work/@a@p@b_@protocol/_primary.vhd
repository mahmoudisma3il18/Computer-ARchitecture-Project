library verilog;
use verilog.vl_types.all;
entity APB_Protocol is
    port(
        PCLK            : in     vl_logic;
        PRESETn         : in     vl_logic;
        transfer        : in     vl_logic;
        READ_WRITE      : in     vl_logic;
        apb_write_paddr : in     vl_logic_vector(7 downto 0);
        apb_write_data  : in     vl_logic_vector(7 downto 0);
        apb_read_paddr  : in     vl_logic_vector(7 downto 0);
        PSLVERR         : out    vl_logic;
        apb_read_data_out: out    vl_logic_vector(7 downto 0)
    );
end APB_Protocol;
