library verilog;
use verilog.vl_types.all;
entity slave is
    port(
        PCLK            : in     vl_logic;
        PRESETn         : in     vl_logic;
        PSEL            : in     vl_logic;
        PENABLE         : in     vl_logic;
        PWRITE          : in     vl_logic;
        PADDR           : in     vl_logic_vector(7 downto 0);
        PWDATA          : in     vl_logic_vector(7 downto 0);
        PRDATA          : out    vl_logic_vector(7 downto 0);
        PREADY          : out    vl_logic
    );
end slave;
