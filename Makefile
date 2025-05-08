# 工具设置
VERILATOR = verilator
CC = g++
CFLAGS = -Wall -Wextra -O2

# Verilator 标志
VERILATOR_FLAGS = --cc --exe --build --trace -Wall -j 0

# 源文件
SOURCES = sim_main.cpp
VERILOG_SOURCES = rtl/alu.v rtl/control_unit.v rtl/data_memory.v \
                  rtl/instruction_memory.v rtl/pc.v rtl/register_file.v \
                  rtl/sign_extend.v rtl/riscv_top.v

# 目标
TARGET = riscv_sim
OBJ_DIR = obj_dir

all: $(TARGET)

$(TARGET): $(SOURCES) $(VERILOG_SOURCES)
	$(VERILATOR) $(VERILATOR_FLAGS) $(SOURCES) $(VERILOG_SOURCES) --top-module riscv_top -o $(TARGET)
	cp $(OBJ_DIR)/riscv_sim $(TARGET)

run: $(TARGET) test.hex
	./$(TARGET)

clean:
	rm -rf $(OBJ_DIR) $(TARGET) riscv_sim.vcd

.PHONY: all run clean