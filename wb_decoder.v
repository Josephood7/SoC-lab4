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

`default_nettype wire
/*
 *-------------------------------------------------------------
 *
 * user_proj_example
 *
 * This is an example of a (trivially simple) user project,
 * showing how the user project can connect to the logic
 * analyzer, the wishbone bus, and the I/O pads.
 *
 * This project generates an integer count, which is output
 * on the user area GPIO pads (digital output only).  The
 * wishbone connection allows the project to be controlled
 * (start and stop) from the management SoC program.
 *
 * See the testbenches in directory "mprj_counter" for the
 * example programs that drive this user project.  The three
 * testbenches are "io_ports", "la_test1", and "la_test2".
 *
 *-------------------------------------------------------------
 */

module wb_decoder #(
    parameter BITS = 32,
    parameter DELAYS=10
)(
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif
    // wb axi
    output wire wbs_clk_o_axi,
    output wire wbs_rst_o_axi,
    output wire wbs_cyc_o_axi,
    output wire wbs_stb_o_axi,
    output wire wbs_we_o_axi,
    output wire [3:0] wbs_sel_o_axi,
    output wire [BITS - 1:0] wbs_adr_o_axi,
    output wire [BITS - 1:0] wbs_dat_o_axi,
    input wire wbs_ack_i_axi,
    input wire [BITS - 1:0] wbs_dat_i_axi, 
    // exmem
    output wire wbs_clk_o_exmem,
    output wire wbs_rst_o_exmeme,
    output wire wbs_cyc_o_exmem,
    output wire wbs_stb_o_exmem,
    output wire wbs_we_o_exmem,
    output wire [3:0] wbs_sel_o_exmem,
    output wire [BITS - 1:0] wbs_adr_o_exmem,
    output wire [BITS - 1:0] wbs_dat_o_exmem,
    input wire wbs_ack_i_exmem,
    input wire [BITS - 1:0] wbs_dat_i_exmem, 
    // host
    input wire wbs_clk_i,
    input wire wbs_rst_i,
    input wire wbs_cyc_i,
    input wire wbs_stb_i,
    input wire wbs_we_i,
    input wire [3:0] wbs_sel_i,
    input wire [BITS - 1:0] wbs_adr_i,
    input wire [BITS - 1:0] wbs_dat_i,
    output wire wbs_ack_o,
    output wire [BITS - 1:0] wbs_dat_o
);
    parameter slave_fir_add = 32'h38000000;
    parameter slave_exmem_add = 32'h38400000;
    parameter IDLE = 0;
    reg[1:0] fir = 2'b00;
    reg[1:0] exmem = 2'b00;
    reg[1:0] = switch_state;

    always @(posedge wbs_clk_i or negedge wbs_rst_i) begin
        
        wbs_clk_o_axi = (fir)? wbs_clk_i : IDLE;
        wbs_rst_o_axi = (fir)? wbs_rst_i : IDLE;
        wbs_cyc_o_axi = (fir)? wbs_cyc_i : IDLE;
        wbs_stb_o_axi = (fir)? wbs_stb_i : IDLE;
        wbs_we_o_axi = (fir)? wbs_we_i : IDLE;
        wbs_sel_o_axi = (fir)? wbs_sel_i : IDLE;
        wbs_adr_o_axi = (fir)? wbs_adr_i : IDLE;
        wbs_dat_o_axi = (fir)? wbs_dat_i : IDLE;
        wbs_ack_i_axi = (fir)? wbs_ack_o : IDLE;
        wbs_dat_i_axi = (fir)? wbs_dat_o : IDLE;

        wbs_clk_o_exmem = (exmem)? wbs_clk_i : IDLE;
        wbs_rst_o_exmeme = (exmem)? wbs_rst_i : IDLE;
        wbs_cyc_o_exmem = (exmem)? wbs_cyc_i : IDLE;
        wbs_stb_o_exmem = (exmem)? wbs_stb_i : IDLE;
        wbs_we_o_exmem = (exmem)? wbs_we_i : IDLE;
        wbs_sel_o_exmem = (exmem)? wbs_sel_i : IDLE;
        wbs_adr_o_exmem = (exmem)? wbs_adr_i : IDLE;
        wbs_dat_o_exmem = (exmem)? wbs_dat_i : IDLE;
        wbs_ack_i_exmem = (exmem)? wbs_ack_o : IDLE;
        wbs_dat_i_exmem = (exmem)? wbs_dat_o : IDLE;
    end

    always @(*) begin
        fir = (slave_fir_add == wbs_adr_i)? 2'b01 : 2'b00; 
        exmem = (slave_exmem_add == wbs_adr_i)? 2'b01 : 2'b00;
    end

endmodule

`default_nettype wire
