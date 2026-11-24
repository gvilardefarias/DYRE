// Copyright 2026 Politecnico di Torino
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Gustavo Vilar de Farias, Politecnico di Torino, Italy
//
// The comparator module allows data_i to be compared with a reference and to reconfigure the output

module comparator #(
    parameter type     DATA_TYPE  = logic [31:0],  // For this module represents the output results
    parameter unsigned NUM_INPUTS = 2,
    parameter unsigned NUM_REP    = 1,     // Should be less or equal to NUM_INPUTS/2

    localparam unsigned REP_RATIO = NUM_INPUTS/NUM_REP
) (
    input  logic                                      clk_i,
    input  logic                                      rst_ni,
    input  DATA_TYPE                 [NUM_INPUTS-1:0] ref_i,   // Reference data
    input  DATA_TYPE                    [NUM_REP-1:0] data_i,  // Input data
    input  logic              [$clog2(REP_RATIO)-1:0] s_i,     // Select signal from the reference

    input  logic                        [NUM_REP-1:0] replace_i,  // Indicates that the spare module is replacing a faulty module
    input  logic [NUM_REP-1:0][$clog2(REP_RATIO)-1:0] s_replace_i,  // Select signal for the spare module

    output logic                        [NUM_REP-1:0] fault_det_o,    // Fault detection
    output DATA_TYPE                 [NUM_INPUTS-1:0] data_o  // Output data. With reconfiguration when a spare module is used, the output data will be the one from the spare module
);
    logic [NUM_REP-1:0] cmp_o;    // Comparator result

    always_comb begin
        for(int i =0; i < NUM_INPUTS; i++) begin
            data_o[i] = ref_i[i];
        end

        for (int i = 0; i < NUM_REP; i++) begin
            if(replace_i[i]) begin
                data_o[s_replace_i[i]*NUM_REP+i] = data_i[i];
            end
        end
    end

    always_comb begin
        for (int i = 0; i < NUM_REP; i++) begin
            cmp_o[i] = (ref_i[(s_i * NUM_REP) + i] == data_i[i]) || replace_i[i];
        end
    end

    always_ff @(posedge clk_i or negedge rst_ni) begin // TODO put inside comparator
        if (!rst_ni) begin
            fault_det_o <= 1'b0;
        end else begin
            fault_det_o <= |(~cmp_o);
        end
    end

endmodule