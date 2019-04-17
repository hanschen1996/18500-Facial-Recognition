# don't forget to run "chmod +777 compile.sh" first
vcs -sverilog -full64 +lint=all -debug_all top_tb.sv top.sv detect_face.sv uart_rcvr.sv uart_tcvr.sv window_std_dev.sv mult.sv downscaler.sv int_img_calc.sv signed_comparator.sv sqrt.sv vj_pipeline.sv ip_lib.sv
