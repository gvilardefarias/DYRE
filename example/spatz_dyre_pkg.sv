package spatz_dyre_pkg;
    import spatz_pkg::*;
    import rvv_pkg::*;
    import fpnew_pkg::*;
    import zoix_pkg::*;

    localparam int unsigned N_DYRE = 1;   // Amount of replications for DYRE

    typedef struct packed {
        logic [31:0]                        hart_id_i;
        logic [3-1:0][FPUFeatures.Width-1:0] operands_i;
        logic                               in_valid_i;
        fpnew_pkg::operation_e              op_i;
        fpnew_pkg::fp_format_e              src_fmt_i;
        fpnew_pkg::fp_format_e              dst_fmt_i;
        fpnew_pkg::int_format_e             int_fmt_i;
        logic                               vectorial_op_i;
        logic                               op_mod_i;
        zoix_pkg::vfu_tag_t                           tag_i;
        fpnew_pkg::roundmode_e              rnd_mode_i;
        logic                               out_ready_i;
    } fpu_input_t;

    typedef struct packed {
        logic               in_ready_o;
        logic               busy_o;
        logic [FPUFeatures.Width-1:0]   result_o;
        fpnew_pkg::status_t status_o;
        zoix_pkg::vfu_tag_t           tag_o;       // Maybe can be removed
        logic               out_valid_o;
    } fpu_output_t;

endpackage : spatz_dyre_pkg