%include"selecter.inc"
[bits 32]

section .text
global Halt
global CopyFar
global outb
global outw
global inb
global inw
global sti
global cli
global syscall
global farjmp
global lidt
global lgdt
global ltr

CopyFar:
;void CopyFar(unsigned short DistSelecter,void* DistOffset,int DStep,unsigned short SrcSelecter,void* SrcOffset,int SStep,int n);
	push eax
	push ebx
	push ecx
	push edx
	push edi
	push esi
	push es
	push gs

;es=書き込み対象のセグメント　edi=書き込み対象のオフセット　esi=書き込むデータへのポインタ　bx=書き込むデータ量

	mov ax,[ss:(esp+36+0)]  	;DistSelecter
	mov es,ax  
	mov edi,[ss:(esp+36+4)] 	;DistOffset
	mov ebx,[ss:(esp+36+8)] 	;DStep


	mov ax,[ss:(esp+36+12)]    	;SrcSelecter
	mov gs,ax		
	mov esi,[ss:(esp+36+16)]	;SrcOffset
	mov edx,[ss:(esp+36+20)]	;SStep

	mov ecx,[ss:(esp+36+24)]	;n
CopyFar_Loop:
	cmp ecx,0       ;While(bx!=0)
	jz CopyFar_End 

	mov al,[gs:esi] ;[es:edi]=[ds:esi]
	mov [es:edi],al

	add edi,ebx    ;edi++ esi++ bx--
	add esi,edx
	dec ecx

	jmp CopyFar_Loop 
CopyFar_End:  
	pop gs 
	pop es
	pop esi
	pop edi
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret

Halt:
	HLT
	ret		;終了

outb:
;int outb(unsigned short port,unsigned char data);
	push eax
	push edx
	mov dx,[ss:(esp+12+0)]
	mov al,[ss:(esp+12+4)]
	out dx,al
	pop edx
	pop eax
	ret

outw:
;int outw(unsigned short port,unsigned short data);
	push eax
	push edx
	mov dx,[ss:(esp+12+0)]
	mov ax,[ss:(esp+12+4)]
	out dx,ax 
	pop edx
	pop eax
	ret


inb:
;unsigned char inb(unsigned short port);
	push edx
	mov dx,[ss:(esp+8+0)]
	xor eax,eax
	in al,dx
	pop edx
	ret


inw:
;unsigned short inw(unsigned short port);
	push edx
	mov dx,[ss:(esp+8+0)]
	xor eax,eax
	in ax,dx
	pop edx
	ret

sti:
;void sti();
	sti
	ret

cli:
;void cli();
	cli
	ret


syscall:
;void syscall(int a,int b,int c,int d,int e,int f);
	push eax
	push ebx
	push ecx
	push edx
	push esi
	push edi
	mov eax,[ss:(esp+4*6+4*1)]
	mov ebx,[ss:(esp+4*6+4*2)]
	mov ecx,[ss:(esp+4*6+4*3)]
	mov edx,[ss:(esp+4*6+4*4)]
	mov esi,[ss:(esp+4*6+4*5)]
	mov edi,[ss:(esp+4*6+4*6)]
	int 0x80
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret


farjmp:
;void farjmp(int eip,int cs);
	jmp far [esp+4]
	ret

lgdt:
;void lgdt(void* gdtr);
	push esi
	mov esi,[esp+8]
	lgdt [ds:esi]
	pop esi
	ret

lidt:
;void lidt(void* idtr);
	push esi
	mov esi,[esp+8]
	lidt [ds:esi]
	pop esi
	ret

ltr:
;void ltr(unsigned short selecter);
	mov eax,[esp+4]
	ltr ax
	ret
