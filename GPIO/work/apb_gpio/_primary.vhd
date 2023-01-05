library verilog;
use verilog.vl_types.all;
entity apb_gpio is
    port(
        PRESETn         : in     vl_logic;
        PCLK            : in     vl_logic;
        PSEL            : in     vl_logic;
        PENABLE         : in     vl_logic;
        PADDR           : in     vl_logic_vector(7 downto 0);
        PWRITE          : in     vl_logic;
        PWDATA          : in     vl_logic_vector(7 downto 0);
        PRDATA          : out    vl_logic_vector(7 downto 0);
        PREADY          : out    vl_logic;
        gpio_i          : in     vl_logic_vector(7 downto 0);
        gpio_o          : out    vl_logic_vector(7 downto 0)
    );
end apb_gpio;
