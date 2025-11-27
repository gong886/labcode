
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
ffffffffc0200000:	00009297          	auipc	t0,0x9
ffffffffc0200004:	00028293          	mv	t0,t0
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc0209000 <boot_hartid>
ffffffffc020000c:	00009297          	auipc	t0,0x9
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc0209008 <boot_dtb>
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)
ffffffffc0200018:	c02082b7          	lui	t0,0xc0208
ffffffffc020001c:	ffd0031b          	addiw	t1,zero,-3
ffffffffc0200020:	037a                	slli	t1,t1,0x1e
ffffffffc0200022:	406282b3          	sub	t0,t0,t1
ffffffffc0200026:	00c2d293          	srli	t0,t0,0xc
ffffffffc020002a:	fff0031b          	addiw	t1,zero,-1
ffffffffc020002e:	137e                	slli	t1,t1,0x3f
ffffffffc0200030:	0062e2b3          	or	t0,t0,t1
ffffffffc0200034:	18029073          	csrw	satp,t0
ffffffffc0200038:	12000073          	sfence.vma
ffffffffc020003c:	c0208137          	lui	sp,0xc0208
ffffffffc0200040:	c02002b7          	lui	t0,0xc0200
ffffffffc0200044:	04a28293          	addi	t0,t0,74 # ffffffffc020004a <kern_init>
ffffffffc0200048:	8282                	jr	t0

ffffffffc020004a <kern_init>:
ffffffffc020004a:	00009517          	auipc	a0,0x9
ffffffffc020004e:	fe650513          	addi	a0,a0,-26 # ffffffffc0209030 <buf>
ffffffffc0200052:	0000d617          	auipc	a2,0xd
ffffffffc0200056:	49a60613          	addi	a2,a2,1178 # ffffffffc020d4ec <end>
ffffffffc020005a:	1141                	addi	sp,sp,-16
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
ffffffffc0200060:	e406                	sd	ra,8(sp)
ffffffffc0200062:	5e9030ef          	jal	ra,ffffffffc0203e4a <memset>
ffffffffc0200066:	514000ef          	jal	ra,ffffffffc020057a <dtb_init>
ffffffffc020006a:	49e000ef          	jal	ra,ffffffffc0200508 <cons_init>
ffffffffc020006e:	00004597          	auipc	a1,0x4
ffffffffc0200072:	e2a58593          	addi	a1,a1,-470 # ffffffffc0203e98 <etext>
ffffffffc0200076:	00004517          	auipc	a0,0x4
ffffffffc020007a:	e4250513          	addi	a0,a0,-446 # ffffffffc0203eb8 <etext+0x20>
ffffffffc020007e:	116000ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200082:	15a000ef          	jal	ra,ffffffffc02001dc <print_kerninfo>
ffffffffc0200086:	0d0020ef          	jal	ra,ffffffffc0202156 <pmm_init>
ffffffffc020008a:	0ad000ef          	jal	ra,ffffffffc0200936 <pic_init>
ffffffffc020008e:	0ab000ef          	jal	ra,ffffffffc0200938 <idt_init>
ffffffffc0200092:	639020ef          	jal	ra,ffffffffc0202eca <vmm_init>
ffffffffc0200096:	574030ef          	jal	ra,ffffffffc020360a <proc_init>
ffffffffc020009a:	41c000ef          	jal	ra,ffffffffc02004b6 <clock_init>
ffffffffc020009e:	08d000ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc02000a2:	7b6030ef          	jal	ra,ffffffffc0203858 <cpu_idle>

ffffffffc02000a6 <readline>:
ffffffffc02000a6:	715d                	addi	sp,sp,-80
ffffffffc02000a8:	e486                	sd	ra,72(sp)
ffffffffc02000aa:	e0a6                	sd	s1,64(sp)
ffffffffc02000ac:	fc4a                	sd	s2,56(sp)
ffffffffc02000ae:	f84e                	sd	s3,48(sp)
ffffffffc02000b0:	f452                	sd	s4,40(sp)
ffffffffc02000b2:	f056                	sd	s5,32(sp)
ffffffffc02000b4:	ec5a                	sd	s6,24(sp)
ffffffffc02000b6:	e85e                	sd	s7,16(sp)
ffffffffc02000b8:	c901                	beqz	a0,ffffffffc02000c8 <readline+0x22>
ffffffffc02000ba:	85aa                	mv	a1,a0
ffffffffc02000bc:	00004517          	auipc	a0,0x4
ffffffffc02000c0:	e0450513          	addi	a0,a0,-508 # ffffffffc0203ec0 <etext+0x28>
ffffffffc02000c4:	0d0000ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02000c8:	4481                	li	s1,0
ffffffffc02000ca:	497d                	li	s2,31
ffffffffc02000cc:	49a1                	li	s3,8
ffffffffc02000ce:	4aa9                	li	s5,10
ffffffffc02000d0:	4b35                	li	s6,13
ffffffffc02000d2:	00009b97          	auipc	s7,0x9
ffffffffc02000d6:	f5eb8b93          	addi	s7,s7,-162 # ffffffffc0209030 <buf>
ffffffffc02000da:	3fe00a13          	li	s4,1022
ffffffffc02000de:	0ee000ef          	jal	ra,ffffffffc02001cc <getchar>
ffffffffc02000e2:	00054a63          	bltz	a0,ffffffffc02000f6 <readline+0x50>
ffffffffc02000e6:	00a95a63          	bge	s2,a0,ffffffffc02000fa <readline+0x54>
ffffffffc02000ea:	029a5263          	bge	s4,s1,ffffffffc020010e <readline+0x68>
ffffffffc02000ee:	0de000ef          	jal	ra,ffffffffc02001cc <getchar>
ffffffffc02000f2:	fe055ae3          	bgez	a0,ffffffffc02000e6 <readline+0x40>
ffffffffc02000f6:	4501                	li	a0,0
ffffffffc02000f8:	a091                	j	ffffffffc020013c <readline+0x96>
ffffffffc02000fa:	03351463          	bne	a0,s3,ffffffffc0200122 <readline+0x7c>
ffffffffc02000fe:	e8a9                	bnez	s1,ffffffffc0200150 <readline+0xaa>
ffffffffc0200100:	0cc000ef          	jal	ra,ffffffffc02001cc <getchar>
ffffffffc0200104:	fe0549e3          	bltz	a0,ffffffffc02000f6 <readline+0x50>
ffffffffc0200108:	fea959e3          	bge	s2,a0,ffffffffc02000fa <readline+0x54>
ffffffffc020010c:	4481                	li	s1,0
ffffffffc020010e:	e42a                	sd	a0,8(sp)
ffffffffc0200110:	0ba000ef          	jal	ra,ffffffffc02001ca <cputchar>
ffffffffc0200114:	6522                	ld	a0,8(sp)
ffffffffc0200116:	009b87b3          	add	a5,s7,s1
ffffffffc020011a:	2485                	addiw	s1,s1,1
ffffffffc020011c:	00a78023          	sb	a0,0(a5)
ffffffffc0200120:	bf7d                	j	ffffffffc02000de <readline+0x38>
ffffffffc0200122:	01550463          	beq	a0,s5,ffffffffc020012a <readline+0x84>
ffffffffc0200126:	fb651ce3          	bne	a0,s6,ffffffffc02000de <readline+0x38>
ffffffffc020012a:	0a0000ef          	jal	ra,ffffffffc02001ca <cputchar>
ffffffffc020012e:	00009517          	auipc	a0,0x9
ffffffffc0200132:	f0250513          	addi	a0,a0,-254 # ffffffffc0209030 <buf>
ffffffffc0200136:	94aa                	add	s1,s1,a0
ffffffffc0200138:	00048023          	sb	zero,0(s1)
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
ffffffffc0200150:	4521                	li	a0,8
ffffffffc0200152:	078000ef          	jal	ra,ffffffffc02001ca <cputchar>
ffffffffc0200156:	34fd                	addiw	s1,s1,-1
ffffffffc0200158:	b759                	j	ffffffffc02000de <readline+0x38>

ffffffffc020015a <cputch>:
ffffffffc020015a:	1141                	addi	sp,sp,-16
ffffffffc020015c:	e022                	sd	s0,0(sp)
ffffffffc020015e:	e406                	sd	ra,8(sp)
ffffffffc0200160:	842e                	mv	s0,a1
ffffffffc0200162:	3a8000ef          	jal	ra,ffffffffc020050a <cons_putc>
ffffffffc0200166:	401c                	lw	a5,0(s0)
ffffffffc0200168:	60a2                	ld	ra,8(sp)
ffffffffc020016a:	2785                	addiw	a5,a5,1
ffffffffc020016c:	c01c                	sw	a5,0(s0)
ffffffffc020016e:	6402                	ld	s0,0(sp)
ffffffffc0200170:	0141                	addi	sp,sp,16
ffffffffc0200172:	8082                	ret

ffffffffc0200174 <vcprintf>:
ffffffffc0200174:	1101                	addi	sp,sp,-32
ffffffffc0200176:	862a                	mv	a2,a0
ffffffffc0200178:	86ae                	mv	a3,a1
ffffffffc020017a:	00000517          	auipc	a0,0x0
ffffffffc020017e:	fe050513          	addi	a0,a0,-32 # ffffffffc020015a <cputch>
ffffffffc0200182:	006c                	addi	a1,sp,12
ffffffffc0200184:	ec06                	sd	ra,24(sp)
ffffffffc0200186:	c602                	sw	zero,12(sp)
ffffffffc0200188:	09f030ef          	jal	ra,ffffffffc0203a26 <vprintfmt>
ffffffffc020018c:	60e2                	ld	ra,24(sp)
ffffffffc020018e:	4532                	lw	a0,12(sp)
ffffffffc0200190:	6105                	addi	sp,sp,32
ffffffffc0200192:	8082                	ret

ffffffffc0200194 <cprintf>:
ffffffffc0200194:	711d                	addi	sp,sp,-96
ffffffffc0200196:	02810313          	addi	t1,sp,40 # ffffffffc0208028 <boot_page_table_sv39+0x28>
ffffffffc020019a:	8e2a                	mv	t3,a0
ffffffffc020019c:	f42e                	sd	a1,40(sp)
ffffffffc020019e:	f832                	sd	a2,48(sp)
ffffffffc02001a0:	fc36                	sd	a3,56(sp)
ffffffffc02001a2:	00000517          	auipc	a0,0x0
ffffffffc02001a6:	fb850513          	addi	a0,a0,-72 # ffffffffc020015a <cputch>
ffffffffc02001aa:	004c                	addi	a1,sp,4
ffffffffc02001ac:	869a                	mv	a3,t1
ffffffffc02001ae:	8672                	mv	a2,t3
ffffffffc02001b0:	ec06                	sd	ra,24(sp)
ffffffffc02001b2:	e0ba                	sd	a4,64(sp)
ffffffffc02001b4:	e4be                	sd	a5,72(sp)
ffffffffc02001b6:	e8c2                	sd	a6,80(sp)
ffffffffc02001b8:	ecc6                	sd	a7,88(sp)
ffffffffc02001ba:	e41a                	sd	t1,8(sp)
ffffffffc02001bc:	c202                	sw	zero,4(sp)
ffffffffc02001be:	069030ef          	jal	ra,ffffffffc0203a26 <vprintfmt>
ffffffffc02001c2:	60e2                	ld	ra,24(sp)
ffffffffc02001c4:	4512                	lw	a0,4(sp)
ffffffffc02001c6:	6125                	addi	sp,sp,96
ffffffffc02001c8:	8082                	ret

ffffffffc02001ca <cputchar>:
ffffffffc02001ca:	a681                	j	ffffffffc020050a <cons_putc>

ffffffffc02001cc <getchar>:
ffffffffc02001cc:	1141                	addi	sp,sp,-16
ffffffffc02001ce:	e406                	sd	ra,8(sp)
ffffffffc02001d0:	36e000ef          	jal	ra,ffffffffc020053e <cons_getc>
ffffffffc02001d4:	dd75                	beqz	a0,ffffffffc02001d0 <getchar+0x4>
ffffffffc02001d6:	60a2                	ld	ra,8(sp)
ffffffffc02001d8:	0141                	addi	sp,sp,16
ffffffffc02001da:	8082                	ret

ffffffffc02001dc <print_kerninfo>:
ffffffffc02001dc:	1141                	addi	sp,sp,-16
ffffffffc02001de:	00004517          	auipc	a0,0x4
ffffffffc02001e2:	cea50513          	addi	a0,a0,-790 # ffffffffc0203ec8 <etext+0x30>
ffffffffc02001e6:	e406                	sd	ra,8(sp)
ffffffffc02001e8:	fadff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02001ec:	00000597          	auipc	a1,0x0
ffffffffc02001f0:	e5e58593          	addi	a1,a1,-418 # ffffffffc020004a <kern_init>
ffffffffc02001f4:	00004517          	auipc	a0,0x4
ffffffffc02001f8:	cf450513          	addi	a0,a0,-780 # ffffffffc0203ee8 <etext+0x50>
ffffffffc02001fc:	f99ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200200:	00004597          	auipc	a1,0x4
ffffffffc0200204:	c9858593          	addi	a1,a1,-872 # ffffffffc0203e98 <etext>
ffffffffc0200208:	00004517          	auipc	a0,0x4
ffffffffc020020c:	d0050513          	addi	a0,a0,-768 # ffffffffc0203f08 <etext+0x70>
ffffffffc0200210:	f85ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200214:	00009597          	auipc	a1,0x9
ffffffffc0200218:	e1c58593          	addi	a1,a1,-484 # ffffffffc0209030 <buf>
ffffffffc020021c:	00004517          	auipc	a0,0x4
ffffffffc0200220:	d0c50513          	addi	a0,a0,-756 # ffffffffc0203f28 <etext+0x90>
ffffffffc0200224:	f71ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200228:	0000d597          	auipc	a1,0xd
ffffffffc020022c:	2c458593          	addi	a1,a1,708 # ffffffffc020d4ec <end>
ffffffffc0200230:	00004517          	auipc	a0,0x4
ffffffffc0200234:	d1850513          	addi	a0,a0,-744 # ffffffffc0203f48 <etext+0xb0>
ffffffffc0200238:	f5dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc020023c:	0000d597          	auipc	a1,0xd
ffffffffc0200240:	6af58593          	addi	a1,a1,1711 # ffffffffc020d8eb <end+0x3ff>
ffffffffc0200244:	00000797          	auipc	a5,0x0
ffffffffc0200248:	e0678793          	addi	a5,a5,-506 # ffffffffc020004a <kern_init>
ffffffffc020024c:	40f587b3          	sub	a5,a1,a5
ffffffffc0200250:	43f7d593          	srai	a1,a5,0x3f
ffffffffc0200254:	60a2                	ld	ra,8(sp)
ffffffffc0200256:	3ff5f593          	andi	a1,a1,1023
ffffffffc020025a:	95be                	add	a1,a1,a5
ffffffffc020025c:	85a9                	srai	a1,a1,0xa
ffffffffc020025e:	00004517          	auipc	a0,0x4
ffffffffc0200262:	d0a50513          	addi	a0,a0,-758 # ffffffffc0203f68 <etext+0xd0>
ffffffffc0200266:	0141                	addi	sp,sp,16
ffffffffc0200268:	b735                	j	ffffffffc0200194 <cprintf>

ffffffffc020026a <print_stackframe>:
ffffffffc020026a:	1141                	addi	sp,sp,-16
ffffffffc020026c:	00004617          	auipc	a2,0x4
ffffffffc0200270:	d2c60613          	addi	a2,a2,-724 # ffffffffc0203f98 <etext+0x100>
ffffffffc0200274:	04900593          	li	a1,73
ffffffffc0200278:	00004517          	auipc	a0,0x4
ffffffffc020027c:	d3850513          	addi	a0,a0,-712 # ffffffffc0203fb0 <etext+0x118>
ffffffffc0200280:	e406                	sd	ra,8(sp)
ffffffffc0200282:	1d8000ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc0200286 <mon_help>:
ffffffffc0200286:	1141                	addi	sp,sp,-16
ffffffffc0200288:	00004617          	auipc	a2,0x4
ffffffffc020028c:	d4060613          	addi	a2,a2,-704 # ffffffffc0203fc8 <etext+0x130>
ffffffffc0200290:	00004597          	auipc	a1,0x4
ffffffffc0200294:	d5858593          	addi	a1,a1,-680 # ffffffffc0203fe8 <etext+0x150>
ffffffffc0200298:	00004517          	auipc	a0,0x4
ffffffffc020029c:	d5850513          	addi	a0,a0,-680 # ffffffffc0203ff0 <etext+0x158>
ffffffffc02002a0:	e406                	sd	ra,8(sp)
ffffffffc02002a2:	ef3ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02002a6:	00004617          	auipc	a2,0x4
ffffffffc02002aa:	d5a60613          	addi	a2,a2,-678 # ffffffffc0204000 <etext+0x168>
ffffffffc02002ae:	00004597          	auipc	a1,0x4
ffffffffc02002b2:	d7a58593          	addi	a1,a1,-646 # ffffffffc0204028 <etext+0x190>
ffffffffc02002b6:	00004517          	auipc	a0,0x4
ffffffffc02002ba:	d3a50513          	addi	a0,a0,-710 # ffffffffc0203ff0 <etext+0x158>
ffffffffc02002be:	ed7ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02002c2:	00004617          	auipc	a2,0x4
ffffffffc02002c6:	d7660613          	addi	a2,a2,-650 # ffffffffc0204038 <etext+0x1a0>
ffffffffc02002ca:	00004597          	auipc	a1,0x4
ffffffffc02002ce:	d8e58593          	addi	a1,a1,-626 # ffffffffc0204058 <etext+0x1c0>
ffffffffc02002d2:	00004517          	auipc	a0,0x4
ffffffffc02002d6:	d1e50513          	addi	a0,a0,-738 # ffffffffc0203ff0 <etext+0x158>
ffffffffc02002da:	ebbff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02002de:	60a2                	ld	ra,8(sp)
ffffffffc02002e0:	4501                	li	a0,0
ffffffffc02002e2:	0141                	addi	sp,sp,16
ffffffffc02002e4:	8082                	ret

ffffffffc02002e6 <mon_kerninfo>:
ffffffffc02002e6:	1141                	addi	sp,sp,-16
ffffffffc02002e8:	e406                	sd	ra,8(sp)
ffffffffc02002ea:	ef3ff0ef          	jal	ra,ffffffffc02001dc <print_kerninfo>
ffffffffc02002ee:	60a2                	ld	ra,8(sp)
ffffffffc02002f0:	4501                	li	a0,0
ffffffffc02002f2:	0141                	addi	sp,sp,16
ffffffffc02002f4:	8082                	ret

ffffffffc02002f6 <mon_backtrace>:
ffffffffc02002f6:	1141                	addi	sp,sp,-16
ffffffffc02002f8:	e406                	sd	ra,8(sp)
ffffffffc02002fa:	f71ff0ef          	jal	ra,ffffffffc020026a <print_stackframe>
ffffffffc02002fe:	60a2                	ld	ra,8(sp)
ffffffffc0200300:	4501                	li	a0,0
ffffffffc0200302:	0141                	addi	sp,sp,16
ffffffffc0200304:	8082                	ret

ffffffffc0200306 <kmonitor>:
ffffffffc0200306:	7115                	addi	sp,sp,-224
ffffffffc0200308:	ed5e                	sd	s7,152(sp)
ffffffffc020030a:	8baa                	mv	s7,a0
ffffffffc020030c:	00004517          	auipc	a0,0x4
ffffffffc0200310:	d5c50513          	addi	a0,a0,-676 # ffffffffc0204068 <etext+0x1d0>
ffffffffc0200314:	ed86                	sd	ra,216(sp)
ffffffffc0200316:	e9a2                	sd	s0,208(sp)
ffffffffc0200318:	e5a6                	sd	s1,200(sp)
ffffffffc020031a:	e1ca                	sd	s2,192(sp)
ffffffffc020031c:	fd4e                	sd	s3,184(sp)
ffffffffc020031e:	f952                	sd	s4,176(sp)
ffffffffc0200320:	f556                	sd	s5,168(sp)
ffffffffc0200322:	f15a                	sd	s6,160(sp)
ffffffffc0200324:	e962                	sd	s8,144(sp)
ffffffffc0200326:	e566                	sd	s9,136(sp)
ffffffffc0200328:	e16a                	sd	s10,128(sp)
ffffffffc020032a:	e6bff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc020032e:	00004517          	auipc	a0,0x4
ffffffffc0200332:	d6250513          	addi	a0,a0,-670 # ffffffffc0204090 <etext+0x1f8>
ffffffffc0200336:	e5fff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc020033a:	000b8563          	beqz	s7,ffffffffc0200344 <kmonitor+0x3e>
ffffffffc020033e:	855e                	mv	a0,s7
ffffffffc0200340:	7e0000ef          	jal	ra,ffffffffc0200b20 <print_trapframe>
ffffffffc0200344:	4501                	li	a0,0
ffffffffc0200346:	4581                	li	a1,0
ffffffffc0200348:	4601                	li	a2,0
ffffffffc020034a:	48a1                	li	a7,8
ffffffffc020034c:	00000073          	ecall
ffffffffc0200350:	00004c17          	auipc	s8,0x4
ffffffffc0200354:	db0c0c13          	addi	s8,s8,-592 # ffffffffc0204100 <commands>
ffffffffc0200358:	00004917          	auipc	s2,0x4
ffffffffc020035c:	d6090913          	addi	s2,s2,-672 # ffffffffc02040b8 <etext+0x220>
ffffffffc0200360:	00004497          	auipc	s1,0x4
ffffffffc0200364:	d6048493          	addi	s1,s1,-672 # ffffffffc02040c0 <etext+0x228>
ffffffffc0200368:	49bd                	li	s3,15
ffffffffc020036a:	00004b17          	auipc	s6,0x4
ffffffffc020036e:	d5eb0b13          	addi	s6,s6,-674 # ffffffffc02040c8 <etext+0x230>
ffffffffc0200372:	00004a17          	auipc	s4,0x4
ffffffffc0200376:	c76a0a13          	addi	s4,s4,-906 # ffffffffc0203fe8 <etext+0x150>
ffffffffc020037a:	4a8d                	li	s5,3
ffffffffc020037c:	854a                	mv	a0,s2
ffffffffc020037e:	d29ff0ef          	jal	ra,ffffffffc02000a6 <readline>
ffffffffc0200382:	842a                	mv	s0,a0
ffffffffc0200384:	dd65                	beqz	a0,ffffffffc020037c <kmonitor+0x76>
ffffffffc0200386:	00054583          	lbu	a1,0(a0)
ffffffffc020038a:	4c81                	li	s9,0
ffffffffc020038c:	e1bd                	bnez	a1,ffffffffc02003f2 <kmonitor+0xec>
ffffffffc020038e:	fe0c87e3          	beqz	s9,ffffffffc020037c <kmonitor+0x76>
ffffffffc0200392:	6582                	ld	a1,0(sp)
ffffffffc0200394:	00004d17          	auipc	s10,0x4
ffffffffc0200398:	d6cd0d13          	addi	s10,s10,-660 # ffffffffc0204100 <commands>
ffffffffc020039c:	8552                	mv	a0,s4
ffffffffc020039e:	4401                	li	s0,0
ffffffffc02003a0:	0d61                	addi	s10,s10,24
ffffffffc02003a2:	24f030ef          	jal	ra,ffffffffc0203df0 <strcmp>
ffffffffc02003a6:	c919                	beqz	a0,ffffffffc02003bc <kmonitor+0xb6>
ffffffffc02003a8:	2405                	addiw	s0,s0,1
ffffffffc02003aa:	0b540063          	beq	s0,s5,ffffffffc020044a <kmonitor+0x144>
ffffffffc02003ae:	000d3503          	ld	a0,0(s10)
ffffffffc02003b2:	6582                	ld	a1,0(sp)
ffffffffc02003b4:	0d61                	addi	s10,s10,24
ffffffffc02003b6:	23b030ef          	jal	ra,ffffffffc0203df0 <strcmp>
ffffffffc02003ba:	f57d                	bnez	a0,ffffffffc02003a8 <kmonitor+0xa2>
ffffffffc02003bc:	00141793          	slli	a5,s0,0x1
ffffffffc02003c0:	97a2                	add	a5,a5,s0
ffffffffc02003c2:	078e                	slli	a5,a5,0x3
ffffffffc02003c4:	97e2                	add	a5,a5,s8
ffffffffc02003c6:	6b9c                	ld	a5,16(a5)
ffffffffc02003c8:	865e                	mv	a2,s7
ffffffffc02003ca:	002c                	addi	a1,sp,8
ffffffffc02003cc:	fffc851b          	addiw	a0,s9,-1
ffffffffc02003d0:	9782                	jalr	a5
ffffffffc02003d2:	fa0555e3          	bgez	a0,ffffffffc020037c <kmonitor+0x76>
ffffffffc02003d6:	60ee                	ld	ra,216(sp)
ffffffffc02003d8:	644e                	ld	s0,208(sp)
ffffffffc02003da:	64ae                	ld	s1,200(sp)
ffffffffc02003dc:	690e                	ld	s2,192(sp)
ffffffffc02003de:	79ea                	ld	s3,184(sp)
ffffffffc02003e0:	7a4a                	ld	s4,176(sp)
ffffffffc02003e2:	7aaa                	ld	s5,168(sp)
ffffffffc02003e4:	7b0a                	ld	s6,160(sp)
ffffffffc02003e6:	6bea                	ld	s7,152(sp)
ffffffffc02003e8:	6c4a                	ld	s8,144(sp)
ffffffffc02003ea:	6caa                	ld	s9,136(sp)
ffffffffc02003ec:	6d0a                	ld	s10,128(sp)
ffffffffc02003ee:	612d                	addi	sp,sp,224
ffffffffc02003f0:	8082                	ret
ffffffffc02003f2:	8526                	mv	a0,s1
ffffffffc02003f4:	241030ef          	jal	ra,ffffffffc0203e34 <strchr>
ffffffffc02003f8:	c901                	beqz	a0,ffffffffc0200408 <kmonitor+0x102>
ffffffffc02003fa:	00144583          	lbu	a1,1(s0)
ffffffffc02003fe:	00040023          	sb	zero,0(s0)
ffffffffc0200402:	0405                	addi	s0,s0,1
ffffffffc0200404:	d5c9                	beqz	a1,ffffffffc020038e <kmonitor+0x88>
ffffffffc0200406:	b7f5                	j	ffffffffc02003f2 <kmonitor+0xec>
ffffffffc0200408:	00044783          	lbu	a5,0(s0)
ffffffffc020040c:	d3c9                	beqz	a5,ffffffffc020038e <kmonitor+0x88>
ffffffffc020040e:	033c8963          	beq	s9,s3,ffffffffc0200440 <kmonitor+0x13a>
ffffffffc0200412:	003c9793          	slli	a5,s9,0x3
ffffffffc0200416:	0118                	addi	a4,sp,128
ffffffffc0200418:	97ba                	add	a5,a5,a4
ffffffffc020041a:	f887b023          	sd	s0,-128(a5)
ffffffffc020041e:	00044583          	lbu	a1,0(s0)
ffffffffc0200422:	2c85                	addiw	s9,s9,1
ffffffffc0200424:	e591                	bnez	a1,ffffffffc0200430 <kmonitor+0x12a>
ffffffffc0200426:	b7b5                	j	ffffffffc0200392 <kmonitor+0x8c>
ffffffffc0200428:	00144583          	lbu	a1,1(s0)
ffffffffc020042c:	0405                	addi	s0,s0,1
ffffffffc020042e:	d1a5                	beqz	a1,ffffffffc020038e <kmonitor+0x88>
ffffffffc0200430:	8526                	mv	a0,s1
ffffffffc0200432:	203030ef          	jal	ra,ffffffffc0203e34 <strchr>
ffffffffc0200436:	d96d                	beqz	a0,ffffffffc0200428 <kmonitor+0x122>
ffffffffc0200438:	00044583          	lbu	a1,0(s0)
ffffffffc020043c:	d9a9                	beqz	a1,ffffffffc020038e <kmonitor+0x88>
ffffffffc020043e:	bf55                	j	ffffffffc02003f2 <kmonitor+0xec>
ffffffffc0200440:	45c1                	li	a1,16
ffffffffc0200442:	855a                	mv	a0,s6
ffffffffc0200444:	d51ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200448:	b7e9                	j	ffffffffc0200412 <kmonitor+0x10c>
ffffffffc020044a:	6582                	ld	a1,0(sp)
ffffffffc020044c:	00004517          	auipc	a0,0x4
ffffffffc0200450:	c9c50513          	addi	a0,a0,-868 # ffffffffc02040e8 <etext+0x250>
ffffffffc0200454:	d41ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200458:	b715                	j	ffffffffc020037c <kmonitor+0x76>

ffffffffc020045a <__panic>:
ffffffffc020045a:	0000d317          	auipc	t1,0xd
ffffffffc020045e:	00e30313          	addi	t1,t1,14 # ffffffffc020d468 <is_panic>
ffffffffc0200462:	00032e03          	lw	t3,0(t1)
ffffffffc0200466:	715d                	addi	sp,sp,-80
ffffffffc0200468:	ec06                	sd	ra,24(sp)
ffffffffc020046a:	e822                	sd	s0,16(sp)
ffffffffc020046c:	f436                	sd	a3,40(sp)
ffffffffc020046e:	f83a                	sd	a4,48(sp)
ffffffffc0200470:	fc3e                	sd	a5,56(sp)
ffffffffc0200472:	e0c2                	sd	a6,64(sp)
ffffffffc0200474:	e4c6                	sd	a7,72(sp)
ffffffffc0200476:	020e1a63          	bnez	t3,ffffffffc02004aa <__panic+0x50>
ffffffffc020047a:	4785                	li	a5,1
ffffffffc020047c:	00f32023          	sw	a5,0(t1)
ffffffffc0200480:	8432                	mv	s0,a2
ffffffffc0200482:	103c                	addi	a5,sp,40
ffffffffc0200484:	862e                	mv	a2,a1
ffffffffc0200486:	85aa                	mv	a1,a0
ffffffffc0200488:	00004517          	auipc	a0,0x4
ffffffffc020048c:	cc050513          	addi	a0,a0,-832 # ffffffffc0204148 <commands+0x48>
ffffffffc0200490:	e43e                	sd	a5,8(sp)
ffffffffc0200492:	d03ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200496:	65a2                	ld	a1,8(sp)
ffffffffc0200498:	8522                	mv	a0,s0
ffffffffc020049a:	cdbff0ef          	jal	ra,ffffffffc0200174 <vcprintf>
ffffffffc020049e:	00005517          	auipc	a0,0x5
ffffffffc02004a2:	d5a50513          	addi	a0,a0,-678 # ffffffffc02051f8 <default_pmm_manager+0x530>
ffffffffc02004a6:	cefff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02004aa:	486000ef          	jal	ra,ffffffffc0200930 <intr_disable>
ffffffffc02004ae:	4501                	li	a0,0
ffffffffc02004b0:	e57ff0ef          	jal	ra,ffffffffc0200306 <kmonitor>
ffffffffc02004b4:	bfed                	j	ffffffffc02004ae <__panic+0x54>

ffffffffc02004b6 <clock_init>:
ffffffffc02004b6:	67e1                	lui	a5,0x18
ffffffffc02004b8:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc02004bc:	0000d717          	auipc	a4,0xd
ffffffffc02004c0:	faf73e23          	sd	a5,-68(a4) # ffffffffc020d478 <timebase>
ffffffffc02004c4:	c0102573          	rdtime	a0
ffffffffc02004c8:	4581                	li	a1,0
ffffffffc02004ca:	953e                	add	a0,a0,a5
ffffffffc02004cc:	4601                	li	a2,0
ffffffffc02004ce:	4881                	li	a7,0
ffffffffc02004d0:	00000073          	ecall
ffffffffc02004d4:	02000793          	li	a5,32
ffffffffc02004d8:	1047a7f3          	csrrs	a5,sie,a5
ffffffffc02004dc:	00004517          	auipc	a0,0x4
ffffffffc02004e0:	c8c50513          	addi	a0,a0,-884 # ffffffffc0204168 <commands+0x68>
ffffffffc02004e4:	0000d797          	auipc	a5,0xd
ffffffffc02004e8:	f807b623          	sd	zero,-116(a5) # ffffffffc020d470 <ticks>
ffffffffc02004ec:	b165                	j	ffffffffc0200194 <cprintf>

ffffffffc02004ee <clock_set_next_event>:
ffffffffc02004ee:	c0102573          	rdtime	a0
ffffffffc02004f2:	0000d797          	auipc	a5,0xd
ffffffffc02004f6:	f867b783          	ld	a5,-122(a5) # ffffffffc020d478 <timebase>
ffffffffc02004fa:	953e                	add	a0,a0,a5
ffffffffc02004fc:	4581                	li	a1,0
ffffffffc02004fe:	4601                	li	a2,0
ffffffffc0200500:	4881                	li	a7,0
ffffffffc0200502:	00000073          	ecall
ffffffffc0200506:	8082                	ret

ffffffffc0200508 <cons_init>:
ffffffffc0200508:	8082                	ret

ffffffffc020050a <cons_putc>:
ffffffffc020050a:	100027f3          	csrr	a5,sstatus
ffffffffc020050e:	8b89                	andi	a5,a5,2
ffffffffc0200510:	0ff57513          	zext.b	a0,a0
ffffffffc0200514:	e799                	bnez	a5,ffffffffc0200522 <cons_putc+0x18>
ffffffffc0200516:	4581                	li	a1,0
ffffffffc0200518:	4601                	li	a2,0
ffffffffc020051a:	4885                	li	a7,1
ffffffffc020051c:	00000073          	ecall
ffffffffc0200520:	8082                	ret
ffffffffc0200522:	1101                	addi	sp,sp,-32
ffffffffc0200524:	ec06                	sd	ra,24(sp)
ffffffffc0200526:	e42a                	sd	a0,8(sp)
ffffffffc0200528:	408000ef          	jal	ra,ffffffffc0200930 <intr_disable>
ffffffffc020052c:	6522                	ld	a0,8(sp)
ffffffffc020052e:	4581                	li	a1,0
ffffffffc0200530:	4601                	li	a2,0
ffffffffc0200532:	4885                	li	a7,1
ffffffffc0200534:	00000073          	ecall
ffffffffc0200538:	60e2                	ld	ra,24(sp)
ffffffffc020053a:	6105                	addi	sp,sp,32
ffffffffc020053c:	a6fd                	j	ffffffffc020092a <intr_enable>

ffffffffc020053e <cons_getc>:
ffffffffc020053e:	100027f3          	csrr	a5,sstatus
ffffffffc0200542:	8b89                	andi	a5,a5,2
ffffffffc0200544:	eb89                	bnez	a5,ffffffffc0200556 <cons_getc+0x18>
ffffffffc0200546:	4501                	li	a0,0
ffffffffc0200548:	4581                	li	a1,0
ffffffffc020054a:	4601                	li	a2,0
ffffffffc020054c:	4889                	li	a7,2
ffffffffc020054e:	00000073          	ecall
ffffffffc0200552:	2501                	sext.w	a0,a0
ffffffffc0200554:	8082                	ret
ffffffffc0200556:	1101                	addi	sp,sp,-32
ffffffffc0200558:	ec06                	sd	ra,24(sp)
ffffffffc020055a:	3d6000ef          	jal	ra,ffffffffc0200930 <intr_disable>
ffffffffc020055e:	4501                	li	a0,0
ffffffffc0200560:	4581                	li	a1,0
ffffffffc0200562:	4601                	li	a2,0
ffffffffc0200564:	4889                	li	a7,2
ffffffffc0200566:	00000073          	ecall
ffffffffc020056a:	2501                	sext.w	a0,a0
ffffffffc020056c:	e42a                	sd	a0,8(sp)
ffffffffc020056e:	3bc000ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc0200572:	60e2                	ld	ra,24(sp)
ffffffffc0200574:	6522                	ld	a0,8(sp)
ffffffffc0200576:	6105                	addi	sp,sp,32
ffffffffc0200578:	8082                	ret

ffffffffc020057a <dtb_init>:
ffffffffc020057a:	7119                	addi	sp,sp,-128
ffffffffc020057c:	00004517          	auipc	a0,0x4
ffffffffc0200580:	c0c50513          	addi	a0,a0,-1012 # ffffffffc0204188 <commands+0x88>
ffffffffc0200584:	fc86                	sd	ra,120(sp)
ffffffffc0200586:	f8a2                	sd	s0,112(sp)
ffffffffc0200588:	e8d2                	sd	s4,80(sp)
ffffffffc020058a:	f4a6                	sd	s1,104(sp)
ffffffffc020058c:	f0ca                	sd	s2,96(sp)
ffffffffc020058e:	ecce                	sd	s3,88(sp)
ffffffffc0200590:	e4d6                	sd	s5,72(sp)
ffffffffc0200592:	e0da                	sd	s6,64(sp)
ffffffffc0200594:	fc5e                	sd	s7,56(sp)
ffffffffc0200596:	f862                	sd	s8,48(sp)
ffffffffc0200598:	f466                	sd	s9,40(sp)
ffffffffc020059a:	f06a                	sd	s10,32(sp)
ffffffffc020059c:	ec6e                	sd	s11,24(sp)
ffffffffc020059e:	bf7ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02005a2:	00009597          	auipc	a1,0x9
ffffffffc02005a6:	a5e5b583          	ld	a1,-1442(a1) # ffffffffc0209000 <boot_hartid>
ffffffffc02005aa:	00004517          	auipc	a0,0x4
ffffffffc02005ae:	bee50513          	addi	a0,a0,-1042 # ffffffffc0204198 <commands+0x98>
ffffffffc02005b2:	be3ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02005b6:	00009417          	auipc	s0,0x9
ffffffffc02005ba:	a5240413          	addi	s0,s0,-1454 # ffffffffc0209008 <boot_dtb>
ffffffffc02005be:	600c                	ld	a1,0(s0)
ffffffffc02005c0:	00004517          	auipc	a0,0x4
ffffffffc02005c4:	be850513          	addi	a0,a0,-1048 # ffffffffc02041a8 <commands+0xa8>
ffffffffc02005c8:	bcdff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02005cc:	00043a03          	ld	s4,0(s0)
ffffffffc02005d0:	00004517          	auipc	a0,0x4
ffffffffc02005d4:	bf050513          	addi	a0,a0,-1040 # ffffffffc02041c0 <commands+0xc0>
ffffffffc02005d8:	120a0463          	beqz	s4,ffffffffc0200700 <dtb_init+0x186>
ffffffffc02005dc:	57f5                	li	a5,-3
ffffffffc02005de:	07fa                	slli	a5,a5,0x1e
ffffffffc02005e0:	00fa0733          	add	a4,s4,a5
ffffffffc02005e4:	431c                	lw	a5,0(a4)
ffffffffc02005e6:	00ff0637          	lui	a2,0xff0
ffffffffc02005ea:	6b41                	lui	s6,0x10
ffffffffc02005ec:	0087d59b          	srliw	a1,a5,0x8
ffffffffc02005f0:	0187969b          	slliw	a3,a5,0x18
ffffffffc02005f4:	0187d51b          	srliw	a0,a5,0x18
ffffffffc02005f8:	0105959b          	slliw	a1,a1,0x10
ffffffffc02005fc:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200600:	8df1                	and	a1,a1,a2
ffffffffc0200602:	8ec9                	or	a3,a3,a0
ffffffffc0200604:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200608:	1b7d                	addi	s6,s6,-1
ffffffffc020060a:	0167f7b3          	and	a5,a5,s6
ffffffffc020060e:	8dd5                	or	a1,a1,a3
ffffffffc0200610:	8ddd                	or	a1,a1,a5
ffffffffc0200612:	d00e07b7          	lui	a5,0xd00e0
ffffffffc0200616:	2581                	sext.w	a1,a1
ffffffffc0200618:	eed78793          	addi	a5,a5,-275 # ffffffffd00dfeed <end+0xfed2a01>
ffffffffc020061c:	10f59163          	bne	a1,a5,ffffffffc020071e <dtb_init+0x1a4>
ffffffffc0200620:	471c                	lw	a5,8(a4)
ffffffffc0200622:	4754                	lw	a3,12(a4)
ffffffffc0200624:	4c81                	li	s9,0
ffffffffc0200626:	0087d59b          	srliw	a1,a5,0x8
ffffffffc020062a:	0086d51b          	srliw	a0,a3,0x8
ffffffffc020062e:	0186941b          	slliw	s0,a3,0x18
ffffffffc0200632:	0186d89b          	srliw	a7,a3,0x18
ffffffffc0200636:	01879a1b          	slliw	s4,a5,0x18
ffffffffc020063a:	0187d81b          	srliw	a6,a5,0x18
ffffffffc020063e:	0105151b          	slliw	a0,a0,0x10
ffffffffc0200642:	0106d69b          	srliw	a3,a3,0x10
ffffffffc0200646:	0105959b          	slliw	a1,a1,0x10
ffffffffc020064a:	0107d79b          	srliw	a5,a5,0x10
ffffffffc020064e:	8d71                	and	a0,a0,a2
ffffffffc0200650:	01146433          	or	s0,s0,a7
ffffffffc0200654:	0086969b          	slliw	a3,a3,0x8
ffffffffc0200658:	010a6a33          	or	s4,s4,a6
ffffffffc020065c:	8e6d                	and	a2,a2,a1
ffffffffc020065e:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200662:	8c49                	or	s0,s0,a0
ffffffffc0200664:	0166f6b3          	and	a3,a3,s6
ffffffffc0200668:	00ca6a33          	or	s4,s4,a2
ffffffffc020066c:	0167f7b3          	and	a5,a5,s6
ffffffffc0200670:	8c55                	or	s0,s0,a3
ffffffffc0200672:	00fa6a33          	or	s4,s4,a5
ffffffffc0200676:	1402                	slli	s0,s0,0x20
ffffffffc0200678:	1a02                	slli	s4,s4,0x20
ffffffffc020067a:	9001                	srli	s0,s0,0x20
ffffffffc020067c:	020a5a13          	srli	s4,s4,0x20
ffffffffc0200680:	943a                	add	s0,s0,a4
ffffffffc0200682:	9a3a                	add	s4,s4,a4
ffffffffc0200684:	00ff0c37          	lui	s8,0xff0
ffffffffc0200688:	4b8d                	li	s7,3
ffffffffc020068a:	00004917          	auipc	s2,0x4
ffffffffc020068e:	b8690913          	addi	s2,s2,-1146 # ffffffffc0204210 <commands+0x110>
ffffffffc0200692:	49bd                	li	s3,15
ffffffffc0200694:	4d91                	li	s11,4
ffffffffc0200696:	4d05                	li	s10,1
ffffffffc0200698:	00004497          	auipc	s1,0x4
ffffffffc020069c:	b7048493          	addi	s1,s1,-1168 # ffffffffc0204208 <commands+0x108>
ffffffffc02006a0:	000a2703          	lw	a4,0(s4)
ffffffffc02006a4:	004a0a93          	addi	s5,s4,4
ffffffffc02006a8:	0087569b          	srliw	a3,a4,0x8
ffffffffc02006ac:	0187179b          	slliw	a5,a4,0x18
ffffffffc02006b0:	0187561b          	srliw	a2,a4,0x18
ffffffffc02006b4:	0106969b          	slliw	a3,a3,0x10
ffffffffc02006b8:	0107571b          	srliw	a4,a4,0x10
ffffffffc02006bc:	8fd1                	or	a5,a5,a2
ffffffffc02006be:	0186f6b3          	and	a3,a3,s8
ffffffffc02006c2:	0087171b          	slliw	a4,a4,0x8
ffffffffc02006c6:	8fd5                	or	a5,a5,a3
ffffffffc02006c8:	00eb7733          	and	a4,s6,a4
ffffffffc02006cc:	8fd9                	or	a5,a5,a4
ffffffffc02006ce:	2781                	sext.w	a5,a5
ffffffffc02006d0:	09778c63          	beq	a5,s7,ffffffffc0200768 <dtb_init+0x1ee>
ffffffffc02006d4:	00fbea63          	bltu	s7,a5,ffffffffc02006e8 <dtb_init+0x16e>
ffffffffc02006d8:	07a78663          	beq	a5,s10,ffffffffc0200744 <dtb_init+0x1ca>
ffffffffc02006dc:	4709                	li	a4,2
ffffffffc02006de:	00e79763          	bne	a5,a4,ffffffffc02006ec <dtb_init+0x172>
ffffffffc02006e2:	4c81                	li	s9,0
ffffffffc02006e4:	8a56                	mv	s4,s5
ffffffffc02006e6:	bf6d                	j	ffffffffc02006a0 <dtb_init+0x126>
ffffffffc02006e8:	ffb78ee3          	beq	a5,s11,ffffffffc02006e4 <dtb_init+0x16a>
ffffffffc02006ec:	00004517          	auipc	a0,0x4
ffffffffc02006f0:	b9c50513          	addi	a0,a0,-1124 # ffffffffc0204288 <commands+0x188>
ffffffffc02006f4:	aa1ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02006f8:	00004517          	auipc	a0,0x4
ffffffffc02006fc:	bc850513          	addi	a0,a0,-1080 # ffffffffc02042c0 <commands+0x1c0>
ffffffffc0200700:	7446                	ld	s0,112(sp)
ffffffffc0200702:	70e6                	ld	ra,120(sp)
ffffffffc0200704:	74a6                	ld	s1,104(sp)
ffffffffc0200706:	7906                	ld	s2,96(sp)
ffffffffc0200708:	69e6                	ld	s3,88(sp)
ffffffffc020070a:	6a46                	ld	s4,80(sp)
ffffffffc020070c:	6aa6                	ld	s5,72(sp)
ffffffffc020070e:	6b06                	ld	s6,64(sp)
ffffffffc0200710:	7be2                	ld	s7,56(sp)
ffffffffc0200712:	7c42                	ld	s8,48(sp)
ffffffffc0200714:	7ca2                	ld	s9,40(sp)
ffffffffc0200716:	7d02                	ld	s10,32(sp)
ffffffffc0200718:	6de2                	ld	s11,24(sp)
ffffffffc020071a:	6109                	addi	sp,sp,128
ffffffffc020071c:	bca5                	j	ffffffffc0200194 <cprintf>
ffffffffc020071e:	7446                	ld	s0,112(sp)
ffffffffc0200720:	70e6                	ld	ra,120(sp)
ffffffffc0200722:	74a6                	ld	s1,104(sp)
ffffffffc0200724:	7906                	ld	s2,96(sp)
ffffffffc0200726:	69e6                	ld	s3,88(sp)
ffffffffc0200728:	6a46                	ld	s4,80(sp)
ffffffffc020072a:	6aa6                	ld	s5,72(sp)
ffffffffc020072c:	6b06                	ld	s6,64(sp)
ffffffffc020072e:	7be2                	ld	s7,56(sp)
ffffffffc0200730:	7c42                	ld	s8,48(sp)
ffffffffc0200732:	7ca2                	ld	s9,40(sp)
ffffffffc0200734:	7d02                	ld	s10,32(sp)
ffffffffc0200736:	6de2                	ld	s11,24(sp)
ffffffffc0200738:	00004517          	auipc	a0,0x4
ffffffffc020073c:	aa850513          	addi	a0,a0,-1368 # ffffffffc02041e0 <commands+0xe0>
ffffffffc0200740:	6109                	addi	sp,sp,128
ffffffffc0200742:	bc89                	j	ffffffffc0200194 <cprintf>
ffffffffc0200744:	8556                	mv	a0,s5
ffffffffc0200746:	662030ef          	jal	ra,ffffffffc0203da8 <strlen>
ffffffffc020074a:	8a2a                	mv	s4,a0
ffffffffc020074c:	4619                	li	a2,6
ffffffffc020074e:	85a6                	mv	a1,s1
ffffffffc0200750:	8556                	mv	a0,s5
ffffffffc0200752:	2a01                	sext.w	s4,s4
ffffffffc0200754:	6ba030ef          	jal	ra,ffffffffc0203e0e <strncmp>
ffffffffc0200758:	e111                	bnez	a0,ffffffffc020075c <dtb_init+0x1e2>
ffffffffc020075a:	4c85                	li	s9,1
ffffffffc020075c:	0a91                	addi	s5,s5,4
ffffffffc020075e:	9ad2                	add	s5,s5,s4
ffffffffc0200760:	ffcafa93          	andi	s5,s5,-4
ffffffffc0200764:	8a56                	mv	s4,s5
ffffffffc0200766:	bf2d                	j	ffffffffc02006a0 <dtb_init+0x126>
ffffffffc0200768:	004a2783          	lw	a5,4(s4)
ffffffffc020076c:	00ca0693          	addi	a3,s4,12
ffffffffc0200770:	0087d71b          	srliw	a4,a5,0x8
ffffffffc0200774:	01879a9b          	slliw	s5,a5,0x18
ffffffffc0200778:	0187d61b          	srliw	a2,a5,0x18
ffffffffc020077c:	0107171b          	slliw	a4,a4,0x10
ffffffffc0200780:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200784:	00caeab3          	or	s5,s5,a2
ffffffffc0200788:	01877733          	and	a4,a4,s8
ffffffffc020078c:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200790:	00eaeab3          	or	s5,s5,a4
ffffffffc0200794:	00fb77b3          	and	a5,s6,a5
ffffffffc0200798:	00faeab3          	or	s5,s5,a5
ffffffffc020079c:	2a81                	sext.w	s5,s5
ffffffffc020079e:	000c9c63          	bnez	s9,ffffffffc02007b6 <dtb_init+0x23c>
ffffffffc02007a2:	1a82                	slli	s5,s5,0x20
ffffffffc02007a4:	00368793          	addi	a5,a3,3
ffffffffc02007a8:	020ada93          	srli	s5,s5,0x20
ffffffffc02007ac:	9abe                	add	s5,s5,a5
ffffffffc02007ae:	ffcafa93          	andi	s5,s5,-4
ffffffffc02007b2:	8a56                	mv	s4,s5
ffffffffc02007b4:	b5f5                	j	ffffffffc02006a0 <dtb_init+0x126>
ffffffffc02007b6:	008a2783          	lw	a5,8(s4)
ffffffffc02007ba:	85ca                	mv	a1,s2
ffffffffc02007bc:	e436                	sd	a3,8(sp)
ffffffffc02007be:	0087d51b          	srliw	a0,a5,0x8
ffffffffc02007c2:	0187d61b          	srliw	a2,a5,0x18
ffffffffc02007c6:	0187971b          	slliw	a4,a5,0x18
ffffffffc02007ca:	0105151b          	slliw	a0,a0,0x10
ffffffffc02007ce:	0107d79b          	srliw	a5,a5,0x10
ffffffffc02007d2:	8f51                	or	a4,a4,a2
ffffffffc02007d4:	01857533          	and	a0,a0,s8
ffffffffc02007d8:	0087979b          	slliw	a5,a5,0x8
ffffffffc02007dc:	8d59                	or	a0,a0,a4
ffffffffc02007de:	00fb77b3          	and	a5,s6,a5
ffffffffc02007e2:	8d5d                	or	a0,a0,a5
ffffffffc02007e4:	1502                	slli	a0,a0,0x20
ffffffffc02007e6:	9101                	srli	a0,a0,0x20
ffffffffc02007e8:	9522                	add	a0,a0,s0
ffffffffc02007ea:	606030ef          	jal	ra,ffffffffc0203df0 <strcmp>
ffffffffc02007ee:	66a2                	ld	a3,8(sp)
ffffffffc02007f0:	f94d                	bnez	a0,ffffffffc02007a2 <dtb_init+0x228>
ffffffffc02007f2:	fb59f8e3          	bgeu	s3,s5,ffffffffc02007a2 <dtb_init+0x228>
ffffffffc02007f6:	00ca3783          	ld	a5,12(s4)
ffffffffc02007fa:	014a3703          	ld	a4,20(s4)
ffffffffc02007fe:	00004517          	auipc	a0,0x4
ffffffffc0200802:	a1a50513          	addi	a0,a0,-1510 # ffffffffc0204218 <commands+0x118>
ffffffffc0200806:	4207d613          	srai	a2,a5,0x20
ffffffffc020080a:	0087d31b          	srliw	t1,a5,0x8
ffffffffc020080e:	42075593          	srai	a1,a4,0x20
ffffffffc0200812:	0187de1b          	srliw	t3,a5,0x18
ffffffffc0200816:	0186581b          	srliw	a6,a2,0x18
ffffffffc020081a:	0187941b          	slliw	s0,a5,0x18
ffffffffc020081e:	0107d89b          	srliw	a7,a5,0x10
ffffffffc0200822:	0187d693          	srli	a3,a5,0x18
ffffffffc0200826:	01861f1b          	slliw	t5,a2,0x18
ffffffffc020082a:	0087579b          	srliw	a5,a4,0x8
ffffffffc020082e:	0103131b          	slliw	t1,t1,0x10
ffffffffc0200832:	0106561b          	srliw	a2,a2,0x10
ffffffffc0200836:	010f6f33          	or	t5,t5,a6
ffffffffc020083a:	0187529b          	srliw	t0,a4,0x18
ffffffffc020083e:	0185df9b          	srliw	t6,a1,0x18
ffffffffc0200842:	01837333          	and	t1,t1,s8
ffffffffc0200846:	01c46433          	or	s0,s0,t3
ffffffffc020084a:	0186f6b3          	and	a3,a3,s8
ffffffffc020084e:	01859e1b          	slliw	t3,a1,0x18
ffffffffc0200852:	01871e9b          	slliw	t4,a4,0x18
ffffffffc0200856:	0107581b          	srliw	a6,a4,0x10
ffffffffc020085a:	0086161b          	slliw	a2,a2,0x8
ffffffffc020085e:	8361                	srli	a4,a4,0x18
ffffffffc0200860:	0107979b          	slliw	a5,a5,0x10
ffffffffc0200864:	0105d59b          	srliw	a1,a1,0x10
ffffffffc0200868:	01e6e6b3          	or	a3,a3,t5
ffffffffc020086c:	00cb7633          	and	a2,s6,a2
ffffffffc0200870:	0088181b          	slliw	a6,a6,0x8
ffffffffc0200874:	0085959b          	slliw	a1,a1,0x8
ffffffffc0200878:	00646433          	or	s0,s0,t1
ffffffffc020087c:	0187f7b3          	and	a5,a5,s8
ffffffffc0200880:	01fe6333          	or	t1,t3,t6
ffffffffc0200884:	01877c33          	and	s8,a4,s8
ffffffffc0200888:	0088989b          	slliw	a7,a7,0x8
ffffffffc020088c:	011b78b3          	and	a7,s6,a7
ffffffffc0200890:	005eeeb3          	or	t4,t4,t0
ffffffffc0200894:	00c6e733          	or	a4,a3,a2
ffffffffc0200898:	006c6c33          	or	s8,s8,t1
ffffffffc020089c:	010b76b3          	and	a3,s6,a6
ffffffffc02008a0:	00bb7b33          	and	s6,s6,a1
ffffffffc02008a4:	01d7e7b3          	or	a5,a5,t4
ffffffffc02008a8:	016c6b33          	or	s6,s8,s6
ffffffffc02008ac:	01146433          	or	s0,s0,a7
ffffffffc02008b0:	8fd5                	or	a5,a5,a3
ffffffffc02008b2:	1702                	slli	a4,a4,0x20
ffffffffc02008b4:	1b02                	slli	s6,s6,0x20
ffffffffc02008b6:	1782                	slli	a5,a5,0x20
ffffffffc02008b8:	9301                	srli	a4,a4,0x20
ffffffffc02008ba:	1402                	slli	s0,s0,0x20
ffffffffc02008bc:	020b5b13          	srli	s6,s6,0x20
ffffffffc02008c0:	0167eb33          	or	s6,a5,s6
ffffffffc02008c4:	8c59                	or	s0,s0,a4
ffffffffc02008c6:	8cfff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02008ca:	85a2                	mv	a1,s0
ffffffffc02008cc:	00004517          	auipc	a0,0x4
ffffffffc02008d0:	96c50513          	addi	a0,a0,-1684 # ffffffffc0204238 <commands+0x138>
ffffffffc02008d4:	8c1ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02008d8:	014b5613          	srli	a2,s6,0x14
ffffffffc02008dc:	85da                	mv	a1,s6
ffffffffc02008de:	00004517          	auipc	a0,0x4
ffffffffc02008e2:	97250513          	addi	a0,a0,-1678 # ffffffffc0204250 <commands+0x150>
ffffffffc02008e6:	8afff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02008ea:	008b05b3          	add	a1,s6,s0
ffffffffc02008ee:	15fd                	addi	a1,a1,-1
ffffffffc02008f0:	00004517          	auipc	a0,0x4
ffffffffc02008f4:	98050513          	addi	a0,a0,-1664 # ffffffffc0204270 <commands+0x170>
ffffffffc02008f8:	89dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02008fc:	00004517          	auipc	a0,0x4
ffffffffc0200900:	9c450513          	addi	a0,a0,-1596 # ffffffffc02042c0 <commands+0x1c0>
ffffffffc0200904:	0000d797          	auipc	a5,0xd
ffffffffc0200908:	b687be23          	sd	s0,-1156(a5) # ffffffffc020d480 <memory_base>
ffffffffc020090c:	0000d797          	auipc	a5,0xd
ffffffffc0200910:	b767be23          	sd	s6,-1156(a5) # ffffffffc020d488 <memory_size>
ffffffffc0200914:	b3f5                	j	ffffffffc0200700 <dtb_init+0x186>

ffffffffc0200916 <get_memory_base>:
ffffffffc0200916:	0000d517          	auipc	a0,0xd
ffffffffc020091a:	b6a53503          	ld	a0,-1174(a0) # ffffffffc020d480 <memory_base>
ffffffffc020091e:	8082                	ret

ffffffffc0200920 <get_memory_size>:
ffffffffc0200920:	0000d517          	auipc	a0,0xd
ffffffffc0200924:	b6853503          	ld	a0,-1176(a0) # ffffffffc020d488 <memory_size>
ffffffffc0200928:	8082                	ret

ffffffffc020092a <intr_enable>:
ffffffffc020092a:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc020092e:	8082                	ret

ffffffffc0200930 <intr_disable>:
ffffffffc0200930:	100177f3          	csrrci	a5,sstatus,2
ffffffffc0200934:	8082                	ret

ffffffffc0200936 <pic_init>:
ffffffffc0200936:	8082                	ret

ffffffffc0200938 <idt_init>:
ffffffffc0200938:	14005073          	csrwi	sscratch,0
ffffffffc020093c:	00000797          	auipc	a5,0x0
ffffffffc0200940:	3e078793          	addi	a5,a5,992 # ffffffffc0200d1c <__alltraps>
ffffffffc0200944:	10579073          	csrw	stvec,a5
ffffffffc0200948:	000407b7          	lui	a5,0x40
ffffffffc020094c:	1007a7f3          	csrrs	a5,sstatus,a5
ffffffffc0200950:	8082                	ret

ffffffffc0200952 <print_regs>:
ffffffffc0200952:	610c                	ld	a1,0(a0)
ffffffffc0200954:	1141                	addi	sp,sp,-16
ffffffffc0200956:	e022                	sd	s0,0(sp)
ffffffffc0200958:	842a                	mv	s0,a0
ffffffffc020095a:	00004517          	auipc	a0,0x4
ffffffffc020095e:	97e50513          	addi	a0,a0,-1666 # ffffffffc02042d8 <commands+0x1d8>
ffffffffc0200962:	e406                	sd	ra,8(sp)
ffffffffc0200964:	831ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200968:	640c                	ld	a1,8(s0)
ffffffffc020096a:	00004517          	auipc	a0,0x4
ffffffffc020096e:	98650513          	addi	a0,a0,-1658 # ffffffffc02042f0 <commands+0x1f0>
ffffffffc0200972:	823ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200976:	680c                	ld	a1,16(s0)
ffffffffc0200978:	00004517          	auipc	a0,0x4
ffffffffc020097c:	99050513          	addi	a0,a0,-1648 # ffffffffc0204308 <commands+0x208>
ffffffffc0200980:	815ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200984:	6c0c                	ld	a1,24(s0)
ffffffffc0200986:	00004517          	auipc	a0,0x4
ffffffffc020098a:	99a50513          	addi	a0,a0,-1638 # ffffffffc0204320 <commands+0x220>
ffffffffc020098e:	807ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200992:	700c                	ld	a1,32(s0)
ffffffffc0200994:	00004517          	auipc	a0,0x4
ffffffffc0200998:	9a450513          	addi	a0,a0,-1628 # ffffffffc0204338 <commands+0x238>
ffffffffc020099c:	ff8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02009a0:	740c                	ld	a1,40(s0)
ffffffffc02009a2:	00004517          	auipc	a0,0x4
ffffffffc02009a6:	9ae50513          	addi	a0,a0,-1618 # ffffffffc0204350 <commands+0x250>
ffffffffc02009aa:	feaff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02009ae:	780c                	ld	a1,48(s0)
ffffffffc02009b0:	00004517          	auipc	a0,0x4
ffffffffc02009b4:	9b850513          	addi	a0,a0,-1608 # ffffffffc0204368 <commands+0x268>
ffffffffc02009b8:	fdcff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02009bc:	7c0c                	ld	a1,56(s0)
ffffffffc02009be:	00004517          	auipc	a0,0x4
ffffffffc02009c2:	9c250513          	addi	a0,a0,-1598 # ffffffffc0204380 <commands+0x280>
ffffffffc02009c6:	fceff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02009ca:	602c                	ld	a1,64(s0)
ffffffffc02009cc:	00004517          	auipc	a0,0x4
ffffffffc02009d0:	9cc50513          	addi	a0,a0,-1588 # ffffffffc0204398 <commands+0x298>
ffffffffc02009d4:	fc0ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02009d8:	642c                	ld	a1,72(s0)
ffffffffc02009da:	00004517          	auipc	a0,0x4
ffffffffc02009de:	9d650513          	addi	a0,a0,-1578 # ffffffffc02043b0 <commands+0x2b0>
ffffffffc02009e2:	fb2ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02009e6:	682c                	ld	a1,80(s0)
ffffffffc02009e8:	00004517          	auipc	a0,0x4
ffffffffc02009ec:	9e050513          	addi	a0,a0,-1568 # ffffffffc02043c8 <commands+0x2c8>
ffffffffc02009f0:	fa4ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02009f4:	6c2c                	ld	a1,88(s0)
ffffffffc02009f6:	00004517          	auipc	a0,0x4
ffffffffc02009fa:	9ea50513          	addi	a0,a0,-1558 # ffffffffc02043e0 <commands+0x2e0>
ffffffffc02009fe:	f96ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200a02:	702c                	ld	a1,96(s0)
ffffffffc0200a04:	00004517          	auipc	a0,0x4
ffffffffc0200a08:	9f450513          	addi	a0,a0,-1548 # ffffffffc02043f8 <commands+0x2f8>
ffffffffc0200a0c:	f88ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200a10:	742c                	ld	a1,104(s0)
ffffffffc0200a12:	00004517          	auipc	a0,0x4
ffffffffc0200a16:	9fe50513          	addi	a0,a0,-1538 # ffffffffc0204410 <commands+0x310>
ffffffffc0200a1a:	f7aff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200a1e:	782c                	ld	a1,112(s0)
ffffffffc0200a20:	00004517          	auipc	a0,0x4
ffffffffc0200a24:	a0850513          	addi	a0,a0,-1528 # ffffffffc0204428 <commands+0x328>
ffffffffc0200a28:	f6cff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200a2c:	7c2c                	ld	a1,120(s0)
ffffffffc0200a2e:	00004517          	auipc	a0,0x4
ffffffffc0200a32:	a1250513          	addi	a0,a0,-1518 # ffffffffc0204440 <commands+0x340>
ffffffffc0200a36:	f5eff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200a3a:	604c                	ld	a1,128(s0)
ffffffffc0200a3c:	00004517          	auipc	a0,0x4
ffffffffc0200a40:	a1c50513          	addi	a0,a0,-1508 # ffffffffc0204458 <commands+0x358>
ffffffffc0200a44:	f50ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200a48:	644c                	ld	a1,136(s0)
ffffffffc0200a4a:	00004517          	auipc	a0,0x4
ffffffffc0200a4e:	a2650513          	addi	a0,a0,-1498 # ffffffffc0204470 <commands+0x370>
ffffffffc0200a52:	f42ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200a56:	684c                	ld	a1,144(s0)
ffffffffc0200a58:	00004517          	auipc	a0,0x4
ffffffffc0200a5c:	a3050513          	addi	a0,a0,-1488 # ffffffffc0204488 <commands+0x388>
ffffffffc0200a60:	f34ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200a64:	6c4c                	ld	a1,152(s0)
ffffffffc0200a66:	00004517          	auipc	a0,0x4
ffffffffc0200a6a:	a3a50513          	addi	a0,a0,-1478 # ffffffffc02044a0 <commands+0x3a0>
ffffffffc0200a6e:	f26ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200a72:	704c                	ld	a1,160(s0)
ffffffffc0200a74:	00004517          	auipc	a0,0x4
ffffffffc0200a78:	a4450513          	addi	a0,a0,-1468 # ffffffffc02044b8 <commands+0x3b8>
ffffffffc0200a7c:	f18ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200a80:	744c                	ld	a1,168(s0)
ffffffffc0200a82:	00004517          	auipc	a0,0x4
ffffffffc0200a86:	a4e50513          	addi	a0,a0,-1458 # ffffffffc02044d0 <commands+0x3d0>
ffffffffc0200a8a:	f0aff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200a8e:	784c                	ld	a1,176(s0)
ffffffffc0200a90:	00004517          	auipc	a0,0x4
ffffffffc0200a94:	a5850513          	addi	a0,a0,-1448 # ffffffffc02044e8 <commands+0x3e8>
ffffffffc0200a98:	efcff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200a9c:	7c4c                	ld	a1,184(s0)
ffffffffc0200a9e:	00004517          	auipc	a0,0x4
ffffffffc0200aa2:	a6250513          	addi	a0,a0,-1438 # ffffffffc0204500 <commands+0x400>
ffffffffc0200aa6:	eeeff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200aaa:	606c                	ld	a1,192(s0)
ffffffffc0200aac:	00004517          	auipc	a0,0x4
ffffffffc0200ab0:	a6c50513          	addi	a0,a0,-1428 # ffffffffc0204518 <commands+0x418>
ffffffffc0200ab4:	ee0ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200ab8:	646c                	ld	a1,200(s0)
ffffffffc0200aba:	00004517          	auipc	a0,0x4
ffffffffc0200abe:	a7650513          	addi	a0,a0,-1418 # ffffffffc0204530 <commands+0x430>
ffffffffc0200ac2:	ed2ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200ac6:	686c                	ld	a1,208(s0)
ffffffffc0200ac8:	00004517          	auipc	a0,0x4
ffffffffc0200acc:	a8050513          	addi	a0,a0,-1408 # ffffffffc0204548 <commands+0x448>
ffffffffc0200ad0:	ec4ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200ad4:	6c6c                	ld	a1,216(s0)
ffffffffc0200ad6:	00004517          	auipc	a0,0x4
ffffffffc0200ada:	a8a50513          	addi	a0,a0,-1398 # ffffffffc0204560 <commands+0x460>
ffffffffc0200ade:	eb6ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200ae2:	706c                	ld	a1,224(s0)
ffffffffc0200ae4:	00004517          	auipc	a0,0x4
ffffffffc0200ae8:	a9450513          	addi	a0,a0,-1388 # ffffffffc0204578 <commands+0x478>
ffffffffc0200aec:	ea8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200af0:	746c                	ld	a1,232(s0)
ffffffffc0200af2:	00004517          	auipc	a0,0x4
ffffffffc0200af6:	a9e50513          	addi	a0,a0,-1378 # ffffffffc0204590 <commands+0x490>
ffffffffc0200afa:	e9aff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200afe:	786c                	ld	a1,240(s0)
ffffffffc0200b00:	00004517          	auipc	a0,0x4
ffffffffc0200b04:	aa850513          	addi	a0,a0,-1368 # ffffffffc02045a8 <commands+0x4a8>
ffffffffc0200b08:	e8cff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200b0c:	7c6c                	ld	a1,248(s0)
ffffffffc0200b0e:	6402                	ld	s0,0(sp)
ffffffffc0200b10:	60a2                	ld	ra,8(sp)
ffffffffc0200b12:	00004517          	auipc	a0,0x4
ffffffffc0200b16:	aae50513          	addi	a0,a0,-1362 # ffffffffc02045c0 <commands+0x4c0>
ffffffffc0200b1a:	0141                	addi	sp,sp,16
ffffffffc0200b1c:	e78ff06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0200b20 <print_trapframe>:
ffffffffc0200b20:	1141                	addi	sp,sp,-16
ffffffffc0200b22:	e022                	sd	s0,0(sp)
ffffffffc0200b24:	85aa                	mv	a1,a0
ffffffffc0200b26:	842a                	mv	s0,a0
ffffffffc0200b28:	00004517          	auipc	a0,0x4
ffffffffc0200b2c:	ab050513          	addi	a0,a0,-1360 # ffffffffc02045d8 <commands+0x4d8>
ffffffffc0200b30:	e406                	sd	ra,8(sp)
ffffffffc0200b32:	e62ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200b36:	8522                	mv	a0,s0
ffffffffc0200b38:	e1bff0ef          	jal	ra,ffffffffc0200952 <print_regs>
ffffffffc0200b3c:	10043583          	ld	a1,256(s0)
ffffffffc0200b40:	00004517          	auipc	a0,0x4
ffffffffc0200b44:	ab050513          	addi	a0,a0,-1360 # ffffffffc02045f0 <commands+0x4f0>
ffffffffc0200b48:	e4cff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200b4c:	10843583          	ld	a1,264(s0)
ffffffffc0200b50:	00004517          	auipc	a0,0x4
ffffffffc0200b54:	ab850513          	addi	a0,a0,-1352 # ffffffffc0204608 <commands+0x508>
ffffffffc0200b58:	e3cff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200b5c:	11043583          	ld	a1,272(s0)
ffffffffc0200b60:	00004517          	auipc	a0,0x4
ffffffffc0200b64:	ac050513          	addi	a0,a0,-1344 # ffffffffc0204620 <commands+0x520>
ffffffffc0200b68:	e2cff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200b6c:	11843583          	ld	a1,280(s0)
ffffffffc0200b70:	6402                	ld	s0,0(sp)
ffffffffc0200b72:	60a2                	ld	ra,8(sp)
ffffffffc0200b74:	00004517          	auipc	a0,0x4
ffffffffc0200b78:	ac450513          	addi	a0,a0,-1340 # ffffffffc0204638 <commands+0x538>
ffffffffc0200b7c:	0141                	addi	sp,sp,16
ffffffffc0200b7e:	e16ff06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0200b82 <interrupt_handler>:
ffffffffc0200b82:	11853783          	ld	a5,280(a0)
ffffffffc0200b86:	472d                	li	a4,11
ffffffffc0200b88:	0786                	slli	a5,a5,0x1
ffffffffc0200b8a:	8385                	srli	a5,a5,0x1
ffffffffc0200b8c:	06f76d63          	bltu	a4,a5,ffffffffc0200c06 <interrupt_handler+0x84>
ffffffffc0200b90:	00004717          	auipc	a4,0x4
ffffffffc0200b94:	b7070713          	addi	a4,a4,-1168 # ffffffffc0204700 <commands+0x600>
ffffffffc0200b98:	078a                	slli	a5,a5,0x2
ffffffffc0200b9a:	97ba                	add	a5,a5,a4
ffffffffc0200b9c:	439c                	lw	a5,0(a5)
ffffffffc0200b9e:	97ba                	add	a5,a5,a4
ffffffffc0200ba0:	8782                	jr	a5
ffffffffc0200ba2:	00004517          	auipc	a0,0x4
ffffffffc0200ba6:	b0e50513          	addi	a0,a0,-1266 # ffffffffc02046b0 <commands+0x5b0>
ffffffffc0200baa:	deaff06f          	j	ffffffffc0200194 <cprintf>
ffffffffc0200bae:	00004517          	auipc	a0,0x4
ffffffffc0200bb2:	ae250513          	addi	a0,a0,-1310 # ffffffffc0204690 <commands+0x590>
ffffffffc0200bb6:	ddeff06f          	j	ffffffffc0200194 <cprintf>
ffffffffc0200bba:	00004517          	auipc	a0,0x4
ffffffffc0200bbe:	a9650513          	addi	a0,a0,-1386 # ffffffffc0204650 <commands+0x550>
ffffffffc0200bc2:	dd2ff06f          	j	ffffffffc0200194 <cprintf>
ffffffffc0200bc6:	00004517          	auipc	a0,0x4
ffffffffc0200bca:	aaa50513          	addi	a0,a0,-1366 # ffffffffc0204670 <commands+0x570>
ffffffffc0200bce:	dc6ff06f          	j	ffffffffc0200194 <cprintf>
ffffffffc0200bd2:	1141                	addi	sp,sp,-16
ffffffffc0200bd4:	e406                	sd	ra,8(sp)
ffffffffc0200bd6:	919ff0ef          	jal	ra,ffffffffc02004ee <clock_set_next_event>
ffffffffc0200bda:	0000d797          	auipc	a5,0xd
ffffffffc0200bde:	89678793          	addi	a5,a5,-1898 # ffffffffc020d470 <ticks>
ffffffffc0200be2:	6398                	ld	a4,0(a5)
ffffffffc0200be4:	0705                	addi	a4,a4,1
ffffffffc0200be6:	e398                	sd	a4,0(a5)
ffffffffc0200be8:	639c                	ld	a5,0(a5)
ffffffffc0200bea:	06400713          	li	a4,100
ffffffffc0200bee:	02e7f7b3          	remu	a5,a5,a4
ffffffffc0200bf2:	cb99                	beqz	a5,ffffffffc0200c08 <interrupt_handler+0x86>
ffffffffc0200bf4:	60a2                	ld	ra,8(sp)
ffffffffc0200bf6:	0141                	addi	sp,sp,16
ffffffffc0200bf8:	8082                	ret
ffffffffc0200bfa:	00004517          	auipc	a0,0x4
ffffffffc0200bfe:	ae650513          	addi	a0,a0,-1306 # ffffffffc02046e0 <commands+0x5e0>
ffffffffc0200c02:	d92ff06f          	j	ffffffffc0200194 <cprintf>
ffffffffc0200c06:	bf29                	j	ffffffffc0200b20 <print_trapframe>
ffffffffc0200c08:	06400593          	li	a1,100
ffffffffc0200c0c:	00004517          	auipc	a0,0x4
ffffffffc0200c10:	ac450513          	addi	a0,a0,-1340 # ffffffffc02046d0 <commands+0x5d0>
ffffffffc0200c14:	d80ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200c18:	0000d697          	auipc	a3,0xd
ffffffffc0200c1c:	87868693          	addi	a3,a3,-1928 # ffffffffc020d490 <printed_num.0>
ffffffffc0200c20:	429c                	lw	a5,0(a3)
ffffffffc0200c22:	4729                	li	a4,10
ffffffffc0200c24:	2785                	addiw	a5,a5,1
ffffffffc0200c26:	02e7e73b          	remw	a4,a5,a4
ffffffffc0200c2a:	c29c                	sw	a5,0(a3)
ffffffffc0200c2c:	f761                	bnez	a4,ffffffffc0200bf4 <interrupt_handler+0x72>
ffffffffc0200c2e:	4501                	li	a0,0
ffffffffc0200c30:	4581                	li	a1,0
ffffffffc0200c32:	4601                	li	a2,0
ffffffffc0200c34:	48a1                	li	a7,8
ffffffffc0200c36:	00000073          	ecall
ffffffffc0200c3a:	bf6d                	j	ffffffffc0200bf4 <interrupt_handler+0x72>

ffffffffc0200c3c <exception_handler>:
ffffffffc0200c3c:	11853783          	ld	a5,280(a0)
ffffffffc0200c40:	473d                	li	a4,15
ffffffffc0200c42:	0cf76563          	bltu	a4,a5,ffffffffc0200d0c <exception_handler+0xd0>
ffffffffc0200c46:	00004717          	auipc	a4,0x4
ffffffffc0200c4a:	c8270713          	addi	a4,a4,-894 # ffffffffc02048c8 <commands+0x7c8>
ffffffffc0200c4e:	078a                	slli	a5,a5,0x2
ffffffffc0200c50:	97ba                	add	a5,a5,a4
ffffffffc0200c52:	439c                	lw	a5,0(a5)
ffffffffc0200c54:	97ba                	add	a5,a5,a4
ffffffffc0200c56:	8782                	jr	a5
ffffffffc0200c58:	00004517          	auipc	a0,0x4
ffffffffc0200c5c:	c5850513          	addi	a0,a0,-936 # ffffffffc02048b0 <commands+0x7b0>
ffffffffc0200c60:	d34ff06f          	j	ffffffffc0200194 <cprintf>
ffffffffc0200c64:	00004517          	auipc	a0,0x4
ffffffffc0200c68:	acc50513          	addi	a0,a0,-1332 # ffffffffc0204730 <commands+0x630>
ffffffffc0200c6c:	d28ff06f          	j	ffffffffc0200194 <cprintf>
ffffffffc0200c70:	00004517          	auipc	a0,0x4
ffffffffc0200c74:	ae050513          	addi	a0,a0,-1312 # ffffffffc0204750 <commands+0x650>
ffffffffc0200c78:	d1cff06f          	j	ffffffffc0200194 <cprintf>
ffffffffc0200c7c:	00004517          	auipc	a0,0x4
ffffffffc0200c80:	af450513          	addi	a0,a0,-1292 # ffffffffc0204770 <commands+0x670>
ffffffffc0200c84:	d10ff06f          	j	ffffffffc0200194 <cprintf>
ffffffffc0200c88:	00004517          	auipc	a0,0x4
ffffffffc0200c8c:	b0050513          	addi	a0,a0,-1280 # ffffffffc0204788 <commands+0x688>
ffffffffc0200c90:	d04ff06f          	j	ffffffffc0200194 <cprintf>
ffffffffc0200c94:	00004517          	auipc	a0,0x4
ffffffffc0200c98:	b0450513          	addi	a0,a0,-1276 # ffffffffc0204798 <commands+0x698>
ffffffffc0200c9c:	cf8ff06f          	j	ffffffffc0200194 <cprintf>
ffffffffc0200ca0:	00004517          	auipc	a0,0x4
ffffffffc0200ca4:	b1850513          	addi	a0,a0,-1256 # ffffffffc02047b8 <commands+0x6b8>
ffffffffc0200ca8:	cecff06f          	j	ffffffffc0200194 <cprintf>
ffffffffc0200cac:	00004517          	auipc	a0,0x4
ffffffffc0200cb0:	b2450513          	addi	a0,a0,-1244 # ffffffffc02047d0 <commands+0x6d0>
ffffffffc0200cb4:	ce0ff06f          	j	ffffffffc0200194 <cprintf>
ffffffffc0200cb8:	00004517          	auipc	a0,0x4
ffffffffc0200cbc:	b3050513          	addi	a0,a0,-1232 # ffffffffc02047e8 <commands+0x6e8>
ffffffffc0200cc0:	cd4ff06f          	j	ffffffffc0200194 <cprintf>
ffffffffc0200cc4:	00004517          	auipc	a0,0x4
ffffffffc0200cc8:	b3c50513          	addi	a0,a0,-1220 # ffffffffc0204800 <commands+0x700>
ffffffffc0200ccc:	cc8ff06f          	j	ffffffffc0200194 <cprintf>
ffffffffc0200cd0:	00004517          	auipc	a0,0x4
ffffffffc0200cd4:	b5050513          	addi	a0,a0,-1200 # ffffffffc0204820 <commands+0x720>
ffffffffc0200cd8:	cbcff06f          	j	ffffffffc0200194 <cprintf>
ffffffffc0200cdc:	00004517          	auipc	a0,0x4
ffffffffc0200ce0:	b6450513          	addi	a0,a0,-1180 # ffffffffc0204840 <commands+0x740>
ffffffffc0200ce4:	cb0ff06f          	j	ffffffffc0200194 <cprintf>
ffffffffc0200ce8:	00004517          	auipc	a0,0x4
ffffffffc0200cec:	b7850513          	addi	a0,a0,-1160 # ffffffffc0204860 <commands+0x760>
ffffffffc0200cf0:	ca4ff06f          	j	ffffffffc0200194 <cprintf>
ffffffffc0200cf4:	00004517          	auipc	a0,0x4
ffffffffc0200cf8:	b8c50513          	addi	a0,a0,-1140 # ffffffffc0204880 <commands+0x780>
ffffffffc0200cfc:	c98ff06f          	j	ffffffffc0200194 <cprintf>
ffffffffc0200d00:	00004517          	auipc	a0,0x4
ffffffffc0200d04:	b9850513          	addi	a0,a0,-1128 # ffffffffc0204898 <commands+0x798>
ffffffffc0200d08:	c8cff06f          	j	ffffffffc0200194 <cprintf>
ffffffffc0200d0c:	bd11                	j	ffffffffc0200b20 <print_trapframe>

ffffffffc0200d0e <trap>:
ffffffffc0200d0e:	11853783          	ld	a5,280(a0)
ffffffffc0200d12:	0007c363          	bltz	a5,ffffffffc0200d18 <trap+0xa>
ffffffffc0200d16:	b71d                	j	ffffffffc0200c3c <exception_handler>
ffffffffc0200d18:	b5ad                	j	ffffffffc0200b82 <interrupt_handler>
	...

ffffffffc0200d1c <__alltraps>:
ffffffffc0200d1c:	14011073          	csrw	sscratch,sp
ffffffffc0200d20:	712d                	addi	sp,sp,-288
ffffffffc0200d22:	e406                	sd	ra,8(sp)
ffffffffc0200d24:	ec0e                	sd	gp,24(sp)
ffffffffc0200d26:	f012                	sd	tp,32(sp)
ffffffffc0200d28:	f416                	sd	t0,40(sp)
ffffffffc0200d2a:	f81a                	sd	t1,48(sp)
ffffffffc0200d2c:	fc1e                	sd	t2,56(sp)
ffffffffc0200d2e:	e0a2                	sd	s0,64(sp)
ffffffffc0200d30:	e4a6                	sd	s1,72(sp)
ffffffffc0200d32:	e8aa                	sd	a0,80(sp)
ffffffffc0200d34:	ecae                	sd	a1,88(sp)
ffffffffc0200d36:	f0b2                	sd	a2,96(sp)
ffffffffc0200d38:	f4b6                	sd	a3,104(sp)
ffffffffc0200d3a:	f8ba                	sd	a4,112(sp)
ffffffffc0200d3c:	fcbe                	sd	a5,120(sp)
ffffffffc0200d3e:	e142                	sd	a6,128(sp)
ffffffffc0200d40:	e546                	sd	a7,136(sp)
ffffffffc0200d42:	e94a                	sd	s2,144(sp)
ffffffffc0200d44:	ed4e                	sd	s3,152(sp)
ffffffffc0200d46:	f152                	sd	s4,160(sp)
ffffffffc0200d48:	f556                	sd	s5,168(sp)
ffffffffc0200d4a:	f95a                	sd	s6,176(sp)
ffffffffc0200d4c:	fd5e                	sd	s7,184(sp)
ffffffffc0200d4e:	e1e2                	sd	s8,192(sp)
ffffffffc0200d50:	e5e6                	sd	s9,200(sp)
ffffffffc0200d52:	e9ea                	sd	s10,208(sp)
ffffffffc0200d54:	edee                	sd	s11,216(sp)
ffffffffc0200d56:	f1f2                	sd	t3,224(sp)
ffffffffc0200d58:	f5f6                	sd	t4,232(sp)
ffffffffc0200d5a:	f9fa                	sd	t5,240(sp)
ffffffffc0200d5c:	fdfe                	sd	t6,248(sp)
ffffffffc0200d5e:	14002473          	csrr	s0,sscratch
ffffffffc0200d62:	100024f3          	csrr	s1,sstatus
ffffffffc0200d66:	14102973          	csrr	s2,sepc
ffffffffc0200d6a:	143029f3          	csrr	s3,stval
ffffffffc0200d6e:	14202a73          	csrr	s4,scause
ffffffffc0200d72:	e822                	sd	s0,16(sp)
ffffffffc0200d74:	e226                	sd	s1,256(sp)
ffffffffc0200d76:	e64a                	sd	s2,264(sp)
ffffffffc0200d78:	ea4e                	sd	s3,272(sp)
ffffffffc0200d7a:	ee52                	sd	s4,280(sp)
ffffffffc0200d7c:	850a                	mv	a0,sp
ffffffffc0200d7e:	f91ff0ef          	jal	ra,ffffffffc0200d0e <trap>

ffffffffc0200d82 <__trapret>:
ffffffffc0200d82:	6492                	ld	s1,256(sp)
ffffffffc0200d84:	6932                	ld	s2,264(sp)
ffffffffc0200d86:	10049073          	csrw	sstatus,s1
ffffffffc0200d8a:	14191073          	csrw	sepc,s2
ffffffffc0200d8e:	60a2                	ld	ra,8(sp)
ffffffffc0200d90:	61e2                	ld	gp,24(sp)
ffffffffc0200d92:	7202                	ld	tp,32(sp)
ffffffffc0200d94:	72a2                	ld	t0,40(sp)
ffffffffc0200d96:	7342                	ld	t1,48(sp)
ffffffffc0200d98:	73e2                	ld	t2,56(sp)
ffffffffc0200d9a:	6406                	ld	s0,64(sp)
ffffffffc0200d9c:	64a6                	ld	s1,72(sp)
ffffffffc0200d9e:	6546                	ld	a0,80(sp)
ffffffffc0200da0:	65e6                	ld	a1,88(sp)
ffffffffc0200da2:	7606                	ld	a2,96(sp)
ffffffffc0200da4:	76a6                	ld	a3,104(sp)
ffffffffc0200da6:	7746                	ld	a4,112(sp)
ffffffffc0200da8:	77e6                	ld	a5,120(sp)
ffffffffc0200daa:	680a                	ld	a6,128(sp)
ffffffffc0200dac:	68aa                	ld	a7,136(sp)
ffffffffc0200dae:	694a                	ld	s2,144(sp)
ffffffffc0200db0:	69ea                	ld	s3,152(sp)
ffffffffc0200db2:	7a0a                	ld	s4,160(sp)
ffffffffc0200db4:	7aaa                	ld	s5,168(sp)
ffffffffc0200db6:	7b4a                	ld	s6,176(sp)
ffffffffc0200db8:	7bea                	ld	s7,184(sp)
ffffffffc0200dba:	6c0e                	ld	s8,192(sp)
ffffffffc0200dbc:	6cae                	ld	s9,200(sp)
ffffffffc0200dbe:	6d4e                	ld	s10,208(sp)
ffffffffc0200dc0:	6dee                	ld	s11,216(sp)
ffffffffc0200dc2:	7e0e                	ld	t3,224(sp)
ffffffffc0200dc4:	7eae                	ld	t4,232(sp)
ffffffffc0200dc6:	7f4e                	ld	t5,240(sp)
ffffffffc0200dc8:	7fee                	ld	t6,248(sp)
ffffffffc0200dca:	6142                	ld	sp,16(sp)
ffffffffc0200dcc:	10200073          	sret

ffffffffc0200dd0 <forkrets>:
ffffffffc0200dd0:	812a                	mv	sp,a0
ffffffffc0200dd2:	bf45                	j	ffffffffc0200d82 <__trapret>
	...

ffffffffc0200dd6 <default_init>:
ffffffffc0200dd6:	00008797          	auipc	a5,0x8
ffffffffc0200dda:	65a78793          	addi	a5,a5,1626 # ffffffffc0209430 <free_area>
ffffffffc0200dde:	e79c                	sd	a5,8(a5)
ffffffffc0200de0:	e39c                	sd	a5,0(a5)
ffffffffc0200de2:	0007a823          	sw	zero,16(a5)
ffffffffc0200de6:	8082                	ret

ffffffffc0200de8 <default_nr_free_pages>:
ffffffffc0200de8:	00008517          	auipc	a0,0x8
ffffffffc0200dec:	65856503          	lwu	a0,1624(a0) # ffffffffc0209440 <free_area+0x10>
ffffffffc0200df0:	8082                	ret

ffffffffc0200df2 <default_check>:
ffffffffc0200df2:	715d                	addi	sp,sp,-80
ffffffffc0200df4:	e0a2                	sd	s0,64(sp)
ffffffffc0200df6:	00008417          	auipc	s0,0x8
ffffffffc0200dfa:	63a40413          	addi	s0,s0,1594 # ffffffffc0209430 <free_area>
ffffffffc0200dfe:	641c                	ld	a5,8(s0)
ffffffffc0200e00:	e486                	sd	ra,72(sp)
ffffffffc0200e02:	fc26                	sd	s1,56(sp)
ffffffffc0200e04:	f84a                	sd	s2,48(sp)
ffffffffc0200e06:	f44e                	sd	s3,40(sp)
ffffffffc0200e08:	f052                	sd	s4,32(sp)
ffffffffc0200e0a:	ec56                	sd	s5,24(sp)
ffffffffc0200e0c:	e85a                	sd	s6,16(sp)
ffffffffc0200e0e:	e45e                	sd	s7,8(sp)
ffffffffc0200e10:	e062                	sd	s8,0(sp)
ffffffffc0200e12:	2a878d63          	beq	a5,s0,ffffffffc02010cc <default_check+0x2da>
ffffffffc0200e16:	4481                	li	s1,0
ffffffffc0200e18:	4901                	li	s2,0
ffffffffc0200e1a:	ff07b703          	ld	a4,-16(a5)
ffffffffc0200e1e:	8b09                	andi	a4,a4,2
ffffffffc0200e20:	2a070a63          	beqz	a4,ffffffffc02010d4 <default_check+0x2e2>
ffffffffc0200e24:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200e28:	679c                	ld	a5,8(a5)
ffffffffc0200e2a:	2905                	addiw	s2,s2,1
ffffffffc0200e2c:	9cb9                	addw	s1,s1,a4
ffffffffc0200e2e:	fe8796e3          	bne	a5,s0,ffffffffc0200e1a <default_check+0x28>
ffffffffc0200e32:	89a6                	mv	s3,s1
ffffffffc0200e34:	6db000ef          	jal	ra,ffffffffc0201d0e <nr_free_pages>
ffffffffc0200e38:	6f351e63          	bne	a0,s3,ffffffffc0201534 <default_check+0x742>
ffffffffc0200e3c:	4505                	li	a0,1
ffffffffc0200e3e:	653000ef          	jal	ra,ffffffffc0201c90 <alloc_pages>
ffffffffc0200e42:	8aaa                	mv	s5,a0
ffffffffc0200e44:	42050863          	beqz	a0,ffffffffc0201274 <default_check+0x482>
ffffffffc0200e48:	4505                	li	a0,1
ffffffffc0200e4a:	647000ef          	jal	ra,ffffffffc0201c90 <alloc_pages>
ffffffffc0200e4e:	89aa                	mv	s3,a0
ffffffffc0200e50:	70050263          	beqz	a0,ffffffffc0201554 <default_check+0x762>
ffffffffc0200e54:	4505                	li	a0,1
ffffffffc0200e56:	63b000ef          	jal	ra,ffffffffc0201c90 <alloc_pages>
ffffffffc0200e5a:	8a2a                	mv	s4,a0
ffffffffc0200e5c:	48050c63          	beqz	a0,ffffffffc02012f4 <default_check+0x502>
ffffffffc0200e60:	293a8a63          	beq	s5,s3,ffffffffc02010f4 <default_check+0x302>
ffffffffc0200e64:	28aa8863          	beq	s5,a0,ffffffffc02010f4 <default_check+0x302>
ffffffffc0200e68:	28a98663          	beq	s3,a0,ffffffffc02010f4 <default_check+0x302>
ffffffffc0200e6c:	000aa783          	lw	a5,0(s5)
ffffffffc0200e70:	2a079263          	bnez	a5,ffffffffc0201114 <default_check+0x322>
ffffffffc0200e74:	0009a783          	lw	a5,0(s3)
ffffffffc0200e78:	28079e63          	bnez	a5,ffffffffc0201114 <default_check+0x322>
ffffffffc0200e7c:	411c                	lw	a5,0(a0)
ffffffffc0200e7e:	28079b63          	bnez	a5,ffffffffc0201114 <default_check+0x322>
ffffffffc0200e82:	0000c797          	auipc	a5,0xc
ffffffffc0200e86:	6367b783          	ld	a5,1590(a5) # ffffffffc020d4b8 <pages>
ffffffffc0200e8a:	40fa8733          	sub	a4,s5,a5
ffffffffc0200e8e:	00005617          	auipc	a2,0x5
ffffffffc0200e92:	b5263603          	ld	a2,-1198(a2) # ffffffffc02059e0 <nbase>
ffffffffc0200e96:	8719                	srai	a4,a4,0x6
ffffffffc0200e98:	9732                	add	a4,a4,a2
ffffffffc0200e9a:	0000c697          	auipc	a3,0xc
ffffffffc0200e9e:	6166b683          	ld	a3,1558(a3) # ffffffffc020d4b0 <npage>
ffffffffc0200ea2:	06b2                	slli	a3,a3,0xc
ffffffffc0200ea4:	0732                	slli	a4,a4,0xc
ffffffffc0200ea6:	28d77763          	bgeu	a4,a3,ffffffffc0201134 <default_check+0x342>
ffffffffc0200eaa:	40f98733          	sub	a4,s3,a5
ffffffffc0200eae:	8719                	srai	a4,a4,0x6
ffffffffc0200eb0:	9732                	add	a4,a4,a2
ffffffffc0200eb2:	0732                	slli	a4,a4,0xc
ffffffffc0200eb4:	4cd77063          	bgeu	a4,a3,ffffffffc0201374 <default_check+0x582>
ffffffffc0200eb8:	40f507b3          	sub	a5,a0,a5
ffffffffc0200ebc:	8799                	srai	a5,a5,0x6
ffffffffc0200ebe:	97b2                	add	a5,a5,a2
ffffffffc0200ec0:	07b2                	slli	a5,a5,0xc
ffffffffc0200ec2:	30d7f963          	bgeu	a5,a3,ffffffffc02011d4 <default_check+0x3e2>
ffffffffc0200ec6:	4505                	li	a0,1
ffffffffc0200ec8:	00043c03          	ld	s8,0(s0)
ffffffffc0200ecc:	00843b83          	ld	s7,8(s0)
ffffffffc0200ed0:	01042b03          	lw	s6,16(s0)
ffffffffc0200ed4:	e400                	sd	s0,8(s0)
ffffffffc0200ed6:	e000                	sd	s0,0(s0)
ffffffffc0200ed8:	00008797          	auipc	a5,0x8
ffffffffc0200edc:	5607a423          	sw	zero,1384(a5) # ffffffffc0209440 <free_area+0x10>
ffffffffc0200ee0:	5b1000ef          	jal	ra,ffffffffc0201c90 <alloc_pages>
ffffffffc0200ee4:	2c051863          	bnez	a0,ffffffffc02011b4 <default_check+0x3c2>
ffffffffc0200ee8:	4585                	li	a1,1
ffffffffc0200eea:	8556                	mv	a0,s5
ffffffffc0200eec:	5e3000ef          	jal	ra,ffffffffc0201cce <free_pages>
ffffffffc0200ef0:	4585                	li	a1,1
ffffffffc0200ef2:	854e                	mv	a0,s3
ffffffffc0200ef4:	5db000ef          	jal	ra,ffffffffc0201cce <free_pages>
ffffffffc0200ef8:	4585                	li	a1,1
ffffffffc0200efa:	8552                	mv	a0,s4
ffffffffc0200efc:	5d3000ef          	jal	ra,ffffffffc0201cce <free_pages>
ffffffffc0200f00:	4818                	lw	a4,16(s0)
ffffffffc0200f02:	478d                	li	a5,3
ffffffffc0200f04:	28f71863          	bne	a4,a5,ffffffffc0201194 <default_check+0x3a2>
ffffffffc0200f08:	4505                	li	a0,1
ffffffffc0200f0a:	587000ef          	jal	ra,ffffffffc0201c90 <alloc_pages>
ffffffffc0200f0e:	89aa                	mv	s3,a0
ffffffffc0200f10:	26050263          	beqz	a0,ffffffffc0201174 <default_check+0x382>
ffffffffc0200f14:	4505                	li	a0,1
ffffffffc0200f16:	57b000ef          	jal	ra,ffffffffc0201c90 <alloc_pages>
ffffffffc0200f1a:	8aaa                	mv	s5,a0
ffffffffc0200f1c:	3a050c63          	beqz	a0,ffffffffc02012d4 <default_check+0x4e2>
ffffffffc0200f20:	4505                	li	a0,1
ffffffffc0200f22:	56f000ef          	jal	ra,ffffffffc0201c90 <alloc_pages>
ffffffffc0200f26:	8a2a                	mv	s4,a0
ffffffffc0200f28:	38050663          	beqz	a0,ffffffffc02012b4 <default_check+0x4c2>
ffffffffc0200f2c:	4505                	li	a0,1
ffffffffc0200f2e:	563000ef          	jal	ra,ffffffffc0201c90 <alloc_pages>
ffffffffc0200f32:	36051163          	bnez	a0,ffffffffc0201294 <default_check+0x4a2>
ffffffffc0200f36:	4585                	li	a1,1
ffffffffc0200f38:	854e                	mv	a0,s3
ffffffffc0200f3a:	595000ef          	jal	ra,ffffffffc0201cce <free_pages>
ffffffffc0200f3e:	641c                	ld	a5,8(s0)
ffffffffc0200f40:	20878a63          	beq	a5,s0,ffffffffc0201154 <default_check+0x362>
ffffffffc0200f44:	4505                	li	a0,1
ffffffffc0200f46:	54b000ef          	jal	ra,ffffffffc0201c90 <alloc_pages>
ffffffffc0200f4a:	30a99563          	bne	s3,a0,ffffffffc0201254 <default_check+0x462>
ffffffffc0200f4e:	4505                	li	a0,1
ffffffffc0200f50:	541000ef          	jal	ra,ffffffffc0201c90 <alloc_pages>
ffffffffc0200f54:	2e051063          	bnez	a0,ffffffffc0201234 <default_check+0x442>
ffffffffc0200f58:	481c                	lw	a5,16(s0)
ffffffffc0200f5a:	2a079d63          	bnez	a5,ffffffffc0201214 <default_check+0x422>
ffffffffc0200f5e:	854e                	mv	a0,s3
ffffffffc0200f60:	4585                	li	a1,1
ffffffffc0200f62:	01843023          	sd	s8,0(s0)
ffffffffc0200f66:	01743423          	sd	s7,8(s0)
ffffffffc0200f6a:	01642823          	sw	s6,16(s0)
ffffffffc0200f6e:	561000ef          	jal	ra,ffffffffc0201cce <free_pages>
ffffffffc0200f72:	4585                	li	a1,1
ffffffffc0200f74:	8556                	mv	a0,s5
ffffffffc0200f76:	559000ef          	jal	ra,ffffffffc0201cce <free_pages>
ffffffffc0200f7a:	4585                	li	a1,1
ffffffffc0200f7c:	8552                	mv	a0,s4
ffffffffc0200f7e:	551000ef          	jal	ra,ffffffffc0201cce <free_pages>
ffffffffc0200f82:	4515                	li	a0,5
ffffffffc0200f84:	50d000ef          	jal	ra,ffffffffc0201c90 <alloc_pages>
ffffffffc0200f88:	89aa                	mv	s3,a0
ffffffffc0200f8a:	26050563          	beqz	a0,ffffffffc02011f4 <default_check+0x402>
ffffffffc0200f8e:	651c                	ld	a5,8(a0)
ffffffffc0200f90:	8385                	srli	a5,a5,0x1
ffffffffc0200f92:	8b85                	andi	a5,a5,1
ffffffffc0200f94:	54079063          	bnez	a5,ffffffffc02014d4 <default_check+0x6e2>
ffffffffc0200f98:	4505                	li	a0,1
ffffffffc0200f9a:	00043b03          	ld	s6,0(s0)
ffffffffc0200f9e:	00843a83          	ld	s5,8(s0)
ffffffffc0200fa2:	e000                	sd	s0,0(s0)
ffffffffc0200fa4:	e400                	sd	s0,8(s0)
ffffffffc0200fa6:	4eb000ef          	jal	ra,ffffffffc0201c90 <alloc_pages>
ffffffffc0200faa:	50051563          	bnez	a0,ffffffffc02014b4 <default_check+0x6c2>
ffffffffc0200fae:	08098a13          	addi	s4,s3,128
ffffffffc0200fb2:	8552                	mv	a0,s4
ffffffffc0200fb4:	458d                	li	a1,3
ffffffffc0200fb6:	01042b83          	lw	s7,16(s0)
ffffffffc0200fba:	00008797          	auipc	a5,0x8
ffffffffc0200fbe:	4807a323          	sw	zero,1158(a5) # ffffffffc0209440 <free_area+0x10>
ffffffffc0200fc2:	50d000ef          	jal	ra,ffffffffc0201cce <free_pages>
ffffffffc0200fc6:	4511                	li	a0,4
ffffffffc0200fc8:	4c9000ef          	jal	ra,ffffffffc0201c90 <alloc_pages>
ffffffffc0200fcc:	4c051463          	bnez	a0,ffffffffc0201494 <default_check+0x6a2>
ffffffffc0200fd0:	0889b783          	ld	a5,136(s3)
ffffffffc0200fd4:	8385                	srli	a5,a5,0x1
ffffffffc0200fd6:	8b85                	andi	a5,a5,1
ffffffffc0200fd8:	48078e63          	beqz	a5,ffffffffc0201474 <default_check+0x682>
ffffffffc0200fdc:	0909a703          	lw	a4,144(s3)
ffffffffc0200fe0:	478d                	li	a5,3
ffffffffc0200fe2:	48f71963          	bne	a4,a5,ffffffffc0201474 <default_check+0x682>
ffffffffc0200fe6:	450d                	li	a0,3
ffffffffc0200fe8:	4a9000ef          	jal	ra,ffffffffc0201c90 <alloc_pages>
ffffffffc0200fec:	8c2a                	mv	s8,a0
ffffffffc0200fee:	46050363          	beqz	a0,ffffffffc0201454 <default_check+0x662>
ffffffffc0200ff2:	4505                	li	a0,1
ffffffffc0200ff4:	49d000ef          	jal	ra,ffffffffc0201c90 <alloc_pages>
ffffffffc0200ff8:	42051e63          	bnez	a0,ffffffffc0201434 <default_check+0x642>
ffffffffc0200ffc:	418a1c63          	bne	s4,s8,ffffffffc0201414 <default_check+0x622>
ffffffffc0201000:	4585                	li	a1,1
ffffffffc0201002:	854e                	mv	a0,s3
ffffffffc0201004:	4cb000ef          	jal	ra,ffffffffc0201cce <free_pages>
ffffffffc0201008:	458d                	li	a1,3
ffffffffc020100a:	8552                	mv	a0,s4
ffffffffc020100c:	4c3000ef          	jal	ra,ffffffffc0201cce <free_pages>
ffffffffc0201010:	0089b783          	ld	a5,8(s3)
ffffffffc0201014:	04098c13          	addi	s8,s3,64
ffffffffc0201018:	8385                	srli	a5,a5,0x1
ffffffffc020101a:	8b85                	andi	a5,a5,1
ffffffffc020101c:	3c078c63          	beqz	a5,ffffffffc02013f4 <default_check+0x602>
ffffffffc0201020:	0109a703          	lw	a4,16(s3)
ffffffffc0201024:	4785                	li	a5,1
ffffffffc0201026:	3cf71763          	bne	a4,a5,ffffffffc02013f4 <default_check+0x602>
ffffffffc020102a:	008a3783          	ld	a5,8(s4)
ffffffffc020102e:	8385                	srli	a5,a5,0x1
ffffffffc0201030:	8b85                	andi	a5,a5,1
ffffffffc0201032:	3a078163          	beqz	a5,ffffffffc02013d4 <default_check+0x5e2>
ffffffffc0201036:	010a2703          	lw	a4,16(s4)
ffffffffc020103a:	478d                	li	a5,3
ffffffffc020103c:	38f71c63          	bne	a4,a5,ffffffffc02013d4 <default_check+0x5e2>
ffffffffc0201040:	4505                	li	a0,1
ffffffffc0201042:	44f000ef          	jal	ra,ffffffffc0201c90 <alloc_pages>
ffffffffc0201046:	36a99763          	bne	s3,a0,ffffffffc02013b4 <default_check+0x5c2>
ffffffffc020104a:	4585                	li	a1,1
ffffffffc020104c:	483000ef          	jal	ra,ffffffffc0201cce <free_pages>
ffffffffc0201050:	4509                	li	a0,2
ffffffffc0201052:	43f000ef          	jal	ra,ffffffffc0201c90 <alloc_pages>
ffffffffc0201056:	32aa1f63          	bne	s4,a0,ffffffffc0201394 <default_check+0x5a2>
ffffffffc020105a:	4589                	li	a1,2
ffffffffc020105c:	473000ef          	jal	ra,ffffffffc0201cce <free_pages>
ffffffffc0201060:	4585                	li	a1,1
ffffffffc0201062:	8562                	mv	a0,s8
ffffffffc0201064:	46b000ef          	jal	ra,ffffffffc0201cce <free_pages>
ffffffffc0201068:	4515                	li	a0,5
ffffffffc020106a:	427000ef          	jal	ra,ffffffffc0201c90 <alloc_pages>
ffffffffc020106e:	89aa                	mv	s3,a0
ffffffffc0201070:	48050263          	beqz	a0,ffffffffc02014f4 <default_check+0x702>
ffffffffc0201074:	4505                	li	a0,1
ffffffffc0201076:	41b000ef          	jal	ra,ffffffffc0201c90 <alloc_pages>
ffffffffc020107a:	2c051d63          	bnez	a0,ffffffffc0201354 <default_check+0x562>
ffffffffc020107e:	481c                	lw	a5,16(s0)
ffffffffc0201080:	2a079a63          	bnez	a5,ffffffffc0201334 <default_check+0x542>
ffffffffc0201084:	4595                	li	a1,5
ffffffffc0201086:	854e                	mv	a0,s3
ffffffffc0201088:	01742823          	sw	s7,16(s0)
ffffffffc020108c:	01643023          	sd	s6,0(s0)
ffffffffc0201090:	01543423          	sd	s5,8(s0)
ffffffffc0201094:	43b000ef          	jal	ra,ffffffffc0201cce <free_pages>
ffffffffc0201098:	641c                	ld	a5,8(s0)
ffffffffc020109a:	00878963          	beq	a5,s0,ffffffffc02010ac <default_check+0x2ba>
ffffffffc020109e:	ff87a703          	lw	a4,-8(a5)
ffffffffc02010a2:	679c                	ld	a5,8(a5)
ffffffffc02010a4:	397d                	addiw	s2,s2,-1
ffffffffc02010a6:	9c99                	subw	s1,s1,a4
ffffffffc02010a8:	fe879be3          	bne	a5,s0,ffffffffc020109e <default_check+0x2ac>
ffffffffc02010ac:	26091463          	bnez	s2,ffffffffc0201314 <default_check+0x522>
ffffffffc02010b0:	46049263          	bnez	s1,ffffffffc0201514 <default_check+0x722>
ffffffffc02010b4:	60a6                	ld	ra,72(sp)
ffffffffc02010b6:	6406                	ld	s0,64(sp)
ffffffffc02010b8:	74e2                	ld	s1,56(sp)
ffffffffc02010ba:	7942                	ld	s2,48(sp)
ffffffffc02010bc:	79a2                	ld	s3,40(sp)
ffffffffc02010be:	7a02                	ld	s4,32(sp)
ffffffffc02010c0:	6ae2                	ld	s5,24(sp)
ffffffffc02010c2:	6b42                	ld	s6,16(sp)
ffffffffc02010c4:	6ba2                	ld	s7,8(sp)
ffffffffc02010c6:	6c02                	ld	s8,0(sp)
ffffffffc02010c8:	6161                	addi	sp,sp,80
ffffffffc02010ca:	8082                	ret
ffffffffc02010cc:	4981                	li	s3,0
ffffffffc02010ce:	4481                	li	s1,0
ffffffffc02010d0:	4901                	li	s2,0
ffffffffc02010d2:	b38d                	j	ffffffffc0200e34 <default_check+0x42>
ffffffffc02010d4:	00004697          	auipc	a3,0x4
ffffffffc02010d8:	83468693          	addi	a3,a3,-1996 # ffffffffc0204908 <commands+0x808>
ffffffffc02010dc:	00004617          	auipc	a2,0x4
ffffffffc02010e0:	83c60613          	addi	a2,a2,-1988 # ffffffffc0204918 <commands+0x818>
ffffffffc02010e4:	0f000593          	li	a1,240
ffffffffc02010e8:	00004517          	auipc	a0,0x4
ffffffffc02010ec:	84850513          	addi	a0,a0,-1976 # ffffffffc0204930 <commands+0x830>
ffffffffc02010f0:	b6aff0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc02010f4:	00004697          	auipc	a3,0x4
ffffffffc02010f8:	8d468693          	addi	a3,a3,-1836 # ffffffffc02049c8 <commands+0x8c8>
ffffffffc02010fc:	00004617          	auipc	a2,0x4
ffffffffc0201100:	81c60613          	addi	a2,a2,-2020 # ffffffffc0204918 <commands+0x818>
ffffffffc0201104:	0bd00593          	li	a1,189
ffffffffc0201108:	00004517          	auipc	a0,0x4
ffffffffc020110c:	82850513          	addi	a0,a0,-2008 # ffffffffc0204930 <commands+0x830>
ffffffffc0201110:	b4aff0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0201114:	00004697          	auipc	a3,0x4
ffffffffc0201118:	8dc68693          	addi	a3,a3,-1828 # ffffffffc02049f0 <commands+0x8f0>
ffffffffc020111c:	00003617          	auipc	a2,0x3
ffffffffc0201120:	7fc60613          	addi	a2,a2,2044 # ffffffffc0204918 <commands+0x818>
ffffffffc0201124:	0be00593          	li	a1,190
ffffffffc0201128:	00004517          	auipc	a0,0x4
ffffffffc020112c:	80850513          	addi	a0,a0,-2040 # ffffffffc0204930 <commands+0x830>
ffffffffc0201130:	b2aff0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0201134:	00004697          	auipc	a3,0x4
ffffffffc0201138:	8fc68693          	addi	a3,a3,-1796 # ffffffffc0204a30 <commands+0x930>
ffffffffc020113c:	00003617          	auipc	a2,0x3
ffffffffc0201140:	7dc60613          	addi	a2,a2,2012 # ffffffffc0204918 <commands+0x818>
ffffffffc0201144:	0c000593          	li	a1,192
ffffffffc0201148:	00003517          	auipc	a0,0x3
ffffffffc020114c:	7e850513          	addi	a0,a0,2024 # ffffffffc0204930 <commands+0x830>
ffffffffc0201150:	b0aff0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0201154:	00004697          	auipc	a3,0x4
ffffffffc0201158:	96468693          	addi	a3,a3,-1692 # ffffffffc0204ab8 <commands+0x9b8>
ffffffffc020115c:	00003617          	auipc	a2,0x3
ffffffffc0201160:	7bc60613          	addi	a2,a2,1980 # ffffffffc0204918 <commands+0x818>
ffffffffc0201164:	0d900593          	li	a1,217
ffffffffc0201168:	00003517          	auipc	a0,0x3
ffffffffc020116c:	7c850513          	addi	a0,a0,1992 # ffffffffc0204930 <commands+0x830>
ffffffffc0201170:	aeaff0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0201174:	00003697          	auipc	a3,0x3
ffffffffc0201178:	7f468693          	addi	a3,a3,2036 # ffffffffc0204968 <commands+0x868>
ffffffffc020117c:	00003617          	auipc	a2,0x3
ffffffffc0201180:	79c60613          	addi	a2,a2,1948 # ffffffffc0204918 <commands+0x818>
ffffffffc0201184:	0d200593          	li	a1,210
ffffffffc0201188:	00003517          	auipc	a0,0x3
ffffffffc020118c:	7a850513          	addi	a0,a0,1960 # ffffffffc0204930 <commands+0x830>
ffffffffc0201190:	acaff0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0201194:	00004697          	auipc	a3,0x4
ffffffffc0201198:	91468693          	addi	a3,a3,-1772 # ffffffffc0204aa8 <commands+0x9a8>
ffffffffc020119c:	00003617          	auipc	a2,0x3
ffffffffc02011a0:	77c60613          	addi	a2,a2,1916 # ffffffffc0204918 <commands+0x818>
ffffffffc02011a4:	0d000593          	li	a1,208
ffffffffc02011a8:	00003517          	auipc	a0,0x3
ffffffffc02011ac:	78850513          	addi	a0,a0,1928 # ffffffffc0204930 <commands+0x830>
ffffffffc02011b0:	aaaff0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc02011b4:	00004697          	auipc	a3,0x4
ffffffffc02011b8:	8dc68693          	addi	a3,a3,-1828 # ffffffffc0204a90 <commands+0x990>
ffffffffc02011bc:	00003617          	auipc	a2,0x3
ffffffffc02011c0:	75c60613          	addi	a2,a2,1884 # ffffffffc0204918 <commands+0x818>
ffffffffc02011c4:	0cb00593          	li	a1,203
ffffffffc02011c8:	00003517          	auipc	a0,0x3
ffffffffc02011cc:	76850513          	addi	a0,a0,1896 # ffffffffc0204930 <commands+0x830>
ffffffffc02011d0:	a8aff0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc02011d4:	00004697          	auipc	a3,0x4
ffffffffc02011d8:	89c68693          	addi	a3,a3,-1892 # ffffffffc0204a70 <commands+0x970>
ffffffffc02011dc:	00003617          	auipc	a2,0x3
ffffffffc02011e0:	73c60613          	addi	a2,a2,1852 # ffffffffc0204918 <commands+0x818>
ffffffffc02011e4:	0c200593          	li	a1,194
ffffffffc02011e8:	00003517          	auipc	a0,0x3
ffffffffc02011ec:	74850513          	addi	a0,a0,1864 # ffffffffc0204930 <commands+0x830>
ffffffffc02011f0:	a6aff0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc02011f4:	00004697          	auipc	a3,0x4
ffffffffc02011f8:	90c68693          	addi	a3,a3,-1780 # ffffffffc0204b00 <commands+0xa00>
ffffffffc02011fc:	00003617          	auipc	a2,0x3
ffffffffc0201200:	71c60613          	addi	a2,a2,1820 # ffffffffc0204918 <commands+0x818>
ffffffffc0201204:	0f800593          	li	a1,248
ffffffffc0201208:	00003517          	auipc	a0,0x3
ffffffffc020120c:	72850513          	addi	a0,a0,1832 # ffffffffc0204930 <commands+0x830>
ffffffffc0201210:	a4aff0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0201214:	00004697          	auipc	a3,0x4
ffffffffc0201218:	8dc68693          	addi	a3,a3,-1828 # ffffffffc0204af0 <commands+0x9f0>
ffffffffc020121c:	00003617          	auipc	a2,0x3
ffffffffc0201220:	6fc60613          	addi	a2,a2,1788 # ffffffffc0204918 <commands+0x818>
ffffffffc0201224:	0df00593          	li	a1,223
ffffffffc0201228:	00003517          	auipc	a0,0x3
ffffffffc020122c:	70850513          	addi	a0,a0,1800 # ffffffffc0204930 <commands+0x830>
ffffffffc0201230:	a2aff0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0201234:	00004697          	auipc	a3,0x4
ffffffffc0201238:	85c68693          	addi	a3,a3,-1956 # ffffffffc0204a90 <commands+0x990>
ffffffffc020123c:	00003617          	auipc	a2,0x3
ffffffffc0201240:	6dc60613          	addi	a2,a2,1756 # ffffffffc0204918 <commands+0x818>
ffffffffc0201244:	0dd00593          	li	a1,221
ffffffffc0201248:	00003517          	auipc	a0,0x3
ffffffffc020124c:	6e850513          	addi	a0,a0,1768 # ffffffffc0204930 <commands+0x830>
ffffffffc0201250:	a0aff0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0201254:	00004697          	auipc	a3,0x4
ffffffffc0201258:	87c68693          	addi	a3,a3,-1924 # ffffffffc0204ad0 <commands+0x9d0>
ffffffffc020125c:	00003617          	auipc	a2,0x3
ffffffffc0201260:	6bc60613          	addi	a2,a2,1724 # ffffffffc0204918 <commands+0x818>
ffffffffc0201264:	0dc00593          	li	a1,220
ffffffffc0201268:	00003517          	auipc	a0,0x3
ffffffffc020126c:	6c850513          	addi	a0,a0,1736 # ffffffffc0204930 <commands+0x830>
ffffffffc0201270:	9eaff0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0201274:	00003697          	auipc	a3,0x3
ffffffffc0201278:	6f468693          	addi	a3,a3,1780 # ffffffffc0204968 <commands+0x868>
ffffffffc020127c:	00003617          	auipc	a2,0x3
ffffffffc0201280:	69c60613          	addi	a2,a2,1692 # ffffffffc0204918 <commands+0x818>
ffffffffc0201284:	0b900593          	li	a1,185
ffffffffc0201288:	00003517          	auipc	a0,0x3
ffffffffc020128c:	6a850513          	addi	a0,a0,1704 # ffffffffc0204930 <commands+0x830>
ffffffffc0201290:	9caff0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0201294:	00003697          	auipc	a3,0x3
ffffffffc0201298:	7fc68693          	addi	a3,a3,2044 # ffffffffc0204a90 <commands+0x990>
ffffffffc020129c:	00003617          	auipc	a2,0x3
ffffffffc02012a0:	67c60613          	addi	a2,a2,1660 # ffffffffc0204918 <commands+0x818>
ffffffffc02012a4:	0d600593          	li	a1,214
ffffffffc02012a8:	00003517          	auipc	a0,0x3
ffffffffc02012ac:	68850513          	addi	a0,a0,1672 # ffffffffc0204930 <commands+0x830>
ffffffffc02012b0:	9aaff0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc02012b4:	00003697          	auipc	a3,0x3
ffffffffc02012b8:	6f468693          	addi	a3,a3,1780 # ffffffffc02049a8 <commands+0x8a8>
ffffffffc02012bc:	00003617          	auipc	a2,0x3
ffffffffc02012c0:	65c60613          	addi	a2,a2,1628 # ffffffffc0204918 <commands+0x818>
ffffffffc02012c4:	0d400593          	li	a1,212
ffffffffc02012c8:	00003517          	auipc	a0,0x3
ffffffffc02012cc:	66850513          	addi	a0,a0,1640 # ffffffffc0204930 <commands+0x830>
ffffffffc02012d0:	98aff0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc02012d4:	00003697          	auipc	a3,0x3
ffffffffc02012d8:	6b468693          	addi	a3,a3,1716 # ffffffffc0204988 <commands+0x888>
ffffffffc02012dc:	00003617          	auipc	a2,0x3
ffffffffc02012e0:	63c60613          	addi	a2,a2,1596 # ffffffffc0204918 <commands+0x818>
ffffffffc02012e4:	0d300593          	li	a1,211
ffffffffc02012e8:	00003517          	auipc	a0,0x3
ffffffffc02012ec:	64850513          	addi	a0,a0,1608 # ffffffffc0204930 <commands+0x830>
ffffffffc02012f0:	96aff0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc02012f4:	00003697          	auipc	a3,0x3
ffffffffc02012f8:	6b468693          	addi	a3,a3,1716 # ffffffffc02049a8 <commands+0x8a8>
ffffffffc02012fc:	00003617          	auipc	a2,0x3
ffffffffc0201300:	61c60613          	addi	a2,a2,1564 # ffffffffc0204918 <commands+0x818>
ffffffffc0201304:	0bb00593          	li	a1,187
ffffffffc0201308:	00003517          	auipc	a0,0x3
ffffffffc020130c:	62850513          	addi	a0,a0,1576 # ffffffffc0204930 <commands+0x830>
ffffffffc0201310:	94aff0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0201314:	00004697          	auipc	a3,0x4
ffffffffc0201318:	93c68693          	addi	a3,a3,-1732 # ffffffffc0204c50 <commands+0xb50>
ffffffffc020131c:	00003617          	auipc	a2,0x3
ffffffffc0201320:	5fc60613          	addi	a2,a2,1532 # ffffffffc0204918 <commands+0x818>
ffffffffc0201324:	12500593          	li	a1,293
ffffffffc0201328:	00003517          	auipc	a0,0x3
ffffffffc020132c:	60850513          	addi	a0,a0,1544 # ffffffffc0204930 <commands+0x830>
ffffffffc0201330:	92aff0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0201334:	00003697          	auipc	a3,0x3
ffffffffc0201338:	7bc68693          	addi	a3,a3,1980 # ffffffffc0204af0 <commands+0x9f0>
ffffffffc020133c:	00003617          	auipc	a2,0x3
ffffffffc0201340:	5dc60613          	addi	a2,a2,1500 # ffffffffc0204918 <commands+0x818>
ffffffffc0201344:	11a00593          	li	a1,282
ffffffffc0201348:	00003517          	auipc	a0,0x3
ffffffffc020134c:	5e850513          	addi	a0,a0,1512 # ffffffffc0204930 <commands+0x830>
ffffffffc0201350:	90aff0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0201354:	00003697          	auipc	a3,0x3
ffffffffc0201358:	73c68693          	addi	a3,a3,1852 # ffffffffc0204a90 <commands+0x990>
ffffffffc020135c:	00003617          	auipc	a2,0x3
ffffffffc0201360:	5bc60613          	addi	a2,a2,1468 # ffffffffc0204918 <commands+0x818>
ffffffffc0201364:	11800593          	li	a1,280
ffffffffc0201368:	00003517          	auipc	a0,0x3
ffffffffc020136c:	5c850513          	addi	a0,a0,1480 # ffffffffc0204930 <commands+0x830>
ffffffffc0201370:	8eaff0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0201374:	00003697          	auipc	a3,0x3
ffffffffc0201378:	6dc68693          	addi	a3,a3,1756 # ffffffffc0204a50 <commands+0x950>
ffffffffc020137c:	00003617          	auipc	a2,0x3
ffffffffc0201380:	59c60613          	addi	a2,a2,1436 # ffffffffc0204918 <commands+0x818>
ffffffffc0201384:	0c100593          	li	a1,193
ffffffffc0201388:	00003517          	auipc	a0,0x3
ffffffffc020138c:	5a850513          	addi	a0,a0,1448 # ffffffffc0204930 <commands+0x830>
ffffffffc0201390:	8caff0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0201394:	00004697          	auipc	a3,0x4
ffffffffc0201398:	87c68693          	addi	a3,a3,-1924 # ffffffffc0204c10 <commands+0xb10>
ffffffffc020139c:	00003617          	auipc	a2,0x3
ffffffffc02013a0:	57c60613          	addi	a2,a2,1404 # ffffffffc0204918 <commands+0x818>
ffffffffc02013a4:	11200593          	li	a1,274
ffffffffc02013a8:	00003517          	auipc	a0,0x3
ffffffffc02013ac:	58850513          	addi	a0,a0,1416 # ffffffffc0204930 <commands+0x830>
ffffffffc02013b0:	8aaff0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc02013b4:	00004697          	auipc	a3,0x4
ffffffffc02013b8:	83c68693          	addi	a3,a3,-1988 # ffffffffc0204bf0 <commands+0xaf0>
ffffffffc02013bc:	00003617          	auipc	a2,0x3
ffffffffc02013c0:	55c60613          	addi	a2,a2,1372 # ffffffffc0204918 <commands+0x818>
ffffffffc02013c4:	11000593          	li	a1,272
ffffffffc02013c8:	00003517          	auipc	a0,0x3
ffffffffc02013cc:	56850513          	addi	a0,a0,1384 # ffffffffc0204930 <commands+0x830>
ffffffffc02013d0:	88aff0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc02013d4:	00003697          	auipc	a3,0x3
ffffffffc02013d8:	7f468693          	addi	a3,a3,2036 # ffffffffc0204bc8 <commands+0xac8>
ffffffffc02013dc:	00003617          	auipc	a2,0x3
ffffffffc02013e0:	53c60613          	addi	a2,a2,1340 # ffffffffc0204918 <commands+0x818>
ffffffffc02013e4:	10e00593          	li	a1,270
ffffffffc02013e8:	00003517          	auipc	a0,0x3
ffffffffc02013ec:	54850513          	addi	a0,a0,1352 # ffffffffc0204930 <commands+0x830>
ffffffffc02013f0:	86aff0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc02013f4:	00003697          	auipc	a3,0x3
ffffffffc02013f8:	7ac68693          	addi	a3,a3,1964 # ffffffffc0204ba0 <commands+0xaa0>
ffffffffc02013fc:	00003617          	auipc	a2,0x3
ffffffffc0201400:	51c60613          	addi	a2,a2,1308 # ffffffffc0204918 <commands+0x818>
ffffffffc0201404:	10d00593          	li	a1,269
ffffffffc0201408:	00003517          	auipc	a0,0x3
ffffffffc020140c:	52850513          	addi	a0,a0,1320 # ffffffffc0204930 <commands+0x830>
ffffffffc0201410:	84aff0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0201414:	00003697          	auipc	a3,0x3
ffffffffc0201418:	77c68693          	addi	a3,a3,1916 # ffffffffc0204b90 <commands+0xa90>
ffffffffc020141c:	00003617          	auipc	a2,0x3
ffffffffc0201420:	4fc60613          	addi	a2,a2,1276 # ffffffffc0204918 <commands+0x818>
ffffffffc0201424:	10800593          	li	a1,264
ffffffffc0201428:	00003517          	auipc	a0,0x3
ffffffffc020142c:	50850513          	addi	a0,a0,1288 # ffffffffc0204930 <commands+0x830>
ffffffffc0201430:	82aff0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0201434:	00003697          	auipc	a3,0x3
ffffffffc0201438:	65c68693          	addi	a3,a3,1628 # ffffffffc0204a90 <commands+0x990>
ffffffffc020143c:	00003617          	auipc	a2,0x3
ffffffffc0201440:	4dc60613          	addi	a2,a2,1244 # ffffffffc0204918 <commands+0x818>
ffffffffc0201444:	10700593          	li	a1,263
ffffffffc0201448:	00003517          	auipc	a0,0x3
ffffffffc020144c:	4e850513          	addi	a0,a0,1256 # ffffffffc0204930 <commands+0x830>
ffffffffc0201450:	80aff0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0201454:	00003697          	auipc	a3,0x3
ffffffffc0201458:	71c68693          	addi	a3,a3,1820 # ffffffffc0204b70 <commands+0xa70>
ffffffffc020145c:	00003617          	auipc	a2,0x3
ffffffffc0201460:	4bc60613          	addi	a2,a2,1212 # ffffffffc0204918 <commands+0x818>
ffffffffc0201464:	10600593          	li	a1,262
ffffffffc0201468:	00003517          	auipc	a0,0x3
ffffffffc020146c:	4c850513          	addi	a0,a0,1224 # ffffffffc0204930 <commands+0x830>
ffffffffc0201470:	febfe0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0201474:	00003697          	auipc	a3,0x3
ffffffffc0201478:	6cc68693          	addi	a3,a3,1740 # ffffffffc0204b40 <commands+0xa40>
ffffffffc020147c:	00003617          	auipc	a2,0x3
ffffffffc0201480:	49c60613          	addi	a2,a2,1180 # ffffffffc0204918 <commands+0x818>
ffffffffc0201484:	10500593          	li	a1,261
ffffffffc0201488:	00003517          	auipc	a0,0x3
ffffffffc020148c:	4a850513          	addi	a0,a0,1192 # ffffffffc0204930 <commands+0x830>
ffffffffc0201490:	fcbfe0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0201494:	00003697          	auipc	a3,0x3
ffffffffc0201498:	69468693          	addi	a3,a3,1684 # ffffffffc0204b28 <commands+0xa28>
ffffffffc020149c:	00003617          	auipc	a2,0x3
ffffffffc02014a0:	47c60613          	addi	a2,a2,1148 # ffffffffc0204918 <commands+0x818>
ffffffffc02014a4:	10400593          	li	a1,260
ffffffffc02014a8:	00003517          	auipc	a0,0x3
ffffffffc02014ac:	48850513          	addi	a0,a0,1160 # ffffffffc0204930 <commands+0x830>
ffffffffc02014b0:	fabfe0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc02014b4:	00003697          	auipc	a3,0x3
ffffffffc02014b8:	5dc68693          	addi	a3,a3,1500 # ffffffffc0204a90 <commands+0x990>
ffffffffc02014bc:	00003617          	auipc	a2,0x3
ffffffffc02014c0:	45c60613          	addi	a2,a2,1116 # ffffffffc0204918 <commands+0x818>
ffffffffc02014c4:	0fe00593          	li	a1,254
ffffffffc02014c8:	00003517          	auipc	a0,0x3
ffffffffc02014cc:	46850513          	addi	a0,a0,1128 # ffffffffc0204930 <commands+0x830>
ffffffffc02014d0:	f8bfe0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc02014d4:	00003697          	auipc	a3,0x3
ffffffffc02014d8:	63c68693          	addi	a3,a3,1596 # ffffffffc0204b10 <commands+0xa10>
ffffffffc02014dc:	00003617          	auipc	a2,0x3
ffffffffc02014e0:	43c60613          	addi	a2,a2,1084 # ffffffffc0204918 <commands+0x818>
ffffffffc02014e4:	0f900593          	li	a1,249
ffffffffc02014e8:	00003517          	auipc	a0,0x3
ffffffffc02014ec:	44850513          	addi	a0,a0,1096 # ffffffffc0204930 <commands+0x830>
ffffffffc02014f0:	f6bfe0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc02014f4:	00003697          	auipc	a3,0x3
ffffffffc02014f8:	73c68693          	addi	a3,a3,1852 # ffffffffc0204c30 <commands+0xb30>
ffffffffc02014fc:	00003617          	auipc	a2,0x3
ffffffffc0201500:	41c60613          	addi	a2,a2,1052 # ffffffffc0204918 <commands+0x818>
ffffffffc0201504:	11700593          	li	a1,279
ffffffffc0201508:	00003517          	auipc	a0,0x3
ffffffffc020150c:	42850513          	addi	a0,a0,1064 # ffffffffc0204930 <commands+0x830>
ffffffffc0201510:	f4bfe0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0201514:	00003697          	auipc	a3,0x3
ffffffffc0201518:	74c68693          	addi	a3,a3,1868 # ffffffffc0204c60 <commands+0xb60>
ffffffffc020151c:	00003617          	auipc	a2,0x3
ffffffffc0201520:	3fc60613          	addi	a2,a2,1020 # ffffffffc0204918 <commands+0x818>
ffffffffc0201524:	12600593          	li	a1,294
ffffffffc0201528:	00003517          	auipc	a0,0x3
ffffffffc020152c:	40850513          	addi	a0,a0,1032 # ffffffffc0204930 <commands+0x830>
ffffffffc0201530:	f2bfe0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0201534:	00003697          	auipc	a3,0x3
ffffffffc0201538:	41468693          	addi	a3,a3,1044 # ffffffffc0204948 <commands+0x848>
ffffffffc020153c:	00003617          	auipc	a2,0x3
ffffffffc0201540:	3dc60613          	addi	a2,a2,988 # ffffffffc0204918 <commands+0x818>
ffffffffc0201544:	0f300593          	li	a1,243
ffffffffc0201548:	00003517          	auipc	a0,0x3
ffffffffc020154c:	3e850513          	addi	a0,a0,1000 # ffffffffc0204930 <commands+0x830>
ffffffffc0201550:	f0bfe0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0201554:	00003697          	auipc	a3,0x3
ffffffffc0201558:	43468693          	addi	a3,a3,1076 # ffffffffc0204988 <commands+0x888>
ffffffffc020155c:	00003617          	auipc	a2,0x3
ffffffffc0201560:	3bc60613          	addi	a2,a2,956 # ffffffffc0204918 <commands+0x818>
ffffffffc0201564:	0ba00593          	li	a1,186
ffffffffc0201568:	00003517          	auipc	a0,0x3
ffffffffc020156c:	3c850513          	addi	a0,a0,968 # ffffffffc0204930 <commands+0x830>
ffffffffc0201570:	eebfe0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc0201574 <default_free_pages>:
ffffffffc0201574:	1141                	addi	sp,sp,-16
ffffffffc0201576:	e406                	sd	ra,8(sp)
ffffffffc0201578:	14058463          	beqz	a1,ffffffffc02016c0 <default_free_pages+0x14c>
ffffffffc020157c:	00659693          	slli	a3,a1,0x6
ffffffffc0201580:	96aa                	add	a3,a3,a0
ffffffffc0201582:	87aa                	mv	a5,a0
ffffffffc0201584:	02d50263          	beq	a0,a3,ffffffffc02015a8 <default_free_pages+0x34>
ffffffffc0201588:	6798                	ld	a4,8(a5)
ffffffffc020158a:	8b05                	andi	a4,a4,1
ffffffffc020158c:	10071a63          	bnez	a4,ffffffffc02016a0 <default_free_pages+0x12c>
ffffffffc0201590:	6798                	ld	a4,8(a5)
ffffffffc0201592:	8b09                	andi	a4,a4,2
ffffffffc0201594:	10071663          	bnez	a4,ffffffffc02016a0 <default_free_pages+0x12c>
ffffffffc0201598:	0007b423          	sd	zero,8(a5)
ffffffffc020159c:	0007a023          	sw	zero,0(a5)
ffffffffc02015a0:	04078793          	addi	a5,a5,64
ffffffffc02015a4:	fed792e3          	bne	a5,a3,ffffffffc0201588 <default_free_pages+0x14>
ffffffffc02015a8:	2581                	sext.w	a1,a1
ffffffffc02015aa:	c90c                	sw	a1,16(a0)
ffffffffc02015ac:	00850893          	addi	a7,a0,8
ffffffffc02015b0:	4789                	li	a5,2
ffffffffc02015b2:	40f8b02f          	amoor.d	zero,a5,(a7)
ffffffffc02015b6:	00008697          	auipc	a3,0x8
ffffffffc02015ba:	e7a68693          	addi	a3,a3,-390 # ffffffffc0209430 <free_area>
ffffffffc02015be:	4a98                	lw	a4,16(a3)
ffffffffc02015c0:	669c                	ld	a5,8(a3)
ffffffffc02015c2:	01850613          	addi	a2,a0,24
ffffffffc02015c6:	9db9                	addw	a1,a1,a4
ffffffffc02015c8:	ca8c                	sw	a1,16(a3)
ffffffffc02015ca:	0ad78463          	beq	a5,a3,ffffffffc0201672 <default_free_pages+0xfe>
ffffffffc02015ce:	fe878713          	addi	a4,a5,-24
ffffffffc02015d2:	0006b803          	ld	a6,0(a3)
ffffffffc02015d6:	4581                	li	a1,0
ffffffffc02015d8:	00e56a63          	bltu	a0,a4,ffffffffc02015ec <default_free_pages+0x78>
ffffffffc02015dc:	6798                	ld	a4,8(a5)
ffffffffc02015de:	04d70c63          	beq	a4,a3,ffffffffc0201636 <default_free_pages+0xc2>
ffffffffc02015e2:	87ba                	mv	a5,a4
ffffffffc02015e4:	fe878713          	addi	a4,a5,-24
ffffffffc02015e8:	fee57ae3          	bgeu	a0,a4,ffffffffc02015dc <default_free_pages+0x68>
ffffffffc02015ec:	c199                	beqz	a1,ffffffffc02015f2 <default_free_pages+0x7e>
ffffffffc02015ee:	0106b023          	sd	a6,0(a3)
ffffffffc02015f2:	6398                	ld	a4,0(a5)
ffffffffc02015f4:	e390                	sd	a2,0(a5)
ffffffffc02015f6:	e710                	sd	a2,8(a4)
ffffffffc02015f8:	f11c                	sd	a5,32(a0)
ffffffffc02015fa:	ed18                	sd	a4,24(a0)
ffffffffc02015fc:	00d70d63          	beq	a4,a3,ffffffffc0201616 <default_free_pages+0xa2>
ffffffffc0201600:	ff872583          	lw	a1,-8(a4)
ffffffffc0201604:	fe870613          	addi	a2,a4,-24
ffffffffc0201608:	02059813          	slli	a6,a1,0x20
ffffffffc020160c:	01a85793          	srli	a5,a6,0x1a
ffffffffc0201610:	97b2                	add	a5,a5,a2
ffffffffc0201612:	02f50c63          	beq	a0,a5,ffffffffc020164a <default_free_pages+0xd6>
ffffffffc0201616:	711c                	ld	a5,32(a0)
ffffffffc0201618:	00d78c63          	beq	a5,a3,ffffffffc0201630 <default_free_pages+0xbc>
ffffffffc020161c:	4910                	lw	a2,16(a0)
ffffffffc020161e:	fe878693          	addi	a3,a5,-24
ffffffffc0201622:	02061593          	slli	a1,a2,0x20
ffffffffc0201626:	01a5d713          	srli	a4,a1,0x1a
ffffffffc020162a:	972a                	add	a4,a4,a0
ffffffffc020162c:	04e68a63          	beq	a3,a4,ffffffffc0201680 <default_free_pages+0x10c>
ffffffffc0201630:	60a2                	ld	ra,8(sp)
ffffffffc0201632:	0141                	addi	sp,sp,16
ffffffffc0201634:	8082                	ret
ffffffffc0201636:	e790                	sd	a2,8(a5)
ffffffffc0201638:	f114                	sd	a3,32(a0)
ffffffffc020163a:	6798                	ld	a4,8(a5)
ffffffffc020163c:	ed1c                	sd	a5,24(a0)
ffffffffc020163e:	02d70763          	beq	a4,a3,ffffffffc020166c <default_free_pages+0xf8>
ffffffffc0201642:	8832                	mv	a6,a2
ffffffffc0201644:	4585                	li	a1,1
ffffffffc0201646:	87ba                	mv	a5,a4
ffffffffc0201648:	bf71                	j	ffffffffc02015e4 <default_free_pages+0x70>
ffffffffc020164a:	491c                	lw	a5,16(a0)
ffffffffc020164c:	9dbd                	addw	a1,a1,a5
ffffffffc020164e:	feb72c23          	sw	a1,-8(a4)
ffffffffc0201652:	57f5                	li	a5,-3
ffffffffc0201654:	60f8b02f          	amoand.d	zero,a5,(a7)
ffffffffc0201658:	01853803          	ld	a6,24(a0)
ffffffffc020165c:	710c                	ld	a1,32(a0)
ffffffffc020165e:	8532                	mv	a0,a2
ffffffffc0201660:	00b83423          	sd	a1,8(a6)
ffffffffc0201664:	671c                	ld	a5,8(a4)
ffffffffc0201666:	0105b023          	sd	a6,0(a1)
ffffffffc020166a:	b77d                	j	ffffffffc0201618 <default_free_pages+0xa4>
ffffffffc020166c:	e290                	sd	a2,0(a3)
ffffffffc020166e:	873e                	mv	a4,a5
ffffffffc0201670:	bf41                	j	ffffffffc0201600 <default_free_pages+0x8c>
ffffffffc0201672:	60a2                	ld	ra,8(sp)
ffffffffc0201674:	e390                	sd	a2,0(a5)
ffffffffc0201676:	e790                	sd	a2,8(a5)
ffffffffc0201678:	f11c                	sd	a5,32(a0)
ffffffffc020167a:	ed1c                	sd	a5,24(a0)
ffffffffc020167c:	0141                	addi	sp,sp,16
ffffffffc020167e:	8082                	ret
ffffffffc0201680:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201684:	ff078693          	addi	a3,a5,-16
ffffffffc0201688:	9e39                	addw	a2,a2,a4
ffffffffc020168a:	c910                	sw	a2,16(a0)
ffffffffc020168c:	5775                	li	a4,-3
ffffffffc020168e:	60e6b02f          	amoand.d	zero,a4,(a3)
ffffffffc0201692:	6398                	ld	a4,0(a5)
ffffffffc0201694:	679c                	ld	a5,8(a5)
ffffffffc0201696:	60a2                	ld	ra,8(sp)
ffffffffc0201698:	e71c                	sd	a5,8(a4)
ffffffffc020169a:	e398                	sd	a4,0(a5)
ffffffffc020169c:	0141                	addi	sp,sp,16
ffffffffc020169e:	8082                	ret
ffffffffc02016a0:	00003697          	auipc	a3,0x3
ffffffffc02016a4:	5d868693          	addi	a3,a3,1496 # ffffffffc0204c78 <commands+0xb78>
ffffffffc02016a8:	00003617          	auipc	a2,0x3
ffffffffc02016ac:	27060613          	addi	a2,a2,624 # ffffffffc0204918 <commands+0x818>
ffffffffc02016b0:	08300593          	li	a1,131
ffffffffc02016b4:	00003517          	auipc	a0,0x3
ffffffffc02016b8:	27c50513          	addi	a0,a0,636 # ffffffffc0204930 <commands+0x830>
ffffffffc02016bc:	d9ffe0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc02016c0:	00003697          	auipc	a3,0x3
ffffffffc02016c4:	5b068693          	addi	a3,a3,1456 # ffffffffc0204c70 <commands+0xb70>
ffffffffc02016c8:	00003617          	auipc	a2,0x3
ffffffffc02016cc:	25060613          	addi	a2,a2,592 # ffffffffc0204918 <commands+0x818>
ffffffffc02016d0:	08000593          	li	a1,128
ffffffffc02016d4:	00003517          	auipc	a0,0x3
ffffffffc02016d8:	25c50513          	addi	a0,a0,604 # ffffffffc0204930 <commands+0x830>
ffffffffc02016dc:	d7ffe0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc02016e0 <default_alloc_pages>:
ffffffffc02016e0:	c941                	beqz	a0,ffffffffc0201770 <default_alloc_pages+0x90>
ffffffffc02016e2:	00008597          	auipc	a1,0x8
ffffffffc02016e6:	d4e58593          	addi	a1,a1,-690 # ffffffffc0209430 <free_area>
ffffffffc02016ea:	0105a803          	lw	a6,16(a1)
ffffffffc02016ee:	872a                	mv	a4,a0
ffffffffc02016f0:	02081793          	slli	a5,a6,0x20
ffffffffc02016f4:	9381                	srli	a5,a5,0x20
ffffffffc02016f6:	00a7ee63          	bltu	a5,a0,ffffffffc0201712 <default_alloc_pages+0x32>
ffffffffc02016fa:	87ae                	mv	a5,a1
ffffffffc02016fc:	a801                	j	ffffffffc020170c <default_alloc_pages+0x2c>
ffffffffc02016fe:	ff87a683          	lw	a3,-8(a5)
ffffffffc0201702:	02069613          	slli	a2,a3,0x20
ffffffffc0201706:	9201                	srli	a2,a2,0x20
ffffffffc0201708:	00e67763          	bgeu	a2,a4,ffffffffc0201716 <default_alloc_pages+0x36>
ffffffffc020170c:	679c                	ld	a5,8(a5)
ffffffffc020170e:	feb798e3          	bne	a5,a1,ffffffffc02016fe <default_alloc_pages+0x1e>
ffffffffc0201712:	4501                	li	a0,0
ffffffffc0201714:	8082                	ret
ffffffffc0201716:	0007b883          	ld	a7,0(a5)
ffffffffc020171a:	0087b303          	ld	t1,8(a5)
ffffffffc020171e:	fe878513          	addi	a0,a5,-24
ffffffffc0201722:	00070e1b          	sext.w	t3,a4
ffffffffc0201726:	0068b423          	sd	t1,8(a7)
ffffffffc020172a:	01133023          	sd	a7,0(t1)
ffffffffc020172e:	02c77863          	bgeu	a4,a2,ffffffffc020175e <default_alloc_pages+0x7e>
ffffffffc0201732:	071a                	slli	a4,a4,0x6
ffffffffc0201734:	972a                	add	a4,a4,a0
ffffffffc0201736:	41c686bb          	subw	a3,a3,t3
ffffffffc020173a:	cb14                	sw	a3,16(a4)
ffffffffc020173c:	00870613          	addi	a2,a4,8
ffffffffc0201740:	4689                	li	a3,2
ffffffffc0201742:	40d6302f          	amoor.d	zero,a3,(a2)
ffffffffc0201746:	0088b683          	ld	a3,8(a7)
ffffffffc020174a:	01870613          	addi	a2,a4,24
ffffffffc020174e:	0105a803          	lw	a6,16(a1)
ffffffffc0201752:	e290                	sd	a2,0(a3)
ffffffffc0201754:	00c8b423          	sd	a2,8(a7)
ffffffffc0201758:	f314                	sd	a3,32(a4)
ffffffffc020175a:	01173c23          	sd	a7,24(a4)
ffffffffc020175e:	41c8083b          	subw	a6,a6,t3
ffffffffc0201762:	0105a823          	sw	a6,16(a1)
ffffffffc0201766:	5775                	li	a4,-3
ffffffffc0201768:	17c1                	addi	a5,a5,-16
ffffffffc020176a:	60e7b02f          	amoand.d	zero,a4,(a5)
ffffffffc020176e:	8082                	ret
ffffffffc0201770:	1141                	addi	sp,sp,-16
ffffffffc0201772:	00003697          	auipc	a3,0x3
ffffffffc0201776:	4fe68693          	addi	a3,a3,1278 # ffffffffc0204c70 <commands+0xb70>
ffffffffc020177a:	00003617          	auipc	a2,0x3
ffffffffc020177e:	19e60613          	addi	a2,a2,414 # ffffffffc0204918 <commands+0x818>
ffffffffc0201782:	06200593          	li	a1,98
ffffffffc0201786:	00003517          	auipc	a0,0x3
ffffffffc020178a:	1aa50513          	addi	a0,a0,426 # ffffffffc0204930 <commands+0x830>
ffffffffc020178e:	e406                	sd	ra,8(sp)
ffffffffc0201790:	ccbfe0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc0201794 <default_init_memmap>:
ffffffffc0201794:	1141                	addi	sp,sp,-16
ffffffffc0201796:	e406                	sd	ra,8(sp)
ffffffffc0201798:	c5f1                	beqz	a1,ffffffffc0201864 <default_init_memmap+0xd0>
ffffffffc020179a:	00659693          	slli	a3,a1,0x6
ffffffffc020179e:	96aa                	add	a3,a3,a0
ffffffffc02017a0:	87aa                	mv	a5,a0
ffffffffc02017a2:	00d50f63          	beq	a0,a3,ffffffffc02017c0 <default_init_memmap+0x2c>
ffffffffc02017a6:	6798                	ld	a4,8(a5)
ffffffffc02017a8:	8b05                	andi	a4,a4,1
ffffffffc02017aa:	cf49                	beqz	a4,ffffffffc0201844 <default_init_memmap+0xb0>
ffffffffc02017ac:	0007a823          	sw	zero,16(a5)
ffffffffc02017b0:	0007b423          	sd	zero,8(a5)
ffffffffc02017b4:	0007a023          	sw	zero,0(a5)
ffffffffc02017b8:	04078793          	addi	a5,a5,64
ffffffffc02017bc:	fed795e3          	bne	a5,a3,ffffffffc02017a6 <default_init_memmap+0x12>
ffffffffc02017c0:	2581                	sext.w	a1,a1
ffffffffc02017c2:	c90c                	sw	a1,16(a0)
ffffffffc02017c4:	4789                	li	a5,2
ffffffffc02017c6:	00850713          	addi	a4,a0,8
ffffffffc02017ca:	40f7302f          	amoor.d	zero,a5,(a4)
ffffffffc02017ce:	00008697          	auipc	a3,0x8
ffffffffc02017d2:	c6268693          	addi	a3,a3,-926 # ffffffffc0209430 <free_area>
ffffffffc02017d6:	4a98                	lw	a4,16(a3)
ffffffffc02017d8:	669c                	ld	a5,8(a3)
ffffffffc02017da:	01850613          	addi	a2,a0,24
ffffffffc02017de:	9db9                	addw	a1,a1,a4
ffffffffc02017e0:	ca8c                	sw	a1,16(a3)
ffffffffc02017e2:	04d78a63          	beq	a5,a3,ffffffffc0201836 <default_init_memmap+0xa2>
ffffffffc02017e6:	fe878713          	addi	a4,a5,-24
ffffffffc02017ea:	0006b803          	ld	a6,0(a3)
ffffffffc02017ee:	4581                	li	a1,0
ffffffffc02017f0:	00e56a63          	bltu	a0,a4,ffffffffc0201804 <default_init_memmap+0x70>
ffffffffc02017f4:	6798                	ld	a4,8(a5)
ffffffffc02017f6:	02d70263          	beq	a4,a3,ffffffffc020181a <default_init_memmap+0x86>
ffffffffc02017fa:	87ba                	mv	a5,a4
ffffffffc02017fc:	fe878713          	addi	a4,a5,-24
ffffffffc0201800:	fee57ae3          	bgeu	a0,a4,ffffffffc02017f4 <default_init_memmap+0x60>
ffffffffc0201804:	c199                	beqz	a1,ffffffffc020180a <default_init_memmap+0x76>
ffffffffc0201806:	0106b023          	sd	a6,0(a3)
ffffffffc020180a:	6398                	ld	a4,0(a5)
ffffffffc020180c:	60a2                	ld	ra,8(sp)
ffffffffc020180e:	e390                	sd	a2,0(a5)
ffffffffc0201810:	e710                	sd	a2,8(a4)
ffffffffc0201812:	f11c                	sd	a5,32(a0)
ffffffffc0201814:	ed18                	sd	a4,24(a0)
ffffffffc0201816:	0141                	addi	sp,sp,16
ffffffffc0201818:	8082                	ret
ffffffffc020181a:	e790                	sd	a2,8(a5)
ffffffffc020181c:	f114                	sd	a3,32(a0)
ffffffffc020181e:	6798                	ld	a4,8(a5)
ffffffffc0201820:	ed1c                	sd	a5,24(a0)
ffffffffc0201822:	00d70663          	beq	a4,a3,ffffffffc020182e <default_init_memmap+0x9a>
ffffffffc0201826:	8832                	mv	a6,a2
ffffffffc0201828:	4585                	li	a1,1
ffffffffc020182a:	87ba                	mv	a5,a4
ffffffffc020182c:	bfc1                	j	ffffffffc02017fc <default_init_memmap+0x68>
ffffffffc020182e:	60a2                	ld	ra,8(sp)
ffffffffc0201830:	e290                	sd	a2,0(a3)
ffffffffc0201832:	0141                	addi	sp,sp,16
ffffffffc0201834:	8082                	ret
ffffffffc0201836:	60a2                	ld	ra,8(sp)
ffffffffc0201838:	e390                	sd	a2,0(a5)
ffffffffc020183a:	e790                	sd	a2,8(a5)
ffffffffc020183c:	f11c                	sd	a5,32(a0)
ffffffffc020183e:	ed1c                	sd	a5,24(a0)
ffffffffc0201840:	0141                	addi	sp,sp,16
ffffffffc0201842:	8082                	ret
ffffffffc0201844:	00003697          	auipc	a3,0x3
ffffffffc0201848:	45c68693          	addi	a3,a3,1116 # ffffffffc0204ca0 <commands+0xba0>
ffffffffc020184c:	00003617          	auipc	a2,0x3
ffffffffc0201850:	0cc60613          	addi	a2,a2,204 # ffffffffc0204918 <commands+0x818>
ffffffffc0201854:	04900593          	li	a1,73
ffffffffc0201858:	00003517          	auipc	a0,0x3
ffffffffc020185c:	0d850513          	addi	a0,a0,216 # ffffffffc0204930 <commands+0x830>
ffffffffc0201860:	bfbfe0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0201864:	00003697          	auipc	a3,0x3
ffffffffc0201868:	40c68693          	addi	a3,a3,1036 # ffffffffc0204c70 <commands+0xb70>
ffffffffc020186c:	00003617          	auipc	a2,0x3
ffffffffc0201870:	0ac60613          	addi	a2,a2,172 # ffffffffc0204918 <commands+0x818>
ffffffffc0201874:	04600593          	li	a1,70
ffffffffc0201878:	00003517          	auipc	a0,0x3
ffffffffc020187c:	0b850513          	addi	a0,a0,184 # ffffffffc0204930 <commands+0x830>
ffffffffc0201880:	bdbfe0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc0201884 <slob_free>:
ffffffffc0201884:	c94d                	beqz	a0,ffffffffc0201936 <slob_free+0xb2>
ffffffffc0201886:	1141                	addi	sp,sp,-16
ffffffffc0201888:	e022                	sd	s0,0(sp)
ffffffffc020188a:	e406                	sd	ra,8(sp)
ffffffffc020188c:	842a                	mv	s0,a0
ffffffffc020188e:	e9c1                	bnez	a1,ffffffffc020191e <slob_free+0x9a>
ffffffffc0201890:	100027f3          	csrr	a5,sstatus
ffffffffc0201894:	8b89                	andi	a5,a5,2
ffffffffc0201896:	4501                	li	a0,0
ffffffffc0201898:	ebd9                	bnez	a5,ffffffffc020192e <slob_free+0xaa>
ffffffffc020189a:	00007617          	auipc	a2,0x7
ffffffffc020189e:	78660613          	addi	a2,a2,1926 # ffffffffc0209020 <slobfree>
ffffffffc02018a2:	621c                	ld	a5,0(a2)
ffffffffc02018a4:	873e                	mv	a4,a5
ffffffffc02018a6:	679c                	ld	a5,8(a5)
ffffffffc02018a8:	02877a63          	bgeu	a4,s0,ffffffffc02018dc <slob_free+0x58>
ffffffffc02018ac:	00f46463          	bltu	s0,a5,ffffffffc02018b4 <slob_free+0x30>
ffffffffc02018b0:	fef76ae3          	bltu	a4,a5,ffffffffc02018a4 <slob_free+0x20>
ffffffffc02018b4:	400c                	lw	a1,0(s0)
ffffffffc02018b6:	00459693          	slli	a3,a1,0x4
ffffffffc02018ba:	96a2                	add	a3,a3,s0
ffffffffc02018bc:	02d78a63          	beq	a5,a3,ffffffffc02018f0 <slob_free+0x6c>
ffffffffc02018c0:	4314                	lw	a3,0(a4)
ffffffffc02018c2:	e41c                	sd	a5,8(s0)
ffffffffc02018c4:	00469793          	slli	a5,a3,0x4
ffffffffc02018c8:	97ba                	add	a5,a5,a4
ffffffffc02018ca:	02f40e63          	beq	s0,a5,ffffffffc0201906 <slob_free+0x82>
ffffffffc02018ce:	e700                	sd	s0,8(a4)
ffffffffc02018d0:	e218                	sd	a4,0(a2)
ffffffffc02018d2:	e129                	bnez	a0,ffffffffc0201914 <slob_free+0x90>
ffffffffc02018d4:	60a2                	ld	ra,8(sp)
ffffffffc02018d6:	6402                	ld	s0,0(sp)
ffffffffc02018d8:	0141                	addi	sp,sp,16
ffffffffc02018da:	8082                	ret
ffffffffc02018dc:	fcf764e3          	bltu	a4,a5,ffffffffc02018a4 <slob_free+0x20>
ffffffffc02018e0:	fcf472e3          	bgeu	s0,a5,ffffffffc02018a4 <slob_free+0x20>
ffffffffc02018e4:	400c                	lw	a1,0(s0)
ffffffffc02018e6:	00459693          	slli	a3,a1,0x4
ffffffffc02018ea:	96a2                	add	a3,a3,s0
ffffffffc02018ec:	fcd79ae3          	bne	a5,a3,ffffffffc02018c0 <slob_free+0x3c>
ffffffffc02018f0:	4394                	lw	a3,0(a5)
ffffffffc02018f2:	679c                	ld	a5,8(a5)
ffffffffc02018f4:	9db5                	addw	a1,a1,a3
ffffffffc02018f6:	c00c                	sw	a1,0(s0)
ffffffffc02018f8:	4314                	lw	a3,0(a4)
ffffffffc02018fa:	e41c                	sd	a5,8(s0)
ffffffffc02018fc:	00469793          	slli	a5,a3,0x4
ffffffffc0201900:	97ba                	add	a5,a5,a4
ffffffffc0201902:	fcf416e3          	bne	s0,a5,ffffffffc02018ce <slob_free+0x4a>
ffffffffc0201906:	401c                	lw	a5,0(s0)
ffffffffc0201908:	640c                	ld	a1,8(s0)
ffffffffc020190a:	e218                	sd	a4,0(a2)
ffffffffc020190c:	9ebd                	addw	a3,a3,a5
ffffffffc020190e:	c314                	sw	a3,0(a4)
ffffffffc0201910:	e70c                	sd	a1,8(a4)
ffffffffc0201912:	d169                	beqz	a0,ffffffffc02018d4 <slob_free+0x50>
ffffffffc0201914:	6402                	ld	s0,0(sp)
ffffffffc0201916:	60a2                	ld	ra,8(sp)
ffffffffc0201918:	0141                	addi	sp,sp,16
ffffffffc020191a:	810ff06f          	j	ffffffffc020092a <intr_enable>
ffffffffc020191e:	25bd                	addiw	a1,a1,15
ffffffffc0201920:	8191                	srli	a1,a1,0x4
ffffffffc0201922:	c10c                	sw	a1,0(a0)
ffffffffc0201924:	100027f3          	csrr	a5,sstatus
ffffffffc0201928:	8b89                	andi	a5,a5,2
ffffffffc020192a:	4501                	li	a0,0
ffffffffc020192c:	d7bd                	beqz	a5,ffffffffc020189a <slob_free+0x16>
ffffffffc020192e:	802ff0ef          	jal	ra,ffffffffc0200930 <intr_disable>
ffffffffc0201932:	4505                	li	a0,1
ffffffffc0201934:	b79d                	j	ffffffffc020189a <slob_free+0x16>
ffffffffc0201936:	8082                	ret

ffffffffc0201938 <__slob_get_free_pages.constprop.0>:
ffffffffc0201938:	4785                	li	a5,1
ffffffffc020193a:	1141                	addi	sp,sp,-16
ffffffffc020193c:	00a7953b          	sllw	a0,a5,a0
ffffffffc0201940:	e406                	sd	ra,8(sp)
ffffffffc0201942:	34e000ef          	jal	ra,ffffffffc0201c90 <alloc_pages>
ffffffffc0201946:	c91d                	beqz	a0,ffffffffc020197c <__slob_get_free_pages.constprop.0+0x44>
ffffffffc0201948:	0000c697          	auipc	a3,0xc
ffffffffc020194c:	b706b683          	ld	a3,-1168(a3) # ffffffffc020d4b8 <pages>
ffffffffc0201950:	8d15                	sub	a0,a0,a3
ffffffffc0201952:	8519                	srai	a0,a0,0x6
ffffffffc0201954:	00004697          	auipc	a3,0x4
ffffffffc0201958:	08c6b683          	ld	a3,140(a3) # ffffffffc02059e0 <nbase>
ffffffffc020195c:	9536                	add	a0,a0,a3
ffffffffc020195e:	00c51793          	slli	a5,a0,0xc
ffffffffc0201962:	83b1                	srli	a5,a5,0xc
ffffffffc0201964:	0000c717          	auipc	a4,0xc
ffffffffc0201968:	b4c73703          	ld	a4,-1204(a4) # ffffffffc020d4b0 <npage>
ffffffffc020196c:	0532                	slli	a0,a0,0xc
ffffffffc020196e:	00e7fa63          	bgeu	a5,a4,ffffffffc0201982 <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc0201972:	0000c697          	auipc	a3,0xc
ffffffffc0201976:	b566b683          	ld	a3,-1194(a3) # ffffffffc020d4c8 <va_pa_offset>
ffffffffc020197a:	9536                	add	a0,a0,a3
ffffffffc020197c:	60a2                	ld	ra,8(sp)
ffffffffc020197e:	0141                	addi	sp,sp,16
ffffffffc0201980:	8082                	ret
ffffffffc0201982:	86aa                	mv	a3,a0
ffffffffc0201984:	00003617          	auipc	a2,0x3
ffffffffc0201988:	37c60613          	addi	a2,a2,892 # ffffffffc0204d00 <default_pmm_manager+0x38>
ffffffffc020198c:	07100593          	li	a1,113
ffffffffc0201990:	00003517          	auipc	a0,0x3
ffffffffc0201994:	39850513          	addi	a0,a0,920 # ffffffffc0204d28 <default_pmm_manager+0x60>
ffffffffc0201998:	ac3fe0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc020199c <slob_alloc.constprop.0>:
ffffffffc020199c:	1101                	addi	sp,sp,-32
ffffffffc020199e:	ec06                	sd	ra,24(sp)
ffffffffc02019a0:	e822                	sd	s0,16(sp)
ffffffffc02019a2:	e426                	sd	s1,8(sp)
ffffffffc02019a4:	e04a                	sd	s2,0(sp)
ffffffffc02019a6:	01050713          	addi	a4,a0,16
ffffffffc02019aa:	6785                	lui	a5,0x1
ffffffffc02019ac:	0cf77363          	bgeu	a4,a5,ffffffffc0201a72 <slob_alloc.constprop.0+0xd6>
ffffffffc02019b0:	00f50493          	addi	s1,a0,15
ffffffffc02019b4:	8091                	srli	s1,s1,0x4
ffffffffc02019b6:	2481                	sext.w	s1,s1
ffffffffc02019b8:	10002673          	csrr	a2,sstatus
ffffffffc02019bc:	8a09                	andi	a2,a2,2
ffffffffc02019be:	e25d                	bnez	a2,ffffffffc0201a64 <slob_alloc.constprop.0+0xc8>
ffffffffc02019c0:	00007917          	auipc	s2,0x7
ffffffffc02019c4:	66090913          	addi	s2,s2,1632 # ffffffffc0209020 <slobfree>
ffffffffc02019c8:	00093683          	ld	a3,0(s2)
ffffffffc02019cc:	669c                	ld	a5,8(a3)
ffffffffc02019ce:	4398                	lw	a4,0(a5)
ffffffffc02019d0:	08975e63          	bge	a4,s1,ffffffffc0201a6c <slob_alloc.constprop.0+0xd0>
ffffffffc02019d4:	00d78b63          	beq	a5,a3,ffffffffc02019ea <slob_alloc.constprop.0+0x4e>
ffffffffc02019d8:	6780                	ld	s0,8(a5)
ffffffffc02019da:	4018                	lw	a4,0(s0)
ffffffffc02019dc:	02975a63          	bge	a4,s1,ffffffffc0201a10 <slob_alloc.constprop.0+0x74>
ffffffffc02019e0:	00093683          	ld	a3,0(s2)
ffffffffc02019e4:	87a2                	mv	a5,s0
ffffffffc02019e6:	fed799e3          	bne	a5,a3,ffffffffc02019d8 <slob_alloc.constprop.0+0x3c>
ffffffffc02019ea:	ee31                	bnez	a2,ffffffffc0201a46 <slob_alloc.constprop.0+0xaa>
ffffffffc02019ec:	4501                	li	a0,0
ffffffffc02019ee:	f4bff0ef          	jal	ra,ffffffffc0201938 <__slob_get_free_pages.constprop.0>
ffffffffc02019f2:	842a                	mv	s0,a0
ffffffffc02019f4:	cd05                	beqz	a0,ffffffffc0201a2c <slob_alloc.constprop.0+0x90>
ffffffffc02019f6:	6585                	lui	a1,0x1
ffffffffc02019f8:	e8dff0ef          	jal	ra,ffffffffc0201884 <slob_free>
ffffffffc02019fc:	10002673          	csrr	a2,sstatus
ffffffffc0201a00:	8a09                	andi	a2,a2,2
ffffffffc0201a02:	ee05                	bnez	a2,ffffffffc0201a3a <slob_alloc.constprop.0+0x9e>
ffffffffc0201a04:	00093783          	ld	a5,0(s2)
ffffffffc0201a08:	6780                	ld	s0,8(a5)
ffffffffc0201a0a:	4018                	lw	a4,0(s0)
ffffffffc0201a0c:	fc974ae3          	blt	a4,s1,ffffffffc02019e0 <slob_alloc.constprop.0+0x44>
ffffffffc0201a10:	04e48763          	beq	s1,a4,ffffffffc0201a5e <slob_alloc.constprop.0+0xc2>
ffffffffc0201a14:	00449693          	slli	a3,s1,0x4
ffffffffc0201a18:	96a2                	add	a3,a3,s0
ffffffffc0201a1a:	e794                	sd	a3,8(a5)
ffffffffc0201a1c:	640c                	ld	a1,8(s0)
ffffffffc0201a1e:	9f05                	subw	a4,a4,s1
ffffffffc0201a20:	c298                	sw	a4,0(a3)
ffffffffc0201a22:	e68c                	sd	a1,8(a3)
ffffffffc0201a24:	c004                	sw	s1,0(s0)
ffffffffc0201a26:	00f93023          	sd	a5,0(s2)
ffffffffc0201a2a:	e20d                	bnez	a2,ffffffffc0201a4c <slob_alloc.constprop.0+0xb0>
ffffffffc0201a2c:	60e2                	ld	ra,24(sp)
ffffffffc0201a2e:	8522                	mv	a0,s0
ffffffffc0201a30:	6442                	ld	s0,16(sp)
ffffffffc0201a32:	64a2                	ld	s1,8(sp)
ffffffffc0201a34:	6902                	ld	s2,0(sp)
ffffffffc0201a36:	6105                	addi	sp,sp,32
ffffffffc0201a38:	8082                	ret
ffffffffc0201a3a:	ef7fe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
ffffffffc0201a3e:	00093783          	ld	a5,0(s2)
ffffffffc0201a42:	4605                	li	a2,1
ffffffffc0201a44:	b7d1                	j	ffffffffc0201a08 <slob_alloc.constprop.0+0x6c>
ffffffffc0201a46:	ee5fe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc0201a4a:	b74d                	j	ffffffffc02019ec <slob_alloc.constprop.0+0x50>
ffffffffc0201a4c:	edffe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc0201a50:	60e2                	ld	ra,24(sp)
ffffffffc0201a52:	8522                	mv	a0,s0
ffffffffc0201a54:	6442                	ld	s0,16(sp)
ffffffffc0201a56:	64a2                	ld	s1,8(sp)
ffffffffc0201a58:	6902                	ld	s2,0(sp)
ffffffffc0201a5a:	6105                	addi	sp,sp,32
ffffffffc0201a5c:	8082                	ret
ffffffffc0201a5e:	6418                	ld	a4,8(s0)
ffffffffc0201a60:	e798                	sd	a4,8(a5)
ffffffffc0201a62:	b7d1                	j	ffffffffc0201a26 <slob_alloc.constprop.0+0x8a>
ffffffffc0201a64:	ecdfe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
ffffffffc0201a68:	4605                	li	a2,1
ffffffffc0201a6a:	bf99                	j	ffffffffc02019c0 <slob_alloc.constprop.0+0x24>
ffffffffc0201a6c:	843e                	mv	s0,a5
ffffffffc0201a6e:	87b6                	mv	a5,a3
ffffffffc0201a70:	b745                	j	ffffffffc0201a10 <slob_alloc.constprop.0+0x74>
ffffffffc0201a72:	00003697          	auipc	a3,0x3
ffffffffc0201a76:	2c668693          	addi	a3,a3,710 # ffffffffc0204d38 <default_pmm_manager+0x70>
ffffffffc0201a7a:	00003617          	auipc	a2,0x3
ffffffffc0201a7e:	e9e60613          	addi	a2,a2,-354 # ffffffffc0204918 <commands+0x818>
ffffffffc0201a82:	06300593          	li	a1,99
ffffffffc0201a86:	00003517          	auipc	a0,0x3
ffffffffc0201a8a:	2d250513          	addi	a0,a0,722 # ffffffffc0204d58 <default_pmm_manager+0x90>
ffffffffc0201a8e:	9cdfe0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc0201a92 <kmalloc_init>:
ffffffffc0201a92:	1141                	addi	sp,sp,-16
ffffffffc0201a94:	00003517          	auipc	a0,0x3
ffffffffc0201a98:	2dc50513          	addi	a0,a0,732 # ffffffffc0204d70 <default_pmm_manager+0xa8>
ffffffffc0201a9c:	e406                	sd	ra,8(sp)
ffffffffc0201a9e:	ef6fe0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0201aa2:	60a2                	ld	ra,8(sp)
ffffffffc0201aa4:	00003517          	auipc	a0,0x3
ffffffffc0201aa8:	2e450513          	addi	a0,a0,740 # ffffffffc0204d88 <default_pmm_manager+0xc0>
ffffffffc0201aac:	0141                	addi	sp,sp,16
ffffffffc0201aae:	ee6fe06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0201ab2 <kmalloc>:
ffffffffc0201ab2:	1101                	addi	sp,sp,-32
ffffffffc0201ab4:	e04a                	sd	s2,0(sp)
ffffffffc0201ab6:	6905                	lui	s2,0x1
ffffffffc0201ab8:	e822                	sd	s0,16(sp)
ffffffffc0201aba:	ec06                	sd	ra,24(sp)
ffffffffc0201abc:	e426                	sd	s1,8(sp)
ffffffffc0201abe:	fef90793          	addi	a5,s2,-17 # fef <kern_entry-0xffffffffc01ff011>
ffffffffc0201ac2:	842a                	mv	s0,a0
ffffffffc0201ac4:	04a7f963          	bgeu	a5,a0,ffffffffc0201b16 <kmalloc+0x64>
ffffffffc0201ac8:	4561                	li	a0,24
ffffffffc0201aca:	ed3ff0ef          	jal	ra,ffffffffc020199c <slob_alloc.constprop.0>
ffffffffc0201ace:	84aa                	mv	s1,a0
ffffffffc0201ad0:	c929                	beqz	a0,ffffffffc0201b22 <kmalloc+0x70>
ffffffffc0201ad2:	0004079b          	sext.w	a5,s0
ffffffffc0201ad6:	4501                	li	a0,0
ffffffffc0201ad8:	00f95763          	bge	s2,a5,ffffffffc0201ae6 <kmalloc+0x34>
ffffffffc0201adc:	6705                	lui	a4,0x1
ffffffffc0201ade:	8785                	srai	a5,a5,0x1
ffffffffc0201ae0:	2505                	addiw	a0,a0,1
ffffffffc0201ae2:	fef74ee3          	blt	a4,a5,ffffffffc0201ade <kmalloc+0x2c>
ffffffffc0201ae6:	c088                	sw	a0,0(s1)
ffffffffc0201ae8:	e51ff0ef          	jal	ra,ffffffffc0201938 <__slob_get_free_pages.constprop.0>
ffffffffc0201aec:	e488                	sd	a0,8(s1)
ffffffffc0201aee:	842a                	mv	s0,a0
ffffffffc0201af0:	c525                	beqz	a0,ffffffffc0201b58 <kmalloc+0xa6>
ffffffffc0201af2:	100027f3          	csrr	a5,sstatus
ffffffffc0201af6:	8b89                	andi	a5,a5,2
ffffffffc0201af8:	ef8d                	bnez	a5,ffffffffc0201b32 <kmalloc+0x80>
ffffffffc0201afa:	0000c797          	auipc	a5,0xc
ffffffffc0201afe:	99e78793          	addi	a5,a5,-1634 # ffffffffc020d498 <bigblocks>
ffffffffc0201b02:	6398                	ld	a4,0(a5)
ffffffffc0201b04:	e384                	sd	s1,0(a5)
ffffffffc0201b06:	e898                	sd	a4,16(s1)
ffffffffc0201b08:	60e2                	ld	ra,24(sp)
ffffffffc0201b0a:	8522                	mv	a0,s0
ffffffffc0201b0c:	6442                	ld	s0,16(sp)
ffffffffc0201b0e:	64a2                	ld	s1,8(sp)
ffffffffc0201b10:	6902                	ld	s2,0(sp)
ffffffffc0201b12:	6105                	addi	sp,sp,32
ffffffffc0201b14:	8082                	ret
ffffffffc0201b16:	0541                	addi	a0,a0,16
ffffffffc0201b18:	e85ff0ef          	jal	ra,ffffffffc020199c <slob_alloc.constprop.0>
ffffffffc0201b1c:	01050413          	addi	s0,a0,16
ffffffffc0201b20:	f565                	bnez	a0,ffffffffc0201b08 <kmalloc+0x56>
ffffffffc0201b22:	4401                	li	s0,0
ffffffffc0201b24:	60e2                	ld	ra,24(sp)
ffffffffc0201b26:	8522                	mv	a0,s0
ffffffffc0201b28:	6442                	ld	s0,16(sp)
ffffffffc0201b2a:	64a2                	ld	s1,8(sp)
ffffffffc0201b2c:	6902                	ld	s2,0(sp)
ffffffffc0201b2e:	6105                	addi	sp,sp,32
ffffffffc0201b30:	8082                	ret
ffffffffc0201b32:	dfffe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
ffffffffc0201b36:	0000c797          	auipc	a5,0xc
ffffffffc0201b3a:	96278793          	addi	a5,a5,-1694 # ffffffffc020d498 <bigblocks>
ffffffffc0201b3e:	6398                	ld	a4,0(a5)
ffffffffc0201b40:	e384                	sd	s1,0(a5)
ffffffffc0201b42:	e898                	sd	a4,16(s1)
ffffffffc0201b44:	de7fe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc0201b48:	6480                	ld	s0,8(s1)
ffffffffc0201b4a:	60e2                	ld	ra,24(sp)
ffffffffc0201b4c:	64a2                	ld	s1,8(sp)
ffffffffc0201b4e:	8522                	mv	a0,s0
ffffffffc0201b50:	6442                	ld	s0,16(sp)
ffffffffc0201b52:	6902                	ld	s2,0(sp)
ffffffffc0201b54:	6105                	addi	sp,sp,32
ffffffffc0201b56:	8082                	ret
ffffffffc0201b58:	45e1                	li	a1,24
ffffffffc0201b5a:	8526                	mv	a0,s1
ffffffffc0201b5c:	d29ff0ef          	jal	ra,ffffffffc0201884 <slob_free>
ffffffffc0201b60:	b765                	j	ffffffffc0201b08 <kmalloc+0x56>

ffffffffc0201b62 <kfree>:
ffffffffc0201b62:	c169                	beqz	a0,ffffffffc0201c24 <kfree+0xc2>
ffffffffc0201b64:	1101                	addi	sp,sp,-32
ffffffffc0201b66:	e822                	sd	s0,16(sp)
ffffffffc0201b68:	ec06                	sd	ra,24(sp)
ffffffffc0201b6a:	e426                	sd	s1,8(sp)
ffffffffc0201b6c:	03451793          	slli	a5,a0,0x34
ffffffffc0201b70:	842a                	mv	s0,a0
ffffffffc0201b72:	e3d9                	bnez	a5,ffffffffc0201bf8 <kfree+0x96>
ffffffffc0201b74:	100027f3          	csrr	a5,sstatus
ffffffffc0201b78:	8b89                	andi	a5,a5,2
ffffffffc0201b7a:	e7d9                	bnez	a5,ffffffffc0201c08 <kfree+0xa6>
ffffffffc0201b7c:	0000c797          	auipc	a5,0xc
ffffffffc0201b80:	91c7b783          	ld	a5,-1764(a5) # ffffffffc020d498 <bigblocks>
ffffffffc0201b84:	4601                	li	a2,0
ffffffffc0201b86:	cbad                	beqz	a5,ffffffffc0201bf8 <kfree+0x96>
ffffffffc0201b88:	0000c697          	auipc	a3,0xc
ffffffffc0201b8c:	91068693          	addi	a3,a3,-1776 # ffffffffc020d498 <bigblocks>
ffffffffc0201b90:	a021                	j	ffffffffc0201b98 <kfree+0x36>
ffffffffc0201b92:	01048693          	addi	a3,s1,16
ffffffffc0201b96:	c3a5                	beqz	a5,ffffffffc0201bf6 <kfree+0x94>
ffffffffc0201b98:	6798                	ld	a4,8(a5)
ffffffffc0201b9a:	84be                	mv	s1,a5
ffffffffc0201b9c:	6b9c                	ld	a5,16(a5)
ffffffffc0201b9e:	fe871ae3          	bne	a4,s0,ffffffffc0201b92 <kfree+0x30>
ffffffffc0201ba2:	e29c                	sd	a5,0(a3)
ffffffffc0201ba4:	ee2d                	bnez	a2,ffffffffc0201c1e <kfree+0xbc>
ffffffffc0201ba6:	c02007b7          	lui	a5,0xc0200
ffffffffc0201baa:	4098                	lw	a4,0(s1)
ffffffffc0201bac:	08f46963          	bltu	s0,a5,ffffffffc0201c3e <kfree+0xdc>
ffffffffc0201bb0:	0000c697          	auipc	a3,0xc
ffffffffc0201bb4:	9186b683          	ld	a3,-1768(a3) # ffffffffc020d4c8 <va_pa_offset>
ffffffffc0201bb8:	8c15                	sub	s0,s0,a3
ffffffffc0201bba:	8031                	srli	s0,s0,0xc
ffffffffc0201bbc:	0000c797          	auipc	a5,0xc
ffffffffc0201bc0:	8f47b783          	ld	a5,-1804(a5) # ffffffffc020d4b0 <npage>
ffffffffc0201bc4:	06f47163          	bgeu	s0,a5,ffffffffc0201c26 <kfree+0xc4>
ffffffffc0201bc8:	00004517          	auipc	a0,0x4
ffffffffc0201bcc:	e1853503          	ld	a0,-488(a0) # ffffffffc02059e0 <nbase>
ffffffffc0201bd0:	8c09                	sub	s0,s0,a0
ffffffffc0201bd2:	041a                	slli	s0,s0,0x6
ffffffffc0201bd4:	0000c517          	auipc	a0,0xc
ffffffffc0201bd8:	8e453503          	ld	a0,-1820(a0) # ffffffffc020d4b8 <pages>
ffffffffc0201bdc:	4585                	li	a1,1
ffffffffc0201bde:	9522                	add	a0,a0,s0
ffffffffc0201be0:	00e595bb          	sllw	a1,a1,a4
ffffffffc0201be4:	0ea000ef          	jal	ra,ffffffffc0201cce <free_pages>
ffffffffc0201be8:	6442                	ld	s0,16(sp)
ffffffffc0201bea:	60e2                	ld	ra,24(sp)
ffffffffc0201bec:	8526                	mv	a0,s1
ffffffffc0201bee:	64a2                	ld	s1,8(sp)
ffffffffc0201bf0:	45e1                	li	a1,24
ffffffffc0201bf2:	6105                	addi	sp,sp,32
ffffffffc0201bf4:	b941                	j	ffffffffc0201884 <slob_free>
ffffffffc0201bf6:	e20d                	bnez	a2,ffffffffc0201c18 <kfree+0xb6>
ffffffffc0201bf8:	ff040513          	addi	a0,s0,-16
ffffffffc0201bfc:	6442                	ld	s0,16(sp)
ffffffffc0201bfe:	60e2                	ld	ra,24(sp)
ffffffffc0201c00:	64a2                	ld	s1,8(sp)
ffffffffc0201c02:	4581                	li	a1,0
ffffffffc0201c04:	6105                	addi	sp,sp,32
ffffffffc0201c06:	b9bd                	j	ffffffffc0201884 <slob_free>
ffffffffc0201c08:	d29fe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
ffffffffc0201c0c:	0000c797          	auipc	a5,0xc
ffffffffc0201c10:	88c7b783          	ld	a5,-1908(a5) # ffffffffc020d498 <bigblocks>
ffffffffc0201c14:	4605                	li	a2,1
ffffffffc0201c16:	fbad                	bnez	a5,ffffffffc0201b88 <kfree+0x26>
ffffffffc0201c18:	d13fe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc0201c1c:	bff1                	j	ffffffffc0201bf8 <kfree+0x96>
ffffffffc0201c1e:	d0dfe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc0201c22:	b751                	j	ffffffffc0201ba6 <kfree+0x44>
ffffffffc0201c24:	8082                	ret
ffffffffc0201c26:	00003617          	auipc	a2,0x3
ffffffffc0201c2a:	1aa60613          	addi	a2,a2,426 # ffffffffc0204dd0 <default_pmm_manager+0x108>
ffffffffc0201c2e:	06900593          	li	a1,105
ffffffffc0201c32:	00003517          	auipc	a0,0x3
ffffffffc0201c36:	0f650513          	addi	a0,a0,246 # ffffffffc0204d28 <default_pmm_manager+0x60>
ffffffffc0201c3a:	821fe0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0201c3e:	86a2                	mv	a3,s0
ffffffffc0201c40:	00003617          	auipc	a2,0x3
ffffffffc0201c44:	16860613          	addi	a2,a2,360 # ffffffffc0204da8 <default_pmm_manager+0xe0>
ffffffffc0201c48:	07700593          	li	a1,119
ffffffffc0201c4c:	00003517          	auipc	a0,0x3
ffffffffc0201c50:	0dc50513          	addi	a0,a0,220 # ffffffffc0204d28 <default_pmm_manager+0x60>
ffffffffc0201c54:	807fe0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc0201c58 <pa2page.part.0>:
ffffffffc0201c58:	1141                	addi	sp,sp,-16
ffffffffc0201c5a:	00003617          	auipc	a2,0x3
ffffffffc0201c5e:	17660613          	addi	a2,a2,374 # ffffffffc0204dd0 <default_pmm_manager+0x108>
ffffffffc0201c62:	06900593          	li	a1,105
ffffffffc0201c66:	00003517          	auipc	a0,0x3
ffffffffc0201c6a:	0c250513          	addi	a0,a0,194 # ffffffffc0204d28 <default_pmm_manager+0x60>
ffffffffc0201c6e:	e406                	sd	ra,8(sp)
ffffffffc0201c70:	feafe0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc0201c74 <pte2page.part.0>:
ffffffffc0201c74:	1141                	addi	sp,sp,-16
ffffffffc0201c76:	00003617          	auipc	a2,0x3
ffffffffc0201c7a:	17a60613          	addi	a2,a2,378 # ffffffffc0204df0 <default_pmm_manager+0x128>
ffffffffc0201c7e:	07f00593          	li	a1,127
ffffffffc0201c82:	00003517          	auipc	a0,0x3
ffffffffc0201c86:	0a650513          	addi	a0,a0,166 # ffffffffc0204d28 <default_pmm_manager+0x60>
ffffffffc0201c8a:	e406                	sd	ra,8(sp)
ffffffffc0201c8c:	fcefe0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc0201c90 <alloc_pages>:
ffffffffc0201c90:	100027f3          	csrr	a5,sstatus
ffffffffc0201c94:	8b89                	andi	a5,a5,2
ffffffffc0201c96:	e799                	bnez	a5,ffffffffc0201ca4 <alloc_pages+0x14>
ffffffffc0201c98:	0000c797          	auipc	a5,0xc
ffffffffc0201c9c:	8287b783          	ld	a5,-2008(a5) # ffffffffc020d4c0 <pmm_manager>
ffffffffc0201ca0:	6f9c                	ld	a5,24(a5)
ffffffffc0201ca2:	8782                	jr	a5
ffffffffc0201ca4:	1141                	addi	sp,sp,-16
ffffffffc0201ca6:	e406                	sd	ra,8(sp)
ffffffffc0201ca8:	e022                	sd	s0,0(sp)
ffffffffc0201caa:	842a                	mv	s0,a0
ffffffffc0201cac:	c85fe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
ffffffffc0201cb0:	0000c797          	auipc	a5,0xc
ffffffffc0201cb4:	8107b783          	ld	a5,-2032(a5) # ffffffffc020d4c0 <pmm_manager>
ffffffffc0201cb8:	6f9c                	ld	a5,24(a5)
ffffffffc0201cba:	8522                	mv	a0,s0
ffffffffc0201cbc:	9782                	jalr	a5
ffffffffc0201cbe:	842a                	mv	s0,a0
ffffffffc0201cc0:	c6bfe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc0201cc4:	60a2                	ld	ra,8(sp)
ffffffffc0201cc6:	8522                	mv	a0,s0
ffffffffc0201cc8:	6402                	ld	s0,0(sp)
ffffffffc0201cca:	0141                	addi	sp,sp,16
ffffffffc0201ccc:	8082                	ret

ffffffffc0201cce <free_pages>:
ffffffffc0201cce:	100027f3          	csrr	a5,sstatus
ffffffffc0201cd2:	8b89                	andi	a5,a5,2
ffffffffc0201cd4:	e799                	bnez	a5,ffffffffc0201ce2 <free_pages+0x14>
ffffffffc0201cd6:	0000b797          	auipc	a5,0xb
ffffffffc0201cda:	7ea7b783          	ld	a5,2026(a5) # ffffffffc020d4c0 <pmm_manager>
ffffffffc0201cde:	739c                	ld	a5,32(a5)
ffffffffc0201ce0:	8782                	jr	a5
ffffffffc0201ce2:	1101                	addi	sp,sp,-32
ffffffffc0201ce4:	ec06                	sd	ra,24(sp)
ffffffffc0201ce6:	e822                	sd	s0,16(sp)
ffffffffc0201ce8:	e426                	sd	s1,8(sp)
ffffffffc0201cea:	842a                	mv	s0,a0
ffffffffc0201cec:	84ae                	mv	s1,a1
ffffffffc0201cee:	c43fe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
ffffffffc0201cf2:	0000b797          	auipc	a5,0xb
ffffffffc0201cf6:	7ce7b783          	ld	a5,1998(a5) # ffffffffc020d4c0 <pmm_manager>
ffffffffc0201cfa:	739c                	ld	a5,32(a5)
ffffffffc0201cfc:	85a6                	mv	a1,s1
ffffffffc0201cfe:	8522                	mv	a0,s0
ffffffffc0201d00:	9782                	jalr	a5
ffffffffc0201d02:	6442                	ld	s0,16(sp)
ffffffffc0201d04:	60e2                	ld	ra,24(sp)
ffffffffc0201d06:	64a2                	ld	s1,8(sp)
ffffffffc0201d08:	6105                	addi	sp,sp,32
ffffffffc0201d0a:	c21fe06f          	j	ffffffffc020092a <intr_enable>

ffffffffc0201d0e <nr_free_pages>:
ffffffffc0201d0e:	100027f3          	csrr	a5,sstatus
ffffffffc0201d12:	8b89                	andi	a5,a5,2
ffffffffc0201d14:	e799                	bnez	a5,ffffffffc0201d22 <nr_free_pages+0x14>
ffffffffc0201d16:	0000b797          	auipc	a5,0xb
ffffffffc0201d1a:	7aa7b783          	ld	a5,1962(a5) # ffffffffc020d4c0 <pmm_manager>
ffffffffc0201d1e:	779c                	ld	a5,40(a5)
ffffffffc0201d20:	8782                	jr	a5
ffffffffc0201d22:	1141                	addi	sp,sp,-16
ffffffffc0201d24:	e406                	sd	ra,8(sp)
ffffffffc0201d26:	e022                	sd	s0,0(sp)
ffffffffc0201d28:	c09fe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
ffffffffc0201d2c:	0000b797          	auipc	a5,0xb
ffffffffc0201d30:	7947b783          	ld	a5,1940(a5) # ffffffffc020d4c0 <pmm_manager>
ffffffffc0201d34:	779c                	ld	a5,40(a5)
ffffffffc0201d36:	9782                	jalr	a5
ffffffffc0201d38:	842a                	mv	s0,a0
ffffffffc0201d3a:	bf1fe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc0201d3e:	60a2                	ld	ra,8(sp)
ffffffffc0201d40:	8522                	mv	a0,s0
ffffffffc0201d42:	6402                	ld	s0,0(sp)
ffffffffc0201d44:	0141                	addi	sp,sp,16
ffffffffc0201d46:	8082                	ret

ffffffffc0201d48 <get_pte>:
ffffffffc0201d48:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0201d4c:	1ff7f793          	andi	a5,a5,511
ffffffffc0201d50:	7139                	addi	sp,sp,-64
ffffffffc0201d52:	078e                	slli	a5,a5,0x3
ffffffffc0201d54:	f426                	sd	s1,40(sp)
ffffffffc0201d56:	00f504b3          	add	s1,a0,a5
ffffffffc0201d5a:	6094                	ld	a3,0(s1)
ffffffffc0201d5c:	f04a                	sd	s2,32(sp)
ffffffffc0201d5e:	ec4e                	sd	s3,24(sp)
ffffffffc0201d60:	e852                	sd	s4,16(sp)
ffffffffc0201d62:	fc06                	sd	ra,56(sp)
ffffffffc0201d64:	f822                	sd	s0,48(sp)
ffffffffc0201d66:	e456                	sd	s5,8(sp)
ffffffffc0201d68:	e05a                	sd	s6,0(sp)
ffffffffc0201d6a:	0016f793          	andi	a5,a3,1
ffffffffc0201d6e:	892e                	mv	s2,a1
ffffffffc0201d70:	8a32                	mv	s4,a2
ffffffffc0201d72:	0000b997          	auipc	s3,0xb
ffffffffc0201d76:	73e98993          	addi	s3,s3,1854 # ffffffffc020d4b0 <npage>
ffffffffc0201d7a:	efbd                	bnez	a5,ffffffffc0201df8 <get_pte+0xb0>
ffffffffc0201d7c:	14060c63          	beqz	a2,ffffffffc0201ed4 <get_pte+0x18c>
ffffffffc0201d80:	100027f3          	csrr	a5,sstatus
ffffffffc0201d84:	8b89                	andi	a5,a5,2
ffffffffc0201d86:	14079963          	bnez	a5,ffffffffc0201ed8 <get_pte+0x190>
ffffffffc0201d8a:	0000b797          	auipc	a5,0xb
ffffffffc0201d8e:	7367b783          	ld	a5,1846(a5) # ffffffffc020d4c0 <pmm_manager>
ffffffffc0201d92:	6f9c                	ld	a5,24(a5)
ffffffffc0201d94:	4505                	li	a0,1
ffffffffc0201d96:	9782                	jalr	a5
ffffffffc0201d98:	842a                	mv	s0,a0
ffffffffc0201d9a:	12040d63          	beqz	s0,ffffffffc0201ed4 <get_pte+0x18c>
ffffffffc0201d9e:	0000bb17          	auipc	s6,0xb
ffffffffc0201da2:	71ab0b13          	addi	s6,s6,1818 # ffffffffc020d4b8 <pages>
ffffffffc0201da6:	000b3503          	ld	a0,0(s6)
ffffffffc0201daa:	00080ab7          	lui	s5,0x80
ffffffffc0201dae:	0000b997          	auipc	s3,0xb
ffffffffc0201db2:	70298993          	addi	s3,s3,1794 # ffffffffc020d4b0 <npage>
ffffffffc0201db6:	40a40533          	sub	a0,s0,a0
ffffffffc0201dba:	8519                	srai	a0,a0,0x6
ffffffffc0201dbc:	9556                	add	a0,a0,s5
ffffffffc0201dbe:	0009b703          	ld	a4,0(s3)
ffffffffc0201dc2:	00c51793          	slli	a5,a0,0xc
ffffffffc0201dc6:	4685                	li	a3,1
ffffffffc0201dc8:	c014                	sw	a3,0(s0)
ffffffffc0201dca:	83b1                	srli	a5,a5,0xc
ffffffffc0201dcc:	0532                	slli	a0,a0,0xc
ffffffffc0201dce:	16e7f763          	bgeu	a5,a4,ffffffffc0201f3c <get_pte+0x1f4>
ffffffffc0201dd2:	0000b797          	auipc	a5,0xb
ffffffffc0201dd6:	6f67b783          	ld	a5,1782(a5) # ffffffffc020d4c8 <va_pa_offset>
ffffffffc0201dda:	6605                	lui	a2,0x1
ffffffffc0201ddc:	4581                	li	a1,0
ffffffffc0201dde:	953e                	add	a0,a0,a5
ffffffffc0201de0:	06a020ef          	jal	ra,ffffffffc0203e4a <memset>
ffffffffc0201de4:	000b3683          	ld	a3,0(s6)
ffffffffc0201de8:	40d406b3          	sub	a3,s0,a3
ffffffffc0201dec:	8699                	srai	a3,a3,0x6
ffffffffc0201dee:	96d6                	add	a3,a3,s5
ffffffffc0201df0:	06aa                	slli	a3,a3,0xa
ffffffffc0201df2:	0116e693          	ori	a3,a3,17
ffffffffc0201df6:	e094                	sd	a3,0(s1)
ffffffffc0201df8:	77fd                	lui	a5,0xfffff
ffffffffc0201dfa:	068a                	slli	a3,a3,0x2
ffffffffc0201dfc:	0009b703          	ld	a4,0(s3)
ffffffffc0201e00:	8efd                	and	a3,a3,a5
ffffffffc0201e02:	00c6d793          	srli	a5,a3,0xc
ffffffffc0201e06:	10e7ff63          	bgeu	a5,a4,ffffffffc0201f24 <get_pte+0x1dc>
ffffffffc0201e0a:	0000ba97          	auipc	s5,0xb
ffffffffc0201e0e:	6bea8a93          	addi	s5,s5,1726 # ffffffffc020d4c8 <va_pa_offset>
ffffffffc0201e12:	000ab403          	ld	s0,0(s5)
ffffffffc0201e16:	01595793          	srli	a5,s2,0x15
ffffffffc0201e1a:	1ff7f793          	andi	a5,a5,511
ffffffffc0201e1e:	96a2                	add	a3,a3,s0
ffffffffc0201e20:	00379413          	slli	s0,a5,0x3
ffffffffc0201e24:	9436                	add	s0,s0,a3
ffffffffc0201e26:	6014                	ld	a3,0(s0)
ffffffffc0201e28:	0016f793          	andi	a5,a3,1
ffffffffc0201e2c:	ebad                	bnez	a5,ffffffffc0201e9e <get_pte+0x156>
ffffffffc0201e2e:	0a0a0363          	beqz	s4,ffffffffc0201ed4 <get_pte+0x18c>
ffffffffc0201e32:	100027f3          	csrr	a5,sstatus
ffffffffc0201e36:	8b89                	andi	a5,a5,2
ffffffffc0201e38:	efcd                	bnez	a5,ffffffffc0201ef2 <get_pte+0x1aa>
ffffffffc0201e3a:	0000b797          	auipc	a5,0xb
ffffffffc0201e3e:	6867b783          	ld	a5,1670(a5) # ffffffffc020d4c0 <pmm_manager>
ffffffffc0201e42:	6f9c                	ld	a5,24(a5)
ffffffffc0201e44:	4505                	li	a0,1
ffffffffc0201e46:	9782                	jalr	a5
ffffffffc0201e48:	84aa                	mv	s1,a0
ffffffffc0201e4a:	c4c9                	beqz	s1,ffffffffc0201ed4 <get_pte+0x18c>
ffffffffc0201e4c:	0000bb17          	auipc	s6,0xb
ffffffffc0201e50:	66cb0b13          	addi	s6,s6,1644 # ffffffffc020d4b8 <pages>
ffffffffc0201e54:	000b3503          	ld	a0,0(s6)
ffffffffc0201e58:	00080a37          	lui	s4,0x80
ffffffffc0201e5c:	0009b703          	ld	a4,0(s3)
ffffffffc0201e60:	40a48533          	sub	a0,s1,a0
ffffffffc0201e64:	8519                	srai	a0,a0,0x6
ffffffffc0201e66:	9552                	add	a0,a0,s4
ffffffffc0201e68:	00c51793          	slli	a5,a0,0xc
ffffffffc0201e6c:	4685                	li	a3,1
ffffffffc0201e6e:	c094                	sw	a3,0(s1)
ffffffffc0201e70:	83b1                	srli	a5,a5,0xc
ffffffffc0201e72:	0532                	slli	a0,a0,0xc
ffffffffc0201e74:	0ee7f163          	bgeu	a5,a4,ffffffffc0201f56 <get_pte+0x20e>
ffffffffc0201e78:	000ab783          	ld	a5,0(s5)
ffffffffc0201e7c:	6605                	lui	a2,0x1
ffffffffc0201e7e:	4581                	li	a1,0
ffffffffc0201e80:	953e                	add	a0,a0,a5
ffffffffc0201e82:	7c9010ef          	jal	ra,ffffffffc0203e4a <memset>
ffffffffc0201e86:	000b3683          	ld	a3,0(s6)
ffffffffc0201e8a:	40d486b3          	sub	a3,s1,a3
ffffffffc0201e8e:	8699                	srai	a3,a3,0x6
ffffffffc0201e90:	96d2                	add	a3,a3,s4
ffffffffc0201e92:	06aa                	slli	a3,a3,0xa
ffffffffc0201e94:	0116e693          	ori	a3,a3,17
ffffffffc0201e98:	e014                	sd	a3,0(s0)
ffffffffc0201e9a:	0009b703          	ld	a4,0(s3)
ffffffffc0201e9e:	068a                	slli	a3,a3,0x2
ffffffffc0201ea0:	757d                	lui	a0,0xfffff
ffffffffc0201ea2:	8ee9                	and	a3,a3,a0
ffffffffc0201ea4:	00c6d793          	srli	a5,a3,0xc
ffffffffc0201ea8:	06e7f263          	bgeu	a5,a4,ffffffffc0201f0c <get_pte+0x1c4>
ffffffffc0201eac:	000ab503          	ld	a0,0(s5)
ffffffffc0201eb0:	00c95913          	srli	s2,s2,0xc
ffffffffc0201eb4:	1ff97913          	andi	s2,s2,511
ffffffffc0201eb8:	96aa                	add	a3,a3,a0
ffffffffc0201eba:	00391513          	slli	a0,s2,0x3
ffffffffc0201ebe:	9536                	add	a0,a0,a3
ffffffffc0201ec0:	70e2                	ld	ra,56(sp)
ffffffffc0201ec2:	7442                	ld	s0,48(sp)
ffffffffc0201ec4:	74a2                	ld	s1,40(sp)
ffffffffc0201ec6:	7902                	ld	s2,32(sp)
ffffffffc0201ec8:	69e2                	ld	s3,24(sp)
ffffffffc0201eca:	6a42                	ld	s4,16(sp)
ffffffffc0201ecc:	6aa2                	ld	s5,8(sp)
ffffffffc0201ece:	6b02                	ld	s6,0(sp)
ffffffffc0201ed0:	6121                	addi	sp,sp,64
ffffffffc0201ed2:	8082                	ret
ffffffffc0201ed4:	4501                	li	a0,0
ffffffffc0201ed6:	b7ed                	j	ffffffffc0201ec0 <get_pte+0x178>
ffffffffc0201ed8:	a59fe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
ffffffffc0201edc:	0000b797          	auipc	a5,0xb
ffffffffc0201ee0:	5e47b783          	ld	a5,1508(a5) # ffffffffc020d4c0 <pmm_manager>
ffffffffc0201ee4:	6f9c                	ld	a5,24(a5)
ffffffffc0201ee6:	4505                	li	a0,1
ffffffffc0201ee8:	9782                	jalr	a5
ffffffffc0201eea:	842a                	mv	s0,a0
ffffffffc0201eec:	a3ffe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc0201ef0:	b56d                	j	ffffffffc0201d9a <get_pte+0x52>
ffffffffc0201ef2:	a3ffe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
ffffffffc0201ef6:	0000b797          	auipc	a5,0xb
ffffffffc0201efa:	5ca7b783          	ld	a5,1482(a5) # ffffffffc020d4c0 <pmm_manager>
ffffffffc0201efe:	6f9c                	ld	a5,24(a5)
ffffffffc0201f00:	4505                	li	a0,1
ffffffffc0201f02:	9782                	jalr	a5
ffffffffc0201f04:	84aa                	mv	s1,a0
ffffffffc0201f06:	a25fe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc0201f0a:	b781                	j	ffffffffc0201e4a <get_pte+0x102>
ffffffffc0201f0c:	00003617          	auipc	a2,0x3
ffffffffc0201f10:	df460613          	addi	a2,a2,-524 # ffffffffc0204d00 <default_pmm_manager+0x38>
ffffffffc0201f14:	0fb00593          	li	a1,251
ffffffffc0201f18:	00003517          	auipc	a0,0x3
ffffffffc0201f1c:	f0050513          	addi	a0,a0,-256 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0201f20:	d3afe0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0201f24:	00003617          	auipc	a2,0x3
ffffffffc0201f28:	ddc60613          	addi	a2,a2,-548 # ffffffffc0204d00 <default_pmm_manager+0x38>
ffffffffc0201f2c:	0ee00593          	li	a1,238
ffffffffc0201f30:	00003517          	auipc	a0,0x3
ffffffffc0201f34:	ee850513          	addi	a0,a0,-280 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0201f38:	d22fe0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0201f3c:	86aa                	mv	a3,a0
ffffffffc0201f3e:	00003617          	auipc	a2,0x3
ffffffffc0201f42:	dc260613          	addi	a2,a2,-574 # ffffffffc0204d00 <default_pmm_manager+0x38>
ffffffffc0201f46:	0eb00593          	li	a1,235
ffffffffc0201f4a:	00003517          	auipc	a0,0x3
ffffffffc0201f4e:	ece50513          	addi	a0,a0,-306 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0201f52:	d08fe0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0201f56:	86aa                	mv	a3,a0
ffffffffc0201f58:	00003617          	auipc	a2,0x3
ffffffffc0201f5c:	da860613          	addi	a2,a2,-600 # ffffffffc0204d00 <default_pmm_manager+0x38>
ffffffffc0201f60:	0f800593          	li	a1,248
ffffffffc0201f64:	00003517          	auipc	a0,0x3
ffffffffc0201f68:	eb450513          	addi	a0,a0,-332 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0201f6c:	ceefe0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc0201f70 <get_page>:
ffffffffc0201f70:	1141                	addi	sp,sp,-16
ffffffffc0201f72:	e022                	sd	s0,0(sp)
ffffffffc0201f74:	8432                	mv	s0,a2
ffffffffc0201f76:	4601                	li	a2,0
ffffffffc0201f78:	e406                	sd	ra,8(sp)
ffffffffc0201f7a:	dcfff0ef          	jal	ra,ffffffffc0201d48 <get_pte>
ffffffffc0201f7e:	c011                	beqz	s0,ffffffffc0201f82 <get_page+0x12>
ffffffffc0201f80:	e008                	sd	a0,0(s0)
ffffffffc0201f82:	c511                	beqz	a0,ffffffffc0201f8e <get_page+0x1e>
ffffffffc0201f84:	611c                	ld	a5,0(a0)
ffffffffc0201f86:	4501                	li	a0,0
ffffffffc0201f88:	0017f713          	andi	a4,a5,1
ffffffffc0201f8c:	e709                	bnez	a4,ffffffffc0201f96 <get_page+0x26>
ffffffffc0201f8e:	60a2                	ld	ra,8(sp)
ffffffffc0201f90:	6402                	ld	s0,0(sp)
ffffffffc0201f92:	0141                	addi	sp,sp,16
ffffffffc0201f94:	8082                	ret
ffffffffc0201f96:	078a                	slli	a5,a5,0x2
ffffffffc0201f98:	83b1                	srli	a5,a5,0xc
ffffffffc0201f9a:	0000b717          	auipc	a4,0xb
ffffffffc0201f9e:	51673703          	ld	a4,1302(a4) # ffffffffc020d4b0 <npage>
ffffffffc0201fa2:	00e7ff63          	bgeu	a5,a4,ffffffffc0201fc0 <get_page+0x50>
ffffffffc0201fa6:	60a2                	ld	ra,8(sp)
ffffffffc0201fa8:	6402                	ld	s0,0(sp)
ffffffffc0201faa:	fff80537          	lui	a0,0xfff80
ffffffffc0201fae:	97aa                	add	a5,a5,a0
ffffffffc0201fb0:	079a                	slli	a5,a5,0x6
ffffffffc0201fb2:	0000b517          	auipc	a0,0xb
ffffffffc0201fb6:	50653503          	ld	a0,1286(a0) # ffffffffc020d4b8 <pages>
ffffffffc0201fba:	953e                	add	a0,a0,a5
ffffffffc0201fbc:	0141                	addi	sp,sp,16
ffffffffc0201fbe:	8082                	ret
ffffffffc0201fc0:	c99ff0ef          	jal	ra,ffffffffc0201c58 <pa2page.part.0>

ffffffffc0201fc4 <page_remove>:
ffffffffc0201fc4:	7179                	addi	sp,sp,-48
ffffffffc0201fc6:	4601                	li	a2,0
ffffffffc0201fc8:	ec26                	sd	s1,24(sp)
ffffffffc0201fca:	f406                	sd	ra,40(sp)
ffffffffc0201fcc:	f022                	sd	s0,32(sp)
ffffffffc0201fce:	84ae                	mv	s1,a1
ffffffffc0201fd0:	d79ff0ef          	jal	ra,ffffffffc0201d48 <get_pte>
ffffffffc0201fd4:	c511                	beqz	a0,ffffffffc0201fe0 <page_remove+0x1c>
ffffffffc0201fd6:	611c                	ld	a5,0(a0)
ffffffffc0201fd8:	842a                	mv	s0,a0
ffffffffc0201fda:	0017f713          	andi	a4,a5,1
ffffffffc0201fde:	e711                	bnez	a4,ffffffffc0201fea <page_remove+0x26>
ffffffffc0201fe0:	70a2                	ld	ra,40(sp)
ffffffffc0201fe2:	7402                	ld	s0,32(sp)
ffffffffc0201fe4:	64e2                	ld	s1,24(sp)
ffffffffc0201fe6:	6145                	addi	sp,sp,48
ffffffffc0201fe8:	8082                	ret
ffffffffc0201fea:	078a                	slli	a5,a5,0x2
ffffffffc0201fec:	83b1                	srli	a5,a5,0xc
ffffffffc0201fee:	0000b717          	auipc	a4,0xb
ffffffffc0201ff2:	4c273703          	ld	a4,1218(a4) # ffffffffc020d4b0 <npage>
ffffffffc0201ff6:	06e7f363          	bgeu	a5,a4,ffffffffc020205c <page_remove+0x98>
ffffffffc0201ffa:	fff80537          	lui	a0,0xfff80
ffffffffc0201ffe:	97aa                	add	a5,a5,a0
ffffffffc0202000:	079a                	slli	a5,a5,0x6
ffffffffc0202002:	0000b517          	auipc	a0,0xb
ffffffffc0202006:	4b653503          	ld	a0,1206(a0) # ffffffffc020d4b8 <pages>
ffffffffc020200a:	953e                	add	a0,a0,a5
ffffffffc020200c:	411c                	lw	a5,0(a0)
ffffffffc020200e:	fff7871b          	addiw	a4,a5,-1
ffffffffc0202012:	c118                	sw	a4,0(a0)
ffffffffc0202014:	cb11                	beqz	a4,ffffffffc0202028 <page_remove+0x64>
ffffffffc0202016:	00043023          	sd	zero,0(s0)
ffffffffc020201a:	12048073          	sfence.vma	s1
ffffffffc020201e:	70a2                	ld	ra,40(sp)
ffffffffc0202020:	7402                	ld	s0,32(sp)
ffffffffc0202022:	64e2                	ld	s1,24(sp)
ffffffffc0202024:	6145                	addi	sp,sp,48
ffffffffc0202026:	8082                	ret
ffffffffc0202028:	100027f3          	csrr	a5,sstatus
ffffffffc020202c:	8b89                	andi	a5,a5,2
ffffffffc020202e:	eb89                	bnez	a5,ffffffffc0202040 <page_remove+0x7c>
ffffffffc0202030:	0000b797          	auipc	a5,0xb
ffffffffc0202034:	4907b783          	ld	a5,1168(a5) # ffffffffc020d4c0 <pmm_manager>
ffffffffc0202038:	739c                	ld	a5,32(a5)
ffffffffc020203a:	4585                	li	a1,1
ffffffffc020203c:	9782                	jalr	a5
ffffffffc020203e:	bfe1                	j	ffffffffc0202016 <page_remove+0x52>
ffffffffc0202040:	e42a                	sd	a0,8(sp)
ffffffffc0202042:	8effe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
ffffffffc0202046:	0000b797          	auipc	a5,0xb
ffffffffc020204a:	47a7b783          	ld	a5,1146(a5) # ffffffffc020d4c0 <pmm_manager>
ffffffffc020204e:	739c                	ld	a5,32(a5)
ffffffffc0202050:	6522                	ld	a0,8(sp)
ffffffffc0202052:	4585                	li	a1,1
ffffffffc0202054:	9782                	jalr	a5
ffffffffc0202056:	8d5fe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc020205a:	bf75                	j	ffffffffc0202016 <page_remove+0x52>
ffffffffc020205c:	bfdff0ef          	jal	ra,ffffffffc0201c58 <pa2page.part.0>

ffffffffc0202060 <page_insert>:
ffffffffc0202060:	7139                	addi	sp,sp,-64
ffffffffc0202062:	e852                	sd	s4,16(sp)
ffffffffc0202064:	8a32                	mv	s4,a2
ffffffffc0202066:	f822                	sd	s0,48(sp)
ffffffffc0202068:	4605                	li	a2,1
ffffffffc020206a:	842e                	mv	s0,a1
ffffffffc020206c:	85d2                	mv	a1,s4
ffffffffc020206e:	f426                	sd	s1,40(sp)
ffffffffc0202070:	fc06                	sd	ra,56(sp)
ffffffffc0202072:	f04a                	sd	s2,32(sp)
ffffffffc0202074:	ec4e                	sd	s3,24(sp)
ffffffffc0202076:	e456                	sd	s5,8(sp)
ffffffffc0202078:	84b6                	mv	s1,a3
ffffffffc020207a:	ccfff0ef          	jal	ra,ffffffffc0201d48 <get_pte>
ffffffffc020207e:	c961                	beqz	a0,ffffffffc020214e <page_insert+0xee>
ffffffffc0202080:	4014                	lw	a3,0(s0)
ffffffffc0202082:	611c                	ld	a5,0(a0)
ffffffffc0202084:	89aa                	mv	s3,a0
ffffffffc0202086:	0016871b          	addiw	a4,a3,1
ffffffffc020208a:	c018                	sw	a4,0(s0)
ffffffffc020208c:	0017f713          	andi	a4,a5,1
ffffffffc0202090:	ef05                	bnez	a4,ffffffffc02020c8 <page_insert+0x68>
ffffffffc0202092:	0000b717          	auipc	a4,0xb
ffffffffc0202096:	42673703          	ld	a4,1062(a4) # ffffffffc020d4b8 <pages>
ffffffffc020209a:	8c19                	sub	s0,s0,a4
ffffffffc020209c:	000807b7          	lui	a5,0x80
ffffffffc02020a0:	8419                	srai	s0,s0,0x6
ffffffffc02020a2:	943e                	add	s0,s0,a5
ffffffffc02020a4:	042a                	slli	s0,s0,0xa
ffffffffc02020a6:	8cc1                	or	s1,s1,s0
ffffffffc02020a8:	0014e493          	ori	s1,s1,1
ffffffffc02020ac:	0099b023          	sd	s1,0(s3)
ffffffffc02020b0:	120a0073          	sfence.vma	s4
ffffffffc02020b4:	4501                	li	a0,0
ffffffffc02020b6:	70e2                	ld	ra,56(sp)
ffffffffc02020b8:	7442                	ld	s0,48(sp)
ffffffffc02020ba:	74a2                	ld	s1,40(sp)
ffffffffc02020bc:	7902                	ld	s2,32(sp)
ffffffffc02020be:	69e2                	ld	s3,24(sp)
ffffffffc02020c0:	6a42                	ld	s4,16(sp)
ffffffffc02020c2:	6aa2                	ld	s5,8(sp)
ffffffffc02020c4:	6121                	addi	sp,sp,64
ffffffffc02020c6:	8082                	ret
ffffffffc02020c8:	078a                	slli	a5,a5,0x2
ffffffffc02020ca:	83b1                	srli	a5,a5,0xc
ffffffffc02020cc:	0000b717          	auipc	a4,0xb
ffffffffc02020d0:	3e473703          	ld	a4,996(a4) # ffffffffc020d4b0 <npage>
ffffffffc02020d4:	06e7ff63          	bgeu	a5,a4,ffffffffc0202152 <page_insert+0xf2>
ffffffffc02020d8:	0000ba97          	auipc	s5,0xb
ffffffffc02020dc:	3e0a8a93          	addi	s5,s5,992 # ffffffffc020d4b8 <pages>
ffffffffc02020e0:	000ab703          	ld	a4,0(s5)
ffffffffc02020e4:	fff80937          	lui	s2,0xfff80
ffffffffc02020e8:	993e                	add	s2,s2,a5
ffffffffc02020ea:	091a                	slli	s2,s2,0x6
ffffffffc02020ec:	993a                	add	s2,s2,a4
ffffffffc02020ee:	01240c63          	beq	s0,s2,ffffffffc0202106 <page_insert+0xa6>
ffffffffc02020f2:	00092783          	lw	a5,0(s2) # fffffffffff80000 <end+0x3fd72b14>
ffffffffc02020f6:	fff7869b          	addiw	a3,a5,-1
ffffffffc02020fa:	00d92023          	sw	a3,0(s2)
ffffffffc02020fe:	c691                	beqz	a3,ffffffffc020210a <page_insert+0xaa>
ffffffffc0202100:	120a0073          	sfence.vma	s4
ffffffffc0202104:	bf59                	j	ffffffffc020209a <page_insert+0x3a>
ffffffffc0202106:	c014                	sw	a3,0(s0)
ffffffffc0202108:	bf49                	j	ffffffffc020209a <page_insert+0x3a>
ffffffffc020210a:	100027f3          	csrr	a5,sstatus
ffffffffc020210e:	8b89                	andi	a5,a5,2
ffffffffc0202110:	ef91                	bnez	a5,ffffffffc020212c <page_insert+0xcc>
ffffffffc0202112:	0000b797          	auipc	a5,0xb
ffffffffc0202116:	3ae7b783          	ld	a5,942(a5) # ffffffffc020d4c0 <pmm_manager>
ffffffffc020211a:	739c                	ld	a5,32(a5)
ffffffffc020211c:	4585                	li	a1,1
ffffffffc020211e:	854a                	mv	a0,s2
ffffffffc0202120:	9782                	jalr	a5
ffffffffc0202122:	000ab703          	ld	a4,0(s5)
ffffffffc0202126:	120a0073          	sfence.vma	s4
ffffffffc020212a:	bf85                	j	ffffffffc020209a <page_insert+0x3a>
ffffffffc020212c:	805fe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
ffffffffc0202130:	0000b797          	auipc	a5,0xb
ffffffffc0202134:	3907b783          	ld	a5,912(a5) # ffffffffc020d4c0 <pmm_manager>
ffffffffc0202138:	739c                	ld	a5,32(a5)
ffffffffc020213a:	4585                	li	a1,1
ffffffffc020213c:	854a                	mv	a0,s2
ffffffffc020213e:	9782                	jalr	a5
ffffffffc0202140:	feafe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc0202144:	000ab703          	ld	a4,0(s5)
ffffffffc0202148:	120a0073          	sfence.vma	s4
ffffffffc020214c:	b7b9                	j	ffffffffc020209a <page_insert+0x3a>
ffffffffc020214e:	5571                	li	a0,-4
ffffffffc0202150:	b79d                	j	ffffffffc02020b6 <page_insert+0x56>
ffffffffc0202152:	b07ff0ef          	jal	ra,ffffffffc0201c58 <pa2page.part.0>

ffffffffc0202156 <pmm_init>:
ffffffffc0202156:	00003797          	auipc	a5,0x3
ffffffffc020215a:	b7278793          	addi	a5,a5,-1166 # ffffffffc0204cc8 <default_pmm_manager>
ffffffffc020215e:	638c                	ld	a1,0(a5)
ffffffffc0202160:	7159                	addi	sp,sp,-112
ffffffffc0202162:	f85a                	sd	s6,48(sp)
ffffffffc0202164:	00003517          	auipc	a0,0x3
ffffffffc0202168:	cc450513          	addi	a0,a0,-828 # ffffffffc0204e28 <default_pmm_manager+0x160>
ffffffffc020216c:	0000bb17          	auipc	s6,0xb
ffffffffc0202170:	354b0b13          	addi	s6,s6,852 # ffffffffc020d4c0 <pmm_manager>
ffffffffc0202174:	f486                	sd	ra,104(sp)
ffffffffc0202176:	e8ca                	sd	s2,80(sp)
ffffffffc0202178:	e4ce                	sd	s3,72(sp)
ffffffffc020217a:	f0a2                	sd	s0,96(sp)
ffffffffc020217c:	eca6                	sd	s1,88(sp)
ffffffffc020217e:	e0d2                	sd	s4,64(sp)
ffffffffc0202180:	fc56                	sd	s5,56(sp)
ffffffffc0202182:	f45e                	sd	s7,40(sp)
ffffffffc0202184:	f062                	sd	s8,32(sp)
ffffffffc0202186:	ec66                	sd	s9,24(sp)
ffffffffc0202188:	00fb3023          	sd	a5,0(s6)
ffffffffc020218c:	808fe0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0202190:	000b3783          	ld	a5,0(s6)
ffffffffc0202194:	0000b997          	auipc	s3,0xb
ffffffffc0202198:	33498993          	addi	s3,s3,820 # ffffffffc020d4c8 <va_pa_offset>
ffffffffc020219c:	679c                	ld	a5,8(a5)
ffffffffc020219e:	9782                	jalr	a5
ffffffffc02021a0:	57f5                	li	a5,-3
ffffffffc02021a2:	07fa                	slli	a5,a5,0x1e
ffffffffc02021a4:	00f9b023          	sd	a5,0(s3)
ffffffffc02021a8:	f6efe0ef          	jal	ra,ffffffffc0200916 <get_memory_base>
ffffffffc02021ac:	892a                	mv	s2,a0
ffffffffc02021ae:	f72fe0ef          	jal	ra,ffffffffc0200920 <get_memory_size>
ffffffffc02021b2:	200505e3          	beqz	a0,ffffffffc0202bbc <pmm_init+0xa66>
ffffffffc02021b6:	84aa                	mv	s1,a0
ffffffffc02021b8:	00003517          	auipc	a0,0x3
ffffffffc02021bc:	ca850513          	addi	a0,a0,-856 # ffffffffc0204e60 <default_pmm_manager+0x198>
ffffffffc02021c0:	fd5fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02021c4:	00990433          	add	s0,s2,s1
ffffffffc02021c8:	fff40693          	addi	a3,s0,-1
ffffffffc02021cc:	864a                	mv	a2,s2
ffffffffc02021ce:	85a6                	mv	a1,s1
ffffffffc02021d0:	00003517          	auipc	a0,0x3
ffffffffc02021d4:	ca850513          	addi	a0,a0,-856 # ffffffffc0204e78 <default_pmm_manager+0x1b0>
ffffffffc02021d8:	fbdfd0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02021dc:	c8000737          	lui	a4,0xc8000
ffffffffc02021e0:	87a2                	mv	a5,s0
ffffffffc02021e2:	54876163          	bltu	a4,s0,ffffffffc0202724 <pmm_init+0x5ce>
ffffffffc02021e6:	757d                	lui	a0,0xfffff
ffffffffc02021e8:	0000c617          	auipc	a2,0xc
ffffffffc02021ec:	30360613          	addi	a2,a2,771 # ffffffffc020e4eb <end+0xfff>
ffffffffc02021f0:	8e69                	and	a2,a2,a0
ffffffffc02021f2:	0000b497          	auipc	s1,0xb
ffffffffc02021f6:	2be48493          	addi	s1,s1,702 # ffffffffc020d4b0 <npage>
ffffffffc02021fa:	00c7d513          	srli	a0,a5,0xc
ffffffffc02021fe:	0000bb97          	auipc	s7,0xb
ffffffffc0202202:	2bab8b93          	addi	s7,s7,698 # ffffffffc020d4b8 <pages>
ffffffffc0202206:	e088                	sd	a0,0(s1)
ffffffffc0202208:	00cbb023          	sd	a2,0(s7)
ffffffffc020220c:	000807b7          	lui	a5,0x80
ffffffffc0202210:	86b2                	mv	a3,a2
ffffffffc0202212:	02f50863          	beq	a0,a5,ffffffffc0202242 <pmm_init+0xec>
ffffffffc0202216:	4781                	li	a5,0
ffffffffc0202218:	4585                	li	a1,1
ffffffffc020221a:	fff806b7          	lui	a3,0xfff80
ffffffffc020221e:	00679513          	slli	a0,a5,0x6
ffffffffc0202222:	9532                	add	a0,a0,a2
ffffffffc0202224:	00850713          	addi	a4,a0,8 # fffffffffffff008 <end+0x3fdf1b1c>
ffffffffc0202228:	40b7302f          	amoor.d	zero,a1,(a4)
ffffffffc020222c:	6088                	ld	a0,0(s1)
ffffffffc020222e:	0785                	addi	a5,a5,1
ffffffffc0202230:	000bb603          	ld	a2,0(s7)
ffffffffc0202234:	00d50733          	add	a4,a0,a3
ffffffffc0202238:	fee7e3e3          	bltu	a5,a4,ffffffffc020221e <pmm_init+0xc8>
ffffffffc020223c:	071a                	slli	a4,a4,0x6
ffffffffc020223e:	00e606b3          	add	a3,a2,a4
ffffffffc0202242:	c02007b7          	lui	a5,0xc0200
ffffffffc0202246:	2ef6ece3          	bltu	a3,a5,ffffffffc0202d3e <pmm_init+0xbe8>
ffffffffc020224a:	0009b583          	ld	a1,0(s3)
ffffffffc020224e:	77fd                	lui	a5,0xfffff
ffffffffc0202250:	8c7d                	and	s0,s0,a5
ffffffffc0202252:	8e8d                	sub	a3,a3,a1
ffffffffc0202254:	5086eb63          	bltu	a3,s0,ffffffffc020276a <pmm_init+0x614>
ffffffffc0202258:	00003517          	auipc	a0,0x3
ffffffffc020225c:	c4850513          	addi	a0,a0,-952 # ffffffffc0204ea0 <default_pmm_manager+0x1d8>
ffffffffc0202260:	f35fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0202264:	000b3783          	ld	a5,0(s6)
ffffffffc0202268:	0000b917          	auipc	s2,0xb
ffffffffc020226c:	24090913          	addi	s2,s2,576 # ffffffffc020d4a8 <boot_pgdir_va>
ffffffffc0202270:	7b9c                	ld	a5,48(a5)
ffffffffc0202272:	9782                	jalr	a5
ffffffffc0202274:	00003517          	auipc	a0,0x3
ffffffffc0202278:	c4450513          	addi	a0,a0,-956 # ffffffffc0204eb8 <default_pmm_manager+0x1f0>
ffffffffc020227c:	f19fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0202280:	00006697          	auipc	a3,0x6
ffffffffc0202284:	d8068693          	addi	a3,a3,-640 # ffffffffc0208000 <boot_page_table_sv39>
ffffffffc0202288:	00d93023          	sd	a3,0(s2)
ffffffffc020228c:	c02007b7          	lui	a5,0xc0200
ffffffffc0202290:	28f6ebe3          	bltu	a3,a5,ffffffffc0202d26 <pmm_init+0xbd0>
ffffffffc0202294:	0009b783          	ld	a5,0(s3)
ffffffffc0202298:	8e9d                	sub	a3,a3,a5
ffffffffc020229a:	0000b797          	auipc	a5,0xb
ffffffffc020229e:	20d7b323          	sd	a3,518(a5) # ffffffffc020d4a0 <boot_pgdir_pa>
ffffffffc02022a2:	100027f3          	csrr	a5,sstatus
ffffffffc02022a6:	8b89                	andi	a5,a5,2
ffffffffc02022a8:	4a079763          	bnez	a5,ffffffffc0202756 <pmm_init+0x600>
ffffffffc02022ac:	000b3783          	ld	a5,0(s6)
ffffffffc02022b0:	779c                	ld	a5,40(a5)
ffffffffc02022b2:	9782                	jalr	a5
ffffffffc02022b4:	842a                	mv	s0,a0
ffffffffc02022b6:	6098                	ld	a4,0(s1)
ffffffffc02022b8:	c80007b7          	lui	a5,0xc8000
ffffffffc02022bc:	83b1                	srli	a5,a5,0xc
ffffffffc02022be:	66e7e363          	bltu	a5,a4,ffffffffc0202924 <pmm_init+0x7ce>
ffffffffc02022c2:	00093503          	ld	a0,0(s2)
ffffffffc02022c6:	62050f63          	beqz	a0,ffffffffc0202904 <pmm_init+0x7ae>
ffffffffc02022ca:	03451793          	slli	a5,a0,0x34
ffffffffc02022ce:	62079b63          	bnez	a5,ffffffffc0202904 <pmm_init+0x7ae>
ffffffffc02022d2:	4601                	li	a2,0
ffffffffc02022d4:	4581                	li	a1,0
ffffffffc02022d6:	c9bff0ef          	jal	ra,ffffffffc0201f70 <get_page>
ffffffffc02022da:	60051563          	bnez	a0,ffffffffc02028e4 <pmm_init+0x78e>
ffffffffc02022de:	100027f3          	csrr	a5,sstatus
ffffffffc02022e2:	8b89                	andi	a5,a5,2
ffffffffc02022e4:	44079e63          	bnez	a5,ffffffffc0202740 <pmm_init+0x5ea>
ffffffffc02022e8:	000b3783          	ld	a5,0(s6)
ffffffffc02022ec:	4505                	li	a0,1
ffffffffc02022ee:	6f9c                	ld	a5,24(a5)
ffffffffc02022f0:	9782                	jalr	a5
ffffffffc02022f2:	8a2a                	mv	s4,a0
ffffffffc02022f4:	00093503          	ld	a0,0(s2)
ffffffffc02022f8:	4681                	li	a3,0
ffffffffc02022fa:	4601                	li	a2,0
ffffffffc02022fc:	85d2                	mv	a1,s4
ffffffffc02022fe:	d63ff0ef          	jal	ra,ffffffffc0202060 <page_insert>
ffffffffc0202302:	26051ae3          	bnez	a0,ffffffffc0202d76 <pmm_init+0xc20>
ffffffffc0202306:	00093503          	ld	a0,0(s2)
ffffffffc020230a:	4601                	li	a2,0
ffffffffc020230c:	4581                	li	a1,0
ffffffffc020230e:	a3bff0ef          	jal	ra,ffffffffc0201d48 <get_pte>
ffffffffc0202312:	240502e3          	beqz	a0,ffffffffc0202d56 <pmm_init+0xc00>
ffffffffc0202316:	611c                	ld	a5,0(a0)
ffffffffc0202318:	0017f713          	andi	a4,a5,1
ffffffffc020231c:	5a070263          	beqz	a4,ffffffffc02028c0 <pmm_init+0x76a>
ffffffffc0202320:	6098                	ld	a4,0(s1)
ffffffffc0202322:	078a                	slli	a5,a5,0x2
ffffffffc0202324:	83b1                	srli	a5,a5,0xc
ffffffffc0202326:	58e7fb63          	bgeu	a5,a4,ffffffffc02028bc <pmm_init+0x766>
ffffffffc020232a:	000bb683          	ld	a3,0(s7)
ffffffffc020232e:	fff80637          	lui	a2,0xfff80
ffffffffc0202332:	97b2                	add	a5,a5,a2
ffffffffc0202334:	079a                	slli	a5,a5,0x6
ffffffffc0202336:	97b6                	add	a5,a5,a3
ffffffffc0202338:	14fa17e3          	bne	s4,a5,ffffffffc0202c86 <pmm_init+0xb30>
ffffffffc020233c:	000a2683          	lw	a3,0(s4) # 80000 <kern_entry-0xffffffffc0180000>
ffffffffc0202340:	4785                	li	a5,1
ffffffffc0202342:	12f692e3          	bne	a3,a5,ffffffffc0202c66 <pmm_init+0xb10>
ffffffffc0202346:	00093503          	ld	a0,0(s2)
ffffffffc020234a:	77fd                	lui	a5,0xfffff
ffffffffc020234c:	6114                	ld	a3,0(a0)
ffffffffc020234e:	068a                	slli	a3,a3,0x2
ffffffffc0202350:	8efd                	and	a3,a3,a5
ffffffffc0202352:	00c6d613          	srli	a2,a3,0xc
ffffffffc0202356:	0ee67ce3          	bgeu	a2,a4,ffffffffc0202c4e <pmm_init+0xaf8>
ffffffffc020235a:	0009bc03          	ld	s8,0(s3)
ffffffffc020235e:	96e2                	add	a3,a3,s8
ffffffffc0202360:	0006ba83          	ld	s5,0(a3)
ffffffffc0202364:	0a8a                	slli	s5,s5,0x2
ffffffffc0202366:	00fafab3          	and	s5,s5,a5
ffffffffc020236a:	00cad793          	srli	a5,s5,0xc
ffffffffc020236e:	0ce7f3e3          	bgeu	a5,a4,ffffffffc0202c34 <pmm_init+0xade>
ffffffffc0202372:	4601                	li	a2,0
ffffffffc0202374:	6585                	lui	a1,0x1
ffffffffc0202376:	9ae2                	add	s5,s5,s8
ffffffffc0202378:	9d1ff0ef          	jal	ra,ffffffffc0201d48 <get_pte>
ffffffffc020237c:	0aa1                	addi	s5,s5,8
ffffffffc020237e:	55551363          	bne	a0,s5,ffffffffc02028c4 <pmm_init+0x76e>
ffffffffc0202382:	100027f3          	csrr	a5,sstatus
ffffffffc0202386:	8b89                	andi	a5,a5,2
ffffffffc0202388:	3a079163          	bnez	a5,ffffffffc020272a <pmm_init+0x5d4>
ffffffffc020238c:	000b3783          	ld	a5,0(s6)
ffffffffc0202390:	4505                	li	a0,1
ffffffffc0202392:	6f9c                	ld	a5,24(a5)
ffffffffc0202394:	9782                	jalr	a5
ffffffffc0202396:	8c2a                	mv	s8,a0
ffffffffc0202398:	00093503          	ld	a0,0(s2)
ffffffffc020239c:	46d1                	li	a3,20
ffffffffc020239e:	6605                	lui	a2,0x1
ffffffffc02023a0:	85e2                	mv	a1,s8
ffffffffc02023a2:	cbfff0ef          	jal	ra,ffffffffc0202060 <page_insert>
ffffffffc02023a6:	060517e3          	bnez	a0,ffffffffc0202c14 <pmm_init+0xabe>
ffffffffc02023aa:	00093503          	ld	a0,0(s2)
ffffffffc02023ae:	4601                	li	a2,0
ffffffffc02023b0:	6585                	lui	a1,0x1
ffffffffc02023b2:	997ff0ef          	jal	ra,ffffffffc0201d48 <get_pte>
ffffffffc02023b6:	02050fe3          	beqz	a0,ffffffffc0202bf4 <pmm_init+0xa9e>
ffffffffc02023ba:	611c                	ld	a5,0(a0)
ffffffffc02023bc:	0107f713          	andi	a4,a5,16
ffffffffc02023c0:	7c070e63          	beqz	a4,ffffffffc0202b9c <pmm_init+0xa46>
ffffffffc02023c4:	8b91                	andi	a5,a5,4
ffffffffc02023c6:	7a078b63          	beqz	a5,ffffffffc0202b7c <pmm_init+0xa26>
ffffffffc02023ca:	00093503          	ld	a0,0(s2)
ffffffffc02023ce:	611c                	ld	a5,0(a0)
ffffffffc02023d0:	8bc1                	andi	a5,a5,16
ffffffffc02023d2:	78078563          	beqz	a5,ffffffffc0202b5c <pmm_init+0xa06>
ffffffffc02023d6:	000c2703          	lw	a4,0(s8) # ff0000 <kern_entry-0xffffffffbf210000>
ffffffffc02023da:	4785                	li	a5,1
ffffffffc02023dc:	76f71063          	bne	a4,a5,ffffffffc0202b3c <pmm_init+0x9e6>
ffffffffc02023e0:	4681                	li	a3,0
ffffffffc02023e2:	6605                	lui	a2,0x1
ffffffffc02023e4:	85d2                	mv	a1,s4
ffffffffc02023e6:	c7bff0ef          	jal	ra,ffffffffc0202060 <page_insert>
ffffffffc02023ea:	72051963          	bnez	a0,ffffffffc0202b1c <pmm_init+0x9c6>
ffffffffc02023ee:	000a2703          	lw	a4,0(s4)
ffffffffc02023f2:	4789                	li	a5,2
ffffffffc02023f4:	70f71463          	bne	a4,a5,ffffffffc0202afc <pmm_init+0x9a6>
ffffffffc02023f8:	000c2783          	lw	a5,0(s8)
ffffffffc02023fc:	6e079063          	bnez	a5,ffffffffc0202adc <pmm_init+0x986>
ffffffffc0202400:	00093503          	ld	a0,0(s2)
ffffffffc0202404:	4601                	li	a2,0
ffffffffc0202406:	6585                	lui	a1,0x1
ffffffffc0202408:	941ff0ef          	jal	ra,ffffffffc0201d48 <get_pte>
ffffffffc020240c:	6a050863          	beqz	a0,ffffffffc0202abc <pmm_init+0x966>
ffffffffc0202410:	6118                	ld	a4,0(a0)
ffffffffc0202412:	00177793          	andi	a5,a4,1
ffffffffc0202416:	4a078563          	beqz	a5,ffffffffc02028c0 <pmm_init+0x76a>
ffffffffc020241a:	6094                	ld	a3,0(s1)
ffffffffc020241c:	00271793          	slli	a5,a4,0x2
ffffffffc0202420:	83b1                	srli	a5,a5,0xc
ffffffffc0202422:	48d7fd63          	bgeu	a5,a3,ffffffffc02028bc <pmm_init+0x766>
ffffffffc0202426:	000bb683          	ld	a3,0(s7)
ffffffffc020242a:	fff80ab7          	lui	s5,0xfff80
ffffffffc020242e:	97d6                	add	a5,a5,s5
ffffffffc0202430:	079a                	slli	a5,a5,0x6
ffffffffc0202432:	97b6                	add	a5,a5,a3
ffffffffc0202434:	66fa1463          	bne	s4,a5,ffffffffc0202a9c <pmm_init+0x946>
ffffffffc0202438:	8b41                	andi	a4,a4,16
ffffffffc020243a:	64071163          	bnez	a4,ffffffffc0202a7c <pmm_init+0x926>
ffffffffc020243e:	00093503          	ld	a0,0(s2)
ffffffffc0202442:	4581                	li	a1,0
ffffffffc0202444:	b81ff0ef          	jal	ra,ffffffffc0201fc4 <page_remove>
ffffffffc0202448:	000a2c83          	lw	s9,0(s4)
ffffffffc020244c:	4785                	li	a5,1
ffffffffc020244e:	60fc9763          	bne	s9,a5,ffffffffc0202a5c <pmm_init+0x906>
ffffffffc0202452:	000c2783          	lw	a5,0(s8)
ffffffffc0202456:	5e079363          	bnez	a5,ffffffffc0202a3c <pmm_init+0x8e6>
ffffffffc020245a:	00093503          	ld	a0,0(s2)
ffffffffc020245e:	6585                	lui	a1,0x1
ffffffffc0202460:	b65ff0ef          	jal	ra,ffffffffc0201fc4 <page_remove>
ffffffffc0202464:	000a2783          	lw	a5,0(s4)
ffffffffc0202468:	52079a63          	bnez	a5,ffffffffc020299c <pmm_init+0x846>
ffffffffc020246c:	000c2783          	lw	a5,0(s8)
ffffffffc0202470:	50079663          	bnez	a5,ffffffffc020297c <pmm_init+0x826>
ffffffffc0202474:	00093a03          	ld	s4,0(s2)
ffffffffc0202478:	608c                	ld	a1,0(s1)
ffffffffc020247a:	000a3683          	ld	a3,0(s4)
ffffffffc020247e:	068a                	slli	a3,a3,0x2
ffffffffc0202480:	82b1                	srli	a3,a3,0xc
ffffffffc0202482:	42b6fd63          	bgeu	a3,a1,ffffffffc02028bc <pmm_init+0x766>
ffffffffc0202486:	000bb503          	ld	a0,0(s7)
ffffffffc020248a:	96d6                	add	a3,a3,s5
ffffffffc020248c:	069a                	slli	a3,a3,0x6
ffffffffc020248e:	00d507b3          	add	a5,a0,a3
ffffffffc0202492:	439c                	lw	a5,0(a5)
ffffffffc0202494:	4d979463          	bne	a5,s9,ffffffffc020295c <pmm_init+0x806>
ffffffffc0202498:	8699                	srai	a3,a3,0x6
ffffffffc020249a:	00080637          	lui	a2,0x80
ffffffffc020249e:	96b2                	add	a3,a3,a2
ffffffffc02024a0:	00c69713          	slli	a4,a3,0xc
ffffffffc02024a4:	8331                	srli	a4,a4,0xc
ffffffffc02024a6:	06b2                	slli	a3,a3,0xc
ffffffffc02024a8:	48b77e63          	bgeu	a4,a1,ffffffffc0202944 <pmm_init+0x7ee>
ffffffffc02024ac:	0009b703          	ld	a4,0(s3)
ffffffffc02024b0:	96ba                	add	a3,a3,a4
ffffffffc02024b2:	629c                	ld	a5,0(a3)
ffffffffc02024b4:	078a                	slli	a5,a5,0x2
ffffffffc02024b6:	83b1                	srli	a5,a5,0xc
ffffffffc02024b8:	40b7f263          	bgeu	a5,a1,ffffffffc02028bc <pmm_init+0x766>
ffffffffc02024bc:	8f91                	sub	a5,a5,a2
ffffffffc02024be:	079a                	slli	a5,a5,0x6
ffffffffc02024c0:	953e                	add	a0,a0,a5
ffffffffc02024c2:	100027f3          	csrr	a5,sstatus
ffffffffc02024c6:	8b89                	andi	a5,a5,2
ffffffffc02024c8:	30079963          	bnez	a5,ffffffffc02027da <pmm_init+0x684>
ffffffffc02024cc:	000b3783          	ld	a5,0(s6)
ffffffffc02024d0:	4585                	li	a1,1
ffffffffc02024d2:	739c                	ld	a5,32(a5)
ffffffffc02024d4:	9782                	jalr	a5
ffffffffc02024d6:	000a3783          	ld	a5,0(s4)
ffffffffc02024da:	6098                	ld	a4,0(s1)
ffffffffc02024dc:	078a                	slli	a5,a5,0x2
ffffffffc02024de:	83b1                	srli	a5,a5,0xc
ffffffffc02024e0:	3ce7fe63          	bgeu	a5,a4,ffffffffc02028bc <pmm_init+0x766>
ffffffffc02024e4:	000bb503          	ld	a0,0(s7)
ffffffffc02024e8:	fff80737          	lui	a4,0xfff80
ffffffffc02024ec:	97ba                	add	a5,a5,a4
ffffffffc02024ee:	079a                	slli	a5,a5,0x6
ffffffffc02024f0:	953e                	add	a0,a0,a5
ffffffffc02024f2:	100027f3          	csrr	a5,sstatus
ffffffffc02024f6:	8b89                	andi	a5,a5,2
ffffffffc02024f8:	2c079563          	bnez	a5,ffffffffc02027c2 <pmm_init+0x66c>
ffffffffc02024fc:	000b3783          	ld	a5,0(s6)
ffffffffc0202500:	4585                	li	a1,1
ffffffffc0202502:	739c                	ld	a5,32(a5)
ffffffffc0202504:	9782                	jalr	a5
ffffffffc0202506:	00093783          	ld	a5,0(s2)
ffffffffc020250a:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fdf1b14>
ffffffffc020250e:	12000073          	sfence.vma
ffffffffc0202512:	100027f3          	csrr	a5,sstatus
ffffffffc0202516:	8b89                	andi	a5,a5,2
ffffffffc0202518:	28079b63          	bnez	a5,ffffffffc02027ae <pmm_init+0x658>
ffffffffc020251c:	000b3783          	ld	a5,0(s6)
ffffffffc0202520:	779c                	ld	a5,40(a5)
ffffffffc0202522:	9782                	jalr	a5
ffffffffc0202524:	8a2a                	mv	s4,a0
ffffffffc0202526:	4b441b63          	bne	s0,s4,ffffffffc02029dc <pmm_init+0x886>
ffffffffc020252a:	00003517          	auipc	a0,0x3
ffffffffc020252e:	cb650513          	addi	a0,a0,-842 # ffffffffc02051e0 <default_pmm_manager+0x518>
ffffffffc0202532:	c63fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0202536:	100027f3          	csrr	a5,sstatus
ffffffffc020253a:	8b89                	andi	a5,a5,2
ffffffffc020253c:	24079f63          	bnez	a5,ffffffffc020279a <pmm_init+0x644>
ffffffffc0202540:	000b3783          	ld	a5,0(s6)
ffffffffc0202544:	779c                	ld	a5,40(a5)
ffffffffc0202546:	9782                	jalr	a5
ffffffffc0202548:	8c2a                	mv	s8,a0
ffffffffc020254a:	6098                	ld	a4,0(s1)
ffffffffc020254c:	c0200437          	lui	s0,0xc0200
ffffffffc0202550:	7afd                	lui	s5,0xfffff
ffffffffc0202552:	00c71793          	slli	a5,a4,0xc
ffffffffc0202556:	6a05                	lui	s4,0x1
ffffffffc0202558:	02f47c63          	bgeu	s0,a5,ffffffffc0202590 <pmm_init+0x43a>
ffffffffc020255c:	00c45793          	srli	a5,s0,0xc
ffffffffc0202560:	00093503          	ld	a0,0(s2)
ffffffffc0202564:	2ee7ff63          	bgeu	a5,a4,ffffffffc0202862 <pmm_init+0x70c>
ffffffffc0202568:	0009b583          	ld	a1,0(s3)
ffffffffc020256c:	4601                	li	a2,0
ffffffffc020256e:	95a2                	add	a1,a1,s0
ffffffffc0202570:	fd8ff0ef          	jal	ra,ffffffffc0201d48 <get_pte>
ffffffffc0202574:	32050463          	beqz	a0,ffffffffc020289c <pmm_init+0x746>
ffffffffc0202578:	611c                	ld	a5,0(a0)
ffffffffc020257a:	078a                	slli	a5,a5,0x2
ffffffffc020257c:	0157f7b3          	and	a5,a5,s5
ffffffffc0202580:	2e879e63          	bne	a5,s0,ffffffffc020287c <pmm_init+0x726>
ffffffffc0202584:	6098                	ld	a4,0(s1)
ffffffffc0202586:	9452                	add	s0,s0,s4
ffffffffc0202588:	00c71793          	slli	a5,a4,0xc
ffffffffc020258c:	fcf468e3          	bltu	s0,a5,ffffffffc020255c <pmm_init+0x406>
ffffffffc0202590:	00093783          	ld	a5,0(s2)
ffffffffc0202594:	639c                	ld	a5,0(a5)
ffffffffc0202596:	42079363          	bnez	a5,ffffffffc02029bc <pmm_init+0x866>
ffffffffc020259a:	100027f3          	csrr	a5,sstatus
ffffffffc020259e:	8b89                	andi	a5,a5,2
ffffffffc02025a0:	24079963          	bnez	a5,ffffffffc02027f2 <pmm_init+0x69c>
ffffffffc02025a4:	000b3783          	ld	a5,0(s6)
ffffffffc02025a8:	4505                	li	a0,1
ffffffffc02025aa:	6f9c                	ld	a5,24(a5)
ffffffffc02025ac:	9782                	jalr	a5
ffffffffc02025ae:	8a2a                	mv	s4,a0
ffffffffc02025b0:	00093503          	ld	a0,0(s2)
ffffffffc02025b4:	4699                	li	a3,6
ffffffffc02025b6:	10000613          	li	a2,256
ffffffffc02025ba:	85d2                	mv	a1,s4
ffffffffc02025bc:	aa5ff0ef          	jal	ra,ffffffffc0202060 <page_insert>
ffffffffc02025c0:	44051e63          	bnez	a0,ffffffffc0202a1c <pmm_init+0x8c6>
ffffffffc02025c4:	000a2703          	lw	a4,0(s4) # 1000 <kern_entry-0xffffffffc01ff000>
ffffffffc02025c8:	4785                	li	a5,1
ffffffffc02025ca:	42f71963          	bne	a4,a5,ffffffffc02029fc <pmm_init+0x8a6>
ffffffffc02025ce:	00093503          	ld	a0,0(s2)
ffffffffc02025d2:	6405                	lui	s0,0x1
ffffffffc02025d4:	4699                	li	a3,6
ffffffffc02025d6:	10040613          	addi	a2,s0,256 # 1100 <kern_entry-0xffffffffc01fef00>
ffffffffc02025da:	85d2                	mv	a1,s4
ffffffffc02025dc:	a85ff0ef          	jal	ra,ffffffffc0202060 <page_insert>
ffffffffc02025e0:	72051363          	bnez	a0,ffffffffc0202d06 <pmm_init+0xbb0>
ffffffffc02025e4:	000a2703          	lw	a4,0(s4)
ffffffffc02025e8:	4789                	li	a5,2
ffffffffc02025ea:	6ef71e63          	bne	a4,a5,ffffffffc0202ce6 <pmm_init+0xb90>
ffffffffc02025ee:	00003597          	auipc	a1,0x3
ffffffffc02025f2:	d3a58593          	addi	a1,a1,-710 # ffffffffc0205328 <default_pmm_manager+0x660>
ffffffffc02025f6:	10000513          	li	a0,256
ffffffffc02025fa:	7e4010ef          	jal	ra,ffffffffc0203dde <strcpy>
ffffffffc02025fe:	10040593          	addi	a1,s0,256
ffffffffc0202602:	10000513          	li	a0,256
ffffffffc0202606:	7ea010ef          	jal	ra,ffffffffc0203df0 <strcmp>
ffffffffc020260a:	6a051e63          	bnez	a0,ffffffffc0202cc6 <pmm_init+0xb70>
ffffffffc020260e:	000bb683          	ld	a3,0(s7)
ffffffffc0202612:	00080737          	lui	a4,0x80
ffffffffc0202616:	547d                	li	s0,-1
ffffffffc0202618:	40da06b3          	sub	a3,s4,a3
ffffffffc020261c:	8699                	srai	a3,a3,0x6
ffffffffc020261e:	609c                	ld	a5,0(s1)
ffffffffc0202620:	96ba                	add	a3,a3,a4
ffffffffc0202622:	8031                	srli	s0,s0,0xc
ffffffffc0202624:	0086f733          	and	a4,a3,s0
ffffffffc0202628:	06b2                	slli	a3,a3,0xc
ffffffffc020262a:	30f77d63          	bgeu	a4,a5,ffffffffc0202944 <pmm_init+0x7ee>
ffffffffc020262e:	0009b783          	ld	a5,0(s3)
ffffffffc0202632:	10000513          	li	a0,256
ffffffffc0202636:	96be                	add	a3,a3,a5
ffffffffc0202638:	10068023          	sb	zero,256(a3)
ffffffffc020263c:	76c010ef          	jal	ra,ffffffffc0203da8 <strlen>
ffffffffc0202640:	66051363          	bnez	a0,ffffffffc0202ca6 <pmm_init+0xb50>
ffffffffc0202644:	00093a83          	ld	s5,0(s2)
ffffffffc0202648:	609c                	ld	a5,0(s1)
ffffffffc020264a:	000ab683          	ld	a3,0(s5) # fffffffffffff000 <end+0x3fdf1b14>
ffffffffc020264e:	068a                	slli	a3,a3,0x2
ffffffffc0202650:	82b1                	srli	a3,a3,0xc
ffffffffc0202652:	26f6f563          	bgeu	a3,a5,ffffffffc02028bc <pmm_init+0x766>
ffffffffc0202656:	8c75                	and	s0,s0,a3
ffffffffc0202658:	06b2                	slli	a3,a3,0xc
ffffffffc020265a:	2ef47563          	bgeu	s0,a5,ffffffffc0202944 <pmm_init+0x7ee>
ffffffffc020265e:	0009b403          	ld	s0,0(s3)
ffffffffc0202662:	9436                	add	s0,s0,a3
ffffffffc0202664:	100027f3          	csrr	a5,sstatus
ffffffffc0202668:	8b89                	andi	a5,a5,2
ffffffffc020266a:	1e079163          	bnez	a5,ffffffffc020284c <pmm_init+0x6f6>
ffffffffc020266e:	000b3783          	ld	a5,0(s6)
ffffffffc0202672:	4585                	li	a1,1
ffffffffc0202674:	8552                	mv	a0,s4
ffffffffc0202676:	739c                	ld	a5,32(a5)
ffffffffc0202678:	9782                	jalr	a5
ffffffffc020267a:	601c                	ld	a5,0(s0)
ffffffffc020267c:	6098                	ld	a4,0(s1)
ffffffffc020267e:	078a                	slli	a5,a5,0x2
ffffffffc0202680:	83b1                	srli	a5,a5,0xc
ffffffffc0202682:	22e7fd63          	bgeu	a5,a4,ffffffffc02028bc <pmm_init+0x766>
ffffffffc0202686:	000bb503          	ld	a0,0(s7)
ffffffffc020268a:	fff80737          	lui	a4,0xfff80
ffffffffc020268e:	97ba                	add	a5,a5,a4
ffffffffc0202690:	079a                	slli	a5,a5,0x6
ffffffffc0202692:	953e                	add	a0,a0,a5
ffffffffc0202694:	100027f3          	csrr	a5,sstatus
ffffffffc0202698:	8b89                	andi	a5,a5,2
ffffffffc020269a:	18079d63          	bnez	a5,ffffffffc0202834 <pmm_init+0x6de>
ffffffffc020269e:	000b3783          	ld	a5,0(s6)
ffffffffc02026a2:	4585                	li	a1,1
ffffffffc02026a4:	739c                	ld	a5,32(a5)
ffffffffc02026a6:	9782                	jalr	a5
ffffffffc02026a8:	000ab783          	ld	a5,0(s5)
ffffffffc02026ac:	6098                	ld	a4,0(s1)
ffffffffc02026ae:	078a                	slli	a5,a5,0x2
ffffffffc02026b0:	83b1                	srli	a5,a5,0xc
ffffffffc02026b2:	20e7f563          	bgeu	a5,a4,ffffffffc02028bc <pmm_init+0x766>
ffffffffc02026b6:	000bb503          	ld	a0,0(s7)
ffffffffc02026ba:	fff80737          	lui	a4,0xfff80
ffffffffc02026be:	97ba                	add	a5,a5,a4
ffffffffc02026c0:	079a                	slli	a5,a5,0x6
ffffffffc02026c2:	953e                	add	a0,a0,a5
ffffffffc02026c4:	100027f3          	csrr	a5,sstatus
ffffffffc02026c8:	8b89                	andi	a5,a5,2
ffffffffc02026ca:	14079963          	bnez	a5,ffffffffc020281c <pmm_init+0x6c6>
ffffffffc02026ce:	000b3783          	ld	a5,0(s6)
ffffffffc02026d2:	4585                	li	a1,1
ffffffffc02026d4:	739c                	ld	a5,32(a5)
ffffffffc02026d6:	9782                	jalr	a5
ffffffffc02026d8:	00093783          	ld	a5,0(s2)
ffffffffc02026dc:	0007b023          	sd	zero,0(a5)
ffffffffc02026e0:	12000073          	sfence.vma
ffffffffc02026e4:	100027f3          	csrr	a5,sstatus
ffffffffc02026e8:	8b89                	andi	a5,a5,2
ffffffffc02026ea:	10079f63          	bnez	a5,ffffffffc0202808 <pmm_init+0x6b2>
ffffffffc02026ee:	000b3783          	ld	a5,0(s6)
ffffffffc02026f2:	779c                	ld	a5,40(a5)
ffffffffc02026f4:	9782                	jalr	a5
ffffffffc02026f6:	842a                	mv	s0,a0
ffffffffc02026f8:	4c8c1e63          	bne	s8,s0,ffffffffc0202bd4 <pmm_init+0xa7e>
ffffffffc02026fc:	00003517          	auipc	a0,0x3
ffffffffc0202700:	ca450513          	addi	a0,a0,-860 # ffffffffc02053a0 <default_pmm_manager+0x6d8>
ffffffffc0202704:	a91fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0202708:	7406                	ld	s0,96(sp)
ffffffffc020270a:	70a6                	ld	ra,104(sp)
ffffffffc020270c:	64e6                	ld	s1,88(sp)
ffffffffc020270e:	6946                	ld	s2,80(sp)
ffffffffc0202710:	69a6                	ld	s3,72(sp)
ffffffffc0202712:	6a06                	ld	s4,64(sp)
ffffffffc0202714:	7ae2                	ld	s5,56(sp)
ffffffffc0202716:	7b42                	ld	s6,48(sp)
ffffffffc0202718:	7ba2                	ld	s7,40(sp)
ffffffffc020271a:	7c02                	ld	s8,32(sp)
ffffffffc020271c:	6ce2                	ld	s9,24(sp)
ffffffffc020271e:	6165                	addi	sp,sp,112
ffffffffc0202720:	b72ff06f          	j	ffffffffc0201a92 <kmalloc_init>
ffffffffc0202724:	c80007b7          	lui	a5,0xc8000
ffffffffc0202728:	bc7d                	j	ffffffffc02021e6 <pmm_init+0x90>
ffffffffc020272a:	a06fe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
ffffffffc020272e:	000b3783          	ld	a5,0(s6)
ffffffffc0202732:	4505                	li	a0,1
ffffffffc0202734:	6f9c                	ld	a5,24(a5)
ffffffffc0202736:	9782                	jalr	a5
ffffffffc0202738:	8c2a                	mv	s8,a0
ffffffffc020273a:	9f0fe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc020273e:	b9a9                	j	ffffffffc0202398 <pmm_init+0x242>
ffffffffc0202740:	9f0fe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
ffffffffc0202744:	000b3783          	ld	a5,0(s6)
ffffffffc0202748:	4505                	li	a0,1
ffffffffc020274a:	6f9c                	ld	a5,24(a5)
ffffffffc020274c:	9782                	jalr	a5
ffffffffc020274e:	8a2a                	mv	s4,a0
ffffffffc0202750:	9dafe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc0202754:	b645                	j	ffffffffc02022f4 <pmm_init+0x19e>
ffffffffc0202756:	9dafe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
ffffffffc020275a:	000b3783          	ld	a5,0(s6)
ffffffffc020275e:	779c                	ld	a5,40(a5)
ffffffffc0202760:	9782                	jalr	a5
ffffffffc0202762:	842a                	mv	s0,a0
ffffffffc0202764:	9c6fe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc0202768:	b6b9                	j	ffffffffc02022b6 <pmm_init+0x160>
ffffffffc020276a:	6705                	lui	a4,0x1
ffffffffc020276c:	177d                	addi	a4,a4,-1
ffffffffc020276e:	96ba                	add	a3,a3,a4
ffffffffc0202770:	8ff5                	and	a5,a5,a3
ffffffffc0202772:	00c7d713          	srli	a4,a5,0xc
ffffffffc0202776:	14a77363          	bgeu	a4,a0,ffffffffc02028bc <pmm_init+0x766>
ffffffffc020277a:	000b3683          	ld	a3,0(s6)
ffffffffc020277e:	fff80537          	lui	a0,0xfff80
ffffffffc0202782:	972a                	add	a4,a4,a0
ffffffffc0202784:	6a94                	ld	a3,16(a3)
ffffffffc0202786:	8c1d                	sub	s0,s0,a5
ffffffffc0202788:	00671513          	slli	a0,a4,0x6
ffffffffc020278c:	00c45593          	srli	a1,s0,0xc
ffffffffc0202790:	9532                	add	a0,a0,a2
ffffffffc0202792:	9682                	jalr	a3
ffffffffc0202794:	0009b583          	ld	a1,0(s3)
ffffffffc0202798:	b4c1                	j	ffffffffc0202258 <pmm_init+0x102>
ffffffffc020279a:	996fe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
ffffffffc020279e:	000b3783          	ld	a5,0(s6)
ffffffffc02027a2:	779c                	ld	a5,40(a5)
ffffffffc02027a4:	9782                	jalr	a5
ffffffffc02027a6:	8c2a                	mv	s8,a0
ffffffffc02027a8:	982fe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc02027ac:	bb79                	j	ffffffffc020254a <pmm_init+0x3f4>
ffffffffc02027ae:	982fe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
ffffffffc02027b2:	000b3783          	ld	a5,0(s6)
ffffffffc02027b6:	779c                	ld	a5,40(a5)
ffffffffc02027b8:	9782                	jalr	a5
ffffffffc02027ba:	8a2a                	mv	s4,a0
ffffffffc02027bc:	96efe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc02027c0:	b39d                	j	ffffffffc0202526 <pmm_init+0x3d0>
ffffffffc02027c2:	e42a                	sd	a0,8(sp)
ffffffffc02027c4:	96cfe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
ffffffffc02027c8:	000b3783          	ld	a5,0(s6)
ffffffffc02027cc:	6522                	ld	a0,8(sp)
ffffffffc02027ce:	4585                	li	a1,1
ffffffffc02027d0:	739c                	ld	a5,32(a5)
ffffffffc02027d2:	9782                	jalr	a5
ffffffffc02027d4:	956fe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc02027d8:	b33d                	j	ffffffffc0202506 <pmm_init+0x3b0>
ffffffffc02027da:	e42a                	sd	a0,8(sp)
ffffffffc02027dc:	954fe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
ffffffffc02027e0:	000b3783          	ld	a5,0(s6)
ffffffffc02027e4:	6522                	ld	a0,8(sp)
ffffffffc02027e6:	4585                	li	a1,1
ffffffffc02027e8:	739c                	ld	a5,32(a5)
ffffffffc02027ea:	9782                	jalr	a5
ffffffffc02027ec:	93efe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc02027f0:	b1dd                	j	ffffffffc02024d6 <pmm_init+0x380>
ffffffffc02027f2:	93efe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
ffffffffc02027f6:	000b3783          	ld	a5,0(s6)
ffffffffc02027fa:	4505                	li	a0,1
ffffffffc02027fc:	6f9c                	ld	a5,24(a5)
ffffffffc02027fe:	9782                	jalr	a5
ffffffffc0202800:	8a2a                	mv	s4,a0
ffffffffc0202802:	928fe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc0202806:	b36d                	j	ffffffffc02025b0 <pmm_init+0x45a>
ffffffffc0202808:	928fe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
ffffffffc020280c:	000b3783          	ld	a5,0(s6)
ffffffffc0202810:	779c                	ld	a5,40(a5)
ffffffffc0202812:	9782                	jalr	a5
ffffffffc0202814:	842a                	mv	s0,a0
ffffffffc0202816:	914fe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc020281a:	bdf9                	j	ffffffffc02026f8 <pmm_init+0x5a2>
ffffffffc020281c:	e42a                	sd	a0,8(sp)
ffffffffc020281e:	912fe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
ffffffffc0202822:	000b3783          	ld	a5,0(s6)
ffffffffc0202826:	6522                	ld	a0,8(sp)
ffffffffc0202828:	4585                	li	a1,1
ffffffffc020282a:	739c                	ld	a5,32(a5)
ffffffffc020282c:	9782                	jalr	a5
ffffffffc020282e:	8fcfe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc0202832:	b55d                	j	ffffffffc02026d8 <pmm_init+0x582>
ffffffffc0202834:	e42a                	sd	a0,8(sp)
ffffffffc0202836:	8fafe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
ffffffffc020283a:	000b3783          	ld	a5,0(s6)
ffffffffc020283e:	6522                	ld	a0,8(sp)
ffffffffc0202840:	4585                	li	a1,1
ffffffffc0202842:	739c                	ld	a5,32(a5)
ffffffffc0202844:	9782                	jalr	a5
ffffffffc0202846:	8e4fe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc020284a:	bdb9                	j	ffffffffc02026a8 <pmm_init+0x552>
ffffffffc020284c:	8e4fe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
ffffffffc0202850:	000b3783          	ld	a5,0(s6)
ffffffffc0202854:	4585                	li	a1,1
ffffffffc0202856:	8552                	mv	a0,s4
ffffffffc0202858:	739c                	ld	a5,32(a5)
ffffffffc020285a:	9782                	jalr	a5
ffffffffc020285c:	8cefe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc0202860:	bd29                	j	ffffffffc020267a <pmm_init+0x524>
ffffffffc0202862:	86a2                	mv	a3,s0
ffffffffc0202864:	00002617          	auipc	a2,0x2
ffffffffc0202868:	49c60613          	addi	a2,a2,1180 # ffffffffc0204d00 <default_pmm_manager+0x38>
ffffffffc020286c:	1a400593          	li	a1,420
ffffffffc0202870:	00002517          	auipc	a0,0x2
ffffffffc0202874:	5a850513          	addi	a0,a0,1448 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202878:	be3fd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc020287c:	00003697          	auipc	a3,0x3
ffffffffc0202880:	9c468693          	addi	a3,a3,-1596 # ffffffffc0205240 <default_pmm_manager+0x578>
ffffffffc0202884:	00002617          	auipc	a2,0x2
ffffffffc0202888:	09460613          	addi	a2,a2,148 # ffffffffc0204918 <commands+0x818>
ffffffffc020288c:	1a500593          	li	a1,421
ffffffffc0202890:	00002517          	auipc	a0,0x2
ffffffffc0202894:	58850513          	addi	a0,a0,1416 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202898:	bc3fd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc020289c:	00003697          	auipc	a3,0x3
ffffffffc02028a0:	96468693          	addi	a3,a3,-1692 # ffffffffc0205200 <default_pmm_manager+0x538>
ffffffffc02028a4:	00002617          	auipc	a2,0x2
ffffffffc02028a8:	07460613          	addi	a2,a2,116 # ffffffffc0204918 <commands+0x818>
ffffffffc02028ac:	1a400593          	li	a1,420
ffffffffc02028b0:	00002517          	auipc	a0,0x2
ffffffffc02028b4:	56850513          	addi	a0,a0,1384 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc02028b8:	ba3fd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc02028bc:	b9cff0ef          	jal	ra,ffffffffc0201c58 <pa2page.part.0>
ffffffffc02028c0:	bb4ff0ef          	jal	ra,ffffffffc0201c74 <pte2page.part.0>
ffffffffc02028c4:	00002697          	auipc	a3,0x2
ffffffffc02028c8:	73468693          	addi	a3,a3,1844 # ffffffffc0204ff8 <default_pmm_manager+0x330>
ffffffffc02028cc:	00002617          	auipc	a2,0x2
ffffffffc02028d0:	04c60613          	addi	a2,a2,76 # ffffffffc0204918 <commands+0x818>
ffffffffc02028d4:	17400593          	li	a1,372
ffffffffc02028d8:	00002517          	auipc	a0,0x2
ffffffffc02028dc:	54050513          	addi	a0,a0,1344 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc02028e0:	b7bfd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc02028e4:	00002697          	auipc	a3,0x2
ffffffffc02028e8:	65468693          	addi	a3,a3,1620 # ffffffffc0204f38 <default_pmm_manager+0x270>
ffffffffc02028ec:	00002617          	auipc	a2,0x2
ffffffffc02028f0:	02c60613          	addi	a2,a2,44 # ffffffffc0204918 <commands+0x818>
ffffffffc02028f4:	16700593          	li	a1,359
ffffffffc02028f8:	00002517          	auipc	a0,0x2
ffffffffc02028fc:	52050513          	addi	a0,a0,1312 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202900:	b5bfd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0202904:	00002697          	auipc	a3,0x2
ffffffffc0202908:	5f468693          	addi	a3,a3,1524 # ffffffffc0204ef8 <default_pmm_manager+0x230>
ffffffffc020290c:	00002617          	auipc	a2,0x2
ffffffffc0202910:	00c60613          	addi	a2,a2,12 # ffffffffc0204918 <commands+0x818>
ffffffffc0202914:	16600593          	li	a1,358
ffffffffc0202918:	00002517          	auipc	a0,0x2
ffffffffc020291c:	50050513          	addi	a0,a0,1280 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202920:	b3bfd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0202924:	00002697          	auipc	a3,0x2
ffffffffc0202928:	5b468693          	addi	a3,a3,1460 # ffffffffc0204ed8 <default_pmm_manager+0x210>
ffffffffc020292c:	00002617          	auipc	a2,0x2
ffffffffc0202930:	fec60613          	addi	a2,a2,-20 # ffffffffc0204918 <commands+0x818>
ffffffffc0202934:	16500593          	li	a1,357
ffffffffc0202938:	00002517          	auipc	a0,0x2
ffffffffc020293c:	4e050513          	addi	a0,a0,1248 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202940:	b1bfd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0202944:	00002617          	auipc	a2,0x2
ffffffffc0202948:	3bc60613          	addi	a2,a2,956 # ffffffffc0204d00 <default_pmm_manager+0x38>
ffffffffc020294c:	07100593          	li	a1,113
ffffffffc0202950:	00002517          	auipc	a0,0x2
ffffffffc0202954:	3d850513          	addi	a0,a0,984 # ffffffffc0204d28 <default_pmm_manager+0x60>
ffffffffc0202958:	b03fd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc020295c:	00003697          	auipc	a3,0x3
ffffffffc0202960:	82c68693          	addi	a3,a3,-2004 # ffffffffc0205188 <default_pmm_manager+0x4c0>
ffffffffc0202964:	00002617          	auipc	a2,0x2
ffffffffc0202968:	fb460613          	addi	a2,a2,-76 # ffffffffc0204918 <commands+0x818>
ffffffffc020296c:	18d00593          	li	a1,397
ffffffffc0202970:	00002517          	auipc	a0,0x2
ffffffffc0202974:	4a850513          	addi	a0,a0,1192 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202978:	ae3fd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc020297c:	00002697          	auipc	a3,0x2
ffffffffc0202980:	7c468693          	addi	a3,a3,1988 # ffffffffc0205140 <default_pmm_manager+0x478>
ffffffffc0202984:	00002617          	auipc	a2,0x2
ffffffffc0202988:	f9460613          	addi	a2,a2,-108 # ffffffffc0204918 <commands+0x818>
ffffffffc020298c:	18b00593          	li	a1,395
ffffffffc0202990:	00002517          	auipc	a0,0x2
ffffffffc0202994:	48850513          	addi	a0,a0,1160 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202998:	ac3fd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc020299c:	00002697          	auipc	a3,0x2
ffffffffc02029a0:	7d468693          	addi	a3,a3,2004 # ffffffffc0205170 <default_pmm_manager+0x4a8>
ffffffffc02029a4:	00002617          	auipc	a2,0x2
ffffffffc02029a8:	f7460613          	addi	a2,a2,-140 # ffffffffc0204918 <commands+0x818>
ffffffffc02029ac:	18a00593          	li	a1,394
ffffffffc02029b0:	00002517          	auipc	a0,0x2
ffffffffc02029b4:	46850513          	addi	a0,a0,1128 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc02029b8:	aa3fd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc02029bc:	00003697          	auipc	a3,0x3
ffffffffc02029c0:	89c68693          	addi	a3,a3,-1892 # ffffffffc0205258 <default_pmm_manager+0x590>
ffffffffc02029c4:	00002617          	auipc	a2,0x2
ffffffffc02029c8:	f5460613          	addi	a2,a2,-172 # ffffffffc0204918 <commands+0x818>
ffffffffc02029cc:	1a800593          	li	a1,424
ffffffffc02029d0:	00002517          	auipc	a0,0x2
ffffffffc02029d4:	44850513          	addi	a0,a0,1096 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc02029d8:	a83fd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc02029dc:	00002697          	auipc	a3,0x2
ffffffffc02029e0:	7dc68693          	addi	a3,a3,2012 # ffffffffc02051b8 <default_pmm_manager+0x4f0>
ffffffffc02029e4:	00002617          	auipc	a2,0x2
ffffffffc02029e8:	f3460613          	addi	a2,a2,-204 # ffffffffc0204918 <commands+0x818>
ffffffffc02029ec:	19500593          	li	a1,405
ffffffffc02029f0:	00002517          	auipc	a0,0x2
ffffffffc02029f4:	42850513          	addi	a0,a0,1064 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc02029f8:	a63fd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc02029fc:	00003697          	auipc	a3,0x3
ffffffffc0202a00:	8b468693          	addi	a3,a3,-1868 # ffffffffc02052b0 <default_pmm_manager+0x5e8>
ffffffffc0202a04:	00002617          	auipc	a2,0x2
ffffffffc0202a08:	f1460613          	addi	a2,a2,-236 # ffffffffc0204918 <commands+0x818>
ffffffffc0202a0c:	1ad00593          	li	a1,429
ffffffffc0202a10:	00002517          	auipc	a0,0x2
ffffffffc0202a14:	40850513          	addi	a0,a0,1032 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202a18:	a43fd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0202a1c:	00003697          	auipc	a3,0x3
ffffffffc0202a20:	85468693          	addi	a3,a3,-1964 # ffffffffc0205270 <default_pmm_manager+0x5a8>
ffffffffc0202a24:	00002617          	auipc	a2,0x2
ffffffffc0202a28:	ef460613          	addi	a2,a2,-268 # ffffffffc0204918 <commands+0x818>
ffffffffc0202a2c:	1ac00593          	li	a1,428
ffffffffc0202a30:	00002517          	auipc	a0,0x2
ffffffffc0202a34:	3e850513          	addi	a0,a0,1000 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202a38:	a23fd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0202a3c:	00002697          	auipc	a3,0x2
ffffffffc0202a40:	70468693          	addi	a3,a3,1796 # ffffffffc0205140 <default_pmm_manager+0x478>
ffffffffc0202a44:	00002617          	auipc	a2,0x2
ffffffffc0202a48:	ed460613          	addi	a2,a2,-300 # ffffffffc0204918 <commands+0x818>
ffffffffc0202a4c:	18700593          	li	a1,391
ffffffffc0202a50:	00002517          	auipc	a0,0x2
ffffffffc0202a54:	3c850513          	addi	a0,a0,968 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202a58:	a03fd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0202a5c:	00002697          	auipc	a3,0x2
ffffffffc0202a60:	58468693          	addi	a3,a3,1412 # ffffffffc0204fe0 <default_pmm_manager+0x318>
ffffffffc0202a64:	00002617          	auipc	a2,0x2
ffffffffc0202a68:	eb460613          	addi	a2,a2,-332 # ffffffffc0204918 <commands+0x818>
ffffffffc0202a6c:	18600593          	li	a1,390
ffffffffc0202a70:	00002517          	auipc	a0,0x2
ffffffffc0202a74:	3a850513          	addi	a0,a0,936 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202a78:	9e3fd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0202a7c:	00002697          	auipc	a3,0x2
ffffffffc0202a80:	6dc68693          	addi	a3,a3,1756 # ffffffffc0205158 <default_pmm_manager+0x490>
ffffffffc0202a84:	00002617          	auipc	a2,0x2
ffffffffc0202a88:	e9460613          	addi	a2,a2,-364 # ffffffffc0204918 <commands+0x818>
ffffffffc0202a8c:	18300593          	li	a1,387
ffffffffc0202a90:	00002517          	auipc	a0,0x2
ffffffffc0202a94:	38850513          	addi	a0,a0,904 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202a98:	9c3fd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0202a9c:	00002697          	auipc	a3,0x2
ffffffffc0202aa0:	52c68693          	addi	a3,a3,1324 # ffffffffc0204fc8 <default_pmm_manager+0x300>
ffffffffc0202aa4:	00002617          	auipc	a2,0x2
ffffffffc0202aa8:	e7460613          	addi	a2,a2,-396 # ffffffffc0204918 <commands+0x818>
ffffffffc0202aac:	18200593          	li	a1,386
ffffffffc0202ab0:	00002517          	auipc	a0,0x2
ffffffffc0202ab4:	36850513          	addi	a0,a0,872 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202ab8:	9a3fd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0202abc:	00002697          	auipc	a3,0x2
ffffffffc0202ac0:	5ac68693          	addi	a3,a3,1452 # ffffffffc0205068 <default_pmm_manager+0x3a0>
ffffffffc0202ac4:	00002617          	auipc	a2,0x2
ffffffffc0202ac8:	e5460613          	addi	a2,a2,-428 # ffffffffc0204918 <commands+0x818>
ffffffffc0202acc:	18100593          	li	a1,385
ffffffffc0202ad0:	00002517          	auipc	a0,0x2
ffffffffc0202ad4:	34850513          	addi	a0,a0,840 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202ad8:	983fd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0202adc:	00002697          	auipc	a3,0x2
ffffffffc0202ae0:	66468693          	addi	a3,a3,1636 # ffffffffc0205140 <default_pmm_manager+0x478>
ffffffffc0202ae4:	00002617          	auipc	a2,0x2
ffffffffc0202ae8:	e3460613          	addi	a2,a2,-460 # ffffffffc0204918 <commands+0x818>
ffffffffc0202aec:	18000593          	li	a1,384
ffffffffc0202af0:	00002517          	auipc	a0,0x2
ffffffffc0202af4:	32850513          	addi	a0,a0,808 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202af8:	963fd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0202afc:	00002697          	auipc	a3,0x2
ffffffffc0202b00:	62c68693          	addi	a3,a3,1580 # ffffffffc0205128 <default_pmm_manager+0x460>
ffffffffc0202b04:	00002617          	auipc	a2,0x2
ffffffffc0202b08:	e1460613          	addi	a2,a2,-492 # ffffffffc0204918 <commands+0x818>
ffffffffc0202b0c:	17f00593          	li	a1,383
ffffffffc0202b10:	00002517          	auipc	a0,0x2
ffffffffc0202b14:	30850513          	addi	a0,a0,776 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202b18:	943fd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0202b1c:	00002697          	auipc	a3,0x2
ffffffffc0202b20:	5dc68693          	addi	a3,a3,1500 # ffffffffc02050f8 <default_pmm_manager+0x430>
ffffffffc0202b24:	00002617          	auipc	a2,0x2
ffffffffc0202b28:	df460613          	addi	a2,a2,-524 # ffffffffc0204918 <commands+0x818>
ffffffffc0202b2c:	17e00593          	li	a1,382
ffffffffc0202b30:	00002517          	auipc	a0,0x2
ffffffffc0202b34:	2e850513          	addi	a0,a0,744 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202b38:	923fd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0202b3c:	00002697          	auipc	a3,0x2
ffffffffc0202b40:	5a468693          	addi	a3,a3,1444 # ffffffffc02050e0 <default_pmm_manager+0x418>
ffffffffc0202b44:	00002617          	auipc	a2,0x2
ffffffffc0202b48:	dd460613          	addi	a2,a2,-556 # ffffffffc0204918 <commands+0x818>
ffffffffc0202b4c:	17c00593          	li	a1,380
ffffffffc0202b50:	00002517          	auipc	a0,0x2
ffffffffc0202b54:	2c850513          	addi	a0,a0,712 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202b58:	903fd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0202b5c:	00002697          	auipc	a3,0x2
ffffffffc0202b60:	56468693          	addi	a3,a3,1380 # ffffffffc02050c0 <default_pmm_manager+0x3f8>
ffffffffc0202b64:	00002617          	auipc	a2,0x2
ffffffffc0202b68:	db460613          	addi	a2,a2,-588 # ffffffffc0204918 <commands+0x818>
ffffffffc0202b6c:	17b00593          	li	a1,379
ffffffffc0202b70:	00002517          	auipc	a0,0x2
ffffffffc0202b74:	2a850513          	addi	a0,a0,680 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202b78:	8e3fd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0202b7c:	00002697          	auipc	a3,0x2
ffffffffc0202b80:	53468693          	addi	a3,a3,1332 # ffffffffc02050b0 <default_pmm_manager+0x3e8>
ffffffffc0202b84:	00002617          	auipc	a2,0x2
ffffffffc0202b88:	d9460613          	addi	a2,a2,-620 # ffffffffc0204918 <commands+0x818>
ffffffffc0202b8c:	17a00593          	li	a1,378
ffffffffc0202b90:	00002517          	auipc	a0,0x2
ffffffffc0202b94:	28850513          	addi	a0,a0,648 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202b98:	8c3fd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0202b9c:	00002697          	auipc	a3,0x2
ffffffffc0202ba0:	50468693          	addi	a3,a3,1284 # ffffffffc02050a0 <default_pmm_manager+0x3d8>
ffffffffc0202ba4:	00002617          	auipc	a2,0x2
ffffffffc0202ba8:	d7460613          	addi	a2,a2,-652 # ffffffffc0204918 <commands+0x818>
ffffffffc0202bac:	17900593          	li	a1,377
ffffffffc0202bb0:	00002517          	auipc	a0,0x2
ffffffffc0202bb4:	26850513          	addi	a0,a0,616 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202bb8:	8a3fd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0202bbc:	00002617          	auipc	a2,0x2
ffffffffc0202bc0:	28460613          	addi	a2,a2,644 # ffffffffc0204e40 <default_pmm_manager+0x178>
ffffffffc0202bc4:	06400593          	li	a1,100
ffffffffc0202bc8:	00002517          	auipc	a0,0x2
ffffffffc0202bcc:	25050513          	addi	a0,a0,592 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202bd0:	88bfd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0202bd4:	00002697          	auipc	a3,0x2
ffffffffc0202bd8:	5e468693          	addi	a3,a3,1508 # ffffffffc02051b8 <default_pmm_manager+0x4f0>
ffffffffc0202bdc:	00002617          	auipc	a2,0x2
ffffffffc0202be0:	d3c60613          	addi	a2,a2,-708 # ffffffffc0204918 <commands+0x818>
ffffffffc0202be4:	1bf00593          	li	a1,447
ffffffffc0202be8:	00002517          	auipc	a0,0x2
ffffffffc0202bec:	23050513          	addi	a0,a0,560 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202bf0:	86bfd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0202bf4:	00002697          	auipc	a3,0x2
ffffffffc0202bf8:	47468693          	addi	a3,a3,1140 # ffffffffc0205068 <default_pmm_manager+0x3a0>
ffffffffc0202bfc:	00002617          	auipc	a2,0x2
ffffffffc0202c00:	d1c60613          	addi	a2,a2,-740 # ffffffffc0204918 <commands+0x818>
ffffffffc0202c04:	17800593          	li	a1,376
ffffffffc0202c08:	00002517          	auipc	a0,0x2
ffffffffc0202c0c:	21050513          	addi	a0,a0,528 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202c10:	84bfd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0202c14:	00002697          	auipc	a3,0x2
ffffffffc0202c18:	41468693          	addi	a3,a3,1044 # ffffffffc0205028 <default_pmm_manager+0x360>
ffffffffc0202c1c:	00002617          	auipc	a2,0x2
ffffffffc0202c20:	cfc60613          	addi	a2,a2,-772 # ffffffffc0204918 <commands+0x818>
ffffffffc0202c24:	17700593          	li	a1,375
ffffffffc0202c28:	00002517          	auipc	a0,0x2
ffffffffc0202c2c:	1f050513          	addi	a0,a0,496 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202c30:	82bfd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0202c34:	86d6                	mv	a3,s5
ffffffffc0202c36:	00002617          	auipc	a2,0x2
ffffffffc0202c3a:	0ca60613          	addi	a2,a2,202 # ffffffffc0204d00 <default_pmm_manager+0x38>
ffffffffc0202c3e:	17300593          	li	a1,371
ffffffffc0202c42:	00002517          	auipc	a0,0x2
ffffffffc0202c46:	1d650513          	addi	a0,a0,470 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202c4a:	811fd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0202c4e:	00002617          	auipc	a2,0x2
ffffffffc0202c52:	0b260613          	addi	a2,a2,178 # ffffffffc0204d00 <default_pmm_manager+0x38>
ffffffffc0202c56:	17200593          	li	a1,370
ffffffffc0202c5a:	00002517          	auipc	a0,0x2
ffffffffc0202c5e:	1be50513          	addi	a0,a0,446 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202c62:	ff8fd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0202c66:	00002697          	auipc	a3,0x2
ffffffffc0202c6a:	37a68693          	addi	a3,a3,890 # ffffffffc0204fe0 <default_pmm_manager+0x318>
ffffffffc0202c6e:	00002617          	auipc	a2,0x2
ffffffffc0202c72:	caa60613          	addi	a2,a2,-854 # ffffffffc0204918 <commands+0x818>
ffffffffc0202c76:	17000593          	li	a1,368
ffffffffc0202c7a:	00002517          	auipc	a0,0x2
ffffffffc0202c7e:	19e50513          	addi	a0,a0,414 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202c82:	fd8fd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0202c86:	00002697          	auipc	a3,0x2
ffffffffc0202c8a:	34268693          	addi	a3,a3,834 # ffffffffc0204fc8 <default_pmm_manager+0x300>
ffffffffc0202c8e:	00002617          	auipc	a2,0x2
ffffffffc0202c92:	c8a60613          	addi	a2,a2,-886 # ffffffffc0204918 <commands+0x818>
ffffffffc0202c96:	16f00593          	li	a1,367
ffffffffc0202c9a:	00002517          	auipc	a0,0x2
ffffffffc0202c9e:	17e50513          	addi	a0,a0,382 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202ca2:	fb8fd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0202ca6:	00002697          	auipc	a3,0x2
ffffffffc0202caa:	6d268693          	addi	a3,a3,1746 # ffffffffc0205378 <default_pmm_manager+0x6b0>
ffffffffc0202cae:	00002617          	auipc	a2,0x2
ffffffffc0202cb2:	c6a60613          	addi	a2,a2,-918 # ffffffffc0204918 <commands+0x818>
ffffffffc0202cb6:	1b600593          	li	a1,438
ffffffffc0202cba:	00002517          	auipc	a0,0x2
ffffffffc0202cbe:	15e50513          	addi	a0,a0,350 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202cc2:	f98fd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0202cc6:	00002697          	auipc	a3,0x2
ffffffffc0202cca:	67a68693          	addi	a3,a3,1658 # ffffffffc0205340 <default_pmm_manager+0x678>
ffffffffc0202cce:	00002617          	auipc	a2,0x2
ffffffffc0202cd2:	c4a60613          	addi	a2,a2,-950 # ffffffffc0204918 <commands+0x818>
ffffffffc0202cd6:	1b300593          	li	a1,435
ffffffffc0202cda:	00002517          	auipc	a0,0x2
ffffffffc0202cde:	13e50513          	addi	a0,a0,318 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202ce2:	f78fd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0202ce6:	00002697          	auipc	a3,0x2
ffffffffc0202cea:	62a68693          	addi	a3,a3,1578 # ffffffffc0205310 <default_pmm_manager+0x648>
ffffffffc0202cee:	00002617          	auipc	a2,0x2
ffffffffc0202cf2:	c2a60613          	addi	a2,a2,-982 # ffffffffc0204918 <commands+0x818>
ffffffffc0202cf6:	1af00593          	li	a1,431
ffffffffc0202cfa:	00002517          	auipc	a0,0x2
ffffffffc0202cfe:	11e50513          	addi	a0,a0,286 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202d02:	f58fd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0202d06:	00002697          	auipc	a3,0x2
ffffffffc0202d0a:	5c268693          	addi	a3,a3,1474 # ffffffffc02052c8 <default_pmm_manager+0x600>
ffffffffc0202d0e:	00002617          	auipc	a2,0x2
ffffffffc0202d12:	c0a60613          	addi	a2,a2,-1014 # ffffffffc0204918 <commands+0x818>
ffffffffc0202d16:	1ae00593          	li	a1,430
ffffffffc0202d1a:	00002517          	auipc	a0,0x2
ffffffffc0202d1e:	0fe50513          	addi	a0,a0,254 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202d22:	f38fd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0202d26:	00002617          	auipc	a2,0x2
ffffffffc0202d2a:	08260613          	addi	a2,a2,130 # ffffffffc0204da8 <default_pmm_manager+0xe0>
ffffffffc0202d2e:	0cb00593          	li	a1,203
ffffffffc0202d32:	00002517          	auipc	a0,0x2
ffffffffc0202d36:	0e650513          	addi	a0,a0,230 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202d3a:	f20fd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0202d3e:	00002617          	auipc	a2,0x2
ffffffffc0202d42:	06a60613          	addi	a2,a2,106 # ffffffffc0204da8 <default_pmm_manager+0xe0>
ffffffffc0202d46:	08000593          	li	a1,128
ffffffffc0202d4a:	00002517          	auipc	a0,0x2
ffffffffc0202d4e:	0ce50513          	addi	a0,a0,206 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202d52:	f08fd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0202d56:	00002697          	auipc	a3,0x2
ffffffffc0202d5a:	24268693          	addi	a3,a3,578 # ffffffffc0204f98 <default_pmm_manager+0x2d0>
ffffffffc0202d5e:	00002617          	auipc	a2,0x2
ffffffffc0202d62:	bba60613          	addi	a2,a2,-1094 # ffffffffc0204918 <commands+0x818>
ffffffffc0202d66:	16e00593          	li	a1,366
ffffffffc0202d6a:	00002517          	auipc	a0,0x2
ffffffffc0202d6e:	0ae50513          	addi	a0,a0,174 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202d72:	ee8fd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0202d76:	00002697          	auipc	a3,0x2
ffffffffc0202d7a:	1f268693          	addi	a3,a3,498 # ffffffffc0204f68 <default_pmm_manager+0x2a0>
ffffffffc0202d7e:	00002617          	auipc	a2,0x2
ffffffffc0202d82:	b9a60613          	addi	a2,a2,-1126 # ffffffffc0204918 <commands+0x818>
ffffffffc0202d86:	16b00593          	li	a1,363
ffffffffc0202d8a:	00002517          	auipc	a0,0x2
ffffffffc0202d8e:	08e50513          	addi	a0,a0,142 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202d92:	ec8fd0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc0202d96 <check_vma_overlap.part.0>:
ffffffffc0202d96:	1141                	addi	sp,sp,-16
ffffffffc0202d98:	00002697          	auipc	a3,0x2
ffffffffc0202d9c:	62868693          	addi	a3,a3,1576 # ffffffffc02053c0 <default_pmm_manager+0x6f8>
ffffffffc0202da0:	00002617          	auipc	a2,0x2
ffffffffc0202da4:	b7860613          	addi	a2,a2,-1160 # ffffffffc0204918 <commands+0x818>
ffffffffc0202da8:	08800593          	li	a1,136
ffffffffc0202dac:	00002517          	auipc	a0,0x2
ffffffffc0202db0:	63450513          	addi	a0,a0,1588 # ffffffffc02053e0 <default_pmm_manager+0x718>
ffffffffc0202db4:	e406                	sd	ra,8(sp)
ffffffffc0202db6:	ea4fd0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc0202dba <find_vma>:
ffffffffc0202dba:	86aa                	mv	a3,a0
ffffffffc0202dbc:	c505                	beqz	a0,ffffffffc0202de4 <find_vma+0x2a>
ffffffffc0202dbe:	6908                	ld	a0,16(a0)
ffffffffc0202dc0:	c501                	beqz	a0,ffffffffc0202dc8 <find_vma+0xe>
ffffffffc0202dc2:	651c                	ld	a5,8(a0)
ffffffffc0202dc4:	02f5f263          	bgeu	a1,a5,ffffffffc0202de8 <find_vma+0x2e>
ffffffffc0202dc8:	669c                	ld	a5,8(a3)
ffffffffc0202dca:	00f68d63          	beq	a3,a5,ffffffffc0202de4 <find_vma+0x2a>
ffffffffc0202dce:	fe87b703          	ld	a4,-24(a5) # ffffffffc7ffffe8 <end+0x7df2afc>
ffffffffc0202dd2:	00e5e663          	bltu	a1,a4,ffffffffc0202dde <find_vma+0x24>
ffffffffc0202dd6:	ff07b703          	ld	a4,-16(a5)
ffffffffc0202dda:	00e5ec63          	bltu	a1,a4,ffffffffc0202df2 <find_vma+0x38>
ffffffffc0202dde:	679c                	ld	a5,8(a5)
ffffffffc0202de0:	fef697e3          	bne	a3,a5,ffffffffc0202dce <find_vma+0x14>
ffffffffc0202de4:	4501                	li	a0,0
ffffffffc0202de6:	8082                	ret
ffffffffc0202de8:	691c                	ld	a5,16(a0)
ffffffffc0202dea:	fcf5ffe3          	bgeu	a1,a5,ffffffffc0202dc8 <find_vma+0xe>
ffffffffc0202dee:	ea88                	sd	a0,16(a3)
ffffffffc0202df0:	8082                	ret
ffffffffc0202df2:	fe078513          	addi	a0,a5,-32
ffffffffc0202df6:	ea88                	sd	a0,16(a3)
ffffffffc0202df8:	8082                	ret

ffffffffc0202dfa <insert_vma_struct>:
ffffffffc0202dfa:	6590                	ld	a2,8(a1)
ffffffffc0202dfc:	0105b803          	ld	a6,16(a1)
ffffffffc0202e00:	1141                	addi	sp,sp,-16
ffffffffc0202e02:	e406                	sd	ra,8(sp)
ffffffffc0202e04:	87aa                	mv	a5,a0
ffffffffc0202e06:	01066763          	bltu	a2,a6,ffffffffc0202e14 <insert_vma_struct+0x1a>
ffffffffc0202e0a:	a085                	j	ffffffffc0202e6a <insert_vma_struct+0x70>
ffffffffc0202e0c:	fe87b703          	ld	a4,-24(a5)
ffffffffc0202e10:	04e66863          	bltu	a2,a4,ffffffffc0202e60 <insert_vma_struct+0x66>
ffffffffc0202e14:	86be                	mv	a3,a5
ffffffffc0202e16:	679c                	ld	a5,8(a5)
ffffffffc0202e18:	fef51ae3          	bne	a0,a5,ffffffffc0202e0c <insert_vma_struct+0x12>
ffffffffc0202e1c:	02a68463          	beq	a3,a0,ffffffffc0202e44 <insert_vma_struct+0x4a>
ffffffffc0202e20:	ff06b703          	ld	a4,-16(a3)
ffffffffc0202e24:	fe86b883          	ld	a7,-24(a3)
ffffffffc0202e28:	08e8f163          	bgeu	a7,a4,ffffffffc0202eaa <insert_vma_struct+0xb0>
ffffffffc0202e2c:	04e66f63          	bltu	a2,a4,ffffffffc0202e8a <insert_vma_struct+0x90>
ffffffffc0202e30:	00f50a63          	beq	a0,a5,ffffffffc0202e44 <insert_vma_struct+0x4a>
ffffffffc0202e34:	fe87b703          	ld	a4,-24(a5)
ffffffffc0202e38:	05076963          	bltu	a4,a6,ffffffffc0202e8a <insert_vma_struct+0x90>
ffffffffc0202e3c:	ff07b603          	ld	a2,-16(a5)
ffffffffc0202e40:	02c77363          	bgeu	a4,a2,ffffffffc0202e66 <insert_vma_struct+0x6c>
ffffffffc0202e44:	5118                	lw	a4,32(a0)
ffffffffc0202e46:	e188                	sd	a0,0(a1)
ffffffffc0202e48:	02058613          	addi	a2,a1,32
ffffffffc0202e4c:	e390                	sd	a2,0(a5)
ffffffffc0202e4e:	e690                	sd	a2,8(a3)
ffffffffc0202e50:	60a2                	ld	ra,8(sp)
ffffffffc0202e52:	f59c                	sd	a5,40(a1)
ffffffffc0202e54:	f194                	sd	a3,32(a1)
ffffffffc0202e56:	0017079b          	addiw	a5,a4,1
ffffffffc0202e5a:	d11c                	sw	a5,32(a0)
ffffffffc0202e5c:	0141                	addi	sp,sp,16
ffffffffc0202e5e:	8082                	ret
ffffffffc0202e60:	fca690e3          	bne	a3,a0,ffffffffc0202e20 <insert_vma_struct+0x26>
ffffffffc0202e64:	bfd1                	j	ffffffffc0202e38 <insert_vma_struct+0x3e>
ffffffffc0202e66:	f31ff0ef          	jal	ra,ffffffffc0202d96 <check_vma_overlap.part.0>
ffffffffc0202e6a:	00002697          	auipc	a3,0x2
ffffffffc0202e6e:	58668693          	addi	a3,a3,1414 # ffffffffc02053f0 <default_pmm_manager+0x728>
ffffffffc0202e72:	00002617          	auipc	a2,0x2
ffffffffc0202e76:	aa660613          	addi	a2,a2,-1370 # ffffffffc0204918 <commands+0x818>
ffffffffc0202e7a:	08e00593          	li	a1,142
ffffffffc0202e7e:	00002517          	auipc	a0,0x2
ffffffffc0202e82:	56250513          	addi	a0,a0,1378 # ffffffffc02053e0 <default_pmm_manager+0x718>
ffffffffc0202e86:	dd4fd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0202e8a:	00002697          	auipc	a3,0x2
ffffffffc0202e8e:	5a668693          	addi	a3,a3,1446 # ffffffffc0205430 <default_pmm_manager+0x768>
ffffffffc0202e92:	00002617          	auipc	a2,0x2
ffffffffc0202e96:	a8660613          	addi	a2,a2,-1402 # ffffffffc0204918 <commands+0x818>
ffffffffc0202e9a:	08700593          	li	a1,135
ffffffffc0202e9e:	00002517          	auipc	a0,0x2
ffffffffc0202ea2:	54250513          	addi	a0,a0,1346 # ffffffffc02053e0 <default_pmm_manager+0x718>
ffffffffc0202ea6:	db4fd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0202eaa:	00002697          	auipc	a3,0x2
ffffffffc0202eae:	56668693          	addi	a3,a3,1382 # ffffffffc0205410 <default_pmm_manager+0x748>
ffffffffc0202eb2:	00002617          	auipc	a2,0x2
ffffffffc0202eb6:	a6660613          	addi	a2,a2,-1434 # ffffffffc0204918 <commands+0x818>
ffffffffc0202eba:	08600593          	li	a1,134
ffffffffc0202ebe:	00002517          	auipc	a0,0x2
ffffffffc0202ec2:	52250513          	addi	a0,a0,1314 # ffffffffc02053e0 <default_pmm_manager+0x718>
ffffffffc0202ec6:	d94fd0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc0202eca <vmm_init>:
ffffffffc0202eca:	7139                	addi	sp,sp,-64
ffffffffc0202ecc:	03000513          	li	a0,48
ffffffffc0202ed0:	fc06                	sd	ra,56(sp)
ffffffffc0202ed2:	f822                	sd	s0,48(sp)
ffffffffc0202ed4:	f426                	sd	s1,40(sp)
ffffffffc0202ed6:	f04a                	sd	s2,32(sp)
ffffffffc0202ed8:	ec4e                	sd	s3,24(sp)
ffffffffc0202eda:	e852                	sd	s4,16(sp)
ffffffffc0202edc:	e456                	sd	s5,8(sp)
ffffffffc0202ede:	bd5fe0ef          	jal	ra,ffffffffc0201ab2 <kmalloc>
ffffffffc0202ee2:	2e050f63          	beqz	a0,ffffffffc02031e0 <vmm_init+0x316>
ffffffffc0202ee6:	84aa                	mv	s1,a0
ffffffffc0202ee8:	e508                	sd	a0,8(a0)
ffffffffc0202eea:	e108                	sd	a0,0(a0)
ffffffffc0202eec:	00053823          	sd	zero,16(a0)
ffffffffc0202ef0:	00053c23          	sd	zero,24(a0)
ffffffffc0202ef4:	02052023          	sw	zero,32(a0)
ffffffffc0202ef8:	02053423          	sd	zero,40(a0)
ffffffffc0202efc:	03200413          	li	s0,50
ffffffffc0202f00:	a811                	j	ffffffffc0202f14 <vmm_init+0x4a>
ffffffffc0202f02:	e500                	sd	s0,8(a0)
ffffffffc0202f04:	e91c                	sd	a5,16(a0)
ffffffffc0202f06:	00052c23          	sw	zero,24(a0)
ffffffffc0202f0a:	146d                	addi	s0,s0,-5
ffffffffc0202f0c:	8526                	mv	a0,s1
ffffffffc0202f0e:	eedff0ef          	jal	ra,ffffffffc0202dfa <insert_vma_struct>
ffffffffc0202f12:	c80d                	beqz	s0,ffffffffc0202f44 <vmm_init+0x7a>
ffffffffc0202f14:	03000513          	li	a0,48
ffffffffc0202f18:	b9bfe0ef          	jal	ra,ffffffffc0201ab2 <kmalloc>
ffffffffc0202f1c:	85aa                	mv	a1,a0
ffffffffc0202f1e:	00240793          	addi	a5,s0,2
ffffffffc0202f22:	f165                	bnez	a0,ffffffffc0202f02 <vmm_init+0x38>
ffffffffc0202f24:	00002697          	auipc	a3,0x2
ffffffffc0202f28:	6a468693          	addi	a3,a3,1700 # ffffffffc02055c8 <default_pmm_manager+0x900>
ffffffffc0202f2c:	00002617          	auipc	a2,0x2
ffffffffc0202f30:	9ec60613          	addi	a2,a2,-1556 # ffffffffc0204918 <commands+0x818>
ffffffffc0202f34:	0da00593          	li	a1,218
ffffffffc0202f38:	00002517          	auipc	a0,0x2
ffffffffc0202f3c:	4a850513          	addi	a0,a0,1192 # ffffffffc02053e0 <default_pmm_manager+0x718>
ffffffffc0202f40:	d1afd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0202f44:	03700413          	li	s0,55
ffffffffc0202f48:	1f900913          	li	s2,505
ffffffffc0202f4c:	a819                	j	ffffffffc0202f62 <vmm_init+0x98>
ffffffffc0202f4e:	e500                	sd	s0,8(a0)
ffffffffc0202f50:	e91c                	sd	a5,16(a0)
ffffffffc0202f52:	00052c23          	sw	zero,24(a0)
ffffffffc0202f56:	0415                	addi	s0,s0,5
ffffffffc0202f58:	8526                	mv	a0,s1
ffffffffc0202f5a:	ea1ff0ef          	jal	ra,ffffffffc0202dfa <insert_vma_struct>
ffffffffc0202f5e:	03240a63          	beq	s0,s2,ffffffffc0202f92 <vmm_init+0xc8>
ffffffffc0202f62:	03000513          	li	a0,48
ffffffffc0202f66:	b4dfe0ef          	jal	ra,ffffffffc0201ab2 <kmalloc>
ffffffffc0202f6a:	85aa                	mv	a1,a0
ffffffffc0202f6c:	00240793          	addi	a5,s0,2
ffffffffc0202f70:	fd79                	bnez	a0,ffffffffc0202f4e <vmm_init+0x84>
ffffffffc0202f72:	00002697          	auipc	a3,0x2
ffffffffc0202f76:	65668693          	addi	a3,a3,1622 # ffffffffc02055c8 <default_pmm_manager+0x900>
ffffffffc0202f7a:	00002617          	auipc	a2,0x2
ffffffffc0202f7e:	99e60613          	addi	a2,a2,-1634 # ffffffffc0204918 <commands+0x818>
ffffffffc0202f82:	0e100593          	li	a1,225
ffffffffc0202f86:	00002517          	auipc	a0,0x2
ffffffffc0202f8a:	45a50513          	addi	a0,a0,1114 # ffffffffc02053e0 <default_pmm_manager+0x718>
ffffffffc0202f8e:	cccfd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0202f92:	649c                	ld	a5,8(s1)
ffffffffc0202f94:	471d                	li	a4,7
ffffffffc0202f96:	1fb00593          	li	a1,507
ffffffffc0202f9a:	18f48363          	beq	s1,a5,ffffffffc0203120 <vmm_init+0x256>
ffffffffc0202f9e:	fe87b603          	ld	a2,-24(a5)
ffffffffc0202fa2:	ffe70693          	addi	a3,a4,-2 # ffe <kern_entry-0xffffffffc01ff002>
ffffffffc0202fa6:	10d61d63          	bne	a2,a3,ffffffffc02030c0 <vmm_init+0x1f6>
ffffffffc0202faa:	ff07b683          	ld	a3,-16(a5)
ffffffffc0202fae:	10e69963          	bne	a3,a4,ffffffffc02030c0 <vmm_init+0x1f6>
ffffffffc0202fb2:	0715                	addi	a4,a4,5
ffffffffc0202fb4:	679c                	ld	a5,8(a5)
ffffffffc0202fb6:	feb712e3          	bne	a4,a1,ffffffffc0202f9a <vmm_init+0xd0>
ffffffffc0202fba:	4a1d                	li	s4,7
ffffffffc0202fbc:	4415                	li	s0,5
ffffffffc0202fbe:	1f900a93          	li	s5,505
ffffffffc0202fc2:	85a2                	mv	a1,s0
ffffffffc0202fc4:	8526                	mv	a0,s1
ffffffffc0202fc6:	df5ff0ef          	jal	ra,ffffffffc0202dba <find_vma>
ffffffffc0202fca:	892a                	mv	s2,a0
ffffffffc0202fcc:	18050a63          	beqz	a0,ffffffffc0203160 <vmm_init+0x296>
ffffffffc0202fd0:	00140593          	addi	a1,s0,1
ffffffffc0202fd4:	8526                	mv	a0,s1
ffffffffc0202fd6:	de5ff0ef          	jal	ra,ffffffffc0202dba <find_vma>
ffffffffc0202fda:	89aa                	mv	s3,a0
ffffffffc0202fdc:	16050263          	beqz	a0,ffffffffc0203140 <vmm_init+0x276>
ffffffffc0202fe0:	85d2                	mv	a1,s4
ffffffffc0202fe2:	8526                	mv	a0,s1
ffffffffc0202fe4:	dd7ff0ef          	jal	ra,ffffffffc0202dba <find_vma>
ffffffffc0202fe8:	18051c63          	bnez	a0,ffffffffc0203180 <vmm_init+0x2b6>
ffffffffc0202fec:	00340593          	addi	a1,s0,3
ffffffffc0202ff0:	8526                	mv	a0,s1
ffffffffc0202ff2:	dc9ff0ef          	jal	ra,ffffffffc0202dba <find_vma>
ffffffffc0202ff6:	1c051563          	bnez	a0,ffffffffc02031c0 <vmm_init+0x2f6>
ffffffffc0202ffa:	00440593          	addi	a1,s0,4
ffffffffc0202ffe:	8526                	mv	a0,s1
ffffffffc0203000:	dbbff0ef          	jal	ra,ffffffffc0202dba <find_vma>
ffffffffc0203004:	18051e63          	bnez	a0,ffffffffc02031a0 <vmm_init+0x2d6>
ffffffffc0203008:	00893783          	ld	a5,8(s2)
ffffffffc020300c:	0c879a63          	bne	a5,s0,ffffffffc02030e0 <vmm_init+0x216>
ffffffffc0203010:	01093783          	ld	a5,16(s2)
ffffffffc0203014:	0d479663          	bne	a5,s4,ffffffffc02030e0 <vmm_init+0x216>
ffffffffc0203018:	0089b783          	ld	a5,8(s3)
ffffffffc020301c:	0e879263          	bne	a5,s0,ffffffffc0203100 <vmm_init+0x236>
ffffffffc0203020:	0109b783          	ld	a5,16(s3)
ffffffffc0203024:	0d479e63          	bne	a5,s4,ffffffffc0203100 <vmm_init+0x236>
ffffffffc0203028:	0415                	addi	s0,s0,5
ffffffffc020302a:	0a15                	addi	s4,s4,5
ffffffffc020302c:	f9541be3          	bne	s0,s5,ffffffffc0202fc2 <vmm_init+0xf8>
ffffffffc0203030:	4411                	li	s0,4
ffffffffc0203032:	597d                	li	s2,-1
ffffffffc0203034:	85a2                	mv	a1,s0
ffffffffc0203036:	8526                	mv	a0,s1
ffffffffc0203038:	d83ff0ef          	jal	ra,ffffffffc0202dba <find_vma>
ffffffffc020303c:	0004059b          	sext.w	a1,s0
ffffffffc0203040:	c90d                	beqz	a0,ffffffffc0203072 <vmm_init+0x1a8>
ffffffffc0203042:	6914                	ld	a3,16(a0)
ffffffffc0203044:	6510                	ld	a2,8(a0)
ffffffffc0203046:	00002517          	auipc	a0,0x2
ffffffffc020304a:	50a50513          	addi	a0,a0,1290 # ffffffffc0205550 <default_pmm_manager+0x888>
ffffffffc020304e:	946fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0203052:	00002697          	auipc	a3,0x2
ffffffffc0203056:	52668693          	addi	a3,a3,1318 # ffffffffc0205578 <default_pmm_manager+0x8b0>
ffffffffc020305a:	00002617          	auipc	a2,0x2
ffffffffc020305e:	8be60613          	addi	a2,a2,-1858 # ffffffffc0204918 <commands+0x818>
ffffffffc0203062:	10700593          	li	a1,263
ffffffffc0203066:	00002517          	auipc	a0,0x2
ffffffffc020306a:	37a50513          	addi	a0,a0,890 # ffffffffc02053e0 <default_pmm_manager+0x718>
ffffffffc020306e:	becfd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0203072:	147d                	addi	s0,s0,-1
ffffffffc0203074:	fd2410e3          	bne	s0,s2,ffffffffc0203034 <vmm_init+0x16a>
ffffffffc0203078:	6488                	ld	a0,8(s1)
ffffffffc020307a:	00a48c63          	beq	s1,a0,ffffffffc0203092 <vmm_init+0x1c8>
ffffffffc020307e:	6118                	ld	a4,0(a0)
ffffffffc0203080:	651c                	ld	a5,8(a0)
ffffffffc0203082:	1501                	addi	a0,a0,-32
ffffffffc0203084:	e71c                	sd	a5,8(a4)
ffffffffc0203086:	e398                	sd	a4,0(a5)
ffffffffc0203088:	adbfe0ef          	jal	ra,ffffffffc0201b62 <kfree>
ffffffffc020308c:	6488                	ld	a0,8(s1)
ffffffffc020308e:	fea498e3          	bne	s1,a0,ffffffffc020307e <vmm_init+0x1b4>
ffffffffc0203092:	8526                	mv	a0,s1
ffffffffc0203094:	acffe0ef          	jal	ra,ffffffffc0201b62 <kfree>
ffffffffc0203098:	00002517          	auipc	a0,0x2
ffffffffc020309c:	4f850513          	addi	a0,a0,1272 # ffffffffc0205590 <default_pmm_manager+0x8c8>
ffffffffc02030a0:	8f4fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02030a4:	7442                	ld	s0,48(sp)
ffffffffc02030a6:	70e2                	ld	ra,56(sp)
ffffffffc02030a8:	74a2                	ld	s1,40(sp)
ffffffffc02030aa:	7902                	ld	s2,32(sp)
ffffffffc02030ac:	69e2                	ld	s3,24(sp)
ffffffffc02030ae:	6a42                	ld	s4,16(sp)
ffffffffc02030b0:	6aa2                	ld	s5,8(sp)
ffffffffc02030b2:	00002517          	auipc	a0,0x2
ffffffffc02030b6:	4fe50513          	addi	a0,a0,1278 # ffffffffc02055b0 <default_pmm_manager+0x8e8>
ffffffffc02030ba:	6121                	addi	sp,sp,64
ffffffffc02030bc:	8d8fd06f          	j	ffffffffc0200194 <cprintf>
ffffffffc02030c0:	00002697          	auipc	a3,0x2
ffffffffc02030c4:	3a868693          	addi	a3,a3,936 # ffffffffc0205468 <default_pmm_manager+0x7a0>
ffffffffc02030c8:	00002617          	auipc	a2,0x2
ffffffffc02030cc:	85060613          	addi	a2,a2,-1968 # ffffffffc0204918 <commands+0x818>
ffffffffc02030d0:	0eb00593          	li	a1,235
ffffffffc02030d4:	00002517          	auipc	a0,0x2
ffffffffc02030d8:	30c50513          	addi	a0,a0,780 # ffffffffc02053e0 <default_pmm_manager+0x718>
ffffffffc02030dc:	b7efd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc02030e0:	00002697          	auipc	a3,0x2
ffffffffc02030e4:	41068693          	addi	a3,a3,1040 # ffffffffc02054f0 <default_pmm_manager+0x828>
ffffffffc02030e8:	00002617          	auipc	a2,0x2
ffffffffc02030ec:	83060613          	addi	a2,a2,-2000 # ffffffffc0204918 <commands+0x818>
ffffffffc02030f0:	0fc00593          	li	a1,252
ffffffffc02030f4:	00002517          	auipc	a0,0x2
ffffffffc02030f8:	2ec50513          	addi	a0,a0,748 # ffffffffc02053e0 <default_pmm_manager+0x718>
ffffffffc02030fc:	b5efd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0203100:	00002697          	auipc	a3,0x2
ffffffffc0203104:	42068693          	addi	a3,a3,1056 # ffffffffc0205520 <default_pmm_manager+0x858>
ffffffffc0203108:	00002617          	auipc	a2,0x2
ffffffffc020310c:	81060613          	addi	a2,a2,-2032 # ffffffffc0204918 <commands+0x818>
ffffffffc0203110:	0fd00593          	li	a1,253
ffffffffc0203114:	00002517          	auipc	a0,0x2
ffffffffc0203118:	2cc50513          	addi	a0,a0,716 # ffffffffc02053e0 <default_pmm_manager+0x718>
ffffffffc020311c:	b3efd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0203120:	00002697          	auipc	a3,0x2
ffffffffc0203124:	33068693          	addi	a3,a3,816 # ffffffffc0205450 <default_pmm_manager+0x788>
ffffffffc0203128:	00001617          	auipc	a2,0x1
ffffffffc020312c:	7f060613          	addi	a2,a2,2032 # ffffffffc0204918 <commands+0x818>
ffffffffc0203130:	0e900593          	li	a1,233
ffffffffc0203134:	00002517          	auipc	a0,0x2
ffffffffc0203138:	2ac50513          	addi	a0,a0,684 # ffffffffc02053e0 <default_pmm_manager+0x718>
ffffffffc020313c:	b1efd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0203140:	00002697          	auipc	a3,0x2
ffffffffc0203144:	37068693          	addi	a3,a3,880 # ffffffffc02054b0 <default_pmm_manager+0x7e8>
ffffffffc0203148:	00001617          	auipc	a2,0x1
ffffffffc020314c:	7d060613          	addi	a2,a2,2000 # ffffffffc0204918 <commands+0x818>
ffffffffc0203150:	0f400593          	li	a1,244
ffffffffc0203154:	00002517          	auipc	a0,0x2
ffffffffc0203158:	28c50513          	addi	a0,a0,652 # ffffffffc02053e0 <default_pmm_manager+0x718>
ffffffffc020315c:	afefd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0203160:	00002697          	auipc	a3,0x2
ffffffffc0203164:	34068693          	addi	a3,a3,832 # ffffffffc02054a0 <default_pmm_manager+0x7d8>
ffffffffc0203168:	00001617          	auipc	a2,0x1
ffffffffc020316c:	7b060613          	addi	a2,a2,1968 # ffffffffc0204918 <commands+0x818>
ffffffffc0203170:	0f200593          	li	a1,242
ffffffffc0203174:	00002517          	auipc	a0,0x2
ffffffffc0203178:	26c50513          	addi	a0,a0,620 # ffffffffc02053e0 <default_pmm_manager+0x718>
ffffffffc020317c:	adefd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0203180:	00002697          	auipc	a3,0x2
ffffffffc0203184:	34068693          	addi	a3,a3,832 # ffffffffc02054c0 <default_pmm_manager+0x7f8>
ffffffffc0203188:	00001617          	auipc	a2,0x1
ffffffffc020318c:	79060613          	addi	a2,a2,1936 # ffffffffc0204918 <commands+0x818>
ffffffffc0203190:	0f600593          	li	a1,246
ffffffffc0203194:	00002517          	auipc	a0,0x2
ffffffffc0203198:	24c50513          	addi	a0,a0,588 # ffffffffc02053e0 <default_pmm_manager+0x718>
ffffffffc020319c:	abefd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc02031a0:	00002697          	auipc	a3,0x2
ffffffffc02031a4:	34068693          	addi	a3,a3,832 # ffffffffc02054e0 <default_pmm_manager+0x818>
ffffffffc02031a8:	00001617          	auipc	a2,0x1
ffffffffc02031ac:	77060613          	addi	a2,a2,1904 # ffffffffc0204918 <commands+0x818>
ffffffffc02031b0:	0fa00593          	li	a1,250
ffffffffc02031b4:	00002517          	auipc	a0,0x2
ffffffffc02031b8:	22c50513          	addi	a0,a0,556 # ffffffffc02053e0 <default_pmm_manager+0x718>
ffffffffc02031bc:	a9efd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc02031c0:	00002697          	auipc	a3,0x2
ffffffffc02031c4:	31068693          	addi	a3,a3,784 # ffffffffc02054d0 <default_pmm_manager+0x808>
ffffffffc02031c8:	00001617          	auipc	a2,0x1
ffffffffc02031cc:	75060613          	addi	a2,a2,1872 # ffffffffc0204918 <commands+0x818>
ffffffffc02031d0:	0f800593          	li	a1,248
ffffffffc02031d4:	00002517          	auipc	a0,0x2
ffffffffc02031d8:	20c50513          	addi	a0,a0,524 # ffffffffc02053e0 <default_pmm_manager+0x718>
ffffffffc02031dc:	a7efd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc02031e0:	00002697          	auipc	a3,0x2
ffffffffc02031e4:	3f868693          	addi	a3,a3,1016 # ffffffffc02055d8 <default_pmm_manager+0x910>
ffffffffc02031e8:	00001617          	auipc	a2,0x1
ffffffffc02031ec:	73060613          	addi	a2,a2,1840 # ffffffffc0204918 <commands+0x818>
ffffffffc02031f0:	0d200593          	li	a1,210
ffffffffc02031f4:	00002517          	auipc	a0,0x2
ffffffffc02031f8:	1ec50513          	addi	a0,a0,492 # ffffffffc02053e0 <default_pmm_manager+0x718>
ffffffffc02031fc:	a5efd0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc0203200 <kernel_thread_entry>:
ffffffffc0203200:	8526                	mv	a0,s1
ffffffffc0203202:	9402                	jalr	s0
ffffffffc0203204:	3ea000ef          	jal	ra,ffffffffc02035ee <do_exit>

ffffffffc0203208 <alloc_proc>:
ffffffffc0203208:	1141                	addi	sp,sp,-16
ffffffffc020320a:	0e800513          	li	a0,232
ffffffffc020320e:	e022                	sd	s0,0(sp)
ffffffffc0203210:	e406                	sd	ra,8(sp)
ffffffffc0203212:	8a1fe0ef          	jal	ra,ffffffffc0201ab2 <kmalloc>
ffffffffc0203216:	842a                	mv	s0,a0
ffffffffc0203218:	c521                	beqz	a0,ffffffffc0203260 <alloc_proc+0x58>
ffffffffc020321a:	0000a797          	auipc	a5,0xa
ffffffffc020321e:	2867b783          	ld	a5,646(a5) # ffffffffc020d4a0 <boot_pgdir_pa>
ffffffffc0203222:	f55c                	sd	a5,168(a0)
ffffffffc0203224:	57fd                	li	a5,-1
ffffffffc0203226:	1782                	slli	a5,a5,0x20
ffffffffc0203228:	07000613          	li	a2,112
ffffffffc020322c:	4581                	li	a1,0
ffffffffc020322e:	e11c                	sd	a5,0(a0)
ffffffffc0203230:	00052423          	sw	zero,8(a0)
ffffffffc0203234:	00053823          	sd	zero,16(a0)
ffffffffc0203238:	00052c23          	sw	zero,24(a0)
ffffffffc020323c:	0a052823          	sw	zero,176(a0)
ffffffffc0203240:	02053023          	sd	zero,32(a0)
ffffffffc0203244:	02053423          	sd	zero,40(a0)
ffffffffc0203248:	0a053023          	sd	zero,160(a0)
ffffffffc020324c:	03050513          	addi	a0,a0,48
ffffffffc0203250:	3fb000ef          	jal	ra,ffffffffc0203e4a <memset>
ffffffffc0203254:	4641                	li	a2,16
ffffffffc0203256:	4581                	li	a1,0
ffffffffc0203258:	0b440513          	addi	a0,s0,180
ffffffffc020325c:	3ef000ef          	jal	ra,ffffffffc0203e4a <memset>
ffffffffc0203260:	60a2                	ld	ra,8(sp)
ffffffffc0203262:	8522                	mv	a0,s0
ffffffffc0203264:	6402                	ld	s0,0(sp)
ffffffffc0203266:	0141                	addi	sp,sp,16
ffffffffc0203268:	8082                	ret

ffffffffc020326a <forkret>:
ffffffffc020326a:	0000a797          	auipc	a5,0xa
ffffffffc020326e:	2667b783          	ld	a5,614(a5) # ffffffffc020d4d0 <current>
ffffffffc0203272:	73c8                	ld	a0,160(a5)
ffffffffc0203274:	b5dfd06f          	j	ffffffffc0200dd0 <forkrets>

ffffffffc0203278 <init_main>:
ffffffffc0203278:	7179                	addi	sp,sp,-48
ffffffffc020327a:	ec26                	sd	s1,24(sp)
ffffffffc020327c:	0000a497          	auipc	s1,0xa
ffffffffc0203280:	1cc48493          	addi	s1,s1,460 # ffffffffc020d448 <name.2>
ffffffffc0203284:	f022                	sd	s0,32(sp)
ffffffffc0203286:	e84a                	sd	s2,16(sp)
ffffffffc0203288:	842a                	mv	s0,a0
ffffffffc020328a:	0000a917          	auipc	s2,0xa
ffffffffc020328e:	24693903          	ld	s2,582(s2) # ffffffffc020d4d0 <current>
ffffffffc0203292:	4641                	li	a2,16
ffffffffc0203294:	4581                	li	a1,0
ffffffffc0203296:	8526                	mv	a0,s1
ffffffffc0203298:	f406                	sd	ra,40(sp)
ffffffffc020329a:	e44e                	sd	s3,8(sp)
ffffffffc020329c:	00492983          	lw	s3,4(s2)
ffffffffc02032a0:	3ab000ef          	jal	ra,ffffffffc0203e4a <memset>
ffffffffc02032a4:	0b490593          	addi	a1,s2,180
ffffffffc02032a8:	463d                	li	a2,15
ffffffffc02032aa:	8526                	mv	a0,s1
ffffffffc02032ac:	3b1000ef          	jal	ra,ffffffffc0203e5c <memcpy>
ffffffffc02032b0:	862a                	mv	a2,a0
ffffffffc02032b2:	85ce                	mv	a1,s3
ffffffffc02032b4:	00002517          	auipc	a0,0x2
ffffffffc02032b8:	33450513          	addi	a0,a0,820 # ffffffffc02055e8 <default_pmm_manager+0x920>
ffffffffc02032bc:	ed9fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02032c0:	85a2                	mv	a1,s0
ffffffffc02032c2:	00002517          	auipc	a0,0x2
ffffffffc02032c6:	34e50513          	addi	a0,a0,846 # ffffffffc0205610 <default_pmm_manager+0x948>
ffffffffc02032ca:	ecbfc0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02032ce:	00002517          	auipc	a0,0x2
ffffffffc02032d2:	35250513          	addi	a0,a0,850 # ffffffffc0205620 <default_pmm_manager+0x958>
ffffffffc02032d6:	ebffc0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02032da:	70a2                	ld	ra,40(sp)
ffffffffc02032dc:	7402                	ld	s0,32(sp)
ffffffffc02032de:	64e2                	ld	s1,24(sp)
ffffffffc02032e0:	6942                	ld	s2,16(sp)
ffffffffc02032e2:	69a2                	ld	s3,8(sp)
ffffffffc02032e4:	4501                	li	a0,0
ffffffffc02032e6:	6145                	addi	sp,sp,48
ffffffffc02032e8:	8082                	ret

ffffffffc02032ea <proc_run>:
ffffffffc02032ea:	7179                	addi	sp,sp,-48
ffffffffc02032ec:	ec4a                	sd	s2,24(sp)
ffffffffc02032ee:	0000a917          	auipc	s2,0xa
ffffffffc02032f2:	1e290913          	addi	s2,s2,482 # ffffffffc020d4d0 <current>
ffffffffc02032f6:	f026                	sd	s1,32(sp)
ffffffffc02032f8:	00093483          	ld	s1,0(s2)
ffffffffc02032fc:	f406                	sd	ra,40(sp)
ffffffffc02032fe:	e84e                	sd	s3,16(sp)
ffffffffc0203300:	02a48963          	beq	s1,a0,ffffffffc0203332 <proc_run+0x48>
ffffffffc0203304:	100027f3          	csrr	a5,sstatus
ffffffffc0203308:	8b89                	andi	a5,a5,2
ffffffffc020330a:	4981                	li	s3,0
ffffffffc020330c:	e3a1                	bnez	a5,ffffffffc020334c <proc_run+0x62>
ffffffffc020330e:	755c                	ld	a5,168(a0)
ffffffffc0203310:	80000737          	lui	a4,0x80000
ffffffffc0203314:	00a93023          	sd	a0,0(s2)
ffffffffc0203318:	00c7d79b          	srliw	a5,a5,0xc
ffffffffc020331c:	8fd9                	or	a5,a5,a4
ffffffffc020331e:	18079073          	csrw	satp,a5
ffffffffc0203322:	03050593          	addi	a1,a0,48
ffffffffc0203326:	03048513          	addi	a0,s1,48
ffffffffc020332a:	54a000ef          	jal	ra,ffffffffc0203874 <switch_to>
ffffffffc020332e:	00099863          	bnez	s3,ffffffffc020333e <proc_run+0x54>
ffffffffc0203332:	70a2                	ld	ra,40(sp)
ffffffffc0203334:	7482                	ld	s1,32(sp)
ffffffffc0203336:	6962                	ld	s2,24(sp)
ffffffffc0203338:	69c2                	ld	s3,16(sp)
ffffffffc020333a:	6145                	addi	sp,sp,48
ffffffffc020333c:	8082                	ret
ffffffffc020333e:	70a2                	ld	ra,40(sp)
ffffffffc0203340:	7482                	ld	s1,32(sp)
ffffffffc0203342:	6962                	ld	s2,24(sp)
ffffffffc0203344:	69c2                	ld	s3,16(sp)
ffffffffc0203346:	6145                	addi	sp,sp,48
ffffffffc0203348:	de2fd06f          	j	ffffffffc020092a <intr_enable>
ffffffffc020334c:	e42a                	sd	a0,8(sp)
ffffffffc020334e:	de2fd0ef          	jal	ra,ffffffffc0200930 <intr_disable>
ffffffffc0203352:	6522                	ld	a0,8(sp)
ffffffffc0203354:	4985                	li	s3,1
ffffffffc0203356:	bf65                	j	ffffffffc020330e <proc_run+0x24>

ffffffffc0203358 <do_fork>:
ffffffffc0203358:	7179                	addi	sp,sp,-48
ffffffffc020335a:	ec26                	sd	s1,24(sp)
ffffffffc020335c:	0000a497          	auipc	s1,0xa
ffffffffc0203360:	18c48493          	addi	s1,s1,396 # ffffffffc020d4e8 <nr_process>
ffffffffc0203364:	4098                	lw	a4,0(s1)
ffffffffc0203366:	f406                	sd	ra,40(sp)
ffffffffc0203368:	f022                	sd	s0,32(sp)
ffffffffc020336a:	e84a                	sd	s2,16(sp)
ffffffffc020336c:	e44e                	sd	s3,8(sp)
ffffffffc020336e:	6785                	lui	a5,0x1
ffffffffc0203370:	1ef75463          	bge	a4,a5,ffffffffc0203558 <do_fork+0x200>
ffffffffc0203374:	892e                	mv	s2,a1
ffffffffc0203376:	8432                	mv	s0,a2
ffffffffc0203378:	e91ff0ef          	jal	ra,ffffffffc0203208 <alloc_proc>
ffffffffc020337c:	89aa                	mv	s3,a0
ffffffffc020337e:	1e050263          	beqz	a0,ffffffffc0203562 <do_fork+0x20a>
ffffffffc0203382:	4509                	li	a0,2
ffffffffc0203384:	90dfe0ef          	jal	ra,ffffffffc0201c90 <alloc_pages>
ffffffffc0203388:	1c050363          	beqz	a0,ffffffffc020354e <do_fork+0x1f6>
ffffffffc020338c:	0000a697          	auipc	a3,0xa
ffffffffc0203390:	12c6b683          	ld	a3,300(a3) # ffffffffc020d4b8 <pages>
ffffffffc0203394:	40d506b3          	sub	a3,a0,a3
ffffffffc0203398:	8699                	srai	a3,a3,0x6
ffffffffc020339a:	00002517          	auipc	a0,0x2
ffffffffc020339e:	64653503          	ld	a0,1606(a0) # ffffffffc02059e0 <nbase>
ffffffffc02033a2:	96aa                	add	a3,a3,a0
ffffffffc02033a4:	00c69793          	slli	a5,a3,0xc
ffffffffc02033a8:	83b1                	srli	a5,a5,0xc
ffffffffc02033aa:	0000a717          	auipc	a4,0xa
ffffffffc02033ae:	10673703          	ld	a4,262(a4) # ffffffffc020d4b0 <npage>
ffffffffc02033b2:	06b2                	slli	a3,a3,0xc
ffffffffc02033b4:	1ce7f963          	bgeu	a5,a4,ffffffffc0203586 <do_fork+0x22e>
ffffffffc02033b8:	0000a317          	auipc	t1,0xa
ffffffffc02033bc:	11833303          	ld	t1,280(t1) # ffffffffc020d4d0 <current>
ffffffffc02033c0:	02833783          	ld	a5,40(t1)
ffffffffc02033c4:	0000a717          	auipc	a4,0xa
ffffffffc02033c8:	10473703          	ld	a4,260(a4) # ffffffffc020d4c8 <va_pa_offset>
ffffffffc02033cc:	96ba                	add	a3,a3,a4
ffffffffc02033ce:	00d9b823          	sd	a3,16(s3)
ffffffffc02033d2:	18079a63          	bnez	a5,ffffffffc0203566 <do_fork+0x20e>
ffffffffc02033d6:	6789                	lui	a5,0x2
ffffffffc02033d8:	ee078793          	addi	a5,a5,-288 # 1ee0 <kern_entry-0xffffffffc01fe120>
ffffffffc02033dc:	96be                	add	a3,a3,a5
ffffffffc02033de:	8622                	mv	a2,s0
ffffffffc02033e0:	0ad9b023          	sd	a3,160(s3)
ffffffffc02033e4:	87b6                	mv	a5,a3
ffffffffc02033e6:	12040893          	addi	a7,s0,288
ffffffffc02033ea:	00063803          	ld	a6,0(a2)
ffffffffc02033ee:	6608                	ld	a0,8(a2)
ffffffffc02033f0:	6a0c                	ld	a1,16(a2)
ffffffffc02033f2:	6e18                	ld	a4,24(a2)
ffffffffc02033f4:	0107b023          	sd	a6,0(a5)
ffffffffc02033f8:	e788                	sd	a0,8(a5)
ffffffffc02033fa:	eb8c                	sd	a1,16(a5)
ffffffffc02033fc:	ef98                	sd	a4,24(a5)
ffffffffc02033fe:	02060613          	addi	a2,a2,32
ffffffffc0203402:	02078793          	addi	a5,a5,32
ffffffffc0203406:	ff1612e3          	bne	a2,a7,ffffffffc02033ea <do_fork+0x92>
ffffffffc020340a:	0406b823          	sd	zero,80(a3)
ffffffffc020340e:	12090363          	beqz	s2,ffffffffc0203534 <do_fork+0x1dc>
ffffffffc0203412:	00006e17          	auipc	t3,0x6
ffffffffc0203416:	c16e0e13          	addi	t3,t3,-1002 # ffffffffc0209028 <last_pid.1>
ffffffffc020341a:	000e2783          	lw	a5,0(t3)
ffffffffc020341e:	0126b823          	sd	s2,16(a3)
ffffffffc0203422:	00000717          	auipc	a4,0x0
ffffffffc0203426:	e4870713          	addi	a4,a4,-440 # ffffffffc020326a <forkret>
ffffffffc020342a:	0017851b          	addiw	a0,a5,1
ffffffffc020342e:	0000a617          	auipc	a2,0xa
ffffffffc0203432:	02a60613          	addi	a2,a2,42 # ffffffffc020d458 <proc_list>
ffffffffc0203436:	02e9b823          	sd	a4,48(s3)
ffffffffc020343a:	02d9bc23          	sd	a3,56(s3)
ffffffffc020343e:	0269b023          	sd	t1,32(s3)
ffffffffc0203442:	00ae2023          	sw	a0,0(t3)
ffffffffc0203446:	6789                	lui	a5,0x2
ffffffffc0203448:	00863883          	ld	a7,8(a2)
ffffffffc020344c:	08f55263          	bge	a0,a5,ffffffffc02034d0 <do_fork+0x178>
ffffffffc0203450:	00006f17          	auipc	t5,0x6
ffffffffc0203454:	bdcf0f13          	addi	t5,t5,-1060 # ffffffffc020902c <next_safe.0>
ffffffffc0203458:	000f2783          	lw	a5,0(t5)
ffffffffc020345c:	08f55263          	bge	a0,a5,ffffffffc02034e0 <do_fork+0x188>
ffffffffc0203460:	0b032783          	lw	a5,176(t1)
ffffffffc0203464:	00a9a223          	sw	a0,4(s3)
ffffffffc0203468:	0009a423          	sw	zero,8(s3)
ffffffffc020346c:	0009a023          	sw	zero,0(s3)
ffffffffc0203470:	0af9a823          	sw	a5,176(s3)
ffffffffc0203474:	0c898793          	addi	a5,s3,200
ffffffffc0203478:	00f8b023          	sd	a5,0(a7)
ffffffffc020347c:	45a9                	li	a1,10
ffffffffc020347e:	0d19b823          	sd	a7,208(s3)
ffffffffc0203482:	0cc9b423          	sd	a2,200(s3)
ffffffffc0203486:	2501                	sext.w	a0,a0
ffffffffc0203488:	e61c                	sd	a5,8(a2)
ffffffffc020348a:	51a000ef          	jal	ra,ffffffffc02039a4 <hash32>
ffffffffc020348e:	02051793          	slli	a5,a0,0x20
ffffffffc0203492:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0203496:	00006797          	auipc	a5,0x6
ffffffffc020349a:	fb278793          	addi	a5,a5,-78 # ffffffffc0209448 <hash_list>
ffffffffc020349e:	953e                	add	a0,a0,a5
ffffffffc02034a0:	6518                	ld	a4,8(a0)
ffffffffc02034a2:	409c                	lw	a5,0(s1)
ffffffffc02034a4:	0d898693          	addi	a3,s3,216
ffffffffc02034a8:	e314                	sd	a3,0(a4)
ffffffffc02034aa:	e514                	sd	a3,8(a0)
ffffffffc02034ac:	2785                	addiw	a5,a5,1
ffffffffc02034ae:	0ca9bc23          	sd	a0,216(s3)
ffffffffc02034b2:	0ee9b023          	sd	a4,224(s3)
ffffffffc02034b6:	854e                	mv	a0,s3
ffffffffc02034b8:	c09c                	sw	a5,0(s1)
ffffffffc02034ba:	424000ef          	jal	ra,ffffffffc02038de <wakeup_proc>
ffffffffc02034be:	0049a503          	lw	a0,4(s3)
ffffffffc02034c2:	70a2                	ld	ra,40(sp)
ffffffffc02034c4:	7402                	ld	s0,32(sp)
ffffffffc02034c6:	64e2                	ld	s1,24(sp)
ffffffffc02034c8:	6942                	ld	s2,16(sp)
ffffffffc02034ca:	69a2                	ld	s3,8(sp)
ffffffffc02034cc:	6145                	addi	sp,sp,48
ffffffffc02034ce:	8082                	ret
ffffffffc02034d0:	4785                	li	a5,1
ffffffffc02034d2:	00fe2023          	sw	a5,0(t3)
ffffffffc02034d6:	4505                	li	a0,1
ffffffffc02034d8:	00006f17          	auipc	t5,0x6
ffffffffc02034dc:	b54f0f13          	addi	t5,t5,-1196 # ffffffffc020902c <next_safe.0>
ffffffffc02034e0:	6789                	lui	a5,0x2
ffffffffc02034e2:	00ff2023          	sw	a5,0(t5)
ffffffffc02034e6:	86aa                	mv	a3,a0
ffffffffc02034e8:	4801                	li	a6,0
ffffffffc02034ea:	6f89                	lui	t6,0x2
ffffffffc02034ec:	04c88b63          	beq	a7,a2,ffffffffc0203542 <do_fork+0x1ea>
ffffffffc02034f0:	8ec2                	mv	t4,a6
ffffffffc02034f2:	87c6                	mv	a5,a7
ffffffffc02034f4:	6589                	lui	a1,0x2
ffffffffc02034f6:	a811                	j	ffffffffc020350a <do_fork+0x1b2>
ffffffffc02034f8:	00e6d663          	bge	a3,a4,ffffffffc0203504 <do_fork+0x1ac>
ffffffffc02034fc:	00b75463          	bge	a4,a1,ffffffffc0203504 <do_fork+0x1ac>
ffffffffc0203500:	85ba                	mv	a1,a4
ffffffffc0203502:	4e85                	li	t4,1
ffffffffc0203504:	679c                	ld	a5,8(a5)
ffffffffc0203506:	00c78d63          	beq	a5,a2,ffffffffc0203520 <do_fork+0x1c8>
ffffffffc020350a:	f3c7a703          	lw	a4,-196(a5) # 1f3c <kern_entry-0xffffffffc01fe0c4>
ffffffffc020350e:	fed715e3          	bne	a4,a3,ffffffffc02034f8 <do_fork+0x1a0>
ffffffffc0203512:	2685                	addiw	a3,a3,1
ffffffffc0203514:	02b6d263          	bge	a3,a1,ffffffffc0203538 <do_fork+0x1e0>
ffffffffc0203518:	679c                	ld	a5,8(a5)
ffffffffc020351a:	4805                	li	a6,1
ffffffffc020351c:	fec797e3          	bne	a5,a2,ffffffffc020350a <do_fork+0x1b2>
ffffffffc0203520:	00080563          	beqz	a6,ffffffffc020352a <do_fork+0x1d2>
ffffffffc0203524:	00de2023          	sw	a3,0(t3)
ffffffffc0203528:	8536                	mv	a0,a3
ffffffffc020352a:	f20e8be3          	beqz	t4,ffffffffc0203460 <do_fork+0x108>
ffffffffc020352e:	00bf2023          	sw	a1,0(t5)
ffffffffc0203532:	b73d                	j	ffffffffc0203460 <do_fork+0x108>
ffffffffc0203534:	8936                	mv	s2,a3
ffffffffc0203536:	bdf1                	j	ffffffffc0203412 <do_fork+0xba>
ffffffffc0203538:	01f6c363          	blt	a3,t6,ffffffffc020353e <do_fork+0x1e6>
ffffffffc020353c:	4685                	li	a3,1
ffffffffc020353e:	4805                	li	a6,1
ffffffffc0203540:	b775                	j	ffffffffc02034ec <do_fork+0x194>
ffffffffc0203542:	00080d63          	beqz	a6,ffffffffc020355c <do_fork+0x204>
ffffffffc0203546:	00de2023          	sw	a3,0(t3)
ffffffffc020354a:	8536                	mv	a0,a3
ffffffffc020354c:	bf11                	j	ffffffffc0203460 <do_fork+0x108>
ffffffffc020354e:	854e                	mv	a0,s3
ffffffffc0203550:	e12fe0ef          	jal	ra,ffffffffc0201b62 <kfree>
ffffffffc0203554:	5571                	li	a0,-4
ffffffffc0203556:	b7b5                	j	ffffffffc02034c2 <do_fork+0x16a>
ffffffffc0203558:	556d                	li	a0,-5
ffffffffc020355a:	b7a5                	j	ffffffffc02034c2 <do_fork+0x16a>
ffffffffc020355c:	000e2503          	lw	a0,0(t3)
ffffffffc0203560:	b701                	j	ffffffffc0203460 <do_fork+0x108>
ffffffffc0203562:	5571                	li	a0,-4
ffffffffc0203564:	bfb9                	j	ffffffffc02034c2 <do_fork+0x16a>
ffffffffc0203566:	00002697          	auipc	a3,0x2
ffffffffc020356a:	0da68693          	addi	a3,a3,218 # ffffffffc0205640 <default_pmm_manager+0x978>
ffffffffc020356e:	00001617          	auipc	a2,0x1
ffffffffc0203572:	3aa60613          	addi	a2,a2,938 # ffffffffc0204918 <commands+0x818>
ffffffffc0203576:	11600593          	li	a1,278
ffffffffc020357a:	00002517          	auipc	a0,0x2
ffffffffc020357e:	0de50513          	addi	a0,a0,222 # ffffffffc0205658 <default_pmm_manager+0x990>
ffffffffc0203582:	ed9fc0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0203586:	00001617          	auipc	a2,0x1
ffffffffc020358a:	77a60613          	addi	a2,a2,1914 # ffffffffc0204d00 <default_pmm_manager+0x38>
ffffffffc020358e:	07100593          	li	a1,113
ffffffffc0203592:	00001517          	auipc	a0,0x1
ffffffffc0203596:	79650513          	addi	a0,a0,1942 # ffffffffc0204d28 <default_pmm_manager+0x60>
ffffffffc020359a:	ec1fc0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc020359e <kernel_thread>:
ffffffffc020359e:	7129                	addi	sp,sp,-320
ffffffffc02035a0:	fa22                	sd	s0,304(sp)
ffffffffc02035a2:	f626                	sd	s1,296(sp)
ffffffffc02035a4:	f24a                	sd	s2,288(sp)
ffffffffc02035a6:	84ae                	mv	s1,a1
ffffffffc02035a8:	892a                	mv	s2,a0
ffffffffc02035aa:	8432                	mv	s0,a2
ffffffffc02035ac:	4581                	li	a1,0
ffffffffc02035ae:	12000613          	li	a2,288
ffffffffc02035b2:	850a                	mv	a0,sp
ffffffffc02035b4:	fe06                	sd	ra,312(sp)
ffffffffc02035b6:	095000ef          	jal	ra,ffffffffc0203e4a <memset>
ffffffffc02035ba:	e0ca                	sd	s2,64(sp)
ffffffffc02035bc:	e4a6                	sd	s1,72(sp)
ffffffffc02035be:	100027f3          	csrr	a5,sstatus
ffffffffc02035c2:	edd7f793          	andi	a5,a5,-291
ffffffffc02035c6:	1207e793          	ori	a5,a5,288
ffffffffc02035ca:	e23e                	sd	a5,256(sp)
ffffffffc02035cc:	860a                	mv	a2,sp
ffffffffc02035ce:	10046513          	ori	a0,s0,256
ffffffffc02035d2:	00000797          	auipc	a5,0x0
ffffffffc02035d6:	c2e78793          	addi	a5,a5,-978 # ffffffffc0203200 <kernel_thread_entry>
ffffffffc02035da:	4581                	li	a1,0
ffffffffc02035dc:	e63e                	sd	a5,264(sp)
ffffffffc02035de:	d7bff0ef          	jal	ra,ffffffffc0203358 <do_fork>
ffffffffc02035e2:	70f2                	ld	ra,312(sp)
ffffffffc02035e4:	7452                	ld	s0,304(sp)
ffffffffc02035e6:	74b2                	ld	s1,296(sp)
ffffffffc02035e8:	7912                	ld	s2,288(sp)
ffffffffc02035ea:	6131                	addi	sp,sp,320
ffffffffc02035ec:	8082                	ret

ffffffffc02035ee <do_exit>:
ffffffffc02035ee:	1141                	addi	sp,sp,-16
ffffffffc02035f0:	00002617          	auipc	a2,0x2
ffffffffc02035f4:	08060613          	addi	a2,a2,128 # ffffffffc0205670 <default_pmm_manager+0x9a8>
ffffffffc02035f8:	19600593          	li	a1,406
ffffffffc02035fc:	00002517          	auipc	a0,0x2
ffffffffc0203600:	05c50513          	addi	a0,a0,92 # ffffffffc0205658 <default_pmm_manager+0x990>
ffffffffc0203604:	e406                	sd	ra,8(sp)
ffffffffc0203606:	e55fc0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc020360a <proc_init>:
ffffffffc020360a:	7179                	addi	sp,sp,-48
ffffffffc020360c:	ec26                	sd	s1,24(sp)
ffffffffc020360e:	0000a797          	auipc	a5,0xa
ffffffffc0203612:	e4a78793          	addi	a5,a5,-438 # ffffffffc020d458 <proc_list>
ffffffffc0203616:	f406                	sd	ra,40(sp)
ffffffffc0203618:	f022                	sd	s0,32(sp)
ffffffffc020361a:	e84a                	sd	s2,16(sp)
ffffffffc020361c:	e44e                	sd	s3,8(sp)
ffffffffc020361e:	00006497          	auipc	s1,0x6
ffffffffc0203622:	e2a48493          	addi	s1,s1,-470 # ffffffffc0209448 <hash_list>
ffffffffc0203626:	e79c                	sd	a5,8(a5)
ffffffffc0203628:	e39c                	sd	a5,0(a5)
ffffffffc020362a:	0000a717          	auipc	a4,0xa
ffffffffc020362e:	e1e70713          	addi	a4,a4,-482 # ffffffffc020d448 <name.2>
ffffffffc0203632:	87a6                	mv	a5,s1
ffffffffc0203634:	e79c                	sd	a5,8(a5)
ffffffffc0203636:	e39c                	sd	a5,0(a5)
ffffffffc0203638:	07c1                	addi	a5,a5,16
ffffffffc020363a:	fef71de3          	bne	a4,a5,ffffffffc0203634 <proc_init+0x2a>
ffffffffc020363e:	bcbff0ef          	jal	ra,ffffffffc0203208 <alloc_proc>
ffffffffc0203642:	0000a917          	auipc	s2,0xa
ffffffffc0203646:	e9690913          	addi	s2,s2,-362 # ffffffffc020d4d8 <idleproc>
ffffffffc020364a:	00a93023          	sd	a0,0(s2)
ffffffffc020364e:	18050d63          	beqz	a0,ffffffffc02037e8 <proc_init+0x1de>
ffffffffc0203652:	07000513          	li	a0,112
ffffffffc0203656:	c5cfe0ef          	jal	ra,ffffffffc0201ab2 <kmalloc>
ffffffffc020365a:	07000613          	li	a2,112
ffffffffc020365e:	4581                	li	a1,0
ffffffffc0203660:	842a                	mv	s0,a0
ffffffffc0203662:	7e8000ef          	jal	ra,ffffffffc0203e4a <memset>
ffffffffc0203666:	00093503          	ld	a0,0(s2)
ffffffffc020366a:	85a2                	mv	a1,s0
ffffffffc020366c:	07000613          	li	a2,112
ffffffffc0203670:	03050513          	addi	a0,a0,48
ffffffffc0203674:	001000ef          	jal	ra,ffffffffc0203e74 <memcmp>
ffffffffc0203678:	89aa                	mv	s3,a0
ffffffffc020367a:	453d                	li	a0,15
ffffffffc020367c:	c36fe0ef          	jal	ra,ffffffffc0201ab2 <kmalloc>
ffffffffc0203680:	463d                	li	a2,15
ffffffffc0203682:	4581                	li	a1,0
ffffffffc0203684:	842a                	mv	s0,a0
ffffffffc0203686:	7c4000ef          	jal	ra,ffffffffc0203e4a <memset>
ffffffffc020368a:	00093503          	ld	a0,0(s2)
ffffffffc020368e:	463d                	li	a2,15
ffffffffc0203690:	85a2                	mv	a1,s0
ffffffffc0203692:	0b450513          	addi	a0,a0,180
ffffffffc0203696:	7de000ef          	jal	ra,ffffffffc0203e74 <memcmp>
ffffffffc020369a:	00093783          	ld	a5,0(s2)
ffffffffc020369e:	0000a717          	auipc	a4,0xa
ffffffffc02036a2:	e0273703          	ld	a4,-510(a4) # ffffffffc020d4a0 <boot_pgdir_pa>
ffffffffc02036a6:	77d4                	ld	a3,168(a5)
ffffffffc02036a8:	0ee68463          	beq	a3,a4,ffffffffc0203790 <proc_init+0x186>
ffffffffc02036ac:	4709                	li	a4,2
ffffffffc02036ae:	e398                	sd	a4,0(a5)
ffffffffc02036b0:	00003717          	auipc	a4,0x3
ffffffffc02036b4:	95070713          	addi	a4,a4,-1712 # ffffffffc0206000 <bootstack>
ffffffffc02036b8:	0b478413          	addi	s0,a5,180
ffffffffc02036bc:	eb98                	sd	a4,16(a5)
ffffffffc02036be:	4705                	li	a4,1
ffffffffc02036c0:	cf98                	sw	a4,24(a5)
ffffffffc02036c2:	4641                	li	a2,16
ffffffffc02036c4:	4581                	li	a1,0
ffffffffc02036c6:	8522                	mv	a0,s0
ffffffffc02036c8:	782000ef          	jal	ra,ffffffffc0203e4a <memset>
ffffffffc02036cc:	463d                	li	a2,15
ffffffffc02036ce:	00002597          	auipc	a1,0x2
ffffffffc02036d2:	fea58593          	addi	a1,a1,-22 # ffffffffc02056b8 <default_pmm_manager+0x9f0>
ffffffffc02036d6:	8522                	mv	a0,s0
ffffffffc02036d8:	784000ef          	jal	ra,ffffffffc0203e5c <memcpy>
ffffffffc02036dc:	0000a717          	auipc	a4,0xa
ffffffffc02036e0:	e0c70713          	addi	a4,a4,-500 # ffffffffc020d4e8 <nr_process>
ffffffffc02036e4:	431c                	lw	a5,0(a4)
ffffffffc02036e6:	00093683          	ld	a3,0(s2)
ffffffffc02036ea:	4601                	li	a2,0
ffffffffc02036ec:	2785                	addiw	a5,a5,1
ffffffffc02036ee:	00002597          	auipc	a1,0x2
ffffffffc02036f2:	fd258593          	addi	a1,a1,-46 # ffffffffc02056c0 <default_pmm_manager+0x9f8>
ffffffffc02036f6:	00000517          	auipc	a0,0x0
ffffffffc02036fa:	b8250513          	addi	a0,a0,-1150 # ffffffffc0203278 <init_main>
ffffffffc02036fe:	c31c                	sw	a5,0(a4)
ffffffffc0203700:	0000a797          	auipc	a5,0xa
ffffffffc0203704:	dcd7b823          	sd	a3,-560(a5) # ffffffffc020d4d0 <current>
ffffffffc0203708:	e97ff0ef          	jal	ra,ffffffffc020359e <kernel_thread>
ffffffffc020370c:	842a                	mv	s0,a0
ffffffffc020370e:	0ea05963          	blez	a0,ffffffffc0203800 <proc_init+0x1f6>
ffffffffc0203712:	6789                	lui	a5,0x2
ffffffffc0203714:	fff5071b          	addiw	a4,a0,-1
ffffffffc0203718:	17f9                	addi	a5,a5,-2
ffffffffc020371a:	2501                	sext.w	a0,a0
ffffffffc020371c:	02e7e363          	bltu	a5,a4,ffffffffc0203742 <proc_init+0x138>
ffffffffc0203720:	45a9                	li	a1,10
ffffffffc0203722:	282000ef          	jal	ra,ffffffffc02039a4 <hash32>
ffffffffc0203726:	02051793          	slli	a5,a0,0x20
ffffffffc020372a:	01c7d693          	srli	a3,a5,0x1c
ffffffffc020372e:	96a6                	add	a3,a3,s1
ffffffffc0203730:	87b6                	mv	a5,a3
ffffffffc0203732:	a029                	j	ffffffffc020373c <proc_init+0x132>
ffffffffc0203734:	f2c7a703          	lw	a4,-212(a5) # 1f2c <kern_entry-0xffffffffc01fe0d4>
ffffffffc0203738:	0a870563          	beq	a4,s0,ffffffffc02037e2 <proc_init+0x1d8>
ffffffffc020373c:	679c                	ld	a5,8(a5)
ffffffffc020373e:	fef69be3          	bne	a3,a5,ffffffffc0203734 <proc_init+0x12a>
ffffffffc0203742:	4781                	li	a5,0
ffffffffc0203744:	0b478493          	addi	s1,a5,180
ffffffffc0203748:	4641                	li	a2,16
ffffffffc020374a:	4581                	li	a1,0
ffffffffc020374c:	0000a417          	auipc	s0,0xa
ffffffffc0203750:	d9440413          	addi	s0,s0,-620 # ffffffffc020d4e0 <initproc>
ffffffffc0203754:	8526                	mv	a0,s1
ffffffffc0203756:	e01c                	sd	a5,0(s0)
ffffffffc0203758:	6f2000ef          	jal	ra,ffffffffc0203e4a <memset>
ffffffffc020375c:	463d                	li	a2,15
ffffffffc020375e:	00002597          	auipc	a1,0x2
ffffffffc0203762:	f9258593          	addi	a1,a1,-110 # ffffffffc02056f0 <default_pmm_manager+0xa28>
ffffffffc0203766:	8526                	mv	a0,s1
ffffffffc0203768:	6f4000ef          	jal	ra,ffffffffc0203e5c <memcpy>
ffffffffc020376c:	00093783          	ld	a5,0(s2)
ffffffffc0203770:	c7e1                	beqz	a5,ffffffffc0203838 <proc_init+0x22e>
ffffffffc0203772:	43dc                	lw	a5,4(a5)
ffffffffc0203774:	e3f1                	bnez	a5,ffffffffc0203838 <proc_init+0x22e>
ffffffffc0203776:	601c                	ld	a5,0(s0)
ffffffffc0203778:	c3c5                	beqz	a5,ffffffffc0203818 <proc_init+0x20e>
ffffffffc020377a:	43d8                	lw	a4,4(a5)
ffffffffc020377c:	4785                	li	a5,1
ffffffffc020377e:	08f71d63          	bne	a4,a5,ffffffffc0203818 <proc_init+0x20e>
ffffffffc0203782:	70a2                	ld	ra,40(sp)
ffffffffc0203784:	7402                	ld	s0,32(sp)
ffffffffc0203786:	64e2                	ld	s1,24(sp)
ffffffffc0203788:	6942                	ld	s2,16(sp)
ffffffffc020378a:	69a2                	ld	s3,8(sp)
ffffffffc020378c:	6145                	addi	sp,sp,48
ffffffffc020378e:	8082                	ret
ffffffffc0203790:	73d8                	ld	a4,160(a5)
ffffffffc0203792:	ff09                	bnez	a4,ffffffffc02036ac <proc_init+0xa2>
ffffffffc0203794:	f0099ce3          	bnez	s3,ffffffffc02036ac <proc_init+0xa2>
ffffffffc0203798:	6394                	ld	a3,0(a5)
ffffffffc020379a:	577d                	li	a4,-1
ffffffffc020379c:	1702                	slli	a4,a4,0x20
ffffffffc020379e:	f0e697e3          	bne	a3,a4,ffffffffc02036ac <proc_init+0xa2>
ffffffffc02037a2:	4798                	lw	a4,8(a5)
ffffffffc02037a4:	f00714e3          	bnez	a4,ffffffffc02036ac <proc_init+0xa2>
ffffffffc02037a8:	6b98                	ld	a4,16(a5)
ffffffffc02037aa:	f00711e3          	bnez	a4,ffffffffc02036ac <proc_init+0xa2>
ffffffffc02037ae:	4f98                	lw	a4,24(a5)
ffffffffc02037b0:	2701                	sext.w	a4,a4
ffffffffc02037b2:	ee071de3          	bnez	a4,ffffffffc02036ac <proc_init+0xa2>
ffffffffc02037b6:	7398                	ld	a4,32(a5)
ffffffffc02037b8:	ee071ae3          	bnez	a4,ffffffffc02036ac <proc_init+0xa2>
ffffffffc02037bc:	7798                	ld	a4,40(a5)
ffffffffc02037be:	ee0717e3          	bnez	a4,ffffffffc02036ac <proc_init+0xa2>
ffffffffc02037c2:	0b07a703          	lw	a4,176(a5)
ffffffffc02037c6:	8d59                	or	a0,a0,a4
ffffffffc02037c8:	0005071b          	sext.w	a4,a0
ffffffffc02037cc:	ee0710e3          	bnez	a4,ffffffffc02036ac <proc_init+0xa2>
ffffffffc02037d0:	00002517          	auipc	a0,0x2
ffffffffc02037d4:	ed050513          	addi	a0,a0,-304 # ffffffffc02056a0 <default_pmm_manager+0x9d8>
ffffffffc02037d8:	9bdfc0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02037dc:	00093783          	ld	a5,0(s2)
ffffffffc02037e0:	b5f1                	j	ffffffffc02036ac <proc_init+0xa2>
ffffffffc02037e2:	f2878793          	addi	a5,a5,-216
ffffffffc02037e6:	bfb9                	j	ffffffffc0203744 <proc_init+0x13a>
ffffffffc02037e8:	00002617          	auipc	a2,0x2
ffffffffc02037ec:	ea060613          	addi	a2,a2,-352 # ffffffffc0205688 <default_pmm_manager+0x9c0>
ffffffffc02037f0:	1b100593          	li	a1,433
ffffffffc02037f4:	00002517          	auipc	a0,0x2
ffffffffc02037f8:	e6450513          	addi	a0,a0,-412 # ffffffffc0205658 <default_pmm_manager+0x990>
ffffffffc02037fc:	c5ffc0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0203800:	00002617          	auipc	a2,0x2
ffffffffc0203804:	ed060613          	addi	a2,a2,-304 # ffffffffc02056d0 <default_pmm_manager+0xa08>
ffffffffc0203808:	1ce00593          	li	a1,462
ffffffffc020380c:	00002517          	auipc	a0,0x2
ffffffffc0203810:	e4c50513          	addi	a0,a0,-436 # ffffffffc0205658 <default_pmm_manager+0x990>
ffffffffc0203814:	c47fc0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0203818:	00002697          	auipc	a3,0x2
ffffffffc020381c:	f0868693          	addi	a3,a3,-248 # ffffffffc0205720 <default_pmm_manager+0xa58>
ffffffffc0203820:	00001617          	auipc	a2,0x1
ffffffffc0203824:	0f860613          	addi	a2,a2,248 # ffffffffc0204918 <commands+0x818>
ffffffffc0203828:	1d500593          	li	a1,469
ffffffffc020382c:	00002517          	auipc	a0,0x2
ffffffffc0203830:	e2c50513          	addi	a0,a0,-468 # ffffffffc0205658 <default_pmm_manager+0x990>
ffffffffc0203834:	c27fc0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0203838:	00002697          	auipc	a3,0x2
ffffffffc020383c:	ec068693          	addi	a3,a3,-320 # ffffffffc02056f8 <default_pmm_manager+0xa30>
ffffffffc0203840:	00001617          	auipc	a2,0x1
ffffffffc0203844:	0d860613          	addi	a2,a2,216 # ffffffffc0204918 <commands+0x818>
ffffffffc0203848:	1d400593          	li	a1,468
ffffffffc020384c:	00002517          	auipc	a0,0x2
ffffffffc0203850:	e0c50513          	addi	a0,a0,-500 # ffffffffc0205658 <default_pmm_manager+0x990>
ffffffffc0203854:	c07fc0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc0203858 <cpu_idle>:
ffffffffc0203858:	1141                	addi	sp,sp,-16
ffffffffc020385a:	e022                	sd	s0,0(sp)
ffffffffc020385c:	e406                	sd	ra,8(sp)
ffffffffc020385e:	0000a417          	auipc	s0,0xa
ffffffffc0203862:	c7240413          	addi	s0,s0,-910 # ffffffffc020d4d0 <current>
ffffffffc0203866:	6018                	ld	a4,0(s0)
ffffffffc0203868:	4f1c                	lw	a5,24(a4)
ffffffffc020386a:	2781                	sext.w	a5,a5
ffffffffc020386c:	dff5                	beqz	a5,ffffffffc0203868 <cpu_idle+0x10>
ffffffffc020386e:	0a2000ef          	jal	ra,ffffffffc0203910 <schedule>
ffffffffc0203872:	bfd5                	j	ffffffffc0203866 <cpu_idle+0xe>

ffffffffc0203874 <switch_to>:
ffffffffc0203874:	00153023          	sd	ra,0(a0)
ffffffffc0203878:	00253423          	sd	sp,8(a0)
ffffffffc020387c:	e900                	sd	s0,16(a0)
ffffffffc020387e:	ed04                	sd	s1,24(a0)
ffffffffc0203880:	03253023          	sd	s2,32(a0)
ffffffffc0203884:	03353423          	sd	s3,40(a0)
ffffffffc0203888:	03453823          	sd	s4,48(a0)
ffffffffc020388c:	03553c23          	sd	s5,56(a0)
ffffffffc0203890:	05653023          	sd	s6,64(a0)
ffffffffc0203894:	05753423          	sd	s7,72(a0)
ffffffffc0203898:	05853823          	sd	s8,80(a0)
ffffffffc020389c:	05953c23          	sd	s9,88(a0)
ffffffffc02038a0:	07a53023          	sd	s10,96(a0)
ffffffffc02038a4:	07b53423          	sd	s11,104(a0)
ffffffffc02038a8:	0005b083          	ld	ra,0(a1)
ffffffffc02038ac:	0085b103          	ld	sp,8(a1)
ffffffffc02038b0:	6980                	ld	s0,16(a1)
ffffffffc02038b2:	6d84                	ld	s1,24(a1)
ffffffffc02038b4:	0205b903          	ld	s2,32(a1)
ffffffffc02038b8:	0285b983          	ld	s3,40(a1)
ffffffffc02038bc:	0305ba03          	ld	s4,48(a1)
ffffffffc02038c0:	0385ba83          	ld	s5,56(a1)
ffffffffc02038c4:	0405bb03          	ld	s6,64(a1)
ffffffffc02038c8:	0485bb83          	ld	s7,72(a1)
ffffffffc02038cc:	0505bc03          	ld	s8,80(a1)
ffffffffc02038d0:	0585bc83          	ld	s9,88(a1)
ffffffffc02038d4:	0605bd03          	ld	s10,96(a1)
ffffffffc02038d8:	0685bd83          	ld	s11,104(a1)
ffffffffc02038dc:	8082                	ret

ffffffffc02038de <wakeup_proc>:
ffffffffc02038de:	411c                	lw	a5,0(a0)
ffffffffc02038e0:	4705                	li	a4,1
ffffffffc02038e2:	37f9                	addiw	a5,a5,-2
ffffffffc02038e4:	00f77563          	bgeu	a4,a5,ffffffffc02038ee <wakeup_proc+0x10>
ffffffffc02038e8:	4789                	li	a5,2
ffffffffc02038ea:	c11c                	sw	a5,0(a0)
ffffffffc02038ec:	8082                	ret
ffffffffc02038ee:	1141                	addi	sp,sp,-16
ffffffffc02038f0:	00002697          	auipc	a3,0x2
ffffffffc02038f4:	e5868693          	addi	a3,a3,-424 # ffffffffc0205748 <default_pmm_manager+0xa80>
ffffffffc02038f8:	00001617          	auipc	a2,0x1
ffffffffc02038fc:	02060613          	addi	a2,a2,32 # ffffffffc0204918 <commands+0x818>
ffffffffc0203900:	45a5                	li	a1,9
ffffffffc0203902:	00002517          	auipc	a0,0x2
ffffffffc0203906:	e8650513          	addi	a0,a0,-378 # ffffffffc0205788 <default_pmm_manager+0xac0>
ffffffffc020390a:	e406                	sd	ra,8(sp)
ffffffffc020390c:	b4ffc0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc0203910 <schedule>:
ffffffffc0203910:	1141                	addi	sp,sp,-16
ffffffffc0203912:	e406                	sd	ra,8(sp)
ffffffffc0203914:	e022                	sd	s0,0(sp)
ffffffffc0203916:	100027f3          	csrr	a5,sstatus
ffffffffc020391a:	8b89                	andi	a5,a5,2
ffffffffc020391c:	4401                	li	s0,0
ffffffffc020391e:	efbd                	bnez	a5,ffffffffc020399c <schedule+0x8c>
ffffffffc0203920:	0000a897          	auipc	a7,0xa
ffffffffc0203924:	bb08b883          	ld	a7,-1104(a7) # ffffffffc020d4d0 <current>
ffffffffc0203928:	0008ac23          	sw	zero,24(a7)
ffffffffc020392c:	0000a517          	auipc	a0,0xa
ffffffffc0203930:	bac53503          	ld	a0,-1108(a0) # ffffffffc020d4d8 <idleproc>
ffffffffc0203934:	04a88e63          	beq	a7,a0,ffffffffc0203990 <schedule+0x80>
ffffffffc0203938:	0c888693          	addi	a3,a7,200
ffffffffc020393c:	0000a617          	auipc	a2,0xa
ffffffffc0203940:	b1c60613          	addi	a2,a2,-1252 # ffffffffc020d458 <proc_list>
ffffffffc0203944:	87b6                	mv	a5,a3
ffffffffc0203946:	4581                	li	a1,0
ffffffffc0203948:	4809                	li	a6,2
ffffffffc020394a:	679c                	ld	a5,8(a5)
ffffffffc020394c:	00c78863          	beq	a5,a2,ffffffffc020395c <schedule+0x4c>
ffffffffc0203950:	f387a703          	lw	a4,-200(a5)
ffffffffc0203954:	f3878593          	addi	a1,a5,-200
ffffffffc0203958:	03070163          	beq	a4,a6,ffffffffc020397a <schedule+0x6a>
ffffffffc020395c:	fef697e3          	bne	a3,a5,ffffffffc020394a <schedule+0x3a>
ffffffffc0203960:	ed89                	bnez	a1,ffffffffc020397a <schedule+0x6a>
ffffffffc0203962:	451c                	lw	a5,8(a0)
ffffffffc0203964:	2785                	addiw	a5,a5,1
ffffffffc0203966:	c51c                	sw	a5,8(a0)
ffffffffc0203968:	00a88463          	beq	a7,a0,ffffffffc0203970 <schedule+0x60>
ffffffffc020396c:	97fff0ef          	jal	ra,ffffffffc02032ea <proc_run>
ffffffffc0203970:	e819                	bnez	s0,ffffffffc0203986 <schedule+0x76>
ffffffffc0203972:	60a2                	ld	ra,8(sp)
ffffffffc0203974:	6402                	ld	s0,0(sp)
ffffffffc0203976:	0141                	addi	sp,sp,16
ffffffffc0203978:	8082                	ret
ffffffffc020397a:	4198                	lw	a4,0(a1)
ffffffffc020397c:	4789                	li	a5,2
ffffffffc020397e:	fef712e3          	bne	a4,a5,ffffffffc0203962 <schedule+0x52>
ffffffffc0203982:	852e                	mv	a0,a1
ffffffffc0203984:	bff9                	j	ffffffffc0203962 <schedule+0x52>
ffffffffc0203986:	6402                	ld	s0,0(sp)
ffffffffc0203988:	60a2                	ld	ra,8(sp)
ffffffffc020398a:	0141                	addi	sp,sp,16
ffffffffc020398c:	f9ffc06f          	j	ffffffffc020092a <intr_enable>
ffffffffc0203990:	0000a617          	auipc	a2,0xa
ffffffffc0203994:	ac860613          	addi	a2,a2,-1336 # ffffffffc020d458 <proc_list>
ffffffffc0203998:	86b2                	mv	a3,a2
ffffffffc020399a:	b76d                	j	ffffffffc0203944 <schedule+0x34>
ffffffffc020399c:	f95fc0ef          	jal	ra,ffffffffc0200930 <intr_disable>
ffffffffc02039a0:	4405                	li	s0,1
ffffffffc02039a2:	bfbd                	j	ffffffffc0203920 <schedule+0x10>

ffffffffc02039a4 <hash32>:
ffffffffc02039a4:	9e3707b7          	lui	a5,0x9e370
ffffffffc02039a8:	2785                	addiw	a5,a5,1
ffffffffc02039aa:	02a7853b          	mulw	a0,a5,a0
ffffffffc02039ae:	02000793          	li	a5,32
ffffffffc02039b2:	9f8d                	subw	a5,a5,a1
ffffffffc02039b4:	00f5553b          	srlw	a0,a0,a5
ffffffffc02039b8:	8082                	ret

ffffffffc02039ba <printnum>:
ffffffffc02039ba:	02069813          	slli	a6,a3,0x20
ffffffffc02039be:	7179                	addi	sp,sp,-48
ffffffffc02039c0:	02085813          	srli	a6,a6,0x20
ffffffffc02039c4:	e052                	sd	s4,0(sp)
ffffffffc02039c6:	03067a33          	remu	s4,a2,a6
ffffffffc02039ca:	f022                	sd	s0,32(sp)
ffffffffc02039cc:	ec26                	sd	s1,24(sp)
ffffffffc02039ce:	e84a                	sd	s2,16(sp)
ffffffffc02039d0:	f406                	sd	ra,40(sp)
ffffffffc02039d2:	e44e                	sd	s3,8(sp)
ffffffffc02039d4:	84aa                	mv	s1,a0
ffffffffc02039d6:	892e                	mv	s2,a1
ffffffffc02039d8:	fff7041b          	addiw	s0,a4,-1
ffffffffc02039dc:	2a01                	sext.w	s4,s4
ffffffffc02039de:	03067e63          	bgeu	a2,a6,ffffffffc0203a1a <printnum+0x60>
ffffffffc02039e2:	89be                	mv	s3,a5
ffffffffc02039e4:	00805763          	blez	s0,ffffffffc02039f2 <printnum+0x38>
ffffffffc02039e8:	347d                	addiw	s0,s0,-1
ffffffffc02039ea:	85ca                	mv	a1,s2
ffffffffc02039ec:	854e                	mv	a0,s3
ffffffffc02039ee:	9482                	jalr	s1
ffffffffc02039f0:	fc65                	bnez	s0,ffffffffc02039e8 <printnum+0x2e>
ffffffffc02039f2:	1a02                	slli	s4,s4,0x20
ffffffffc02039f4:	00002797          	auipc	a5,0x2
ffffffffc02039f8:	dac78793          	addi	a5,a5,-596 # ffffffffc02057a0 <default_pmm_manager+0xad8>
ffffffffc02039fc:	020a5a13          	srli	s4,s4,0x20
ffffffffc0203a00:	9a3e                	add	s4,s4,a5
ffffffffc0203a02:	7402                	ld	s0,32(sp)
ffffffffc0203a04:	000a4503          	lbu	a0,0(s4)
ffffffffc0203a08:	70a2                	ld	ra,40(sp)
ffffffffc0203a0a:	69a2                	ld	s3,8(sp)
ffffffffc0203a0c:	6a02                	ld	s4,0(sp)
ffffffffc0203a0e:	85ca                	mv	a1,s2
ffffffffc0203a10:	87a6                	mv	a5,s1
ffffffffc0203a12:	6942                	ld	s2,16(sp)
ffffffffc0203a14:	64e2                	ld	s1,24(sp)
ffffffffc0203a16:	6145                	addi	sp,sp,48
ffffffffc0203a18:	8782                	jr	a5
ffffffffc0203a1a:	03065633          	divu	a2,a2,a6
ffffffffc0203a1e:	8722                	mv	a4,s0
ffffffffc0203a20:	f9bff0ef          	jal	ra,ffffffffc02039ba <printnum>
ffffffffc0203a24:	b7f9                	j	ffffffffc02039f2 <printnum+0x38>

ffffffffc0203a26 <vprintfmt>:
ffffffffc0203a26:	7119                	addi	sp,sp,-128
ffffffffc0203a28:	f4a6                	sd	s1,104(sp)
ffffffffc0203a2a:	f0ca                	sd	s2,96(sp)
ffffffffc0203a2c:	ecce                	sd	s3,88(sp)
ffffffffc0203a2e:	e8d2                	sd	s4,80(sp)
ffffffffc0203a30:	e4d6                	sd	s5,72(sp)
ffffffffc0203a32:	e0da                	sd	s6,64(sp)
ffffffffc0203a34:	fc5e                	sd	s7,56(sp)
ffffffffc0203a36:	f06a                	sd	s10,32(sp)
ffffffffc0203a38:	fc86                	sd	ra,120(sp)
ffffffffc0203a3a:	f8a2                	sd	s0,112(sp)
ffffffffc0203a3c:	f862                	sd	s8,48(sp)
ffffffffc0203a3e:	f466                	sd	s9,40(sp)
ffffffffc0203a40:	ec6e                	sd	s11,24(sp)
ffffffffc0203a42:	892a                	mv	s2,a0
ffffffffc0203a44:	84ae                	mv	s1,a1
ffffffffc0203a46:	8d32                	mv	s10,a2
ffffffffc0203a48:	8a36                	mv	s4,a3
ffffffffc0203a4a:	02500993          	li	s3,37
ffffffffc0203a4e:	5b7d                	li	s6,-1
ffffffffc0203a50:	00002a97          	auipc	s5,0x2
ffffffffc0203a54:	d7ca8a93          	addi	s5,s5,-644 # ffffffffc02057cc <default_pmm_manager+0xb04>
ffffffffc0203a58:	00002b97          	auipc	s7,0x2
ffffffffc0203a5c:	f50b8b93          	addi	s7,s7,-176 # ffffffffc02059a8 <error_string>
ffffffffc0203a60:	000d4503          	lbu	a0,0(s10)
ffffffffc0203a64:	001d0413          	addi	s0,s10,1
ffffffffc0203a68:	01350a63          	beq	a0,s3,ffffffffc0203a7c <vprintfmt+0x56>
ffffffffc0203a6c:	c121                	beqz	a0,ffffffffc0203aac <vprintfmt+0x86>
ffffffffc0203a6e:	85a6                	mv	a1,s1
ffffffffc0203a70:	0405                	addi	s0,s0,1
ffffffffc0203a72:	9902                	jalr	s2
ffffffffc0203a74:	fff44503          	lbu	a0,-1(s0)
ffffffffc0203a78:	ff351ae3          	bne	a0,s3,ffffffffc0203a6c <vprintfmt+0x46>
ffffffffc0203a7c:	00044603          	lbu	a2,0(s0)
ffffffffc0203a80:	02000793          	li	a5,32
ffffffffc0203a84:	4c81                	li	s9,0
ffffffffc0203a86:	4881                	li	a7,0
ffffffffc0203a88:	5c7d                	li	s8,-1
ffffffffc0203a8a:	5dfd                	li	s11,-1
ffffffffc0203a8c:	05500513          	li	a0,85
ffffffffc0203a90:	4825                	li	a6,9
ffffffffc0203a92:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0203a96:	0ff5f593          	zext.b	a1,a1
ffffffffc0203a9a:	00140d13          	addi	s10,s0,1
ffffffffc0203a9e:	04b56263          	bltu	a0,a1,ffffffffc0203ae2 <vprintfmt+0xbc>
ffffffffc0203aa2:	058a                	slli	a1,a1,0x2
ffffffffc0203aa4:	95d6                	add	a1,a1,s5
ffffffffc0203aa6:	4194                	lw	a3,0(a1)
ffffffffc0203aa8:	96d6                	add	a3,a3,s5
ffffffffc0203aaa:	8682                	jr	a3
ffffffffc0203aac:	70e6                	ld	ra,120(sp)
ffffffffc0203aae:	7446                	ld	s0,112(sp)
ffffffffc0203ab0:	74a6                	ld	s1,104(sp)
ffffffffc0203ab2:	7906                	ld	s2,96(sp)
ffffffffc0203ab4:	69e6                	ld	s3,88(sp)
ffffffffc0203ab6:	6a46                	ld	s4,80(sp)
ffffffffc0203ab8:	6aa6                	ld	s5,72(sp)
ffffffffc0203aba:	6b06                	ld	s6,64(sp)
ffffffffc0203abc:	7be2                	ld	s7,56(sp)
ffffffffc0203abe:	7c42                	ld	s8,48(sp)
ffffffffc0203ac0:	7ca2                	ld	s9,40(sp)
ffffffffc0203ac2:	7d02                	ld	s10,32(sp)
ffffffffc0203ac4:	6de2                	ld	s11,24(sp)
ffffffffc0203ac6:	6109                	addi	sp,sp,128
ffffffffc0203ac8:	8082                	ret
ffffffffc0203aca:	87b2                	mv	a5,a2
ffffffffc0203acc:	00144603          	lbu	a2,1(s0)
ffffffffc0203ad0:	846a                	mv	s0,s10
ffffffffc0203ad2:	00140d13          	addi	s10,s0,1
ffffffffc0203ad6:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0203ada:	0ff5f593          	zext.b	a1,a1
ffffffffc0203ade:	fcb572e3          	bgeu	a0,a1,ffffffffc0203aa2 <vprintfmt+0x7c>
ffffffffc0203ae2:	85a6                	mv	a1,s1
ffffffffc0203ae4:	02500513          	li	a0,37
ffffffffc0203ae8:	9902                	jalr	s2
ffffffffc0203aea:	fff44783          	lbu	a5,-1(s0)
ffffffffc0203aee:	8d22                	mv	s10,s0
ffffffffc0203af0:	f73788e3          	beq	a5,s3,ffffffffc0203a60 <vprintfmt+0x3a>
ffffffffc0203af4:	ffed4783          	lbu	a5,-2(s10)
ffffffffc0203af8:	1d7d                	addi	s10,s10,-1
ffffffffc0203afa:	ff379de3          	bne	a5,s3,ffffffffc0203af4 <vprintfmt+0xce>
ffffffffc0203afe:	b78d                	j	ffffffffc0203a60 <vprintfmt+0x3a>
ffffffffc0203b00:	fd060c1b          	addiw	s8,a2,-48
ffffffffc0203b04:	00144603          	lbu	a2,1(s0)
ffffffffc0203b08:	846a                	mv	s0,s10
ffffffffc0203b0a:	fd06069b          	addiw	a3,a2,-48
ffffffffc0203b0e:	0006059b          	sext.w	a1,a2
ffffffffc0203b12:	02d86463          	bltu	a6,a3,ffffffffc0203b3a <vprintfmt+0x114>
ffffffffc0203b16:	00144603          	lbu	a2,1(s0)
ffffffffc0203b1a:	002c169b          	slliw	a3,s8,0x2
ffffffffc0203b1e:	0186873b          	addw	a4,a3,s8
ffffffffc0203b22:	0017171b          	slliw	a4,a4,0x1
ffffffffc0203b26:	9f2d                	addw	a4,a4,a1
ffffffffc0203b28:	fd06069b          	addiw	a3,a2,-48
ffffffffc0203b2c:	0405                	addi	s0,s0,1
ffffffffc0203b2e:	fd070c1b          	addiw	s8,a4,-48
ffffffffc0203b32:	0006059b          	sext.w	a1,a2
ffffffffc0203b36:	fed870e3          	bgeu	a6,a3,ffffffffc0203b16 <vprintfmt+0xf0>
ffffffffc0203b3a:	f40ddce3          	bgez	s11,ffffffffc0203a92 <vprintfmt+0x6c>
ffffffffc0203b3e:	8de2                	mv	s11,s8
ffffffffc0203b40:	5c7d                	li	s8,-1
ffffffffc0203b42:	bf81                	j	ffffffffc0203a92 <vprintfmt+0x6c>
ffffffffc0203b44:	fffdc693          	not	a3,s11
ffffffffc0203b48:	96fd                	srai	a3,a3,0x3f
ffffffffc0203b4a:	00ddfdb3          	and	s11,s11,a3
ffffffffc0203b4e:	00144603          	lbu	a2,1(s0)
ffffffffc0203b52:	2d81                	sext.w	s11,s11
ffffffffc0203b54:	846a                	mv	s0,s10
ffffffffc0203b56:	bf35                	j	ffffffffc0203a92 <vprintfmt+0x6c>
ffffffffc0203b58:	000a2c03          	lw	s8,0(s4)
ffffffffc0203b5c:	00144603          	lbu	a2,1(s0)
ffffffffc0203b60:	0a21                	addi	s4,s4,8
ffffffffc0203b62:	846a                	mv	s0,s10
ffffffffc0203b64:	bfd9                	j	ffffffffc0203b3a <vprintfmt+0x114>
ffffffffc0203b66:	4705                	li	a4,1
ffffffffc0203b68:	008a0593          	addi	a1,s4,8
ffffffffc0203b6c:	01174463          	blt	a4,a7,ffffffffc0203b74 <vprintfmt+0x14e>
ffffffffc0203b70:	1a088e63          	beqz	a7,ffffffffc0203d2c <vprintfmt+0x306>
ffffffffc0203b74:	000a3603          	ld	a2,0(s4)
ffffffffc0203b78:	46c1                	li	a3,16
ffffffffc0203b7a:	8a2e                	mv	s4,a1
ffffffffc0203b7c:	2781                	sext.w	a5,a5
ffffffffc0203b7e:	876e                	mv	a4,s11
ffffffffc0203b80:	85a6                	mv	a1,s1
ffffffffc0203b82:	854a                	mv	a0,s2
ffffffffc0203b84:	e37ff0ef          	jal	ra,ffffffffc02039ba <printnum>
ffffffffc0203b88:	bde1                	j	ffffffffc0203a60 <vprintfmt+0x3a>
ffffffffc0203b8a:	000a2503          	lw	a0,0(s4)
ffffffffc0203b8e:	85a6                	mv	a1,s1
ffffffffc0203b90:	0a21                	addi	s4,s4,8
ffffffffc0203b92:	9902                	jalr	s2
ffffffffc0203b94:	b5f1                	j	ffffffffc0203a60 <vprintfmt+0x3a>
ffffffffc0203b96:	4705                	li	a4,1
ffffffffc0203b98:	008a0593          	addi	a1,s4,8
ffffffffc0203b9c:	01174463          	blt	a4,a7,ffffffffc0203ba4 <vprintfmt+0x17e>
ffffffffc0203ba0:	18088163          	beqz	a7,ffffffffc0203d22 <vprintfmt+0x2fc>
ffffffffc0203ba4:	000a3603          	ld	a2,0(s4)
ffffffffc0203ba8:	46a9                	li	a3,10
ffffffffc0203baa:	8a2e                	mv	s4,a1
ffffffffc0203bac:	bfc1                	j	ffffffffc0203b7c <vprintfmt+0x156>
ffffffffc0203bae:	00144603          	lbu	a2,1(s0)
ffffffffc0203bb2:	4c85                	li	s9,1
ffffffffc0203bb4:	846a                	mv	s0,s10
ffffffffc0203bb6:	bdf1                	j	ffffffffc0203a92 <vprintfmt+0x6c>
ffffffffc0203bb8:	85a6                	mv	a1,s1
ffffffffc0203bba:	02500513          	li	a0,37
ffffffffc0203bbe:	9902                	jalr	s2
ffffffffc0203bc0:	b545                	j	ffffffffc0203a60 <vprintfmt+0x3a>
ffffffffc0203bc2:	00144603          	lbu	a2,1(s0)
ffffffffc0203bc6:	2885                	addiw	a7,a7,1
ffffffffc0203bc8:	846a                	mv	s0,s10
ffffffffc0203bca:	b5e1                	j	ffffffffc0203a92 <vprintfmt+0x6c>
ffffffffc0203bcc:	4705                	li	a4,1
ffffffffc0203bce:	008a0593          	addi	a1,s4,8
ffffffffc0203bd2:	01174463          	blt	a4,a7,ffffffffc0203bda <vprintfmt+0x1b4>
ffffffffc0203bd6:	14088163          	beqz	a7,ffffffffc0203d18 <vprintfmt+0x2f2>
ffffffffc0203bda:	000a3603          	ld	a2,0(s4)
ffffffffc0203bde:	46a1                	li	a3,8
ffffffffc0203be0:	8a2e                	mv	s4,a1
ffffffffc0203be2:	bf69                	j	ffffffffc0203b7c <vprintfmt+0x156>
ffffffffc0203be4:	03000513          	li	a0,48
ffffffffc0203be8:	85a6                	mv	a1,s1
ffffffffc0203bea:	e03e                	sd	a5,0(sp)
ffffffffc0203bec:	9902                	jalr	s2
ffffffffc0203bee:	85a6                	mv	a1,s1
ffffffffc0203bf0:	07800513          	li	a0,120
ffffffffc0203bf4:	9902                	jalr	s2
ffffffffc0203bf6:	0a21                	addi	s4,s4,8
ffffffffc0203bf8:	6782                	ld	a5,0(sp)
ffffffffc0203bfa:	46c1                	li	a3,16
ffffffffc0203bfc:	ff8a3603          	ld	a2,-8(s4)
ffffffffc0203c00:	bfb5                	j	ffffffffc0203b7c <vprintfmt+0x156>
ffffffffc0203c02:	000a3403          	ld	s0,0(s4)
ffffffffc0203c06:	008a0713          	addi	a4,s4,8
ffffffffc0203c0a:	e03a                	sd	a4,0(sp)
ffffffffc0203c0c:	14040263          	beqz	s0,ffffffffc0203d50 <vprintfmt+0x32a>
ffffffffc0203c10:	0fb05763          	blez	s11,ffffffffc0203cfe <vprintfmt+0x2d8>
ffffffffc0203c14:	02d00693          	li	a3,45
ffffffffc0203c18:	0cd79163          	bne	a5,a3,ffffffffc0203cda <vprintfmt+0x2b4>
ffffffffc0203c1c:	00044783          	lbu	a5,0(s0)
ffffffffc0203c20:	0007851b          	sext.w	a0,a5
ffffffffc0203c24:	cf85                	beqz	a5,ffffffffc0203c5c <vprintfmt+0x236>
ffffffffc0203c26:	00140a13          	addi	s4,s0,1
ffffffffc0203c2a:	05e00413          	li	s0,94
ffffffffc0203c2e:	000c4563          	bltz	s8,ffffffffc0203c38 <vprintfmt+0x212>
ffffffffc0203c32:	3c7d                	addiw	s8,s8,-1
ffffffffc0203c34:	036c0263          	beq	s8,s6,ffffffffc0203c58 <vprintfmt+0x232>
ffffffffc0203c38:	85a6                	mv	a1,s1
ffffffffc0203c3a:	0e0c8e63          	beqz	s9,ffffffffc0203d36 <vprintfmt+0x310>
ffffffffc0203c3e:	3781                	addiw	a5,a5,-32
ffffffffc0203c40:	0ef47b63          	bgeu	s0,a5,ffffffffc0203d36 <vprintfmt+0x310>
ffffffffc0203c44:	03f00513          	li	a0,63
ffffffffc0203c48:	9902                	jalr	s2
ffffffffc0203c4a:	000a4783          	lbu	a5,0(s4)
ffffffffc0203c4e:	3dfd                	addiw	s11,s11,-1
ffffffffc0203c50:	0a05                	addi	s4,s4,1
ffffffffc0203c52:	0007851b          	sext.w	a0,a5
ffffffffc0203c56:	ffe1                	bnez	a5,ffffffffc0203c2e <vprintfmt+0x208>
ffffffffc0203c58:	01b05963          	blez	s11,ffffffffc0203c6a <vprintfmt+0x244>
ffffffffc0203c5c:	3dfd                	addiw	s11,s11,-1
ffffffffc0203c5e:	85a6                	mv	a1,s1
ffffffffc0203c60:	02000513          	li	a0,32
ffffffffc0203c64:	9902                	jalr	s2
ffffffffc0203c66:	fe0d9be3          	bnez	s11,ffffffffc0203c5c <vprintfmt+0x236>
ffffffffc0203c6a:	6a02                	ld	s4,0(sp)
ffffffffc0203c6c:	bbd5                	j	ffffffffc0203a60 <vprintfmt+0x3a>
ffffffffc0203c6e:	4705                	li	a4,1
ffffffffc0203c70:	008a0c93          	addi	s9,s4,8
ffffffffc0203c74:	01174463          	blt	a4,a7,ffffffffc0203c7c <vprintfmt+0x256>
ffffffffc0203c78:	08088d63          	beqz	a7,ffffffffc0203d12 <vprintfmt+0x2ec>
ffffffffc0203c7c:	000a3403          	ld	s0,0(s4)
ffffffffc0203c80:	0a044d63          	bltz	s0,ffffffffc0203d3a <vprintfmt+0x314>
ffffffffc0203c84:	8622                	mv	a2,s0
ffffffffc0203c86:	8a66                	mv	s4,s9
ffffffffc0203c88:	46a9                	li	a3,10
ffffffffc0203c8a:	bdcd                	j	ffffffffc0203b7c <vprintfmt+0x156>
ffffffffc0203c8c:	000a2783          	lw	a5,0(s4)
ffffffffc0203c90:	4719                	li	a4,6
ffffffffc0203c92:	0a21                	addi	s4,s4,8
ffffffffc0203c94:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc0203c98:	8fb5                	xor	a5,a5,a3
ffffffffc0203c9a:	40d786bb          	subw	a3,a5,a3
ffffffffc0203c9e:	02d74163          	blt	a4,a3,ffffffffc0203cc0 <vprintfmt+0x29a>
ffffffffc0203ca2:	00369793          	slli	a5,a3,0x3
ffffffffc0203ca6:	97de                	add	a5,a5,s7
ffffffffc0203ca8:	639c                	ld	a5,0(a5)
ffffffffc0203caa:	cb99                	beqz	a5,ffffffffc0203cc0 <vprintfmt+0x29a>
ffffffffc0203cac:	86be                	mv	a3,a5
ffffffffc0203cae:	00000617          	auipc	a2,0x0
ffffffffc0203cb2:	21260613          	addi	a2,a2,530 # ffffffffc0203ec0 <etext+0x28>
ffffffffc0203cb6:	85a6                	mv	a1,s1
ffffffffc0203cb8:	854a                	mv	a0,s2
ffffffffc0203cba:	0ce000ef          	jal	ra,ffffffffc0203d88 <printfmt>
ffffffffc0203cbe:	b34d                	j	ffffffffc0203a60 <vprintfmt+0x3a>
ffffffffc0203cc0:	00002617          	auipc	a2,0x2
ffffffffc0203cc4:	b0060613          	addi	a2,a2,-1280 # ffffffffc02057c0 <default_pmm_manager+0xaf8>
ffffffffc0203cc8:	85a6                	mv	a1,s1
ffffffffc0203cca:	854a                	mv	a0,s2
ffffffffc0203ccc:	0bc000ef          	jal	ra,ffffffffc0203d88 <printfmt>
ffffffffc0203cd0:	bb41                	j	ffffffffc0203a60 <vprintfmt+0x3a>
ffffffffc0203cd2:	00002417          	auipc	s0,0x2
ffffffffc0203cd6:	ae640413          	addi	s0,s0,-1306 # ffffffffc02057b8 <default_pmm_manager+0xaf0>
ffffffffc0203cda:	85e2                	mv	a1,s8
ffffffffc0203cdc:	8522                	mv	a0,s0
ffffffffc0203cde:	e43e                	sd	a5,8(sp)
ffffffffc0203ce0:	0e2000ef          	jal	ra,ffffffffc0203dc2 <strnlen>
ffffffffc0203ce4:	40ad8dbb          	subw	s11,s11,a0
ffffffffc0203ce8:	01b05b63          	blez	s11,ffffffffc0203cfe <vprintfmt+0x2d8>
ffffffffc0203cec:	67a2                	ld	a5,8(sp)
ffffffffc0203cee:	00078a1b          	sext.w	s4,a5
ffffffffc0203cf2:	3dfd                	addiw	s11,s11,-1
ffffffffc0203cf4:	85a6                	mv	a1,s1
ffffffffc0203cf6:	8552                	mv	a0,s4
ffffffffc0203cf8:	9902                	jalr	s2
ffffffffc0203cfa:	fe0d9ce3          	bnez	s11,ffffffffc0203cf2 <vprintfmt+0x2cc>
ffffffffc0203cfe:	00044783          	lbu	a5,0(s0)
ffffffffc0203d02:	00140a13          	addi	s4,s0,1
ffffffffc0203d06:	0007851b          	sext.w	a0,a5
ffffffffc0203d0a:	d3a5                	beqz	a5,ffffffffc0203c6a <vprintfmt+0x244>
ffffffffc0203d0c:	05e00413          	li	s0,94
ffffffffc0203d10:	bf39                	j	ffffffffc0203c2e <vprintfmt+0x208>
ffffffffc0203d12:	000a2403          	lw	s0,0(s4)
ffffffffc0203d16:	b7ad                	j	ffffffffc0203c80 <vprintfmt+0x25a>
ffffffffc0203d18:	000a6603          	lwu	a2,0(s4)
ffffffffc0203d1c:	46a1                	li	a3,8
ffffffffc0203d1e:	8a2e                	mv	s4,a1
ffffffffc0203d20:	bdb1                	j	ffffffffc0203b7c <vprintfmt+0x156>
ffffffffc0203d22:	000a6603          	lwu	a2,0(s4)
ffffffffc0203d26:	46a9                	li	a3,10
ffffffffc0203d28:	8a2e                	mv	s4,a1
ffffffffc0203d2a:	bd89                	j	ffffffffc0203b7c <vprintfmt+0x156>
ffffffffc0203d2c:	000a6603          	lwu	a2,0(s4)
ffffffffc0203d30:	46c1                	li	a3,16
ffffffffc0203d32:	8a2e                	mv	s4,a1
ffffffffc0203d34:	b5a1                	j	ffffffffc0203b7c <vprintfmt+0x156>
ffffffffc0203d36:	9902                	jalr	s2
ffffffffc0203d38:	bf09                	j	ffffffffc0203c4a <vprintfmt+0x224>
ffffffffc0203d3a:	85a6                	mv	a1,s1
ffffffffc0203d3c:	02d00513          	li	a0,45
ffffffffc0203d40:	e03e                	sd	a5,0(sp)
ffffffffc0203d42:	9902                	jalr	s2
ffffffffc0203d44:	6782                	ld	a5,0(sp)
ffffffffc0203d46:	8a66                	mv	s4,s9
ffffffffc0203d48:	40800633          	neg	a2,s0
ffffffffc0203d4c:	46a9                	li	a3,10
ffffffffc0203d4e:	b53d                	j	ffffffffc0203b7c <vprintfmt+0x156>
ffffffffc0203d50:	03b05163          	blez	s11,ffffffffc0203d72 <vprintfmt+0x34c>
ffffffffc0203d54:	02d00693          	li	a3,45
ffffffffc0203d58:	f6d79de3          	bne	a5,a3,ffffffffc0203cd2 <vprintfmt+0x2ac>
ffffffffc0203d5c:	00002417          	auipc	s0,0x2
ffffffffc0203d60:	a5c40413          	addi	s0,s0,-1444 # ffffffffc02057b8 <default_pmm_manager+0xaf0>
ffffffffc0203d64:	02800793          	li	a5,40
ffffffffc0203d68:	02800513          	li	a0,40
ffffffffc0203d6c:	00140a13          	addi	s4,s0,1
ffffffffc0203d70:	bd6d                	j	ffffffffc0203c2a <vprintfmt+0x204>
ffffffffc0203d72:	00002a17          	auipc	s4,0x2
ffffffffc0203d76:	a47a0a13          	addi	s4,s4,-1465 # ffffffffc02057b9 <default_pmm_manager+0xaf1>
ffffffffc0203d7a:	02800513          	li	a0,40
ffffffffc0203d7e:	02800793          	li	a5,40
ffffffffc0203d82:	05e00413          	li	s0,94
ffffffffc0203d86:	b565                	j	ffffffffc0203c2e <vprintfmt+0x208>

ffffffffc0203d88 <printfmt>:
ffffffffc0203d88:	715d                	addi	sp,sp,-80
ffffffffc0203d8a:	02810313          	addi	t1,sp,40
ffffffffc0203d8e:	f436                	sd	a3,40(sp)
ffffffffc0203d90:	869a                	mv	a3,t1
ffffffffc0203d92:	ec06                	sd	ra,24(sp)
ffffffffc0203d94:	f83a                	sd	a4,48(sp)
ffffffffc0203d96:	fc3e                	sd	a5,56(sp)
ffffffffc0203d98:	e0c2                	sd	a6,64(sp)
ffffffffc0203d9a:	e4c6                	sd	a7,72(sp)
ffffffffc0203d9c:	e41a                	sd	t1,8(sp)
ffffffffc0203d9e:	c89ff0ef          	jal	ra,ffffffffc0203a26 <vprintfmt>
ffffffffc0203da2:	60e2                	ld	ra,24(sp)
ffffffffc0203da4:	6161                	addi	sp,sp,80
ffffffffc0203da6:	8082                	ret

ffffffffc0203da8 <strlen>:
ffffffffc0203da8:	00054783          	lbu	a5,0(a0)
ffffffffc0203dac:	872a                	mv	a4,a0
ffffffffc0203dae:	4501                	li	a0,0
ffffffffc0203db0:	cb81                	beqz	a5,ffffffffc0203dc0 <strlen+0x18>
ffffffffc0203db2:	0505                	addi	a0,a0,1
ffffffffc0203db4:	00a707b3          	add	a5,a4,a0
ffffffffc0203db8:	0007c783          	lbu	a5,0(a5)
ffffffffc0203dbc:	fbfd                	bnez	a5,ffffffffc0203db2 <strlen+0xa>
ffffffffc0203dbe:	8082                	ret
ffffffffc0203dc0:	8082                	ret

ffffffffc0203dc2 <strnlen>:
ffffffffc0203dc2:	4781                	li	a5,0
ffffffffc0203dc4:	e589                	bnez	a1,ffffffffc0203dce <strnlen+0xc>
ffffffffc0203dc6:	a811                	j	ffffffffc0203dda <strnlen+0x18>
ffffffffc0203dc8:	0785                	addi	a5,a5,1
ffffffffc0203dca:	00f58863          	beq	a1,a5,ffffffffc0203dda <strnlen+0x18>
ffffffffc0203dce:	00f50733          	add	a4,a0,a5
ffffffffc0203dd2:	00074703          	lbu	a4,0(a4)
ffffffffc0203dd6:	fb6d                	bnez	a4,ffffffffc0203dc8 <strnlen+0x6>
ffffffffc0203dd8:	85be                	mv	a1,a5
ffffffffc0203dda:	852e                	mv	a0,a1
ffffffffc0203ddc:	8082                	ret

ffffffffc0203dde <strcpy>:
ffffffffc0203dde:	87aa                	mv	a5,a0
ffffffffc0203de0:	0005c703          	lbu	a4,0(a1)
ffffffffc0203de4:	0785                	addi	a5,a5,1
ffffffffc0203de6:	0585                	addi	a1,a1,1
ffffffffc0203de8:	fee78fa3          	sb	a4,-1(a5)
ffffffffc0203dec:	fb75                	bnez	a4,ffffffffc0203de0 <strcpy+0x2>
ffffffffc0203dee:	8082                	ret

ffffffffc0203df0 <strcmp>:
ffffffffc0203df0:	00054783          	lbu	a5,0(a0)
ffffffffc0203df4:	0005c703          	lbu	a4,0(a1)
ffffffffc0203df8:	cb89                	beqz	a5,ffffffffc0203e0a <strcmp+0x1a>
ffffffffc0203dfa:	0505                	addi	a0,a0,1
ffffffffc0203dfc:	0585                	addi	a1,a1,1
ffffffffc0203dfe:	fee789e3          	beq	a5,a4,ffffffffc0203df0 <strcmp>
ffffffffc0203e02:	0007851b          	sext.w	a0,a5
ffffffffc0203e06:	9d19                	subw	a0,a0,a4
ffffffffc0203e08:	8082                	ret
ffffffffc0203e0a:	4501                	li	a0,0
ffffffffc0203e0c:	bfed                	j	ffffffffc0203e06 <strcmp+0x16>

ffffffffc0203e0e <strncmp>:
ffffffffc0203e0e:	c20d                	beqz	a2,ffffffffc0203e30 <strncmp+0x22>
ffffffffc0203e10:	962e                	add	a2,a2,a1
ffffffffc0203e12:	a031                	j	ffffffffc0203e1e <strncmp+0x10>
ffffffffc0203e14:	0505                	addi	a0,a0,1
ffffffffc0203e16:	00e79a63          	bne	a5,a4,ffffffffc0203e2a <strncmp+0x1c>
ffffffffc0203e1a:	00b60b63          	beq	a2,a1,ffffffffc0203e30 <strncmp+0x22>
ffffffffc0203e1e:	00054783          	lbu	a5,0(a0)
ffffffffc0203e22:	0585                	addi	a1,a1,1
ffffffffc0203e24:	fff5c703          	lbu	a4,-1(a1)
ffffffffc0203e28:	f7f5                	bnez	a5,ffffffffc0203e14 <strncmp+0x6>
ffffffffc0203e2a:	40e7853b          	subw	a0,a5,a4
ffffffffc0203e2e:	8082                	ret
ffffffffc0203e30:	4501                	li	a0,0
ffffffffc0203e32:	8082                	ret

ffffffffc0203e34 <strchr>:
ffffffffc0203e34:	00054783          	lbu	a5,0(a0)
ffffffffc0203e38:	c799                	beqz	a5,ffffffffc0203e46 <strchr+0x12>
ffffffffc0203e3a:	00f58763          	beq	a1,a5,ffffffffc0203e48 <strchr+0x14>
ffffffffc0203e3e:	00154783          	lbu	a5,1(a0)
ffffffffc0203e42:	0505                	addi	a0,a0,1
ffffffffc0203e44:	fbfd                	bnez	a5,ffffffffc0203e3a <strchr+0x6>
ffffffffc0203e46:	4501                	li	a0,0
ffffffffc0203e48:	8082                	ret

ffffffffc0203e4a <memset>:
ffffffffc0203e4a:	ca01                	beqz	a2,ffffffffc0203e5a <memset+0x10>
ffffffffc0203e4c:	962a                	add	a2,a2,a0
ffffffffc0203e4e:	87aa                	mv	a5,a0
ffffffffc0203e50:	0785                	addi	a5,a5,1
ffffffffc0203e52:	feb78fa3          	sb	a1,-1(a5)
ffffffffc0203e56:	fec79de3          	bne	a5,a2,ffffffffc0203e50 <memset+0x6>
ffffffffc0203e5a:	8082                	ret

ffffffffc0203e5c <memcpy>:
ffffffffc0203e5c:	ca19                	beqz	a2,ffffffffc0203e72 <memcpy+0x16>
ffffffffc0203e5e:	962e                	add	a2,a2,a1
ffffffffc0203e60:	87aa                	mv	a5,a0
ffffffffc0203e62:	0005c703          	lbu	a4,0(a1)
ffffffffc0203e66:	0585                	addi	a1,a1,1
ffffffffc0203e68:	0785                	addi	a5,a5,1
ffffffffc0203e6a:	fee78fa3          	sb	a4,-1(a5)
ffffffffc0203e6e:	fec59ae3          	bne	a1,a2,ffffffffc0203e62 <memcpy+0x6>
ffffffffc0203e72:	8082                	ret

ffffffffc0203e74 <memcmp>:
ffffffffc0203e74:	c205                	beqz	a2,ffffffffc0203e94 <memcmp+0x20>
ffffffffc0203e76:	962e                	add	a2,a2,a1
ffffffffc0203e78:	a019                	j	ffffffffc0203e7e <memcmp+0xa>
ffffffffc0203e7a:	00c58d63          	beq	a1,a2,ffffffffc0203e94 <memcmp+0x20>
ffffffffc0203e7e:	00054783          	lbu	a5,0(a0)
ffffffffc0203e82:	0005c703          	lbu	a4,0(a1)
ffffffffc0203e86:	0505                	addi	a0,a0,1
ffffffffc0203e88:	0585                	addi	a1,a1,1
ffffffffc0203e8a:	fee788e3          	beq	a5,a4,ffffffffc0203e7a <memcmp+0x6>
ffffffffc0203e8e:	40e7853b          	subw	a0,a5,a4
ffffffffc0203e92:	8082                	ret
ffffffffc0203e94:	4501                	li	a0,0
ffffffffc0203e96:	8082                	ret
