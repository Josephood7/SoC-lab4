// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * user_project_wrapper
 *
 * This wrapper enumerates all of the pins available to the
 * user for the user project.
 *
 * An example user project is provided in this wrapper.  The
 * example should be removed and replaced with the actual
 * user project.
 *
 *-------------------------------------------------------------
 */

module user_project_wrapper #(
    parameter BITS = 32
) (
`ifdef USE_POWER_PINS
    inout vdda1,	// User area 1 3.3V supply
    inout vdda2,	// User area 2 3.3V supply
    inout vssa1,	// User area 1 analog ground
    inout vssa2,	// User area 2 analog ground
    inout vccd1,	// User area 1 1.8V supply
    inout vccd2,	// User area 2 1.8v supply
    inout vssd1,	// User area 1 digital ground
    inout vssd2,	// User area 2 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // Analog (direct connection to GPIO pad---use with caution)
    // Note that analog I/O is not available on the 7 lowest-numbered
    // GPIO pads, and so the analog_io indexing is offset from the
    // GPIO indexing by 7 (also upper 2 GPIOs do not have analog_io).
    inout [`MPRJ_IO_PADS-10:0] analog_io,

    // Independent clock (on independent integer divider)
    input   user_clock2,

    // User maskable interrupt signals
    output [2:0] user_irq
);

/*--------------------------------------*/
/* User project is instantiated  here   */
/*--------------------------------------*/

user_proj_example mprj (
`ifdef USE_POWER_PINS
	.vccd1(vccd1),	// User area 1 1.8V power
	.vssd1(vssd1),	// User area 1 digital ground
`endif

    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),

    // MGMT SoC Wishbone Slave

    .wbs_cyc_i(wbs_cyc_o_exmem),
    .wbs_stb_i(wbs_stb_o_exmem),
    .wbs_we_i(wbs_we_o_exmem),
    .wbs_sel_i(wbs_sel_o_exmem),
    .wbs_adr_i(wbs_adr_o_exmem),
    .wbs_dat_i(wbs_dat_o_exmem),
    .wbs_ack_o(wbs_ack_o_exmem),
    .wbs_dat_o(wbs_dat_o_exmem),

    // Logic Analyzer

    .la_data_in(la_data_in),
    .la_data_out(la_data_out),
    .la_oenb (la_oenb),

    // IO Pads

    .io_in (io_in),
    .io_out(io_out),
    .io_oeb(io_oeb),

    // IRQ
    .irq(user_irq)
);

wb_decoder wb_decoder (
   //////////////////////////////////WB_axi
    .wbs_clk_o_axi(wbs_clk_o_axi),
    .wbs_rst_o_axi(wbs_rst_o_axi),
    .wbs_cyc_o_axi(wbs_cyc_i_axi),
    .wbs_stb_o_axi(wbs_stb_i_axi),
    .wbs_we_o_axi(wbs_we_i_axi),
    .wbs_sel_o_axi(wbs_sel_i_axi),
    .wbs_adr_o_axi(wbs_adr_i_axi),
    .wbs_dat_o_axi(wbs_dat_i_axi),
    .wbs_ack_i_axi(wbs_ack_o_axi),
    .wbs_dat_i_axi(wbs_dat_o_axi), 
    //////////////////////////////////exmem
    .wbs_clk_o_exmem(wbs_clk_o_exmem),
    .wbs_rst_o_exmeme(wbs_rst_o_exmeme),
    .wbs_cyc_o_exmem(wbs_cyc_i_exmem),
    .wbs_stb_o_exmem(wbs_stb_i_exmem),
    .wbs_we_o_exmem(wbs_we_i_exmem),
    .wbs_sel_o_exmem(wbs_sel_i_exmem),
    .wbs_adr_o_exmem(wbs_adr_i_exmem),
    .wbs_dat_o_exmem(wbs_dat_i_exmem),
    .wbs_ack_i_exmem(wbs_ack_o_exmem),
    .wbs_dat_i_exmem(wbs_dat_o_exmem), 
    //////////////////////////////////host
    .wbs_clk_i(wbs_clk_i),
    .wbs_rst_i(wbs_rst_i),
    .wbs_cyc_i(wbs_cyc_i),
    .wbs_stb_i(wbs_stb_i),
    .wbs_we_i(wbs_we_i),
    .wbs_sel_i(wbs_sel_i),
    .wbs_adr_i(wbs_adr_i),
    .wbs_dat_i(wbs_dat_i),
    .wbs_ack_o(wbs_ack_o),
    .wbs_dat_o(wbs_dat_o)
);

wb_axi wb_axi (
    //////////////////////////////////WB
    .wbs_clk_i(wbs_clk_o_axi),
    .wbs_rst_i(wbs_rst_o_axi),
    .wbs_cyc_i(wbs_cyc_o_axi),
    .wbs_stb_i(wbs_stb_o_axi),
    .wbs_we_i(wbs_we_o_axi),
    .wbs_sel_i(wbs_sel_o_axi),
    .wbs_adr_i(wbs_adr_o_axi),
    .wbs_dat_i(wbs_dat_o_axi),
    .wbs_ack_o(wbs_ack_i_axi),
    .wbs_dat_o(wbs_dat_i_axi),
    /////////////////////////////////AXI
    .awready(awready),
    .wready(wready),
    .awvalid(awvalid),
    .awaddr(awaddr),
    .wvalid(wvalid),
    .wdata(wdata),
    .arready(arready),
    .rready(rready),
    .arvalid(arvalid),
    .araddr(araddr),
    .rvalid(rvalid),
    .rdata(rdata),    
    .ss_tvalid(ss_tvalid), 
    .ss_tdata(ss_tdata), 
    .ss_tlast(ss_tlast), 
    .ss_tready(ss_tready), 
    .sm_tready(sm_tready), 
    .sm_tvalid(sm_tvalid), 
    .sm_tdata(sm_tdata), 
    .sm_tlast(sm_tlast)
);

fir fir_inst (
    .awready(awready),
    .wready(wready),
    .awvalid(awvalid),
    .awaddr(awaddr),
    .wvalid(wvalid),
    .wdata(wdata),
    .arready(arready),
    .rready(rready),
    .arvalid(arvalid),
    .araddr(araddr),
    .rvalid(rvalid),
    .rdata(rdata),    
    .ss_tvalid(ss_tvalid), 
    .ss_tdata(ss_tdata), 
    .ss_tlast(ss_tlast), 
    .ss_tready(ss_tready), 
    .sm_tready(sm_tready), 
    .sm_tvalid(sm_tvalid), 
    .sm_tdata(sm_tdata), 
    .sm_tlast(sm_tlast), 
    
    // bram for tap RAM
    .tap_WE(),
    .tap_EN(),
    .tap_Di(),
    .tap_A(),
    .tap_Do(),

    // bram for data RAM
    .data_WE(),
    .data_EN(),
    .data_Di(),
    .data_A(),
    .data_Do(),

    .axis_clk(),
    .axis_rst_n()
);

endmodule	// user_project_wrapper

`default_nettype wire
