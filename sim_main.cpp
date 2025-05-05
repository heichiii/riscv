#include "Vriscv_top.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

int main(int argc, char **argv)
{
    Verilated::commandArgs(argc, argv);
    Vriscv_top *top = new Vriscv_top;

    // Trace generation
    Verilated::traceEverOn(true);
    VerilatedVcdC *tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("riscv_sim.vcd");

    // Initialize
    top->clk = 0;
    top->reset = 1;

    // Run simulation
    for (int i = 0; i < 100; i++)
    {
        if (i > 10)
            top->reset = 0; // Release reset after 10 cycles

        top->clk = !top->clk;
        top->eval();
        tfp->dump(i);

        if (Verilated::gotFinish())
            break;
    }

    // Cleanup
    tfp->close();
    delete top;
    delete tfp;
    exit(0);
}
