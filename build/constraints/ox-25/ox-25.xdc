# Intended Vivado part: xc7s25ftgb196-1
# OSD62x-PM <-> Spartan-7 FTGB196 constraints for module ox
#
# Logical architecture:
#   Bank 14 (VCCO assumed 3.3 V on FPGA side):
#     - pad_gpmc_ad[15:0]
#     - permanent GPMC control
#     - CPU reset/status management
#     - pad_hybrid[22:1]
#   Bank 34:
#     - pad_sysclk on G4 (MRCC)
#     - pad_gpio_p[22:0] / pad_gpio_n[22:0] (23 complete P/N pairs)
#     - pad_gpio_single[2:0]
#
# 99 of 100 FTGB196 user I/Os are assigned. B10/PUDC_B is intentionally
# left unassigned as a user port and must still satisfy configuration-time
# requirements in the schematic.
#
# IMPORTANT:
#   * These IOSTANDARD constraints describe the FPGA side as LVCMOS33.
#     Any AM62x reset/status signal that is not natively 3.3 V must be
#     level-shifted/buffered before reaching the FPGA.
#   * pad_cpu_rstn is assumed to be the FPGA output feeding the external
#     MCU_PORz reset/permit gating circuit; it is not assumed to connect
#     directly to MCU_PORz.
#   * pad_cpu_porz is assumed to be AM62x PORz_OUT observed by the FPGA.
#   * pad_cpu_rst_status is assumed to be AM62x RESETSTATz observed by FPGA.
#   * pad_hybrid[N] is the FPGA ball selectable by 0-ohm stuffing either
#     toward the OSD62x GPMC_A[N]-capable pad or toward a castellated pad.
#
# Dedicated FTGB196 configuration/JTAG balls for schematic reference:
#   CCLK=A8, PROGRAM_B=L7, INIT_B=P8, DONE=P9
#   M0=M7, M1=M8, M2=M9, CFGBVS=N7
#   TCK=A7, TDI=P7, TDO=P6, TMS=M6
#
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]

# -----------------------------------------------------------------------------
# Independent FPGA system clock
# -----------------------------------------------------------------------------
# Bank 34 MRCC; independent FPGA system/reference clock
set_property -dict {PACKAGE_PIN G4 IOSTANDARD LVCMOS33} [get_ports {pad_sysclk}]

# -----------------------------------------------------------------------------
# CPU reset/status management
# -----------------------------------------------------------------------------
# FPGA -> external MCU_PORz reset/permit logic
set_property -dict {PACKAGE_PIN A10 IOSTANDARD LVCMOS33} [get_ports {pad_cpu_rstn}]
# AM62x PORz_OUT -> FPGA
set_property -dict {PACKAGE_PIN F11 IOSTANDARD LVCMOS33} [get_ports {pad_cpu_porz}]
# AM62x RESETSTATz -> FPGA
set_property -dict {PACKAGE_PIN M10 IOSTANDARD LVCMOS33} [get_ports {pad_cpu_rst_status}]

# -----------------------------------------------------------------------------
# Permanent GPMC AD bus
# -----------------------------------------------------------------------------
# GPMC AD0; FPGA configuration D00 capable
set_property -dict {PACKAGE_PIN B11 IOSTANDARD LVCMOS33} [get_ports {pad_gpmc_ad[0]}]
# GPMC AD1; FPGA configuration D01 capable
set_property -dict {PACKAGE_PIN B12 IOSTANDARD LVCMOS33} [get_ports {pad_gpmc_ad[1]}]
# GPMC AD2; FPGA configuration D02 capable
set_property -dict {PACKAGE_PIN D10 IOSTANDARD LVCMOS33} [get_ports {pad_gpmc_ad[2]}]
# GPMC AD3; FPGA configuration D03 capable
set_property -dict {PACKAGE_PIN C10 IOSTANDARD LVCMOS33} [get_ports {pad_gpmc_ad[3]}]
# GPMC AD4; FPGA configuration D04 capable
set_property -dict {PACKAGE_PIN A12 IOSTANDARD LVCMOS33} [get_ports {pad_gpmc_ad[4]}]
# GPMC AD5; FPGA configuration D05 capable
set_property -dict {PACKAGE_PIN A13 IOSTANDARD LVCMOS33} [get_ports {pad_gpmc_ad[5]}]
# GPMC AD6; FPGA configuration D06 capable
set_property -dict {PACKAGE_PIN B13 IOSTANDARD LVCMOS33} [get_ports {pad_gpmc_ad[6]}]
# GPMC AD7; FPGA configuration D07 capable
set_property -dict {PACKAGE_PIN B14 IOSTANDARD LVCMOS33} [get_ports {pad_gpmc_ad[7]}]
# GPMC AD8; FPGA configuration D08 capable
set_property -dict {PACKAGE_PIN C12 IOSTANDARD LVCMOS33} [get_ports {pad_gpmc_ad[8]}]
# GPMC AD9; FPGA configuration D09 capable
set_property -dict {PACKAGE_PIN F12 IOSTANDARD LVCMOS33} [get_ports {pad_gpmc_ad[9]}]
# GPMC AD10; FPGA configuration D10 capable
set_property -dict {PACKAGE_PIN E12 IOSTANDARD LVCMOS33} [get_ports {pad_gpmc_ad[10]}]
# GPMC AD11; FPGA configuration D11 capable
set_property -dict {PACKAGE_PIN D12 IOSTANDARD LVCMOS33} [get_ports {pad_gpmc_ad[11]}]
# GPMC AD12; FPGA configuration D12 capable
set_property -dict {PACKAGE_PIN D13 IOSTANDARD LVCMOS33} [get_ports {pad_gpmc_ad[12]}]
# GPMC AD13; FPGA configuration D13 capable
set_property -dict {PACKAGE_PIN F14 IOSTANDARD LVCMOS33} [get_ports {pad_gpmc_ad[13]}]
# GPMC AD14; FPGA configuration D14 capable
set_property -dict {PACKAGE_PIN F13 IOSTANDARD LVCMOS33} [get_ports {pad_gpmc_ad[14]}]
# GPMC AD15; FPGA configuration D15 capable
set_property -dict {PACKAGE_PIN E13 IOSTANDARD LVCMOS33} [get_ports {pad_gpmc_ad[15]}]

# -----------------------------------------------------------------------------
# Permanent GPMC control
# -----------------------------------------------------------------------------
# GPMC CSn0; FPGA FCS_B multifunction pin
set_property -dict {PACKAGE_PIN C11 IOSTANDARD LVCMOS33} [get_ports {pad_gpmc_csn0}]
# GPMC OEn/REn
set_property -dict {PACKAGE_PIN D14 IOSTANDARD LVCMOS33} [get_ports {pad_gpmc_oen_ren}]
# GPMC WEn
set_property -dict {PACKAGE_PIN C14 IOSTANDARD LVCMOS33} [get_ports {pad_gpmc_wen}]
# GPMC clock; Bank 14 MRCC
set_property -dict {PACKAGE_PIN G11 IOSTANDARD LVCMOS33} [get_ports {pad_gpmc_clk}]
# GPMC BE0n/CLE
set_property -dict {PACKAGE_PIN H11 IOSTANDARD LVCMOS33} [get_ports {pad_gpmc_be0n_cle}]
# GPMC BE1n
set_property -dict {PACKAGE_PIN H12 IOSTANDARD LVCMOS33} [get_ports {pad_gpmc_be1n}]
# GPMC ADVn/ALE
set_property -dict {PACKAGE_PIN H13 IOSTANDARD LVCMOS33} [get_ports {pad_gpmc_advn_ale}]
# GPMC WAIT0
set_property -dict {PACKAGE_PIN H14 IOSTANDARD LVCMOS33} [get_ports {pad_gpmc_wait0}]

# -----------------------------------------------------------------------------
# Hybrid CPU / castellated FPGA I/O
# -----------------------------------------------------------------------------
# Hybrid channel 1: optional CPU/GPMC_A1 or castellation
set_property -dict {PACKAGE_PIN M13 IOSTANDARD LVCMOS33} [get_ports {pad_hybrid[1]}]
# Hybrid channel 2: optional CPU/GPMC_A2 or castellation
set_property -dict {PACKAGE_PIN L14 IOSTANDARD LVCMOS33} [get_ports {pad_hybrid[2]}]
# Hybrid channel 3: optional CPU/GPMC_A3 or castellation
set_property -dict {PACKAGE_PIN L12 IOSTANDARD LVCMOS33} [get_ports {pad_hybrid[3]}]
# Hybrid channel 4: optional CPU/GPMC_A4 or castellation
set_property -dict {PACKAGE_PIN L13 IOSTANDARD LVCMOS33} [get_ports {pad_hybrid[4]}]
# Hybrid channel 5: optional CPU/GPMC_A5 or castellation
set_property -dict {PACKAGE_PIN J11 IOSTANDARD LVCMOS33} [get_ports {pad_hybrid[5]}]
# Hybrid channel 6: optional CPU/GPMC_A6 or castellation
set_property -dict {PACKAGE_PIN J12 IOSTANDARD LVCMOS33} [get_ports {pad_hybrid[6]}]
# Hybrid channel 7: optional CPU/GPMC_A7 or castellation
set_property -dict {PACKAGE_PIN J13 IOSTANDARD LVCMOS33} [get_ports {pad_hybrid[7]}]
# Hybrid channel 8: optional CPU/GPMC_A8 or castellation
set_property -dict {PACKAGE_PIN J14 IOSTANDARD LVCMOS33} [get_ports {pad_hybrid[8]}]
# Hybrid channel 9: optional CPU/GPMC_A9 or castellation
set_property -dict {PACKAGE_PIN K11 IOSTANDARD LVCMOS33} [get_ports {pad_hybrid[9]}]
# Hybrid channel 10: optional CPU/GPMC_A10 or castellation
set_property -dict {PACKAGE_PIN K12 IOSTANDARD LVCMOS33} [get_ports {pad_hybrid[10]}]
# Hybrid channel 11: optional CPU/GPMC_A11 or castellation
set_property -dict {PACKAGE_PIN M11 IOSTANDARD LVCMOS33} [get_ports {pad_hybrid[11]}]
# Hybrid channel 12: optional CPU/GPMC_A12 or castellation
set_property -dict {PACKAGE_PIN M12 IOSTANDARD LVCMOS33} [get_ports {pad_hybrid[12]}]
# Hybrid channel 13: optional CPU/GPMC_A13 or castellation
set_property -dict {PACKAGE_PIN N14 IOSTANDARD LVCMOS33} [get_ports {pad_hybrid[13]}]
# Hybrid channel 14: optional CPU/GPMC_A14 or castellation
set_property -dict {PACKAGE_PIN M14 IOSTANDARD LVCMOS33} [get_ports {pad_hybrid[14]}]
# Hybrid channel 15: optional CPU/GPMC_A15 or castellation
set_property -dict {PACKAGE_PIN P12 IOSTANDARD LVCMOS33} [get_ports {pad_hybrid[15]}]
# Hybrid channel 16: optional CPU/GPMC_A16 or castellation
set_property -dict {PACKAGE_PIN P13 IOSTANDARD LVCMOS33} [get_ports {pad_hybrid[16]}]
# Hybrid channel 17: optional CPU/GPMC_A17 or castellation
set_property -dict {PACKAGE_PIN N10 IOSTANDARD LVCMOS33} [get_ports {pad_hybrid[17]}]
# Hybrid channel 18: optional CPU/GPMC_A18 or castellation
set_property -dict {PACKAGE_PIN N11 IOSTANDARD LVCMOS33} [get_ports {pad_hybrid[18]}]
# Hybrid channel 19: optional CPU/GPMC_A19 or castellation
set_property -dict {PACKAGE_PIN P10 IOSTANDARD LVCMOS33} [get_ports {pad_hybrid[19]}]
# Hybrid channel 20: optional CPU/GPMC_A20 or castellation
set_property -dict {PACKAGE_PIN P11 IOSTANDARD LVCMOS33} [get_ports {pad_hybrid[20]}]
# Hybrid channel 21: optional CPU/GPMC_A21 or castellation
set_property -dict {PACKAGE_PIN G14 IOSTANDARD LVCMOS33} [get_ports {pad_hybrid[21]}]
# Hybrid channel 22: optional CPU/GPMC_A22 or castellation
set_property -dict {PACKAGE_PIN E11 IOSTANDARD LVCMOS33} [get_ports {pad_hybrid[22]}]

# -----------------------------------------------------------------------------
# Permanent castellated FPGA P/N GPIO pairs
# -----------------------------------------------------------------------------
# Castellated FPGA differential-capable P channel 0
set_property -dict {PACKAGE_PIN D3 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_p[0]}]
# Castellated FPGA differential-capable N channel 0
set_property -dict {PACKAGE_PIN C3 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_n[0]}]
# Castellated FPGA differential-capable P channel 1
set_property -dict {PACKAGE_PIN A4 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_p[1]}]
# Castellated FPGA differential-capable N channel 1
set_property -dict {PACKAGE_PIN A3 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_n[1]}]
# Castellated FPGA differential-capable P channel 2
set_property -dict {PACKAGE_PIN B3 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_p[2]}]
# Castellated FPGA differential-capable N channel 2
set_property -dict {PACKAGE_PIN A2 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_n[2]}]
# Castellated FPGA differential-capable P channel 3
set_property -dict {PACKAGE_PIN B5 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_p[3]}]
# Castellated FPGA differential-capable N channel 3
set_property -dict {PACKAGE_PIN A5 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_n[3]}]
# Castellated FPGA differential-capable P channel 4
set_property -dict {PACKAGE_PIN B2 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_p[4]}]
# Castellated FPGA differential-capable N channel 4
set_property -dict {PACKAGE_PIN B1 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_n[4]}]
# Castellated FPGA differential-capable P channel 5
set_property -dict {PACKAGE_PIN C5 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_p[5]}]
# Castellated FPGA differential-capable N channel 5
set_property -dict {PACKAGE_PIN C4 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_n[5]}]
# Castellated FPGA differential-capable P channel 6
set_property -dict {PACKAGE_PIN E4 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_p[6]}]
# Castellated FPGA differential-capable N channel 6
set_property -dict {PACKAGE_PIN D4 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_n[6]}]
# Castellated FPGA differential-capable P channel 7
set_property -dict {PACKAGE_PIN F3 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_p[7]}]
# Castellated FPGA differential-capable N channel 7
set_property -dict {PACKAGE_PIN F2 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_n[7]}]
# Castellated FPGA differential-capable P channel 8
set_property -dict {PACKAGE_PIN G1 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_p[8]}]
# Castellated FPGA differential-capable N channel 8
set_property -dict {PACKAGE_PIN F1 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_n[8]}]
# Castellated FPGA differential-capable P channel 9
set_property -dict {PACKAGE_PIN E2 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_p[9]}]
# Castellated FPGA differential-capable N channel 9
set_property -dict {PACKAGE_PIN D2 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_n[9]}]
# Castellated FPGA differential-capable P channel 10
set_property -dict {PACKAGE_PIN D1 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_p[10]}]
# Castellated FPGA differential-capable N channel 10
set_property -dict {PACKAGE_PIN C1 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_n[10]}]
# Castellated FPGA differential-capable P channel 11
set_property -dict {PACKAGE_PIN H4 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_p[11]}]
# Castellated FPGA differential-capable N channel 11
set_property -dict {PACKAGE_PIN H3 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_n[11]}]
# Castellated FPGA differential-capable P channel 12
set_property -dict {PACKAGE_PIN H2 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_p[12]}]
# Castellated FPGA differential-capable N channel 12
set_property -dict {PACKAGE_PIN H1 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_n[12]}]
# Castellated FPGA differential-capable P channel 13
set_property -dict {PACKAGE_PIN J2 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_p[13]}]
# Castellated FPGA differential-capable N channel 13
set_property -dict {PACKAGE_PIN J1 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_n[13]}]
# Castellated FPGA differential-capable P channel 14
set_property -dict {PACKAGE_PIN K4 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_p[14]}]
# Castellated FPGA differential-capable N channel 14
set_property -dict {PACKAGE_PIN K3 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_n[14]}]
# Castellated FPGA differential-capable P channel 15
set_property -dict {PACKAGE_PIN J4 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_p[15]}]
# Castellated FPGA differential-capable N channel 15
set_property -dict {PACKAGE_PIN J3 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_n[15]}]
# Castellated FPGA differential-capable P channel 16
set_property -dict {PACKAGE_PIN M1 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_p[16]}]
# Castellated FPGA differential-capable N channel 16
set_property -dict {PACKAGE_PIN L1 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_n[16]}]
# Castellated FPGA differential-capable P channel 17
set_property -dict {PACKAGE_PIN M3 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_p[17]}]
# Castellated FPGA differential-capable N channel 17
set_property -dict {PACKAGE_PIN M2 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_n[17]}]
# Castellated FPGA differential-capable P channel 18
set_property -dict {PACKAGE_PIN P2 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_p[18]}]
# Castellated FPGA differential-capable N channel 18
set_property -dict {PACKAGE_PIN N1 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_n[18]}]
# Castellated FPGA differential-capable P channel 19
set_property -dict {PACKAGE_PIN P4 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_p[19]}]
# Castellated FPGA differential-capable N channel 19
set_property -dict {PACKAGE_PIN P3 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_n[19]}]
# Castellated FPGA differential-capable P channel 20
set_property -dict {PACKAGE_PIN L3 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_p[20]}]
# Castellated FPGA differential-capable N channel 20
set_property -dict {PACKAGE_PIN L2 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_n[20]}]
# Castellated FPGA differential-capable P channel 21
set_property -dict {PACKAGE_PIN M5 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_p[21]}]
# Castellated FPGA differential-capable N channel 21
set_property -dict {PACKAGE_PIN M4 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_n[21]}]
# Castellated FPGA differential-capable P channel 22
set_property -dict {PACKAGE_PIN P5 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_p[22]}]
# Castellated FPGA differential-capable N channel 22
set_property -dict {PACKAGE_PIN N4 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_n[22]}]

# -----------------------------------------------------------------------------
# Permanent castellated FPGA single-ended GPIO
# -----------------------------------------------------------------------------
# Castellated FPGA single-ended GPIO
set_property -dict {PACKAGE_PIN B6 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_single[0]}]
# Castellated FPGA single-ended GPIO
set_property -dict {PACKAGE_PIN L5 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_single[1]}]
# N-side mate of pad_sysclk MRCC pair; single-ended GPIO only in this pin map
set_property -dict {PACKAGE_PIN F4 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_single[2]}]
# Castellated FPGA single-ended GPIO
set_property -dict {PACKAGE_PIN B10 IOSTANDARD LVCMOS33} [get_ports {pad_gpio_single[3]}]


# Clock declarations
# Update these periods to match the fitted oscillator / selected GPMC timing.
# 50 MHz FPGA oscillator example:
create_clock -name SYSCLK -period 20.000 [get_ports pad_sysclk]
# 133.333 MHz synchronous GPMC example:
create_clock -name GPMC_CLK -period 7.500 [get_ports pad_gpmc_clk]