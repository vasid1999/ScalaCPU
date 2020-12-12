// ---headers---
// verilator includes
#include "verilated.h"
#include "VMyCPU.h"

// standard C includes
#include<stdio.h>
#include<stdlib.h>
#include<time.h>

// defines
#define TRIG_POSEDGE
#define PIPE_PC_LAG 2 // lag between EX PC and actual PC

#define IMEM_LOCATION_STRING "mem/imem1_ini.mem"
#define MAX_IMEM_SIZE 30

#define DMEM_LOCATION_STRING "mem/dmem_ini.mem"
#define MAX_DMEM_SIZE 30

#define STRSIZE 16
#define UDELAY 250000
#define DEBUG_FORMAT_STRING_1 \
"iaddr  = %u\n\
idata  = 0x%08x\n\
daddr  = %u\n\
dwdata = 0x%08x\n\
drdata = 0x%08x\n\
-------------------\n"

// ---typedefs---
typedef unsigned int MemInputData;

// ---class declarations---
class MyVModule{
	public:
	VMyCPU *m;
	MyVModule();
};

// ---function declarations---
// tick one clock cycle (not being used currently)
void tick(MyVModule*);

// read lines from a file as hex into an integer array
int read_hex_data(FILE*,MemInputData);

// print debug format 1
void print_debug_1(MyVModule*);
