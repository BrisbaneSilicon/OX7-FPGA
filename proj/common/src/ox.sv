module ox #(
    parameter int PIN_CHECK_EN = 1
        // NOTE: default for now...
) (
    input             pad_sysclk,

    output reg        pad_cpu_rstn,
    input             pad_cpu_porz,
    input             pad_cpu_rst_status,

    input             pad_gpmc_clk,
    inout      [15:0] pad_gpmc_ad,
    input             pad_gpmc_csn0,
    input             pad_gpmc_oen_ren,
    input             pad_gpmc_wen,
    input             pad_gpmc_be0n_cle,
    input             pad_gpmc_be1n,
    input             pad_gpmc_advn_ale,
    output reg        pad_gpmc_wait0,

    inout      [22:1] pad_hybrid,

    inout      [22:0] pad_gpio_p,
    inout      [22:0] pad_gpio_n,
    inout      [3:0]  pad_gpio_single
);

    generate
        if (PIN_CHECK_EN) begin

            reg [98:0] i_pin_state;
            reg [98:0] i_pin_state_d1;
                // NOTE: max possible sizing...

            assign pad_gpmc_ad      = 16'hzzzz;
            assign pad_hybrid       = {22{1'bz}};
            assign pad_gpio_p       = {23{1'bz}};
            assign pad_gpio_n       = {23{1'bz}};
            assign pad_gpio_single  = 3'bzzz;
                // NOTE: Leave all general-purpose
                // bidirectional pins undriven in
                // the pin-check design.

            always_ff @(posedge pad_sysclk) begin
                i_pin_state <= {
                    pad_cpu_porz,
                    pad_cpu_rst_status,
                    pad_gpmc_ad,
                    pad_gpmc_csn0,
                    pad_gpmc_oen_ren,
                    pad_gpmc_wen,
                    pad_gpmc_be0n_cle,
                    pad_gpmc_be1n,
                    pad_gpmc_advn_ale,
                    pad_hybrid,
                    pad_gpio_p,
                    pad_gpio_n,
                    pad_gpio_single
                };
                i_pin_state_d1 <= i_pin_state;

                if (i_pin_state_d1 != i_pin_state) begin
                    pad_cpu_rstn <= ~pad_cpu_rstn;
                end
            end

            always_ff @(posedge pad_gpmc_clk) begin
                pad_gpmc_wait0 <= ~pad_gpmc_wait0;
            end

        end
    endgenerate

endmodule
