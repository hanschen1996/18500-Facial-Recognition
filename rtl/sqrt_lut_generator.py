import math

LIMIT = 2**20

sqrt_file = open("sqrt.sv", mode="wb")
sqrt_file.write("module sqrt(\n    input[31:0] val,\n    output[31:0] res);\n")

sqrt_file.write("    always_comb begin\n")
sqrt_file.write("        case (val)\n")
prev_sqrt = 0
sqrt_file.write("            32'd0")

for i in range(1, LIMIT):
  curr_sqrt = int(math.sqrt(i))
  if (curr_sqrt != prev_sqrt):
    sqrt_file.write(": res = 32'd%d;\n            32'd%d"%(prev_sqrt, i))
  else:
    sqrt_file.write(",32'd%d"%(i))
  prev_sqrt = curr_sqrt

sqrt_file.write(": res = 32'd%d;\n"%(prev_sqrt))

sqrt_file.write("            default: res = 0;\n")
sqrt_file.write("        endcase\n")
sqrt_file.write("    end\n")
sqrt_file.write("endmodule\n")

sqrt_file.close()