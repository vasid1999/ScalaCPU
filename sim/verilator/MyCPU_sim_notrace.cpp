// ---headers---
#include "MyCPU_sim.h"

// ---class member function definitions---
MyVModule::MyVModule(){
	this->m = new VMyCPU;
}

// ---function definitions---
void tick(MyVModule *vmodule){
	vmodule->m->clock = 0;
	vmodule->m->eval();
	vmodule->m->clock = 1;
	vmodule->m->eval();
}

int read_hex_data(FILE* in_file,MemInputData* data_array){
	int length = 0;
	char* line = (char*) malloc(STRSIZE);
	
	while((line = fgets(line,STRSIZE,in_file))!=NULL){
		data_array[length] = (MemInputData) strtol(line,NULL,16);
		length++;
	}
	return length;
}

void print_debug_1(MyVModule* vmodule){
	printf(DEBUG_FORMAT_STRING_1
		,vmodule->m->io_iaddr
		,vmodule->m->io_idata
		,vmodule->m->io_daddr
		,vmodule->m->io_dwdata
		,vmodule->m->io_drdata);
}

// ---main function---
int main(int argc,char **argv){
	// command line arguments go to verilator
	Verilated::commandArgs(argc,argv);
	
	// create new CPU module
	MyVModule *vmodule = new MyVModule;
	
	// IMEM read start
	MemInputData imem[MAX_IMEM_SIZE];
	FILE *imem_file = fopen(IMEM_LOCATION_STRING,"r");
	int imem_length = read_hex_data(imem_file,imem);
	fclose(imem_file);
	// IMEM read end
	
	// DMEM read start
	MemInputData dmem[MAX_DMEM_SIZE];
	FILE *dmem_file = fopen(DMEM_LOCATION_STRING,"r");
	int dmem_length = read_hex_data(dmem_file,dmem);
	fclose(dmem_file);
	// DMEM read end
	
	// set initial values
	vmodule->m->clock = 1;
	vmodule->m->reset = 0;
	vmodule->m->eval();
	
	// enter simulation loop
	while(!Verilated::gotFinish()){
		// 1. imem read
		if(vmodule->m->io_iaddr>>2>=imem_length+PIPE_PC_LAG){
			fprintf(stderr,"Error: instruction at byte number %u is out of bounds\nExiting...\n",vmodule->m->io_iaddr);
			return 1;
		}
		vmodule->m->io_idata = imem[vmodule->m->io_iaddr>>2];
		
		// 2. EVAL
		vmodule->m->eval();
		
		// 3. dmem read
		if(vmodule->m->io_daddr < dmem_length){
			vmodule->m->io_drdata =   dmem[vmodule->m->io_daddr & 0xFFFFFFFC | 0]
								| dmem[vmodule->m->io_daddr & 0xFFFFFFFC | 1]<<8
								| dmem[vmodule->m->io_daddr & 0xFFFFFFFC | 2]<<16
								| dmem[vmodule->m->io_daddr & 0xFFFFFFFC | 3]<<24;
		}
		
		// 4. EVAL
		vmodule->m->eval();
		
		// 5. TICK
		vmodule->m->clock = 0;
		vmodule->m->eval(); // else the sim won't know that a cycle has indeed elapsed - if not for this, sim will see clock as being an unchanging HIGH
		print_debug_1(vmodule);
		vmodule->m->clock = 1;
		
		// 6. dmem write
		if(vmodule->m->io_daddr < dmem_length){
			if(vmodule->m->io_dmem_we & 1) dmem[vmodule->m->io_daddr & 0xFFFFFFFC | 0] = vmodule->m->io_dwdata     & 0x000000FF;
			if(vmodule->m->io_dmem_we & 2) dmem[vmodule->m->io_daddr & 0xFFFFFFFC | 1] = vmodule->m->io_dwdata>>8  & 0x000000FF;
			if(vmodule->m->io_dmem_we & 4) dmem[vmodule->m->io_daddr & 0xFFFFFFFC | 2] = vmodule->m->io_dwdata>>16 & 0x000000FF;
			if(vmodule->m->io_dmem_we & 8) dmem[vmodule->m->io_daddr & 0xFFFFFFFC | 3] = vmodule->m->io_dwdata>>24 & 0x000000FF;
		}
		
		// 7. EVAL
		vmodule->m->eval();
		
		// 8. delay for visibility
		usleep(UDELAY);
	}
}

/*
Hypothesis 1: (20201213_0005)
The way I understand it as of now, the simulator can only tell what's happening at the edge, not in between. So if clock is set to 1, any future evals will compute only what's happening at the edge till the clock is given a negedge

Algo v1:
1. imem read        => idata ready
2. EVAL             => idata processed, dwdata ready
3. dmem read        => drdata ready
4. EVAL             => drdata processed (and wb_indata ready)
5. TICK             => idata done, drdata done, pc ready
6. dmem write       => dwdata processed
7. EVAL             => pc incremented
8. delay for visibility

Update: Algo v1 worked!
*/
