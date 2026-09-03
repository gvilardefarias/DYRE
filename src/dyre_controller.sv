// Copyright 2026 Politecnico di Torino
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Gustavo Vilar de Farias, Politecnico di Torino, Italy
//
// The controller module drives the select signal

module DYRE_controller #(
    parameter unsigned NUM_INPUTS    = 2,
    parameter unsigned NUM_REP       = 1,     // Should be less or equal to NUM_INPUTS/2
    parameter unsigned COUNTER_WIDTH = 3,

    localparam unsigned REP_RATIO = NUM_INPUTS/NUM_REP
) (
    input  logic                            clk_i,
    input  logic                            rst_ni,
    input  logic           [NUM_INPUTS-1:0] busy_i,

    output logic [$clog2(REP_RATIO)-1:0] s_o     // Select signal
);
    logic                         switch_on;     // Switch in the s signal can be performed
    logic [$clog2(REP_RATIO)-1:0] s_comb;
    logic [$clog2(REP_RATIO)-1:0] s_next_idx;

    logic        [COUNTER_WIDTH-1:0] counter_comb;
    logic        [COUNTER_WIDTH-1:0] counter_ff;

    assign s_next_idx = (s_o == REP_RATIO - 1) ? 'd0 : s_o + 1'b1;
    assign switch_on =    &(~busy_i[s_o*NUM_REP+:NUM_REP])
                       && &(~busy_i[(s_next_idx)*NUM_REP+:NUM_REP]);   // If current and next modules are avaible
    // TODO: verify if there is any transaction so we will not be switching s without any operation

    always_comb begin
        counter_comb = counter_ff;

        if(&counter_ff && switch_on) begin
            counter_comb = 'd0;
        end else if (&counter_ff && !switch_on) begin
            counter_comb = counter_ff;
        end else begin
            counter_comb = counter_ff + 'd1;
        end
    end

    always_comb begin
        s_comb = s_o;

        if(&counter_ff && switch_on) begin
            s_comb = s_next_idx;
        end
    end

    always_ff @(posedge clk_i or negedge rst_ni) begin 
        if(!rst_ni) begin
            counter_ff <= 'd0;
            s_o        <= 'd0;
        end else begin
            counter_ff <= counter_comb;
            s_o        <= s_comb;
        end
    end

endmodule