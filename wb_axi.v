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

module user_proj_example #(
    parameter BITS = 32,
    parameter DELAYS=10
    parameter pDATA_WIDTH = 32;
    parameter pADDR_WIDTH = 12;
)(
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wire wb_clk_i,
    input wire wb_rst_i,
    input wire wbs_stb_i,
    input wire wbs_cyc_i,
    input wire wbs_we_i,
    input wire [3:0] wbs_sel_i,
    input wire [31:0] wbs_dat_i,
    input wire [31:0] wbs_adr_i,
    output wire wbs_ack_o,
    output wire [31:0] wbs_dat_o,
    // AXI Write in 
    input wire awready,
    input wire wready,
    output reg awvalid,
    output reg [pADDR_WIDTH - 1:0] awaddr,
    output reg wvalid,
    output reg [pDATA_WIDTH - 1:0] wdata,
    // AXI Read out
    input wire arready,
    output reg rready,
    output reg arvalid,
    output reg [pADDR_WIDTH - 1:0] araddr,
    input wire rvalid,
    input wire [pDATA_WIDTH - 1:0] rdata,    
    
    output reg ss_tvalid, 
    output reg ss_tdata, 
    output reg ss_tlast, 
    input wire ss_tready, 
    
    output reg sm_tready, 
    input wire sm_tvalid, 
    input wire sm_tdata, 
    input wire sm_tlast,

    // Logic Analyzer Signals
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // IRQ
    output [2:0] irq
);
    parameter CONNECT = 1'b1;
    parameter IDLE  = 1'b0;

    wire clk;
    wire rst;

    wire [`MPRJ_IO_PADS-1:0] io_in;
    wire [`MPRJ_IO_PADS-1:0] io_out;
    wire [`MPRJ_IO_PADS-1:0] io_oeb;

    reg [3:0] cnt;

    always @(posedge wbs_clk_i or negedge wbs_rst_i) begin
        if(~wbs_rst_i) begin
            cnt <= 4'b0000;        
        end else if(wbs_stb_i or wbs_cyc_i) begin
            cnt <= (cnt == 4'b1010)? 4'b0000:(cnt + 1'b1);
        end

        awvalid = (wbs_adr_i == 32'h38000000)? CONNECT:IDLE;
        awaddr = awaddr;
        wvalid = (wbs_stb_i or wbs_stb_i)? ((wbs_we_i)? CONNECT:IDLE):IDLE;
        wdata = 

        // wbs_ack_o = (wvalid)? ((cnt == 4'b1010) :):;
        rready = (wvalid)? ((cnt == 4'b1010) wbs_ack_o:IDLE):IDLE;
        arvalid = (wvalid)? ((cnt == 4'b1010) wbs_ack_o:IDLE):IDLE;
        araddr = 32'h2600000c;
        ss_tvalid = (wbs_stb_i or wbs_stb_i)? ((wbs_we_i)? CONNECT:IDLE):IDLE;
        ss_tdata = (wvalid)? wbs_dat_i:{(pDATA_WIDTH){IDLE}};
        ss_tlast
        sm_tready
    end

endmodule

`default_nettype wire
