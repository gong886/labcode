
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
    .globl kern_entry
kern_entry:
    # a0: hartid
    # a1: dtb physical address
    # save hartid and dtb address
    la t0, boot_hartid
ffffffffc0200000:	0000b297          	auipc	t0,0xb
ffffffffc0200004:	00028293          	mv	t0,t0
    sd a0, 0(t0)
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc020b000 <boot_hartid>
    la t0, boot_dtb
ffffffffc020000c:	0000b297          	auipc	t0,0xb
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc020b008 <boot_dtb>
    sd a1, 0(t0)
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)
    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200018:	c020a2b7          	lui	t0,0xc020a
    # t1 := 0xffffffff40000000 即虚实映射偏移量
    li      t1, 0xffffffffc0000000 - 0x80000000
ffffffffc020001c:	ffd0031b          	addiw	t1,zero,-3
ffffffffc0200020:	037a                	slli	t1,t1,0x1e
    # t0 减去虚实映射偏移量 0xffffffff40000000，变为三级页表的物理地址
    sub     t0, t0, t1
ffffffffc0200022:	406282b3          	sub	t0,t0,t1
    # t0 >>= 12，变为三级页表的物理页号
    srli    t0, t0, 12
ffffffffc0200026:	00c2d293          	srli	t0,t0,0xc

    # t1 := 8 << 60，设置 satp 的 MODE 字段为 Sv39
    li      t1, 8 << 60
ffffffffc020002a:	fff0031b          	addiw	t1,zero,-1
ffffffffc020002e:	137e                	slli	t1,t1,0x3f
    # 将刚才计算出的预设三级页表物理页号附加到 satp 中
    or      t0, t0, t1
ffffffffc0200030:	0062e2b3          	or	t0,t0,t1
    # 将算出的 t0(即新的MODE|页表基址物理页号) 覆盖到 satp 中
    csrw    satp, t0
ffffffffc0200034:	18029073          	csrw	satp,t0
    # 使用 sfence.vma 指令刷新 TLB
    sfence.vma
ffffffffc0200038:	12000073          	sfence.vma
    # 从此，我们给内核搭建出了一个完美的虚拟内存空间！
    #nop # 可能映射的位置有些bug。。插入一个nop
    
    # 我们在虚拟内存空间中：随意将 sp 设置为虚拟地址！
    lui sp, %hi(bootstacktop)
ffffffffc020003c:	c020a137          	lui	sp,0xc020a

    # 我们在虚拟内存空间中：随意跳转到虚拟地址！
    # 跳转到 kern_init
    lui t0, %hi(kern_init)
ffffffffc0200040:	c02002b7          	lui	t0,0xc0200
    addi t0, t0, %lo(kern_init)
ffffffffc0200044:	04a28293          	addi	t0,t0,74 # ffffffffc020004a <kern_init>
    jr t0
ffffffffc0200048:	8282                	jr	t0

ffffffffc020004a <kern_init>:
void grade_backtrace(void);

int kern_init(void)
{
    extern char edata[], end[];
    memset(edata, 0, end - edata);
ffffffffc020004a:	000a6517          	auipc	a0,0xa6
ffffffffc020004e:	33650513          	addi	a0,a0,822 # ffffffffc02a6380 <buf>
ffffffffc0200052:	000aa617          	auipc	a2,0xaa
ffffffffc0200056:	7da60613          	addi	a2,a2,2010 # ffffffffc02aa82c <end>
{
ffffffffc020005a:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
{
ffffffffc0200060:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc0200062:	670050ef          	jal	ra,ffffffffc02056d2 <memset>
    dtb_init();
ffffffffc0200066:	598000ef          	jal	ra,ffffffffc02005fe <dtb_init>
    cons_init(); // init the console
ffffffffc020006a:	522000ef          	jal	ra,ffffffffc020058c <cons_init>

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc020006e:	00005597          	auipc	a1,0x5
ffffffffc0200072:	69258593          	addi	a1,a1,1682 # ffffffffc0205700 <etext+0x4>
ffffffffc0200076:	00005517          	auipc	a0,0x5
ffffffffc020007a:	6aa50513          	addi	a0,a0,1706 # ffffffffc0205720 <etext+0x24>
ffffffffc020007e:	116000ef          	jal	ra,ffffffffc0200194 <cprintf>

    print_kerninfo();
ffffffffc0200082:	19a000ef          	jal	ra,ffffffffc020021c <print_kerninfo>

    // grade_backtrace();

    pmm_init(); // init physical memory management
ffffffffc0200086:	6c0020ef          	jal	ra,ffffffffc0202746 <pmm_init>

    pic_init(); // init interrupt controller
ffffffffc020008a:	131000ef          	jal	ra,ffffffffc02009ba <pic_init>
    idt_init(); // init interrupt descriptor table
ffffffffc020008e:	12f000ef          	jal	ra,ffffffffc02009bc <idt_init>

    vmm_init();  // init virtual memory management
ffffffffc0200092:	18d030ef          	jal	ra,ffffffffc0203a1e <vmm_init>
    proc_init(); // init process table
ffffffffc0200096:	58f040ef          	jal	ra,ffffffffc0204e24 <proc_init>

    clock_init();  // init clock interrupt
ffffffffc020009a:	4a0000ef          	jal	ra,ffffffffc020053a <clock_init>
    intr_enable(); // enable irq interrupt
ffffffffc020009e:	111000ef          	jal	ra,ffffffffc02009ae <intr_enable>

    cpu_idle(); // run idle process
ffffffffc02000a2:	71b040ef          	jal	ra,ffffffffc0204fbc <cpu_idle>

ffffffffc02000a6 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc02000a6:	715d                	addi	sp,sp,-80
ffffffffc02000a8:	e486                	sd	ra,72(sp)
ffffffffc02000aa:	e0a6                	sd	s1,64(sp)
ffffffffc02000ac:	fc4a                	sd	s2,56(sp)
ffffffffc02000ae:	f84e                	sd	s3,48(sp)
ffffffffc02000b0:	f452                	sd	s4,40(sp)
ffffffffc02000b2:	f056                	sd	s5,32(sp)
ffffffffc02000b4:	ec5a                	sd	s6,24(sp)
ffffffffc02000b6:	e85e                	sd	s7,16(sp)
    if (prompt != NULL) {
ffffffffc02000b8:	c901                	beqz	a0,ffffffffc02000c8 <readline+0x22>
ffffffffc02000ba:	85aa                	mv	a1,a0
        cprintf("%s", prompt);
ffffffffc02000bc:	00005517          	auipc	a0,0x5
ffffffffc02000c0:	66c50513          	addi	a0,a0,1644 # ffffffffc0205728 <etext+0x2c>
ffffffffc02000c4:	0d0000ef          	jal	ra,ffffffffc0200194 <cprintf>
readline(const char *prompt) {
ffffffffc02000c8:	4481                	li	s1,0
    while (1) {
        c = getchar();
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000ca:	497d                	li	s2,31
            cputchar(c);
            buf[i ++] = c;
        }
        else if (c == '\b' && i > 0) {
ffffffffc02000cc:	49a1                	li	s3,8
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc02000ce:	4aa9                	li	s5,10
ffffffffc02000d0:	4b35                	li	s6,13
            buf[i ++] = c;
ffffffffc02000d2:	000a6b97          	auipc	s7,0xa6
ffffffffc02000d6:	2aeb8b93          	addi	s7,s7,686 # ffffffffc02a6380 <buf>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000da:	3fe00a13          	li	s4,1022
        c = getchar();
ffffffffc02000de:	12e000ef          	jal	ra,ffffffffc020020c <getchar>
        if (c < 0) {
ffffffffc02000e2:	00054a63          	bltz	a0,ffffffffc02000f6 <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000e6:	00a95a63          	bge	s2,a0,ffffffffc02000fa <readline+0x54>
ffffffffc02000ea:	029a5263          	bge	s4,s1,ffffffffc020010e <readline+0x68>
        c = getchar();
ffffffffc02000ee:	11e000ef          	jal	ra,ffffffffc020020c <getchar>
        if (c < 0) {
ffffffffc02000f2:	fe055ae3          	bgez	a0,ffffffffc02000e6 <readline+0x40>
            return NULL;
ffffffffc02000f6:	4501                	li	a0,0
ffffffffc02000f8:	a091                	j	ffffffffc020013c <readline+0x96>
        else if (c == '\b' && i > 0) {
ffffffffc02000fa:	03351463          	bne	a0,s3,ffffffffc0200122 <readline+0x7c>
ffffffffc02000fe:	e8a9                	bnez	s1,ffffffffc0200150 <readline+0xaa>
        c = getchar();
ffffffffc0200100:	10c000ef          	jal	ra,ffffffffc020020c <getchar>
        if (c < 0) {
ffffffffc0200104:	fe0549e3          	bltz	a0,ffffffffc02000f6 <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0200108:	fea959e3          	bge	s2,a0,ffffffffc02000fa <readline+0x54>
ffffffffc020010c:	4481                	li	s1,0
            cputchar(c);
ffffffffc020010e:	e42a                	sd	a0,8(sp)
ffffffffc0200110:	0ba000ef          	jal	ra,ffffffffc02001ca <cputchar>
            buf[i ++] = c;
ffffffffc0200114:	6522                	ld	a0,8(sp)
ffffffffc0200116:	009b87b3          	add	a5,s7,s1
ffffffffc020011a:	2485                	addiw	s1,s1,1
ffffffffc020011c:	00a78023          	sb	a0,0(a5)
ffffffffc0200120:	bf7d                	j	ffffffffc02000de <readline+0x38>
        else if (c == '\n' || c == '\r') {
ffffffffc0200122:	01550463          	beq	a0,s5,ffffffffc020012a <readline+0x84>
ffffffffc0200126:	fb651ce3          	bne	a0,s6,ffffffffc02000de <readline+0x38>
            cputchar(c);
ffffffffc020012a:	0a0000ef          	jal	ra,ffffffffc02001ca <cputchar>
            buf[i] = '\0';
ffffffffc020012e:	000a6517          	auipc	a0,0xa6
ffffffffc0200132:	25250513          	addi	a0,a0,594 # ffffffffc02a6380 <buf>
ffffffffc0200136:	94aa                	add	s1,s1,a0
ffffffffc0200138:	00048023          	sb	zero,0(s1)
            return buf;
        }
    }
}
ffffffffc020013c:	60a6                	ld	ra,72(sp)
ffffffffc020013e:	6486                	ld	s1,64(sp)
ffffffffc0200140:	7962                	ld	s2,56(sp)
ffffffffc0200142:	79c2                	ld	s3,48(sp)
ffffffffc0200144:	7a22                	ld	s4,40(sp)
ffffffffc0200146:	7a82                	ld	s5,32(sp)
ffffffffc0200148:	6b62                	ld	s6,24(sp)
ffffffffc020014a:	6bc2                	ld	s7,16(sp)
ffffffffc020014c:	6161                	addi	sp,sp,80
ffffffffc020014e:	8082                	ret
            cputchar(c);
ffffffffc0200150:	4521                	li	a0,8
ffffffffc0200152:	078000ef          	jal	ra,ffffffffc02001ca <cputchar>
            i --;
ffffffffc0200156:	34fd                	addiw	s1,s1,-1
ffffffffc0200158:	b759                	j	ffffffffc02000de <readline+0x38>

ffffffffc020015a <cputch>:
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt)
{
ffffffffc020015a:	1141                	addi	sp,sp,-16
ffffffffc020015c:	e022                	sd	s0,0(sp)
ffffffffc020015e:	e406                	sd	ra,8(sp)
ffffffffc0200160:	842e                	mv	s0,a1
    cons_putc(c);
ffffffffc0200162:	42c000ef          	jal	ra,ffffffffc020058e <cons_putc>
    (*cnt)++;
ffffffffc0200166:	401c                	lw	a5,0(s0)
}
ffffffffc0200168:	60a2                	ld	ra,8(sp)
    (*cnt)++;
ffffffffc020016a:	2785                	addiw	a5,a5,1
ffffffffc020016c:	c01c                	sw	a5,0(s0)
}
ffffffffc020016e:	6402                	ld	s0,0(sp)
ffffffffc0200170:	0141                	addi	sp,sp,16
ffffffffc0200172:	8082                	ret

ffffffffc0200174 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int vcprintf(const char *fmt, va_list ap)
{
ffffffffc0200174:	1101                	addi	sp,sp,-32
ffffffffc0200176:	862a                	mv	a2,a0
ffffffffc0200178:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc020017a:	00000517          	auipc	a0,0x0
ffffffffc020017e:	fe050513          	addi	a0,a0,-32 # ffffffffc020015a <cputch>
ffffffffc0200182:	006c                	addi	a1,sp,12
{
ffffffffc0200184:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc0200186:	c602                	sw	zero,12(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc0200188:	126050ef          	jal	ra,ffffffffc02052ae <vprintfmt>
    return cnt;
}
ffffffffc020018c:	60e2                	ld	ra,24(sp)
ffffffffc020018e:	4532                	lw	a0,12(sp)
ffffffffc0200190:	6105                	addi	sp,sp,32
ffffffffc0200192:	8082                	ret

ffffffffc0200194 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int cprintf(const char *fmt, ...)
{
ffffffffc0200194:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc0200196:	02810313          	addi	t1,sp,40 # ffffffffc020a028 <boot_page_table_sv39+0x28>
{
ffffffffc020019a:	8e2a                	mv	t3,a0
ffffffffc020019c:	f42e                	sd	a1,40(sp)
ffffffffc020019e:	f832                	sd	a2,48(sp)
ffffffffc02001a0:	fc36                	sd	a3,56(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc02001a2:	00000517          	auipc	a0,0x0
ffffffffc02001a6:	fb850513          	addi	a0,a0,-72 # ffffffffc020015a <cputch>
ffffffffc02001aa:	004c                	addi	a1,sp,4
ffffffffc02001ac:	869a                	mv	a3,t1
ffffffffc02001ae:	8672                	mv	a2,t3
{
ffffffffc02001b0:	ec06                	sd	ra,24(sp)
ffffffffc02001b2:	e0ba                	sd	a4,64(sp)
ffffffffc02001b4:	e4be                	sd	a5,72(sp)
ffffffffc02001b6:	e8c2                	sd	a6,80(sp)
ffffffffc02001b8:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
ffffffffc02001ba:	e41a                	sd	t1,8(sp)
    int cnt = 0;
ffffffffc02001bc:	c202                	sw	zero,4(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc02001be:	0f0050ef          	jal	ra,ffffffffc02052ae <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc02001c2:	60e2                	ld	ra,24(sp)
ffffffffc02001c4:	4512                	lw	a0,4(sp)
ffffffffc02001c6:	6125                	addi	sp,sp,96
ffffffffc02001c8:	8082                	ret

ffffffffc02001ca <cputchar>:

/* cputchar - writes a single character to stdout */
void cputchar(int c)
{
    cons_putc(c);
ffffffffc02001ca:	a6d1                	j	ffffffffc020058e <cons_putc>

ffffffffc02001cc <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int cputs(const char *str)
{
ffffffffc02001cc:	1101                	addi	sp,sp,-32
ffffffffc02001ce:	e822                	sd	s0,16(sp)
ffffffffc02001d0:	ec06                	sd	ra,24(sp)
ffffffffc02001d2:	e426                	sd	s1,8(sp)
ffffffffc02001d4:	842a                	mv	s0,a0
    int cnt = 0;
    char c;
    while ((c = *str++) != '\0')
ffffffffc02001d6:	00054503          	lbu	a0,0(a0)
ffffffffc02001da:	c51d                	beqz	a0,ffffffffc0200208 <cputs+0x3c>
ffffffffc02001dc:	0405                	addi	s0,s0,1
ffffffffc02001de:	4485                	li	s1,1
ffffffffc02001e0:	9c81                	subw	s1,s1,s0
    cons_putc(c);
ffffffffc02001e2:	3ac000ef          	jal	ra,ffffffffc020058e <cons_putc>
    while ((c = *str++) != '\0')
ffffffffc02001e6:	00044503          	lbu	a0,0(s0)
ffffffffc02001ea:	008487bb          	addw	a5,s1,s0
ffffffffc02001ee:	0405                	addi	s0,s0,1
ffffffffc02001f0:	f96d                	bnez	a0,ffffffffc02001e2 <cputs+0x16>
    (*cnt)++;
ffffffffc02001f2:	0017841b          	addiw	s0,a5,1
    cons_putc(c);
ffffffffc02001f6:	4529                	li	a0,10
ffffffffc02001f8:	396000ef          	jal	ra,ffffffffc020058e <cons_putc>
    {
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
ffffffffc02001fc:	60e2                	ld	ra,24(sp)
ffffffffc02001fe:	8522                	mv	a0,s0
ffffffffc0200200:	6442                	ld	s0,16(sp)
ffffffffc0200202:	64a2                	ld	s1,8(sp)
ffffffffc0200204:	6105                	addi	sp,sp,32
ffffffffc0200206:	8082                	ret
    while ((c = *str++) != '\0')
ffffffffc0200208:	4405                	li	s0,1
ffffffffc020020a:	b7f5                	j	ffffffffc02001f6 <cputs+0x2a>

ffffffffc020020c <getchar>:

/* getchar - reads a single non-zero character from stdin */
int getchar(void)
{
ffffffffc020020c:	1141                	addi	sp,sp,-16
ffffffffc020020e:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc0200210:	3b2000ef          	jal	ra,ffffffffc02005c2 <cons_getc>
ffffffffc0200214:	dd75                	beqz	a0,ffffffffc0200210 <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc0200216:	60a2                	ld	ra,8(sp)
ffffffffc0200218:	0141                	addi	sp,sp,16
ffffffffc020021a:	8082                	ret

ffffffffc020021c <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void)
{
ffffffffc020021c:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc020021e:	00005517          	auipc	a0,0x5
ffffffffc0200222:	51250513          	addi	a0,a0,1298 # ffffffffc0205730 <etext+0x34>
{
ffffffffc0200226:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200228:	f6dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc020022c:	00000597          	auipc	a1,0x0
ffffffffc0200230:	e1e58593          	addi	a1,a1,-482 # ffffffffc020004a <kern_init>
ffffffffc0200234:	00005517          	auipc	a0,0x5
ffffffffc0200238:	51c50513          	addi	a0,a0,1308 # ffffffffc0205750 <etext+0x54>
ffffffffc020023c:	f59ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc0200240:	00005597          	auipc	a1,0x5
ffffffffc0200244:	4bc58593          	addi	a1,a1,1212 # ffffffffc02056fc <etext>
ffffffffc0200248:	00005517          	auipc	a0,0x5
ffffffffc020024c:	52850513          	addi	a0,a0,1320 # ffffffffc0205770 <etext+0x74>
ffffffffc0200250:	f45ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc0200254:	000a6597          	auipc	a1,0xa6
ffffffffc0200258:	12c58593          	addi	a1,a1,300 # ffffffffc02a6380 <buf>
ffffffffc020025c:	00005517          	auipc	a0,0x5
ffffffffc0200260:	53450513          	addi	a0,a0,1332 # ffffffffc0205790 <etext+0x94>
ffffffffc0200264:	f31ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc0200268:	000aa597          	auipc	a1,0xaa
ffffffffc020026c:	5c458593          	addi	a1,a1,1476 # ffffffffc02aa82c <end>
ffffffffc0200270:	00005517          	auipc	a0,0x5
ffffffffc0200274:	54050513          	addi	a0,a0,1344 # ffffffffc02057b0 <etext+0xb4>
ffffffffc0200278:	f1dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc020027c:	000ab597          	auipc	a1,0xab
ffffffffc0200280:	9af58593          	addi	a1,a1,-1617 # ffffffffc02aac2b <end+0x3ff>
ffffffffc0200284:	00000797          	auipc	a5,0x0
ffffffffc0200288:	dc678793          	addi	a5,a5,-570 # ffffffffc020004a <kern_init>
ffffffffc020028c:	40f587b3          	sub	a5,a1,a5
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200290:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc0200294:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200296:	3ff5f593          	andi	a1,a1,1023
ffffffffc020029a:	95be                	add	a1,a1,a5
ffffffffc020029c:	85a9                	srai	a1,a1,0xa
ffffffffc020029e:	00005517          	auipc	a0,0x5
ffffffffc02002a2:	53250513          	addi	a0,a0,1330 # ffffffffc02057d0 <etext+0xd4>
}
ffffffffc02002a6:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02002a8:	b5f5                	j	ffffffffc0200194 <cprintf>

ffffffffc02002aa <print_stackframe>:
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void)
{
ffffffffc02002aa:	1141                	addi	sp,sp,-16
    panic("Not Implemented!");
ffffffffc02002ac:	00005617          	auipc	a2,0x5
ffffffffc02002b0:	55460613          	addi	a2,a2,1364 # ffffffffc0205800 <etext+0x104>
ffffffffc02002b4:	04f00593          	li	a1,79
ffffffffc02002b8:	00005517          	auipc	a0,0x5
ffffffffc02002bc:	56050513          	addi	a0,a0,1376 # ffffffffc0205818 <etext+0x11c>
{
ffffffffc02002c0:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc02002c2:	1cc000ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02002c6 <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int mon_help(int argc, char **argv, struct trapframe *tf)
{
ffffffffc02002c6:	1141                	addi	sp,sp,-16
    int i;
    for (i = 0; i < NCOMMANDS; i++)
    {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002c8:	00005617          	auipc	a2,0x5
ffffffffc02002cc:	56860613          	addi	a2,a2,1384 # ffffffffc0205830 <etext+0x134>
ffffffffc02002d0:	00005597          	auipc	a1,0x5
ffffffffc02002d4:	58058593          	addi	a1,a1,1408 # ffffffffc0205850 <etext+0x154>
ffffffffc02002d8:	00005517          	auipc	a0,0x5
ffffffffc02002dc:	58050513          	addi	a0,a0,1408 # ffffffffc0205858 <etext+0x15c>
{
ffffffffc02002e0:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002e2:	eb3ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02002e6:	00005617          	auipc	a2,0x5
ffffffffc02002ea:	58260613          	addi	a2,a2,1410 # ffffffffc0205868 <etext+0x16c>
ffffffffc02002ee:	00005597          	auipc	a1,0x5
ffffffffc02002f2:	5a258593          	addi	a1,a1,1442 # ffffffffc0205890 <etext+0x194>
ffffffffc02002f6:	00005517          	auipc	a0,0x5
ffffffffc02002fa:	56250513          	addi	a0,a0,1378 # ffffffffc0205858 <etext+0x15c>
ffffffffc02002fe:	e97ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200302:	00005617          	auipc	a2,0x5
ffffffffc0200306:	59e60613          	addi	a2,a2,1438 # ffffffffc02058a0 <etext+0x1a4>
ffffffffc020030a:	00005597          	auipc	a1,0x5
ffffffffc020030e:	5b658593          	addi	a1,a1,1462 # ffffffffc02058c0 <etext+0x1c4>
ffffffffc0200312:	00005517          	auipc	a0,0x5
ffffffffc0200316:	54650513          	addi	a0,a0,1350 # ffffffffc0205858 <etext+0x15c>
ffffffffc020031a:	e7bff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    }
    return 0;
}
ffffffffc020031e:	60a2                	ld	ra,8(sp)
ffffffffc0200320:	4501                	li	a0,0
ffffffffc0200322:	0141                	addi	sp,sp,16
ffffffffc0200324:	8082                	ret

ffffffffc0200326 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int mon_kerninfo(int argc, char **argv, struct trapframe *tf)
{
ffffffffc0200326:	1141                	addi	sp,sp,-16
ffffffffc0200328:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc020032a:	ef3ff0ef          	jal	ra,ffffffffc020021c <print_kerninfo>
    return 0;
}
ffffffffc020032e:	60a2                	ld	ra,8(sp)
ffffffffc0200330:	4501                	li	a0,0
ffffffffc0200332:	0141                	addi	sp,sp,16
ffffffffc0200334:	8082                	ret

ffffffffc0200336 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int mon_backtrace(int argc, char **argv, struct trapframe *tf)
{
ffffffffc0200336:	1141                	addi	sp,sp,-16
ffffffffc0200338:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc020033a:	f71ff0ef          	jal	ra,ffffffffc02002aa <print_stackframe>
    return 0;
}
ffffffffc020033e:	60a2                	ld	ra,8(sp)
ffffffffc0200340:	4501                	li	a0,0
ffffffffc0200342:	0141                	addi	sp,sp,16
ffffffffc0200344:	8082                	ret

ffffffffc0200346 <kmonitor>:
{
ffffffffc0200346:	7115                	addi	sp,sp,-224
ffffffffc0200348:	ed5e                	sd	s7,152(sp)
ffffffffc020034a:	8baa                	mv	s7,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc020034c:	00005517          	auipc	a0,0x5
ffffffffc0200350:	58450513          	addi	a0,a0,1412 # ffffffffc02058d0 <etext+0x1d4>
{
ffffffffc0200354:	ed86                	sd	ra,216(sp)
ffffffffc0200356:	e9a2                	sd	s0,208(sp)
ffffffffc0200358:	e5a6                	sd	s1,200(sp)
ffffffffc020035a:	e1ca                	sd	s2,192(sp)
ffffffffc020035c:	fd4e                	sd	s3,184(sp)
ffffffffc020035e:	f952                	sd	s4,176(sp)
ffffffffc0200360:	f556                	sd	s5,168(sp)
ffffffffc0200362:	f15a                	sd	s6,160(sp)
ffffffffc0200364:	e962                	sd	s8,144(sp)
ffffffffc0200366:	e566                	sd	s9,136(sp)
ffffffffc0200368:	e16a                	sd	s10,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc020036a:	e2bff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc020036e:	00005517          	auipc	a0,0x5
ffffffffc0200372:	58a50513          	addi	a0,a0,1418 # ffffffffc02058f8 <etext+0x1fc>
ffffffffc0200376:	e1fff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    if (tf != NULL)
ffffffffc020037a:	000b8563          	beqz	s7,ffffffffc0200384 <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc020037e:	855e                	mv	a0,s7
ffffffffc0200380:	025000ef          	jal	ra,ffffffffc0200ba4 <print_trapframe>
ffffffffc0200384:	00005c17          	auipc	s8,0x5
ffffffffc0200388:	5e4c0c13          	addi	s8,s8,1508 # ffffffffc0205968 <commands>
        if ((buf = readline("K> ")) != NULL)
ffffffffc020038c:	00005917          	auipc	s2,0x5
ffffffffc0200390:	59490913          	addi	s2,s2,1428 # ffffffffc0205920 <etext+0x224>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc0200394:	00005497          	auipc	s1,0x5
ffffffffc0200398:	59448493          	addi	s1,s1,1428 # ffffffffc0205928 <etext+0x22c>
        if (argc == MAXARGS - 1)
ffffffffc020039c:	49bd                	li	s3,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc020039e:	00005b17          	auipc	s6,0x5
ffffffffc02003a2:	592b0b13          	addi	s6,s6,1426 # ffffffffc0205930 <etext+0x234>
        argv[argc++] = buf;
ffffffffc02003a6:	00005a17          	auipc	s4,0x5
ffffffffc02003aa:	4aaa0a13          	addi	s4,s4,1194 # ffffffffc0205850 <etext+0x154>
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc02003ae:	4a8d                	li	s5,3
        if ((buf = readline("K> ")) != NULL)
ffffffffc02003b0:	854a                	mv	a0,s2
ffffffffc02003b2:	cf5ff0ef          	jal	ra,ffffffffc02000a6 <readline>
ffffffffc02003b6:	842a                	mv	s0,a0
ffffffffc02003b8:	dd65                	beqz	a0,ffffffffc02003b0 <kmonitor+0x6a>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc02003ba:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc02003be:	4c81                	li	s9,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc02003c0:	e1bd                	bnez	a1,ffffffffc0200426 <kmonitor+0xe0>
    if (argc == 0)
ffffffffc02003c2:	fe0c87e3          	beqz	s9,ffffffffc02003b0 <kmonitor+0x6a>
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc02003c6:	6582                	ld	a1,0(sp)
ffffffffc02003c8:	00005d17          	auipc	s10,0x5
ffffffffc02003cc:	5a0d0d13          	addi	s10,s10,1440 # ffffffffc0205968 <commands>
        argv[argc++] = buf;
ffffffffc02003d0:	8552                	mv	a0,s4
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc02003d2:	4401                	li	s0,0
ffffffffc02003d4:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc02003d6:	2a2050ef          	jal	ra,ffffffffc0205678 <strcmp>
ffffffffc02003da:	c919                	beqz	a0,ffffffffc02003f0 <kmonitor+0xaa>
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc02003dc:	2405                	addiw	s0,s0,1
ffffffffc02003de:	0b540063          	beq	s0,s5,ffffffffc020047e <kmonitor+0x138>
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc02003e2:	000d3503          	ld	a0,0(s10)
ffffffffc02003e6:	6582                	ld	a1,0(sp)
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc02003e8:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc02003ea:	28e050ef          	jal	ra,ffffffffc0205678 <strcmp>
ffffffffc02003ee:	f57d                	bnez	a0,ffffffffc02003dc <kmonitor+0x96>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc02003f0:	00141793          	slli	a5,s0,0x1
ffffffffc02003f4:	97a2                	add	a5,a5,s0
ffffffffc02003f6:	078e                	slli	a5,a5,0x3
ffffffffc02003f8:	97e2                	add	a5,a5,s8
ffffffffc02003fa:	6b9c                	ld	a5,16(a5)
ffffffffc02003fc:	865e                	mv	a2,s7
ffffffffc02003fe:	002c                	addi	a1,sp,8
ffffffffc0200400:	fffc851b          	addiw	a0,s9,-1
ffffffffc0200404:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0)
ffffffffc0200406:	fa0555e3          	bgez	a0,ffffffffc02003b0 <kmonitor+0x6a>
}
ffffffffc020040a:	60ee                	ld	ra,216(sp)
ffffffffc020040c:	644e                	ld	s0,208(sp)
ffffffffc020040e:	64ae                	ld	s1,200(sp)
ffffffffc0200410:	690e                	ld	s2,192(sp)
ffffffffc0200412:	79ea                	ld	s3,184(sp)
ffffffffc0200414:	7a4a                	ld	s4,176(sp)
ffffffffc0200416:	7aaa                	ld	s5,168(sp)
ffffffffc0200418:	7b0a                	ld	s6,160(sp)
ffffffffc020041a:	6bea                	ld	s7,152(sp)
ffffffffc020041c:	6c4a                	ld	s8,144(sp)
ffffffffc020041e:	6caa                	ld	s9,136(sp)
ffffffffc0200420:	6d0a                	ld	s10,128(sp)
ffffffffc0200422:	612d                	addi	sp,sp,224
ffffffffc0200424:	8082                	ret
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc0200426:	8526                	mv	a0,s1
ffffffffc0200428:	294050ef          	jal	ra,ffffffffc02056bc <strchr>
ffffffffc020042c:	c901                	beqz	a0,ffffffffc020043c <kmonitor+0xf6>
ffffffffc020042e:	00144583          	lbu	a1,1(s0)
            *buf++ = '\0';
ffffffffc0200432:	00040023          	sb	zero,0(s0)
ffffffffc0200436:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc0200438:	d5c9                	beqz	a1,ffffffffc02003c2 <kmonitor+0x7c>
ffffffffc020043a:	b7f5                	j	ffffffffc0200426 <kmonitor+0xe0>
        if (*buf == '\0')
ffffffffc020043c:	00044783          	lbu	a5,0(s0)
ffffffffc0200440:	d3c9                	beqz	a5,ffffffffc02003c2 <kmonitor+0x7c>
        if (argc == MAXARGS - 1)
ffffffffc0200442:	033c8963          	beq	s9,s3,ffffffffc0200474 <kmonitor+0x12e>
        argv[argc++] = buf;
ffffffffc0200446:	003c9793          	slli	a5,s9,0x3
ffffffffc020044a:	0118                	addi	a4,sp,128
ffffffffc020044c:	97ba                	add	a5,a5,a4
ffffffffc020044e:	f887b023          	sd	s0,-128(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL)
ffffffffc0200452:	00044583          	lbu	a1,0(s0)
        argv[argc++] = buf;
ffffffffc0200456:	2c85                	addiw	s9,s9,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL)
ffffffffc0200458:	e591                	bnez	a1,ffffffffc0200464 <kmonitor+0x11e>
ffffffffc020045a:	b7b5                	j	ffffffffc02003c6 <kmonitor+0x80>
ffffffffc020045c:	00144583          	lbu	a1,1(s0)
            buf++;
ffffffffc0200460:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL)
ffffffffc0200462:	d1a5                	beqz	a1,ffffffffc02003c2 <kmonitor+0x7c>
ffffffffc0200464:	8526                	mv	a0,s1
ffffffffc0200466:	256050ef          	jal	ra,ffffffffc02056bc <strchr>
ffffffffc020046a:	d96d                	beqz	a0,ffffffffc020045c <kmonitor+0x116>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc020046c:	00044583          	lbu	a1,0(s0)
ffffffffc0200470:	d9a9                	beqz	a1,ffffffffc02003c2 <kmonitor+0x7c>
ffffffffc0200472:	bf55                	j	ffffffffc0200426 <kmonitor+0xe0>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc0200474:	45c1                	li	a1,16
ffffffffc0200476:	855a                	mv	a0,s6
ffffffffc0200478:	d1dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc020047c:	b7e9                	j	ffffffffc0200446 <kmonitor+0x100>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc020047e:	6582                	ld	a1,0(sp)
ffffffffc0200480:	00005517          	auipc	a0,0x5
ffffffffc0200484:	4d050513          	addi	a0,a0,1232 # ffffffffc0205950 <etext+0x254>
ffffffffc0200488:	d0dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    return 0;
ffffffffc020048c:	b715                	j	ffffffffc02003b0 <kmonitor+0x6a>

ffffffffc020048e <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void __panic(const char *file, int line, const char *fmt, ...)
{
    if (is_panic)
ffffffffc020048e:	000aa317          	auipc	t1,0xaa
ffffffffc0200492:	31a30313          	addi	t1,t1,794 # ffffffffc02aa7a8 <is_panic>
ffffffffc0200496:	00033e03          	ld	t3,0(t1)
{
ffffffffc020049a:	715d                	addi	sp,sp,-80
ffffffffc020049c:	ec06                	sd	ra,24(sp)
ffffffffc020049e:	e822                	sd	s0,16(sp)
ffffffffc02004a0:	f436                	sd	a3,40(sp)
ffffffffc02004a2:	f83a                	sd	a4,48(sp)
ffffffffc02004a4:	fc3e                	sd	a5,56(sp)
ffffffffc02004a6:	e0c2                	sd	a6,64(sp)
ffffffffc02004a8:	e4c6                	sd	a7,72(sp)
    if (is_panic)
ffffffffc02004aa:	020e1a63          	bnez	t3,ffffffffc02004de <__panic+0x50>
    {
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc02004ae:	4785                	li	a5,1
ffffffffc02004b0:	00f33023          	sd	a5,0(t1)

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
ffffffffc02004b4:	8432                	mv	s0,a2
ffffffffc02004b6:	103c                	addi	a5,sp,40
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02004b8:	862e                	mv	a2,a1
ffffffffc02004ba:	85aa                	mv	a1,a0
ffffffffc02004bc:	00005517          	auipc	a0,0x5
ffffffffc02004c0:	4f450513          	addi	a0,a0,1268 # ffffffffc02059b0 <commands+0x48>
    va_start(ap, fmt);
ffffffffc02004c4:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02004c6:	ccfff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    vcprintf(fmt, ap);
ffffffffc02004ca:	65a2                	ld	a1,8(sp)
ffffffffc02004cc:	8522                	mv	a0,s0
ffffffffc02004ce:	ca7ff0ef          	jal	ra,ffffffffc0200174 <vcprintf>
    cprintf("\n");
ffffffffc02004d2:	00006517          	auipc	a0,0x6
ffffffffc02004d6:	5e650513          	addi	a0,a0,1510 # ffffffffc0206ab8 <default_pmm_manager+0x578>
ffffffffc02004da:	cbbff0ef          	jal	ra,ffffffffc0200194 <cprintf>
#endif
}

static inline void sbi_shutdown(void)
{
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc02004de:	4501                	li	a0,0
ffffffffc02004e0:	4581                	li	a1,0
ffffffffc02004e2:	4601                	li	a2,0
ffffffffc02004e4:	48a1                	li	a7,8
ffffffffc02004e6:	00000073          	ecall
    va_end(ap);

panic_dead:
    // No debug monitor here
    sbi_shutdown();
    intr_disable();
ffffffffc02004ea:	4ca000ef          	jal	ra,ffffffffc02009b4 <intr_disable>
    while (1)
    {
        kmonitor(NULL);
ffffffffc02004ee:	4501                	li	a0,0
ffffffffc02004f0:	e57ff0ef          	jal	ra,ffffffffc0200346 <kmonitor>
    while (1)
ffffffffc02004f4:	bfed                	j	ffffffffc02004ee <__panic+0x60>

ffffffffc02004f6 <__warn>:
    }
}

/* __warn - like panic, but don't */
void __warn(const char *file, int line, const char *fmt, ...)
{
ffffffffc02004f6:	715d                	addi	sp,sp,-80
ffffffffc02004f8:	832e                	mv	t1,a1
ffffffffc02004fa:	e822                	sd	s0,16(sp)
    va_list ap;
    va_start(ap, fmt);
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc02004fc:	85aa                	mv	a1,a0
{
ffffffffc02004fe:	8432                	mv	s0,a2
ffffffffc0200500:	fc3e                	sd	a5,56(sp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc0200502:	861a                	mv	a2,t1
    va_start(ap, fmt);
ffffffffc0200504:	103c                	addi	a5,sp,40
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc0200506:	00005517          	auipc	a0,0x5
ffffffffc020050a:	4ca50513          	addi	a0,a0,1226 # ffffffffc02059d0 <commands+0x68>
{
ffffffffc020050e:	ec06                	sd	ra,24(sp)
ffffffffc0200510:	f436                	sd	a3,40(sp)
ffffffffc0200512:	f83a                	sd	a4,48(sp)
ffffffffc0200514:	e0c2                	sd	a6,64(sp)
ffffffffc0200516:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0200518:	e43e                	sd	a5,8(sp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc020051a:	c7bff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    vcprintf(fmt, ap);
ffffffffc020051e:	65a2                	ld	a1,8(sp)
ffffffffc0200520:	8522                	mv	a0,s0
ffffffffc0200522:	c53ff0ef          	jal	ra,ffffffffc0200174 <vcprintf>
    cprintf("\n");
ffffffffc0200526:	00006517          	auipc	a0,0x6
ffffffffc020052a:	59250513          	addi	a0,a0,1426 # ffffffffc0206ab8 <default_pmm_manager+0x578>
ffffffffc020052e:	c67ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    va_end(ap);
}
ffffffffc0200532:	60e2                	ld	ra,24(sp)
ffffffffc0200534:	6442                	ld	s0,16(sp)
ffffffffc0200536:	6161                	addi	sp,sp,80
ffffffffc0200538:	8082                	ret

ffffffffc020053a <clock_init>:
 * and then enable IRQ_TIMER.
 * */
void clock_init(void) {
    // divided by 500 when using Spike(2MHz)
    // divided by 100 when using QEMU(10MHz)
    timebase = 1e7 / 100;
ffffffffc020053a:	67e1                	lui	a5,0x18
ffffffffc020053c:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_obj___user_exit_out_size+0xd570>
ffffffffc0200540:	000aa717          	auipc	a4,0xaa
ffffffffc0200544:	26f73c23          	sd	a5,632(a4) # ffffffffc02aa7b8 <timebase>
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200548:	c0102573          	rdtime	a0
	SBI_CALL_1(SBI_SET_TIMER, stime_value);
ffffffffc020054c:	4581                	li	a1,0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc020054e:	953e                	add	a0,a0,a5
ffffffffc0200550:	4601                	li	a2,0
ffffffffc0200552:	4881                	li	a7,0
ffffffffc0200554:	00000073          	ecall
    set_csr(sie, MIP_STIP);
ffffffffc0200558:	02000793          	li	a5,32
ffffffffc020055c:	1047a7f3          	csrrs	a5,sie,a5
    cprintf("++ setup timer interrupts\n");
ffffffffc0200560:	00005517          	auipc	a0,0x5
ffffffffc0200564:	49050513          	addi	a0,a0,1168 # ffffffffc02059f0 <commands+0x88>
    ticks = 0;
ffffffffc0200568:	000aa797          	auipc	a5,0xaa
ffffffffc020056c:	2407b423          	sd	zero,584(a5) # ffffffffc02aa7b0 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc0200570:	b115                	j	ffffffffc0200194 <cprintf>

ffffffffc0200572 <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200572:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200576:	000aa797          	auipc	a5,0xaa
ffffffffc020057a:	2427b783          	ld	a5,578(a5) # ffffffffc02aa7b8 <timebase>
ffffffffc020057e:	953e                	add	a0,a0,a5
ffffffffc0200580:	4581                	li	a1,0
ffffffffc0200582:	4601                	li	a2,0
ffffffffc0200584:	4881                	li	a7,0
ffffffffc0200586:	00000073          	ecall
ffffffffc020058a:	8082                	ret

ffffffffc020058c <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc020058c:	8082                	ret

ffffffffc020058e <cons_putc>:
#include <riscv.h>
#include <assert.h>

static inline bool __intr_save(void)
{
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020058e:	100027f3          	csrr	a5,sstatus
ffffffffc0200592:	8b89                	andi	a5,a5,2
	SBI_CALL_1(SBI_CONSOLE_PUTCHAR, ch);
ffffffffc0200594:	0ff57513          	zext.b	a0,a0
ffffffffc0200598:	e799                	bnez	a5,ffffffffc02005a6 <cons_putc+0x18>
ffffffffc020059a:	4581                	li	a1,0
ffffffffc020059c:	4601                	li	a2,0
ffffffffc020059e:	4885                	li	a7,1
ffffffffc02005a0:	00000073          	ecall
    return 0;
}

static inline void __intr_restore(bool flag)
{
    if (flag)
ffffffffc02005a4:	8082                	ret

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) {
ffffffffc02005a6:	1101                	addi	sp,sp,-32
ffffffffc02005a8:	ec06                	sd	ra,24(sp)
ffffffffc02005aa:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02005ac:	408000ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc02005b0:	6522                	ld	a0,8(sp)
ffffffffc02005b2:	4581                	li	a1,0
ffffffffc02005b4:	4601                	li	a2,0
ffffffffc02005b6:	4885                	li	a7,1
ffffffffc02005b8:	00000073          	ecall
    local_intr_save(intr_flag);
    {
        sbi_console_putchar((unsigned char)c);
    }
    local_intr_restore(intr_flag);
}
ffffffffc02005bc:	60e2                	ld	ra,24(sp)
ffffffffc02005be:	6105                	addi	sp,sp,32
    {
        intr_enable();
ffffffffc02005c0:	a6fd                	j	ffffffffc02009ae <intr_enable>

ffffffffc02005c2 <cons_getc>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02005c2:	100027f3          	csrr	a5,sstatus
ffffffffc02005c6:	8b89                	andi	a5,a5,2
ffffffffc02005c8:	eb89                	bnez	a5,ffffffffc02005da <cons_getc+0x18>
	return SBI_CALL_0(SBI_CONSOLE_GETCHAR);
ffffffffc02005ca:	4501                	li	a0,0
ffffffffc02005cc:	4581                	li	a1,0
ffffffffc02005ce:	4601                	li	a2,0
ffffffffc02005d0:	4889                	li	a7,2
ffffffffc02005d2:	00000073          	ecall
ffffffffc02005d6:	2501                	sext.w	a0,a0
    {
        c = sbi_console_getchar();
    }
    local_intr_restore(intr_flag);
    return c;
}
ffffffffc02005d8:	8082                	ret
int cons_getc(void) {
ffffffffc02005da:	1101                	addi	sp,sp,-32
ffffffffc02005dc:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc02005de:	3d6000ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc02005e2:	4501                	li	a0,0
ffffffffc02005e4:	4581                	li	a1,0
ffffffffc02005e6:	4601                	li	a2,0
ffffffffc02005e8:	4889                	li	a7,2
ffffffffc02005ea:	00000073          	ecall
ffffffffc02005ee:	2501                	sext.w	a0,a0
ffffffffc02005f0:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc02005f2:	3bc000ef          	jal	ra,ffffffffc02009ae <intr_enable>
}
ffffffffc02005f6:	60e2                	ld	ra,24(sp)
ffffffffc02005f8:	6522                	ld	a0,8(sp)
ffffffffc02005fa:	6105                	addi	sp,sp,32
ffffffffc02005fc:	8082                	ret

ffffffffc02005fe <dtb_init>:

// 保存解析出的系统物理内存信息
static uint64_t memory_base = 0;
static uint64_t memory_size = 0;

void dtb_init(void) {
ffffffffc02005fe:	7119                	addi	sp,sp,-128
    cprintf("DTB Init\n");
ffffffffc0200600:	00005517          	auipc	a0,0x5
ffffffffc0200604:	41050513          	addi	a0,a0,1040 # ffffffffc0205a10 <commands+0xa8>
void dtb_init(void) {
ffffffffc0200608:	fc86                	sd	ra,120(sp)
ffffffffc020060a:	f8a2                	sd	s0,112(sp)
ffffffffc020060c:	e8d2                	sd	s4,80(sp)
ffffffffc020060e:	f4a6                	sd	s1,104(sp)
ffffffffc0200610:	f0ca                	sd	s2,96(sp)
ffffffffc0200612:	ecce                	sd	s3,88(sp)
ffffffffc0200614:	e4d6                	sd	s5,72(sp)
ffffffffc0200616:	e0da                	sd	s6,64(sp)
ffffffffc0200618:	fc5e                	sd	s7,56(sp)
ffffffffc020061a:	f862                	sd	s8,48(sp)
ffffffffc020061c:	f466                	sd	s9,40(sp)
ffffffffc020061e:	f06a                	sd	s10,32(sp)
ffffffffc0200620:	ec6e                	sd	s11,24(sp)
    cprintf("DTB Init\n");
ffffffffc0200622:	b73ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc0200626:	0000b597          	auipc	a1,0xb
ffffffffc020062a:	9da5b583          	ld	a1,-1574(a1) # ffffffffc020b000 <boot_hartid>
ffffffffc020062e:	00005517          	auipc	a0,0x5
ffffffffc0200632:	3f250513          	addi	a0,a0,1010 # ffffffffc0205a20 <commands+0xb8>
ffffffffc0200636:	b5fff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc020063a:	0000b417          	auipc	s0,0xb
ffffffffc020063e:	9ce40413          	addi	s0,s0,-1586 # ffffffffc020b008 <boot_dtb>
ffffffffc0200642:	600c                	ld	a1,0(s0)
ffffffffc0200644:	00005517          	auipc	a0,0x5
ffffffffc0200648:	3ec50513          	addi	a0,a0,1004 # ffffffffc0205a30 <commands+0xc8>
ffffffffc020064c:	b49ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc0200650:	00043a03          	ld	s4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc0200654:	00005517          	auipc	a0,0x5
ffffffffc0200658:	3f450513          	addi	a0,a0,1012 # ffffffffc0205a48 <commands+0xe0>
    if (boot_dtb == 0) {
ffffffffc020065c:	120a0463          	beqz	s4,ffffffffc0200784 <dtb_init+0x186>
        return;
    }
    
    // 转换为虚拟地址
    uintptr_t dtb_vaddr = boot_dtb + PHYSICAL_MEMORY_OFFSET;
ffffffffc0200660:	57f5                	li	a5,-3
ffffffffc0200662:	07fa                	slli	a5,a5,0x1e
ffffffffc0200664:	00fa0733          	add	a4,s4,a5
    const struct fdt_header *header = (const struct fdt_header *)dtb_vaddr;
    
    // 验证DTB
    uint32_t magic = fdt32_to_cpu(header->magic);
ffffffffc0200668:	431c                	lw	a5,0(a4)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020066a:	00ff0637          	lui	a2,0xff0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020066e:	6b41                	lui	s6,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200670:	0087d59b          	srliw	a1,a5,0x8
ffffffffc0200674:	0187969b          	slliw	a3,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200678:	0187d51b          	srliw	a0,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020067c:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200680:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200684:	8df1                	and	a1,a1,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200686:	8ec9                	or	a3,a3,a0
ffffffffc0200688:	0087979b          	slliw	a5,a5,0x8
ffffffffc020068c:	1b7d                	addi	s6,s6,-1
ffffffffc020068e:	0167f7b3          	and	a5,a5,s6
ffffffffc0200692:	8dd5                	or	a1,a1,a3
ffffffffc0200694:	8ddd                	or	a1,a1,a5
    if (magic != 0xd00dfeed) {
ffffffffc0200696:	d00e07b7          	lui	a5,0xd00e0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020069a:	2581                	sext.w	a1,a1
    if (magic != 0xd00dfeed) {
ffffffffc020069c:	eed78793          	addi	a5,a5,-275 # ffffffffd00dfeed <end+0xfe356c1>
ffffffffc02006a0:	10f59163          	bne	a1,a5,ffffffffc02007a2 <dtb_init+0x1a4>
        return;
    }
    
    // 提取内存信息
    uint64_t mem_base, mem_size;
    if (extract_memory_info(dtb_vaddr, header, &mem_base, &mem_size) == 0) {
ffffffffc02006a4:	471c                	lw	a5,8(a4)
ffffffffc02006a6:	4754                	lw	a3,12(a4)
    int in_memory_node = 0;
ffffffffc02006a8:	4c81                	li	s9,0
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006aa:	0087d59b          	srliw	a1,a5,0x8
ffffffffc02006ae:	0086d51b          	srliw	a0,a3,0x8
ffffffffc02006b2:	0186941b          	slliw	s0,a3,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006b6:	0186d89b          	srliw	a7,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006ba:	01879a1b          	slliw	s4,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006be:	0187d81b          	srliw	a6,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006c2:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006c6:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006ca:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006ce:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006d2:	8d71                	and	a0,a0,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006d4:	01146433          	or	s0,s0,a7
ffffffffc02006d8:	0086969b          	slliw	a3,a3,0x8
ffffffffc02006dc:	010a6a33          	or	s4,s4,a6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006e0:	8e6d                	and	a2,a2,a1
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006e2:	0087979b          	slliw	a5,a5,0x8
ffffffffc02006e6:	8c49                	or	s0,s0,a0
ffffffffc02006e8:	0166f6b3          	and	a3,a3,s6
ffffffffc02006ec:	00ca6a33          	or	s4,s4,a2
ffffffffc02006f0:	0167f7b3          	and	a5,a5,s6
ffffffffc02006f4:	8c55                	or	s0,s0,a3
ffffffffc02006f6:	00fa6a33          	or	s4,s4,a5
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02006fa:	1402                	slli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc02006fc:	1a02                	slli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02006fe:	9001                	srli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200700:	020a5a13          	srli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200704:	943a                	add	s0,s0,a4
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200706:	9a3a                	add	s4,s4,a4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200708:	00ff0c37          	lui	s8,0xff0
        switch (token) {
ffffffffc020070c:	4b8d                	li	s7,3
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020070e:	00005917          	auipc	s2,0x5
ffffffffc0200712:	38a90913          	addi	s2,s2,906 # ffffffffc0205a98 <commands+0x130>
ffffffffc0200716:	49bd                	li	s3,15
        switch (token) {
ffffffffc0200718:	4d91                	li	s11,4
ffffffffc020071a:	4d05                	li	s10,1
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc020071c:	00005497          	auipc	s1,0x5
ffffffffc0200720:	37448493          	addi	s1,s1,884 # ffffffffc0205a90 <commands+0x128>
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200724:	000a2703          	lw	a4,0(s4)
ffffffffc0200728:	004a0a93          	addi	s5,s4,4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020072c:	0087569b          	srliw	a3,a4,0x8
ffffffffc0200730:	0187179b          	slliw	a5,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200734:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200738:	0106969b          	slliw	a3,a3,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020073c:	0107571b          	srliw	a4,a4,0x10
ffffffffc0200740:	8fd1                	or	a5,a5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200742:	0186f6b3          	and	a3,a3,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200746:	0087171b          	slliw	a4,a4,0x8
ffffffffc020074a:	8fd5                	or	a5,a5,a3
ffffffffc020074c:	00eb7733          	and	a4,s6,a4
ffffffffc0200750:	8fd9                	or	a5,a5,a4
ffffffffc0200752:	2781                	sext.w	a5,a5
        switch (token) {
ffffffffc0200754:	09778c63          	beq	a5,s7,ffffffffc02007ec <dtb_init+0x1ee>
ffffffffc0200758:	00fbea63          	bltu	s7,a5,ffffffffc020076c <dtb_init+0x16e>
ffffffffc020075c:	07a78663          	beq	a5,s10,ffffffffc02007c8 <dtb_init+0x1ca>
ffffffffc0200760:	4709                	li	a4,2
ffffffffc0200762:	00e79763          	bne	a5,a4,ffffffffc0200770 <dtb_init+0x172>
ffffffffc0200766:	4c81                	li	s9,0
ffffffffc0200768:	8a56                	mv	s4,s5
ffffffffc020076a:	bf6d                	j	ffffffffc0200724 <dtb_init+0x126>
ffffffffc020076c:	ffb78ee3          	beq	a5,s11,ffffffffc0200768 <dtb_init+0x16a>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
        // 保存到全局变量，供 PMM 查询
        memory_base = mem_base;
        memory_size = mem_size;
    } else {
        cprintf("Warning: Could not extract memory info from DTB\n");
ffffffffc0200770:	00005517          	auipc	a0,0x5
ffffffffc0200774:	3a050513          	addi	a0,a0,928 # ffffffffc0205b10 <commands+0x1a8>
ffffffffc0200778:	a1dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc020077c:	00005517          	auipc	a0,0x5
ffffffffc0200780:	3cc50513          	addi	a0,a0,972 # ffffffffc0205b48 <commands+0x1e0>
}
ffffffffc0200784:	7446                	ld	s0,112(sp)
ffffffffc0200786:	70e6                	ld	ra,120(sp)
ffffffffc0200788:	74a6                	ld	s1,104(sp)
ffffffffc020078a:	7906                	ld	s2,96(sp)
ffffffffc020078c:	69e6                	ld	s3,88(sp)
ffffffffc020078e:	6a46                	ld	s4,80(sp)
ffffffffc0200790:	6aa6                	ld	s5,72(sp)
ffffffffc0200792:	6b06                	ld	s6,64(sp)
ffffffffc0200794:	7be2                	ld	s7,56(sp)
ffffffffc0200796:	7c42                	ld	s8,48(sp)
ffffffffc0200798:	7ca2                	ld	s9,40(sp)
ffffffffc020079a:	7d02                	ld	s10,32(sp)
ffffffffc020079c:	6de2                	ld	s11,24(sp)
ffffffffc020079e:	6109                	addi	sp,sp,128
    cprintf("DTB init completed\n");
ffffffffc02007a0:	bad5                	j	ffffffffc0200194 <cprintf>
}
ffffffffc02007a2:	7446                	ld	s0,112(sp)
ffffffffc02007a4:	70e6                	ld	ra,120(sp)
ffffffffc02007a6:	74a6                	ld	s1,104(sp)
ffffffffc02007a8:	7906                	ld	s2,96(sp)
ffffffffc02007aa:	69e6                	ld	s3,88(sp)
ffffffffc02007ac:	6a46                	ld	s4,80(sp)
ffffffffc02007ae:	6aa6                	ld	s5,72(sp)
ffffffffc02007b0:	6b06                	ld	s6,64(sp)
ffffffffc02007b2:	7be2                	ld	s7,56(sp)
ffffffffc02007b4:	7c42                	ld	s8,48(sp)
ffffffffc02007b6:	7ca2                	ld	s9,40(sp)
ffffffffc02007b8:	7d02                	ld	s10,32(sp)
ffffffffc02007ba:	6de2                	ld	s11,24(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02007bc:	00005517          	auipc	a0,0x5
ffffffffc02007c0:	2ac50513          	addi	a0,a0,684 # ffffffffc0205a68 <commands+0x100>
}
ffffffffc02007c4:	6109                	addi	sp,sp,128
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02007c6:	b2f9                	j	ffffffffc0200194 <cprintf>
                int name_len = strlen(name);
ffffffffc02007c8:	8556                	mv	a0,s5
ffffffffc02007ca:	667040ef          	jal	ra,ffffffffc0205630 <strlen>
ffffffffc02007ce:	8a2a                	mv	s4,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02007d0:	4619                	li	a2,6
ffffffffc02007d2:	85a6                	mv	a1,s1
ffffffffc02007d4:	8556                	mv	a0,s5
                int name_len = strlen(name);
ffffffffc02007d6:	2a01                	sext.w	s4,s4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02007d8:	6bf040ef          	jal	ra,ffffffffc0205696 <strncmp>
ffffffffc02007dc:	e111                	bnez	a0,ffffffffc02007e0 <dtb_init+0x1e2>
                    in_memory_node = 1;
ffffffffc02007de:	4c85                	li	s9,1
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc02007e0:	0a91                	addi	s5,s5,4
ffffffffc02007e2:	9ad2                	add	s5,s5,s4
ffffffffc02007e4:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc02007e8:	8a56                	mv	s4,s5
ffffffffc02007ea:	bf2d                	j	ffffffffc0200724 <dtb_init+0x126>
                uint32_t prop_len = fdt32_to_cpu(*struct_ptr++);
ffffffffc02007ec:	004a2783          	lw	a5,4(s4)
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc02007f0:	00ca0693          	addi	a3,s4,12
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007f4:	0087d71b          	srliw	a4,a5,0x8
ffffffffc02007f8:	01879a9b          	slliw	s5,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007fc:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200800:	0107171b          	slliw	a4,a4,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200804:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200808:	00caeab3          	or	s5,s5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020080c:	01877733          	and	a4,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200810:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200814:	00eaeab3          	or	s5,s5,a4
ffffffffc0200818:	00fb77b3          	and	a5,s6,a5
ffffffffc020081c:	00faeab3          	or	s5,s5,a5
ffffffffc0200820:	2a81                	sext.w	s5,s5
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200822:	000c9c63          	bnez	s9,ffffffffc020083a <dtb_init+0x23c>
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + prop_len + 3) & ~3);
ffffffffc0200826:	1a82                	slli	s5,s5,0x20
ffffffffc0200828:	00368793          	addi	a5,a3,3
ffffffffc020082c:	020ada93          	srli	s5,s5,0x20
ffffffffc0200830:	9abe                	add	s5,s5,a5
ffffffffc0200832:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc0200836:	8a56                	mv	s4,s5
ffffffffc0200838:	b5f5                	j	ffffffffc0200724 <dtb_init+0x126>
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc020083a:	008a2783          	lw	a5,8(s4)
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020083e:	85ca                	mv	a1,s2
ffffffffc0200840:	e436                	sd	a3,8(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200842:	0087d51b          	srliw	a0,a5,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200846:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020084a:	0187971b          	slliw	a4,a5,0x18
ffffffffc020084e:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200852:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200856:	8f51                	or	a4,a4,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200858:	01857533          	and	a0,a0,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020085c:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200860:	8d59                	or	a0,a0,a4
ffffffffc0200862:	00fb77b3          	and	a5,s6,a5
ffffffffc0200866:	8d5d                	or	a0,a0,a5
                const char *prop_name = strings_base + prop_nameoff;
ffffffffc0200868:	1502                	slli	a0,a0,0x20
ffffffffc020086a:	9101                	srli	a0,a0,0x20
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020086c:	9522                	add	a0,a0,s0
ffffffffc020086e:	60b040ef          	jal	ra,ffffffffc0205678 <strcmp>
ffffffffc0200872:	66a2                	ld	a3,8(sp)
ffffffffc0200874:	f94d                	bnez	a0,ffffffffc0200826 <dtb_init+0x228>
ffffffffc0200876:	fb59f8e3          	bgeu	s3,s5,ffffffffc0200826 <dtb_init+0x228>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc020087a:	00ca3783          	ld	a5,12(s4)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc020087e:	014a3703          	ld	a4,20(s4)
        cprintf("Physical Memory from DTB:\n");
ffffffffc0200882:	00005517          	auipc	a0,0x5
ffffffffc0200886:	21e50513          	addi	a0,a0,542 # ffffffffc0205aa0 <commands+0x138>
           fdt32_to_cpu(x >> 32);
ffffffffc020088a:	4207d613          	srai	a2,a5,0x20
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020088e:	0087d31b          	srliw	t1,a5,0x8
           fdt32_to_cpu(x >> 32);
ffffffffc0200892:	42075593          	srai	a1,a4,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200896:	0187de1b          	srliw	t3,a5,0x18
ffffffffc020089a:	0186581b          	srliw	a6,a2,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020089e:	0187941b          	slliw	s0,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008a2:	0107d89b          	srliw	a7,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008a6:	0187d693          	srli	a3,a5,0x18
ffffffffc02008aa:	01861f1b          	slliw	t5,a2,0x18
ffffffffc02008ae:	0087579b          	srliw	a5,a4,0x8
ffffffffc02008b2:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008b6:	0106561b          	srliw	a2,a2,0x10
ffffffffc02008ba:	010f6f33          	or	t5,t5,a6
ffffffffc02008be:	0187529b          	srliw	t0,a4,0x18
ffffffffc02008c2:	0185df9b          	srliw	t6,a1,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008c6:	01837333          	and	t1,t1,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008ca:	01c46433          	or	s0,s0,t3
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008ce:	0186f6b3          	and	a3,a3,s8
ffffffffc02008d2:	01859e1b          	slliw	t3,a1,0x18
ffffffffc02008d6:	01871e9b          	slliw	t4,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008da:	0107581b          	srliw	a6,a4,0x10
ffffffffc02008de:	0086161b          	slliw	a2,a2,0x8
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008e2:	8361                	srli	a4,a4,0x18
ffffffffc02008e4:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008e8:	0105d59b          	srliw	a1,a1,0x10
ffffffffc02008ec:	01e6e6b3          	or	a3,a3,t5
ffffffffc02008f0:	00cb7633          	and	a2,s6,a2
ffffffffc02008f4:	0088181b          	slliw	a6,a6,0x8
ffffffffc02008f8:	0085959b          	slliw	a1,a1,0x8
ffffffffc02008fc:	00646433          	or	s0,s0,t1
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200900:	0187f7b3          	and	a5,a5,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200904:	01fe6333          	or	t1,t3,t6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200908:	01877c33          	and	s8,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020090c:	0088989b          	slliw	a7,a7,0x8
ffffffffc0200910:	011b78b3          	and	a7,s6,a7
ffffffffc0200914:	005eeeb3          	or	t4,t4,t0
ffffffffc0200918:	00c6e733          	or	a4,a3,a2
ffffffffc020091c:	006c6c33          	or	s8,s8,t1
ffffffffc0200920:	010b76b3          	and	a3,s6,a6
ffffffffc0200924:	00bb7b33          	and	s6,s6,a1
ffffffffc0200928:	01d7e7b3          	or	a5,a5,t4
ffffffffc020092c:	016c6b33          	or	s6,s8,s6
ffffffffc0200930:	01146433          	or	s0,s0,a7
ffffffffc0200934:	8fd5                	or	a5,a5,a3
           fdt32_to_cpu(x >> 32);
ffffffffc0200936:	1702                	slli	a4,a4,0x20
ffffffffc0200938:	1b02                	slli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc020093a:	1782                	slli	a5,a5,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc020093c:	9301                	srli	a4,a4,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc020093e:	1402                	slli	s0,s0,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc0200940:	020b5b13          	srli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200944:	0167eb33          	or	s6,a5,s6
ffffffffc0200948:	8c59                	or	s0,s0,a4
        cprintf("Physical Memory from DTB:\n");
ffffffffc020094a:	84bff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        cprintf("  Base: 0x%016lx\n", mem_base);
ffffffffc020094e:	85a2                	mv	a1,s0
ffffffffc0200950:	00005517          	auipc	a0,0x5
ffffffffc0200954:	17050513          	addi	a0,a0,368 # ffffffffc0205ac0 <commands+0x158>
ffffffffc0200958:	83dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc020095c:	014b5613          	srli	a2,s6,0x14
ffffffffc0200960:	85da                	mv	a1,s6
ffffffffc0200962:	00005517          	auipc	a0,0x5
ffffffffc0200966:	17650513          	addi	a0,a0,374 # ffffffffc0205ad8 <commands+0x170>
ffffffffc020096a:	82bff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc020096e:	008b05b3          	add	a1,s6,s0
ffffffffc0200972:	15fd                	addi	a1,a1,-1
ffffffffc0200974:	00005517          	auipc	a0,0x5
ffffffffc0200978:	18450513          	addi	a0,a0,388 # ffffffffc0205af8 <commands+0x190>
ffffffffc020097c:	819ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("DTB init completed\n");
ffffffffc0200980:	00005517          	auipc	a0,0x5
ffffffffc0200984:	1c850513          	addi	a0,a0,456 # ffffffffc0205b48 <commands+0x1e0>
        memory_base = mem_base;
ffffffffc0200988:	000aa797          	auipc	a5,0xaa
ffffffffc020098c:	e287bc23          	sd	s0,-456(a5) # ffffffffc02aa7c0 <memory_base>
        memory_size = mem_size;
ffffffffc0200990:	000aa797          	auipc	a5,0xaa
ffffffffc0200994:	e367bc23          	sd	s6,-456(a5) # ffffffffc02aa7c8 <memory_size>
    cprintf("DTB init completed\n");
ffffffffc0200998:	b3f5                	j	ffffffffc0200784 <dtb_init+0x186>

ffffffffc020099a <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc020099a:	000aa517          	auipc	a0,0xaa
ffffffffc020099e:	e2653503          	ld	a0,-474(a0) # ffffffffc02aa7c0 <memory_base>
ffffffffc02009a2:	8082                	ret

ffffffffc02009a4 <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
}
ffffffffc02009a4:	000aa517          	auipc	a0,0xaa
ffffffffc02009a8:	e2453503          	ld	a0,-476(a0) # ffffffffc02aa7c8 <memory_size>
ffffffffc02009ac:	8082                	ret

ffffffffc02009ae <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc02009ae:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc02009b2:	8082                	ret

ffffffffc02009b4 <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc02009b4:	100177f3          	csrrci	a5,sstatus,2
ffffffffc02009b8:	8082                	ret

ffffffffc02009ba <pic_init>:
#include <picirq.h>

void pic_enable(unsigned int irq) {}

/* pic_init - initialize the 8259A interrupt controllers */
void pic_init(void) {}
ffffffffc02009ba:	8082                	ret

ffffffffc02009bc <idt_init>:
void idt_init(void)
{
    extern void __alltraps(void);
    /* Set sscratch register to 0, indicating to exception vector that we are
     * presently executing in the kernel */
    write_csr(sscratch, 0);
ffffffffc02009bc:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
ffffffffc02009c0:	00000797          	auipc	a5,0x0
ffffffffc02009c4:	4b478793          	addi	a5,a5,1204 # ffffffffc0200e74 <__alltraps>
ffffffffc02009c8:	10579073          	csrw	stvec,a5
    /* Allow kernel to access user memory */
    set_csr(sstatus, SSTATUS_SUM);
ffffffffc02009cc:	000407b7          	lui	a5,0x40
ffffffffc02009d0:	1007a7f3          	csrrs	a5,sstatus,a5
}
ffffffffc02009d4:	8082                	ret

ffffffffc02009d6 <print_regs>:
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr)
{
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009d6:	610c                	ld	a1,0(a0)
{
ffffffffc02009d8:	1141                	addi	sp,sp,-16
ffffffffc02009da:	e022                	sd	s0,0(sp)
ffffffffc02009dc:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009de:	00005517          	auipc	a0,0x5
ffffffffc02009e2:	18250513          	addi	a0,a0,386 # ffffffffc0205b60 <commands+0x1f8>
{
ffffffffc02009e6:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009e8:	facff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc02009ec:	640c                	ld	a1,8(s0)
ffffffffc02009ee:	00005517          	auipc	a0,0x5
ffffffffc02009f2:	18a50513          	addi	a0,a0,394 # ffffffffc0205b78 <commands+0x210>
ffffffffc02009f6:	f9eff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc02009fa:	680c                	ld	a1,16(s0)
ffffffffc02009fc:	00005517          	auipc	a0,0x5
ffffffffc0200a00:	19450513          	addi	a0,a0,404 # ffffffffc0205b90 <commands+0x228>
ffffffffc0200a04:	f90ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc0200a08:	6c0c                	ld	a1,24(s0)
ffffffffc0200a0a:	00005517          	auipc	a0,0x5
ffffffffc0200a0e:	19e50513          	addi	a0,a0,414 # ffffffffc0205ba8 <commands+0x240>
ffffffffc0200a12:	f82ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc0200a16:	700c                	ld	a1,32(s0)
ffffffffc0200a18:	00005517          	auipc	a0,0x5
ffffffffc0200a1c:	1a850513          	addi	a0,a0,424 # ffffffffc0205bc0 <commands+0x258>
ffffffffc0200a20:	f74ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc0200a24:	740c                	ld	a1,40(s0)
ffffffffc0200a26:	00005517          	auipc	a0,0x5
ffffffffc0200a2a:	1b250513          	addi	a0,a0,434 # ffffffffc0205bd8 <commands+0x270>
ffffffffc0200a2e:	f66ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc0200a32:	780c                	ld	a1,48(s0)
ffffffffc0200a34:	00005517          	auipc	a0,0x5
ffffffffc0200a38:	1bc50513          	addi	a0,a0,444 # ffffffffc0205bf0 <commands+0x288>
ffffffffc0200a3c:	f58ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc0200a40:	7c0c                	ld	a1,56(s0)
ffffffffc0200a42:	00005517          	auipc	a0,0x5
ffffffffc0200a46:	1c650513          	addi	a0,a0,454 # ffffffffc0205c08 <commands+0x2a0>
ffffffffc0200a4a:	f4aff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc0200a4e:	602c                	ld	a1,64(s0)
ffffffffc0200a50:	00005517          	auipc	a0,0x5
ffffffffc0200a54:	1d050513          	addi	a0,a0,464 # ffffffffc0205c20 <commands+0x2b8>
ffffffffc0200a58:	f3cff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc0200a5c:	642c                	ld	a1,72(s0)
ffffffffc0200a5e:	00005517          	auipc	a0,0x5
ffffffffc0200a62:	1da50513          	addi	a0,a0,474 # ffffffffc0205c38 <commands+0x2d0>
ffffffffc0200a66:	f2eff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc0200a6a:	682c                	ld	a1,80(s0)
ffffffffc0200a6c:	00005517          	auipc	a0,0x5
ffffffffc0200a70:	1e450513          	addi	a0,a0,484 # ffffffffc0205c50 <commands+0x2e8>
ffffffffc0200a74:	f20ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc0200a78:	6c2c                	ld	a1,88(s0)
ffffffffc0200a7a:	00005517          	auipc	a0,0x5
ffffffffc0200a7e:	1ee50513          	addi	a0,a0,494 # ffffffffc0205c68 <commands+0x300>
ffffffffc0200a82:	f12ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200a86:	702c                	ld	a1,96(s0)
ffffffffc0200a88:	00005517          	auipc	a0,0x5
ffffffffc0200a8c:	1f850513          	addi	a0,a0,504 # ffffffffc0205c80 <commands+0x318>
ffffffffc0200a90:	f04ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc0200a94:	742c                	ld	a1,104(s0)
ffffffffc0200a96:	00005517          	auipc	a0,0x5
ffffffffc0200a9a:	20250513          	addi	a0,a0,514 # ffffffffc0205c98 <commands+0x330>
ffffffffc0200a9e:	ef6ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc0200aa2:	782c                	ld	a1,112(s0)
ffffffffc0200aa4:	00005517          	auipc	a0,0x5
ffffffffc0200aa8:	20c50513          	addi	a0,a0,524 # ffffffffc0205cb0 <commands+0x348>
ffffffffc0200aac:	ee8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200ab0:	7c2c                	ld	a1,120(s0)
ffffffffc0200ab2:	00005517          	auipc	a0,0x5
ffffffffc0200ab6:	21650513          	addi	a0,a0,534 # ffffffffc0205cc8 <commands+0x360>
ffffffffc0200aba:	edaff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc0200abe:	604c                	ld	a1,128(s0)
ffffffffc0200ac0:	00005517          	auipc	a0,0x5
ffffffffc0200ac4:	22050513          	addi	a0,a0,544 # ffffffffc0205ce0 <commands+0x378>
ffffffffc0200ac8:	eccff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc0200acc:	644c                	ld	a1,136(s0)
ffffffffc0200ace:	00005517          	auipc	a0,0x5
ffffffffc0200ad2:	22a50513          	addi	a0,a0,554 # ffffffffc0205cf8 <commands+0x390>
ffffffffc0200ad6:	ebeff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200ada:	684c                	ld	a1,144(s0)
ffffffffc0200adc:	00005517          	auipc	a0,0x5
ffffffffc0200ae0:	23450513          	addi	a0,a0,564 # ffffffffc0205d10 <commands+0x3a8>
ffffffffc0200ae4:	eb0ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200ae8:	6c4c                	ld	a1,152(s0)
ffffffffc0200aea:	00005517          	auipc	a0,0x5
ffffffffc0200aee:	23e50513          	addi	a0,a0,574 # ffffffffc0205d28 <commands+0x3c0>
ffffffffc0200af2:	ea2ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc0200af6:	704c                	ld	a1,160(s0)
ffffffffc0200af8:	00005517          	auipc	a0,0x5
ffffffffc0200afc:	24850513          	addi	a0,a0,584 # ffffffffc0205d40 <commands+0x3d8>
ffffffffc0200b00:	e94ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc0200b04:	744c                	ld	a1,168(s0)
ffffffffc0200b06:	00005517          	auipc	a0,0x5
ffffffffc0200b0a:	25250513          	addi	a0,a0,594 # ffffffffc0205d58 <commands+0x3f0>
ffffffffc0200b0e:	e86ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc0200b12:	784c                	ld	a1,176(s0)
ffffffffc0200b14:	00005517          	auipc	a0,0x5
ffffffffc0200b18:	25c50513          	addi	a0,a0,604 # ffffffffc0205d70 <commands+0x408>
ffffffffc0200b1c:	e78ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc0200b20:	7c4c                	ld	a1,184(s0)
ffffffffc0200b22:	00005517          	auipc	a0,0x5
ffffffffc0200b26:	26650513          	addi	a0,a0,614 # ffffffffc0205d88 <commands+0x420>
ffffffffc0200b2a:	e6aff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc0200b2e:	606c                	ld	a1,192(s0)
ffffffffc0200b30:	00005517          	auipc	a0,0x5
ffffffffc0200b34:	27050513          	addi	a0,a0,624 # ffffffffc0205da0 <commands+0x438>
ffffffffc0200b38:	e5cff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc0200b3c:	646c                	ld	a1,200(s0)
ffffffffc0200b3e:	00005517          	auipc	a0,0x5
ffffffffc0200b42:	27a50513          	addi	a0,a0,634 # ffffffffc0205db8 <commands+0x450>
ffffffffc0200b46:	e4eff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc0200b4a:	686c                	ld	a1,208(s0)
ffffffffc0200b4c:	00005517          	auipc	a0,0x5
ffffffffc0200b50:	28450513          	addi	a0,a0,644 # ffffffffc0205dd0 <commands+0x468>
ffffffffc0200b54:	e40ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc0200b58:	6c6c                	ld	a1,216(s0)
ffffffffc0200b5a:	00005517          	auipc	a0,0x5
ffffffffc0200b5e:	28e50513          	addi	a0,a0,654 # ffffffffc0205de8 <commands+0x480>
ffffffffc0200b62:	e32ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200b66:	706c                	ld	a1,224(s0)
ffffffffc0200b68:	00005517          	auipc	a0,0x5
ffffffffc0200b6c:	29850513          	addi	a0,a0,664 # ffffffffc0205e00 <commands+0x498>
ffffffffc0200b70:	e24ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200b74:	746c                	ld	a1,232(s0)
ffffffffc0200b76:	00005517          	auipc	a0,0x5
ffffffffc0200b7a:	2a250513          	addi	a0,a0,674 # ffffffffc0205e18 <commands+0x4b0>
ffffffffc0200b7e:	e16ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200b82:	786c                	ld	a1,240(s0)
ffffffffc0200b84:	00005517          	auipc	a0,0x5
ffffffffc0200b88:	2ac50513          	addi	a0,a0,684 # ffffffffc0205e30 <commands+0x4c8>
ffffffffc0200b8c:	e08ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b90:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200b92:	6402                	ld	s0,0(sp)
ffffffffc0200b94:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b96:	00005517          	auipc	a0,0x5
ffffffffc0200b9a:	2b250513          	addi	a0,a0,690 # ffffffffc0205e48 <commands+0x4e0>
}
ffffffffc0200b9e:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200ba0:	df4ff06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0200ba4 <print_trapframe>:
{
ffffffffc0200ba4:	1141                	addi	sp,sp,-16
ffffffffc0200ba6:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200ba8:	85aa                	mv	a1,a0
{
ffffffffc0200baa:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc0200bac:	00005517          	auipc	a0,0x5
ffffffffc0200bb0:	2b450513          	addi	a0,a0,692 # ffffffffc0205e60 <commands+0x4f8>
{
ffffffffc0200bb4:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200bb6:	ddeff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200bba:	8522                	mv	a0,s0
ffffffffc0200bbc:	e1bff0ef          	jal	ra,ffffffffc02009d6 <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200bc0:	10043583          	ld	a1,256(s0)
ffffffffc0200bc4:	00005517          	auipc	a0,0x5
ffffffffc0200bc8:	2b450513          	addi	a0,a0,692 # ffffffffc0205e78 <commands+0x510>
ffffffffc0200bcc:	dc8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200bd0:	10843583          	ld	a1,264(s0)
ffffffffc0200bd4:	00005517          	auipc	a0,0x5
ffffffffc0200bd8:	2bc50513          	addi	a0,a0,700 # ffffffffc0205e90 <commands+0x528>
ffffffffc0200bdc:	db8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  tval 0x%08x\n", tf->tval);
ffffffffc0200be0:	11043583          	ld	a1,272(s0)
ffffffffc0200be4:	00005517          	auipc	a0,0x5
ffffffffc0200be8:	2c450513          	addi	a0,a0,708 # ffffffffc0205ea8 <commands+0x540>
ffffffffc0200bec:	da8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200bf0:	11843583          	ld	a1,280(s0)
}
ffffffffc0200bf4:	6402                	ld	s0,0(sp)
ffffffffc0200bf6:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200bf8:	00005517          	auipc	a0,0x5
ffffffffc0200bfc:	2c050513          	addi	a0,a0,704 # ffffffffc0205eb8 <commands+0x550>
}
ffffffffc0200c00:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200c02:	d92ff06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0200c06 <interrupt_handler>:

extern struct mm_struct *check_mm_struct;

void interrupt_handler(struct trapframe *tf)
{
    intptr_t cause = (tf->cause << 1) >> 1;
ffffffffc0200c06:	11853783          	ld	a5,280(a0)
ffffffffc0200c0a:	472d                	li	a4,11
ffffffffc0200c0c:	0786                	slli	a5,a5,0x1
ffffffffc0200c0e:	8385                	srli	a5,a5,0x1
ffffffffc0200c10:	08f76363          	bltu	a4,a5,ffffffffc0200c96 <interrupt_handler+0x90>
ffffffffc0200c14:	00005717          	auipc	a4,0x5
ffffffffc0200c18:	36c70713          	addi	a4,a4,876 # ffffffffc0205f80 <commands+0x618>
ffffffffc0200c1c:	078a                	slli	a5,a5,0x2
ffffffffc0200c1e:	97ba                	add	a5,a5,a4
ffffffffc0200c20:	439c                	lw	a5,0(a5)
ffffffffc0200c22:	97ba                	add	a5,a5,a4
ffffffffc0200c24:	8782                	jr	a5
        break;
    case IRQ_H_SOFT:
        cprintf("Hypervisor software interrupt\n");
        break;
    case IRQ_M_SOFT:
        cprintf("Machine software interrupt\n");
ffffffffc0200c26:	00005517          	auipc	a0,0x5
ffffffffc0200c2a:	30a50513          	addi	a0,a0,778 # ffffffffc0205f30 <commands+0x5c8>
ffffffffc0200c2e:	d66ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Hypervisor software interrupt\n");
ffffffffc0200c32:	00005517          	auipc	a0,0x5
ffffffffc0200c36:	2de50513          	addi	a0,a0,734 # ffffffffc0205f10 <commands+0x5a8>
ffffffffc0200c3a:	d5aff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("User software interrupt\n");
ffffffffc0200c3e:	00005517          	auipc	a0,0x5
ffffffffc0200c42:	29250513          	addi	a0,a0,658 # ffffffffc0205ed0 <commands+0x568>
ffffffffc0200c46:	d4eff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Supervisor software interrupt\n");
ffffffffc0200c4a:	00005517          	auipc	a0,0x5
ffffffffc0200c4e:	2a650513          	addi	a0,a0,678 # ffffffffc0205ef0 <commands+0x588>
ffffffffc0200c52:	d42ff06f          	j	ffffffffc0200194 <cprintf>
{
ffffffffc0200c56:	1141                	addi	sp,sp,-16
ffffffffc0200c58:	e406                	sd	ra,8(sp)
        /*(1)设置下次时钟中断- clock_set_next_event()
         *(2)计数器（ticks）加一
         *(3)当计数器加到100的时候，我们会输出一个`100ticks`表示我们触发了100次时钟中断，同时打印次数（num）加一
         * (4)判断打印次数，当打印次数为10时，调用<sbi.h>中的关机函数关机
         */
        clock_set_next_event();
ffffffffc0200c5a:	919ff0ef          	jal	ra,ffffffffc0200572 <clock_set_next_event>
        current->need_resched = 1;
ffffffffc0200c5e:	000aa797          	auipc	a5,0xaa
ffffffffc0200c62:	bb27b783          	ld	a5,-1102(a5) # ffffffffc02aa810 <current>
ffffffffc0200c66:	4705                	li	a4,1
ffffffffc0200c68:	ef98                	sd	a4,24(a5)
        static int printed_num = 0;

        // 递增 ticks 并检查是否达到阈值
        ticks++;
ffffffffc0200c6a:	000aa797          	auipc	a5,0xaa
ffffffffc0200c6e:	b4678793          	addi	a5,a5,-1210 # ffffffffc02aa7b0 <ticks>
ffffffffc0200c72:	6398                	ld	a4,0(a5)
ffffffffc0200c74:	0705                	addi	a4,a4,1
ffffffffc0200c76:	e398                	sd	a4,0(a5)
        if (ticks % TICK_NUM == 0) {
ffffffffc0200c78:	639c                	ld	a5,0(a5)
ffffffffc0200c7a:	06400713          	li	a4,100
ffffffffc0200c7e:	02e7f7b3          	remu	a5,a5,a4
ffffffffc0200c82:	cb99                	beqz	a5,ffffffffc0200c98 <interrupt_handler+0x92>
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200c84:	60a2                	ld	ra,8(sp)
ffffffffc0200c86:	0141                	addi	sp,sp,16
ffffffffc0200c88:	8082                	ret
        cprintf("Supervisor external interrupt\n");
ffffffffc0200c8a:	00005517          	auipc	a0,0x5
ffffffffc0200c8e:	2d650513          	addi	a0,a0,726 # ffffffffc0205f60 <commands+0x5f8>
ffffffffc0200c92:	d02ff06f          	j	ffffffffc0200194 <cprintf>
        print_trapframe(tf);
ffffffffc0200c96:	b739                	j	ffffffffc0200ba4 <print_trapframe>
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200c98:	06400593          	li	a1,100
ffffffffc0200c9c:	00005517          	auipc	a0,0x5
ffffffffc0200ca0:	2b450513          	addi	a0,a0,692 # ffffffffc0205f50 <commands+0x5e8>
ffffffffc0200ca4:	cf0ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
            printed_num++;
ffffffffc0200ca8:	000aa697          	auipc	a3,0xaa
ffffffffc0200cac:	b2868693          	addi	a3,a3,-1240 # ffffffffc02aa7d0 <printed_num.0>
ffffffffc0200cb0:	429c                	lw	a5,0(a3)
            if (printed_num % 10 == 0) {
ffffffffc0200cb2:	4729                	li	a4,10
            printed_num++;
ffffffffc0200cb4:	2785                	addiw	a5,a5,1
            if (printed_num % 10 == 0) {
ffffffffc0200cb6:	02e7e73b          	remw	a4,a5,a4
            printed_num++;
ffffffffc0200cba:	c29c                	sw	a5,0(a3)
            if (printed_num % 10 == 0) {
ffffffffc0200cbc:	f761                	bnez	a4,ffffffffc0200c84 <interrupt_handler+0x7e>
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc0200cbe:	4501                	li	a0,0
ffffffffc0200cc0:	4581                	li	a1,0
ffffffffc0200cc2:	4601                	li	a2,0
ffffffffc0200cc4:	48a1                	li	a7,8
ffffffffc0200cc6:	00000073          	ecall
}
ffffffffc0200cca:	bf6d                	j	ffffffffc0200c84 <interrupt_handler+0x7e>

ffffffffc0200ccc <exception_handler>:
void kernel_execve_ret(struct trapframe *tf, uintptr_t kstacktop);
void exception_handler(struct trapframe *tf)
{
    int ret;
    switch (tf->cause)
ffffffffc0200ccc:	11853783          	ld	a5,280(a0)
{
ffffffffc0200cd0:	1141                	addi	sp,sp,-16
ffffffffc0200cd2:	e022                	sd	s0,0(sp)
ffffffffc0200cd4:	e406                	sd	ra,8(sp)
ffffffffc0200cd6:	473d                	li	a4,15
ffffffffc0200cd8:	842a                	mv	s0,a0
ffffffffc0200cda:	0cf76463          	bltu	a4,a5,ffffffffc0200da2 <exception_handler+0xd6>
ffffffffc0200cde:	00005717          	auipc	a4,0x5
ffffffffc0200ce2:	46270713          	addi	a4,a4,1122 # ffffffffc0206140 <commands+0x7d8>
ffffffffc0200ce6:	078a                	slli	a5,a5,0x2
ffffffffc0200ce8:	97ba                	add	a5,a5,a4
ffffffffc0200cea:	439c                	lw	a5,0(a5)
ffffffffc0200cec:	97ba                	add	a5,a5,a4
ffffffffc0200cee:	8782                	jr	a5
        // cprintf("Environment call from U-mode\n");
        tf->epc += 4;
        syscall();
        break;
    case CAUSE_SUPERVISOR_ECALL:
        cprintf("Environment call from S-mode\n");
ffffffffc0200cf0:	00005517          	auipc	a0,0x5
ffffffffc0200cf4:	3a850513          	addi	a0,a0,936 # ffffffffc0206098 <commands+0x730>
ffffffffc0200cf8:	c9cff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        tf->epc += 4;
ffffffffc0200cfc:	10843783          	ld	a5,264(s0)
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200d00:	60a2                	ld	ra,8(sp)
        tf->epc += 4;
ffffffffc0200d02:	0791                	addi	a5,a5,4
ffffffffc0200d04:	10f43423          	sd	a5,264(s0)
}
ffffffffc0200d08:	6402                	ld	s0,0(sp)
ffffffffc0200d0a:	0141                	addi	sp,sp,16
        syscall();
ffffffffc0200d0c:	4a00406f          	j	ffffffffc02051ac <syscall>
        cprintf("Environment call from H-mode\n");
ffffffffc0200d10:	00005517          	auipc	a0,0x5
ffffffffc0200d14:	3a850513          	addi	a0,a0,936 # ffffffffc02060b8 <commands+0x750>
}
ffffffffc0200d18:	6402                	ld	s0,0(sp)
ffffffffc0200d1a:	60a2                	ld	ra,8(sp)
ffffffffc0200d1c:	0141                	addi	sp,sp,16
        cprintf("Instruction access fault\n");
ffffffffc0200d1e:	c76ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Environment call from M-mode\n");
ffffffffc0200d22:	00005517          	auipc	a0,0x5
ffffffffc0200d26:	3b650513          	addi	a0,a0,950 # ffffffffc02060d8 <commands+0x770>
ffffffffc0200d2a:	b7fd                	j	ffffffffc0200d18 <exception_handler+0x4c>
        cprintf("Instruction page fault\n");
ffffffffc0200d2c:	00005517          	auipc	a0,0x5
ffffffffc0200d30:	3cc50513          	addi	a0,a0,972 # ffffffffc02060f8 <commands+0x790>
ffffffffc0200d34:	b7d5                	j	ffffffffc0200d18 <exception_handler+0x4c>
        cprintf("Load page fault\n");
ffffffffc0200d36:	00005517          	auipc	a0,0x5
ffffffffc0200d3a:	3da50513          	addi	a0,a0,986 # ffffffffc0206110 <commands+0x7a8>
ffffffffc0200d3e:	bfe9                	j	ffffffffc0200d18 <exception_handler+0x4c>
        cprintf("Store/AMO page fault\n");
ffffffffc0200d40:	00005517          	auipc	a0,0x5
ffffffffc0200d44:	3e850513          	addi	a0,a0,1000 # ffffffffc0206128 <commands+0x7c0>
ffffffffc0200d48:	bfc1                	j	ffffffffc0200d18 <exception_handler+0x4c>
        cprintf("Instruction address misaligned\n");
ffffffffc0200d4a:	00005517          	auipc	a0,0x5
ffffffffc0200d4e:	26650513          	addi	a0,a0,614 # ffffffffc0205fb0 <commands+0x648>
ffffffffc0200d52:	b7d9                	j	ffffffffc0200d18 <exception_handler+0x4c>
        cprintf("Instruction access fault\n");
ffffffffc0200d54:	00005517          	auipc	a0,0x5
ffffffffc0200d58:	27c50513          	addi	a0,a0,636 # ffffffffc0205fd0 <commands+0x668>
ffffffffc0200d5c:	bf75                	j	ffffffffc0200d18 <exception_handler+0x4c>
        cprintf("Illegal instruction\n");
ffffffffc0200d5e:	00005517          	auipc	a0,0x5
ffffffffc0200d62:	29250513          	addi	a0,a0,658 # ffffffffc0205ff0 <commands+0x688>
ffffffffc0200d66:	bf4d                	j	ffffffffc0200d18 <exception_handler+0x4c>
        cprintf("Breakpoint\n");
ffffffffc0200d68:	00005517          	auipc	a0,0x5
ffffffffc0200d6c:	2a050513          	addi	a0,a0,672 # ffffffffc0206008 <commands+0x6a0>
ffffffffc0200d70:	c24ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        if (tf->gpr.a7 == 10)
ffffffffc0200d74:	6458                	ld	a4,136(s0)
ffffffffc0200d76:	47a9                	li	a5,10
ffffffffc0200d78:	04f70663          	beq	a4,a5,ffffffffc0200dc4 <exception_handler+0xf8>
}
ffffffffc0200d7c:	60a2                	ld	ra,8(sp)
ffffffffc0200d7e:	6402                	ld	s0,0(sp)
ffffffffc0200d80:	0141                	addi	sp,sp,16
ffffffffc0200d82:	8082                	ret
        cprintf("Load address misaligned\n");
ffffffffc0200d84:	00005517          	auipc	a0,0x5
ffffffffc0200d88:	29450513          	addi	a0,a0,660 # ffffffffc0206018 <commands+0x6b0>
ffffffffc0200d8c:	b771                	j	ffffffffc0200d18 <exception_handler+0x4c>
        cprintf("Load access fault\n");
ffffffffc0200d8e:	00005517          	auipc	a0,0x5
ffffffffc0200d92:	2aa50513          	addi	a0,a0,682 # ffffffffc0206038 <commands+0x6d0>
ffffffffc0200d96:	b749                	j	ffffffffc0200d18 <exception_handler+0x4c>
        cprintf("Store/AMO access fault\n");
ffffffffc0200d98:	00005517          	auipc	a0,0x5
ffffffffc0200d9c:	2e850513          	addi	a0,a0,744 # ffffffffc0206080 <commands+0x718>
ffffffffc0200da0:	bfa5                	j	ffffffffc0200d18 <exception_handler+0x4c>
        print_trapframe(tf);
ffffffffc0200da2:	8522                	mv	a0,s0
}
ffffffffc0200da4:	6402                	ld	s0,0(sp)
ffffffffc0200da6:	60a2                	ld	ra,8(sp)
ffffffffc0200da8:	0141                	addi	sp,sp,16
        print_trapframe(tf);
ffffffffc0200daa:	bbed                	j	ffffffffc0200ba4 <print_trapframe>
        panic("AMO address misaligned\n");
ffffffffc0200dac:	00005617          	auipc	a2,0x5
ffffffffc0200db0:	2a460613          	addi	a2,a2,676 # ffffffffc0206050 <commands+0x6e8>
ffffffffc0200db4:	0cb00593          	li	a1,203
ffffffffc0200db8:	00005517          	auipc	a0,0x5
ffffffffc0200dbc:	2b050513          	addi	a0,a0,688 # ffffffffc0206068 <commands+0x700>
ffffffffc0200dc0:	eceff0ef          	jal	ra,ffffffffc020048e <__panic>
            tf->epc += 4;
ffffffffc0200dc4:	10843783          	ld	a5,264(s0)
ffffffffc0200dc8:	0791                	addi	a5,a5,4
ffffffffc0200dca:	10f43423          	sd	a5,264(s0)
            syscall();
ffffffffc0200dce:	3de040ef          	jal	ra,ffffffffc02051ac <syscall>
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200dd2:	000aa797          	auipc	a5,0xaa
ffffffffc0200dd6:	a3e7b783          	ld	a5,-1474(a5) # ffffffffc02aa810 <current>
ffffffffc0200dda:	6b9c                	ld	a5,16(a5)
ffffffffc0200ddc:	8522                	mv	a0,s0
}
ffffffffc0200dde:	6402                	ld	s0,0(sp)
ffffffffc0200de0:	60a2                	ld	ra,8(sp)
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200de2:	6589                	lui	a1,0x2
ffffffffc0200de4:	95be                	add	a1,a1,a5
}
ffffffffc0200de6:	0141                	addi	sp,sp,16
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200de8:	aaa9                	j	ffffffffc0200f42 <kernel_execve_ret>

ffffffffc0200dea <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf)
{
ffffffffc0200dea:	1101                	addi	sp,sp,-32
ffffffffc0200dec:	e822                	sd	s0,16(sp)
    // dispatch based on what type of trap occurred
    //    cputs("some trap");
    if (current == NULL)
ffffffffc0200dee:	000aa417          	auipc	s0,0xaa
ffffffffc0200df2:	a2240413          	addi	s0,s0,-1502 # ffffffffc02aa810 <current>
ffffffffc0200df6:	6018                	ld	a4,0(s0)
{
ffffffffc0200df8:	ec06                	sd	ra,24(sp)
ffffffffc0200dfa:	e426                	sd	s1,8(sp)
ffffffffc0200dfc:	e04a                	sd	s2,0(sp)
    if ((intptr_t)tf->cause < 0)
ffffffffc0200dfe:	11853683          	ld	a3,280(a0)
    if (current == NULL)
ffffffffc0200e02:	cf1d                	beqz	a4,ffffffffc0200e40 <trap+0x56>
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200e04:	10053483          	ld	s1,256(a0)
    {
        trap_dispatch(tf);
    }
    else
    {
        struct trapframe *otf = current->tf;
ffffffffc0200e08:	0a073903          	ld	s2,160(a4)
        current->tf = tf;
ffffffffc0200e0c:	f348                	sd	a0,160(a4)
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200e0e:	1004f493          	andi	s1,s1,256
    if ((intptr_t)tf->cause < 0)
ffffffffc0200e12:	0206c463          	bltz	a3,ffffffffc0200e3a <trap+0x50>
        exception_handler(tf);
ffffffffc0200e16:	eb7ff0ef          	jal	ra,ffffffffc0200ccc <exception_handler>

        bool in_kernel = trap_in_kernel(tf);

        trap_dispatch(tf);

        current->tf = otf;
ffffffffc0200e1a:	601c                	ld	a5,0(s0)
ffffffffc0200e1c:	0b27b023          	sd	s2,160(a5)
        if (!in_kernel)
ffffffffc0200e20:	e499                	bnez	s1,ffffffffc0200e2e <trap+0x44>
        {
            if (current->flags & PF_EXITING)
ffffffffc0200e22:	0b07a703          	lw	a4,176(a5)
ffffffffc0200e26:	8b05                	andi	a4,a4,1
ffffffffc0200e28:	e329                	bnez	a4,ffffffffc0200e6a <trap+0x80>
            {
                do_exit(-E_KILLED);
            }
            if (current->need_resched)
ffffffffc0200e2a:	6f9c                	ld	a5,24(a5)
ffffffffc0200e2c:	eb85                	bnez	a5,ffffffffc0200e5c <trap+0x72>
            {
                schedule();
            }
        }
    }
}
ffffffffc0200e2e:	60e2                	ld	ra,24(sp)
ffffffffc0200e30:	6442                	ld	s0,16(sp)
ffffffffc0200e32:	64a2                	ld	s1,8(sp)
ffffffffc0200e34:	6902                	ld	s2,0(sp)
ffffffffc0200e36:	6105                	addi	sp,sp,32
ffffffffc0200e38:	8082                	ret
        interrupt_handler(tf);
ffffffffc0200e3a:	dcdff0ef          	jal	ra,ffffffffc0200c06 <interrupt_handler>
ffffffffc0200e3e:	bff1                	j	ffffffffc0200e1a <trap+0x30>
    if ((intptr_t)tf->cause < 0)
ffffffffc0200e40:	0006c863          	bltz	a3,ffffffffc0200e50 <trap+0x66>
}
ffffffffc0200e44:	6442                	ld	s0,16(sp)
ffffffffc0200e46:	60e2                	ld	ra,24(sp)
ffffffffc0200e48:	64a2                	ld	s1,8(sp)
ffffffffc0200e4a:	6902                	ld	s2,0(sp)
ffffffffc0200e4c:	6105                	addi	sp,sp,32
        exception_handler(tf);
ffffffffc0200e4e:	bdbd                	j	ffffffffc0200ccc <exception_handler>
}
ffffffffc0200e50:	6442                	ld	s0,16(sp)
ffffffffc0200e52:	60e2                	ld	ra,24(sp)
ffffffffc0200e54:	64a2                	ld	s1,8(sp)
ffffffffc0200e56:	6902                	ld	s2,0(sp)
ffffffffc0200e58:	6105                	addi	sp,sp,32
        interrupt_handler(tf);
ffffffffc0200e5a:	b375                	j	ffffffffc0200c06 <interrupt_handler>
}
ffffffffc0200e5c:	6442                	ld	s0,16(sp)
ffffffffc0200e5e:	60e2                	ld	ra,24(sp)
ffffffffc0200e60:	64a2                	ld	s1,8(sp)
ffffffffc0200e62:	6902                	ld	s2,0(sp)
ffffffffc0200e64:	6105                	addi	sp,sp,32
                schedule();
ffffffffc0200e66:	25a0406f          	j	ffffffffc02050c0 <schedule>
                do_exit(-E_KILLED);
ffffffffc0200e6a:	555d                	li	a0,-9
ffffffffc0200e6c:	596030ef          	jal	ra,ffffffffc0204402 <do_exit>
            if (current->need_resched)
ffffffffc0200e70:	601c                	ld	a5,0(s0)
ffffffffc0200e72:	bf65                	j	ffffffffc0200e2a <trap+0x40>

ffffffffc0200e74 <__alltraps>:
    LOAD x2, 2*REGBYTES(sp)
    .endm

    .globl __alltraps
__alltraps:
    SAVE_ALL
ffffffffc0200e74:	14011173          	csrrw	sp,sscratch,sp
ffffffffc0200e78:	00011463          	bnez	sp,ffffffffc0200e80 <__alltraps+0xc>
ffffffffc0200e7c:	14002173          	csrr	sp,sscratch
ffffffffc0200e80:	712d                	addi	sp,sp,-288
ffffffffc0200e82:	e002                	sd	zero,0(sp)
ffffffffc0200e84:	e406                	sd	ra,8(sp)
ffffffffc0200e86:	ec0e                	sd	gp,24(sp)
ffffffffc0200e88:	f012                	sd	tp,32(sp)
ffffffffc0200e8a:	f416                	sd	t0,40(sp)
ffffffffc0200e8c:	f81a                	sd	t1,48(sp)
ffffffffc0200e8e:	fc1e                	sd	t2,56(sp)
ffffffffc0200e90:	e0a2                	sd	s0,64(sp)
ffffffffc0200e92:	e4a6                	sd	s1,72(sp)
ffffffffc0200e94:	e8aa                	sd	a0,80(sp)
ffffffffc0200e96:	ecae                	sd	a1,88(sp)
ffffffffc0200e98:	f0b2                	sd	a2,96(sp)
ffffffffc0200e9a:	f4b6                	sd	a3,104(sp)
ffffffffc0200e9c:	f8ba                	sd	a4,112(sp)
ffffffffc0200e9e:	fcbe                	sd	a5,120(sp)
ffffffffc0200ea0:	e142                	sd	a6,128(sp)
ffffffffc0200ea2:	e546                	sd	a7,136(sp)
ffffffffc0200ea4:	e94a                	sd	s2,144(sp)
ffffffffc0200ea6:	ed4e                	sd	s3,152(sp)
ffffffffc0200ea8:	f152                	sd	s4,160(sp)
ffffffffc0200eaa:	f556                	sd	s5,168(sp)
ffffffffc0200eac:	f95a                	sd	s6,176(sp)
ffffffffc0200eae:	fd5e                	sd	s7,184(sp)
ffffffffc0200eb0:	e1e2                	sd	s8,192(sp)
ffffffffc0200eb2:	e5e6                	sd	s9,200(sp)
ffffffffc0200eb4:	e9ea                	sd	s10,208(sp)
ffffffffc0200eb6:	edee                	sd	s11,216(sp)
ffffffffc0200eb8:	f1f2                	sd	t3,224(sp)
ffffffffc0200eba:	f5f6                	sd	t4,232(sp)
ffffffffc0200ebc:	f9fa                	sd	t5,240(sp)
ffffffffc0200ebe:	fdfe                	sd	t6,248(sp)
ffffffffc0200ec0:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0200ec4:	100024f3          	csrr	s1,sstatus
ffffffffc0200ec8:	14102973          	csrr	s2,sepc
ffffffffc0200ecc:	143029f3          	csrr	s3,stval
ffffffffc0200ed0:	14202a73          	csrr	s4,scause
ffffffffc0200ed4:	e822                	sd	s0,16(sp)
ffffffffc0200ed6:	e226                	sd	s1,256(sp)
ffffffffc0200ed8:	e64a                	sd	s2,264(sp)
ffffffffc0200eda:	ea4e                	sd	s3,272(sp)
ffffffffc0200edc:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200ede:	850a                	mv	a0,sp
    jal trap
ffffffffc0200ee0:	f0bff0ef          	jal	ra,ffffffffc0200dea <trap>

ffffffffc0200ee4 <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200ee4:	6492                	ld	s1,256(sp)
ffffffffc0200ee6:	6932                	ld	s2,264(sp)
ffffffffc0200ee8:	1004f413          	andi	s0,s1,256
ffffffffc0200eec:	e401                	bnez	s0,ffffffffc0200ef4 <__trapret+0x10>
ffffffffc0200eee:	1200                	addi	s0,sp,288
ffffffffc0200ef0:	14041073          	csrw	sscratch,s0
ffffffffc0200ef4:	10049073          	csrw	sstatus,s1
ffffffffc0200ef8:	14191073          	csrw	sepc,s2
ffffffffc0200efc:	60a2                	ld	ra,8(sp)
ffffffffc0200efe:	61e2                	ld	gp,24(sp)
ffffffffc0200f00:	7202                	ld	tp,32(sp)
ffffffffc0200f02:	72a2                	ld	t0,40(sp)
ffffffffc0200f04:	7342                	ld	t1,48(sp)
ffffffffc0200f06:	73e2                	ld	t2,56(sp)
ffffffffc0200f08:	6406                	ld	s0,64(sp)
ffffffffc0200f0a:	64a6                	ld	s1,72(sp)
ffffffffc0200f0c:	6546                	ld	a0,80(sp)
ffffffffc0200f0e:	65e6                	ld	a1,88(sp)
ffffffffc0200f10:	7606                	ld	a2,96(sp)
ffffffffc0200f12:	76a6                	ld	a3,104(sp)
ffffffffc0200f14:	7746                	ld	a4,112(sp)
ffffffffc0200f16:	77e6                	ld	a5,120(sp)
ffffffffc0200f18:	680a                	ld	a6,128(sp)
ffffffffc0200f1a:	68aa                	ld	a7,136(sp)
ffffffffc0200f1c:	694a                	ld	s2,144(sp)
ffffffffc0200f1e:	69ea                	ld	s3,152(sp)
ffffffffc0200f20:	7a0a                	ld	s4,160(sp)
ffffffffc0200f22:	7aaa                	ld	s5,168(sp)
ffffffffc0200f24:	7b4a                	ld	s6,176(sp)
ffffffffc0200f26:	7bea                	ld	s7,184(sp)
ffffffffc0200f28:	6c0e                	ld	s8,192(sp)
ffffffffc0200f2a:	6cae                	ld	s9,200(sp)
ffffffffc0200f2c:	6d4e                	ld	s10,208(sp)
ffffffffc0200f2e:	6dee                	ld	s11,216(sp)
ffffffffc0200f30:	7e0e                	ld	t3,224(sp)
ffffffffc0200f32:	7eae                	ld	t4,232(sp)
ffffffffc0200f34:	7f4e                	ld	t5,240(sp)
ffffffffc0200f36:	7fee                	ld	t6,248(sp)
ffffffffc0200f38:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
ffffffffc0200f3a:	10200073          	sret

ffffffffc0200f3e <forkrets>:
 
    .globl forkrets
forkrets:
    # set stack to this new process's trapframe
    move sp, a0
ffffffffc0200f3e:	812a                	mv	sp,a0
    j __trapret
ffffffffc0200f40:	b755                	j	ffffffffc0200ee4 <__trapret>

ffffffffc0200f42 <kernel_execve_ret>:

    .global kernel_execve_ret
kernel_execve_ret:
    // adjust sp to beneath kstacktop of current process
    addi a1, a1, -36*REGBYTES
ffffffffc0200f42:	ee058593          	addi	a1,a1,-288 # 1ee0 <_binary_obj___user_faultread_out_size-0x7cd8>

    // copy from previous trapframe to new trapframe
    LOAD s1, 35*REGBYTES(a0)
ffffffffc0200f46:	11853483          	ld	s1,280(a0)
    STORE s1, 35*REGBYTES(a1)
ffffffffc0200f4a:	1095bc23          	sd	s1,280(a1)
    LOAD s1, 34*REGBYTES(a0)
ffffffffc0200f4e:	11053483          	ld	s1,272(a0)
    STORE s1, 34*REGBYTES(a1)
ffffffffc0200f52:	1095b823          	sd	s1,272(a1)
    LOAD s1, 33*REGBYTES(a0)
ffffffffc0200f56:	10853483          	ld	s1,264(a0)
    STORE s1, 33*REGBYTES(a1)
ffffffffc0200f5a:	1095b423          	sd	s1,264(a1)
    LOAD s1, 32*REGBYTES(a0)
ffffffffc0200f5e:	10053483          	ld	s1,256(a0)
    STORE s1, 32*REGBYTES(a1)
ffffffffc0200f62:	1095b023          	sd	s1,256(a1)
    LOAD s1, 31*REGBYTES(a0)
ffffffffc0200f66:	7d64                	ld	s1,248(a0)
    STORE s1, 31*REGBYTES(a1)
ffffffffc0200f68:	fde4                	sd	s1,248(a1)
    LOAD s1, 30*REGBYTES(a0)
ffffffffc0200f6a:	7964                	ld	s1,240(a0)
    STORE s1, 30*REGBYTES(a1)
ffffffffc0200f6c:	f9e4                	sd	s1,240(a1)
    LOAD s1, 29*REGBYTES(a0)
ffffffffc0200f6e:	7564                	ld	s1,232(a0)
    STORE s1, 29*REGBYTES(a1)
ffffffffc0200f70:	f5e4                	sd	s1,232(a1)
    LOAD s1, 28*REGBYTES(a0)
ffffffffc0200f72:	7164                	ld	s1,224(a0)
    STORE s1, 28*REGBYTES(a1)
ffffffffc0200f74:	f1e4                	sd	s1,224(a1)
    LOAD s1, 27*REGBYTES(a0)
ffffffffc0200f76:	6d64                	ld	s1,216(a0)
    STORE s1, 27*REGBYTES(a1)
ffffffffc0200f78:	ede4                	sd	s1,216(a1)
    LOAD s1, 26*REGBYTES(a0)
ffffffffc0200f7a:	6964                	ld	s1,208(a0)
    STORE s1, 26*REGBYTES(a1)
ffffffffc0200f7c:	e9e4                	sd	s1,208(a1)
    LOAD s1, 25*REGBYTES(a0)
ffffffffc0200f7e:	6564                	ld	s1,200(a0)
    STORE s1, 25*REGBYTES(a1)
ffffffffc0200f80:	e5e4                	sd	s1,200(a1)
    LOAD s1, 24*REGBYTES(a0)
ffffffffc0200f82:	6164                	ld	s1,192(a0)
    STORE s1, 24*REGBYTES(a1)
ffffffffc0200f84:	e1e4                	sd	s1,192(a1)
    LOAD s1, 23*REGBYTES(a0)
ffffffffc0200f86:	7d44                	ld	s1,184(a0)
    STORE s1, 23*REGBYTES(a1)
ffffffffc0200f88:	fdc4                	sd	s1,184(a1)
    LOAD s1, 22*REGBYTES(a0)
ffffffffc0200f8a:	7944                	ld	s1,176(a0)
    STORE s1, 22*REGBYTES(a1)
ffffffffc0200f8c:	f9c4                	sd	s1,176(a1)
    LOAD s1, 21*REGBYTES(a0)
ffffffffc0200f8e:	7544                	ld	s1,168(a0)
    STORE s1, 21*REGBYTES(a1)
ffffffffc0200f90:	f5c4                	sd	s1,168(a1)
    LOAD s1, 20*REGBYTES(a0)
ffffffffc0200f92:	7144                	ld	s1,160(a0)
    STORE s1, 20*REGBYTES(a1)
ffffffffc0200f94:	f1c4                	sd	s1,160(a1)
    LOAD s1, 19*REGBYTES(a0)
ffffffffc0200f96:	6d44                	ld	s1,152(a0)
    STORE s1, 19*REGBYTES(a1)
ffffffffc0200f98:	edc4                	sd	s1,152(a1)
    LOAD s1, 18*REGBYTES(a0)
ffffffffc0200f9a:	6944                	ld	s1,144(a0)
    STORE s1, 18*REGBYTES(a1)
ffffffffc0200f9c:	e9c4                	sd	s1,144(a1)
    LOAD s1, 17*REGBYTES(a0)
ffffffffc0200f9e:	6544                	ld	s1,136(a0)
    STORE s1, 17*REGBYTES(a1)
ffffffffc0200fa0:	e5c4                	sd	s1,136(a1)
    LOAD s1, 16*REGBYTES(a0)
ffffffffc0200fa2:	6144                	ld	s1,128(a0)
    STORE s1, 16*REGBYTES(a1)
ffffffffc0200fa4:	e1c4                	sd	s1,128(a1)
    LOAD s1, 15*REGBYTES(a0)
ffffffffc0200fa6:	7d24                	ld	s1,120(a0)
    STORE s1, 15*REGBYTES(a1)
ffffffffc0200fa8:	fda4                	sd	s1,120(a1)
    LOAD s1, 14*REGBYTES(a0)
ffffffffc0200faa:	7924                	ld	s1,112(a0)
    STORE s1, 14*REGBYTES(a1)
ffffffffc0200fac:	f9a4                	sd	s1,112(a1)
    LOAD s1, 13*REGBYTES(a0)
ffffffffc0200fae:	7524                	ld	s1,104(a0)
    STORE s1, 13*REGBYTES(a1)
ffffffffc0200fb0:	f5a4                	sd	s1,104(a1)
    LOAD s1, 12*REGBYTES(a0)
ffffffffc0200fb2:	7124                	ld	s1,96(a0)
    STORE s1, 12*REGBYTES(a1)
ffffffffc0200fb4:	f1a4                	sd	s1,96(a1)
    LOAD s1, 11*REGBYTES(a0)
ffffffffc0200fb6:	6d24                	ld	s1,88(a0)
    STORE s1, 11*REGBYTES(a1)
ffffffffc0200fb8:	eda4                	sd	s1,88(a1)
    LOAD s1, 10*REGBYTES(a0)
ffffffffc0200fba:	6924                	ld	s1,80(a0)
    STORE s1, 10*REGBYTES(a1)
ffffffffc0200fbc:	e9a4                	sd	s1,80(a1)
    LOAD s1, 9*REGBYTES(a0)
ffffffffc0200fbe:	6524                	ld	s1,72(a0)
    STORE s1, 9*REGBYTES(a1)
ffffffffc0200fc0:	e5a4                	sd	s1,72(a1)
    LOAD s1, 8*REGBYTES(a0)
ffffffffc0200fc2:	6124                	ld	s1,64(a0)
    STORE s1, 8*REGBYTES(a1)
ffffffffc0200fc4:	e1a4                	sd	s1,64(a1)
    LOAD s1, 7*REGBYTES(a0)
ffffffffc0200fc6:	7d04                	ld	s1,56(a0)
    STORE s1, 7*REGBYTES(a1)
ffffffffc0200fc8:	fd84                	sd	s1,56(a1)
    LOAD s1, 6*REGBYTES(a0)
ffffffffc0200fca:	7904                	ld	s1,48(a0)
    STORE s1, 6*REGBYTES(a1)
ffffffffc0200fcc:	f984                	sd	s1,48(a1)
    LOAD s1, 5*REGBYTES(a0)
ffffffffc0200fce:	7504                	ld	s1,40(a0)
    STORE s1, 5*REGBYTES(a1)
ffffffffc0200fd0:	f584                	sd	s1,40(a1)
    LOAD s1, 4*REGBYTES(a0)
ffffffffc0200fd2:	7104                	ld	s1,32(a0)
    STORE s1, 4*REGBYTES(a1)
ffffffffc0200fd4:	f184                	sd	s1,32(a1)
    LOAD s1, 3*REGBYTES(a0)
ffffffffc0200fd6:	6d04                	ld	s1,24(a0)
    STORE s1, 3*REGBYTES(a1)
ffffffffc0200fd8:	ed84                	sd	s1,24(a1)
    LOAD s1, 2*REGBYTES(a0)
ffffffffc0200fda:	6904                	ld	s1,16(a0)
    STORE s1, 2*REGBYTES(a1)
ffffffffc0200fdc:	e984                	sd	s1,16(a1)
    LOAD s1, 1*REGBYTES(a0)
ffffffffc0200fde:	6504                	ld	s1,8(a0)
    STORE s1, 1*REGBYTES(a1)
ffffffffc0200fe0:	e584                	sd	s1,8(a1)
    LOAD s1, 0*REGBYTES(a0)
ffffffffc0200fe2:	6104                	ld	s1,0(a0)
    STORE s1, 0*REGBYTES(a1)
ffffffffc0200fe4:	e184                	sd	s1,0(a1)

    // acutually adjust sp
    move sp, a1
ffffffffc0200fe6:	812e                	mv	sp,a1
ffffffffc0200fe8:	bdf5                	j	ffffffffc0200ee4 <__trapret>

ffffffffc0200fea <default_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200fea:	000a5797          	auipc	a5,0xa5
ffffffffc0200fee:	79678793          	addi	a5,a5,1942 # ffffffffc02a6780 <free_area>
ffffffffc0200ff2:	e79c                	sd	a5,8(a5)
ffffffffc0200ff4:	e39c                	sd	a5,0(a5)

static void
default_init(void)
{
    list_init(&free_list);
    nr_free = 0;
ffffffffc0200ff6:	0007a823          	sw	zero,16(a5)
}
ffffffffc0200ffa:	8082                	ret

ffffffffc0200ffc <default_nr_free_pages>:

static size_t
default_nr_free_pages(void)
{
    return nr_free;
}
ffffffffc0200ffc:	000a5517          	auipc	a0,0xa5
ffffffffc0201000:	79456503          	lwu	a0,1940(a0) # ffffffffc02a6790 <free_area+0x10>
ffffffffc0201004:	8082                	ret

ffffffffc0201006 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1)
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void)
{
ffffffffc0201006:	715d                	addi	sp,sp,-80
ffffffffc0201008:	e0a2                	sd	s0,64(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc020100a:	000a5417          	auipc	s0,0xa5
ffffffffc020100e:	77640413          	addi	s0,s0,1910 # ffffffffc02a6780 <free_area>
ffffffffc0201012:	641c                	ld	a5,8(s0)
ffffffffc0201014:	e486                	sd	ra,72(sp)
ffffffffc0201016:	fc26                	sd	s1,56(sp)
ffffffffc0201018:	f84a                	sd	s2,48(sp)
ffffffffc020101a:	f44e                	sd	s3,40(sp)
ffffffffc020101c:	f052                	sd	s4,32(sp)
ffffffffc020101e:	ec56                	sd	s5,24(sp)
ffffffffc0201020:	e85a                	sd	s6,16(sp)
ffffffffc0201022:	e45e                	sd	s7,8(sp)
ffffffffc0201024:	e062                	sd	s8,0(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc0201026:	2a878d63          	beq	a5,s0,ffffffffc02012e0 <default_check+0x2da>
    int count = 0, total = 0;
ffffffffc020102a:	4481                	li	s1,0
ffffffffc020102c:	4901                	li	s2,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc020102e:	ff07b703          	ld	a4,-16(a5)
    {
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0201032:	8b09                	andi	a4,a4,2
ffffffffc0201034:	2a070a63          	beqz	a4,ffffffffc02012e8 <default_check+0x2e2>
        count++, total += p->property;
ffffffffc0201038:	ff87a703          	lw	a4,-8(a5)
ffffffffc020103c:	679c                	ld	a5,8(a5)
ffffffffc020103e:	2905                	addiw	s2,s2,1
ffffffffc0201040:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc0201042:	fe8796e3          	bne	a5,s0,ffffffffc020102e <default_check+0x28>
    }
    assert(total == nr_free_pages());
ffffffffc0201046:	89a6                	mv	s3,s1
ffffffffc0201048:	6df000ef          	jal	ra,ffffffffc0201f26 <nr_free_pages>
ffffffffc020104c:	6f351e63          	bne	a0,s3,ffffffffc0201748 <default_check+0x742>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201050:	4505                	li	a0,1
ffffffffc0201052:	657000ef          	jal	ra,ffffffffc0201ea8 <alloc_pages>
ffffffffc0201056:	8aaa                	mv	s5,a0
ffffffffc0201058:	42050863          	beqz	a0,ffffffffc0201488 <default_check+0x482>
    assert((p1 = alloc_page()) != NULL);
ffffffffc020105c:	4505                	li	a0,1
ffffffffc020105e:	64b000ef          	jal	ra,ffffffffc0201ea8 <alloc_pages>
ffffffffc0201062:	89aa                	mv	s3,a0
ffffffffc0201064:	70050263          	beqz	a0,ffffffffc0201768 <default_check+0x762>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201068:	4505                	li	a0,1
ffffffffc020106a:	63f000ef          	jal	ra,ffffffffc0201ea8 <alloc_pages>
ffffffffc020106e:	8a2a                	mv	s4,a0
ffffffffc0201070:	48050c63          	beqz	a0,ffffffffc0201508 <default_check+0x502>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0201074:	293a8a63          	beq	s5,s3,ffffffffc0201308 <default_check+0x302>
ffffffffc0201078:	28aa8863          	beq	s5,a0,ffffffffc0201308 <default_check+0x302>
ffffffffc020107c:	28a98663          	beq	s3,a0,ffffffffc0201308 <default_check+0x302>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0201080:	000aa783          	lw	a5,0(s5)
ffffffffc0201084:	2a079263          	bnez	a5,ffffffffc0201328 <default_check+0x322>
ffffffffc0201088:	0009a783          	lw	a5,0(s3)
ffffffffc020108c:	28079e63          	bnez	a5,ffffffffc0201328 <default_check+0x322>
ffffffffc0201090:	411c                	lw	a5,0(a0)
ffffffffc0201092:	28079b63          	bnez	a5,ffffffffc0201328 <default_check+0x322>
extern uint_t va_pa_offset;

static inline ppn_t
page2ppn(struct Page *page)
{
    return page - pages + nbase;
ffffffffc0201096:	000a9797          	auipc	a5,0xa9
ffffffffc020109a:	7627b783          	ld	a5,1890(a5) # ffffffffc02aa7f8 <pages>
ffffffffc020109e:	40fa8733          	sub	a4,s5,a5
ffffffffc02010a2:	00006617          	auipc	a2,0x6
ffffffffc02010a6:	7c663603          	ld	a2,1990(a2) # ffffffffc0207868 <nbase>
ffffffffc02010aa:	8719                	srai	a4,a4,0x6
ffffffffc02010ac:	9732                	add	a4,a4,a2
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc02010ae:	000a9697          	auipc	a3,0xa9
ffffffffc02010b2:	7426b683          	ld	a3,1858(a3) # ffffffffc02aa7f0 <npage>
ffffffffc02010b6:	06b2                	slli	a3,a3,0xc
}

static inline uintptr_t
page2pa(struct Page *page)
{
    return page2ppn(page) << PGSHIFT;
ffffffffc02010b8:	0732                	slli	a4,a4,0xc
ffffffffc02010ba:	28d77763          	bgeu	a4,a3,ffffffffc0201348 <default_check+0x342>
    return page - pages + nbase;
ffffffffc02010be:	40f98733          	sub	a4,s3,a5
ffffffffc02010c2:	8719                	srai	a4,a4,0x6
ffffffffc02010c4:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc02010c6:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc02010c8:	4cd77063          	bgeu	a4,a3,ffffffffc0201588 <default_check+0x582>
    return page - pages + nbase;
ffffffffc02010cc:	40f507b3          	sub	a5,a0,a5
ffffffffc02010d0:	8799                	srai	a5,a5,0x6
ffffffffc02010d2:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc02010d4:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc02010d6:	30d7f963          	bgeu	a5,a3,ffffffffc02013e8 <default_check+0x3e2>
    assert(alloc_page() == NULL);
ffffffffc02010da:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc02010dc:	00043c03          	ld	s8,0(s0)
ffffffffc02010e0:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
ffffffffc02010e4:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
ffffffffc02010e8:	e400                	sd	s0,8(s0)
ffffffffc02010ea:	e000                	sd	s0,0(s0)
    nr_free = 0;
ffffffffc02010ec:	000a5797          	auipc	a5,0xa5
ffffffffc02010f0:	6a07a223          	sw	zero,1700(a5) # ffffffffc02a6790 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc02010f4:	5b5000ef          	jal	ra,ffffffffc0201ea8 <alloc_pages>
ffffffffc02010f8:	2c051863          	bnez	a0,ffffffffc02013c8 <default_check+0x3c2>
    free_page(p0);
ffffffffc02010fc:	4585                	li	a1,1
ffffffffc02010fe:	8556                	mv	a0,s5
ffffffffc0201100:	5e7000ef          	jal	ra,ffffffffc0201ee6 <free_pages>
    free_page(p1);
ffffffffc0201104:	4585                	li	a1,1
ffffffffc0201106:	854e                	mv	a0,s3
ffffffffc0201108:	5df000ef          	jal	ra,ffffffffc0201ee6 <free_pages>
    free_page(p2);
ffffffffc020110c:	4585                	li	a1,1
ffffffffc020110e:	8552                	mv	a0,s4
ffffffffc0201110:	5d7000ef          	jal	ra,ffffffffc0201ee6 <free_pages>
    assert(nr_free == 3);
ffffffffc0201114:	4818                	lw	a4,16(s0)
ffffffffc0201116:	478d                	li	a5,3
ffffffffc0201118:	28f71863          	bne	a4,a5,ffffffffc02013a8 <default_check+0x3a2>
    assert((p0 = alloc_page()) != NULL);
ffffffffc020111c:	4505                	li	a0,1
ffffffffc020111e:	58b000ef          	jal	ra,ffffffffc0201ea8 <alloc_pages>
ffffffffc0201122:	89aa                	mv	s3,a0
ffffffffc0201124:	26050263          	beqz	a0,ffffffffc0201388 <default_check+0x382>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201128:	4505                	li	a0,1
ffffffffc020112a:	57f000ef          	jal	ra,ffffffffc0201ea8 <alloc_pages>
ffffffffc020112e:	8aaa                	mv	s5,a0
ffffffffc0201130:	3a050c63          	beqz	a0,ffffffffc02014e8 <default_check+0x4e2>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201134:	4505                	li	a0,1
ffffffffc0201136:	573000ef          	jal	ra,ffffffffc0201ea8 <alloc_pages>
ffffffffc020113a:	8a2a                	mv	s4,a0
ffffffffc020113c:	38050663          	beqz	a0,ffffffffc02014c8 <default_check+0x4c2>
    assert(alloc_page() == NULL);
ffffffffc0201140:	4505                	li	a0,1
ffffffffc0201142:	567000ef          	jal	ra,ffffffffc0201ea8 <alloc_pages>
ffffffffc0201146:	36051163          	bnez	a0,ffffffffc02014a8 <default_check+0x4a2>
    free_page(p0);
ffffffffc020114a:	4585                	li	a1,1
ffffffffc020114c:	854e                	mv	a0,s3
ffffffffc020114e:	599000ef          	jal	ra,ffffffffc0201ee6 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc0201152:	641c                	ld	a5,8(s0)
ffffffffc0201154:	20878a63          	beq	a5,s0,ffffffffc0201368 <default_check+0x362>
    assert((p = alloc_page()) == p0);
ffffffffc0201158:	4505                	li	a0,1
ffffffffc020115a:	54f000ef          	jal	ra,ffffffffc0201ea8 <alloc_pages>
ffffffffc020115e:	30a99563          	bne	s3,a0,ffffffffc0201468 <default_check+0x462>
    assert(alloc_page() == NULL);
ffffffffc0201162:	4505                	li	a0,1
ffffffffc0201164:	545000ef          	jal	ra,ffffffffc0201ea8 <alloc_pages>
ffffffffc0201168:	2e051063          	bnez	a0,ffffffffc0201448 <default_check+0x442>
    assert(nr_free == 0);
ffffffffc020116c:	481c                	lw	a5,16(s0)
ffffffffc020116e:	2a079d63          	bnez	a5,ffffffffc0201428 <default_check+0x422>
    free_page(p);
ffffffffc0201172:	854e                	mv	a0,s3
ffffffffc0201174:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc0201176:	01843023          	sd	s8,0(s0)
ffffffffc020117a:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
ffffffffc020117e:	01642823          	sw	s6,16(s0)
    free_page(p);
ffffffffc0201182:	565000ef          	jal	ra,ffffffffc0201ee6 <free_pages>
    free_page(p1);
ffffffffc0201186:	4585                	li	a1,1
ffffffffc0201188:	8556                	mv	a0,s5
ffffffffc020118a:	55d000ef          	jal	ra,ffffffffc0201ee6 <free_pages>
    free_page(p2);
ffffffffc020118e:	4585                	li	a1,1
ffffffffc0201190:	8552                	mv	a0,s4
ffffffffc0201192:	555000ef          	jal	ra,ffffffffc0201ee6 <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc0201196:	4515                	li	a0,5
ffffffffc0201198:	511000ef          	jal	ra,ffffffffc0201ea8 <alloc_pages>
ffffffffc020119c:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc020119e:	26050563          	beqz	a0,ffffffffc0201408 <default_check+0x402>
ffffffffc02011a2:	651c                	ld	a5,8(a0)
ffffffffc02011a4:	8385                	srli	a5,a5,0x1
ffffffffc02011a6:	8b85                	andi	a5,a5,1
    assert(!PageProperty(p0));
ffffffffc02011a8:	54079063          	bnez	a5,ffffffffc02016e8 <default_check+0x6e2>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc02011ac:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc02011ae:	00043b03          	ld	s6,0(s0)
ffffffffc02011b2:	00843a83          	ld	s5,8(s0)
ffffffffc02011b6:	e000                	sd	s0,0(s0)
ffffffffc02011b8:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
ffffffffc02011ba:	4ef000ef          	jal	ra,ffffffffc0201ea8 <alloc_pages>
ffffffffc02011be:	50051563          	bnez	a0,ffffffffc02016c8 <default_check+0x6c2>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc02011c2:	08098a13          	addi	s4,s3,128
ffffffffc02011c6:	8552                	mv	a0,s4
ffffffffc02011c8:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc02011ca:	01042b83          	lw	s7,16(s0)
    nr_free = 0;
ffffffffc02011ce:	000a5797          	auipc	a5,0xa5
ffffffffc02011d2:	5c07a123          	sw	zero,1474(a5) # ffffffffc02a6790 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc02011d6:	511000ef          	jal	ra,ffffffffc0201ee6 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc02011da:	4511                	li	a0,4
ffffffffc02011dc:	4cd000ef          	jal	ra,ffffffffc0201ea8 <alloc_pages>
ffffffffc02011e0:	4c051463          	bnez	a0,ffffffffc02016a8 <default_check+0x6a2>
ffffffffc02011e4:	0889b783          	ld	a5,136(s3)
ffffffffc02011e8:	8385                	srli	a5,a5,0x1
ffffffffc02011ea:	8b85                	andi	a5,a5,1
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc02011ec:	48078e63          	beqz	a5,ffffffffc0201688 <default_check+0x682>
ffffffffc02011f0:	0909a703          	lw	a4,144(s3)
ffffffffc02011f4:	478d                	li	a5,3
ffffffffc02011f6:	48f71963          	bne	a4,a5,ffffffffc0201688 <default_check+0x682>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc02011fa:	450d                	li	a0,3
ffffffffc02011fc:	4ad000ef          	jal	ra,ffffffffc0201ea8 <alloc_pages>
ffffffffc0201200:	8c2a                	mv	s8,a0
ffffffffc0201202:	46050363          	beqz	a0,ffffffffc0201668 <default_check+0x662>
    assert(alloc_page() == NULL);
ffffffffc0201206:	4505                	li	a0,1
ffffffffc0201208:	4a1000ef          	jal	ra,ffffffffc0201ea8 <alloc_pages>
ffffffffc020120c:	42051e63          	bnez	a0,ffffffffc0201648 <default_check+0x642>
    assert(p0 + 2 == p1);
ffffffffc0201210:	418a1c63          	bne	s4,s8,ffffffffc0201628 <default_check+0x622>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc0201214:	4585                	li	a1,1
ffffffffc0201216:	854e                	mv	a0,s3
ffffffffc0201218:	4cf000ef          	jal	ra,ffffffffc0201ee6 <free_pages>
    free_pages(p1, 3);
ffffffffc020121c:	458d                	li	a1,3
ffffffffc020121e:	8552                	mv	a0,s4
ffffffffc0201220:	4c7000ef          	jal	ra,ffffffffc0201ee6 <free_pages>
ffffffffc0201224:	0089b783          	ld	a5,8(s3)
    p2 = p0 + 1;
ffffffffc0201228:	04098c13          	addi	s8,s3,64
ffffffffc020122c:	8385                	srli	a5,a5,0x1
ffffffffc020122e:	8b85                	andi	a5,a5,1
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0201230:	3c078c63          	beqz	a5,ffffffffc0201608 <default_check+0x602>
ffffffffc0201234:	0109a703          	lw	a4,16(s3)
ffffffffc0201238:	4785                	li	a5,1
ffffffffc020123a:	3cf71763          	bne	a4,a5,ffffffffc0201608 <default_check+0x602>
ffffffffc020123e:	008a3783          	ld	a5,8(s4)
ffffffffc0201242:	8385                	srli	a5,a5,0x1
ffffffffc0201244:	8b85                	andi	a5,a5,1
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0201246:	3a078163          	beqz	a5,ffffffffc02015e8 <default_check+0x5e2>
ffffffffc020124a:	010a2703          	lw	a4,16(s4)
ffffffffc020124e:	478d                	li	a5,3
ffffffffc0201250:	38f71c63          	bne	a4,a5,ffffffffc02015e8 <default_check+0x5e2>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201254:	4505                	li	a0,1
ffffffffc0201256:	453000ef          	jal	ra,ffffffffc0201ea8 <alloc_pages>
ffffffffc020125a:	36a99763          	bne	s3,a0,ffffffffc02015c8 <default_check+0x5c2>
    free_page(p0);
ffffffffc020125e:	4585                	li	a1,1
ffffffffc0201260:	487000ef          	jal	ra,ffffffffc0201ee6 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201264:	4509                	li	a0,2
ffffffffc0201266:	443000ef          	jal	ra,ffffffffc0201ea8 <alloc_pages>
ffffffffc020126a:	32aa1f63          	bne	s4,a0,ffffffffc02015a8 <default_check+0x5a2>

    free_pages(p0, 2);
ffffffffc020126e:	4589                	li	a1,2
ffffffffc0201270:	477000ef          	jal	ra,ffffffffc0201ee6 <free_pages>
    free_page(p2);
ffffffffc0201274:	4585                	li	a1,1
ffffffffc0201276:	8562                	mv	a0,s8
ffffffffc0201278:	46f000ef          	jal	ra,ffffffffc0201ee6 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc020127c:	4515                	li	a0,5
ffffffffc020127e:	42b000ef          	jal	ra,ffffffffc0201ea8 <alloc_pages>
ffffffffc0201282:	89aa                	mv	s3,a0
ffffffffc0201284:	48050263          	beqz	a0,ffffffffc0201708 <default_check+0x702>
    assert(alloc_page() == NULL);
ffffffffc0201288:	4505                	li	a0,1
ffffffffc020128a:	41f000ef          	jal	ra,ffffffffc0201ea8 <alloc_pages>
ffffffffc020128e:	2c051d63          	bnez	a0,ffffffffc0201568 <default_check+0x562>

    assert(nr_free == 0);
ffffffffc0201292:	481c                	lw	a5,16(s0)
ffffffffc0201294:	2a079a63          	bnez	a5,ffffffffc0201548 <default_check+0x542>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc0201298:	4595                	li	a1,5
ffffffffc020129a:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc020129c:	01742823          	sw	s7,16(s0)
    free_list = free_list_store;
ffffffffc02012a0:	01643023          	sd	s6,0(s0)
ffffffffc02012a4:	01543423          	sd	s5,8(s0)
    free_pages(p0, 5);
ffffffffc02012a8:	43f000ef          	jal	ra,ffffffffc0201ee6 <free_pages>
    return listelm->next;
ffffffffc02012ac:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc02012ae:	00878963          	beq	a5,s0,ffffffffc02012c0 <default_check+0x2ba>
    {
        struct Page *p = le2page(le, page_link);
        count--, total -= p->property;
ffffffffc02012b2:	ff87a703          	lw	a4,-8(a5)
ffffffffc02012b6:	679c                	ld	a5,8(a5)
ffffffffc02012b8:	397d                	addiw	s2,s2,-1
ffffffffc02012ba:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc02012bc:	fe879be3          	bne	a5,s0,ffffffffc02012b2 <default_check+0x2ac>
    }
    assert(count == 0);
ffffffffc02012c0:	26091463          	bnez	s2,ffffffffc0201528 <default_check+0x522>
    assert(total == 0);
ffffffffc02012c4:	46049263          	bnez	s1,ffffffffc0201728 <default_check+0x722>
}
ffffffffc02012c8:	60a6                	ld	ra,72(sp)
ffffffffc02012ca:	6406                	ld	s0,64(sp)
ffffffffc02012cc:	74e2                	ld	s1,56(sp)
ffffffffc02012ce:	7942                	ld	s2,48(sp)
ffffffffc02012d0:	79a2                	ld	s3,40(sp)
ffffffffc02012d2:	7a02                	ld	s4,32(sp)
ffffffffc02012d4:	6ae2                	ld	s5,24(sp)
ffffffffc02012d6:	6b42                	ld	s6,16(sp)
ffffffffc02012d8:	6ba2                	ld	s7,8(sp)
ffffffffc02012da:	6c02                	ld	s8,0(sp)
ffffffffc02012dc:	6161                	addi	sp,sp,80
ffffffffc02012de:	8082                	ret
    while ((le = list_next(le)) != &free_list)
ffffffffc02012e0:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc02012e2:	4481                	li	s1,0
ffffffffc02012e4:	4901                	li	s2,0
ffffffffc02012e6:	b38d                	j	ffffffffc0201048 <default_check+0x42>
        assert(PageProperty(p));
ffffffffc02012e8:	00005697          	auipc	a3,0x5
ffffffffc02012ec:	e9868693          	addi	a3,a3,-360 # ffffffffc0206180 <commands+0x818>
ffffffffc02012f0:	00005617          	auipc	a2,0x5
ffffffffc02012f4:	ea060613          	addi	a2,a2,-352 # ffffffffc0206190 <commands+0x828>
ffffffffc02012f8:	11000593          	li	a1,272
ffffffffc02012fc:	00005517          	auipc	a0,0x5
ffffffffc0201300:	eac50513          	addi	a0,a0,-340 # ffffffffc02061a8 <commands+0x840>
ffffffffc0201304:	98aff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0201308:	00005697          	auipc	a3,0x5
ffffffffc020130c:	f3868693          	addi	a3,a3,-200 # ffffffffc0206240 <commands+0x8d8>
ffffffffc0201310:	00005617          	auipc	a2,0x5
ffffffffc0201314:	e8060613          	addi	a2,a2,-384 # ffffffffc0206190 <commands+0x828>
ffffffffc0201318:	0db00593          	li	a1,219
ffffffffc020131c:	00005517          	auipc	a0,0x5
ffffffffc0201320:	e8c50513          	addi	a0,a0,-372 # ffffffffc02061a8 <commands+0x840>
ffffffffc0201324:	96aff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0201328:	00005697          	auipc	a3,0x5
ffffffffc020132c:	f4068693          	addi	a3,a3,-192 # ffffffffc0206268 <commands+0x900>
ffffffffc0201330:	00005617          	auipc	a2,0x5
ffffffffc0201334:	e6060613          	addi	a2,a2,-416 # ffffffffc0206190 <commands+0x828>
ffffffffc0201338:	0dc00593          	li	a1,220
ffffffffc020133c:	00005517          	auipc	a0,0x5
ffffffffc0201340:	e6c50513          	addi	a0,a0,-404 # ffffffffc02061a8 <commands+0x840>
ffffffffc0201344:	94aff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0201348:	00005697          	auipc	a3,0x5
ffffffffc020134c:	f6068693          	addi	a3,a3,-160 # ffffffffc02062a8 <commands+0x940>
ffffffffc0201350:	00005617          	auipc	a2,0x5
ffffffffc0201354:	e4060613          	addi	a2,a2,-448 # ffffffffc0206190 <commands+0x828>
ffffffffc0201358:	0de00593          	li	a1,222
ffffffffc020135c:	00005517          	auipc	a0,0x5
ffffffffc0201360:	e4c50513          	addi	a0,a0,-436 # ffffffffc02061a8 <commands+0x840>
ffffffffc0201364:	92aff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(!list_empty(&free_list));
ffffffffc0201368:	00005697          	auipc	a3,0x5
ffffffffc020136c:	fc868693          	addi	a3,a3,-56 # ffffffffc0206330 <commands+0x9c8>
ffffffffc0201370:	00005617          	auipc	a2,0x5
ffffffffc0201374:	e2060613          	addi	a2,a2,-480 # ffffffffc0206190 <commands+0x828>
ffffffffc0201378:	0f700593          	li	a1,247
ffffffffc020137c:	00005517          	auipc	a0,0x5
ffffffffc0201380:	e2c50513          	addi	a0,a0,-468 # ffffffffc02061a8 <commands+0x840>
ffffffffc0201384:	90aff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201388:	00005697          	auipc	a3,0x5
ffffffffc020138c:	e5868693          	addi	a3,a3,-424 # ffffffffc02061e0 <commands+0x878>
ffffffffc0201390:	00005617          	auipc	a2,0x5
ffffffffc0201394:	e0060613          	addi	a2,a2,-512 # ffffffffc0206190 <commands+0x828>
ffffffffc0201398:	0f000593          	li	a1,240
ffffffffc020139c:	00005517          	auipc	a0,0x5
ffffffffc02013a0:	e0c50513          	addi	a0,a0,-500 # ffffffffc02061a8 <commands+0x840>
ffffffffc02013a4:	8eaff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free == 3);
ffffffffc02013a8:	00005697          	auipc	a3,0x5
ffffffffc02013ac:	f7868693          	addi	a3,a3,-136 # ffffffffc0206320 <commands+0x9b8>
ffffffffc02013b0:	00005617          	auipc	a2,0x5
ffffffffc02013b4:	de060613          	addi	a2,a2,-544 # ffffffffc0206190 <commands+0x828>
ffffffffc02013b8:	0ee00593          	li	a1,238
ffffffffc02013bc:	00005517          	auipc	a0,0x5
ffffffffc02013c0:	dec50513          	addi	a0,a0,-532 # ffffffffc02061a8 <commands+0x840>
ffffffffc02013c4:	8caff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc02013c8:	00005697          	auipc	a3,0x5
ffffffffc02013cc:	f4068693          	addi	a3,a3,-192 # ffffffffc0206308 <commands+0x9a0>
ffffffffc02013d0:	00005617          	auipc	a2,0x5
ffffffffc02013d4:	dc060613          	addi	a2,a2,-576 # ffffffffc0206190 <commands+0x828>
ffffffffc02013d8:	0e900593          	li	a1,233
ffffffffc02013dc:	00005517          	auipc	a0,0x5
ffffffffc02013e0:	dcc50513          	addi	a0,a0,-564 # ffffffffc02061a8 <commands+0x840>
ffffffffc02013e4:	8aaff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc02013e8:	00005697          	auipc	a3,0x5
ffffffffc02013ec:	f0068693          	addi	a3,a3,-256 # ffffffffc02062e8 <commands+0x980>
ffffffffc02013f0:	00005617          	auipc	a2,0x5
ffffffffc02013f4:	da060613          	addi	a2,a2,-608 # ffffffffc0206190 <commands+0x828>
ffffffffc02013f8:	0e000593          	li	a1,224
ffffffffc02013fc:	00005517          	auipc	a0,0x5
ffffffffc0201400:	dac50513          	addi	a0,a0,-596 # ffffffffc02061a8 <commands+0x840>
ffffffffc0201404:	88aff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(p0 != NULL);
ffffffffc0201408:	00005697          	auipc	a3,0x5
ffffffffc020140c:	f7068693          	addi	a3,a3,-144 # ffffffffc0206378 <commands+0xa10>
ffffffffc0201410:	00005617          	auipc	a2,0x5
ffffffffc0201414:	d8060613          	addi	a2,a2,-640 # ffffffffc0206190 <commands+0x828>
ffffffffc0201418:	11800593          	li	a1,280
ffffffffc020141c:	00005517          	auipc	a0,0x5
ffffffffc0201420:	d8c50513          	addi	a0,a0,-628 # ffffffffc02061a8 <commands+0x840>
ffffffffc0201424:	86aff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free == 0);
ffffffffc0201428:	00005697          	auipc	a3,0x5
ffffffffc020142c:	f4068693          	addi	a3,a3,-192 # ffffffffc0206368 <commands+0xa00>
ffffffffc0201430:	00005617          	auipc	a2,0x5
ffffffffc0201434:	d6060613          	addi	a2,a2,-672 # ffffffffc0206190 <commands+0x828>
ffffffffc0201438:	0fd00593          	li	a1,253
ffffffffc020143c:	00005517          	auipc	a0,0x5
ffffffffc0201440:	d6c50513          	addi	a0,a0,-660 # ffffffffc02061a8 <commands+0x840>
ffffffffc0201444:	84aff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201448:	00005697          	auipc	a3,0x5
ffffffffc020144c:	ec068693          	addi	a3,a3,-320 # ffffffffc0206308 <commands+0x9a0>
ffffffffc0201450:	00005617          	auipc	a2,0x5
ffffffffc0201454:	d4060613          	addi	a2,a2,-704 # ffffffffc0206190 <commands+0x828>
ffffffffc0201458:	0fb00593          	li	a1,251
ffffffffc020145c:	00005517          	auipc	a0,0x5
ffffffffc0201460:	d4c50513          	addi	a0,a0,-692 # ffffffffc02061a8 <commands+0x840>
ffffffffc0201464:	82aff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc0201468:	00005697          	auipc	a3,0x5
ffffffffc020146c:	ee068693          	addi	a3,a3,-288 # ffffffffc0206348 <commands+0x9e0>
ffffffffc0201470:	00005617          	auipc	a2,0x5
ffffffffc0201474:	d2060613          	addi	a2,a2,-736 # ffffffffc0206190 <commands+0x828>
ffffffffc0201478:	0fa00593          	li	a1,250
ffffffffc020147c:	00005517          	auipc	a0,0x5
ffffffffc0201480:	d2c50513          	addi	a0,a0,-724 # ffffffffc02061a8 <commands+0x840>
ffffffffc0201484:	80aff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201488:	00005697          	auipc	a3,0x5
ffffffffc020148c:	d5868693          	addi	a3,a3,-680 # ffffffffc02061e0 <commands+0x878>
ffffffffc0201490:	00005617          	auipc	a2,0x5
ffffffffc0201494:	d0060613          	addi	a2,a2,-768 # ffffffffc0206190 <commands+0x828>
ffffffffc0201498:	0d700593          	li	a1,215
ffffffffc020149c:	00005517          	auipc	a0,0x5
ffffffffc02014a0:	d0c50513          	addi	a0,a0,-756 # ffffffffc02061a8 <commands+0x840>
ffffffffc02014a4:	febfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc02014a8:	00005697          	auipc	a3,0x5
ffffffffc02014ac:	e6068693          	addi	a3,a3,-416 # ffffffffc0206308 <commands+0x9a0>
ffffffffc02014b0:	00005617          	auipc	a2,0x5
ffffffffc02014b4:	ce060613          	addi	a2,a2,-800 # ffffffffc0206190 <commands+0x828>
ffffffffc02014b8:	0f400593          	li	a1,244
ffffffffc02014bc:	00005517          	auipc	a0,0x5
ffffffffc02014c0:	cec50513          	addi	a0,a0,-788 # ffffffffc02061a8 <commands+0x840>
ffffffffc02014c4:	fcbfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02014c8:	00005697          	auipc	a3,0x5
ffffffffc02014cc:	d5868693          	addi	a3,a3,-680 # ffffffffc0206220 <commands+0x8b8>
ffffffffc02014d0:	00005617          	auipc	a2,0x5
ffffffffc02014d4:	cc060613          	addi	a2,a2,-832 # ffffffffc0206190 <commands+0x828>
ffffffffc02014d8:	0f200593          	li	a1,242
ffffffffc02014dc:	00005517          	auipc	a0,0x5
ffffffffc02014e0:	ccc50513          	addi	a0,a0,-820 # ffffffffc02061a8 <commands+0x840>
ffffffffc02014e4:	fabfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02014e8:	00005697          	auipc	a3,0x5
ffffffffc02014ec:	d1868693          	addi	a3,a3,-744 # ffffffffc0206200 <commands+0x898>
ffffffffc02014f0:	00005617          	auipc	a2,0x5
ffffffffc02014f4:	ca060613          	addi	a2,a2,-864 # ffffffffc0206190 <commands+0x828>
ffffffffc02014f8:	0f100593          	li	a1,241
ffffffffc02014fc:	00005517          	auipc	a0,0x5
ffffffffc0201500:	cac50513          	addi	a0,a0,-852 # ffffffffc02061a8 <commands+0x840>
ffffffffc0201504:	f8bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201508:	00005697          	auipc	a3,0x5
ffffffffc020150c:	d1868693          	addi	a3,a3,-744 # ffffffffc0206220 <commands+0x8b8>
ffffffffc0201510:	00005617          	auipc	a2,0x5
ffffffffc0201514:	c8060613          	addi	a2,a2,-896 # ffffffffc0206190 <commands+0x828>
ffffffffc0201518:	0d900593          	li	a1,217
ffffffffc020151c:	00005517          	auipc	a0,0x5
ffffffffc0201520:	c8c50513          	addi	a0,a0,-884 # ffffffffc02061a8 <commands+0x840>
ffffffffc0201524:	f6bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(count == 0);
ffffffffc0201528:	00005697          	auipc	a3,0x5
ffffffffc020152c:	fa068693          	addi	a3,a3,-96 # ffffffffc02064c8 <commands+0xb60>
ffffffffc0201530:	00005617          	auipc	a2,0x5
ffffffffc0201534:	c6060613          	addi	a2,a2,-928 # ffffffffc0206190 <commands+0x828>
ffffffffc0201538:	14600593          	li	a1,326
ffffffffc020153c:	00005517          	auipc	a0,0x5
ffffffffc0201540:	c6c50513          	addi	a0,a0,-916 # ffffffffc02061a8 <commands+0x840>
ffffffffc0201544:	f4bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free == 0);
ffffffffc0201548:	00005697          	auipc	a3,0x5
ffffffffc020154c:	e2068693          	addi	a3,a3,-480 # ffffffffc0206368 <commands+0xa00>
ffffffffc0201550:	00005617          	auipc	a2,0x5
ffffffffc0201554:	c4060613          	addi	a2,a2,-960 # ffffffffc0206190 <commands+0x828>
ffffffffc0201558:	13a00593          	li	a1,314
ffffffffc020155c:	00005517          	auipc	a0,0x5
ffffffffc0201560:	c4c50513          	addi	a0,a0,-948 # ffffffffc02061a8 <commands+0x840>
ffffffffc0201564:	f2bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201568:	00005697          	auipc	a3,0x5
ffffffffc020156c:	da068693          	addi	a3,a3,-608 # ffffffffc0206308 <commands+0x9a0>
ffffffffc0201570:	00005617          	auipc	a2,0x5
ffffffffc0201574:	c2060613          	addi	a2,a2,-992 # ffffffffc0206190 <commands+0x828>
ffffffffc0201578:	13800593          	li	a1,312
ffffffffc020157c:	00005517          	auipc	a0,0x5
ffffffffc0201580:	c2c50513          	addi	a0,a0,-980 # ffffffffc02061a8 <commands+0x840>
ffffffffc0201584:	f0bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201588:	00005697          	auipc	a3,0x5
ffffffffc020158c:	d4068693          	addi	a3,a3,-704 # ffffffffc02062c8 <commands+0x960>
ffffffffc0201590:	00005617          	auipc	a2,0x5
ffffffffc0201594:	c0060613          	addi	a2,a2,-1024 # ffffffffc0206190 <commands+0x828>
ffffffffc0201598:	0df00593          	li	a1,223
ffffffffc020159c:	00005517          	auipc	a0,0x5
ffffffffc02015a0:	c0c50513          	addi	a0,a0,-1012 # ffffffffc02061a8 <commands+0x840>
ffffffffc02015a4:	eebfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc02015a8:	00005697          	auipc	a3,0x5
ffffffffc02015ac:	ee068693          	addi	a3,a3,-288 # ffffffffc0206488 <commands+0xb20>
ffffffffc02015b0:	00005617          	auipc	a2,0x5
ffffffffc02015b4:	be060613          	addi	a2,a2,-1056 # ffffffffc0206190 <commands+0x828>
ffffffffc02015b8:	13200593          	li	a1,306
ffffffffc02015bc:	00005517          	auipc	a0,0x5
ffffffffc02015c0:	bec50513          	addi	a0,a0,-1044 # ffffffffc02061a8 <commands+0x840>
ffffffffc02015c4:	ecbfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc02015c8:	00005697          	auipc	a3,0x5
ffffffffc02015cc:	ea068693          	addi	a3,a3,-352 # ffffffffc0206468 <commands+0xb00>
ffffffffc02015d0:	00005617          	auipc	a2,0x5
ffffffffc02015d4:	bc060613          	addi	a2,a2,-1088 # ffffffffc0206190 <commands+0x828>
ffffffffc02015d8:	13000593          	li	a1,304
ffffffffc02015dc:	00005517          	auipc	a0,0x5
ffffffffc02015e0:	bcc50513          	addi	a0,a0,-1076 # ffffffffc02061a8 <commands+0x840>
ffffffffc02015e4:	eabfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc02015e8:	00005697          	auipc	a3,0x5
ffffffffc02015ec:	e5868693          	addi	a3,a3,-424 # ffffffffc0206440 <commands+0xad8>
ffffffffc02015f0:	00005617          	auipc	a2,0x5
ffffffffc02015f4:	ba060613          	addi	a2,a2,-1120 # ffffffffc0206190 <commands+0x828>
ffffffffc02015f8:	12e00593          	li	a1,302
ffffffffc02015fc:	00005517          	auipc	a0,0x5
ffffffffc0201600:	bac50513          	addi	a0,a0,-1108 # ffffffffc02061a8 <commands+0x840>
ffffffffc0201604:	e8bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0201608:	00005697          	auipc	a3,0x5
ffffffffc020160c:	e1068693          	addi	a3,a3,-496 # ffffffffc0206418 <commands+0xab0>
ffffffffc0201610:	00005617          	auipc	a2,0x5
ffffffffc0201614:	b8060613          	addi	a2,a2,-1152 # ffffffffc0206190 <commands+0x828>
ffffffffc0201618:	12d00593          	li	a1,301
ffffffffc020161c:	00005517          	auipc	a0,0x5
ffffffffc0201620:	b8c50513          	addi	a0,a0,-1140 # ffffffffc02061a8 <commands+0x840>
ffffffffc0201624:	e6bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(p0 + 2 == p1);
ffffffffc0201628:	00005697          	auipc	a3,0x5
ffffffffc020162c:	de068693          	addi	a3,a3,-544 # ffffffffc0206408 <commands+0xaa0>
ffffffffc0201630:	00005617          	auipc	a2,0x5
ffffffffc0201634:	b6060613          	addi	a2,a2,-1184 # ffffffffc0206190 <commands+0x828>
ffffffffc0201638:	12800593          	li	a1,296
ffffffffc020163c:	00005517          	auipc	a0,0x5
ffffffffc0201640:	b6c50513          	addi	a0,a0,-1172 # ffffffffc02061a8 <commands+0x840>
ffffffffc0201644:	e4bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201648:	00005697          	auipc	a3,0x5
ffffffffc020164c:	cc068693          	addi	a3,a3,-832 # ffffffffc0206308 <commands+0x9a0>
ffffffffc0201650:	00005617          	auipc	a2,0x5
ffffffffc0201654:	b4060613          	addi	a2,a2,-1216 # ffffffffc0206190 <commands+0x828>
ffffffffc0201658:	12700593          	li	a1,295
ffffffffc020165c:	00005517          	auipc	a0,0x5
ffffffffc0201660:	b4c50513          	addi	a0,a0,-1204 # ffffffffc02061a8 <commands+0x840>
ffffffffc0201664:	e2bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0201668:	00005697          	auipc	a3,0x5
ffffffffc020166c:	d8068693          	addi	a3,a3,-640 # ffffffffc02063e8 <commands+0xa80>
ffffffffc0201670:	00005617          	auipc	a2,0x5
ffffffffc0201674:	b2060613          	addi	a2,a2,-1248 # ffffffffc0206190 <commands+0x828>
ffffffffc0201678:	12600593          	li	a1,294
ffffffffc020167c:	00005517          	auipc	a0,0x5
ffffffffc0201680:	b2c50513          	addi	a0,a0,-1236 # ffffffffc02061a8 <commands+0x840>
ffffffffc0201684:	e0bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201688:	00005697          	auipc	a3,0x5
ffffffffc020168c:	d3068693          	addi	a3,a3,-720 # ffffffffc02063b8 <commands+0xa50>
ffffffffc0201690:	00005617          	auipc	a2,0x5
ffffffffc0201694:	b0060613          	addi	a2,a2,-1280 # ffffffffc0206190 <commands+0x828>
ffffffffc0201698:	12500593          	li	a1,293
ffffffffc020169c:	00005517          	auipc	a0,0x5
ffffffffc02016a0:	b0c50513          	addi	a0,a0,-1268 # ffffffffc02061a8 <commands+0x840>
ffffffffc02016a4:	debfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc02016a8:	00005697          	auipc	a3,0x5
ffffffffc02016ac:	cf868693          	addi	a3,a3,-776 # ffffffffc02063a0 <commands+0xa38>
ffffffffc02016b0:	00005617          	auipc	a2,0x5
ffffffffc02016b4:	ae060613          	addi	a2,a2,-1312 # ffffffffc0206190 <commands+0x828>
ffffffffc02016b8:	12400593          	li	a1,292
ffffffffc02016bc:	00005517          	auipc	a0,0x5
ffffffffc02016c0:	aec50513          	addi	a0,a0,-1300 # ffffffffc02061a8 <commands+0x840>
ffffffffc02016c4:	dcbfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc02016c8:	00005697          	auipc	a3,0x5
ffffffffc02016cc:	c4068693          	addi	a3,a3,-960 # ffffffffc0206308 <commands+0x9a0>
ffffffffc02016d0:	00005617          	auipc	a2,0x5
ffffffffc02016d4:	ac060613          	addi	a2,a2,-1344 # ffffffffc0206190 <commands+0x828>
ffffffffc02016d8:	11e00593          	li	a1,286
ffffffffc02016dc:	00005517          	auipc	a0,0x5
ffffffffc02016e0:	acc50513          	addi	a0,a0,-1332 # ffffffffc02061a8 <commands+0x840>
ffffffffc02016e4:	dabfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(!PageProperty(p0));
ffffffffc02016e8:	00005697          	auipc	a3,0x5
ffffffffc02016ec:	ca068693          	addi	a3,a3,-864 # ffffffffc0206388 <commands+0xa20>
ffffffffc02016f0:	00005617          	auipc	a2,0x5
ffffffffc02016f4:	aa060613          	addi	a2,a2,-1376 # ffffffffc0206190 <commands+0x828>
ffffffffc02016f8:	11900593          	li	a1,281
ffffffffc02016fc:	00005517          	auipc	a0,0x5
ffffffffc0201700:	aac50513          	addi	a0,a0,-1364 # ffffffffc02061a8 <commands+0x840>
ffffffffc0201704:	d8bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0201708:	00005697          	auipc	a3,0x5
ffffffffc020170c:	da068693          	addi	a3,a3,-608 # ffffffffc02064a8 <commands+0xb40>
ffffffffc0201710:	00005617          	auipc	a2,0x5
ffffffffc0201714:	a8060613          	addi	a2,a2,-1408 # ffffffffc0206190 <commands+0x828>
ffffffffc0201718:	13700593          	li	a1,311
ffffffffc020171c:	00005517          	auipc	a0,0x5
ffffffffc0201720:	a8c50513          	addi	a0,a0,-1396 # ffffffffc02061a8 <commands+0x840>
ffffffffc0201724:	d6bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(total == 0);
ffffffffc0201728:	00005697          	auipc	a3,0x5
ffffffffc020172c:	db068693          	addi	a3,a3,-592 # ffffffffc02064d8 <commands+0xb70>
ffffffffc0201730:	00005617          	auipc	a2,0x5
ffffffffc0201734:	a6060613          	addi	a2,a2,-1440 # ffffffffc0206190 <commands+0x828>
ffffffffc0201738:	14700593          	li	a1,327
ffffffffc020173c:	00005517          	auipc	a0,0x5
ffffffffc0201740:	a6c50513          	addi	a0,a0,-1428 # ffffffffc02061a8 <commands+0x840>
ffffffffc0201744:	d4bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(total == nr_free_pages());
ffffffffc0201748:	00005697          	auipc	a3,0x5
ffffffffc020174c:	a7868693          	addi	a3,a3,-1416 # ffffffffc02061c0 <commands+0x858>
ffffffffc0201750:	00005617          	auipc	a2,0x5
ffffffffc0201754:	a4060613          	addi	a2,a2,-1472 # ffffffffc0206190 <commands+0x828>
ffffffffc0201758:	11300593          	li	a1,275
ffffffffc020175c:	00005517          	auipc	a0,0x5
ffffffffc0201760:	a4c50513          	addi	a0,a0,-1460 # ffffffffc02061a8 <commands+0x840>
ffffffffc0201764:	d2bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201768:	00005697          	auipc	a3,0x5
ffffffffc020176c:	a9868693          	addi	a3,a3,-1384 # ffffffffc0206200 <commands+0x898>
ffffffffc0201770:	00005617          	auipc	a2,0x5
ffffffffc0201774:	a2060613          	addi	a2,a2,-1504 # ffffffffc0206190 <commands+0x828>
ffffffffc0201778:	0d800593          	li	a1,216
ffffffffc020177c:	00005517          	auipc	a0,0x5
ffffffffc0201780:	a2c50513          	addi	a0,a0,-1492 # ffffffffc02061a8 <commands+0x840>
ffffffffc0201784:	d0bfe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201788 <default_free_pages>:
{
ffffffffc0201788:	1141                	addi	sp,sp,-16
ffffffffc020178a:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc020178c:	14058463          	beqz	a1,ffffffffc02018d4 <default_free_pages+0x14c>
    for (; p != base + n; p++)
ffffffffc0201790:	00659693          	slli	a3,a1,0x6
ffffffffc0201794:	96aa                	add	a3,a3,a0
ffffffffc0201796:	87aa                	mv	a5,a0
ffffffffc0201798:	02d50263          	beq	a0,a3,ffffffffc02017bc <default_free_pages+0x34>
ffffffffc020179c:	6798                	ld	a4,8(a5)
ffffffffc020179e:	8b05                	andi	a4,a4,1
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc02017a0:	10071a63          	bnez	a4,ffffffffc02018b4 <default_free_pages+0x12c>
ffffffffc02017a4:	6798                	ld	a4,8(a5)
ffffffffc02017a6:	8b09                	andi	a4,a4,2
ffffffffc02017a8:	10071663          	bnez	a4,ffffffffc02018b4 <default_free_pages+0x12c>
        p->flags = 0;
ffffffffc02017ac:	0007b423          	sd	zero,8(a5)
}

static inline void
set_page_ref(struct Page *page, int val)
{
    page->ref = val;
ffffffffc02017b0:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc02017b4:	04078793          	addi	a5,a5,64
ffffffffc02017b8:	fed792e3          	bne	a5,a3,ffffffffc020179c <default_free_pages+0x14>
    base->property = n;
ffffffffc02017bc:	2581                	sext.w	a1,a1
ffffffffc02017be:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc02017c0:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02017c4:	4789                	li	a5,2
ffffffffc02017c6:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc02017ca:	000a5697          	auipc	a3,0xa5
ffffffffc02017ce:	fb668693          	addi	a3,a3,-74 # ffffffffc02a6780 <free_area>
ffffffffc02017d2:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc02017d4:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc02017d6:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc02017da:	9db9                	addw	a1,a1,a4
ffffffffc02017dc:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list))
ffffffffc02017de:	0ad78463          	beq	a5,a3,ffffffffc0201886 <default_free_pages+0xfe>
            struct Page *page = le2page(le, page_link);
ffffffffc02017e2:	fe878713          	addi	a4,a5,-24
ffffffffc02017e6:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list))
ffffffffc02017ea:	4581                	li	a1,0
            if (base < page)
ffffffffc02017ec:	00e56a63          	bltu	a0,a4,ffffffffc0201800 <default_free_pages+0x78>
    return listelm->next;
ffffffffc02017f0:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc02017f2:	04d70c63          	beq	a4,a3,ffffffffc020184a <default_free_pages+0xc2>
    for (; p != base + n; p++)
ffffffffc02017f6:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc02017f8:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc02017fc:	fee57ae3          	bgeu	a0,a4,ffffffffc02017f0 <default_free_pages+0x68>
ffffffffc0201800:	c199                	beqz	a1,ffffffffc0201806 <default_free_pages+0x7e>
ffffffffc0201802:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0201806:	6398                	ld	a4,0(a5)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc0201808:	e390                	sd	a2,0(a5)
ffffffffc020180a:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc020180c:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc020180e:	ed18                	sd	a4,24(a0)
    if (le != &free_list)
ffffffffc0201810:	00d70d63          	beq	a4,a3,ffffffffc020182a <default_free_pages+0xa2>
        if (p + p->property == base)
ffffffffc0201814:	ff872583          	lw	a1,-8(a4)
        p = le2page(le, page_link);
ffffffffc0201818:	fe870613          	addi	a2,a4,-24
        if (p + p->property == base)
ffffffffc020181c:	02059813          	slli	a6,a1,0x20
ffffffffc0201820:	01a85793          	srli	a5,a6,0x1a
ffffffffc0201824:	97b2                	add	a5,a5,a2
ffffffffc0201826:	02f50c63          	beq	a0,a5,ffffffffc020185e <default_free_pages+0xd6>
    return listelm->next;
ffffffffc020182a:	711c                	ld	a5,32(a0)
    if (le != &free_list)
ffffffffc020182c:	00d78c63          	beq	a5,a3,ffffffffc0201844 <default_free_pages+0xbc>
        if (base + base->property == p)
ffffffffc0201830:	4910                	lw	a2,16(a0)
        p = le2page(le, page_link);
ffffffffc0201832:	fe878693          	addi	a3,a5,-24
        if (base + base->property == p)
ffffffffc0201836:	02061593          	slli	a1,a2,0x20
ffffffffc020183a:	01a5d713          	srli	a4,a1,0x1a
ffffffffc020183e:	972a                	add	a4,a4,a0
ffffffffc0201840:	04e68a63          	beq	a3,a4,ffffffffc0201894 <default_free_pages+0x10c>
}
ffffffffc0201844:	60a2                	ld	ra,8(sp)
ffffffffc0201846:	0141                	addi	sp,sp,16
ffffffffc0201848:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc020184a:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc020184c:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc020184e:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201850:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list)
ffffffffc0201852:	02d70763          	beq	a4,a3,ffffffffc0201880 <default_free_pages+0xf8>
    prev->next = next->prev = elm;
ffffffffc0201856:	8832                	mv	a6,a2
ffffffffc0201858:	4585                	li	a1,1
    for (; p != base + n; p++)
ffffffffc020185a:	87ba                	mv	a5,a4
ffffffffc020185c:	bf71                	j	ffffffffc02017f8 <default_free_pages+0x70>
            p->property += base->property;
ffffffffc020185e:	491c                	lw	a5,16(a0)
ffffffffc0201860:	9dbd                	addw	a1,a1,a5
ffffffffc0201862:	feb72c23          	sw	a1,-8(a4)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201866:	57f5                	li	a5,-3
ffffffffc0201868:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc020186c:	01853803          	ld	a6,24(a0)
ffffffffc0201870:	710c                	ld	a1,32(a0)
            base = p;
ffffffffc0201872:	8532                	mv	a0,a2
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0201874:	00b83423          	sd	a1,8(a6)
    return listelm->next;
ffffffffc0201878:	671c                	ld	a5,8(a4)
    next->prev = prev;
ffffffffc020187a:	0105b023          	sd	a6,0(a1)
ffffffffc020187e:	b77d                	j	ffffffffc020182c <default_free_pages+0xa4>
ffffffffc0201880:	e290                	sd	a2,0(a3)
        while ((le = list_next(le)) != &free_list)
ffffffffc0201882:	873e                	mv	a4,a5
ffffffffc0201884:	bf41                	j	ffffffffc0201814 <default_free_pages+0x8c>
}
ffffffffc0201886:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201888:	e390                	sd	a2,0(a5)
ffffffffc020188a:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc020188c:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc020188e:	ed1c                	sd	a5,24(a0)
ffffffffc0201890:	0141                	addi	sp,sp,16
ffffffffc0201892:	8082                	ret
            base->property += p->property;
ffffffffc0201894:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201898:	ff078693          	addi	a3,a5,-16
ffffffffc020189c:	9e39                	addw	a2,a2,a4
ffffffffc020189e:	c910                	sw	a2,16(a0)
ffffffffc02018a0:	5775                	li	a4,-3
ffffffffc02018a2:	60e6b02f          	amoand.d	zero,a4,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc02018a6:	6398                	ld	a4,0(a5)
ffffffffc02018a8:	679c                	ld	a5,8(a5)
}
ffffffffc02018aa:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc02018ac:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc02018ae:	e398                	sd	a4,0(a5)
ffffffffc02018b0:	0141                	addi	sp,sp,16
ffffffffc02018b2:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc02018b4:	00005697          	auipc	a3,0x5
ffffffffc02018b8:	c3c68693          	addi	a3,a3,-964 # ffffffffc02064f0 <commands+0xb88>
ffffffffc02018bc:	00005617          	auipc	a2,0x5
ffffffffc02018c0:	8d460613          	addi	a2,a2,-1836 # ffffffffc0206190 <commands+0x828>
ffffffffc02018c4:	09400593          	li	a1,148
ffffffffc02018c8:	00005517          	auipc	a0,0x5
ffffffffc02018cc:	8e050513          	addi	a0,a0,-1824 # ffffffffc02061a8 <commands+0x840>
ffffffffc02018d0:	bbffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(n > 0);
ffffffffc02018d4:	00005697          	auipc	a3,0x5
ffffffffc02018d8:	c1468693          	addi	a3,a3,-1004 # ffffffffc02064e8 <commands+0xb80>
ffffffffc02018dc:	00005617          	auipc	a2,0x5
ffffffffc02018e0:	8b460613          	addi	a2,a2,-1868 # ffffffffc0206190 <commands+0x828>
ffffffffc02018e4:	09000593          	li	a1,144
ffffffffc02018e8:	00005517          	auipc	a0,0x5
ffffffffc02018ec:	8c050513          	addi	a0,a0,-1856 # ffffffffc02061a8 <commands+0x840>
ffffffffc02018f0:	b9ffe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02018f4 <default_alloc_pages>:
    assert(n > 0);
ffffffffc02018f4:	c941                	beqz	a0,ffffffffc0201984 <default_alloc_pages+0x90>
    if (n > nr_free)
ffffffffc02018f6:	000a5597          	auipc	a1,0xa5
ffffffffc02018fa:	e8a58593          	addi	a1,a1,-374 # ffffffffc02a6780 <free_area>
ffffffffc02018fe:	0105a803          	lw	a6,16(a1)
ffffffffc0201902:	872a                	mv	a4,a0
ffffffffc0201904:	02081793          	slli	a5,a6,0x20
ffffffffc0201908:	9381                	srli	a5,a5,0x20
ffffffffc020190a:	00a7ee63          	bltu	a5,a0,ffffffffc0201926 <default_alloc_pages+0x32>
    list_entry_t *le = &free_list;
ffffffffc020190e:	87ae                	mv	a5,a1
ffffffffc0201910:	a801                	j	ffffffffc0201920 <default_alloc_pages+0x2c>
        if (p->property >= n)
ffffffffc0201912:	ff87a683          	lw	a3,-8(a5)
ffffffffc0201916:	02069613          	slli	a2,a3,0x20
ffffffffc020191a:	9201                	srli	a2,a2,0x20
ffffffffc020191c:	00e67763          	bgeu	a2,a4,ffffffffc020192a <default_alloc_pages+0x36>
    return listelm->next;
ffffffffc0201920:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list)
ffffffffc0201922:	feb798e3          	bne	a5,a1,ffffffffc0201912 <default_alloc_pages+0x1e>
        return NULL;
ffffffffc0201926:	4501                	li	a0,0
}
ffffffffc0201928:	8082                	ret
    return listelm->prev;
ffffffffc020192a:	0007b883          	ld	a7,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc020192e:	0087b303          	ld	t1,8(a5)
        struct Page *p = le2page(le, page_link);
ffffffffc0201932:	fe878513          	addi	a0,a5,-24
            p->property = page->property - n;
ffffffffc0201936:	00070e1b          	sext.w	t3,a4
    prev->next = next;
ffffffffc020193a:	0068b423          	sd	t1,8(a7)
    next->prev = prev;
ffffffffc020193e:	01133023          	sd	a7,0(t1)
        if (page->property > n)
ffffffffc0201942:	02c77863          	bgeu	a4,a2,ffffffffc0201972 <default_alloc_pages+0x7e>
            struct Page *p = page + n;
ffffffffc0201946:	071a                	slli	a4,a4,0x6
ffffffffc0201948:	972a                	add	a4,a4,a0
            p->property = page->property - n;
ffffffffc020194a:	41c686bb          	subw	a3,a3,t3
ffffffffc020194e:	cb14                	sw	a3,16(a4)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201950:	00870613          	addi	a2,a4,8
ffffffffc0201954:	4689                	li	a3,2
ffffffffc0201956:	40d6302f          	amoor.d	zero,a3,(a2)
    __list_add(elm, listelm, listelm->next);
ffffffffc020195a:	0088b683          	ld	a3,8(a7)
            list_add(prev, &(p->page_link));
ffffffffc020195e:	01870613          	addi	a2,a4,24
        nr_free -= n;
ffffffffc0201962:	0105a803          	lw	a6,16(a1)
    prev->next = next->prev = elm;
ffffffffc0201966:	e290                	sd	a2,0(a3)
ffffffffc0201968:	00c8b423          	sd	a2,8(a7)
    elm->next = next;
ffffffffc020196c:	f314                	sd	a3,32(a4)
    elm->prev = prev;
ffffffffc020196e:	01173c23          	sd	a7,24(a4)
ffffffffc0201972:	41c8083b          	subw	a6,a6,t3
ffffffffc0201976:	0105a823          	sw	a6,16(a1)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc020197a:	5775                	li	a4,-3
ffffffffc020197c:	17c1                	addi	a5,a5,-16
ffffffffc020197e:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc0201982:	8082                	ret
{
ffffffffc0201984:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc0201986:	00005697          	auipc	a3,0x5
ffffffffc020198a:	b6268693          	addi	a3,a3,-1182 # ffffffffc02064e8 <commands+0xb80>
ffffffffc020198e:	00005617          	auipc	a2,0x5
ffffffffc0201992:	80260613          	addi	a2,a2,-2046 # ffffffffc0206190 <commands+0x828>
ffffffffc0201996:	06c00593          	li	a1,108
ffffffffc020199a:	00005517          	auipc	a0,0x5
ffffffffc020199e:	80e50513          	addi	a0,a0,-2034 # ffffffffc02061a8 <commands+0x840>
{
ffffffffc02019a2:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02019a4:	aebfe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02019a8 <default_init_memmap>:
{
ffffffffc02019a8:	1141                	addi	sp,sp,-16
ffffffffc02019aa:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02019ac:	c5f1                	beqz	a1,ffffffffc0201a78 <default_init_memmap+0xd0>
    for (; p != base + n; p++)
ffffffffc02019ae:	00659693          	slli	a3,a1,0x6
ffffffffc02019b2:	96aa                	add	a3,a3,a0
ffffffffc02019b4:	87aa                	mv	a5,a0
ffffffffc02019b6:	00d50f63          	beq	a0,a3,ffffffffc02019d4 <default_init_memmap+0x2c>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc02019ba:	6798                	ld	a4,8(a5)
ffffffffc02019bc:	8b05                	andi	a4,a4,1
        assert(PageReserved(p));
ffffffffc02019be:	cf49                	beqz	a4,ffffffffc0201a58 <default_init_memmap+0xb0>
        p->flags = p->property = 0;
ffffffffc02019c0:	0007a823          	sw	zero,16(a5)
ffffffffc02019c4:	0007b423          	sd	zero,8(a5)
ffffffffc02019c8:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc02019cc:	04078793          	addi	a5,a5,64
ffffffffc02019d0:	fed795e3          	bne	a5,a3,ffffffffc02019ba <default_init_memmap+0x12>
    base->property = n;
ffffffffc02019d4:	2581                	sext.w	a1,a1
ffffffffc02019d6:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02019d8:	4789                	li	a5,2
ffffffffc02019da:	00850713          	addi	a4,a0,8
ffffffffc02019de:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc02019e2:	000a5697          	auipc	a3,0xa5
ffffffffc02019e6:	d9e68693          	addi	a3,a3,-610 # ffffffffc02a6780 <free_area>
ffffffffc02019ea:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc02019ec:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc02019ee:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc02019f2:	9db9                	addw	a1,a1,a4
ffffffffc02019f4:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list))
ffffffffc02019f6:	04d78a63          	beq	a5,a3,ffffffffc0201a4a <default_init_memmap+0xa2>
            struct Page *page = le2page(le, page_link);
ffffffffc02019fa:	fe878713          	addi	a4,a5,-24
ffffffffc02019fe:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list))
ffffffffc0201a02:	4581                	li	a1,0
            if (base < page)
ffffffffc0201a04:	00e56a63          	bltu	a0,a4,ffffffffc0201a18 <default_init_memmap+0x70>
    return listelm->next;
ffffffffc0201a08:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc0201a0a:	02d70263          	beq	a4,a3,ffffffffc0201a2e <default_init_memmap+0x86>
    for (; p != base + n; p++)
ffffffffc0201a0e:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc0201a10:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc0201a14:	fee57ae3          	bgeu	a0,a4,ffffffffc0201a08 <default_init_memmap+0x60>
ffffffffc0201a18:	c199                	beqz	a1,ffffffffc0201a1e <default_init_memmap+0x76>
ffffffffc0201a1a:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0201a1e:	6398                	ld	a4,0(a5)
}
ffffffffc0201a20:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201a22:	e390                	sd	a2,0(a5)
ffffffffc0201a24:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0201a26:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201a28:	ed18                	sd	a4,24(a0)
ffffffffc0201a2a:	0141                	addi	sp,sp,16
ffffffffc0201a2c:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0201a2e:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201a30:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0201a32:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201a34:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list)
ffffffffc0201a36:	00d70663          	beq	a4,a3,ffffffffc0201a42 <default_init_memmap+0x9a>
    prev->next = next->prev = elm;
ffffffffc0201a3a:	8832                	mv	a6,a2
ffffffffc0201a3c:	4585                	li	a1,1
    for (; p != base + n; p++)
ffffffffc0201a3e:	87ba                	mv	a5,a4
ffffffffc0201a40:	bfc1                	j	ffffffffc0201a10 <default_init_memmap+0x68>
}
ffffffffc0201a42:	60a2                	ld	ra,8(sp)
ffffffffc0201a44:	e290                	sd	a2,0(a3)
ffffffffc0201a46:	0141                	addi	sp,sp,16
ffffffffc0201a48:	8082                	ret
ffffffffc0201a4a:	60a2                	ld	ra,8(sp)
ffffffffc0201a4c:	e390                	sd	a2,0(a5)
ffffffffc0201a4e:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201a50:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201a52:	ed1c                	sd	a5,24(a0)
ffffffffc0201a54:	0141                	addi	sp,sp,16
ffffffffc0201a56:	8082                	ret
        assert(PageReserved(p));
ffffffffc0201a58:	00005697          	auipc	a3,0x5
ffffffffc0201a5c:	ac068693          	addi	a3,a3,-1344 # ffffffffc0206518 <commands+0xbb0>
ffffffffc0201a60:	00004617          	auipc	a2,0x4
ffffffffc0201a64:	73060613          	addi	a2,a2,1840 # ffffffffc0206190 <commands+0x828>
ffffffffc0201a68:	04b00593          	li	a1,75
ffffffffc0201a6c:	00004517          	auipc	a0,0x4
ffffffffc0201a70:	73c50513          	addi	a0,a0,1852 # ffffffffc02061a8 <commands+0x840>
ffffffffc0201a74:	a1bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(n > 0);
ffffffffc0201a78:	00005697          	auipc	a3,0x5
ffffffffc0201a7c:	a7068693          	addi	a3,a3,-1424 # ffffffffc02064e8 <commands+0xb80>
ffffffffc0201a80:	00004617          	auipc	a2,0x4
ffffffffc0201a84:	71060613          	addi	a2,a2,1808 # ffffffffc0206190 <commands+0x828>
ffffffffc0201a88:	04700593          	li	a1,71
ffffffffc0201a8c:	00004517          	auipc	a0,0x4
ffffffffc0201a90:	71c50513          	addi	a0,a0,1820 # ffffffffc02061a8 <commands+0x840>
ffffffffc0201a94:	9fbfe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201a98 <slob_free>:
static void slob_free(void *block, int size)
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
ffffffffc0201a98:	c94d                	beqz	a0,ffffffffc0201b4a <slob_free+0xb2>
{
ffffffffc0201a9a:	1141                	addi	sp,sp,-16
ffffffffc0201a9c:	e022                	sd	s0,0(sp)
ffffffffc0201a9e:	e406                	sd	ra,8(sp)
ffffffffc0201aa0:	842a                	mv	s0,a0
		return;

	if (size)
ffffffffc0201aa2:	e9c1                	bnez	a1,ffffffffc0201b32 <slob_free+0x9a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201aa4:	100027f3          	csrr	a5,sstatus
ffffffffc0201aa8:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201aaa:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201aac:	ebd9                	bnez	a5,ffffffffc0201b42 <slob_free+0xaa>
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201aae:	000a5617          	auipc	a2,0xa5
ffffffffc0201ab2:	8c260613          	addi	a2,a2,-1854 # ffffffffc02a6370 <slobfree>
ffffffffc0201ab6:	621c                	ld	a5,0(a2)
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201ab8:	873e                	mv	a4,a5
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201aba:	679c                	ld	a5,8(a5)
ffffffffc0201abc:	02877a63          	bgeu	a4,s0,ffffffffc0201af0 <slob_free+0x58>
ffffffffc0201ac0:	00f46463          	bltu	s0,a5,ffffffffc0201ac8 <slob_free+0x30>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201ac4:	fef76ae3          	bltu	a4,a5,ffffffffc0201ab8 <slob_free+0x20>
			break;

	if (b + b->units == cur->next)
ffffffffc0201ac8:	400c                	lw	a1,0(s0)
ffffffffc0201aca:	00459693          	slli	a3,a1,0x4
ffffffffc0201ace:	96a2                	add	a3,a3,s0
ffffffffc0201ad0:	02d78a63          	beq	a5,a3,ffffffffc0201b04 <slob_free+0x6c>
		b->next = cur->next->next;
	}
	else
		b->next = cur->next;

	if (cur + cur->units == b)
ffffffffc0201ad4:	4314                	lw	a3,0(a4)
		b->next = cur->next;
ffffffffc0201ad6:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b)
ffffffffc0201ad8:	00469793          	slli	a5,a3,0x4
ffffffffc0201adc:	97ba                	add	a5,a5,a4
ffffffffc0201ade:	02f40e63          	beq	s0,a5,ffffffffc0201b1a <slob_free+0x82>
	{
		cur->units += b->units;
		cur->next = b->next;
	}
	else
		cur->next = b;
ffffffffc0201ae2:	e700                	sd	s0,8(a4)

	slobfree = cur;
ffffffffc0201ae4:	e218                	sd	a4,0(a2)
    if (flag)
ffffffffc0201ae6:	e129                	bnez	a0,ffffffffc0201b28 <slob_free+0x90>

	spin_unlock_irqrestore(&slob_lock, flags);
}
ffffffffc0201ae8:	60a2                	ld	ra,8(sp)
ffffffffc0201aea:	6402                	ld	s0,0(sp)
ffffffffc0201aec:	0141                	addi	sp,sp,16
ffffffffc0201aee:	8082                	ret
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201af0:	fcf764e3          	bltu	a4,a5,ffffffffc0201ab8 <slob_free+0x20>
ffffffffc0201af4:	fcf472e3          	bgeu	s0,a5,ffffffffc0201ab8 <slob_free+0x20>
	if (b + b->units == cur->next)
ffffffffc0201af8:	400c                	lw	a1,0(s0)
ffffffffc0201afa:	00459693          	slli	a3,a1,0x4
ffffffffc0201afe:	96a2                	add	a3,a3,s0
ffffffffc0201b00:	fcd79ae3          	bne	a5,a3,ffffffffc0201ad4 <slob_free+0x3c>
		b->units += cur->next->units;
ffffffffc0201b04:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc0201b06:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc0201b08:	9db5                	addw	a1,a1,a3
ffffffffc0201b0a:	c00c                	sw	a1,0(s0)
	if (cur + cur->units == b)
ffffffffc0201b0c:	4314                	lw	a3,0(a4)
		b->next = cur->next->next;
ffffffffc0201b0e:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b)
ffffffffc0201b10:	00469793          	slli	a5,a3,0x4
ffffffffc0201b14:	97ba                	add	a5,a5,a4
ffffffffc0201b16:	fcf416e3          	bne	s0,a5,ffffffffc0201ae2 <slob_free+0x4a>
		cur->units += b->units;
ffffffffc0201b1a:	401c                	lw	a5,0(s0)
		cur->next = b->next;
ffffffffc0201b1c:	640c                	ld	a1,8(s0)
	slobfree = cur;
ffffffffc0201b1e:	e218                	sd	a4,0(a2)
		cur->units += b->units;
ffffffffc0201b20:	9ebd                	addw	a3,a3,a5
ffffffffc0201b22:	c314                	sw	a3,0(a4)
		cur->next = b->next;
ffffffffc0201b24:	e70c                	sd	a1,8(a4)
ffffffffc0201b26:	d169                	beqz	a0,ffffffffc0201ae8 <slob_free+0x50>
}
ffffffffc0201b28:	6402                	ld	s0,0(sp)
ffffffffc0201b2a:	60a2                	ld	ra,8(sp)
ffffffffc0201b2c:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc0201b2e:	e81fe06f          	j	ffffffffc02009ae <intr_enable>
		b->units = SLOB_UNITS(size);
ffffffffc0201b32:	25bd                	addiw	a1,a1,15
ffffffffc0201b34:	8191                	srli	a1,a1,0x4
ffffffffc0201b36:	c10c                	sw	a1,0(a0)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201b38:	100027f3          	csrr	a5,sstatus
ffffffffc0201b3c:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201b3e:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201b40:	d7bd                	beqz	a5,ffffffffc0201aae <slob_free+0x16>
        intr_disable();
ffffffffc0201b42:	e73fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0201b46:	4505                	li	a0,1
ffffffffc0201b48:	b79d                	j	ffffffffc0201aae <slob_free+0x16>
ffffffffc0201b4a:	8082                	ret

ffffffffc0201b4c <__slob_get_free_pages.constprop.0>:
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201b4c:	4785                	li	a5,1
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201b4e:	1141                	addi	sp,sp,-16
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201b50:	00a7953b          	sllw	a0,a5,a0
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201b54:	e406                	sd	ra,8(sp)
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201b56:	352000ef          	jal	ra,ffffffffc0201ea8 <alloc_pages>
	if (!page)
ffffffffc0201b5a:	c91d                	beqz	a0,ffffffffc0201b90 <__slob_get_free_pages.constprop.0+0x44>
    return page - pages + nbase;
ffffffffc0201b5c:	000a9697          	auipc	a3,0xa9
ffffffffc0201b60:	c9c6b683          	ld	a3,-868(a3) # ffffffffc02aa7f8 <pages>
ffffffffc0201b64:	8d15                	sub	a0,a0,a3
ffffffffc0201b66:	8519                	srai	a0,a0,0x6
ffffffffc0201b68:	00006697          	auipc	a3,0x6
ffffffffc0201b6c:	d006b683          	ld	a3,-768(a3) # ffffffffc0207868 <nbase>
ffffffffc0201b70:	9536                	add	a0,a0,a3
    return KADDR(page2pa(page));
ffffffffc0201b72:	00c51793          	slli	a5,a0,0xc
ffffffffc0201b76:	83b1                	srli	a5,a5,0xc
ffffffffc0201b78:	000a9717          	auipc	a4,0xa9
ffffffffc0201b7c:	c7873703          	ld	a4,-904(a4) # ffffffffc02aa7f0 <npage>
    return page2ppn(page) << PGSHIFT;
ffffffffc0201b80:	0532                	slli	a0,a0,0xc
    return KADDR(page2pa(page));
ffffffffc0201b82:	00e7fa63          	bgeu	a5,a4,ffffffffc0201b96 <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc0201b86:	000a9697          	auipc	a3,0xa9
ffffffffc0201b8a:	c826b683          	ld	a3,-894(a3) # ffffffffc02aa808 <va_pa_offset>
ffffffffc0201b8e:	9536                	add	a0,a0,a3
}
ffffffffc0201b90:	60a2                	ld	ra,8(sp)
ffffffffc0201b92:	0141                	addi	sp,sp,16
ffffffffc0201b94:	8082                	ret
ffffffffc0201b96:	86aa                	mv	a3,a0
ffffffffc0201b98:	00005617          	auipc	a2,0x5
ffffffffc0201b9c:	9e060613          	addi	a2,a2,-1568 # ffffffffc0206578 <default_pmm_manager+0x38>
ffffffffc0201ba0:	07100593          	li	a1,113
ffffffffc0201ba4:	00005517          	auipc	a0,0x5
ffffffffc0201ba8:	9fc50513          	addi	a0,a0,-1540 # ffffffffc02065a0 <default_pmm_manager+0x60>
ffffffffc0201bac:	8e3fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201bb0 <slob_alloc.constprop.0>:
static void *slob_alloc(size_t size, gfp_t gfp, int align)
ffffffffc0201bb0:	1101                	addi	sp,sp,-32
ffffffffc0201bb2:	ec06                	sd	ra,24(sp)
ffffffffc0201bb4:	e822                	sd	s0,16(sp)
ffffffffc0201bb6:	e426                	sd	s1,8(sp)
ffffffffc0201bb8:	e04a                	sd	s2,0(sp)
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201bba:	01050713          	addi	a4,a0,16
ffffffffc0201bbe:	6785                	lui	a5,0x1
ffffffffc0201bc0:	0cf77363          	bgeu	a4,a5,ffffffffc0201c86 <slob_alloc.constprop.0+0xd6>
	int delta = 0, units = SLOB_UNITS(size);
ffffffffc0201bc4:	00f50493          	addi	s1,a0,15
ffffffffc0201bc8:	8091                	srli	s1,s1,0x4
ffffffffc0201bca:	2481                	sext.w	s1,s1
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201bcc:	10002673          	csrr	a2,sstatus
ffffffffc0201bd0:	8a09                	andi	a2,a2,2
ffffffffc0201bd2:	e25d                	bnez	a2,ffffffffc0201c78 <slob_alloc.constprop.0+0xc8>
	prev = slobfree;
ffffffffc0201bd4:	000a4917          	auipc	s2,0xa4
ffffffffc0201bd8:	79c90913          	addi	s2,s2,1948 # ffffffffc02a6370 <slobfree>
ffffffffc0201bdc:	00093683          	ld	a3,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201be0:	669c                	ld	a5,8(a3)
		if (cur->units >= units + delta)
ffffffffc0201be2:	4398                	lw	a4,0(a5)
ffffffffc0201be4:	08975e63          	bge	a4,s1,ffffffffc0201c80 <slob_alloc.constprop.0+0xd0>
		if (cur == slobfree)
ffffffffc0201be8:	00f68b63          	beq	a3,a5,ffffffffc0201bfe <slob_alloc.constprop.0+0x4e>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201bec:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc0201bee:	4018                	lw	a4,0(s0)
ffffffffc0201bf0:	02975a63          	bge	a4,s1,ffffffffc0201c24 <slob_alloc.constprop.0+0x74>
		if (cur == slobfree)
ffffffffc0201bf4:	00093683          	ld	a3,0(s2)
ffffffffc0201bf8:	87a2                	mv	a5,s0
ffffffffc0201bfa:	fef699e3          	bne	a3,a5,ffffffffc0201bec <slob_alloc.constprop.0+0x3c>
    if (flag)
ffffffffc0201bfe:	ee31                	bnez	a2,ffffffffc0201c5a <slob_alloc.constprop.0+0xaa>
			cur = (slob_t *)__slob_get_free_page(gfp);
ffffffffc0201c00:	4501                	li	a0,0
ffffffffc0201c02:	f4bff0ef          	jal	ra,ffffffffc0201b4c <__slob_get_free_pages.constprop.0>
ffffffffc0201c06:	842a                	mv	s0,a0
			if (!cur)
ffffffffc0201c08:	cd05                	beqz	a0,ffffffffc0201c40 <slob_alloc.constprop.0+0x90>
			slob_free(cur, PAGE_SIZE);
ffffffffc0201c0a:	6585                	lui	a1,0x1
ffffffffc0201c0c:	e8dff0ef          	jal	ra,ffffffffc0201a98 <slob_free>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201c10:	10002673          	csrr	a2,sstatus
ffffffffc0201c14:	8a09                	andi	a2,a2,2
ffffffffc0201c16:	ee05                	bnez	a2,ffffffffc0201c4e <slob_alloc.constprop.0+0x9e>
			cur = slobfree;
ffffffffc0201c18:	00093783          	ld	a5,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201c1c:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc0201c1e:	4018                	lw	a4,0(s0)
ffffffffc0201c20:	fc974ae3          	blt	a4,s1,ffffffffc0201bf4 <slob_alloc.constprop.0+0x44>
			if (cur->units == units)	/* exact fit? */
ffffffffc0201c24:	04e48763          	beq	s1,a4,ffffffffc0201c72 <slob_alloc.constprop.0+0xc2>
				prev->next = cur + units;
ffffffffc0201c28:	00449693          	slli	a3,s1,0x4
ffffffffc0201c2c:	96a2                	add	a3,a3,s0
ffffffffc0201c2e:	e794                	sd	a3,8(a5)
				prev->next->next = cur->next;
ffffffffc0201c30:	640c                	ld	a1,8(s0)
				prev->next->units = cur->units - units;
ffffffffc0201c32:	9f05                	subw	a4,a4,s1
ffffffffc0201c34:	c298                	sw	a4,0(a3)
				prev->next->next = cur->next;
ffffffffc0201c36:	e68c                	sd	a1,8(a3)
				cur->units = units;
ffffffffc0201c38:	c004                	sw	s1,0(s0)
			slobfree = prev;
ffffffffc0201c3a:	00f93023          	sd	a5,0(s2)
    if (flag)
ffffffffc0201c3e:	e20d                	bnez	a2,ffffffffc0201c60 <slob_alloc.constprop.0+0xb0>
}
ffffffffc0201c40:	60e2                	ld	ra,24(sp)
ffffffffc0201c42:	8522                	mv	a0,s0
ffffffffc0201c44:	6442                	ld	s0,16(sp)
ffffffffc0201c46:	64a2                	ld	s1,8(sp)
ffffffffc0201c48:	6902                	ld	s2,0(sp)
ffffffffc0201c4a:	6105                	addi	sp,sp,32
ffffffffc0201c4c:	8082                	ret
        intr_disable();
ffffffffc0201c4e:	d67fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
			cur = slobfree;
ffffffffc0201c52:	00093783          	ld	a5,0(s2)
        return 1;
ffffffffc0201c56:	4605                	li	a2,1
ffffffffc0201c58:	b7d1                	j	ffffffffc0201c1c <slob_alloc.constprop.0+0x6c>
        intr_enable();
ffffffffc0201c5a:	d55fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0201c5e:	b74d                	j	ffffffffc0201c00 <slob_alloc.constprop.0+0x50>
ffffffffc0201c60:	d4ffe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
}
ffffffffc0201c64:	60e2                	ld	ra,24(sp)
ffffffffc0201c66:	8522                	mv	a0,s0
ffffffffc0201c68:	6442                	ld	s0,16(sp)
ffffffffc0201c6a:	64a2                	ld	s1,8(sp)
ffffffffc0201c6c:	6902                	ld	s2,0(sp)
ffffffffc0201c6e:	6105                	addi	sp,sp,32
ffffffffc0201c70:	8082                	ret
				prev->next = cur->next; /* unlink */
ffffffffc0201c72:	6418                	ld	a4,8(s0)
ffffffffc0201c74:	e798                	sd	a4,8(a5)
ffffffffc0201c76:	b7d1                	j	ffffffffc0201c3a <slob_alloc.constprop.0+0x8a>
        intr_disable();
ffffffffc0201c78:	d3dfe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0201c7c:	4605                	li	a2,1
ffffffffc0201c7e:	bf99                	j	ffffffffc0201bd4 <slob_alloc.constprop.0+0x24>
		if (cur->units >= units + delta)
ffffffffc0201c80:	843e                	mv	s0,a5
ffffffffc0201c82:	87b6                	mv	a5,a3
ffffffffc0201c84:	b745                	j	ffffffffc0201c24 <slob_alloc.constprop.0+0x74>
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201c86:	00005697          	auipc	a3,0x5
ffffffffc0201c8a:	92a68693          	addi	a3,a3,-1750 # ffffffffc02065b0 <default_pmm_manager+0x70>
ffffffffc0201c8e:	00004617          	auipc	a2,0x4
ffffffffc0201c92:	50260613          	addi	a2,a2,1282 # ffffffffc0206190 <commands+0x828>
ffffffffc0201c96:	06400593          	li	a1,100
ffffffffc0201c9a:	00005517          	auipc	a0,0x5
ffffffffc0201c9e:	93650513          	addi	a0,a0,-1738 # ffffffffc02065d0 <default_pmm_manager+0x90>
ffffffffc0201ca2:	fecfe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201ca6 <kmalloc_init>:
	cprintf("use SLOB allocator\n");
}

inline void
kmalloc_init(void)
{
ffffffffc0201ca6:	1141                	addi	sp,sp,-16
	cprintf("use SLOB allocator\n");
ffffffffc0201ca8:	00005517          	auipc	a0,0x5
ffffffffc0201cac:	94050513          	addi	a0,a0,-1728 # ffffffffc02065e8 <default_pmm_manager+0xa8>
{
ffffffffc0201cb0:	e406                	sd	ra,8(sp)
	cprintf("use SLOB allocator\n");
ffffffffc0201cb2:	ce2fe0ef          	jal	ra,ffffffffc0200194 <cprintf>
	slob_init();
	cprintf("kmalloc_init() succeeded!\n");
}
ffffffffc0201cb6:	60a2                	ld	ra,8(sp)
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201cb8:	00005517          	auipc	a0,0x5
ffffffffc0201cbc:	94850513          	addi	a0,a0,-1720 # ffffffffc0206600 <default_pmm_manager+0xc0>
}
ffffffffc0201cc0:	0141                	addi	sp,sp,16
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201cc2:	cd2fe06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0201cc6 <kallocated>:

size_t
kallocated(void)
{
	return slob_allocated();
}
ffffffffc0201cc6:	4501                	li	a0,0
ffffffffc0201cc8:	8082                	ret

ffffffffc0201cca <kmalloc>:
	return 0;
}

void *
kmalloc(size_t size)
{
ffffffffc0201cca:	1101                	addi	sp,sp,-32
ffffffffc0201ccc:	e04a                	sd	s2,0(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201cce:	6905                	lui	s2,0x1
{
ffffffffc0201cd0:	e822                	sd	s0,16(sp)
ffffffffc0201cd2:	ec06                	sd	ra,24(sp)
ffffffffc0201cd4:	e426                	sd	s1,8(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201cd6:	fef90793          	addi	a5,s2,-17 # fef <_binary_obj___user_faultread_out_size-0x8bc9>
{
ffffffffc0201cda:	842a                	mv	s0,a0
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201cdc:	04a7f963          	bgeu	a5,a0,ffffffffc0201d2e <kmalloc+0x64>
	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
ffffffffc0201ce0:	4561                	li	a0,24
ffffffffc0201ce2:	ecfff0ef          	jal	ra,ffffffffc0201bb0 <slob_alloc.constprop.0>
ffffffffc0201ce6:	84aa                	mv	s1,a0
	if (!bb)
ffffffffc0201ce8:	c929                	beqz	a0,ffffffffc0201d3a <kmalloc+0x70>
	bb->order = find_order(size);
ffffffffc0201cea:	0004079b          	sext.w	a5,s0
	int order = 0;
ffffffffc0201cee:	4501                	li	a0,0
	for (; size > 4096; size >>= 1)
ffffffffc0201cf0:	00f95763          	bge	s2,a5,ffffffffc0201cfe <kmalloc+0x34>
ffffffffc0201cf4:	6705                	lui	a4,0x1
ffffffffc0201cf6:	8785                	srai	a5,a5,0x1
		order++;
ffffffffc0201cf8:	2505                	addiw	a0,a0,1
	for (; size > 4096; size >>= 1)
ffffffffc0201cfa:	fef74ee3          	blt	a4,a5,ffffffffc0201cf6 <kmalloc+0x2c>
	bb->order = find_order(size);
ffffffffc0201cfe:	c088                	sw	a0,0(s1)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
ffffffffc0201d00:	e4dff0ef          	jal	ra,ffffffffc0201b4c <__slob_get_free_pages.constprop.0>
ffffffffc0201d04:	e488                	sd	a0,8(s1)
ffffffffc0201d06:	842a                	mv	s0,a0
	if (bb->pages)
ffffffffc0201d08:	c525                	beqz	a0,ffffffffc0201d70 <kmalloc+0xa6>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201d0a:	100027f3          	csrr	a5,sstatus
ffffffffc0201d0e:	8b89                	andi	a5,a5,2
ffffffffc0201d10:	ef8d                	bnez	a5,ffffffffc0201d4a <kmalloc+0x80>
		bb->next = bigblocks;
ffffffffc0201d12:	000a9797          	auipc	a5,0xa9
ffffffffc0201d16:	ac678793          	addi	a5,a5,-1338 # ffffffffc02aa7d8 <bigblocks>
ffffffffc0201d1a:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc0201d1c:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0201d1e:	e898                	sd	a4,16(s1)
	return __kmalloc(size, 0);
}
ffffffffc0201d20:	60e2                	ld	ra,24(sp)
ffffffffc0201d22:	8522                	mv	a0,s0
ffffffffc0201d24:	6442                	ld	s0,16(sp)
ffffffffc0201d26:	64a2                	ld	s1,8(sp)
ffffffffc0201d28:	6902                	ld	s2,0(sp)
ffffffffc0201d2a:	6105                	addi	sp,sp,32
ffffffffc0201d2c:	8082                	ret
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
ffffffffc0201d2e:	0541                	addi	a0,a0,16
ffffffffc0201d30:	e81ff0ef          	jal	ra,ffffffffc0201bb0 <slob_alloc.constprop.0>
		return m ? (void *)(m + 1) : 0;
ffffffffc0201d34:	01050413          	addi	s0,a0,16
ffffffffc0201d38:	f565                	bnez	a0,ffffffffc0201d20 <kmalloc+0x56>
ffffffffc0201d3a:	4401                	li	s0,0
}
ffffffffc0201d3c:	60e2                	ld	ra,24(sp)
ffffffffc0201d3e:	8522                	mv	a0,s0
ffffffffc0201d40:	6442                	ld	s0,16(sp)
ffffffffc0201d42:	64a2                	ld	s1,8(sp)
ffffffffc0201d44:	6902                	ld	s2,0(sp)
ffffffffc0201d46:	6105                	addi	sp,sp,32
ffffffffc0201d48:	8082                	ret
        intr_disable();
ffffffffc0201d4a:	c6bfe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
		bb->next = bigblocks;
ffffffffc0201d4e:	000a9797          	auipc	a5,0xa9
ffffffffc0201d52:	a8a78793          	addi	a5,a5,-1398 # ffffffffc02aa7d8 <bigblocks>
ffffffffc0201d56:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc0201d58:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0201d5a:	e898                	sd	a4,16(s1)
        intr_enable();
ffffffffc0201d5c:	c53fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
		return bb->pages;
ffffffffc0201d60:	6480                	ld	s0,8(s1)
}
ffffffffc0201d62:	60e2                	ld	ra,24(sp)
ffffffffc0201d64:	64a2                	ld	s1,8(sp)
ffffffffc0201d66:	8522                	mv	a0,s0
ffffffffc0201d68:	6442                	ld	s0,16(sp)
ffffffffc0201d6a:	6902                	ld	s2,0(sp)
ffffffffc0201d6c:	6105                	addi	sp,sp,32
ffffffffc0201d6e:	8082                	ret
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0201d70:	45e1                	li	a1,24
ffffffffc0201d72:	8526                	mv	a0,s1
ffffffffc0201d74:	d25ff0ef          	jal	ra,ffffffffc0201a98 <slob_free>
	return __kmalloc(size, 0);
ffffffffc0201d78:	b765                	j	ffffffffc0201d20 <kmalloc+0x56>

ffffffffc0201d7a <kfree>:
void kfree(void *block)
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
ffffffffc0201d7a:	c169                	beqz	a0,ffffffffc0201e3c <kfree+0xc2>
{
ffffffffc0201d7c:	1101                	addi	sp,sp,-32
ffffffffc0201d7e:	e822                	sd	s0,16(sp)
ffffffffc0201d80:	ec06                	sd	ra,24(sp)
ffffffffc0201d82:	e426                	sd	s1,8(sp)
		return;

	if (!((unsigned long)block & (PAGE_SIZE - 1)))
ffffffffc0201d84:	03451793          	slli	a5,a0,0x34
ffffffffc0201d88:	842a                	mv	s0,a0
ffffffffc0201d8a:	e3d9                	bnez	a5,ffffffffc0201e10 <kfree+0x96>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201d8c:	100027f3          	csrr	a5,sstatus
ffffffffc0201d90:	8b89                	andi	a5,a5,2
ffffffffc0201d92:	e7d9                	bnez	a5,ffffffffc0201e20 <kfree+0xa6>
	{
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201d94:	000a9797          	auipc	a5,0xa9
ffffffffc0201d98:	a447b783          	ld	a5,-1468(a5) # ffffffffc02aa7d8 <bigblocks>
    return 0;
ffffffffc0201d9c:	4601                	li	a2,0
ffffffffc0201d9e:	cbad                	beqz	a5,ffffffffc0201e10 <kfree+0x96>
	bigblock_t *bb, **last = &bigblocks;
ffffffffc0201da0:	000a9697          	auipc	a3,0xa9
ffffffffc0201da4:	a3868693          	addi	a3,a3,-1480 # ffffffffc02aa7d8 <bigblocks>
ffffffffc0201da8:	a021                	j	ffffffffc0201db0 <kfree+0x36>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201daa:	01048693          	addi	a3,s1,16
ffffffffc0201dae:	c3a5                	beqz	a5,ffffffffc0201e0e <kfree+0x94>
		{
			if (bb->pages == block)
ffffffffc0201db0:	6798                	ld	a4,8(a5)
ffffffffc0201db2:	84be                	mv	s1,a5
			{
				*last = bb->next;
ffffffffc0201db4:	6b9c                	ld	a5,16(a5)
			if (bb->pages == block)
ffffffffc0201db6:	fe871ae3          	bne	a4,s0,ffffffffc0201daa <kfree+0x30>
				*last = bb->next;
ffffffffc0201dba:	e29c                	sd	a5,0(a3)
    if (flag)
ffffffffc0201dbc:	ee2d                	bnez	a2,ffffffffc0201e36 <kfree+0xbc>
    return pa2page(PADDR(kva));
ffffffffc0201dbe:	c02007b7          	lui	a5,0xc0200
				spin_unlock_irqrestore(&block_lock, flags);
				__slob_free_pages((unsigned long)block, bb->order);
ffffffffc0201dc2:	4098                	lw	a4,0(s1)
ffffffffc0201dc4:	08f46963          	bltu	s0,a5,ffffffffc0201e56 <kfree+0xdc>
ffffffffc0201dc8:	000a9697          	auipc	a3,0xa9
ffffffffc0201dcc:	a406b683          	ld	a3,-1472(a3) # ffffffffc02aa808 <va_pa_offset>
ffffffffc0201dd0:	8c15                	sub	s0,s0,a3
    if (PPN(pa) >= npage)
ffffffffc0201dd2:	8031                	srli	s0,s0,0xc
ffffffffc0201dd4:	000a9797          	auipc	a5,0xa9
ffffffffc0201dd8:	a1c7b783          	ld	a5,-1508(a5) # ffffffffc02aa7f0 <npage>
ffffffffc0201ddc:	06f47163          	bgeu	s0,a5,ffffffffc0201e3e <kfree+0xc4>
    return &pages[PPN(pa) - nbase];
ffffffffc0201de0:	00006517          	auipc	a0,0x6
ffffffffc0201de4:	a8853503          	ld	a0,-1400(a0) # ffffffffc0207868 <nbase>
ffffffffc0201de8:	8c09                	sub	s0,s0,a0
ffffffffc0201dea:	041a                	slli	s0,s0,0x6
	free_pages(kva2page((void *)kva), 1 << order);
ffffffffc0201dec:	000a9517          	auipc	a0,0xa9
ffffffffc0201df0:	a0c53503          	ld	a0,-1524(a0) # ffffffffc02aa7f8 <pages>
ffffffffc0201df4:	4585                	li	a1,1
ffffffffc0201df6:	9522                	add	a0,a0,s0
ffffffffc0201df8:	00e595bb          	sllw	a1,a1,a4
ffffffffc0201dfc:	0ea000ef          	jal	ra,ffffffffc0201ee6 <free_pages>
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
ffffffffc0201e00:	6442                	ld	s0,16(sp)
ffffffffc0201e02:	60e2                	ld	ra,24(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201e04:	8526                	mv	a0,s1
}
ffffffffc0201e06:	64a2                	ld	s1,8(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201e08:	45e1                	li	a1,24
}
ffffffffc0201e0a:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201e0c:	b171                	j	ffffffffc0201a98 <slob_free>
ffffffffc0201e0e:	e20d                	bnez	a2,ffffffffc0201e30 <kfree+0xb6>
ffffffffc0201e10:	ff040513          	addi	a0,s0,-16
}
ffffffffc0201e14:	6442                	ld	s0,16(sp)
ffffffffc0201e16:	60e2                	ld	ra,24(sp)
ffffffffc0201e18:	64a2                	ld	s1,8(sp)
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201e1a:	4581                	li	a1,0
}
ffffffffc0201e1c:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201e1e:	b9ad                	j	ffffffffc0201a98 <slob_free>
        intr_disable();
ffffffffc0201e20:	b95fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201e24:	000a9797          	auipc	a5,0xa9
ffffffffc0201e28:	9b47b783          	ld	a5,-1612(a5) # ffffffffc02aa7d8 <bigblocks>
        return 1;
ffffffffc0201e2c:	4605                	li	a2,1
ffffffffc0201e2e:	fbad                	bnez	a5,ffffffffc0201da0 <kfree+0x26>
        intr_enable();
ffffffffc0201e30:	b7ffe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0201e34:	bff1                	j	ffffffffc0201e10 <kfree+0x96>
ffffffffc0201e36:	b79fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0201e3a:	b751                	j	ffffffffc0201dbe <kfree+0x44>
ffffffffc0201e3c:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc0201e3e:	00005617          	auipc	a2,0x5
ffffffffc0201e42:	80a60613          	addi	a2,a2,-2038 # ffffffffc0206648 <default_pmm_manager+0x108>
ffffffffc0201e46:	06900593          	li	a1,105
ffffffffc0201e4a:	00004517          	auipc	a0,0x4
ffffffffc0201e4e:	75650513          	addi	a0,a0,1878 # ffffffffc02065a0 <default_pmm_manager+0x60>
ffffffffc0201e52:	e3cfe0ef          	jal	ra,ffffffffc020048e <__panic>
    return pa2page(PADDR(kva));
ffffffffc0201e56:	86a2                	mv	a3,s0
ffffffffc0201e58:	00004617          	auipc	a2,0x4
ffffffffc0201e5c:	7c860613          	addi	a2,a2,1992 # ffffffffc0206620 <default_pmm_manager+0xe0>
ffffffffc0201e60:	07700593          	li	a1,119
ffffffffc0201e64:	00004517          	auipc	a0,0x4
ffffffffc0201e68:	73c50513          	addi	a0,a0,1852 # ffffffffc02065a0 <default_pmm_manager+0x60>
ffffffffc0201e6c:	e22fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201e70 <pa2page.part.0>:
pa2page(uintptr_t pa)
ffffffffc0201e70:	1141                	addi	sp,sp,-16
        panic("pa2page called with invalid pa");
ffffffffc0201e72:	00004617          	auipc	a2,0x4
ffffffffc0201e76:	7d660613          	addi	a2,a2,2006 # ffffffffc0206648 <default_pmm_manager+0x108>
ffffffffc0201e7a:	06900593          	li	a1,105
ffffffffc0201e7e:	00004517          	auipc	a0,0x4
ffffffffc0201e82:	72250513          	addi	a0,a0,1826 # ffffffffc02065a0 <default_pmm_manager+0x60>
pa2page(uintptr_t pa)
ffffffffc0201e86:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc0201e88:	e06fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201e8c <pte2page.part.0>:
pte2page(pte_t pte)
ffffffffc0201e8c:	1141                	addi	sp,sp,-16
        panic("pte2page called with invalid pte");
ffffffffc0201e8e:	00004617          	auipc	a2,0x4
ffffffffc0201e92:	7da60613          	addi	a2,a2,2010 # ffffffffc0206668 <default_pmm_manager+0x128>
ffffffffc0201e96:	07f00593          	li	a1,127
ffffffffc0201e9a:	00004517          	auipc	a0,0x4
ffffffffc0201e9e:	70650513          	addi	a0,a0,1798 # ffffffffc02065a0 <default_pmm_manager+0x60>
pte2page(pte_t pte)
ffffffffc0201ea2:	e406                	sd	ra,8(sp)
        panic("pte2page called with invalid pte");
ffffffffc0201ea4:	deafe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201ea8 <alloc_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201ea8:	100027f3          	csrr	a5,sstatus
ffffffffc0201eac:	8b89                	andi	a5,a5,2
ffffffffc0201eae:	e799                	bnez	a5,ffffffffc0201ebc <alloc_pages+0x14>
{
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc0201eb0:	000a9797          	auipc	a5,0xa9
ffffffffc0201eb4:	9507b783          	ld	a5,-1712(a5) # ffffffffc02aa800 <pmm_manager>
ffffffffc0201eb8:	6f9c                	ld	a5,24(a5)
ffffffffc0201eba:	8782                	jr	a5
{
ffffffffc0201ebc:	1141                	addi	sp,sp,-16
ffffffffc0201ebe:	e406                	sd	ra,8(sp)
ffffffffc0201ec0:	e022                	sd	s0,0(sp)
ffffffffc0201ec2:	842a                	mv	s0,a0
        intr_disable();
ffffffffc0201ec4:	af1fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201ec8:	000a9797          	auipc	a5,0xa9
ffffffffc0201ecc:	9387b783          	ld	a5,-1736(a5) # ffffffffc02aa800 <pmm_manager>
ffffffffc0201ed0:	6f9c                	ld	a5,24(a5)
ffffffffc0201ed2:	8522                	mv	a0,s0
ffffffffc0201ed4:	9782                	jalr	a5
ffffffffc0201ed6:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201ed8:	ad7fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc0201edc:	60a2                	ld	ra,8(sp)
ffffffffc0201ede:	8522                	mv	a0,s0
ffffffffc0201ee0:	6402                	ld	s0,0(sp)
ffffffffc0201ee2:	0141                	addi	sp,sp,16
ffffffffc0201ee4:	8082                	ret

ffffffffc0201ee6 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201ee6:	100027f3          	csrr	a5,sstatus
ffffffffc0201eea:	8b89                	andi	a5,a5,2
ffffffffc0201eec:	e799                	bnez	a5,ffffffffc0201efa <free_pages+0x14>
void free_pages(struct Page *base, size_t n)
{
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc0201eee:	000a9797          	auipc	a5,0xa9
ffffffffc0201ef2:	9127b783          	ld	a5,-1774(a5) # ffffffffc02aa800 <pmm_manager>
ffffffffc0201ef6:	739c                	ld	a5,32(a5)
ffffffffc0201ef8:	8782                	jr	a5
{
ffffffffc0201efa:	1101                	addi	sp,sp,-32
ffffffffc0201efc:	ec06                	sd	ra,24(sp)
ffffffffc0201efe:	e822                	sd	s0,16(sp)
ffffffffc0201f00:	e426                	sd	s1,8(sp)
ffffffffc0201f02:	842a                	mv	s0,a0
ffffffffc0201f04:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc0201f06:	aaffe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0201f0a:	000a9797          	auipc	a5,0xa9
ffffffffc0201f0e:	8f67b783          	ld	a5,-1802(a5) # ffffffffc02aa800 <pmm_manager>
ffffffffc0201f12:	739c                	ld	a5,32(a5)
ffffffffc0201f14:	85a6                	mv	a1,s1
ffffffffc0201f16:	8522                	mv	a0,s0
ffffffffc0201f18:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc0201f1a:	6442                	ld	s0,16(sp)
ffffffffc0201f1c:	60e2                	ld	ra,24(sp)
ffffffffc0201f1e:	64a2                	ld	s1,8(sp)
ffffffffc0201f20:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0201f22:	a8dfe06f          	j	ffffffffc02009ae <intr_enable>

ffffffffc0201f26 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201f26:	100027f3          	csrr	a5,sstatus
ffffffffc0201f2a:	8b89                	andi	a5,a5,2
ffffffffc0201f2c:	e799                	bnez	a5,ffffffffc0201f3a <nr_free_pages+0x14>
{
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc0201f2e:	000a9797          	auipc	a5,0xa9
ffffffffc0201f32:	8d27b783          	ld	a5,-1838(a5) # ffffffffc02aa800 <pmm_manager>
ffffffffc0201f36:	779c                	ld	a5,40(a5)
ffffffffc0201f38:	8782                	jr	a5
{
ffffffffc0201f3a:	1141                	addi	sp,sp,-16
ffffffffc0201f3c:	e406                	sd	ra,8(sp)
ffffffffc0201f3e:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc0201f40:	a75fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0201f44:	000a9797          	auipc	a5,0xa9
ffffffffc0201f48:	8bc7b783          	ld	a5,-1860(a5) # ffffffffc02aa800 <pmm_manager>
ffffffffc0201f4c:	779c                	ld	a5,40(a5)
ffffffffc0201f4e:	9782                	jalr	a5
ffffffffc0201f50:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201f52:	a5dfe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0201f56:	60a2                	ld	ra,8(sp)
ffffffffc0201f58:	8522                	mv	a0,s0
ffffffffc0201f5a:	6402                	ld	s0,0(sp)
ffffffffc0201f5c:	0141                	addi	sp,sp,16
ffffffffc0201f5e:	8082                	ret

ffffffffc0201f60 <get_pte>:
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create)
{
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201f60:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0201f64:	1ff7f793          	andi	a5,a5,511
{
ffffffffc0201f68:	7139                	addi	sp,sp,-64
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201f6a:	078e                	slli	a5,a5,0x3
{
ffffffffc0201f6c:	f426                	sd	s1,40(sp)
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201f6e:	00f504b3          	add	s1,a0,a5
    if (!(*pdep1 & PTE_V))
ffffffffc0201f72:	6094                	ld	a3,0(s1)
{
ffffffffc0201f74:	f04a                	sd	s2,32(sp)
ffffffffc0201f76:	ec4e                	sd	s3,24(sp)
ffffffffc0201f78:	e852                	sd	s4,16(sp)
ffffffffc0201f7a:	fc06                	sd	ra,56(sp)
ffffffffc0201f7c:	f822                	sd	s0,48(sp)
ffffffffc0201f7e:	e456                	sd	s5,8(sp)
ffffffffc0201f80:	e05a                	sd	s6,0(sp)
    if (!(*pdep1 & PTE_V))
ffffffffc0201f82:	0016f793          	andi	a5,a3,1
{
ffffffffc0201f86:	892e                	mv	s2,a1
ffffffffc0201f88:	8a32                	mv	s4,a2
ffffffffc0201f8a:	000a9997          	auipc	s3,0xa9
ffffffffc0201f8e:	86698993          	addi	s3,s3,-1946 # ffffffffc02aa7f0 <npage>
    if (!(*pdep1 & PTE_V))
ffffffffc0201f92:	efbd                	bnez	a5,ffffffffc0202010 <get_pte+0xb0>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201f94:	14060c63          	beqz	a2,ffffffffc02020ec <get_pte+0x18c>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201f98:	100027f3          	csrr	a5,sstatus
ffffffffc0201f9c:	8b89                	andi	a5,a5,2
ffffffffc0201f9e:	14079963          	bnez	a5,ffffffffc02020f0 <get_pte+0x190>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201fa2:	000a9797          	auipc	a5,0xa9
ffffffffc0201fa6:	85e7b783          	ld	a5,-1954(a5) # ffffffffc02aa800 <pmm_manager>
ffffffffc0201faa:	6f9c                	ld	a5,24(a5)
ffffffffc0201fac:	4505                	li	a0,1
ffffffffc0201fae:	9782                	jalr	a5
ffffffffc0201fb0:	842a                	mv	s0,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201fb2:	12040d63          	beqz	s0,ffffffffc02020ec <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc0201fb6:	000a9b17          	auipc	s6,0xa9
ffffffffc0201fba:	842b0b13          	addi	s6,s6,-1982 # ffffffffc02aa7f8 <pages>
ffffffffc0201fbe:	000b3503          	ld	a0,0(s6)
ffffffffc0201fc2:	00080ab7          	lui	s5,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201fc6:	000a9997          	auipc	s3,0xa9
ffffffffc0201fca:	82a98993          	addi	s3,s3,-2006 # ffffffffc02aa7f0 <npage>
ffffffffc0201fce:	40a40533          	sub	a0,s0,a0
ffffffffc0201fd2:	8519                	srai	a0,a0,0x6
ffffffffc0201fd4:	9556                	add	a0,a0,s5
ffffffffc0201fd6:	0009b703          	ld	a4,0(s3)
ffffffffc0201fda:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc0201fde:	4685                	li	a3,1
ffffffffc0201fe0:	c014                	sw	a3,0(s0)
ffffffffc0201fe2:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0201fe4:	0532                	slli	a0,a0,0xc
ffffffffc0201fe6:	16e7f763          	bgeu	a5,a4,ffffffffc0202154 <get_pte+0x1f4>
ffffffffc0201fea:	000a9797          	auipc	a5,0xa9
ffffffffc0201fee:	81e7b783          	ld	a5,-2018(a5) # ffffffffc02aa808 <va_pa_offset>
ffffffffc0201ff2:	6605                	lui	a2,0x1
ffffffffc0201ff4:	4581                	li	a1,0
ffffffffc0201ff6:	953e                	add	a0,a0,a5
ffffffffc0201ff8:	6da030ef          	jal	ra,ffffffffc02056d2 <memset>
    return page - pages + nbase;
ffffffffc0201ffc:	000b3683          	ld	a3,0(s6)
ffffffffc0202000:	40d406b3          	sub	a3,s0,a3
ffffffffc0202004:	8699                	srai	a3,a3,0x6
ffffffffc0202006:	96d6                	add	a3,a3,s5
}

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type)
{
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202008:	06aa                	slli	a3,a3,0xa
ffffffffc020200a:	0116e693          	ori	a3,a3,17
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc020200e:	e094                	sd	a3,0(s1)
    }

    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0202010:	77fd                	lui	a5,0xfffff
ffffffffc0202012:	068a                	slli	a3,a3,0x2
ffffffffc0202014:	0009b703          	ld	a4,0(s3)
ffffffffc0202018:	8efd                	and	a3,a3,a5
ffffffffc020201a:	00c6d793          	srli	a5,a3,0xc
ffffffffc020201e:	10e7ff63          	bgeu	a5,a4,ffffffffc020213c <get_pte+0x1dc>
ffffffffc0202022:	000a8a97          	auipc	s5,0xa8
ffffffffc0202026:	7e6a8a93          	addi	s5,s5,2022 # ffffffffc02aa808 <va_pa_offset>
ffffffffc020202a:	000ab403          	ld	s0,0(s5)
ffffffffc020202e:	01595793          	srli	a5,s2,0x15
ffffffffc0202032:	1ff7f793          	andi	a5,a5,511
ffffffffc0202036:	96a2                	add	a3,a3,s0
ffffffffc0202038:	00379413          	slli	s0,a5,0x3
ffffffffc020203c:	9436                	add	s0,s0,a3
    if (!(*pdep0 & PTE_V))
ffffffffc020203e:	6014                	ld	a3,0(s0)
ffffffffc0202040:	0016f793          	andi	a5,a3,1
ffffffffc0202044:	ebad                	bnez	a5,ffffffffc02020b6 <get_pte+0x156>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0202046:	0a0a0363          	beqz	s4,ffffffffc02020ec <get_pte+0x18c>
ffffffffc020204a:	100027f3          	csrr	a5,sstatus
ffffffffc020204e:	8b89                	andi	a5,a5,2
ffffffffc0202050:	efcd                	bnez	a5,ffffffffc020210a <get_pte+0x1aa>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202052:	000a8797          	auipc	a5,0xa8
ffffffffc0202056:	7ae7b783          	ld	a5,1966(a5) # ffffffffc02aa800 <pmm_manager>
ffffffffc020205a:	6f9c                	ld	a5,24(a5)
ffffffffc020205c:	4505                	li	a0,1
ffffffffc020205e:	9782                	jalr	a5
ffffffffc0202060:	84aa                	mv	s1,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0202062:	c4c9                	beqz	s1,ffffffffc02020ec <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc0202064:	000a8b17          	auipc	s6,0xa8
ffffffffc0202068:	794b0b13          	addi	s6,s6,1940 # ffffffffc02aa7f8 <pages>
ffffffffc020206c:	000b3503          	ld	a0,0(s6)
ffffffffc0202070:	00080a37          	lui	s4,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202074:	0009b703          	ld	a4,0(s3)
ffffffffc0202078:	40a48533          	sub	a0,s1,a0
ffffffffc020207c:	8519                	srai	a0,a0,0x6
ffffffffc020207e:	9552                	add	a0,a0,s4
ffffffffc0202080:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc0202084:	4685                	li	a3,1
ffffffffc0202086:	c094                	sw	a3,0(s1)
ffffffffc0202088:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc020208a:	0532                	slli	a0,a0,0xc
ffffffffc020208c:	0ee7f163          	bgeu	a5,a4,ffffffffc020216e <get_pte+0x20e>
ffffffffc0202090:	000ab783          	ld	a5,0(s5)
ffffffffc0202094:	6605                	lui	a2,0x1
ffffffffc0202096:	4581                	li	a1,0
ffffffffc0202098:	953e                	add	a0,a0,a5
ffffffffc020209a:	638030ef          	jal	ra,ffffffffc02056d2 <memset>
    return page - pages + nbase;
ffffffffc020209e:	000b3683          	ld	a3,0(s6)
ffffffffc02020a2:	40d486b3          	sub	a3,s1,a3
ffffffffc02020a6:	8699                	srai	a3,a3,0x6
ffffffffc02020a8:	96d2                	add	a3,a3,s4
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc02020aa:	06aa                	slli	a3,a3,0xa
ffffffffc02020ac:	0116e693          	ori	a3,a3,17
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc02020b0:	e014                	sd	a3,0(s0)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc02020b2:	0009b703          	ld	a4,0(s3)
ffffffffc02020b6:	068a                	slli	a3,a3,0x2
ffffffffc02020b8:	757d                	lui	a0,0xfffff
ffffffffc02020ba:	8ee9                	and	a3,a3,a0
ffffffffc02020bc:	00c6d793          	srli	a5,a3,0xc
ffffffffc02020c0:	06e7f263          	bgeu	a5,a4,ffffffffc0202124 <get_pte+0x1c4>
ffffffffc02020c4:	000ab503          	ld	a0,0(s5)
ffffffffc02020c8:	00c95913          	srli	s2,s2,0xc
ffffffffc02020cc:	1ff97913          	andi	s2,s2,511
ffffffffc02020d0:	96aa                	add	a3,a3,a0
ffffffffc02020d2:	00391513          	slli	a0,s2,0x3
ffffffffc02020d6:	9536                	add	a0,a0,a3
}
ffffffffc02020d8:	70e2                	ld	ra,56(sp)
ffffffffc02020da:	7442                	ld	s0,48(sp)
ffffffffc02020dc:	74a2                	ld	s1,40(sp)
ffffffffc02020de:	7902                	ld	s2,32(sp)
ffffffffc02020e0:	69e2                	ld	s3,24(sp)
ffffffffc02020e2:	6a42                	ld	s4,16(sp)
ffffffffc02020e4:	6aa2                	ld	s5,8(sp)
ffffffffc02020e6:	6b02                	ld	s6,0(sp)
ffffffffc02020e8:	6121                	addi	sp,sp,64
ffffffffc02020ea:	8082                	ret
            return NULL;
ffffffffc02020ec:	4501                	li	a0,0
ffffffffc02020ee:	b7ed                	j	ffffffffc02020d8 <get_pte+0x178>
        intr_disable();
ffffffffc02020f0:	8c5fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc02020f4:	000a8797          	auipc	a5,0xa8
ffffffffc02020f8:	70c7b783          	ld	a5,1804(a5) # ffffffffc02aa800 <pmm_manager>
ffffffffc02020fc:	6f9c                	ld	a5,24(a5)
ffffffffc02020fe:	4505                	li	a0,1
ffffffffc0202100:	9782                	jalr	a5
ffffffffc0202102:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202104:	8abfe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202108:	b56d                	j	ffffffffc0201fb2 <get_pte+0x52>
        intr_disable();
ffffffffc020210a:	8abfe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc020210e:	000a8797          	auipc	a5,0xa8
ffffffffc0202112:	6f27b783          	ld	a5,1778(a5) # ffffffffc02aa800 <pmm_manager>
ffffffffc0202116:	6f9c                	ld	a5,24(a5)
ffffffffc0202118:	4505                	li	a0,1
ffffffffc020211a:	9782                	jalr	a5
ffffffffc020211c:	84aa                	mv	s1,a0
        intr_enable();
ffffffffc020211e:	891fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202122:	b781                	j	ffffffffc0202062 <get_pte+0x102>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0202124:	00004617          	auipc	a2,0x4
ffffffffc0202128:	45460613          	addi	a2,a2,1108 # ffffffffc0206578 <default_pmm_manager+0x38>
ffffffffc020212c:	0fa00593          	li	a1,250
ffffffffc0202130:	00004517          	auipc	a0,0x4
ffffffffc0202134:	56050513          	addi	a0,a0,1376 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc0202138:	b56fe0ef          	jal	ra,ffffffffc020048e <__panic>
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc020213c:	00004617          	auipc	a2,0x4
ffffffffc0202140:	43c60613          	addi	a2,a2,1084 # ffffffffc0206578 <default_pmm_manager+0x38>
ffffffffc0202144:	0ed00593          	li	a1,237
ffffffffc0202148:	00004517          	auipc	a0,0x4
ffffffffc020214c:	54850513          	addi	a0,a0,1352 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc0202150:	b3efe0ef          	jal	ra,ffffffffc020048e <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202154:	86aa                	mv	a3,a0
ffffffffc0202156:	00004617          	auipc	a2,0x4
ffffffffc020215a:	42260613          	addi	a2,a2,1058 # ffffffffc0206578 <default_pmm_manager+0x38>
ffffffffc020215e:	0e900593          	li	a1,233
ffffffffc0202162:	00004517          	auipc	a0,0x4
ffffffffc0202166:	52e50513          	addi	a0,a0,1326 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc020216a:	b24fe0ef          	jal	ra,ffffffffc020048e <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc020216e:	86aa                	mv	a3,a0
ffffffffc0202170:	00004617          	auipc	a2,0x4
ffffffffc0202174:	40860613          	addi	a2,a2,1032 # ffffffffc0206578 <default_pmm_manager+0x38>
ffffffffc0202178:	0f700593          	li	a1,247
ffffffffc020217c:	00004517          	auipc	a0,0x4
ffffffffc0202180:	51450513          	addi	a0,a0,1300 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc0202184:	b0afe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0202188 <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store)
{
ffffffffc0202188:	1141                	addi	sp,sp,-16
ffffffffc020218a:	e022                	sd	s0,0(sp)
ffffffffc020218c:	8432                	mv	s0,a2
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc020218e:	4601                	li	a2,0
{
ffffffffc0202190:	e406                	sd	ra,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202192:	dcfff0ef          	jal	ra,ffffffffc0201f60 <get_pte>
    if (ptep_store != NULL)
ffffffffc0202196:	c011                	beqz	s0,ffffffffc020219a <get_page+0x12>
    {
        *ptep_store = ptep;
ffffffffc0202198:	e008                	sd	a0,0(s0)
    }
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc020219a:	c511                	beqz	a0,ffffffffc02021a6 <get_page+0x1e>
ffffffffc020219c:	611c                	ld	a5,0(a0)
    {
        return pte2page(*ptep);
    }
    return NULL;
ffffffffc020219e:	4501                	li	a0,0
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc02021a0:	0017f713          	andi	a4,a5,1
ffffffffc02021a4:	e709                	bnez	a4,ffffffffc02021ae <get_page+0x26>
}
ffffffffc02021a6:	60a2                	ld	ra,8(sp)
ffffffffc02021a8:	6402                	ld	s0,0(sp)
ffffffffc02021aa:	0141                	addi	sp,sp,16
ffffffffc02021ac:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc02021ae:	078a                	slli	a5,a5,0x2
ffffffffc02021b0:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02021b2:	000a8717          	auipc	a4,0xa8
ffffffffc02021b6:	63e73703          	ld	a4,1598(a4) # ffffffffc02aa7f0 <npage>
ffffffffc02021ba:	00e7ff63          	bgeu	a5,a4,ffffffffc02021d8 <get_page+0x50>
ffffffffc02021be:	60a2                	ld	ra,8(sp)
ffffffffc02021c0:	6402                	ld	s0,0(sp)
    return &pages[PPN(pa) - nbase];
ffffffffc02021c2:	fff80537          	lui	a0,0xfff80
ffffffffc02021c6:	97aa                	add	a5,a5,a0
ffffffffc02021c8:	079a                	slli	a5,a5,0x6
ffffffffc02021ca:	000a8517          	auipc	a0,0xa8
ffffffffc02021ce:	62e53503          	ld	a0,1582(a0) # ffffffffc02aa7f8 <pages>
ffffffffc02021d2:	953e                	add	a0,a0,a5
ffffffffc02021d4:	0141                	addi	sp,sp,16
ffffffffc02021d6:	8082                	ret
ffffffffc02021d8:	c99ff0ef          	jal	ra,ffffffffc0201e70 <pa2page.part.0>

ffffffffc02021dc <unmap_range>:
        tlb_invalidate(pgdir, la);
    }
}

void unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end)
{
ffffffffc02021dc:	7159                	addi	sp,sp,-112
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02021de:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc02021e2:	f486                	sd	ra,104(sp)
ffffffffc02021e4:	f0a2                	sd	s0,96(sp)
ffffffffc02021e6:	eca6                	sd	s1,88(sp)
ffffffffc02021e8:	e8ca                	sd	s2,80(sp)
ffffffffc02021ea:	e4ce                	sd	s3,72(sp)
ffffffffc02021ec:	e0d2                	sd	s4,64(sp)
ffffffffc02021ee:	fc56                	sd	s5,56(sp)
ffffffffc02021f0:	f85a                	sd	s6,48(sp)
ffffffffc02021f2:	f45e                	sd	s7,40(sp)
ffffffffc02021f4:	f062                	sd	s8,32(sp)
ffffffffc02021f6:	ec66                	sd	s9,24(sp)
ffffffffc02021f8:	e86a                	sd	s10,16(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02021fa:	17d2                	slli	a5,a5,0x34
ffffffffc02021fc:	e3ed                	bnez	a5,ffffffffc02022de <unmap_range+0x102>
    assert(USER_ACCESS(start, end));
ffffffffc02021fe:	002007b7          	lui	a5,0x200
ffffffffc0202202:	842e                	mv	s0,a1
ffffffffc0202204:	0ef5ed63          	bltu	a1,a5,ffffffffc02022fe <unmap_range+0x122>
ffffffffc0202208:	8932                	mv	s2,a2
ffffffffc020220a:	0ec5fa63          	bgeu	a1,a2,ffffffffc02022fe <unmap_range+0x122>
ffffffffc020220e:	4785                	li	a5,1
ffffffffc0202210:	07fe                	slli	a5,a5,0x1f
ffffffffc0202212:	0ec7e663          	bltu	a5,a2,ffffffffc02022fe <unmap_range+0x122>
ffffffffc0202216:	89aa                	mv	s3,a0
        }
        if (*ptep != 0)
        {
            page_remove_pte(pgdir, start, ptep);
        }
        start += PGSIZE;
ffffffffc0202218:	6a05                	lui	s4,0x1
    if (PPN(pa) >= npage)
ffffffffc020221a:	000a8c97          	auipc	s9,0xa8
ffffffffc020221e:	5d6c8c93          	addi	s9,s9,1494 # ffffffffc02aa7f0 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc0202222:	000a8c17          	auipc	s8,0xa8
ffffffffc0202226:	5d6c0c13          	addi	s8,s8,1494 # ffffffffc02aa7f8 <pages>
ffffffffc020222a:	fff80bb7          	lui	s7,0xfff80
        pmm_manager->free_pages(base, n);
ffffffffc020222e:	000a8d17          	auipc	s10,0xa8
ffffffffc0202232:	5d2d0d13          	addi	s10,s10,1490 # ffffffffc02aa800 <pmm_manager>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0202236:	00200b37          	lui	s6,0x200
ffffffffc020223a:	ffe00ab7          	lui	s5,0xffe00
        pte_t *ptep = get_pte(pgdir, start, 0);
ffffffffc020223e:	4601                	li	a2,0
ffffffffc0202240:	85a2                	mv	a1,s0
ffffffffc0202242:	854e                	mv	a0,s3
ffffffffc0202244:	d1dff0ef          	jal	ra,ffffffffc0201f60 <get_pte>
ffffffffc0202248:	84aa                	mv	s1,a0
        if (ptep == NULL)
ffffffffc020224a:	cd29                	beqz	a0,ffffffffc02022a4 <unmap_range+0xc8>
        if (*ptep != 0)
ffffffffc020224c:	611c                	ld	a5,0(a0)
ffffffffc020224e:	e395                	bnez	a5,ffffffffc0202272 <unmap_range+0x96>
        start += PGSIZE;
ffffffffc0202250:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc0202252:	ff2466e3          	bltu	s0,s2,ffffffffc020223e <unmap_range+0x62>
}
ffffffffc0202256:	70a6                	ld	ra,104(sp)
ffffffffc0202258:	7406                	ld	s0,96(sp)
ffffffffc020225a:	64e6                	ld	s1,88(sp)
ffffffffc020225c:	6946                	ld	s2,80(sp)
ffffffffc020225e:	69a6                	ld	s3,72(sp)
ffffffffc0202260:	6a06                	ld	s4,64(sp)
ffffffffc0202262:	7ae2                	ld	s5,56(sp)
ffffffffc0202264:	7b42                	ld	s6,48(sp)
ffffffffc0202266:	7ba2                	ld	s7,40(sp)
ffffffffc0202268:	7c02                	ld	s8,32(sp)
ffffffffc020226a:	6ce2                	ld	s9,24(sp)
ffffffffc020226c:	6d42                	ld	s10,16(sp)
ffffffffc020226e:	6165                	addi	sp,sp,112
ffffffffc0202270:	8082                	ret
    if (*ptep & PTE_V)
ffffffffc0202272:	0017f713          	andi	a4,a5,1
ffffffffc0202276:	df69                	beqz	a4,ffffffffc0202250 <unmap_range+0x74>
    if (PPN(pa) >= npage)
ffffffffc0202278:	000cb703          	ld	a4,0(s9)
    return pa2page(PTE_ADDR(pte));
ffffffffc020227c:	078a                	slli	a5,a5,0x2
ffffffffc020227e:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202280:	08e7ff63          	bgeu	a5,a4,ffffffffc020231e <unmap_range+0x142>
    return &pages[PPN(pa) - nbase];
ffffffffc0202284:	000c3503          	ld	a0,0(s8)
ffffffffc0202288:	97de                	add	a5,a5,s7
ffffffffc020228a:	079a                	slli	a5,a5,0x6
ffffffffc020228c:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc020228e:	411c                	lw	a5,0(a0)
ffffffffc0202290:	fff7871b          	addiw	a4,a5,-1
ffffffffc0202294:	c118                	sw	a4,0(a0)
        if (page_ref(page) == 0)
ffffffffc0202296:	cf11                	beqz	a4,ffffffffc02022b2 <unmap_range+0xd6>
        *ptep = 0;
ffffffffc0202298:	0004b023          	sd	zero,0(s1)

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la)
{
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020229c:	12040073          	sfence.vma	s0
        start += PGSIZE;
ffffffffc02022a0:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc02022a2:	bf45                	j	ffffffffc0202252 <unmap_range+0x76>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc02022a4:	945a                	add	s0,s0,s6
ffffffffc02022a6:	01547433          	and	s0,s0,s5
    } while (start != 0 && start < end);
ffffffffc02022aa:	d455                	beqz	s0,ffffffffc0202256 <unmap_range+0x7a>
ffffffffc02022ac:	f92469e3          	bltu	s0,s2,ffffffffc020223e <unmap_range+0x62>
ffffffffc02022b0:	b75d                	j	ffffffffc0202256 <unmap_range+0x7a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02022b2:	100027f3          	csrr	a5,sstatus
ffffffffc02022b6:	8b89                	andi	a5,a5,2
ffffffffc02022b8:	e799                	bnez	a5,ffffffffc02022c6 <unmap_range+0xea>
        pmm_manager->free_pages(base, n);
ffffffffc02022ba:	000d3783          	ld	a5,0(s10)
ffffffffc02022be:	4585                	li	a1,1
ffffffffc02022c0:	739c                	ld	a5,32(a5)
ffffffffc02022c2:	9782                	jalr	a5
    if (flag)
ffffffffc02022c4:	bfd1                	j	ffffffffc0202298 <unmap_range+0xbc>
ffffffffc02022c6:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02022c8:	eecfe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc02022cc:	000d3783          	ld	a5,0(s10)
ffffffffc02022d0:	6522                	ld	a0,8(sp)
ffffffffc02022d2:	4585                	li	a1,1
ffffffffc02022d4:	739c                	ld	a5,32(a5)
ffffffffc02022d6:	9782                	jalr	a5
        intr_enable();
ffffffffc02022d8:	ed6fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02022dc:	bf75                	j	ffffffffc0202298 <unmap_range+0xbc>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02022de:	00004697          	auipc	a3,0x4
ffffffffc02022e2:	3c268693          	addi	a3,a3,962 # ffffffffc02066a0 <default_pmm_manager+0x160>
ffffffffc02022e6:	00004617          	auipc	a2,0x4
ffffffffc02022ea:	eaa60613          	addi	a2,a2,-342 # ffffffffc0206190 <commands+0x828>
ffffffffc02022ee:	12000593          	li	a1,288
ffffffffc02022f2:	00004517          	auipc	a0,0x4
ffffffffc02022f6:	39e50513          	addi	a0,a0,926 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc02022fa:	994fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc02022fe:	00004697          	auipc	a3,0x4
ffffffffc0202302:	3d268693          	addi	a3,a3,978 # ffffffffc02066d0 <default_pmm_manager+0x190>
ffffffffc0202306:	00004617          	auipc	a2,0x4
ffffffffc020230a:	e8a60613          	addi	a2,a2,-374 # ffffffffc0206190 <commands+0x828>
ffffffffc020230e:	12100593          	li	a1,289
ffffffffc0202312:	00004517          	auipc	a0,0x4
ffffffffc0202316:	37e50513          	addi	a0,a0,894 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc020231a:	974fe0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc020231e:	b53ff0ef          	jal	ra,ffffffffc0201e70 <pa2page.part.0>

ffffffffc0202322 <exit_range>:
{
ffffffffc0202322:	7119                	addi	sp,sp,-128
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202324:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc0202328:	fc86                	sd	ra,120(sp)
ffffffffc020232a:	f8a2                	sd	s0,112(sp)
ffffffffc020232c:	f4a6                	sd	s1,104(sp)
ffffffffc020232e:	f0ca                	sd	s2,96(sp)
ffffffffc0202330:	ecce                	sd	s3,88(sp)
ffffffffc0202332:	e8d2                	sd	s4,80(sp)
ffffffffc0202334:	e4d6                	sd	s5,72(sp)
ffffffffc0202336:	e0da                	sd	s6,64(sp)
ffffffffc0202338:	fc5e                	sd	s7,56(sp)
ffffffffc020233a:	f862                	sd	s8,48(sp)
ffffffffc020233c:	f466                	sd	s9,40(sp)
ffffffffc020233e:	f06a                	sd	s10,32(sp)
ffffffffc0202340:	ec6e                	sd	s11,24(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202342:	17d2                	slli	a5,a5,0x34
ffffffffc0202344:	20079a63          	bnez	a5,ffffffffc0202558 <exit_range+0x236>
    assert(USER_ACCESS(start, end));
ffffffffc0202348:	002007b7          	lui	a5,0x200
ffffffffc020234c:	24f5e463          	bltu	a1,a5,ffffffffc0202594 <exit_range+0x272>
ffffffffc0202350:	8ab2                	mv	s5,a2
ffffffffc0202352:	24c5f163          	bgeu	a1,a2,ffffffffc0202594 <exit_range+0x272>
ffffffffc0202356:	4785                	li	a5,1
ffffffffc0202358:	07fe                	slli	a5,a5,0x1f
ffffffffc020235a:	22c7ed63          	bltu	a5,a2,ffffffffc0202594 <exit_range+0x272>
    d1start = ROUNDDOWN(start, PDSIZE);
ffffffffc020235e:	c00009b7          	lui	s3,0xc0000
ffffffffc0202362:	0135f9b3          	and	s3,a1,s3
    d0start = ROUNDDOWN(start, PTSIZE);
ffffffffc0202366:	ffe00937          	lui	s2,0xffe00
ffffffffc020236a:	400007b7          	lui	a5,0x40000
    return KADDR(page2pa(page));
ffffffffc020236e:	5cfd                	li	s9,-1
ffffffffc0202370:	8c2a                	mv	s8,a0
ffffffffc0202372:	0125f933          	and	s2,a1,s2
ffffffffc0202376:	99be                	add	s3,s3,a5
    if (PPN(pa) >= npage)
ffffffffc0202378:	000a8d17          	auipc	s10,0xa8
ffffffffc020237c:	478d0d13          	addi	s10,s10,1144 # ffffffffc02aa7f0 <npage>
    return KADDR(page2pa(page));
ffffffffc0202380:	00ccdc93          	srli	s9,s9,0xc
    return &pages[PPN(pa) - nbase];
ffffffffc0202384:	000a8717          	auipc	a4,0xa8
ffffffffc0202388:	47470713          	addi	a4,a4,1140 # ffffffffc02aa7f8 <pages>
        pmm_manager->free_pages(base, n);
ffffffffc020238c:	000a8d97          	auipc	s11,0xa8
ffffffffc0202390:	474d8d93          	addi	s11,s11,1140 # ffffffffc02aa800 <pmm_manager>
        pde1 = pgdir[PDX1(d1start)];
ffffffffc0202394:	c0000437          	lui	s0,0xc0000
ffffffffc0202398:	944e                	add	s0,s0,s3
ffffffffc020239a:	8079                	srli	s0,s0,0x1e
ffffffffc020239c:	1ff47413          	andi	s0,s0,511
ffffffffc02023a0:	040e                	slli	s0,s0,0x3
ffffffffc02023a2:	9462                	add	s0,s0,s8
ffffffffc02023a4:	00043a03          	ld	s4,0(s0) # ffffffffc0000000 <_binary_obj___user_exit_out_size+0xffffffffbfff4ed0>
        if (pde1 & PTE_V)
ffffffffc02023a8:	001a7793          	andi	a5,s4,1
ffffffffc02023ac:	eb99                	bnez	a5,ffffffffc02023c2 <exit_range+0xa0>
    } while (d1start != 0 && d1start < end);
ffffffffc02023ae:	12098463          	beqz	s3,ffffffffc02024d6 <exit_range+0x1b4>
ffffffffc02023b2:	400007b7          	lui	a5,0x40000
ffffffffc02023b6:	97ce                	add	a5,a5,s3
ffffffffc02023b8:	894e                	mv	s2,s3
ffffffffc02023ba:	1159fe63          	bgeu	s3,s5,ffffffffc02024d6 <exit_range+0x1b4>
ffffffffc02023be:	89be                	mv	s3,a5
ffffffffc02023c0:	bfd1                	j	ffffffffc0202394 <exit_range+0x72>
    if (PPN(pa) >= npage)
ffffffffc02023c2:	000d3783          	ld	a5,0(s10)
    return pa2page(PDE_ADDR(pde));
ffffffffc02023c6:	0a0a                	slli	s4,s4,0x2
ffffffffc02023c8:	00ca5a13          	srli	s4,s4,0xc
    if (PPN(pa) >= npage)
ffffffffc02023cc:	1cfa7263          	bgeu	s4,a5,ffffffffc0202590 <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc02023d0:	fff80637          	lui	a2,0xfff80
ffffffffc02023d4:	9652                	add	a2,a2,s4
    return page - pages + nbase;
ffffffffc02023d6:	000806b7          	lui	a3,0x80
ffffffffc02023da:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc02023dc:	0196f5b3          	and	a1,a3,s9
    return &pages[PPN(pa) - nbase];
ffffffffc02023e0:	061a                	slli	a2,a2,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc02023e2:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02023e4:	18f5fa63          	bgeu	a1,a5,ffffffffc0202578 <exit_range+0x256>
ffffffffc02023e8:	000a8817          	auipc	a6,0xa8
ffffffffc02023ec:	42080813          	addi	a6,a6,1056 # ffffffffc02aa808 <va_pa_offset>
ffffffffc02023f0:	00083b03          	ld	s6,0(a6)
            free_pd0 = 1;
ffffffffc02023f4:	4b85                	li	s7,1
    return &pages[PPN(pa) - nbase];
ffffffffc02023f6:	fff80e37          	lui	t3,0xfff80
    return KADDR(page2pa(page));
ffffffffc02023fa:	9b36                	add	s6,s6,a3
    return page - pages + nbase;
ffffffffc02023fc:	00080337          	lui	t1,0x80
ffffffffc0202400:	6885                	lui	a7,0x1
ffffffffc0202402:	a819                	j	ffffffffc0202418 <exit_range+0xf6>
                    free_pd0 = 0;
ffffffffc0202404:	4b81                	li	s7,0
                d0start += PTSIZE;
ffffffffc0202406:	002007b7          	lui	a5,0x200
ffffffffc020240a:	993e                	add	s2,s2,a5
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc020240c:	08090c63          	beqz	s2,ffffffffc02024a4 <exit_range+0x182>
ffffffffc0202410:	09397a63          	bgeu	s2,s3,ffffffffc02024a4 <exit_range+0x182>
ffffffffc0202414:	0f597063          	bgeu	s2,s5,ffffffffc02024f4 <exit_range+0x1d2>
                pde0 = pd0[PDX0(d0start)];
ffffffffc0202418:	01595493          	srli	s1,s2,0x15
ffffffffc020241c:	1ff4f493          	andi	s1,s1,511
ffffffffc0202420:	048e                	slli	s1,s1,0x3
ffffffffc0202422:	94da                	add	s1,s1,s6
ffffffffc0202424:	609c                	ld	a5,0(s1)
                if (pde0 & PTE_V)
ffffffffc0202426:	0017f693          	andi	a3,a5,1
ffffffffc020242a:	dee9                	beqz	a3,ffffffffc0202404 <exit_range+0xe2>
    if (PPN(pa) >= npage)
ffffffffc020242c:	000d3583          	ld	a1,0(s10)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202430:	078a                	slli	a5,a5,0x2
ffffffffc0202432:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202434:	14b7fe63          	bgeu	a5,a1,ffffffffc0202590 <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc0202438:	97f2                	add	a5,a5,t3
    return page - pages + nbase;
ffffffffc020243a:	006786b3          	add	a3,a5,t1
    return KADDR(page2pa(page));
ffffffffc020243e:	0196feb3          	and	t4,a3,s9
    return &pages[PPN(pa) - nbase];
ffffffffc0202442:	00679513          	slli	a0,a5,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc0202446:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202448:	12bef863          	bgeu	t4,a1,ffffffffc0202578 <exit_range+0x256>
ffffffffc020244c:	00083783          	ld	a5,0(a6)
ffffffffc0202450:	96be                	add	a3,a3,a5
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc0202452:	011685b3          	add	a1,a3,a7
                        if (pt[i] & PTE_V)
ffffffffc0202456:	629c                	ld	a5,0(a3)
ffffffffc0202458:	8b85                	andi	a5,a5,1
ffffffffc020245a:	f7d5                	bnez	a5,ffffffffc0202406 <exit_range+0xe4>
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc020245c:	06a1                	addi	a3,a3,8
ffffffffc020245e:	fed59ce3          	bne	a1,a3,ffffffffc0202456 <exit_range+0x134>
    return &pages[PPN(pa) - nbase];
ffffffffc0202462:	631c                	ld	a5,0(a4)
ffffffffc0202464:	953e                	add	a0,a0,a5
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202466:	100027f3          	csrr	a5,sstatus
ffffffffc020246a:	8b89                	andi	a5,a5,2
ffffffffc020246c:	e7d9                	bnez	a5,ffffffffc02024fa <exit_range+0x1d8>
        pmm_manager->free_pages(base, n);
ffffffffc020246e:	000db783          	ld	a5,0(s11)
ffffffffc0202472:	4585                	li	a1,1
ffffffffc0202474:	e032                	sd	a2,0(sp)
ffffffffc0202476:	739c                	ld	a5,32(a5)
ffffffffc0202478:	9782                	jalr	a5
    if (flag)
ffffffffc020247a:	6602                	ld	a2,0(sp)
ffffffffc020247c:	000a8817          	auipc	a6,0xa8
ffffffffc0202480:	38c80813          	addi	a6,a6,908 # ffffffffc02aa808 <va_pa_offset>
ffffffffc0202484:	fff80e37          	lui	t3,0xfff80
ffffffffc0202488:	00080337          	lui	t1,0x80
ffffffffc020248c:	6885                	lui	a7,0x1
ffffffffc020248e:	000a8717          	auipc	a4,0xa8
ffffffffc0202492:	36a70713          	addi	a4,a4,874 # ffffffffc02aa7f8 <pages>
                        pd0[PDX0(d0start)] = 0;
ffffffffc0202496:	0004b023          	sd	zero,0(s1)
                d0start += PTSIZE;
ffffffffc020249a:	002007b7          	lui	a5,0x200
ffffffffc020249e:	993e                	add	s2,s2,a5
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc02024a0:	f60918e3          	bnez	s2,ffffffffc0202410 <exit_range+0xee>
            if (free_pd0)
ffffffffc02024a4:	f00b85e3          	beqz	s7,ffffffffc02023ae <exit_range+0x8c>
    if (PPN(pa) >= npage)
ffffffffc02024a8:	000d3783          	ld	a5,0(s10)
ffffffffc02024ac:	0efa7263          	bgeu	s4,a5,ffffffffc0202590 <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc02024b0:	6308                	ld	a0,0(a4)
ffffffffc02024b2:	9532                	add	a0,a0,a2
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02024b4:	100027f3          	csrr	a5,sstatus
ffffffffc02024b8:	8b89                	andi	a5,a5,2
ffffffffc02024ba:	efad                	bnez	a5,ffffffffc0202534 <exit_range+0x212>
        pmm_manager->free_pages(base, n);
ffffffffc02024bc:	000db783          	ld	a5,0(s11)
ffffffffc02024c0:	4585                	li	a1,1
ffffffffc02024c2:	739c                	ld	a5,32(a5)
ffffffffc02024c4:	9782                	jalr	a5
ffffffffc02024c6:	000a8717          	auipc	a4,0xa8
ffffffffc02024ca:	33270713          	addi	a4,a4,818 # ffffffffc02aa7f8 <pages>
                pgdir[PDX1(d1start)] = 0;
ffffffffc02024ce:	00043023          	sd	zero,0(s0)
    } while (d1start != 0 && d1start < end);
ffffffffc02024d2:	ee0990e3          	bnez	s3,ffffffffc02023b2 <exit_range+0x90>
}
ffffffffc02024d6:	70e6                	ld	ra,120(sp)
ffffffffc02024d8:	7446                	ld	s0,112(sp)
ffffffffc02024da:	74a6                	ld	s1,104(sp)
ffffffffc02024dc:	7906                	ld	s2,96(sp)
ffffffffc02024de:	69e6                	ld	s3,88(sp)
ffffffffc02024e0:	6a46                	ld	s4,80(sp)
ffffffffc02024e2:	6aa6                	ld	s5,72(sp)
ffffffffc02024e4:	6b06                	ld	s6,64(sp)
ffffffffc02024e6:	7be2                	ld	s7,56(sp)
ffffffffc02024e8:	7c42                	ld	s8,48(sp)
ffffffffc02024ea:	7ca2                	ld	s9,40(sp)
ffffffffc02024ec:	7d02                	ld	s10,32(sp)
ffffffffc02024ee:	6de2                	ld	s11,24(sp)
ffffffffc02024f0:	6109                	addi	sp,sp,128
ffffffffc02024f2:	8082                	ret
            if (free_pd0)
ffffffffc02024f4:	ea0b8fe3          	beqz	s7,ffffffffc02023b2 <exit_range+0x90>
ffffffffc02024f8:	bf45                	j	ffffffffc02024a8 <exit_range+0x186>
ffffffffc02024fa:	e032                	sd	a2,0(sp)
        intr_disable();
ffffffffc02024fc:	e42a                	sd	a0,8(sp)
ffffffffc02024fe:	cb6fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202502:	000db783          	ld	a5,0(s11)
ffffffffc0202506:	6522                	ld	a0,8(sp)
ffffffffc0202508:	4585                	li	a1,1
ffffffffc020250a:	739c                	ld	a5,32(a5)
ffffffffc020250c:	9782                	jalr	a5
        intr_enable();
ffffffffc020250e:	ca0fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202512:	6602                	ld	a2,0(sp)
ffffffffc0202514:	000a8717          	auipc	a4,0xa8
ffffffffc0202518:	2e470713          	addi	a4,a4,740 # ffffffffc02aa7f8 <pages>
ffffffffc020251c:	6885                	lui	a7,0x1
ffffffffc020251e:	00080337          	lui	t1,0x80
ffffffffc0202522:	fff80e37          	lui	t3,0xfff80
ffffffffc0202526:	000a8817          	auipc	a6,0xa8
ffffffffc020252a:	2e280813          	addi	a6,a6,738 # ffffffffc02aa808 <va_pa_offset>
                        pd0[PDX0(d0start)] = 0;
ffffffffc020252e:	0004b023          	sd	zero,0(s1)
ffffffffc0202532:	b7a5                	j	ffffffffc020249a <exit_range+0x178>
ffffffffc0202534:	e02a                	sd	a0,0(sp)
        intr_disable();
ffffffffc0202536:	c7efe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc020253a:	000db783          	ld	a5,0(s11)
ffffffffc020253e:	6502                	ld	a0,0(sp)
ffffffffc0202540:	4585                	li	a1,1
ffffffffc0202542:	739c                	ld	a5,32(a5)
ffffffffc0202544:	9782                	jalr	a5
        intr_enable();
ffffffffc0202546:	c68fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc020254a:	000a8717          	auipc	a4,0xa8
ffffffffc020254e:	2ae70713          	addi	a4,a4,686 # ffffffffc02aa7f8 <pages>
                pgdir[PDX1(d1start)] = 0;
ffffffffc0202552:	00043023          	sd	zero,0(s0)
ffffffffc0202556:	bfb5                	j	ffffffffc02024d2 <exit_range+0x1b0>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202558:	00004697          	auipc	a3,0x4
ffffffffc020255c:	14868693          	addi	a3,a3,328 # ffffffffc02066a0 <default_pmm_manager+0x160>
ffffffffc0202560:	00004617          	auipc	a2,0x4
ffffffffc0202564:	c3060613          	addi	a2,a2,-976 # ffffffffc0206190 <commands+0x828>
ffffffffc0202568:	13500593          	li	a1,309
ffffffffc020256c:	00004517          	auipc	a0,0x4
ffffffffc0202570:	12450513          	addi	a0,a0,292 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc0202574:	f1bfd0ef          	jal	ra,ffffffffc020048e <__panic>
    return KADDR(page2pa(page));
ffffffffc0202578:	00004617          	auipc	a2,0x4
ffffffffc020257c:	00060613          	mv	a2,a2
ffffffffc0202580:	07100593          	li	a1,113
ffffffffc0202584:	00004517          	auipc	a0,0x4
ffffffffc0202588:	01c50513          	addi	a0,a0,28 # ffffffffc02065a0 <default_pmm_manager+0x60>
ffffffffc020258c:	f03fd0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc0202590:	8e1ff0ef          	jal	ra,ffffffffc0201e70 <pa2page.part.0>
    assert(USER_ACCESS(start, end));
ffffffffc0202594:	00004697          	auipc	a3,0x4
ffffffffc0202598:	13c68693          	addi	a3,a3,316 # ffffffffc02066d0 <default_pmm_manager+0x190>
ffffffffc020259c:	00004617          	auipc	a2,0x4
ffffffffc02025a0:	bf460613          	addi	a2,a2,-1036 # ffffffffc0206190 <commands+0x828>
ffffffffc02025a4:	13600593          	li	a1,310
ffffffffc02025a8:	00004517          	auipc	a0,0x4
ffffffffc02025ac:	0e850513          	addi	a0,a0,232 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc02025b0:	edffd0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02025b4 <page_remove>:
{
ffffffffc02025b4:	7179                	addi	sp,sp,-48
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02025b6:	4601                	li	a2,0
{
ffffffffc02025b8:	ec26                	sd	s1,24(sp)
ffffffffc02025ba:	f406                	sd	ra,40(sp)
ffffffffc02025bc:	f022                	sd	s0,32(sp)
ffffffffc02025be:	84ae                	mv	s1,a1
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02025c0:	9a1ff0ef          	jal	ra,ffffffffc0201f60 <get_pte>
    if (ptep != NULL)
ffffffffc02025c4:	c511                	beqz	a0,ffffffffc02025d0 <page_remove+0x1c>
    if (*ptep & PTE_V)
ffffffffc02025c6:	611c                	ld	a5,0(a0)
ffffffffc02025c8:	842a                	mv	s0,a0
ffffffffc02025ca:	0017f713          	andi	a4,a5,1
ffffffffc02025ce:	e711                	bnez	a4,ffffffffc02025da <page_remove+0x26>
}
ffffffffc02025d0:	70a2                	ld	ra,40(sp)
ffffffffc02025d2:	7402                	ld	s0,32(sp)
ffffffffc02025d4:	64e2                	ld	s1,24(sp)
ffffffffc02025d6:	6145                	addi	sp,sp,48
ffffffffc02025d8:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc02025da:	078a                	slli	a5,a5,0x2
ffffffffc02025dc:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02025de:	000a8717          	auipc	a4,0xa8
ffffffffc02025e2:	21273703          	ld	a4,530(a4) # ffffffffc02aa7f0 <npage>
ffffffffc02025e6:	06e7f363          	bgeu	a5,a4,ffffffffc020264c <page_remove+0x98>
    return &pages[PPN(pa) - nbase];
ffffffffc02025ea:	fff80537          	lui	a0,0xfff80
ffffffffc02025ee:	97aa                	add	a5,a5,a0
ffffffffc02025f0:	079a                	slli	a5,a5,0x6
ffffffffc02025f2:	000a8517          	auipc	a0,0xa8
ffffffffc02025f6:	20653503          	ld	a0,518(a0) # ffffffffc02aa7f8 <pages>
ffffffffc02025fa:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc02025fc:	411c                	lw	a5,0(a0)
ffffffffc02025fe:	fff7871b          	addiw	a4,a5,-1
ffffffffc0202602:	c118                	sw	a4,0(a0)
        if (page_ref(page) == 0)
ffffffffc0202604:	cb11                	beqz	a4,ffffffffc0202618 <page_remove+0x64>
        *ptep = 0;
ffffffffc0202606:	00043023          	sd	zero,0(s0)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020260a:	12048073          	sfence.vma	s1
}
ffffffffc020260e:	70a2                	ld	ra,40(sp)
ffffffffc0202610:	7402                	ld	s0,32(sp)
ffffffffc0202612:	64e2                	ld	s1,24(sp)
ffffffffc0202614:	6145                	addi	sp,sp,48
ffffffffc0202616:	8082                	ret
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202618:	100027f3          	csrr	a5,sstatus
ffffffffc020261c:	8b89                	andi	a5,a5,2
ffffffffc020261e:	eb89                	bnez	a5,ffffffffc0202630 <page_remove+0x7c>
        pmm_manager->free_pages(base, n);
ffffffffc0202620:	000a8797          	auipc	a5,0xa8
ffffffffc0202624:	1e07b783          	ld	a5,480(a5) # ffffffffc02aa800 <pmm_manager>
ffffffffc0202628:	739c                	ld	a5,32(a5)
ffffffffc020262a:	4585                	li	a1,1
ffffffffc020262c:	9782                	jalr	a5
    if (flag)
ffffffffc020262e:	bfe1                	j	ffffffffc0202606 <page_remove+0x52>
        intr_disable();
ffffffffc0202630:	e42a                	sd	a0,8(sp)
ffffffffc0202632:	b82fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202636:	000a8797          	auipc	a5,0xa8
ffffffffc020263a:	1ca7b783          	ld	a5,458(a5) # ffffffffc02aa800 <pmm_manager>
ffffffffc020263e:	739c                	ld	a5,32(a5)
ffffffffc0202640:	6522                	ld	a0,8(sp)
ffffffffc0202642:	4585                	li	a1,1
ffffffffc0202644:	9782                	jalr	a5
        intr_enable();
ffffffffc0202646:	b68fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc020264a:	bf75                	j	ffffffffc0202606 <page_remove+0x52>
ffffffffc020264c:	825ff0ef          	jal	ra,ffffffffc0201e70 <pa2page.part.0>

ffffffffc0202650 <page_insert>:
{
ffffffffc0202650:	7139                	addi	sp,sp,-64
ffffffffc0202652:	e852                	sd	s4,16(sp)
ffffffffc0202654:	8a32                	mv	s4,a2
ffffffffc0202656:	f822                	sd	s0,48(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202658:	4605                	li	a2,1
{
ffffffffc020265a:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc020265c:	85d2                	mv	a1,s4
{
ffffffffc020265e:	f426                	sd	s1,40(sp)
ffffffffc0202660:	fc06                	sd	ra,56(sp)
ffffffffc0202662:	f04a                	sd	s2,32(sp)
ffffffffc0202664:	ec4e                	sd	s3,24(sp)
ffffffffc0202666:	e456                	sd	s5,8(sp)
ffffffffc0202668:	84b6                	mv	s1,a3
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc020266a:	8f7ff0ef          	jal	ra,ffffffffc0201f60 <get_pte>
    if (ptep == NULL)
ffffffffc020266e:	c961                	beqz	a0,ffffffffc020273e <page_insert+0xee>
    page->ref += 1;
ffffffffc0202670:	4014                	lw	a3,0(s0)
    if (*ptep & PTE_V)
ffffffffc0202672:	611c                	ld	a5,0(a0)
ffffffffc0202674:	89aa                	mv	s3,a0
ffffffffc0202676:	0016871b          	addiw	a4,a3,1
ffffffffc020267a:	c018                	sw	a4,0(s0)
ffffffffc020267c:	0017f713          	andi	a4,a5,1
ffffffffc0202680:	ef05                	bnez	a4,ffffffffc02026b8 <page_insert+0x68>
    return page - pages + nbase;
ffffffffc0202682:	000a8717          	auipc	a4,0xa8
ffffffffc0202686:	17673703          	ld	a4,374(a4) # ffffffffc02aa7f8 <pages>
ffffffffc020268a:	8c19                	sub	s0,s0,a4
ffffffffc020268c:	000807b7          	lui	a5,0x80
ffffffffc0202690:	8419                	srai	s0,s0,0x6
ffffffffc0202692:	943e                	add	s0,s0,a5
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202694:	042a                	slli	s0,s0,0xa
ffffffffc0202696:	8cc1                	or	s1,s1,s0
ffffffffc0202698:	0014e493          	ori	s1,s1,1
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc020269c:	0099b023          	sd	s1,0(s3) # ffffffffc0000000 <_binary_obj___user_exit_out_size+0xffffffffbfff4ed0>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02026a0:	120a0073          	sfence.vma	s4
    return 0;
ffffffffc02026a4:	4501                	li	a0,0
}
ffffffffc02026a6:	70e2                	ld	ra,56(sp)
ffffffffc02026a8:	7442                	ld	s0,48(sp)
ffffffffc02026aa:	74a2                	ld	s1,40(sp)
ffffffffc02026ac:	7902                	ld	s2,32(sp)
ffffffffc02026ae:	69e2                	ld	s3,24(sp)
ffffffffc02026b0:	6a42                	ld	s4,16(sp)
ffffffffc02026b2:	6aa2                	ld	s5,8(sp)
ffffffffc02026b4:	6121                	addi	sp,sp,64
ffffffffc02026b6:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc02026b8:	078a                	slli	a5,a5,0x2
ffffffffc02026ba:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02026bc:	000a8717          	auipc	a4,0xa8
ffffffffc02026c0:	13473703          	ld	a4,308(a4) # ffffffffc02aa7f0 <npage>
ffffffffc02026c4:	06e7ff63          	bgeu	a5,a4,ffffffffc0202742 <page_insert+0xf2>
    return &pages[PPN(pa) - nbase];
ffffffffc02026c8:	000a8a97          	auipc	s5,0xa8
ffffffffc02026cc:	130a8a93          	addi	s5,s5,304 # ffffffffc02aa7f8 <pages>
ffffffffc02026d0:	000ab703          	ld	a4,0(s5)
ffffffffc02026d4:	fff80937          	lui	s2,0xfff80
ffffffffc02026d8:	993e                	add	s2,s2,a5
ffffffffc02026da:	091a                	slli	s2,s2,0x6
ffffffffc02026dc:	993a                	add	s2,s2,a4
        if (p == page)
ffffffffc02026de:	01240c63          	beq	s0,s2,ffffffffc02026f6 <page_insert+0xa6>
    page->ref -= 1;
ffffffffc02026e2:	00092783          	lw	a5,0(s2) # fffffffffff80000 <end+0x3fcd57d4>
ffffffffc02026e6:	fff7869b          	addiw	a3,a5,-1
ffffffffc02026ea:	00d92023          	sw	a3,0(s2)
        if (page_ref(page) == 0)
ffffffffc02026ee:	c691                	beqz	a3,ffffffffc02026fa <page_insert+0xaa>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02026f0:	120a0073          	sfence.vma	s4
}
ffffffffc02026f4:	bf59                	j	ffffffffc020268a <page_insert+0x3a>
ffffffffc02026f6:	c014                	sw	a3,0(s0)
    return page->ref;
ffffffffc02026f8:	bf49                	j	ffffffffc020268a <page_insert+0x3a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02026fa:	100027f3          	csrr	a5,sstatus
ffffffffc02026fe:	8b89                	andi	a5,a5,2
ffffffffc0202700:	ef91                	bnez	a5,ffffffffc020271c <page_insert+0xcc>
        pmm_manager->free_pages(base, n);
ffffffffc0202702:	000a8797          	auipc	a5,0xa8
ffffffffc0202706:	0fe7b783          	ld	a5,254(a5) # ffffffffc02aa800 <pmm_manager>
ffffffffc020270a:	739c                	ld	a5,32(a5)
ffffffffc020270c:	4585                	li	a1,1
ffffffffc020270e:	854a                	mv	a0,s2
ffffffffc0202710:	9782                	jalr	a5
    return page - pages + nbase;
ffffffffc0202712:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202716:	120a0073          	sfence.vma	s4
ffffffffc020271a:	bf85                	j	ffffffffc020268a <page_insert+0x3a>
        intr_disable();
ffffffffc020271c:	a98fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202720:	000a8797          	auipc	a5,0xa8
ffffffffc0202724:	0e07b783          	ld	a5,224(a5) # ffffffffc02aa800 <pmm_manager>
ffffffffc0202728:	739c                	ld	a5,32(a5)
ffffffffc020272a:	4585                	li	a1,1
ffffffffc020272c:	854a                	mv	a0,s2
ffffffffc020272e:	9782                	jalr	a5
        intr_enable();
ffffffffc0202730:	a7efe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202734:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202738:	120a0073          	sfence.vma	s4
ffffffffc020273c:	b7b9                	j	ffffffffc020268a <page_insert+0x3a>
        return -E_NO_MEM;
ffffffffc020273e:	5571                	li	a0,-4
ffffffffc0202740:	b79d                	j	ffffffffc02026a6 <page_insert+0x56>
ffffffffc0202742:	f2eff0ef          	jal	ra,ffffffffc0201e70 <pa2page.part.0>

ffffffffc0202746 <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc0202746:	00004797          	auipc	a5,0x4
ffffffffc020274a:	dfa78793          	addi	a5,a5,-518 # ffffffffc0206540 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc020274e:	638c                	ld	a1,0(a5)
{
ffffffffc0202750:	7159                	addi	sp,sp,-112
ffffffffc0202752:	f85a                	sd	s6,48(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202754:	00004517          	auipc	a0,0x4
ffffffffc0202758:	f9450513          	addi	a0,a0,-108 # ffffffffc02066e8 <default_pmm_manager+0x1a8>
    pmm_manager = &default_pmm_manager;
ffffffffc020275c:	000a8b17          	auipc	s6,0xa8
ffffffffc0202760:	0a4b0b13          	addi	s6,s6,164 # ffffffffc02aa800 <pmm_manager>
{
ffffffffc0202764:	f486                	sd	ra,104(sp)
ffffffffc0202766:	e8ca                	sd	s2,80(sp)
ffffffffc0202768:	e4ce                	sd	s3,72(sp)
ffffffffc020276a:	f0a2                	sd	s0,96(sp)
ffffffffc020276c:	eca6                	sd	s1,88(sp)
ffffffffc020276e:	e0d2                	sd	s4,64(sp)
ffffffffc0202770:	fc56                	sd	s5,56(sp)
ffffffffc0202772:	f45e                	sd	s7,40(sp)
ffffffffc0202774:	f062                	sd	s8,32(sp)
ffffffffc0202776:	ec66                	sd	s9,24(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc0202778:	00fb3023          	sd	a5,0(s6)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc020277c:	a19fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    pmm_manager->init();
ffffffffc0202780:	000b3783          	ld	a5,0(s6)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0202784:	000a8997          	auipc	s3,0xa8
ffffffffc0202788:	08498993          	addi	s3,s3,132 # ffffffffc02aa808 <va_pa_offset>
    pmm_manager->init();
ffffffffc020278c:	679c                	ld	a5,8(a5)
ffffffffc020278e:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0202790:	57f5                	li	a5,-3
ffffffffc0202792:	07fa                	slli	a5,a5,0x1e
ffffffffc0202794:	00f9b023          	sd	a5,0(s3)
    uint64_t mem_begin = get_memory_base();
ffffffffc0202798:	a02fe0ef          	jal	ra,ffffffffc020099a <get_memory_base>
ffffffffc020279c:	892a                	mv	s2,a0
    uint64_t mem_size = get_memory_size();
ffffffffc020279e:	a06fe0ef          	jal	ra,ffffffffc02009a4 <get_memory_size>
    if (mem_size == 0)
ffffffffc02027a2:	200505e3          	beqz	a0,ffffffffc02031ac <pmm_init+0xa66>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc02027a6:	84aa                	mv	s1,a0
    cprintf("physcial memory map:\n");
ffffffffc02027a8:	00004517          	auipc	a0,0x4
ffffffffc02027ac:	f7850513          	addi	a0,a0,-136 # ffffffffc0206720 <default_pmm_manager+0x1e0>
ffffffffc02027b0:	9e5fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc02027b4:	00990433          	add	s0,s2,s1
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc02027b8:	fff40693          	addi	a3,s0,-1
ffffffffc02027bc:	864a                	mv	a2,s2
ffffffffc02027be:	85a6                	mv	a1,s1
ffffffffc02027c0:	00004517          	auipc	a0,0x4
ffffffffc02027c4:	f7850513          	addi	a0,a0,-136 # ffffffffc0206738 <default_pmm_manager+0x1f8>
ffffffffc02027c8:	9cdfd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    npage = maxpa / PGSIZE;
ffffffffc02027cc:	c8000737          	lui	a4,0xc8000
ffffffffc02027d0:	87a2                	mv	a5,s0
ffffffffc02027d2:	54876163          	bltu	a4,s0,ffffffffc0202d14 <pmm_init+0x5ce>
ffffffffc02027d6:	757d                	lui	a0,0xfffff
ffffffffc02027d8:	000a9617          	auipc	a2,0xa9
ffffffffc02027dc:	05360613          	addi	a2,a2,83 # ffffffffc02ab82b <end+0xfff>
ffffffffc02027e0:	8e69                	and	a2,a2,a0
ffffffffc02027e2:	000a8497          	auipc	s1,0xa8
ffffffffc02027e6:	00e48493          	addi	s1,s1,14 # ffffffffc02aa7f0 <npage>
ffffffffc02027ea:	00c7d513          	srli	a0,a5,0xc
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02027ee:	000a8b97          	auipc	s7,0xa8
ffffffffc02027f2:	00ab8b93          	addi	s7,s7,10 # ffffffffc02aa7f8 <pages>
    npage = maxpa / PGSIZE;
ffffffffc02027f6:	e088                	sd	a0,0(s1)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02027f8:	00cbb023          	sd	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc02027fc:	000807b7          	lui	a5,0x80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202800:	86b2                	mv	a3,a2
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202802:	02f50863          	beq	a0,a5,ffffffffc0202832 <pmm_init+0xec>
ffffffffc0202806:	4781                	li	a5,0
ffffffffc0202808:	4585                	li	a1,1
ffffffffc020280a:	fff806b7          	lui	a3,0xfff80
        SetPageReserved(pages + i);
ffffffffc020280e:	00679513          	slli	a0,a5,0x6
ffffffffc0202812:	9532                	add	a0,a0,a2
ffffffffc0202814:	00850713          	addi	a4,a0,8 # fffffffffffff008 <end+0x3fd547dc>
ffffffffc0202818:	40b7302f          	amoor.d	zero,a1,(a4)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc020281c:	6088                	ld	a0,0(s1)
ffffffffc020281e:	0785                	addi	a5,a5,1
        SetPageReserved(pages + i);
ffffffffc0202820:	000bb603          	ld	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202824:	00d50733          	add	a4,a0,a3
ffffffffc0202828:	fee7e3e3          	bltu	a5,a4,ffffffffc020280e <pmm_init+0xc8>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc020282c:	071a                	slli	a4,a4,0x6
ffffffffc020282e:	00e606b3          	add	a3,a2,a4
ffffffffc0202832:	c02007b7          	lui	a5,0xc0200
ffffffffc0202836:	2ef6ece3          	bltu	a3,a5,ffffffffc020332e <pmm_init+0xbe8>
ffffffffc020283a:	0009b583          	ld	a1,0(s3)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc020283e:	77fd                	lui	a5,0xfffff
ffffffffc0202840:	8c7d                	and	s0,s0,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202842:	8e8d                	sub	a3,a3,a1
    if (freemem < mem_end)
ffffffffc0202844:	5086eb63          	bltu	a3,s0,ffffffffc0202d5a <pmm_init+0x614>
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0202848:	00004517          	auipc	a0,0x4
ffffffffc020284c:	f1850513          	addi	a0,a0,-232 # ffffffffc0206760 <default_pmm_manager+0x220>
ffffffffc0202850:	945fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    return page;
}

static void check_alloc_page(void)
{
    pmm_manager->check();
ffffffffc0202854:	000b3783          	ld	a5,0(s6)
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc0202858:	000a8917          	auipc	s2,0xa8
ffffffffc020285c:	f9090913          	addi	s2,s2,-112 # ffffffffc02aa7e8 <boot_pgdir_va>
    pmm_manager->check();
ffffffffc0202860:	7b9c                	ld	a5,48(a5)
ffffffffc0202862:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc0202864:	00004517          	auipc	a0,0x4
ffffffffc0202868:	f1450513          	addi	a0,a0,-236 # ffffffffc0206778 <default_pmm_manager+0x238>
ffffffffc020286c:	929fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc0202870:	00007697          	auipc	a3,0x7
ffffffffc0202874:	79068693          	addi	a3,a3,1936 # ffffffffc020a000 <boot_page_table_sv39>
ffffffffc0202878:	00d93023          	sd	a3,0(s2)
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc020287c:	c02007b7          	lui	a5,0xc0200
ffffffffc0202880:	28f6ebe3          	bltu	a3,a5,ffffffffc0203316 <pmm_init+0xbd0>
ffffffffc0202884:	0009b783          	ld	a5,0(s3)
ffffffffc0202888:	8e9d                	sub	a3,a3,a5
ffffffffc020288a:	000a8797          	auipc	a5,0xa8
ffffffffc020288e:	f4d7bb23          	sd	a3,-170(a5) # ffffffffc02aa7e0 <boot_pgdir_pa>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202892:	100027f3          	csrr	a5,sstatus
ffffffffc0202896:	8b89                	andi	a5,a5,2
ffffffffc0202898:	4a079763          	bnez	a5,ffffffffc0202d46 <pmm_init+0x600>
        ret = pmm_manager->nr_free_pages();
ffffffffc020289c:	000b3783          	ld	a5,0(s6)
ffffffffc02028a0:	779c                	ld	a5,40(a5)
ffffffffc02028a2:	9782                	jalr	a5
ffffffffc02028a4:	842a                	mv	s0,a0
    // so npage is always larger than KMEMSIZE / PGSIZE
    size_t nr_free_store;

    nr_free_store = nr_free_pages();

    assert(npage <= KERNTOP / PGSIZE);
ffffffffc02028a6:	6098                	ld	a4,0(s1)
ffffffffc02028a8:	c80007b7          	lui	a5,0xc8000
ffffffffc02028ac:	83b1                	srli	a5,a5,0xc
ffffffffc02028ae:	66e7e363          	bltu	a5,a4,ffffffffc0202f14 <pmm_init+0x7ce>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc02028b2:	00093503          	ld	a0,0(s2)
ffffffffc02028b6:	62050f63          	beqz	a0,ffffffffc0202ef4 <pmm_init+0x7ae>
ffffffffc02028ba:	03451793          	slli	a5,a0,0x34
ffffffffc02028be:	62079b63          	bnez	a5,ffffffffc0202ef4 <pmm_init+0x7ae>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc02028c2:	4601                	li	a2,0
ffffffffc02028c4:	4581                	li	a1,0
ffffffffc02028c6:	8c3ff0ef          	jal	ra,ffffffffc0202188 <get_page>
ffffffffc02028ca:	60051563          	bnez	a0,ffffffffc0202ed4 <pmm_init+0x78e>
ffffffffc02028ce:	100027f3          	csrr	a5,sstatus
ffffffffc02028d2:	8b89                	andi	a5,a5,2
ffffffffc02028d4:	44079e63          	bnez	a5,ffffffffc0202d30 <pmm_init+0x5ea>
        page = pmm_manager->alloc_pages(n);
ffffffffc02028d8:	000b3783          	ld	a5,0(s6)
ffffffffc02028dc:	4505                	li	a0,1
ffffffffc02028de:	6f9c                	ld	a5,24(a5)
ffffffffc02028e0:	9782                	jalr	a5
ffffffffc02028e2:	8a2a                	mv	s4,a0

    struct Page *p1, *p2;
    p1 = alloc_page();
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc02028e4:	00093503          	ld	a0,0(s2)
ffffffffc02028e8:	4681                	li	a3,0
ffffffffc02028ea:	4601                	li	a2,0
ffffffffc02028ec:	85d2                	mv	a1,s4
ffffffffc02028ee:	d63ff0ef          	jal	ra,ffffffffc0202650 <page_insert>
ffffffffc02028f2:	26051ae3          	bnez	a0,ffffffffc0203366 <pmm_init+0xc20>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc02028f6:	00093503          	ld	a0,0(s2)
ffffffffc02028fa:	4601                	li	a2,0
ffffffffc02028fc:	4581                	li	a1,0
ffffffffc02028fe:	e62ff0ef          	jal	ra,ffffffffc0201f60 <get_pte>
ffffffffc0202902:	240502e3          	beqz	a0,ffffffffc0203346 <pmm_init+0xc00>
    assert(pte2page(*ptep) == p1);
ffffffffc0202906:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V))
ffffffffc0202908:	0017f713          	andi	a4,a5,1
ffffffffc020290c:	5a070263          	beqz	a4,ffffffffc0202eb0 <pmm_init+0x76a>
    if (PPN(pa) >= npage)
ffffffffc0202910:	6098                	ld	a4,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202912:	078a                	slli	a5,a5,0x2
ffffffffc0202914:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202916:	58e7fb63          	bgeu	a5,a4,ffffffffc0202eac <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc020291a:	000bb683          	ld	a3,0(s7)
ffffffffc020291e:	fff80637          	lui	a2,0xfff80
ffffffffc0202922:	97b2                	add	a5,a5,a2
ffffffffc0202924:	079a                	slli	a5,a5,0x6
ffffffffc0202926:	97b6                	add	a5,a5,a3
ffffffffc0202928:	14fa17e3          	bne	s4,a5,ffffffffc0203276 <pmm_init+0xb30>
    assert(page_ref(p1) == 1);
ffffffffc020292c:	000a2683          	lw	a3,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8bb8>
ffffffffc0202930:	4785                	li	a5,1
ffffffffc0202932:	12f692e3          	bne	a3,a5,ffffffffc0203256 <pmm_init+0xb10>

    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc0202936:	00093503          	ld	a0,0(s2)
ffffffffc020293a:	77fd                	lui	a5,0xfffff
ffffffffc020293c:	6114                	ld	a3,0(a0)
ffffffffc020293e:	068a                	slli	a3,a3,0x2
ffffffffc0202940:	8efd                	and	a3,a3,a5
ffffffffc0202942:	00c6d613          	srli	a2,a3,0xc
ffffffffc0202946:	0ee67ce3          	bgeu	a2,a4,ffffffffc020323e <pmm_init+0xaf8>
ffffffffc020294a:	0009bc03          	ld	s8,0(s3)
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc020294e:	96e2                	add	a3,a3,s8
ffffffffc0202950:	0006ba83          	ld	s5,0(a3)
ffffffffc0202954:	0a8a                	slli	s5,s5,0x2
ffffffffc0202956:	00fafab3          	and	s5,s5,a5
ffffffffc020295a:	00cad793          	srli	a5,s5,0xc
ffffffffc020295e:	0ce7f3e3          	bgeu	a5,a4,ffffffffc0203224 <pmm_init+0xade>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202962:	4601                	li	a2,0
ffffffffc0202964:	6585                	lui	a1,0x1
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202966:	9ae2                	add	s5,s5,s8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202968:	df8ff0ef          	jal	ra,ffffffffc0201f60 <get_pte>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc020296c:	0aa1                	addi	s5,s5,8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc020296e:	55551363          	bne	a0,s5,ffffffffc0202eb4 <pmm_init+0x76e>
ffffffffc0202972:	100027f3          	csrr	a5,sstatus
ffffffffc0202976:	8b89                	andi	a5,a5,2
ffffffffc0202978:	3a079163          	bnez	a5,ffffffffc0202d1a <pmm_init+0x5d4>
        page = pmm_manager->alloc_pages(n);
ffffffffc020297c:	000b3783          	ld	a5,0(s6)
ffffffffc0202980:	4505                	li	a0,1
ffffffffc0202982:	6f9c                	ld	a5,24(a5)
ffffffffc0202984:	9782                	jalr	a5
ffffffffc0202986:	8c2a                	mv	s8,a0

    p2 = alloc_page();
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0202988:	00093503          	ld	a0,0(s2)
ffffffffc020298c:	46d1                	li	a3,20
ffffffffc020298e:	6605                	lui	a2,0x1
ffffffffc0202990:	85e2                	mv	a1,s8
ffffffffc0202992:	cbfff0ef          	jal	ra,ffffffffc0202650 <page_insert>
ffffffffc0202996:	060517e3          	bnez	a0,ffffffffc0203204 <pmm_init+0xabe>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc020299a:	00093503          	ld	a0,0(s2)
ffffffffc020299e:	4601                	li	a2,0
ffffffffc02029a0:	6585                	lui	a1,0x1
ffffffffc02029a2:	dbeff0ef          	jal	ra,ffffffffc0201f60 <get_pte>
ffffffffc02029a6:	02050fe3          	beqz	a0,ffffffffc02031e4 <pmm_init+0xa9e>
    assert(*ptep & PTE_U);
ffffffffc02029aa:	611c                	ld	a5,0(a0)
ffffffffc02029ac:	0107f713          	andi	a4,a5,16
ffffffffc02029b0:	7c070e63          	beqz	a4,ffffffffc020318c <pmm_init+0xa46>
    assert(*ptep & PTE_W);
ffffffffc02029b4:	8b91                	andi	a5,a5,4
ffffffffc02029b6:	7a078b63          	beqz	a5,ffffffffc020316c <pmm_init+0xa26>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc02029ba:	00093503          	ld	a0,0(s2)
ffffffffc02029be:	611c                	ld	a5,0(a0)
ffffffffc02029c0:	8bc1                	andi	a5,a5,16
ffffffffc02029c2:	78078563          	beqz	a5,ffffffffc020314c <pmm_init+0xa06>
    assert(page_ref(p2) == 1);
ffffffffc02029c6:	000c2703          	lw	a4,0(s8)
ffffffffc02029ca:	4785                	li	a5,1
ffffffffc02029cc:	76f71063          	bne	a4,a5,ffffffffc020312c <pmm_init+0x9e6>

    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc02029d0:	4681                	li	a3,0
ffffffffc02029d2:	6605                	lui	a2,0x1
ffffffffc02029d4:	85d2                	mv	a1,s4
ffffffffc02029d6:	c7bff0ef          	jal	ra,ffffffffc0202650 <page_insert>
ffffffffc02029da:	72051963          	bnez	a0,ffffffffc020310c <pmm_init+0x9c6>
    assert(page_ref(p1) == 2);
ffffffffc02029de:	000a2703          	lw	a4,0(s4)
ffffffffc02029e2:	4789                	li	a5,2
ffffffffc02029e4:	70f71463          	bne	a4,a5,ffffffffc02030ec <pmm_init+0x9a6>
    assert(page_ref(p2) == 0);
ffffffffc02029e8:	000c2783          	lw	a5,0(s8)
ffffffffc02029ec:	6e079063          	bnez	a5,ffffffffc02030cc <pmm_init+0x986>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc02029f0:	00093503          	ld	a0,0(s2)
ffffffffc02029f4:	4601                	li	a2,0
ffffffffc02029f6:	6585                	lui	a1,0x1
ffffffffc02029f8:	d68ff0ef          	jal	ra,ffffffffc0201f60 <get_pte>
ffffffffc02029fc:	6a050863          	beqz	a0,ffffffffc02030ac <pmm_init+0x966>
    assert(pte2page(*ptep) == p1);
ffffffffc0202a00:	6118                	ld	a4,0(a0)
    if (!(pte & PTE_V))
ffffffffc0202a02:	00177793          	andi	a5,a4,1
ffffffffc0202a06:	4a078563          	beqz	a5,ffffffffc0202eb0 <pmm_init+0x76a>
    if (PPN(pa) >= npage)
ffffffffc0202a0a:	6094                	ld	a3,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202a0c:	00271793          	slli	a5,a4,0x2
ffffffffc0202a10:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202a12:	48d7fd63          	bgeu	a5,a3,ffffffffc0202eac <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202a16:	000bb683          	ld	a3,0(s7)
ffffffffc0202a1a:	fff80ab7          	lui	s5,0xfff80
ffffffffc0202a1e:	97d6                	add	a5,a5,s5
ffffffffc0202a20:	079a                	slli	a5,a5,0x6
ffffffffc0202a22:	97b6                	add	a5,a5,a3
ffffffffc0202a24:	66fa1463          	bne	s4,a5,ffffffffc020308c <pmm_init+0x946>
    assert((*ptep & PTE_U) == 0);
ffffffffc0202a28:	8b41                	andi	a4,a4,16
ffffffffc0202a2a:	64071163          	bnez	a4,ffffffffc020306c <pmm_init+0x926>

    page_remove(boot_pgdir_va, 0x0);
ffffffffc0202a2e:	00093503          	ld	a0,0(s2)
ffffffffc0202a32:	4581                	li	a1,0
ffffffffc0202a34:	b81ff0ef          	jal	ra,ffffffffc02025b4 <page_remove>
    assert(page_ref(p1) == 1);
ffffffffc0202a38:	000a2c83          	lw	s9,0(s4)
ffffffffc0202a3c:	4785                	li	a5,1
ffffffffc0202a3e:	60fc9763          	bne	s9,a5,ffffffffc020304c <pmm_init+0x906>
    assert(page_ref(p2) == 0);
ffffffffc0202a42:	000c2783          	lw	a5,0(s8)
ffffffffc0202a46:	5e079363          	bnez	a5,ffffffffc020302c <pmm_init+0x8e6>

    page_remove(boot_pgdir_va, PGSIZE);
ffffffffc0202a4a:	00093503          	ld	a0,0(s2)
ffffffffc0202a4e:	6585                	lui	a1,0x1
ffffffffc0202a50:	b65ff0ef          	jal	ra,ffffffffc02025b4 <page_remove>
    assert(page_ref(p1) == 0);
ffffffffc0202a54:	000a2783          	lw	a5,0(s4)
ffffffffc0202a58:	52079a63          	bnez	a5,ffffffffc0202f8c <pmm_init+0x846>
    assert(page_ref(p2) == 0);
ffffffffc0202a5c:	000c2783          	lw	a5,0(s8)
ffffffffc0202a60:	50079663          	bnez	a5,ffffffffc0202f6c <pmm_init+0x826>

    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202a64:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202a68:	608c                	ld	a1,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202a6a:	000a3683          	ld	a3,0(s4)
ffffffffc0202a6e:	068a                	slli	a3,a3,0x2
ffffffffc0202a70:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc0202a72:	42b6fd63          	bgeu	a3,a1,ffffffffc0202eac <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202a76:	000bb503          	ld	a0,0(s7)
ffffffffc0202a7a:	96d6                	add	a3,a3,s5
ffffffffc0202a7c:	069a                	slli	a3,a3,0x6
    return page->ref;
ffffffffc0202a7e:	00d507b3          	add	a5,a0,a3
ffffffffc0202a82:	439c                	lw	a5,0(a5)
ffffffffc0202a84:	4d979463          	bne	a5,s9,ffffffffc0202f4c <pmm_init+0x806>
    return page - pages + nbase;
ffffffffc0202a88:	8699                	srai	a3,a3,0x6
ffffffffc0202a8a:	00080637          	lui	a2,0x80
ffffffffc0202a8e:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc0202a90:	00c69713          	slli	a4,a3,0xc
ffffffffc0202a94:	8331                	srli	a4,a4,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202a96:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202a98:	48b77e63          	bgeu	a4,a1,ffffffffc0202f34 <pmm_init+0x7ee>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
    free_page(pde2page(pd0[0]));
ffffffffc0202a9c:	0009b703          	ld	a4,0(s3)
ffffffffc0202aa0:	96ba                	add	a3,a3,a4
    return pa2page(PDE_ADDR(pde));
ffffffffc0202aa2:	629c                	ld	a5,0(a3)
ffffffffc0202aa4:	078a                	slli	a5,a5,0x2
ffffffffc0202aa6:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202aa8:	40b7f263          	bgeu	a5,a1,ffffffffc0202eac <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202aac:	8f91                	sub	a5,a5,a2
ffffffffc0202aae:	079a                	slli	a5,a5,0x6
ffffffffc0202ab0:	953e                	add	a0,a0,a5
ffffffffc0202ab2:	100027f3          	csrr	a5,sstatus
ffffffffc0202ab6:	8b89                	andi	a5,a5,2
ffffffffc0202ab8:	30079963          	bnez	a5,ffffffffc0202dca <pmm_init+0x684>
        pmm_manager->free_pages(base, n);
ffffffffc0202abc:	000b3783          	ld	a5,0(s6)
ffffffffc0202ac0:	4585                	li	a1,1
ffffffffc0202ac2:	739c                	ld	a5,32(a5)
ffffffffc0202ac4:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202ac6:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc0202aca:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202acc:	078a                	slli	a5,a5,0x2
ffffffffc0202ace:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202ad0:	3ce7fe63          	bgeu	a5,a4,ffffffffc0202eac <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202ad4:	000bb503          	ld	a0,0(s7)
ffffffffc0202ad8:	fff80737          	lui	a4,0xfff80
ffffffffc0202adc:	97ba                	add	a5,a5,a4
ffffffffc0202ade:	079a                	slli	a5,a5,0x6
ffffffffc0202ae0:	953e                	add	a0,a0,a5
ffffffffc0202ae2:	100027f3          	csrr	a5,sstatus
ffffffffc0202ae6:	8b89                	andi	a5,a5,2
ffffffffc0202ae8:	2c079563          	bnez	a5,ffffffffc0202db2 <pmm_init+0x66c>
ffffffffc0202aec:	000b3783          	ld	a5,0(s6)
ffffffffc0202af0:	4585                	li	a1,1
ffffffffc0202af2:	739c                	ld	a5,32(a5)
ffffffffc0202af4:	9782                	jalr	a5
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202af6:	00093783          	ld	a5,0(s2)
ffffffffc0202afa:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fd547d4>
    asm volatile("sfence.vma");
ffffffffc0202afe:	12000073          	sfence.vma
ffffffffc0202b02:	100027f3          	csrr	a5,sstatus
ffffffffc0202b06:	8b89                	andi	a5,a5,2
ffffffffc0202b08:	28079b63          	bnez	a5,ffffffffc0202d9e <pmm_init+0x658>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202b0c:	000b3783          	ld	a5,0(s6)
ffffffffc0202b10:	779c                	ld	a5,40(a5)
ffffffffc0202b12:	9782                	jalr	a5
ffffffffc0202b14:	8a2a                	mv	s4,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202b16:	4b441b63          	bne	s0,s4,ffffffffc0202fcc <pmm_init+0x886>

    cprintf("check_pgdir() succeeded!\n");
ffffffffc0202b1a:	00004517          	auipc	a0,0x4
ffffffffc0202b1e:	f8650513          	addi	a0,a0,-122 # ffffffffc0206aa0 <default_pmm_manager+0x560>
ffffffffc0202b22:	e72fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0202b26:	100027f3          	csrr	a5,sstatus
ffffffffc0202b2a:	8b89                	andi	a5,a5,2
ffffffffc0202b2c:	24079f63          	bnez	a5,ffffffffc0202d8a <pmm_init+0x644>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202b30:	000b3783          	ld	a5,0(s6)
ffffffffc0202b34:	779c                	ld	a5,40(a5)
ffffffffc0202b36:	9782                	jalr	a5
ffffffffc0202b38:	8c2a                	mv	s8,a0
    pte_t *ptep;
    int i;

    nr_free_store = nr_free_pages();

    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202b3a:	6098                	ld	a4,0(s1)
ffffffffc0202b3c:	c0200437          	lui	s0,0xc0200
    {
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202b40:	7afd                	lui	s5,0xfffff
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202b42:	00c71793          	slli	a5,a4,0xc
ffffffffc0202b46:	6a05                	lui	s4,0x1
ffffffffc0202b48:	02f47c63          	bgeu	s0,a5,ffffffffc0202b80 <pmm_init+0x43a>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202b4c:	00c45793          	srli	a5,s0,0xc
ffffffffc0202b50:	00093503          	ld	a0,0(s2)
ffffffffc0202b54:	2ee7ff63          	bgeu	a5,a4,ffffffffc0202e52 <pmm_init+0x70c>
ffffffffc0202b58:	0009b583          	ld	a1,0(s3)
ffffffffc0202b5c:	4601                	li	a2,0
ffffffffc0202b5e:	95a2                	add	a1,a1,s0
ffffffffc0202b60:	c00ff0ef          	jal	ra,ffffffffc0201f60 <get_pte>
ffffffffc0202b64:	32050463          	beqz	a0,ffffffffc0202e8c <pmm_init+0x746>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202b68:	611c                	ld	a5,0(a0)
ffffffffc0202b6a:	078a                	slli	a5,a5,0x2
ffffffffc0202b6c:	0157f7b3          	and	a5,a5,s5
ffffffffc0202b70:	2e879e63          	bne	a5,s0,ffffffffc0202e6c <pmm_init+0x726>
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202b74:	6098                	ld	a4,0(s1)
ffffffffc0202b76:	9452                	add	s0,s0,s4
ffffffffc0202b78:	00c71793          	slli	a5,a4,0xc
ffffffffc0202b7c:	fcf468e3          	bltu	s0,a5,ffffffffc0202b4c <pmm_init+0x406>
    }

    assert(boot_pgdir_va[0] == 0);
ffffffffc0202b80:	00093783          	ld	a5,0(s2)
ffffffffc0202b84:	639c                	ld	a5,0(a5)
ffffffffc0202b86:	42079363          	bnez	a5,ffffffffc0202fac <pmm_init+0x866>
ffffffffc0202b8a:	100027f3          	csrr	a5,sstatus
ffffffffc0202b8e:	8b89                	andi	a5,a5,2
ffffffffc0202b90:	24079963          	bnez	a5,ffffffffc0202de2 <pmm_init+0x69c>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202b94:	000b3783          	ld	a5,0(s6)
ffffffffc0202b98:	4505                	li	a0,1
ffffffffc0202b9a:	6f9c                	ld	a5,24(a5)
ffffffffc0202b9c:	9782                	jalr	a5
ffffffffc0202b9e:	8a2a                	mv	s4,a0

    struct Page *p;
    p = alloc_page();
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0202ba0:	00093503          	ld	a0,0(s2)
ffffffffc0202ba4:	4699                	li	a3,6
ffffffffc0202ba6:	10000613          	li	a2,256
ffffffffc0202baa:	85d2                	mv	a1,s4
ffffffffc0202bac:	aa5ff0ef          	jal	ra,ffffffffc0202650 <page_insert>
ffffffffc0202bb0:	44051e63          	bnez	a0,ffffffffc020300c <pmm_init+0x8c6>
    assert(page_ref(p) == 1);
ffffffffc0202bb4:	000a2703          	lw	a4,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8bb8>
ffffffffc0202bb8:	4785                	li	a5,1
ffffffffc0202bba:	42f71963          	bne	a4,a5,ffffffffc0202fec <pmm_init+0x8a6>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0202bbe:	00093503          	ld	a0,0(s2)
ffffffffc0202bc2:	6405                	lui	s0,0x1
ffffffffc0202bc4:	4699                	li	a3,6
ffffffffc0202bc6:	10040613          	addi	a2,s0,256 # 1100 <_binary_obj___user_faultread_out_size-0x8ab8>
ffffffffc0202bca:	85d2                	mv	a1,s4
ffffffffc0202bcc:	a85ff0ef          	jal	ra,ffffffffc0202650 <page_insert>
ffffffffc0202bd0:	72051363          	bnez	a0,ffffffffc02032f6 <pmm_init+0xbb0>
    assert(page_ref(p) == 2);
ffffffffc0202bd4:	000a2703          	lw	a4,0(s4)
ffffffffc0202bd8:	4789                	li	a5,2
ffffffffc0202bda:	6ef71e63          	bne	a4,a5,ffffffffc02032d6 <pmm_init+0xb90>

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
ffffffffc0202bde:	00004597          	auipc	a1,0x4
ffffffffc0202be2:	00a58593          	addi	a1,a1,10 # ffffffffc0206be8 <default_pmm_manager+0x6a8>
ffffffffc0202be6:	10000513          	li	a0,256
ffffffffc0202bea:	27d020ef          	jal	ra,ffffffffc0205666 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0202bee:	10040593          	addi	a1,s0,256
ffffffffc0202bf2:	10000513          	li	a0,256
ffffffffc0202bf6:	283020ef          	jal	ra,ffffffffc0205678 <strcmp>
ffffffffc0202bfa:	6a051e63          	bnez	a0,ffffffffc02032b6 <pmm_init+0xb70>
    return page - pages + nbase;
ffffffffc0202bfe:	000bb683          	ld	a3,0(s7)
ffffffffc0202c02:	00080737          	lui	a4,0x80
    return KADDR(page2pa(page));
ffffffffc0202c06:	547d                	li	s0,-1
    return page - pages + nbase;
ffffffffc0202c08:	40da06b3          	sub	a3,s4,a3
ffffffffc0202c0c:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0202c0e:	609c                	ld	a5,0(s1)
    return page - pages + nbase;
ffffffffc0202c10:	96ba                	add	a3,a3,a4
    return KADDR(page2pa(page));
ffffffffc0202c12:	8031                	srli	s0,s0,0xc
ffffffffc0202c14:	0086f733          	and	a4,a3,s0
    return page2ppn(page) << PGSHIFT;
ffffffffc0202c18:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202c1a:	30f77d63          	bgeu	a4,a5,ffffffffc0202f34 <pmm_init+0x7ee>

    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202c1e:	0009b783          	ld	a5,0(s3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202c22:	10000513          	li	a0,256
    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202c26:	96be                	add	a3,a3,a5
ffffffffc0202c28:	10068023          	sb	zero,256(a3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202c2c:	205020ef          	jal	ra,ffffffffc0205630 <strlen>
ffffffffc0202c30:	66051363          	bnez	a0,ffffffffc0203296 <pmm_init+0xb50>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
ffffffffc0202c34:	00093a83          	ld	s5,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202c38:	609c                	ld	a5,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202c3a:	000ab683          	ld	a3,0(s5) # fffffffffffff000 <end+0x3fd547d4>
ffffffffc0202c3e:	068a                	slli	a3,a3,0x2
ffffffffc0202c40:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc0202c42:	26f6f563          	bgeu	a3,a5,ffffffffc0202eac <pmm_init+0x766>
    return KADDR(page2pa(page));
ffffffffc0202c46:	8c75                	and	s0,s0,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0202c48:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202c4a:	2ef47563          	bgeu	s0,a5,ffffffffc0202f34 <pmm_init+0x7ee>
ffffffffc0202c4e:	0009b403          	ld	s0,0(s3)
ffffffffc0202c52:	9436                	add	s0,s0,a3
ffffffffc0202c54:	100027f3          	csrr	a5,sstatus
ffffffffc0202c58:	8b89                	andi	a5,a5,2
ffffffffc0202c5a:	1e079163          	bnez	a5,ffffffffc0202e3c <pmm_init+0x6f6>
        pmm_manager->free_pages(base, n);
ffffffffc0202c5e:	000b3783          	ld	a5,0(s6)
ffffffffc0202c62:	4585                	li	a1,1
ffffffffc0202c64:	8552                	mv	a0,s4
ffffffffc0202c66:	739c                	ld	a5,32(a5)
ffffffffc0202c68:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202c6a:	601c                	ld	a5,0(s0)
    if (PPN(pa) >= npage)
ffffffffc0202c6c:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202c6e:	078a                	slli	a5,a5,0x2
ffffffffc0202c70:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202c72:	22e7fd63          	bgeu	a5,a4,ffffffffc0202eac <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202c76:	000bb503          	ld	a0,0(s7)
ffffffffc0202c7a:	fff80737          	lui	a4,0xfff80
ffffffffc0202c7e:	97ba                	add	a5,a5,a4
ffffffffc0202c80:	079a                	slli	a5,a5,0x6
ffffffffc0202c82:	953e                	add	a0,a0,a5
ffffffffc0202c84:	100027f3          	csrr	a5,sstatus
ffffffffc0202c88:	8b89                	andi	a5,a5,2
ffffffffc0202c8a:	18079d63          	bnez	a5,ffffffffc0202e24 <pmm_init+0x6de>
ffffffffc0202c8e:	000b3783          	ld	a5,0(s6)
ffffffffc0202c92:	4585                	li	a1,1
ffffffffc0202c94:	739c                	ld	a5,32(a5)
ffffffffc0202c96:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202c98:	000ab783          	ld	a5,0(s5)
    if (PPN(pa) >= npage)
ffffffffc0202c9c:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202c9e:	078a                	slli	a5,a5,0x2
ffffffffc0202ca0:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202ca2:	20e7f563          	bgeu	a5,a4,ffffffffc0202eac <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202ca6:	000bb503          	ld	a0,0(s7)
ffffffffc0202caa:	fff80737          	lui	a4,0xfff80
ffffffffc0202cae:	97ba                	add	a5,a5,a4
ffffffffc0202cb0:	079a                	slli	a5,a5,0x6
ffffffffc0202cb2:	953e                	add	a0,a0,a5
ffffffffc0202cb4:	100027f3          	csrr	a5,sstatus
ffffffffc0202cb8:	8b89                	andi	a5,a5,2
ffffffffc0202cba:	14079963          	bnez	a5,ffffffffc0202e0c <pmm_init+0x6c6>
ffffffffc0202cbe:	000b3783          	ld	a5,0(s6)
ffffffffc0202cc2:	4585                	li	a1,1
ffffffffc0202cc4:	739c                	ld	a5,32(a5)
ffffffffc0202cc6:	9782                	jalr	a5
    free_page(p);
    free_page(pde2page(pd0[0]));
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202cc8:	00093783          	ld	a5,0(s2)
ffffffffc0202ccc:	0007b023          	sd	zero,0(a5)
    asm volatile("sfence.vma");
ffffffffc0202cd0:	12000073          	sfence.vma
ffffffffc0202cd4:	100027f3          	csrr	a5,sstatus
ffffffffc0202cd8:	8b89                	andi	a5,a5,2
ffffffffc0202cda:	10079f63          	bnez	a5,ffffffffc0202df8 <pmm_init+0x6b2>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202cde:	000b3783          	ld	a5,0(s6)
ffffffffc0202ce2:	779c                	ld	a5,40(a5)
ffffffffc0202ce4:	9782                	jalr	a5
ffffffffc0202ce6:	842a                	mv	s0,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202ce8:	4c8c1e63          	bne	s8,s0,ffffffffc02031c4 <pmm_init+0xa7e>

    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc0202cec:	00004517          	auipc	a0,0x4
ffffffffc0202cf0:	f7450513          	addi	a0,a0,-140 # ffffffffc0206c60 <default_pmm_manager+0x720>
ffffffffc0202cf4:	ca0fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
}
ffffffffc0202cf8:	7406                	ld	s0,96(sp)
ffffffffc0202cfa:	70a6                	ld	ra,104(sp)
ffffffffc0202cfc:	64e6                	ld	s1,88(sp)
ffffffffc0202cfe:	6946                	ld	s2,80(sp)
ffffffffc0202d00:	69a6                	ld	s3,72(sp)
ffffffffc0202d02:	6a06                	ld	s4,64(sp)
ffffffffc0202d04:	7ae2                	ld	s5,56(sp)
ffffffffc0202d06:	7b42                	ld	s6,48(sp)
ffffffffc0202d08:	7ba2                	ld	s7,40(sp)
ffffffffc0202d0a:	7c02                	ld	s8,32(sp)
ffffffffc0202d0c:	6ce2                	ld	s9,24(sp)
ffffffffc0202d0e:	6165                	addi	sp,sp,112
    kmalloc_init();
ffffffffc0202d10:	f97fe06f          	j	ffffffffc0201ca6 <kmalloc_init>
    npage = maxpa / PGSIZE;
ffffffffc0202d14:	c80007b7          	lui	a5,0xc8000
ffffffffc0202d18:	bc7d                	j	ffffffffc02027d6 <pmm_init+0x90>
        intr_disable();
ffffffffc0202d1a:	c9bfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202d1e:	000b3783          	ld	a5,0(s6)
ffffffffc0202d22:	4505                	li	a0,1
ffffffffc0202d24:	6f9c                	ld	a5,24(a5)
ffffffffc0202d26:	9782                	jalr	a5
ffffffffc0202d28:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202d2a:	c85fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202d2e:	b9a9                	j	ffffffffc0202988 <pmm_init+0x242>
        intr_disable();
ffffffffc0202d30:	c85fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202d34:	000b3783          	ld	a5,0(s6)
ffffffffc0202d38:	4505                	li	a0,1
ffffffffc0202d3a:	6f9c                	ld	a5,24(a5)
ffffffffc0202d3c:	9782                	jalr	a5
ffffffffc0202d3e:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202d40:	c6ffd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202d44:	b645                	j	ffffffffc02028e4 <pmm_init+0x19e>
        intr_disable();
ffffffffc0202d46:	c6ffd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202d4a:	000b3783          	ld	a5,0(s6)
ffffffffc0202d4e:	779c                	ld	a5,40(a5)
ffffffffc0202d50:	9782                	jalr	a5
ffffffffc0202d52:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202d54:	c5bfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202d58:	b6b9                	j	ffffffffc02028a6 <pmm_init+0x160>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0202d5a:	6705                	lui	a4,0x1
ffffffffc0202d5c:	177d                	addi	a4,a4,-1
ffffffffc0202d5e:	96ba                	add	a3,a3,a4
ffffffffc0202d60:	8ff5                	and	a5,a5,a3
    if (PPN(pa) >= npage)
ffffffffc0202d62:	00c7d713          	srli	a4,a5,0xc
ffffffffc0202d66:	14a77363          	bgeu	a4,a0,ffffffffc0202eac <pmm_init+0x766>
    pmm_manager->init_memmap(base, n);
ffffffffc0202d6a:	000b3683          	ld	a3,0(s6)
    return &pages[PPN(pa) - nbase];
ffffffffc0202d6e:	fff80537          	lui	a0,0xfff80
ffffffffc0202d72:	972a                	add	a4,a4,a0
ffffffffc0202d74:	6a94                	ld	a3,16(a3)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0202d76:	8c1d                	sub	s0,s0,a5
ffffffffc0202d78:	00671513          	slli	a0,a4,0x6
    pmm_manager->init_memmap(base, n);
ffffffffc0202d7c:	00c45593          	srli	a1,s0,0xc
ffffffffc0202d80:	9532                	add	a0,a0,a2
ffffffffc0202d82:	9682                	jalr	a3
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0202d84:	0009b583          	ld	a1,0(s3)
}
ffffffffc0202d88:	b4c1                	j	ffffffffc0202848 <pmm_init+0x102>
        intr_disable();
ffffffffc0202d8a:	c2bfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202d8e:	000b3783          	ld	a5,0(s6)
ffffffffc0202d92:	779c                	ld	a5,40(a5)
ffffffffc0202d94:	9782                	jalr	a5
ffffffffc0202d96:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202d98:	c17fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202d9c:	bb79                	j	ffffffffc0202b3a <pmm_init+0x3f4>
        intr_disable();
ffffffffc0202d9e:	c17fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202da2:	000b3783          	ld	a5,0(s6)
ffffffffc0202da6:	779c                	ld	a5,40(a5)
ffffffffc0202da8:	9782                	jalr	a5
ffffffffc0202daa:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202dac:	c03fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202db0:	b39d                	j	ffffffffc0202b16 <pmm_init+0x3d0>
ffffffffc0202db2:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202db4:	c01fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202db8:	000b3783          	ld	a5,0(s6)
ffffffffc0202dbc:	6522                	ld	a0,8(sp)
ffffffffc0202dbe:	4585                	li	a1,1
ffffffffc0202dc0:	739c                	ld	a5,32(a5)
ffffffffc0202dc2:	9782                	jalr	a5
        intr_enable();
ffffffffc0202dc4:	bebfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202dc8:	b33d                	j	ffffffffc0202af6 <pmm_init+0x3b0>
ffffffffc0202dca:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202dcc:	be9fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202dd0:	000b3783          	ld	a5,0(s6)
ffffffffc0202dd4:	6522                	ld	a0,8(sp)
ffffffffc0202dd6:	4585                	li	a1,1
ffffffffc0202dd8:	739c                	ld	a5,32(a5)
ffffffffc0202dda:	9782                	jalr	a5
        intr_enable();
ffffffffc0202ddc:	bd3fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202de0:	b1dd                	j	ffffffffc0202ac6 <pmm_init+0x380>
        intr_disable();
ffffffffc0202de2:	bd3fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202de6:	000b3783          	ld	a5,0(s6)
ffffffffc0202dea:	4505                	li	a0,1
ffffffffc0202dec:	6f9c                	ld	a5,24(a5)
ffffffffc0202dee:	9782                	jalr	a5
ffffffffc0202df0:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202df2:	bbdfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202df6:	b36d                	j	ffffffffc0202ba0 <pmm_init+0x45a>
        intr_disable();
ffffffffc0202df8:	bbdfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202dfc:	000b3783          	ld	a5,0(s6)
ffffffffc0202e00:	779c                	ld	a5,40(a5)
ffffffffc0202e02:	9782                	jalr	a5
ffffffffc0202e04:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202e06:	ba9fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202e0a:	bdf9                	j	ffffffffc0202ce8 <pmm_init+0x5a2>
ffffffffc0202e0c:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202e0e:	ba7fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202e12:	000b3783          	ld	a5,0(s6)
ffffffffc0202e16:	6522                	ld	a0,8(sp)
ffffffffc0202e18:	4585                	li	a1,1
ffffffffc0202e1a:	739c                	ld	a5,32(a5)
ffffffffc0202e1c:	9782                	jalr	a5
        intr_enable();
ffffffffc0202e1e:	b91fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202e22:	b55d                	j	ffffffffc0202cc8 <pmm_init+0x582>
ffffffffc0202e24:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202e26:	b8ffd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202e2a:	000b3783          	ld	a5,0(s6)
ffffffffc0202e2e:	6522                	ld	a0,8(sp)
ffffffffc0202e30:	4585                	li	a1,1
ffffffffc0202e32:	739c                	ld	a5,32(a5)
ffffffffc0202e34:	9782                	jalr	a5
        intr_enable();
ffffffffc0202e36:	b79fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202e3a:	bdb9                	j	ffffffffc0202c98 <pmm_init+0x552>
        intr_disable();
ffffffffc0202e3c:	b79fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202e40:	000b3783          	ld	a5,0(s6)
ffffffffc0202e44:	4585                	li	a1,1
ffffffffc0202e46:	8552                	mv	a0,s4
ffffffffc0202e48:	739c                	ld	a5,32(a5)
ffffffffc0202e4a:	9782                	jalr	a5
        intr_enable();
ffffffffc0202e4c:	b63fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202e50:	bd29                	j	ffffffffc0202c6a <pmm_init+0x524>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202e52:	86a2                	mv	a3,s0
ffffffffc0202e54:	00003617          	auipc	a2,0x3
ffffffffc0202e58:	72460613          	addi	a2,a2,1828 # ffffffffc0206578 <default_pmm_manager+0x38>
ffffffffc0202e5c:	25200593          	li	a1,594
ffffffffc0202e60:	00004517          	auipc	a0,0x4
ffffffffc0202e64:	83050513          	addi	a0,a0,-2000 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc0202e68:	e26fd0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202e6c:	00004697          	auipc	a3,0x4
ffffffffc0202e70:	c9468693          	addi	a3,a3,-876 # ffffffffc0206b00 <default_pmm_manager+0x5c0>
ffffffffc0202e74:	00003617          	auipc	a2,0x3
ffffffffc0202e78:	31c60613          	addi	a2,a2,796 # ffffffffc0206190 <commands+0x828>
ffffffffc0202e7c:	25300593          	li	a1,595
ffffffffc0202e80:	00004517          	auipc	a0,0x4
ffffffffc0202e84:	81050513          	addi	a0,a0,-2032 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc0202e88:	e06fd0ef          	jal	ra,ffffffffc020048e <__panic>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202e8c:	00004697          	auipc	a3,0x4
ffffffffc0202e90:	c3468693          	addi	a3,a3,-972 # ffffffffc0206ac0 <default_pmm_manager+0x580>
ffffffffc0202e94:	00003617          	auipc	a2,0x3
ffffffffc0202e98:	2fc60613          	addi	a2,a2,764 # ffffffffc0206190 <commands+0x828>
ffffffffc0202e9c:	25200593          	li	a1,594
ffffffffc0202ea0:	00003517          	auipc	a0,0x3
ffffffffc0202ea4:	7f050513          	addi	a0,a0,2032 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc0202ea8:	de6fd0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc0202eac:	fc5fe0ef          	jal	ra,ffffffffc0201e70 <pa2page.part.0>
ffffffffc0202eb0:	fddfe0ef          	jal	ra,ffffffffc0201e8c <pte2page.part.0>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202eb4:	00004697          	auipc	a3,0x4
ffffffffc0202eb8:	a0468693          	addi	a3,a3,-1532 # ffffffffc02068b8 <default_pmm_manager+0x378>
ffffffffc0202ebc:	00003617          	auipc	a2,0x3
ffffffffc0202ec0:	2d460613          	addi	a2,a2,724 # ffffffffc0206190 <commands+0x828>
ffffffffc0202ec4:	22200593          	li	a1,546
ffffffffc0202ec8:	00003517          	auipc	a0,0x3
ffffffffc0202ecc:	7c850513          	addi	a0,a0,1992 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc0202ed0:	dbefd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc0202ed4:	00004697          	auipc	a3,0x4
ffffffffc0202ed8:	92468693          	addi	a3,a3,-1756 # ffffffffc02067f8 <default_pmm_manager+0x2b8>
ffffffffc0202edc:	00003617          	auipc	a2,0x3
ffffffffc0202ee0:	2b460613          	addi	a2,a2,692 # ffffffffc0206190 <commands+0x828>
ffffffffc0202ee4:	21500593          	li	a1,533
ffffffffc0202ee8:	00003517          	auipc	a0,0x3
ffffffffc0202eec:	7a850513          	addi	a0,a0,1960 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc0202ef0:	d9efd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc0202ef4:	00004697          	auipc	a3,0x4
ffffffffc0202ef8:	8c468693          	addi	a3,a3,-1852 # ffffffffc02067b8 <default_pmm_manager+0x278>
ffffffffc0202efc:	00003617          	auipc	a2,0x3
ffffffffc0202f00:	29460613          	addi	a2,a2,660 # ffffffffc0206190 <commands+0x828>
ffffffffc0202f04:	21400593          	li	a1,532
ffffffffc0202f08:	00003517          	auipc	a0,0x3
ffffffffc0202f0c:	78850513          	addi	a0,a0,1928 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc0202f10:	d7efd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0202f14:	00004697          	auipc	a3,0x4
ffffffffc0202f18:	88468693          	addi	a3,a3,-1916 # ffffffffc0206798 <default_pmm_manager+0x258>
ffffffffc0202f1c:	00003617          	auipc	a2,0x3
ffffffffc0202f20:	27460613          	addi	a2,a2,628 # ffffffffc0206190 <commands+0x828>
ffffffffc0202f24:	21300593          	li	a1,531
ffffffffc0202f28:	00003517          	auipc	a0,0x3
ffffffffc0202f2c:	76850513          	addi	a0,a0,1896 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc0202f30:	d5efd0ef          	jal	ra,ffffffffc020048e <__panic>
    return KADDR(page2pa(page));
ffffffffc0202f34:	00003617          	auipc	a2,0x3
ffffffffc0202f38:	64460613          	addi	a2,a2,1604 # ffffffffc0206578 <default_pmm_manager+0x38>
ffffffffc0202f3c:	07100593          	li	a1,113
ffffffffc0202f40:	00003517          	auipc	a0,0x3
ffffffffc0202f44:	66050513          	addi	a0,a0,1632 # ffffffffc02065a0 <default_pmm_manager+0x60>
ffffffffc0202f48:	d46fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202f4c:	00004697          	auipc	a3,0x4
ffffffffc0202f50:	afc68693          	addi	a3,a3,-1284 # ffffffffc0206a48 <default_pmm_manager+0x508>
ffffffffc0202f54:	00003617          	auipc	a2,0x3
ffffffffc0202f58:	23c60613          	addi	a2,a2,572 # ffffffffc0206190 <commands+0x828>
ffffffffc0202f5c:	23b00593          	li	a1,571
ffffffffc0202f60:	00003517          	auipc	a0,0x3
ffffffffc0202f64:	73050513          	addi	a0,a0,1840 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc0202f68:	d26fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202f6c:	00004697          	auipc	a3,0x4
ffffffffc0202f70:	a9468693          	addi	a3,a3,-1388 # ffffffffc0206a00 <default_pmm_manager+0x4c0>
ffffffffc0202f74:	00003617          	auipc	a2,0x3
ffffffffc0202f78:	21c60613          	addi	a2,a2,540 # ffffffffc0206190 <commands+0x828>
ffffffffc0202f7c:	23900593          	li	a1,569
ffffffffc0202f80:	00003517          	auipc	a0,0x3
ffffffffc0202f84:	71050513          	addi	a0,a0,1808 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc0202f88:	d06fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 0);
ffffffffc0202f8c:	00004697          	auipc	a3,0x4
ffffffffc0202f90:	aa468693          	addi	a3,a3,-1372 # ffffffffc0206a30 <default_pmm_manager+0x4f0>
ffffffffc0202f94:	00003617          	auipc	a2,0x3
ffffffffc0202f98:	1fc60613          	addi	a2,a2,508 # ffffffffc0206190 <commands+0x828>
ffffffffc0202f9c:	23800593          	li	a1,568
ffffffffc0202fa0:	00003517          	auipc	a0,0x3
ffffffffc0202fa4:	6f050513          	addi	a0,a0,1776 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc0202fa8:	ce6fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(boot_pgdir_va[0] == 0);
ffffffffc0202fac:	00004697          	auipc	a3,0x4
ffffffffc0202fb0:	b6c68693          	addi	a3,a3,-1172 # ffffffffc0206b18 <default_pmm_manager+0x5d8>
ffffffffc0202fb4:	00003617          	auipc	a2,0x3
ffffffffc0202fb8:	1dc60613          	addi	a2,a2,476 # ffffffffc0206190 <commands+0x828>
ffffffffc0202fbc:	25600593          	li	a1,598
ffffffffc0202fc0:	00003517          	auipc	a0,0x3
ffffffffc0202fc4:	6d050513          	addi	a0,a0,1744 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc0202fc8:	cc6fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc0202fcc:	00004697          	auipc	a3,0x4
ffffffffc0202fd0:	aac68693          	addi	a3,a3,-1364 # ffffffffc0206a78 <default_pmm_manager+0x538>
ffffffffc0202fd4:	00003617          	auipc	a2,0x3
ffffffffc0202fd8:	1bc60613          	addi	a2,a2,444 # ffffffffc0206190 <commands+0x828>
ffffffffc0202fdc:	24300593          	li	a1,579
ffffffffc0202fe0:	00003517          	auipc	a0,0x3
ffffffffc0202fe4:	6b050513          	addi	a0,a0,1712 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc0202fe8:	ca6fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p) == 1);
ffffffffc0202fec:	00004697          	auipc	a3,0x4
ffffffffc0202ff0:	b8468693          	addi	a3,a3,-1148 # ffffffffc0206b70 <default_pmm_manager+0x630>
ffffffffc0202ff4:	00003617          	auipc	a2,0x3
ffffffffc0202ff8:	19c60613          	addi	a2,a2,412 # ffffffffc0206190 <commands+0x828>
ffffffffc0202ffc:	25b00593          	li	a1,603
ffffffffc0203000:	00003517          	auipc	a0,0x3
ffffffffc0203004:	69050513          	addi	a0,a0,1680 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc0203008:	c86fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc020300c:	00004697          	auipc	a3,0x4
ffffffffc0203010:	b2468693          	addi	a3,a3,-1244 # ffffffffc0206b30 <default_pmm_manager+0x5f0>
ffffffffc0203014:	00003617          	auipc	a2,0x3
ffffffffc0203018:	17c60613          	addi	a2,a2,380 # ffffffffc0206190 <commands+0x828>
ffffffffc020301c:	25a00593          	li	a1,602
ffffffffc0203020:	00003517          	auipc	a0,0x3
ffffffffc0203024:	67050513          	addi	a0,a0,1648 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc0203028:	c66fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 0);
ffffffffc020302c:	00004697          	auipc	a3,0x4
ffffffffc0203030:	9d468693          	addi	a3,a3,-1580 # ffffffffc0206a00 <default_pmm_manager+0x4c0>
ffffffffc0203034:	00003617          	auipc	a2,0x3
ffffffffc0203038:	15c60613          	addi	a2,a2,348 # ffffffffc0206190 <commands+0x828>
ffffffffc020303c:	23500593          	li	a1,565
ffffffffc0203040:	00003517          	auipc	a0,0x3
ffffffffc0203044:	65050513          	addi	a0,a0,1616 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc0203048:	c46fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 1);
ffffffffc020304c:	00004697          	auipc	a3,0x4
ffffffffc0203050:	85468693          	addi	a3,a3,-1964 # ffffffffc02068a0 <default_pmm_manager+0x360>
ffffffffc0203054:	00003617          	auipc	a2,0x3
ffffffffc0203058:	13c60613          	addi	a2,a2,316 # ffffffffc0206190 <commands+0x828>
ffffffffc020305c:	23400593          	li	a1,564
ffffffffc0203060:	00003517          	auipc	a0,0x3
ffffffffc0203064:	63050513          	addi	a0,a0,1584 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc0203068:	c26fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc020306c:	00004697          	auipc	a3,0x4
ffffffffc0203070:	9ac68693          	addi	a3,a3,-1620 # ffffffffc0206a18 <default_pmm_manager+0x4d8>
ffffffffc0203074:	00003617          	auipc	a2,0x3
ffffffffc0203078:	11c60613          	addi	a2,a2,284 # ffffffffc0206190 <commands+0x828>
ffffffffc020307c:	23100593          	li	a1,561
ffffffffc0203080:	00003517          	auipc	a0,0x3
ffffffffc0203084:	61050513          	addi	a0,a0,1552 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc0203088:	c06fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc020308c:	00003697          	auipc	a3,0x3
ffffffffc0203090:	7fc68693          	addi	a3,a3,2044 # ffffffffc0206888 <default_pmm_manager+0x348>
ffffffffc0203094:	00003617          	auipc	a2,0x3
ffffffffc0203098:	0fc60613          	addi	a2,a2,252 # ffffffffc0206190 <commands+0x828>
ffffffffc020309c:	23000593          	li	a1,560
ffffffffc02030a0:	00003517          	auipc	a0,0x3
ffffffffc02030a4:	5f050513          	addi	a0,a0,1520 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc02030a8:	be6fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc02030ac:	00004697          	auipc	a3,0x4
ffffffffc02030b0:	87c68693          	addi	a3,a3,-1924 # ffffffffc0206928 <default_pmm_manager+0x3e8>
ffffffffc02030b4:	00003617          	auipc	a2,0x3
ffffffffc02030b8:	0dc60613          	addi	a2,a2,220 # ffffffffc0206190 <commands+0x828>
ffffffffc02030bc:	22f00593          	li	a1,559
ffffffffc02030c0:	00003517          	auipc	a0,0x3
ffffffffc02030c4:	5d050513          	addi	a0,a0,1488 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc02030c8:	bc6fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 0);
ffffffffc02030cc:	00004697          	auipc	a3,0x4
ffffffffc02030d0:	93468693          	addi	a3,a3,-1740 # ffffffffc0206a00 <default_pmm_manager+0x4c0>
ffffffffc02030d4:	00003617          	auipc	a2,0x3
ffffffffc02030d8:	0bc60613          	addi	a2,a2,188 # ffffffffc0206190 <commands+0x828>
ffffffffc02030dc:	22e00593          	li	a1,558
ffffffffc02030e0:	00003517          	auipc	a0,0x3
ffffffffc02030e4:	5b050513          	addi	a0,a0,1456 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc02030e8:	ba6fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 2);
ffffffffc02030ec:	00004697          	auipc	a3,0x4
ffffffffc02030f0:	8fc68693          	addi	a3,a3,-1796 # ffffffffc02069e8 <default_pmm_manager+0x4a8>
ffffffffc02030f4:	00003617          	auipc	a2,0x3
ffffffffc02030f8:	09c60613          	addi	a2,a2,156 # ffffffffc0206190 <commands+0x828>
ffffffffc02030fc:	22d00593          	li	a1,557
ffffffffc0203100:	00003517          	auipc	a0,0x3
ffffffffc0203104:	59050513          	addi	a0,a0,1424 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc0203108:	b86fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc020310c:	00004697          	auipc	a3,0x4
ffffffffc0203110:	8ac68693          	addi	a3,a3,-1876 # ffffffffc02069b8 <default_pmm_manager+0x478>
ffffffffc0203114:	00003617          	auipc	a2,0x3
ffffffffc0203118:	07c60613          	addi	a2,a2,124 # ffffffffc0206190 <commands+0x828>
ffffffffc020311c:	22c00593          	li	a1,556
ffffffffc0203120:	00003517          	auipc	a0,0x3
ffffffffc0203124:	57050513          	addi	a0,a0,1392 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc0203128:	b66fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 1);
ffffffffc020312c:	00004697          	auipc	a3,0x4
ffffffffc0203130:	87468693          	addi	a3,a3,-1932 # ffffffffc02069a0 <default_pmm_manager+0x460>
ffffffffc0203134:	00003617          	auipc	a2,0x3
ffffffffc0203138:	05c60613          	addi	a2,a2,92 # ffffffffc0206190 <commands+0x828>
ffffffffc020313c:	22a00593          	li	a1,554
ffffffffc0203140:	00003517          	auipc	a0,0x3
ffffffffc0203144:	55050513          	addi	a0,a0,1360 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc0203148:	b46fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc020314c:	00004697          	auipc	a3,0x4
ffffffffc0203150:	83468693          	addi	a3,a3,-1996 # ffffffffc0206980 <default_pmm_manager+0x440>
ffffffffc0203154:	00003617          	auipc	a2,0x3
ffffffffc0203158:	03c60613          	addi	a2,a2,60 # ffffffffc0206190 <commands+0x828>
ffffffffc020315c:	22900593          	li	a1,553
ffffffffc0203160:	00003517          	auipc	a0,0x3
ffffffffc0203164:	53050513          	addi	a0,a0,1328 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc0203168:	b26fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(*ptep & PTE_W);
ffffffffc020316c:	00004697          	auipc	a3,0x4
ffffffffc0203170:	80468693          	addi	a3,a3,-2044 # ffffffffc0206970 <default_pmm_manager+0x430>
ffffffffc0203174:	00003617          	auipc	a2,0x3
ffffffffc0203178:	01c60613          	addi	a2,a2,28 # ffffffffc0206190 <commands+0x828>
ffffffffc020317c:	22800593          	li	a1,552
ffffffffc0203180:	00003517          	auipc	a0,0x3
ffffffffc0203184:	51050513          	addi	a0,a0,1296 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc0203188:	b06fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(*ptep & PTE_U);
ffffffffc020318c:	00003697          	auipc	a3,0x3
ffffffffc0203190:	7d468693          	addi	a3,a3,2004 # ffffffffc0206960 <default_pmm_manager+0x420>
ffffffffc0203194:	00003617          	auipc	a2,0x3
ffffffffc0203198:	ffc60613          	addi	a2,a2,-4 # ffffffffc0206190 <commands+0x828>
ffffffffc020319c:	22700593          	li	a1,551
ffffffffc02031a0:	00003517          	auipc	a0,0x3
ffffffffc02031a4:	4f050513          	addi	a0,a0,1264 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc02031a8:	ae6fd0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("DTB memory info not available");
ffffffffc02031ac:	00003617          	auipc	a2,0x3
ffffffffc02031b0:	55460613          	addi	a2,a2,1364 # ffffffffc0206700 <default_pmm_manager+0x1c0>
ffffffffc02031b4:	06500593          	li	a1,101
ffffffffc02031b8:	00003517          	auipc	a0,0x3
ffffffffc02031bc:	4d850513          	addi	a0,a0,1240 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc02031c0:	acefd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc02031c4:	00004697          	auipc	a3,0x4
ffffffffc02031c8:	8b468693          	addi	a3,a3,-1868 # ffffffffc0206a78 <default_pmm_manager+0x538>
ffffffffc02031cc:	00003617          	auipc	a2,0x3
ffffffffc02031d0:	fc460613          	addi	a2,a2,-60 # ffffffffc0206190 <commands+0x828>
ffffffffc02031d4:	26d00593          	li	a1,621
ffffffffc02031d8:	00003517          	auipc	a0,0x3
ffffffffc02031dc:	4b850513          	addi	a0,a0,1208 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc02031e0:	aaefd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc02031e4:	00003697          	auipc	a3,0x3
ffffffffc02031e8:	74468693          	addi	a3,a3,1860 # ffffffffc0206928 <default_pmm_manager+0x3e8>
ffffffffc02031ec:	00003617          	auipc	a2,0x3
ffffffffc02031f0:	fa460613          	addi	a2,a2,-92 # ffffffffc0206190 <commands+0x828>
ffffffffc02031f4:	22600593          	li	a1,550
ffffffffc02031f8:	00003517          	auipc	a0,0x3
ffffffffc02031fc:	49850513          	addi	a0,a0,1176 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc0203200:	a8efd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0203204:	00003697          	auipc	a3,0x3
ffffffffc0203208:	6e468693          	addi	a3,a3,1764 # ffffffffc02068e8 <default_pmm_manager+0x3a8>
ffffffffc020320c:	00003617          	auipc	a2,0x3
ffffffffc0203210:	f8460613          	addi	a2,a2,-124 # ffffffffc0206190 <commands+0x828>
ffffffffc0203214:	22500593          	li	a1,549
ffffffffc0203218:	00003517          	auipc	a0,0x3
ffffffffc020321c:	47850513          	addi	a0,a0,1144 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc0203220:	a6efd0ef          	jal	ra,ffffffffc020048e <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0203224:	86d6                	mv	a3,s5
ffffffffc0203226:	00003617          	auipc	a2,0x3
ffffffffc020322a:	35260613          	addi	a2,a2,850 # ffffffffc0206578 <default_pmm_manager+0x38>
ffffffffc020322e:	22100593          	li	a1,545
ffffffffc0203232:	00003517          	auipc	a0,0x3
ffffffffc0203236:	45e50513          	addi	a0,a0,1118 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc020323a:	a54fd0ef          	jal	ra,ffffffffc020048e <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc020323e:	00003617          	auipc	a2,0x3
ffffffffc0203242:	33a60613          	addi	a2,a2,826 # ffffffffc0206578 <default_pmm_manager+0x38>
ffffffffc0203246:	22000593          	li	a1,544
ffffffffc020324a:	00003517          	auipc	a0,0x3
ffffffffc020324e:	44650513          	addi	a0,a0,1094 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc0203252:	a3cfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0203256:	00003697          	auipc	a3,0x3
ffffffffc020325a:	64a68693          	addi	a3,a3,1610 # ffffffffc02068a0 <default_pmm_manager+0x360>
ffffffffc020325e:	00003617          	auipc	a2,0x3
ffffffffc0203262:	f3260613          	addi	a2,a2,-206 # ffffffffc0206190 <commands+0x828>
ffffffffc0203266:	21e00593          	li	a1,542
ffffffffc020326a:	00003517          	auipc	a0,0x3
ffffffffc020326e:	42650513          	addi	a0,a0,1062 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc0203272:	a1cfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0203276:	00003697          	auipc	a3,0x3
ffffffffc020327a:	61268693          	addi	a3,a3,1554 # ffffffffc0206888 <default_pmm_manager+0x348>
ffffffffc020327e:	00003617          	auipc	a2,0x3
ffffffffc0203282:	f1260613          	addi	a2,a2,-238 # ffffffffc0206190 <commands+0x828>
ffffffffc0203286:	21d00593          	li	a1,541
ffffffffc020328a:	00003517          	auipc	a0,0x3
ffffffffc020328e:	40650513          	addi	a0,a0,1030 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc0203292:	9fcfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc0203296:	00004697          	auipc	a3,0x4
ffffffffc020329a:	9a268693          	addi	a3,a3,-1630 # ffffffffc0206c38 <default_pmm_manager+0x6f8>
ffffffffc020329e:	00003617          	auipc	a2,0x3
ffffffffc02032a2:	ef260613          	addi	a2,a2,-270 # ffffffffc0206190 <commands+0x828>
ffffffffc02032a6:	26400593          	li	a1,612
ffffffffc02032aa:	00003517          	auipc	a0,0x3
ffffffffc02032ae:	3e650513          	addi	a0,a0,998 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc02032b2:	9dcfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc02032b6:	00004697          	auipc	a3,0x4
ffffffffc02032ba:	94a68693          	addi	a3,a3,-1718 # ffffffffc0206c00 <default_pmm_manager+0x6c0>
ffffffffc02032be:	00003617          	auipc	a2,0x3
ffffffffc02032c2:	ed260613          	addi	a2,a2,-302 # ffffffffc0206190 <commands+0x828>
ffffffffc02032c6:	26100593          	li	a1,609
ffffffffc02032ca:	00003517          	auipc	a0,0x3
ffffffffc02032ce:	3c650513          	addi	a0,a0,966 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc02032d2:	9bcfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p) == 2);
ffffffffc02032d6:	00004697          	auipc	a3,0x4
ffffffffc02032da:	8fa68693          	addi	a3,a3,-1798 # ffffffffc0206bd0 <default_pmm_manager+0x690>
ffffffffc02032de:	00003617          	auipc	a2,0x3
ffffffffc02032e2:	eb260613          	addi	a2,a2,-334 # ffffffffc0206190 <commands+0x828>
ffffffffc02032e6:	25d00593          	li	a1,605
ffffffffc02032ea:	00003517          	auipc	a0,0x3
ffffffffc02032ee:	3a650513          	addi	a0,a0,934 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc02032f2:	99cfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc02032f6:	00004697          	auipc	a3,0x4
ffffffffc02032fa:	89268693          	addi	a3,a3,-1902 # ffffffffc0206b88 <default_pmm_manager+0x648>
ffffffffc02032fe:	00003617          	auipc	a2,0x3
ffffffffc0203302:	e9260613          	addi	a2,a2,-366 # ffffffffc0206190 <commands+0x828>
ffffffffc0203306:	25c00593          	li	a1,604
ffffffffc020330a:	00003517          	auipc	a0,0x3
ffffffffc020330e:	38650513          	addi	a0,a0,902 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc0203312:	97cfd0ef          	jal	ra,ffffffffc020048e <__panic>
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc0203316:	00003617          	auipc	a2,0x3
ffffffffc020331a:	30a60613          	addi	a2,a2,778 # ffffffffc0206620 <default_pmm_manager+0xe0>
ffffffffc020331e:	0c900593          	li	a1,201
ffffffffc0203322:	00003517          	auipc	a0,0x3
ffffffffc0203326:	36e50513          	addi	a0,a0,878 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc020332a:	964fd0ef          	jal	ra,ffffffffc020048e <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc020332e:	00003617          	auipc	a2,0x3
ffffffffc0203332:	2f260613          	addi	a2,a2,754 # ffffffffc0206620 <default_pmm_manager+0xe0>
ffffffffc0203336:	08100593          	li	a1,129
ffffffffc020333a:	00003517          	auipc	a0,0x3
ffffffffc020333e:	35650513          	addi	a0,a0,854 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc0203342:	94cfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc0203346:	00003697          	auipc	a3,0x3
ffffffffc020334a:	51268693          	addi	a3,a3,1298 # ffffffffc0206858 <default_pmm_manager+0x318>
ffffffffc020334e:	00003617          	auipc	a2,0x3
ffffffffc0203352:	e4260613          	addi	a2,a2,-446 # ffffffffc0206190 <commands+0x828>
ffffffffc0203356:	21c00593          	li	a1,540
ffffffffc020335a:	00003517          	auipc	a0,0x3
ffffffffc020335e:	33650513          	addi	a0,a0,822 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc0203362:	92cfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc0203366:	00003697          	auipc	a3,0x3
ffffffffc020336a:	4c268693          	addi	a3,a3,1218 # ffffffffc0206828 <default_pmm_manager+0x2e8>
ffffffffc020336e:	00003617          	auipc	a2,0x3
ffffffffc0203372:	e2260613          	addi	a2,a2,-478 # ffffffffc0206190 <commands+0x828>
ffffffffc0203376:	21900593          	li	a1,537
ffffffffc020337a:	00003517          	auipc	a0,0x3
ffffffffc020337e:	31650513          	addi	a0,a0,790 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc0203382:	90cfd0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203386 <copy_range>:
{
ffffffffc0203386:	7159                	addi	sp,sp,-112
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0203388:	00d667b3          	or	a5,a2,a3
{
ffffffffc020338c:	f486                	sd	ra,104(sp)
ffffffffc020338e:	f0a2                	sd	s0,96(sp)
ffffffffc0203390:	eca6                	sd	s1,88(sp)
ffffffffc0203392:	e8ca                	sd	s2,80(sp)
ffffffffc0203394:	e4ce                	sd	s3,72(sp)
ffffffffc0203396:	e0d2                	sd	s4,64(sp)
ffffffffc0203398:	fc56                	sd	s5,56(sp)
ffffffffc020339a:	f85a                	sd	s6,48(sp)
ffffffffc020339c:	f45e                	sd	s7,40(sp)
ffffffffc020339e:	f062                	sd	s8,32(sp)
ffffffffc02033a0:	ec66                	sd	s9,24(sp)
ffffffffc02033a2:	e86a                	sd	s10,16(sp)
ffffffffc02033a4:	e46e                	sd	s11,8(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02033a6:	17d2                	slli	a5,a5,0x34
ffffffffc02033a8:	20079f63          	bnez	a5,ffffffffc02035c6 <copy_range+0x240>
    assert(USER_ACCESS(start, end));
ffffffffc02033ac:	002007b7          	lui	a5,0x200
ffffffffc02033b0:	8432                	mv	s0,a2
ffffffffc02033b2:	1af66263          	bltu	a2,a5,ffffffffc0203556 <copy_range+0x1d0>
ffffffffc02033b6:	8936                	mv	s2,a3
ffffffffc02033b8:	18d67f63          	bgeu	a2,a3,ffffffffc0203556 <copy_range+0x1d0>
ffffffffc02033bc:	4785                	li	a5,1
ffffffffc02033be:	07fe                	slli	a5,a5,0x1f
ffffffffc02033c0:	18d7eb63          	bltu	a5,a3,ffffffffc0203556 <copy_range+0x1d0>
ffffffffc02033c4:	5b7d                	li	s6,-1
ffffffffc02033c6:	8aaa                	mv	s5,a0
ffffffffc02033c8:	89ae                	mv	s3,a1
        start += PGSIZE;
ffffffffc02033ca:	6a05                	lui	s4,0x1
    if (PPN(pa) >= npage)
ffffffffc02033cc:	000a7c17          	auipc	s8,0xa7
ffffffffc02033d0:	424c0c13          	addi	s8,s8,1060 # ffffffffc02aa7f0 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc02033d4:	000a7b97          	auipc	s7,0xa7
ffffffffc02033d8:	424b8b93          	addi	s7,s7,1060 # ffffffffc02aa7f8 <pages>
    return KADDR(page2pa(page));
ffffffffc02033dc:	00cb5b13          	srli	s6,s6,0xc
        page = pmm_manager->alloc_pages(n);
ffffffffc02033e0:	000a7c97          	auipc	s9,0xa7
ffffffffc02033e4:	420c8c93          	addi	s9,s9,1056 # ffffffffc02aa800 <pmm_manager>
        pte_t *ptep = get_pte(from, start, 0), *nptep;
ffffffffc02033e8:	4601                	li	a2,0
ffffffffc02033ea:	85a2                	mv	a1,s0
ffffffffc02033ec:	854e                	mv	a0,s3
ffffffffc02033ee:	b73fe0ef          	jal	ra,ffffffffc0201f60 <get_pte>
ffffffffc02033f2:	84aa                	mv	s1,a0
        if (ptep == NULL)
ffffffffc02033f4:	0e050c63          	beqz	a0,ffffffffc02034ec <copy_range+0x166>
        if (*ptep & PTE_V)
ffffffffc02033f8:	611c                	ld	a5,0(a0)
ffffffffc02033fa:	8b85                	andi	a5,a5,1
ffffffffc02033fc:	e785                	bnez	a5,ffffffffc0203424 <copy_range+0x9e>
        start += PGSIZE;
ffffffffc02033fe:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc0203400:	ff2464e3          	bltu	s0,s2,ffffffffc02033e8 <copy_range+0x62>
    return 0;
ffffffffc0203404:	4501                	li	a0,0
}
ffffffffc0203406:	70a6                	ld	ra,104(sp)
ffffffffc0203408:	7406                	ld	s0,96(sp)
ffffffffc020340a:	64e6                	ld	s1,88(sp)
ffffffffc020340c:	6946                	ld	s2,80(sp)
ffffffffc020340e:	69a6                	ld	s3,72(sp)
ffffffffc0203410:	6a06                	ld	s4,64(sp)
ffffffffc0203412:	7ae2                	ld	s5,56(sp)
ffffffffc0203414:	7b42                	ld	s6,48(sp)
ffffffffc0203416:	7ba2                	ld	s7,40(sp)
ffffffffc0203418:	7c02                	ld	s8,32(sp)
ffffffffc020341a:	6ce2                	ld	s9,24(sp)
ffffffffc020341c:	6d42                	ld	s10,16(sp)
ffffffffc020341e:	6da2                	ld	s11,8(sp)
ffffffffc0203420:	6165                	addi	sp,sp,112
ffffffffc0203422:	8082                	ret
            if ((nptep = get_pte(to, start, 1)) == NULL)
ffffffffc0203424:	4605                	li	a2,1
ffffffffc0203426:	85a2                	mv	a1,s0
ffffffffc0203428:	8556                	mv	a0,s5
ffffffffc020342a:	b37fe0ef          	jal	ra,ffffffffc0201f60 <get_pte>
ffffffffc020342e:	c56d                	beqz	a0,ffffffffc0203518 <copy_range+0x192>
            uint32_t perm = (*ptep & PTE_USER);
ffffffffc0203430:	609c                	ld	a5,0(s1)
    if (!(pte & PTE_V))
ffffffffc0203432:	0017f713          	andi	a4,a5,1
ffffffffc0203436:	01f7f493          	andi	s1,a5,31
ffffffffc020343a:	16070a63          	beqz	a4,ffffffffc02035ae <copy_range+0x228>
    if (PPN(pa) >= npage)
ffffffffc020343e:	000c3683          	ld	a3,0(s8)
    return pa2page(PTE_ADDR(pte));
ffffffffc0203442:	078a                	slli	a5,a5,0x2
ffffffffc0203444:	00c7d713          	srli	a4,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0203448:	14d77763          	bgeu	a4,a3,ffffffffc0203596 <copy_range+0x210>
    return &pages[PPN(pa) - nbase];
ffffffffc020344c:	000bb783          	ld	a5,0(s7)
ffffffffc0203450:	fff806b7          	lui	a3,0xfff80
ffffffffc0203454:	9736                	add	a4,a4,a3
ffffffffc0203456:	071a                	slli	a4,a4,0x6
ffffffffc0203458:	00e78db3          	add	s11,a5,a4
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020345c:	10002773          	csrr	a4,sstatus
ffffffffc0203460:	8b09                	andi	a4,a4,2
ffffffffc0203462:	e345                	bnez	a4,ffffffffc0203502 <copy_range+0x17c>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203464:	000cb703          	ld	a4,0(s9)
ffffffffc0203468:	4505                	li	a0,1
ffffffffc020346a:	6f18                	ld	a4,24(a4)
ffffffffc020346c:	9702                	jalr	a4
ffffffffc020346e:	8d2a                	mv	s10,a0
            assert(page != NULL);
ffffffffc0203470:	0c0d8363          	beqz	s11,ffffffffc0203536 <copy_range+0x1b0>
            assert(npage != NULL);
ffffffffc0203474:	100d0163          	beqz	s10,ffffffffc0203576 <copy_range+0x1f0>
    return page - pages + nbase;
ffffffffc0203478:	000bb703          	ld	a4,0(s7)
ffffffffc020347c:	000805b7          	lui	a1,0x80
    return KADDR(page2pa(page));
ffffffffc0203480:	000c3603          	ld	a2,0(s8)
    return page - pages + nbase;
ffffffffc0203484:	40ed86b3          	sub	a3,s11,a4
ffffffffc0203488:	8699                	srai	a3,a3,0x6
ffffffffc020348a:	96ae                	add	a3,a3,a1
    return KADDR(page2pa(page));
ffffffffc020348c:	0166f7b3          	and	a5,a3,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc0203490:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0203492:	08c7f663          	bgeu	a5,a2,ffffffffc020351e <copy_range+0x198>
    return page - pages + nbase;
ffffffffc0203496:	40ed07b3          	sub	a5,s10,a4
    return KADDR(page2pa(page));
ffffffffc020349a:	000a7717          	auipc	a4,0xa7
ffffffffc020349e:	36e70713          	addi	a4,a4,878 # ffffffffc02aa808 <va_pa_offset>
ffffffffc02034a2:	6308                	ld	a0,0(a4)
    return page - pages + nbase;
ffffffffc02034a4:	8799                	srai	a5,a5,0x6
ffffffffc02034a6:	97ae                	add	a5,a5,a1
    return KADDR(page2pa(page));
ffffffffc02034a8:	0167f733          	and	a4,a5,s6
ffffffffc02034ac:	00a685b3          	add	a1,a3,a0
    return page2ppn(page) << PGSHIFT;
ffffffffc02034b0:	07b2                	slli	a5,a5,0xc
    return KADDR(page2pa(page));
ffffffffc02034b2:	06c77563          	bgeu	a4,a2,ffffffffc020351c <copy_range+0x196>
            memcpy(dst_kvaddr, src_kvaddr, PGSIZE);
ffffffffc02034b6:	6605                	lui	a2,0x1
ffffffffc02034b8:	953e                	add	a0,a0,a5
ffffffffc02034ba:	22a020ef          	jal	ra,ffffffffc02056e4 <memcpy>
            ret = page_insert(to, npage, start, perm);
ffffffffc02034be:	86a6                	mv	a3,s1
ffffffffc02034c0:	8622                	mv	a2,s0
ffffffffc02034c2:	85ea                	mv	a1,s10
ffffffffc02034c4:	8556                	mv	a0,s5
ffffffffc02034c6:	98aff0ef          	jal	ra,ffffffffc0202650 <page_insert>
            assert(ret == 0);
ffffffffc02034ca:	d915                	beqz	a0,ffffffffc02033fe <copy_range+0x78>
ffffffffc02034cc:	00003697          	auipc	a3,0x3
ffffffffc02034d0:	7d468693          	addi	a3,a3,2004 # ffffffffc0206ca0 <default_pmm_manager+0x760>
ffffffffc02034d4:	00003617          	auipc	a2,0x3
ffffffffc02034d8:	cbc60613          	addi	a2,a2,-836 # ffffffffc0206190 <commands+0x828>
ffffffffc02034dc:	1b100593          	li	a1,433
ffffffffc02034e0:	00003517          	auipc	a0,0x3
ffffffffc02034e4:	1b050513          	addi	a0,a0,432 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc02034e8:	fa7fc0ef          	jal	ra,ffffffffc020048e <__panic>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc02034ec:	00200637          	lui	a2,0x200
ffffffffc02034f0:	9432                	add	s0,s0,a2
ffffffffc02034f2:	ffe00637          	lui	a2,0xffe00
ffffffffc02034f6:	8c71                	and	s0,s0,a2
    } while (start != 0 && start < end);
ffffffffc02034f8:	f00406e3          	beqz	s0,ffffffffc0203404 <copy_range+0x7e>
ffffffffc02034fc:	ef2466e3          	bltu	s0,s2,ffffffffc02033e8 <copy_range+0x62>
ffffffffc0203500:	b711                	j	ffffffffc0203404 <copy_range+0x7e>
        intr_disable();
ffffffffc0203502:	cb2fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203506:	000cb703          	ld	a4,0(s9)
ffffffffc020350a:	4505                	li	a0,1
ffffffffc020350c:	6f18                	ld	a4,24(a4)
ffffffffc020350e:	9702                	jalr	a4
ffffffffc0203510:	8d2a                	mv	s10,a0
        intr_enable();
ffffffffc0203512:	c9cfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203516:	bfa9                	j	ffffffffc0203470 <copy_range+0xea>
                return -E_NO_MEM;
ffffffffc0203518:	5571                	li	a0,-4
ffffffffc020351a:	b5f5                	j	ffffffffc0203406 <copy_range+0x80>
ffffffffc020351c:	86be                	mv	a3,a5
ffffffffc020351e:	00003617          	auipc	a2,0x3
ffffffffc0203522:	05a60613          	addi	a2,a2,90 # ffffffffc0206578 <default_pmm_manager+0x38>
ffffffffc0203526:	07100593          	li	a1,113
ffffffffc020352a:	00003517          	auipc	a0,0x3
ffffffffc020352e:	07650513          	addi	a0,a0,118 # ffffffffc02065a0 <default_pmm_manager+0x60>
ffffffffc0203532:	f5dfc0ef          	jal	ra,ffffffffc020048e <__panic>
            assert(page != NULL);
ffffffffc0203536:	00003697          	auipc	a3,0x3
ffffffffc020353a:	74a68693          	addi	a3,a3,1866 # ffffffffc0206c80 <default_pmm_manager+0x740>
ffffffffc020353e:	00003617          	auipc	a2,0x3
ffffffffc0203542:	c5260613          	addi	a2,a2,-942 # ffffffffc0206190 <commands+0x828>
ffffffffc0203546:	19400593          	li	a1,404
ffffffffc020354a:	00003517          	auipc	a0,0x3
ffffffffc020354e:	14650513          	addi	a0,a0,326 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc0203552:	f3dfc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc0203556:	00003697          	auipc	a3,0x3
ffffffffc020355a:	17a68693          	addi	a3,a3,378 # ffffffffc02066d0 <default_pmm_manager+0x190>
ffffffffc020355e:	00003617          	auipc	a2,0x3
ffffffffc0203562:	c3260613          	addi	a2,a2,-974 # ffffffffc0206190 <commands+0x828>
ffffffffc0203566:	17c00593          	li	a1,380
ffffffffc020356a:	00003517          	auipc	a0,0x3
ffffffffc020356e:	12650513          	addi	a0,a0,294 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc0203572:	f1dfc0ef          	jal	ra,ffffffffc020048e <__panic>
            assert(npage != NULL);
ffffffffc0203576:	00003697          	auipc	a3,0x3
ffffffffc020357a:	71a68693          	addi	a3,a3,1818 # ffffffffc0206c90 <default_pmm_manager+0x750>
ffffffffc020357e:	00003617          	auipc	a2,0x3
ffffffffc0203582:	c1260613          	addi	a2,a2,-1006 # ffffffffc0206190 <commands+0x828>
ffffffffc0203586:	19500593          	li	a1,405
ffffffffc020358a:	00003517          	auipc	a0,0x3
ffffffffc020358e:	10650513          	addi	a0,a0,262 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc0203592:	efdfc0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0203596:	00003617          	auipc	a2,0x3
ffffffffc020359a:	0b260613          	addi	a2,a2,178 # ffffffffc0206648 <default_pmm_manager+0x108>
ffffffffc020359e:	06900593          	li	a1,105
ffffffffc02035a2:	00003517          	auipc	a0,0x3
ffffffffc02035a6:	ffe50513          	addi	a0,a0,-2 # ffffffffc02065a0 <default_pmm_manager+0x60>
ffffffffc02035aa:	ee5fc0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pte2page called with invalid pte");
ffffffffc02035ae:	00003617          	auipc	a2,0x3
ffffffffc02035b2:	0ba60613          	addi	a2,a2,186 # ffffffffc0206668 <default_pmm_manager+0x128>
ffffffffc02035b6:	07f00593          	li	a1,127
ffffffffc02035ba:	00003517          	auipc	a0,0x3
ffffffffc02035be:	fe650513          	addi	a0,a0,-26 # ffffffffc02065a0 <default_pmm_manager+0x60>
ffffffffc02035c2:	ecdfc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02035c6:	00003697          	auipc	a3,0x3
ffffffffc02035ca:	0da68693          	addi	a3,a3,218 # ffffffffc02066a0 <default_pmm_manager+0x160>
ffffffffc02035ce:	00003617          	auipc	a2,0x3
ffffffffc02035d2:	bc260613          	addi	a2,a2,-1086 # ffffffffc0206190 <commands+0x828>
ffffffffc02035d6:	17b00593          	li	a1,379
ffffffffc02035da:	00003517          	auipc	a0,0x3
ffffffffc02035de:	0b650513          	addi	a0,a0,182 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc02035e2:	eadfc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02035e6 <pgdir_alloc_page>:
{
ffffffffc02035e6:	7179                	addi	sp,sp,-48
ffffffffc02035e8:	ec26                	sd	s1,24(sp)
ffffffffc02035ea:	e84a                	sd	s2,16(sp)
ffffffffc02035ec:	e052                	sd	s4,0(sp)
ffffffffc02035ee:	f406                	sd	ra,40(sp)
ffffffffc02035f0:	f022                	sd	s0,32(sp)
ffffffffc02035f2:	e44e                	sd	s3,8(sp)
ffffffffc02035f4:	8a2a                	mv	s4,a0
ffffffffc02035f6:	84ae                	mv	s1,a1
ffffffffc02035f8:	8932                	mv	s2,a2
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02035fa:	100027f3          	csrr	a5,sstatus
ffffffffc02035fe:	8b89                	andi	a5,a5,2
        page = pmm_manager->alloc_pages(n);
ffffffffc0203600:	000a7997          	auipc	s3,0xa7
ffffffffc0203604:	20098993          	addi	s3,s3,512 # ffffffffc02aa800 <pmm_manager>
ffffffffc0203608:	ef8d                	bnez	a5,ffffffffc0203642 <pgdir_alloc_page+0x5c>
ffffffffc020360a:	0009b783          	ld	a5,0(s3)
ffffffffc020360e:	4505                	li	a0,1
ffffffffc0203610:	6f9c                	ld	a5,24(a5)
ffffffffc0203612:	9782                	jalr	a5
ffffffffc0203614:	842a                	mv	s0,a0
    if (page != NULL)
ffffffffc0203616:	cc09                	beqz	s0,ffffffffc0203630 <pgdir_alloc_page+0x4a>
        if (page_insert(pgdir, page, la, perm) != 0)
ffffffffc0203618:	86ca                	mv	a3,s2
ffffffffc020361a:	8626                	mv	a2,s1
ffffffffc020361c:	85a2                	mv	a1,s0
ffffffffc020361e:	8552                	mv	a0,s4
ffffffffc0203620:	830ff0ef          	jal	ra,ffffffffc0202650 <page_insert>
ffffffffc0203624:	e915                	bnez	a0,ffffffffc0203658 <pgdir_alloc_page+0x72>
        assert(page_ref(page) == 1);
ffffffffc0203626:	4018                	lw	a4,0(s0)
        page->pra_vaddr = la;
ffffffffc0203628:	fc04                	sd	s1,56(s0)
        assert(page_ref(page) == 1);
ffffffffc020362a:	4785                	li	a5,1
ffffffffc020362c:	04f71e63          	bne	a4,a5,ffffffffc0203688 <pgdir_alloc_page+0xa2>
}
ffffffffc0203630:	70a2                	ld	ra,40(sp)
ffffffffc0203632:	8522                	mv	a0,s0
ffffffffc0203634:	7402                	ld	s0,32(sp)
ffffffffc0203636:	64e2                	ld	s1,24(sp)
ffffffffc0203638:	6942                	ld	s2,16(sp)
ffffffffc020363a:	69a2                	ld	s3,8(sp)
ffffffffc020363c:	6a02                	ld	s4,0(sp)
ffffffffc020363e:	6145                	addi	sp,sp,48
ffffffffc0203640:	8082                	ret
        intr_disable();
ffffffffc0203642:	b72fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203646:	0009b783          	ld	a5,0(s3)
ffffffffc020364a:	4505                	li	a0,1
ffffffffc020364c:	6f9c                	ld	a5,24(a5)
ffffffffc020364e:	9782                	jalr	a5
ffffffffc0203650:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0203652:	b5cfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203656:	b7c1                	j	ffffffffc0203616 <pgdir_alloc_page+0x30>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203658:	100027f3          	csrr	a5,sstatus
ffffffffc020365c:	8b89                	andi	a5,a5,2
ffffffffc020365e:	eb89                	bnez	a5,ffffffffc0203670 <pgdir_alloc_page+0x8a>
        pmm_manager->free_pages(base, n);
ffffffffc0203660:	0009b783          	ld	a5,0(s3)
ffffffffc0203664:	8522                	mv	a0,s0
ffffffffc0203666:	4585                	li	a1,1
ffffffffc0203668:	739c                	ld	a5,32(a5)
            return NULL;
ffffffffc020366a:	4401                	li	s0,0
        pmm_manager->free_pages(base, n);
ffffffffc020366c:	9782                	jalr	a5
    if (flag)
ffffffffc020366e:	b7c9                	j	ffffffffc0203630 <pgdir_alloc_page+0x4a>
        intr_disable();
ffffffffc0203670:	b44fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0203674:	0009b783          	ld	a5,0(s3)
ffffffffc0203678:	8522                	mv	a0,s0
ffffffffc020367a:	4585                	li	a1,1
ffffffffc020367c:	739c                	ld	a5,32(a5)
            return NULL;
ffffffffc020367e:	4401                	li	s0,0
        pmm_manager->free_pages(base, n);
ffffffffc0203680:	9782                	jalr	a5
        intr_enable();
ffffffffc0203682:	b2cfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203686:	b76d                	j	ffffffffc0203630 <pgdir_alloc_page+0x4a>
        assert(page_ref(page) == 1);
ffffffffc0203688:	00003697          	auipc	a3,0x3
ffffffffc020368c:	62868693          	addi	a3,a3,1576 # ffffffffc0206cb0 <default_pmm_manager+0x770>
ffffffffc0203690:	00003617          	auipc	a2,0x3
ffffffffc0203694:	b0060613          	addi	a2,a2,-1280 # ffffffffc0206190 <commands+0x828>
ffffffffc0203698:	1fa00593          	li	a1,506
ffffffffc020369c:	00003517          	auipc	a0,0x3
ffffffffc02036a0:	ff450513          	addi	a0,a0,-12 # ffffffffc0206690 <default_pmm_manager+0x150>
ffffffffc02036a4:	debfc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02036a8 <check_vma_overlap.part.0>:
    return vma;
}

// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc02036a8:	1141                	addi	sp,sp,-16
{
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc02036aa:	00003697          	auipc	a3,0x3
ffffffffc02036ae:	61e68693          	addi	a3,a3,1566 # ffffffffc0206cc8 <default_pmm_manager+0x788>
ffffffffc02036b2:	00003617          	auipc	a2,0x3
ffffffffc02036b6:	ade60613          	addi	a2,a2,-1314 # ffffffffc0206190 <commands+0x828>
ffffffffc02036ba:	07400593          	li	a1,116
ffffffffc02036be:	00003517          	auipc	a0,0x3
ffffffffc02036c2:	62a50513          	addi	a0,a0,1578 # ffffffffc0206ce8 <default_pmm_manager+0x7a8>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc02036c6:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc02036c8:	dc7fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02036cc <mm_create>:
{
ffffffffc02036cc:	1141                	addi	sp,sp,-16
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc02036ce:	04000513          	li	a0,64
{
ffffffffc02036d2:	e406                	sd	ra,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc02036d4:	df6fe0ef          	jal	ra,ffffffffc0201cca <kmalloc>
    if (mm != NULL)
ffffffffc02036d8:	cd19                	beqz	a0,ffffffffc02036f6 <mm_create+0x2a>
    elm->prev = elm->next = elm;
ffffffffc02036da:	e508                	sd	a0,8(a0)
ffffffffc02036dc:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc02036de:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc02036e2:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc02036e6:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc02036ea:	02053423          	sd	zero,40(a0)
}

static inline void
set_mm_count(struct mm_struct *mm, int val)
{
    mm->mm_count = val;
ffffffffc02036ee:	02052823          	sw	zero,48(a0)
typedef volatile bool lock_t;

static inline void
lock_init(lock_t *lock)
{
    *lock = 0;
ffffffffc02036f2:	02053c23          	sd	zero,56(a0)
}
ffffffffc02036f6:	60a2                	ld	ra,8(sp)
ffffffffc02036f8:	0141                	addi	sp,sp,16
ffffffffc02036fa:	8082                	ret

ffffffffc02036fc <find_vma>:
{
ffffffffc02036fc:	86aa                	mv	a3,a0
    if (mm != NULL)
ffffffffc02036fe:	c505                	beqz	a0,ffffffffc0203726 <find_vma+0x2a>
        vma = mm->mmap_cache;
ffffffffc0203700:	6908                	ld	a0,16(a0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc0203702:	c501                	beqz	a0,ffffffffc020370a <find_vma+0xe>
ffffffffc0203704:	651c                	ld	a5,8(a0)
ffffffffc0203706:	02f5f263          	bgeu	a1,a5,ffffffffc020372a <find_vma+0x2e>
    return listelm->next;
ffffffffc020370a:	669c                	ld	a5,8(a3)
            while ((le = list_next(le)) != list)
ffffffffc020370c:	00f68d63          	beq	a3,a5,ffffffffc0203726 <find_vma+0x2a>
                if (vma->vm_start <= addr && addr < vma->vm_end)
ffffffffc0203710:	fe87b703          	ld	a4,-24(a5) # 1fffe8 <_binary_obj___user_exit_out_size+0x1f4eb8>
ffffffffc0203714:	00e5e663          	bltu	a1,a4,ffffffffc0203720 <find_vma+0x24>
ffffffffc0203718:	ff07b703          	ld	a4,-16(a5)
ffffffffc020371c:	00e5ec63          	bltu	a1,a4,ffffffffc0203734 <find_vma+0x38>
ffffffffc0203720:	679c                	ld	a5,8(a5)
            while ((le = list_next(le)) != list)
ffffffffc0203722:	fef697e3          	bne	a3,a5,ffffffffc0203710 <find_vma+0x14>
    struct vma_struct *vma = NULL;
ffffffffc0203726:	4501                	li	a0,0
}
ffffffffc0203728:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc020372a:	691c                	ld	a5,16(a0)
ffffffffc020372c:	fcf5ffe3          	bgeu	a1,a5,ffffffffc020370a <find_vma+0xe>
            mm->mmap_cache = vma;
ffffffffc0203730:	ea88                	sd	a0,16(a3)
ffffffffc0203732:	8082                	ret
                vma = le2vma(le, list_link);
ffffffffc0203734:	fe078513          	addi	a0,a5,-32
            mm->mmap_cache = vma;
ffffffffc0203738:	ea88                	sd	a0,16(a3)
ffffffffc020373a:	8082                	ret

ffffffffc020373c <insert_vma_struct>:
}

// insert_vma_struct -insert vma in mm's list link
void insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma)
{
    assert(vma->vm_start < vma->vm_end);
ffffffffc020373c:	6590                	ld	a2,8(a1)
ffffffffc020373e:	0105b803          	ld	a6,16(a1) # 80010 <_binary_obj___user_exit_out_size+0x74ee0>
{
ffffffffc0203742:	1141                	addi	sp,sp,-16
ffffffffc0203744:	e406                	sd	ra,8(sp)
ffffffffc0203746:	87aa                	mv	a5,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc0203748:	01066763          	bltu	a2,a6,ffffffffc0203756 <insert_vma_struct+0x1a>
ffffffffc020374c:	a085                	j	ffffffffc02037ac <insert_vma_struct+0x70>

    list_entry_t *le = list;
    while ((le = list_next(le)) != list)
    {
        struct vma_struct *mmap_prev = le2vma(le, list_link);
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc020374e:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203752:	04e66863          	bltu	a2,a4,ffffffffc02037a2 <insert_vma_struct+0x66>
ffffffffc0203756:	86be                	mv	a3,a5
ffffffffc0203758:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != list)
ffffffffc020375a:	fef51ae3          	bne	a0,a5,ffffffffc020374e <insert_vma_struct+0x12>
    }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list)
ffffffffc020375e:	02a68463          	beq	a3,a0,ffffffffc0203786 <insert_vma_struct+0x4a>
    {
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc0203762:	ff06b703          	ld	a4,-16(a3)
    assert(prev->vm_start < prev->vm_end);
ffffffffc0203766:	fe86b883          	ld	a7,-24(a3)
ffffffffc020376a:	08e8f163          	bgeu	a7,a4,ffffffffc02037ec <insert_vma_struct+0xb0>
    assert(prev->vm_end <= next->vm_start);
ffffffffc020376e:	04e66f63          	bltu	a2,a4,ffffffffc02037cc <insert_vma_struct+0x90>
    }
    if (le_next != list)
ffffffffc0203772:	00f50a63          	beq	a0,a5,ffffffffc0203786 <insert_vma_struct+0x4a>
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc0203776:	fe87b703          	ld	a4,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc020377a:	05076963          	bltu	a4,a6,ffffffffc02037cc <insert_vma_struct+0x90>
    assert(next->vm_start < next->vm_end);
ffffffffc020377e:	ff07b603          	ld	a2,-16(a5)
ffffffffc0203782:	02c77363          	bgeu	a4,a2,ffffffffc02037a8 <insert_vma_struct+0x6c>
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count++;
ffffffffc0203786:	5118                	lw	a4,32(a0)
    vma->vm_mm = mm;
ffffffffc0203788:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc020378a:	02058613          	addi	a2,a1,32
    prev->next = next->prev = elm;
ffffffffc020378e:	e390                	sd	a2,0(a5)
ffffffffc0203790:	e690                	sd	a2,8(a3)
}
ffffffffc0203792:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc0203794:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc0203796:	f194                	sd	a3,32(a1)
    mm->map_count++;
ffffffffc0203798:	0017079b          	addiw	a5,a4,1
ffffffffc020379c:	d11c                	sw	a5,32(a0)
}
ffffffffc020379e:	0141                	addi	sp,sp,16
ffffffffc02037a0:	8082                	ret
    if (le_prev != list)
ffffffffc02037a2:	fca690e3          	bne	a3,a0,ffffffffc0203762 <insert_vma_struct+0x26>
ffffffffc02037a6:	bfd1                	j	ffffffffc020377a <insert_vma_struct+0x3e>
ffffffffc02037a8:	f01ff0ef          	jal	ra,ffffffffc02036a8 <check_vma_overlap.part.0>
    assert(vma->vm_start < vma->vm_end);
ffffffffc02037ac:	00003697          	auipc	a3,0x3
ffffffffc02037b0:	54c68693          	addi	a3,a3,1356 # ffffffffc0206cf8 <default_pmm_manager+0x7b8>
ffffffffc02037b4:	00003617          	auipc	a2,0x3
ffffffffc02037b8:	9dc60613          	addi	a2,a2,-1572 # ffffffffc0206190 <commands+0x828>
ffffffffc02037bc:	07a00593          	li	a1,122
ffffffffc02037c0:	00003517          	auipc	a0,0x3
ffffffffc02037c4:	52850513          	addi	a0,a0,1320 # ffffffffc0206ce8 <default_pmm_manager+0x7a8>
ffffffffc02037c8:	cc7fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc02037cc:	00003697          	auipc	a3,0x3
ffffffffc02037d0:	56c68693          	addi	a3,a3,1388 # ffffffffc0206d38 <default_pmm_manager+0x7f8>
ffffffffc02037d4:	00003617          	auipc	a2,0x3
ffffffffc02037d8:	9bc60613          	addi	a2,a2,-1604 # ffffffffc0206190 <commands+0x828>
ffffffffc02037dc:	07300593          	li	a1,115
ffffffffc02037e0:	00003517          	auipc	a0,0x3
ffffffffc02037e4:	50850513          	addi	a0,a0,1288 # ffffffffc0206ce8 <default_pmm_manager+0x7a8>
ffffffffc02037e8:	ca7fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc02037ec:	00003697          	auipc	a3,0x3
ffffffffc02037f0:	52c68693          	addi	a3,a3,1324 # ffffffffc0206d18 <default_pmm_manager+0x7d8>
ffffffffc02037f4:	00003617          	auipc	a2,0x3
ffffffffc02037f8:	99c60613          	addi	a2,a2,-1636 # ffffffffc0206190 <commands+0x828>
ffffffffc02037fc:	07200593          	li	a1,114
ffffffffc0203800:	00003517          	auipc	a0,0x3
ffffffffc0203804:	4e850513          	addi	a0,a0,1256 # ffffffffc0206ce8 <default_pmm_manager+0x7a8>
ffffffffc0203808:	c87fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020380c <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void mm_destroy(struct mm_struct *mm)
{
    assert(mm_count(mm) == 0);
ffffffffc020380c:	591c                	lw	a5,48(a0)
{
ffffffffc020380e:	1141                	addi	sp,sp,-16
ffffffffc0203810:	e406                	sd	ra,8(sp)
ffffffffc0203812:	e022                	sd	s0,0(sp)
    assert(mm_count(mm) == 0);
ffffffffc0203814:	e78d                	bnez	a5,ffffffffc020383e <mm_destroy+0x32>
ffffffffc0203816:	842a                	mv	s0,a0
    return listelm->next;
ffffffffc0203818:	6508                	ld	a0,8(a0)

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list)
ffffffffc020381a:	00a40c63          	beq	s0,a0,ffffffffc0203832 <mm_destroy+0x26>
    __list_del(listelm->prev, listelm->next);
ffffffffc020381e:	6118                	ld	a4,0(a0)
ffffffffc0203820:	651c                	ld	a5,8(a0)
    {
        list_del(le);
        kfree(le2vma(le, list_link)); // kfree vma
ffffffffc0203822:	1501                	addi	a0,a0,-32
    prev->next = next;
ffffffffc0203824:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0203826:	e398                	sd	a4,0(a5)
ffffffffc0203828:	d52fe0ef          	jal	ra,ffffffffc0201d7a <kfree>
    return listelm->next;
ffffffffc020382c:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list)
ffffffffc020382e:	fea418e3          	bne	s0,a0,ffffffffc020381e <mm_destroy+0x12>
    }
    kfree(mm); // kfree mm
ffffffffc0203832:	8522                	mv	a0,s0
    mm = NULL;
}
ffffffffc0203834:	6402                	ld	s0,0(sp)
ffffffffc0203836:	60a2                	ld	ra,8(sp)
ffffffffc0203838:	0141                	addi	sp,sp,16
    kfree(mm); // kfree mm
ffffffffc020383a:	d40fe06f          	j	ffffffffc0201d7a <kfree>
    assert(mm_count(mm) == 0);
ffffffffc020383e:	00003697          	auipc	a3,0x3
ffffffffc0203842:	51a68693          	addi	a3,a3,1306 # ffffffffc0206d58 <default_pmm_manager+0x818>
ffffffffc0203846:	00003617          	auipc	a2,0x3
ffffffffc020384a:	94a60613          	addi	a2,a2,-1718 # ffffffffc0206190 <commands+0x828>
ffffffffc020384e:	09e00593          	li	a1,158
ffffffffc0203852:	00003517          	auipc	a0,0x3
ffffffffc0203856:	49650513          	addi	a0,a0,1174 # ffffffffc0206ce8 <default_pmm_manager+0x7a8>
ffffffffc020385a:	c35fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020385e <mm_map>:

int mm_map(struct mm_struct *mm, uintptr_t addr, size_t len, uint32_t vm_flags,
           struct vma_struct **vma_store)
{
ffffffffc020385e:	7139                	addi	sp,sp,-64
ffffffffc0203860:	f822                	sd	s0,48(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0203862:	6405                	lui	s0,0x1
ffffffffc0203864:	147d                	addi	s0,s0,-1
ffffffffc0203866:	77fd                	lui	a5,0xfffff
ffffffffc0203868:	9622                	add	a2,a2,s0
ffffffffc020386a:	962e                	add	a2,a2,a1
{
ffffffffc020386c:	f426                	sd	s1,40(sp)
ffffffffc020386e:	fc06                	sd	ra,56(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0203870:	00f5f4b3          	and	s1,a1,a5
{
ffffffffc0203874:	f04a                	sd	s2,32(sp)
ffffffffc0203876:	ec4e                	sd	s3,24(sp)
ffffffffc0203878:	e852                	sd	s4,16(sp)
ffffffffc020387a:	e456                	sd	s5,8(sp)
    if (!USER_ACCESS(start, end))
ffffffffc020387c:	002005b7          	lui	a1,0x200
ffffffffc0203880:	00f67433          	and	s0,a2,a5
ffffffffc0203884:	06b4e363          	bltu	s1,a1,ffffffffc02038ea <mm_map+0x8c>
ffffffffc0203888:	0684f163          	bgeu	s1,s0,ffffffffc02038ea <mm_map+0x8c>
ffffffffc020388c:	4785                	li	a5,1
ffffffffc020388e:	07fe                	slli	a5,a5,0x1f
ffffffffc0203890:	0487ed63          	bltu	a5,s0,ffffffffc02038ea <mm_map+0x8c>
ffffffffc0203894:	89aa                	mv	s3,a0
    {
        return -E_INVAL;
    }

    assert(mm != NULL);
ffffffffc0203896:	cd21                	beqz	a0,ffffffffc02038ee <mm_map+0x90>

    int ret = -E_INVAL;

    struct vma_struct *vma;
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start)
ffffffffc0203898:	85a6                	mv	a1,s1
ffffffffc020389a:	8ab6                	mv	s5,a3
ffffffffc020389c:	8a3a                	mv	s4,a4
ffffffffc020389e:	e5fff0ef          	jal	ra,ffffffffc02036fc <find_vma>
ffffffffc02038a2:	c501                	beqz	a0,ffffffffc02038aa <mm_map+0x4c>
ffffffffc02038a4:	651c                	ld	a5,8(a0)
ffffffffc02038a6:	0487e263          	bltu	a5,s0,ffffffffc02038ea <mm_map+0x8c>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc02038aa:	03000513          	li	a0,48
ffffffffc02038ae:	c1cfe0ef          	jal	ra,ffffffffc0201cca <kmalloc>
ffffffffc02038b2:	892a                	mv	s2,a0
    {
        goto out;
    }
    ret = -E_NO_MEM;
ffffffffc02038b4:	5571                	li	a0,-4
    if (vma != NULL)
ffffffffc02038b6:	02090163          	beqz	s2,ffffffffc02038d8 <mm_map+0x7a>

    if ((vma = vma_create(start, end, vm_flags)) == NULL)
    {
        goto out;
    }
    insert_vma_struct(mm, vma);
ffffffffc02038ba:	854e                	mv	a0,s3
        vma->vm_start = vm_start;
ffffffffc02038bc:	00993423          	sd	s1,8(s2)
        vma->vm_end = vm_end;
ffffffffc02038c0:	00893823          	sd	s0,16(s2)
        vma->vm_flags = vm_flags;
ffffffffc02038c4:	01592c23          	sw	s5,24(s2)
    insert_vma_struct(mm, vma);
ffffffffc02038c8:	85ca                	mv	a1,s2
ffffffffc02038ca:	e73ff0ef          	jal	ra,ffffffffc020373c <insert_vma_struct>
    if (vma_store != NULL)
    {
        *vma_store = vma;
    }
    ret = 0;
ffffffffc02038ce:	4501                	li	a0,0
    if (vma_store != NULL)
ffffffffc02038d0:	000a0463          	beqz	s4,ffffffffc02038d8 <mm_map+0x7a>
        *vma_store = vma;
ffffffffc02038d4:	012a3023          	sd	s2,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8bb8>

out:
    return ret;
}
ffffffffc02038d8:	70e2                	ld	ra,56(sp)
ffffffffc02038da:	7442                	ld	s0,48(sp)
ffffffffc02038dc:	74a2                	ld	s1,40(sp)
ffffffffc02038de:	7902                	ld	s2,32(sp)
ffffffffc02038e0:	69e2                	ld	s3,24(sp)
ffffffffc02038e2:	6a42                	ld	s4,16(sp)
ffffffffc02038e4:	6aa2                	ld	s5,8(sp)
ffffffffc02038e6:	6121                	addi	sp,sp,64
ffffffffc02038e8:	8082                	ret
        return -E_INVAL;
ffffffffc02038ea:	5575                	li	a0,-3
ffffffffc02038ec:	b7f5                	j	ffffffffc02038d8 <mm_map+0x7a>
    assert(mm != NULL);
ffffffffc02038ee:	00003697          	auipc	a3,0x3
ffffffffc02038f2:	48268693          	addi	a3,a3,1154 # ffffffffc0206d70 <default_pmm_manager+0x830>
ffffffffc02038f6:	00003617          	auipc	a2,0x3
ffffffffc02038fa:	89a60613          	addi	a2,a2,-1894 # ffffffffc0206190 <commands+0x828>
ffffffffc02038fe:	0b300593          	li	a1,179
ffffffffc0203902:	00003517          	auipc	a0,0x3
ffffffffc0203906:	3e650513          	addi	a0,a0,998 # ffffffffc0206ce8 <default_pmm_manager+0x7a8>
ffffffffc020390a:	b85fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020390e <dup_mmap>:

int dup_mmap(struct mm_struct *to, struct mm_struct *from)
{
ffffffffc020390e:	7139                	addi	sp,sp,-64
ffffffffc0203910:	fc06                	sd	ra,56(sp)
ffffffffc0203912:	f822                	sd	s0,48(sp)
ffffffffc0203914:	f426                	sd	s1,40(sp)
ffffffffc0203916:	f04a                	sd	s2,32(sp)
ffffffffc0203918:	ec4e                	sd	s3,24(sp)
ffffffffc020391a:	e852                	sd	s4,16(sp)
ffffffffc020391c:	e456                	sd	s5,8(sp)
    assert(to != NULL && from != NULL);
ffffffffc020391e:	c52d                	beqz	a0,ffffffffc0203988 <dup_mmap+0x7a>
ffffffffc0203920:	892a                	mv	s2,a0
ffffffffc0203922:	84ae                	mv	s1,a1
    list_entry_t *list = &(from->mmap_list), *le = list;
ffffffffc0203924:	842e                	mv	s0,a1
    assert(to != NULL && from != NULL);
ffffffffc0203926:	e595                	bnez	a1,ffffffffc0203952 <dup_mmap+0x44>
ffffffffc0203928:	a085                	j	ffffffffc0203988 <dup_mmap+0x7a>
        if (nvma == NULL)
        {
            return -E_NO_MEM;
        }

        insert_vma_struct(to, nvma);
ffffffffc020392a:	854a                	mv	a0,s2
        vma->vm_start = vm_start;
ffffffffc020392c:	0155b423          	sd	s5,8(a1) # 200008 <_binary_obj___user_exit_out_size+0x1f4ed8>
        vma->vm_end = vm_end;
ffffffffc0203930:	0145b823          	sd	s4,16(a1)
        vma->vm_flags = vm_flags;
ffffffffc0203934:	0135ac23          	sw	s3,24(a1)
        insert_vma_struct(to, nvma);
ffffffffc0203938:	e05ff0ef          	jal	ra,ffffffffc020373c <insert_vma_struct>

        bool share = 0;
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0)
ffffffffc020393c:	ff043683          	ld	a3,-16(s0) # ff0 <_binary_obj___user_faultread_out_size-0x8bc8>
ffffffffc0203940:	fe843603          	ld	a2,-24(s0)
ffffffffc0203944:	6c8c                	ld	a1,24(s1)
ffffffffc0203946:	01893503          	ld	a0,24(s2)
ffffffffc020394a:	4701                	li	a4,0
ffffffffc020394c:	a3bff0ef          	jal	ra,ffffffffc0203386 <copy_range>
ffffffffc0203950:	e105                	bnez	a0,ffffffffc0203970 <dup_mmap+0x62>
    return listelm->prev;
ffffffffc0203952:	6000                	ld	s0,0(s0)
    while ((le = list_prev(le)) != list)
ffffffffc0203954:	02848863          	beq	s1,s0,ffffffffc0203984 <dup_mmap+0x76>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203958:	03000513          	li	a0,48
        nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
ffffffffc020395c:	fe843a83          	ld	s5,-24(s0)
ffffffffc0203960:	ff043a03          	ld	s4,-16(s0)
ffffffffc0203964:	ff842983          	lw	s3,-8(s0)
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203968:	b62fe0ef          	jal	ra,ffffffffc0201cca <kmalloc>
ffffffffc020396c:	85aa                	mv	a1,a0
    if (vma != NULL)
ffffffffc020396e:	fd55                	bnez	a0,ffffffffc020392a <dup_mmap+0x1c>
            return -E_NO_MEM;
ffffffffc0203970:	5571                	li	a0,-4
        {
            return -E_NO_MEM;
        }
    }
    return 0;
}
ffffffffc0203972:	70e2                	ld	ra,56(sp)
ffffffffc0203974:	7442                	ld	s0,48(sp)
ffffffffc0203976:	74a2                	ld	s1,40(sp)
ffffffffc0203978:	7902                	ld	s2,32(sp)
ffffffffc020397a:	69e2                	ld	s3,24(sp)
ffffffffc020397c:	6a42                	ld	s4,16(sp)
ffffffffc020397e:	6aa2                	ld	s5,8(sp)
ffffffffc0203980:	6121                	addi	sp,sp,64
ffffffffc0203982:	8082                	ret
    return 0;
ffffffffc0203984:	4501                	li	a0,0
ffffffffc0203986:	b7f5                	j	ffffffffc0203972 <dup_mmap+0x64>
    assert(to != NULL && from != NULL);
ffffffffc0203988:	00003697          	auipc	a3,0x3
ffffffffc020398c:	3f868693          	addi	a3,a3,1016 # ffffffffc0206d80 <default_pmm_manager+0x840>
ffffffffc0203990:	00003617          	auipc	a2,0x3
ffffffffc0203994:	80060613          	addi	a2,a2,-2048 # ffffffffc0206190 <commands+0x828>
ffffffffc0203998:	0cf00593          	li	a1,207
ffffffffc020399c:	00003517          	auipc	a0,0x3
ffffffffc02039a0:	34c50513          	addi	a0,a0,844 # ffffffffc0206ce8 <default_pmm_manager+0x7a8>
ffffffffc02039a4:	aebfc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02039a8 <exit_mmap>:

void exit_mmap(struct mm_struct *mm)
{
ffffffffc02039a8:	1101                	addi	sp,sp,-32
ffffffffc02039aa:	ec06                	sd	ra,24(sp)
ffffffffc02039ac:	e822                	sd	s0,16(sp)
ffffffffc02039ae:	e426                	sd	s1,8(sp)
ffffffffc02039b0:	e04a                	sd	s2,0(sp)
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc02039b2:	c531                	beqz	a0,ffffffffc02039fe <exit_mmap+0x56>
ffffffffc02039b4:	591c                	lw	a5,48(a0)
ffffffffc02039b6:	84aa                	mv	s1,a0
ffffffffc02039b8:	e3b9                	bnez	a5,ffffffffc02039fe <exit_mmap+0x56>
    return listelm->next;
ffffffffc02039ba:	6500                	ld	s0,8(a0)
    pde_t *pgdir = mm->pgdir;
ffffffffc02039bc:	01853903          	ld	s2,24(a0)
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list)
ffffffffc02039c0:	02850663          	beq	a0,s0,ffffffffc02039ec <exit_mmap+0x44>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc02039c4:	ff043603          	ld	a2,-16(s0)
ffffffffc02039c8:	fe843583          	ld	a1,-24(s0)
ffffffffc02039cc:	854a                	mv	a0,s2
ffffffffc02039ce:	80ffe0ef          	jal	ra,ffffffffc02021dc <unmap_range>
ffffffffc02039d2:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc02039d4:	fe8498e3          	bne	s1,s0,ffffffffc02039c4 <exit_mmap+0x1c>
ffffffffc02039d8:	6400                	ld	s0,8(s0)
    }
    while ((le = list_next(le)) != list)
ffffffffc02039da:	00848c63          	beq	s1,s0,ffffffffc02039f2 <exit_mmap+0x4a>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        exit_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc02039de:	ff043603          	ld	a2,-16(s0)
ffffffffc02039e2:	fe843583          	ld	a1,-24(s0)
ffffffffc02039e6:	854a                	mv	a0,s2
ffffffffc02039e8:	93bfe0ef          	jal	ra,ffffffffc0202322 <exit_range>
ffffffffc02039ec:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc02039ee:	fe8498e3          	bne	s1,s0,ffffffffc02039de <exit_mmap+0x36>
    }
}
ffffffffc02039f2:	60e2                	ld	ra,24(sp)
ffffffffc02039f4:	6442                	ld	s0,16(sp)
ffffffffc02039f6:	64a2                	ld	s1,8(sp)
ffffffffc02039f8:	6902                	ld	s2,0(sp)
ffffffffc02039fa:	6105                	addi	sp,sp,32
ffffffffc02039fc:	8082                	ret
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc02039fe:	00003697          	auipc	a3,0x3
ffffffffc0203a02:	3a268693          	addi	a3,a3,930 # ffffffffc0206da0 <default_pmm_manager+0x860>
ffffffffc0203a06:	00002617          	auipc	a2,0x2
ffffffffc0203a0a:	78a60613          	addi	a2,a2,1930 # ffffffffc0206190 <commands+0x828>
ffffffffc0203a0e:	0e800593          	li	a1,232
ffffffffc0203a12:	00003517          	auipc	a0,0x3
ffffffffc0203a16:	2d650513          	addi	a0,a0,726 # ffffffffc0206ce8 <default_pmm_manager+0x7a8>
ffffffffc0203a1a:	a75fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203a1e <vmm_init>:
}

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void vmm_init(void)
{
ffffffffc0203a1e:	7139                	addi	sp,sp,-64
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203a20:	04000513          	li	a0,64
{
ffffffffc0203a24:	fc06                	sd	ra,56(sp)
ffffffffc0203a26:	f822                	sd	s0,48(sp)
ffffffffc0203a28:	f426                	sd	s1,40(sp)
ffffffffc0203a2a:	f04a                	sd	s2,32(sp)
ffffffffc0203a2c:	ec4e                	sd	s3,24(sp)
ffffffffc0203a2e:	e852                	sd	s4,16(sp)
ffffffffc0203a30:	e456                	sd	s5,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203a32:	a98fe0ef          	jal	ra,ffffffffc0201cca <kmalloc>
    if (mm != NULL)
ffffffffc0203a36:	2e050663          	beqz	a0,ffffffffc0203d22 <vmm_init+0x304>
ffffffffc0203a3a:	84aa                	mv	s1,a0
    elm->prev = elm->next = elm;
ffffffffc0203a3c:	e508                	sd	a0,8(a0)
ffffffffc0203a3e:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0203a40:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0203a44:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0203a48:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc0203a4c:	02053423          	sd	zero,40(a0)
ffffffffc0203a50:	02052823          	sw	zero,48(a0)
ffffffffc0203a54:	02053c23          	sd	zero,56(a0)
ffffffffc0203a58:	03200413          	li	s0,50
ffffffffc0203a5c:	a811                	j	ffffffffc0203a70 <vmm_init+0x52>
        vma->vm_start = vm_start;
ffffffffc0203a5e:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0203a60:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203a62:	00052c23          	sw	zero,24(a0)
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i--)
ffffffffc0203a66:	146d                	addi	s0,s0,-5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203a68:	8526                	mv	a0,s1
ffffffffc0203a6a:	cd3ff0ef          	jal	ra,ffffffffc020373c <insert_vma_struct>
    for (i = step1; i >= 1; i--)
ffffffffc0203a6e:	c80d                	beqz	s0,ffffffffc0203aa0 <vmm_init+0x82>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203a70:	03000513          	li	a0,48
ffffffffc0203a74:	a56fe0ef          	jal	ra,ffffffffc0201cca <kmalloc>
ffffffffc0203a78:	85aa                	mv	a1,a0
ffffffffc0203a7a:	00240793          	addi	a5,s0,2
    if (vma != NULL)
ffffffffc0203a7e:	f165                	bnez	a0,ffffffffc0203a5e <vmm_init+0x40>
        assert(vma != NULL);
ffffffffc0203a80:	00003697          	auipc	a3,0x3
ffffffffc0203a84:	4b868693          	addi	a3,a3,1208 # ffffffffc0206f38 <default_pmm_manager+0x9f8>
ffffffffc0203a88:	00002617          	auipc	a2,0x2
ffffffffc0203a8c:	70860613          	addi	a2,a2,1800 # ffffffffc0206190 <commands+0x828>
ffffffffc0203a90:	12c00593          	li	a1,300
ffffffffc0203a94:	00003517          	auipc	a0,0x3
ffffffffc0203a98:	25450513          	addi	a0,a0,596 # ffffffffc0206ce8 <default_pmm_manager+0x7a8>
ffffffffc0203a9c:	9f3fc0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc0203aa0:	03700413          	li	s0,55
    }

    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203aa4:	1f900913          	li	s2,505
ffffffffc0203aa8:	a819                	j	ffffffffc0203abe <vmm_init+0xa0>
        vma->vm_start = vm_start;
ffffffffc0203aaa:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0203aac:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203aae:	00052c23          	sw	zero,24(a0)
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203ab2:	0415                	addi	s0,s0,5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203ab4:	8526                	mv	a0,s1
ffffffffc0203ab6:	c87ff0ef          	jal	ra,ffffffffc020373c <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203aba:	03240a63          	beq	s0,s2,ffffffffc0203aee <vmm_init+0xd0>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203abe:	03000513          	li	a0,48
ffffffffc0203ac2:	a08fe0ef          	jal	ra,ffffffffc0201cca <kmalloc>
ffffffffc0203ac6:	85aa                	mv	a1,a0
ffffffffc0203ac8:	00240793          	addi	a5,s0,2
    if (vma != NULL)
ffffffffc0203acc:	fd79                	bnez	a0,ffffffffc0203aaa <vmm_init+0x8c>
        assert(vma != NULL);
ffffffffc0203ace:	00003697          	auipc	a3,0x3
ffffffffc0203ad2:	46a68693          	addi	a3,a3,1130 # ffffffffc0206f38 <default_pmm_manager+0x9f8>
ffffffffc0203ad6:	00002617          	auipc	a2,0x2
ffffffffc0203ada:	6ba60613          	addi	a2,a2,1722 # ffffffffc0206190 <commands+0x828>
ffffffffc0203ade:	13300593          	li	a1,307
ffffffffc0203ae2:	00003517          	auipc	a0,0x3
ffffffffc0203ae6:	20650513          	addi	a0,a0,518 # ffffffffc0206ce8 <default_pmm_manager+0x7a8>
ffffffffc0203aea:	9a5fc0ef          	jal	ra,ffffffffc020048e <__panic>
    return listelm->next;
ffffffffc0203aee:	649c                	ld	a5,8(s1)
ffffffffc0203af0:	471d                	li	a4,7
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i++)
ffffffffc0203af2:	1fb00593          	li	a1,507
    {
        assert(le != &(mm->mmap_list));
ffffffffc0203af6:	16f48663          	beq	s1,a5,ffffffffc0203c62 <vmm_init+0x244>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203afa:	fe87b603          	ld	a2,-24(a5) # ffffffffffffefe8 <end+0x3fd547bc>
ffffffffc0203afe:	ffe70693          	addi	a3,a4,-2
ffffffffc0203b02:	10d61063          	bne	a2,a3,ffffffffc0203c02 <vmm_init+0x1e4>
ffffffffc0203b06:	ff07b683          	ld	a3,-16(a5)
ffffffffc0203b0a:	0ed71c63          	bne	a4,a3,ffffffffc0203c02 <vmm_init+0x1e4>
    for (i = 1; i <= step2; i++)
ffffffffc0203b0e:	0715                	addi	a4,a4,5
ffffffffc0203b10:	679c                	ld	a5,8(a5)
ffffffffc0203b12:	feb712e3          	bne	a4,a1,ffffffffc0203af6 <vmm_init+0xd8>
ffffffffc0203b16:	4a1d                	li	s4,7
ffffffffc0203b18:	4415                	li	s0,5
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0203b1a:	1f900a93          	li	s5,505
    {
        struct vma_struct *vma1 = find_vma(mm, i);
ffffffffc0203b1e:	85a2                	mv	a1,s0
ffffffffc0203b20:	8526                	mv	a0,s1
ffffffffc0203b22:	bdbff0ef          	jal	ra,ffffffffc02036fc <find_vma>
ffffffffc0203b26:	892a                	mv	s2,a0
        assert(vma1 != NULL);
ffffffffc0203b28:	16050d63          	beqz	a0,ffffffffc0203ca2 <vmm_init+0x284>
        struct vma_struct *vma2 = find_vma(mm, i + 1);
ffffffffc0203b2c:	00140593          	addi	a1,s0,1
ffffffffc0203b30:	8526                	mv	a0,s1
ffffffffc0203b32:	bcbff0ef          	jal	ra,ffffffffc02036fc <find_vma>
ffffffffc0203b36:	89aa                	mv	s3,a0
        assert(vma2 != NULL);
ffffffffc0203b38:	14050563          	beqz	a0,ffffffffc0203c82 <vmm_init+0x264>
        struct vma_struct *vma3 = find_vma(mm, i + 2);
ffffffffc0203b3c:	85d2                	mv	a1,s4
ffffffffc0203b3e:	8526                	mv	a0,s1
ffffffffc0203b40:	bbdff0ef          	jal	ra,ffffffffc02036fc <find_vma>
        assert(vma3 == NULL);
ffffffffc0203b44:	16051f63          	bnez	a0,ffffffffc0203cc2 <vmm_init+0x2a4>
        struct vma_struct *vma4 = find_vma(mm, i + 3);
ffffffffc0203b48:	00340593          	addi	a1,s0,3
ffffffffc0203b4c:	8526                	mv	a0,s1
ffffffffc0203b4e:	bafff0ef          	jal	ra,ffffffffc02036fc <find_vma>
        assert(vma4 == NULL);
ffffffffc0203b52:	1a051863          	bnez	a0,ffffffffc0203d02 <vmm_init+0x2e4>
        struct vma_struct *vma5 = find_vma(mm, i + 4);
ffffffffc0203b56:	00440593          	addi	a1,s0,4
ffffffffc0203b5a:	8526                	mv	a0,s1
ffffffffc0203b5c:	ba1ff0ef          	jal	ra,ffffffffc02036fc <find_vma>
        assert(vma5 == NULL);
ffffffffc0203b60:	18051163          	bnez	a0,ffffffffc0203ce2 <vmm_init+0x2c4>

        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203b64:	00893783          	ld	a5,8(s2)
ffffffffc0203b68:	0a879d63          	bne	a5,s0,ffffffffc0203c22 <vmm_init+0x204>
ffffffffc0203b6c:	01093783          	ld	a5,16(s2)
ffffffffc0203b70:	0b479963          	bne	a5,s4,ffffffffc0203c22 <vmm_init+0x204>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203b74:	0089b783          	ld	a5,8(s3)
ffffffffc0203b78:	0c879563          	bne	a5,s0,ffffffffc0203c42 <vmm_init+0x224>
ffffffffc0203b7c:	0109b783          	ld	a5,16(s3)
ffffffffc0203b80:	0d479163          	bne	a5,s4,ffffffffc0203c42 <vmm_init+0x224>
    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0203b84:	0415                	addi	s0,s0,5
ffffffffc0203b86:	0a15                	addi	s4,s4,5
ffffffffc0203b88:	f9541be3          	bne	s0,s5,ffffffffc0203b1e <vmm_init+0x100>
ffffffffc0203b8c:	4411                	li	s0,4
    }

    for (i = 4; i >= 0; i--)
ffffffffc0203b8e:	597d                	li	s2,-1
    {
        struct vma_struct *vma_below_5 = find_vma(mm, i);
ffffffffc0203b90:	85a2                	mv	a1,s0
ffffffffc0203b92:	8526                	mv	a0,s1
ffffffffc0203b94:	b69ff0ef          	jal	ra,ffffffffc02036fc <find_vma>
ffffffffc0203b98:	0004059b          	sext.w	a1,s0
        if (vma_below_5 != NULL)
ffffffffc0203b9c:	c90d                	beqz	a0,ffffffffc0203bce <vmm_init+0x1b0>
        {
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
ffffffffc0203b9e:	6914                	ld	a3,16(a0)
ffffffffc0203ba0:	6510                	ld	a2,8(a0)
ffffffffc0203ba2:	00003517          	auipc	a0,0x3
ffffffffc0203ba6:	31e50513          	addi	a0,a0,798 # ffffffffc0206ec0 <default_pmm_manager+0x980>
ffffffffc0203baa:	deafc0ef          	jal	ra,ffffffffc0200194 <cprintf>
        }
        assert(vma_below_5 == NULL);
ffffffffc0203bae:	00003697          	auipc	a3,0x3
ffffffffc0203bb2:	33a68693          	addi	a3,a3,826 # ffffffffc0206ee8 <default_pmm_manager+0x9a8>
ffffffffc0203bb6:	00002617          	auipc	a2,0x2
ffffffffc0203bba:	5da60613          	addi	a2,a2,1498 # ffffffffc0206190 <commands+0x828>
ffffffffc0203bbe:	15900593          	li	a1,345
ffffffffc0203bc2:	00003517          	auipc	a0,0x3
ffffffffc0203bc6:	12650513          	addi	a0,a0,294 # ffffffffc0206ce8 <default_pmm_manager+0x7a8>
ffffffffc0203bca:	8c5fc0ef          	jal	ra,ffffffffc020048e <__panic>
    for (i = 4; i >= 0; i--)
ffffffffc0203bce:	147d                	addi	s0,s0,-1
ffffffffc0203bd0:	fd2410e3          	bne	s0,s2,ffffffffc0203b90 <vmm_init+0x172>
    }

    mm_destroy(mm);
ffffffffc0203bd4:	8526                	mv	a0,s1
ffffffffc0203bd6:	c37ff0ef          	jal	ra,ffffffffc020380c <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc0203bda:	00003517          	auipc	a0,0x3
ffffffffc0203bde:	32650513          	addi	a0,a0,806 # ffffffffc0206f00 <default_pmm_manager+0x9c0>
ffffffffc0203be2:	db2fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
}
ffffffffc0203be6:	7442                	ld	s0,48(sp)
ffffffffc0203be8:	70e2                	ld	ra,56(sp)
ffffffffc0203bea:	74a2                	ld	s1,40(sp)
ffffffffc0203bec:	7902                	ld	s2,32(sp)
ffffffffc0203bee:	69e2                	ld	s3,24(sp)
ffffffffc0203bf0:	6a42                	ld	s4,16(sp)
ffffffffc0203bf2:	6aa2                	ld	s5,8(sp)
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203bf4:	00003517          	auipc	a0,0x3
ffffffffc0203bf8:	32c50513          	addi	a0,a0,812 # ffffffffc0206f20 <default_pmm_manager+0x9e0>
}
ffffffffc0203bfc:	6121                	addi	sp,sp,64
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203bfe:	d96fc06f          	j	ffffffffc0200194 <cprintf>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203c02:	00003697          	auipc	a3,0x3
ffffffffc0203c06:	1d668693          	addi	a3,a3,470 # ffffffffc0206dd8 <default_pmm_manager+0x898>
ffffffffc0203c0a:	00002617          	auipc	a2,0x2
ffffffffc0203c0e:	58660613          	addi	a2,a2,1414 # ffffffffc0206190 <commands+0x828>
ffffffffc0203c12:	13d00593          	li	a1,317
ffffffffc0203c16:	00003517          	auipc	a0,0x3
ffffffffc0203c1a:	0d250513          	addi	a0,a0,210 # ffffffffc0206ce8 <default_pmm_manager+0x7a8>
ffffffffc0203c1e:	871fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203c22:	00003697          	auipc	a3,0x3
ffffffffc0203c26:	23e68693          	addi	a3,a3,574 # ffffffffc0206e60 <default_pmm_manager+0x920>
ffffffffc0203c2a:	00002617          	auipc	a2,0x2
ffffffffc0203c2e:	56660613          	addi	a2,a2,1382 # ffffffffc0206190 <commands+0x828>
ffffffffc0203c32:	14e00593          	li	a1,334
ffffffffc0203c36:	00003517          	auipc	a0,0x3
ffffffffc0203c3a:	0b250513          	addi	a0,a0,178 # ffffffffc0206ce8 <default_pmm_manager+0x7a8>
ffffffffc0203c3e:	851fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203c42:	00003697          	auipc	a3,0x3
ffffffffc0203c46:	24e68693          	addi	a3,a3,590 # ffffffffc0206e90 <default_pmm_manager+0x950>
ffffffffc0203c4a:	00002617          	auipc	a2,0x2
ffffffffc0203c4e:	54660613          	addi	a2,a2,1350 # ffffffffc0206190 <commands+0x828>
ffffffffc0203c52:	14f00593          	li	a1,335
ffffffffc0203c56:	00003517          	auipc	a0,0x3
ffffffffc0203c5a:	09250513          	addi	a0,a0,146 # ffffffffc0206ce8 <default_pmm_manager+0x7a8>
ffffffffc0203c5e:	831fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc0203c62:	00003697          	auipc	a3,0x3
ffffffffc0203c66:	15e68693          	addi	a3,a3,350 # ffffffffc0206dc0 <default_pmm_manager+0x880>
ffffffffc0203c6a:	00002617          	auipc	a2,0x2
ffffffffc0203c6e:	52660613          	addi	a2,a2,1318 # ffffffffc0206190 <commands+0x828>
ffffffffc0203c72:	13b00593          	li	a1,315
ffffffffc0203c76:	00003517          	auipc	a0,0x3
ffffffffc0203c7a:	07250513          	addi	a0,a0,114 # ffffffffc0206ce8 <default_pmm_manager+0x7a8>
ffffffffc0203c7e:	811fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma2 != NULL);
ffffffffc0203c82:	00003697          	auipc	a3,0x3
ffffffffc0203c86:	19e68693          	addi	a3,a3,414 # ffffffffc0206e20 <default_pmm_manager+0x8e0>
ffffffffc0203c8a:	00002617          	auipc	a2,0x2
ffffffffc0203c8e:	50660613          	addi	a2,a2,1286 # ffffffffc0206190 <commands+0x828>
ffffffffc0203c92:	14600593          	li	a1,326
ffffffffc0203c96:	00003517          	auipc	a0,0x3
ffffffffc0203c9a:	05250513          	addi	a0,a0,82 # ffffffffc0206ce8 <default_pmm_manager+0x7a8>
ffffffffc0203c9e:	ff0fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma1 != NULL);
ffffffffc0203ca2:	00003697          	auipc	a3,0x3
ffffffffc0203ca6:	16e68693          	addi	a3,a3,366 # ffffffffc0206e10 <default_pmm_manager+0x8d0>
ffffffffc0203caa:	00002617          	auipc	a2,0x2
ffffffffc0203cae:	4e660613          	addi	a2,a2,1254 # ffffffffc0206190 <commands+0x828>
ffffffffc0203cb2:	14400593          	li	a1,324
ffffffffc0203cb6:	00003517          	auipc	a0,0x3
ffffffffc0203cba:	03250513          	addi	a0,a0,50 # ffffffffc0206ce8 <default_pmm_manager+0x7a8>
ffffffffc0203cbe:	fd0fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma3 == NULL);
ffffffffc0203cc2:	00003697          	auipc	a3,0x3
ffffffffc0203cc6:	16e68693          	addi	a3,a3,366 # ffffffffc0206e30 <default_pmm_manager+0x8f0>
ffffffffc0203cca:	00002617          	auipc	a2,0x2
ffffffffc0203cce:	4c660613          	addi	a2,a2,1222 # ffffffffc0206190 <commands+0x828>
ffffffffc0203cd2:	14800593          	li	a1,328
ffffffffc0203cd6:	00003517          	auipc	a0,0x3
ffffffffc0203cda:	01250513          	addi	a0,a0,18 # ffffffffc0206ce8 <default_pmm_manager+0x7a8>
ffffffffc0203cde:	fb0fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma5 == NULL);
ffffffffc0203ce2:	00003697          	auipc	a3,0x3
ffffffffc0203ce6:	16e68693          	addi	a3,a3,366 # ffffffffc0206e50 <default_pmm_manager+0x910>
ffffffffc0203cea:	00002617          	auipc	a2,0x2
ffffffffc0203cee:	4a660613          	addi	a2,a2,1190 # ffffffffc0206190 <commands+0x828>
ffffffffc0203cf2:	14c00593          	li	a1,332
ffffffffc0203cf6:	00003517          	auipc	a0,0x3
ffffffffc0203cfa:	ff250513          	addi	a0,a0,-14 # ffffffffc0206ce8 <default_pmm_manager+0x7a8>
ffffffffc0203cfe:	f90fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma4 == NULL);
ffffffffc0203d02:	00003697          	auipc	a3,0x3
ffffffffc0203d06:	13e68693          	addi	a3,a3,318 # ffffffffc0206e40 <default_pmm_manager+0x900>
ffffffffc0203d0a:	00002617          	auipc	a2,0x2
ffffffffc0203d0e:	48660613          	addi	a2,a2,1158 # ffffffffc0206190 <commands+0x828>
ffffffffc0203d12:	14a00593          	li	a1,330
ffffffffc0203d16:	00003517          	auipc	a0,0x3
ffffffffc0203d1a:	fd250513          	addi	a0,a0,-46 # ffffffffc0206ce8 <default_pmm_manager+0x7a8>
ffffffffc0203d1e:	f70fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(mm != NULL);
ffffffffc0203d22:	00003697          	auipc	a3,0x3
ffffffffc0203d26:	04e68693          	addi	a3,a3,78 # ffffffffc0206d70 <default_pmm_manager+0x830>
ffffffffc0203d2a:	00002617          	auipc	a2,0x2
ffffffffc0203d2e:	46660613          	addi	a2,a2,1126 # ffffffffc0206190 <commands+0x828>
ffffffffc0203d32:	12400593          	li	a1,292
ffffffffc0203d36:	00003517          	auipc	a0,0x3
ffffffffc0203d3a:	fb250513          	addi	a0,a0,-78 # ffffffffc0206ce8 <default_pmm_manager+0x7a8>
ffffffffc0203d3e:	f50fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203d42 <user_mem_check>:
}
bool user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write)
{
ffffffffc0203d42:	7179                	addi	sp,sp,-48
ffffffffc0203d44:	f022                	sd	s0,32(sp)
ffffffffc0203d46:	f406                	sd	ra,40(sp)
ffffffffc0203d48:	ec26                	sd	s1,24(sp)
ffffffffc0203d4a:	e84a                	sd	s2,16(sp)
ffffffffc0203d4c:	e44e                	sd	s3,8(sp)
ffffffffc0203d4e:	e052                	sd	s4,0(sp)
ffffffffc0203d50:	842e                	mv	s0,a1
    if (mm != NULL)
ffffffffc0203d52:	c135                	beqz	a0,ffffffffc0203db6 <user_mem_check+0x74>
    {
        if (!USER_ACCESS(addr, addr + len))
ffffffffc0203d54:	002007b7          	lui	a5,0x200
ffffffffc0203d58:	04f5e663          	bltu	a1,a5,ffffffffc0203da4 <user_mem_check+0x62>
ffffffffc0203d5c:	00c584b3          	add	s1,a1,a2
ffffffffc0203d60:	0495f263          	bgeu	a1,s1,ffffffffc0203da4 <user_mem_check+0x62>
ffffffffc0203d64:	4785                	li	a5,1
ffffffffc0203d66:	07fe                	slli	a5,a5,0x1f
ffffffffc0203d68:	0297ee63          	bltu	a5,s1,ffffffffc0203da4 <user_mem_check+0x62>
ffffffffc0203d6c:	892a                	mv	s2,a0
ffffffffc0203d6e:	89b6                	mv	s3,a3
            {
                return 0;
            }
            if (write && (vma->vm_flags & VM_STACK))
            {
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203d70:	6a05                	lui	s4,0x1
ffffffffc0203d72:	a821                	j	ffffffffc0203d8a <user_mem_check+0x48>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203d74:	0027f693          	andi	a3,a5,2
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203d78:	9752                	add	a4,a4,s4
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0203d7a:	8ba1                	andi	a5,a5,8
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203d7c:	c685                	beqz	a3,ffffffffc0203da4 <user_mem_check+0x62>
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0203d7e:	c399                	beqz	a5,ffffffffc0203d84 <user_mem_check+0x42>
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203d80:	02e46263          	bltu	s0,a4,ffffffffc0203da4 <user_mem_check+0x62>
                { // check stack start & size
                    return 0;
                }
            }
            start = vma->vm_end;
ffffffffc0203d84:	6900                	ld	s0,16(a0)
        while (start < end)
ffffffffc0203d86:	04947663          	bgeu	s0,s1,ffffffffc0203dd2 <user_mem_check+0x90>
            if ((vma = find_vma(mm, start)) == NULL || start < vma->vm_start)
ffffffffc0203d8a:	85a2                	mv	a1,s0
ffffffffc0203d8c:	854a                	mv	a0,s2
ffffffffc0203d8e:	96fff0ef          	jal	ra,ffffffffc02036fc <find_vma>
ffffffffc0203d92:	c909                	beqz	a0,ffffffffc0203da4 <user_mem_check+0x62>
ffffffffc0203d94:	6518                	ld	a4,8(a0)
ffffffffc0203d96:	00e46763          	bltu	s0,a4,ffffffffc0203da4 <user_mem_check+0x62>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203d9a:	4d1c                	lw	a5,24(a0)
ffffffffc0203d9c:	fc099ce3          	bnez	s3,ffffffffc0203d74 <user_mem_check+0x32>
ffffffffc0203da0:	8b85                	andi	a5,a5,1
ffffffffc0203da2:	f3ed                	bnez	a5,ffffffffc0203d84 <user_mem_check+0x42>
            return 0;
ffffffffc0203da4:	4501                	li	a0,0
        }
        return 1;
    }
    return KERN_ACCESS(addr, addr + len);
ffffffffc0203da6:	70a2                	ld	ra,40(sp)
ffffffffc0203da8:	7402                	ld	s0,32(sp)
ffffffffc0203daa:	64e2                	ld	s1,24(sp)
ffffffffc0203dac:	6942                	ld	s2,16(sp)
ffffffffc0203dae:	69a2                	ld	s3,8(sp)
ffffffffc0203db0:	6a02                	ld	s4,0(sp)
ffffffffc0203db2:	6145                	addi	sp,sp,48
ffffffffc0203db4:	8082                	ret
    return KERN_ACCESS(addr, addr + len);
ffffffffc0203db6:	c02007b7          	lui	a5,0xc0200
ffffffffc0203dba:	4501                	li	a0,0
ffffffffc0203dbc:	fef5e5e3          	bltu	a1,a5,ffffffffc0203da6 <user_mem_check+0x64>
ffffffffc0203dc0:	962e                	add	a2,a2,a1
ffffffffc0203dc2:	fec5f2e3          	bgeu	a1,a2,ffffffffc0203da6 <user_mem_check+0x64>
ffffffffc0203dc6:	c8000537          	lui	a0,0xc8000
ffffffffc0203dca:	0505                	addi	a0,a0,1
ffffffffc0203dcc:	00a63533          	sltu	a0,a2,a0
ffffffffc0203dd0:	bfd9                	j	ffffffffc0203da6 <user_mem_check+0x64>
        return 1;
ffffffffc0203dd2:	4505                	li	a0,1
ffffffffc0203dd4:	bfc9                	j	ffffffffc0203da6 <user_mem_check+0x64>

ffffffffc0203dd6 <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)
	move a0, s1
ffffffffc0203dd6:	8526                	mv	a0,s1
	jalr s0
ffffffffc0203dd8:	9402                	jalr	s0

	jal do_exit
ffffffffc0203dda:	628000ef          	jal	ra,ffffffffc0204402 <do_exit>

ffffffffc0203dde <alloc_proc>:
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void)
{
ffffffffc0203dde:	1141                	addi	sp,sp,-16
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0203de0:	10800513          	li	a0,264
{
ffffffffc0203de4:	e022                	sd	s0,0(sp)
ffffffffc0203de6:	e406                	sd	ra,8(sp)
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0203de8:	ee3fd0ef          	jal	ra,ffffffffc0201cca <kmalloc>
ffffffffc0203dec:	842a                	mv	s0,a0
    if (proc != NULL)
ffffffffc0203dee:	cd21                	beqz	a0,ffffffffc0203e46 <alloc_proc+0x68>
        /*
         * below fields(add in LAB5) in proc_struct need to be initialized
         *       uint32_t wait_state;                        // waiting state
         *       struct proc_struct *cptr, *yptr, *optr;     // relations between processes
         */
        proc->pgdir = boot_pgdir_pa; // 页目录表地址
ffffffffc0203df0:	000a7797          	auipc	a5,0xa7
ffffffffc0203df4:	9f07b783          	ld	a5,-1552(a5) # ffffffffc02aa7e0 <boot_pgdir_pa>
ffffffffc0203df8:	f55c                	sd	a5,168(a0)
        proc->state = PROC_UNINIT; // 进程状态：未初始化
ffffffffc0203dfa:	57fd                	li	a5,-1
ffffffffc0203dfc:	1782                	slli	a5,a5,0x20
ffffffffc0203dfe:	e11c                	sd	a5,0(a0)
        proc->need_resched = 0; // 调度标志
        proc->flags = 0; // 进程标志
        proc->parent = NULL; // 父进程指针
        proc->mm = NULL; // 内存管理结构
        proc->tf = NULL; // 中断帧指针
        memset(&(proc->context), 0, sizeof(struct context)); // 清空上下文
ffffffffc0203e00:	07000613          	li	a2,112
ffffffffc0203e04:	4581                	li	a1,0
        proc->runs = 0;  // 运行次数
ffffffffc0203e06:	00052423          	sw	zero,8(a0) # ffffffffc8000008 <end+0x7d557dc>
        proc->kstack = 0; // 内核栈地址
ffffffffc0203e0a:	00053823          	sd	zero,16(a0)
        proc->need_resched = 0; // 调度标志
ffffffffc0203e0e:	00053c23          	sd	zero,24(a0)
        proc->flags = 0; // 进程标志
ffffffffc0203e12:	0a052823          	sw	zero,176(a0)
        proc->parent = NULL; // 父进程指针
ffffffffc0203e16:	02053023          	sd	zero,32(a0)
        proc->mm = NULL; // 内存管理结构
ffffffffc0203e1a:	02053423          	sd	zero,40(a0)
        proc->tf = NULL; // 中断帧指针
ffffffffc0203e1e:	0a053023          	sd	zero,160(a0)
        memset(&(proc->context), 0, sizeof(struct context)); // 清空上下文
ffffffffc0203e22:	03050513          	addi	a0,a0,48
ffffffffc0203e26:	0ad010ef          	jal	ra,ffffffffc02056d2 <memset>
        memset(proc->name, 0, PROC_NAME_LEN + 1);    // 清空进程名称     
ffffffffc0203e2a:	4641                	li	a2,16
ffffffffc0203e2c:	4581                	li	a1,0
ffffffffc0203e2e:	0b440513          	addi	a0,s0,180
ffffffffc0203e32:	0a1010ef          	jal	ra,ffffffffc02056d2 <memset>
        proc->wait_state = 0; // 初始化等待状态
ffffffffc0203e36:	0e042623          	sw	zero,236(s0)
        proc->cptr = proc->optr = proc->yptr = NULL; // 初始化进程关系链表 
ffffffffc0203e3a:	0e043c23          	sd	zero,248(s0)
ffffffffc0203e3e:	10043023          	sd	zero,256(s0)
ffffffffc0203e42:	0e043823          	sd	zero,240(s0)
    }
    return proc;
}
ffffffffc0203e46:	60a2                	ld	ra,8(sp)
ffffffffc0203e48:	8522                	mv	a0,s0
ffffffffc0203e4a:	6402                	ld	s0,0(sp)
ffffffffc0203e4c:	0141                	addi	sp,sp,16
ffffffffc0203e4e:	8082                	ret

ffffffffc0203e50 <forkret>:
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void)
{
    forkrets(current->tf);
ffffffffc0203e50:	000a7797          	auipc	a5,0xa7
ffffffffc0203e54:	9c07b783          	ld	a5,-1600(a5) # ffffffffc02aa810 <current>
ffffffffc0203e58:	73c8                	ld	a0,160(a5)
ffffffffc0203e5a:	8e4fd06f          	j	ffffffffc0200f3e <forkrets>

ffffffffc0203e5e <user_main>:
// user_main - kernel thread used to exec a user program
static int
user_main(void *arg)
{
#ifdef TEST
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0203e5e:	000a7797          	auipc	a5,0xa7
ffffffffc0203e62:	9b27b783          	ld	a5,-1614(a5) # ffffffffc02aa810 <current>
ffffffffc0203e66:	43cc                	lw	a1,4(a5)
{
ffffffffc0203e68:	7139                	addi	sp,sp,-64
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0203e6a:	00003617          	auipc	a2,0x3
ffffffffc0203e6e:	0de60613          	addi	a2,a2,222 # ffffffffc0206f48 <default_pmm_manager+0xa08>
ffffffffc0203e72:	00003517          	auipc	a0,0x3
ffffffffc0203e76:	0e650513          	addi	a0,a0,230 # ffffffffc0206f58 <default_pmm_manager+0xa18>
{
ffffffffc0203e7a:	fc06                	sd	ra,56(sp)
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0203e7c:	b18fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0203e80:	3fe07797          	auipc	a5,0x3fe07
ffffffffc0203e84:	af078793          	addi	a5,a5,-1296 # a970 <_binary_obj___user_forktest_out_size>
ffffffffc0203e88:	e43e                	sd	a5,8(sp)
ffffffffc0203e8a:	00003517          	auipc	a0,0x3
ffffffffc0203e8e:	0be50513          	addi	a0,a0,190 # ffffffffc0206f48 <default_pmm_manager+0xa08>
ffffffffc0203e92:	00046797          	auipc	a5,0x46
ffffffffc0203e96:	8be78793          	addi	a5,a5,-1858 # ffffffffc0249750 <_binary_obj___user_forktest_out_start>
ffffffffc0203e9a:	f03e                	sd	a5,32(sp)
ffffffffc0203e9c:	f42a                	sd	a0,40(sp)
    int64_t ret = 0, len = strlen(name);
ffffffffc0203e9e:	e802                	sd	zero,16(sp)
ffffffffc0203ea0:	790010ef          	jal	ra,ffffffffc0205630 <strlen>
ffffffffc0203ea4:	ec2a                	sd	a0,24(sp)
    asm volatile(
ffffffffc0203ea6:	4511                	li	a0,4
ffffffffc0203ea8:	55a2                	lw	a1,40(sp)
ffffffffc0203eaa:	4662                	lw	a2,24(sp)
ffffffffc0203eac:	5682                	lw	a3,32(sp)
ffffffffc0203eae:	4722                	lw	a4,8(sp)
ffffffffc0203eb0:	48a9                	li	a7,10
ffffffffc0203eb2:	9002                	ebreak
ffffffffc0203eb4:	c82a                	sw	a0,16(sp)
    cprintf("ret = %d\n", ret);
ffffffffc0203eb6:	65c2                	ld	a1,16(sp)
ffffffffc0203eb8:	00003517          	auipc	a0,0x3
ffffffffc0203ebc:	0c850513          	addi	a0,a0,200 # ffffffffc0206f80 <default_pmm_manager+0xa40>
ffffffffc0203ec0:	ad4fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
#else
    KERNEL_EXECVE(exit);
#endif
    panic("user_main execve failed.\n");
ffffffffc0203ec4:	00003617          	auipc	a2,0x3
ffffffffc0203ec8:	0cc60613          	addi	a2,a2,204 # ffffffffc0206f90 <default_pmm_manager+0xa50>
ffffffffc0203ecc:	3c800593          	li	a1,968
ffffffffc0203ed0:	00003517          	auipc	a0,0x3
ffffffffc0203ed4:	0e050513          	addi	a0,a0,224 # ffffffffc0206fb0 <default_pmm_manager+0xa70>
ffffffffc0203ed8:	db6fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203edc <put_pgdir>:
    return pa2page(PADDR(kva));
ffffffffc0203edc:	6d14                	ld	a3,24(a0)
{
ffffffffc0203ede:	1141                	addi	sp,sp,-16
ffffffffc0203ee0:	e406                	sd	ra,8(sp)
ffffffffc0203ee2:	c02007b7          	lui	a5,0xc0200
ffffffffc0203ee6:	02f6ee63          	bltu	a3,a5,ffffffffc0203f22 <put_pgdir+0x46>
ffffffffc0203eea:	000a7517          	auipc	a0,0xa7
ffffffffc0203eee:	91e53503          	ld	a0,-1762(a0) # ffffffffc02aa808 <va_pa_offset>
ffffffffc0203ef2:	8e89                	sub	a3,a3,a0
    if (PPN(pa) >= npage)
ffffffffc0203ef4:	82b1                	srli	a3,a3,0xc
ffffffffc0203ef6:	000a7797          	auipc	a5,0xa7
ffffffffc0203efa:	8fa7b783          	ld	a5,-1798(a5) # ffffffffc02aa7f0 <npage>
ffffffffc0203efe:	02f6fe63          	bgeu	a3,a5,ffffffffc0203f3a <put_pgdir+0x5e>
    return &pages[PPN(pa) - nbase];
ffffffffc0203f02:	00004517          	auipc	a0,0x4
ffffffffc0203f06:	96653503          	ld	a0,-1690(a0) # ffffffffc0207868 <nbase>
}
ffffffffc0203f0a:	60a2                	ld	ra,8(sp)
ffffffffc0203f0c:	8e89                	sub	a3,a3,a0
ffffffffc0203f0e:	069a                	slli	a3,a3,0x6
    free_page(kva2page(mm->pgdir));
ffffffffc0203f10:	000a7517          	auipc	a0,0xa7
ffffffffc0203f14:	8e853503          	ld	a0,-1816(a0) # ffffffffc02aa7f8 <pages>
ffffffffc0203f18:	4585                	li	a1,1
ffffffffc0203f1a:	9536                	add	a0,a0,a3
}
ffffffffc0203f1c:	0141                	addi	sp,sp,16
    free_page(kva2page(mm->pgdir));
ffffffffc0203f1e:	fc9fd06f          	j	ffffffffc0201ee6 <free_pages>
    return pa2page(PADDR(kva));
ffffffffc0203f22:	00002617          	auipc	a2,0x2
ffffffffc0203f26:	6fe60613          	addi	a2,a2,1790 # ffffffffc0206620 <default_pmm_manager+0xe0>
ffffffffc0203f2a:	07700593          	li	a1,119
ffffffffc0203f2e:	00002517          	auipc	a0,0x2
ffffffffc0203f32:	67250513          	addi	a0,a0,1650 # ffffffffc02065a0 <default_pmm_manager+0x60>
ffffffffc0203f36:	d58fc0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0203f3a:	00002617          	auipc	a2,0x2
ffffffffc0203f3e:	70e60613          	addi	a2,a2,1806 # ffffffffc0206648 <default_pmm_manager+0x108>
ffffffffc0203f42:	06900593          	li	a1,105
ffffffffc0203f46:	00002517          	auipc	a0,0x2
ffffffffc0203f4a:	65a50513          	addi	a0,a0,1626 # ffffffffc02065a0 <default_pmm_manager+0x60>
ffffffffc0203f4e:	d40fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203f52 <proc_run>:
{
ffffffffc0203f52:	7179                	addi	sp,sp,-48
ffffffffc0203f54:	ec4a                	sd	s2,24(sp)
    if (proc != current)
ffffffffc0203f56:	000a7917          	auipc	s2,0xa7
ffffffffc0203f5a:	8ba90913          	addi	s2,s2,-1862 # ffffffffc02aa810 <current>
{
ffffffffc0203f5e:	f026                	sd	s1,32(sp)
    if (proc != current)
ffffffffc0203f60:	00093483          	ld	s1,0(s2)
{
ffffffffc0203f64:	f406                	sd	ra,40(sp)
ffffffffc0203f66:	e84e                	sd	s3,16(sp)
    if (proc != current)
ffffffffc0203f68:	02a48a63          	beq	s1,a0,ffffffffc0203f9c <proc_run+0x4a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203f6c:	100027f3          	csrr	a5,sstatus
ffffffffc0203f70:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0203f72:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203f74:	e3a9                	bnez	a5,ffffffffc0203fb6 <proc_run+0x64>
#define barrier() __asm__ __volatile__("fence" ::: "memory")

static inline void
lsatp(unsigned long pgdir)
{
  write_csr(satp, 0x8000000000000000 | (pgdir >> RISCV_PGSHIFT));
ffffffffc0203f76:	755c                	ld	a5,168(a0)
ffffffffc0203f78:	577d                	li	a4,-1
ffffffffc0203f7a:	177e                	slli	a4,a4,0x3f
ffffffffc0203f7c:	83b1                	srli	a5,a5,0xc
            current = proc;
ffffffffc0203f7e:	00a93023          	sd	a0,0(s2)
ffffffffc0203f82:	8fd9                	or	a5,a5,a4
ffffffffc0203f84:	18079073          	csrw	satp,a5
            asm volatile("sfence.vma");
ffffffffc0203f88:	12000073          	sfence.vma
            switch_to(&(prev->context), &(next->context));//进行上下文切换,之后代码执行流会跳转到next进程上次停止的地方或新进程的入口
ffffffffc0203f8c:	03050593          	addi	a1,a0,48
ffffffffc0203f90:	03048513          	addi	a0,s1,48
ffffffffc0203f94:	042010ef          	jal	ra,ffffffffc0204fd6 <switch_to>
    if (flag)
ffffffffc0203f98:	00099863          	bnez	s3,ffffffffc0203fa8 <proc_run+0x56>
}
ffffffffc0203f9c:	70a2                	ld	ra,40(sp)
ffffffffc0203f9e:	7482                	ld	s1,32(sp)
ffffffffc0203fa0:	6962                	ld	s2,24(sp)
ffffffffc0203fa2:	69c2                	ld	s3,16(sp)
ffffffffc0203fa4:	6145                	addi	sp,sp,48
ffffffffc0203fa6:	8082                	ret
ffffffffc0203fa8:	70a2                	ld	ra,40(sp)
ffffffffc0203faa:	7482                	ld	s1,32(sp)
ffffffffc0203fac:	6962                	ld	s2,24(sp)
ffffffffc0203fae:	69c2                	ld	s3,16(sp)
ffffffffc0203fb0:	6145                	addi	sp,sp,48
        intr_enable();
ffffffffc0203fb2:	9fdfc06f          	j	ffffffffc02009ae <intr_enable>
ffffffffc0203fb6:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0203fb8:	9fdfc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0203fbc:	6522                	ld	a0,8(sp)
ffffffffc0203fbe:	4985                	li	s3,1
ffffffffc0203fc0:	bf5d                	j	ffffffffc0203f76 <proc_run+0x24>

ffffffffc0203fc2 <do_fork>:
{
ffffffffc0203fc2:	7119                	addi	sp,sp,-128
ffffffffc0203fc4:	f0ca                	sd	s2,96(sp)
    if (nr_process >= MAX_PROCESS)
ffffffffc0203fc6:	000a7917          	auipc	s2,0xa7
ffffffffc0203fca:	86290913          	addi	s2,s2,-1950 # ffffffffc02aa828 <nr_process>
ffffffffc0203fce:	00092703          	lw	a4,0(s2)
{
ffffffffc0203fd2:	fc86                	sd	ra,120(sp)
ffffffffc0203fd4:	f8a2                	sd	s0,112(sp)
ffffffffc0203fd6:	f4a6                	sd	s1,104(sp)
ffffffffc0203fd8:	ecce                	sd	s3,88(sp)
ffffffffc0203fda:	e8d2                	sd	s4,80(sp)
ffffffffc0203fdc:	e4d6                	sd	s5,72(sp)
ffffffffc0203fde:	e0da                	sd	s6,64(sp)
ffffffffc0203fe0:	fc5e                	sd	s7,56(sp)
ffffffffc0203fe2:	f862                	sd	s8,48(sp)
ffffffffc0203fe4:	f466                	sd	s9,40(sp)
ffffffffc0203fe6:	f06a                	sd	s10,32(sp)
ffffffffc0203fe8:	ec6e                	sd	s11,24(sp)
    if (nr_process >= MAX_PROCESS)
ffffffffc0203fea:	6785                	lui	a5,0x1
ffffffffc0203fec:	32f75163          	bge	a4,a5,ffffffffc020430e <do_fork+0x34c>
ffffffffc0203ff0:	8a2a                	mv	s4,a0
ffffffffc0203ff2:	89ae                	mv	s3,a1
ffffffffc0203ff4:	8432                	mv	s0,a2
    proc = alloc_proc();
ffffffffc0203ff6:	de9ff0ef          	jal	ra,ffffffffc0203dde <alloc_proc>
ffffffffc0203ffa:	84aa                	mv	s1,a0
    if (proc == NULL) {
ffffffffc0203ffc:	2e050663          	beqz	a0,ffffffffc02042e8 <do_fork+0x326>
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc0204000:	4509                	li	a0,2
ffffffffc0204002:	ea7fd0ef          	jal	ra,ffffffffc0201ea8 <alloc_pages>
    if (page != NULL)
ffffffffc0204006:	2c050e63          	beqz	a0,ffffffffc02042e2 <do_fork+0x320>
    return page - pages + nbase;
ffffffffc020400a:	000a6a97          	auipc	s5,0xa6
ffffffffc020400e:	7eea8a93          	addi	s5,s5,2030 # ffffffffc02aa7f8 <pages>
ffffffffc0204012:	000ab683          	ld	a3,0(s5)
ffffffffc0204016:	00004797          	auipc	a5,0x4
ffffffffc020401a:	85278793          	addi	a5,a5,-1966 # ffffffffc0207868 <nbase>
ffffffffc020401e:	6398                	ld	a4,0(a5)
ffffffffc0204020:	40d506b3          	sub	a3,a0,a3
    return KADDR(page2pa(page));
ffffffffc0204024:	000a6b97          	auipc	s7,0xa6
ffffffffc0204028:	7ccb8b93          	addi	s7,s7,1996 # ffffffffc02aa7f0 <npage>
    return page - pages + nbase;
ffffffffc020402c:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc020402e:	57fd                	li	a5,-1
ffffffffc0204030:	000bb603          	ld	a2,0(s7)
    return page - pages + nbase;
ffffffffc0204034:	96ba                	add	a3,a3,a4
    return KADDR(page2pa(page));
ffffffffc0204036:	00c7db13          	srli	s6,a5,0xc
ffffffffc020403a:	0166f5b3          	and	a1,a3,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc020403e:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204040:	32c5f563          	bgeu	a1,a2,ffffffffc020436a <do_fork+0x3a8>
    struct mm_struct *mm, *oldmm = current->mm;
ffffffffc0204044:	000a6c97          	auipc	s9,0xa6
ffffffffc0204048:	7ccc8c93          	addi	s9,s9,1996 # ffffffffc02aa810 <current>
ffffffffc020404c:	000cb303          	ld	t1,0(s9)
ffffffffc0204050:	000a6c17          	auipc	s8,0xa6
ffffffffc0204054:	7b8c0c13          	addi	s8,s8,1976 # ffffffffc02aa808 <va_pa_offset>
ffffffffc0204058:	000c3603          	ld	a2,0(s8)
ffffffffc020405c:	02833d83          	ld	s11,40(t1) # 80028 <_binary_obj___user_exit_out_size+0x74ef8>
ffffffffc0204060:	e43a                	sd	a4,8(sp)
ffffffffc0204062:	96b2                	add	a3,a3,a2
        proc->kstack = (uintptr_t)page2kva(page);
ffffffffc0204064:	e894                	sd	a3,16(s1)
    if (oldmm == NULL)
ffffffffc0204066:	020d8a63          	beqz	s11,ffffffffc020409a <do_fork+0xd8>
    if (clone_flags & CLONE_VM)
ffffffffc020406a:	100a7a13          	andi	s4,s4,256
ffffffffc020406e:	1a0a0863          	beqz	s4,ffffffffc020421e <do_fork+0x25c>
}

static inline int
mm_count_inc(struct mm_struct *mm)
{
    mm->mm_count += 1;
ffffffffc0204072:	030da703          	lw	a4,48(s11)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0204076:	018db783          	ld	a5,24(s11)
ffffffffc020407a:	c02006b7          	lui	a3,0xc0200
ffffffffc020407e:	2705                	addiw	a4,a4,1
ffffffffc0204080:	02eda823          	sw	a4,48(s11)
    proc->mm = mm;
ffffffffc0204084:	03b4b423          	sd	s11,40(s1)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0204088:	2ad7e863          	bltu	a5,a3,ffffffffc0204338 <do_fork+0x376>
ffffffffc020408c:	000c3703          	ld	a4,0(s8)
    proc->parent = current;
ffffffffc0204090:	000cb303          	ld	t1,0(s9)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc0204094:	6894                	ld	a3,16(s1)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0204096:	8f99                	sub	a5,a5,a4
ffffffffc0204098:	f4dc                	sd	a5,168(s1)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc020409a:	6789                	lui	a5,0x2
ffffffffc020409c:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_obj___user_faultread_out_size-0x7cd8>
ffffffffc02040a0:	96be                	add	a3,a3,a5
    *(proc->tf) = *tf;
ffffffffc02040a2:	8622                	mv	a2,s0
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc02040a4:	f0d4                	sd	a3,160(s1)
    *(proc->tf) = *tf;
ffffffffc02040a6:	87b6                	mv	a5,a3
ffffffffc02040a8:	12040893          	addi	a7,s0,288
ffffffffc02040ac:	00063803          	ld	a6,0(a2)
ffffffffc02040b0:	6608                	ld	a0,8(a2)
ffffffffc02040b2:	6a0c                	ld	a1,16(a2)
ffffffffc02040b4:	6e18                	ld	a4,24(a2)
ffffffffc02040b6:	0107b023          	sd	a6,0(a5)
ffffffffc02040ba:	e788                	sd	a0,8(a5)
ffffffffc02040bc:	eb8c                	sd	a1,16(a5)
ffffffffc02040be:	ef98                	sd	a4,24(a5)
ffffffffc02040c0:	02060613          	addi	a2,a2,32
ffffffffc02040c4:	02078793          	addi	a5,a5,32
ffffffffc02040c8:	ff1612e3          	bne	a2,a7,ffffffffc02040ac <do_fork+0xea>
    proc->tf->gpr.a0 = 0;
ffffffffc02040cc:	0406b823          	sd	zero,80(a3) # ffffffffc0200050 <kern_init+0x6>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc02040d0:	14098563          	beqz	s3,ffffffffc020421a <do_fork+0x258>
    assert(current->wait_state == 0);
ffffffffc02040d4:	0ec32783          	lw	a5,236(t1)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc02040d8:	00000717          	auipc	a4,0x0
ffffffffc02040dc:	d7870713          	addi	a4,a4,-648 # ffffffffc0203e50 <forkret>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc02040e0:	0136b823          	sd	s3,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc02040e4:	f898                	sd	a4,48(s1)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc02040e6:	fc94                	sd	a3,56(s1)
    proc->parent = current;
ffffffffc02040e8:	0264b023          	sd	t1,32(s1)
    assert(current->wait_state == 0);
ffffffffc02040ec:	22079663          	bnez	a5,ffffffffc0204318 <do_fork+0x356>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02040f0:	100027f3          	csrr	a5,sstatus
ffffffffc02040f4:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02040f6:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02040f8:	20079263          	bnez	a5,ffffffffc02042fc <do_fork+0x33a>
    if (++last_pid >= MAX_PID)
ffffffffc02040fc:	000a2817          	auipc	a6,0xa2
ffffffffc0204100:	27c80813          	addi	a6,a6,636 # ffffffffc02a6378 <last_pid.1>
ffffffffc0204104:	00082783          	lw	a5,0(a6)
ffffffffc0204108:	6709                	lui	a4,0x2
ffffffffc020410a:	0017851b          	addiw	a0,a5,1
ffffffffc020410e:	00a82023          	sw	a0,0(a6)
ffffffffc0204112:	08e55d63          	bge	a0,a4,ffffffffc02041ac <do_fork+0x1ea>
    if (last_pid >= next_safe)
ffffffffc0204116:	000a2317          	auipc	t1,0xa2
ffffffffc020411a:	26630313          	addi	t1,t1,614 # ffffffffc02a637c <next_safe.0>
ffffffffc020411e:	00032783          	lw	a5,0(t1)
ffffffffc0204122:	000a6417          	auipc	s0,0xa6
ffffffffc0204126:	67640413          	addi	s0,s0,1654 # ffffffffc02aa798 <proc_list>
ffffffffc020412a:	08f55963          	bge	a0,a5,ffffffffc02041bc <do_fork+0x1fa>
        proc->pid = get_pid();
ffffffffc020412e:	c0c8                	sw	a0,4(s1)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc0204130:	45a9                	li	a1,10
ffffffffc0204132:	2501                	sext.w	a0,a0
ffffffffc0204134:	0f8010ef          	jal	ra,ffffffffc020522c <hash32>
ffffffffc0204138:	02051793          	slli	a5,a0,0x20
ffffffffc020413c:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0204140:	000a2797          	auipc	a5,0xa2
ffffffffc0204144:	65878793          	addi	a5,a5,1624 # ffffffffc02a6798 <hash_list>
ffffffffc0204148:	953e                	add	a0,a0,a5
    __list_add(elm, listelm, listelm->next);
ffffffffc020414a:	650c                	ld	a1,8(a0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc020414c:	7094                	ld	a3,32(s1)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc020414e:	0d848793          	addi	a5,s1,216
    prev->next = next->prev = elm;
ffffffffc0204152:	e19c                	sd	a5,0(a1)
    __list_add(elm, listelm, listelm->next);
ffffffffc0204154:	6410                	ld	a2,8(s0)
    prev->next = next->prev = elm;
ffffffffc0204156:	e51c                	sd	a5,8(a0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0204158:	7af8                	ld	a4,240(a3)
    list_add(&proc_list, &(proc->list_link));
ffffffffc020415a:	0c848793          	addi	a5,s1,200
    elm->next = next;
ffffffffc020415e:	f0ec                	sd	a1,224(s1)
    elm->prev = prev;
ffffffffc0204160:	ece8                	sd	a0,216(s1)
    prev->next = next->prev = elm;
ffffffffc0204162:	e21c                	sd	a5,0(a2)
ffffffffc0204164:	e41c                	sd	a5,8(s0)
    elm->next = next;
ffffffffc0204166:	e8f0                	sd	a2,208(s1)
    elm->prev = prev;
ffffffffc0204168:	e4e0                	sd	s0,200(s1)
    proc->yptr = NULL;
ffffffffc020416a:	0e04bc23          	sd	zero,248(s1)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc020416e:	10e4b023          	sd	a4,256(s1)
ffffffffc0204172:	c311                	beqz	a4,ffffffffc0204176 <do_fork+0x1b4>
        proc->optr->yptr = proc;
ffffffffc0204174:	ff64                	sd	s1,248(a4)
    nr_process++;
ffffffffc0204176:	00092783          	lw	a5,0(s2)
    proc->parent->cptr = proc;
ffffffffc020417a:	fae4                	sd	s1,240(a3)
    nr_process++;
ffffffffc020417c:	2785                	addiw	a5,a5,1
ffffffffc020417e:	00f92023          	sw	a5,0(s2)
    if (flag)
ffffffffc0204182:	16099563          	bnez	s3,ffffffffc02042ec <do_fork+0x32a>
    wakeup_proc(proc);
ffffffffc0204186:	8526                	mv	a0,s1
ffffffffc0204188:	6b9000ef          	jal	ra,ffffffffc0205040 <wakeup_proc>
    ret = proc->pid;
ffffffffc020418c:	40c8                	lw	a0,4(s1)
}
ffffffffc020418e:	70e6                	ld	ra,120(sp)
ffffffffc0204190:	7446                	ld	s0,112(sp)
ffffffffc0204192:	74a6                	ld	s1,104(sp)
ffffffffc0204194:	7906                	ld	s2,96(sp)
ffffffffc0204196:	69e6                	ld	s3,88(sp)
ffffffffc0204198:	6a46                	ld	s4,80(sp)
ffffffffc020419a:	6aa6                	ld	s5,72(sp)
ffffffffc020419c:	6b06                	ld	s6,64(sp)
ffffffffc020419e:	7be2                	ld	s7,56(sp)
ffffffffc02041a0:	7c42                	ld	s8,48(sp)
ffffffffc02041a2:	7ca2                	ld	s9,40(sp)
ffffffffc02041a4:	7d02                	ld	s10,32(sp)
ffffffffc02041a6:	6de2                	ld	s11,24(sp)
ffffffffc02041a8:	6109                	addi	sp,sp,128
ffffffffc02041aa:	8082                	ret
        last_pid = 1;
ffffffffc02041ac:	4785                	li	a5,1
ffffffffc02041ae:	00f82023          	sw	a5,0(a6)
        goto inside;
ffffffffc02041b2:	4505                	li	a0,1
ffffffffc02041b4:	000a2317          	auipc	t1,0xa2
ffffffffc02041b8:	1c830313          	addi	t1,t1,456 # ffffffffc02a637c <next_safe.0>
    return listelm->next;
ffffffffc02041bc:	000a6417          	auipc	s0,0xa6
ffffffffc02041c0:	5dc40413          	addi	s0,s0,1500 # ffffffffc02aa798 <proc_list>
ffffffffc02041c4:	00843e03          	ld	t3,8(s0)
        next_safe = MAX_PID;
ffffffffc02041c8:	6789                	lui	a5,0x2
ffffffffc02041ca:	00f32023          	sw	a5,0(t1)
ffffffffc02041ce:	86aa                	mv	a3,a0
ffffffffc02041d0:	4581                	li	a1,0
        while ((le = list_next(le)) != list)
ffffffffc02041d2:	6e89                	lui	t4,0x2
ffffffffc02041d4:	128e0863          	beq	t3,s0,ffffffffc0204304 <do_fork+0x342>
ffffffffc02041d8:	88ae                	mv	a7,a1
ffffffffc02041da:	87f2                	mv	a5,t3
ffffffffc02041dc:	6609                	lui	a2,0x2
ffffffffc02041de:	a811                	j	ffffffffc02041f2 <do_fork+0x230>
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc02041e0:	00e6d663          	bge	a3,a4,ffffffffc02041ec <do_fork+0x22a>
ffffffffc02041e4:	00c75463          	bge	a4,a2,ffffffffc02041ec <do_fork+0x22a>
ffffffffc02041e8:	863a                	mv	a2,a4
ffffffffc02041ea:	4885                	li	a7,1
ffffffffc02041ec:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc02041ee:	00878d63          	beq	a5,s0,ffffffffc0204208 <do_fork+0x246>
            if (proc->pid == last_pid)
ffffffffc02041f2:	f3c7a703          	lw	a4,-196(a5) # 1f3c <_binary_obj___user_faultread_out_size-0x7c7c>
ffffffffc02041f6:	fed715e3          	bne	a4,a3,ffffffffc02041e0 <do_fork+0x21e>
                if (++last_pid >= next_safe)
ffffffffc02041fa:	2685                	addiw	a3,a3,1
ffffffffc02041fc:	0ec6db63          	bge	a3,a2,ffffffffc02042f2 <do_fork+0x330>
ffffffffc0204200:	679c                	ld	a5,8(a5)
ffffffffc0204202:	4585                	li	a1,1
        while ((le = list_next(le)) != list)
ffffffffc0204204:	fe8797e3          	bne	a5,s0,ffffffffc02041f2 <do_fork+0x230>
ffffffffc0204208:	c581                	beqz	a1,ffffffffc0204210 <do_fork+0x24e>
ffffffffc020420a:	00d82023          	sw	a3,0(a6)
ffffffffc020420e:	8536                	mv	a0,a3
ffffffffc0204210:	f0088fe3          	beqz	a7,ffffffffc020412e <do_fork+0x16c>
ffffffffc0204214:	00c32023          	sw	a2,0(t1)
ffffffffc0204218:	bf19                	j	ffffffffc020412e <do_fork+0x16c>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc020421a:	89b6                	mv	s3,a3
ffffffffc020421c:	bd65                	j	ffffffffc02040d4 <do_fork+0x112>
    if ((mm = mm_create()) == NULL)
ffffffffc020421e:	caeff0ef          	jal	ra,ffffffffc02036cc <mm_create>
ffffffffc0204222:	8d2a                	mv	s10,a0
ffffffffc0204224:	c541                	beqz	a0,ffffffffc02042ac <do_fork+0x2ea>
    if ((page = alloc_page()) == NULL)
ffffffffc0204226:	4505                	li	a0,1
ffffffffc0204228:	c81fd0ef          	jal	ra,ffffffffc0201ea8 <alloc_pages>
ffffffffc020422c:	cd2d                	beqz	a0,ffffffffc02042a6 <do_fork+0x2e4>
    return page - pages + nbase;
ffffffffc020422e:	000ab683          	ld	a3,0(s5)
ffffffffc0204232:	6722                	ld	a4,8(sp)
    return KADDR(page2pa(page));
ffffffffc0204234:	000bb603          	ld	a2,0(s7)
    return page - pages + nbase;
ffffffffc0204238:	40d506b3          	sub	a3,a0,a3
ffffffffc020423c:	8699                	srai	a3,a3,0x6
ffffffffc020423e:	96ba                	add	a3,a3,a4
    return KADDR(page2pa(page));
ffffffffc0204240:	0166f7b3          	and	a5,a3,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc0204244:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204246:	12c7f263          	bgeu	a5,a2,ffffffffc020436a <do_fork+0x3a8>
ffffffffc020424a:	000c3a03          	ld	s4,0(s8)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc020424e:	6605                	lui	a2,0x1
ffffffffc0204250:	000a6597          	auipc	a1,0xa6
ffffffffc0204254:	5985b583          	ld	a1,1432(a1) # ffffffffc02aa7e8 <boot_pgdir_va>
ffffffffc0204258:	9a36                	add	s4,s4,a3
ffffffffc020425a:	8552                	mv	a0,s4
ffffffffc020425c:	488010ef          	jal	ra,ffffffffc02056e4 <memcpy>
static inline void
lock_mm(struct mm_struct *mm)
{
    if (mm != NULL)
    {
        lock(&(mm->mm_lock));
ffffffffc0204260:	038d8b13          	addi	s6,s11,56
    mm->pgdir = pgdir;
ffffffffc0204264:	014d3c23          	sd	s4,24(s10)
 * test_and_set_bit - Atomically set a bit and return its old value
 * @nr:     the bit to set
 * @addr:   the address to count from
 * */
static inline bool test_and_set_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0204268:	4785                	li	a5,1
ffffffffc020426a:	40fb37af          	amoor.d	a5,a5,(s6)
}

static inline void
lock(lock_t *lock)
{
    while (!try_lock(lock))
ffffffffc020426e:	8b85                	andi	a5,a5,1
ffffffffc0204270:	4a05                	li	s4,1
ffffffffc0204272:	c799                	beqz	a5,ffffffffc0204280 <do_fork+0x2be>
    {
        schedule();
ffffffffc0204274:	64d000ef          	jal	ra,ffffffffc02050c0 <schedule>
ffffffffc0204278:	414b37af          	amoor.d	a5,s4,(s6)
    while (!try_lock(lock))
ffffffffc020427c:	8b85                	andi	a5,a5,1
ffffffffc020427e:	fbfd                	bnez	a5,ffffffffc0204274 <do_fork+0x2b2>
        ret = dup_mmap(mm, oldmm);
ffffffffc0204280:	85ee                	mv	a1,s11
ffffffffc0204282:	856a                	mv	a0,s10
ffffffffc0204284:	e8aff0ef          	jal	ra,ffffffffc020390e <dup_mmap>
 * test_and_clear_bit - Atomically clear a bit and return its old value
 * @nr:     the bit to clear
 * @addr:   the address to count from
 * */
static inline bool test_and_clear_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0204288:	57f9                	li	a5,-2
ffffffffc020428a:	60fb37af          	amoand.d	a5,a5,(s6)
ffffffffc020428e:	8b85                	andi	a5,a5,1
}

static inline void
unlock(lock_t *lock)
{
    if (!test_and_clear_bit(0, lock))
ffffffffc0204290:	10078563          	beqz	a5,ffffffffc020439a <do_fork+0x3d8>
good_mm:
ffffffffc0204294:	8dea                	mv	s11,s10
    if (ret != 0)
ffffffffc0204296:	dc050ee3          	beqz	a0,ffffffffc0204072 <do_fork+0xb0>
    exit_mmap(mm);
ffffffffc020429a:	856a                	mv	a0,s10
ffffffffc020429c:	f0cff0ef          	jal	ra,ffffffffc02039a8 <exit_mmap>
    put_pgdir(mm);
ffffffffc02042a0:	856a                	mv	a0,s10
ffffffffc02042a2:	c3bff0ef          	jal	ra,ffffffffc0203edc <put_pgdir>
    mm_destroy(mm);
ffffffffc02042a6:	856a                	mv	a0,s10
ffffffffc02042a8:	d64ff0ef          	jal	ra,ffffffffc020380c <mm_destroy>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc02042ac:	6894                	ld	a3,16(s1)
    return pa2page(PADDR(kva));
ffffffffc02042ae:	c02007b7          	lui	a5,0xc0200
ffffffffc02042b2:	0cf6e863          	bltu	a3,a5,ffffffffc0204382 <do_fork+0x3c0>
ffffffffc02042b6:	000c3783          	ld	a5,0(s8)
    if (PPN(pa) >= npage)
ffffffffc02042ba:	000bb703          	ld	a4,0(s7)
    return pa2page(PADDR(kva));
ffffffffc02042be:	40f687b3          	sub	a5,a3,a5
    if (PPN(pa) >= npage)
ffffffffc02042c2:	83b1                	srli	a5,a5,0xc
ffffffffc02042c4:	08e7f763          	bgeu	a5,a4,ffffffffc0204352 <do_fork+0x390>
    return &pages[PPN(pa) - nbase];
ffffffffc02042c8:	00003717          	auipc	a4,0x3
ffffffffc02042cc:	5a070713          	addi	a4,a4,1440 # ffffffffc0207868 <nbase>
ffffffffc02042d0:	6318                	ld	a4,0(a4)
ffffffffc02042d2:	000ab503          	ld	a0,0(s5)
ffffffffc02042d6:	4589                	li	a1,2
ffffffffc02042d8:	8f99                	sub	a5,a5,a4
ffffffffc02042da:	079a                	slli	a5,a5,0x6
ffffffffc02042dc:	953e                	add	a0,a0,a5
ffffffffc02042de:	c09fd0ef          	jal	ra,ffffffffc0201ee6 <free_pages>
    kfree(proc);
ffffffffc02042e2:	8526                	mv	a0,s1
ffffffffc02042e4:	a97fd0ef          	jal	ra,ffffffffc0201d7a <kfree>
    ret = -E_NO_MEM;
ffffffffc02042e8:	5571                	li	a0,-4
    return ret;
ffffffffc02042ea:	b555                	j	ffffffffc020418e <do_fork+0x1cc>
        intr_enable();
ffffffffc02042ec:	ec2fc0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02042f0:	bd59                	j	ffffffffc0204186 <do_fork+0x1c4>
                    if (last_pid >= MAX_PID)
ffffffffc02042f2:	01d6c363          	blt	a3,t4,ffffffffc02042f8 <do_fork+0x336>
                        last_pid = 1;
ffffffffc02042f6:	4685                	li	a3,1
                    goto repeat;
ffffffffc02042f8:	4585                	li	a1,1
ffffffffc02042fa:	bde9                	j	ffffffffc02041d4 <do_fork+0x212>
        intr_disable();
ffffffffc02042fc:	eb8fc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0204300:	4985                	li	s3,1
ffffffffc0204302:	bbed                	j	ffffffffc02040fc <do_fork+0x13a>
ffffffffc0204304:	c599                	beqz	a1,ffffffffc0204312 <do_fork+0x350>
ffffffffc0204306:	00d82023          	sw	a3,0(a6)
    return last_pid;
ffffffffc020430a:	8536                	mv	a0,a3
ffffffffc020430c:	b50d                	j	ffffffffc020412e <do_fork+0x16c>
    int ret = -E_NO_FREE_PROC;
ffffffffc020430e:	556d                	li	a0,-5
ffffffffc0204310:	bdbd                	j	ffffffffc020418e <do_fork+0x1cc>
    return last_pid;
ffffffffc0204312:	00082503          	lw	a0,0(a6)
ffffffffc0204316:	bd21                	j	ffffffffc020412e <do_fork+0x16c>
    assert(current->wait_state == 0);
ffffffffc0204318:	00003697          	auipc	a3,0x3
ffffffffc020431c:	cd868693          	addi	a3,a3,-808 # ffffffffc0206ff0 <default_pmm_manager+0xab0>
ffffffffc0204320:	00002617          	auipc	a2,0x2
ffffffffc0204324:	e7060613          	addi	a2,a2,-400 # ffffffffc0206190 <commands+0x828>
ffffffffc0204328:	1ed00593          	li	a1,493
ffffffffc020432c:	00003517          	auipc	a0,0x3
ffffffffc0204330:	c8450513          	addi	a0,a0,-892 # ffffffffc0206fb0 <default_pmm_manager+0xa70>
ffffffffc0204334:	95afc0ef          	jal	ra,ffffffffc020048e <__panic>
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0204338:	86be                	mv	a3,a5
ffffffffc020433a:	00002617          	auipc	a2,0x2
ffffffffc020433e:	2e660613          	addi	a2,a2,742 # ffffffffc0206620 <default_pmm_manager+0xe0>
ffffffffc0204342:	18d00593          	li	a1,397
ffffffffc0204346:	00003517          	auipc	a0,0x3
ffffffffc020434a:	c6a50513          	addi	a0,a0,-918 # ffffffffc0206fb0 <default_pmm_manager+0xa70>
ffffffffc020434e:	940fc0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0204352:	00002617          	auipc	a2,0x2
ffffffffc0204356:	2f660613          	addi	a2,a2,758 # ffffffffc0206648 <default_pmm_manager+0x108>
ffffffffc020435a:	06900593          	li	a1,105
ffffffffc020435e:	00002517          	auipc	a0,0x2
ffffffffc0204362:	24250513          	addi	a0,a0,578 # ffffffffc02065a0 <default_pmm_manager+0x60>
ffffffffc0204366:	928fc0ef          	jal	ra,ffffffffc020048e <__panic>
    return KADDR(page2pa(page));
ffffffffc020436a:	00002617          	auipc	a2,0x2
ffffffffc020436e:	20e60613          	addi	a2,a2,526 # ffffffffc0206578 <default_pmm_manager+0x38>
ffffffffc0204372:	07100593          	li	a1,113
ffffffffc0204376:	00002517          	auipc	a0,0x2
ffffffffc020437a:	22a50513          	addi	a0,a0,554 # ffffffffc02065a0 <default_pmm_manager+0x60>
ffffffffc020437e:	910fc0ef          	jal	ra,ffffffffc020048e <__panic>
    return pa2page(PADDR(kva));
ffffffffc0204382:	00002617          	auipc	a2,0x2
ffffffffc0204386:	29e60613          	addi	a2,a2,670 # ffffffffc0206620 <default_pmm_manager+0xe0>
ffffffffc020438a:	07700593          	li	a1,119
ffffffffc020438e:	00002517          	auipc	a0,0x2
ffffffffc0204392:	21250513          	addi	a0,a0,530 # ffffffffc02065a0 <default_pmm_manager+0x60>
ffffffffc0204396:	8f8fc0ef          	jal	ra,ffffffffc020048e <__panic>
    {
        panic("Unlock failed.\n");
ffffffffc020439a:	00003617          	auipc	a2,0x3
ffffffffc020439e:	c2e60613          	addi	a2,a2,-978 # ffffffffc0206fc8 <default_pmm_manager+0xa88>
ffffffffc02043a2:	03f00593          	li	a1,63
ffffffffc02043a6:	00003517          	auipc	a0,0x3
ffffffffc02043aa:	c3250513          	addi	a0,a0,-974 # ffffffffc0206fd8 <default_pmm_manager+0xa98>
ffffffffc02043ae:	8e0fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02043b2 <kernel_thread>:
{
ffffffffc02043b2:	7129                	addi	sp,sp,-320
ffffffffc02043b4:	fa22                	sd	s0,304(sp)
ffffffffc02043b6:	f626                	sd	s1,296(sp)
ffffffffc02043b8:	f24a                	sd	s2,288(sp)
ffffffffc02043ba:	84ae                	mv	s1,a1
ffffffffc02043bc:	892a                	mv	s2,a0
ffffffffc02043be:	8432                	mv	s0,a2
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc02043c0:	4581                	li	a1,0
ffffffffc02043c2:	12000613          	li	a2,288
ffffffffc02043c6:	850a                	mv	a0,sp
{
ffffffffc02043c8:	fe06                	sd	ra,312(sp)
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc02043ca:	308010ef          	jal	ra,ffffffffc02056d2 <memset>
    tf.gpr.s0 = (uintptr_t)fn;
ffffffffc02043ce:	e0ca                	sd	s2,64(sp)
    tf.gpr.s1 = (uintptr_t)arg;
ffffffffc02043d0:	e4a6                	sd	s1,72(sp)
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc02043d2:	100027f3          	csrr	a5,sstatus
ffffffffc02043d6:	edd7f793          	andi	a5,a5,-291
ffffffffc02043da:	1207e793          	ori	a5,a5,288
ffffffffc02043de:	e23e                	sd	a5,256(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02043e0:	860a                	mv	a2,sp
ffffffffc02043e2:	10046513          	ori	a0,s0,256
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc02043e6:	00000797          	auipc	a5,0x0
ffffffffc02043ea:	9f078793          	addi	a5,a5,-1552 # ffffffffc0203dd6 <kernel_thread_entry>
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02043ee:	4581                	li	a1,0
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc02043f0:	e63e                	sd	a5,264(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02043f2:	bd1ff0ef          	jal	ra,ffffffffc0203fc2 <do_fork>
}
ffffffffc02043f6:	70f2                	ld	ra,312(sp)
ffffffffc02043f8:	7452                	ld	s0,304(sp)
ffffffffc02043fa:	74b2                	ld	s1,296(sp)
ffffffffc02043fc:	7912                	ld	s2,288(sp)
ffffffffc02043fe:	6131                	addi	sp,sp,320
ffffffffc0204400:	8082                	ret

ffffffffc0204402 <do_exit>:
{
ffffffffc0204402:	7179                	addi	sp,sp,-48
ffffffffc0204404:	f022                	sd	s0,32(sp)
    if (current == idleproc)
ffffffffc0204406:	000a6417          	auipc	s0,0xa6
ffffffffc020440a:	40a40413          	addi	s0,s0,1034 # ffffffffc02aa810 <current>
ffffffffc020440e:	601c                	ld	a5,0(s0)
{
ffffffffc0204410:	f406                	sd	ra,40(sp)
ffffffffc0204412:	ec26                	sd	s1,24(sp)
ffffffffc0204414:	e84a                	sd	s2,16(sp)
ffffffffc0204416:	e44e                	sd	s3,8(sp)
ffffffffc0204418:	e052                	sd	s4,0(sp)
    if (current == idleproc)
ffffffffc020441a:	000a6717          	auipc	a4,0xa6
ffffffffc020441e:	3fe73703          	ld	a4,1022(a4) # ffffffffc02aa818 <idleproc>
ffffffffc0204422:	0ce78c63          	beq	a5,a4,ffffffffc02044fa <do_exit+0xf8>
    if (current == initproc)
ffffffffc0204426:	000a6497          	auipc	s1,0xa6
ffffffffc020442a:	3fa48493          	addi	s1,s1,1018 # ffffffffc02aa820 <initproc>
ffffffffc020442e:	6098                	ld	a4,0(s1)
ffffffffc0204430:	0ee78b63          	beq	a5,a4,ffffffffc0204526 <do_exit+0x124>
    struct mm_struct *mm = current->mm;
ffffffffc0204434:	0287b983          	ld	s3,40(a5)
ffffffffc0204438:	892a                	mv	s2,a0
    if (mm != NULL)
ffffffffc020443a:	02098663          	beqz	s3,ffffffffc0204466 <do_exit+0x64>
ffffffffc020443e:	000a6797          	auipc	a5,0xa6
ffffffffc0204442:	3a27b783          	ld	a5,930(a5) # ffffffffc02aa7e0 <boot_pgdir_pa>
ffffffffc0204446:	577d                	li	a4,-1
ffffffffc0204448:	177e                	slli	a4,a4,0x3f
ffffffffc020444a:	83b1                	srli	a5,a5,0xc
ffffffffc020444c:	8fd9                	or	a5,a5,a4
ffffffffc020444e:	18079073          	csrw	satp,a5
    mm->mm_count -= 1;
ffffffffc0204452:	0309a783          	lw	a5,48(s3)
ffffffffc0204456:	fff7871b          	addiw	a4,a5,-1
ffffffffc020445a:	02e9a823          	sw	a4,48(s3)
        if (mm_count_dec(mm) == 0)
ffffffffc020445e:	cb55                	beqz	a4,ffffffffc0204512 <do_exit+0x110>
        current->mm = NULL;
ffffffffc0204460:	601c                	ld	a5,0(s0)
ffffffffc0204462:	0207b423          	sd	zero,40(a5)
    current->state = PROC_ZOMBIE;
ffffffffc0204466:	601c                	ld	a5,0(s0)
ffffffffc0204468:	470d                	li	a4,3
ffffffffc020446a:	c398                	sw	a4,0(a5)
    current->exit_code = error_code;
ffffffffc020446c:	0f27a423          	sw	s2,232(a5)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204470:	100027f3          	csrr	a5,sstatus
ffffffffc0204474:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204476:	4a01                	li	s4,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204478:	e3f9                	bnez	a5,ffffffffc020453e <do_exit+0x13c>
        proc = current->parent;
ffffffffc020447a:	6018                	ld	a4,0(s0)
        if (proc->wait_state == WT_CHILD)
ffffffffc020447c:	800007b7          	lui	a5,0x80000
ffffffffc0204480:	0785                	addi	a5,a5,1
        proc = current->parent;
ffffffffc0204482:	7308                	ld	a0,32(a4)
        if (proc->wait_state == WT_CHILD)
ffffffffc0204484:	0ec52703          	lw	a4,236(a0)
ffffffffc0204488:	0af70f63          	beq	a4,a5,ffffffffc0204546 <do_exit+0x144>
        while (current->cptr != NULL)
ffffffffc020448c:	6018                	ld	a4,0(s0)
ffffffffc020448e:	7b7c                	ld	a5,240(a4)
ffffffffc0204490:	c3a1                	beqz	a5,ffffffffc02044d0 <do_exit+0xce>
                if (initproc->wait_state == WT_CHILD)
ffffffffc0204492:	800009b7          	lui	s3,0x80000
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204496:	490d                	li	s2,3
                if (initproc->wait_state == WT_CHILD)
ffffffffc0204498:	0985                	addi	s3,s3,1
ffffffffc020449a:	a021                	j	ffffffffc02044a2 <do_exit+0xa0>
        while (current->cptr != NULL)
ffffffffc020449c:	6018                	ld	a4,0(s0)
ffffffffc020449e:	7b7c                	ld	a5,240(a4)
ffffffffc02044a0:	cb85                	beqz	a5,ffffffffc02044d0 <do_exit+0xce>
            current->cptr = proc->optr;
ffffffffc02044a2:	1007b683          	ld	a3,256(a5) # ffffffff80000100 <_binary_obj___user_exit_out_size+0xffffffff7fff4fd0>
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc02044a6:	6088                	ld	a0,0(s1)
            current->cptr = proc->optr;
ffffffffc02044a8:	fb74                	sd	a3,240(a4)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc02044aa:	7978                	ld	a4,240(a0)
            proc->yptr = NULL;
ffffffffc02044ac:	0e07bc23          	sd	zero,248(a5)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc02044b0:	10e7b023          	sd	a4,256(a5)
ffffffffc02044b4:	c311                	beqz	a4,ffffffffc02044b8 <do_exit+0xb6>
                initproc->cptr->yptr = proc;
ffffffffc02044b6:	ff7c                	sd	a5,248(a4)
            if (proc->state == PROC_ZOMBIE)
ffffffffc02044b8:	4398                	lw	a4,0(a5)
            proc->parent = initproc;
ffffffffc02044ba:	f388                	sd	a0,32(a5)
            initproc->cptr = proc;
ffffffffc02044bc:	f97c                	sd	a5,240(a0)
            if (proc->state == PROC_ZOMBIE)
ffffffffc02044be:	fd271fe3          	bne	a4,s2,ffffffffc020449c <do_exit+0x9a>
                if (initproc->wait_state == WT_CHILD)
ffffffffc02044c2:	0ec52783          	lw	a5,236(a0)
ffffffffc02044c6:	fd379be3          	bne	a5,s3,ffffffffc020449c <do_exit+0x9a>
                    wakeup_proc(initproc);
ffffffffc02044ca:	377000ef          	jal	ra,ffffffffc0205040 <wakeup_proc>
ffffffffc02044ce:	b7f9                	j	ffffffffc020449c <do_exit+0x9a>
    if (flag)
ffffffffc02044d0:	020a1263          	bnez	s4,ffffffffc02044f4 <do_exit+0xf2>
    schedule();
ffffffffc02044d4:	3ed000ef          	jal	ra,ffffffffc02050c0 <schedule>
    panic("do_exit will not return!! %d.\n", current->pid);
ffffffffc02044d8:	601c                	ld	a5,0(s0)
ffffffffc02044da:	00003617          	auipc	a2,0x3
ffffffffc02044de:	b5660613          	addi	a2,a2,-1194 # ffffffffc0207030 <default_pmm_manager+0xaf0>
ffffffffc02044e2:	24a00593          	li	a1,586
ffffffffc02044e6:	43d4                	lw	a3,4(a5)
ffffffffc02044e8:	00003517          	auipc	a0,0x3
ffffffffc02044ec:	ac850513          	addi	a0,a0,-1336 # ffffffffc0206fb0 <default_pmm_manager+0xa70>
ffffffffc02044f0:	f9ffb0ef          	jal	ra,ffffffffc020048e <__panic>
        intr_enable();
ffffffffc02044f4:	cbafc0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02044f8:	bff1                	j	ffffffffc02044d4 <do_exit+0xd2>
        panic("idleproc exit.\n");
ffffffffc02044fa:	00003617          	auipc	a2,0x3
ffffffffc02044fe:	b1660613          	addi	a2,a2,-1258 # ffffffffc0207010 <default_pmm_manager+0xad0>
ffffffffc0204502:	21600593          	li	a1,534
ffffffffc0204506:	00003517          	auipc	a0,0x3
ffffffffc020450a:	aaa50513          	addi	a0,a0,-1366 # ffffffffc0206fb0 <default_pmm_manager+0xa70>
ffffffffc020450e:	f81fb0ef          	jal	ra,ffffffffc020048e <__panic>
            exit_mmap(mm);
ffffffffc0204512:	854e                	mv	a0,s3
ffffffffc0204514:	c94ff0ef          	jal	ra,ffffffffc02039a8 <exit_mmap>
            put_pgdir(mm);
ffffffffc0204518:	854e                	mv	a0,s3
ffffffffc020451a:	9c3ff0ef          	jal	ra,ffffffffc0203edc <put_pgdir>
            mm_destroy(mm);
ffffffffc020451e:	854e                	mv	a0,s3
ffffffffc0204520:	aecff0ef          	jal	ra,ffffffffc020380c <mm_destroy>
ffffffffc0204524:	bf35                	j	ffffffffc0204460 <do_exit+0x5e>
        panic("initproc exit.\n");
ffffffffc0204526:	00003617          	auipc	a2,0x3
ffffffffc020452a:	afa60613          	addi	a2,a2,-1286 # ffffffffc0207020 <default_pmm_manager+0xae0>
ffffffffc020452e:	21a00593          	li	a1,538
ffffffffc0204532:	00003517          	auipc	a0,0x3
ffffffffc0204536:	a7e50513          	addi	a0,a0,-1410 # ffffffffc0206fb0 <default_pmm_manager+0xa70>
ffffffffc020453a:	f55fb0ef          	jal	ra,ffffffffc020048e <__panic>
        intr_disable();
ffffffffc020453e:	c76fc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0204542:	4a05                	li	s4,1
ffffffffc0204544:	bf1d                	j	ffffffffc020447a <do_exit+0x78>
            wakeup_proc(proc);
ffffffffc0204546:	2fb000ef          	jal	ra,ffffffffc0205040 <wakeup_proc>
ffffffffc020454a:	b789                	j	ffffffffc020448c <do_exit+0x8a>

ffffffffc020454c <do_wait.part.0>:
int do_wait(int pid, int *code_store)
ffffffffc020454c:	715d                	addi	sp,sp,-80
ffffffffc020454e:	f84a                	sd	s2,48(sp)
ffffffffc0204550:	f44e                	sd	s3,40(sp)
        current->wait_state = WT_CHILD;
ffffffffc0204552:	80000937          	lui	s2,0x80000
    if (0 < pid && pid < MAX_PID)
ffffffffc0204556:	6989                	lui	s3,0x2
int do_wait(int pid, int *code_store)
ffffffffc0204558:	fc26                	sd	s1,56(sp)
ffffffffc020455a:	f052                	sd	s4,32(sp)
ffffffffc020455c:	ec56                	sd	s5,24(sp)
ffffffffc020455e:	e85a                	sd	s6,16(sp)
ffffffffc0204560:	e45e                	sd	s7,8(sp)
ffffffffc0204562:	e486                	sd	ra,72(sp)
ffffffffc0204564:	e0a2                	sd	s0,64(sp)
ffffffffc0204566:	84aa                	mv	s1,a0
ffffffffc0204568:	8a2e                	mv	s4,a1
        proc = current->cptr;
ffffffffc020456a:	000a6b97          	auipc	s7,0xa6
ffffffffc020456e:	2a6b8b93          	addi	s7,s7,678 # ffffffffc02aa810 <current>
    if (0 < pid && pid < MAX_PID)
ffffffffc0204572:	00050b1b          	sext.w	s6,a0
ffffffffc0204576:	fff50a9b          	addiw	s5,a0,-1
ffffffffc020457a:	19f9                	addi	s3,s3,-2
        current->wait_state = WT_CHILD;
ffffffffc020457c:	0905                	addi	s2,s2,1
    if (pid != 0)
ffffffffc020457e:	ccbd                	beqz	s1,ffffffffc02045fc <do_wait.part.0+0xb0>
    if (0 < pid && pid < MAX_PID)
ffffffffc0204580:	0359e863          	bltu	s3,s5,ffffffffc02045b0 <do_wait.part.0+0x64>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204584:	45a9                	li	a1,10
ffffffffc0204586:	855a                	mv	a0,s6
ffffffffc0204588:	4a5000ef          	jal	ra,ffffffffc020522c <hash32>
ffffffffc020458c:	02051793          	slli	a5,a0,0x20
ffffffffc0204590:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0204594:	000a2797          	auipc	a5,0xa2
ffffffffc0204598:	20478793          	addi	a5,a5,516 # ffffffffc02a6798 <hash_list>
ffffffffc020459c:	953e                	add	a0,a0,a5
ffffffffc020459e:	842a                	mv	s0,a0
        while ((le = list_next(le)) != list)
ffffffffc02045a0:	a029                	j	ffffffffc02045aa <do_wait.part.0+0x5e>
            if (proc->pid == pid)
ffffffffc02045a2:	f2c42783          	lw	a5,-212(s0)
ffffffffc02045a6:	02978163          	beq	a5,s1,ffffffffc02045c8 <do_wait.part.0+0x7c>
ffffffffc02045aa:	6400                	ld	s0,8(s0)
        while ((le = list_next(le)) != list)
ffffffffc02045ac:	fe851be3          	bne	a0,s0,ffffffffc02045a2 <do_wait.part.0+0x56>
    return -E_BAD_PROC;
ffffffffc02045b0:	5579                	li	a0,-2
}
ffffffffc02045b2:	60a6                	ld	ra,72(sp)
ffffffffc02045b4:	6406                	ld	s0,64(sp)
ffffffffc02045b6:	74e2                	ld	s1,56(sp)
ffffffffc02045b8:	7942                	ld	s2,48(sp)
ffffffffc02045ba:	79a2                	ld	s3,40(sp)
ffffffffc02045bc:	7a02                	ld	s4,32(sp)
ffffffffc02045be:	6ae2                	ld	s5,24(sp)
ffffffffc02045c0:	6b42                	ld	s6,16(sp)
ffffffffc02045c2:	6ba2                	ld	s7,8(sp)
ffffffffc02045c4:	6161                	addi	sp,sp,80
ffffffffc02045c6:	8082                	ret
        if (proc != NULL && proc->parent == current)
ffffffffc02045c8:	000bb683          	ld	a3,0(s7)
ffffffffc02045cc:	f4843783          	ld	a5,-184(s0)
ffffffffc02045d0:	fed790e3          	bne	a5,a3,ffffffffc02045b0 <do_wait.part.0+0x64>
            if (proc->state == PROC_ZOMBIE)
ffffffffc02045d4:	f2842703          	lw	a4,-216(s0)
ffffffffc02045d8:	478d                	li	a5,3
ffffffffc02045da:	0ef70b63          	beq	a4,a5,ffffffffc02046d0 <do_wait.part.0+0x184>
        current->state = PROC_SLEEPING;
ffffffffc02045de:	4785                	li	a5,1
ffffffffc02045e0:	c29c                	sw	a5,0(a3)
        current->wait_state = WT_CHILD;
ffffffffc02045e2:	0f26a623          	sw	s2,236(a3)
        schedule();
ffffffffc02045e6:	2db000ef          	jal	ra,ffffffffc02050c0 <schedule>
        if (current->flags & PF_EXITING)
ffffffffc02045ea:	000bb783          	ld	a5,0(s7)
ffffffffc02045ee:	0b07a783          	lw	a5,176(a5)
ffffffffc02045f2:	8b85                	andi	a5,a5,1
ffffffffc02045f4:	d7c9                	beqz	a5,ffffffffc020457e <do_wait.part.0+0x32>
            do_exit(-E_KILLED);
ffffffffc02045f6:	555d                	li	a0,-9
ffffffffc02045f8:	e0bff0ef          	jal	ra,ffffffffc0204402 <do_exit>
        proc = current->cptr;
ffffffffc02045fc:	000bb683          	ld	a3,0(s7)
ffffffffc0204600:	7ae0                	ld	s0,240(a3)
        for (; proc != NULL; proc = proc->optr)
ffffffffc0204602:	d45d                	beqz	s0,ffffffffc02045b0 <do_wait.part.0+0x64>
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204604:	470d                	li	a4,3
ffffffffc0204606:	a021                	j	ffffffffc020460e <do_wait.part.0+0xc2>
        for (; proc != NULL; proc = proc->optr)
ffffffffc0204608:	10043403          	ld	s0,256(s0)
ffffffffc020460c:	d869                	beqz	s0,ffffffffc02045de <do_wait.part.0+0x92>
            if (proc->state == PROC_ZOMBIE)
ffffffffc020460e:	401c                	lw	a5,0(s0)
ffffffffc0204610:	fee79ce3          	bne	a5,a4,ffffffffc0204608 <do_wait.part.0+0xbc>
    if (proc == idleproc || proc == initproc)
ffffffffc0204614:	000a6797          	auipc	a5,0xa6
ffffffffc0204618:	2047b783          	ld	a5,516(a5) # ffffffffc02aa818 <idleproc>
ffffffffc020461c:	0c878963          	beq	a5,s0,ffffffffc02046ee <do_wait.part.0+0x1a2>
ffffffffc0204620:	000a6797          	auipc	a5,0xa6
ffffffffc0204624:	2007b783          	ld	a5,512(a5) # ffffffffc02aa820 <initproc>
ffffffffc0204628:	0cf40363          	beq	s0,a5,ffffffffc02046ee <do_wait.part.0+0x1a2>
    if (code_store != NULL)
ffffffffc020462c:	000a0663          	beqz	s4,ffffffffc0204638 <do_wait.part.0+0xec>
        *code_store = proc->exit_code;
ffffffffc0204630:	0e842783          	lw	a5,232(s0)
ffffffffc0204634:	00fa2023          	sw	a5,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8bb8>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204638:	100027f3          	csrr	a5,sstatus
ffffffffc020463c:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc020463e:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204640:	e7c1                	bnez	a5,ffffffffc02046c8 <do_wait.part.0+0x17c>
    __list_del(listelm->prev, listelm->next);
ffffffffc0204642:	6c70                	ld	a2,216(s0)
ffffffffc0204644:	7074                	ld	a3,224(s0)
    if (proc->optr != NULL)
ffffffffc0204646:	10043703          	ld	a4,256(s0)
        proc->optr->yptr = proc->yptr;
ffffffffc020464a:	7c7c                	ld	a5,248(s0)
    prev->next = next;
ffffffffc020464c:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc020464e:	e290                	sd	a2,0(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc0204650:	6470                	ld	a2,200(s0)
ffffffffc0204652:	6874                	ld	a3,208(s0)
    prev->next = next;
ffffffffc0204654:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc0204656:	e290                	sd	a2,0(a3)
    if (proc->optr != NULL)
ffffffffc0204658:	c319                	beqz	a4,ffffffffc020465e <do_wait.part.0+0x112>
        proc->optr->yptr = proc->yptr;
ffffffffc020465a:	ff7c                	sd	a5,248(a4)
    if (proc->yptr != NULL)
ffffffffc020465c:	7c7c                	ld	a5,248(s0)
ffffffffc020465e:	c3b5                	beqz	a5,ffffffffc02046c2 <do_wait.part.0+0x176>
        proc->yptr->optr = proc->optr;
ffffffffc0204660:	10e7b023          	sd	a4,256(a5)
    nr_process--;
ffffffffc0204664:	000a6717          	auipc	a4,0xa6
ffffffffc0204668:	1c470713          	addi	a4,a4,452 # ffffffffc02aa828 <nr_process>
ffffffffc020466c:	431c                	lw	a5,0(a4)
ffffffffc020466e:	37fd                	addiw	a5,a5,-1
ffffffffc0204670:	c31c                	sw	a5,0(a4)
    if (flag)
ffffffffc0204672:	e5a9                	bnez	a1,ffffffffc02046bc <do_wait.part.0+0x170>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc0204674:	6814                	ld	a3,16(s0)
ffffffffc0204676:	c02007b7          	lui	a5,0xc0200
ffffffffc020467a:	04f6ee63          	bltu	a3,a5,ffffffffc02046d6 <do_wait.part.0+0x18a>
ffffffffc020467e:	000a6797          	auipc	a5,0xa6
ffffffffc0204682:	18a7b783          	ld	a5,394(a5) # ffffffffc02aa808 <va_pa_offset>
ffffffffc0204686:	8e9d                	sub	a3,a3,a5
    if (PPN(pa) >= npage)
ffffffffc0204688:	82b1                	srli	a3,a3,0xc
ffffffffc020468a:	000a6797          	auipc	a5,0xa6
ffffffffc020468e:	1667b783          	ld	a5,358(a5) # ffffffffc02aa7f0 <npage>
ffffffffc0204692:	06f6fa63          	bgeu	a3,a5,ffffffffc0204706 <do_wait.part.0+0x1ba>
    return &pages[PPN(pa) - nbase];
ffffffffc0204696:	00003517          	auipc	a0,0x3
ffffffffc020469a:	1d253503          	ld	a0,466(a0) # ffffffffc0207868 <nbase>
ffffffffc020469e:	8e89                	sub	a3,a3,a0
ffffffffc02046a0:	069a                	slli	a3,a3,0x6
ffffffffc02046a2:	000a6517          	auipc	a0,0xa6
ffffffffc02046a6:	15653503          	ld	a0,342(a0) # ffffffffc02aa7f8 <pages>
ffffffffc02046aa:	9536                	add	a0,a0,a3
ffffffffc02046ac:	4589                	li	a1,2
ffffffffc02046ae:	839fd0ef          	jal	ra,ffffffffc0201ee6 <free_pages>
    kfree(proc);
ffffffffc02046b2:	8522                	mv	a0,s0
ffffffffc02046b4:	ec6fd0ef          	jal	ra,ffffffffc0201d7a <kfree>
    return 0;
ffffffffc02046b8:	4501                	li	a0,0
ffffffffc02046ba:	bde5                	j	ffffffffc02045b2 <do_wait.part.0+0x66>
        intr_enable();
ffffffffc02046bc:	af2fc0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02046c0:	bf55                	j	ffffffffc0204674 <do_wait.part.0+0x128>
        proc->parent->cptr = proc->optr;
ffffffffc02046c2:	701c                	ld	a5,32(s0)
ffffffffc02046c4:	fbf8                	sd	a4,240(a5)
ffffffffc02046c6:	bf79                	j	ffffffffc0204664 <do_wait.part.0+0x118>
        intr_disable();
ffffffffc02046c8:	aecfc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc02046cc:	4585                	li	a1,1
ffffffffc02046ce:	bf95                	j	ffffffffc0204642 <do_wait.part.0+0xf6>
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc02046d0:	f2840413          	addi	s0,s0,-216
ffffffffc02046d4:	b781                	j	ffffffffc0204614 <do_wait.part.0+0xc8>
    return pa2page(PADDR(kva));
ffffffffc02046d6:	00002617          	auipc	a2,0x2
ffffffffc02046da:	f4a60613          	addi	a2,a2,-182 # ffffffffc0206620 <default_pmm_manager+0xe0>
ffffffffc02046de:	07700593          	li	a1,119
ffffffffc02046e2:	00002517          	auipc	a0,0x2
ffffffffc02046e6:	ebe50513          	addi	a0,a0,-322 # ffffffffc02065a0 <default_pmm_manager+0x60>
ffffffffc02046ea:	da5fb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("wait idleproc or initproc.\n");
ffffffffc02046ee:	00003617          	auipc	a2,0x3
ffffffffc02046f2:	96260613          	addi	a2,a2,-1694 # ffffffffc0207050 <default_pmm_manager+0xb10>
ffffffffc02046f6:	37000593          	li	a1,880
ffffffffc02046fa:	00003517          	auipc	a0,0x3
ffffffffc02046fe:	8b650513          	addi	a0,a0,-1866 # ffffffffc0206fb0 <default_pmm_manager+0xa70>
ffffffffc0204702:	d8dfb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0204706:	00002617          	auipc	a2,0x2
ffffffffc020470a:	f4260613          	addi	a2,a2,-190 # ffffffffc0206648 <default_pmm_manager+0x108>
ffffffffc020470e:	06900593          	li	a1,105
ffffffffc0204712:	00002517          	auipc	a0,0x2
ffffffffc0204716:	e8e50513          	addi	a0,a0,-370 # ffffffffc02065a0 <default_pmm_manager+0x60>
ffffffffc020471a:	d75fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020471e <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg)
{
ffffffffc020471e:	1141                	addi	sp,sp,-16
ffffffffc0204720:	e406                	sd	ra,8(sp)
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc0204722:	805fd0ef          	jal	ra,ffffffffc0201f26 <nr_free_pages>
    size_t kernel_allocated_store = kallocated();
ffffffffc0204726:	da0fd0ef          	jal	ra,ffffffffc0201cc6 <kallocated>

    int pid = kernel_thread(user_main, NULL, 0);
ffffffffc020472a:	4601                	li	a2,0
ffffffffc020472c:	4581                	li	a1,0
ffffffffc020472e:	fffff517          	auipc	a0,0xfffff
ffffffffc0204732:	73050513          	addi	a0,a0,1840 # ffffffffc0203e5e <user_main>
ffffffffc0204736:	c7dff0ef          	jal	ra,ffffffffc02043b2 <kernel_thread>
    if (pid <= 0)
ffffffffc020473a:	00a04563          	bgtz	a0,ffffffffc0204744 <init_main+0x26>
ffffffffc020473e:	a071                	j	ffffffffc02047ca <init_main+0xac>
        panic("create user_main failed.\n");
    }

    while (do_wait(0, NULL) == 0)
    {
        schedule();
ffffffffc0204740:	181000ef          	jal	ra,ffffffffc02050c0 <schedule>
    if (code_store != NULL)
ffffffffc0204744:	4581                	li	a1,0
ffffffffc0204746:	4501                	li	a0,0
ffffffffc0204748:	e05ff0ef          	jal	ra,ffffffffc020454c <do_wait.part.0>
    while (do_wait(0, NULL) == 0)
ffffffffc020474c:	d975                	beqz	a0,ffffffffc0204740 <init_main+0x22>
    }

    cprintf("all user-mode processes have quit.\n");
ffffffffc020474e:	00003517          	auipc	a0,0x3
ffffffffc0204752:	94250513          	addi	a0,a0,-1726 # ffffffffc0207090 <default_pmm_manager+0xb50>
ffffffffc0204756:	a3ffb0ef          	jal	ra,ffffffffc0200194 <cprintf>
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc020475a:	000a6797          	auipc	a5,0xa6
ffffffffc020475e:	0c67b783          	ld	a5,198(a5) # ffffffffc02aa820 <initproc>
ffffffffc0204762:	7bf8                	ld	a4,240(a5)
ffffffffc0204764:	e339                	bnez	a4,ffffffffc02047aa <init_main+0x8c>
ffffffffc0204766:	7ff8                	ld	a4,248(a5)
ffffffffc0204768:	e329                	bnez	a4,ffffffffc02047aa <init_main+0x8c>
ffffffffc020476a:	1007b703          	ld	a4,256(a5)
ffffffffc020476e:	ef15                	bnez	a4,ffffffffc02047aa <init_main+0x8c>
    assert(nr_process == 2);
ffffffffc0204770:	000a6697          	auipc	a3,0xa6
ffffffffc0204774:	0b86a683          	lw	a3,184(a3) # ffffffffc02aa828 <nr_process>
ffffffffc0204778:	4709                	li	a4,2
ffffffffc020477a:	0ae69463          	bne	a3,a4,ffffffffc0204822 <init_main+0x104>
    return listelm->next;
ffffffffc020477e:	000a6697          	auipc	a3,0xa6
ffffffffc0204782:	01a68693          	addi	a3,a3,26 # ffffffffc02aa798 <proc_list>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc0204786:	6698                	ld	a4,8(a3)
ffffffffc0204788:	0c878793          	addi	a5,a5,200
ffffffffc020478c:	06f71b63          	bne	a4,a5,ffffffffc0204802 <init_main+0xe4>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc0204790:	629c                	ld	a5,0(a3)
ffffffffc0204792:	04f71863          	bne	a4,a5,ffffffffc02047e2 <init_main+0xc4>

    cprintf("init check memory pass.\n");
ffffffffc0204796:	00003517          	auipc	a0,0x3
ffffffffc020479a:	9e250513          	addi	a0,a0,-1566 # ffffffffc0207178 <default_pmm_manager+0xc38>
ffffffffc020479e:	9f7fb0ef          	jal	ra,ffffffffc0200194 <cprintf>
    return 0;
}
ffffffffc02047a2:	60a2                	ld	ra,8(sp)
ffffffffc02047a4:	4501                	li	a0,0
ffffffffc02047a6:	0141                	addi	sp,sp,16
ffffffffc02047a8:	8082                	ret
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc02047aa:	00003697          	auipc	a3,0x3
ffffffffc02047ae:	90e68693          	addi	a3,a3,-1778 # ffffffffc02070b8 <default_pmm_manager+0xb78>
ffffffffc02047b2:	00002617          	auipc	a2,0x2
ffffffffc02047b6:	9de60613          	addi	a2,a2,-1570 # ffffffffc0206190 <commands+0x828>
ffffffffc02047ba:	3de00593          	li	a1,990
ffffffffc02047be:	00002517          	auipc	a0,0x2
ffffffffc02047c2:	7f250513          	addi	a0,a0,2034 # ffffffffc0206fb0 <default_pmm_manager+0xa70>
ffffffffc02047c6:	cc9fb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("create user_main failed.\n");
ffffffffc02047ca:	00003617          	auipc	a2,0x3
ffffffffc02047ce:	8a660613          	addi	a2,a2,-1882 # ffffffffc0207070 <default_pmm_manager+0xb30>
ffffffffc02047d2:	3d500593          	li	a1,981
ffffffffc02047d6:	00002517          	auipc	a0,0x2
ffffffffc02047da:	7da50513          	addi	a0,a0,2010 # ffffffffc0206fb0 <default_pmm_manager+0xa70>
ffffffffc02047de:	cb1fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc02047e2:	00003697          	auipc	a3,0x3
ffffffffc02047e6:	96668693          	addi	a3,a3,-1690 # ffffffffc0207148 <default_pmm_manager+0xc08>
ffffffffc02047ea:	00002617          	auipc	a2,0x2
ffffffffc02047ee:	9a660613          	addi	a2,a2,-1626 # ffffffffc0206190 <commands+0x828>
ffffffffc02047f2:	3e100593          	li	a1,993
ffffffffc02047f6:	00002517          	auipc	a0,0x2
ffffffffc02047fa:	7ba50513          	addi	a0,a0,1978 # ffffffffc0206fb0 <default_pmm_manager+0xa70>
ffffffffc02047fe:	c91fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc0204802:	00003697          	auipc	a3,0x3
ffffffffc0204806:	91668693          	addi	a3,a3,-1770 # ffffffffc0207118 <default_pmm_manager+0xbd8>
ffffffffc020480a:	00002617          	auipc	a2,0x2
ffffffffc020480e:	98660613          	addi	a2,a2,-1658 # ffffffffc0206190 <commands+0x828>
ffffffffc0204812:	3e000593          	li	a1,992
ffffffffc0204816:	00002517          	auipc	a0,0x2
ffffffffc020481a:	79a50513          	addi	a0,a0,1946 # ffffffffc0206fb0 <default_pmm_manager+0xa70>
ffffffffc020481e:	c71fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_process == 2);
ffffffffc0204822:	00003697          	auipc	a3,0x3
ffffffffc0204826:	8e668693          	addi	a3,a3,-1818 # ffffffffc0207108 <default_pmm_manager+0xbc8>
ffffffffc020482a:	00002617          	auipc	a2,0x2
ffffffffc020482e:	96660613          	addi	a2,a2,-1690 # ffffffffc0206190 <commands+0x828>
ffffffffc0204832:	3df00593          	li	a1,991
ffffffffc0204836:	00002517          	auipc	a0,0x2
ffffffffc020483a:	77a50513          	addi	a0,a0,1914 # ffffffffc0206fb0 <default_pmm_manager+0xa70>
ffffffffc020483e:	c51fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0204842 <do_execve>:
{
ffffffffc0204842:	7171                	addi	sp,sp,-176
ffffffffc0204844:	e4ee                	sd	s11,72(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204846:	000a6d97          	auipc	s11,0xa6
ffffffffc020484a:	fcad8d93          	addi	s11,s11,-54 # ffffffffc02aa810 <current>
ffffffffc020484e:	000db783          	ld	a5,0(s11)
{
ffffffffc0204852:	e94a                	sd	s2,144(sp)
ffffffffc0204854:	f122                	sd	s0,160(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204856:	0287b903          	ld	s2,40(a5)
{
ffffffffc020485a:	ed26                	sd	s1,152(sp)
ffffffffc020485c:	f8da                	sd	s6,112(sp)
ffffffffc020485e:	84aa                	mv	s1,a0
ffffffffc0204860:	8b32                	mv	s6,a2
ffffffffc0204862:	842e                	mv	s0,a1
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc0204864:	862e                	mv	a2,a1
ffffffffc0204866:	4681                	li	a3,0
ffffffffc0204868:	85aa                	mv	a1,a0
ffffffffc020486a:	854a                	mv	a0,s2
{
ffffffffc020486c:	f506                	sd	ra,168(sp)
ffffffffc020486e:	e54e                	sd	s3,136(sp)
ffffffffc0204870:	e152                	sd	s4,128(sp)
ffffffffc0204872:	fcd6                	sd	s5,120(sp)
ffffffffc0204874:	f4de                	sd	s7,104(sp)
ffffffffc0204876:	f0e2                	sd	s8,96(sp)
ffffffffc0204878:	ece6                	sd	s9,88(sp)
ffffffffc020487a:	e8ea                	sd	s10,80(sp)
ffffffffc020487c:	f05a                	sd	s6,32(sp)
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc020487e:	cc4ff0ef          	jal	ra,ffffffffc0203d42 <user_mem_check>
ffffffffc0204882:	40050c63          	beqz	a0,ffffffffc0204c9a <do_execve+0x458>
    memset(local_name, 0, sizeof(local_name));
ffffffffc0204886:	4641                	li	a2,16
ffffffffc0204888:	4581                	li	a1,0
ffffffffc020488a:	1808                	addi	a0,sp,48
ffffffffc020488c:	647000ef          	jal	ra,ffffffffc02056d2 <memset>
    memcpy(local_name, name, len);
ffffffffc0204890:	47bd                	li	a5,15
ffffffffc0204892:	8622                	mv	a2,s0
ffffffffc0204894:	1e87e463          	bltu	a5,s0,ffffffffc0204a7c <do_execve+0x23a>
ffffffffc0204898:	85a6                	mv	a1,s1
ffffffffc020489a:	1808                	addi	a0,sp,48
ffffffffc020489c:	649000ef          	jal	ra,ffffffffc02056e4 <memcpy>
    if (mm != NULL)
ffffffffc02048a0:	1e090563          	beqz	s2,ffffffffc0204a8a <do_execve+0x248>
        cputs("mm != NULL");
ffffffffc02048a4:	00002517          	auipc	a0,0x2
ffffffffc02048a8:	4cc50513          	addi	a0,a0,1228 # ffffffffc0206d70 <default_pmm_manager+0x830>
ffffffffc02048ac:	921fb0ef          	jal	ra,ffffffffc02001cc <cputs>
ffffffffc02048b0:	000a6797          	auipc	a5,0xa6
ffffffffc02048b4:	f307b783          	ld	a5,-208(a5) # ffffffffc02aa7e0 <boot_pgdir_pa>
ffffffffc02048b8:	577d                	li	a4,-1
ffffffffc02048ba:	177e                	slli	a4,a4,0x3f
ffffffffc02048bc:	83b1                	srli	a5,a5,0xc
ffffffffc02048be:	8fd9                	or	a5,a5,a4
ffffffffc02048c0:	18079073          	csrw	satp,a5
ffffffffc02048c4:	03092783          	lw	a5,48(s2) # ffffffff80000030 <_binary_obj___user_exit_out_size+0xffffffff7fff4f00>
ffffffffc02048c8:	fff7871b          	addiw	a4,a5,-1
ffffffffc02048cc:	02e92823          	sw	a4,48(s2)
        if (mm_count_dec(mm) == 0)
ffffffffc02048d0:	2c070663          	beqz	a4,ffffffffc0204b9c <do_execve+0x35a>
        current->mm = NULL;
ffffffffc02048d4:	000db783          	ld	a5,0(s11)
ffffffffc02048d8:	0207b423          	sd	zero,40(a5)
    if ((mm = mm_create()) == NULL)
ffffffffc02048dc:	df1fe0ef          	jal	ra,ffffffffc02036cc <mm_create>
ffffffffc02048e0:	842a                	mv	s0,a0
ffffffffc02048e2:	1c050f63          	beqz	a0,ffffffffc0204ac0 <do_execve+0x27e>
    if ((page = alloc_page()) == NULL)
ffffffffc02048e6:	4505                	li	a0,1
ffffffffc02048e8:	dc0fd0ef          	jal	ra,ffffffffc0201ea8 <alloc_pages>
ffffffffc02048ec:	3a050b63          	beqz	a0,ffffffffc0204ca2 <do_execve+0x460>
    return page - pages + nbase;
ffffffffc02048f0:	000a6c97          	auipc	s9,0xa6
ffffffffc02048f4:	f08c8c93          	addi	s9,s9,-248 # ffffffffc02aa7f8 <pages>
ffffffffc02048f8:	000cb683          	ld	a3,0(s9)
    return KADDR(page2pa(page));
ffffffffc02048fc:	000a6c17          	auipc	s8,0xa6
ffffffffc0204900:	ef4c0c13          	addi	s8,s8,-268 # ffffffffc02aa7f0 <npage>
    return page - pages + nbase;
ffffffffc0204904:	00003717          	auipc	a4,0x3
ffffffffc0204908:	f6473703          	ld	a4,-156(a4) # ffffffffc0207868 <nbase>
ffffffffc020490c:	40d506b3          	sub	a3,a0,a3
ffffffffc0204910:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0204912:	5a7d                	li	s4,-1
ffffffffc0204914:	000c3783          	ld	a5,0(s8)
    return page - pages + nbase;
ffffffffc0204918:	96ba                	add	a3,a3,a4
ffffffffc020491a:	e83a                	sd	a4,16(sp)
    return KADDR(page2pa(page));
ffffffffc020491c:	00ca5713          	srli	a4,s4,0xc
ffffffffc0204920:	ec3a                	sd	a4,24(sp)
ffffffffc0204922:	8f75                	and	a4,a4,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0204924:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204926:	38f77263          	bgeu	a4,a5,ffffffffc0204caa <do_execve+0x468>
ffffffffc020492a:	000a6a97          	auipc	s5,0xa6
ffffffffc020492e:	edea8a93          	addi	s5,s5,-290 # ffffffffc02aa808 <va_pa_offset>
ffffffffc0204932:	000ab483          	ld	s1,0(s5)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc0204936:	6605                	lui	a2,0x1
ffffffffc0204938:	000a6597          	auipc	a1,0xa6
ffffffffc020493c:	eb05b583          	ld	a1,-336(a1) # ffffffffc02aa7e8 <boot_pgdir_va>
ffffffffc0204940:	94b6                	add	s1,s1,a3
ffffffffc0204942:	8526                	mv	a0,s1
ffffffffc0204944:	5a1000ef          	jal	ra,ffffffffc02056e4 <memcpy>
    if (elf->e_magic != ELF_MAGIC)
ffffffffc0204948:	7782                	ld	a5,32(sp)
ffffffffc020494a:	4398                	lw	a4,0(a5)
ffffffffc020494c:	464c47b7          	lui	a5,0x464c4
    mm->pgdir = pgdir;
ffffffffc0204950:	ec04                	sd	s1,24(s0)
    if (elf->e_magic != ELF_MAGIC)
ffffffffc0204952:	57f78793          	addi	a5,a5,1407 # 464c457f <_binary_obj___user_exit_out_size+0x464b944f>
ffffffffc0204956:	14f71b63          	bne	a4,a5,ffffffffc0204aac <do_execve+0x26a>
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc020495a:	7682                	ld	a3,32(sp)
    struct Page *page=NULL;
ffffffffc020495c:	4b81                	li	s7,0
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc020495e:	0386d703          	lhu	a4,56(a3)
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc0204962:	0206b903          	ld	s2,32(a3)
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204966:	00371793          	slli	a5,a4,0x3
ffffffffc020496a:	8f99                	sub	a5,a5,a4
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc020496c:	9936                	add	s2,s2,a3
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc020496e:	078e                	slli	a5,a5,0x3
ffffffffc0204970:	97ca                	add	a5,a5,s2
ffffffffc0204972:	f43e                	sd	a5,40(sp)
    for (; ph < ph_end; ph++)
ffffffffc0204974:	00f97c63          	bgeu	s2,a5,ffffffffc020498c <do_execve+0x14a>
        if (ph->p_type != ELF_PT_LOAD)
ffffffffc0204978:	00092783          	lw	a5,0(s2)
ffffffffc020497c:	4705                	li	a4,1
ffffffffc020497e:	14e78363          	beq	a5,a4,ffffffffc0204ac4 <do_execve+0x282>
    for (; ph < ph_end; ph++)
ffffffffc0204982:	77a2                	ld	a5,40(sp)
ffffffffc0204984:	03890913          	addi	s2,s2,56
ffffffffc0204988:	fef968e3          	bltu	s2,a5,ffffffffc0204978 <do_execve+0x136>
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0)
ffffffffc020498c:	4701                	li	a4,0
ffffffffc020498e:	46ad                	li	a3,11
ffffffffc0204990:	00100637          	lui	a2,0x100
ffffffffc0204994:	7ff005b7          	lui	a1,0x7ff00
ffffffffc0204998:	8522                	mv	a0,s0
ffffffffc020499a:	ec5fe0ef          	jal	ra,ffffffffc020385e <mm_map>
ffffffffc020499e:	89aa                	mv	s3,a0
ffffffffc02049a0:	1e051463          	bnez	a0,ffffffffc0204b88 <do_execve+0x346>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc02049a4:	6c08                	ld	a0,24(s0)
ffffffffc02049a6:	467d                	li	a2,31
ffffffffc02049a8:	7ffff5b7          	lui	a1,0x7ffff
ffffffffc02049ac:	c3bfe0ef          	jal	ra,ffffffffc02035e6 <pgdir_alloc_page>
ffffffffc02049b0:	38050563          	beqz	a0,ffffffffc0204d3a <do_execve+0x4f8>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc02049b4:	6c08                	ld	a0,24(s0)
ffffffffc02049b6:	467d                	li	a2,31
ffffffffc02049b8:	7fffe5b7          	lui	a1,0x7fffe
ffffffffc02049bc:	c2bfe0ef          	jal	ra,ffffffffc02035e6 <pgdir_alloc_page>
ffffffffc02049c0:	34050d63          	beqz	a0,ffffffffc0204d1a <do_execve+0x4d8>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc02049c4:	6c08                	ld	a0,24(s0)
ffffffffc02049c6:	467d                	li	a2,31
ffffffffc02049c8:	7fffd5b7          	lui	a1,0x7fffd
ffffffffc02049cc:	c1bfe0ef          	jal	ra,ffffffffc02035e6 <pgdir_alloc_page>
ffffffffc02049d0:	32050563          	beqz	a0,ffffffffc0204cfa <do_execve+0x4b8>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc02049d4:	6c08                	ld	a0,24(s0)
ffffffffc02049d6:	467d                	li	a2,31
ffffffffc02049d8:	7fffc5b7          	lui	a1,0x7fffc
ffffffffc02049dc:	c0bfe0ef          	jal	ra,ffffffffc02035e6 <pgdir_alloc_page>
ffffffffc02049e0:	2e050d63          	beqz	a0,ffffffffc0204cda <do_execve+0x498>
    mm->mm_count += 1;
ffffffffc02049e4:	581c                	lw	a5,48(s0)
    current->mm = mm;
ffffffffc02049e6:	000db603          	ld	a2,0(s11)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc02049ea:	6c14                	ld	a3,24(s0)
ffffffffc02049ec:	2785                	addiw	a5,a5,1
ffffffffc02049ee:	d81c                	sw	a5,48(s0)
    current->mm = mm;
ffffffffc02049f0:	f600                	sd	s0,40(a2)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc02049f2:	c02007b7          	lui	a5,0xc0200
ffffffffc02049f6:	2cf6e663          	bltu	a3,a5,ffffffffc0204cc2 <do_execve+0x480>
ffffffffc02049fa:	000ab783          	ld	a5,0(s5)
ffffffffc02049fe:	577d                	li	a4,-1
ffffffffc0204a00:	177e                	slli	a4,a4,0x3f
ffffffffc0204a02:	8e9d                	sub	a3,a3,a5
ffffffffc0204a04:	00c6d793          	srli	a5,a3,0xc
ffffffffc0204a08:	f654                	sd	a3,168(a2)
ffffffffc0204a0a:	8fd9                	or	a5,a5,a4
ffffffffc0204a0c:	18079073          	csrw	satp,a5
    struct trapframe *tf = current->tf;
ffffffffc0204a10:	0a063903          	ld	s2,160(a2) # 1000a0 <_binary_obj___user_exit_out_size+0xf4f70>
    uintptr_t sstatus = read_csr(sstatus);
ffffffffc0204a14:	10002473          	csrr	s0,sstatus
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0204a18:	12000613          	li	a2,288
ffffffffc0204a1c:	4581                	li	a1,0
ffffffffc0204a1e:	854a                	mv	a0,s2
ffffffffc0204a20:	4b3000ef          	jal	ra,ffffffffc02056d2 <memset>
    tf->epc = elf->e_entry;
ffffffffc0204a24:	7782                	ld	a5,32(sp)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204a26:	000db483          	ld	s1,0(s11)
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc0204a2a:	edf47413          	andi	s0,s0,-289
    tf->epc = elf->e_entry;
ffffffffc0204a2e:	6f98                	ld	a4,24(a5)
    tf->gpr.sp = USTACKTOP;
ffffffffc0204a30:	4785                	li	a5,1
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204a32:	0b448493          	addi	s1,s1,180
    tf->gpr.sp = USTACKTOP;
ffffffffc0204a36:	07fe                	slli	a5,a5,0x1f
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc0204a38:	02046413          	ori	s0,s0,32
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204a3c:	4641                	li	a2,16
ffffffffc0204a3e:	4581                	li	a1,0
    tf->gpr.sp = USTACKTOP;
ffffffffc0204a40:	00f93823          	sd	a5,16(s2)
    tf->epc = elf->e_entry;
ffffffffc0204a44:	10e93423          	sd	a4,264(s2)
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc0204a48:	10893023          	sd	s0,256(s2)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204a4c:	8526                	mv	a0,s1
ffffffffc0204a4e:	485000ef          	jal	ra,ffffffffc02056d2 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204a52:	463d                	li	a2,15
ffffffffc0204a54:	180c                	addi	a1,sp,48
ffffffffc0204a56:	8526                	mv	a0,s1
ffffffffc0204a58:	48d000ef          	jal	ra,ffffffffc02056e4 <memcpy>
}
ffffffffc0204a5c:	70aa                	ld	ra,168(sp)
ffffffffc0204a5e:	740a                	ld	s0,160(sp)
ffffffffc0204a60:	64ea                	ld	s1,152(sp)
ffffffffc0204a62:	694a                	ld	s2,144(sp)
ffffffffc0204a64:	6a0a                	ld	s4,128(sp)
ffffffffc0204a66:	7ae6                	ld	s5,120(sp)
ffffffffc0204a68:	7b46                	ld	s6,112(sp)
ffffffffc0204a6a:	7ba6                	ld	s7,104(sp)
ffffffffc0204a6c:	7c06                	ld	s8,96(sp)
ffffffffc0204a6e:	6ce6                	ld	s9,88(sp)
ffffffffc0204a70:	6d46                	ld	s10,80(sp)
ffffffffc0204a72:	6da6                	ld	s11,72(sp)
ffffffffc0204a74:	854e                	mv	a0,s3
ffffffffc0204a76:	69aa                	ld	s3,136(sp)
ffffffffc0204a78:	614d                	addi	sp,sp,176
ffffffffc0204a7a:	8082                	ret
    memcpy(local_name, name, len);
ffffffffc0204a7c:	463d                	li	a2,15
ffffffffc0204a7e:	85a6                	mv	a1,s1
ffffffffc0204a80:	1808                	addi	a0,sp,48
ffffffffc0204a82:	463000ef          	jal	ra,ffffffffc02056e4 <memcpy>
    if (mm != NULL)
ffffffffc0204a86:	e0091fe3          	bnez	s2,ffffffffc02048a4 <do_execve+0x62>
    if (current->mm != NULL)
ffffffffc0204a8a:	000db783          	ld	a5,0(s11)
ffffffffc0204a8e:	779c                	ld	a5,40(a5)
ffffffffc0204a90:	e40786e3          	beqz	a5,ffffffffc02048dc <do_execve+0x9a>
        panic("load_icode: current->mm must be empty.\n");
ffffffffc0204a94:	00002617          	auipc	a2,0x2
ffffffffc0204a98:	70460613          	addi	a2,a2,1796 # ffffffffc0207198 <default_pmm_manager+0xc58>
ffffffffc0204a9c:	25600593          	li	a1,598
ffffffffc0204aa0:	00002517          	auipc	a0,0x2
ffffffffc0204aa4:	51050513          	addi	a0,a0,1296 # ffffffffc0206fb0 <default_pmm_manager+0xa70>
ffffffffc0204aa8:	9e7fb0ef          	jal	ra,ffffffffc020048e <__panic>
    put_pgdir(mm);
ffffffffc0204aac:	8522                	mv	a0,s0
ffffffffc0204aae:	c2eff0ef          	jal	ra,ffffffffc0203edc <put_pgdir>
    mm_destroy(mm);
ffffffffc0204ab2:	8522                	mv	a0,s0
ffffffffc0204ab4:	d59fe0ef          	jal	ra,ffffffffc020380c <mm_destroy>
        ret = -E_INVAL_ELF;
ffffffffc0204ab8:	59e1                	li	s3,-8
    do_exit(ret);
ffffffffc0204aba:	854e                	mv	a0,s3
ffffffffc0204abc:	947ff0ef          	jal	ra,ffffffffc0204402 <do_exit>
    int ret = -E_NO_MEM;
ffffffffc0204ac0:	59f1                	li	s3,-4
ffffffffc0204ac2:	bfe5                	j	ffffffffc0204aba <do_execve+0x278>
        if (ph->p_filesz > ph->p_memsz)
ffffffffc0204ac4:	02893603          	ld	a2,40(s2)
ffffffffc0204ac8:	02093783          	ld	a5,32(s2)
ffffffffc0204acc:	1cf66d63          	bltu	a2,a5,ffffffffc0204ca6 <do_execve+0x464>
        if (ph->p_flags & ELF_PF_X)
ffffffffc0204ad0:	00492783          	lw	a5,4(s2)
ffffffffc0204ad4:	0017f693          	andi	a3,a5,1
ffffffffc0204ad8:	c291                	beqz	a3,ffffffffc0204adc <do_execve+0x29a>
            vm_flags |= VM_EXEC;
ffffffffc0204ada:	4691                	li	a3,4
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204adc:	0027f713          	andi	a4,a5,2
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204ae0:	8b91                	andi	a5,a5,4
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204ae2:	e779                	bnez	a4,ffffffffc0204bb0 <do_execve+0x36e>
        vm_flags = 0, perm = PTE_U | PTE_V;
ffffffffc0204ae4:	4d45                	li	s10,17
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204ae6:	c781                	beqz	a5,ffffffffc0204aee <do_execve+0x2ac>
            vm_flags |= VM_READ;
ffffffffc0204ae8:	0016e693          	ori	a3,a3,1
            perm |= PTE_R;
ffffffffc0204aec:	4d4d                	li	s10,19
        if (vm_flags & VM_WRITE)
ffffffffc0204aee:	0026f793          	andi	a5,a3,2
ffffffffc0204af2:	e3f1                	bnez	a5,ffffffffc0204bb6 <do_execve+0x374>
        if (vm_flags & VM_EXEC)
ffffffffc0204af4:	0046f793          	andi	a5,a3,4
ffffffffc0204af8:	c399                	beqz	a5,ffffffffc0204afe <do_execve+0x2bc>
            perm |= PTE_X;
ffffffffc0204afa:	008d6d13          	ori	s10,s10,8
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0)
ffffffffc0204afe:	01093583          	ld	a1,16(s2)
ffffffffc0204b02:	4701                	li	a4,0
ffffffffc0204b04:	8522                	mv	a0,s0
ffffffffc0204b06:	d59fe0ef          	jal	ra,ffffffffc020385e <mm_map>
ffffffffc0204b0a:	89aa                	mv	s3,a0
ffffffffc0204b0c:	ed35                	bnez	a0,ffffffffc0204b88 <do_execve+0x346>
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204b0e:	01093b03          	ld	s6,16(s2)
ffffffffc0204b12:	77fd                	lui	a5,0xfffff
        end = ph->p_va + ph->p_filesz;
ffffffffc0204b14:	02093983          	ld	s3,32(s2)
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204b18:	00893483          	ld	s1,8(s2)
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204b1c:	00fb7a33          	and	s4,s6,a5
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204b20:	7782                	ld	a5,32(sp)
        end = ph->p_va + ph->p_filesz;
ffffffffc0204b22:	99da                	add	s3,s3,s6
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204b24:	94be                	add	s1,s1,a5
        while (start < end)
ffffffffc0204b26:	053b6963          	bltu	s6,s3,ffffffffc0204b78 <do_execve+0x336>
ffffffffc0204b2a:	aa95                	j	ffffffffc0204c9e <do_execve+0x45c>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204b2c:	6785                	lui	a5,0x1
ffffffffc0204b2e:	414b0533          	sub	a0,s6,s4
ffffffffc0204b32:	9a3e                	add	s4,s4,a5
ffffffffc0204b34:	416a0633          	sub	a2,s4,s6
            if (end < la)
ffffffffc0204b38:	0149f463          	bgeu	s3,s4,ffffffffc0204b40 <do_execve+0x2fe>
                size -= la - end;
ffffffffc0204b3c:	41698633          	sub	a2,s3,s6
    return page - pages + nbase;
ffffffffc0204b40:	000cb683          	ld	a3,0(s9)
ffffffffc0204b44:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204b46:	000c3583          	ld	a1,0(s8)
    return page - pages + nbase;
ffffffffc0204b4a:	40db86b3          	sub	a3,s7,a3
ffffffffc0204b4e:	8699                	srai	a3,a3,0x6
ffffffffc0204b50:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204b52:	67e2                	ld	a5,24(sp)
ffffffffc0204b54:	00f6f8b3          	and	a7,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204b58:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204b5a:	14b8f863          	bgeu	a7,a1,ffffffffc0204caa <do_execve+0x468>
ffffffffc0204b5e:	000ab883          	ld	a7,0(s5)
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204b62:	85a6                	mv	a1,s1
            start += size, from += size;
ffffffffc0204b64:	9b32                	add	s6,s6,a2
ffffffffc0204b66:	96c6                	add	a3,a3,a7
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204b68:	9536                	add	a0,a0,a3
            start += size, from += size;
ffffffffc0204b6a:	e432                	sd	a2,8(sp)
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204b6c:	379000ef          	jal	ra,ffffffffc02056e4 <memcpy>
            start += size, from += size;
ffffffffc0204b70:	6622                	ld	a2,8(sp)
ffffffffc0204b72:	94b2                	add	s1,s1,a2
        while (start < end)
ffffffffc0204b74:	053b7363          	bgeu	s6,s3,ffffffffc0204bba <do_execve+0x378>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204b78:	6c08                	ld	a0,24(s0)
ffffffffc0204b7a:	866a                	mv	a2,s10
ffffffffc0204b7c:	85d2                	mv	a1,s4
ffffffffc0204b7e:	a69fe0ef          	jal	ra,ffffffffc02035e6 <pgdir_alloc_page>
ffffffffc0204b82:	8baa                	mv	s7,a0
ffffffffc0204b84:	f545                	bnez	a0,ffffffffc0204b2c <do_execve+0x2ea>
        ret = -E_NO_MEM;
ffffffffc0204b86:	59f1                	li	s3,-4
    exit_mmap(mm);
ffffffffc0204b88:	8522                	mv	a0,s0
ffffffffc0204b8a:	e1ffe0ef          	jal	ra,ffffffffc02039a8 <exit_mmap>
    put_pgdir(mm);
ffffffffc0204b8e:	8522                	mv	a0,s0
ffffffffc0204b90:	b4cff0ef          	jal	ra,ffffffffc0203edc <put_pgdir>
    mm_destroy(mm);
ffffffffc0204b94:	8522                	mv	a0,s0
ffffffffc0204b96:	c77fe0ef          	jal	ra,ffffffffc020380c <mm_destroy>
    return ret;
ffffffffc0204b9a:	b705                	j	ffffffffc0204aba <do_execve+0x278>
            exit_mmap(mm);
ffffffffc0204b9c:	854a                	mv	a0,s2
ffffffffc0204b9e:	e0bfe0ef          	jal	ra,ffffffffc02039a8 <exit_mmap>
            put_pgdir(mm);
ffffffffc0204ba2:	854a                	mv	a0,s2
ffffffffc0204ba4:	b38ff0ef          	jal	ra,ffffffffc0203edc <put_pgdir>
            mm_destroy(mm);
ffffffffc0204ba8:	854a                	mv	a0,s2
ffffffffc0204baa:	c63fe0ef          	jal	ra,ffffffffc020380c <mm_destroy>
ffffffffc0204bae:	b31d                	j	ffffffffc02048d4 <do_execve+0x92>
            vm_flags |= VM_WRITE;
ffffffffc0204bb0:	0026e693          	ori	a3,a3,2
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204bb4:	fb95                	bnez	a5,ffffffffc0204ae8 <do_execve+0x2a6>
            perm |= (PTE_W | PTE_R);
ffffffffc0204bb6:	4d5d                	li	s10,23
ffffffffc0204bb8:	bf35                	j	ffffffffc0204af4 <do_execve+0x2b2>
        end = ph->p_va + ph->p_memsz;
ffffffffc0204bba:	01093483          	ld	s1,16(s2)
ffffffffc0204bbe:	02893683          	ld	a3,40(s2)
ffffffffc0204bc2:	94b6                	add	s1,s1,a3
        if (start < la)
ffffffffc0204bc4:	074b7d63          	bgeu	s6,s4,ffffffffc0204c3e <do_execve+0x3fc>
            if (start == end)
ffffffffc0204bc8:	db648de3          	beq	s1,s6,ffffffffc0204982 <do_execve+0x140>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204bcc:	6785                	lui	a5,0x1
ffffffffc0204bce:	00fb0533          	add	a0,s6,a5
ffffffffc0204bd2:	41450533          	sub	a0,a0,s4
                size -= la - end;
ffffffffc0204bd6:	416489b3          	sub	s3,s1,s6
            if (end < la)
ffffffffc0204bda:	0b44fd63          	bgeu	s1,s4,ffffffffc0204c94 <do_execve+0x452>
    return page - pages + nbase;
ffffffffc0204bde:	000cb683          	ld	a3,0(s9)
ffffffffc0204be2:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204be4:	000c3603          	ld	a2,0(s8)
    return page - pages + nbase;
ffffffffc0204be8:	40db86b3          	sub	a3,s7,a3
ffffffffc0204bec:	8699                	srai	a3,a3,0x6
ffffffffc0204bee:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204bf0:	67e2                	ld	a5,24(sp)
ffffffffc0204bf2:	00f6f5b3          	and	a1,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204bf6:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204bf8:	0ac5f963          	bgeu	a1,a2,ffffffffc0204caa <do_execve+0x468>
ffffffffc0204bfc:	000ab883          	ld	a7,0(s5)
            memset(page2kva(page) + off, 0, size);
ffffffffc0204c00:	864e                	mv	a2,s3
ffffffffc0204c02:	4581                	li	a1,0
ffffffffc0204c04:	96c6                	add	a3,a3,a7
ffffffffc0204c06:	9536                	add	a0,a0,a3
ffffffffc0204c08:	2cb000ef          	jal	ra,ffffffffc02056d2 <memset>
            start += size;
ffffffffc0204c0c:	01698733          	add	a4,s3,s6
            assert((end < la && start == end) || (end >= la && start == la));
ffffffffc0204c10:	0344f463          	bgeu	s1,s4,ffffffffc0204c38 <do_execve+0x3f6>
ffffffffc0204c14:	d6e487e3          	beq	s1,a4,ffffffffc0204982 <do_execve+0x140>
ffffffffc0204c18:	00002697          	auipc	a3,0x2
ffffffffc0204c1c:	5a868693          	addi	a3,a3,1448 # ffffffffc02071c0 <default_pmm_manager+0xc80>
ffffffffc0204c20:	00001617          	auipc	a2,0x1
ffffffffc0204c24:	57060613          	addi	a2,a2,1392 # ffffffffc0206190 <commands+0x828>
ffffffffc0204c28:	2bf00593          	li	a1,703
ffffffffc0204c2c:	00002517          	auipc	a0,0x2
ffffffffc0204c30:	38450513          	addi	a0,a0,900 # ffffffffc0206fb0 <default_pmm_manager+0xa70>
ffffffffc0204c34:	85bfb0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc0204c38:	ff4710e3          	bne	a4,s4,ffffffffc0204c18 <do_execve+0x3d6>
ffffffffc0204c3c:	8b52                	mv	s6,s4
        while (start < end)
ffffffffc0204c3e:	d49b72e3          	bgeu	s6,s1,ffffffffc0204982 <do_execve+0x140>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204c42:	6c08                	ld	a0,24(s0)
ffffffffc0204c44:	866a                	mv	a2,s10
ffffffffc0204c46:	85d2                	mv	a1,s4
ffffffffc0204c48:	99ffe0ef          	jal	ra,ffffffffc02035e6 <pgdir_alloc_page>
ffffffffc0204c4c:	8baa                	mv	s7,a0
ffffffffc0204c4e:	dd05                	beqz	a0,ffffffffc0204b86 <do_execve+0x344>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204c50:	6785                	lui	a5,0x1
ffffffffc0204c52:	414b0533          	sub	a0,s6,s4
ffffffffc0204c56:	9a3e                	add	s4,s4,a5
ffffffffc0204c58:	416a0633          	sub	a2,s4,s6
            if (end < la)
ffffffffc0204c5c:	0144f463          	bgeu	s1,s4,ffffffffc0204c64 <do_execve+0x422>
                size -= la - end;
ffffffffc0204c60:	41648633          	sub	a2,s1,s6
    return page - pages + nbase;
ffffffffc0204c64:	000cb683          	ld	a3,0(s9)
ffffffffc0204c68:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204c6a:	000c3583          	ld	a1,0(s8)
    return page - pages + nbase;
ffffffffc0204c6e:	40db86b3          	sub	a3,s7,a3
ffffffffc0204c72:	8699                	srai	a3,a3,0x6
ffffffffc0204c74:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204c76:	67e2                	ld	a5,24(sp)
ffffffffc0204c78:	00f6f8b3          	and	a7,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204c7c:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204c7e:	02b8f663          	bgeu	a7,a1,ffffffffc0204caa <do_execve+0x468>
ffffffffc0204c82:	000ab883          	ld	a7,0(s5)
            memset(page2kva(page) + off, 0, size);
ffffffffc0204c86:	4581                	li	a1,0
            start += size;
ffffffffc0204c88:	9b32                	add	s6,s6,a2
ffffffffc0204c8a:	96c6                	add	a3,a3,a7
            memset(page2kva(page) + off, 0, size);
ffffffffc0204c8c:	9536                	add	a0,a0,a3
ffffffffc0204c8e:	245000ef          	jal	ra,ffffffffc02056d2 <memset>
ffffffffc0204c92:	b775                	j	ffffffffc0204c3e <do_execve+0x3fc>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204c94:	416a09b3          	sub	s3,s4,s6
ffffffffc0204c98:	b799                	j	ffffffffc0204bde <do_execve+0x39c>
        return -E_INVAL;
ffffffffc0204c9a:	59f5                	li	s3,-3
ffffffffc0204c9c:	b3c1                	j	ffffffffc0204a5c <do_execve+0x21a>
        while (start < end)
ffffffffc0204c9e:	84da                	mv	s1,s6
ffffffffc0204ca0:	bf39                	j	ffffffffc0204bbe <do_execve+0x37c>
    int ret = -E_NO_MEM;
ffffffffc0204ca2:	59f1                	li	s3,-4
ffffffffc0204ca4:	bdc5                	j	ffffffffc0204b94 <do_execve+0x352>
            ret = -E_INVAL_ELF;
ffffffffc0204ca6:	59e1                	li	s3,-8
ffffffffc0204ca8:	b5c5                	j	ffffffffc0204b88 <do_execve+0x346>
ffffffffc0204caa:	00002617          	auipc	a2,0x2
ffffffffc0204cae:	8ce60613          	addi	a2,a2,-1842 # ffffffffc0206578 <default_pmm_manager+0x38>
ffffffffc0204cb2:	07100593          	li	a1,113
ffffffffc0204cb6:	00002517          	auipc	a0,0x2
ffffffffc0204cba:	8ea50513          	addi	a0,a0,-1814 # ffffffffc02065a0 <default_pmm_manager+0x60>
ffffffffc0204cbe:	fd0fb0ef          	jal	ra,ffffffffc020048e <__panic>
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204cc2:	00002617          	auipc	a2,0x2
ffffffffc0204cc6:	95e60613          	addi	a2,a2,-1698 # ffffffffc0206620 <default_pmm_manager+0xe0>
ffffffffc0204cca:	2de00593          	li	a1,734
ffffffffc0204cce:	00002517          	auipc	a0,0x2
ffffffffc0204cd2:	2e250513          	addi	a0,a0,738 # ffffffffc0206fb0 <default_pmm_manager+0xa70>
ffffffffc0204cd6:	fb8fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204cda:	00002697          	auipc	a3,0x2
ffffffffc0204cde:	5fe68693          	addi	a3,a3,1534 # ffffffffc02072d8 <default_pmm_manager+0xd98>
ffffffffc0204ce2:	00001617          	auipc	a2,0x1
ffffffffc0204ce6:	4ae60613          	addi	a2,a2,1198 # ffffffffc0206190 <commands+0x828>
ffffffffc0204cea:	2d900593          	li	a1,729
ffffffffc0204cee:	00002517          	auipc	a0,0x2
ffffffffc0204cf2:	2c250513          	addi	a0,a0,706 # ffffffffc0206fb0 <default_pmm_manager+0xa70>
ffffffffc0204cf6:	f98fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204cfa:	00002697          	auipc	a3,0x2
ffffffffc0204cfe:	59668693          	addi	a3,a3,1430 # ffffffffc0207290 <default_pmm_manager+0xd50>
ffffffffc0204d02:	00001617          	auipc	a2,0x1
ffffffffc0204d06:	48e60613          	addi	a2,a2,1166 # ffffffffc0206190 <commands+0x828>
ffffffffc0204d0a:	2d800593          	li	a1,728
ffffffffc0204d0e:	00002517          	auipc	a0,0x2
ffffffffc0204d12:	2a250513          	addi	a0,a0,674 # ffffffffc0206fb0 <default_pmm_manager+0xa70>
ffffffffc0204d16:	f78fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204d1a:	00002697          	auipc	a3,0x2
ffffffffc0204d1e:	52e68693          	addi	a3,a3,1326 # ffffffffc0207248 <default_pmm_manager+0xd08>
ffffffffc0204d22:	00001617          	auipc	a2,0x1
ffffffffc0204d26:	46e60613          	addi	a2,a2,1134 # ffffffffc0206190 <commands+0x828>
ffffffffc0204d2a:	2d700593          	li	a1,727
ffffffffc0204d2e:	00002517          	auipc	a0,0x2
ffffffffc0204d32:	28250513          	addi	a0,a0,642 # ffffffffc0206fb0 <default_pmm_manager+0xa70>
ffffffffc0204d36:	f58fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc0204d3a:	00002697          	auipc	a3,0x2
ffffffffc0204d3e:	4c668693          	addi	a3,a3,1222 # ffffffffc0207200 <default_pmm_manager+0xcc0>
ffffffffc0204d42:	00001617          	auipc	a2,0x1
ffffffffc0204d46:	44e60613          	addi	a2,a2,1102 # ffffffffc0206190 <commands+0x828>
ffffffffc0204d4a:	2d600593          	li	a1,726
ffffffffc0204d4e:	00002517          	auipc	a0,0x2
ffffffffc0204d52:	26250513          	addi	a0,a0,610 # ffffffffc0206fb0 <default_pmm_manager+0xa70>
ffffffffc0204d56:	f38fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0204d5a <do_yield>:
    current->need_resched = 1;
ffffffffc0204d5a:	000a6797          	auipc	a5,0xa6
ffffffffc0204d5e:	ab67b783          	ld	a5,-1354(a5) # ffffffffc02aa810 <current>
ffffffffc0204d62:	4705                	li	a4,1
ffffffffc0204d64:	ef98                	sd	a4,24(a5)
}
ffffffffc0204d66:	4501                	li	a0,0
ffffffffc0204d68:	8082                	ret

ffffffffc0204d6a <do_wait>:
{
ffffffffc0204d6a:	1101                	addi	sp,sp,-32
ffffffffc0204d6c:	e822                	sd	s0,16(sp)
ffffffffc0204d6e:	e426                	sd	s1,8(sp)
ffffffffc0204d70:	ec06                	sd	ra,24(sp)
ffffffffc0204d72:	842e                	mv	s0,a1
ffffffffc0204d74:	84aa                	mv	s1,a0
    if (code_store != NULL)
ffffffffc0204d76:	c999                	beqz	a1,ffffffffc0204d8c <do_wait+0x22>
    struct mm_struct *mm = current->mm;
ffffffffc0204d78:	000a6797          	auipc	a5,0xa6
ffffffffc0204d7c:	a987b783          	ld	a5,-1384(a5) # ffffffffc02aa810 <current>
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1))
ffffffffc0204d80:	7788                	ld	a0,40(a5)
ffffffffc0204d82:	4685                	li	a3,1
ffffffffc0204d84:	4611                	li	a2,4
ffffffffc0204d86:	fbdfe0ef          	jal	ra,ffffffffc0203d42 <user_mem_check>
ffffffffc0204d8a:	c909                	beqz	a0,ffffffffc0204d9c <do_wait+0x32>
ffffffffc0204d8c:	85a2                	mv	a1,s0
}
ffffffffc0204d8e:	6442                	ld	s0,16(sp)
ffffffffc0204d90:	60e2                	ld	ra,24(sp)
ffffffffc0204d92:	8526                	mv	a0,s1
ffffffffc0204d94:	64a2                	ld	s1,8(sp)
ffffffffc0204d96:	6105                	addi	sp,sp,32
ffffffffc0204d98:	fb4ff06f          	j	ffffffffc020454c <do_wait.part.0>
ffffffffc0204d9c:	60e2                	ld	ra,24(sp)
ffffffffc0204d9e:	6442                	ld	s0,16(sp)
ffffffffc0204da0:	64a2                	ld	s1,8(sp)
ffffffffc0204da2:	5575                	li	a0,-3
ffffffffc0204da4:	6105                	addi	sp,sp,32
ffffffffc0204da6:	8082                	ret

ffffffffc0204da8 <do_kill>:
{
ffffffffc0204da8:	1141                	addi	sp,sp,-16
    if (0 < pid && pid < MAX_PID)
ffffffffc0204daa:	6789                	lui	a5,0x2
{
ffffffffc0204dac:	e406                	sd	ra,8(sp)
ffffffffc0204dae:	e022                	sd	s0,0(sp)
    if (0 < pid && pid < MAX_PID)
ffffffffc0204db0:	fff5071b          	addiw	a4,a0,-1
ffffffffc0204db4:	17f9                	addi	a5,a5,-2
ffffffffc0204db6:	02e7e963          	bltu	a5,a4,ffffffffc0204de8 <do_kill+0x40>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204dba:	842a                	mv	s0,a0
ffffffffc0204dbc:	45a9                	li	a1,10
ffffffffc0204dbe:	2501                	sext.w	a0,a0
ffffffffc0204dc0:	46c000ef          	jal	ra,ffffffffc020522c <hash32>
ffffffffc0204dc4:	02051793          	slli	a5,a0,0x20
ffffffffc0204dc8:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0204dcc:	000a2797          	auipc	a5,0xa2
ffffffffc0204dd0:	9cc78793          	addi	a5,a5,-1588 # ffffffffc02a6798 <hash_list>
ffffffffc0204dd4:	953e                	add	a0,a0,a5
ffffffffc0204dd6:	87aa                	mv	a5,a0
        while ((le = list_next(le)) != list)
ffffffffc0204dd8:	a029                	j	ffffffffc0204de2 <do_kill+0x3a>
            if (proc->pid == pid)
ffffffffc0204dda:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0204dde:	00870b63          	beq	a4,s0,ffffffffc0204df4 <do_kill+0x4c>
ffffffffc0204de2:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0204de4:	fef51be3          	bne	a0,a5,ffffffffc0204dda <do_kill+0x32>
    return -E_INVAL;
ffffffffc0204de8:	5475                	li	s0,-3
}
ffffffffc0204dea:	60a2                	ld	ra,8(sp)
ffffffffc0204dec:	8522                	mv	a0,s0
ffffffffc0204dee:	6402                	ld	s0,0(sp)
ffffffffc0204df0:	0141                	addi	sp,sp,16
ffffffffc0204df2:	8082                	ret
        if (!(proc->flags & PF_EXITING))
ffffffffc0204df4:	fd87a703          	lw	a4,-40(a5)
ffffffffc0204df8:	00177693          	andi	a3,a4,1
ffffffffc0204dfc:	e295                	bnez	a3,ffffffffc0204e20 <do_kill+0x78>
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc0204dfe:	4bd4                	lw	a3,20(a5)
            proc->flags |= PF_EXITING;
ffffffffc0204e00:	00176713          	ori	a4,a4,1
ffffffffc0204e04:	fce7ac23          	sw	a4,-40(a5)
            return 0;
ffffffffc0204e08:	4401                	li	s0,0
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc0204e0a:	fe06d0e3          	bgez	a3,ffffffffc0204dea <do_kill+0x42>
                wakeup_proc(proc);
ffffffffc0204e0e:	f2878513          	addi	a0,a5,-216
ffffffffc0204e12:	22e000ef          	jal	ra,ffffffffc0205040 <wakeup_proc>
}
ffffffffc0204e16:	60a2                	ld	ra,8(sp)
ffffffffc0204e18:	8522                	mv	a0,s0
ffffffffc0204e1a:	6402                	ld	s0,0(sp)
ffffffffc0204e1c:	0141                	addi	sp,sp,16
ffffffffc0204e1e:	8082                	ret
        return -E_KILLED;
ffffffffc0204e20:	545d                	li	s0,-9
ffffffffc0204e22:	b7e1                	j	ffffffffc0204dea <do_kill+0x42>

ffffffffc0204e24 <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and
//           - create the second kernel thread init_main
void proc_init(void)
{
ffffffffc0204e24:	1101                	addi	sp,sp,-32
ffffffffc0204e26:	e426                	sd	s1,8(sp)
    elm->prev = elm->next = elm;
ffffffffc0204e28:	000a6797          	auipc	a5,0xa6
ffffffffc0204e2c:	97078793          	addi	a5,a5,-1680 # ffffffffc02aa798 <proc_list>
ffffffffc0204e30:	ec06                	sd	ra,24(sp)
ffffffffc0204e32:	e822                	sd	s0,16(sp)
ffffffffc0204e34:	e04a                	sd	s2,0(sp)
ffffffffc0204e36:	000a2497          	auipc	s1,0xa2
ffffffffc0204e3a:	96248493          	addi	s1,s1,-1694 # ffffffffc02a6798 <hash_list>
ffffffffc0204e3e:	e79c                	sd	a5,8(a5)
ffffffffc0204e40:	e39c                	sd	a5,0(a5)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i++)
ffffffffc0204e42:	000a6717          	auipc	a4,0xa6
ffffffffc0204e46:	95670713          	addi	a4,a4,-1706 # ffffffffc02aa798 <proc_list>
ffffffffc0204e4a:	87a6                	mv	a5,s1
ffffffffc0204e4c:	e79c                	sd	a5,8(a5)
ffffffffc0204e4e:	e39c                	sd	a5,0(a5)
ffffffffc0204e50:	07c1                	addi	a5,a5,16
ffffffffc0204e52:	fef71de3          	bne	a4,a5,ffffffffc0204e4c <proc_init+0x28>
    {
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL)
ffffffffc0204e56:	f89fe0ef          	jal	ra,ffffffffc0203dde <alloc_proc>
ffffffffc0204e5a:	000a6917          	auipc	s2,0xa6
ffffffffc0204e5e:	9be90913          	addi	s2,s2,-1602 # ffffffffc02aa818 <idleproc>
ffffffffc0204e62:	00a93023          	sd	a0,0(s2)
ffffffffc0204e66:	0e050f63          	beqz	a0,ffffffffc0204f64 <proc_init+0x140>
    {
        panic("cannot alloc idleproc.\n");
    }

    idleproc->pid = 0;
    idleproc->state = PROC_RUNNABLE;
ffffffffc0204e6a:	4789                	li	a5,2
ffffffffc0204e6c:	e11c                	sd	a5,0(a0)
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0204e6e:	00003797          	auipc	a5,0x3
ffffffffc0204e72:	19278793          	addi	a5,a5,402 # ffffffffc0208000 <bootstack>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204e76:	0b450413          	addi	s0,a0,180
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0204e7a:	e91c                	sd	a5,16(a0)
    idleproc->need_resched = 1;
ffffffffc0204e7c:	4785                	li	a5,1
ffffffffc0204e7e:	ed1c                	sd	a5,24(a0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204e80:	4641                	li	a2,16
ffffffffc0204e82:	4581                	li	a1,0
ffffffffc0204e84:	8522                	mv	a0,s0
ffffffffc0204e86:	04d000ef          	jal	ra,ffffffffc02056d2 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204e8a:	463d                	li	a2,15
ffffffffc0204e8c:	00002597          	auipc	a1,0x2
ffffffffc0204e90:	4ac58593          	addi	a1,a1,1196 # ffffffffc0207338 <default_pmm_manager+0xdf8>
ffffffffc0204e94:	8522                	mv	a0,s0
ffffffffc0204e96:	04f000ef          	jal	ra,ffffffffc02056e4 <memcpy>
    set_proc_name(idleproc, "idle");
    nr_process++;
ffffffffc0204e9a:	000a6717          	auipc	a4,0xa6
ffffffffc0204e9e:	98e70713          	addi	a4,a4,-1650 # ffffffffc02aa828 <nr_process>
ffffffffc0204ea2:	431c                	lw	a5,0(a4)

    current = idleproc;
ffffffffc0204ea4:	00093683          	ld	a3,0(s2)

    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0204ea8:	4601                	li	a2,0
    nr_process++;
ffffffffc0204eaa:	2785                	addiw	a5,a5,1
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0204eac:	4581                	li	a1,0
ffffffffc0204eae:	00000517          	auipc	a0,0x0
ffffffffc0204eb2:	87050513          	addi	a0,a0,-1936 # ffffffffc020471e <init_main>
    nr_process++;
ffffffffc0204eb6:	c31c                	sw	a5,0(a4)
    current = idleproc;
ffffffffc0204eb8:	000a6797          	auipc	a5,0xa6
ffffffffc0204ebc:	94d7bc23          	sd	a3,-1704(a5) # ffffffffc02aa810 <current>
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0204ec0:	cf2ff0ef          	jal	ra,ffffffffc02043b2 <kernel_thread>
ffffffffc0204ec4:	842a                	mv	s0,a0
    if (pid <= 0)
ffffffffc0204ec6:	08a05363          	blez	a0,ffffffffc0204f4c <proc_init+0x128>
    if (0 < pid && pid < MAX_PID)
ffffffffc0204eca:	6789                	lui	a5,0x2
ffffffffc0204ecc:	fff5071b          	addiw	a4,a0,-1
ffffffffc0204ed0:	17f9                	addi	a5,a5,-2
ffffffffc0204ed2:	2501                	sext.w	a0,a0
ffffffffc0204ed4:	02e7e363          	bltu	a5,a4,ffffffffc0204efa <proc_init+0xd6>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204ed8:	45a9                	li	a1,10
ffffffffc0204eda:	352000ef          	jal	ra,ffffffffc020522c <hash32>
ffffffffc0204ede:	02051793          	slli	a5,a0,0x20
ffffffffc0204ee2:	01c7d693          	srli	a3,a5,0x1c
ffffffffc0204ee6:	96a6                	add	a3,a3,s1
ffffffffc0204ee8:	87b6                	mv	a5,a3
        while ((le = list_next(le)) != list)
ffffffffc0204eea:	a029                	j	ffffffffc0204ef4 <proc_init+0xd0>
            if (proc->pid == pid)
ffffffffc0204eec:	f2c7a703          	lw	a4,-212(a5) # 1f2c <_binary_obj___user_faultread_out_size-0x7c8c>
ffffffffc0204ef0:	04870b63          	beq	a4,s0,ffffffffc0204f46 <proc_init+0x122>
    return listelm->next;
ffffffffc0204ef4:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0204ef6:	fef69be3          	bne	a3,a5,ffffffffc0204eec <proc_init+0xc8>
    return NULL;
ffffffffc0204efa:	4781                	li	a5,0
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204efc:	0b478493          	addi	s1,a5,180
ffffffffc0204f00:	4641                	li	a2,16
ffffffffc0204f02:	4581                	li	a1,0
    {
        panic("create init_main failed.\n");
    }

    initproc = find_proc(pid);
ffffffffc0204f04:	000a6417          	auipc	s0,0xa6
ffffffffc0204f08:	91c40413          	addi	s0,s0,-1764 # ffffffffc02aa820 <initproc>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204f0c:	8526                	mv	a0,s1
    initproc = find_proc(pid);
ffffffffc0204f0e:	e01c                	sd	a5,0(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204f10:	7c2000ef          	jal	ra,ffffffffc02056d2 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204f14:	463d                	li	a2,15
ffffffffc0204f16:	00002597          	auipc	a1,0x2
ffffffffc0204f1a:	44a58593          	addi	a1,a1,1098 # ffffffffc0207360 <default_pmm_manager+0xe20>
ffffffffc0204f1e:	8526                	mv	a0,s1
ffffffffc0204f20:	7c4000ef          	jal	ra,ffffffffc02056e4 <memcpy>
    set_proc_name(initproc, "init");

    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0204f24:	00093783          	ld	a5,0(s2)
ffffffffc0204f28:	cbb5                	beqz	a5,ffffffffc0204f9c <proc_init+0x178>
ffffffffc0204f2a:	43dc                	lw	a5,4(a5)
ffffffffc0204f2c:	eba5                	bnez	a5,ffffffffc0204f9c <proc_init+0x178>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0204f2e:	601c                	ld	a5,0(s0)
ffffffffc0204f30:	c7b1                	beqz	a5,ffffffffc0204f7c <proc_init+0x158>
ffffffffc0204f32:	43d8                	lw	a4,4(a5)
ffffffffc0204f34:	4785                	li	a5,1
ffffffffc0204f36:	04f71363          	bne	a4,a5,ffffffffc0204f7c <proc_init+0x158>
}
ffffffffc0204f3a:	60e2                	ld	ra,24(sp)
ffffffffc0204f3c:	6442                	ld	s0,16(sp)
ffffffffc0204f3e:	64a2                	ld	s1,8(sp)
ffffffffc0204f40:	6902                	ld	s2,0(sp)
ffffffffc0204f42:	6105                	addi	sp,sp,32
ffffffffc0204f44:	8082                	ret
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc0204f46:	f2878793          	addi	a5,a5,-216
ffffffffc0204f4a:	bf4d                	j	ffffffffc0204efc <proc_init+0xd8>
        panic("create init_main failed.\n");
ffffffffc0204f4c:	00002617          	auipc	a2,0x2
ffffffffc0204f50:	3f460613          	addi	a2,a2,1012 # ffffffffc0207340 <default_pmm_manager+0xe00>
ffffffffc0204f54:	40400593          	li	a1,1028
ffffffffc0204f58:	00002517          	auipc	a0,0x2
ffffffffc0204f5c:	05850513          	addi	a0,a0,88 # ffffffffc0206fb0 <default_pmm_manager+0xa70>
ffffffffc0204f60:	d2efb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("cannot alloc idleproc.\n");
ffffffffc0204f64:	00002617          	auipc	a2,0x2
ffffffffc0204f68:	3bc60613          	addi	a2,a2,956 # ffffffffc0207320 <default_pmm_manager+0xde0>
ffffffffc0204f6c:	3f500593          	li	a1,1013
ffffffffc0204f70:	00002517          	auipc	a0,0x2
ffffffffc0204f74:	04050513          	addi	a0,a0,64 # ffffffffc0206fb0 <default_pmm_manager+0xa70>
ffffffffc0204f78:	d16fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0204f7c:	00002697          	auipc	a3,0x2
ffffffffc0204f80:	41468693          	addi	a3,a3,1044 # ffffffffc0207390 <default_pmm_manager+0xe50>
ffffffffc0204f84:	00001617          	auipc	a2,0x1
ffffffffc0204f88:	20c60613          	addi	a2,a2,524 # ffffffffc0206190 <commands+0x828>
ffffffffc0204f8c:	40b00593          	li	a1,1035
ffffffffc0204f90:	00002517          	auipc	a0,0x2
ffffffffc0204f94:	02050513          	addi	a0,a0,32 # ffffffffc0206fb0 <default_pmm_manager+0xa70>
ffffffffc0204f98:	cf6fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0204f9c:	00002697          	auipc	a3,0x2
ffffffffc0204fa0:	3cc68693          	addi	a3,a3,972 # ffffffffc0207368 <default_pmm_manager+0xe28>
ffffffffc0204fa4:	00001617          	auipc	a2,0x1
ffffffffc0204fa8:	1ec60613          	addi	a2,a2,492 # ffffffffc0206190 <commands+0x828>
ffffffffc0204fac:	40a00593          	li	a1,1034
ffffffffc0204fb0:	00002517          	auipc	a0,0x2
ffffffffc0204fb4:	00050513          	mv	a0,a0
ffffffffc0204fb8:	cd6fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0204fbc <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void cpu_idle(void)
{
ffffffffc0204fbc:	1141                	addi	sp,sp,-16
ffffffffc0204fbe:	e022                	sd	s0,0(sp)
ffffffffc0204fc0:	e406                	sd	ra,8(sp)
ffffffffc0204fc2:	000a6417          	auipc	s0,0xa6
ffffffffc0204fc6:	84e40413          	addi	s0,s0,-1970 # ffffffffc02aa810 <current>
    while (1)
    {
        if (current->need_resched)
ffffffffc0204fca:	6018                	ld	a4,0(s0)
ffffffffc0204fcc:	6f1c                	ld	a5,24(a4)
ffffffffc0204fce:	dffd                	beqz	a5,ffffffffc0204fcc <cpu_idle+0x10>
        {
            schedule();
ffffffffc0204fd0:	0f0000ef          	jal	ra,ffffffffc02050c0 <schedule>
ffffffffc0204fd4:	bfdd                	j	ffffffffc0204fca <cpu_idle+0xe>

ffffffffc0204fd6 <switch_to>:
.text
# void switch_to(struct proc_struct* from, struct proc_struct* to)
.globl switch_to
switch_to:
    # save from's registers
    STORE ra, 0*REGBYTES(a0)
ffffffffc0204fd6:	00153023          	sd	ra,0(a0) # ffffffffc0206fb0 <default_pmm_manager+0xa70>
    STORE sp, 1*REGBYTES(a0)
ffffffffc0204fda:	00253423          	sd	sp,8(a0)
    STORE s0, 2*REGBYTES(a0)
ffffffffc0204fde:	e900                	sd	s0,16(a0)
    STORE s1, 3*REGBYTES(a0)
ffffffffc0204fe0:	ed04                	sd	s1,24(a0)
    STORE s2, 4*REGBYTES(a0)
ffffffffc0204fe2:	03253023          	sd	s2,32(a0)
    STORE s3, 5*REGBYTES(a0)
ffffffffc0204fe6:	03353423          	sd	s3,40(a0)
    STORE s4, 6*REGBYTES(a0)
ffffffffc0204fea:	03453823          	sd	s4,48(a0)
    STORE s5, 7*REGBYTES(a0)
ffffffffc0204fee:	03553c23          	sd	s5,56(a0)
    STORE s6, 8*REGBYTES(a0)
ffffffffc0204ff2:	05653023          	sd	s6,64(a0)
    STORE s7, 9*REGBYTES(a0)
ffffffffc0204ff6:	05753423          	sd	s7,72(a0)
    STORE s8, 10*REGBYTES(a0)
ffffffffc0204ffa:	05853823          	sd	s8,80(a0)
    STORE s9, 11*REGBYTES(a0)
ffffffffc0204ffe:	05953c23          	sd	s9,88(a0)
    STORE s10, 12*REGBYTES(a0)
ffffffffc0205002:	07a53023          	sd	s10,96(a0)
    STORE s11, 13*REGBYTES(a0)
ffffffffc0205006:	07b53423          	sd	s11,104(a0)

    # restore to's registers
    LOAD ra, 0*REGBYTES(a1)
ffffffffc020500a:	0005b083          	ld	ra,0(a1)
    LOAD sp, 1*REGBYTES(a1)
ffffffffc020500e:	0085b103          	ld	sp,8(a1)
    LOAD s0, 2*REGBYTES(a1)
ffffffffc0205012:	6980                	ld	s0,16(a1)
    LOAD s1, 3*REGBYTES(a1)
ffffffffc0205014:	6d84                	ld	s1,24(a1)
    LOAD s2, 4*REGBYTES(a1)
ffffffffc0205016:	0205b903          	ld	s2,32(a1)
    LOAD s3, 5*REGBYTES(a1)
ffffffffc020501a:	0285b983          	ld	s3,40(a1)
    LOAD s4, 6*REGBYTES(a1)
ffffffffc020501e:	0305ba03          	ld	s4,48(a1)
    LOAD s5, 7*REGBYTES(a1)
ffffffffc0205022:	0385ba83          	ld	s5,56(a1)
    LOAD s6, 8*REGBYTES(a1)
ffffffffc0205026:	0405bb03          	ld	s6,64(a1)
    LOAD s7, 9*REGBYTES(a1)
ffffffffc020502a:	0485bb83          	ld	s7,72(a1)
    LOAD s8, 10*REGBYTES(a1)
ffffffffc020502e:	0505bc03          	ld	s8,80(a1)
    LOAD s9, 11*REGBYTES(a1)
ffffffffc0205032:	0585bc83          	ld	s9,88(a1)
    LOAD s10, 12*REGBYTES(a1)
ffffffffc0205036:	0605bd03          	ld	s10,96(a1)
    LOAD s11, 13*REGBYTES(a1)
ffffffffc020503a:	0685bd83          	ld	s11,104(a1)

    ret
ffffffffc020503e:	8082                	ret

ffffffffc0205040 <wakeup_proc>:
#include <sched.h>
#include <assert.h>

void wakeup_proc(struct proc_struct *proc)
{
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0205040:	4118                	lw	a4,0(a0)
{
ffffffffc0205042:	1101                	addi	sp,sp,-32
ffffffffc0205044:	ec06                	sd	ra,24(sp)
ffffffffc0205046:	e822                	sd	s0,16(sp)
ffffffffc0205048:	e426                	sd	s1,8(sp)
    assert(proc->state != PROC_ZOMBIE);
ffffffffc020504a:	478d                	li	a5,3
ffffffffc020504c:	04f70b63          	beq	a4,a5,ffffffffc02050a2 <wakeup_proc+0x62>
ffffffffc0205050:	842a                	mv	s0,a0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0205052:	100027f3          	csrr	a5,sstatus
ffffffffc0205056:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0205058:	4481                	li	s1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020505a:	ef9d                	bnez	a5,ffffffffc0205098 <wakeup_proc+0x58>
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        if (proc->state != PROC_RUNNABLE)
ffffffffc020505c:	4789                	li	a5,2
ffffffffc020505e:	02f70163          	beq	a4,a5,ffffffffc0205080 <wakeup_proc+0x40>
        {
            proc->state = PROC_RUNNABLE;
ffffffffc0205062:	c01c                	sw	a5,0(s0)
            proc->wait_state = 0;
ffffffffc0205064:	0e042623          	sw	zero,236(s0)
    if (flag)
ffffffffc0205068:	e491                	bnez	s1,ffffffffc0205074 <wakeup_proc+0x34>
        {
            warn("wakeup runnable process.\n");
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc020506a:	60e2                	ld	ra,24(sp)
ffffffffc020506c:	6442                	ld	s0,16(sp)
ffffffffc020506e:	64a2                	ld	s1,8(sp)
ffffffffc0205070:	6105                	addi	sp,sp,32
ffffffffc0205072:	8082                	ret
ffffffffc0205074:	6442                	ld	s0,16(sp)
ffffffffc0205076:	60e2                	ld	ra,24(sp)
ffffffffc0205078:	64a2                	ld	s1,8(sp)
ffffffffc020507a:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc020507c:	933fb06f          	j	ffffffffc02009ae <intr_enable>
            warn("wakeup runnable process.\n");
ffffffffc0205080:	00002617          	auipc	a2,0x2
ffffffffc0205084:	37060613          	addi	a2,a2,880 # ffffffffc02073f0 <default_pmm_manager+0xeb0>
ffffffffc0205088:	45d1                	li	a1,20
ffffffffc020508a:	00002517          	auipc	a0,0x2
ffffffffc020508e:	34e50513          	addi	a0,a0,846 # ffffffffc02073d8 <default_pmm_manager+0xe98>
ffffffffc0205092:	c64fb0ef          	jal	ra,ffffffffc02004f6 <__warn>
ffffffffc0205096:	bfc9                	j	ffffffffc0205068 <wakeup_proc+0x28>
        intr_disable();
ffffffffc0205098:	91dfb0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        if (proc->state != PROC_RUNNABLE)
ffffffffc020509c:	4018                	lw	a4,0(s0)
        return 1;
ffffffffc020509e:	4485                	li	s1,1
ffffffffc02050a0:	bf75                	j	ffffffffc020505c <wakeup_proc+0x1c>
    assert(proc->state != PROC_ZOMBIE);
ffffffffc02050a2:	00002697          	auipc	a3,0x2
ffffffffc02050a6:	31668693          	addi	a3,a3,790 # ffffffffc02073b8 <default_pmm_manager+0xe78>
ffffffffc02050aa:	00001617          	auipc	a2,0x1
ffffffffc02050ae:	0e660613          	addi	a2,a2,230 # ffffffffc0206190 <commands+0x828>
ffffffffc02050b2:	45a5                	li	a1,9
ffffffffc02050b4:	00002517          	auipc	a0,0x2
ffffffffc02050b8:	32450513          	addi	a0,a0,804 # ffffffffc02073d8 <default_pmm_manager+0xe98>
ffffffffc02050bc:	bd2fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02050c0 <schedule>:

void schedule(void)
{
ffffffffc02050c0:	1141                	addi	sp,sp,-16
ffffffffc02050c2:	e406                	sd	ra,8(sp)
ffffffffc02050c4:	e022                	sd	s0,0(sp)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02050c6:	100027f3          	csrr	a5,sstatus
ffffffffc02050ca:	8b89                	andi	a5,a5,2
ffffffffc02050cc:	4401                	li	s0,0
ffffffffc02050ce:	efbd                	bnez	a5,ffffffffc020514c <schedule+0x8c>
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
    local_intr_save(intr_flag);
    {
        current->need_resched = 0;
ffffffffc02050d0:	000a5897          	auipc	a7,0xa5
ffffffffc02050d4:	7408b883          	ld	a7,1856(a7) # ffffffffc02aa810 <current>
ffffffffc02050d8:	0008bc23          	sd	zero,24(a7)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc02050dc:	000a5517          	auipc	a0,0xa5
ffffffffc02050e0:	73c53503          	ld	a0,1852(a0) # ffffffffc02aa818 <idleproc>
ffffffffc02050e4:	04a88e63          	beq	a7,a0,ffffffffc0205140 <schedule+0x80>
ffffffffc02050e8:	0c888693          	addi	a3,a7,200
ffffffffc02050ec:	000a5617          	auipc	a2,0xa5
ffffffffc02050f0:	6ac60613          	addi	a2,a2,1708 # ffffffffc02aa798 <proc_list>
        le = last;
ffffffffc02050f4:	87b6                	mv	a5,a3
    struct proc_struct *next = NULL;
ffffffffc02050f6:	4581                	li	a1,0
        do
        {
            if ((le = list_next(le)) != &proc_list)
            {
                next = le2proc(le, list_link);
                if (next->state == PROC_RUNNABLE)
ffffffffc02050f8:	4809                	li	a6,2
ffffffffc02050fa:	679c                	ld	a5,8(a5)
            if ((le = list_next(le)) != &proc_list)
ffffffffc02050fc:	00c78863          	beq	a5,a2,ffffffffc020510c <schedule+0x4c>
                if (next->state == PROC_RUNNABLE)
ffffffffc0205100:	f387a703          	lw	a4,-200(a5)
                next = le2proc(le, list_link);
ffffffffc0205104:	f3878593          	addi	a1,a5,-200
                if (next->state == PROC_RUNNABLE)
ffffffffc0205108:	03070163          	beq	a4,a6,ffffffffc020512a <schedule+0x6a>
                {
                    break;
                }
            }
        } while (le != last);
ffffffffc020510c:	fef697e3          	bne	a3,a5,ffffffffc02050fa <schedule+0x3a>
        if (next == NULL || next->state != PROC_RUNNABLE)
ffffffffc0205110:	ed89                	bnez	a1,ffffffffc020512a <schedule+0x6a>
        {
            next = idleproc;
        }
        next->runs++;
ffffffffc0205112:	451c                	lw	a5,8(a0)
ffffffffc0205114:	2785                	addiw	a5,a5,1
ffffffffc0205116:	c51c                	sw	a5,8(a0)
        if (next != current)
ffffffffc0205118:	00a88463          	beq	a7,a0,ffffffffc0205120 <schedule+0x60>
        {
            proc_run(next);
ffffffffc020511c:	e37fe0ef          	jal	ra,ffffffffc0203f52 <proc_run>
    if (flag)
ffffffffc0205120:	e819                	bnez	s0,ffffffffc0205136 <schedule+0x76>
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc0205122:	60a2                	ld	ra,8(sp)
ffffffffc0205124:	6402                	ld	s0,0(sp)
ffffffffc0205126:	0141                	addi	sp,sp,16
ffffffffc0205128:	8082                	ret
        if (next == NULL || next->state != PROC_RUNNABLE)
ffffffffc020512a:	4198                	lw	a4,0(a1)
ffffffffc020512c:	4789                	li	a5,2
ffffffffc020512e:	fef712e3          	bne	a4,a5,ffffffffc0205112 <schedule+0x52>
ffffffffc0205132:	852e                	mv	a0,a1
ffffffffc0205134:	bff9                	j	ffffffffc0205112 <schedule+0x52>
}
ffffffffc0205136:	6402                	ld	s0,0(sp)
ffffffffc0205138:	60a2                	ld	ra,8(sp)
ffffffffc020513a:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc020513c:	873fb06f          	j	ffffffffc02009ae <intr_enable>
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc0205140:	000a5617          	auipc	a2,0xa5
ffffffffc0205144:	65860613          	addi	a2,a2,1624 # ffffffffc02aa798 <proc_list>
ffffffffc0205148:	86b2                	mv	a3,a2
ffffffffc020514a:	b76d                	j	ffffffffc02050f4 <schedule+0x34>
        intr_disable();
ffffffffc020514c:	869fb0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0205150:	4405                	li	s0,1
ffffffffc0205152:	bfbd                	j	ffffffffc02050d0 <schedule+0x10>

ffffffffc0205154 <sys_getpid>:
    return do_kill(pid);
}

static int
sys_getpid(uint64_t arg[]) {
    return current->pid;
ffffffffc0205154:	000a5797          	auipc	a5,0xa5
ffffffffc0205158:	6bc7b783          	ld	a5,1724(a5) # ffffffffc02aa810 <current>
}
ffffffffc020515c:	43c8                	lw	a0,4(a5)
ffffffffc020515e:	8082                	ret

ffffffffc0205160 <sys_pgdir>:

static int
sys_pgdir(uint64_t arg[]) {
    //print_pgdir();
    return 0;
}
ffffffffc0205160:	4501                	li	a0,0
ffffffffc0205162:	8082                	ret

ffffffffc0205164 <sys_putc>:
    cputchar(c);
ffffffffc0205164:	4108                	lw	a0,0(a0)
sys_putc(uint64_t arg[]) {
ffffffffc0205166:	1141                	addi	sp,sp,-16
ffffffffc0205168:	e406                	sd	ra,8(sp)
    cputchar(c);
ffffffffc020516a:	860fb0ef          	jal	ra,ffffffffc02001ca <cputchar>
}
ffffffffc020516e:	60a2                	ld	ra,8(sp)
ffffffffc0205170:	4501                	li	a0,0
ffffffffc0205172:	0141                	addi	sp,sp,16
ffffffffc0205174:	8082                	ret

ffffffffc0205176 <sys_kill>:
    return do_kill(pid);
ffffffffc0205176:	4108                	lw	a0,0(a0)
ffffffffc0205178:	c31ff06f          	j	ffffffffc0204da8 <do_kill>

ffffffffc020517c <sys_yield>:
    return do_yield();
ffffffffc020517c:	bdfff06f          	j	ffffffffc0204d5a <do_yield>

ffffffffc0205180 <sys_exec>:
    return do_execve(name, len, binary, size);
ffffffffc0205180:	6d14                	ld	a3,24(a0)
ffffffffc0205182:	6910                	ld	a2,16(a0)
ffffffffc0205184:	650c                	ld	a1,8(a0)
ffffffffc0205186:	6108                	ld	a0,0(a0)
ffffffffc0205188:	ebaff06f          	j	ffffffffc0204842 <do_execve>

ffffffffc020518c <sys_wait>:
    return do_wait(pid, store);
ffffffffc020518c:	650c                	ld	a1,8(a0)
ffffffffc020518e:	4108                	lw	a0,0(a0)
ffffffffc0205190:	bdbff06f          	j	ffffffffc0204d6a <do_wait>

ffffffffc0205194 <sys_fork>:
    struct trapframe *tf = current->tf;
ffffffffc0205194:	000a5797          	auipc	a5,0xa5
ffffffffc0205198:	67c7b783          	ld	a5,1660(a5) # ffffffffc02aa810 <current>
ffffffffc020519c:	73d0                	ld	a2,160(a5)
    return do_fork(0, stack, tf);
ffffffffc020519e:	4501                	li	a0,0
ffffffffc02051a0:	6a0c                	ld	a1,16(a2)
ffffffffc02051a2:	e21fe06f          	j	ffffffffc0203fc2 <do_fork>

ffffffffc02051a6 <sys_exit>:
    return do_exit(error_code);
ffffffffc02051a6:	4108                	lw	a0,0(a0)
ffffffffc02051a8:	a5aff06f          	j	ffffffffc0204402 <do_exit>

ffffffffc02051ac <syscall>:
};

#define NUM_SYSCALLS        ((sizeof(syscalls)) / (sizeof(syscalls[0])))

void
syscall(void) {
ffffffffc02051ac:	715d                	addi	sp,sp,-80
ffffffffc02051ae:	fc26                	sd	s1,56(sp)
    struct trapframe *tf = current->tf;
ffffffffc02051b0:	000a5497          	auipc	s1,0xa5
ffffffffc02051b4:	66048493          	addi	s1,s1,1632 # ffffffffc02aa810 <current>
ffffffffc02051b8:	6098                	ld	a4,0(s1)
syscall(void) {
ffffffffc02051ba:	e0a2                	sd	s0,64(sp)
ffffffffc02051bc:	f84a                	sd	s2,48(sp)
    struct trapframe *tf = current->tf;
ffffffffc02051be:	7340                	ld	s0,160(a4)
syscall(void) {
ffffffffc02051c0:	e486                	sd	ra,72(sp)
    uint64_t arg[5];
    int num = tf->gpr.a0;
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc02051c2:	47fd                	li	a5,31
    int num = tf->gpr.a0;
ffffffffc02051c4:	05042903          	lw	s2,80(s0)
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc02051c8:	0327ee63          	bltu	a5,s2,ffffffffc0205204 <syscall+0x58>
        if (syscalls[num] != NULL) {
ffffffffc02051cc:	00391713          	slli	a4,s2,0x3
ffffffffc02051d0:	00002797          	auipc	a5,0x2
ffffffffc02051d4:	28878793          	addi	a5,a5,648 # ffffffffc0207458 <syscalls>
ffffffffc02051d8:	97ba                	add	a5,a5,a4
ffffffffc02051da:	639c                	ld	a5,0(a5)
ffffffffc02051dc:	c785                	beqz	a5,ffffffffc0205204 <syscall+0x58>
            arg[0] = tf->gpr.a1;
ffffffffc02051de:	6c28                	ld	a0,88(s0)
            arg[1] = tf->gpr.a2;
ffffffffc02051e0:	702c                	ld	a1,96(s0)
            arg[2] = tf->gpr.a3;
ffffffffc02051e2:	7430                	ld	a2,104(s0)
            arg[3] = tf->gpr.a4;
ffffffffc02051e4:	7834                	ld	a3,112(s0)
            arg[4] = tf->gpr.a5;
ffffffffc02051e6:	7c38                	ld	a4,120(s0)
            arg[0] = tf->gpr.a1;
ffffffffc02051e8:	e42a                	sd	a0,8(sp)
            arg[1] = tf->gpr.a2;
ffffffffc02051ea:	e82e                	sd	a1,16(sp)
            arg[2] = tf->gpr.a3;
ffffffffc02051ec:	ec32                	sd	a2,24(sp)
            arg[3] = tf->gpr.a4;
ffffffffc02051ee:	f036                	sd	a3,32(sp)
            arg[4] = tf->gpr.a5;
ffffffffc02051f0:	f43a                	sd	a4,40(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc02051f2:	0028                	addi	a0,sp,8
ffffffffc02051f4:	9782                	jalr	a5
        }
    }
    print_trapframe(tf);
    panic("undefined syscall %d, pid = %d, name = %s.\n",
            num, current->pid, current->name);
}
ffffffffc02051f6:	60a6                	ld	ra,72(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc02051f8:	e828                	sd	a0,80(s0)
}
ffffffffc02051fa:	6406                	ld	s0,64(sp)
ffffffffc02051fc:	74e2                	ld	s1,56(sp)
ffffffffc02051fe:	7942                	ld	s2,48(sp)
ffffffffc0205200:	6161                	addi	sp,sp,80
ffffffffc0205202:	8082                	ret
    print_trapframe(tf);
ffffffffc0205204:	8522                	mv	a0,s0
ffffffffc0205206:	99ffb0ef          	jal	ra,ffffffffc0200ba4 <print_trapframe>
    panic("undefined syscall %d, pid = %d, name = %s.\n",
ffffffffc020520a:	609c                	ld	a5,0(s1)
ffffffffc020520c:	86ca                	mv	a3,s2
ffffffffc020520e:	00002617          	auipc	a2,0x2
ffffffffc0205212:	20260613          	addi	a2,a2,514 # ffffffffc0207410 <default_pmm_manager+0xed0>
ffffffffc0205216:	43d8                	lw	a4,4(a5)
ffffffffc0205218:	06200593          	li	a1,98
ffffffffc020521c:	0b478793          	addi	a5,a5,180
ffffffffc0205220:	00002517          	auipc	a0,0x2
ffffffffc0205224:	22050513          	addi	a0,a0,544 # ffffffffc0207440 <default_pmm_manager+0xf00>
ffffffffc0205228:	a66fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020522c <hash32>:
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
ffffffffc020522c:	9e3707b7          	lui	a5,0x9e370
ffffffffc0205230:	2785                	addiw	a5,a5,1
ffffffffc0205232:	02a7853b          	mulw	a0,a5,a0
    return (hash >> (32 - bits));
ffffffffc0205236:	02000793          	li	a5,32
ffffffffc020523a:	9f8d                	subw	a5,a5,a1
}
ffffffffc020523c:	00f5553b          	srlw	a0,a0,a5
ffffffffc0205240:	8082                	ret

ffffffffc0205242 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc0205242:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205246:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc0205248:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020524c:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc020524e:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205252:	f022                	sd	s0,32(sp)
ffffffffc0205254:	ec26                	sd	s1,24(sp)
ffffffffc0205256:	e84a                	sd	s2,16(sp)
ffffffffc0205258:	f406                	sd	ra,40(sp)
ffffffffc020525a:	e44e                	sd	s3,8(sp)
ffffffffc020525c:	84aa                	mv	s1,a0
ffffffffc020525e:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc0205260:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc0205264:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc0205266:	03067e63          	bgeu	a2,a6,ffffffffc02052a2 <printnum+0x60>
ffffffffc020526a:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc020526c:	00805763          	blez	s0,ffffffffc020527a <printnum+0x38>
ffffffffc0205270:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0205272:	85ca                	mv	a1,s2
ffffffffc0205274:	854e                	mv	a0,s3
ffffffffc0205276:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0205278:	fc65                	bnez	s0,ffffffffc0205270 <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020527a:	1a02                	slli	s4,s4,0x20
ffffffffc020527c:	00002797          	auipc	a5,0x2
ffffffffc0205280:	2dc78793          	addi	a5,a5,732 # ffffffffc0207558 <syscalls+0x100>
ffffffffc0205284:	020a5a13          	srli	s4,s4,0x20
ffffffffc0205288:	9a3e                	add	s4,s4,a5
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
ffffffffc020528a:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020528c:	000a4503          	lbu	a0,0(s4)
}
ffffffffc0205290:	70a2                	ld	ra,40(sp)
ffffffffc0205292:	69a2                	ld	s3,8(sp)
ffffffffc0205294:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205296:	85ca                	mv	a1,s2
ffffffffc0205298:	87a6                	mv	a5,s1
}
ffffffffc020529a:	6942                	ld	s2,16(sp)
ffffffffc020529c:	64e2                	ld	s1,24(sp)
ffffffffc020529e:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02052a0:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc02052a2:	03065633          	divu	a2,a2,a6
ffffffffc02052a6:	8722                	mv	a4,s0
ffffffffc02052a8:	f9bff0ef          	jal	ra,ffffffffc0205242 <printnum>
ffffffffc02052ac:	b7f9                	j	ffffffffc020527a <printnum+0x38>

ffffffffc02052ae <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc02052ae:	7119                	addi	sp,sp,-128
ffffffffc02052b0:	f4a6                	sd	s1,104(sp)
ffffffffc02052b2:	f0ca                	sd	s2,96(sp)
ffffffffc02052b4:	ecce                	sd	s3,88(sp)
ffffffffc02052b6:	e8d2                	sd	s4,80(sp)
ffffffffc02052b8:	e4d6                	sd	s5,72(sp)
ffffffffc02052ba:	e0da                	sd	s6,64(sp)
ffffffffc02052bc:	fc5e                	sd	s7,56(sp)
ffffffffc02052be:	f06a                	sd	s10,32(sp)
ffffffffc02052c0:	fc86                	sd	ra,120(sp)
ffffffffc02052c2:	f8a2                	sd	s0,112(sp)
ffffffffc02052c4:	f862                	sd	s8,48(sp)
ffffffffc02052c6:	f466                	sd	s9,40(sp)
ffffffffc02052c8:	ec6e                	sd	s11,24(sp)
ffffffffc02052ca:	892a                	mv	s2,a0
ffffffffc02052cc:	84ae                	mv	s1,a1
ffffffffc02052ce:	8d32                	mv	s10,a2
ffffffffc02052d0:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02052d2:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc02052d6:	5b7d                	li	s6,-1
ffffffffc02052d8:	00002a97          	auipc	s5,0x2
ffffffffc02052dc:	2aca8a93          	addi	s5,s5,684 # ffffffffc0207584 <syscalls+0x12c>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02052e0:	00002b97          	auipc	s7,0x2
ffffffffc02052e4:	4c0b8b93          	addi	s7,s7,1216 # ffffffffc02077a0 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02052e8:	000d4503          	lbu	a0,0(s10)
ffffffffc02052ec:	001d0413          	addi	s0,s10,1
ffffffffc02052f0:	01350a63          	beq	a0,s3,ffffffffc0205304 <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc02052f4:	c121                	beqz	a0,ffffffffc0205334 <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc02052f6:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02052f8:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc02052fa:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02052fc:	fff44503          	lbu	a0,-1(s0)
ffffffffc0205300:	ff351ae3          	bne	a0,s3,ffffffffc02052f4 <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205304:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc0205308:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc020530c:	4c81                	li	s9,0
ffffffffc020530e:	4881                	li	a7,0
        width = precision = -1;
ffffffffc0205310:	5c7d                	li	s8,-1
ffffffffc0205312:	5dfd                	li	s11,-1
ffffffffc0205314:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc0205318:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020531a:	fdd6059b          	addiw	a1,a2,-35
ffffffffc020531e:	0ff5f593          	zext.b	a1,a1
ffffffffc0205322:	00140d13          	addi	s10,s0,1
ffffffffc0205326:	04b56263          	bltu	a0,a1,ffffffffc020536a <vprintfmt+0xbc>
ffffffffc020532a:	058a                	slli	a1,a1,0x2
ffffffffc020532c:	95d6                	add	a1,a1,s5
ffffffffc020532e:	4194                	lw	a3,0(a1)
ffffffffc0205330:	96d6                	add	a3,a3,s5
ffffffffc0205332:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0205334:	70e6                	ld	ra,120(sp)
ffffffffc0205336:	7446                	ld	s0,112(sp)
ffffffffc0205338:	74a6                	ld	s1,104(sp)
ffffffffc020533a:	7906                	ld	s2,96(sp)
ffffffffc020533c:	69e6                	ld	s3,88(sp)
ffffffffc020533e:	6a46                	ld	s4,80(sp)
ffffffffc0205340:	6aa6                	ld	s5,72(sp)
ffffffffc0205342:	6b06                	ld	s6,64(sp)
ffffffffc0205344:	7be2                	ld	s7,56(sp)
ffffffffc0205346:	7c42                	ld	s8,48(sp)
ffffffffc0205348:	7ca2                	ld	s9,40(sp)
ffffffffc020534a:	7d02                	ld	s10,32(sp)
ffffffffc020534c:	6de2                	ld	s11,24(sp)
ffffffffc020534e:	6109                	addi	sp,sp,128
ffffffffc0205350:	8082                	ret
            padc = '0';
ffffffffc0205352:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc0205354:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205358:	846a                	mv	s0,s10
ffffffffc020535a:	00140d13          	addi	s10,s0,1
ffffffffc020535e:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0205362:	0ff5f593          	zext.b	a1,a1
ffffffffc0205366:	fcb572e3          	bgeu	a0,a1,ffffffffc020532a <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc020536a:	85a6                	mv	a1,s1
ffffffffc020536c:	02500513          	li	a0,37
ffffffffc0205370:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0205372:	fff44783          	lbu	a5,-1(s0)
ffffffffc0205376:	8d22                	mv	s10,s0
ffffffffc0205378:	f73788e3          	beq	a5,s3,ffffffffc02052e8 <vprintfmt+0x3a>
ffffffffc020537c:	ffed4783          	lbu	a5,-2(s10)
ffffffffc0205380:	1d7d                	addi	s10,s10,-1
ffffffffc0205382:	ff379de3          	bne	a5,s3,ffffffffc020537c <vprintfmt+0xce>
ffffffffc0205386:	b78d                	j	ffffffffc02052e8 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc0205388:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc020538c:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205390:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc0205392:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc0205396:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc020539a:	02d86463          	bltu	a6,a3,ffffffffc02053c2 <vprintfmt+0x114>
                ch = *fmt;
ffffffffc020539e:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc02053a2:	002c169b          	slliw	a3,s8,0x2
ffffffffc02053a6:	0186873b          	addw	a4,a3,s8
ffffffffc02053aa:	0017171b          	slliw	a4,a4,0x1
ffffffffc02053ae:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc02053b0:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc02053b4:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc02053b6:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc02053ba:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc02053be:	fed870e3          	bgeu	a6,a3,ffffffffc020539e <vprintfmt+0xf0>
            if (width < 0)
ffffffffc02053c2:	f40ddce3          	bgez	s11,ffffffffc020531a <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc02053c6:	8de2                	mv	s11,s8
ffffffffc02053c8:	5c7d                	li	s8,-1
ffffffffc02053ca:	bf81                	j	ffffffffc020531a <vprintfmt+0x6c>
            if (width < 0)
ffffffffc02053cc:	fffdc693          	not	a3,s11
ffffffffc02053d0:	96fd                	srai	a3,a3,0x3f
ffffffffc02053d2:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02053d6:	00144603          	lbu	a2,1(s0)
ffffffffc02053da:	2d81                	sext.w	s11,s11
ffffffffc02053dc:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc02053de:	bf35                	j	ffffffffc020531a <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc02053e0:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02053e4:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc02053e8:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02053ea:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc02053ec:	bfd9                	j	ffffffffc02053c2 <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc02053ee:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02053f0:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02053f4:	01174463          	blt	a4,a7,ffffffffc02053fc <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc02053f8:	1a088e63          	beqz	a7,ffffffffc02055b4 <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc02053fc:	000a3603          	ld	a2,0(s4)
ffffffffc0205400:	46c1                	li	a3,16
ffffffffc0205402:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0205404:	2781                	sext.w	a5,a5
ffffffffc0205406:	876e                	mv	a4,s11
ffffffffc0205408:	85a6                	mv	a1,s1
ffffffffc020540a:	854a                	mv	a0,s2
ffffffffc020540c:	e37ff0ef          	jal	ra,ffffffffc0205242 <printnum>
            break;
ffffffffc0205410:	bde1                	j	ffffffffc02052e8 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc0205412:	000a2503          	lw	a0,0(s4)
ffffffffc0205416:	85a6                	mv	a1,s1
ffffffffc0205418:	0a21                	addi	s4,s4,8
ffffffffc020541a:	9902                	jalr	s2
            break;
ffffffffc020541c:	b5f1                	j	ffffffffc02052e8 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc020541e:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0205420:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0205424:	01174463          	blt	a4,a7,ffffffffc020542c <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc0205428:	18088163          	beqz	a7,ffffffffc02055aa <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc020542c:	000a3603          	ld	a2,0(s4)
ffffffffc0205430:	46a9                	li	a3,10
ffffffffc0205432:	8a2e                	mv	s4,a1
ffffffffc0205434:	bfc1                	j	ffffffffc0205404 <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205436:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc020543a:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020543c:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc020543e:	bdf1                	j	ffffffffc020531a <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc0205440:	85a6                	mv	a1,s1
ffffffffc0205442:	02500513          	li	a0,37
ffffffffc0205446:	9902                	jalr	s2
            break;
ffffffffc0205448:	b545                	j	ffffffffc02052e8 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020544a:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc020544e:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205450:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0205452:	b5e1                	j	ffffffffc020531a <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc0205454:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0205456:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc020545a:	01174463          	blt	a4,a7,ffffffffc0205462 <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc020545e:	14088163          	beqz	a7,ffffffffc02055a0 <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc0205462:	000a3603          	ld	a2,0(s4)
ffffffffc0205466:	46a1                	li	a3,8
ffffffffc0205468:	8a2e                	mv	s4,a1
ffffffffc020546a:	bf69                	j	ffffffffc0205404 <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc020546c:	03000513          	li	a0,48
ffffffffc0205470:	85a6                	mv	a1,s1
ffffffffc0205472:	e03e                	sd	a5,0(sp)
ffffffffc0205474:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc0205476:	85a6                	mv	a1,s1
ffffffffc0205478:	07800513          	li	a0,120
ffffffffc020547c:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc020547e:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc0205480:	6782                	ld	a5,0(sp)
ffffffffc0205482:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0205484:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc0205488:	bfb5                	j	ffffffffc0205404 <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc020548a:	000a3403          	ld	s0,0(s4)
ffffffffc020548e:	008a0713          	addi	a4,s4,8
ffffffffc0205492:	e03a                	sd	a4,0(sp)
ffffffffc0205494:	14040263          	beqz	s0,ffffffffc02055d8 <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc0205498:	0fb05763          	blez	s11,ffffffffc0205586 <vprintfmt+0x2d8>
ffffffffc020549c:	02d00693          	li	a3,45
ffffffffc02054a0:	0cd79163          	bne	a5,a3,ffffffffc0205562 <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02054a4:	00044783          	lbu	a5,0(s0)
ffffffffc02054a8:	0007851b          	sext.w	a0,a5
ffffffffc02054ac:	cf85                	beqz	a5,ffffffffc02054e4 <vprintfmt+0x236>
ffffffffc02054ae:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02054b2:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02054b6:	000c4563          	bltz	s8,ffffffffc02054c0 <vprintfmt+0x212>
ffffffffc02054ba:	3c7d                	addiw	s8,s8,-1
ffffffffc02054bc:	036c0263          	beq	s8,s6,ffffffffc02054e0 <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc02054c0:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02054c2:	0e0c8e63          	beqz	s9,ffffffffc02055be <vprintfmt+0x310>
ffffffffc02054c6:	3781                	addiw	a5,a5,-32
ffffffffc02054c8:	0ef47b63          	bgeu	s0,a5,ffffffffc02055be <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc02054cc:	03f00513          	li	a0,63
ffffffffc02054d0:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02054d2:	000a4783          	lbu	a5,0(s4)
ffffffffc02054d6:	3dfd                	addiw	s11,s11,-1
ffffffffc02054d8:	0a05                	addi	s4,s4,1
ffffffffc02054da:	0007851b          	sext.w	a0,a5
ffffffffc02054de:	ffe1                	bnez	a5,ffffffffc02054b6 <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc02054e0:	01b05963          	blez	s11,ffffffffc02054f2 <vprintfmt+0x244>
ffffffffc02054e4:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc02054e6:	85a6                	mv	a1,s1
ffffffffc02054e8:	02000513          	li	a0,32
ffffffffc02054ec:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc02054ee:	fe0d9be3          	bnez	s11,ffffffffc02054e4 <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc02054f2:	6a02                	ld	s4,0(sp)
ffffffffc02054f4:	bbd5                	j	ffffffffc02052e8 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc02054f6:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02054f8:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc02054fc:	01174463          	blt	a4,a7,ffffffffc0205504 <vprintfmt+0x256>
    else if (lflag) {
ffffffffc0205500:	08088d63          	beqz	a7,ffffffffc020559a <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc0205504:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0205508:	0a044d63          	bltz	s0,ffffffffc02055c2 <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc020550c:	8622                	mv	a2,s0
ffffffffc020550e:	8a66                	mv	s4,s9
ffffffffc0205510:	46a9                	li	a3,10
ffffffffc0205512:	bdcd                	j	ffffffffc0205404 <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc0205514:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0205518:	4761                	li	a4,24
            err = va_arg(ap, int);
ffffffffc020551a:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc020551c:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc0205520:	8fb5                	xor	a5,a5,a3
ffffffffc0205522:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0205526:	02d74163          	blt	a4,a3,ffffffffc0205548 <vprintfmt+0x29a>
ffffffffc020552a:	00369793          	slli	a5,a3,0x3
ffffffffc020552e:	97de                	add	a5,a5,s7
ffffffffc0205530:	639c                	ld	a5,0(a5)
ffffffffc0205532:	cb99                	beqz	a5,ffffffffc0205548 <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc0205534:	86be                	mv	a3,a5
ffffffffc0205536:	00000617          	auipc	a2,0x0
ffffffffc020553a:	1f260613          	addi	a2,a2,498 # ffffffffc0205728 <etext+0x2c>
ffffffffc020553e:	85a6                	mv	a1,s1
ffffffffc0205540:	854a                	mv	a0,s2
ffffffffc0205542:	0ce000ef          	jal	ra,ffffffffc0205610 <printfmt>
ffffffffc0205546:	b34d                	j	ffffffffc02052e8 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0205548:	00002617          	auipc	a2,0x2
ffffffffc020554c:	03060613          	addi	a2,a2,48 # ffffffffc0207578 <syscalls+0x120>
ffffffffc0205550:	85a6                	mv	a1,s1
ffffffffc0205552:	854a                	mv	a0,s2
ffffffffc0205554:	0bc000ef          	jal	ra,ffffffffc0205610 <printfmt>
ffffffffc0205558:	bb41                	j	ffffffffc02052e8 <vprintfmt+0x3a>
                p = "(null)";
ffffffffc020555a:	00002417          	auipc	s0,0x2
ffffffffc020555e:	01640413          	addi	s0,s0,22 # ffffffffc0207570 <syscalls+0x118>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205562:	85e2                	mv	a1,s8
ffffffffc0205564:	8522                	mv	a0,s0
ffffffffc0205566:	e43e                	sd	a5,8(sp)
ffffffffc0205568:	0e2000ef          	jal	ra,ffffffffc020564a <strnlen>
ffffffffc020556c:	40ad8dbb          	subw	s11,s11,a0
ffffffffc0205570:	01b05b63          	blez	s11,ffffffffc0205586 <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc0205574:	67a2                	ld	a5,8(sp)
ffffffffc0205576:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020557a:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc020557c:	85a6                	mv	a1,s1
ffffffffc020557e:	8552                	mv	a0,s4
ffffffffc0205580:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205582:	fe0d9ce3          	bnez	s11,ffffffffc020557a <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205586:	00044783          	lbu	a5,0(s0)
ffffffffc020558a:	00140a13          	addi	s4,s0,1
ffffffffc020558e:	0007851b          	sext.w	a0,a5
ffffffffc0205592:	d3a5                	beqz	a5,ffffffffc02054f2 <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0205594:	05e00413          	li	s0,94
ffffffffc0205598:	bf39                	j	ffffffffc02054b6 <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc020559a:	000a2403          	lw	s0,0(s4)
ffffffffc020559e:	b7ad                	j	ffffffffc0205508 <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc02055a0:	000a6603          	lwu	a2,0(s4)
ffffffffc02055a4:	46a1                	li	a3,8
ffffffffc02055a6:	8a2e                	mv	s4,a1
ffffffffc02055a8:	bdb1                	j	ffffffffc0205404 <vprintfmt+0x156>
ffffffffc02055aa:	000a6603          	lwu	a2,0(s4)
ffffffffc02055ae:	46a9                	li	a3,10
ffffffffc02055b0:	8a2e                	mv	s4,a1
ffffffffc02055b2:	bd89                	j	ffffffffc0205404 <vprintfmt+0x156>
ffffffffc02055b4:	000a6603          	lwu	a2,0(s4)
ffffffffc02055b8:	46c1                	li	a3,16
ffffffffc02055ba:	8a2e                	mv	s4,a1
ffffffffc02055bc:	b5a1                	j	ffffffffc0205404 <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc02055be:	9902                	jalr	s2
ffffffffc02055c0:	bf09                	j	ffffffffc02054d2 <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc02055c2:	85a6                	mv	a1,s1
ffffffffc02055c4:	02d00513          	li	a0,45
ffffffffc02055c8:	e03e                	sd	a5,0(sp)
ffffffffc02055ca:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc02055cc:	6782                	ld	a5,0(sp)
ffffffffc02055ce:	8a66                	mv	s4,s9
ffffffffc02055d0:	40800633          	neg	a2,s0
ffffffffc02055d4:	46a9                	li	a3,10
ffffffffc02055d6:	b53d                	j	ffffffffc0205404 <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc02055d8:	03b05163          	blez	s11,ffffffffc02055fa <vprintfmt+0x34c>
ffffffffc02055dc:	02d00693          	li	a3,45
ffffffffc02055e0:	f6d79de3          	bne	a5,a3,ffffffffc020555a <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc02055e4:	00002417          	auipc	s0,0x2
ffffffffc02055e8:	f8c40413          	addi	s0,s0,-116 # ffffffffc0207570 <syscalls+0x118>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02055ec:	02800793          	li	a5,40
ffffffffc02055f0:	02800513          	li	a0,40
ffffffffc02055f4:	00140a13          	addi	s4,s0,1
ffffffffc02055f8:	bd6d                	j	ffffffffc02054b2 <vprintfmt+0x204>
ffffffffc02055fa:	00002a17          	auipc	s4,0x2
ffffffffc02055fe:	f77a0a13          	addi	s4,s4,-137 # ffffffffc0207571 <syscalls+0x119>
ffffffffc0205602:	02800513          	li	a0,40
ffffffffc0205606:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc020560a:	05e00413          	li	s0,94
ffffffffc020560e:	b565                	j	ffffffffc02054b6 <vprintfmt+0x208>

ffffffffc0205610 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0205610:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0205612:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0205616:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0205618:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc020561a:	ec06                	sd	ra,24(sp)
ffffffffc020561c:	f83a                	sd	a4,48(sp)
ffffffffc020561e:	fc3e                	sd	a5,56(sp)
ffffffffc0205620:	e0c2                	sd	a6,64(sp)
ffffffffc0205622:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0205624:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0205626:	c89ff0ef          	jal	ra,ffffffffc02052ae <vprintfmt>
}
ffffffffc020562a:	60e2                	ld	ra,24(sp)
ffffffffc020562c:	6161                	addi	sp,sp,80
ffffffffc020562e:	8082                	ret

ffffffffc0205630 <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc0205630:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc0205634:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc0205636:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc0205638:	cb81                	beqz	a5,ffffffffc0205648 <strlen+0x18>
        cnt ++;
ffffffffc020563a:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc020563c:	00a707b3          	add	a5,a4,a0
ffffffffc0205640:	0007c783          	lbu	a5,0(a5)
ffffffffc0205644:	fbfd                	bnez	a5,ffffffffc020563a <strlen+0xa>
ffffffffc0205646:	8082                	ret
    }
    return cnt;
}
ffffffffc0205648:	8082                	ret

ffffffffc020564a <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc020564a:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc020564c:	e589                	bnez	a1,ffffffffc0205656 <strnlen+0xc>
ffffffffc020564e:	a811                	j	ffffffffc0205662 <strnlen+0x18>
        cnt ++;
ffffffffc0205650:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0205652:	00f58863          	beq	a1,a5,ffffffffc0205662 <strnlen+0x18>
ffffffffc0205656:	00f50733          	add	a4,a0,a5
ffffffffc020565a:	00074703          	lbu	a4,0(a4)
ffffffffc020565e:	fb6d                	bnez	a4,ffffffffc0205650 <strnlen+0x6>
ffffffffc0205660:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc0205662:	852e                	mv	a0,a1
ffffffffc0205664:	8082                	ret

ffffffffc0205666 <strcpy>:
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
ffffffffc0205666:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc0205668:	0005c703          	lbu	a4,0(a1)
ffffffffc020566c:	0785                	addi	a5,a5,1
ffffffffc020566e:	0585                	addi	a1,a1,1
ffffffffc0205670:	fee78fa3          	sb	a4,-1(a5)
ffffffffc0205674:	fb75                	bnez	a4,ffffffffc0205668 <strcpy+0x2>
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
ffffffffc0205676:	8082                	ret

ffffffffc0205678 <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0205678:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc020567c:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0205680:	cb89                	beqz	a5,ffffffffc0205692 <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc0205682:	0505                	addi	a0,a0,1
ffffffffc0205684:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0205686:	fee789e3          	beq	a5,a4,ffffffffc0205678 <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc020568a:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc020568e:	9d19                	subw	a0,a0,a4
ffffffffc0205690:	8082                	ret
ffffffffc0205692:	4501                	li	a0,0
ffffffffc0205694:	bfed                	j	ffffffffc020568e <strcmp+0x16>

ffffffffc0205696 <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0205696:	c20d                	beqz	a2,ffffffffc02056b8 <strncmp+0x22>
ffffffffc0205698:	962e                	add	a2,a2,a1
ffffffffc020569a:	a031                	j	ffffffffc02056a6 <strncmp+0x10>
        n --, s1 ++, s2 ++;
ffffffffc020569c:	0505                	addi	a0,a0,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc020569e:	00e79a63          	bne	a5,a4,ffffffffc02056b2 <strncmp+0x1c>
ffffffffc02056a2:	00b60b63          	beq	a2,a1,ffffffffc02056b8 <strncmp+0x22>
ffffffffc02056a6:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc02056aa:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc02056ac:	fff5c703          	lbu	a4,-1(a1)
ffffffffc02056b0:	f7f5                	bnez	a5,ffffffffc020569c <strncmp+0x6>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02056b2:	40e7853b          	subw	a0,a5,a4
}
ffffffffc02056b6:	8082                	ret
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02056b8:	4501                	li	a0,0
ffffffffc02056ba:	8082                	ret

ffffffffc02056bc <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc02056bc:	00054783          	lbu	a5,0(a0)
ffffffffc02056c0:	c799                	beqz	a5,ffffffffc02056ce <strchr+0x12>
        if (*s == c) {
ffffffffc02056c2:	00f58763          	beq	a1,a5,ffffffffc02056d0 <strchr+0x14>
    while (*s != '\0') {
ffffffffc02056c6:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc02056ca:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc02056cc:	fbfd                	bnez	a5,ffffffffc02056c2 <strchr+0x6>
    }
    return NULL;
ffffffffc02056ce:	4501                	li	a0,0
}
ffffffffc02056d0:	8082                	ret

ffffffffc02056d2 <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc02056d2:	ca01                	beqz	a2,ffffffffc02056e2 <memset+0x10>
ffffffffc02056d4:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc02056d6:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc02056d8:	0785                	addi	a5,a5,1
ffffffffc02056da:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc02056de:	fec79de3          	bne	a5,a2,ffffffffc02056d8 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc02056e2:	8082                	ret

ffffffffc02056e4 <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc02056e4:	ca19                	beqz	a2,ffffffffc02056fa <memcpy+0x16>
ffffffffc02056e6:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc02056e8:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc02056ea:	0005c703          	lbu	a4,0(a1)
ffffffffc02056ee:	0585                	addi	a1,a1,1
ffffffffc02056f0:	0785                	addi	a5,a5,1
ffffffffc02056f2:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc02056f6:	fec59ae3          	bne	a1,a2,ffffffffc02056ea <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc02056fa:	8082                	ret
