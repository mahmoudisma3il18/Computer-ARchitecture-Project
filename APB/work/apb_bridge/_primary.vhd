library verilog;
use verilog.vl_types.all;
entity apb_bridge is
    port(
        apb_write_paddr : in     vl_logic_vector(7 downto 0);
        apb_read_paddr  : in     vl_logic_vector(7 downto 0);
        apb_write_data  : in     vl_logic_vector(7 downto 0);
        PRDATA          : in     vl_logic_vector(7 downto 0);
        PRESETn         : in     vl_logic;
        PCLK            : in     vl_logic;
        READ_WRITE      : in     vl_logic;
        transfer        : in     vl_logic;
        PREADY          : in     vl_logic;
        PSEL            : out    vl_logic;
        PENABLE         : out    vl_logic;
        PADDR           : out    vl_logic_vector(7 downto 0);
        PWRITE          : out    vl_logic;
        PWDATA          : out    vl_logic_vector(7 downto 0);
        apb_read_data_out: out    vl_logic_vector(7 downto 0);
        PSLVERR         : out    vl_logic
    );
end apb_bridge;
