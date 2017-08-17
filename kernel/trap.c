#include"defs.h"

void (*IntHandler[256])(struct trapframe* tf);

void trap(struct trapframe* tf){
	struct trapframe *tf2;
	
	tf2=mem_alloc(sizeof(struct trapframe));
	CopyFar(SysDataSelecter,tf2,1,UsrDataSelecter,tf,1,sizeof(struct trapframe));
	IntHandler[tf2->trapno](tf2);
	mem_free(tf2,sizeof(struct trapframe));
	return ;
}

void SolvePICLock(){
	outb(0x20,0x20);
	outb(0xA0,0x20);
}
