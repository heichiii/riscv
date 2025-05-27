# 文件名必须为 "Makefile" (注意大写M)
.PHONY: all synth clean

all: synth

synth:
	# 注意: 以下每行必须以 TAB 开头(非空格)
	@echo "======== 开始综合流程 ========"
	yosys -l yosys.log riscv_synth.ys
	dot -Tpng riscv_block_diagram.dot -o block_diagram.png
	dot -Tpng riscv_gate_level.dot -o gate_level.png
	@echo "综合完成！结果见 block_diagram.png 和 gate_level.png"

clean:
	rm -f *.dot *.png *.v *.log