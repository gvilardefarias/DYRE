// Copyright 2026 Politecnico di Torino
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Gustavo Vilar de Farias, Politecnico di Torino, Italy
//
// The crossbar module allows data_i to be routed into output

module crossbar #(
    parameter type     DATA_TYPE   = logic [31:0],  // For this module represents the input operands
    parameter unsigned NUM_INPUTS  = 2,
    parameter unsigned NUM_OUTPUTS = 1,     // Should be less or equal to NUM_INPUTS/2

    localparam unsigned OUTPUT_RATIO = NUM_INPUTS/NUM_OUTPUTS
) (
    input  DATA_TYPE                        [NUM_INPUTS-1:0] data_i,  // Input data
    input  logic                  [$clog2(OUTPUT_RATIO)-1:0] s_i,     // Select signal

    input  logic                           [NUM_OUTPUTS-1:0] replace_i,  // Indicates that the spare module is replacing a faulty module
    input  logic [NUM_OUTPUTS-1:0][$clog2(OUTPUT_RATIO)-1:0] s_replace_i,  // Select signal for the spare module

    output DATA_TYPE                       [NUM_OUTPUTS-1:0] data_o   // Output data
);

    always_comb begin
        for(int i = 0; i < NUM_OUTPUTS; i++) begin
            if(replace_i[i]) begin
                data_o[i] = data_i[s_replace_i[i]*NUM_OUTPUTS+i];
            end else begin
                data_o[i] = data_i[s_i*NUM_OUTPUTS+i];
            end
        end
    end

endmodule