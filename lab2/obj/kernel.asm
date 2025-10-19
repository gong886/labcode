
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
    .globl kern_entry
kern_entry:
    # a0: hartid
    # a1: dtb physical address
    # save hartid and dtb address
    la t0, boot_hartid
ffffffffc0200000:	00005297          	auipc	t0,0x5
ffffffffc0200004:	00028293          	mv	t0,t0
    sd a0, 0(t0)
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc0205000 <boot_hartid>
    la t0, boot_dtb
ffffffffc020000c:	00005297          	auipc	t0,0x5
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc0205008 <boot_dtb>
    sd a1, 0(t0)
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)

    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200018:	c02042b7          	lui	t0,0xc0204
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
ffffffffc020003c:	c0204137          	lui	sp,0xc0204

    # 我们在虚拟内存空间中：随意跳转到虚拟地址！
    # 跳转到 kern_init
    lui t0, %hi(kern_init)
ffffffffc0200040:	c02002b7          	lui	t0,0xc0200
    addi t0, t0, %lo(kern_init)
ffffffffc0200044:	0d828293          	addi	t0,t0,216 # ffffffffc02000d8 <kern_init>
    jr t0
ffffffffc0200048:	8282                	jr	t0

ffffffffc020004a <print_kerninfo>:
/* *
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void) {
ffffffffc020004a:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[];
    cprintf("Special kernel symbols:\n");
ffffffffc020004c:	00001517          	auipc	a0,0x1
ffffffffc0200050:	29450513          	addi	a0,a0,660 # ffffffffc02012e0 <etext>
void print_kerninfo(void) {
ffffffffc0200054:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200056:	0f6000ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("  entry  0x%016lx (virtual)\n", (uintptr_t)kern_init);
ffffffffc020005a:	00000597          	auipc	a1,0x0
ffffffffc020005e:	07e58593          	addi	a1,a1,126 # ffffffffc02000d8 <kern_init>
ffffffffc0200062:	00001517          	auipc	a0,0x1
ffffffffc0200066:	29e50513          	addi	a0,a0,670 # ffffffffc0201300 <etext+0x20>
ffffffffc020006a:	0e2000ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("  etext  0x%016lx (virtual)\n", etext);
ffffffffc020006e:	00001597          	auipc	a1,0x1
ffffffffc0200072:	27258593          	addi	a1,a1,626 # ffffffffc02012e0 <etext>
ffffffffc0200076:	00001517          	auipc	a0,0x1
ffffffffc020007a:	2aa50513          	addi	a0,a0,682 # ffffffffc0201320 <etext+0x40>
ffffffffc020007e:	0ce000ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("  edata  0x%016lx (virtual)\n", edata);
ffffffffc0200082:	00005597          	auipc	a1,0x5
ffffffffc0200086:	f9658593          	addi	a1,a1,-106 # ffffffffc0205018 <buddy_area>
ffffffffc020008a:	00001517          	auipc	a0,0x1
ffffffffc020008e:	2b650513          	addi	a0,a0,694 # ffffffffc0201340 <etext+0x60>
ffffffffc0200092:	0ba000ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("  end    0x%016lx (virtual)\n", end);
ffffffffc0200096:	00005597          	auipc	a1,0x5
ffffffffc020009a:	16258593          	addi	a1,a1,354 # ffffffffc02051f8 <end>
ffffffffc020009e:	00001517          	auipc	a0,0x1
ffffffffc02000a2:	2c250513          	addi	a0,a0,706 # ffffffffc0201360 <etext+0x80>
ffffffffc02000a6:	0a6000ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - (char*)kern_init + 1023) / 1024);
ffffffffc02000aa:	00005597          	auipc	a1,0x5
ffffffffc02000ae:	54d58593          	addi	a1,a1,1357 # ffffffffc02055f7 <end+0x3ff>
ffffffffc02000b2:	00000797          	auipc	a5,0x0
ffffffffc02000b6:	02678793          	addi	a5,a5,38 # ffffffffc02000d8 <kern_init>
ffffffffc02000ba:	40f587b3          	sub	a5,a1,a5
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02000be:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc02000c2:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02000c4:	3ff5f593          	andi	a1,a1,1023
ffffffffc02000c8:	95be                	add	a1,a1,a5
ffffffffc02000ca:	85a9                	srai	a1,a1,0xa
ffffffffc02000cc:	00001517          	auipc	a0,0x1
ffffffffc02000d0:	2b450513          	addi	a0,a0,692 # ffffffffc0201380 <etext+0xa0>
}
ffffffffc02000d4:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02000d6:	a89d                	j	ffffffffc020014c <cprintf>

ffffffffc02000d8 <kern_init>:

int kern_init(void) {
    extern char edata[], end[];
    memset(edata, 0, end - edata);
ffffffffc02000d8:	00005517          	auipc	a0,0x5
ffffffffc02000dc:	f4050513          	addi	a0,a0,-192 # ffffffffc0205018 <buddy_area>
ffffffffc02000e0:	00005617          	auipc	a2,0x5
ffffffffc02000e4:	11860613          	addi	a2,a2,280 # ffffffffc02051f8 <end>
int kern_init(void) {
ffffffffc02000e8:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc02000ea:	8e09                	sub	a2,a2,a0
ffffffffc02000ec:	4581                	li	a1,0
int kern_init(void) {
ffffffffc02000ee:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc02000f0:	1de010ef          	jal	ra,ffffffffc02012ce <memset>
    dtb_init();
ffffffffc02000f4:	12c000ef          	jal	ra,ffffffffc0200220 <dtb_init>
    cons_init();  // init the console
ffffffffc02000f8:	11e000ef          	jal	ra,ffffffffc0200216 <cons_init>
    const char *message = "(THU.CST) os is loading ...\0";
    //cprintf("%s\n\n", message);
    cputs(message);
ffffffffc02000fc:	00001517          	auipc	a0,0x1
ffffffffc0200100:	2b450513          	addi	a0,a0,692 # ffffffffc02013b0 <etext+0xd0>
ffffffffc0200104:	07e000ef          	jal	ra,ffffffffc0200182 <cputs>

    print_kerninfo();
ffffffffc0200108:	f43ff0ef          	jal	ra,ffffffffc020004a <print_kerninfo>

    // grade_backtrace();
    pmm_init();  // init physical memory management
ffffffffc020010c:	369000ef          	jal	ra,ffffffffc0200c74 <pmm_init>

    /* do nothing */
    while (1)
ffffffffc0200110:	a001                	j	ffffffffc0200110 <kern_init+0x38>

ffffffffc0200112 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
ffffffffc0200112:	1141                	addi	sp,sp,-16
ffffffffc0200114:	e022                	sd	s0,0(sp)
ffffffffc0200116:	e406                	sd	ra,8(sp)
ffffffffc0200118:	842e                	mv	s0,a1
    cons_putc(c);
ffffffffc020011a:	0fe000ef          	jal	ra,ffffffffc0200218 <cons_putc>
    (*cnt) ++;
ffffffffc020011e:	401c                	lw	a5,0(s0)
}
ffffffffc0200120:	60a2                	ld	ra,8(sp)
    (*cnt) ++;
ffffffffc0200122:	2785                	addiw	a5,a5,1
ffffffffc0200124:	c01c                	sw	a5,0(s0)
}
ffffffffc0200126:	6402                	ld	s0,0(sp)
ffffffffc0200128:	0141                	addi	sp,sp,16
ffffffffc020012a:	8082                	ret

ffffffffc020012c <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
ffffffffc020012c:	1101                	addi	sp,sp,-32
ffffffffc020012e:	862a                	mv	a2,a0
ffffffffc0200130:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc0200132:	00000517          	auipc	a0,0x0
ffffffffc0200136:	fe050513          	addi	a0,a0,-32 # ffffffffc0200112 <cputch>
ffffffffc020013a:	006c                	addi	a1,sp,12
vcprintf(const char *fmt, va_list ap) {
ffffffffc020013c:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc020013e:	c602                	sw	zero,12(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc0200140:	579000ef          	jal	ra,ffffffffc0200eb8 <vprintfmt>
    return cnt;
}
ffffffffc0200144:	60e2                	ld	ra,24(sp)
ffffffffc0200146:	4532                	lw	a0,12(sp)
ffffffffc0200148:	6105                	addi	sp,sp,32
ffffffffc020014a:	8082                	ret

ffffffffc020014c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
ffffffffc020014c:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc020014e:	02810313          	addi	t1,sp,40 # ffffffffc0204028 <boot_page_table_sv39+0x28>
cprintf(const char *fmt, ...) {
ffffffffc0200152:	8e2a                	mv	t3,a0
ffffffffc0200154:	f42e                	sd	a1,40(sp)
ffffffffc0200156:	f832                	sd	a2,48(sp)
ffffffffc0200158:	fc36                	sd	a3,56(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc020015a:	00000517          	auipc	a0,0x0
ffffffffc020015e:	fb850513          	addi	a0,a0,-72 # ffffffffc0200112 <cputch>
ffffffffc0200162:	004c                	addi	a1,sp,4
ffffffffc0200164:	869a                	mv	a3,t1
ffffffffc0200166:	8672                	mv	a2,t3
cprintf(const char *fmt, ...) {
ffffffffc0200168:	ec06                	sd	ra,24(sp)
ffffffffc020016a:	e0ba                	sd	a4,64(sp)
ffffffffc020016c:	e4be                	sd	a5,72(sp)
ffffffffc020016e:	e8c2                	sd	a6,80(sp)
ffffffffc0200170:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
ffffffffc0200172:	e41a                	sd	t1,8(sp)
    int cnt = 0;
ffffffffc0200174:	c202                	sw	zero,4(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc0200176:	543000ef          	jal	ra,ffffffffc0200eb8 <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc020017a:	60e2                	ld	ra,24(sp)
ffffffffc020017c:	4512                	lw	a0,4(sp)
ffffffffc020017e:	6125                	addi	sp,sp,96
ffffffffc0200180:	8082                	ret

ffffffffc0200182 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
ffffffffc0200182:	1101                	addi	sp,sp,-32
ffffffffc0200184:	e822                	sd	s0,16(sp)
ffffffffc0200186:	ec06                	sd	ra,24(sp)
ffffffffc0200188:	e426                	sd	s1,8(sp)
ffffffffc020018a:	842a                	mv	s0,a0
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
ffffffffc020018c:	00054503          	lbu	a0,0(a0)
ffffffffc0200190:	c51d                	beqz	a0,ffffffffc02001be <cputs+0x3c>
ffffffffc0200192:	0405                	addi	s0,s0,1
ffffffffc0200194:	4485                	li	s1,1
ffffffffc0200196:	9c81                	subw	s1,s1,s0
    cons_putc(c);
ffffffffc0200198:	080000ef          	jal	ra,ffffffffc0200218 <cons_putc>
    while ((c = *str ++) != '\0') {
ffffffffc020019c:	00044503          	lbu	a0,0(s0)
ffffffffc02001a0:	008487bb          	addw	a5,s1,s0
ffffffffc02001a4:	0405                	addi	s0,s0,1
ffffffffc02001a6:	f96d                	bnez	a0,ffffffffc0200198 <cputs+0x16>
    (*cnt) ++;
ffffffffc02001a8:	0017841b          	addiw	s0,a5,1
    cons_putc(c);
ffffffffc02001ac:	4529                	li	a0,10
ffffffffc02001ae:	06a000ef          	jal	ra,ffffffffc0200218 <cons_putc>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
ffffffffc02001b2:	60e2                	ld	ra,24(sp)
ffffffffc02001b4:	8522                	mv	a0,s0
ffffffffc02001b6:	6442                	ld	s0,16(sp)
ffffffffc02001b8:	64a2                	ld	s1,8(sp)
ffffffffc02001ba:	6105                	addi	sp,sp,32
ffffffffc02001bc:	8082                	ret
    while ((c = *str ++) != '\0') {
ffffffffc02001be:	4405                	li	s0,1
ffffffffc02001c0:	b7f5                	j	ffffffffc02001ac <cputs+0x2a>

ffffffffc02001c2 <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
ffffffffc02001c2:	00005317          	auipc	t1,0x5
ffffffffc02001c6:	fd630313          	addi	t1,t1,-42 # ffffffffc0205198 <is_panic>
ffffffffc02001ca:	00032e03          	lw	t3,0(t1)
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc02001ce:	715d                	addi	sp,sp,-80
ffffffffc02001d0:	ec06                	sd	ra,24(sp)
ffffffffc02001d2:	e822                	sd	s0,16(sp)
ffffffffc02001d4:	f436                	sd	a3,40(sp)
ffffffffc02001d6:	f83a                	sd	a4,48(sp)
ffffffffc02001d8:	fc3e                	sd	a5,56(sp)
ffffffffc02001da:	e0c2                	sd	a6,64(sp)
ffffffffc02001dc:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc02001de:	000e0363          	beqz	t3,ffffffffc02001e4 <__panic+0x22>
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);

panic_dead:
    while (1) {
ffffffffc02001e2:	a001                	j	ffffffffc02001e2 <__panic+0x20>
    is_panic = 1;
ffffffffc02001e4:	4785                	li	a5,1
ffffffffc02001e6:	00f32023          	sw	a5,0(t1)
    va_start(ap, fmt);
ffffffffc02001ea:	8432                	mv	s0,a2
ffffffffc02001ec:	103c                	addi	a5,sp,40
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02001ee:	862e                	mv	a2,a1
ffffffffc02001f0:	85aa                	mv	a1,a0
ffffffffc02001f2:	00001517          	auipc	a0,0x1
ffffffffc02001f6:	1de50513          	addi	a0,a0,478 # ffffffffc02013d0 <etext+0xf0>
    va_start(ap, fmt);
ffffffffc02001fa:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02001fc:	f51ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    vcprintf(fmt, ap);
ffffffffc0200200:	65a2                	ld	a1,8(sp)
ffffffffc0200202:	8522                	mv	a0,s0
ffffffffc0200204:	f29ff0ef          	jal	ra,ffffffffc020012c <vcprintf>
    cprintf("\n");
ffffffffc0200208:	00001517          	auipc	a0,0x1
ffffffffc020020c:	1a050513          	addi	a0,a0,416 # ffffffffc02013a8 <etext+0xc8>
ffffffffc0200210:	f3dff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200214:	b7f9                	j	ffffffffc02001e2 <__panic+0x20>

ffffffffc0200216 <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc0200216:	8082                	ret

ffffffffc0200218 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) { sbi_console_putchar((unsigned char)c); }
ffffffffc0200218:	0ff57513          	zext.b	a0,a0
ffffffffc020021c:	01e0106f          	j	ffffffffc020123a <sbi_console_putchar>

ffffffffc0200220 <dtb_init>:

// 保存解析出的系统物理内存信息
static uint64_t memory_base = 0;
static uint64_t memory_size = 0;

void dtb_init(void) {
ffffffffc0200220:	7119                	addi	sp,sp,-128
    cprintf("DTB Init\n");
ffffffffc0200222:	00001517          	auipc	a0,0x1
ffffffffc0200226:	1ce50513          	addi	a0,a0,462 # ffffffffc02013f0 <etext+0x110>
void dtb_init(void) {
ffffffffc020022a:	fc86                	sd	ra,120(sp)
ffffffffc020022c:	f8a2                	sd	s0,112(sp)
ffffffffc020022e:	e8d2                	sd	s4,80(sp)
ffffffffc0200230:	f4a6                	sd	s1,104(sp)
ffffffffc0200232:	f0ca                	sd	s2,96(sp)
ffffffffc0200234:	ecce                	sd	s3,88(sp)
ffffffffc0200236:	e4d6                	sd	s5,72(sp)
ffffffffc0200238:	e0da                	sd	s6,64(sp)
ffffffffc020023a:	fc5e                	sd	s7,56(sp)
ffffffffc020023c:	f862                	sd	s8,48(sp)
ffffffffc020023e:	f466                	sd	s9,40(sp)
ffffffffc0200240:	f06a                	sd	s10,32(sp)
ffffffffc0200242:	ec6e                	sd	s11,24(sp)
    cprintf("DTB Init\n");
ffffffffc0200244:	f09ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc0200248:	00005597          	auipc	a1,0x5
ffffffffc020024c:	db85b583          	ld	a1,-584(a1) # ffffffffc0205000 <boot_hartid>
ffffffffc0200250:	00001517          	auipc	a0,0x1
ffffffffc0200254:	1b050513          	addi	a0,a0,432 # ffffffffc0201400 <etext+0x120>
ffffffffc0200258:	ef5ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc020025c:	00005417          	auipc	s0,0x5
ffffffffc0200260:	dac40413          	addi	s0,s0,-596 # ffffffffc0205008 <boot_dtb>
ffffffffc0200264:	600c                	ld	a1,0(s0)
ffffffffc0200266:	00001517          	auipc	a0,0x1
ffffffffc020026a:	1aa50513          	addi	a0,a0,426 # ffffffffc0201410 <etext+0x130>
ffffffffc020026e:	edfff0ef          	jal	ra,ffffffffc020014c <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc0200272:	00043a03          	ld	s4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc0200276:	00001517          	auipc	a0,0x1
ffffffffc020027a:	1b250513          	addi	a0,a0,434 # ffffffffc0201428 <etext+0x148>
    if (boot_dtb == 0) {
ffffffffc020027e:	120a0463          	beqz	s4,ffffffffc02003a6 <dtb_init+0x186>
        return;
    }
    
    // 转换为虚拟地址
    uintptr_t dtb_vaddr = boot_dtb + PHYSICAL_MEMORY_OFFSET;
ffffffffc0200282:	57f5                	li	a5,-3
ffffffffc0200284:	07fa                	slli	a5,a5,0x1e
ffffffffc0200286:	00fa0733          	add	a4,s4,a5
    const struct fdt_header *header = (const struct fdt_header *)dtb_vaddr;
    
    // 验证DTB
    uint32_t magic = fdt32_to_cpu(header->magic);
ffffffffc020028a:	431c                	lw	a5,0(a4)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020028c:	00ff0637          	lui	a2,0xff0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200290:	6b41                	lui	s6,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200292:	0087d59b          	srliw	a1,a5,0x8
ffffffffc0200296:	0187969b          	slliw	a3,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020029a:	0187d51b          	srliw	a0,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020029e:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002a2:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002a6:	8df1                	and	a1,a1,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002a8:	8ec9                	or	a3,a3,a0
ffffffffc02002aa:	0087979b          	slliw	a5,a5,0x8
ffffffffc02002ae:	1b7d                	addi	s6,s6,-1
ffffffffc02002b0:	0167f7b3          	and	a5,a5,s6
ffffffffc02002b4:	8dd5                	or	a1,a1,a3
ffffffffc02002b6:	8ddd                	or	a1,a1,a5
    if (magic != 0xd00dfeed) {
ffffffffc02002b8:	d00e07b7          	lui	a5,0xd00e0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002bc:	2581                	sext.w	a1,a1
    if (magic != 0xd00dfeed) {
ffffffffc02002be:	eed78793          	addi	a5,a5,-275 # ffffffffd00dfeed <end+0xfedacf5>
ffffffffc02002c2:	10f59163          	bne	a1,a5,ffffffffc02003c4 <dtb_init+0x1a4>
        return;
    }
    
    // 提取内存信息
    uint64_t mem_base, mem_size;
    if (extract_memory_info(dtb_vaddr, header, &mem_base, &mem_size) == 0) {
ffffffffc02002c6:	471c                	lw	a5,8(a4)
ffffffffc02002c8:	4754                	lw	a3,12(a4)
    int in_memory_node = 0;
ffffffffc02002ca:	4c81                	li	s9,0
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002cc:	0087d59b          	srliw	a1,a5,0x8
ffffffffc02002d0:	0086d51b          	srliw	a0,a3,0x8
ffffffffc02002d4:	0186941b          	slliw	s0,a3,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002d8:	0186d89b          	srliw	a7,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002dc:	01879a1b          	slliw	s4,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002e0:	0187d81b          	srliw	a6,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002e4:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002e8:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002ec:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002f0:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002f4:	8d71                	and	a0,a0,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002f6:	01146433          	or	s0,s0,a7
ffffffffc02002fa:	0086969b          	slliw	a3,a3,0x8
ffffffffc02002fe:	010a6a33          	or	s4,s4,a6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200302:	8e6d                	and	a2,a2,a1
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200304:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200308:	8c49                	or	s0,s0,a0
ffffffffc020030a:	0166f6b3          	and	a3,a3,s6
ffffffffc020030e:	00ca6a33          	or	s4,s4,a2
ffffffffc0200312:	0167f7b3          	and	a5,a5,s6
ffffffffc0200316:	8c55                	or	s0,s0,a3
ffffffffc0200318:	00fa6a33          	or	s4,s4,a5
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc020031c:	1402                	slli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc020031e:	1a02                	slli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200320:	9001                	srli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200322:	020a5a13          	srli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200326:	943a                	add	s0,s0,a4
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200328:	9a3a                	add	s4,s4,a4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020032a:	00ff0c37          	lui	s8,0xff0
        switch (token) {
ffffffffc020032e:	4b8d                	li	s7,3
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200330:	00001917          	auipc	s2,0x1
ffffffffc0200334:	14890913          	addi	s2,s2,328 # ffffffffc0201478 <etext+0x198>
ffffffffc0200338:	49bd                	li	s3,15
        switch (token) {
ffffffffc020033a:	4d91                	li	s11,4
ffffffffc020033c:	4d05                	li	s10,1
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc020033e:	00001497          	auipc	s1,0x1
ffffffffc0200342:	13248493          	addi	s1,s1,306 # ffffffffc0201470 <etext+0x190>
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200346:	000a2703          	lw	a4,0(s4)
ffffffffc020034a:	004a0a93          	addi	s5,s4,4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020034e:	0087569b          	srliw	a3,a4,0x8
ffffffffc0200352:	0187179b          	slliw	a5,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200356:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020035a:	0106969b          	slliw	a3,a3,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020035e:	0107571b          	srliw	a4,a4,0x10
ffffffffc0200362:	8fd1                	or	a5,a5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200364:	0186f6b3          	and	a3,a3,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200368:	0087171b          	slliw	a4,a4,0x8
ffffffffc020036c:	8fd5                	or	a5,a5,a3
ffffffffc020036e:	00eb7733          	and	a4,s6,a4
ffffffffc0200372:	8fd9                	or	a5,a5,a4
ffffffffc0200374:	2781                	sext.w	a5,a5
        switch (token) {
ffffffffc0200376:	09778c63          	beq	a5,s7,ffffffffc020040e <dtb_init+0x1ee>
ffffffffc020037a:	00fbea63          	bltu	s7,a5,ffffffffc020038e <dtb_init+0x16e>
ffffffffc020037e:	07a78663          	beq	a5,s10,ffffffffc02003ea <dtb_init+0x1ca>
ffffffffc0200382:	4709                	li	a4,2
ffffffffc0200384:	00e79763          	bne	a5,a4,ffffffffc0200392 <dtb_init+0x172>
ffffffffc0200388:	4c81                	li	s9,0
ffffffffc020038a:	8a56                	mv	s4,s5
ffffffffc020038c:	bf6d                	j	ffffffffc0200346 <dtb_init+0x126>
ffffffffc020038e:	ffb78ee3          	beq	a5,s11,ffffffffc020038a <dtb_init+0x16a>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
        // 保存到全局变量，供 PMM 查询
        memory_base = mem_base;
        memory_size = mem_size;
    } else {
        cprintf("Warning: Could not extract memory info from DTB\n");
ffffffffc0200392:	00001517          	auipc	a0,0x1
ffffffffc0200396:	15e50513          	addi	a0,a0,350 # ffffffffc02014f0 <etext+0x210>
ffffffffc020039a:	db3ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc020039e:	00001517          	auipc	a0,0x1
ffffffffc02003a2:	18a50513          	addi	a0,a0,394 # ffffffffc0201528 <etext+0x248>
}
ffffffffc02003a6:	7446                	ld	s0,112(sp)
ffffffffc02003a8:	70e6                	ld	ra,120(sp)
ffffffffc02003aa:	74a6                	ld	s1,104(sp)
ffffffffc02003ac:	7906                	ld	s2,96(sp)
ffffffffc02003ae:	69e6                	ld	s3,88(sp)
ffffffffc02003b0:	6a46                	ld	s4,80(sp)
ffffffffc02003b2:	6aa6                	ld	s5,72(sp)
ffffffffc02003b4:	6b06                	ld	s6,64(sp)
ffffffffc02003b6:	7be2                	ld	s7,56(sp)
ffffffffc02003b8:	7c42                	ld	s8,48(sp)
ffffffffc02003ba:	7ca2                	ld	s9,40(sp)
ffffffffc02003bc:	7d02                	ld	s10,32(sp)
ffffffffc02003be:	6de2                	ld	s11,24(sp)
ffffffffc02003c0:	6109                	addi	sp,sp,128
    cprintf("DTB init completed\n");
ffffffffc02003c2:	b369                	j	ffffffffc020014c <cprintf>
}
ffffffffc02003c4:	7446                	ld	s0,112(sp)
ffffffffc02003c6:	70e6                	ld	ra,120(sp)
ffffffffc02003c8:	74a6                	ld	s1,104(sp)
ffffffffc02003ca:	7906                	ld	s2,96(sp)
ffffffffc02003cc:	69e6                	ld	s3,88(sp)
ffffffffc02003ce:	6a46                	ld	s4,80(sp)
ffffffffc02003d0:	6aa6                	ld	s5,72(sp)
ffffffffc02003d2:	6b06                	ld	s6,64(sp)
ffffffffc02003d4:	7be2                	ld	s7,56(sp)
ffffffffc02003d6:	7c42                	ld	s8,48(sp)
ffffffffc02003d8:	7ca2                	ld	s9,40(sp)
ffffffffc02003da:	7d02                	ld	s10,32(sp)
ffffffffc02003dc:	6de2                	ld	s11,24(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02003de:	00001517          	auipc	a0,0x1
ffffffffc02003e2:	06a50513          	addi	a0,a0,106 # ffffffffc0201448 <etext+0x168>
}
ffffffffc02003e6:	6109                	addi	sp,sp,128
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02003e8:	b395                	j	ffffffffc020014c <cprintf>
                int name_len = strlen(name);
ffffffffc02003ea:	8556                	mv	a0,s5
ffffffffc02003ec:	669000ef          	jal	ra,ffffffffc0201254 <strlen>
ffffffffc02003f0:	8a2a                	mv	s4,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02003f2:	4619                	li	a2,6
ffffffffc02003f4:	85a6                	mv	a1,s1
ffffffffc02003f6:	8556                	mv	a0,s5
                int name_len = strlen(name);
ffffffffc02003f8:	2a01                	sext.w	s4,s4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02003fa:	6af000ef          	jal	ra,ffffffffc02012a8 <strncmp>
ffffffffc02003fe:	e111                	bnez	a0,ffffffffc0200402 <dtb_init+0x1e2>
                    in_memory_node = 1;
ffffffffc0200400:	4c85                	li	s9,1
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc0200402:	0a91                	addi	s5,s5,4
ffffffffc0200404:	9ad2                	add	s5,s5,s4
ffffffffc0200406:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc020040a:	8a56                	mv	s4,s5
ffffffffc020040c:	bf2d                	j	ffffffffc0200346 <dtb_init+0x126>
                uint32_t prop_len = fdt32_to_cpu(*struct_ptr++);
ffffffffc020040e:	004a2783          	lw	a5,4(s4)
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200412:	00ca0693          	addi	a3,s4,12
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200416:	0087d71b          	srliw	a4,a5,0x8
ffffffffc020041a:	01879a9b          	slliw	s5,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020041e:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200422:	0107171b          	slliw	a4,a4,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200426:	0107d79b          	srliw	a5,a5,0x10
ffffffffc020042a:	00caeab3          	or	s5,s5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020042e:	01877733          	and	a4,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200432:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200436:	00eaeab3          	or	s5,s5,a4
ffffffffc020043a:	00fb77b3          	and	a5,s6,a5
ffffffffc020043e:	00faeab3          	or	s5,s5,a5
ffffffffc0200442:	2a81                	sext.w	s5,s5
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200444:	000c9c63          	bnez	s9,ffffffffc020045c <dtb_init+0x23c>
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + prop_len + 3) & ~3);
ffffffffc0200448:	1a82                	slli	s5,s5,0x20
ffffffffc020044a:	00368793          	addi	a5,a3,3
ffffffffc020044e:	020ada93          	srli	s5,s5,0x20
ffffffffc0200452:	9abe                	add	s5,s5,a5
ffffffffc0200454:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc0200458:	8a56                	mv	s4,s5
ffffffffc020045a:	b5f5                	j	ffffffffc0200346 <dtb_init+0x126>
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc020045c:	008a2783          	lw	a5,8(s4)
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200460:	85ca                	mv	a1,s2
ffffffffc0200462:	e436                	sd	a3,8(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200464:	0087d51b          	srliw	a0,a5,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200468:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020046c:	0187971b          	slliw	a4,a5,0x18
ffffffffc0200470:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200474:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200478:	8f51                	or	a4,a4,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020047a:	01857533          	and	a0,a0,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020047e:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200482:	8d59                	or	a0,a0,a4
ffffffffc0200484:	00fb77b3          	and	a5,s6,a5
ffffffffc0200488:	8d5d                	or	a0,a0,a5
                const char *prop_name = strings_base + prop_nameoff;
ffffffffc020048a:	1502                	slli	a0,a0,0x20
ffffffffc020048c:	9101                	srli	a0,a0,0x20
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020048e:	9522                	add	a0,a0,s0
ffffffffc0200490:	5fb000ef          	jal	ra,ffffffffc020128a <strcmp>
ffffffffc0200494:	66a2                	ld	a3,8(sp)
ffffffffc0200496:	f94d                	bnez	a0,ffffffffc0200448 <dtb_init+0x228>
ffffffffc0200498:	fb59f8e3          	bgeu	s3,s5,ffffffffc0200448 <dtb_init+0x228>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc020049c:	00ca3783          	ld	a5,12(s4)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc02004a0:	014a3703          	ld	a4,20(s4)
        cprintf("Physical Memory from DTB:\n");
ffffffffc02004a4:	00001517          	auipc	a0,0x1
ffffffffc02004a8:	fdc50513          	addi	a0,a0,-36 # ffffffffc0201480 <etext+0x1a0>
           fdt32_to_cpu(x >> 32);
ffffffffc02004ac:	4207d613          	srai	a2,a5,0x20
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004b0:	0087d31b          	srliw	t1,a5,0x8
           fdt32_to_cpu(x >> 32);
ffffffffc02004b4:	42075593          	srai	a1,a4,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004b8:	0187de1b          	srliw	t3,a5,0x18
ffffffffc02004bc:	0186581b          	srliw	a6,a2,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004c0:	0187941b          	slliw	s0,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004c4:	0107d89b          	srliw	a7,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004c8:	0187d693          	srli	a3,a5,0x18
ffffffffc02004cc:	01861f1b          	slliw	t5,a2,0x18
ffffffffc02004d0:	0087579b          	srliw	a5,a4,0x8
ffffffffc02004d4:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004d8:	0106561b          	srliw	a2,a2,0x10
ffffffffc02004dc:	010f6f33          	or	t5,t5,a6
ffffffffc02004e0:	0187529b          	srliw	t0,a4,0x18
ffffffffc02004e4:	0185df9b          	srliw	t6,a1,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004e8:	01837333          	and	t1,t1,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004ec:	01c46433          	or	s0,s0,t3
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004f0:	0186f6b3          	and	a3,a3,s8
ffffffffc02004f4:	01859e1b          	slliw	t3,a1,0x18
ffffffffc02004f8:	01871e9b          	slliw	t4,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004fc:	0107581b          	srliw	a6,a4,0x10
ffffffffc0200500:	0086161b          	slliw	a2,a2,0x8
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200504:	8361                	srli	a4,a4,0x18
ffffffffc0200506:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020050a:	0105d59b          	srliw	a1,a1,0x10
ffffffffc020050e:	01e6e6b3          	or	a3,a3,t5
ffffffffc0200512:	00cb7633          	and	a2,s6,a2
ffffffffc0200516:	0088181b          	slliw	a6,a6,0x8
ffffffffc020051a:	0085959b          	slliw	a1,a1,0x8
ffffffffc020051e:	00646433          	or	s0,s0,t1
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200522:	0187f7b3          	and	a5,a5,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200526:	01fe6333          	or	t1,t3,t6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020052a:	01877c33          	and	s8,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020052e:	0088989b          	slliw	a7,a7,0x8
ffffffffc0200532:	011b78b3          	and	a7,s6,a7
ffffffffc0200536:	005eeeb3          	or	t4,t4,t0
ffffffffc020053a:	00c6e733          	or	a4,a3,a2
ffffffffc020053e:	006c6c33          	or	s8,s8,t1
ffffffffc0200542:	010b76b3          	and	a3,s6,a6
ffffffffc0200546:	00bb7b33          	and	s6,s6,a1
ffffffffc020054a:	01d7e7b3          	or	a5,a5,t4
ffffffffc020054e:	016c6b33          	or	s6,s8,s6
ffffffffc0200552:	01146433          	or	s0,s0,a7
ffffffffc0200556:	8fd5                	or	a5,a5,a3
           fdt32_to_cpu(x >> 32);
ffffffffc0200558:	1702                	slli	a4,a4,0x20
ffffffffc020055a:	1b02                	slli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc020055c:	1782                	slli	a5,a5,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc020055e:	9301                	srli	a4,a4,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200560:	1402                	slli	s0,s0,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc0200562:	020b5b13          	srli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200566:	0167eb33          	or	s6,a5,s6
ffffffffc020056a:	8c59                	or	s0,s0,a4
        cprintf("Physical Memory from DTB:\n");
ffffffffc020056c:	be1ff0ef          	jal	ra,ffffffffc020014c <cprintf>
        cprintf("  Base: 0x%016lx\n", mem_base);
ffffffffc0200570:	85a2                	mv	a1,s0
ffffffffc0200572:	00001517          	auipc	a0,0x1
ffffffffc0200576:	f2e50513          	addi	a0,a0,-210 # ffffffffc02014a0 <etext+0x1c0>
ffffffffc020057a:	bd3ff0ef          	jal	ra,ffffffffc020014c <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc020057e:	014b5613          	srli	a2,s6,0x14
ffffffffc0200582:	85da                	mv	a1,s6
ffffffffc0200584:	00001517          	auipc	a0,0x1
ffffffffc0200588:	f3450513          	addi	a0,a0,-204 # ffffffffc02014b8 <etext+0x1d8>
ffffffffc020058c:	bc1ff0ef          	jal	ra,ffffffffc020014c <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc0200590:	008b05b3          	add	a1,s6,s0
ffffffffc0200594:	15fd                	addi	a1,a1,-1
ffffffffc0200596:	00001517          	auipc	a0,0x1
ffffffffc020059a:	f4250513          	addi	a0,a0,-190 # ffffffffc02014d8 <etext+0x1f8>
ffffffffc020059e:	bafff0ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("DTB init completed\n");
ffffffffc02005a2:	00001517          	auipc	a0,0x1
ffffffffc02005a6:	f8650513          	addi	a0,a0,-122 # ffffffffc0201528 <etext+0x248>
        memory_base = mem_base;
ffffffffc02005aa:	00005797          	auipc	a5,0x5
ffffffffc02005ae:	be87bb23          	sd	s0,-1034(a5) # ffffffffc02051a0 <memory_base>
        memory_size = mem_size;
ffffffffc02005b2:	00005797          	auipc	a5,0x5
ffffffffc02005b6:	bf67bb23          	sd	s6,-1034(a5) # ffffffffc02051a8 <memory_size>
    cprintf("DTB init completed\n");
ffffffffc02005ba:	b3f5                	j	ffffffffc02003a6 <dtb_init+0x186>

ffffffffc02005bc <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc02005bc:	00005517          	auipc	a0,0x5
ffffffffc02005c0:	be453503          	ld	a0,-1052(a0) # ffffffffc02051a0 <memory_base>
ffffffffc02005c4:	8082                	ret

ffffffffc02005c6 <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
ffffffffc02005c6:	00005517          	auipc	a0,0x5
ffffffffc02005ca:	be253503          	ld	a0,-1054(a0) # ffffffffc02051a8 <memory_size>
ffffffffc02005ce:	8082                	ret

ffffffffc02005d0 <buddy_init>:
    }
    return order;
}

static void buddy_init(void) {
    for (int i = 0; i < max_order; i++) {
ffffffffc02005d0:	00005797          	auipc	a5,0x5
ffffffffc02005d4:	a4878793          	addi	a5,a5,-1464 # ffffffffc0205018 <buddy_area>
ffffffffc02005d8:	00005717          	auipc	a4,0x5
ffffffffc02005dc:	bc070713          	addi	a4,a4,-1088 # ffffffffc0205198 <is_panic>
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc02005e0:	e79c                	sd	a5,8(a5)
ffffffffc02005e2:	e39c                	sd	a5,0(a5)
        list_init(&buddy_area[i].free_list);
        buddy_area[i].nr_free = 0;
ffffffffc02005e4:	0007a823          	sw	zero,16(a5)
    for (int i = 0; i < max_order; i++) {
ffffffffc02005e8:	07e1                	addi	a5,a5,24
ffffffffc02005ea:	fee79be3          	bne	a5,a4,ffffffffc02005e0 <buddy_init+0x10>
    }
    buddy_free_pages_count = 0;
ffffffffc02005ee:	00005797          	auipc	a5,0x5
ffffffffc02005f2:	bc07b123          	sd	zero,-1086(a5) # ffffffffc02051b0 <buddy_free_pages_count>
}
ffffffffc02005f6:	8082                	ret

ffffffffc02005f8 <buddy_nr_free_pages>:
}

// 返回空闲页面数
static size_t buddy_nr_free_pages(void) {
    return buddy_free_pages_count;
}
ffffffffc02005f8:	00005517          	auipc	a0,0x5
ffffffffc02005fc:	bb853503          	ld	a0,-1096(a0) # ffffffffc02051b0 <buddy_free_pages_count>
ffffffffc0200600:	8082                	ret

ffffffffc0200602 <buddy_alloc_pages>:
    assert(n > 0);
ffffffffc0200602:	10050163          	beqz	a0,ffffffffc0200704 <buddy_alloc_pages+0x102>
    if (n > buddy_free_pages_count) {
ffffffffc0200606:	00005297          	auipc	t0,0x5
ffffffffc020060a:	baa28293          	addi	t0,t0,-1110 # ffffffffc02051b0 <buddy_free_pages_count>
ffffffffc020060e:	0002bf03          	ld	t5,0(t0)
ffffffffc0200612:	0eaf6763          	bltu	t5,a0,ffffffffc0200700 <buddy_alloc_pages+0xfe>
    while (sz < n) {
ffffffffc0200616:	4785                	li	a5,1
    int order = 0;
ffffffffc0200618:	4601                	li	a2,0
    while (sz < n) {
ffffffffc020061a:	00f50963          	beq	a0,a5,ffffffffc020062c <buddy_alloc_pages+0x2a>
        sz <<= 1;
ffffffffc020061e:	0786                	slli	a5,a5,0x1
        order++;
ffffffffc0200620:	2605                	addiw	a2,a2,1
    while (sz < n) {
ffffffffc0200622:	fea7eee3          	bltu	a5,a0,ffffffffc020061e <buddy_alloc_pages+0x1c>
    for (int ord = need_order; ord < max_order; ord++) {
ffffffffc0200626:	47bd                	li	a5,15
ffffffffc0200628:	0cc7cc63          	blt	a5,a2,ffffffffc0200700 <buddy_alloc_pages+0xfe>
ffffffffc020062c:	00161713          	slli	a4,a2,0x1
ffffffffc0200630:	9732                	add	a4,a4,a2
ffffffffc0200632:	00005697          	auipc	a3,0x5
ffffffffc0200636:	9e668693          	addi	a3,a3,-1562 # ffffffffc0205018 <buddy_area>
ffffffffc020063a:	070e                	slli	a4,a4,0x3
ffffffffc020063c:	9736                	add	a4,a4,a3
    int order = 0;
ffffffffc020063e:	87b2                	mv	a5,a2
    for (int ord = need_order; ord < max_order; ord++) {
ffffffffc0200640:	45c1                	li	a1,16
ffffffffc0200642:	a029                	j	ffffffffc020064c <buddy_alloc_pages+0x4a>
ffffffffc0200644:	2785                	addiw	a5,a5,1
ffffffffc0200646:	0761                	addi	a4,a4,24
ffffffffc0200648:	0ab78c63          	beq	a5,a1,ffffffffc0200700 <buddy_alloc_pages+0xfe>
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
ffffffffc020064c:	00873883          	ld	a7,8(a4)
        if (!list_empty(&buddy_area[ord].free_list)) {
ffffffffc0200650:	fee88ae3          	beq	a7,a4,ffffffffc0200644 <buddy_alloc_pages+0x42>
    buddy_area[found_order].nr_free -= order_to_pages(found_order);
ffffffffc0200654:	00179713          	slli	a4,a5,0x1
    __list_del(listelm->prev, listelm->next);
ffffffffc0200658:	0088b583          	ld	a1,8(a7)
ffffffffc020065c:	0008b303          	ld	t1,0(a7)
ffffffffc0200660:	973e                	add	a4,a4,a5
ffffffffc0200662:	070e                	slli	a4,a4,0x3
ffffffffc0200664:	00e68833          	add	a6,a3,a4
ffffffffc0200668:	01082503          	lw	a0,16(a6)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc020066c:	00b33423          	sd	a1,8(t1)
    next->prev = prev;
ffffffffc0200670:	0065b023          	sd	t1,0(a1)
static inline size_t order_to_pages(int order) { return (size_t)1 << order; }
ffffffffc0200674:	4585                	li	a1,1
ffffffffc0200676:	00f595b3          	sll	a1,a1,a5
    buddy_area[found_order].nr_free -= order_to_pages(found_order);
ffffffffc020067a:	9d0d                	subw	a0,a0,a1
    elm->prev = elm->next = elm;
ffffffffc020067c:	0118b423          	sd	a7,8(a7)
ffffffffc0200680:	0118b023          	sd	a7,0(a7)
    buddy_free_pages_count -= order_to_pages(found_order);
ffffffffc0200684:	40bf0f33          	sub	t5,t5,a1
ffffffffc0200688:	1721                	addi	a4,a4,-24
    buddy_area[found_order].nr_free -= order_to_pages(found_order);
ffffffffc020068a:	00a82823          	sw	a0,16(a6)
    buddy_free_pages_count -= order_to_pages(found_order);
ffffffffc020068e:	01e2b023          	sd	t5,0(t0)
    struct Page *block = le2page(le, page_link);
ffffffffc0200692:	fe888513          	addi	a0,a7,-24
    while (found_order > need_order) {
ffffffffc0200696:	96ba                	add	a3,a3,a4
static inline size_t order_to_pages(int order) { return (size_t)1 << order; }
ffffffffc0200698:	4385                	li	t2,1
        struct Page *right = block + order_to_pages(found_order);
ffffffffc020069a:	02800f93          	li	t6,40
    while (found_order > need_order) {
ffffffffc020069e:	04f65763          	bge	a2,a5,ffffffffc02006ec <buddy_alloc_pages+0xea>
        found_order--;
ffffffffc02006a2:	37fd                	addiw	a5,a5,-1
        struct Page *right = block + order_to_pages(found_order);
ffffffffc02006a4:	00ff9733          	sll	a4,t6,a5
ffffffffc02006a8:	972a                	add	a4,a4,a0
        SetPageProperty(right);
ffffffffc02006aa:	00873803          	ld	a6,8(a4)
static inline size_t order_to_pages(int order) { return (size_t)1 << order; }
ffffffffc02006ae:	00f39333          	sll	t1,t2,a5
    __list_add(elm, listelm, listelm->next);
ffffffffc02006b2:	0086be83          	ld	t4,8(a3)
        right->property = order_to_pages(found_order);
ffffffffc02006b6:	00030e1b          	sext.w	t3,t1
ffffffffc02006ba:	01c72823          	sw	t3,16(a4)
        SetPageProperty(right);
ffffffffc02006be:	00286813          	ori	a6,a6,2
        buddy_area[found_order].nr_free += order_to_pages(found_order);
ffffffffc02006c2:	4a8c                	lw	a1,16(a3)
        SetPageProperty(right);
ffffffffc02006c4:	01073423          	sd	a6,8(a4)
        list_add(&buddy_area[found_order].free_list, &right->page_link);
ffffffffc02006c8:	01870813          	addi	a6,a4,24
    prev->next = next->prev = elm;
ffffffffc02006cc:	010eb023          	sd	a6,0(t4)
ffffffffc02006d0:	0106b423          	sd	a6,8(a3)
    elm->prev = prev;
ffffffffc02006d4:	ef14                	sd	a3,24(a4)
    elm->next = next;
ffffffffc02006d6:	03d73023          	sd	t4,32(a4)
        buddy_area[found_order].nr_free += order_to_pages(found_order);
ffffffffc02006da:	01c5873b          	addw	a4,a1,t3
ffffffffc02006de:	ca98                	sw	a4,16(a3)
        buddy_free_pages_count += order_to_pages(found_order);
ffffffffc02006e0:	9f1a                	add	t5,t5,t1
    while (found_order > need_order) {
ffffffffc02006e2:	16a1                	addi	a3,a3,-24
ffffffffc02006e4:	fac79fe3          	bne	a5,a2,ffffffffc02006a2 <buddy_alloc_pages+0xa0>
ffffffffc02006e8:	01e2b023          	sd	t5,0(t0)
    ClearPageProperty(block);     // 不是空闲头
ffffffffc02006ec:	ff08b783          	ld	a5,-16(a7)
    block->property = need_order; // 存储 order
ffffffffc02006f0:	fec8ac23          	sw	a2,-8(a7)



static inline int page_ref(struct Page *page) { return page->ref; }

static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc02006f4:	fe08a423          	sw	zero,-24(a7)
    ClearPageProperty(block);     // 不是空闲头
ffffffffc02006f8:	9bf5                	andi	a5,a5,-3
ffffffffc02006fa:	fef8b823          	sd	a5,-16(a7)
    return block;
ffffffffc02006fe:	8082                	ret
        return NULL;
ffffffffc0200700:	4501                	li	a0,0
}
ffffffffc0200702:	8082                	ret
static struct Page *buddy_alloc_pages(size_t n) {
ffffffffc0200704:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc0200706:	00001697          	auipc	a3,0x1
ffffffffc020070a:	e3a68693          	addi	a3,a3,-454 # ffffffffc0201540 <etext+0x260>
ffffffffc020070e:	00001617          	auipc	a2,0x1
ffffffffc0200712:	e3a60613          	addi	a2,a2,-454 # ffffffffc0201548 <etext+0x268>
ffffffffc0200716:	06f00593          	li	a1,111
ffffffffc020071a:	00001517          	auipc	a0,0x1
ffffffffc020071e:	e4650513          	addi	a0,a0,-442 # ffffffffc0201560 <etext+0x280>
static struct Page *buddy_alloc_pages(size_t n) {
ffffffffc0200722:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0200724:	a9fff0ef          	jal	ra,ffffffffc02001c2 <__panic>

ffffffffc0200728 <buddy_check>:

//调试输出和放宽的正确性断言
static void buddy_check(void) {
ffffffffc0200728:	1101                	addi	sp,sp,-32
    struct Page *a, *b, *c;
    a = b = c = NULL;

    cprintf("start\n");
ffffffffc020072a:	00001517          	auipc	a0,0x1
ffffffffc020072e:	e4e50513          	addi	a0,a0,-434 # ffffffffc0201578 <etext+0x298>
static void buddy_check(void) {
ffffffffc0200732:	ec06                	sd	ra,24(sp)
ffffffffc0200734:	e822                	sd	s0,16(sp)
ffffffffc0200736:	e426                	sd	s1,8(sp)
ffffffffc0200738:	e04a                	sd	s2,0(sp)
    cprintf("start\n");
ffffffffc020073a:	a13ff0ef          	jal	ra,ffffffffc020014c <cprintf>

    // 分配三个单页请求
    assert((a = alloc_page()) != NULL);
ffffffffc020073e:	4505                	li	a0,1
ffffffffc0200740:	510000ef          	jal	ra,ffffffffc0200c50 <alloc_pages>
ffffffffc0200744:	16050063          	beqz	a0,ffffffffc02008a4 <buddy_check+0x17c>
ffffffffc0200748:	842a                	mv	s0,a0
    assert((b = alloc_page()) != NULL);
ffffffffc020074a:	4505                	li	a0,1
ffffffffc020074c:	504000ef          	jal	ra,ffffffffc0200c50 <alloc_pages>
ffffffffc0200750:	892a                	mv	s2,a0
ffffffffc0200752:	12050963          	beqz	a0,ffffffffc0200884 <buddy_check+0x15c>
    assert((c = alloc_page()) != NULL);
ffffffffc0200756:	4505                	li	a0,1
ffffffffc0200758:	4f8000ef          	jal	ra,ffffffffc0200c50 <alloc_pages>
ffffffffc020075c:	84aa                	mv	s1,a0
ffffffffc020075e:	10050363          	beqz	a0,ffffffffc0200864 <buddy_check+0x13c>
    assert(a != b && a != c && b != c);
ffffffffc0200762:	0f240163          	beq	s0,s2,ffffffffc0200844 <buddy_check+0x11c>
ffffffffc0200766:	0ca40f63          	beq	s0,a0,ffffffffc0200844 <buddy_check+0x11c>
ffffffffc020076a:	0ca90d63          	beq	s2,a0,ffffffffc0200844 <buddy_check+0x11c>

    cprintf("alloc pages: a=%p b=%p c=%p\n", a, b, c);
ffffffffc020076e:	86aa                	mv	a3,a0
ffffffffc0200770:	864a                	mv	a2,s2
ffffffffc0200772:	85a2                	mv	a1,s0
ffffffffc0200774:	00001517          	auipc	a0,0x1
ffffffffc0200778:	e8c50513          	addi	a0,a0,-372 # ffffffffc0201600 <etext+0x320>
ffffffffc020077c:	9d1ff0ef          	jal	ra,ffffffffc020014c <cprintf>

    // 释放它们
    free_page(a);
ffffffffc0200780:	4585                	li	a1,1
ffffffffc0200782:	8522                	mv	a0,s0
ffffffffc0200784:	4d8000ef          	jal	ra,ffffffffc0200c5c <free_pages>
    free_page(b);
ffffffffc0200788:	4585                	li	a1,1
ffffffffc020078a:	854a                	mv	a0,s2
ffffffffc020078c:	4d0000ef          	jal	ra,ffffffffc0200c5c <free_pages>
    free_page(c);
ffffffffc0200790:	4585                	li	a1,1
ffffffffc0200792:	8526                	mv	a0,s1
ffffffffc0200794:	4c8000ef          	jal	ra,ffffffffc0200c5c <free_pages>

    cprintf("freed single pages\n");
ffffffffc0200798:	00001517          	auipc	a0,0x1
ffffffffc020079c:	e8850513          	addi	a0,a0,-376 # ffffffffc0201620 <etext+0x340>
ffffffffc02007a0:	9adff0ef          	jal	ra,ffffffffc020014c <cprintf>

    // 分配 5 页
    struct Page *p = alloc_pages(5);
ffffffffc02007a4:	4515                	li	a0,5
ffffffffc02007a6:	4aa000ef          	jal	ra,ffffffffc0200c50 <alloc_pages>
ffffffffc02007aa:	84aa                	mv	s1,a0
    assert(p != NULL);
ffffffffc02007ac:	14050963          	beqz	a0,ffffffffc02008fe <buddy_check+0x1d6>
    // 读取存储的 order
    int alloc_order = (int)p->property;
ffffffffc02007b0:	4910                	lw	a2,16(a0)
    size_t alloc_size = (size_t)1 << alloc_order;
ffffffffc02007b2:	4405                	li	s0,1

    cprintf("alloc_pages(5) -> p=%p order=%d size=%zu\n",
ffffffffc02007b4:	85aa                	mv	a1,a0
    size_t alloc_size = (size_t)1 << alloc_order;
ffffffffc02007b6:	00c41433          	sll	s0,s0,a2
    cprintf("alloc_pages(5) -> p=%p order=%d size=%zu\n",
ffffffffc02007ba:	86a2                	mv	a3,s0
ffffffffc02007bc:	00001517          	auipc	a0,0x1
ffffffffc02007c0:	e8c50513          	addi	a0,a0,-372 # ffffffffc0201648 <etext+0x368>
ffffffffc02007c4:	989ff0ef          	jal	ra,ffffffffc020014c <cprintf>
            p, alloc_order, alloc_size);

    // 释放刚分配的完整 2 的幂块
    free_pages(p, alloc_size);
ffffffffc02007c8:	8526                	mv	a0,s1
ffffffffc02007ca:	85a2                	mv	a1,s0
ffffffffc02007cc:	490000ef          	jal	ra,ffffffffc0200c5c <free_pages>
    cprintf("free_pages(p, %zu) done\n", alloc_size);
ffffffffc02007d0:	85a2                	mv	a1,s0
ffffffffc02007d2:	00001517          	auipc	a0,0x1
ffffffffc02007d6:	ea650513          	addi	a0,a0,-346 # ffffffffc0201678 <etext+0x398>
ffffffffc02007da:	973ff0ef          	jal	ra,ffffffffc020014c <cprintf>

    // 现在尝试再次分配同样大小的块
    struct Page *q = alloc_pages(alloc_size);
ffffffffc02007de:	8522                	mv	a0,s0
ffffffffc02007e0:	470000ef          	jal	ra,ffffffffc0200c50 <alloc_pages>
ffffffffc02007e4:	84aa                	mv	s1,a0
    if (q == NULL) {
ffffffffc02007e6:	0e050f63          	beqz	a0,ffffffffc02008e4 <buddy_check+0x1bc>
        panic("alloc_pages(%zu) returned NULL after freeing block\n",
              alloc_size);
    }
    cprintf("re-alloc of size %zu returned q=%p\n", alloc_size, q);
ffffffffc02007ea:	862a                	mv	a2,a0
ffffffffc02007ec:	85a2                	mv	a1,s0
ffffffffc02007ee:	00001517          	auipc	a0,0x1
ffffffffc02007f2:	ee250513          	addi	a0,a0,-286 # ffffffffc02016d0 <etext+0x3f0>
ffffffffc02007f6:	957ff0ef          	jal	ra,ffffffffc020014c <cprintf>


    // 确保分配器一致：释放新分配的块，确保 nr_free_pages 返回到先前的值
    size_t before = nr_free_pages();
ffffffffc02007fa:	46e000ef          	jal	ra,ffffffffc0200c68 <nr_free_pages>
ffffffffc02007fe:	87aa                	mv	a5,a0
    free_pages(q, alloc_size);
ffffffffc0200800:	85a2                	mv	a1,s0
ffffffffc0200802:	8526                	mv	a0,s1
    size_t before = nr_free_pages();
ffffffffc0200804:	843e                	mv	s0,a5
    free_pages(q, alloc_size);
ffffffffc0200806:	456000ef          	jal	ra,ffffffffc0200c5c <free_pages>
    size_t after = nr_free_pages();
ffffffffc020080a:	45e000ef          	jal	ra,ffffffffc0200c68 <nr_free_pages>
ffffffffc020080e:	862a                	mv	a2,a0
    cprintf("freed q; free_pages before=%zu after=%zu (delta=%ld)\n",
ffffffffc0200810:	408506b3          	sub	a3,a0,s0
ffffffffc0200814:	85a2                	mv	a1,s0
ffffffffc0200816:	00001517          	auipc	a0,0x1
ffffffffc020081a:	ee250513          	addi	a0,a0,-286 # ffffffffc02016f8 <etext+0x418>
ffffffffc020081e:	92fff0ef          	jal	ra,ffffffffc020014c <cprintf>
            before, after, (long)(after - before));

    // 基本的单页分配/释放测试
    struct Page *x = alloc_page();
ffffffffc0200822:	4505                	li	a0,1
ffffffffc0200824:	42c000ef          	jal	ra,ffffffffc0200c50 <alloc_pages>
    assert(x != NULL);
ffffffffc0200828:	cd51                	beqz	a0,ffffffffc02008c4 <buddy_check+0x19c>
    free_page(x);
ffffffffc020082a:	4585                	li	a1,1
ffffffffc020082c:	430000ef          	jal	ra,ffffffffc0200c5c <free_pages>

    cprintf("end\n");
}
ffffffffc0200830:	6442                	ld	s0,16(sp)
ffffffffc0200832:	60e2                	ld	ra,24(sp)
ffffffffc0200834:	64a2                	ld	s1,8(sp)
ffffffffc0200836:	6902                	ld	s2,0(sp)
    cprintf("end\n");
ffffffffc0200838:	00001517          	auipc	a0,0x1
ffffffffc020083c:	f0850513          	addi	a0,a0,-248 # ffffffffc0201740 <etext+0x460>
}
ffffffffc0200840:	6105                	addi	sp,sp,32
    cprintf("end\n");
ffffffffc0200842:	b229                	j	ffffffffc020014c <cprintf>
    assert(a != b && a != c && b != c);
ffffffffc0200844:	00001697          	auipc	a3,0x1
ffffffffc0200848:	d9c68693          	addi	a3,a3,-612 # ffffffffc02015e0 <etext+0x300>
ffffffffc020084c:	00001617          	auipc	a2,0x1
ffffffffc0200850:	cfc60613          	addi	a2,a2,-772 # ffffffffc0201548 <etext+0x268>
ffffffffc0200854:	0dd00593          	li	a1,221
ffffffffc0200858:	00001517          	auipc	a0,0x1
ffffffffc020085c:	d0850513          	addi	a0,a0,-760 # ffffffffc0201560 <etext+0x280>
ffffffffc0200860:	963ff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert((c = alloc_page()) != NULL);
ffffffffc0200864:	00001697          	auipc	a3,0x1
ffffffffc0200868:	d5c68693          	addi	a3,a3,-676 # ffffffffc02015c0 <etext+0x2e0>
ffffffffc020086c:	00001617          	auipc	a2,0x1
ffffffffc0200870:	cdc60613          	addi	a2,a2,-804 # ffffffffc0201548 <etext+0x268>
ffffffffc0200874:	0dc00593          	li	a1,220
ffffffffc0200878:	00001517          	auipc	a0,0x1
ffffffffc020087c:	ce850513          	addi	a0,a0,-792 # ffffffffc0201560 <etext+0x280>
ffffffffc0200880:	943ff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert((b = alloc_page()) != NULL);
ffffffffc0200884:	00001697          	auipc	a3,0x1
ffffffffc0200888:	d1c68693          	addi	a3,a3,-740 # ffffffffc02015a0 <etext+0x2c0>
ffffffffc020088c:	00001617          	auipc	a2,0x1
ffffffffc0200890:	cbc60613          	addi	a2,a2,-836 # ffffffffc0201548 <etext+0x268>
ffffffffc0200894:	0db00593          	li	a1,219
ffffffffc0200898:	00001517          	auipc	a0,0x1
ffffffffc020089c:	cc850513          	addi	a0,a0,-824 # ffffffffc0201560 <etext+0x280>
ffffffffc02008a0:	923ff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert((a = alloc_page()) != NULL);
ffffffffc02008a4:	00001697          	auipc	a3,0x1
ffffffffc02008a8:	cdc68693          	addi	a3,a3,-804 # ffffffffc0201580 <etext+0x2a0>
ffffffffc02008ac:	00001617          	auipc	a2,0x1
ffffffffc02008b0:	c9c60613          	addi	a2,a2,-868 # ffffffffc0201548 <etext+0x268>
ffffffffc02008b4:	0da00593          	li	a1,218
ffffffffc02008b8:	00001517          	auipc	a0,0x1
ffffffffc02008bc:	ca850513          	addi	a0,a0,-856 # ffffffffc0201560 <etext+0x280>
ffffffffc02008c0:	903ff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(x != NULL);
ffffffffc02008c4:	00001697          	auipc	a3,0x1
ffffffffc02008c8:	e6c68693          	addi	a3,a3,-404 # ffffffffc0201730 <etext+0x450>
ffffffffc02008cc:	00001617          	auipc	a2,0x1
ffffffffc02008d0:	c7c60613          	addi	a2,a2,-900 # ffffffffc0201548 <etext+0x268>
ffffffffc02008d4:	10800593          	li	a1,264
ffffffffc02008d8:	00001517          	auipc	a0,0x1
ffffffffc02008dc:	c8850513          	addi	a0,a0,-888 # ffffffffc0201560 <etext+0x280>
ffffffffc02008e0:	8e3ff0ef          	jal	ra,ffffffffc02001c2 <__panic>
        panic("alloc_pages(%zu) returned NULL after freeing block\n",
ffffffffc02008e4:	86a2                	mv	a3,s0
ffffffffc02008e6:	00001617          	auipc	a2,0x1
ffffffffc02008ea:	db260613          	addi	a2,a2,-590 # ffffffffc0201698 <etext+0x3b8>
ffffffffc02008ee:	0f900593          	li	a1,249
ffffffffc02008f2:	00001517          	auipc	a0,0x1
ffffffffc02008f6:	c6e50513          	addi	a0,a0,-914 # ffffffffc0201560 <etext+0x280>
ffffffffc02008fa:	8c9ff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(p != NULL);
ffffffffc02008fe:	00001697          	auipc	a3,0x1
ffffffffc0200902:	d3a68693          	addi	a3,a3,-710 # ffffffffc0201638 <etext+0x358>
ffffffffc0200906:	00001617          	auipc	a2,0x1
ffffffffc020090a:	c4260613          	addi	a2,a2,-958 # ffffffffc0201548 <etext+0x268>
ffffffffc020090e:	0ea00593          	li	a1,234
ffffffffc0200912:	00001517          	auipc	a0,0x1
ffffffffc0200916:	c4e50513          	addi	a0,a0,-946 # ffffffffc0201560 <etext+0x280>
ffffffffc020091a:	8a9ff0ef          	jal	ra,ffffffffc02001c2 <__panic>

ffffffffc020091e <buddy_free_pages>:
static void buddy_free_pages(struct Page *base, size_t n) {
ffffffffc020091e:	7159                	addi	sp,sp,-112
ffffffffc0200920:	f486                	sd	ra,104(sp)
ffffffffc0200922:	f0a2                	sd	s0,96(sp)
ffffffffc0200924:	eca6                	sd	s1,88(sp)
ffffffffc0200926:	e8ca                	sd	s2,80(sp)
ffffffffc0200928:	e4ce                	sd	s3,72(sp)
ffffffffc020092a:	e0d2                	sd	s4,64(sp)
ffffffffc020092c:	fc56                	sd	s5,56(sp)
ffffffffc020092e:	f85a                	sd	s6,48(sp)
ffffffffc0200930:	f45e                	sd	s7,40(sp)
ffffffffc0200932:	f062                	sd	s8,32(sp)
ffffffffc0200934:	ec66                	sd	s9,24(sp)
ffffffffc0200936:	e86a                	sd	s10,16(sp)
ffffffffc0200938:	e46e                	sd	s11,8(sp)
    assert(n > 0);
ffffffffc020093a:	1e058663          	beqz	a1,ffffffffc0200b26 <buddy_free_pages+0x208>
    return p >= managed_base_page && p < (managed_base_page + managed_npages);
ffffffffc020093e:	00005797          	auipc	a5,0x5
ffffffffc0200942:	8827b783          	ld	a5,-1918(a5) # ffffffffc02051c0 <managed_npages>
ffffffffc0200946:	00279993          	slli	s3,a5,0x2
ffffffffc020094a:	00005917          	auipc	s2,0x5
ffffffffc020094e:	86690913          	addi	s2,s2,-1946 # ffffffffc02051b0 <buddy_free_pages_count>
ffffffffc0200952:	99be                	add	s3,s3,a5
ffffffffc0200954:	00093303          	ld	t1,0(s2)
ffffffffc0200958:	00005297          	auipc	t0,0x5
ffffffffc020095c:	8602b283          	ld	t0,-1952(t0) # ffffffffc02051b8 <managed_base_page>
ffffffffc0200960:	098e                	slli	s3,s3,0x3
static inline int page_ref_dec(struct Page *page) {
    page->ref -= 1;
    return page->ref;
}
static inline struct Page *pa2page(uintptr_t pa) {
    if (PPN(pa) >= npage) {
ffffffffc0200962:	5ffd                	li	t6,-1
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200964:	00005f17          	auipc	t5,0x5
ffffffffc0200968:	86cf3f03          	ld	t5,-1940(t5) # ffffffffc02051d0 <pages>
ffffffffc020096c:	00001e97          	auipc	t4,0x1
ffffffffc0200970:	20cebe83          	ld	t4,524(t4) # ffffffffc0201b78 <nbase>
    if (PPN(pa) >= npage) {
ffffffffc0200974:	00005497          	auipc	s1,0x5
ffffffffc0200978:	8544b483          	ld	s1,-1964(s1) # ffffffffc02051c8 <npage>
ffffffffc020097c:	9996                	add	s3,s3,t0
ffffffffc020097e:	4601                	li	a2,0
    for (size_t i = 0; i < n; i++) {
ffffffffc0200980:	4881                	li	a7,0
        cur->property = 1;
ffffffffc0200982:	4e05                	li	t3,1
        SetPageProperty(cur);
ffffffffc0200984:	4389                	li	t2,2
    __list_add(elm, listelm, listelm->next);
ffffffffc0200986:	00004697          	auipc	a3,0x4
ffffffffc020098a:	69268693          	addi	a3,a3,1682 # ffffffffc0205018 <buddy_area>
ffffffffc020098e:	00001417          	auipc	s0,0x1
ffffffffc0200992:	1e243403          	ld	s0,482(s0) # ffffffffc0201b70 <error_string+0x38>
ffffffffc0200996:	00cfdf93          	srli	t6,t6,0xc
        while (order < max_order - 1) {
ffffffffc020099a:	4a3d                	li	s4,15
        assert(!PageReserved(cur) && !PageProperty(cur));
ffffffffc020099c:	651c                	ld	a5,8(a0)
        struct Page *cur = base + i;
ffffffffc020099e:	872a                	mv	a4,a0
        assert(!PageReserved(cur) && !PageProperty(cur));
ffffffffc02009a0:	8b8d                	andi	a5,a5,3
ffffffffc02009a2:	14079f63          	bnez	a5,ffffffffc0200b00 <buddy_free_pages+0x1e2>
ffffffffc02009a6:	6690                	ld	a2,8(a3)
static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc02009a8:	00052023          	sw	zero,0(a0)
        cur->property = 1;
ffffffffc02009ac:	01c52823          	sw	t3,16(a0)
        buddy_area[0].nr_free += 1;
ffffffffc02009b0:	4a9c                	lw	a5,16(a3)
        SetPageProperty(cur);
ffffffffc02009b2:	00753423          	sd	t2,8(a0)
        list_add(&buddy_area[0].free_list, &cur->page_link);
ffffffffc02009b6:	01850813          	addi	a6,a0,24
    prev->next = next->prev = elm;
ffffffffc02009ba:	01063023          	sd	a6,0(a2)
ffffffffc02009be:	0106b423          	sd	a6,8(a3)
    elm->next = next;
ffffffffc02009c2:	f110                	sd	a2,32(a0)
    elm->prev = prev;
ffffffffc02009c4:	ed14                	sd	a3,24(a0)
        buddy_area[0].nr_free += 1;
ffffffffc02009c6:	2785                	addiw	a5,a5,1
ffffffffc02009c8:	ca9c                	sw	a5,16(a3)
        buddy_free_pages_count += 1;
ffffffffc02009ca:	0305                	addi	t1,t1,1
        while (order < max_order - 1) {
ffffffffc02009cc:	00004817          	auipc	a6,0x4
ffffffffc02009d0:	66480813          	addi	a6,a6,1636 # ffffffffc0205030 <buddy_area+0x18>
        int order = 0;
ffffffffc02009d4:	4601                	li	a2,0
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc02009d6:	41e707b3          	sub	a5,a4,t5
ffffffffc02009da:	878d                	srai	a5,a5,0x3
ffffffffc02009dc:	028787b3          	mul	a5,a5,s0
    ppn_t buddy_ppn = ppn ^ ((ppn_t)1 << order);
ffffffffc02009e0:	00ce1ab3          	sll	s5,t3,a2
ffffffffc02009e4:	97f6                	add	a5,a5,t4
ffffffffc02009e6:	0157c7b3          	xor	a5,a5,s5
    if (PPN(pa) >= npage) {
ffffffffc02009ea:	01f7f7b3          	and	a5,a5,t6
ffffffffc02009ee:	0e97fb63          	bgeu	a5,s1,ffffffffc0200ae4 <buddy_free_pages+0x1c6>
        panic("pa2page called with invalid pa");
    }
    return &pages[PPN(pa) - nbase];
ffffffffc02009f2:	41d787b3          	sub	a5,a5,t4
ffffffffc02009f6:	00279b93          	slli	s7,a5,0x2
ffffffffc02009fa:	97de                	add	a5,a5,s7
ffffffffc02009fc:	078e                	slli	a5,a5,0x3
ffffffffc02009fe:	97fa                	add	a5,a5,t5
    return p >= managed_base_page && p < (managed_base_page + managed_npages);
ffffffffc0200a00:	0a57eb63          	bltu	a5,t0,ffffffffc0200ab6 <buddy_free_pages+0x198>
ffffffffc0200a04:	0b37f963          	bgeu	a5,s3,ffffffffc0200ab6 <buddy_free_pages+0x198>
            if (!PageProperty(b)) break;
ffffffffc0200a08:	0087bb83          	ld	s7,8(a5)
ffffffffc0200a0c:	002bfb93          	andi	s7,s7,2
ffffffffc0200a10:	0a0b8363          	beqz	s7,ffffffffc0200ab6 <buddy_free_pages+0x198>
            if (b->property != order_to_pages(order)) break;
ffffffffc0200a14:	0107eb83          	lwu	s7,16(a5)
ffffffffc0200a18:	095b9f63          	bne	s7,s5,ffffffffc0200ab6 <buddy_free_pages+0x198>
    __list_del(listelm->prev, listelm->next);
ffffffffc0200a1c:	0187bd03          	ld	s10,24(a5)
ffffffffc0200a20:	0207ba83          	ld	s5,32(a5)
            buddy_area[order].nr_free -= order_to_pages(order);
ffffffffc0200a24:	ff882c03          	lw	s8,-8(a6)
            list_init(&b->page_link);
ffffffffc0200a28:	01878c93          	addi	s9,a5,24
    prev->next = next;
ffffffffc0200a2c:	015d3423          	sd	s5,8(s10)
    next->prev = prev;
ffffffffc0200a30:	01aab023          	sd	s10,0(s5)
    elm->prev = elm->next = elm;
ffffffffc0200a34:	0397b023          	sd	s9,32(a5)
ffffffffc0200a38:	0197bc23          	sd	s9,24(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc0200a3c:	01873d83          	ld	s11,24(a4)
ffffffffc0200a40:	02073d03          	ld	s10,32(a4)
            list_init(&block->page_link);
ffffffffc0200a44:	01870a93          	addi	s5,a4,24
            buddy_area[order].nr_free -= order_to_pages(order);
ffffffffc0200a48:	001b9b9b          	slliw	s7,s7,0x1
    prev->next = next;
ffffffffc0200a4c:	01adb423          	sd	s10,8(s11)
    next->prev = prev;
ffffffffc0200a50:	01bd3023          	sd	s11,0(s10)
    elm->prev = elm->next = elm;
ffffffffc0200a54:	03573023          	sd	s5,32(a4)
ffffffffc0200a58:	01573c23          	sd	s5,24(a4)
ffffffffc0200a5c:	417c0bbb          	subw	s7,s8,s7
ffffffffc0200a60:	ff782c23          	sw	s7,-8(a6)
static inline size_t order_to_pages(int order) { return (size_t)1 << order; }
ffffffffc0200a64:	00c39b33          	sll	s6,t2,a2
            struct Page *merged = (b < block) ? b : block;
ffffffffc0200a68:	00e7f463          	bgeu	a5,a4,ffffffffc0200a70 <buddy_free_pages+0x152>
ffffffffc0200a6c:	873e                	mv	a4,a5
ffffffffc0200a6e:	8ae6                	mv	s5,s9
            SetPageProperty(merged);
ffffffffc0200a70:	00873c03          	ld	s8,8(a4)
            order++;
ffffffffc0200a74:	2605                	addiw	a2,a2,1
static inline size_t order_to_pages(int order) { return (size_t)1 << order; }
ffffffffc0200a76:	00ce17b3          	sll	a5,t3,a2
    __list_add(elm, listelm, listelm->next);
ffffffffc0200a7a:	00883d03          	ld	s10,8(a6)
            merged->property = order_to_pages(order);
ffffffffc0200a7e:	00078c9b          	sext.w	s9,a5
ffffffffc0200a82:	01972823          	sw	s9,16(a4)
            SetPageProperty(merged);
ffffffffc0200a86:	002c6c13          	ori	s8,s8,2
            buddy_area[order].nr_free += order_to_pages(order);
ffffffffc0200a8a:	01082b83          	lw	s7,16(a6)
            SetPageProperty(merged);
ffffffffc0200a8e:	01873423          	sd	s8,8(a4)
    prev->next = next->prev = elm;
ffffffffc0200a92:	015d3023          	sd	s5,0(s10)
ffffffffc0200a96:	01583423          	sd	s5,8(a6)
    elm->prev = prev;
ffffffffc0200a9a:	01073c23          	sd	a6,24(a4)
    elm->next = next;
ffffffffc0200a9e:	03a73023          	sd	s10,32(a4)
            buddy_area[order].nr_free += order_to_pages(order);
ffffffffc0200aa2:	019b8abb          	addw	s5,s7,s9
ffffffffc0200aa6:	01582823          	sw	s5,16(a6)
            buddy_free_pages_count += order_to_pages(order);
ffffffffc0200aaa:	416787b3          	sub	a5,a5,s6
ffffffffc0200aae:	933e                	add	t1,t1,a5
        while (order < max_order - 1) {
ffffffffc0200ab0:	0861                	addi	a6,a6,24
ffffffffc0200ab2:	f34612e3          	bne	a2,s4,ffffffffc02009d6 <buddy_free_pages+0xb8>
    for (size_t i = 0; i < n; i++) {
ffffffffc0200ab6:	0885                	addi	a7,a7,1
ffffffffc0200ab8:	02850513          	addi	a0,a0,40
ffffffffc0200abc:	4605                	li	a2,1
ffffffffc0200abe:	ed159fe3          	bne	a1,a7,ffffffffc020099c <buddy_free_pages+0x7e>
}
ffffffffc0200ac2:	70a6                	ld	ra,104(sp)
ffffffffc0200ac4:	7406                	ld	s0,96(sp)
ffffffffc0200ac6:	00693023          	sd	t1,0(s2)
ffffffffc0200aca:	64e6                	ld	s1,88(sp)
ffffffffc0200acc:	6946                	ld	s2,80(sp)
ffffffffc0200ace:	69a6                	ld	s3,72(sp)
ffffffffc0200ad0:	6a06                	ld	s4,64(sp)
ffffffffc0200ad2:	7ae2                	ld	s5,56(sp)
ffffffffc0200ad4:	7b42                	ld	s6,48(sp)
ffffffffc0200ad6:	7ba2                	ld	s7,40(sp)
ffffffffc0200ad8:	7c02                	ld	s8,32(sp)
ffffffffc0200ada:	6ce2                	ld	s9,24(sp)
ffffffffc0200adc:	6d42                	ld	s10,16(sp)
ffffffffc0200ade:	6da2                	ld	s11,8(sp)
ffffffffc0200ae0:	6165                	addi	sp,sp,112
ffffffffc0200ae2:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc0200ae4:	00001617          	auipc	a2,0x1
ffffffffc0200ae8:	c9460613          	addi	a2,a2,-876 # ffffffffc0201778 <etext+0x498>
ffffffffc0200aec:	06a00593          	li	a1,106
ffffffffc0200af0:	00001517          	auipc	a0,0x1
ffffffffc0200af4:	ca850513          	addi	a0,a0,-856 # ffffffffc0201798 <etext+0x4b8>
ffffffffc0200af8:	00693023          	sd	t1,0(s2)
ffffffffc0200afc:	ec6ff0ef          	jal	ra,ffffffffc02001c2 <__panic>
ffffffffc0200b00:	c219                	beqz	a2,ffffffffc0200b06 <buddy_free_pages+0x1e8>
ffffffffc0200b02:	00693023          	sd	t1,0(s2)
        assert(!PageReserved(cur) && !PageProperty(cur));
ffffffffc0200b06:	00001697          	auipc	a3,0x1
ffffffffc0200b0a:	c4268693          	addi	a3,a3,-958 # ffffffffc0201748 <etext+0x468>
ffffffffc0200b0e:	00001617          	auipc	a2,0x1
ffffffffc0200b12:	a3a60613          	addi	a2,a2,-1478 # ffffffffc0201548 <etext+0x268>
ffffffffc0200b16:	09d00593          	li	a1,157
ffffffffc0200b1a:	00001517          	auipc	a0,0x1
ffffffffc0200b1e:	a4650513          	addi	a0,a0,-1466 # ffffffffc0201560 <etext+0x280>
ffffffffc0200b22:	ea0ff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(n > 0);
ffffffffc0200b26:	00001697          	auipc	a3,0x1
ffffffffc0200b2a:	a1a68693          	addi	a3,a3,-1510 # ffffffffc0201540 <etext+0x260>
ffffffffc0200b2e:	00001617          	auipc	a2,0x1
ffffffffc0200b32:	a1a60613          	addi	a2,a2,-1510 # ffffffffc0201548 <etext+0x268>
ffffffffc0200b36:	09800593          	li	a1,152
ffffffffc0200b3a:	00001517          	auipc	a0,0x1
ffffffffc0200b3e:	a2650513          	addi	a0,a0,-1498 # ffffffffc0201560 <etext+0x280>
ffffffffc0200b42:	e80ff0ef          	jal	ra,ffffffffc02001c2 <__panic>

ffffffffc0200b46 <buddy_init_memmap>:
static void buddy_init_memmap(struct Page *base, size_t n) {
ffffffffc0200b46:	1141                	addi	sp,sp,-16
ffffffffc0200b48:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0200b4a:	c1fd                	beqz	a1,ffffffffc0200c30 <buddy_init_memmap+0xea>
    managed_base_page = base;
ffffffffc0200b4c:	00004e97          	auipc	t4,0x4
ffffffffc0200b50:	664e8e93          	addi	t4,t4,1636 # ffffffffc02051b0 <buddy_free_pages_count>
ffffffffc0200b54:	000eb303          	ld	t1,0(t4)
ffffffffc0200b58:	00004797          	auipc	a5,0x4
ffffffffc0200b5c:	66a7b023          	sd	a0,1632(a5) # ffffffffc02051b8 <managed_base_page>
    managed_npages = n;
ffffffffc0200b60:	00004797          	auipc	a5,0x4
ffffffffc0200b64:	66b7b023          	sd	a1,1632(a5) # ffffffffc02051c0 <managed_npages>
ffffffffc0200b68:	4f01                	li	t5,0
        while ((order + 1) < max_order && (block << 1) <= remain) {
ffffffffc0200b6a:	48bd                	li	a7,15
    __list_add(elm, listelm, listelm->next);
ffffffffc0200b6c:	00004e17          	auipc	t3,0x4
ffffffffc0200b70:	4ace0e13          	addi	t3,t3,1196 # ffffffffc0205018 <buddy_area>
    managed_npages = n;
ffffffffc0200b74:	4701                	li	a4,0
        size_t block = 1;
ffffffffc0200b76:	4685                	li	a3,1
ffffffffc0200b78:	0007079b          	sext.w	a5,a4
ffffffffc0200b7c:	8636                	mv	a2,a3
        while ((order + 1) < max_order && (block << 1) <= remain) {
ffffffffc0200b7e:	0686                	slli	a3,a3,0x1
ffffffffc0200b80:	0007881b          	sext.w	a6,a5
ffffffffc0200b84:	2705                	addiw	a4,a4,1
ffffffffc0200b86:	06d5ef63          	bltu	a1,a3,ffffffffc0200c04 <buddy_init_memmap+0xbe>
ffffffffc0200b8a:	ff1717e3          	bne	a4,a7,ffffffffc0200b78 <buddy_init_memmap+0x32>
ffffffffc0200b8e:	483d                	li	a6,15
        for (size_t i = 0; i < block; i++) {
ffffffffc0200b90:	87aa                	mv	a5,a0
ffffffffc0200b92:	4601                	li	a2,0
ffffffffc0200b94:	ce99                	beqz	a3,ffffffffc0200bb2 <buddy_init_memmap+0x6c>
            assert(PageReserved(pp));
ffffffffc0200b96:	6798                	ld	a4,8(a5)
ffffffffc0200b98:	8b05                	andi	a4,a4,1
ffffffffc0200b9a:	c73d                	beqz	a4,ffffffffc0200c08 <buddy_init_memmap+0xc2>
            pp->flags = pp->property = 0;
ffffffffc0200b9c:	0007a823          	sw	zero,16(a5)
ffffffffc0200ba0:	0007b423          	sd	zero,8(a5)
static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc0200ba4:	0007a023          	sw	zero,0(a5)
        for (size_t i = 0; i < block; i++) {
ffffffffc0200ba8:	0605                	addi	a2,a2,1
ffffffffc0200baa:	02878793          	addi	a5,a5,40
ffffffffc0200bae:	fed614e3          	bne	a2,a3,ffffffffc0200b96 <buddy_init_memmap+0x50>
ffffffffc0200bb2:	00181793          	slli	a5,a6,0x1
ffffffffc0200bb6:	97c2                	add	a5,a5,a6
        SetPageProperty(p);
ffffffffc0200bb8:	6518                	ld	a4,8(a0)
ffffffffc0200bba:	078e                	slli	a5,a5,0x3
ffffffffc0200bbc:	97f2                	add	a5,a5,t3
ffffffffc0200bbe:	0087bf03          	ld	t5,8(a5)
        p->property = block;
ffffffffc0200bc2:	0006881b          	sext.w	a6,a3
        SetPageProperty(p);
ffffffffc0200bc6:	00276713          	ori	a4,a4,2
        buddy_area[order].nr_free += block;
ffffffffc0200bca:	4b90                	lw	a2,16(a5)
        SetPageProperty(p);
ffffffffc0200bcc:	e518                	sd	a4,8(a0)
        p->property = block;
ffffffffc0200bce:	01052823          	sw	a6,16(a0)
        list_add(&buddy_area[order].free_list, &(p->page_link));
ffffffffc0200bd2:	01850713          	addi	a4,a0,24
    prev->next = next->prev = elm;
ffffffffc0200bd6:	00ef3023          	sd	a4,0(t5)
ffffffffc0200bda:	e798                	sd	a4,8(a5)
        p += block;
ffffffffc0200bdc:	00269713          	slli	a4,a3,0x2
    elm->next = next;
ffffffffc0200be0:	03e53023          	sd	t5,32(a0)
    elm->prev = prev;
ffffffffc0200be4:	ed1c                	sd	a5,24(a0)
        buddy_area[order].nr_free += block;
ffffffffc0200be6:	0106063b          	addw	a2,a2,a6
        p += block;
ffffffffc0200bea:	9736                	add	a4,a4,a3
ffffffffc0200bec:	070e                	slli	a4,a4,0x3
        buddy_area[order].nr_free += block;
ffffffffc0200bee:	cb90                	sw	a2,16(a5)
        remain -= block;
ffffffffc0200bf0:	8d95                	sub	a1,a1,a3
        buddy_free_pages_count += block;
ffffffffc0200bf2:	9336                	add	t1,t1,a3
        p += block;
ffffffffc0200bf4:	953a                	add	a0,a0,a4
    while (remain > 0) {
ffffffffc0200bf6:	4f05                	li	t5,1
ffffffffc0200bf8:	fdb5                	bnez	a1,ffffffffc0200b74 <buddy_init_memmap+0x2e>
}
ffffffffc0200bfa:	60a2                	ld	ra,8(sp)
ffffffffc0200bfc:	006eb023          	sd	t1,0(t4)
ffffffffc0200c00:	0141                	addi	sp,sp,16
ffffffffc0200c02:	8082                	ret
ffffffffc0200c04:	86b2                	mv	a3,a2
ffffffffc0200c06:	b769                	j	ffffffffc0200b90 <buddy_init_memmap+0x4a>
ffffffffc0200c08:	000f0463          	beqz	t5,ffffffffc0200c10 <buddy_init_memmap+0xca>
ffffffffc0200c0c:	006eb023          	sd	t1,0(t4)
            assert(PageReserved(pp));
ffffffffc0200c10:	00001697          	auipc	a3,0x1
ffffffffc0200c14:	b9868693          	addi	a3,a3,-1128 # ffffffffc02017a8 <etext+0x4c8>
ffffffffc0200c18:	00001617          	auipc	a2,0x1
ffffffffc0200c1c:	93060613          	addi	a2,a2,-1744 # ffffffffc0201548 <etext+0x268>
ffffffffc0200c20:	05d00593          	li	a1,93
ffffffffc0200c24:	00001517          	auipc	a0,0x1
ffffffffc0200c28:	93c50513          	addi	a0,a0,-1732 # ffffffffc0201560 <etext+0x280>
ffffffffc0200c2c:	d96ff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(n > 0);
ffffffffc0200c30:	00001697          	auipc	a3,0x1
ffffffffc0200c34:	91068693          	addi	a3,a3,-1776 # ffffffffc0201540 <etext+0x260>
ffffffffc0200c38:	00001617          	auipc	a2,0x1
ffffffffc0200c3c:	91060613          	addi	a2,a2,-1776 # ffffffffc0201548 <etext+0x268>
ffffffffc0200c40:	04c00593          	li	a1,76
ffffffffc0200c44:	00001517          	auipc	a0,0x1
ffffffffc0200c48:	91c50513          	addi	a0,a0,-1764 # ffffffffc0201560 <etext+0x280>
ffffffffc0200c4c:	d76ff0ef          	jal	ra,ffffffffc02001c2 <__panic>

ffffffffc0200c50 <alloc_pages>:
}

// alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE
// memory
struct Page *alloc_pages(size_t n) {
    return pmm_manager->alloc_pages(n);
ffffffffc0200c50:	00004797          	auipc	a5,0x4
ffffffffc0200c54:	5887b783          	ld	a5,1416(a5) # ffffffffc02051d8 <pmm_manager>
ffffffffc0200c58:	6f9c                	ld	a5,24(a5)
ffffffffc0200c5a:	8782                	jr	a5

ffffffffc0200c5c <free_pages>:
}

// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n) {
    pmm_manager->free_pages(base, n);
ffffffffc0200c5c:	00004797          	auipc	a5,0x4
ffffffffc0200c60:	57c7b783          	ld	a5,1404(a5) # ffffffffc02051d8 <pmm_manager>
ffffffffc0200c64:	739c                	ld	a5,32(a5)
ffffffffc0200c66:	8782                	jr	a5

ffffffffc0200c68 <nr_free_pages>:
}

// nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE)
// of current free memory
size_t nr_free_pages(void) {
    return pmm_manager->nr_free_pages();
ffffffffc0200c68:	00004797          	auipc	a5,0x4
ffffffffc0200c6c:	5707b783          	ld	a5,1392(a5) # ffffffffc02051d8 <pmm_manager>
ffffffffc0200c70:	779c                	ld	a5,40(a5)
ffffffffc0200c72:	8782                	jr	a5

ffffffffc0200c74 <pmm_init>:
    pmm_manager = &buddy_pmm_manager;
ffffffffc0200c74:	00001797          	auipc	a5,0x1
ffffffffc0200c78:	b6478793          	addi	a5,a5,-1180 # ffffffffc02017d8 <buddy_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0200c7c:	638c                	ld	a1,0(a5)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
    }
}

/* pmm_init - initialize the physical memory management */
void pmm_init(void) {
ffffffffc0200c7e:	7179                	addi	sp,sp,-48
ffffffffc0200c80:	f022                	sd	s0,32(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0200c82:	00001517          	auipc	a0,0x1
ffffffffc0200c86:	b8e50513          	addi	a0,a0,-1138 # ffffffffc0201810 <buddy_pmm_manager+0x38>
    pmm_manager = &buddy_pmm_manager;
ffffffffc0200c8a:	00004417          	auipc	s0,0x4
ffffffffc0200c8e:	54e40413          	addi	s0,s0,1358 # ffffffffc02051d8 <pmm_manager>
void pmm_init(void) {
ffffffffc0200c92:	f406                	sd	ra,40(sp)
ffffffffc0200c94:	ec26                	sd	s1,24(sp)
ffffffffc0200c96:	e44e                	sd	s3,8(sp)
ffffffffc0200c98:	e84a                	sd	s2,16(sp)
ffffffffc0200c9a:	e052                	sd	s4,0(sp)
    pmm_manager = &buddy_pmm_manager;
ffffffffc0200c9c:	e01c                	sd	a5,0(s0)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0200c9e:	caeff0ef          	jal	ra,ffffffffc020014c <cprintf>
    pmm_manager->init();
ffffffffc0200ca2:	601c                	ld	a5,0(s0)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0200ca4:	00004497          	auipc	s1,0x4
ffffffffc0200ca8:	54c48493          	addi	s1,s1,1356 # ffffffffc02051f0 <va_pa_offset>
    pmm_manager->init();
ffffffffc0200cac:	679c                	ld	a5,8(a5)
ffffffffc0200cae:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0200cb0:	57f5                	li	a5,-3
ffffffffc0200cb2:	07fa                	slli	a5,a5,0x1e
ffffffffc0200cb4:	e09c                	sd	a5,0(s1)
    uint64_t mem_begin = get_memory_base();
ffffffffc0200cb6:	907ff0ef          	jal	ra,ffffffffc02005bc <get_memory_base>
ffffffffc0200cba:	89aa                	mv	s3,a0
    uint64_t mem_size  = get_memory_size();
ffffffffc0200cbc:	90bff0ef          	jal	ra,ffffffffc02005c6 <get_memory_size>
    if (mem_size == 0) {
ffffffffc0200cc0:	14050d63          	beqz	a0,ffffffffc0200e1a <pmm_init+0x1a6>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc0200cc4:	892a                	mv	s2,a0
    cprintf("physcial memory map:\n");
ffffffffc0200cc6:	00001517          	auipc	a0,0x1
ffffffffc0200cca:	b9250513          	addi	a0,a0,-1134 # ffffffffc0201858 <buddy_pmm_manager+0x80>
ffffffffc0200cce:	c7eff0ef          	jal	ra,ffffffffc020014c <cprintf>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc0200cd2:	01298a33          	add	s4,s3,s2
    cprintf("  memory: 0x%016lx, [0x%016lx, 0x%016lx].\n", mem_size, mem_begin,
ffffffffc0200cd6:	864e                	mv	a2,s3
ffffffffc0200cd8:	fffa0693          	addi	a3,s4,-1
ffffffffc0200cdc:	85ca                	mv	a1,s2
ffffffffc0200cde:	00001517          	auipc	a0,0x1
ffffffffc0200ce2:	b9250513          	addi	a0,a0,-1134 # ffffffffc0201870 <buddy_pmm_manager+0x98>
ffffffffc0200ce6:	c66ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    npage = maxpa / PGSIZE;
ffffffffc0200cea:	c80007b7          	lui	a5,0xc8000
ffffffffc0200cee:	8652                	mv	a2,s4
ffffffffc0200cf0:	0d47e463          	bltu	a5,s4,ffffffffc0200db8 <pmm_init+0x144>
ffffffffc0200cf4:	00005797          	auipc	a5,0x5
ffffffffc0200cf8:	50378793          	addi	a5,a5,1283 # ffffffffc02061f7 <end+0xfff>
ffffffffc0200cfc:	757d                	lui	a0,0xfffff
ffffffffc0200cfe:	8d7d                	and	a0,a0,a5
ffffffffc0200d00:	8231                	srli	a2,a2,0xc
ffffffffc0200d02:	00004797          	auipc	a5,0x4
ffffffffc0200d06:	4cc7b323          	sd	a2,1222(a5) # ffffffffc02051c8 <npage>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0200d0a:	00004797          	auipc	a5,0x4
ffffffffc0200d0e:	4ca7b323          	sd	a0,1222(a5) # ffffffffc02051d0 <pages>
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0200d12:	000807b7          	lui	a5,0x80
ffffffffc0200d16:	002005b7          	lui	a1,0x200
ffffffffc0200d1a:	02f60563          	beq	a2,a5,ffffffffc0200d44 <pmm_init+0xd0>
ffffffffc0200d1e:	00261593          	slli	a1,a2,0x2
ffffffffc0200d22:	00c586b3          	add	a3,a1,a2
ffffffffc0200d26:	fec007b7          	lui	a5,0xfec00
ffffffffc0200d2a:	97aa                	add	a5,a5,a0
ffffffffc0200d2c:	068e                	slli	a3,a3,0x3
ffffffffc0200d2e:	96be                	add	a3,a3,a5
ffffffffc0200d30:	87aa                	mv	a5,a0
        SetPageReserved(pages + i);
ffffffffc0200d32:	6798                	ld	a4,8(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0200d34:	02878793          	addi	a5,a5,40 # fffffffffec00028 <end+0x3e9fae30>
        SetPageReserved(pages + i);
ffffffffc0200d38:	00176713          	ori	a4,a4,1
ffffffffc0200d3c:	fee7b023          	sd	a4,-32(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0200d40:	fef699e3          	bne	a3,a5,ffffffffc0200d32 <pmm_init+0xbe>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0200d44:	95b2                	add	a1,a1,a2
ffffffffc0200d46:	fec006b7          	lui	a3,0xfec00
ffffffffc0200d4a:	96aa                	add	a3,a3,a0
ffffffffc0200d4c:	058e                	slli	a1,a1,0x3
ffffffffc0200d4e:	96ae                	add	a3,a3,a1
ffffffffc0200d50:	c02007b7          	lui	a5,0xc0200
ffffffffc0200d54:	0af6e763          	bltu	a3,a5,ffffffffc0200e02 <pmm_init+0x18e>
ffffffffc0200d58:	6098                	ld	a4,0(s1)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc0200d5a:	77fd                	lui	a5,0xfffff
ffffffffc0200d5c:	00fa75b3          	and	a1,s4,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0200d60:	8e99                	sub	a3,a3,a4
    if (freemem < mem_end) {
ffffffffc0200d62:	04b6ee63          	bltu	a3,a1,ffffffffc0200dbe <pmm_init+0x14a>
    satp_physical = PADDR(satp_virtual);
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
}

static void check_alloc_page(void) {
    pmm_manager->check();
ffffffffc0200d66:	601c                	ld	a5,0(s0)
ffffffffc0200d68:	7b9c                	ld	a5,48(a5)
ffffffffc0200d6a:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc0200d6c:	00001517          	auipc	a0,0x1
ffffffffc0200d70:	b5c50513          	addi	a0,a0,-1188 # ffffffffc02018c8 <buddy_pmm_manager+0xf0>
ffffffffc0200d74:	bd8ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    satp_virtual = (pte_t*)boot_page_table_sv39;
ffffffffc0200d78:	00003597          	auipc	a1,0x3
ffffffffc0200d7c:	28858593          	addi	a1,a1,648 # ffffffffc0204000 <boot_page_table_sv39>
ffffffffc0200d80:	00004797          	auipc	a5,0x4
ffffffffc0200d84:	46b7b423          	sd	a1,1128(a5) # ffffffffc02051e8 <satp_virtual>
    satp_physical = PADDR(satp_virtual);
ffffffffc0200d88:	c02007b7          	lui	a5,0xc0200
ffffffffc0200d8c:	0af5e363          	bltu	a1,a5,ffffffffc0200e32 <pmm_init+0x1be>
ffffffffc0200d90:	6090                	ld	a2,0(s1)
}
ffffffffc0200d92:	7402                	ld	s0,32(sp)
ffffffffc0200d94:	70a2                	ld	ra,40(sp)
ffffffffc0200d96:	64e2                	ld	s1,24(sp)
ffffffffc0200d98:	6942                	ld	s2,16(sp)
ffffffffc0200d9a:	69a2                	ld	s3,8(sp)
ffffffffc0200d9c:	6a02                	ld	s4,0(sp)
    satp_physical = PADDR(satp_virtual);
ffffffffc0200d9e:	40c58633          	sub	a2,a1,a2
ffffffffc0200da2:	00004797          	auipc	a5,0x4
ffffffffc0200da6:	42c7bf23          	sd	a2,1086(a5) # ffffffffc02051e0 <satp_physical>
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc0200daa:	00001517          	auipc	a0,0x1
ffffffffc0200dae:	b3e50513          	addi	a0,a0,-1218 # ffffffffc02018e8 <buddy_pmm_manager+0x110>
}
ffffffffc0200db2:	6145                	addi	sp,sp,48
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc0200db4:	b98ff06f          	j	ffffffffc020014c <cprintf>
    npage = maxpa / PGSIZE;
ffffffffc0200db8:	c8000637          	lui	a2,0xc8000
ffffffffc0200dbc:	bf25                	j	ffffffffc0200cf4 <pmm_init+0x80>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0200dbe:	6705                	lui	a4,0x1
ffffffffc0200dc0:	177d                	addi	a4,a4,-1
ffffffffc0200dc2:	96ba                	add	a3,a3,a4
ffffffffc0200dc4:	8efd                	and	a3,a3,a5
    if (PPN(pa) >= npage) {
ffffffffc0200dc6:	00c6d793          	srli	a5,a3,0xc
ffffffffc0200dca:	02c7f063          	bgeu	a5,a2,ffffffffc0200dea <pmm_init+0x176>
    pmm_manager->init_memmap(base, n);
ffffffffc0200dce:	6010                	ld	a2,0(s0)
    return &pages[PPN(pa) - nbase];
ffffffffc0200dd0:	fff80737          	lui	a4,0xfff80
ffffffffc0200dd4:	973e                	add	a4,a4,a5
ffffffffc0200dd6:	00271793          	slli	a5,a4,0x2
ffffffffc0200dda:	97ba                	add	a5,a5,a4
ffffffffc0200ddc:	6a18                	ld	a4,16(a2)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0200dde:	8d95                	sub	a1,a1,a3
ffffffffc0200de0:	078e                	slli	a5,a5,0x3
    pmm_manager->init_memmap(base, n);
ffffffffc0200de2:	81b1                	srli	a1,a1,0xc
ffffffffc0200de4:	953e                	add	a0,a0,a5
ffffffffc0200de6:	9702                	jalr	a4
}
ffffffffc0200de8:	bfbd                	j	ffffffffc0200d66 <pmm_init+0xf2>
        panic("pa2page called with invalid pa");
ffffffffc0200dea:	00001617          	auipc	a2,0x1
ffffffffc0200dee:	98e60613          	addi	a2,a2,-1650 # ffffffffc0201778 <etext+0x498>
ffffffffc0200df2:	06a00593          	li	a1,106
ffffffffc0200df6:	00001517          	auipc	a0,0x1
ffffffffc0200dfa:	9a250513          	addi	a0,a0,-1630 # ffffffffc0201798 <etext+0x4b8>
ffffffffc0200dfe:	bc4ff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0200e02:	00001617          	auipc	a2,0x1
ffffffffc0200e06:	a9e60613          	addi	a2,a2,-1378 # ffffffffc02018a0 <buddy_pmm_manager+0xc8>
ffffffffc0200e0a:	05f00593          	li	a1,95
ffffffffc0200e0e:	00001517          	auipc	a0,0x1
ffffffffc0200e12:	a3a50513          	addi	a0,a0,-1478 # ffffffffc0201848 <buddy_pmm_manager+0x70>
ffffffffc0200e16:	bacff0ef          	jal	ra,ffffffffc02001c2 <__panic>
        panic("DTB memory info not available");
ffffffffc0200e1a:	00001617          	auipc	a2,0x1
ffffffffc0200e1e:	a0e60613          	addi	a2,a2,-1522 # ffffffffc0201828 <buddy_pmm_manager+0x50>
ffffffffc0200e22:	04700593          	li	a1,71
ffffffffc0200e26:	00001517          	auipc	a0,0x1
ffffffffc0200e2a:	a2250513          	addi	a0,a0,-1502 # ffffffffc0201848 <buddy_pmm_manager+0x70>
ffffffffc0200e2e:	b94ff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    satp_physical = PADDR(satp_virtual);
ffffffffc0200e32:	86ae                	mv	a3,a1
ffffffffc0200e34:	00001617          	auipc	a2,0x1
ffffffffc0200e38:	a6c60613          	addi	a2,a2,-1428 # ffffffffc02018a0 <buddy_pmm_manager+0xc8>
ffffffffc0200e3c:	07a00593          	li	a1,122
ffffffffc0200e40:	00001517          	auipc	a0,0x1
ffffffffc0200e44:	a0850513          	addi	a0,a0,-1528 # ffffffffc0201848 <buddy_pmm_manager+0x70>
ffffffffc0200e48:	b7aff0ef          	jal	ra,ffffffffc02001c2 <__panic>

ffffffffc0200e4c <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc0200e4c:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0200e50:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc0200e52:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0200e56:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc0200e58:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0200e5c:	f022                	sd	s0,32(sp)
ffffffffc0200e5e:	ec26                	sd	s1,24(sp)
ffffffffc0200e60:	e84a                	sd	s2,16(sp)
ffffffffc0200e62:	f406                	sd	ra,40(sp)
ffffffffc0200e64:	e44e                	sd	s3,8(sp)
ffffffffc0200e66:	84aa                	mv	s1,a0
ffffffffc0200e68:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc0200e6a:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc0200e6e:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc0200e70:	03067e63          	bgeu	a2,a6,ffffffffc0200eac <printnum+0x60>
ffffffffc0200e74:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc0200e76:	00805763          	blez	s0,ffffffffc0200e84 <printnum+0x38>
ffffffffc0200e7a:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0200e7c:	85ca                	mv	a1,s2
ffffffffc0200e7e:	854e                	mv	a0,s3
ffffffffc0200e80:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0200e82:	fc65                	bnez	s0,ffffffffc0200e7a <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0200e84:	1a02                	slli	s4,s4,0x20
ffffffffc0200e86:	00001797          	auipc	a5,0x1
ffffffffc0200e8a:	aa278793          	addi	a5,a5,-1374 # ffffffffc0201928 <buddy_pmm_manager+0x150>
ffffffffc0200e8e:	020a5a13          	srli	s4,s4,0x20
ffffffffc0200e92:	9a3e                	add	s4,s4,a5
}
ffffffffc0200e94:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0200e96:	000a4503          	lbu	a0,0(s4)
}
ffffffffc0200e9a:	70a2                	ld	ra,40(sp)
ffffffffc0200e9c:	69a2                	ld	s3,8(sp)
ffffffffc0200e9e:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0200ea0:	85ca                	mv	a1,s2
ffffffffc0200ea2:	87a6                	mv	a5,s1
}
ffffffffc0200ea4:	6942                	ld	s2,16(sp)
ffffffffc0200ea6:	64e2                	ld	s1,24(sp)
ffffffffc0200ea8:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0200eaa:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0200eac:	03065633          	divu	a2,a2,a6
ffffffffc0200eb0:	8722                	mv	a4,s0
ffffffffc0200eb2:	f9bff0ef          	jal	ra,ffffffffc0200e4c <printnum>
ffffffffc0200eb6:	b7f9                	j	ffffffffc0200e84 <printnum+0x38>

ffffffffc0200eb8 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc0200eb8:	7119                	addi	sp,sp,-128
ffffffffc0200eba:	f4a6                	sd	s1,104(sp)
ffffffffc0200ebc:	f0ca                	sd	s2,96(sp)
ffffffffc0200ebe:	ecce                	sd	s3,88(sp)
ffffffffc0200ec0:	e8d2                	sd	s4,80(sp)
ffffffffc0200ec2:	e4d6                	sd	s5,72(sp)
ffffffffc0200ec4:	e0da                	sd	s6,64(sp)
ffffffffc0200ec6:	fc5e                	sd	s7,56(sp)
ffffffffc0200ec8:	f06a                	sd	s10,32(sp)
ffffffffc0200eca:	fc86                	sd	ra,120(sp)
ffffffffc0200ecc:	f8a2                	sd	s0,112(sp)
ffffffffc0200ece:	f862                	sd	s8,48(sp)
ffffffffc0200ed0:	f466                	sd	s9,40(sp)
ffffffffc0200ed2:	ec6e                	sd	s11,24(sp)
ffffffffc0200ed4:	892a                	mv	s2,a0
ffffffffc0200ed6:	84ae                	mv	s1,a1
ffffffffc0200ed8:	8d32                	mv	s10,a2
ffffffffc0200eda:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0200edc:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc0200ee0:	5b7d                	li	s6,-1
ffffffffc0200ee2:	00001a97          	auipc	s5,0x1
ffffffffc0200ee6:	a7aa8a93          	addi	s5,s5,-1414 # ffffffffc020195c <buddy_pmm_manager+0x184>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0200eea:	00001b97          	auipc	s7,0x1
ffffffffc0200eee:	c4eb8b93          	addi	s7,s7,-946 # ffffffffc0201b38 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0200ef2:	000d4503          	lbu	a0,0(s10)
ffffffffc0200ef6:	001d0413          	addi	s0,s10,1
ffffffffc0200efa:	01350a63          	beq	a0,s3,ffffffffc0200f0e <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc0200efe:	c121                	beqz	a0,ffffffffc0200f3e <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc0200f00:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0200f02:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc0200f04:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0200f06:	fff44503          	lbu	a0,-1(s0)
ffffffffc0200f0a:	ff351ae3          	bne	a0,s3,ffffffffc0200efe <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0200f0e:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc0200f12:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc0200f16:	4c81                	li	s9,0
ffffffffc0200f18:	4881                	li	a7,0
        width = precision = -1;
ffffffffc0200f1a:	5c7d                	li	s8,-1
ffffffffc0200f1c:	5dfd                	li	s11,-1
ffffffffc0200f1e:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc0200f22:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0200f24:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0200f28:	0ff5f593          	zext.b	a1,a1
ffffffffc0200f2c:	00140d13          	addi	s10,s0,1
ffffffffc0200f30:	04b56263          	bltu	a0,a1,ffffffffc0200f74 <vprintfmt+0xbc>
ffffffffc0200f34:	058a                	slli	a1,a1,0x2
ffffffffc0200f36:	95d6                	add	a1,a1,s5
ffffffffc0200f38:	4194                	lw	a3,0(a1)
ffffffffc0200f3a:	96d6                	add	a3,a3,s5
ffffffffc0200f3c:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0200f3e:	70e6                	ld	ra,120(sp)
ffffffffc0200f40:	7446                	ld	s0,112(sp)
ffffffffc0200f42:	74a6                	ld	s1,104(sp)
ffffffffc0200f44:	7906                	ld	s2,96(sp)
ffffffffc0200f46:	69e6                	ld	s3,88(sp)
ffffffffc0200f48:	6a46                	ld	s4,80(sp)
ffffffffc0200f4a:	6aa6                	ld	s5,72(sp)
ffffffffc0200f4c:	6b06                	ld	s6,64(sp)
ffffffffc0200f4e:	7be2                	ld	s7,56(sp)
ffffffffc0200f50:	7c42                	ld	s8,48(sp)
ffffffffc0200f52:	7ca2                	ld	s9,40(sp)
ffffffffc0200f54:	7d02                	ld	s10,32(sp)
ffffffffc0200f56:	6de2                	ld	s11,24(sp)
ffffffffc0200f58:	6109                	addi	sp,sp,128
ffffffffc0200f5a:	8082                	ret
            padc = '0';
ffffffffc0200f5c:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc0200f5e:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0200f62:	846a                	mv	s0,s10
ffffffffc0200f64:	00140d13          	addi	s10,s0,1
ffffffffc0200f68:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0200f6c:	0ff5f593          	zext.b	a1,a1
ffffffffc0200f70:	fcb572e3          	bgeu	a0,a1,ffffffffc0200f34 <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc0200f74:	85a6                	mv	a1,s1
ffffffffc0200f76:	02500513          	li	a0,37
ffffffffc0200f7a:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0200f7c:	fff44783          	lbu	a5,-1(s0)
ffffffffc0200f80:	8d22                	mv	s10,s0
ffffffffc0200f82:	f73788e3          	beq	a5,s3,ffffffffc0200ef2 <vprintfmt+0x3a>
ffffffffc0200f86:	ffed4783          	lbu	a5,-2(s10)
ffffffffc0200f8a:	1d7d                	addi	s10,s10,-1
ffffffffc0200f8c:	ff379de3          	bne	a5,s3,ffffffffc0200f86 <vprintfmt+0xce>
ffffffffc0200f90:	b78d                	j	ffffffffc0200ef2 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc0200f92:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc0200f96:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0200f9a:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc0200f9c:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc0200fa0:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc0200fa4:	02d86463          	bltu	a6,a3,ffffffffc0200fcc <vprintfmt+0x114>
                ch = *fmt;
ffffffffc0200fa8:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0200fac:	002c169b          	slliw	a3,s8,0x2
ffffffffc0200fb0:	0186873b          	addw	a4,a3,s8
ffffffffc0200fb4:	0017171b          	slliw	a4,a4,0x1
ffffffffc0200fb8:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc0200fba:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc0200fbe:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc0200fc0:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc0200fc4:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc0200fc8:	fed870e3          	bgeu	a6,a3,ffffffffc0200fa8 <vprintfmt+0xf0>
            if (width < 0)
ffffffffc0200fcc:	f40ddce3          	bgez	s11,ffffffffc0200f24 <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc0200fd0:	8de2                	mv	s11,s8
ffffffffc0200fd2:	5c7d                	li	s8,-1
ffffffffc0200fd4:	bf81                	j	ffffffffc0200f24 <vprintfmt+0x6c>
            if (width < 0)
ffffffffc0200fd6:	fffdc693          	not	a3,s11
ffffffffc0200fda:	96fd                	srai	a3,a3,0x3f
ffffffffc0200fdc:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0200fe0:	00144603          	lbu	a2,1(s0)
ffffffffc0200fe4:	2d81                	sext.w	s11,s11
ffffffffc0200fe6:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0200fe8:	bf35                	j	ffffffffc0200f24 <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc0200fea:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0200fee:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc0200ff2:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0200ff4:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc0200ff6:	bfd9                	j	ffffffffc0200fcc <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc0200ff8:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0200ffa:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0200ffe:	01174463          	blt	a4,a7,ffffffffc0201006 <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc0201002:	1a088e63          	beqz	a7,ffffffffc02011be <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc0201006:	000a3603          	ld	a2,0(s4)
ffffffffc020100a:	46c1                	li	a3,16
ffffffffc020100c:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc020100e:	2781                	sext.w	a5,a5
ffffffffc0201010:	876e                	mv	a4,s11
ffffffffc0201012:	85a6                	mv	a1,s1
ffffffffc0201014:	854a                	mv	a0,s2
ffffffffc0201016:	e37ff0ef          	jal	ra,ffffffffc0200e4c <printnum>
            break;
ffffffffc020101a:	bde1                	j	ffffffffc0200ef2 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc020101c:	000a2503          	lw	a0,0(s4)
ffffffffc0201020:	85a6                	mv	a1,s1
ffffffffc0201022:	0a21                	addi	s4,s4,8
ffffffffc0201024:	9902                	jalr	s2
            break;
ffffffffc0201026:	b5f1                	j	ffffffffc0200ef2 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0201028:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc020102a:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc020102e:	01174463          	blt	a4,a7,ffffffffc0201036 <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc0201032:	18088163          	beqz	a7,ffffffffc02011b4 <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc0201036:	000a3603          	ld	a2,0(s4)
ffffffffc020103a:	46a9                	li	a3,10
ffffffffc020103c:	8a2e                	mv	s4,a1
ffffffffc020103e:	bfc1                	j	ffffffffc020100e <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201040:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc0201044:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201046:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0201048:	bdf1                	j	ffffffffc0200f24 <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc020104a:	85a6                	mv	a1,s1
ffffffffc020104c:	02500513          	li	a0,37
ffffffffc0201050:	9902                	jalr	s2
            break;
ffffffffc0201052:	b545                	j	ffffffffc0200ef2 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201054:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc0201058:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020105a:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc020105c:	b5e1                	j	ffffffffc0200f24 <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc020105e:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201060:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0201064:	01174463          	blt	a4,a7,ffffffffc020106c <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc0201068:	14088163          	beqz	a7,ffffffffc02011aa <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc020106c:	000a3603          	ld	a2,0(s4)
ffffffffc0201070:	46a1                	li	a3,8
ffffffffc0201072:	8a2e                	mv	s4,a1
ffffffffc0201074:	bf69                	j	ffffffffc020100e <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc0201076:	03000513          	li	a0,48
ffffffffc020107a:	85a6                	mv	a1,s1
ffffffffc020107c:	e03e                	sd	a5,0(sp)
ffffffffc020107e:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc0201080:	85a6                	mv	a1,s1
ffffffffc0201082:	07800513          	li	a0,120
ffffffffc0201086:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0201088:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc020108a:	6782                	ld	a5,0(sp)
ffffffffc020108c:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc020108e:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc0201092:	bfb5                	j	ffffffffc020100e <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201094:	000a3403          	ld	s0,0(s4)
ffffffffc0201098:	008a0713          	addi	a4,s4,8
ffffffffc020109c:	e03a                	sd	a4,0(sp)
ffffffffc020109e:	14040263          	beqz	s0,ffffffffc02011e2 <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc02010a2:	0fb05763          	blez	s11,ffffffffc0201190 <vprintfmt+0x2d8>
ffffffffc02010a6:	02d00693          	li	a3,45
ffffffffc02010aa:	0cd79163          	bne	a5,a3,ffffffffc020116c <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02010ae:	00044783          	lbu	a5,0(s0)
ffffffffc02010b2:	0007851b          	sext.w	a0,a5
ffffffffc02010b6:	cf85                	beqz	a5,ffffffffc02010ee <vprintfmt+0x236>
ffffffffc02010b8:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02010bc:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02010c0:	000c4563          	bltz	s8,ffffffffc02010ca <vprintfmt+0x212>
ffffffffc02010c4:	3c7d                	addiw	s8,s8,-1
ffffffffc02010c6:	036c0263          	beq	s8,s6,ffffffffc02010ea <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc02010ca:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02010cc:	0e0c8e63          	beqz	s9,ffffffffc02011c8 <vprintfmt+0x310>
ffffffffc02010d0:	3781                	addiw	a5,a5,-32
ffffffffc02010d2:	0ef47b63          	bgeu	s0,a5,ffffffffc02011c8 <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc02010d6:	03f00513          	li	a0,63
ffffffffc02010da:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02010dc:	000a4783          	lbu	a5,0(s4)
ffffffffc02010e0:	3dfd                	addiw	s11,s11,-1
ffffffffc02010e2:	0a05                	addi	s4,s4,1
ffffffffc02010e4:	0007851b          	sext.w	a0,a5
ffffffffc02010e8:	ffe1                	bnez	a5,ffffffffc02010c0 <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc02010ea:	01b05963          	blez	s11,ffffffffc02010fc <vprintfmt+0x244>
ffffffffc02010ee:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc02010f0:	85a6                	mv	a1,s1
ffffffffc02010f2:	02000513          	li	a0,32
ffffffffc02010f6:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc02010f8:	fe0d9be3          	bnez	s11,ffffffffc02010ee <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc02010fc:	6a02                	ld	s4,0(sp)
ffffffffc02010fe:	bbd5                	j	ffffffffc0200ef2 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0201100:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201102:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc0201106:	01174463          	blt	a4,a7,ffffffffc020110e <vprintfmt+0x256>
    else if (lflag) {
ffffffffc020110a:	08088d63          	beqz	a7,ffffffffc02011a4 <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc020110e:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0201112:	0a044d63          	bltz	s0,ffffffffc02011cc <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc0201116:	8622                	mv	a2,s0
ffffffffc0201118:	8a66                	mv	s4,s9
ffffffffc020111a:	46a9                	li	a3,10
ffffffffc020111c:	bdcd                	j	ffffffffc020100e <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc020111e:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0201122:	4719                	li	a4,6
            err = va_arg(ap, int);
ffffffffc0201124:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc0201126:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc020112a:	8fb5                	xor	a5,a5,a3
ffffffffc020112c:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0201130:	02d74163          	blt	a4,a3,ffffffffc0201152 <vprintfmt+0x29a>
ffffffffc0201134:	00369793          	slli	a5,a3,0x3
ffffffffc0201138:	97de                	add	a5,a5,s7
ffffffffc020113a:	639c                	ld	a5,0(a5)
ffffffffc020113c:	cb99                	beqz	a5,ffffffffc0201152 <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc020113e:	86be                	mv	a3,a5
ffffffffc0201140:	00001617          	auipc	a2,0x1
ffffffffc0201144:	81860613          	addi	a2,a2,-2024 # ffffffffc0201958 <buddy_pmm_manager+0x180>
ffffffffc0201148:	85a6                	mv	a1,s1
ffffffffc020114a:	854a                	mv	a0,s2
ffffffffc020114c:	0ce000ef          	jal	ra,ffffffffc020121a <printfmt>
ffffffffc0201150:	b34d                	j	ffffffffc0200ef2 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0201152:	00000617          	auipc	a2,0x0
ffffffffc0201156:	7f660613          	addi	a2,a2,2038 # ffffffffc0201948 <buddy_pmm_manager+0x170>
ffffffffc020115a:	85a6                	mv	a1,s1
ffffffffc020115c:	854a                	mv	a0,s2
ffffffffc020115e:	0bc000ef          	jal	ra,ffffffffc020121a <printfmt>
ffffffffc0201162:	bb41                	j	ffffffffc0200ef2 <vprintfmt+0x3a>
                p = "(null)";
ffffffffc0201164:	00000417          	auipc	s0,0x0
ffffffffc0201168:	7dc40413          	addi	s0,s0,2012 # ffffffffc0201940 <buddy_pmm_manager+0x168>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020116c:	85e2                	mv	a1,s8
ffffffffc020116e:	8522                	mv	a0,s0
ffffffffc0201170:	e43e                	sd	a5,8(sp)
ffffffffc0201172:	0fc000ef          	jal	ra,ffffffffc020126e <strnlen>
ffffffffc0201176:	40ad8dbb          	subw	s11,s11,a0
ffffffffc020117a:	01b05b63          	blez	s11,ffffffffc0201190 <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc020117e:	67a2                	ld	a5,8(sp)
ffffffffc0201180:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201184:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc0201186:	85a6                	mv	a1,s1
ffffffffc0201188:	8552                	mv	a0,s4
ffffffffc020118a:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020118c:	fe0d9ce3          	bnez	s11,ffffffffc0201184 <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201190:	00044783          	lbu	a5,0(s0)
ffffffffc0201194:	00140a13          	addi	s4,s0,1
ffffffffc0201198:	0007851b          	sext.w	a0,a5
ffffffffc020119c:	d3a5                	beqz	a5,ffffffffc02010fc <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc020119e:	05e00413          	li	s0,94
ffffffffc02011a2:	bf39                	j	ffffffffc02010c0 <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc02011a4:	000a2403          	lw	s0,0(s4)
ffffffffc02011a8:	b7ad                	j	ffffffffc0201112 <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc02011aa:	000a6603          	lwu	a2,0(s4)
ffffffffc02011ae:	46a1                	li	a3,8
ffffffffc02011b0:	8a2e                	mv	s4,a1
ffffffffc02011b2:	bdb1                	j	ffffffffc020100e <vprintfmt+0x156>
ffffffffc02011b4:	000a6603          	lwu	a2,0(s4)
ffffffffc02011b8:	46a9                	li	a3,10
ffffffffc02011ba:	8a2e                	mv	s4,a1
ffffffffc02011bc:	bd89                	j	ffffffffc020100e <vprintfmt+0x156>
ffffffffc02011be:	000a6603          	lwu	a2,0(s4)
ffffffffc02011c2:	46c1                	li	a3,16
ffffffffc02011c4:	8a2e                	mv	s4,a1
ffffffffc02011c6:	b5a1                	j	ffffffffc020100e <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc02011c8:	9902                	jalr	s2
ffffffffc02011ca:	bf09                	j	ffffffffc02010dc <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc02011cc:	85a6                	mv	a1,s1
ffffffffc02011ce:	02d00513          	li	a0,45
ffffffffc02011d2:	e03e                	sd	a5,0(sp)
ffffffffc02011d4:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc02011d6:	6782                	ld	a5,0(sp)
ffffffffc02011d8:	8a66                	mv	s4,s9
ffffffffc02011da:	40800633          	neg	a2,s0
ffffffffc02011de:	46a9                	li	a3,10
ffffffffc02011e0:	b53d                	j	ffffffffc020100e <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc02011e2:	03b05163          	blez	s11,ffffffffc0201204 <vprintfmt+0x34c>
ffffffffc02011e6:	02d00693          	li	a3,45
ffffffffc02011ea:	f6d79de3          	bne	a5,a3,ffffffffc0201164 <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc02011ee:	00000417          	auipc	s0,0x0
ffffffffc02011f2:	75240413          	addi	s0,s0,1874 # ffffffffc0201940 <buddy_pmm_manager+0x168>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02011f6:	02800793          	li	a5,40
ffffffffc02011fa:	02800513          	li	a0,40
ffffffffc02011fe:	00140a13          	addi	s4,s0,1
ffffffffc0201202:	bd6d                	j	ffffffffc02010bc <vprintfmt+0x204>
ffffffffc0201204:	00000a17          	auipc	s4,0x0
ffffffffc0201208:	73da0a13          	addi	s4,s4,1853 # ffffffffc0201941 <buddy_pmm_manager+0x169>
ffffffffc020120c:	02800513          	li	a0,40
ffffffffc0201210:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201214:	05e00413          	li	s0,94
ffffffffc0201218:	b565                	j	ffffffffc02010c0 <vprintfmt+0x208>

ffffffffc020121a <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc020121a:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc020121c:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201220:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0201222:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201224:	ec06                	sd	ra,24(sp)
ffffffffc0201226:	f83a                	sd	a4,48(sp)
ffffffffc0201228:	fc3e                	sd	a5,56(sp)
ffffffffc020122a:	e0c2                	sd	a6,64(sp)
ffffffffc020122c:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc020122e:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0201230:	c89ff0ef          	jal	ra,ffffffffc0200eb8 <vprintfmt>
}
ffffffffc0201234:	60e2                	ld	ra,24(sp)
ffffffffc0201236:	6161                	addi	sp,sp,80
ffffffffc0201238:	8082                	ret

ffffffffc020123a <sbi_console_putchar>:
uint64_t SBI_REMOTE_SFENCE_VMA_ASID = 7;
uint64_t SBI_SHUTDOWN = 8;

uint64_t sbi_call(uint64_t sbi_type, uint64_t arg0, uint64_t arg1, uint64_t arg2) {
    uint64_t ret_val;
    __asm__ volatile (
ffffffffc020123a:	4781                	li	a5,0
ffffffffc020123c:	00004717          	auipc	a4,0x4
ffffffffc0201240:	dd473703          	ld	a4,-556(a4) # ffffffffc0205010 <SBI_CONSOLE_PUTCHAR>
ffffffffc0201244:	88ba                	mv	a7,a4
ffffffffc0201246:	852a                	mv	a0,a0
ffffffffc0201248:	85be                	mv	a1,a5
ffffffffc020124a:	863e                	mv	a2,a5
ffffffffc020124c:	00000073          	ecall
ffffffffc0201250:	87aa                	mv	a5,a0
    return ret_val;
}

void sbi_console_putchar(unsigned char ch) {
    sbi_call(SBI_CONSOLE_PUTCHAR, ch, 0, 0);
}
ffffffffc0201252:	8082                	ret

ffffffffc0201254 <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc0201254:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc0201258:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc020125a:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc020125c:	cb81                	beqz	a5,ffffffffc020126c <strlen+0x18>
        cnt ++;
ffffffffc020125e:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc0201260:	00a707b3          	add	a5,a4,a0
ffffffffc0201264:	0007c783          	lbu	a5,0(a5)
ffffffffc0201268:	fbfd                	bnez	a5,ffffffffc020125e <strlen+0xa>
ffffffffc020126a:	8082                	ret
    }
    return cnt;
}
ffffffffc020126c:	8082                	ret

ffffffffc020126e <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc020126e:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc0201270:	e589                	bnez	a1,ffffffffc020127a <strnlen+0xc>
ffffffffc0201272:	a811                	j	ffffffffc0201286 <strnlen+0x18>
        cnt ++;
ffffffffc0201274:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0201276:	00f58863          	beq	a1,a5,ffffffffc0201286 <strnlen+0x18>
ffffffffc020127a:	00f50733          	add	a4,a0,a5
ffffffffc020127e:	00074703          	lbu	a4,0(a4)
ffffffffc0201282:	fb6d                	bnez	a4,ffffffffc0201274 <strnlen+0x6>
ffffffffc0201284:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc0201286:	852e                	mv	a0,a1
ffffffffc0201288:	8082                	ret

ffffffffc020128a <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc020128a:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc020128e:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0201292:	cb89                	beqz	a5,ffffffffc02012a4 <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc0201294:	0505                	addi	a0,a0,1
ffffffffc0201296:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0201298:	fee789e3          	beq	a5,a4,ffffffffc020128a <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc020129c:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc02012a0:	9d19                	subw	a0,a0,a4
ffffffffc02012a2:	8082                	ret
ffffffffc02012a4:	4501                	li	a0,0
ffffffffc02012a6:	bfed                	j	ffffffffc02012a0 <strcmp+0x16>

ffffffffc02012a8 <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc02012a8:	c20d                	beqz	a2,ffffffffc02012ca <strncmp+0x22>
ffffffffc02012aa:	962e                	add	a2,a2,a1
ffffffffc02012ac:	a031                	j	ffffffffc02012b8 <strncmp+0x10>
        n --, s1 ++, s2 ++;
ffffffffc02012ae:	0505                	addi	a0,a0,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc02012b0:	00e79a63          	bne	a5,a4,ffffffffc02012c4 <strncmp+0x1c>
ffffffffc02012b4:	00b60b63          	beq	a2,a1,ffffffffc02012ca <strncmp+0x22>
ffffffffc02012b8:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc02012bc:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc02012be:	fff5c703          	lbu	a4,-1(a1)
ffffffffc02012c2:	f7f5                	bnez	a5,ffffffffc02012ae <strncmp+0x6>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02012c4:	40e7853b          	subw	a0,a5,a4
}
ffffffffc02012c8:	8082                	ret
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02012ca:	4501                	li	a0,0
ffffffffc02012cc:	8082                	ret

ffffffffc02012ce <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc02012ce:	ca01                	beqz	a2,ffffffffc02012de <memset+0x10>
ffffffffc02012d0:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc02012d2:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc02012d4:	0785                	addi	a5,a5,1
ffffffffc02012d6:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc02012da:	fec79de3          	bne	a5,a2,ffffffffc02012d4 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc02012de:	8082                	ret
