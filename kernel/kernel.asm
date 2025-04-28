
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00019117          	auipc	sp,0x19
    80000004:	b3010113          	addi	sp,sp,-1232 # 80018b30 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	4a7040ef          	jal	80004cbc <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	e7a9                	bnez	a5,80000076 <kfree+0x5a>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00021797          	auipc	a5,0x21
    80000034:	c0078793          	addi	a5,a5,-1024 # 80020c30 <end>
    80000038:	02f56f63          	bltu	a0,a5,80000076 <kfree+0x5a>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	02f57b63          	bgeu	a0,a5,80000076 <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	106000ef          	jal	8000014e <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    8000004c:	00008917          	auipc	s2,0x8
    80000050:	8b490913          	addi	s2,s2,-1868 # 80007900 <kmem>
    80000054:	854a                	mv	a0,s2
    80000056:	6ce050ef          	jal	80005724 <acquire>
  r->next = kmem.freelist;
    8000005a:	01893783          	ld	a5,24(s2)
    8000005e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000060:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000064:	854a                	mv	a0,s2
    80000066:	752050ef          	jal	800057b8 <release>
}
    8000006a:	60e2                	ld	ra,24(sp)
    8000006c:	6442                	ld	s0,16(sp)
    8000006e:	64a2                	ld	s1,8(sp)
    80000070:	6902                	ld	s2,0(sp)
    80000072:	6105                	addi	sp,sp,32
    80000074:	8082                	ret
    panic("kfree");
    80000076:	00007517          	auipc	a0,0x7
    8000007a:	f8a50513          	addi	a0,a0,-118 # 80007000 <etext>
    8000007e:	378050ef          	jal	800053f6 <panic>

0000000080000082 <freerange>:
{
    80000082:	7179                	addi	sp,sp,-48
    80000084:	f406                	sd	ra,40(sp)
    80000086:	f022                	sd	s0,32(sp)
    80000088:	ec26                	sd	s1,24(sp)
    8000008a:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    8000008c:	6785                	lui	a5,0x1
    8000008e:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000092:	00e504b3          	add	s1,a0,a4
    80000096:	777d                	lui	a4,0xfffff
    80000098:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000009a:	94be                	add	s1,s1,a5
    8000009c:	0295e263          	bltu	a1,s1,800000c0 <freerange+0x3e>
    800000a0:	e84a                	sd	s2,16(sp)
    800000a2:	e44e                	sd	s3,8(sp)
    800000a4:	e052                	sd	s4,0(sp)
    800000a6:	892e                	mv	s2,a1
    kfree(p);
    800000a8:	8a3a                	mv	s4,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000aa:	89be                	mv	s3,a5
    kfree(p);
    800000ac:	01448533          	add	a0,s1,s4
    800000b0:	f6dff0ef          	jal	8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b4:	94ce                	add	s1,s1,s3
    800000b6:	fe997be3          	bgeu	s2,s1,800000ac <freerange+0x2a>
    800000ba:	6942                	ld	s2,16(sp)
    800000bc:	69a2                	ld	s3,8(sp)
    800000be:	6a02                	ld	s4,0(sp)
}
    800000c0:	70a2                	ld	ra,40(sp)
    800000c2:	7402                	ld	s0,32(sp)
    800000c4:	64e2                	ld	s1,24(sp)
    800000c6:	6145                	addi	sp,sp,48
    800000c8:	8082                	ret

00000000800000ca <kinit>:
{
    800000ca:	1141                	addi	sp,sp,-16
    800000cc:	e406                	sd	ra,8(sp)
    800000ce:	e022                	sd	s0,0(sp)
    800000d0:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000d2:	00007597          	auipc	a1,0x7
    800000d6:	f3e58593          	addi	a1,a1,-194 # 80007010 <etext+0x10>
    800000da:	00008517          	auipc	a0,0x8
    800000de:	82650513          	addi	a0,a0,-2010 # 80007900 <kmem>
    800000e2:	5be050ef          	jal	800056a0 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000e6:	45c5                	li	a1,17
    800000e8:	05ee                	slli	a1,a1,0x1b
    800000ea:	00021517          	auipc	a0,0x21
    800000ee:	b4650513          	addi	a0,a0,-1210 # 80020c30 <end>
    800000f2:	f91ff0ef          	jal	80000082 <freerange>
}
    800000f6:	60a2                	ld	ra,8(sp)
    800000f8:	6402                	ld	s0,0(sp)
    800000fa:	0141                	addi	sp,sp,16
    800000fc:	8082                	ret

00000000800000fe <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800000fe:	1101                	addi	sp,sp,-32
    80000100:	ec06                	sd	ra,24(sp)
    80000102:	e822                	sd	s0,16(sp)
    80000104:	e426                	sd	s1,8(sp)
    80000106:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000108:	00007497          	auipc	s1,0x7
    8000010c:	7f848493          	addi	s1,s1,2040 # 80007900 <kmem>
    80000110:	8526                	mv	a0,s1
    80000112:	612050ef          	jal	80005724 <acquire>
  r = kmem.freelist;
    80000116:	6c84                	ld	s1,24(s1)
  if(r)
    80000118:	c485                	beqz	s1,80000140 <kalloc+0x42>
    kmem.freelist = r->next;
    8000011a:	609c                	ld	a5,0(s1)
    8000011c:	00007517          	auipc	a0,0x7
    80000120:	7e450513          	addi	a0,a0,2020 # 80007900 <kmem>
    80000124:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000126:	692050ef          	jal	800057b8 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000012a:	6605                	lui	a2,0x1
    8000012c:	4595                	li	a1,5
    8000012e:	8526                	mv	a0,s1
    80000130:	01e000ef          	jal	8000014e <memset>
  return (void*)r;
}
    80000134:	8526                	mv	a0,s1
    80000136:	60e2                	ld	ra,24(sp)
    80000138:	6442                	ld	s0,16(sp)
    8000013a:	64a2                	ld	s1,8(sp)
    8000013c:	6105                	addi	sp,sp,32
    8000013e:	8082                	ret
  release(&kmem.lock);
    80000140:	00007517          	auipc	a0,0x7
    80000144:	7c050513          	addi	a0,a0,1984 # 80007900 <kmem>
    80000148:	670050ef          	jal	800057b8 <release>
  if(r)
    8000014c:	b7e5                	j	80000134 <kalloc+0x36>

000000008000014e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000014e:	1141                	addi	sp,sp,-16
    80000150:	e406                	sd	ra,8(sp)
    80000152:	e022                	sd	s0,0(sp)
    80000154:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000156:	ca19                	beqz	a2,8000016c <memset+0x1e>
    80000158:	87aa                	mv	a5,a0
    8000015a:	1602                	slli	a2,a2,0x20
    8000015c:	9201                	srli	a2,a2,0x20
    8000015e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000162:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000166:	0785                	addi	a5,a5,1
    80000168:	fee79de3          	bne	a5,a4,80000162 <memset+0x14>
  }
  return dst;
}
    8000016c:	60a2                	ld	ra,8(sp)
    8000016e:	6402                	ld	s0,0(sp)
    80000170:	0141                	addi	sp,sp,16
    80000172:	8082                	ret

0000000080000174 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000174:	1141                	addi	sp,sp,-16
    80000176:	e406                	sd	ra,8(sp)
    80000178:	e022                	sd	s0,0(sp)
    8000017a:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    8000017c:	ca0d                	beqz	a2,800001ae <memcmp+0x3a>
    8000017e:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000182:	1682                	slli	a3,a3,0x20
    80000184:	9281                	srli	a3,a3,0x20
    80000186:	0685                	addi	a3,a3,1
    80000188:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    8000018a:	00054783          	lbu	a5,0(a0)
    8000018e:	0005c703          	lbu	a4,0(a1)
    80000192:	00e79863          	bne	a5,a4,800001a2 <memcmp+0x2e>
      return *s1 - *s2;
    s1++, s2++;
    80000196:	0505                	addi	a0,a0,1
    80000198:	0585                	addi	a1,a1,1
  while(n-- > 0){
    8000019a:	fed518e3          	bne	a0,a3,8000018a <memcmp+0x16>
  }

  return 0;
    8000019e:	4501                	li	a0,0
    800001a0:	a019                	j	800001a6 <memcmp+0x32>
      return *s1 - *s2;
    800001a2:	40e7853b          	subw	a0,a5,a4
}
    800001a6:	60a2                	ld	ra,8(sp)
    800001a8:	6402                	ld	s0,0(sp)
    800001aa:	0141                	addi	sp,sp,16
    800001ac:	8082                	ret
  return 0;
    800001ae:	4501                	li	a0,0
    800001b0:	bfdd                	j	800001a6 <memcmp+0x32>

00000000800001b2 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001b2:	1141                	addi	sp,sp,-16
    800001b4:	e406                	sd	ra,8(sp)
    800001b6:	e022                	sd	s0,0(sp)
    800001b8:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001ba:	c205                	beqz	a2,800001da <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001bc:	02a5e363          	bltu	a1,a0,800001e2 <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001c0:	1602                	slli	a2,a2,0x20
    800001c2:	9201                	srli	a2,a2,0x20
    800001c4:	00c587b3          	add	a5,a1,a2
{
    800001c8:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ca:	0585                	addi	a1,a1,1
    800001cc:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffde3d1>
    800001ce:	fff5c683          	lbu	a3,-1(a1)
    800001d2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001d6:	feb79ae3          	bne	a5,a1,800001ca <memmove+0x18>

  return dst;
}
    800001da:	60a2                	ld	ra,8(sp)
    800001dc:	6402                	ld	s0,0(sp)
    800001de:	0141                	addi	sp,sp,16
    800001e0:	8082                	ret
  if(s < d && s + n > d){
    800001e2:	02061693          	slli	a3,a2,0x20
    800001e6:	9281                	srli	a3,a3,0x20
    800001e8:	00d58733          	add	a4,a1,a3
    800001ec:	fce57ae3          	bgeu	a0,a4,800001c0 <memmove+0xe>
    d += n;
    800001f0:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800001f2:	fff6079b          	addiw	a5,a2,-1
    800001f6:	1782                	slli	a5,a5,0x20
    800001f8:	9381                	srli	a5,a5,0x20
    800001fa:	fff7c793          	not	a5,a5
    800001fe:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000200:	177d                	addi	a4,a4,-1
    80000202:	16fd                	addi	a3,a3,-1
    80000204:	00074603          	lbu	a2,0(a4)
    80000208:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000020c:	fee79ae3          	bne	a5,a4,80000200 <memmove+0x4e>
    80000210:	b7e9                	j	800001da <memmove+0x28>

0000000080000212 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000212:	1141                	addi	sp,sp,-16
    80000214:	e406                	sd	ra,8(sp)
    80000216:	e022                	sd	s0,0(sp)
    80000218:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000021a:	f99ff0ef          	jal	800001b2 <memmove>
}
    8000021e:	60a2                	ld	ra,8(sp)
    80000220:	6402                	ld	s0,0(sp)
    80000222:	0141                	addi	sp,sp,16
    80000224:	8082                	ret

0000000080000226 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000226:	1141                	addi	sp,sp,-16
    80000228:	e406                	sd	ra,8(sp)
    8000022a:	e022                	sd	s0,0(sp)
    8000022c:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000022e:	ce11                	beqz	a2,8000024a <strncmp+0x24>
    80000230:	00054783          	lbu	a5,0(a0)
    80000234:	cf89                	beqz	a5,8000024e <strncmp+0x28>
    80000236:	0005c703          	lbu	a4,0(a1)
    8000023a:	00f71a63          	bne	a4,a5,8000024e <strncmp+0x28>
    n--, p++, q++;
    8000023e:	367d                	addiw	a2,a2,-1
    80000240:	0505                	addi	a0,a0,1
    80000242:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000244:	f675                	bnez	a2,80000230 <strncmp+0xa>
  if(n == 0)
    return 0;
    80000246:	4501                	li	a0,0
    80000248:	a801                	j	80000258 <strncmp+0x32>
    8000024a:	4501                	li	a0,0
    8000024c:	a031                	j	80000258 <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    8000024e:	00054503          	lbu	a0,0(a0)
    80000252:	0005c783          	lbu	a5,0(a1)
    80000256:	9d1d                	subw	a0,a0,a5
}
    80000258:	60a2                	ld	ra,8(sp)
    8000025a:	6402                	ld	s0,0(sp)
    8000025c:	0141                	addi	sp,sp,16
    8000025e:	8082                	ret

0000000080000260 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000260:	1141                	addi	sp,sp,-16
    80000262:	e406                	sd	ra,8(sp)
    80000264:	e022                	sd	s0,0(sp)
    80000266:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000268:	87aa                	mv	a5,a0
    8000026a:	86b2                	mv	a3,a2
    8000026c:	367d                	addiw	a2,a2,-1
    8000026e:	02d05563          	blez	a3,80000298 <strncpy+0x38>
    80000272:	0785                	addi	a5,a5,1
    80000274:	0005c703          	lbu	a4,0(a1)
    80000278:	fee78fa3          	sb	a4,-1(a5)
    8000027c:	0585                	addi	a1,a1,1
    8000027e:	f775                	bnez	a4,8000026a <strncpy+0xa>
    ;
  while(n-- > 0)
    80000280:	873e                	mv	a4,a5
    80000282:	00c05b63          	blez	a2,80000298 <strncpy+0x38>
    80000286:	9fb5                	addw	a5,a5,a3
    80000288:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    8000028a:	0705                	addi	a4,a4,1
    8000028c:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000290:	40e786bb          	subw	a3,a5,a4
    80000294:	fed04be3          	bgtz	a3,8000028a <strncpy+0x2a>
  return os;
}
    80000298:	60a2                	ld	ra,8(sp)
    8000029a:	6402                	ld	s0,0(sp)
    8000029c:	0141                	addi	sp,sp,16
    8000029e:	8082                	ret

00000000800002a0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002a0:	1141                	addi	sp,sp,-16
    800002a2:	e406                	sd	ra,8(sp)
    800002a4:	e022                	sd	s0,0(sp)
    800002a6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002a8:	02c05363          	blez	a2,800002ce <safestrcpy+0x2e>
    800002ac:	fff6069b          	addiw	a3,a2,-1
    800002b0:	1682                	slli	a3,a3,0x20
    800002b2:	9281                	srli	a3,a3,0x20
    800002b4:	96ae                	add	a3,a3,a1
    800002b6:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002b8:	00d58963          	beq	a1,a3,800002ca <safestrcpy+0x2a>
    800002bc:	0585                	addi	a1,a1,1
    800002be:	0785                	addi	a5,a5,1
    800002c0:	fff5c703          	lbu	a4,-1(a1)
    800002c4:	fee78fa3          	sb	a4,-1(a5)
    800002c8:	fb65                	bnez	a4,800002b8 <safestrcpy+0x18>
    ;
  *s = 0;
    800002ca:	00078023          	sb	zero,0(a5)
  return os;
}
    800002ce:	60a2                	ld	ra,8(sp)
    800002d0:	6402                	ld	s0,0(sp)
    800002d2:	0141                	addi	sp,sp,16
    800002d4:	8082                	ret

00000000800002d6 <strlen>:

int
strlen(const char *s)
{
    800002d6:	1141                	addi	sp,sp,-16
    800002d8:	e406                	sd	ra,8(sp)
    800002da:	e022                	sd	s0,0(sp)
    800002dc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002de:	00054783          	lbu	a5,0(a0)
    800002e2:	cf99                	beqz	a5,80000300 <strlen+0x2a>
    800002e4:	0505                	addi	a0,a0,1
    800002e6:	87aa                	mv	a5,a0
    800002e8:	86be                	mv	a3,a5
    800002ea:	0785                	addi	a5,a5,1
    800002ec:	fff7c703          	lbu	a4,-1(a5)
    800002f0:	ff65                	bnez	a4,800002e8 <strlen+0x12>
    800002f2:	40a6853b          	subw	a0,a3,a0
    800002f6:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    800002f8:	60a2                	ld	ra,8(sp)
    800002fa:	6402                	ld	s0,0(sp)
    800002fc:	0141                	addi	sp,sp,16
    800002fe:	8082                	ret
  for(n = 0; s[n]; n++)
    80000300:	4501                	li	a0,0
    80000302:	bfdd                	j	800002f8 <strlen+0x22>

0000000080000304 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000304:	1141                	addi	sp,sp,-16
    80000306:	e406                	sd	ra,8(sp)
    80000308:	e022                	sd	s0,0(sp)
    8000030a:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000030c:	21d000ef          	jal	80000d28 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000310:	00007717          	auipc	a4,0x7
    80000314:	5c070713          	addi	a4,a4,1472 # 800078d0 <started>
  if(cpuid() == 0){
    80000318:	c51d                	beqz	a0,80000346 <main+0x42>
    while(started == 0)
    8000031a:	431c                	lw	a5,0(a4)
    8000031c:	2781                	sext.w	a5,a5
    8000031e:	dff5                	beqz	a5,8000031a <main+0x16>
      ;
    __sync_synchronize();
    80000320:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000324:	205000ef          	jal	80000d28 <cpuid>
    80000328:	85aa                	mv	a1,a0
    8000032a:	00007517          	auipc	a0,0x7
    8000032e:	d0e50513          	addi	a0,a0,-754 # 80007038 <etext+0x38>
    80000332:	5f5040ef          	jal	80005126 <printf>
    kvminithart();    // turn on paging
    80000336:	080000ef          	jal	800003b6 <kvminithart>
    trapinithart();   // install kernel trap vector
    8000033a:	50c010ef          	jal	80001846 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000033e:	3ca040ef          	jal	80004708 <plicinithart>
  }

  scheduler();        
    80000342:	64f000ef          	jal	80001190 <scheduler>
    consoleinit();
    80000346:	513040ef          	jal	80005058 <consoleinit>
    printfinit();
    8000034a:	0e6050ef          	jal	80005430 <printfinit>
    printf("\n");
    8000034e:	00007517          	auipc	a0,0x7
    80000352:	cca50513          	addi	a0,a0,-822 # 80007018 <etext+0x18>
    80000356:	5d1040ef          	jal	80005126 <printf>
    printf("xv6 kernel is booting\n");
    8000035a:	00007517          	auipc	a0,0x7
    8000035e:	cc650513          	addi	a0,a0,-826 # 80007020 <etext+0x20>
    80000362:	5c5040ef          	jal	80005126 <printf>
    printf("\n");
    80000366:	00007517          	auipc	a0,0x7
    8000036a:	cb250513          	addi	a0,a0,-846 # 80007018 <etext+0x18>
    8000036e:	5b9040ef          	jal	80005126 <printf>
    kinit();         // physical page allocator
    80000372:	d59ff0ef          	jal	800000ca <kinit>
    kvminit();       // create kernel page table
    80000376:	2ce000ef          	jal	80000644 <kvminit>
    kvminithart();   // turn on paging
    8000037a:	03c000ef          	jal	800003b6 <kvminithart>
    procinit();      // process table
    8000037e:	0fb000ef          	jal	80000c78 <procinit>
    trapinit();      // trap vectors
    80000382:	4a0010ef          	jal	80001822 <trapinit>
    trapinithart();  // install kernel trap vector
    80000386:	4c0010ef          	jal	80001846 <trapinithart>
    plicinit();      // set up interrupt controller
    8000038a:	364040ef          	jal	800046ee <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000038e:	37a040ef          	jal	80004708 <plicinithart>
    binit();         // buffer cache
    80000392:	2e3010ef          	jal	80001e74 <binit>
    iinit();         // inode table
    80000396:	0ae020ef          	jal	80002444 <iinit>
    fileinit();      // file table
    8000039a:	67d020ef          	jal	80003216 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000039e:	45a040ef          	jal	800047f8 <virtio_disk_init>
    userinit();      // first user process
    800003a2:	423000ef          	jal	80000fc4 <userinit>
    __sync_synchronize();
    800003a6:	0330000f          	fence	rw,rw
    started = 1;
    800003aa:	4785                	li	a5,1
    800003ac:	00007717          	auipc	a4,0x7
    800003b0:	52f72223          	sw	a5,1316(a4) # 800078d0 <started>
    800003b4:	b779                	j	80000342 <main+0x3e>

00000000800003b6 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    800003b6:	1141                	addi	sp,sp,-16
    800003b8:	e406                	sd	ra,8(sp)
    800003ba:	e022                	sd	s0,0(sp)
    800003bc:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800003be:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800003c2:	00007797          	auipc	a5,0x7
    800003c6:	5167b783          	ld	a5,1302(a5) # 800078d8 <kernel_pagetable>
    800003ca:	83b1                	srli	a5,a5,0xc
    800003cc:	577d                	li	a4,-1
    800003ce:	177e                	slli	a4,a4,0x3f
    800003d0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800003d2:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800003d6:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800003da:	60a2                	ld	ra,8(sp)
    800003dc:	6402                	ld	s0,0(sp)
    800003de:	0141                	addi	sp,sp,16
    800003e0:	8082                	ret

00000000800003e2 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800003e2:	7139                	addi	sp,sp,-64
    800003e4:	fc06                	sd	ra,56(sp)
    800003e6:	f822                	sd	s0,48(sp)
    800003e8:	f426                	sd	s1,40(sp)
    800003ea:	f04a                	sd	s2,32(sp)
    800003ec:	ec4e                	sd	s3,24(sp)
    800003ee:	e852                	sd	s4,16(sp)
    800003f0:	e456                	sd	s5,8(sp)
    800003f2:	e05a                	sd	s6,0(sp)
    800003f4:	0080                	addi	s0,sp,64
    800003f6:	84aa                	mv	s1,a0
    800003f8:	89ae                	mv	s3,a1
    800003fa:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800003fc:	57fd                	li	a5,-1
    800003fe:	83e9                	srli	a5,a5,0x1a
    80000400:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000402:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000404:	04b7e263          	bltu	a5,a1,80000448 <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    80000408:	0149d933          	srl	s2,s3,s4
    8000040c:	1ff97913          	andi	s2,s2,511
    80000410:	090e                	slli	s2,s2,0x3
    80000412:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000414:	00093483          	ld	s1,0(s2)
    80000418:	0014f793          	andi	a5,s1,1
    8000041c:	cf85                	beqz	a5,80000454 <walk+0x72>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000041e:	80a9                	srli	s1,s1,0xa
    80000420:	04b2                	slli	s1,s1,0xc
  for(int level = 2; level > 0; level--) {
    80000422:	3a5d                	addiw	s4,s4,-9
    80000424:	ff6a12e3          	bne	s4,s6,80000408 <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    80000428:	00c9d513          	srli	a0,s3,0xc
    8000042c:	1ff57513          	andi	a0,a0,511
    80000430:	050e                	slli	a0,a0,0x3
    80000432:	9526                	add	a0,a0,s1
}
    80000434:	70e2                	ld	ra,56(sp)
    80000436:	7442                	ld	s0,48(sp)
    80000438:	74a2                	ld	s1,40(sp)
    8000043a:	7902                	ld	s2,32(sp)
    8000043c:	69e2                	ld	s3,24(sp)
    8000043e:	6a42                	ld	s4,16(sp)
    80000440:	6aa2                	ld	s5,8(sp)
    80000442:	6b02                	ld	s6,0(sp)
    80000444:	6121                	addi	sp,sp,64
    80000446:	8082                	ret
    panic("walk");
    80000448:	00007517          	auipc	a0,0x7
    8000044c:	c0850513          	addi	a0,a0,-1016 # 80007050 <etext+0x50>
    80000450:	7a7040ef          	jal	800053f6 <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000454:	020a8263          	beqz	s5,80000478 <walk+0x96>
    80000458:	ca7ff0ef          	jal	800000fe <kalloc>
    8000045c:	84aa                	mv	s1,a0
    8000045e:	d979                	beqz	a0,80000434 <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    80000460:	6605                	lui	a2,0x1
    80000462:	4581                	li	a1,0
    80000464:	cebff0ef          	jal	8000014e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000468:	00c4d793          	srli	a5,s1,0xc
    8000046c:	07aa                	slli	a5,a5,0xa
    8000046e:	0017e793          	ori	a5,a5,1
    80000472:	00f93023          	sd	a5,0(s2)
    80000476:	b775                	j	80000422 <walk+0x40>
        return 0;
    80000478:	4501                	li	a0,0
    8000047a:	bf6d                	j	80000434 <walk+0x52>

000000008000047c <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000047c:	57fd                	li	a5,-1
    8000047e:	83e9                	srli	a5,a5,0x1a
    80000480:	00b7f463          	bgeu	a5,a1,80000488 <walkaddr+0xc>
    return 0;
    80000484:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000486:	8082                	ret
{
    80000488:	1141                	addi	sp,sp,-16
    8000048a:	e406                	sd	ra,8(sp)
    8000048c:	e022                	sd	s0,0(sp)
    8000048e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000490:	4601                	li	a2,0
    80000492:	f51ff0ef          	jal	800003e2 <walk>
  if(pte == 0)
    80000496:	c105                	beqz	a0,800004b6 <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80000498:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000049a:	0117f693          	andi	a3,a5,17
    8000049e:	4745                	li	a4,17
    return 0;
    800004a0:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800004a2:	00e68663          	beq	a3,a4,800004ae <walkaddr+0x32>
}
    800004a6:	60a2                	ld	ra,8(sp)
    800004a8:	6402                	ld	s0,0(sp)
    800004aa:	0141                	addi	sp,sp,16
    800004ac:	8082                	ret
  pa = PTE2PA(*pte);
    800004ae:	83a9                	srli	a5,a5,0xa
    800004b0:	00c79513          	slli	a0,a5,0xc
  return pa;
    800004b4:	bfcd                	j	800004a6 <walkaddr+0x2a>
    return 0;
    800004b6:	4501                	li	a0,0
    800004b8:	b7fd                	j	800004a6 <walkaddr+0x2a>

00000000800004ba <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800004ba:	715d                	addi	sp,sp,-80
    800004bc:	e486                	sd	ra,72(sp)
    800004be:	e0a2                	sd	s0,64(sp)
    800004c0:	fc26                	sd	s1,56(sp)
    800004c2:	f84a                	sd	s2,48(sp)
    800004c4:	f44e                	sd	s3,40(sp)
    800004c6:	f052                	sd	s4,32(sp)
    800004c8:	ec56                	sd	s5,24(sp)
    800004ca:	e85a                	sd	s6,16(sp)
    800004cc:	e45e                	sd	s7,8(sp)
    800004ce:	e062                	sd	s8,0(sp)
    800004d0:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800004d2:	03459793          	slli	a5,a1,0x34
    800004d6:	e7b1                	bnez	a5,80000522 <mappages+0x68>
    800004d8:	8aaa                	mv	s5,a0
    800004da:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800004dc:	03461793          	slli	a5,a2,0x34
    800004e0:	e7b9                	bnez	a5,8000052e <mappages+0x74>
    panic("mappages: size not aligned");

  if(size == 0)
    800004e2:	ce21                	beqz	a2,8000053a <mappages+0x80>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    800004e4:	77fd                	lui	a5,0xfffff
    800004e6:	963e                	add	a2,a2,a5
    800004e8:	00b609b3          	add	s3,a2,a1
  a = va;
    800004ec:	892e                	mv	s2,a1
    800004ee:	40b68a33          	sub	s4,a3,a1
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    800004f2:	4b85                	li	s7,1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800004f4:	6c05                	lui	s8,0x1
    800004f6:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    800004fa:	865e                	mv	a2,s7
    800004fc:	85ca                	mv	a1,s2
    800004fe:	8556                	mv	a0,s5
    80000500:	ee3ff0ef          	jal	800003e2 <walk>
    80000504:	c539                	beqz	a0,80000552 <mappages+0x98>
    if(*pte & PTE_V)
    80000506:	611c                	ld	a5,0(a0)
    80000508:	8b85                	andi	a5,a5,1
    8000050a:	ef95                	bnez	a5,80000546 <mappages+0x8c>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000050c:	80b1                	srli	s1,s1,0xc
    8000050e:	04aa                	slli	s1,s1,0xa
    80000510:	0164e4b3          	or	s1,s1,s6
    80000514:	0014e493          	ori	s1,s1,1
    80000518:	e104                	sd	s1,0(a0)
    if(a == last)
    8000051a:	05390963          	beq	s2,s3,8000056c <mappages+0xb2>
    a += PGSIZE;
    8000051e:	9962                	add	s2,s2,s8
    if((pte = walk(pagetable, a, 1)) == 0)
    80000520:	bfd9                	j	800004f6 <mappages+0x3c>
    panic("mappages: va not aligned");
    80000522:	00007517          	auipc	a0,0x7
    80000526:	b3650513          	addi	a0,a0,-1226 # 80007058 <etext+0x58>
    8000052a:	6cd040ef          	jal	800053f6 <panic>
    panic("mappages: size not aligned");
    8000052e:	00007517          	auipc	a0,0x7
    80000532:	b4a50513          	addi	a0,a0,-1206 # 80007078 <etext+0x78>
    80000536:	6c1040ef          	jal	800053f6 <panic>
    panic("mappages: size");
    8000053a:	00007517          	auipc	a0,0x7
    8000053e:	b5e50513          	addi	a0,a0,-1186 # 80007098 <etext+0x98>
    80000542:	6b5040ef          	jal	800053f6 <panic>
      panic("mappages: remap");
    80000546:	00007517          	auipc	a0,0x7
    8000054a:	b6250513          	addi	a0,a0,-1182 # 800070a8 <etext+0xa8>
    8000054e:	6a9040ef          	jal	800053f6 <panic>
      return -1;
    80000552:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000554:	60a6                	ld	ra,72(sp)
    80000556:	6406                	ld	s0,64(sp)
    80000558:	74e2                	ld	s1,56(sp)
    8000055a:	7942                	ld	s2,48(sp)
    8000055c:	79a2                	ld	s3,40(sp)
    8000055e:	7a02                	ld	s4,32(sp)
    80000560:	6ae2                	ld	s5,24(sp)
    80000562:	6b42                	ld	s6,16(sp)
    80000564:	6ba2                	ld	s7,8(sp)
    80000566:	6c02                	ld	s8,0(sp)
    80000568:	6161                	addi	sp,sp,80
    8000056a:	8082                	ret
  return 0;
    8000056c:	4501                	li	a0,0
    8000056e:	b7dd                	j	80000554 <mappages+0x9a>

0000000080000570 <kvmmap>:
{
    80000570:	1141                	addi	sp,sp,-16
    80000572:	e406                	sd	ra,8(sp)
    80000574:	e022                	sd	s0,0(sp)
    80000576:	0800                	addi	s0,sp,16
    80000578:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000057a:	86b2                	mv	a3,a2
    8000057c:	863e                	mv	a2,a5
    8000057e:	f3dff0ef          	jal	800004ba <mappages>
    80000582:	e509                	bnez	a0,8000058c <kvmmap+0x1c>
}
    80000584:	60a2                	ld	ra,8(sp)
    80000586:	6402                	ld	s0,0(sp)
    80000588:	0141                	addi	sp,sp,16
    8000058a:	8082                	ret
    panic("kvmmap");
    8000058c:	00007517          	auipc	a0,0x7
    80000590:	b2c50513          	addi	a0,a0,-1236 # 800070b8 <etext+0xb8>
    80000594:	663040ef          	jal	800053f6 <panic>

0000000080000598 <kvmmake>:
{
    80000598:	1101                	addi	sp,sp,-32
    8000059a:	ec06                	sd	ra,24(sp)
    8000059c:	e822                	sd	s0,16(sp)
    8000059e:	e426                	sd	s1,8(sp)
    800005a0:	e04a                	sd	s2,0(sp)
    800005a2:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800005a4:	b5bff0ef          	jal	800000fe <kalloc>
    800005a8:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800005aa:	6605                	lui	a2,0x1
    800005ac:	4581                	li	a1,0
    800005ae:	ba1ff0ef          	jal	8000014e <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800005b2:	4719                	li	a4,6
    800005b4:	6685                	lui	a3,0x1
    800005b6:	10000637          	lui	a2,0x10000
    800005ba:	85b2                	mv	a1,a2
    800005bc:	8526                	mv	a0,s1
    800005be:	fb3ff0ef          	jal	80000570 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800005c2:	4719                	li	a4,6
    800005c4:	6685                	lui	a3,0x1
    800005c6:	10001637          	lui	a2,0x10001
    800005ca:	85b2                	mv	a1,a2
    800005cc:	8526                	mv	a0,s1
    800005ce:	fa3ff0ef          	jal	80000570 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800005d2:	4719                	li	a4,6
    800005d4:	040006b7          	lui	a3,0x4000
    800005d8:	0c000637          	lui	a2,0xc000
    800005dc:	85b2                	mv	a1,a2
    800005de:	8526                	mv	a0,s1
    800005e0:	f91ff0ef          	jal	80000570 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800005e4:	00007917          	auipc	s2,0x7
    800005e8:	a1c90913          	addi	s2,s2,-1508 # 80007000 <etext>
    800005ec:	4729                	li	a4,10
    800005ee:	80007697          	auipc	a3,0x80007
    800005f2:	a1268693          	addi	a3,a3,-1518 # 7000 <_entry-0x7fff9000>
    800005f6:	4605                	li	a2,1
    800005f8:	067e                	slli	a2,a2,0x1f
    800005fa:	85b2                	mv	a1,a2
    800005fc:	8526                	mv	a0,s1
    800005fe:	f73ff0ef          	jal	80000570 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80000602:	4719                	li	a4,6
    80000604:	46c5                	li	a3,17
    80000606:	06ee                	slli	a3,a3,0x1b
    80000608:	412686b3          	sub	a3,a3,s2
    8000060c:	864a                	mv	a2,s2
    8000060e:	85ca                	mv	a1,s2
    80000610:	8526                	mv	a0,s1
    80000612:	f5fff0ef          	jal	80000570 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000616:	4729                	li	a4,10
    80000618:	6685                	lui	a3,0x1
    8000061a:	00006617          	auipc	a2,0x6
    8000061e:	9e660613          	addi	a2,a2,-1562 # 80006000 <_trampoline>
    80000622:	040005b7          	lui	a1,0x4000
    80000626:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000628:	05b2                	slli	a1,a1,0xc
    8000062a:	8526                	mv	a0,s1
    8000062c:	f45ff0ef          	jal	80000570 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000630:	8526                	mv	a0,s1
    80000632:	5a8000ef          	jal	80000bda <proc_mapstacks>
}
    80000636:	8526                	mv	a0,s1
    80000638:	60e2                	ld	ra,24(sp)
    8000063a:	6442                	ld	s0,16(sp)
    8000063c:	64a2                	ld	s1,8(sp)
    8000063e:	6902                	ld	s2,0(sp)
    80000640:	6105                	addi	sp,sp,32
    80000642:	8082                	ret

0000000080000644 <kvminit>:
{
    80000644:	1141                	addi	sp,sp,-16
    80000646:	e406                	sd	ra,8(sp)
    80000648:	e022                	sd	s0,0(sp)
    8000064a:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000064c:	f4dff0ef          	jal	80000598 <kvmmake>
    80000650:	00007797          	auipc	a5,0x7
    80000654:	28a7b423          	sd	a0,648(a5) # 800078d8 <kernel_pagetable>
}
    80000658:	60a2                	ld	ra,8(sp)
    8000065a:	6402                	ld	s0,0(sp)
    8000065c:	0141                	addi	sp,sp,16
    8000065e:	8082                	ret

0000000080000660 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000660:	715d                	addi	sp,sp,-80
    80000662:	e486                	sd	ra,72(sp)
    80000664:	e0a2                	sd	s0,64(sp)
    80000666:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000668:	03459793          	slli	a5,a1,0x34
    8000066c:	e39d                	bnez	a5,80000692 <uvmunmap+0x32>
    8000066e:	f84a                	sd	s2,48(sp)
    80000670:	f44e                	sd	s3,40(sp)
    80000672:	f052                	sd	s4,32(sp)
    80000674:	ec56                	sd	s5,24(sp)
    80000676:	e85a                	sd	s6,16(sp)
    80000678:	e45e                	sd	s7,8(sp)
    8000067a:	8a2a                	mv	s4,a0
    8000067c:	892e                	mv	s2,a1
    8000067e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000680:	0632                	slli	a2,a2,0xc
    80000682:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000686:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000688:	6b05                	lui	s6,0x1
    8000068a:	0735ff63          	bgeu	a1,s3,80000708 <uvmunmap+0xa8>
    8000068e:	fc26                	sd	s1,56(sp)
    80000690:	a0a9                	j	800006da <uvmunmap+0x7a>
    80000692:	fc26                	sd	s1,56(sp)
    80000694:	f84a                	sd	s2,48(sp)
    80000696:	f44e                	sd	s3,40(sp)
    80000698:	f052                	sd	s4,32(sp)
    8000069a:	ec56                	sd	s5,24(sp)
    8000069c:	e85a                	sd	s6,16(sp)
    8000069e:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    800006a0:	00007517          	auipc	a0,0x7
    800006a4:	a2050513          	addi	a0,a0,-1504 # 800070c0 <etext+0xc0>
    800006a8:	54f040ef          	jal	800053f6 <panic>
      panic("uvmunmap: walk");
    800006ac:	00007517          	auipc	a0,0x7
    800006b0:	a2c50513          	addi	a0,a0,-1492 # 800070d8 <etext+0xd8>
    800006b4:	543040ef          	jal	800053f6 <panic>
      panic("uvmunmap: not mapped");
    800006b8:	00007517          	auipc	a0,0x7
    800006bc:	a3050513          	addi	a0,a0,-1488 # 800070e8 <etext+0xe8>
    800006c0:	537040ef          	jal	800053f6 <panic>
      panic("uvmunmap: not a leaf");
    800006c4:	00007517          	auipc	a0,0x7
    800006c8:	a3c50513          	addi	a0,a0,-1476 # 80007100 <etext+0x100>
    800006cc:	52b040ef          	jal	800053f6 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800006d0:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800006d4:	995a                	add	s2,s2,s6
    800006d6:	03397863          	bgeu	s2,s3,80000706 <uvmunmap+0xa6>
    if((pte = walk(pagetable, a, 0)) == 0)
    800006da:	4601                	li	a2,0
    800006dc:	85ca                	mv	a1,s2
    800006de:	8552                	mv	a0,s4
    800006e0:	d03ff0ef          	jal	800003e2 <walk>
    800006e4:	84aa                	mv	s1,a0
    800006e6:	d179                	beqz	a0,800006ac <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0)
    800006e8:	6108                	ld	a0,0(a0)
    800006ea:	00157793          	andi	a5,a0,1
    800006ee:	d7e9                	beqz	a5,800006b8 <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    800006f0:	3ff57793          	andi	a5,a0,1023
    800006f4:	fd7788e3          	beq	a5,s7,800006c4 <uvmunmap+0x64>
    if(do_free){
    800006f8:	fc0a8ce3          	beqz	s5,800006d0 <uvmunmap+0x70>
      uint64 pa = PTE2PA(*pte);
    800006fc:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800006fe:	0532                	slli	a0,a0,0xc
    80000700:	91dff0ef          	jal	8000001c <kfree>
    80000704:	b7f1                	j	800006d0 <uvmunmap+0x70>
    80000706:	74e2                	ld	s1,56(sp)
    80000708:	7942                	ld	s2,48(sp)
    8000070a:	79a2                	ld	s3,40(sp)
    8000070c:	7a02                	ld	s4,32(sp)
    8000070e:	6ae2                	ld	s5,24(sp)
    80000710:	6b42                	ld	s6,16(sp)
    80000712:	6ba2                	ld	s7,8(sp)
  }
}
    80000714:	60a6                	ld	ra,72(sp)
    80000716:	6406                	ld	s0,64(sp)
    80000718:	6161                	addi	sp,sp,80
    8000071a:	8082                	ret

000000008000071c <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000071c:	1101                	addi	sp,sp,-32
    8000071e:	ec06                	sd	ra,24(sp)
    80000720:	e822                	sd	s0,16(sp)
    80000722:	e426                	sd	s1,8(sp)
    80000724:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000726:	9d9ff0ef          	jal	800000fe <kalloc>
    8000072a:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000072c:	c509                	beqz	a0,80000736 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000072e:	6605                	lui	a2,0x1
    80000730:	4581                	li	a1,0
    80000732:	a1dff0ef          	jal	8000014e <memset>
  return pagetable;
}
    80000736:	8526                	mv	a0,s1
    80000738:	60e2                	ld	ra,24(sp)
    8000073a:	6442                	ld	s0,16(sp)
    8000073c:	64a2                	ld	s1,8(sp)
    8000073e:	6105                	addi	sp,sp,32
    80000740:	8082                	ret

0000000080000742 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000742:	7179                	addi	sp,sp,-48
    80000744:	f406                	sd	ra,40(sp)
    80000746:	f022                	sd	s0,32(sp)
    80000748:	ec26                	sd	s1,24(sp)
    8000074a:	e84a                	sd	s2,16(sp)
    8000074c:	e44e                	sd	s3,8(sp)
    8000074e:	e052                	sd	s4,0(sp)
    80000750:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000752:	6785                	lui	a5,0x1
    80000754:	04f67063          	bgeu	a2,a5,80000794 <uvmfirst+0x52>
    80000758:	8a2a                	mv	s4,a0
    8000075a:	89ae                	mv	s3,a1
    8000075c:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    8000075e:	9a1ff0ef          	jal	800000fe <kalloc>
    80000762:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000764:	6605                	lui	a2,0x1
    80000766:	4581                	li	a1,0
    80000768:	9e7ff0ef          	jal	8000014e <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000076c:	4779                	li	a4,30
    8000076e:	86ca                	mv	a3,s2
    80000770:	6605                	lui	a2,0x1
    80000772:	4581                	li	a1,0
    80000774:	8552                	mv	a0,s4
    80000776:	d45ff0ef          	jal	800004ba <mappages>
  memmove(mem, src, sz);
    8000077a:	8626                	mv	a2,s1
    8000077c:	85ce                	mv	a1,s3
    8000077e:	854a                	mv	a0,s2
    80000780:	a33ff0ef          	jal	800001b2 <memmove>
}
    80000784:	70a2                	ld	ra,40(sp)
    80000786:	7402                	ld	s0,32(sp)
    80000788:	64e2                	ld	s1,24(sp)
    8000078a:	6942                	ld	s2,16(sp)
    8000078c:	69a2                	ld	s3,8(sp)
    8000078e:	6a02                	ld	s4,0(sp)
    80000790:	6145                	addi	sp,sp,48
    80000792:	8082                	ret
    panic("uvmfirst: more than a page");
    80000794:	00007517          	auipc	a0,0x7
    80000798:	98450513          	addi	a0,a0,-1660 # 80007118 <etext+0x118>
    8000079c:	45b040ef          	jal	800053f6 <panic>

00000000800007a0 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800007a0:	1101                	addi	sp,sp,-32
    800007a2:	ec06                	sd	ra,24(sp)
    800007a4:	e822                	sd	s0,16(sp)
    800007a6:	e426                	sd	s1,8(sp)
    800007a8:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800007aa:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800007ac:	00b67d63          	bgeu	a2,a1,800007c6 <uvmdealloc+0x26>
    800007b0:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800007b2:	6785                	lui	a5,0x1
    800007b4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800007b6:	00f60733          	add	a4,a2,a5
    800007ba:	76fd                	lui	a3,0xfffff
    800007bc:	8f75                	and	a4,a4,a3
    800007be:	97ae                	add	a5,a5,a1
    800007c0:	8ff5                	and	a5,a5,a3
    800007c2:	00f76863          	bltu	a4,a5,800007d2 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800007c6:	8526                	mv	a0,s1
    800007c8:	60e2                	ld	ra,24(sp)
    800007ca:	6442                	ld	s0,16(sp)
    800007cc:	64a2                	ld	s1,8(sp)
    800007ce:	6105                	addi	sp,sp,32
    800007d0:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800007d2:	8f99                	sub	a5,a5,a4
    800007d4:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800007d6:	4685                	li	a3,1
    800007d8:	0007861b          	sext.w	a2,a5
    800007dc:	85ba                	mv	a1,a4
    800007de:	e83ff0ef          	jal	80000660 <uvmunmap>
    800007e2:	b7d5                	j	800007c6 <uvmdealloc+0x26>

00000000800007e4 <uvmalloc>:
  if(newsz < oldsz)
    800007e4:	0ab66363          	bltu	a2,a1,8000088a <uvmalloc+0xa6>
{
    800007e8:	715d                	addi	sp,sp,-80
    800007ea:	e486                	sd	ra,72(sp)
    800007ec:	e0a2                	sd	s0,64(sp)
    800007ee:	f052                	sd	s4,32(sp)
    800007f0:	ec56                	sd	s5,24(sp)
    800007f2:	e85a                	sd	s6,16(sp)
    800007f4:	0880                	addi	s0,sp,80
    800007f6:	8b2a                	mv	s6,a0
    800007f8:	8ab2                	mv	s5,a2
  oldsz = PGROUNDUP(oldsz);
    800007fa:	6785                	lui	a5,0x1
    800007fc:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800007fe:	95be                	add	a1,a1,a5
    80000800:	77fd                	lui	a5,0xfffff
    80000802:	00f5fa33          	and	s4,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000806:	08ca7463          	bgeu	s4,a2,8000088e <uvmalloc+0xaa>
    8000080a:	fc26                	sd	s1,56(sp)
    8000080c:	f84a                	sd	s2,48(sp)
    8000080e:	f44e                	sd	s3,40(sp)
    80000810:	e45e                	sd	s7,8(sp)
    80000812:	8952                	mv	s2,s4
    memset(mem, 0, PGSIZE);
    80000814:	6985                	lui	s3,0x1
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000816:	0126eb93          	ori	s7,a3,18
    mem = kalloc();
    8000081a:	8e5ff0ef          	jal	800000fe <kalloc>
    8000081e:	84aa                	mv	s1,a0
    if(mem == 0){
    80000820:	c515                	beqz	a0,8000084c <uvmalloc+0x68>
    memset(mem, 0, PGSIZE);
    80000822:	864e                	mv	a2,s3
    80000824:	4581                	li	a1,0
    80000826:	929ff0ef          	jal	8000014e <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000082a:	875e                	mv	a4,s7
    8000082c:	86a6                	mv	a3,s1
    8000082e:	864e                	mv	a2,s3
    80000830:	85ca                	mv	a1,s2
    80000832:	855a                	mv	a0,s6
    80000834:	c87ff0ef          	jal	800004ba <mappages>
    80000838:	e91d                	bnez	a0,8000086e <uvmalloc+0x8a>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000083a:	994e                	add	s2,s2,s3
    8000083c:	fd596fe3          	bltu	s2,s5,8000081a <uvmalloc+0x36>
  return newsz;
    80000840:	8556                	mv	a0,s5
    80000842:	74e2                	ld	s1,56(sp)
    80000844:	7942                	ld	s2,48(sp)
    80000846:	79a2                	ld	s3,40(sp)
    80000848:	6ba2                	ld	s7,8(sp)
    8000084a:	a819                	j	80000860 <uvmalloc+0x7c>
      uvmdealloc(pagetable, a, oldsz);
    8000084c:	8652                	mv	a2,s4
    8000084e:	85ca                	mv	a1,s2
    80000850:	855a                	mv	a0,s6
    80000852:	f4fff0ef          	jal	800007a0 <uvmdealloc>
      return 0;
    80000856:	4501                	li	a0,0
    80000858:	74e2                	ld	s1,56(sp)
    8000085a:	7942                	ld	s2,48(sp)
    8000085c:	79a2                	ld	s3,40(sp)
    8000085e:	6ba2                	ld	s7,8(sp)
}
    80000860:	60a6                	ld	ra,72(sp)
    80000862:	6406                	ld	s0,64(sp)
    80000864:	7a02                	ld	s4,32(sp)
    80000866:	6ae2                	ld	s5,24(sp)
    80000868:	6b42                	ld	s6,16(sp)
    8000086a:	6161                	addi	sp,sp,80
    8000086c:	8082                	ret
      kfree(mem);
    8000086e:	8526                	mv	a0,s1
    80000870:	facff0ef          	jal	8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000874:	8652                	mv	a2,s4
    80000876:	85ca                	mv	a1,s2
    80000878:	855a                	mv	a0,s6
    8000087a:	f27ff0ef          	jal	800007a0 <uvmdealloc>
      return 0;
    8000087e:	4501                	li	a0,0
    80000880:	74e2                	ld	s1,56(sp)
    80000882:	7942                	ld	s2,48(sp)
    80000884:	79a2                	ld	s3,40(sp)
    80000886:	6ba2                	ld	s7,8(sp)
    80000888:	bfe1                	j	80000860 <uvmalloc+0x7c>
    return oldsz;
    8000088a:	852e                	mv	a0,a1
}
    8000088c:	8082                	ret
  return newsz;
    8000088e:	8532                	mv	a0,a2
    80000890:	bfc1                	j	80000860 <uvmalloc+0x7c>

0000000080000892 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000892:	7179                	addi	sp,sp,-48
    80000894:	f406                	sd	ra,40(sp)
    80000896:	f022                	sd	s0,32(sp)
    80000898:	ec26                	sd	s1,24(sp)
    8000089a:	e84a                	sd	s2,16(sp)
    8000089c:	e44e                	sd	s3,8(sp)
    8000089e:	e052                	sd	s4,0(sp)
    800008a0:	1800                	addi	s0,sp,48
    800008a2:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800008a4:	84aa                	mv	s1,a0
    800008a6:	6905                	lui	s2,0x1
    800008a8:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800008aa:	4985                	li	s3,1
    800008ac:	a819                	j	800008c2 <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800008ae:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800008b0:	00c79513          	slli	a0,a5,0xc
    800008b4:	fdfff0ef          	jal	80000892 <freewalk>
      pagetable[i] = 0;
    800008b8:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800008bc:	04a1                	addi	s1,s1,8
    800008be:	01248f63          	beq	s1,s2,800008dc <freewalk+0x4a>
    pte_t pte = pagetable[i];
    800008c2:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800008c4:	00f7f713          	andi	a4,a5,15
    800008c8:	ff3703e3          	beq	a4,s3,800008ae <freewalk+0x1c>
    } else if(pte & PTE_V){
    800008cc:	8b85                	andi	a5,a5,1
    800008ce:	d7fd                	beqz	a5,800008bc <freewalk+0x2a>
      panic("freewalk: leaf");
    800008d0:	00007517          	auipc	a0,0x7
    800008d4:	86850513          	addi	a0,a0,-1944 # 80007138 <etext+0x138>
    800008d8:	31f040ef          	jal	800053f6 <panic>
    }
  }
  kfree((void*)pagetable);
    800008dc:	8552                	mv	a0,s4
    800008de:	f3eff0ef          	jal	8000001c <kfree>
}
    800008e2:	70a2                	ld	ra,40(sp)
    800008e4:	7402                	ld	s0,32(sp)
    800008e6:	64e2                	ld	s1,24(sp)
    800008e8:	6942                	ld	s2,16(sp)
    800008ea:	69a2                	ld	s3,8(sp)
    800008ec:	6a02                	ld	s4,0(sp)
    800008ee:	6145                	addi	sp,sp,48
    800008f0:	8082                	ret

00000000800008f2 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800008f2:	1101                	addi	sp,sp,-32
    800008f4:	ec06                	sd	ra,24(sp)
    800008f6:	e822                	sd	s0,16(sp)
    800008f8:	e426                	sd	s1,8(sp)
    800008fa:	1000                	addi	s0,sp,32
    800008fc:	84aa                	mv	s1,a0
  if(sz > 0)
    800008fe:	e989                	bnez	a1,80000910 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000900:	8526                	mv	a0,s1
    80000902:	f91ff0ef          	jal	80000892 <freewalk>
}
    80000906:	60e2                	ld	ra,24(sp)
    80000908:	6442                	ld	s0,16(sp)
    8000090a:	64a2                	ld	s1,8(sp)
    8000090c:	6105                	addi	sp,sp,32
    8000090e:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000910:	6785                	lui	a5,0x1
    80000912:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000914:	95be                	add	a1,a1,a5
    80000916:	4685                	li	a3,1
    80000918:	00c5d613          	srli	a2,a1,0xc
    8000091c:	4581                	li	a1,0
    8000091e:	d43ff0ef          	jal	80000660 <uvmunmap>
    80000922:	bff9                	j	80000900 <uvmfree+0xe>

0000000080000924 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000924:	ca4d                	beqz	a2,800009d6 <uvmcopy+0xb2>
{
    80000926:	715d                	addi	sp,sp,-80
    80000928:	e486                	sd	ra,72(sp)
    8000092a:	e0a2                	sd	s0,64(sp)
    8000092c:	fc26                	sd	s1,56(sp)
    8000092e:	f84a                	sd	s2,48(sp)
    80000930:	f44e                	sd	s3,40(sp)
    80000932:	f052                	sd	s4,32(sp)
    80000934:	ec56                	sd	s5,24(sp)
    80000936:	e85a                	sd	s6,16(sp)
    80000938:	e45e                	sd	s7,8(sp)
    8000093a:	e062                	sd	s8,0(sp)
    8000093c:	0880                	addi	s0,sp,80
    8000093e:	8baa                	mv	s7,a0
    80000940:	8b2e                	mv	s6,a1
    80000942:	8ab2                	mv	s5,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000944:	4981                	li	s3,0
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000946:	6a05                	lui	s4,0x1
    if((pte = walk(old, i, 0)) == 0)
    80000948:	4601                	li	a2,0
    8000094a:	85ce                	mv	a1,s3
    8000094c:	855e                	mv	a0,s7
    8000094e:	a95ff0ef          	jal	800003e2 <walk>
    80000952:	cd1d                	beqz	a0,80000990 <uvmcopy+0x6c>
    if((*pte & PTE_V) == 0)
    80000954:	6118                	ld	a4,0(a0)
    80000956:	00177793          	andi	a5,a4,1
    8000095a:	c3a9                	beqz	a5,8000099c <uvmcopy+0x78>
    pa = PTE2PA(*pte);
    8000095c:	00a75593          	srli	a1,a4,0xa
    80000960:	00c59c13          	slli	s8,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000964:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000968:	f96ff0ef          	jal	800000fe <kalloc>
    8000096c:	892a                	mv	s2,a0
    8000096e:	c121                	beqz	a0,800009ae <uvmcopy+0x8a>
    memmove(mem, (char*)pa, PGSIZE);
    80000970:	8652                	mv	a2,s4
    80000972:	85e2                	mv	a1,s8
    80000974:	83fff0ef          	jal	800001b2 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000978:	8726                	mv	a4,s1
    8000097a:	86ca                	mv	a3,s2
    8000097c:	8652                	mv	a2,s4
    8000097e:	85ce                	mv	a1,s3
    80000980:	855a                	mv	a0,s6
    80000982:	b39ff0ef          	jal	800004ba <mappages>
    80000986:	e10d                	bnez	a0,800009a8 <uvmcopy+0x84>
  for(i = 0; i < sz; i += PGSIZE){
    80000988:	99d2                	add	s3,s3,s4
    8000098a:	fb59efe3          	bltu	s3,s5,80000948 <uvmcopy+0x24>
    8000098e:	a805                	j	800009be <uvmcopy+0x9a>
      panic("uvmcopy: pte should exist");
    80000990:	00006517          	auipc	a0,0x6
    80000994:	7b850513          	addi	a0,a0,1976 # 80007148 <etext+0x148>
    80000998:	25f040ef          	jal	800053f6 <panic>
      panic("uvmcopy: page not present");
    8000099c:	00006517          	auipc	a0,0x6
    800009a0:	7cc50513          	addi	a0,a0,1996 # 80007168 <etext+0x168>
    800009a4:	253040ef          	jal	800053f6 <panic>
      kfree(mem);
    800009a8:	854a                	mv	a0,s2
    800009aa:	e72ff0ef          	jal	8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800009ae:	4685                	li	a3,1
    800009b0:	00c9d613          	srli	a2,s3,0xc
    800009b4:	4581                	li	a1,0
    800009b6:	855a                	mv	a0,s6
    800009b8:	ca9ff0ef          	jal	80000660 <uvmunmap>
  return -1;
    800009bc:	557d                	li	a0,-1
}
    800009be:	60a6                	ld	ra,72(sp)
    800009c0:	6406                	ld	s0,64(sp)
    800009c2:	74e2                	ld	s1,56(sp)
    800009c4:	7942                	ld	s2,48(sp)
    800009c6:	79a2                	ld	s3,40(sp)
    800009c8:	7a02                	ld	s4,32(sp)
    800009ca:	6ae2                	ld	s5,24(sp)
    800009cc:	6b42                	ld	s6,16(sp)
    800009ce:	6ba2                	ld	s7,8(sp)
    800009d0:	6c02                	ld	s8,0(sp)
    800009d2:	6161                	addi	sp,sp,80
    800009d4:	8082                	ret
  return 0;
    800009d6:	4501                	li	a0,0
}
    800009d8:	8082                	ret

00000000800009da <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800009da:	1141                	addi	sp,sp,-16
    800009dc:	e406                	sd	ra,8(sp)
    800009de:	e022                	sd	s0,0(sp)
    800009e0:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800009e2:	4601                	li	a2,0
    800009e4:	9ffff0ef          	jal	800003e2 <walk>
  if(pte == 0)
    800009e8:	c901                	beqz	a0,800009f8 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800009ea:	611c                	ld	a5,0(a0)
    800009ec:	9bbd                	andi	a5,a5,-17
    800009ee:	e11c                	sd	a5,0(a0)
}
    800009f0:	60a2                	ld	ra,8(sp)
    800009f2:	6402                	ld	s0,0(sp)
    800009f4:	0141                	addi	sp,sp,16
    800009f6:	8082                	ret
    panic("uvmclear");
    800009f8:	00006517          	auipc	a0,0x6
    800009fc:	79050513          	addi	a0,a0,1936 # 80007188 <etext+0x188>
    80000a00:	1f7040ef          	jal	800053f6 <panic>

0000000080000a04 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80000a04:	c2d9                	beqz	a3,80000a8a <copyout+0x86>
{
    80000a06:	711d                	addi	sp,sp,-96
    80000a08:	ec86                	sd	ra,88(sp)
    80000a0a:	e8a2                	sd	s0,80(sp)
    80000a0c:	e4a6                	sd	s1,72(sp)
    80000a0e:	e0ca                	sd	s2,64(sp)
    80000a10:	fc4e                	sd	s3,56(sp)
    80000a12:	f852                	sd	s4,48(sp)
    80000a14:	f456                	sd	s5,40(sp)
    80000a16:	f05a                	sd	s6,32(sp)
    80000a18:	ec5e                	sd	s7,24(sp)
    80000a1a:	e862                	sd	s8,16(sp)
    80000a1c:	e466                	sd	s9,8(sp)
    80000a1e:	e06a                	sd	s10,0(sp)
    80000a20:	1080                	addi	s0,sp,96
    80000a22:	8c2a                	mv	s8,a0
    80000a24:	892e                	mv	s2,a1
    80000a26:	8ab2                	mv	s5,a2
    80000a28:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    80000a2a:	7cfd                	lui	s9,0xfffff
    if(va0 >= MAXVA)
    80000a2c:	5bfd                	li	s7,-1
    80000a2e:	01abdb93          	srli	s7,s7,0x1a
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000a32:	4d55                	li	s10,21
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    n = PGSIZE - (dstva - va0);
    80000a34:	6b05                	lui	s6,0x1
    80000a36:	a015                	j	80000a5a <copyout+0x56>
    pa0 = PTE2PA(*pte);
    80000a38:	83a9                	srli	a5,a5,0xa
    80000a3a:	07b2                	slli	a5,a5,0xc
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000a3c:	41390533          	sub	a0,s2,s3
    80000a40:	0004861b          	sext.w	a2,s1
    80000a44:	85d6                	mv	a1,s5
    80000a46:	953e                	add	a0,a0,a5
    80000a48:	f6aff0ef          	jal	800001b2 <memmove>

    len -= n;
    80000a4c:	409a0a33          	sub	s4,s4,s1
    src += n;
    80000a50:	9aa6                	add	s5,s5,s1
    dstva = va0 + PGSIZE;
    80000a52:	01698933          	add	s2,s3,s6
  while(len > 0){
    80000a56:	020a0863          	beqz	s4,80000a86 <copyout+0x82>
    va0 = PGROUNDDOWN(dstva);
    80000a5a:	019979b3          	and	s3,s2,s9
    if(va0 >= MAXVA)
    80000a5e:	033be863          	bltu	s7,s3,80000a8e <copyout+0x8a>
    pte = walk(pagetable, va0, 0);
    80000a62:	4601                	li	a2,0
    80000a64:	85ce                	mv	a1,s3
    80000a66:	8562                	mv	a0,s8
    80000a68:	97bff0ef          	jal	800003e2 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000a6c:	c121                	beqz	a0,80000aac <copyout+0xa8>
    80000a6e:	611c                	ld	a5,0(a0)
    80000a70:	0157f713          	andi	a4,a5,21
    80000a74:	03a71e63          	bne	a4,s10,80000ab0 <copyout+0xac>
    n = PGSIZE - (dstva - va0);
    80000a78:	412984b3          	sub	s1,s3,s2
    80000a7c:	94da                	add	s1,s1,s6
    if(n > len)
    80000a7e:	fa9a7de3          	bgeu	s4,s1,80000a38 <copyout+0x34>
    80000a82:	84d2                	mv	s1,s4
    80000a84:	bf55                	j	80000a38 <copyout+0x34>
  }
  return 0;
    80000a86:	4501                	li	a0,0
    80000a88:	a021                	j	80000a90 <copyout+0x8c>
    80000a8a:	4501                	li	a0,0
}
    80000a8c:	8082                	ret
      return -1;
    80000a8e:	557d                	li	a0,-1
}
    80000a90:	60e6                	ld	ra,88(sp)
    80000a92:	6446                	ld	s0,80(sp)
    80000a94:	64a6                	ld	s1,72(sp)
    80000a96:	6906                	ld	s2,64(sp)
    80000a98:	79e2                	ld	s3,56(sp)
    80000a9a:	7a42                	ld	s4,48(sp)
    80000a9c:	7aa2                	ld	s5,40(sp)
    80000a9e:	7b02                	ld	s6,32(sp)
    80000aa0:	6be2                	ld	s7,24(sp)
    80000aa2:	6c42                	ld	s8,16(sp)
    80000aa4:	6ca2                	ld	s9,8(sp)
    80000aa6:	6d02                	ld	s10,0(sp)
    80000aa8:	6125                	addi	sp,sp,96
    80000aaa:	8082                	ret
      return -1;
    80000aac:	557d                	li	a0,-1
    80000aae:	b7cd                	j	80000a90 <copyout+0x8c>
    80000ab0:	557d                	li	a0,-1
    80000ab2:	bff9                	j	80000a90 <copyout+0x8c>

0000000080000ab4 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000ab4:	c6a5                	beqz	a3,80000b1c <copyin+0x68>
{
    80000ab6:	715d                	addi	sp,sp,-80
    80000ab8:	e486                	sd	ra,72(sp)
    80000aba:	e0a2                	sd	s0,64(sp)
    80000abc:	fc26                	sd	s1,56(sp)
    80000abe:	f84a                	sd	s2,48(sp)
    80000ac0:	f44e                	sd	s3,40(sp)
    80000ac2:	f052                	sd	s4,32(sp)
    80000ac4:	ec56                	sd	s5,24(sp)
    80000ac6:	e85a                	sd	s6,16(sp)
    80000ac8:	e45e                	sd	s7,8(sp)
    80000aca:	e062                	sd	s8,0(sp)
    80000acc:	0880                	addi	s0,sp,80
    80000ace:	8b2a                	mv	s6,a0
    80000ad0:	8a2e                	mv	s4,a1
    80000ad2:	8c32                	mv	s8,a2
    80000ad4:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000ad6:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000ad8:	6a85                	lui	s5,0x1
    80000ada:	a00d                	j	80000afc <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000adc:	018505b3          	add	a1,a0,s8
    80000ae0:	0004861b          	sext.w	a2,s1
    80000ae4:	412585b3          	sub	a1,a1,s2
    80000ae8:	8552                	mv	a0,s4
    80000aea:	ec8ff0ef          	jal	800001b2 <memmove>

    len -= n;
    80000aee:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000af2:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000af4:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000af8:	02098063          	beqz	s3,80000b18 <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    80000afc:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b00:	85ca                	mv	a1,s2
    80000b02:	855a                	mv	a0,s6
    80000b04:	979ff0ef          	jal	8000047c <walkaddr>
    if(pa0 == 0)
    80000b08:	cd01                	beqz	a0,80000b20 <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    80000b0a:	418904b3          	sub	s1,s2,s8
    80000b0e:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b10:	fc99f6e3          	bgeu	s3,s1,80000adc <copyin+0x28>
    80000b14:	84ce                	mv	s1,s3
    80000b16:	b7d9                	j	80000adc <copyin+0x28>
  }
  return 0;
    80000b18:	4501                	li	a0,0
    80000b1a:	a021                	j	80000b22 <copyin+0x6e>
    80000b1c:	4501                	li	a0,0
}
    80000b1e:	8082                	ret
      return -1;
    80000b20:	557d                	li	a0,-1
}
    80000b22:	60a6                	ld	ra,72(sp)
    80000b24:	6406                	ld	s0,64(sp)
    80000b26:	74e2                	ld	s1,56(sp)
    80000b28:	7942                	ld	s2,48(sp)
    80000b2a:	79a2                	ld	s3,40(sp)
    80000b2c:	7a02                	ld	s4,32(sp)
    80000b2e:	6ae2                	ld	s5,24(sp)
    80000b30:	6b42                	ld	s6,16(sp)
    80000b32:	6ba2                	ld	s7,8(sp)
    80000b34:	6c02                	ld	s8,0(sp)
    80000b36:	6161                	addi	sp,sp,80
    80000b38:	8082                	ret

0000000080000b3a <copyinstr>:
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    80000b3a:	715d                	addi	sp,sp,-80
    80000b3c:	e486                	sd	ra,72(sp)
    80000b3e:	e0a2                	sd	s0,64(sp)
    80000b40:	fc26                	sd	s1,56(sp)
    80000b42:	f84a                	sd	s2,48(sp)
    80000b44:	f44e                	sd	s3,40(sp)
    80000b46:	f052                	sd	s4,32(sp)
    80000b48:	ec56                	sd	s5,24(sp)
    80000b4a:	e85a                	sd	s6,16(sp)
    80000b4c:	e45e                	sd	s7,8(sp)
    80000b4e:	0880                	addi	s0,sp,80
    80000b50:	8aaa                	mv	s5,a0
    80000b52:	89ae                	mv	s3,a1
    80000b54:	8bb2                	mv	s7,a2
    80000b56:	84b6                	mv	s1,a3
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    va0 = PGROUNDDOWN(srcva);
    80000b58:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b5a:	6a05                	lui	s4,0x1
    80000b5c:	a02d                	j	80000b86 <copyinstr+0x4c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000b5e:	00078023          	sb	zero,0(a5)
    80000b62:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000b64:	0017c793          	xori	a5,a5,1
    80000b68:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000b6c:	60a6                	ld	ra,72(sp)
    80000b6e:	6406                	ld	s0,64(sp)
    80000b70:	74e2                	ld	s1,56(sp)
    80000b72:	7942                	ld	s2,48(sp)
    80000b74:	79a2                	ld	s3,40(sp)
    80000b76:	7a02                	ld	s4,32(sp)
    80000b78:	6ae2                	ld	s5,24(sp)
    80000b7a:	6b42                	ld	s6,16(sp)
    80000b7c:	6ba2                	ld	s7,8(sp)
    80000b7e:	6161                	addi	sp,sp,80
    80000b80:	8082                	ret
    srcva = va0 + PGSIZE;
    80000b82:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
    80000b86:	c4b1                	beqz	s1,80000bd2 <copyinstr+0x98>
    va0 = PGROUNDDOWN(srcva);
    80000b88:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    80000b8c:	85ca                	mv	a1,s2
    80000b8e:	8556                	mv	a0,s5
    80000b90:	8edff0ef          	jal	8000047c <walkaddr>
    if(pa0 == 0)
    80000b94:	c129                	beqz	a0,80000bd6 <copyinstr+0x9c>
    n = PGSIZE - (srcva - va0);
    80000b96:	41790633          	sub	a2,s2,s7
    80000b9a:	9652                	add	a2,a2,s4
    if(n > max)
    80000b9c:	00c4f363          	bgeu	s1,a2,80000ba2 <copyinstr+0x68>
    80000ba0:	8626                	mv	a2,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000ba2:	412b8bb3          	sub	s7,s7,s2
    80000ba6:	9baa                	add	s7,s7,a0
    while(n > 0){
    80000ba8:	de69                	beqz	a2,80000b82 <copyinstr+0x48>
    80000baa:	87ce                	mv	a5,s3
      if(*p == '\0'){
    80000bac:	413b86b3          	sub	a3,s7,s3
    while(n > 0){
    80000bb0:	964e                	add	a2,a2,s3
    80000bb2:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000bb4:	00f68733          	add	a4,a3,a5
    80000bb8:	00074703          	lbu	a4,0(a4)
    80000bbc:	d34d                	beqz	a4,80000b5e <copyinstr+0x24>
        *dst = *p;
    80000bbe:	00e78023          	sb	a4,0(a5)
      dst++;
    80000bc2:	0785                	addi	a5,a5,1
    while(n > 0){
    80000bc4:	fec797e3          	bne	a5,a2,80000bb2 <copyinstr+0x78>
    80000bc8:	14fd                	addi	s1,s1,-1
    80000bca:	94ce                	add	s1,s1,s3
      --max;
    80000bcc:	8c8d                	sub	s1,s1,a1
    80000bce:	89be                	mv	s3,a5
    80000bd0:	bf4d                	j	80000b82 <copyinstr+0x48>
    80000bd2:	4781                	li	a5,0
    80000bd4:	bf41                	j	80000b64 <copyinstr+0x2a>
      return -1;
    80000bd6:	557d                	li	a0,-1
    80000bd8:	bf51                	j	80000b6c <copyinstr+0x32>

0000000080000bda <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000bda:	715d                	addi	sp,sp,-80
    80000bdc:	e486                	sd	ra,72(sp)
    80000bde:	e0a2                	sd	s0,64(sp)
    80000be0:	fc26                	sd	s1,56(sp)
    80000be2:	f84a                	sd	s2,48(sp)
    80000be4:	f44e                	sd	s3,40(sp)
    80000be6:	f052                	sd	s4,32(sp)
    80000be8:	ec56                	sd	s5,24(sp)
    80000bea:	e85a                	sd	s6,16(sp)
    80000bec:	e45e                	sd	s7,8(sp)
    80000bee:	e062                	sd	s8,0(sp)
    80000bf0:	0880                	addi	s0,sp,80
    80000bf2:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000bf4:	00007497          	auipc	s1,0x7
    80000bf8:	15c48493          	addi	s1,s1,348 # 80007d50 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000bfc:	8c26                	mv	s8,s1
    80000bfe:	a4fa57b7          	lui	a5,0xa4fa5
    80000c02:	fa578793          	addi	a5,a5,-91 # ffffffffa4fa4fa5 <end+0xffffffff24f84375>
    80000c06:	4fa50937          	lui	s2,0x4fa50
    80000c0a:	a5090913          	addi	s2,s2,-1456 # 4fa4fa50 <_entry-0x305b05b0>
    80000c0e:	1902                	slli	s2,s2,0x20
    80000c10:	993e                	add	s2,s2,a5
    80000c12:	040009b7          	lui	s3,0x4000
    80000c16:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000c18:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c1a:	4b99                	li	s7,6
    80000c1c:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c1e:	0000da97          	auipc	s5,0xd
    80000c22:	b32a8a93          	addi	s5,s5,-1230 # 8000d750 <tickslock>
    char *pa = kalloc();
    80000c26:	cd8ff0ef          	jal	800000fe <kalloc>
    80000c2a:	862a                	mv	a2,a0
    if(pa == 0)
    80000c2c:	c121                	beqz	a0,80000c6c <proc_mapstacks+0x92>
    uint64 va = KSTACK((int) (p - proc));
    80000c2e:	418485b3          	sub	a1,s1,s8
    80000c32:	858d                	srai	a1,a1,0x3
    80000c34:	032585b3          	mul	a1,a1,s2
    80000c38:	2585                	addiw	a1,a1,1
    80000c3a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c3e:	875e                	mv	a4,s7
    80000c40:	86da                	mv	a3,s6
    80000c42:	40b985b3          	sub	a1,s3,a1
    80000c46:	8552                	mv	a0,s4
    80000c48:	929ff0ef          	jal	80000570 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c4c:	16848493          	addi	s1,s1,360
    80000c50:	fd549be3          	bne	s1,s5,80000c26 <proc_mapstacks+0x4c>
  }
}
    80000c54:	60a6                	ld	ra,72(sp)
    80000c56:	6406                	ld	s0,64(sp)
    80000c58:	74e2                	ld	s1,56(sp)
    80000c5a:	7942                	ld	s2,48(sp)
    80000c5c:	79a2                	ld	s3,40(sp)
    80000c5e:	7a02                	ld	s4,32(sp)
    80000c60:	6ae2                	ld	s5,24(sp)
    80000c62:	6b42                	ld	s6,16(sp)
    80000c64:	6ba2                	ld	s7,8(sp)
    80000c66:	6c02                	ld	s8,0(sp)
    80000c68:	6161                	addi	sp,sp,80
    80000c6a:	8082                	ret
      panic("kalloc");
    80000c6c:	00006517          	auipc	a0,0x6
    80000c70:	52c50513          	addi	a0,a0,1324 # 80007198 <etext+0x198>
    80000c74:	782040ef          	jal	800053f6 <panic>

0000000080000c78 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000c78:	7139                	addi	sp,sp,-64
    80000c7a:	fc06                	sd	ra,56(sp)
    80000c7c:	f822                	sd	s0,48(sp)
    80000c7e:	f426                	sd	s1,40(sp)
    80000c80:	f04a                	sd	s2,32(sp)
    80000c82:	ec4e                	sd	s3,24(sp)
    80000c84:	e852                	sd	s4,16(sp)
    80000c86:	e456                	sd	s5,8(sp)
    80000c88:	e05a                	sd	s6,0(sp)
    80000c8a:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000c8c:	00006597          	auipc	a1,0x6
    80000c90:	51458593          	addi	a1,a1,1300 # 800071a0 <etext+0x1a0>
    80000c94:	00007517          	auipc	a0,0x7
    80000c98:	c8c50513          	addi	a0,a0,-884 # 80007920 <pid_lock>
    80000c9c:	205040ef          	jal	800056a0 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000ca0:	00006597          	auipc	a1,0x6
    80000ca4:	50858593          	addi	a1,a1,1288 # 800071a8 <etext+0x1a8>
    80000ca8:	00007517          	auipc	a0,0x7
    80000cac:	c9050513          	addi	a0,a0,-880 # 80007938 <wait_lock>
    80000cb0:	1f1040ef          	jal	800056a0 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cb4:	00007497          	auipc	s1,0x7
    80000cb8:	09c48493          	addi	s1,s1,156 # 80007d50 <proc>
      initlock(&p->lock, "proc");
    80000cbc:	00006b17          	auipc	s6,0x6
    80000cc0:	4fcb0b13          	addi	s6,s6,1276 # 800071b8 <etext+0x1b8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000cc4:	8aa6                	mv	s5,s1
    80000cc6:	a4fa57b7          	lui	a5,0xa4fa5
    80000cca:	fa578793          	addi	a5,a5,-91 # ffffffffa4fa4fa5 <end+0xffffffff24f84375>
    80000cce:	4fa50937          	lui	s2,0x4fa50
    80000cd2:	a5090913          	addi	s2,s2,-1456 # 4fa4fa50 <_entry-0x305b05b0>
    80000cd6:	1902                	slli	s2,s2,0x20
    80000cd8:	993e                	add	s2,s2,a5
    80000cda:	040009b7          	lui	s3,0x4000
    80000cde:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000ce0:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ce2:	0000da17          	auipc	s4,0xd
    80000ce6:	a6ea0a13          	addi	s4,s4,-1426 # 8000d750 <tickslock>
      initlock(&p->lock, "proc");
    80000cea:	85da                	mv	a1,s6
    80000cec:	8526                	mv	a0,s1
    80000cee:	1b3040ef          	jal	800056a0 <initlock>
      p->state = UNUSED;
    80000cf2:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000cf6:	415487b3          	sub	a5,s1,s5
    80000cfa:	878d                	srai	a5,a5,0x3
    80000cfc:	032787b3          	mul	a5,a5,s2
    80000d00:	2785                	addiw	a5,a5,1
    80000d02:	00d7979b          	slliw	a5,a5,0xd
    80000d06:	40f987b3          	sub	a5,s3,a5
    80000d0a:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d0c:	16848493          	addi	s1,s1,360
    80000d10:	fd449de3          	bne	s1,s4,80000cea <procinit+0x72>
  }
}
    80000d14:	70e2                	ld	ra,56(sp)
    80000d16:	7442                	ld	s0,48(sp)
    80000d18:	74a2                	ld	s1,40(sp)
    80000d1a:	7902                	ld	s2,32(sp)
    80000d1c:	69e2                	ld	s3,24(sp)
    80000d1e:	6a42                	ld	s4,16(sp)
    80000d20:	6aa2                	ld	s5,8(sp)
    80000d22:	6b02                	ld	s6,0(sp)
    80000d24:	6121                	addi	sp,sp,64
    80000d26:	8082                	ret

0000000080000d28 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000d28:	1141                	addi	sp,sp,-16
    80000d2a:	e406                	sd	ra,8(sp)
    80000d2c:	e022                	sd	s0,0(sp)
    80000d2e:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000d30:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000d32:	2501                	sext.w	a0,a0
    80000d34:	60a2                	ld	ra,8(sp)
    80000d36:	6402                	ld	s0,0(sp)
    80000d38:	0141                	addi	sp,sp,16
    80000d3a:	8082                	ret

0000000080000d3c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000d3c:	1141                	addi	sp,sp,-16
    80000d3e:	e406                	sd	ra,8(sp)
    80000d40:	e022                	sd	s0,0(sp)
    80000d42:	0800                	addi	s0,sp,16
    80000d44:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000d46:	2781                	sext.w	a5,a5
    80000d48:	079e                	slli	a5,a5,0x7
  return c;
}
    80000d4a:	00007517          	auipc	a0,0x7
    80000d4e:	c0650513          	addi	a0,a0,-1018 # 80007950 <cpus>
    80000d52:	953e                	add	a0,a0,a5
    80000d54:	60a2                	ld	ra,8(sp)
    80000d56:	6402                	ld	s0,0(sp)
    80000d58:	0141                	addi	sp,sp,16
    80000d5a:	8082                	ret

0000000080000d5c <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000d5c:	1101                	addi	sp,sp,-32
    80000d5e:	ec06                	sd	ra,24(sp)
    80000d60:	e822                	sd	s0,16(sp)
    80000d62:	e426                	sd	s1,8(sp)
    80000d64:	1000                	addi	s0,sp,32
  push_off();
    80000d66:	17f040ef          	jal	800056e4 <push_off>
    80000d6a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000d6c:	2781                	sext.w	a5,a5
    80000d6e:	079e                	slli	a5,a5,0x7
    80000d70:	00007717          	auipc	a4,0x7
    80000d74:	bb070713          	addi	a4,a4,-1104 # 80007920 <pid_lock>
    80000d78:	97ba                	add	a5,a5,a4
    80000d7a:	7b84                	ld	s1,48(a5)
  pop_off();
    80000d7c:	1ed040ef          	jal	80005768 <pop_off>
  return p;
}
    80000d80:	8526                	mv	a0,s1
    80000d82:	60e2                	ld	ra,24(sp)
    80000d84:	6442                	ld	s0,16(sp)
    80000d86:	64a2                	ld	s1,8(sp)
    80000d88:	6105                	addi	sp,sp,32
    80000d8a:	8082                	ret

0000000080000d8c <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000d8c:	1141                	addi	sp,sp,-16
    80000d8e:	e406                	sd	ra,8(sp)
    80000d90:	e022                	sd	s0,0(sp)
    80000d92:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000d94:	fc9ff0ef          	jal	80000d5c <myproc>
    80000d98:	221040ef          	jal	800057b8 <release>

  if (first) {
    80000d9c:	00007797          	auipc	a5,0x7
    80000da0:	ae47a783          	lw	a5,-1308(a5) # 80007880 <first.1>
    80000da4:	e799                	bnez	a5,80000db2 <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000da6:	2bd000ef          	jal	80001862 <usertrapret>
}
    80000daa:	60a2                	ld	ra,8(sp)
    80000dac:	6402                	ld	s0,0(sp)
    80000dae:	0141                	addi	sp,sp,16
    80000db0:	8082                	ret
    fsinit(ROOTDEV);
    80000db2:	4505                	li	a0,1
    80000db4:	624010ef          	jal	800023d8 <fsinit>
    first = 0;
    80000db8:	00007797          	auipc	a5,0x7
    80000dbc:	ac07a423          	sw	zero,-1336(a5) # 80007880 <first.1>
    __sync_synchronize();
    80000dc0:	0330000f          	fence	rw,rw
    80000dc4:	b7cd                	j	80000da6 <forkret+0x1a>

0000000080000dc6 <allocpid>:
{
    80000dc6:	1101                	addi	sp,sp,-32
    80000dc8:	ec06                	sd	ra,24(sp)
    80000dca:	e822                	sd	s0,16(sp)
    80000dcc:	e426                	sd	s1,8(sp)
    80000dce:	e04a                	sd	s2,0(sp)
    80000dd0:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000dd2:	00007917          	auipc	s2,0x7
    80000dd6:	b4e90913          	addi	s2,s2,-1202 # 80007920 <pid_lock>
    80000dda:	854a                	mv	a0,s2
    80000ddc:	149040ef          	jal	80005724 <acquire>
  pid = nextpid;
    80000de0:	00007797          	auipc	a5,0x7
    80000de4:	aa478793          	addi	a5,a5,-1372 # 80007884 <nextpid>
    80000de8:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000dea:	0014871b          	addiw	a4,s1,1
    80000dee:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000df0:	854a                	mv	a0,s2
    80000df2:	1c7040ef          	jal	800057b8 <release>
}
    80000df6:	8526                	mv	a0,s1
    80000df8:	60e2                	ld	ra,24(sp)
    80000dfa:	6442                	ld	s0,16(sp)
    80000dfc:	64a2                	ld	s1,8(sp)
    80000dfe:	6902                	ld	s2,0(sp)
    80000e00:	6105                	addi	sp,sp,32
    80000e02:	8082                	ret

0000000080000e04 <proc_pagetable>:
{
    80000e04:	1101                	addi	sp,sp,-32
    80000e06:	ec06                	sd	ra,24(sp)
    80000e08:	e822                	sd	s0,16(sp)
    80000e0a:	e426                	sd	s1,8(sp)
    80000e0c:	e04a                	sd	s2,0(sp)
    80000e0e:	1000                	addi	s0,sp,32
    80000e10:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000e12:	90bff0ef          	jal	8000071c <uvmcreate>
    80000e16:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000e18:	cd05                	beqz	a0,80000e50 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000e1a:	4729                	li	a4,10
    80000e1c:	00005697          	auipc	a3,0x5
    80000e20:	1e468693          	addi	a3,a3,484 # 80006000 <_trampoline>
    80000e24:	6605                	lui	a2,0x1
    80000e26:	040005b7          	lui	a1,0x4000
    80000e2a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000e2c:	05b2                	slli	a1,a1,0xc
    80000e2e:	e8cff0ef          	jal	800004ba <mappages>
    80000e32:	02054663          	bltz	a0,80000e5e <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000e36:	4719                	li	a4,6
    80000e38:	05893683          	ld	a3,88(s2)
    80000e3c:	6605                	lui	a2,0x1
    80000e3e:	020005b7          	lui	a1,0x2000
    80000e42:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000e44:	05b6                	slli	a1,a1,0xd
    80000e46:	8526                	mv	a0,s1
    80000e48:	e72ff0ef          	jal	800004ba <mappages>
    80000e4c:	00054f63          	bltz	a0,80000e6a <proc_pagetable+0x66>
}
    80000e50:	8526                	mv	a0,s1
    80000e52:	60e2                	ld	ra,24(sp)
    80000e54:	6442                	ld	s0,16(sp)
    80000e56:	64a2                	ld	s1,8(sp)
    80000e58:	6902                	ld	s2,0(sp)
    80000e5a:	6105                	addi	sp,sp,32
    80000e5c:	8082                	ret
    uvmfree(pagetable, 0);
    80000e5e:	4581                	li	a1,0
    80000e60:	8526                	mv	a0,s1
    80000e62:	a91ff0ef          	jal	800008f2 <uvmfree>
    return 0;
    80000e66:	4481                	li	s1,0
    80000e68:	b7e5                	j	80000e50 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000e6a:	4681                	li	a3,0
    80000e6c:	4605                	li	a2,1
    80000e6e:	040005b7          	lui	a1,0x4000
    80000e72:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000e74:	05b2                	slli	a1,a1,0xc
    80000e76:	8526                	mv	a0,s1
    80000e78:	fe8ff0ef          	jal	80000660 <uvmunmap>
    uvmfree(pagetable, 0);
    80000e7c:	4581                	li	a1,0
    80000e7e:	8526                	mv	a0,s1
    80000e80:	a73ff0ef          	jal	800008f2 <uvmfree>
    return 0;
    80000e84:	4481                	li	s1,0
    80000e86:	b7e9                	j	80000e50 <proc_pagetable+0x4c>

0000000080000e88 <proc_freepagetable>:
{
    80000e88:	1101                	addi	sp,sp,-32
    80000e8a:	ec06                	sd	ra,24(sp)
    80000e8c:	e822                	sd	s0,16(sp)
    80000e8e:	e426                	sd	s1,8(sp)
    80000e90:	e04a                	sd	s2,0(sp)
    80000e92:	1000                	addi	s0,sp,32
    80000e94:	84aa                	mv	s1,a0
    80000e96:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000e98:	4681                	li	a3,0
    80000e9a:	4605                	li	a2,1
    80000e9c:	040005b7          	lui	a1,0x4000
    80000ea0:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ea2:	05b2                	slli	a1,a1,0xc
    80000ea4:	fbcff0ef          	jal	80000660 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000ea8:	4681                	li	a3,0
    80000eaa:	4605                	li	a2,1
    80000eac:	020005b7          	lui	a1,0x2000
    80000eb0:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000eb2:	05b6                	slli	a1,a1,0xd
    80000eb4:	8526                	mv	a0,s1
    80000eb6:	faaff0ef          	jal	80000660 <uvmunmap>
  uvmfree(pagetable, sz);
    80000eba:	85ca                	mv	a1,s2
    80000ebc:	8526                	mv	a0,s1
    80000ebe:	a35ff0ef          	jal	800008f2 <uvmfree>
}
    80000ec2:	60e2                	ld	ra,24(sp)
    80000ec4:	6442                	ld	s0,16(sp)
    80000ec6:	64a2                	ld	s1,8(sp)
    80000ec8:	6902                	ld	s2,0(sp)
    80000eca:	6105                	addi	sp,sp,32
    80000ecc:	8082                	ret

0000000080000ece <freeproc>:
{
    80000ece:	1101                	addi	sp,sp,-32
    80000ed0:	ec06                	sd	ra,24(sp)
    80000ed2:	e822                	sd	s0,16(sp)
    80000ed4:	e426                	sd	s1,8(sp)
    80000ed6:	1000                	addi	s0,sp,32
    80000ed8:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000eda:	6d28                	ld	a0,88(a0)
    80000edc:	c119                	beqz	a0,80000ee2 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80000ede:	93eff0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    80000ee2:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80000ee6:	68a8                	ld	a0,80(s1)
    80000ee8:	c501                	beqz	a0,80000ef0 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80000eea:	64ac                	ld	a1,72(s1)
    80000eec:	f9dff0ef          	jal	80000e88 <proc_freepagetable>
  p->pagetable = 0;
    80000ef0:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80000ef4:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80000ef8:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80000efc:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80000f00:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80000f04:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80000f08:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80000f0c:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80000f10:	0004ac23          	sw	zero,24(s1)
}
    80000f14:	60e2                	ld	ra,24(sp)
    80000f16:	6442                	ld	s0,16(sp)
    80000f18:	64a2                	ld	s1,8(sp)
    80000f1a:	6105                	addi	sp,sp,32
    80000f1c:	8082                	ret

0000000080000f1e <allocproc>:
{
    80000f1e:	1101                	addi	sp,sp,-32
    80000f20:	ec06                	sd	ra,24(sp)
    80000f22:	e822                	sd	s0,16(sp)
    80000f24:	e426                	sd	s1,8(sp)
    80000f26:	e04a                	sd	s2,0(sp)
    80000f28:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f2a:	00007497          	auipc	s1,0x7
    80000f2e:	e2648493          	addi	s1,s1,-474 # 80007d50 <proc>
    80000f32:	0000d917          	auipc	s2,0xd
    80000f36:	81e90913          	addi	s2,s2,-2018 # 8000d750 <tickslock>
    acquire(&p->lock);
    80000f3a:	8526                	mv	a0,s1
    80000f3c:	7e8040ef          	jal	80005724 <acquire>
    if(p->state == UNUSED) {
    80000f40:	4c9c                	lw	a5,24(s1)
    80000f42:	cb91                	beqz	a5,80000f56 <allocproc+0x38>
      release(&p->lock);
    80000f44:	8526                	mv	a0,s1
    80000f46:	073040ef          	jal	800057b8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f4a:	16848493          	addi	s1,s1,360
    80000f4e:	ff2496e3          	bne	s1,s2,80000f3a <allocproc+0x1c>
  return 0;
    80000f52:	4481                	li	s1,0
    80000f54:	a089                	j	80000f96 <allocproc+0x78>
  p->pid = allocpid();
    80000f56:	e71ff0ef          	jal	80000dc6 <allocpid>
    80000f5a:	d888                	sw	a0,48(s1)
  p->state = USED;
    80000f5c:	4785                	li	a5,1
    80000f5e:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80000f60:	99eff0ef          	jal	800000fe <kalloc>
    80000f64:	892a                	mv	s2,a0
    80000f66:	eca8                	sd	a0,88(s1)
    80000f68:	cd15                	beqz	a0,80000fa4 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80000f6a:	8526                	mv	a0,s1
    80000f6c:	e99ff0ef          	jal	80000e04 <proc_pagetable>
    80000f70:	892a                	mv	s2,a0
    80000f72:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80000f74:	c121                	beqz	a0,80000fb4 <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80000f76:	07000613          	li	a2,112
    80000f7a:	4581                	li	a1,0
    80000f7c:	06048513          	addi	a0,s1,96
    80000f80:	9ceff0ef          	jal	8000014e <memset>
  p->context.ra = (uint64)forkret;
    80000f84:	00000797          	auipc	a5,0x0
    80000f88:	e0878793          	addi	a5,a5,-504 # 80000d8c <forkret>
    80000f8c:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80000f8e:	60bc                	ld	a5,64(s1)
    80000f90:	6705                	lui	a4,0x1
    80000f92:	97ba                	add	a5,a5,a4
    80000f94:	f4bc                	sd	a5,104(s1)
}
    80000f96:	8526                	mv	a0,s1
    80000f98:	60e2                	ld	ra,24(sp)
    80000f9a:	6442                	ld	s0,16(sp)
    80000f9c:	64a2                	ld	s1,8(sp)
    80000f9e:	6902                	ld	s2,0(sp)
    80000fa0:	6105                	addi	sp,sp,32
    80000fa2:	8082                	ret
    freeproc(p);
    80000fa4:	8526                	mv	a0,s1
    80000fa6:	f29ff0ef          	jal	80000ece <freeproc>
    release(&p->lock);
    80000faa:	8526                	mv	a0,s1
    80000fac:	00d040ef          	jal	800057b8 <release>
    return 0;
    80000fb0:	84ca                	mv	s1,s2
    80000fb2:	b7d5                	j	80000f96 <allocproc+0x78>
    freeproc(p);
    80000fb4:	8526                	mv	a0,s1
    80000fb6:	f19ff0ef          	jal	80000ece <freeproc>
    release(&p->lock);
    80000fba:	8526                	mv	a0,s1
    80000fbc:	7fc040ef          	jal	800057b8 <release>
    return 0;
    80000fc0:	84ca                	mv	s1,s2
    80000fc2:	bfd1                	j	80000f96 <allocproc+0x78>

0000000080000fc4 <userinit>:
{
    80000fc4:	1101                	addi	sp,sp,-32
    80000fc6:	ec06                	sd	ra,24(sp)
    80000fc8:	e822                	sd	s0,16(sp)
    80000fca:	e426                	sd	s1,8(sp)
    80000fcc:	1000                	addi	s0,sp,32
  p = allocproc();
    80000fce:	f51ff0ef          	jal	80000f1e <allocproc>
    80000fd2:	84aa                	mv	s1,a0
  initproc = p;
    80000fd4:	00007797          	auipc	a5,0x7
    80000fd8:	90a7b623          	sd	a0,-1780(a5) # 800078e0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80000fdc:	03400613          	li	a2,52
    80000fe0:	00007597          	auipc	a1,0x7
    80000fe4:	8b058593          	addi	a1,a1,-1872 # 80007890 <initcode>
    80000fe8:	6928                	ld	a0,80(a0)
    80000fea:	f58ff0ef          	jal	80000742 <uvmfirst>
  p->sz = PGSIZE;
    80000fee:	6785                	lui	a5,0x1
    80000ff0:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80000ff2:	6cb8                	ld	a4,88(s1)
    80000ff4:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80000ff8:	6cb8                	ld	a4,88(s1)
    80000ffa:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80000ffc:	4641                	li	a2,16
    80000ffe:	00006597          	auipc	a1,0x6
    80001002:	1c258593          	addi	a1,a1,450 # 800071c0 <etext+0x1c0>
    80001006:	15848513          	addi	a0,s1,344
    8000100a:	a96ff0ef          	jal	800002a0 <safestrcpy>
  p->cwd = namei("/");
    8000100e:	00006517          	auipc	a0,0x6
    80001012:	1c250513          	addi	a0,a0,450 # 800071d0 <etext+0x1d0>
    80001016:	4e7010ef          	jal	80002cfc <namei>
    8000101a:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000101e:	478d                	li	a5,3
    80001020:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001022:	8526                	mv	a0,s1
    80001024:	794040ef          	jal	800057b8 <release>
}
    80001028:	60e2                	ld	ra,24(sp)
    8000102a:	6442                	ld	s0,16(sp)
    8000102c:	64a2                	ld	s1,8(sp)
    8000102e:	6105                	addi	sp,sp,32
    80001030:	8082                	ret

0000000080001032 <growproc>:
{
    80001032:	1101                	addi	sp,sp,-32
    80001034:	ec06                	sd	ra,24(sp)
    80001036:	e822                	sd	s0,16(sp)
    80001038:	e426                	sd	s1,8(sp)
    8000103a:	e04a                	sd	s2,0(sp)
    8000103c:	1000                	addi	s0,sp,32
    8000103e:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001040:	d1dff0ef          	jal	80000d5c <myproc>
    80001044:	84aa                	mv	s1,a0
  sz = p->sz;
    80001046:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001048:	01204c63          	bgtz	s2,80001060 <growproc+0x2e>
  } else if(n < 0){
    8000104c:	02094463          	bltz	s2,80001074 <growproc+0x42>
  p->sz = sz;
    80001050:	e4ac                	sd	a1,72(s1)
  return 0;
    80001052:	4501                	li	a0,0
}
    80001054:	60e2                	ld	ra,24(sp)
    80001056:	6442                	ld	s0,16(sp)
    80001058:	64a2                	ld	s1,8(sp)
    8000105a:	6902                	ld	s2,0(sp)
    8000105c:	6105                	addi	sp,sp,32
    8000105e:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001060:	4691                	li	a3,4
    80001062:	00b90633          	add	a2,s2,a1
    80001066:	6928                	ld	a0,80(a0)
    80001068:	f7cff0ef          	jal	800007e4 <uvmalloc>
    8000106c:	85aa                	mv	a1,a0
    8000106e:	f16d                	bnez	a0,80001050 <growproc+0x1e>
      return -1;
    80001070:	557d                	li	a0,-1
    80001072:	b7cd                	j	80001054 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001074:	00b90633          	add	a2,s2,a1
    80001078:	6928                	ld	a0,80(a0)
    8000107a:	f26ff0ef          	jal	800007a0 <uvmdealloc>
    8000107e:	85aa                	mv	a1,a0
    80001080:	bfc1                	j	80001050 <growproc+0x1e>

0000000080001082 <fork>:
{
    80001082:	7139                	addi	sp,sp,-64
    80001084:	fc06                	sd	ra,56(sp)
    80001086:	f822                	sd	s0,48(sp)
    80001088:	f04a                	sd	s2,32(sp)
    8000108a:	e456                	sd	s5,8(sp)
    8000108c:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000108e:	ccfff0ef          	jal	80000d5c <myproc>
    80001092:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001094:	e8bff0ef          	jal	80000f1e <allocproc>
    80001098:	0e050a63          	beqz	a0,8000118c <fork+0x10a>
    8000109c:	e852                	sd	s4,16(sp)
    8000109e:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800010a0:	048ab603          	ld	a2,72(s5)
    800010a4:	692c                	ld	a1,80(a0)
    800010a6:	050ab503          	ld	a0,80(s5)
    800010aa:	87bff0ef          	jal	80000924 <uvmcopy>
    800010ae:	04054a63          	bltz	a0,80001102 <fork+0x80>
    800010b2:	f426                	sd	s1,40(sp)
    800010b4:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    800010b6:	048ab783          	ld	a5,72(s5)
    800010ba:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800010be:	058ab683          	ld	a3,88(s5)
    800010c2:	87b6                	mv	a5,a3
    800010c4:	058a3703          	ld	a4,88(s4)
    800010c8:	12068693          	addi	a3,a3,288
    800010cc:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800010d0:	6788                	ld	a0,8(a5)
    800010d2:	6b8c                	ld	a1,16(a5)
    800010d4:	6f90                	ld	a2,24(a5)
    800010d6:	01073023          	sd	a6,0(a4)
    800010da:	e708                	sd	a0,8(a4)
    800010dc:	eb0c                	sd	a1,16(a4)
    800010de:	ef10                	sd	a2,24(a4)
    800010e0:	02078793          	addi	a5,a5,32
    800010e4:	02070713          	addi	a4,a4,32
    800010e8:	fed792e3          	bne	a5,a3,800010cc <fork+0x4a>
  np->trapframe->a0 = 0;
    800010ec:	058a3783          	ld	a5,88(s4)
    800010f0:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800010f4:	0d0a8493          	addi	s1,s5,208
    800010f8:	0d0a0913          	addi	s2,s4,208
    800010fc:	150a8993          	addi	s3,s5,336
    80001100:	a831                	j	8000111c <fork+0x9a>
    freeproc(np);
    80001102:	8552                	mv	a0,s4
    80001104:	dcbff0ef          	jal	80000ece <freeproc>
    release(&np->lock);
    80001108:	8552                	mv	a0,s4
    8000110a:	6ae040ef          	jal	800057b8 <release>
    return -1;
    8000110e:	597d                	li	s2,-1
    80001110:	6a42                	ld	s4,16(sp)
    80001112:	a0b5                	j	8000117e <fork+0xfc>
  for(i = 0; i < NOFILE; i++)
    80001114:	04a1                	addi	s1,s1,8
    80001116:	0921                	addi	s2,s2,8
    80001118:	01348963          	beq	s1,s3,8000112a <fork+0xa8>
    if(p->ofile[i])
    8000111c:	6088                	ld	a0,0(s1)
    8000111e:	d97d                	beqz	a0,80001114 <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    80001120:	178020ef          	jal	80003298 <filedup>
    80001124:	00a93023          	sd	a0,0(s2)
    80001128:	b7f5                	j	80001114 <fork+0x92>
  np->cwd = idup(p->cwd);
    8000112a:	150ab503          	ld	a0,336(s5)
    8000112e:	4a8010ef          	jal	800025d6 <idup>
    80001132:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001136:	4641                	li	a2,16
    80001138:	158a8593          	addi	a1,s5,344
    8000113c:	158a0513          	addi	a0,s4,344
    80001140:	960ff0ef          	jal	800002a0 <safestrcpy>
  pid = np->pid;
    80001144:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001148:	8552                	mv	a0,s4
    8000114a:	66e040ef          	jal	800057b8 <release>
  acquire(&wait_lock);
    8000114e:	00006497          	auipc	s1,0x6
    80001152:	7ea48493          	addi	s1,s1,2026 # 80007938 <wait_lock>
    80001156:	8526                	mv	a0,s1
    80001158:	5cc040ef          	jal	80005724 <acquire>
  np->parent = p;
    8000115c:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001160:	8526                	mv	a0,s1
    80001162:	656040ef          	jal	800057b8 <release>
  acquire(&np->lock);
    80001166:	8552                	mv	a0,s4
    80001168:	5bc040ef          	jal	80005724 <acquire>
  np->state = RUNNABLE;
    8000116c:	478d                	li	a5,3
    8000116e:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001172:	8552                	mv	a0,s4
    80001174:	644040ef          	jal	800057b8 <release>
  return pid;
    80001178:	74a2                	ld	s1,40(sp)
    8000117a:	69e2                	ld	s3,24(sp)
    8000117c:	6a42                	ld	s4,16(sp)
}
    8000117e:	854a                	mv	a0,s2
    80001180:	70e2                	ld	ra,56(sp)
    80001182:	7442                	ld	s0,48(sp)
    80001184:	7902                	ld	s2,32(sp)
    80001186:	6aa2                	ld	s5,8(sp)
    80001188:	6121                	addi	sp,sp,64
    8000118a:	8082                	ret
    return -1;
    8000118c:	597d                	li	s2,-1
    8000118e:	bfc5                	j	8000117e <fork+0xfc>

0000000080001190 <scheduler>:
{
    80001190:	715d                	addi	sp,sp,-80
    80001192:	e486                	sd	ra,72(sp)
    80001194:	e0a2                	sd	s0,64(sp)
    80001196:	fc26                	sd	s1,56(sp)
    80001198:	f84a                	sd	s2,48(sp)
    8000119a:	f44e                	sd	s3,40(sp)
    8000119c:	f052                	sd	s4,32(sp)
    8000119e:	ec56                	sd	s5,24(sp)
    800011a0:	e85a                	sd	s6,16(sp)
    800011a2:	e45e                	sd	s7,8(sp)
    800011a4:	e062                	sd	s8,0(sp)
    800011a6:	0880                	addi	s0,sp,80
    800011a8:	8792                	mv	a5,tp
  int id = r_tp();
    800011aa:	2781                	sext.w	a5,a5
  c->proc = 0;
    800011ac:	00779b13          	slli	s6,a5,0x7
    800011b0:	00006717          	auipc	a4,0x6
    800011b4:	77070713          	addi	a4,a4,1904 # 80007920 <pid_lock>
    800011b8:	975a                	add	a4,a4,s6
    800011ba:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800011be:	00006717          	auipc	a4,0x6
    800011c2:	79a70713          	addi	a4,a4,1946 # 80007958 <cpus+0x8>
    800011c6:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    800011c8:	4c11                	li	s8,4
        c->proc = p;
    800011ca:	079e                	slli	a5,a5,0x7
    800011cc:	00006a17          	auipc	s4,0x6
    800011d0:	754a0a13          	addi	s4,s4,1876 # 80007920 <pid_lock>
    800011d4:	9a3e                	add	s4,s4,a5
        found = 1;
    800011d6:	4b85                	li	s7,1
    800011d8:	a0a9                	j	80001222 <scheduler+0x92>
      release(&p->lock);
    800011da:	8526                	mv	a0,s1
    800011dc:	5dc040ef          	jal	800057b8 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800011e0:	16848493          	addi	s1,s1,360
    800011e4:	03248563          	beq	s1,s2,8000120e <scheduler+0x7e>
      acquire(&p->lock);
    800011e8:	8526                	mv	a0,s1
    800011ea:	53a040ef          	jal	80005724 <acquire>
      if(p->state == RUNNABLE) {
    800011ee:	4c9c                	lw	a5,24(s1)
    800011f0:	ff3795e3          	bne	a5,s3,800011da <scheduler+0x4a>
        p->state = RUNNING;
    800011f4:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    800011f8:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800011fc:	06048593          	addi	a1,s1,96
    80001200:	855a                	mv	a0,s6
    80001202:	5b6000ef          	jal	800017b8 <swtch>
        c->proc = 0;
    80001206:	020a3823          	sd	zero,48(s4)
        found = 1;
    8000120a:	8ade                	mv	s5,s7
    8000120c:	b7f9                	j	800011da <scheduler+0x4a>
    if(found == 0) {
    8000120e:	000a9a63          	bnez	s5,80001222 <scheduler+0x92>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001212:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001216:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000121a:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    8000121e:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001222:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001226:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000122a:	10079073          	csrw	sstatus,a5
    int found = 0;
    8000122e:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001230:	00007497          	auipc	s1,0x7
    80001234:	b2048493          	addi	s1,s1,-1248 # 80007d50 <proc>
      if(p->state == RUNNABLE) {
    80001238:	498d                	li	s3,3
    for(p = proc; p < &proc[NPROC]; p++) {
    8000123a:	0000c917          	auipc	s2,0xc
    8000123e:	51690913          	addi	s2,s2,1302 # 8000d750 <tickslock>
    80001242:	b75d                	j	800011e8 <scheduler+0x58>

0000000080001244 <sched>:
{
    80001244:	7179                	addi	sp,sp,-48
    80001246:	f406                	sd	ra,40(sp)
    80001248:	f022                	sd	s0,32(sp)
    8000124a:	ec26                	sd	s1,24(sp)
    8000124c:	e84a                	sd	s2,16(sp)
    8000124e:	e44e                	sd	s3,8(sp)
    80001250:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001252:	b0bff0ef          	jal	80000d5c <myproc>
    80001256:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001258:	462040ef          	jal	800056ba <holding>
    8000125c:	c92d                	beqz	a0,800012ce <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000125e:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001260:	2781                	sext.w	a5,a5
    80001262:	079e                	slli	a5,a5,0x7
    80001264:	00006717          	auipc	a4,0x6
    80001268:	6bc70713          	addi	a4,a4,1724 # 80007920 <pid_lock>
    8000126c:	97ba                	add	a5,a5,a4
    8000126e:	0a87a703          	lw	a4,168(a5)
    80001272:	4785                	li	a5,1
    80001274:	06f71363          	bne	a4,a5,800012da <sched+0x96>
  if(p->state == RUNNING)
    80001278:	4c98                	lw	a4,24(s1)
    8000127a:	4791                	li	a5,4
    8000127c:	06f70563          	beq	a4,a5,800012e6 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001280:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001284:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001286:	e7b5                	bnez	a5,800012f2 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001288:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000128a:	00006917          	auipc	s2,0x6
    8000128e:	69690913          	addi	s2,s2,1686 # 80007920 <pid_lock>
    80001292:	2781                	sext.w	a5,a5
    80001294:	079e                	slli	a5,a5,0x7
    80001296:	97ca                	add	a5,a5,s2
    80001298:	0ac7a983          	lw	s3,172(a5)
    8000129c:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000129e:	2781                	sext.w	a5,a5
    800012a0:	079e                	slli	a5,a5,0x7
    800012a2:	00006597          	auipc	a1,0x6
    800012a6:	6b658593          	addi	a1,a1,1718 # 80007958 <cpus+0x8>
    800012aa:	95be                	add	a1,a1,a5
    800012ac:	06048513          	addi	a0,s1,96
    800012b0:	508000ef          	jal	800017b8 <swtch>
    800012b4:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800012b6:	2781                	sext.w	a5,a5
    800012b8:	079e                	slli	a5,a5,0x7
    800012ba:	993e                	add	s2,s2,a5
    800012bc:	0b392623          	sw	s3,172(s2)
}
    800012c0:	70a2                	ld	ra,40(sp)
    800012c2:	7402                	ld	s0,32(sp)
    800012c4:	64e2                	ld	s1,24(sp)
    800012c6:	6942                	ld	s2,16(sp)
    800012c8:	69a2                	ld	s3,8(sp)
    800012ca:	6145                	addi	sp,sp,48
    800012cc:	8082                	ret
    panic("sched p->lock");
    800012ce:	00006517          	auipc	a0,0x6
    800012d2:	f0a50513          	addi	a0,a0,-246 # 800071d8 <etext+0x1d8>
    800012d6:	120040ef          	jal	800053f6 <panic>
    panic("sched locks");
    800012da:	00006517          	auipc	a0,0x6
    800012de:	f0e50513          	addi	a0,a0,-242 # 800071e8 <etext+0x1e8>
    800012e2:	114040ef          	jal	800053f6 <panic>
    panic("sched running");
    800012e6:	00006517          	auipc	a0,0x6
    800012ea:	f1250513          	addi	a0,a0,-238 # 800071f8 <etext+0x1f8>
    800012ee:	108040ef          	jal	800053f6 <panic>
    panic("sched interruptible");
    800012f2:	00006517          	auipc	a0,0x6
    800012f6:	f1650513          	addi	a0,a0,-234 # 80007208 <etext+0x208>
    800012fa:	0fc040ef          	jal	800053f6 <panic>

00000000800012fe <yield>:
{
    800012fe:	1101                	addi	sp,sp,-32
    80001300:	ec06                	sd	ra,24(sp)
    80001302:	e822                	sd	s0,16(sp)
    80001304:	e426                	sd	s1,8(sp)
    80001306:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001308:	a55ff0ef          	jal	80000d5c <myproc>
    8000130c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000130e:	416040ef          	jal	80005724 <acquire>
  p->state = RUNNABLE;
    80001312:	478d                	li	a5,3
    80001314:	cc9c                	sw	a5,24(s1)
  sched();
    80001316:	f2fff0ef          	jal	80001244 <sched>
  release(&p->lock);
    8000131a:	8526                	mv	a0,s1
    8000131c:	49c040ef          	jal	800057b8 <release>
}
    80001320:	60e2                	ld	ra,24(sp)
    80001322:	6442                	ld	s0,16(sp)
    80001324:	64a2                	ld	s1,8(sp)
    80001326:	6105                	addi	sp,sp,32
    80001328:	8082                	ret

000000008000132a <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000132a:	7179                	addi	sp,sp,-48
    8000132c:	f406                	sd	ra,40(sp)
    8000132e:	f022                	sd	s0,32(sp)
    80001330:	ec26                	sd	s1,24(sp)
    80001332:	e84a                	sd	s2,16(sp)
    80001334:	e44e                	sd	s3,8(sp)
    80001336:	1800                	addi	s0,sp,48
    80001338:	89aa                	mv	s3,a0
    8000133a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000133c:	a21ff0ef          	jal	80000d5c <myproc>
    80001340:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001342:	3e2040ef          	jal	80005724 <acquire>
  release(lk);
    80001346:	854a                	mv	a0,s2
    80001348:	470040ef          	jal	800057b8 <release>

  // Go to sleep.
  p->chan = chan;
    8000134c:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001350:	4789                	li	a5,2
    80001352:	cc9c                	sw	a5,24(s1)

  sched();
    80001354:	ef1ff0ef          	jal	80001244 <sched>

  // Tidy up.
  p->chan = 0;
    80001358:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000135c:	8526                	mv	a0,s1
    8000135e:	45a040ef          	jal	800057b8 <release>
  acquire(lk);
    80001362:	854a                	mv	a0,s2
    80001364:	3c0040ef          	jal	80005724 <acquire>
}
    80001368:	70a2                	ld	ra,40(sp)
    8000136a:	7402                	ld	s0,32(sp)
    8000136c:	64e2                	ld	s1,24(sp)
    8000136e:	6942                	ld	s2,16(sp)
    80001370:	69a2                	ld	s3,8(sp)
    80001372:	6145                	addi	sp,sp,48
    80001374:	8082                	ret

0000000080001376 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001376:	7139                	addi	sp,sp,-64
    80001378:	fc06                	sd	ra,56(sp)
    8000137a:	f822                	sd	s0,48(sp)
    8000137c:	f426                	sd	s1,40(sp)
    8000137e:	f04a                	sd	s2,32(sp)
    80001380:	ec4e                	sd	s3,24(sp)
    80001382:	e852                	sd	s4,16(sp)
    80001384:	e456                	sd	s5,8(sp)
    80001386:	0080                	addi	s0,sp,64
    80001388:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000138a:	00007497          	auipc	s1,0x7
    8000138e:	9c648493          	addi	s1,s1,-1594 # 80007d50 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001392:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001394:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001396:	0000c917          	auipc	s2,0xc
    8000139a:	3ba90913          	addi	s2,s2,954 # 8000d750 <tickslock>
    8000139e:	a801                	j	800013ae <wakeup+0x38>
      }
      release(&p->lock);
    800013a0:	8526                	mv	a0,s1
    800013a2:	416040ef          	jal	800057b8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800013a6:	16848493          	addi	s1,s1,360
    800013aa:	03248263          	beq	s1,s2,800013ce <wakeup+0x58>
    if(p != myproc()){
    800013ae:	9afff0ef          	jal	80000d5c <myproc>
    800013b2:	fea48ae3          	beq	s1,a0,800013a6 <wakeup+0x30>
      acquire(&p->lock);
    800013b6:	8526                	mv	a0,s1
    800013b8:	36c040ef          	jal	80005724 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800013bc:	4c9c                	lw	a5,24(s1)
    800013be:	ff3791e3          	bne	a5,s3,800013a0 <wakeup+0x2a>
    800013c2:	709c                	ld	a5,32(s1)
    800013c4:	fd479ee3          	bne	a5,s4,800013a0 <wakeup+0x2a>
        p->state = RUNNABLE;
    800013c8:	0154ac23          	sw	s5,24(s1)
    800013cc:	bfd1                	j	800013a0 <wakeup+0x2a>
    }
  }
}
    800013ce:	70e2                	ld	ra,56(sp)
    800013d0:	7442                	ld	s0,48(sp)
    800013d2:	74a2                	ld	s1,40(sp)
    800013d4:	7902                	ld	s2,32(sp)
    800013d6:	69e2                	ld	s3,24(sp)
    800013d8:	6a42                	ld	s4,16(sp)
    800013da:	6aa2                	ld	s5,8(sp)
    800013dc:	6121                	addi	sp,sp,64
    800013de:	8082                	ret

00000000800013e0 <reparent>:
{
    800013e0:	7179                	addi	sp,sp,-48
    800013e2:	f406                	sd	ra,40(sp)
    800013e4:	f022                	sd	s0,32(sp)
    800013e6:	ec26                	sd	s1,24(sp)
    800013e8:	e84a                	sd	s2,16(sp)
    800013ea:	e44e                	sd	s3,8(sp)
    800013ec:	e052                	sd	s4,0(sp)
    800013ee:	1800                	addi	s0,sp,48
    800013f0:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800013f2:	00007497          	auipc	s1,0x7
    800013f6:	95e48493          	addi	s1,s1,-1698 # 80007d50 <proc>
      pp->parent = initproc;
    800013fa:	00006a17          	auipc	s4,0x6
    800013fe:	4e6a0a13          	addi	s4,s4,1254 # 800078e0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001402:	0000c997          	auipc	s3,0xc
    80001406:	34e98993          	addi	s3,s3,846 # 8000d750 <tickslock>
    8000140a:	a029                	j	80001414 <reparent+0x34>
    8000140c:	16848493          	addi	s1,s1,360
    80001410:	01348b63          	beq	s1,s3,80001426 <reparent+0x46>
    if(pp->parent == p){
    80001414:	7c9c                	ld	a5,56(s1)
    80001416:	ff279be3          	bne	a5,s2,8000140c <reparent+0x2c>
      pp->parent = initproc;
    8000141a:	000a3503          	ld	a0,0(s4)
    8000141e:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001420:	f57ff0ef          	jal	80001376 <wakeup>
    80001424:	b7e5                	j	8000140c <reparent+0x2c>
}
    80001426:	70a2                	ld	ra,40(sp)
    80001428:	7402                	ld	s0,32(sp)
    8000142a:	64e2                	ld	s1,24(sp)
    8000142c:	6942                	ld	s2,16(sp)
    8000142e:	69a2                	ld	s3,8(sp)
    80001430:	6a02                	ld	s4,0(sp)
    80001432:	6145                	addi	sp,sp,48
    80001434:	8082                	ret

0000000080001436 <exit>:
{
    80001436:	7179                	addi	sp,sp,-48
    80001438:	f406                	sd	ra,40(sp)
    8000143a:	f022                	sd	s0,32(sp)
    8000143c:	ec26                	sd	s1,24(sp)
    8000143e:	e84a                	sd	s2,16(sp)
    80001440:	e44e                	sd	s3,8(sp)
    80001442:	e052                	sd	s4,0(sp)
    80001444:	1800                	addi	s0,sp,48
    80001446:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001448:	915ff0ef          	jal	80000d5c <myproc>
    8000144c:	89aa                	mv	s3,a0
  if(p == initproc)
    8000144e:	00006797          	auipc	a5,0x6
    80001452:	4927b783          	ld	a5,1170(a5) # 800078e0 <initproc>
    80001456:	0d050493          	addi	s1,a0,208
    8000145a:	15050913          	addi	s2,a0,336
    8000145e:	00a79b63          	bne	a5,a0,80001474 <exit+0x3e>
    panic("init exiting");
    80001462:	00006517          	auipc	a0,0x6
    80001466:	dbe50513          	addi	a0,a0,-578 # 80007220 <etext+0x220>
    8000146a:	78d030ef          	jal	800053f6 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    8000146e:	04a1                	addi	s1,s1,8
    80001470:	01248963          	beq	s1,s2,80001482 <exit+0x4c>
    if(p->ofile[fd]){
    80001474:	6088                	ld	a0,0(s1)
    80001476:	dd65                	beqz	a0,8000146e <exit+0x38>
      fileclose(f);
    80001478:	667010ef          	jal	800032de <fileclose>
      p->ofile[fd] = 0;
    8000147c:	0004b023          	sd	zero,0(s1)
    80001480:	b7fd                	j	8000146e <exit+0x38>
  begin_op();
    80001482:	23d010ef          	jal	80002ebe <begin_op>
  iput(p->cwd);
    80001486:	1509b503          	ld	a0,336(s3)
    8000148a:	304010ef          	jal	8000278e <iput>
  end_op();
    8000148e:	29b010ef          	jal	80002f28 <end_op>
  p->cwd = 0;
    80001492:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001496:	00006497          	auipc	s1,0x6
    8000149a:	4a248493          	addi	s1,s1,1186 # 80007938 <wait_lock>
    8000149e:	8526                	mv	a0,s1
    800014a0:	284040ef          	jal	80005724 <acquire>
  reparent(p);
    800014a4:	854e                	mv	a0,s3
    800014a6:	f3bff0ef          	jal	800013e0 <reparent>
  wakeup(p->parent);
    800014aa:	0389b503          	ld	a0,56(s3)
    800014ae:	ec9ff0ef          	jal	80001376 <wakeup>
  acquire(&p->lock);
    800014b2:	854e                	mv	a0,s3
    800014b4:	270040ef          	jal	80005724 <acquire>
  p->xstate = status;
    800014b8:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800014bc:	4795                	li	a5,5
    800014be:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800014c2:	8526                	mv	a0,s1
    800014c4:	2f4040ef          	jal	800057b8 <release>
  sched();
    800014c8:	d7dff0ef          	jal	80001244 <sched>
  panic("zombie exit");
    800014cc:	00006517          	auipc	a0,0x6
    800014d0:	d6450513          	addi	a0,a0,-668 # 80007230 <etext+0x230>
    800014d4:	723030ef          	jal	800053f6 <panic>

00000000800014d8 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800014d8:	7179                	addi	sp,sp,-48
    800014da:	f406                	sd	ra,40(sp)
    800014dc:	f022                	sd	s0,32(sp)
    800014de:	ec26                	sd	s1,24(sp)
    800014e0:	e84a                	sd	s2,16(sp)
    800014e2:	e44e                	sd	s3,8(sp)
    800014e4:	1800                	addi	s0,sp,48
    800014e6:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800014e8:	00007497          	auipc	s1,0x7
    800014ec:	86848493          	addi	s1,s1,-1944 # 80007d50 <proc>
    800014f0:	0000c997          	auipc	s3,0xc
    800014f4:	26098993          	addi	s3,s3,608 # 8000d750 <tickslock>
    acquire(&p->lock);
    800014f8:	8526                	mv	a0,s1
    800014fa:	22a040ef          	jal	80005724 <acquire>
    if(p->pid == pid){
    800014fe:	589c                	lw	a5,48(s1)
    80001500:	01278b63          	beq	a5,s2,80001516 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001504:	8526                	mv	a0,s1
    80001506:	2b2040ef          	jal	800057b8 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000150a:	16848493          	addi	s1,s1,360
    8000150e:	ff3495e3          	bne	s1,s3,800014f8 <kill+0x20>
  }
  return -1;
    80001512:	557d                	li	a0,-1
    80001514:	a819                	j	8000152a <kill+0x52>
      p->killed = 1;
    80001516:	4785                	li	a5,1
    80001518:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000151a:	4c98                	lw	a4,24(s1)
    8000151c:	4789                	li	a5,2
    8000151e:	00f70d63          	beq	a4,a5,80001538 <kill+0x60>
      release(&p->lock);
    80001522:	8526                	mv	a0,s1
    80001524:	294040ef          	jal	800057b8 <release>
      return 0;
    80001528:	4501                	li	a0,0
}
    8000152a:	70a2                	ld	ra,40(sp)
    8000152c:	7402                	ld	s0,32(sp)
    8000152e:	64e2                	ld	s1,24(sp)
    80001530:	6942                	ld	s2,16(sp)
    80001532:	69a2                	ld	s3,8(sp)
    80001534:	6145                	addi	sp,sp,48
    80001536:	8082                	ret
        p->state = RUNNABLE;
    80001538:	478d                	li	a5,3
    8000153a:	cc9c                	sw	a5,24(s1)
    8000153c:	b7dd                	j	80001522 <kill+0x4a>

000000008000153e <setkilled>:

void
setkilled(struct proc *p)
{
    8000153e:	1101                	addi	sp,sp,-32
    80001540:	ec06                	sd	ra,24(sp)
    80001542:	e822                	sd	s0,16(sp)
    80001544:	e426                	sd	s1,8(sp)
    80001546:	1000                	addi	s0,sp,32
    80001548:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000154a:	1da040ef          	jal	80005724 <acquire>
  p->killed = 1;
    8000154e:	4785                	li	a5,1
    80001550:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001552:	8526                	mv	a0,s1
    80001554:	264040ef          	jal	800057b8 <release>
}
    80001558:	60e2                	ld	ra,24(sp)
    8000155a:	6442                	ld	s0,16(sp)
    8000155c:	64a2                	ld	s1,8(sp)
    8000155e:	6105                	addi	sp,sp,32
    80001560:	8082                	ret

0000000080001562 <killed>:

int
killed(struct proc *p)
{
    80001562:	1101                	addi	sp,sp,-32
    80001564:	ec06                	sd	ra,24(sp)
    80001566:	e822                	sd	s0,16(sp)
    80001568:	e426                	sd	s1,8(sp)
    8000156a:	e04a                	sd	s2,0(sp)
    8000156c:	1000                	addi	s0,sp,32
    8000156e:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001570:	1b4040ef          	jal	80005724 <acquire>
  k = p->killed;
    80001574:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001578:	8526                	mv	a0,s1
    8000157a:	23e040ef          	jal	800057b8 <release>
  return k;
}
    8000157e:	854a                	mv	a0,s2
    80001580:	60e2                	ld	ra,24(sp)
    80001582:	6442                	ld	s0,16(sp)
    80001584:	64a2                	ld	s1,8(sp)
    80001586:	6902                	ld	s2,0(sp)
    80001588:	6105                	addi	sp,sp,32
    8000158a:	8082                	ret

000000008000158c <wait>:
{
    8000158c:	715d                	addi	sp,sp,-80
    8000158e:	e486                	sd	ra,72(sp)
    80001590:	e0a2                	sd	s0,64(sp)
    80001592:	fc26                	sd	s1,56(sp)
    80001594:	f84a                	sd	s2,48(sp)
    80001596:	f44e                	sd	s3,40(sp)
    80001598:	f052                	sd	s4,32(sp)
    8000159a:	ec56                	sd	s5,24(sp)
    8000159c:	e85a                	sd	s6,16(sp)
    8000159e:	e45e                	sd	s7,8(sp)
    800015a0:	0880                	addi	s0,sp,80
    800015a2:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015a4:	fb8ff0ef          	jal	80000d5c <myproc>
    800015a8:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015aa:	00006517          	auipc	a0,0x6
    800015ae:	38e50513          	addi	a0,a0,910 # 80007938 <wait_lock>
    800015b2:	172040ef          	jal	80005724 <acquire>
        if(pp->state == ZOMBIE){
    800015b6:	4a15                	li	s4,5
        havekids = 1;
    800015b8:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800015ba:	0000c997          	auipc	s3,0xc
    800015be:	19698993          	addi	s3,s3,406 # 8000d750 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015c2:	00006b97          	auipc	s7,0x6
    800015c6:	376b8b93          	addi	s7,s7,886 # 80007938 <wait_lock>
    800015ca:	a869                	j	80001664 <wait+0xd8>
          pid = pp->pid;
    800015cc:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800015d0:	000b0c63          	beqz	s6,800015e8 <wait+0x5c>
    800015d4:	4691                	li	a3,4
    800015d6:	02c48613          	addi	a2,s1,44
    800015da:	85da                	mv	a1,s6
    800015dc:	05093503          	ld	a0,80(s2)
    800015e0:	c24ff0ef          	jal	80000a04 <copyout>
    800015e4:	02054a63          	bltz	a0,80001618 <wait+0x8c>
          freeproc(pp);
    800015e8:	8526                	mv	a0,s1
    800015ea:	8e5ff0ef          	jal	80000ece <freeproc>
          release(&pp->lock);
    800015ee:	8526                	mv	a0,s1
    800015f0:	1c8040ef          	jal	800057b8 <release>
          release(&wait_lock);
    800015f4:	00006517          	auipc	a0,0x6
    800015f8:	34450513          	addi	a0,a0,836 # 80007938 <wait_lock>
    800015fc:	1bc040ef          	jal	800057b8 <release>
}
    80001600:	854e                	mv	a0,s3
    80001602:	60a6                	ld	ra,72(sp)
    80001604:	6406                	ld	s0,64(sp)
    80001606:	74e2                	ld	s1,56(sp)
    80001608:	7942                	ld	s2,48(sp)
    8000160a:	79a2                	ld	s3,40(sp)
    8000160c:	7a02                	ld	s4,32(sp)
    8000160e:	6ae2                	ld	s5,24(sp)
    80001610:	6b42                	ld	s6,16(sp)
    80001612:	6ba2                	ld	s7,8(sp)
    80001614:	6161                	addi	sp,sp,80
    80001616:	8082                	ret
            release(&pp->lock);
    80001618:	8526                	mv	a0,s1
    8000161a:	19e040ef          	jal	800057b8 <release>
            release(&wait_lock);
    8000161e:	00006517          	auipc	a0,0x6
    80001622:	31a50513          	addi	a0,a0,794 # 80007938 <wait_lock>
    80001626:	192040ef          	jal	800057b8 <release>
            return -1;
    8000162a:	59fd                	li	s3,-1
    8000162c:	bfd1                	j	80001600 <wait+0x74>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000162e:	16848493          	addi	s1,s1,360
    80001632:	03348063          	beq	s1,s3,80001652 <wait+0xc6>
      if(pp->parent == p){
    80001636:	7c9c                	ld	a5,56(s1)
    80001638:	ff279be3          	bne	a5,s2,8000162e <wait+0xa2>
        acquire(&pp->lock);
    8000163c:	8526                	mv	a0,s1
    8000163e:	0e6040ef          	jal	80005724 <acquire>
        if(pp->state == ZOMBIE){
    80001642:	4c9c                	lw	a5,24(s1)
    80001644:	f94784e3          	beq	a5,s4,800015cc <wait+0x40>
        release(&pp->lock);
    80001648:	8526                	mv	a0,s1
    8000164a:	16e040ef          	jal	800057b8 <release>
        havekids = 1;
    8000164e:	8756                	mv	a4,s5
    80001650:	bff9                	j	8000162e <wait+0xa2>
    if(!havekids || killed(p)){
    80001652:	cf19                	beqz	a4,80001670 <wait+0xe4>
    80001654:	854a                	mv	a0,s2
    80001656:	f0dff0ef          	jal	80001562 <killed>
    8000165a:	e919                	bnez	a0,80001670 <wait+0xe4>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000165c:	85de                	mv	a1,s7
    8000165e:	854a                	mv	a0,s2
    80001660:	ccbff0ef          	jal	8000132a <sleep>
    havekids = 0;
    80001664:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001666:	00006497          	auipc	s1,0x6
    8000166a:	6ea48493          	addi	s1,s1,1770 # 80007d50 <proc>
    8000166e:	b7e1                	j	80001636 <wait+0xaa>
      release(&wait_lock);
    80001670:	00006517          	auipc	a0,0x6
    80001674:	2c850513          	addi	a0,a0,712 # 80007938 <wait_lock>
    80001678:	140040ef          	jal	800057b8 <release>
      return -1;
    8000167c:	59fd                	li	s3,-1
    8000167e:	b749                	j	80001600 <wait+0x74>

0000000080001680 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001680:	7179                	addi	sp,sp,-48
    80001682:	f406                	sd	ra,40(sp)
    80001684:	f022                	sd	s0,32(sp)
    80001686:	ec26                	sd	s1,24(sp)
    80001688:	e84a                	sd	s2,16(sp)
    8000168a:	e44e                	sd	s3,8(sp)
    8000168c:	e052                	sd	s4,0(sp)
    8000168e:	1800                	addi	s0,sp,48
    80001690:	84aa                	mv	s1,a0
    80001692:	892e                	mv	s2,a1
    80001694:	89b2                	mv	s3,a2
    80001696:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001698:	ec4ff0ef          	jal	80000d5c <myproc>
  if(user_dst){
    8000169c:	cc99                	beqz	s1,800016ba <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    8000169e:	86d2                	mv	a3,s4
    800016a0:	864e                	mv	a2,s3
    800016a2:	85ca                	mv	a1,s2
    800016a4:	6928                	ld	a0,80(a0)
    800016a6:	b5eff0ef          	jal	80000a04 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800016aa:	70a2                	ld	ra,40(sp)
    800016ac:	7402                	ld	s0,32(sp)
    800016ae:	64e2                	ld	s1,24(sp)
    800016b0:	6942                	ld	s2,16(sp)
    800016b2:	69a2                	ld	s3,8(sp)
    800016b4:	6a02                	ld	s4,0(sp)
    800016b6:	6145                	addi	sp,sp,48
    800016b8:	8082                	ret
    memmove((char *)dst, src, len);
    800016ba:	000a061b          	sext.w	a2,s4
    800016be:	85ce                	mv	a1,s3
    800016c0:	854a                	mv	a0,s2
    800016c2:	af1fe0ef          	jal	800001b2 <memmove>
    return 0;
    800016c6:	8526                	mv	a0,s1
    800016c8:	b7cd                	j	800016aa <either_copyout+0x2a>

00000000800016ca <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800016ca:	7179                	addi	sp,sp,-48
    800016cc:	f406                	sd	ra,40(sp)
    800016ce:	f022                	sd	s0,32(sp)
    800016d0:	ec26                	sd	s1,24(sp)
    800016d2:	e84a                	sd	s2,16(sp)
    800016d4:	e44e                	sd	s3,8(sp)
    800016d6:	e052                	sd	s4,0(sp)
    800016d8:	1800                	addi	s0,sp,48
    800016da:	892a                	mv	s2,a0
    800016dc:	84ae                	mv	s1,a1
    800016de:	89b2                	mv	s3,a2
    800016e0:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800016e2:	e7aff0ef          	jal	80000d5c <myproc>
  if(user_src){
    800016e6:	cc99                	beqz	s1,80001704 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800016e8:	86d2                	mv	a3,s4
    800016ea:	864e                	mv	a2,s3
    800016ec:	85ca                	mv	a1,s2
    800016ee:	6928                	ld	a0,80(a0)
    800016f0:	bc4ff0ef          	jal	80000ab4 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800016f4:	70a2                	ld	ra,40(sp)
    800016f6:	7402                	ld	s0,32(sp)
    800016f8:	64e2                	ld	s1,24(sp)
    800016fa:	6942                	ld	s2,16(sp)
    800016fc:	69a2                	ld	s3,8(sp)
    800016fe:	6a02                	ld	s4,0(sp)
    80001700:	6145                	addi	sp,sp,48
    80001702:	8082                	ret
    memmove(dst, (char*)src, len);
    80001704:	000a061b          	sext.w	a2,s4
    80001708:	85ce                	mv	a1,s3
    8000170a:	854a                	mv	a0,s2
    8000170c:	aa7fe0ef          	jal	800001b2 <memmove>
    return 0;
    80001710:	8526                	mv	a0,s1
    80001712:	b7cd                	j	800016f4 <either_copyin+0x2a>

0000000080001714 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001714:	715d                	addi	sp,sp,-80
    80001716:	e486                	sd	ra,72(sp)
    80001718:	e0a2                	sd	s0,64(sp)
    8000171a:	fc26                	sd	s1,56(sp)
    8000171c:	f84a                	sd	s2,48(sp)
    8000171e:	f44e                	sd	s3,40(sp)
    80001720:	f052                	sd	s4,32(sp)
    80001722:	ec56                	sd	s5,24(sp)
    80001724:	e85a                	sd	s6,16(sp)
    80001726:	e45e                	sd	s7,8(sp)
    80001728:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000172a:	00006517          	auipc	a0,0x6
    8000172e:	8ee50513          	addi	a0,a0,-1810 # 80007018 <etext+0x18>
    80001732:	1f5030ef          	jal	80005126 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001736:	00006497          	auipc	s1,0x6
    8000173a:	77248493          	addi	s1,s1,1906 # 80007ea8 <proc+0x158>
    8000173e:	0000c917          	auipc	s2,0xc
    80001742:	16a90913          	addi	s2,s2,362 # 8000d8a8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001746:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001748:	00006997          	auipc	s3,0x6
    8000174c:	af898993          	addi	s3,s3,-1288 # 80007240 <etext+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    80001750:	00006a97          	auipc	s5,0x6
    80001754:	af8a8a93          	addi	s5,s5,-1288 # 80007248 <etext+0x248>
    printf("\n");
    80001758:	00006a17          	auipc	s4,0x6
    8000175c:	8c0a0a13          	addi	s4,s4,-1856 # 80007018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001760:	00006b97          	auipc	s7,0x6
    80001764:	010b8b93          	addi	s7,s7,16 # 80007770 <states.0>
    80001768:	a829                	j	80001782 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    8000176a:	ed86a583          	lw	a1,-296(a3)
    8000176e:	8556                	mv	a0,s5
    80001770:	1b7030ef          	jal	80005126 <printf>
    printf("\n");
    80001774:	8552                	mv	a0,s4
    80001776:	1b1030ef          	jal	80005126 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000177a:	16848493          	addi	s1,s1,360
    8000177e:	03248263          	beq	s1,s2,800017a2 <procdump+0x8e>
    if(p->state == UNUSED)
    80001782:	86a6                	mv	a3,s1
    80001784:	ec04a783          	lw	a5,-320(s1)
    80001788:	dbed                	beqz	a5,8000177a <procdump+0x66>
      state = "???";
    8000178a:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000178c:	fcfb6fe3          	bltu	s6,a5,8000176a <procdump+0x56>
    80001790:	02079713          	slli	a4,a5,0x20
    80001794:	01d75793          	srli	a5,a4,0x1d
    80001798:	97de                	add	a5,a5,s7
    8000179a:	6390                	ld	a2,0(a5)
    8000179c:	f679                	bnez	a2,8000176a <procdump+0x56>
      state = "???";
    8000179e:	864e                	mv	a2,s3
    800017a0:	b7e9                	j	8000176a <procdump+0x56>
  }
}
    800017a2:	60a6                	ld	ra,72(sp)
    800017a4:	6406                	ld	s0,64(sp)
    800017a6:	74e2                	ld	s1,56(sp)
    800017a8:	7942                	ld	s2,48(sp)
    800017aa:	79a2                	ld	s3,40(sp)
    800017ac:	7a02                	ld	s4,32(sp)
    800017ae:	6ae2                	ld	s5,24(sp)
    800017b0:	6b42                	ld	s6,16(sp)
    800017b2:	6ba2                	ld	s7,8(sp)
    800017b4:	6161                	addi	sp,sp,80
    800017b6:	8082                	ret

00000000800017b8 <swtch>:
    800017b8:	00153023          	sd	ra,0(a0)
    800017bc:	00253423          	sd	sp,8(a0)
    800017c0:	e900                	sd	s0,16(a0)
    800017c2:	ed04                	sd	s1,24(a0)
    800017c4:	03253023          	sd	s2,32(a0)
    800017c8:	03353423          	sd	s3,40(a0)
    800017cc:	03453823          	sd	s4,48(a0)
    800017d0:	03553c23          	sd	s5,56(a0)
    800017d4:	05653023          	sd	s6,64(a0)
    800017d8:	05753423          	sd	s7,72(a0)
    800017dc:	05853823          	sd	s8,80(a0)
    800017e0:	05953c23          	sd	s9,88(a0)
    800017e4:	07a53023          	sd	s10,96(a0)
    800017e8:	07b53423          	sd	s11,104(a0)
    800017ec:	0005b083          	ld	ra,0(a1)
    800017f0:	0085b103          	ld	sp,8(a1)
    800017f4:	6980                	ld	s0,16(a1)
    800017f6:	6d84                	ld	s1,24(a1)
    800017f8:	0205b903          	ld	s2,32(a1)
    800017fc:	0285b983          	ld	s3,40(a1)
    80001800:	0305ba03          	ld	s4,48(a1)
    80001804:	0385ba83          	ld	s5,56(a1)
    80001808:	0405bb03          	ld	s6,64(a1)
    8000180c:	0485bb83          	ld	s7,72(a1)
    80001810:	0505bc03          	ld	s8,80(a1)
    80001814:	0585bc83          	ld	s9,88(a1)
    80001818:	0605bd03          	ld	s10,96(a1)
    8000181c:	0685bd83          	ld	s11,104(a1)
    80001820:	8082                	ret

0000000080001822 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001822:	1141                	addi	sp,sp,-16
    80001824:	e406                	sd	ra,8(sp)
    80001826:	e022                	sd	s0,0(sp)
    80001828:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    8000182a:	00006597          	auipc	a1,0x6
    8000182e:	a5e58593          	addi	a1,a1,-1442 # 80007288 <etext+0x288>
    80001832:	0000c517          	auipc	a0,0xc
    80001836:	f1e50513          	addi	a0,a0,-226 # 8000d750 <tickslock>
    8000183a:	667030ef          	jal	800056a0 <initlock>
}
    8000183e:	60a2                	ld	ra,8(sp)
    80001840:	6402                	ld	s0,0(sp)
    80001842:	0141                	addi	sp,sp,16
    80001844:	8082                	ret

0000000080001846 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001846:	1141                	addi	sp,sp,-16
    80001848:	e406                	sd	ra,8(sp)
    8000184a:	e022                	sd	s0,0(sp)
    8000184c:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000184e:	00003797          	auipc	a5,0x3
    80001852:	e4278793          	addi	a5,a5,-446 # 80004690 <kernelvec>
    80001856:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    8000185a:	60a2                	ld	ra,8(sp)
    8000185c:	6402                	ld	s0,0(sp)
    8000185e:	0141                	addi	sp,sp,16
    80001860:	8082                	ret

0000000080001862 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001862:	1141                	addi	sp,sp,-16
    80001864:	e406                	sd	ra,8(sp)
    80001866:	e022                	sd	s0,0(sp)
    80001868:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    8000186a:	cf2ff0ef          	jal	80000d5c <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000186e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001872:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001874:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001878:	00004697          	auipc	a3,0x4
    8000187c:	78868693          	addi	a3,a3,1928 # 80006000 <_trampoline>
    80001880:	00004717          	auipc	a4,0x4
    80001884:	78070713          	addi	a4,a4,1920 # 80006000 <_trampoline>
    80001888:	8f15                	sub	a4,a4,a3
    8000188a:	040007b7          	lui	a5,0x4000
    8000188e:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001890:	07b2                	slli	a5,a5,0xc
    80001892:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001894:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001898:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    8000189a:	18002673          	csrr	a2,satp
    8000189e:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800018a0:	6d30                	ld	a2,88(a0)
    800018a2:	6138                	ld	a4,64(a0)
    800018a4:	6585                	lui	a1,0x1
    800018a6:	972e                	add	a4,a4,a1
    800018a8:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800018aa:	6d38                	ld	a4,88(a0)
    800018ac:	00000617          	auipc	a2,0x0
    800018b0:	11060613          	addi	a2,a2,272 # 800019bc <usertrap>
    800018b4:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800018b6:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800018b8:	8612                	mv	a2,tp
    800018ba:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800018bc:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800018c0:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800018c4:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800018c8:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800018cc:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800018ce:	6f18                	ld	a4,24(a4)
    800018d0:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800018d4:	6928                	ld	a0,80(a0)
    800018d6:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800018d8:	00004717          	auipc	a4,0x4
    800018dc:	7c470713          	addi	a4,a4,1988 # 8000609c <userret>
    800018e0:	8f15                	sub	a4,a4,a3
    800018e2:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800018e4:	577d                	li	a4,-1
    800018e6:	177e                	slli	a4,a4,0x3f
    800018e8:	8d59                	or	a0,a0,a4
    800018ea:	9782                	jalr	a5
}
    800018ec:	60a2                	ld	ra,8(sp)
    800018ee:	6402                	ld	s0,0(sp)
    800018f0:	0141                	addi	sp,sp,16
    800018f2:	8082                	ret

00000000800018f4 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800018f4:	1101                	addi	sp,sp,-32
    800018f6:	ec06                	sd	ra,24(sp)
    800018f8:	e822                	sd	s0,16(sp)
    800018fa:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    800018fc:	c2cff0ef          	jal	80000d28 <cpuid>
    80001900:	cd11                	beqz	a0,8000191c <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80001902:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80001906:	000f4737          	lui	a4,0xf4
    8000190a:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000190e:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80001910:	14d79073          	csrw	stimecmp,a5
}
    80001914:	60e2                	ld	ra,24(sp)
    80001916:	6442                	ld	s0,16(sp)
    80001918:	6105                	addi	sp,sp,32
    8000191a:	8082                	ret
    8000191c:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    8000191e:	0000c497          	auipc	s1,0xc
    80001922:	e3248493          	addi	s1,s1,-462 # 8000d750 <tickslock>
    80001926:	8526                	mv	a0,s1
    80001928:	5fd030ef          	jal	80005724 <acquire>
    ticks++;
    8000192c:	00006517          	auipc	a0,0x6
    80001930:	fbc50513          	addi	a0,a0,-68 # 800078e8 <ticks>
    80001934:	411c                	lw	a5,0(a0)
    80001936:	2785                	addiw	a5,a5,1
    80001938:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    8000193a:	a3dff0ef          	jal	80001376 <wakeup>
    release(&tickslock);
    8000193e:	8526                	mv	a0,s1
    80001940:	679030ef          	jal	800057b8 <release>
    80001944:	64a2                	ld	s1,8(sp)
    80001946:	bf75                	j	80001902 <clockintr+0xe>

0000000080001948 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001948:	1101                	addi	sp,sp,-32
    8000194a:	ec06                	sd	ra,24(sp)
    8000194c:	e822                	sd	s0,16(sp)
    8000194e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001950:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80001954:	57fd                	li	a5,-1
    80001956:	17fe                	slli	a5,a5,0x3f
    80001958:	07a5                	addi	a5,a5,9
    8000195a:	00f70c63          	beq	a4,a5,80001972 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    8000195e:	57fd                	li	a5,-1
    80001960:	17fe                	slli	a5,a5,0x3f
    80001962:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80001964:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80001966:	04f70763          	beq	a4,a5,800019b4 <devintr+0x6c>
  }
}
    8000196a:	60e2                	ld	ra,24(sp)
    8000196c:	6442                	ld	s0,16(sp)
    8000196e:	6105                	addi	sp,sp,32
    80001970:	8082                	ret
    80001972:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001974:	5c9020ef          	jal	8000473c <plic_claim>
    80001978:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    8000197a:	47a9                	li	a5,10
    8000197c:	00f50963          	beq	a0,a5,8000198e <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    80001980:	4785                	li	a5,1
    80001982:	00f50963          	beq	a0,a5,80001994 <devintr+0x4c>
    return 1;
    80001986:	4505                	li	a0,1
    } else if(irq){
    80001988:	e889                	bnez	s1,8000199a <devintr+0x52>
    8000198a:	64a2                	ld	s1,8(sp)
    8000198c:	bff9                	j	8000196a <devintr+0x22>
      uartintr();
    8000198e:	4d7030ef          	jal	80005664 <uartintr>
    if(irq)
    80001992:	a819                	j	800019a8 <devintr+0x60>
      virtio_disk_intr();
    80001994:	238030ef          	jal	80004bcc <virtio_disk_intr>
    if(irq)
    80001998:	a801                	j	800019a8 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    8000199a:	85a6                	mv	a1,s1
    8000199c:	00006517          	auipc	a0,0x6
    800019a0:	8f450513          	addi	a0,a0,-1804 # 80007290 <etext+0x290>
    800019a4:	782030ef          	jal	80005126 <printf>
      plic_complete(irq);
    800019a8:	8526                	mv	a0,s1
    800019aa:	5b3020ef          	jal	8000475c <plic_complete>
    return 1;
    800019ae:	4505                	li	a0,1
    800019b0:	64a2                	ld	s1,8(sp)
    800019b2:	bf65                	j	8000196a <devintr+0x22>
    clockintr();
    800019b4:	f41ff0ef          	jal	800018f4 <clockintr>
    return 2;
    800019b8:	4509                	li	a0,2
    800019ba:	bf45                	j	8000196a <devintr+0x22>

00000000800019bc <usertrap>:
{
    800019bc:	1101                	addi	sp,sp,-32
    800019be:	ec06                	sd	ra,24(sp)
    800019c0:	e822                	sd	s0,16(sp)
    800019c2:	e426                	sd	s1,8(sp)
    800019c4:	e04a                	sd	s2,0(sp)
    800019c6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800019c8:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800019cc:	1007f793          	andi	a5,a5,256
    800019d0:	ef85                	bnez	a5,80001a08 <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800019d2:	00003797          	auipc	a5,0x3
    800019d6:	cbe78793          	addi	a5,a5,-834 # 80004690 <kernelvec>
    800019da:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800019de:	b7eff0ef          	jal	80000d5c <myproc>
    800019e2:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800019e4:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800019e6:	14102773          	csrr	a4,sepc
    800019ea:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800019ec:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800019f0:	47a1                	li	a5,8
    800019f2:	02f70163          	beq	a4,a5,80001a14 <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    800019f6:	f53ff0ef          	jal	80001948 <devintr>
    800019fa:	892a                	mv	s2,a0
    800019fc:	c135                	beqz	a0,80001a60 <usertrap+0xa4>
  if(killed(p))
    800019fe:	8526                	mv	a0,s1
    80001a00:	b63ff0ef          	jal	80001562 <killed>
    80001a04:	cd1d                	beqz	a0,80001a42 <usertrap+0x86>
    80001a06:	a81d                	j	80001a3c <usertrap+0x80>
    panic("usertrap: not from user mode");
    80001a08:	00006517          	auipc	a0,0x6
    80001a0c:	8a850513          	addi	a0,a0,-1880 # 800072b0 <etext+0x2b0>
    80001a10:	1e7030ef          	jal	800053f6 <panic>
    if(killed(p))
    80001a14:	b4fff0ef          	jal	80001562 <killed>
    80001a18:	e121                	bnez	a0,80001a58 <usertrap+0x9c>
    p->trapframe->epc += 4;
    80001a1a:	6cb8                	ld	a4,88(s1)
    80001a1c:	6f1c                	ld	a5,24(a4)
    80001a1e:	0791                	addi	a5,a5,4
    80001a20:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a22:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001a26:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001a2a:	10079073          	csrw	sstatus,a5
    syscall();
    80001a2e:	240000ef          	jal	80001c6e <syscall>
  if(killed(p))
    80001a32:	8526                	mv	a0,s1
    80001a34:	b2fff0ef          	jal	80001562 <killed>
    80001a38:	c901                	beqz	a0,80001a48 <usertrap+0x8c>
    80001a3a:	4901                	li	s2,0
    exit(-1);
    80001a3c:	557d                	li	a0,-1
    80001a3e:	9f9ff0ef          	jal	80001436 <exit>
  if(which_dev == 2)
    80001a42:	4789                	li	a5,2
    80001a44:	04f90563          	beq	s2,a5,80001a8e <usertrap+0xd2>
  usertrapret();
    80001a48:	e1bff0ef          	jal	80001862 <usertrapret>
}
    80001a4c:	60e2                	ld	ra,24(sp)
    80001a4e:	6442                	ld	s0,16(sp)
    80001a50:	64a2                	ld	s1,8(sp)
    80001a52:	6902                	ld	s2,0(sp)
    80001a54:	6105                	addi	sp,sp,32
    80001a56:	8082                	ret
      exit(-1);
    80001a58:	557d                	li	a0,-1
    80001a5a:	9ddff0ef          	jal	80001436 <exit>
    80001a5e:	bf75                	j	80001a1a <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a60:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001a64:	5890                	lw	a2,48(s1)
    80001a66:	00006517          	auipc	a0,0x6
    80001a6a:	86a50513          	addi	a0,a0,-1942 # 800072d0 <etext+0x2d0>
    80001a6e:	6b8030ef          	jal	80005126 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a72:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001a76:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001a7a:	00006517          	auipc	a0,0x6
    80001a7e:	88650513          	addi	a0,a0,-1914 # 80007300 <etext+0x300>
    80001a82:	6a4030ef          	jal	80005126 <printf>
    setkilled(p);
    80001a86:	8526                	mv	a0,s1
    80001a88:	ab7ff0ef          	jal	8000153e <setkilled>
    80001a8c:	b75d                	j	80001a32 <usertrap+0x76>
    yield();
    80001a8e:	871ff0ef          	jal	800012fe <yield>
    80001a92:	bf5d                	j	80001a48 <usertrap+0x8c>

0000000080001a94 <kerneltrap>:
{
    80001a94:	7179                	addi	sp,sp,-48
    80001a96:	f406                	sd	ra,40(sp)
    80001a98:	f022                	sd	s0,32(sp)
    80001a9a:	ec26                	sd	s1,24(sp)
    80001a9c:	e84a                	sd	s2,16(sp)
    80001a9e:	e44e                	sd	s3,8(sp)
    80001aa0:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001aa2:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001aa6:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001aaa:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001aae:	1004f793          	andi	a5,s1,256
    80001ab2:	c795                	beqz	a5,80001ade <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ab4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001ab8:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001aba:	eb85                	bnez	a5,80001aea <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80001abc:	e8dff0ef          	jal	80001948 <devintr>
    80001ac0:	c91d                	beqz	a0,80001af6 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80001ac2:	4789                	li	a5,2
    80001ac4:	04f50a63          	beq	a0,a5,80001b18 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001ac8:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001acc:	10049073          	csrw	sstatus,s1
}
    80001ad0:	70a2                	ld	ra,40(sp)
    80001ad2:	7402                	ld	s0,32(sp)
    80001ad4:	64e2                	ld	s1,24(sp)
    80001ad6:	6942                	ld	s2,16(sp)
    80001ad8:	69a2                	ld	s3,8(sp)
    80001ada:	6145                	addi	sp,sp,48
    80001adc:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001ade:	00006517          	auipc	a0,0x6
    80001ae2:	84a50513          	addi	a0,a0,-1974 # 80007328 <etext+0x328>
    80001ae6:	111030ef          	jal	800053f6 <panic>
    panic("kerneltrap: interrupts enabled");
    80001aea:	00006517          	auipc	a0,0x6
    80001aee:	86650513          	addi	a0,a0,-1946 # 80007350 <etext+0x350>
    80001af2:	105030ef          	jal	800053f6 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001af6:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001afa:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001afe:	85ce                	mv	a1,s3
    80001b00:	00006517          	auipc	a0,0x6
    80001b04:	87050513          	addi	a0,a0,-1936 # 80007370 <etext+0x370>
    80001b08:	61e030ef          	jal	80005126 <printf>
    panic("kerneltrap");
    80001b0c:	00006517          	auipc	a0,0x6
    80001b10:	88c50513          	addi	a0,a0,-1908 # 80007398 <etext+0x398>
    80001b14:	0e3030ef          	jal	800053f6 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001b18:	a44ff0ef          	jal	80000d5c <myproc>
    80001b1c:	d555                	beqz	a0,80001ac8 <kerneltrap+0x34>
    yield();
    80001b1e:	fe0ff0ef          	jal	800012fe <yield>
    80001b22:	b75d                	j	80001ac8 <kerneltrap+0x34>

0000000080001b24 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001b24:	1101                	addi	sp,sp,-32
    80001b26:	ec06                	sd	ra,24(sp)
    80001b28:	e822                	sd	s0,16(sp)
    80001b2a:	e426                	sd	s1,8(sp)
    80001b2c:	1000                	addi	s0,sp,32
    80001b2e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001b30:	a2cff0ef          	jal	80000d5c <myproc>
  switch (n) {
    80001b34:	4795                	li	a5,5
    80001b36:	0497e163          	bltu	a5,s1,80001b78 <argraw+0x54>
    80001b3a:	048a                	slli	s1,s1,0x2
    80001b3c:	00006717          	auipc	a4,0x6
    80001b40:	c6470713          	addi	a4,a4,-924 # 800077a0 <states.0+0x30>
    80001b44:	94ba                	add	s1,s1,a4
    80001b46:	409c                	lw	a5,0(s1)
    80001b48:	97ba                	add	a5,a5,a4
    80001b4a:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001b4c:	6d3c                	ld	a5,88(a0)
    80001b4e:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001b50:	60e2                	ld	ra,24(sp)
    80001b52:	6442                	ld	s0,16(sp)
    80001b54:	64a2                	ld	s1,8(sp)
    80001b56:	6105                	addi	sp,sp,32
    80001b58:	8082                	ret
    return p->trapframe->a1;
    80001b5a:	6d3c                	ld	a5,88(a0)
    80001b5c:	7fa8                	ld	a0,120(a5)
    80001b5e:	bfcd                	j	80001b50 <argraw+0x2c>
    return p->trapframe->a2;
    80001b60:	6d3c                	ld	a5,88(a0)
    80001b62:	63c8                	ld	a0,128(a5)
    80001b64:	b7f5                	j	80001b50 <argraw+0x2c>
    return p->trapframe->a3;
    80001b66:	6d3c                	ld	a5,88(a0)
    80001b68:	67c8                	ld	a0,136(a5)
    80001b6a:	b7dd                	j	80001b50 <argraw+0x2c>
    return p->trapframe->a4;
    80001b6c:	6d3c                	ld	a5,88(a0)
    80001b6e:	6bc8                	ld	a0,144(a5)
    80001b70:	b7c5                	j	80001b50 <argraw+0x2c>
    return p->trapframe->a5;
    80001b72:	6d3c                	ld	a5,88(a0)
    80001b74:	6fc8                	ld	a0,152(a5)
    80001b76:	bfe9                	j	80001b50 <argraw+0x2c>
  panic("argraw");
    80001b78:	00006517          	auipc	a0,0x6
    80001b7c:	83050513          	addi	a0,a0,-2000 # 800073a8 <etext+0x3a8>
    80001b80:	077030ef          	jal	800053f6 <panic>

0000000080001b84 <fetchaddr>:
{
    80001b84:	1101                	addi	sp,sp,-32
    80001b86:	ec06                	sd	ra,24(sp)
    80001b88:	e822                	sd	s0,16(sp)
    80001b8a:	e426                	sd	s1,8(sp)
    80001b8c:	e04a                	sd	s2,0(sp)
    80001b8e:	1000                	addi	s0,sp,32
    80001b90:	84aa                	mv	s1,a0
    80001b92:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001b94:	9c8ff0ef          	jal	80000d5c <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001b98:	653c                	ld	a5,72(a0)
    80001b9a:	02f4f663          	bgeu	s1,a5,80001bc6 <fetchaddr+0x42>
    80001b9e:	00848713          	addi	a4,s1,8
    80001ba2:	02e7e463          	bltu	a5,a4,80001bca <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001ba6:	46a1                	li	a3,8
    80001ba8:	8626                	mv	a2,s1
    80001baa:	85ca                	mv	a1,s2
    80001bac:	6928                	ld	a0,80(a0)
    80001bae:	f07fe0ef          	jal	80000ab4 <copyin>
    80001bb2:	00a03533          	snez	a0,a0
    80001bb6:	40a0053b          	negw	a0,a0
}
    80001bba:	60e2                	ld	ra,24(sp)
    80001bbc:	6442                	ld	s0,16(sp)
    80001bbe:	64a2                	ld	s1,8(sp)
    80001bc0:	6902                	ld	s2,0(sp)
    80001bc2:	6105                	addi	sp,sp,32
    80001bc4:	8082                	ret
    return -1;
    80001bc6:	557d                	li	a0,-1
    80001bc8:	bfcd                	j	80001bba <fetchaddr+0x36>
    80001bca:	557d                	li	a0,-1
    80001bcc:	b7fd                	j	80001bba <fetchaddr+0x36>

0000000080001bce <fetchstr>:
{
    80001bce:	7179                	addi	sp,sp,-48
    80001bd0:	f406                	sd	ra,40(sp)
    80001bd2:	f022                	sd	s0,32(sp)
    80001bd4:	ec26                	sd	s1,24(sp)
    80001bd6:	e84a                	sd	s2,16(sp)
    80001bd8:	e44e                	sd	s3,8(sp)
    80001bda:	1800                	addi	s0,sp,48
    80001bdc:	892a                	mv	s2,a0
    80001bde:	84ae                	mv	s1,a1
    80001be0:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001be2:	97aff0ef          	jal	80000d5c <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001be6:	86ce                	mv	a3,s3
    80001be8:	864a                	mv	a2,s2
    80001bea:	85a6                	mv	a1,s1
    80001bec:	6928                	ld	a0,80(a0)
    80001bee:	f4dfe0ef          	jal	80000b3a <copyinstr>
    80001bf2:	00054c63          	bltz	a0,80001c0a <fetchstr+0x3c>
  return strlen(buf);
    80001bf6:	8526                	mv	a0,s1
    80001bf8:	edefe0ef          	jal	800002d6 <strlen>
}
    80001bfc:	70a2                	ld	ra,40(sp)
    80001bfe:	7402                	ld	s0,32(sp)
    80001c00:	64e2                	ld	s1,24(sp)
    80001c02:	6942                	ld	s2,16(sp)
    80001c04:	69a2                	ld	s3,8(sp)
    80001c06:	6145                	addi	sp,sp,48
    80001c08:	8082                	ret
    return -1;
    80001c0a:	557d                	li	a0,-1
    80001c0c:	bfc5                	j	80001bfc <fetchstr+0x2e>

0000000080001c0e <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001c0e:	1101                	addi	sp,sp,-32
    80001c10:	ec06                	sd	ra,24(sp)
    80001c12:	e822                	sd	s0,16(sp)
    80001c14:	e426                	sd	s1,8(sp)
    80001c16:	1000                	addi	s0,sp,32
    80001c18:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001c1a:	f0bff0ef          	jal	80001b24 <argraw>
    80001c1e:	c088                	sw	a0,0(s1)
}
    80001c20:	60e2                	ld	ra,24(sp)
    80001c22:	6442                	ld	s0,16(sp)
    80001c24:	64a2                	ld	s1,8(sp)
    80001c26:	6105                	addi	sp,sp,32
    80001c28:	8082                	ret

0000000080001c2a <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001c2a:	1101                	addi	sp,sp,-32
    80001c2c:	ec06                	sd	ra,24(sp)
    80001c2e:	e822                	sd	s0,16(sp)
    80001c30:	e426                	sd	s1,8(sp)
    80001c32:	1000                	addi	s0,sp,32
    80001c34:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001c36:	eefff0ef          	jal	80001b24 <argraw>
    80001c3a:	e088                	sd	a0,0(s1)
}
    80001c3c:	60e2                	ld	ra,24(sp)
    80001c3e:	6442                	ld	s0,16(sp)
    80001c40:	64a2                	ld	s1,8(sp)
    80001c42:	6105                	addi	sp,sp,32
    80001c44:	8082                	ret

0000000080001c46 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001c46:	1101                	addi	sp,sp,-32
    80001c48:	ec06                	sd	ra,24(sp)
    80001c4a:	e822                	sd	s0,16(sp)
    80001c4c:	e426                	sd	s1,8(sp)
    80001c4e:	e04a                	sd	s2,0(sp)
    80001c50:	1000                	addi	s0,sp,32
    80001c52:	84ae                	mv	s1,a1
    80001c54:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001c56:	ecfff0ef          	jal	80001b24 <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    80001c5a:	864a                	mv	a2,s2
    80001c5c:	85a6                	mv	a1,s1
    80001c5e:	f71ff0ef          	jal	80001bce <fetchstr>
}
    80001c62:	60e2                	ld	ra,24(sp)
    80001c64:	6442                	ld	s0,16(sp)
    80001c66:	64a2                	ld	s1,8(sp)
    80001c68:	6902                	ld	s2,0(sp)
    80001c6a:	6105                	addi	sp,sp,32
    80001c6c:	8082                	ret

0000000080001c6e <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80001c6e:	1101                	addi	sp,sp,-32
    80001c70:	ec06                	sd	ra,24(sp)
    80001c72:	e822                	sd	s0,16(sp)
    80001c74:	e426                	sd	s1,8(sp)
    80001c76:	e04a                	sd	s2,0(sp)
    80001c78:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001c7a:	8e2ff0ef          	jal	80000d5c <myproc>
    80001c7e:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001c80:	05853903          	ld	s2,88(a0)
    80001c84:	0a893783          	ld	a5,168(s2)
    80001c88:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001c8c:	37fd                	addiw	a5,a5,-1
    80001c8e:	4751                	li	a4,20
    80001c90:	00f76f63          	bltu	a4,a5,80001cae <syscall+0x40>
    80001c94:	00369713          	slli	a4,a3,0x3
    80001c98:	00006797          	auipc	a5,0x6
    80001c9c:	b2078793          	addi	a5,a5,-1248 # 800077b8 <syscalls>
    80001ca0:	97ba                	add	a5,a5,a4
    80001ca2:	639c                	ld	a5,0(a5)
    80001ca4:	c789                	beqz	a5,80001cae <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001ca6:	9782                	jalr	a5
    80001ca8:	06a93823          	sd	a0,112(s2)
    80001cac:	a829                	j	80001cc6 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001cae:	15848613          	addi	a2,s1,344
    80001cb2:	588c                	lw	a1,48(s1)
    80001cb4:	00005517          	auipc	a0,0x5
    80001cb8:	6fc50513          	addi	a0,a0,1788 # 800073b0 <etext+0x3b0>
    80001cbc:	46a030ef          	jal	80005126 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001cc0:	6cbc                	ld	a5,88(s1)
    80001cc2:	577d                	li	a4,-1
    80001cc4:	fbb8                	sd	a4,112(a5)
  }
}
    80001cc6:	60e2                	ld	ra,24(sp)
    80001cc8:	6442                	ld	s0,16(sp)
    80001cca:	64a2                	ld	s1,8(sp)
    80001ccc:	6902                	ld	s2,0(sp)
    80001cce:	6105                	addi	sp,sp,32
    80001cd0:	8082                	ret

0000000080001cd2 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80001cd2:	1101                	addi	sp,sp,-32
    80001cd4:	ec06                	sd	ra,24(sp)
    80001cd6:	e822                	sd	s0,16(sp)
    80001cd8:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001cda:	fec40593          	addi	a1,s0,-20
    80001cde:	4501                	li	a0,0
    80001ce0:	f2fff0ef          	jal	80001c0e <argint>
  exit(n);
    80001ce4:	fec42503          	lw	a0,-20(s0)
    80001ce8:	f4eff0ef          	jal	80001436 <exit>
  return 0;  // not reached
}
    80001cec:	4501                	li	a0,0
    80001cee:	60e2                	ld	ra,24(sp)
    80001cf0:	6442                	ld	s0,16(sp)
    80001cf2:	6105                	addi	sp,sp,32
    80001cf4:	8082                	ret

0000000080001cf6 <sys_getpid>:

uint64
sys_getpid(void)
{
    80001cf6:	1141                	addi	sp,sp,-16
    80001cf8:	e406                	sd	ra,8(sp)
    80001cfa:	e022                	sd	s0,0(sp)
    80001cfc:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001cfe:	85eff0ef          	jal	80000d5c <myproc>
}
    80001d02:	5908                	lw	a0,48(a0)
    80001d04:	60a2                	ld	ra,8(sp)
    80001d06:	6402                	ld	s0,0(sp)
    80001d08:	0141                	addi	sp,sp,16
    80001d0a:	8082                	ret

0000000080001d0c <sys_fork>:

uint64
sys_fork(void)
{
    80001d0c:	1141                	addi	sp,sp,-16
    80001d0e:	e406                	sd	ra,8(sp)
    80001d10:	e022                	sd	s0,0(sp)
    80001d12:	0800                	addi	s0,sp,16
  return fork();
    80001d14:	b6eff0ef          	jal	80001082 <fork>
}
    80001d18:	60a2                	ld	ra,8(sp)
    80001d1a:	6402                	ld	s0,0(sp)
    80001d1c:	0141                	addi	sp,sp,16
    80001d1e:	8082                	ret

0000000080001d20 <sys_wait>:

uint64
sys_wait(void)
{
    80001d20:	1101                	addi	sp,sp,-32
    80001d22:	ec06                	sd	ra,24(sp)
    80001d24:	e822                	sd	s0,16(sp)
    80001d26:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001d28:	fe840593          	addi	a1,s0,-24
    80001d2c:	4501                	li	a0,0
    80001d2e:	efdff0ef          	jal	80001c2a <argaddr>
  return wait(p);
    80001d32:	fe843503          	ld	a0,-24(s0)
    80001d36:	857ff0ef          	jal	8000158c <wait>
}
    80001d3a:	60e2                	ld	ra,24(sp)
    80001d3c:	6442                	ld	s0,16(sp)
    80001d3e:	6105                	addi	sp,sp,32
    80001d40:	8082                	ret

0000000080001d42 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001d42:	7179                	addi	sp,sp,-48
    80001d44:	f406                	sd	ra,40(sp)
    80001d46:	f022                	sd	s0,32(sp)
    80001d48:	ec26                	sd	s1,24(sp)
    80001d4a:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80001d4c:	fdc40593          	addi	a1,s0,-36
    80001d50:	4501                	li	a0,0
    80001d52:	ebdff0ef          	jal	80001c0e <argint>
  addr = myproc()->sz;
    80001d56:	806ff0ef          	jal	80000d5c <myproc>
    80001d5a:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80001d5c:	fdc42503          	lw	a0,-36(s0)
    80001d60:	ad2ff0ef          	jal	80001032 <growproc>
    80001d64:	00054863          	bltz	a0,80001d74 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80001d68:	8526                	mv	a0,s1
    80001d6a:	70a2                	ld	ra,40(sp)
    80001d6c:	7402                	ld	s0,32(sp)
    80001d6e:	64e2                	ld	s1,24(sp)
    80001d70:	6145                	addi	sp,sp,48
    80001d72:	8082                	ret
    return -1;
    80001d74:	54fd                	li	s1,-1
    80001d76:	bfcd                	j	80001d68 <sys_sbrk+0x26>

0000000080001d78 <sys_sleep>:

uint64
sys_sleep(void)
{
    80001d78:	7139                	addi	sp,sp,-64
    80001d7a:	fc06                	sd	ra,56(sp)
    80001d7c:	f822                	sd	s0,48(sp)
    80001d7e:	f04a                	sd	s2,32(sp)
    80001d80:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80001d82:	fcc40593          	addi	a1,s0,-52
    80001d86:	4501                	li	a0,0
    80001d88:	e87ff0ef          	jal	80001c0e <argint>
  if(n < 0)
    80001d8c:	fcc42783          	lw	a5,-52(s0)
    80001d90:	0607c763          	bltz	a5,80001dfe <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80001d94:	0000c517          	auipc	a0,0xc
    80001d98:	9bc50513          	addi	a0,a0,-1604 # 8000d750 <tickslock>
    80001d9c:	189030ef          	jal	80005724 <acquire>
  ticks0 = ticks;
    80001da0:	00006917          	auipc	s2,0x6
    80001da4:	b4892903          	lw	s2,-1208(s2) # 800078e8 <ticks>
  while(ticks - ticks0 < n){
    80001da8:	fcc42783          	lw	a5,-52(s0)
    80001dac:	cf8d                	beqz	a5,80001de6 <sys_sleep+0x6e>
    80001dae:	f426                	sd	s1,40(sp)
    80001db0:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001db2:	0000c997          	auipc	s3,0xc
    80001db6:	99e98993          	addi	s3,s3,-1634 # 8000d750 <tickslock>
    80001dba:	00006497          	auipc	s1,0x6
    80001dbe:	b2e48493          	addi	s1,s1,-1234 # 800078e8 <ticks>
    if(killed(myproc())){
    80001dc2:	f9bfe0ef          	jal	80000d5c <myproc>
    80001dc6:	f9cff0ef          	jal	80001562 <killed>
    80001dca:	ed0d                	bnez	a0,80001e04 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80001dcc:	85ce                	mv	a1,s3
    80001dce:	8526                	mv	a0,s1
    80001dd0:	d5aff0ef          	jal	8000132a <sleep>
  while(ticks - ticks0 < n){
    80001dd4:	409c                	lw	a5,0(s1)
    80001dd6:	412787bb          	subw	a5,a5,s2
    80001dda:	fcc42703          	lw	a4,-52(s0)
    80001dde:	fee7e2e3          	bltu	a5,a4,80001dc2 <sys_sleep+0x4a>
    80001de2:	74a2                	ld	s1,40(sp)
    80001de4:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80001de6:	0000c517          	auipc	a0,0xc
    80001dea:	96a50513          	addi	a0,a0,-1686 # 8000d750 <tickslock>
    80001dee:	1cb030ef          	jal	800057b8 <release>
  return 0;
    80001df2:	4501                	li	a0,0
}
    80001df4:	70e2                	ld	ra,56(sp)
    80001df6:	7442                	ld	s0,48(sp)
    80001df8:	7902                	ld	s2,32(sp)
    80001dfa:	6121                	addi	sp,sp,64
    80001dfc:	8082                	ret
    n = 0;
    80001dfe:	fc042623          	sw	zero,-52(s0)
    80001e02:	bf49                	j	80001d94 <sys_sleep+0x1c>
      release(&tickslock);
    80001e04:	0000c517          	auipc	a0,0xc
    80001e08:	94c50513          	addi	a0,a0,-1716 # 8000d750 <tickslock>
    80001e0c:	1ad030ef          	jal	800057b8 <release>
      return -1;
    80001e10:	557d                	li	a0,-1
    80001e12:	74a2                	ld	s1,40(sp)
    80001e14:	69e2                	ld	s3,24(sp)
    80001e16:	bff9                	j	80001df4 <sys_sleep+0x7c>

0000000080001e18 <sys_kill>:

uint64
sys_kill(void)
{
    80001e18:	1101                	addi	sp,sp,-32
    80001e1a:	ec06                	sd	ra,24(sp)
    80001e1c:	e822                	sd	s0,16(sp)
    80001e1e:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80001e20:	fec40593          	addi	a1,s0,-20
    80001e24:	4501                	li	a0,0
    80001e26:	de9ff0ef          	jal	80001c0e <argint>
  return kill(pid);
    80001e2a:	fec42503          	lw	a0,-20(s0)
    80001e2e:	eaaff0ef          	jal	800014d8 <kill>
}
    80001e32:	60e2                	ld	ra,24(sp)
    80001e34:	6442                	ld	s0,16(sp)
    80001e36:	6105                	addi	sp,sp,32
    80001e38:	8082                	ret

0000000080001e3a <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80001e3a:	1101                	addi	sp,sp,-32
    80001e3c:	ec06                	sd	ra,24(sp)
    80001e3e:	e822                	sd	s0,16(sp)
    80001e40:	e426                	sd	s1,8(sp)
    80001e42:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80001e44:	0000c517          	auipc	a0,0xc
    80001e48:	90c50513          	addi	a0,a0,-1780 # 8000d750 <tickslock>
    80001e4c:	0d9030ef          	jal	80005724 <acquire>
  xticks = ticks;
    80001e50:	00006497          	auipc	s1,0x6
    80001e54:	a984a483          	lw	s1,-1384(s1) # 800078e8 <ticks>
  release(&tickslock);
    80001e58:	0000c517          	auipc	a0,0xc
    80001e5c:	8f850513          	addi	a0,a0,-1800 # 8000d750 <tickslock>
    80001e60:	159030ef          	jal	800057b8 <release>
  return xticks;
}
    80001e64:	02049513          	slli	a0,s1,0x20
    80001e68:	9101                	srli	a0,a0,0x20
    80001e6a:	60e2                	ld	ra,24(sp)
    80001e6c:	6442                	ld	s0,16(sp)
    80001e6e:	64a2                	ld	s1,8(sp)
    80001e70:	6105                	addi	sp,sp,32
    80001e72:	8082                	ret

0000000080001e74 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80001e74:	7179                	addi	sp,sp,-48
    80001e76:	f406                	sd	ra,40(sp)
    80001e78:	f022                	sd	s0,32(sp)
    80001e7a:	ec26                	sd	s1,24(sp)
    80001e7c:	e84a                	sd	s2,16(sp)
    80001e7e:	e44e                	sd	s3,8(sp)
    80001e80:	e052                	sd	s4,0(sp)
    80001e82:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80001e84:	00005597          	auipc	a1,0x5
    80001e88:	54c58593          	addi	a1,a1,1356 # 800073d0 <etext+0x3d0>
    80001e8c:	0000c517          	auipc	a0,0xc
    80001e90:	8dc50513          	addi	a0,a0,-1828 # 8000d768 <bcache>
    80001e94:	00d030ef          	jal	800056a0 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80001e98:	00014797          	auipc	a5,0x14
    80001e9c:	8d078793          	addi	a5,a5,-1840 # 80015768 <bcache+0x8000>
    80001ea0:	00014717          	auipc	a4,0x14
    80001ea4:	b3070713          	addi	a4,a4,-1232 # 800159d0 <bcache+0x8268>
    80001ea8:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80001eac:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001eb0:	0000c497          	auipc	s1,0xc
    80001eb4:	8d048493          	addi	s1,s1,-1840 # 8000d780 <bcache+0x18>
    b->next = bcache.head.next;
    80001eb8:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80001eba:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80001ebc:	00005a17          	auipc	s4,0x5
    80001ec0:	51ca0a13          	addi	s4,s4,1308 # 800073d8 <etext+0x3d8>
    b->next = bcache.head.next;
    80001ec4:	2b893783          	ld	a5,696(s2)
    80001ec8:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80001eca:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80001ece:	85d2                	mv	a1,s4
    80001ed0:	01048513          	addi	a0,s1,16
    80001ed4:	244010ef          	jal	80003118 <initsleeplock>
    bcache.head.next->prev = b;
    80001ed8:	2b893783          	ld	a5,696(s2)
    80001edc:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80001ede:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001ee2:	45848493          	addi	s1,s1,1112
    80001ee6:	fd349fe3          	bne	s1,s3,80001ec4 <binit+0x50>
  }
}
    80001eea:	70a2                	ld	ra,40(sp)
    80001eec:	7402                	ld	s0,32(sp)
    80001eee:	64e2                	ld	s1,24(sp)
    80001ef0:	6942                	ld	s2,16(sp)
    80001ef2:	69a2                	ld	s3,8(sp)
    80001ef4:	6a02                	ld	s4,0(sp)
    80001ef6:	6145                	addi	sp,sp,48
    80001ef8:	8082                	ret

0000000080001efa <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80001efa:	7179                	addi	sp,sp,-48
    80001efc:	f406                	sd	ra,40(sp)
    80001efe:	f022                	sd	s0,32(sp)
    80001f00:	ec26                	sd	s1,24(sp)
    80001f02:	e84a                	sd	s2,16(sp)
    80001f04:	e44e                	sd	s3,8(sp)
    80001f06:	1800                	addi	s0,sp,48
    80001f08:	892a                	mv	s2,a0
    80001f0a:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80001f0c:	0000c517          	auipc	a0,0xc
    80001f10:	85c50513          	addi	a0,a0,-1956 # 8000d768 <bcache>
    80001f14:	011030ef          	jal	80005724 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80001f18:	00014497          	auipc	s1,0x14
    80001f1c:	b084b483          	ld	s1,-1272(s1) # 80015a20 <bcache+0x82b8>
    80001f20:	00014797          	auipc	a5,0x14
    80001f24:	ab078793          	addi	a5,a5,-1360 # 800159d0 <bcache+0x8268>
    80001f28:	02f48b63          	beq	s1,a5,80001f5e <bread+0x64>
    80001f2c:	873e                	mv	a4,a5
    80001f2e:	a021                	j	80001f36 <bread+0x3c>
    80001f30:	68a4                	ld	s1,80(s1)
    80001f32:	02e48663          	beq	s1,a4,80001f5e <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80001f36:	449c                	lw	a5,8(s1)
    80001f38:	ff279ce3          	bne	a5,s2,80001f30 <bread+0x36>
    80001f3c:	44dc                	lw	a5,12(s1)
    80001f3e:	ff3799e3          	bne	a5,s3,80001f30 <bread+0x36>
      b->refcnt++;
    80001f42:	40bc                	lw	a5,64(s1)
    80001f44:	2785                	addiw	a5,a5,1
    80001f46:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80001f48:	0000c517          	auipc	a0,0xc
    80001f4c:	82050513          	addi	a0,a0,-2016 # 8000d768 <bcache>
    80001f50:	069030ef          	jal	800057b8 <release>
      acquiresleep(&b->lock);
    80001f54:	01048513          	addi	a0,s1,16
    80001f58:	1f6010ef          	jal	8000314e <acquiresleep>
      return b;
    80001f5c:	a889                	j	80001fae <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80001f5e:	00014497          	auipc	s1,0x14
    80001f62:	aba4b483          	ld	s1,-1350(s1) # 80015a18 <bcache+0x82b0>
    80001f66:	00014797          	auipc	a5,0x14
    80001f6a:	a6a78793          	addi	a5,a5,-1430 # 800159d0 <bcache+0x8268>
    80001f6e:	00f48863          	beq	s1,a5,80001f7e <bread+0x84>
    80001f72:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80001f74:	40bc                	lw	a5,64(s1)
    80001f76:	cb91                	beqz	a5,80001f8a <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80001f78:	64a4                	ld	s1,72(s1)
    80001f7a:	fee49de3          	bne	s1,a4,80001f74 <bread+0x7a>
  panic("bget: no buffers");
    80001f7e:	00005517          	auipc	a0,0x5
    80001f82:	46250513          	addi	a0,a0,1122 # 800073e0 <etext+0x3e0>
    80001f86:	470030ef          	jal	800053f6 <panic>
      b->dev = dev;
    80001f8a:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80001f8e:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80001f92:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80001f96:	4785                	li	a5,1
    80001f98:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80001f9a:	0000b517          	auipc	a0,0xb
    80001f9e:	7ce50513          	addi	a0,a0,1998 # 8000d768 <bcache>
    80001fa2:	017030ef          	jal	800057b8 <release>
      acquiresleep(&b->lock);
    80001fa6:	01048513          	addi	a0,s1,16
    80001faa:	1a4010ef          	jal	8000314e <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80001fae:	409c                	lw	a5,0(s1)
    80001fb0:	cb89                	beqz	a5,80001fc2 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80001fb2:	8526                	mv	a0,s1
    80001fb4:	70a2                	ld	ra,40(sp)
    80001fb6:	7402                	ld	s0,32(sp)
    80001fb8:	64e2                	ld	s1,24(sp)
    80001fba:	6942                	ld	s2,16(sp)
    80001fbc:	69a2                	ld	s3,8(sp)
    80001fbe:	6145                	addi	sp,sp,48
    80001fc0:	8082                	ret
    virtio_disk_rw(b, 0);
    80001fc2:	4581                	li	a1,0
    80001fc4:	8526                	mv	a0,s1
    80001fc6:	1fb020ef          	jal	800049c0 <virtio_disk_rw>
    b->valid = 1;
    80001fca:	4785                	li	a5,1
    80001fcc:	c09c                	sw	a5,0(s1)
  return b;
    80001fce:	b7d5                	j	80001fb2 <bread+0xb8>

0000000080001fd0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80001fd0:	1101                	addi	sp,sp,-32
    80001fd2:	ec06                	sd	ra,24(sp)
    80001fd4:	e822                	sd	s0,16(sp)
    80001fd6:	e426                	sd	s1,8(sp)
    80001fd8:	1000                	addi	s0,sp,32
    80001fda:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80001fdc:	0541                	addi	a0,a0,16
    80001fde:	1ee010ef          	jal	800031cc <holdingsleep>
    80001fe2:	c911                	beqz	a0,80001ff6 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80001fe4:	4585                	li	a1,1
    80001fe6:	8526                	mv	a0,s1
    80001fe8:	1d9020ef          	jal	800049c0 <virtio_disk_rw>
}
    80001fec:	60e2                	ld	ra,24(sp)
    80001fee:	6442                	ld	s0,16(sp)
    80001ff0:	64a2                	ld	s1,8(sp)
    80001ff2:	6105                	addi	sp,sp,32
    80001ff4:	8082                	ret
    panic("bwrite");
    80001ff6:	00005517          	auipc	a0,0x5
    80001ffa:	40250513          	addi	a0,a0,1026 # 800073f8 <etext+0x3f8>
    80001ffe:	3f8030ef          	jal	800053f6 <panic>

0000000080002002 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002002:	1101                	addi	sp,sp,-32
    80002004:	ec06                	sd	ra,24(sp)
    80002006:	e822                	sd	s0,16(sp)
    80002008:	e426                	sd	s1,8(sp)
    8000200a:	e04a                	sd	s2,0(sp)
    8000200c:	1000                	addi	s0,sp,32
    8000200e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002010:	01050913          	addi	s2,a0,16
    80002014:	854a                	mv	a0,s2
    80002016:	1b6010ef          	jal	800031cc <holdingsleep>
    8000201a:	c125                	beqz	a0,8000207a <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    8000201c:	854a                	mv	a0,s2
    8000201e:	176010ef          	jal	80003194 <releasesleep>

  acquire(&bcache.lock);
    80002022:	0000b517          	auipc	a0,0xb
    80002026:	74650513          	addi	a0,a0,1862 # 8000d768 <bcache>
    8000202a:	6fa030ef          	jal	80005724 <acquire>
  b->refcnt--;
    8000202e:	40bc                	lw	a5,64(s1)
    80002030:	37fd                	addiw	a5,a5,-1
    80002032:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002034:	e79d                	bnez	a5,80002062 <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002036:	68b8                	ld	a4,80(s1)
    80002038:	64bc                	ld	a5,72(s1)
    8000203a:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    8000203c:	68b8                	ld	a4,80(s1)
    8000203e:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002040:	00013797          	auipc	a5,0x13
    80002044:	72878793          	addi	a5,a5,1832 # 80015768 <bcache+0x8000>
    80002048:	2b87b703          	ld	a4,696(a5)
    8000204c:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000204e:	00014717          	auipc	a4,0x14
    80002052:	98270713          	addi	a4,a4,-1662 # 800159d0 <bcache+0x8268>
    80002056:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002058:	2b87b703          	ld	a4,696(a5)
    8000205c:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000205e:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002062:	0000b517          	auipc	a0,0xb
    80002066:	70650513          	addi	a0,a0,1798 # 8000d768 <bcache>
    8000206a:	74e030ef          	jal	800057b8 <release>
}
    8000206e:	60e2                	ld	ra,24(sp)
    80002070:	6442                	ld	s0,16(sp)
    80002072:	64a2                	ld	s1,8(sp)
    80002074:	6902                	ld	s2,0(sp)
    80002076:	6105                	addi	sp,sp,32
    80002078:	8082                	ret
    panic("brelse");
    8000207a:	00005517          	auipc	a0,0x5
    8000207e:	38650513          	addi	a0,a0,902 # 80007400 <etext+0x400>
    80002082:	374030ef          	jal	800053f6 <panic>

0000000080002086 <bpin>:

void
bpin(struct buf *b) {
    80002086:	1101                	addi	sp,sp,-32
    80002088:	ec06                	sd	ra,24(sp)
    8000208a:	e822                	sd	s0,16(sp)
    8000208c:	e426                	sd	s1,8(sp)
    8000208e:	1000                	addi	s0,sp,32
    80002090:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002092:	0000b517          	auipc	a0,0xb
    80002096:	6d650513          	addi	a0,a0,1750 # 8000d768 <bcache>
    8000209a:	68a030ef          	jal	80005724 <acquire>
  b->refcnt++;
    8000209e:	40bc                	lw	a5,64(s1)
    800020a0:	2785                	addiw	a5,a5,1
    800020a2:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800020a4:	0000b517          	auipc	a0,0xb
    800020a8:	6c450513          	addi	a0,a0,1732 # 8000d768 <bcache>
    800020ac:	70c030ef          	jal	800057b8 <release>
}
    800020b0:	60e2                	ld	ra,24(sp)
    800020b2:	6442                	ld	s0,16(sp)
    800020b4:	64a2                	ld	s1,8(sp)
    800020b6:	6105                	addi	sp,sp,32
    800020b8:	8082                	ret

00000000800020ba <bunpin>:

void
bunpin(struct buf *b) {
    800020ba:	1101                	addi	sp,sp,-32
    800020bc:	ec06                	sd	ra,24(sp)
    800020be:	e822                	sd	s0,16(sp)
    800020c0:	e426                	sd	s1,8(sp)
    800020c2:	1000                	addi	s0,sp,32
    800020c4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800020c6:	0000b517          	auipc	a0,0xb
    800020ca:	6a250513          	addi	a0,a0,1698 # 8000d768 <bcache>
    800020ce:	656030ef          	jal	80005724 <acquire>
  b->refcnt--;
    800020d2:	40bc                	lw	a5,64(s1)
    800020d4:	37fd                	addiw	a5,a5,-1
    800020d6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800020d8:	0000b517          	auipc	a0,0xb
    800020dc:	69050513          	addi	a0,a0,1680 # 8000d768 <bcache>
    800020e0:	6d8030ef          	jal	800057b8 <release>
}
    800020e4:	60e2                	ld	ra,24(sp)
    800020e6:	6442                	ld	s0,16(sp)
    800020e8:	64a2                	ld	s1,8(sp)
    800020ea:	6105                	addi	sp,sp,32
    800020ec:	8082                	ret

00000000800020ee <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800020ee:	1101                	addi	sp,sp,-32
    800020f0:	ec06                	sd	ra,24(sp)
    800020f2:	e822                	sd	s0,16(sp)
    800020f4:	e426                	sd	s1,8(sp)
    800020f6:	e04a                	sd	s2,0(sp)
    800020f8:	1000                	addi	s0,sp,32
    800020fa:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800020fc:	00d5d79b          	srliw	a5,a1,0xd
    80002100:	00014597          	auipc	a1,0x14
    80002104:	d445a583          	lw	a1,-700(a1) # 80015e44 <sb+0x1c>
    80002108:	9dbd                	addw	a1,a1,a5
    8000210a:	df1ff0ef          	jal	80001efa <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000210e:	0074f713          	andi	a4,s1,7
    80002112:	4785                	li	a5,1
    80002114:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80002118:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    8000211a:	90d9                	srli	s1,s1,0x36
    8000211c:	00950733          	add	a4,a0,s1
    80002120:	05874703          	lbu	a4,88(a4)
    80002124:	00e7f6b3          	and	a3,a5,a4
    80002128:	c29d                	beqz	a3,8000214e <bfree+0x60>
    8000212a:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000212c:	94aa                	add	s1,s1,a0
    8000212e:	fff7c793          	not	a5,a5
    80002132:	8f7d                	and	a4,a4,a5
    80002134:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002138:	711000ef          	jal	80003048 <log_write>
  brelse(bp);
    8000213c:	854a                	mv	a0,s2
    8000213e:	ec5ff0ef          	jal	80002002 <brelse>
}
    80002142:	60e2                	ld	ra,24(sp)
    80002144:	6442                	ld	s0,16(sp)
    80002146:	64a2                	ld	s1,8(sp)
    80002148:	6902                	ld	s2,0(sp)
    8000214a:	6105                	addi	sp,sp,32
    8000214c:	8082                	ret
    panic("freeing free block");
    8000214e:	00005517          	auipc	a0,0x5
    80002152:	2ba50513          	addi	a0,a0,698 # 80007408 <etext+0x408>
    80002156:	2a0030ef          	jal	800053f6 <panic>

000000008000215a <balloc>:
{
    8000215a:	715d                	addi	sp,sp,-80
    8000215c:	e486                	sd	ra,72(sp)
    8000215e:	e0a2                	sd	s0,64(sp)
    80002160:	fc26                	sd	s1,56(sp)
    80002162:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    80002164:	00014797          	auipc	a5,0x14
    80002168:	cc87a783          	lw	a5,-824(a5) # 80015e2c <sb+0x4>
    8000216c:	0e078863          	beqz	a5,8000225c <balloc+0x102>
    80002170:	f84a                	sd	s2,48(sp)
    80002172:	f44e                	sd	s3,40(sp)
    80002174:	f052                	sd	s4,32(sp)
    80002176:	ec56                	sd	s5,24(sp)
    80002178:	e85a                	sd	s6,16(sp)
    8000217a:	e45e                	sd	s7,8(sp)
    8000217c:	e062                	sd	s8,0(sp)
    8000217e:	8baa                	mv	s7,a0
    80002180:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002182:	00014b17          	auipc	s6,0x14
    80002186:	ca6b0b13          	addi	s6,s6,-858 # 80015e28 <sb>
      m = 1 << (bi % 8);
    8000218a:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000218c:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000218e:	6c09                	lui	s8,0x2
    80002190:	a09d                	j	800021f6 <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002192:	97ca                	add	a5,a5,s2
    80002194:	8e55                	or	a2,a2,a3
    80002196:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000219a:	854a                	mv	a0,s2
    8000219c:	6ad000ef          	jal	80003048 <log_write>
        brelse(bp);
    800021a0:	854a                	mv	a0,s2
    800021a2:	e61ff0ef          	jal	80002002 <brelse>
  bp = bread(dev, bno);
    800021a6:	85a6                	mv	a1,s1
    800021a8:	855e                	mv	a0,s7
    800021aa:	d51ff0ef          	jal	80001efa <bread>
    800021ae:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800021b0:	40000613          	li	a2,1024
    800021b4:	4581                	li	a1,0
    800021b6:	05850513          	addi	a0,a0,88
    800021ba:	f95fd0ef          	jal	8000014e <memset>
  log_write(bp);
    800021be:	854a                	mv	a0,s2
    800021c0:	689000ef          	jal	80003048 <log_write>
  brelse(bp);
    800021c4:	854a                	mv	a0,s2
    800021c6:	e3dff0ef          	jal	80002002 <brelse>
}
    800021ca:	7942                	ld	s2,48(sp)
    800021cc:	79a2                	ld	s3,40(sp)
    800021ce:	7a02                	ld	s4,32(sp)
    800021d0:	6ae2                	ld	s5,24(sp)
    800021d2:	6b42                	ld	s6,16(sp)
    800021d4:	6ba2                	ld	s7,8(sp)
    800021d6:	6c02                	ld	s8,0(sp)
}
    800021d8:	8526                	mv	a0,s1
    800021da:	60a6                	ld	ra,72(sp)
    800021dc:	6406                	ld	s0,64(sp)
    800021de:	74e2                	ld	s1,56(sp)
    800021e0:	6161                	addi	sp,sp,80
    800021e2:	8082                	ret
    brelse(bp);
    800021e4:	854a                	mv	a0,s2
    800021e6:	e1dff0ef          	jal	80002002 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800021ea:	015c0abb          	addw	s5,s8,s5
    800021ee:	004b2783          	lw	a5,4(s6)
    800021f2:	04fafe63          	bgeu	s5,a5,8000224e <balloc+0xf4>
    bp = bread(dev, BBLOCK(b, sb));
    800021f6:	41fad79b          	sraiw	a5,s5,0x1f
    800021fa:	0137d79b          	srliw	a5,a5,0x13
    800021fe:	015787bb          	addw	a5,a5,s5
    80002202:	40d7d79b          	sraiw	a5,a5,0xd
    80002206:	01cb2583          	lw	a1,28(s6)
    8000220a:	9dbd                	addw	a1,a1,a5
    8000220c:	855e                	mv	a0,s7
    8000220e:	cedff0ef          	jal	80001efa <bread>
    80002212:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002214:	004b2503          	lw	a0,4(s6)
    80002218:	84d6                	mv	s1,s5
    8000221a:	4701                	li	a4,0
    8000221c:	fca4f4e3          	bgeu	s1,a0,800021e4 <balloc+0x8a>
      m = 1 << (bi % 8);
    80002220:	00777693          	andi	a3,a4,7
    80002224:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002228:	41f7579b          	sraiw	a5,a4,0x1f
    8000222c:	01d7d79b          	srliw	a5,a5,0x1d
    80002230:	9fb9                	addw	a5,a5,a4
    80002232:	4037d79b          	sraiw	a5,a5,0x3
    80002236:	00f90633          	add	a2,s2,a5
    8000223a:	05864603          	lbu	a2,88(a2)
    8000223e:	00c6f5b3          	and	a1,a3,a2
    80002242:	d9a1                	beqz	a1,80002192 <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002244:	2705                	addiw	a4,a4,1
    80002246:	2485                	addiw	s1,s1,1
    80002248:	fd471ae3          	bne	a4,s4,8000221c <balloc+0xc2>
    8000224c:	bf61                	j	800021e4 <balloc+0x8a>
    8000224e:	7942                	ld	s2,48(sp)
    80002250:	79a2                	ld	s3,40(sp)
    80002252:	7a02                	ld	s4,32(sp)
    80002254:	6ae2                	ld	s5,24(sp)
    80002256:	6b42                	ld	s6,16(sp)
    80002258:	6ba2                	ld	s7,8(sp)
    8000225a:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    8000225c:	00005517          	auipc	a0,0x5
    80002260:	1c450513          	addi	a0,a0,452 # 80007420 <etext+0x420>
    80002264:	6c3020ef          	jal	80005126 <printf>
  return 0;
    80002268:	4481                	li	s1,0
    8000226a:	b7bd                	j	800021d8 <balloc+0x7e>

000000008000226c <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000226c:	7179                	addi	sp,sp,-48
    8000226e:	f406                	sd	ra,40(sp)
    80002270:	f022                	sd	s0,32(sp)
    80002272:	ec26                	sd	s1,24(sp)
    80002274:	e84a                	sd	s2,16(sp)
    80002276:	e44e                	sd	s3,8(sp)
    80002278:	1800                	addi	s0,sp,48
    8000227a:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000227c:	47ad                	li	a5,11
    8000227e:	02b7e363          	bltu	a5,a1,800022a4 <bmap+0x38>
    if((addr = ip->addrs[bn]) == 0){
    80002282:	02059793          	slli	a5,a1,0x20
    80002286:	01e7d593          	srli	a1,a5,0x1e
    8000228a:	00b504b3          	add	s1,a0,a1
    8000228e:	0504a903          	lw	s2,80(s1)
    80002292:	06091363          	bnez	s2,800022f8 <bmap+0x8c>
      addr = balloc(ip->dev);
    80002296:	4108                	lw	a0,0(a0)
    80002298:	ec3ff0ef          	jal	8000215a <balloc>
    8000229c:	892a                	mv	s2,a0
      if(addr == 0)
    8000229e:	cd29                	beqz	a0,800022f8 <bmap+0x8c>
        return 0;
      ip->addrs[bn] = addr;
    800022a0:	c8a8                	sw	a0,80(s1)
    800022a2:	a899                	j	800022f8 <bmap+0x8c>
    }
    return addr;
  }
  bn -= NDIRECT;
    800022a4:	ff45849b          	addiw	s1,a1,-12

  if(bn < NINDIRECT){
    800022a8:	0ff00793          	li	a5,255
    800022ac:	0697e963          	bltu	a5,s1,8000231e <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800022b0:	08052903          	lw	s2,128(a0)
    800022b4:	00091b63          	bnez	s2,800022ca <bmap+0x5e>
      addr = balloc(ip->dev);
    800022b8:	4108                	lw	a0,0(a0)
    800022ba:	ea1ff0ef          	jal	8000215a <balloc>
    800022be:	892a                	mv	s2,a0
      if(addr == 0)
    800022c0:	cd05                	beqz	a0,800022f8 <bmap+0x8c>
    800022c2:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800022c4:	08a9a023          	sw	a0,128(s3)
    800022c8:	a011                	j	800022cc <bmap+0x60>
    800022ca:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800022cc:	85ca                	mv	a1,s2
    800022ce:	0009a503          	lw	a0,0(s3)
    800022d2:	c29ff0ef          	jal	80001efa <bread>
    800022d6:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800022d8:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800022dc:	02049713          	slli	a4,s1,0x20
    800022e0:	01e75593          	srli	a1,a4,0x1e
    800022e4:	00b784b3          	add	s1,a5,a1
    800022e8:	0004a903          	lw	s2,0(s1)
    800022ec:	00090e63          	beqz	s2,80002308 <bmap+0x9c>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800022f0:	8552                	mv	a0,s4
    800022f2:	d11ff0ef          	jal	80002002 <brelse>
    return addr;
    800022f6:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800022f8:	854a                	mv	a0,s2
    800022fa:	70a2                	ld	ra,40(sp)
    800022fc:	7402                	ld	s0,32(sp)
    800022fe:	64e2                	ld	s1,24(sp)
    80002300:	6942                	ld	s2,16(sp)
    80002302:	69a2                	ld	s3,8(sp)
    80002304:	6145                	addi	sp,sp,48
    80002306:	8082                	ret
      addr = balloc(ip->dev);
    80002308:	0009a503          	lw	a0,0(s3)
    8000230c:	e4fff0ef          	jal	8000215a <balloc>
    80002310:	892a                	mv	s2,a0
      if(addr){
    80002312:	dd79                	beqz	a0,800022f0 <bmap+0x84>
        a[bn] = addr;
    80002314:	c088                	sw	a0,0(s1)
        log_write(bp);
    80002316:	8552                	mv	a0,s4
    80002318:	531000ef          	jal	80003048 <log_write>
    8000231c:	bfd1                	j	800022f0 <bmap+0x84>
    8000231e:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002320:	00005517          	auipc	a0,0x5
    80002324:	11850513          	addi	a0,a0,280 # 80007438 <etext+0x438>
    80002328:	0ce030ef          	jal	800053f6 <panic>

000000008000232c <iget>:
{
    8000232c:	7179                	addi	sp,sp,-48
    8000232e:	f406                	sd	ra,40(sp)
    80002330:	f022                	sd	s0,32(sp)
    80002332:	ec26                	sd	s1,24(sp)
    80002334:	e84a                	sd	s2,16(sp)
    80002336:	e44e                	sd	s3,8(sp)
    80002338:	e052                	sd	s4,0(sp)
    8000233a:	1800                	addi	s0,sp,48
    8000233c:	89aa                	mv	s3,a0
    8000233e:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002340:	00014517          	auipc	a0,0x14
    80002344:	b0850513          	addi	a0,a0,-1272 # 80015e48 <itable>
    80002348:	3dc030ef          	jal	80005724 <acquire>
  empty = 0;
    8000234c:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000234e:	00014497          	auipc	s1,0x14
    80002352:	b1248493          	addi	s1,s1,-1262 # 80015e60 <itable+0x18>
    80002356:	00015697          	auipc	a3,0x15
    8000235a:	59a68693          	addi	a3,a3,1434 # 800178f0 <log>
    8000235e:	a039                	j	8000236c <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002360:	02090963          	beqz	s2,80002392 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002364:	08848493          	addi	s1,s1,136
    80002368:	02d48863          	beq	s1,a3,80002398 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000236c:	449c                	lw	a5,8(s1)
    8000236e:	fef059e3          	blez	a5,80002360 <iget+0x34>
    80002372:	4098                	lw	a4,0(s1)
    80002374:	ff3716e3          	bne	a4,s3,80002360 <iget+0x34>
    80002378:	40d8                	lw	a4,4(s1)
    8000237a:	ff4713e3          	bne	a4,s4,80002360 <iget+0x34>
      ip->ref++;
    8000237e:	2785                	addiw	a5,a5,1
    80002380:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002382:	00014517          	auipc	a0,0x14
    80002386:	ac650513          	addi	a0,a0,-1338 # 80015e48 <itable>
    8000238a:	42e030ef          	jal	800057b8 <release>
      return ip;
    8000238e:	8926                	mv	s2,s1
    80002390:	a02d                	j	800023ba <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002392:	fbe9                	bnez	a5,80002364 <iget+0x38>
      empty = ip;
    80002394:	8926                	mv	s2,s1
    80002396:	b7f9                	j	80002364 <iget+0x38>
  if(empty == 0)
    80002398:	02090a63          	beqz	s2,800023cc <iget+0xa0>
  ip->dev = dev;
    8000239c:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800023a0:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800023a4:	4785                	li	a5,1
    800023a6:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800023aa:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800023ae:	00014517          	auipc	a0,0x14
    800023b2:	a9a50513          	addi	a0,a0,-1382 # 80015e48 <itable>
    800023b6:	402030ef          	jal	800057b8 <release>
}
    800023ba:	854a                	mv	a0,s2
    800023bc:	70a2                	ld	ra,40(sp)
    800023be:	7402                	ld	s0,32(sp)
    800023c0:	64e2                	ld	s1,24(sp)
    800023c2:	6942                	ld	s2,16(sp)
    800023c4:	69a2                	ld	s3,8(sp)
    800023c6:	6a02                	ld	s4,0(sp)
    800023c8:	6145                	addi	sp,sp,48
    800023ca:	8082                	ret
    panic("iget: no inodes");
    800023cc:	00005517          	auipc	a0,0x5
    800023d0:	08450513          	addi	a0,a0,132 # 80007450 <etext+0x450>
    800023d4:	022030ef          	jal	800053f6 <panic>

00000000800023d8 <fsinit>:
fsinit(int dev) {
    800023d8:	7179                	addi	sp,sp,-48
    800023da:	f406                	sd	ra,40(sp)
    800023dc:	f022                	sd	s0,32(sp)
    800023de:	ec26                	sd	s1,24(sp)
    800023e0:	e84a                	sd	s2,16(sp)
    800023e2:	e44e                	sd	s3,8(sp)
    800023e4:	1800                	addi	s0,sp,48
    800023e6:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800023e8:	4585                	li	a1,1
    800023ea:	b11ff0ef          	jal	80001efa <bread>
    800023ee:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800023f0:	00014997          	auipc	s3,0x14
    800023f4:	a3898993          	addi	s3,s3,-1480 # 80015e28 <sb>
    800023f8:	02000613          	li	a2,32
    800023fc:	05850593          	addi	a1,a0,88
    80002400:	854e                	mv	a0,s3
    80002402:	db1fd0ef          	jal	800001b2 <memmove>
  brelse(bp);
    80002406:	8526                	mv	a0,s1
    80002408:	bfbff0ef          	jal	80002002 <brelse>
  if(sb.magic != FSMAGIC)
    8000240c:	0009a703          	lw	a4,0(s3)
    80002410:	102037b7          	lui	a5,0x10203
    80002414:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002418:	02f71063          	bne	a4,a5,80002438 <fsinit+0x60>
  initlog(dev, &sb);
    8000241c:	00014597          	auipc	a1,0x14
    80002420:	a0c58593          	addi	a1,a1,-1524 # 80015e28 <sb>
    80002424:	854a                	mv	a0,s2
    80002426:	215000ef          	jal	80002e3a <initlog>
}
    8000242a:	70a2                	ld	ra,40(sp)
    8000242c:	7402                	ld	s0,32(sp)
    8000242e:	64e2                	ld	s1,24(sp)
    80002430:	6942                	ld	s2,16(sp)
    80002432:	69a2                	ld	s3,8(sp)
    80002434:	6145                	addi	sp,sp,48
    80002436:	8082                	ret
    panic("invalid file system");
    80002438:	00005517          	auipc	a0,0x5
    8000243c:	02850513          	addi	a0,a0,40 # 80007460 <etext+0x460>
    80002440:	7b7020ef          	jal	800053f6 <panic>

0000000080002444 <iinit>:
{
    80002444:	7179                	addi	sp,sp,-48
    80002446:	f406                	sd	ra,40(sp)
    80002448:	f022                	sd	s0,32(sp)
    8000244a:	ec26                	sd	s1,24(sp)
    8000244c:	e84a                	sd	s2,16(sp)
    8000244e:	e44e                	sd	s3,8(sp)
    80002450:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002452:	00005597          	auipc	a1,0x5
    80002456:	02658593          	addi	a1,a1,38 # 80007478 <etext+0x478>
    8000245a:	00014517          	auipc	a0,0x14
    8000245e:	9ee50513          	addi	a0,a0,-1554 # 80015e48 <itable>
    80002462:	23e030ef          	jal	800056a0 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002466:	00014497          	auipc	s1,0x14
    8000246a:	a0a48493          	addi	s1,s1,-1526 # 80015e70 <itable+0x28>
    8000246e:	00015997          	auipc	s3,0x15
    80002472:	49298993          	addi	s3,s3,1170 # 80017900 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002476:	00005917          	auipc	s2,0x5
    8000247a:	00a90913          	addi	s2,s2,10 # 80007480 <etext+0x480>
    8000247e:	85ca                	mv	a1,s2
    80002480:	8526                	mv	a0,s1
    80002482:	497000ef          	jal	80003118 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002486:	08848493          	addi	s1,s1,136
    8000248a:	ff349ae3          	bne	s1,s3,8000247e <iinit+0x3a>
}
    8000248e:	70a2                	ld	ra,40(sp)
    80002490:	7402                	ld	s0,32(sp)
    80002492:	64e2                	ld	s1,24(sp)
    80002494:	6942                	ld	s2,16(sp)
    80002496:	69a2                	ld	s3,8(sp)
    80002498:	6145                	addi	sp,sp,48
    8000249a:	8082                	ret

000000008000249c <ialloc>:
{
    8000249c:	7139                	addi	sp,sp,-64
    8000249e:	fc06                	sd	ra,56(sp)
    800024a0:	f822                	sd	s0,48(sp)
    800024a2:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800024a4:	00014717          	auipc	a4,0x14
    800024a8:	99072703          	lw	a4,-1648(a4) # 80015e34 <sb+0xc>
    800024ac:	4785                	li	a5,1
    800024ae:	06e7f063          	bgeu	a5,a4,8000250e <ialloc+0x72>
    800024b2:	f426                	sd	s1,40(sp)
    800024b4:	f04a                	sd	s2,32(sp)
    800024b6:	ec4e                	sd	s3,24(sp)
    800024b8:	e852                	sd	s4,16(sp)
    800024ba:	e456                	sd	s5,8(sp)
    800024bc:	e05a                	sd	s6,0(sp)
    800024be:	8aaa                	mv	s5,a0
    800024c0:	8b2e                	mv	s6,a1
    800024c2:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    800024c4:	00014a17          	auipc	s4,0x14
    800024c8:	964a0a13          	addi	s4,s4,-1692 # 80015e28 <sb>
    800024cc:	00495593          	srli	a1,s2,0x4
    800024d0:	018a2783          	lw	a5,24(s4)
    800024d4:	9dbd                	addw	a1,a1,a5
    800024d6:	8556                	mv	a0,s5
    800024d8:	a23ff0ef          	jal	80001efa <bread>
    800024dc:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800024de:	05850993          	addi	s3,a0,88
    800024e2:	00f97793          	andi	a5,s2,15
    800024e6:	079a                	slli	a5,a5,0x6
    800024e8:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800024ea:	00099783          	lh	a5,0(s3)
    800024ee:	cb9d                	beqz	a5,80002524 <ialloc+0x88>
    brelse(bp);
    800024f0:	b13ff0ef          	jal	80002002 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800024f4:	0905                	addi	s2,s2,1
    800024f6:	00ca2703          	lw	a4,12(s4)
    800024fa:	0009079b          	sext.w	a5,s2
    800024fe:	fce7e7e3          	bltu	a5,a4,800024cc <ialloc+0x30>
    80002502:	74a2                	ld	s1,40(sp)
    80002504:	7902                	ld	s2,32(sp)
    80002506:	69e2                	ld	s3,24(sp)
    80002508:	6a42                	ld	s4,16(sp)
    8000250a:	6aa2                	ld	s5,8(sp)
    8000250c:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    8000250e:	00005517          	auipc	a0,0x5
    80002512:	f7a50513          	addi	a0,a0,-134 # 80007488 <etext+0x488>
    80002516:	411020ef          	jal	80005126 <printf>
  return 0;
    8000251a:	4501                	li	a0,0
}
    8000251c:	70e2                	ld	ra,56(sp)
    8000251e:	7442                	ld	s0,48(sp)
    80002520:	6121                	addi	sp,sp,64
    80002522:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002524:	04000613          	li	a2,64
    80002528:	4581                	li	a1,0
    8000252a:	854e                	mv	a0,s3
    8000252c:	c23fd0ef          	jal	8000014e <memset>
      dip->type = type;
    80002530:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002534:	8526                	mv	a0,s1
    80002536:	313000ef          	jal	80003048 <log_write>
      brelse(bp);
    8000253a:	8526                	mv	a0,s1
    8000253c:	ac7ff0ef          	jal	80002002 <brelse>
      return iget(dev, inum);
    80002540:	0009059b          	sext.w	a1,s2
    80002544:	8556                	mv	a0,s5
    80002546:	de7ff0ef          	jal	8000232c <iget>
    8000254a:	74a2                	ld	s1,40(sp)
    8000254c:	7902                	ld	s2,32(sp)
    8000254e:	69e2                	ld	s3,24(sp)
    80002550:	6a42                	ld	s4,16(sp)
    80002552:	6aa2                	ld	s5,8(sp)
    80002554:	6b02                	ld	s6,0(sp)
    80002556:	b7d9                	j	8000251c <ialloc+0x80>

0000000080002558 <iupdate>:
{
    80002558:	1101                	addi	sp,sp,-32
    8000255a:	ec06                	sd	ra,24(sp)
    8000255c:	e822                	sd	s0,16(sp)
    8000255e:	e426                	sd	s1,8(sp)
    80002560:	e04a                	sd	s2,0(sp)
    80002562:	1000                	addi	s0,sp,32
    80002564:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002566:	415c                	lw	a5,4(a0)
    80002568:	0047d79b          	srliw	a5,a5,0x4
    8000256c:	00014597          	auipc	a1,0x14
    80002570:	8d45a583          	lw	a1,-1836(a1) # 80015e40 <sb+0x18>
    80002574:	9dbd                	addw	a1,a1,a5
    80002576:	4108                	lw	a0,0(a0)
    80002578:	983ff0ef          	jal	80001efa <bread>
    8000257c:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000257e:	05850793          	addi	a5,a0,88
    80002582:	40d8                	lw	a4,4(s1)
    80002584:	8b3d                	andi	a4,a4,15
    80002586:	071a                	slli	a4,a4,0x6
    80002588:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    8000258a:	04449703          	lh	a4,68(s1)
    8000258e:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002592:	04649703          	lh	a4,70(s1)
    80002596:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    8000259a:	04849703          	lh	a4,72(s1)
    8000259e:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800025a2:	04a49703          	lh	a4,74(s1)
    800025a6:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800025aa:	44f8                	lw	a4,76(s1)
    800025ac:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800025ae:	03400613          	li	a2,52
    800025b2:	05048593          	addi	a1,s1,80
    800025b6:	00c78513          	addi	a0,a5,12
    800025ba:	bf9fd0ef          	jal	800001b2 <memmove>
  log_write(bp);
    800025be:	854a                	mv	a0,s2
    800025c0:	289000ef          	jal	80003048 <log_write>
  brelse(bp);
    800025c4:	854a                	mv	a0,s2
    800025c6:	a3dff0ef          	jal	80002002 <brelse>
}
    800025ca:	60e2                	ld	ra,24(sp)
    800025cc:	6442                	ld	s0,16(sp)
    800025ce:	64a2                	ld	s1,8(sp)
    800025d0:	6902                	ld	s2,0(sp)
    800025d2:	6105                	addi	sp,sp,32
    800025d4:	8082                	ret

00000000800025d6 <idup>:
{
    800025d6:	1101                	addi	sp,sp,-32
    800025d8:	ec06                	sd	ra,24(sp)
    800025da:	e822                	sd	s0,16(sp)
    800025dc:	e426                	sd	s1,8(sp)
    800025de:	1000                	addi	s0,sp,32
    800025e0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800025e2:	00014517          	auipc	a0,0x14
    800025e6:	86650513          	addi	a0,a0,-1946 # 80015e48 <itable>
    800025ea:	13a030ef          	jal	80005724 <acquire>
  ip->ref++;
    800025ee:	449c                	lw	a5,8(s1)
    800025f0:	2785                	addiw	a5,a5,1
    800025f2:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800025f4:	00014517          	auipc	a0,0x14
    800025f8:	85450513          	addi	a0,a0,-1964 # 80015e48 <itable>
    800025fc:	1bc030ef          	jal	800057b8 <release>
}
    80002600:	8526                	mv	a0,s1
    80002602:	60e2                	ld	ra,24(sp)
    80002604:	6442                	ld	s0,16(sp)
    80002606:	64a2                	ld	s1,8(sp)
    80002608:	6105                	addi	sp,sp,32
    8000260a:	8082                	ret

000000008000260c <ilock>:
{
    8000260c:	1101                	addi	sp,sp,-32
    8000260e:	ec06                	sd	ra,24(sp)
    80002610:	e822                	sd	s0,16(sp)
    80002612:	e426                	sd	s1,8(sp)
    80002614:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002616:	cd19                	beqz	a0,80002634 <ilock+0x28>
    80002618:	84aa                	mv	s1,a0
    8000261a:	451c                	lw	a5,8(a0)
    8000261c:	00f05c63          	blez	a5,80002634 <ilock+0x28>
  acquiresleep(&ip->lock);
    80002620:	0541                	addi	a0,a0,16
    80002622:	32d000ef          	jal	8000314e <acquiresleep>
  if(ip->valid == 0){
    80002626:	40bc                	lw	a5,64(s1)
    80002628:	cf89                	beqz	a5,80002642 <ilock+0x36>
}
    8000262a:	60e2                	ld	ra,24(sp)
    8000262c:	6442                	ld	s0,16(sp)
    8000262e:	64a2                	ld	s1,8(sp)
    80002630:	6105                	addi	sp,sp,32
    80002632:	8082                	ret
    80002634:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002636:	00005517          	auipc	a0,0x5
    8000263a:	e6a50513          	addi	a0,a0,-406 # 800074a0 <etext+0x4a0>
    8000263e:	5b9020ef          	jal	800053f6 <panic>
    80002642:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002644:	40dc                	lw	a5,4(s1)
    80002646:	0047d79b          	srliw	a5,a5,0x4
    8000264a:	00013597          	auipc	a1,0x13
    8000264e:	7f65a583          	lw	a1,2038(a1) # 80015e40 <sb+0x18>
    80002652:	9dbd                	addw	a1,a1,a5
    80002654:	4088                	lw	a0,0(s1)
    80002656:	8a5ff0ef          	jal	80001efa <bread>
    8000265a:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000265c:	05850593          	addi	a1,a0,88
    80002660:	40dc                	lw	a5,4(s1)
    80002662:	8bbd                	andi	a5,a5,15
    80002664:	079a                	slli	a5,a5,0x6
    80002666:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002668:	00059783          	lh	a5,0(a1)
    8000266c:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002670:	00259783          	lh	a5,2(a1)
    80002674:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002678:	00459783          	lh	a5,4(a1)
    8000267c:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002680:	00659783          	lh	a5,6(a1)
    80002684:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002688:	459c                	lw	a5,8(a1)
    8000268a:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000268c:	03400613          	li	a2,52
    80002690:	05b1                	addi	a1,a1,12
    80002692:	05048513          	addi	a0,s1,80
    80002696:	b1dfd0ef          	jal	800001b2 <memmove>
    brelse(bp);
    8000269a:	854a                	mv	a0,s2
    8000269c:	967ff0ef          	jal	80002002 <brelse>
    ip->valid = 1;
    800026a0:	4785                	li	a5,1
    800026a2:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800026a4:	04449783          	lh	a5,68(s1)
    800026a8:	c399                	beqz	a5,800026ae <ilock+0xa2>
    800026aa:	6902                	ld	s2,0(sp)
    800026ac:	bfbd                	j	8000262a <ilock+0x1e>
      panic("ilock: no type");
    800026ae:	00005517          	auipc	a0,0x5
    800026b2:	dfa50513          	addi	a0,a0,-518 # 800074a8 <etext+0x4a8>
    800026b6:	541020ef          	jal	800053f6 <panic>

00000000800026ba <iunlock>:
{
    800026ba:	1101                	addi	sp,sp,-32
    800026bc:	ec06                	sd	ra,24(sp)
    800026be:	e822                	sd	s0,16(sp)
    800026c0:	e426                	sd	s1,8(sp)
    800026c2:	e04a                	sd	s2,0(sp)
    800026c4:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800026c6:	c505                	beqz	a0,800026ee <iunlock+0x34>
    800026c8:	84aa                	mv	s1,a0
    800026ca:	01050913          	addi	s2,a0,16
    800026ce:	854a                	mv	a0,s2
    800026d0:	2fd000ef          	jal	800031cc <holdingsleep>
    800026d4:	cd09                	beqz	a0,800026ee <iunlock+0x34>
    800026d6:	449c                	lw	a5,8(s1)
    800026d8:	00f05b63          	blez	a5,800026ee <iunlock+0x34>
  releasesleep(&ip->lock);
    800026dc:	854a                	mv	a0,s2
    800026de:	2b7000ef          	jal	80003194 <releasesleep>
}
    800026e2:	60e2                	ld	ra,24(sp)
    800026e4:	6442                	ld	s0,16(sp)
    800026e6:	64a2                	ld	s1,8(sp)
    800026e8:	6902                	ld	s2,0(sp)
    800026ea:	6105                	addi	sp,sp,32
    800026ec:	8082                	ret
    panic("iunlock");
    800026ee:	00005517          	auipc	a0,0x5
    800026f2:	dca50513          	addi	a0,a0,-566 # 800074b8 <etext+0x4b8>
    800026f6:	501020ef          	jal	800053f6 <panic>

00000000800026fa <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800026fa:	7179                	addi	sp,sp,-48
    800026fc:	f406                	sd	ra,40(sp)
    800026fe:	f022                	sd	s0,32(sp)
    80002700:	ec26                	sd	s1,24(sp)
    80002702:	e84a                	sd	s2,16(sp)
    80002704:	e44e                	sd	s3,8(sp)
    80002706:	1800                	addi	s0,sp,48
    80002708:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000270a:	05050493          	addi	s1,a0,80
    8000270e:	08050913          	addi	s2,a0,128
    80002712:	a021                	j	8000271a <itrunc+0x20>
    80002714:	0491                	addi	s1,s1,4
    80002716:	01248b63          	beq	s1,s2,8000272c <itrunc+0x32>
    if(ip->addrs[i]){
    8000271a:	408c                	lw	a1,0(s1)
    8000271c:	dde5                	beqz	a1,80002714 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    8000271e:	0009a503          	lw	a0,0(s3)
    80002722:	9cdff0ef          	jal	800020ee <bfree>
      ip->addrs[i] = 0;
    80002726:	0004a023          	sw	zero,0(s1)
    8000272a:	b7ed                	j	80002714 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    8000272c:	0809a583          	lw	a1,128(s3)
    80002730:	ed89                	bnez	a1,8000274a <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002732:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002736:	854e                	mv	a0,s3
    80002738:	e21ff0ef          	jal	80002558 <iupdate>
}
    8000273c:	70a2                	ld	ra,40(sp)
    8000273e:	7402                	ld	s0,32(sp)
    80002740:	64e2                	ld	s1,24(sp)
    80002742:	6942                	ld	s2,16(sp)
    80002744:	69a2                	ld	s3,8(sp)
    80002746:	6145                	addi	sp,sp,48
    80002748:	8082                	ret
    8000274a:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000274c:	0009a503          	lw	a0,0(s3)
    80002750:	faaff0ef          	jal	80001efa <bread>
    80002754:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002756:	05850493          	addi	s1,a0,88
    8000275a:	45850913          	addi	s2,a0,1112
    8000275e:	a021                	j	80002766 <itrunc+0x6c>
    80002760:	0491                	addi	s1,s1,4
    80002762:	01248963          	beq	s1,s2,80002774 <itrunc+0x7a>
      if(a[j])
    80002766:	408c                	lw	a1,0(s1)
    80002768:	dde5                	beqz	a1,80002760 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    8000276a:	0009a503          	lw	a0,0(s3)
    8000276e:	981ff0ef          	jal	800020ee <bfree>
    80002772:	b7fd                	j	80002760 <itrunc+0x66>
    brelse(bp);
    80002774:	8552                	mv	a0,s4
    80002776:	88dff0ef          	jal	80002002 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    8000277a:	0809a583          	lw	a1,128(s3)
    8000277e:	0009a503          	lw	a0,0(s3)
    80002782:	96dff0ef          	jal	800020ee <bfree>
    ip->addrs[NDIRECT] = 0;
    80002786:	0809a023          	sw	zero,128(s3)
    8000278a:	6a02                	ld	s4,0(sp)
    8000278c:	b75d                	j	80002732 <itrunc+0x38>

000000008000278e <iput>:
{
    8000278e:	1101                	addi	sp,sp,-32
    80002790:	ec06                	sd	ra,24(sp)
    80002792:	e822                	sd	s0,16(sp)
    80002794:	e426                	sd	s1,8(sp)
    80002796:	1000                	addi	s0,sp,32
    80002798:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000279a:	00013517          	auipc	a0,0x13
    8000279e:	6ae50513          	addi	a0,a0,1710 # 80015e48 <itable>
    800027a2:	783020ef          	jal	80005724 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800027a6:	4498                	lw	a4,8(s1)
    800027a8:	4785                	li	a5,1
    800027aa:	02f70063          	beq	a4,a5,800027ca <iput+0x3c>
  ip->ref--;
    800027ae:	449c                	lw	a5,8(s1)
    800027b0:	37fd                	addiw	a5,a5,-1
    800027b2:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800027b4:	00013517          	auipc	a0,0x13
    800027b8:	69450513          	addi	a0,a0,1684 # 80015e48 <itable>
    800027bc:	7fd020ef          	jal	800057b8 <release>
}
    800027c0:	60e2                	ld	ra,24(sp)
    800027c2:	6442                	ld	s0,16(sp)
    800027c4:	64a2                	ld	s1,8(sp)
    800027c6:	6105                	addi	sp,sp,32
    800027c8:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800027ca:	40bc                	lw	a5,64(s1)
    800027cc:	d3ed                	beqz	a5,800027ae <iput+0x20>
    800027ce:	04a49783          	lh	a5,74(s1)
    800027d2:	fff1                	bnez	a5,800027ae <iput+0x20>
    800027d4:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800027d6:	01048913          	addi	s2,s1,16
    800027da:	854a                	mv	a0,s2
    800027dc:	173000ef          	jal	8000314e <acquiresleep>
    release(&itable.lock);
    800027e0:	00013517          	auipc	a0,0x13
    800027e4:	66850513          	addi	a0,a0,1640 # 80015e48 <itable>
    800027e8:	7d1020ef          	jal	800057b8 <release>
    itrunc(ip);
    800027ec:	8526                	mv	a0,s1
    800027ee:	f0dff0ef          	jal	800026fa <itrunc>
    ip->type = 0;
    800027f2:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800027f6:	8526                	mv	a0,s1
    800027f8:	d61ff0ef          	jal	80002558 <iupdate>
    ip->valid = 0;
    800027fc:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002800:	854a                	mv	a0,s2
    80002802:	193000ef          	jal	80003194 <releasesleep>
    acquire(&itable.lock);
    80002806:	00013517          	auipc	a0,0x13
    8000280a:	64250513          	addi	a0,a0,1602 # 80015e48 <itable>
    8000280e:	717020ef          	jal	80005724 <acquire>
    80002812:	6902                	ld	s2,0(sp)
    80002814:	bf69                	j	800027ae <iput+0x20>

0000000080002816 <iunlockput>:
{
    80002816:	1101                	addi	sp,sp,-32
    80002818:	ec06                	sd	ra,24(sp)
    8000281a:	e822                	sd	s0,16(sp)
    8000281c:	e426                	sd	s1,8(sp)
    8000281e:	1000                	addi	s0,sp,32
    80002820:	84aa                	mv	s1,a0
  iunlock(ip);
    80002822:	e99ff0ef          	jal	800026ba <iunlock>
  iput(ip);
    80002826:	8526                	mv	a0,s1
    80002828:	f67ff0ef          	jal	8000278e <iput>
}
    8000282c:	60e2                	ld	ra,24(sp)
    8000282e:	6442                	ld	s0,16(sp)
    80002830:	64a2                	ld	s1,8(sp)
    80002832:	6105                	addi	sp,sp,32
    80002834:	8082                	ret

0000000080002836 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002836:	1141                	addi	sp,sp,-16
    80002838:	e406                	sd	ra,8(sp)
    8000283a:	e022                	sd	s0,0(sp)
    8000283c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    8000283e:	411c                	lw	a5,0(a0)
    80002840:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002842:	415c                	lw	a5,4(a0)
    80002844:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002846:	04451783          	lh	a5,68(a0)
    8000284a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000284e:	04a51783          	lh	a5,74(a0)
    80002852:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002856:	04c56783          	lwu	a5,76(a0)
    8000285a:	e99c                	sd	a5,16(a1)
}
    8000285c:	60a2                	ld	ra,8(sp)
    8000285e:	6402                	ld	s0,0(sp)
    80002860:	0141                	addi	sp,sp,16
    80002862:	8082                	ret

0000000080002864 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002864:	457c                	lw	a5,76(a0)
    80002866:	0ed7e663          	bltu	a5,a3,80002952 <readi+0xee>
{
    8000286a:	7159                	addi	sp,sp,-112
    8000286c:	f486                	sd	ra,104(sp)
    8000286e:	f0a2                	sd	s0,96(sp)
    80002870:	eca6                	sd	s1,88(sp)
    80002872:	e0d2                	sd	s4,64(sp)
    80002874:	fc56                	sd	s5,56(sp)
    80002876:	f85a                	sd	s6,48(sp)
    80002878:	f45e                	sd	s7,40(sp)
    8000287a:	1880                	addi	s0,sp,112
    8000287c:	8b2a                	mv	s6,a0
    8000287e:	8bae                	mv	s7,a1
    80002880:	8a32                	mv	s4,a2
    80002882:	84b6                	mv	s1,a3
    80002884:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002886:	9f35                	addw	a4,a4,a3
    return 0;
    80002888:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000288a:	0ad76b63          	bltu	a4,a3,80002940 <readi+0xdc>
    8000288e:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002890:	00e7f463          	bgeu	a5,a4,80002898 <readi+0x34>
    n = ip->size - off;
    80002894:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002898:	080a8b63          	beqz	s5,8000292e <readi+0xca>
    8000289c:	e8ca                	sd	s2,80(sp)
    8000289e:	f062                	sd	s8,32(sp)
    800028a0:	ec66                	sd	s9,24(sp)
    800028a2:	e86a                	sd	s10,16(sp)
    800028a4:	e46e                	sd	s11,8(sp)
    800028a6:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800028a8:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800028ac:	5c7d                	li	s8,-1
    800028ae:	a80d                	j	800028e0 <readi+0x7c>
    800028b0:	020d1d93          	slli	s11,s10,0x20
    800028b4:	020ddd93          	srli	s11,s11,0x20
    800028b8:	05890613          	addi	a2,s2,88
    800028bc:	86ee                	mv	a3,s11
    800028be:	963e                	add	a2,a2,a5
    800028c0:	85d2                	mv	a1,s4
    800028c2:	855e                	mv	a0,s7
    800028c4:	dbdfe0ef          	jal	80001680 <either_copyout>
    800028c8:	05850363          	beq	a0,s8,8000290e <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800028cc:	854a                	mv	a0,s2
    800028ce:	f34ff0ef          	jal	80002002 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800028d2:	013d09bb          	addw	s3,s10,s3
    800028d6:	009d04bb          	addw	s1,s10,s1
    800028da:	9a6e                	add	s4,s4,s11
    800028dc:	0559f363          	bgeu	s3,s5,80002922 <readi+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    800028e0:	00a4d59b          	srliw	a1,s1,0xa
    800028e4:	855a                	mv	a0,s6
    800028e6:	987ff0ef          	jal	8000226c <bmap>
    800028ea:	85aa                	mv	a1,a0
    if(addr == 0)
    800028ec:	c139                	beqz	a0,80002932 <readi+0xce>
    bp = bread(ip->dev, addr);
    800028ee:	000b2503          	lw	a0,0(s6)
    800028f2:	e08ff0ef          	jal	80001efa <bread>
    800028f6:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800028f8:	3ff4f793          	andi	a5,s1,1023
    800028fc:	40fc873b          	subw	a4,s9,a5
    80002900:	413a86bb          	subw	a3,s5,s3
    80002904:	8d3a                	mv	s10,a4
    80002906:	fae6f5e3          	bgeu	a3,a4,800028b0 <readi+0x4c>
    8000290a:	8d36                	mv	s10,a3
    8000290c:	b755                	j	800028b0 <readi+0x4c>
      brelse(bp);
    8000290e:	854a                	mv	a0,s2
    80002910:	ef2ff0ef          	jal	80002002 <brelse>
      tot = -1;
    80002914:	59fd                	li	s3,-1
      break;
    80002916:	6946                	ld	s2,80(sp)
    80002918:	7c02                	ld	s8,32(sp)
    8000291a:	6ce2                	ld	s9,24(sp)
    8000291c:	6d42                	ld	s10,16(sp)
    8000291e:	6da2                	ld	s11,8(sp)
    80002920:	a831                	j	8000293c <readi+0xd8>
    80002922:	6946                	ld	s2,80(sp)
    80002924:	7c02                	ld	s8,32(sp)
    80002926:	6ce2                	ld	s9,24(sp)
    80002928:	6d42                	ld	s10,16(sp)
    8000292a:	6da2                	ld	s11,8(sp)
    8000292c:	a801                	j	8000293c <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000292e:	89d6                	mv	s3,s5
    80002930:	a031                	j	8000293c <readi+0xd8>
    80002932:	6946                	ld	s2,80(sp)
    80002934:	7c02                	ld	s8,32(sp)
    80002936:	6ce2                	ld	s9,24(sp)
    80002938:	6d42                	ld	s10,16(sp)
    8000293a:	6da2                	ld	s11,8(sp)
  }
  return tot;
    8000293c:	854e                	mv	a0,s3
    8000293e:	69a6                	ld	s3,72(sp)
}
    80002940:	70a6                	ld	ra,104(sp)
    80002942:	7406                	ld	s0,96(sp)
    80002944:	64e6                	ld	s1,88(sp)
    80002946:	6a06                	ld	s4,64(sp)
    80002948:	7ae2                	ld	s5,56(sp)
    8000294a:	7b42                	ld	s6,48(sp)
    8000294c:	7ba2                	ld	s7,40(sp)
    8000294e:	6165                	addi	sp,sp,112
    80002950:	8082                	ret
    return 0;
    80002952:	4501                	li	a0,0
}
    80002954:	8082                	ret

0000000080002956 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002956:	457c                	lw	a5,76(a0)
    80002958:	0ed7eb63          	bltu	a5,a3,80002a4e <writei+0xf8>
{
    8000295c:	7159                	addi	sp,sp,-112
    8000295e:	f486                	sd	ra,104(sp)
    80002960:	f0a2                	sd	s0,96(sp)
    80002962:	e8ca                	sd	s2,80(sp)
    80002964:	e0d2                	sd	s4,64(sp)
    80002966:	fc56                	sd	s5,56(sp)
    80002968:	f85a                	sd	s6,48(sp)
    8000296a:	f45e                	sd	s7,40(sp)
    8000296c:	1880                	addi	s0,sp,112
    8000296e:	8aaa                	mv	s5,a0
    80002970:	8bae                	mv	s7,a1
    80002972:	8a32                	mv	s4,a2
    80002974:	8936                	mv	s2,a3
    80002976:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002978:	00e687bb          	addw	a5,a3,a4
    8000297c:	0cd7eb63          	bltu	a5,a3,80002a52 <writei+0xfc>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002980:	00043737          	lui	a4,0x43
    80002984:	0cf76963          	bltu	a4,a5,80002a56 <writei+0x100>
    80002988:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000298a:	0a0b0a63          	beqz	s6,80002a3e <writei+0xe8>
    8000298e:	eca6                	sd	s1,88(sp)
    80002990:	f062                	sd	s8,32(sp)
    80002992:	ec66                	sd	s9,24(sp)
    80002994:	e86a                	sd	s10,16(sp)
    80002996:	e46e                	sd	s11,8(sp)
    80002998:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000299a:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000299e:	5c7d                	li	s8,-1
    800029a0:	a825                	j	800029d8 <writei+0x82>
    800029a2:	020d1d93          	slli	s11,s10,0x20
    800029a6:	020ddd93          	srli	s11,s11,0x20
    800029aa:	05848513          	addi	a0,s1,88
    800029ae:	86ee                	mv	a3,s11
    800029b0:	8652                	mv	a2,s4
    800029b2:	85de                	mv	a1,s7
    800029b4:	953e                	add	a0,a0,a5
    800029b6:	d15fe0ef          	jal	800016ca <either_copyin>
    800029ba:	05850663          	beq	a0,s8,80002a06 <writei+0xb0>
      brelse(bp);
      break;
    }
    log_write(bp);
    800029be:	8526                	mv	a0,s1
    800029c0:	688000ef          	jal	80003048 <log_write>
    brelse(bp);
    800029c4:	8526                	mv	a0,s1
    800029c6:	e3cff0ef          	jal	80002002 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800029ca:	013d09bb          	addw	s3,s10,s3
    800029ce:	012d093b          	addw	s2,s10,s2
    800029d2:	9a6e                	add	s4,s4,s11
    800029d4:	0369fc63          	bgeu	s3,s6,80002a0c <writei+0xb6>
    uint addr = bmap(ip, off/BSIZE);
    800029d8:	00a9559b          	srliw	a1,s2,0xa
    800029dc:	8556                	mv	a0,s5
    800029de:	88fff0ef          	jal	8000226c <bmap>
    800029e2:	85aa                	mv	a1,a0
    if(addr == 0)
    800029e4:	c505                	beqz	a0,80002a0c <writei+0xb6>
    bp = bread(ip->dev, addr);
    800029e6:	000aa503          	lw	a0,0(s5)
    800029ea:	d10ff0ef          	jal	80001efa <bread>
    800029ee:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800029f0:	3ff97793          	andi	a5,s2,1023
    800029f4:	40fc873b          	subw	a4,s9,a5
    800029f8:	413b06bb          	subw	a3,s6,s3
    800029fc:	8d3a                	mv	s10,a4
    800029fe:	fae6f2e3          	bgeu	a3,a4,800029a2 <writei+0x4c>
    80002a02:	8d36                	mv	s10,a3
    80002a04:	bf79                	j	800029a2 <writei+0x4c>
      brelse(bp);
    80002a06:	8526                	mv	a0,s1
    80002a08:	dfaff0ef          	jal	80002002 <brelse>
  }

  if(off > ip->size)
    80002a0c:	04caa783          	lw	a5,76(s5)
    80002a10:	0327f963          	bgeu	a5,s2,80002a42 <writei+0xec>
    ip->size = off;
    80002a14:	052aa623          	sw	s2,76(s5)
    80002a18:	64e6                	ld	s1,88(sp)
    80002a1a:	7c02                	ld	s8,32(sp)
    80002a1c:	6ce2                	ld	s9,24(sp)
    80002a1e:	6d42                	ld	s10,16(sp)
    80002a20:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002a22:	8556                	mv	a0,s5
    80002a24:	b35ff0ef          	jal	80002558 <iupdate>

  return tot;
    80002a28:	854e                	mv	a0,s3
    80002a2a:	69a6                	ld	s3,72(sp)
}
    80002a2c:	70a6                	ld	ra,104(sp)
    80002a2e:	7406                	ld	s0,96(sp)
    80002a30:	6946                	ld	s2,80(sp)
    80002a32:	6a06                	ld	s4,64(sp)
    80002a34:	7ae2                	ld	s5,56(sp)
    80002a36:	7b42                	ld	s6,48(sp)
    80002a38:	7ba2                	ld	s7,40(sp)
    80002a3a:	6165                	addi	sp,sp,112
    80002a3c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002a3e:	89da                	mv	s3,s6
    80002a40:	b7cd                	j	80002a22 <writei+0xcc>
    80002a42:	64e6                	ld	s1,88(sp)
    80002a44:	7c02                	ld	s8,32(sp)
    80002a46:	6ce2                	ld	s9,24(sp)
    80002a48:	6d42                	ld	s10,16(sp)
    80002a4a:	6da2                	ld	s11,8(sp)
    80002a4c:	bfd9                	j	80002a22 <writei+0xcc>
    return -1;
    80002a4e:	557d                	li	a0,-1
}
    80002a50:	8082                	ret
    return -1;
    80002a52:	557d                	li	a0,-1
    80002a54:	bfe1                	j	80002a2c <writei+0xd6>
    return -1;
    80002a56:	557d                	li	a0,-1
    80002a58:	bfd1                	j	80002a2c <writei+0xd6>

0000000080002a5a <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002a5a:	1141                	addi	sp,sp,-16
    80002a5c:	e406                	sd	ra,8(sp)
    80002a5e:	e022                	sd	s0,0(sp)
    80002a60:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002a62:	4639                	li	a2,14
    80002a64:	fc2fd0ef          	jal	80000226 <strncmp>
}
    80002a68:	60a2                	ld	ra,8(sp)
    80002a6a:	6402                	ld	s0,0(sp)
    80002a6c:	0141                	addi	sp,sp,16
    80002a6e:	8082                	ret

0000000080002a70 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002a70:	711d                	addi	sp,sp,-96
    80002a72:	ec86                	sd	ra,88(sp)
    80002a74:	e8a2                	sd	s0,80(sp)
    80002a76:	e4a6                	sd	s1,72(sp)
    80002a78:	e0ca                	sd	s2,64(sp)
    80002a7a:	fc4e                	sd	s3,56(sp)
    80002a7c:	f852                	sd	s4,48(sp)
    80002a7e:	f456                	sd	s5,40(sp)
    80002a80:	f05a                	sd	s6,32(sp)
    80002a82:	ec5e                	sd	s7,24(sp)
    80002a84:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002a86:	04451703          	lh	a4,68(a0)
    80002a8a:	4785                	li	a5,1
    80002a8c:	00f71f63          	bne	a4,a5,80002aaa <dirlookup+0x3a>
    80002a90:	892a                	mv	s2,a0
    80002a92:	8aae                	mv	s5,a1
    80002a94:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002a96:	457c                	lw	a5,76(a0)
    80002a98:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002a9a:	fa040a13          	addi	s4,s0,-96
    80002a9e:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80002aa0:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002aa4:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002aa6:	e39d                	bnez	a5,80002acc <dirlookup+0x5c>
    80002aa8:	a8b9                	j	80002b06 <dirlookup+0x96>
    panic("dirlookup not DIR");
    80002aaa:	00005517          	auipc	a0,0x5
    80002aae:	a1650513          	addi	a0,a0,-1514 # 800074c0 <etext+0x4c0>
    80002ab2:	145020ef          	jal	800053f6 <panic>
      panic("dirlookup read");
    80002ab6:	00005517          	auipc	a0,0x5
    80002aba:	a2250513          	addi	a0,a0,-1502 # 800074d8 <etext+0x4d8>
    80002abe:	139020ef          	jal	800053f6 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ac2:	24c1                	addiw	s1,s1,16
    80002ac4:	04c92783          	lw	a5,76(s2)
    80002ac8:	02f4fe63          	bgeu	s1,a5,80002b04 <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002acc:	874e                	mv	a4,s3
    80002ace:	86a6                	mv	a3,s1
    80002ad0:	8652                	mv	a2,s4
    80002ad2:	4581                	li	a1,0
    80002ad4:	854a                	mv	a0,s2
    80002ad6:	d8fff0ef          	jal	80002864 <readi>
    80002ada:	fd351ee3          	bne	a0,s3,80002ab6 <dirlookup+0x46>
    if(de.inum == 0)
    80002ade:	fa045783          	lhu	a5,-96(s0)
    80002ae2:	d3e5                	beqz	a5,80002ac2 <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    80002ae4:	85da                	mv	a1,s6
    80002ae6:	8556                	mv	a0,s5
    80002ae8:	f73ff0ef          	jal	80002a5a <namecmp>
    80002aec:	f979                	bnez	a0,80002ac2 <dirlookup+0x52>
      if(poff)
    80002aee:	000b8463          	beqz	s7,80002af6 <dirlookup+0x86>
        *poff = off;
    80002af2:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80002af6:	fa045583          	lhu	a1,-96(s0)
    80002afa:	00092503          	lw	a0,0(s2)
    80002afe:	82fff0ef          	jal	8000232c <iget>
    80002b02:	a011                	j	80002b06 <dirlookup+0x96>
  return 0;
    80002b04:	4501                	li	a0,0
}
    80002b06:	60e6                	ld	ra,88(sp)
    80002b08:	6446                	ld	s0,80(sp)
    80002b0a:	64a6                	ld	s1,72(sp)
    80002b0c:	6906                	ld	s2,64(sp)
    80002b0e:	79e2                	ld	s3,56(sp)
    80002b10:	7a42                	ld	s4,48(sp)
    80002b12:	7aa2                	ld	s5,40(sp)
    80002b14:	7b02                	ld	s6,32(sp)
    80002b16:	6be2                	ld	s7,24(sp)
    80002b18:	6125                	addi	sp,sp,96
    80002b1a:	8082                	ret

0000000080002b1c <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002b1c:	711d                	addi	sp,sp,-96
    80002b1e:	ec86                	sd	ra,88(sp)
    80002b20:	e8a2                	sd	s0,80(sp)
    80002b22:	e4a6                	sd	s1,72(sp)
    80002b24:	e0ca                	sd	s2,64(sp)
    80002b26:	fc4e                	sd	s3,56(sp)
    80002b28:	f852                	sd	s4,48(sp)
    80002b2a:	f456                	sd	s5,40(sp)
    80002b2c:	f05a                	sd	s6,32(sp)
    80002b2e:	ec5e                	sd	s7,24(sp)
    80002b30:	e862                	sd	s8,16(sp)
    80002b32:	e466                	sd	s9,8(sp)
    80002b34:	e06a                	sd	s10,0(sp)
    80002b36:	1080                	addi	s0,sp,96
    80002b38:	84aa                	mv	s1,a0
    80002b3a:	8b2e                	mv	s6,a1
    80002b3c:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002b3e:	00054703          	lbu	a4,0(a0)
    80002b42:	02f00793          	li	a5,47
    80002b46:	00f70f63          	beq	a4,a5,80002b64 <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002b4a:	a12fe0ef          	jal	80000d5c <myproc>
    80002b4e:	15053503          	ld	a0,336(a0)
    80002b52:	a85ff0ef          	jal	800025d6 <idup>
    80002b56:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002b58:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80002b5c:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80002b5e:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002b60:	4b85                	li	s7,1
    80002b62:	a879                	j	80002c00 <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    80002b64:	4585                	li	a1,1
    80002b66:	852e                	mv	a0,a1
    80002b68:	fc4ff0ef          	jal	8000232c <iget>
    80002b6c:	8a2a                	mv	s4,a0
    80002b6e:	b7ed                	j	80002b58 <namex+0x3c>
      iunlockput(ip);
    80002b70:	8552                	mv	a0,s4
    80002b72:	ca5ff0ef          	jal	80002816 <iunlockput>
      return 0;
    80002b76:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002b78:	8552                	mv	a0,s4
    80002b7a:	60e6                	ld	ra,88(sp)
    80002b7c:	6446                	ld	s0,80(sp)
    80002b7e:	64a6                	ld	s1,72(sp)
    80002b80:	6906                	ld	s2,64(sp)
    80002b82:	79e2                	ld	s3,56(sp)
    80002b84:	7a42                	ld	s4,48(sp)
    80002b86:	7aa2                	ld	s5,40(sp)
    80002b88:	7b02                	ld	s6,32(sp)
    80002b8a:	6be2                	ld	s7,24(sp)
    80002b8c:	6c42                	ld	s8,16(sp)
    80002b8e:	6ca2                	ld	s9,8(sp)
    80002b90:	6d02                	ld	s10,0(sp)
    80002b92:	6125                	addi	sp,sp,96
    80002b94:	8082                	ret
      iunlock(ip);
    80002b96:	8552                	mv	a0,s4
    80002b98:	b23ff0ef          	jal	800026ba <iunlock>
      return ip;
    80002b9c:	bff1                	j	80002b78 <namex+0x5c>
      iunlockput(ip);
    80002b9e:	8552                	mv	a0,s4
    80002ba0:	c77ff0ef          	jal	80002816 <iunlockput>
      return 0;
    80002ba4:	8a4e                	mv	s4,s3
    80002ba6:	bfc9                	j	80002b78 <namex+0x5c>
  len = path - s;
    80002ba8:	40998633          	sub	a2,s3,s1
    80002bac:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80002bb0:	09ac5063          	bge	s8,s10,80002c30 <namex+0x114>
    memmove(name, s, DIRSIZ);
    80002bb4:	8666                	mv	a2,s9
    80002bb6:	85a6                	mv	a1,s1
    80002bb8:	8556                	mv	a0,s5
    80002bba:	df8fd0ef          	jal	800001b2 <memmove>
    80002bbe:	84ce                	mv	s1,s3
  while(*path == '/')
    80002bc0:	0004c783          	lbu	a5,0(s1)
    80002bc4:	01279763          	bne	a5,s2,80002bd2 <namex+0xb6>
    path++;
    80002bc8:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002bca:	0004c783          	lbu	a5,0(s1)
    80002bce:	ff278de3          	beq	a5,s2,80002bc8 <namex+0xac>
    ilock(ip);
    80002bd2:	8552                	mv	a0,s4
    80002bd4:	a39ff0ef          	jal	8000260c <ilock>
    if(ip->type != T_DIR){
    80002bd8:	044a1783          	lh	a5,68(s4)
    80002bdc:	f9779ae3          	bne	a5,s7,80002b70 <namex+0x54>
    if(nameiparent && *path == '\0'){
    80002be0:	000b0563          	beqz	s6,80002bea <namex+0xce>
    80002be4:	0004c783          	lbu	a5,0(s1)
    80002be8:	d7dd                	beqz	a5,80002b96 <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002bea:	4601                	li	a2,0
    80002bec:	85d6                	mv	a1,s5
    80002bee:	8552                	mv	a0,s4
    80002bf0:	e81ff0ef          	jal	80002a70 <dirlookup>
    80002bf4:	89aa                	mv	s3,a0
    80002bf6:	d545                	beqz	a0,80002b9e <namex+0x82>
    iunlockput(ip);
    80002bf8:	8552                	mv	a0,s4
    80002bfa:	c1dff0ef          	jal	80002816 <iunlockput>
    ip = next;
    80002bfe:	8a4e                	mv	s4,s3
  while(*path == '/')
    80002c00:	0004c783          	lbu	a5,0(s1)
    80002c04:	01279763          	bne	a5,s2,80002c12 <namex+0xf6>
    path++;
    80002c08:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002c0a:	0004c783          	lbu	a5,0(s1)
    80002c0e:	ff278de3          	beq	a5,s2,80002c08 <namex+0xec>
  if(*path == 0)
    80002c12:	cb8d                	beqz	a5,80002c44 <namex+0x128>
  while(*path != '/' && *path != 0)
    80002c14:	0004c783          	lbu	a5,0(s1)
    80002c18:	89a6                	mv	s3,s1
  len = path - s;
    80002c1a:	4d01                	li	s10,0
    80002c1c:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80002c1e:	01278963          	beq	a5,s2,80002c30 <namex+0x114>
    80002c22:	d3d9                	beqz	a5,80002ba8 <namex+0x8c>
    path++;
    80002c24:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80002c26:	0009c783          	lbu	a5,0(s3)
    80002c2a:	ff279ce3          	bne	a5,s2,80002c22 <namex+0x106>
    80002c2e:	bfad                	j	80002ba8 <namex+0x8c>
    memmove(name, s, len);
    80002c30:	2601                	sext.w	a2,a2
    80002c32:	85a6                	mv	a1,s1
    80002c34:	8556                	mv	a0,s5
    80002c36:	d7cfd0ef          	jal	800001b2 <memmove>
    name[len] = 0;
    80002c3a:	9d56                	add	s10,s10,s5
    80002c3c:	000d0023          	sb	zero,0(s10)
    80002c40:	84ce                	mv	s1,s3
    80002c42:	bfbd                	j	80002bc0 <namex+0xa4>
  if(nameiparent){
    80002c44:	f20b0ae3          	beqz	s6,80002b78 <namex+0x5c>
    iput(ip);
    80002c48:	8552                	mv	a0,s4
    80002c4a:	b45ff0ef          	jal	8000278e <iput>
    return 0;
    80002c4e:	4a01                	li	s4,0
    80002c50:	b725                	j	80002b78 <namex+0x5c>

0000000080002c52 <dirlink>:
{
    80002c52:	715d                	addi	sp,sp,-80
    80002c54:	e486                	sd	ra,72(sp)
    80002c56:	e0a2                	sd	s0,64(sp)
    80002c58:	f84a                	sd	s2,48(sp)
    80002c5a:	ec56                	sd	s5,24(sp)
    80002c5c:	e85a                	sd	s6,16(sp)
    80002c5e:	0880                	addi	s0,sp,80
    80002c60:	892a                	mv	s2,a0
    80002c62:	8aae                	mv	s5,a1
    80002c64:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002c66:	4601                	li	a2,0
    80002c68:	e09ff0ef          	jal	80002a70 <dirlookup>
    80002c6c:	ed1d                	bnez	a0,80002caa <dirlink+0x58>
    80002c6e:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c70:	04c92483          	lw	s1,76(s2)
    80002c74:	c4b9                	beqz	s1,80002cc2 <dirlink+0x70>
    80002c76:	f44e                	sd	s3,40(sp)
    80002c78:	f052                	sd	s4,32(sp)
    80002c7a:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002c7c:	fb040a13          	addi	s4,s0,-80
    80002c80:	49c1                	li	s3,16
    80002c82:	874e                	mv	a4,s3
    80002c84:	86a6                	mv	a3,s1
    80002c86:	8652                	mv	a2,s4
    80002c88:	4581                	li	a1,0
    80002c8a:	854a                	mv	a0,s2
    80002c8c:	bd9ff0ef          	jal	80002864 <readi>
    80002c90:	03351163          	bne	a0,s3,80002cb2 <dirlink+0x60>
    if(de.inum == 0)
    80002c94:	fb045783          	lhu	a5,-80(s0)
    80002c98:	c39d                	beqz	a5,80002cbe <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c9a:	24c1                	addiw	s1,s1,16
    80002c9c:	04c92783          	lw	a5,76(s2)
    80002ca0:	fef4e1e3          	bltu	s1,a5,80002c82 <dirlink+0x30>
    80002ca4:	79a2                	ld	s3,40(sp)
    80002ca6:	7a02                	ld	s4,32(sp)
    80002ca8:	a829                	j	80002cc2 <dirlink+0x70>
    iput(ip);
    80002caa:	ae5ff0ef          	jal	8000278e <iput>
    return -1;
    80002cae:	557d                	li	a0,-1
    80002cb0:	a83d                	j	80002cee <dirlink+0x9c>
      panic("dirlink read");
    80002cb2:	00005517          	auipc	a0,0x5
    80002cb6:	83650513          	addi	a0,a0,-1994 # 800074e8 <etext+0x4e8>
    80002cba:	73c020ef          	jal	800053f6 <panic>
    80002cbe:	79a2                	ld	s3,40(sp)
    80002cc0:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80002cc2:	4639                	li	a2,14
    80002cc4:	85d6                	mv	a1,s5
    80002cc6:	fb240513          	addi	a0,s0,-78
    80002cca:	d96fd0ef          	jal	80000260 <strncpy>
  de.inum = inum;
    80002cce:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002cd2:	4741                	li	a4,16
    80002cd4:	86a6                	mv	a3,s1
    80002cd6:	fb040613          	addi	a2,s0,-80
    80002cda:	4581                	li	a1,0
    80002cdc:	854a                	mv	a0,s2
    80002cde:	c79ff0ef          	jal	80002956 <writei>
    80002ce2:	1541                	addi	a0,a0,-16
    80002ce4:	00a03533          	snez	a0,a0
    80002ce8:	40a0053b          	negw	a0,a0
    80002cec:	74e2                	ld	s1,56(sp)
}
    80002cee:	60a6                	ld	ra,72(sp)
    80002cf0:	6406                	ld	s0,64(sp)
    80002cf2:	7942                	ld	s2,48(sp)
    80002cf4:	6ae2                	ld	s5,24(sp)
    80002cf6:	6b42                	ld	s6,16(sp)
    80002cf8:	6161                	addi	sp,sp,80
    80002cfa:	8082                	ret

0000000080002cfc <namei>:

struct inode*
namei(char *path)
{
    80002cfc:	1101                	addi	sp,sp,-32
    80002cfe:	ec06                	sd	ra,24(sp)
    80002d00:	e822                	sd	s0,16(sp)
    80002d02:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002d04:	fe040613          	addi	a2,s0,-32
    80002d08:	4581                	li	a1,0
    80002d0a:	e13ff0ef          	jal	80002b1c <namex>
}
    80002d0e:	60e2                	ld	ra,24(sp)
    80002d10:	6442                	ld	s0,16(sp)
    80002d12:	6105                	addi	sp,sp,32
    80002d14:	8082                	ret

0000000080002d16 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002d16:	1141                	addi	sp,sp,-16
    80002d18:	e406                	sd	ra,8(sp)
    80002d1a:	e022                	sd	s0,0(sp)
    80002d1c:	0800                	addi	s0,sp,16
    80002d1e:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002d20:	4585                	li	a1,1
    80002d22:	dfbff0ef          	jal	80002b1c <namex>
}
    80002d26:	60a2                	ld	ra,8(sp)
    80002d28:	6402                	ld	s0,0(sp)
    80002d2a:	0141                	addi	sp,sp,16
    80002d2c:	8082                	ret

0000000080002d2e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002d2e:	1101                	addi	sp,sp,-32
    80002d30:	ec06                	sd	ra,24(sp)
    80002d32:	e822                	sd	s0,16(sp)
    80002d34:	e426                	sd	s1,8(sp)
    80002d36:	e04a                	sd	s2,0(sp)
    80002d38:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002d3a:	00015917          	auipc	s2,0x15
    80002d3e:	bb690913          	addi	s2,s2,-1098 # 800178f0 <log>
    80002d42:	01892583          	lw	a1,24(s2)
    80002d46:	02892503          	lw	a0,40(s2)
    80002d4a:	9b0ff0ef          	jal	80001efa <bread>
    80002d4e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002d50:	02c92603          	lw	a2,44(s2)
    80002d54:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002d56:	00c05f63          	blez	a2,80002d74 <write_head+0x46>
    80002d5a:	00015717          	auipc	a4,0x15
    80002d5e:	bc670713          	addi	a4,a4,-1082 # 80017920 <log+0x30>
    80002d62:	87aa                	mv	a5,a0
    80002d64:	060a                	slli	a2,a2,0x2
    80002d66:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80002d68:	4314                	lw	a3,0(a4)
    80002d6a:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80002d6c:	0711                	addi	a4,a4,4
    80002d6e:	0791                	addi	a5,a5,4
    80002d70:	fec79ce3          	bne	a5,a2,80002d68 <write_head+0x3a>
  }
  bwrite(buf);
    80002d74:	8526                	mv	a0,s1
    80002d76:	a5aff0ef          	jal	80001fd0 <bwrite>
  brelse(buf);
    80002d7a:	8526                	mv	a0,s1
    80002d7c:	a86ff0ef          	jal	80002002 <brelse>
}
    80002d80:	60e2                	ld	ra,24(sp)
    80002d82:	6442                	ld	s0,16(sp)
    80002d84:	64a2                	ld	s1,8(sp)
    80002d86:	6902                	ld	s2,0(sp)
    80002d88:	6105                	addi	sp,sp,32
    80002d8a:	8082                	ret

0000000080002d8c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80002d8c:	00015797          	auipc	a5,0x15
    80002d90:	b907a783          	lw	a5,-1136(a5) # 8001791c <log+0x2c>
    80002d94:	0af05263          	blez	a5,80002e38 <install_trans+0xac>
{
    80002d98:	715d                	addi	sp,sp,-80
    80002d9a:	e486                	sd	ra,72(sp)
    80002d9c:	e0a2                	sd	s0,64(sp)
    80002d9e:	fc26                	sd	s1,56(sp)
    80002da0:	f84a                	sd	s2,48(sp)
    80002da2:	f44e                	sd	s3,40(sp)
    80002da4:	f052                	sd	s4,32(sp)
    80002da6:	ec56                	sd	s5,24(sp)
    80002da8:	e85a                	sd	s6,16(sp)
    80002daa:	e45e                	sd	s7,8(sp)
    80002dac:	0880                	addi	s0,sp,80
    80002dae:	8b2a                	mv	s6,a0
    80002db0:	00015a97          	auipc	s5,0x15
    80002db4:	b70a8a93          	addi	s5,s5,-1168 # 80017920 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002db8:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002dba:	00015997          	auipc	s3,0x15
    80002dbe:	b3698993          	addi	s3,s3,-1226 # 800178f0 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002dc2:	40000b93          	li	s7,1024
    80002dc6:	a829                	j	80002de0 <install_trans+0x54>
    brelse(lbuf);
    80002dc8:	854a                	mv	a0,s2
    80002dca:	a38ff0ef          	jal	80002002 <brelse>
    brelse(dbuf);
    80002dce:	8526                	mv	a0,s1
    80002dd0:	a32ff0ef          	jal	80002002 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002dd4:	2a05                	addiw	s4,s4,1
    80002dd6:	0a91                	addi	s5,s5,4
    80002dd8:	02c9a783          	lw	a5,44(s3)
    80002ddc:	04fa5363          	bge	s4,a5,80002e22 <install_trans+0x96>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002de0:	0189a583          	lw	a1,24(s3)
    80002de4:	014585bb          	addw	a1,a1,s4
    80002de8:	2585                	addiw	a1,a1,1
    80002dea:	0289a503          	lw	a0,40(s3)
    80002dee:	90cff0ef          	jal	80001efa <bread>
    80002df2:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80002df4:	000aa583          	lw	a1,0(s5)
    80002df8:	0289a503          	lw	a0,40(s3)
    80002dfc:	8feff0ef          	jal	80001efa <bread>
    80002e00:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002e02:	865e                	mv	a2,s7
    80002e04:	05890593          	addi	a1,s2,88
    80002e08:	05850513          	addi	a0,a0,88
    80002e0c:	ba6fd0ef          	jal	800001b2 <memmove>
    bwrite(dbuf);  // write dst to disk
    80002e10:	8526                	mv	a0,s1
    80002e12:	9beff0ef          	jal	80001fd0 <bwrite>
    if(recovering == 0)
    80002e16:	fa0b19e3          	bnez	s6,80002dc8 <install_trans+0x3c>
      bunpin(dbuf);
    80002e1a:	8526                	mv	a0,s1
    80002e1c:	a9eff0ef          	jal	800020ba <bunpin>
    80002e20:	b765                	j	80002dc8 <install_trans+0x3c>
}
    80002e22:	60a6                	ld	ra,72(sp)
    80002e24:	6406                	ld	s0,64(sp)
    80002e26:	74e2                	ld	s1,56(sp)
    80002e28:	7942                	ld	s2,48(sp)
    80002e2a:	79a2                	ld	s3,40(sp)
    80002e2c:	7a02                	ld	s4,32(sp)
    80002e2e:	6ae2                	ld	s5,24(sp)
    80002e30:	6b42                	ld	s6,16(sp)
    80002e32:	6ba2                	ld	s7,8(sp)
    80002e34:	6161                	addi	sp,sp,80
    80002e36:	8082                	ret
    80002e38:	8082                	ret

0000000080002e3a <initlog>:
{
    80002e3a:	7179                	addi	sp,sp,-48
    80002e3c:	f406                	sd	ra,40(sp)
    80002e3e:	f022                	sd	s0,32(sp)
    80002e40:	ec26                	sd	s1,24(sp)
    80002e42:	e84a                	sd	s2,16(sp)
    80002e44:	e44e                	sd	s3,8(sp)
    80002e46:	1800                	addi	s0,sp,48
    80002e48:	892a                	mv	s2,a0
    80002e4a:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80002e4c:	00015497          	auipc	s1,0x15
    80002e50:	aa448493          	addi	s1,s1,-1372 # 800178f0 <log>
    80002e54:	00004597          	auipc	a1,0x4
    80002e58:	6a458593          	addi	a1,a1,1700 # 800074f8 <etext+0x4f8>
    80002e5c:	8526                	mv	a0,s1
    80002e5e:	043020ef          	jal	800056a0 <initlock>
  log.start = sb->logstart;
    80002e62:	0149a583          	lw	a1,20(s3)
    80002e66:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80002e68:	0109a783          	lw	a5,16(s3)
    80002e6c:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80002e6e:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80002e72:	854a                	mv	a0,s2
    80002e74:	886ff0ef          	jal	80001efa <bread>
  log.lh.n = lh->n;
    80002e78:	4d30                	lw	a2,88(a0)
    80002e7a:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80002e7c:	00c05f63          	blez	a2,80002e9a <initlog+0x60>
    80002e80:	87aa                	mv	a5,a0
    80002e82:	00015717          	auipc	a4,0x15
    80002e86:	a9e70713          	addi	a4,a4,-1378 # 80017920 <log+0x30>
    80002e8a:	060a                	slli	a2,a2,0x2
    80002e8c:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80002e8e:	4ff4                	lw	a3,92(a5)
    80002e90:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80002e92:	0791                	addi	a5,a5,4
    80002e94:	0711                	addi	a4,a4,4
    80002e96:	fec79ce3          	bne	a5,a2,80002e8e <initlog+0x54>
  brelse(buf);
    80002e9a:	968ff0ef          	jal	80002002 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80002e9e:	4505                	li	a0,1
    80002ea0:	eedff0ef          	jal	80002d8c <install_trans>
  log.lh.n = 0;
    80002ea4:	00015797          	auipc	a5,0x15
    80002ea8:	a607ac23          	sw	zero,-1416(a5) # 8001791c <log+0x2c>
  write_head(); // clear the log
    80002eac:	e83ff0ef          	jal	80002d2e <write_head>
}
    80002eb0:	70a2                	ld	ra,40(sp)
    80002eb2:	7402                	ld	s0,32(sp)
    80002eb4:	64e2                	ld	s1,24(sp)
    80002eb6:	6942                	ld	s2,16(sp)
    80002eb8:	69a2                	ld	s3,8(sp)
    80002eba:	6145                	addi	sp,sp,48
    80002ebc:	8082                	ret

0000000080002ebe <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80002ebe:	1101                	addi	sp,sp,-32
    80002ec0:	ec06                	sd	ra,24(sp)
    80002ec2:	e822                	sd	s0,16(sp)
    80002ec4:	e426                	sd	s1,8(sp)
    80002ec6:	e04a                	sd	s2,0(sp)
    80002ec8:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80002eca:	00015517          	auipc	a0,0x15
    80002ece:	a2650513          	addi	a0,a0,-1498 # 800178f0 <log>
    80002ed2:	053020ef          	jal	80005724 <acquire>
  while(1){
    if(log.committing){
    80002ed6:	00015497          	auipc	s1,0x15
    80002eda:	a1a48493          	addi	s1,s1,-1510 # 800178f0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80002ede:	4979                	li	s2,30
    80002ee0:	a029                	j	80002eea <begin_op+0x2c>
      sleep(&log, &log.lock);
    80002ee2:	85a6                	mv	a1,s1
    80002ee4:	8526                	mv	a0,s1
    80002ee6:	c44fe0ef          	jal	8000132a <sleep>
    if(log.committing){
    80002eea:	50dc                	lw	a5,36(s1)
    80002eec:	fbfd                	bnez	a5,80002ee2 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80002eee:	5098                	lw	a4,32(s1)
    80002ef0:	2705                	addiw	a4,a4,1
    80002ef2:	0027179b          	slliw	a5,a4,0x2
    80002ef6:	9fb9                	addw	a5,a5,a4
    80002ef8:	0017979b          	slliw	a5,a5,0x1
    80002efc:	54d4                	lw	a3,44(s1)
    80002efe:	9fb5                	addw	a5,a5,a3
    80002f00:	00f95763          	bge	s2,a5,80002f0e <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80002f04:	85a6                	mv	a1,s1
    80002f06:	8526                	mv	a0,s1
    80002f08:	c22fe0ef          	jal	8000132a <sleep>
    80002f0c:	bff9                	j	80002eea <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80002f0e:	00015517          	auipc	a0,0x15
    80002f12:	9e250513          	addi	a0,a0,-1566 # 800178f0 <log>
    80002f16:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80002f18:	0a1020ef          	jal	800057b8 <release>
      break;
    }
  }
}
    80002f1c:	60e2                	ld	ra,24(sp)
    80002f1e:	6442                	ld	s0,16(sp)
    80002f20:	64a2                	ld	s1,8(sp)
    80002f22:	6902                	ld	s2,0(sp)
    80002f24:	6105                	addi	sp,sp,32
    80002f26:	8082                	ret

0000000080002f28 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80002f28:	7139                	addi	sp,sp,-64
    80002f2a:	fc06                	sd	ra,56(sp)
    80002f2c:	f822                	sd	s0,48(sp)
    80002f2e:	f426                	sd	s1,40(sp)
    80002f30:	f04a                	sd	s2,32(sp)
    80002f32:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80002f34:	00015497          	auipc	s1,0x15
    80002f38:	9bc48493          	addi	s1,s1,-1604 # 800178f0 <log>
    80002f3c:	8526                	mv	a0,s1
    80002f3e:	7e6020ef          	jal	80005724 <acquire>
  log.outstanding -= 1;
    80002f42:	509c                	lw	a5,32(s1)
    80002f44:	37fd                	addiw	a5,a5,-1
    80002f46:	893e                	mv	s2,a5
    80002f48:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80002f4a:	50dc                	lw	a5,36(s1)
    80002f4c:	ef9d                	bnez	a5,80002f8a <end_op+0x62>
    panic("log.committing");
  if(log.outstanding == 0){
    80002f4e:	04091863          	bnez	s2,80002f9e <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80002f52:	00015497          	auipc	s1,0x15
    80002f56:	99e48493          	addi	s1,s1,-1634 # 800178f0 <log>
    80002f5a:	4785                	li	a5,1
    80002f5c:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80002f5e:	8526                	mv	a0,s1
    80002f60:	059020ef          	jal	800057b8 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80002f64:	54dc                	lw	a5,44(s1)
    80002f66:	04f04c63          	bgtz	a5,80002fbe <end_op+0x96>
    acquire(&log.lock);
    80002f6a:	00015497          	auipc	s1,0x15
    80002f6e:	98648493          	addi	s1,s1,-1658 # 800178f0 <log>
    80002f72:	8526                	mv	a0,s1
    80002f74:	7b0020ef          	jal	80005724 <acquire>
    log.committing = 0;
    80002f78:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80002f7c:	8526                	mv	a0,s1
    80002f7e:	bf8fe0ef          	jal	80001376 <wakeup>
    release(&log.lock);
    80002f82:	8526                	mv	a0,s1
    80002f84:	035020ef          	jal	800057b8 <release>
}
    80002f88:	a02d                	j	80002fb2 <end_op+0x8a>
    80002f8a:	ec4e                	sd	s3,24(sp)
    80002f8c:	e852                	sd	s4,16(sp)
    80002f8e:	e456                	sd	s5,8(sp)
    80002f90:	e05a                	sd	s6,0(sp)
    panic("log.committing");
    80002f92:	00004517          	auipc	a0,0x4
    80002f96:	56e50513          	addi	a0,a0,1390 # 80007500 <etext+0x500>
    80002f9a:	45c020ef          	jal	800053f6 <panic>
    wakeup(&log);
    80002f9e:	00015497          	auipc	s1,0x15
    80002fa2:	95248493          	addi	s1,s1,-1710 # 800178f0 <log>
    80002fa6:	8526                	mv	a0,s1
    80002fa8:	bcefe0ef          	jal	80001376 <wakeup>
  release(&log.lock);
    80002fac:	8526                	mv	a0,s1
    80002fae:	00b020ef          	jal	800057b8 <release>
}
    80002fb2:	70e2                	ld	ra,56(sp)
    80002fb4:	7442                	ld	s0,48(sp)
    80002fb6:	74a2                	ld	s1,40(sp)
    80002fb8:	7902                	ld	s2,32(sp)
    80002fba:	6121                	addi	sp,sp,64
    80002fbc:	8082                	ret
    80002fbe:	ec4e                	sd	s3,24(sp)
    80002fc0:	e852                	sd	s4,16(sp)
    80002fc2:	e456                	sd	s5,8(sp)
    80002fc4:	e05a                	sd	s6,0(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80002fc6:	00015a97          	auipc	s5,0x15
    80002fca:	95aa8a93          	addi	s5,s5,-1702 # 80017920 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80002fce:	00015a17          	auipc	s4,0x15
    80002fd2:	922a0a13          	addi	s4,s4,-1758 # 800178f0 <log>
    memmove(to->data, from->data, BSIZE);
    80002fd6:	40000b13          	li	s6,1024
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80002fda:	018a2583          	lw	a1,24(s4)
    80002fde:	012585bb          	addw	a1,a1,s2
    80002fe2:	2585                	addiw	a1,a1,1
    80002fe4:	028a2503          	lw	a0,40(s4)
    80002fe8:	f13fe0ef          	jal	80001efa <bread>
    80002fec:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80002fee:	000aa583          	lw	a1,0(s5)
    80002ff2:	028a2503          	lw	a0,40(s4)
    80002ff6:	f05fe0ef          	jal	80001efa <bread>
    80002ffa:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80002ffc:	865a                	mv	a2,s6
    80002ffe:	05850593          	addi	a1,a0,88
    80003002:	05848513          	addi	a0,s1,88
    80003006:	9acfd0ef          	jal	800001b2 <memmove>
    bwrite(to);  // write the log
    8000300a:	8526                	mv	a0,s1
    8000300c:	fc5fe0ef          	jal	80001fd0 <bwrite>
    brelse(from);
    80003010:	854e                	mv	a0,s3
    80003012:	ff1fe0ef          	jal	80002002 <brelse>
    brelse(to);
    80003016:	8526                	mv	a0,s1
    80003018:	febfe0ef          	jal	80002002 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000301c:	2905                	addiw	s2,s2,1
    8000301e:	0a91                	addi	s5,s5,4
    80003020:	02ca2783          	lw	a5,44(s4)
    80003024:	faf94be3          	blt	s2,a5,80002fda <end_op+0xb2>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003028:	d07ff0ef          	jal	80002d2e <write_head>
    install_trans(0); // Now install writes to home locations
    8000302c:	4501                	li	a0,0
    8000302e:	d5fff0ef          	jal	80002d8c <install_trans>
    log.lh.n = 0;
    80003032:	00015797          	auipc	a5,0x15
    80003036:	8e07a523          	sw	zero,-1814(a5) # 8001791c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000303a:	cf5ff0ef          	jal	80002d2e <write_head>
    8000303e:	69e2                	ld	s3,24(sp)
    80003040:	6a42                	ld	s4,16(sp)
    80003042:	6aa2                	ld	s5,8(sp)
    80003044:	6b02                	ld	s6,0(sp)
    80003046:	b715                	j	80002f6a <end_op+0x42>

0000000080003048 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003048:	1101                	addi	sp,sp,-32
    8000304a:	ec06                	sd	ra,24(sp)
    8000304c:	e822                	sd	s0,16(sp)
    8000304e:	e426                	sd	s1,8(sp)
    80003050:	e04a                	sd	s2,0(sp)
    80003052:	1000                	addi	s0,sp,32
    80003054:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003056:	00015917          	auipc	s2,0x15
    8000305a:	89a90913          	addi	s2,s2,-1894 # 800178f0 <log>
    8000305e:	854a                	mv	a0,s2
    80003060:	6c4020ef          	jal	80005724 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003064:	02c92603          	lw	a2,44(s2)
    80003068:	47f5                	li	a5,29
    8000306a:	06c7c363          	blt	a5,a2,800030d0 <log_write+0x88>
    8000306e:	00015797          	auipc	a5,0x15
    80003072:	89e7a783          	lw	a5,-1890(a5) # 8001790c <log+0x1c>
    80003076:	37fd                	addiw	a5,a5,-1
    80003078:	04f65c63          	bge	a2,a5,800030d0 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000307c:	00015797          	auipc	a5,0x15
    80003080:	8947a783          	lw	a5,-1900(a5) # 80017910 <log+0x20>
    80003084:	04f05c63          	blez	a5,800030dc <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003088:	4781                	li	a5,0
    8000308a:	04c05f63          	blez	a2,800030e8 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000308e:	44cc                	lw	a1,12(s1)
    80003090:	00015717          	auipc	a4,0x15
    80003094:	89070713          	addi	a4,a4,-1904 # 80017920 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003098:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000309a:	4314                	lw	a3,0(a4)
    8000309c:	04b68663          	beq	a3,a1,800030e8 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    800030a0:	2785                	addiw	a5,a5,1
    800030a2:	0711                	addi	a4,a4,4
    800030a4:	fef61be3          	bne	a2,a5,8000309a <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    800030a8:	0621                	addi	a2,a2,8
    800030aa:	060a                	slli	a2,a2,0x2
    800030ac:	00015797          	auipc	a5,0x15
    800030b0:	84478793          	addi	a5,a5,-1980 # 800178f0 <log>
    800030b4:	97b2                	add	a5,a5,a2
    800030b6:	44d8                	lw	a4,12(s1)
    800030b8:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800030ba:	8526                	mv	a0,s1
    800030bc:	fcbfe0ef          	jal	80002086 <bpin>
    log.lh.n++;
    800030c0:	00015717          	auipc	a4,0x15
    800030c4:	83070713          	addi	a4,a4,-2000 # 800178f0 <log>
    800030c8:	575c                	lw	a5,44(a4)
    800030ca:	2785                	addiw	a5,a5,1
    800030cc:	d75c                	sw	a5,44(a4)
    800030ce:	a80d                	j	80003100 <log_write+0xb8>
    panic("too big a transaction");
    800030d0:	00004517          	auipc	a0,0x4
    800030d4:	44050513          	addi	a0,a0,1088 # 80007510 <etext+0x510>
    800030d8:	31e020ef          	jal	800053f6 <panic>
    panic("log_write outside of trans");
    800030dc:	00004517          	auipc	a0,0x4
    800030e0:	44c50513          	addi	a0,a0,1100 # 80007528 <etext+0x528>
    800030e4:	312020ef          	jal	800053f6 <panic>
  log.lh.block[i] = b->blockno;
    800030e8:	00878693          	addi	a3,a5,8
    800030ec:	068a                	slli	a3,a3,0x2
    800030ee:	00015717          	auipc	a4,0x15
    800030f2:	80270713          	addi	a4,a4,-2046 # 800178f0 <log>
    800030f6:	9736                	add	a4,a4,a3
    800030f8:	44d4                	lw	a3,12(s1)
    800030fa:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800030fc:	faf60fe3          	beq	a2,a5,800030ba <log_write+0x72>
  }
  release(&log.lock);
    80003100:	00014517          	auipc	a0,0x14
    80003104:	7f050513          	addi	a0,a0,2032 # 800178f0 <log>
    80003108:	6b0020ef          	jal	800057b8 <release>
}
    8000310c:	60e2                	ld	ra,24(sp)
    8000310e:	6442                	ld	s0,16(sp)
    80003110:	64a2                	ld	s1,8(sp)
    80003112:	6902                	ld	s2,0(sp)
    80003114:	6105                	addi	sp,sp,32
    80003116:	8082                	ret

0000000080003118 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003118:	1101                	addi	sp,sp,-32
    8000311a:	ec06                	sd	ra,24(sp)
    8000311c:	e822                	sd	s0,16(sp)
    8000311e:	e426                	sd	s1,8(sp)
    80003120:	e04a                	sd	s2,0(sp)
    80003122:	1000                	addi	s0,sp,32
    80003124:	84aa                	mv	s1,a0
    80003126:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003128:	00004597          	auipc	a1,0x4
    8000312c:	42058593          	addi	a1,a1,1056 # 80007548 <etext+0x548>
    80003130:	0521                	addi	a0,a0,8
    80003132:	56e020ef          	jal	800056a0 <initlock>
  lk->name = name;
    80003136:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000313a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000313e:	0204a423          	sw	zero,40(s1)
}
    80003142:	60e2                	ld	ra,24(sp)
    80003144:	6442                	ld	s0,16(sp)
    80003146:	64a2                	ld	s1,8(sp)
    80003148:	6902                	ld	s2,0(sp)
    8000314a:	6105                	addi	sp,sp,32
    8000314c:	8082                	ret

000000008000314e <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000314e:	1101                	addi	sp,sp,-32
    80003150:	ec06                	sd	ra,24(sp)
    80003152:	e822                	sd	s0,16(sp)
    80003154:	e426                	sd	s1,8(sp)
    80003156:	e04a                	sd	s2,0(sp)
    80003158:	1000                	addi	s0,sp,32
    8000315a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000315c:	00850913          	addi	s2,a0,8
    80003160:	854a                	mv	a0,s2
    80003162:	5c2020ef          	jal	80005724 <acquire>
  while (lk->locked) {
    80003166:	409c                	lw	a5,0(s1)
    80003168:	c799                	beqz	a5,80003176 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    8000316a:	85ca                	mv	a1,s2
    8000316c:	8526                	mv	a0,s1
    8000316e:	9bcfe0ef          	jal	8000132a <sleep>
  while (lk->locked) {
    80003172:	409c                	lw	a5,0(s1)
    80003174:	fbfd                	bnez	a5,8000316a <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003176:	4785                	li	a5,1
    80003178:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000317a:	be3fd0ef          	jal	80000d5c <myproc>
    8000317e:	591c                	lw	a5,48(a0)
    80003180:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003182:	854a                	mv	a0,s2
    80003184:	634020ef          	jal	800057b8 <release>
}
    80003188:	60e2                	ld	ra,24(sp)
    8000318a:	6442                	ld	s0,16(sp)
    8000318c:	64a2                	ld	s1,8(sp)
    8000318e:	6902                	ld	s2,0(sp)
    80003190:	6105                	addi	sp,sp,32
    80003192:	8082                	ret

0000000080003194 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003194:	1101                	addi	sp,sp,-32
    80003196:	ec06                	sd	ra,24(sp)
    80003198:	e822                	sd	s0,16(sp)
    8000319a:	e426                	sd	s1,8(sp)
    8000319c:	e04a                	sd	s2,0(sp)
    8000319e:	1000                	addi	s0,sp,32
    800031a0:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800031a2:	00850913          	addi	s2,a0,8
    800031a6:	854a                	mv	a0,s2
    800031a8:	57c020ef          	jal	80005724 <acquire>
  lk->locked = 0;
    800031ac:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800031b0:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800031b4:	8526                	mv	a0,s1
    800031b6:	9c0fe0ef          	jal	80001376 <wakeup>
  release(&lk->lk);
    800031ba:	854a                	mv	a0,s2
    800031bc:	5fc020ef          	jal	800057b8 <release>
}
    800031c0:	60e2                	ld	ra,24(sp)
    800031c2:	6442                	ld	s0,16(sp)
    800031c4:	64a2                	ld	s1,8(sp)
    800031c6:	6902                	ld	s2,0(sp)
    800031c8:	6105                	addi	sp,sp,32
    800031ca:	8082                	ret

00000000800031cc <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800031cc:	7179                	addi	sp,sp,-48
    800031ce:	f406                	sd	ra,40(sp)
    800031d0:	f022                	sd	s0,32(sp)
    800031d2:	ec26                	sd	s1,24(sp)
    800031d4:	e84a                	sd	s2,16(sp)
    800031d6:	1800                	addi	s0,sp,48
    800031d8:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800031da:	00850913          	addi	s2,a0,8
    800031de:	854a                	mv	a0,s2
    800031e0:	544020ef          	jal	80005724 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800031e4:	409c                	lw	a5,0(s1)
    800031e6:	ef81                	bnez	a5,800031fe <holdingsleep+0x32>
    800031e8:	4481                	li	s1,0
  release(&lk->lk);
    800031ea:	854a                	mv	a0,s2
    800031ec:	5cc020ef          	jal	800057b8 <release>
  return r;
}
    800031f0:	8526                	mv	a0,s1
    800031f2:	70a2                	ld	ra,40(sp)
    800031f4:	7402                	ld	s0,32(sp)
    800031f6:	64e2                	ld	s1,24(sp)
    800031f8:	6942                	ld	s2,16(sp)
    800031fa:	6145                	addi	sp,sp,48
    800031fc:	8082                	ret
    800031fe:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003200:	0284a983          	lw	s3,40(s1)
    80003204:	b59fd0ef          	jal	80000d5c <myproc>
    80003208:	5904                	lw	s1,48(a0)
    8000320a:	413484b3          	sub	s1,s1,s3
    8000320e:	0014b493          	seqz	s1,s1
    80003212:	69a2                	ld	s3,8(sp)
    80003214:	bfd9                	j	800031ea <holdingsleep+0x1e>

0000000080003216 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003216:	1141                	addi	sp,sp,-16
    80003218:	e406                	sd	ra,8(sp)
    8000321a:	e022                	sd	s0,0(sp)
    8000321c:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000321e:	00004597          	auipc	a1,0x4
    80003222:	33a58593          	addi	a1,a1,826 # 80007558 <etext+0x558>
    80003226:	00015517          	auipc	a0,0x15
    8000322a:	81250513          	addi	a0,a0,-2030 # 80017a38 <ftable>
    8000322e:	472020ef          	jal	800056a0 <initlock>
}
    80003232:	60a2                	ld	ra,8(sp)
    80003234:	6402                	ld	s0,0(sp)
    80003236:	0141                	addi	sp,sp,16
    80003238:	8082                	ret

000000008000323a <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000323a:	1101                	addi	sp,sp,-32
    8000323c:	ec06                	sd	ra,24(sp)
    8000323e:	e822                	sd	s0,16(sp)
    80003240:	e426                	sd	s1,8(sp)
    80003242:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003244:	00014517          	auipc	a0,0x14
    80003248:	7f450513          	addi	a0,a0,2036 # 80017a38 <ftable>
    8000324c:	4d8020ef          	jal	80005724 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003250:	00015497          	auipc	s1,0x15
    80003254:	80048493          	addi	s1,s1,-2048 # 80017a50 <ftable+0x18>
    80003258:	00015717          	auipc	a4,0x15
    8000325c:	79870713          	addi	a4,a4,1944 # 800189f0 <disk>
    if(f->ref == 0){
    80003260:	40dc                	lw	a5,4(s1)
    80003262:	cf89                	beqz	a5,8000327c <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003264:	02848493          	addi	s1,s1,40
    80003268:	fee49ce3          	bne	s1,a4,80003260 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000326c:	00014517          	auipc	a0,0x14
    80003270:	7cc50513          	addi	a0,a0,1996 # 80017a38 <ftable>
    80003274:	544020ef          	jal	800057b8 <release>
  return 0;
    80003278:	4481                	li	s1,0
    8000327a:	a809                	j	8000328c <filealloc+0x52>
      f->ref = 1;
    8000327c:	4785                	li	a5,1
    8000327e:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003280:	00014517          	auipc	a0,0x14
    80003284:	7b850513          	addi	a0,a0,1976 # 80017a38 <ftable>
    80003288:	530020ef          	jal	800057b8 <release>
}
    8000328c:	8526                	mv	a0,s1
    8000328e:	60e2                	ld	ra,24(sp)
    80003290:	6442                	ld	s0,16(sp)
    80003292:	64a2                	ld	s1,8(sp)
    80003294:	6105                	addi	sp,sp,32
    80003296:	8082                	ret

0000000080003298 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003298:	1101                	addi	sp,sp,-32
    8000329a:	ec06                	sd	ra,24(sp)
    8000329c:	e822                	sd	s0,16(sp)
    8000329e:	e426                	sd	s1,8(sp)
    800032a0:	1000                	addi	s0,sp,32
    800032a2:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800032a4:	00014517          	auipc	a0,0x14
    800032a8:	79450513          	addi	a0,a0,1940 # 80017a38 <ftable>
    800032ac:	478020ef          	jal	80005724 <acquire>
  if(f->ref < 1)
    800032b0:	40dc                	lw	a5,4(s1)
    800032b2:	02f05063          	blez	a5,800032d2 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800032b6:	2785                	addiw	a5,a5,1
    800032b8:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800032ba:	00014517          	auipc	a0,0x14
    800032be:	77e50513          	addi	a0,a0,1918 # 80017a38 <ftable>
    800032c2:	4f6020ef          	jal	800057b8 <release>
  return f;
}
    800032c6:	8526                	mv	a0,s1
    800032c8:	60e2                	ld	ra,24(sp)
    800032ca:	6442                	ld	s0,16(sp)
    800032cc:	64a2                	ld	s1,8(sp)
    800032ce:	6105                	addi	sp,sp,32
    800032d0:	8082                	ret
    panic("filedup");
    800032d2:	00004517          	auipc	a0,0x4
    800032d6:	28e50513          	addi	a0,a0,654 # 80007560 <etext+0x560>
    800032da:	11c020ef          	jal	800053f6 <panic>

00000000800032de <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800032de:	7139                	addi	sp,sp,-64
    800032e0:	fc06                	sd	ra,56(sp)
    800032e2:	f822                	sd	s0,48(sp)
    800032e4:	f426                	sd	s1,40(sp)
    800032e6:	0080                	addi	s0,sp,64
    800032e8:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800032ea:	00014517          	auipc	a0,0x14
    800032ee:	74e50513          	addi	a0,a0,1870 # 80017a38 <ftable>
    800032f2:	432020ef          	jal	80005724 <acquire>
  if(f->ref < 1)
    800032f6:	40dc                	lw	a5,4(s1)
    800032f8:	04f05863          	blez	a5,80003348 <fileclose+0x6a>
    panic("fileclose");
  if(--f->ref > 0){
    800032fc:	37fd                	addiw	a5,a5,-1
    800032fe:	c0dc                	sw	a5,4(s1)
    80003300:	04f04e63          	bgtz	a5,8000335c <fileclose+0x7e>
    80003304:	f04a                	sd	s2,32(sp)
    80003306:	ec4e                	sd	s3,24(sp)
    80003308:	e852                	sd	s4,16(sp)
    8000330a:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    8000330c:	0004a903          	lw	s2,0(s1)
    80003310:	0094ca83          	lbu	s5,9(s1)
    80003314:	0104ba03          	ld	s4,16(s1)
    80003318:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    8000331c:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003320:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003324:	00014517          	auipc	a0,0x14
    80003328:	71450513          	addi	a0,a0,1812 # 80017a38 <ftable>
    8000332c:	48c020ef          	jal	800057b8 <release>

  if(ff.type == FD_PIPE){
    80003330:	4785                	li	a5,1
    80003332:	04f90063          	beq	s2,a5,80003372 <fileclose+0x94>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003336:	3979                	addiw	s2,s2,-2
    80003338:	4785                	li	a5,1
    8000333a:	0527f563          	bgeu	a5,s2,80003384 <fileclose+0xa6>
    8000333e:	7902                	ld	s2,32(sp)
    80003340:	69e2                	ld	s3,24(sp)
    80003342:	6a42                	ld	s4,16(sp)
    80003344:	6aa2                	ld	s5,8(sp)
    80003346:	a00d                	j	80003368 <fileclose+0x8a>
    80003348:	f04a                	sd	s2,32(sp)
    8000334a:	ec4e                	sd	s3,24(sp)
    8000334c:	e852                	sd	s4,16(sp)
    8000334e:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003350:	00004517          	auipc	a0,0x4
    80003354:	21850513          	addi	a0,a0,536 # 80007568 <etext+0x568>
    80003358:	09e020ef          	jal	800053f6 <panic>
    release(&ftable.lock);
    8000335c:	00014517          	auipc	a0,0x14
    80003360:	6dc50513          	addi	a0,a0,1756 # 80017a38 <ftable>
    80003364:	454020ef          	jal	800057b8 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003368:	70e2                	ld	ra,56(sp)
    8000336a:	7442                	ld	s0,48(sp)
    8000336c:	74a2                	ld	s1,40(sp)
    8000336e:	6121                	addi	sp,sp,64
    80003370:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003372:	85d6                	mv	a1,s5
    80003374:	8552                	mv	a0,s4
    80003376:	340000ef          	jal	800036b6 <pipeclose>
    8000337a:	7902                	ld	s2,32(sp)
    8000337c:	69e2                	ld	s3,24(sp)
    8000337e:	6a42                	ld	s4,16(sp)
    80003380:	6aa2                	ld	s5,8(sp)
    80003382:	b7dd                	j	80003368 <fileclose+0x8a>
    begin_op();
    80003384:	b3bff0ef          	jal	80002ebe <begin_op>
    iput(ff.ip);
    80003388:	854e                	mv	a0,s3
    8000338a:	c04ff0ef          	jal	8000278e <iput>
    end_op();
    8000338e:	b9bff0ef          	jal	80002f28 <end_op>
    80003392:	7902                	ld	s2,32(sp)
    80003394:	69e2                	ld	s3,24(sp)
    80003396:	6a42                	ld	s4,16(sp)
    80003398:	6aa2                	ld	s5,8(sp)
    8000339a:	b7f9                	j	80003368 <fileclose+0x8a>

000000008000339c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000339c:	715d                	addi	sp,sp,-80
    8000339e:	e486                	sd	ra,72(sp)
    800033a0:	e0a2                	sd	s0,64(sp)
    800033a2:	fc26                	sd	s1,56(sp)
    800033a4:	f44e                	sd	s3,40(sp)
    800033a6:	0880                	addi	s0,sp,80
    800033a8:	84aa                	mv	s1,a0
    800033aa:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800033ac:	9b1fd0ef          	jal	80000d5c <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800033b0:	409c                	lw	a5,0(s1)
    800033b2:	37f9                	addiw	a5,a5,-2
    800033b4:	4705                	li	a4,1
    800033b6:	04f76263          	bltu	a4,a5,800033fa <filestat+0x5e>
    800033ba:	f84a                	sd	s2,48(sp)
    800033bc:	f052                	sd	s4,32(sp)
    800033be:	892a                	mv	s2,a0
    ilock(f->ip);
    800033c0:	6c88                	ld	a0,24(s1)
    800033c2:	a4aff0ef          	jal	8000260c <ilock>
    stati(f->ip, &st);
    800033c6:	fb840a13          	addi	s4,s0,-72
    800033ca:	85d2                	mv	a1,s4
    800033cc:	6c88                	ld	a0,24(s1)
    800033ce:	c68ff0ef          	jal	80002836 <stati>
    iunlock(f->ip);
    800033d2:	6c88                	ld	a0,24(s1)
    800033d4:	ae6ff0ef          	jal	800026ba <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800033d8:	46e1                	li	a3,24
    800033da:	8652                	mv	a2,s4
    800033dc:	85ce                	mv	a1,s3
    800033de:	05093503          	ld	a0,80(s2)
    800033e2:	e22fd0ef          	jal	80000a04 <copyout>
    800033e6:	41f5551b          	sraiw	a0,a0,0x1f
    800033ea:	7942                	ld	s2,48(sp)
    800033ec:	7a02                	ld	s4,32(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800033ee:	60a6                	ld	ra,72(sp)
    800033f0:	6406                	ld	s0,64(sp)
    800033f2:	74e2                	ld	s1,56(sp)
    800033f4:	79a2                	ld	s3,40(sp)
    800033f6:	6161                	addi	sp,sp,80
    800033f8:	8082                	ret
  return -1;
    800033fa:	557d                	li	a0,-1
    800033fc:	bfcd                	j	800033ee <filestat+0x52>

00000000800033fe <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800033fe:	7179                	addi	sp,sp,-48
    80003400:	f406                	sd	ra,40(sp)
    80003402:	f022                	sd	s0,32(sp)
    80003404:	e84a                	sd	s2,16(sp)
    80003406:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003408:	00854783          	lbu	a5,8(a0)
    8000340c:	cfd1                	beqz	a5,800034a8 <fileread+0xaa>
    8000340e:	ec26                	sd	s1,24(sp)
    80003410:	e44e                	sd	s3,8(sp)
    80003412:	84aa                	mv	s1,a0
    80003414:	89ae                	mv	s3,a1
    80003416:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003418:	411c                	lw	a5,0(a0)
    8000341a:	4705                	li	a4,1
    8000341c:	04e78363          	beq	a5,a4,80003462 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003420:	470d                	li	a4,3
    80003422:	04e78763          	beq	a5,a4,80003470 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003426:	4709                	li	a4,2
    80003428:	06e79a63          	bne	a5,a4,8000349c <fileread+0x9e>
    ilock(f->ip);
    8000342c:	6d08                	ld	a0,24(a0)
    8000342e:	9deff0ef          	jal	8000260c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003432:	874a                	mv	a4,s2
    80003434:	5094                	lw	a3,32(s1)
    80003436:	864e                	mv	a2,s3
    80003438:	4585                	li	a1,1
    8000343a:	6c88                	ld	a0,24(s1)
    8000343c:	c28ff0ef          	jal	80002864 <readi>
    80003440:	892a                	mv	s2,a0
    80003442:	00a05563          	blez	a0,8000344c <fileread+0x4e>
      f->off += r;
    80003446:	509c                	lw	a5,32(s1)
    80003448:	9fa9                	addw	a5,a5,a0
    8000344a:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000344c:	6c88                	ld	a0,24(s1)
    8000344e:	a6cff0ef          	jal	800026ba <iunlock>
    80003452:	64e2                	ld	s1,24(sp)
    80003454:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003456:	854a                	mv	a0,s2
    80003458:	70a2                	ld	ra,40(sp)
    8000345a:	7402                	ld	s0,32(sp)
    8000345c:	6942                	ld	s2,16(sp)
    8000345e:	6145                	addi	sp,sp,48
    80003460:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003462:	6908                	ld	a0,16(a0)
    80003464:	3a2000ef          	jal	80003806 <piperead>
    80003468:	892a                	mv	s2,a0
    8000346a:	64e2                	ld	s1,24(sp)
    8000346c:	69a2                	ld	s3,8(sp)
    8000346e:	b7e5                	j	80003456 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003470:	02451783          	lh	a5,36(a0)
    80003474:	03079693          	slli	a3,a5,0x30
    80003478:	92c1                	srli	a3,a3,0x30
    8000347a:	4725                	li	a4,9
    8000347c:	02d76863          	bltu	a4,a3,800034ac <fileread+0xae>
    80003480:	0792                	slli	a5,a5,0x4
    80003482:	00014717          	auipc	a4,0x14
    80003486:	51670713          	addi	a4,a4,1302 # 80017998 <devsw>
    8000348a:	97ba                	add	a5,a5,a4
    8000348c:	639c                	ld	a5,0(a5)
    8000348e:	c39d                	beqz	a5,800034b4 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    80003490:	4505                	li	a0,1
    80003492:	9782                	jalr	a5
    80003494:	892a                	mv	s2,a0
    80003496:	64e2                	ld	s1,24(sp)
    80003498:	69a2                	ld	s3,8(sp)
    8000349a:	bf75                	j	80003456 <fileread+0x58>
    panic("fileread");
    8000349c:	00004517          	auipc	a0,0x4
    800034a0:	0dc50513          	addi	a0,a0,220 # 80007578 <etext+0x578>
    800034a4:	753010ef          	jal	800053f6 <panic>
    return -1;
    800034a8:	597d                	li	s2,-1
    800034aa:	b775                	j	80003456 <fileread+0x58>
      return -1;
    800034ac:	597d                	li	s2,-1
    800034ae:	64e2                	ld	s1,24(sp)
    800034b0:	69a2                	ld	s3,8(sp)
    800034b2:	b755                	j	80003456 <fileread+0x58>
    800034b4:	597d                	li	s2,-1
    800034b6:	64e2                	ld	s1,24(sp)
    800034b8:	69a2                	ld	s3,8(sp)
    800034ba:	bf71                	j	80003456 <fileread+0x58>

00000000800034bc <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800034bc:	00954783          	lbu	a5,9(a0)
    800034c0:	10078e63          	beqz	a5,800035dc <filewrite+0x120>
{
    800034c4:	711d                	addi	sp,sp,-96
    800034c6:	ec86                	sd	ra,88(sp)
    800034c8:	e8a2                	sd	s0,80(sp)
    800034ca:	e0ca                	sd	s2,64(sp)
    800034cc:	f456                	sd	s5,40(sp)
    800034ce:	f05a                	sd	s6,32(sp)
    800034d0:	1080                	addi	s0,sp,96
    800034d2:	892a                	mv	s2,a0
    800034d4:	8b2e                	mv	s6,a1
    800034d6:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    800034d8:	411c                	lw	a5,0(a0)
    800034da:	4705                	li	a4,1
    800034dc:	02e78963          	beq	a5,a4,8000350e <filewrite+0x52>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800034e0:	470d                	li	a4,3
    800034e2:	02e78a63          	beq	a5,a4,80003516 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800034e6:	4709                	li	a4,2
    800034e8:	0ce79e63          	bne	a5,a4,800035c4 <filewrite+0x108>
    800034ec:	f852                	sd	s4,48(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800034ee:	0ac05963          	blez	a2,800035a0 <filewrite+0xe4>
    800034f2:	e4a6                	sd	s1,72(sp)
    800034f4:	fc4e                	sd	s3,56(sp)
    800034f6:	ec5e                	sd	s7,24(sp)
    800034f8:	e862                	sd	s8,16(sp)
    800034fa:	e466                	sd	s9,8(sp)
    int i = 0;
    800034fc:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    800034fe:	6b85                	lui	s7,0x1
    80003500:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003504:	6c85                	lui	s9,0x1
    80003506:	c00c8c9b          	addiw	s9,s9,-1024 # c00 <_entry-0x7ffff400>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000350a:	4c05                	li	s8,1
    8000350c:	a8ad                	j	80003586 <filewrite+0xca>
    ret = pipewrite(f->pipe, addr, n);
    8000350e:	6908                	ld	a0,16(a0)
    80003510:	1fe000ef          	jal	8000370e <pipewrite>
    80003514:	a04d                	j	800035b6 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003516:	02451783          	lh	a5,36(a0)
    8000351a:	03079693          	slli	a3,a5,0x30
    8000351e:	92c1                	srli	a3,a3,0x30
    80003520:	4725                	li	a4,9
    80003522:	0ad76f63          	bltu	a4,a3,800035e0 <filewrite+0x124>
    80003526:	0792                	slli	a5,a5,0x4
    80003528:	00014717          	auipc	a4,0x14
    8000352c:	47070713          	addi	a4,a4,1136 # 80017998 <devsw>
    80003530:	97ba                	add	a5,a5,a4
    80003532:	679c                	ld	a5,8(a5)
    80003534:	cbc5                	beqz	a5,800035e4 <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    80003536:	4505                	li	a0,1
    80003538:	9782                	jalr	a5
    8000353a:	a8b5                	j	800035b6 <filewrite+0xfa>
      if(n1 > max)
    8000353c:	2981                	sext.w	s3,s3
      begin_op();
    8000353e:	981ff0ef          	jal	80002ebe <begin_op>
      ilock(f->ip);
    80003542:	01893503          	ld	a0,24(s2)
    80003546:	8c6ff0ef          	jal	8000260c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000354a:	874e                	mv	a4,s3
    8000354c:	02092683          	lw	a3,32(s2)
    80003550:	016a0633          	add	a2,s4,s6
    80003554:	85e2                	mv	a1,s8
    80003556:	01893503          	ld	a0,24(s2)
    8000355a:	bfcff0ef          	jal	80002956 <writei>
    8000355e:	84aa                	mv	s1,a0
    80003560:	00a05763          	blez	a0,8000356e <filewrite+0xb2>
        f->off += r;
    80003564:	02092783          	lw	a5,32(s2)
    80003568:	9fa9                	addw	a5,a5,a0
    8000356a:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000356e:	01893503          	ld	a0,24(s2)
    80003572:	948ff0ef          	jal	800026ba <iunlock>
      end_op();
    80003576:	9b3ff0ef          	jal	80002f28 <end_op>

      if(r != n1){
    8000357a:	02999563          	bne	s3,s1,800035a4 <filewrite+0xe8>
        // error from writei
        break;
      }
      i += r;
    8000357e:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80003582:	015a5963          	bge	s4,s5,80003594 <filewrite+0xd8>
      int n1 = n - i;
    80003586:	414a87bb          	subw	a5,s5,s4
    8000358a:	89be                	mv	s3,a5
      if(n1 > max)
    8000358c:	fafbd8e3          	bge	s7,a5,8000353c <filewrite+0x80>
    80003590:	89e6                	mv	s3,s9
    80003592:	b76d                	j	8000353c <filewrite+0x80>
    80003594:	64a6                	ld	s1,72(sp)
    80003596:	79e2                	ld	s3,56(sp)
    80003598:	6be2                	ld	s7,24(sp)
    8000359a:	6c42                	ld	s8,16(sp)
    8000359c:	6ca2                	ld	s9,8(sp)
    8000359e:	a801                	j	800035ae <filewrite+0xf2>
    int i = 0;
    800035a0:	4a01                	li	s4,0
    800035a2:	a031                	j	800035ae <filewrite+0xf2>
    800035a4:	64a6                	ld	s1,72(sp)
    800035a6:	79e2                	ld	s3,56(sp)
    800035a8:	6be2                	ld	s7,24(sp)
    800035aa:	6c42                	ld	s8,16(sp)
    800035ac:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    800035ae:	034a9d63          	bne	s5,s4,800035e8 <filewrite+0x12c>
    800035b2:	8556                	mv	a0,s5
    800035b4:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800035b6:	60e6                	ld	ra,88(sp)
    800035b8:	6446                	ld	s0,80(sp)
    800035ba:	6906                	ld	s2,64(sp)
    800035bc:	7aa2                	ld	s5,40(sp)
    800035be:	7b02                	ld	s6,32(sp)
    800035c0:	6125                	addi	sp,sp,96
    800035c2:	8082                	ret
    800035c4:	e4a6                	sd	s1,72(sp)
    800035c6:	fc4e                	sd	s3,56(sp)
    800035c8:	f852                	sd	s4,48(sp)
    800035ca:	ec5e                	sd	s7,24(sp)
    800035cc:	e862                	sd	s8,16(sp)
    800035ce:	e466                	sd	s9,8(sp)
    panic("filewrite");
    800035d0:	00004517          	auipc	a0,0x4
    800035d4:	fb850513          	addi	a0,a0,-72 # 80007588 <etext+0x588>
    800035d8:	61f010ef          	jal	800053f6 <panic>
    return -1;
    800035dc:	557d                	li	a0,-1
}
    800035de:	8082                	ret
      return -1;
    800035e0:	557d                	li	a0,-1
    800035e2:	bfd1                	j	800035b6 <filewrite+0xfa>
    800035e4:	557d                	li	a0,-1
    800035e6:	bfc1                	j	800035b6 <filewrite+0xfa>
    ret = (i == n ? n : -1);
    800035e8:	557d                	li	a0,-1
    800035ea:	7a42                	ld	s4,48(sp)
    800035ec:	b7e9                	j	800035b6 <filewrite+0xfa>

00000000800035ee <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800035ee:	7179                	addi	sp,sp,-48
    800035f0:	f406                	sd	ra,40(sp)
    800035f2:	f022                	sd	s0,32(sp)
    800035f4:	ec26                	sd	s1,24(sp)
    800035f6:	e052                	sd	s4,0(sp)
    800035f8:	1800                	addi	s0,sp,48
    800035fa:	84aa                	mv	s1,a0
    800035fc:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800035fe:	0005b023          	sd	zero,0(a1)
    80003602:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003606:	c35ff0ef          	jal	8000323a <filealloc>
    8000360a:	e088                	sd	a0,0(s1)
    8000360c:	c549                	beqz	a0,80003696 <pipealloc+0xa8>
    8000360e:	c2dff0ef          	jal	8000323a <filealloc>
    80003612:	00aa3023          	sd	a0,0(s4)
    80003616:	cd25                	beqz	a0,8000368e <pipealloc+0xa0>
    80003618:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    8000361a:	ae5fc0ef          	jal	800000fe <kalloc>
    8000361e:	892a                	mv	s2,a0
    80003620:	c12d                	beqz	a0,80003682 <pipealloc+0x94>
    80003622:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003624:	4985                	li	s3,1
    80003626:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000362a:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000362e:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003632:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003636:	00004597          	auipc	a1,0x4
    8000363a:	f6258593          	addi	a1,a1,-158 # 80007598 <etext+0x598>
    8000363e:	062020ef          	jal	800056a0 <initlock>
  (*f0)->type = FD_PIPE;
    80003642:	609c                	ld	a5,0(s1)
    80003644:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003648:	609c                	ld	a5,0(s1)
    8000364a:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000364e:	609c                	ld	a5,0(s1)
    80003650:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003654:	609c                	ld	a5,0(s1)
    80003656:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000365a:	000a3783          	ld	a5,0(s4)
    8000365e:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003662:	000a3783          	ld	a5,0(s4)
    80003666:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000366a:	000a3783          	ld	a5,0(s4)
    8000366e:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003672:	000a3783          	ld	a5,0(s4)
    80003676:	0127b823          	sd	s2,16(a5)
  return 0;
    8000367a:	4501                	li	a0,0
    8000367c:	6942                	ld	s2,16(sp)
    8000367e:	69a2                	ld	s3,8(sp)
    80003680:	a01d                	j	800036a6 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003682:	6088                	ld	a0,0(s1)
    80003684:	c119                	beqz	a0,8000368a <pipealloc+0x9c>
    80003686:	6942                	ld	s2,16(sp)
    80003688:	a029                	j	80003692 <pipealloc+0xa4>
    8000368a:	6942                	ld	s2,16(sp)
    8000368c:	a029                	j	80003696 <pipealloc+0xa8>
    8000368e:	6088                	ld	a0,0(s1)
    80003690:	c10d                	beqz	a0,800036b2 <pipealloc+0xc4>
    fileclose(*f0);
    80003692:	c4dff0ef          	jal	800032de <fileclose>
  if(*f1)
    80003696:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000369a:	557d                	li	a0,-1
  if(*f1)
    8000369c:	c789                	beqz	a5,800036a6 <pipealloc+0xb8>
    fileclose(*f1);
    8000369e:	853e                	mv	a0,a5
    800036a0:	c3fff0ef          	jal	800032de <fileclose>
  return -1;
    800036a4:	557d                	li	a0,-1
}
    800036a6:	70a2                	ld	ra,40(sp)
    800036a8:	7402                	ld	s0,32(sp)
    800036aa:	64e2                	ld	s1,24(sp)
    800036ac:	6a02                	ld	s4,0(sp)
    800036ae:	6145                	addi	sp,sp,48
    800036b0:	8082                	ret
  return -1;
    800036b2:	557d                	li	a0,-1
    800036b4:	bfcd                	j	800036a6 <pipealloc+0xb8>

00000000800036b6 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800036b6:	1101                	addi	sp,sp,-32
    800036b8:	ec06                	sd	ra,24(sp)
    800036ba:	e822                	sd	s0,16(sp)
    800036bc:	e426                	sd	s1,8(sp)
    800036be:	e04a                	sd	s2,0(sp)
    800036c0:	1000                	addi	s0,sp,32
    800036c2:	84aa                	mv	s1,a0
    800036c4:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800036c6:	05e020ef          	jal	80005724 <acquire>
  if(writable){
    800036ca:	02090763          	beqz	s2,800036f8 <pipeclose+0x42>
    pi->writeopen = 0;
    800036ce:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800036d2:	21848513          	addi	a0,s1,536
    800036d6:	ca1fd0ef          	jal	80001376 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800036da:	2204b783          	ld	a5,544(s1)
    800036de:	e785                	bnez	a5,80003706 <pipeclose+0x50>
    release(&pi->lock);
    800036e0:	8526                	mv	a0,s1
    800036e2:	0d6020ef          	jal	800057b8 <release>
    kfree((char*)pi);
    800036e6:	8526                	mv	a0,s1
    800036e8:	935fc0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    800036ec:	60e2                	ld	ra,24(sp)
    800036ee:	6442                	ld	s0,16(sp)
    800036f0:	64a2                	ld	s1,8(sp)
    800036f2:	6902                	ld	s2,0(sp)
    800036f4:	6105                	addi	sp,sp,32
    800036f6:	8082                	ret
    pi->readopen = 0;
    800036f8:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800036fc:	21c48513          	addi	a0,s1,540
    80003700:	c77fd0ef          	jal	80001376 <wakeup>
    80003704:	bfd9                	j	800036da <pipeclose+0x24>
    release(&pi->lock);
    80003706:	8526                	mv	a0,s1
    80003708:	0b0020ef          	jal	800057b8 <release>
}
    8000370c:	b7c5                	j	800036ec <pipeclose+0x36>

000000008000370e <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000370e:	7159                	addi	sp,sp,-112
    80003710:	f486                	sd	ra,104(sp)
    80003712:	f0a2                	sd	s0,96(sp)
    80003714:	eca6                	sd	s1,88(sp)
    80003716:	e8ca                	sd	s2,80(sp)
    80003718:	e4ce                	sd	s3,72(sp)
    8000371a:	e0d2                	sd	s4,64(sp)
    8000371c:	fc56                	sd	s5,56(sp)
    8000371e:	1880                	addi	s0,sp,112
    80003720:	84aa                	mv	s1,a0
    80003722:	8aae                	mv	s5,a1
    80003724:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003726:	e36fd0ef          	jal	80000d5c <myproc>
    8000372a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000372c:	8526                	mv	a0,s1
    8000372e:	7f7010ef          	jal	80005724 <acquire>
  while(i < n){
    80003732:	0d405263          	blez	s4,800037f6 <pipewrite+0xe8>
    80003736:	f85a                	sd	s6,48(sp)
    80003738:	f45e                	sd	s7,40(sp)
    8000373a:	f062                	sd	s8,32(sp)
    8000373c:	ec66                	sd	s9,24(sp)
    8000373e:	e86a                	sd	s10,16(sp)
  int i = 0;
    80003740:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003742:	f9f40c13          	addi	s8,s0,-97
    80003746:	4b85                	li	s7,1
    80003748:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000374a:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000374e:	21c48c93          	addi	s9,s1,540
    80003752:	a82d                	j	8000378c <pipewrite+0x7e>
      release(&pi->lock);
    80003754:	8526                	mv	a0,s1
    80003756:	062020ef          	jal	800057b8 <release>
      return -1;
    8000375a:	597d                	li	s2,-1
    8000375c:	7b42                	ld	s6,48(sp)
    8000375e:	7ba2                	ld	s7,40(sp)
    80003760:	7c02                	ld	s8,32(sp)
    80003762:	6ce2                	ld	s9,24(sp)
    80003764:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003766:	854a                	mv	a0,s2
    80003768:	70a6                	ld	ra,104(sp)
    8000376a:	7406                	ld	s0,96(sp)
    8000376c:	64e6                	ld	s1,88(sp)
    8000376e:	6946                	ld	s2,80(sp)
    80003770:	69a6                	ld	s3,72(sp)
    80003772:	6a06                	ld	s4,64(sp)
    80003774:	7ae2                	ld	s5,56(sp)
    80003776:	6165                	addi	sp,sp,112
    80003778:	8082                	ret
      wakeup(&pi->nread);
    8000377a:	856a                	mv	a0,s10
    8000377c:	bfbfd0ef          	jal	80001376 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003780:	85a6                	mv	a1,s1
    80003782:	8566                	mv	a0,s9
    80003784:	ba7fd0ef          	jal	8000132a <sleep>
  while(i < n){
    80003788:	05495a63          	bge	s2,s4,800037dc <pipewrite+0xce>
    if(pi->readopen == 0 || killed(pr)){
    8000378c:	2204a783          	lw	a5,544(s1)
    80003790:	d3f1                	beqz	a5,80003754 <pipewrite+0x46>
    80003792:	854e                	mv	a0,s3
    80003794:	dcffd0ef          	jal	80001562 <killed>
    80003798:	fd55                	bnez	a0,80003754 <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000379a:	2184a783          	lw	a5,536(s1)
    8000379e:	21c4a703          	lw	a4,540(s1)
    800037a2:	2007879b          	addiw	a5,a5,512
    800037a6:	fcf70ae3          	beq	a4,a5,8000377a <pipewrite+0x6c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800037aa:	86de                	mv	a3,s7
    800037ac:	01590633          	add	a2,s2,s5
    800037b0:	85e2                	mv	a1,s8
    800037b2:	0509b503          	ld	a0,80(s3)
    800037b6:	afefd0ef          	jal	80000ab4 <copyin>
    800037ba:	05650063          	beq	a0,s6,800037fa <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800037be:	21c4a783          	lw	a5,540(s1)
    800037c2:	0017871b          	addiw	a4,a5,1
    800037c6:	20e4ae23          	sw	a4,540(s1)
    800037ca:	1ff7f793          	andi	a5,a5,511
    800037ce:	97a6                	add	a5,a5,s1
    800037d0:	f9f44703          	lbu	a4,-97(s0)
    800037d4:	00e78c23          	sb	a4,24(a5)
      i++;
    800037d8:	2905                	addiw	s2,s2,1
    800037da:	b77d                	j	80003788 <pipewrite+0x7a>
    800037dc:	7b42                	ld	s6,48(sp)
    800037de:	7ba2                	ld	s7,40(sp)
    800037e0:	7c02                	ld	s8,32(sp)
    800037e2:	6ce2                	ld	s9,24(sp)
    800037e4:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    800037e6:	21848513          	addi	a0,s1,536
    800037ea:	b8dfd0ef          	jal	80001376 <wakeup>
  release(&pi->lock);
    800037ee:	8526                	mv	a0,s1
    800037f0:	7c9010ef          	jal	800057b8 <release>
  return i;
    800037f4:	bf8d                	j	80003766 <pipewrite+0x58>
  int i = 0;
    800037f6:	4901                	li	s2,0
    800037f8:	b7fd                	j	800037e6 <pipewrite+0xd8>
    800037fa:	7b42                	ld	s6,48(sp)
    800037fc:	7ba2                	ld	s7,40(sp)
    800037fe:	7c02                	ld	s8,32(sp)
    80003800:	6ce2                	ld	s9,24(sp)
    80003802:	6d42                	ld	s10,16(sp)
    80003804:	b7cd                	j	800037e6 <pipewrite+0xd8>

0000000080003806 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003806:	711d                	addi	sp,sp,-96
    80003808:	ec86                	sd	ra,88(sp)
    8000380a:	e8a2                	sd	s0,80(sp)
    8000380c:	e4a6                	sd	s1,72(sp)
    8000380e:	e0ca                	sd	s2,64(sp)
    80003810:	fc4e                	sd	s3,56(sp)
    80003812:	f852                	sd	s4,48(sp)
    80003814:	f456                	sd	s5,40(sp)
    80003816:	1080                	addi	s0,sp,96
    80003818:	84aa                	mv	s1,a0
    8000381a:	892e                	mv	s2,a1
    8000381c:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000381e:	d3efd0ef          	jal	80000d5c <myproc>
    80003822:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003824:	8526                	mv	a0,s1
    80003826:	6ff010ef          	jal	80005724 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000382a:	2184a703          	lw	a4,536(s1)
    8000382e:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003832:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003836:	02f71763          	bne	a4,a5,80003864 <piperead+0x5e>
    8000383a:	2244a783          	lw	a5,548(s1)
    8000383e:	cf85                	beqz	a5,80003876 <piperead+0x70>
    if(killed(pr)){
    80003840:	8552                	mv	a0,s4
    80003842:	d21fd0ef          	jal	80001562 <killed>
    80003846:	e11d                	bnez	a0,8000386c <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003848:	85a6                	mv	a1,s1
    8000384a:	854e                	mv	a0,s3
    8000384c:	adffd0ef          	jal	8000132a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003850:	2184a703          	lw	a4,536(s1)
    80003854:	21c4a783          	lw	a5,540(s1)
    80003858:	fef701e3          	beq	a4,a5,8000383a <piperead+0x34>
    8000385c:	f05a                	sd	s6,32(sp)
    8000385e:	ec5e                	sd	s7,24(sp)
    80003860:	e862                	sd	s8,16(sp)
    80003862:	a829                	j	8000387c <piperead+0x76>
    80003864:	f05a                	sd	s6,32(sp)
    80003866:	ec5e                	sd	s7,24(sp)
    80003868:	e862                	sd	s8,16(sp)
    8000386a:	a809                	j	8000387c <piperead+0x76>
      release(&pi->lock);
    8000386c:	8526                	mv	a0,s1
    8000386e:	74b010ef          	jal	800057b8 <release>
      return -1;
    80003872:	59fd                	li	s3,-1
    80003874:	a0a5                	j	800038dc <piperead+0xd6>
    80003876:	f05a                	sd	s6,32(sp)
    80003878:	ec5e                	sd	s7,24(sp)
    8000387a:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000387c:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000387e:	faf40c13          	addi	s8,s0,-81
    80003882:	4b85                	li	s7,1
    80003884:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003886:	05505163          	blez	s5,800038c8 <piperead+0xc2>
    if(pi->nread == pi->nwrite)
    8000388a:	2184a783          	lw	a5,536(s1)
    8000388e:	21c4a703          	lw	a4,540(s1)
    80003892:	02f70b63          	beq	a4,a5,800038c8 <piperead+0xc2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003896:	0017871b          	addiw	a4,a5,1
    8000389a:	20e4ac23          	sw	a4,536(s1)
    8000389e:	1ff7f793          	andi	a5,a5,511
    800038a2:	97a6                	add	a5,a5,s1
    800038a4:	0187c783          	lbu	a5,24(a5)
    800038a8:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800038ac:	86de                	mv	a3,s7
    800038ae:	8662                	mv	a2,s8
    800038b0:	85ca                	mv	a1,s2
    800038b2:	050a3503          	ld	a0,80(s4)
    800038b6:	94efd0ef          	jal	80000a04 <copyout>
    800038ba:	01650763          	beq	a0,s6,800038c8 <piperead+0xc2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800038be:	2985                	addiw	s3,s3,1
    800038c0:	0905                	addi	s2,s2,1
    800038c2:	fd3a94e3          	bne	s5,s3,8000388a <piperead+0x84>
    800038c6:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800038c8:	21c48513          	addi	a0,s1,540
    800038cc:	aabfd0ef          	jal	80001376 <wakeup>
  release(&pi->lock);
    800038d0:	8526                	mv	a0,s1
    800038d2:	6e7010ef          	jal	800057b8 <release>
    800038d6:	7b02                	ld	s6,32(sp)
    800038d8:	6be2                	ld	s7,24(sp)
    800038da:	6c42                	ld	s8,16(sp)
  return i;
}
    800038dc:	854e                	mv	a0,s3
    800038de:	60e6                	ld	ra,88(sp)
    800038e0:	6446                	ld	s0,80(sp)
    800038e2:	64a6                	ld	s1,72(sp)
    800038e4:	6906                	ld	s2,64(sp)
    800038e6:	79e2                	ld	s3,56(sp)
    800038e8:	7a42                	ld	s4,48(sp)
    800038ea:	7aa2                	ld	s5,40(sp)
    800038ec:	6125                	addi	sp,sp,96
    800038ee:	8082                	ret

00000000800038f0 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800038f0:	1141                	addi	sp,sp,-16
    800038f2:	e406                	sd	ra,8(sp)
    800038f4:	e022                	sd	s0,0(sp)
    800038f6:	0800                	addi	s0,sp,16
    800038f8:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800038fa:	0035151b          	slliw	a0,a0,0x3
    800038fe:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    80003900:	8b89                	andi	a5,a5,2
    80003902:	c399                	beqz	a5,80003908 <flags2perm+0x18>
      perm |= PTE_W;
    80003904:	00456513          	ori	a0,a0,4
    return perm;
}
    80003908:	60a2                	ld	ra,8(sp)
    8000390a:	6402                	ld	s0,0(sp)
    8000390c:	0141                	addi	sp,sp,16
    8000390e:	8082                	ret

0000000080003910 <exec>:

int
exec(char *path, char **argv)
{
    80003910:	de010113          	addi	sp,sp,-544
    80003914:	20113c23          	sd	ra,536(sp)
    80003918:	20813823          	sd	s0,528(sp)
    8000391c:	20913423          	sd	s1,520(sp)
    80003920:	21213023          	sd	s2,512(sp)
    80003924:	1400                	addi	s0,sp,544
    80003926:	892a                	mv	s2,a0
    80003928:	dea43823          	sd	a0,-528(s0)
    8000392c:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003930:	c2cfd0ef          	jal	80000d5c <myproc>
    80003934:	84aa                	mv	s1,a0

  begin_op();
    80003936:	d88ff0ef          	jal	80002ebe <begin_op>

  if((ip = namei(path)) == 0){
    8000393a:	854a                	mv	a0,s2
    8000393c:	bc0ff0ef          	jal	80002cfc <namei>
    80003940:	cd21                	beqz	a0,80003998 <exec+0x88>
    80003942:	fbd2                	sd	s4,496(sp)
    80003944:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003946:	cc7fe0ef          	jal	8000260c <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000394a:	04000713          	li	a4,64
    8000394e:	4681                	li	a3,0
    80003950:	e5040613          	addi	a2,s0,-432
    80003954:	4581                	li	a1,0
    80003956:	8552                	mv	a0,s4
    80003958:	f0dfe0ef          	jal	80002864 <readi>
    8000395c:	04000793          	li	a5,64
    80003960:	00f51a63          	bne	a0,a5,80003974 <exec+0x64>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80003964:	e5042703          	lw	a4,-432(s0)
    80003968:	464c47b7          	lui	a5,0x464c4
    8000396c:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003970:	02f70863          	beq	a4,a5,800039a0 <exec+0x90>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003974:	8552                	mv	a0,s4
    80003976:	ea1fe0ef          	jal	80002816 <iunlockput>
    end_op();
    8000397a:	daeff0ef          	jal	80002f28 <end_op>
  }
  return -1;
    8000397e:	557d                	li	a0,-1
    80003980:	7a5e                	ld	s4,496(sp)
}
    80003982:	21813083          	ld	ra,536(sp)
    80003986:	21013403          	ld	s0,528(sp)
    8000398a:	20813483          	ld	s1,520(sp)
    8000398e:	20013903          	ld	s2,512(sp)
    80003992:	22010113          	addi	sp,sp,544
    80003996:	8082                	ret
    end_op();
    80003998:	d90ff0ef          	jal	80002f28 <end_op>
    return -1;
    8000399c:	557d                	li	a0,-1
    8000399e:	b7d5                	j	80003982 <exec+0x72>
    800039a0:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    800039a2:	8526                	mv	a0,s1
    800039a4:	c60fd0ef          	jal	80000e04 <proc_pagetable>
    800039a8:	8b2a                	mv	s6,a0
    800039aa:	26050d63          	beqz	a0,80003c24 <exec+0x314>
    800039ae:	ffce                	sd	s3,504(sp)
    800039b0:	f7d6                	sd	s5,488(sp)
    800039b2:	efde                	sd	s7,472(sp)
    800039b4:	ebe2                	sd	s8,464(sp)
    800039b6:	e7e6                	sd	s9,456(sp)
    800039b8:	e3ea                	sd	s10,448(sp)
    800039ba:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800039bc:	e7042683          	lw	a3,-400(s0)
    800039c0:	e8845783          	lhu	a5,-376(s0)
    800039c4:	0e078763          	beqz	a5,80003ab2 <exec+0x1a2>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800039c8:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800039ca:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800039cc:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    800039d0:	6c85                	lui	s9,0x1
    800039d2:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800039d6:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800039da:	6a85                	lui	s5,0x1
    800039dc:	a085                	j	80003a3c <exec+0x12c>
      panic("loadseg: address should exist");
    800039de:	00004517          	auipc	a0,0x4
    800039e2:	bc250513          	addi	a0,a0,-1086 # 800075a0 <etext+0x5a0>
    800039e6:	211010ef          	jal	800053f6 <panic>
    if(sz - i < PGSIZE)
    800039ea:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800039ec:	874a                	mv	a4,s2
    800039ee:	009c06bb          	addw	a3,s8,s1
    800039f2:	4581                	li	a1,0
    800039f4:	8552                	mv	a0,s4
    800039f6:	e6ffe0ef          	jal	80002864 <readi>
    800039fa:	22a91963          	bne	s2,a0,80003c2c <exec+0x31c>
  for(i = 0; i < sz; i += PGSIZE){
    800039fe:	009a84bb          	addw	s1,s5,s1
    80003a02:	0334f263          	bgeu	s1,s3,80003a26 <exec+0x116>
    pa = walkaddr(pagetable, va + i);
    80003a06:	02049593          	slli	a1,s1,0x20
    80003a0a:	9181                	srli	a1,a1,0x20
    80003a0c:	95de                	add	a1,a1,s7
    80003a0e:	855a                	mv	a0,s6
    80003a10:	a6dfc0ef          	jal	8000047c <walkaddr>
    80003a14:	862a                	mv	a2,a0
    if(pa == 0)
    80003a16:	d561                	beqz	a0,800039de <exec+0xce>
    if(sz - i < PGSIZE)
    80003a18:	409987bb          	subw	a5,s3,s1
    80003a1c:	893e                	mv	s2,a5
    80003a1e:	fcfcf6e3          	bgeu	s9,a5,800039ea <exec+0xda>
    80003a22:	8956                	mv	s2,s5
    80003a24:	b7d9                	j	800039ea <exec+0xda>
    sz = sz1;
    80003a26:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003a2a:	2d05                	addiw	s10,s10,1
    80003a2c:	e0843783          	ld	a5,-504(s0)
    80003a30:	0387869b          	addiw	a3,a5,56
    80003a34:	e8845783          	lhu	a5,-376(s0)
    80003a38:	06fd5e63          	bge	s10,a5,80003ab4 <exec+0x1a4>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003a3c:	e0d43423          	sd	a3,-504(s0)
    80003a40:	876e                	mv	a4,s11
    80003a42:	e1840613          	addi	a2,s0,-488
    80003a46:	4581                	li	a1,0
    80003a48:	8552                	mv	a0,s4
    80003a4a:	e1bfe0ef          	jal	80002864 <readi>
    80003a4e:	1db51d63          	bne	a0,s11,80003c28 <exec+0x318>
    if(ph.type != ELF_PROG_LOAD)
    80003a52:	e1842783          	lw	a5,-488(s0)
    80003a56:	4705                	li	a4,1
    80003a58:	fce799e3          	bne	a5,a4,80003a2a <exec+0x11a>
    if(ph.memsz < ph.filesz)
    80003a5c:	e4043483          	ld	s1,-448(s0)
    80003a60:	e3843783          	ld	a5,-456(s0)
    80003a64:	1ef4e263          	bltu	s1,a5,80003c48 <exec+0x338>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003a68:	e2843783          	ld	a5,-472(s0)
    80003a6c:	94be                	add	s1,s1,a5
    80003a6e:	1ef4e063          	bltu	s1,a5,80003c4e <exec+0x33e>
    if(ph.vaddr % PGSIZE != 0)
    80003a72:	de843703          	ld	a4,-536(s0)
    80003a76:	8ff9                	and	a5,a5,a4
    80003a78:	1c079e63          	bnez	a5,80003c54 <exec+0x344>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003a7c:	e1c42503          	lw	a0,-484(s0)
    80003a80:	e71ff0ef          	jal	800038f0 <flags2perm>
    80003a84:	86aa                	mv	a3,a0
    80003a86:	8626                	mv	a2,s1
    80003a88:	85ca                	mv	a1,s2
    80003a8a:	855a                	mv	a0,s6
    80003a8c:	d59fc0ef          	jal	800007e4 <uvmalloc>
    80003a90:	dea43c23          	sd	a0,-520(s0)
    80003a94:	1c050363          	beqz	a0,80003c5a <exec+0x34a>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003a98:	e2843b83          	ld	s7,-472(s0)
    80003a9c:	e2042c03          	lw	s8,-480(s0)
    80003aa0:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003aa4:	00098463          	beqz	s3,80003aac <exec+0x19c>
    80003aa8:	4481                	li	s1,0
    80003aaa:	bfb1                	j	80003a06 <exec+0xf6>
    sz = sz1;
    80003aac:	df843903          	ld	s2,-520(s0)
    80003ab0:	bfad                	j	80003a2a <exec+0x11a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003ab2:	4901                	li	s2,0
  iunlockput(ip);
    80003ab4:	8552                	mv	a0,s4
    80003ab6:	d61fe0ef          	jal	80002816 <iunlockput>
  end_op();
    80003aba:	c6eff0ef          	jal	80002f28 <end_op>
  p = myproc();
    80003abe:	a9efd0ef          	jal	80000d5c <myproc>
    80003ac2:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003ac4:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80003ac8:	6985                	lui	s3,0x1
    80003aca:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003acc:	99ca                	add	s3,s3,s2
    80003ace:	77fd                	lui	a5,0xfffff
    80003ad0:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003ad4:	4691                	li	a3,4
    80003ad6:	660d                	lui	a2,0x3
    80003ad8:	964e                	add	a2,a2,s3
    80003ada:	85ce                	mv	a1,s3
    80003adc:	855a                	mv	a0,s6
    80003ade:	d07fc0ef          	jal	800007e4 <uvmalloc>
    80003ae2:	8a2a                	mv	s4,a0
    80003ae4:	e105                	bnez	a0,80003b04 <exec+0x1f4>
    proc_freepagetable(pagetable, sz);
    80003ae6:	85ce                	mv	a1,s3
    80003ae8:	855a                	mv	a0,s6
    80003aea:	b9efd0ef          	jal	80000e88 <proc_freepagetable>
  return -1;
    80003aee:	557d                	li	a0,-1
    80003af0:	79fe                	ld	s3,504(sp)
    80003af2:	7a5e                	ld	s4,496(sp)
    80003af4:	7abe                	ld	s5,488(sp)
    80003af6:	7b1e                	ld	s6,480(sp)
    80003af8:	6bfe                	ld	s7,472(sp)
    80003afa:	6c5e                	ld	s8,464(sp)
    80003afc:	6cbe                	ld	s9,456(sp)
    80003afe:	6d1e                	ld	s10,448(sp)
    80003b00:	7dfa                	ld	s11,440(sp)
    80003b02:	b541                	j	80003982 <exec+0x72>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003b04:	75f5                	lui	a1,0xffffd
    80003b06:	95aa                	add	a1,a1,a0
    80003b08:	855a                	mv	a0,s6
    80003b0a:	ed1fc0ef          	jal	800009da <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003b0e:	7bf9                	lui	s7,0xffffe
    80003b10:	9bd2                	add	s7,s7,s4
  for(argc = 0; argv[argc]; argc++) {
    80003b12:	e0043783          	ld	a5,-512(s0)
    80003b16:	6388                	ld	a0,0(a5)
  sp = sz;
    80003b18:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    80003b1a:	4481                	li	s1,0
    ustack[argc] = sp;
    80003b1c:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80003b20:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80003b24:	cd21                	beqz	a0,80003b7c <exec+0x26c>
    sp -= strlen(argv[argc]) + 1;
    80003b26:	fb0fc0ef          	jal	800002d6 <strlen>
    80003b2a:	0015079b          	addiw	a5,a0,1
    80003b2e:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003b32:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003b36:	13796563          	bltu	s2,s7,80003c60 <exec+0x350>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003b3a:	e0043d83          	ld	s11,-512(s0)
    80003b3e:	000db983          	ld	s3,0(s11)
    80003b42:	854e                	mv	a0,s3
    80003b44:	f92fc0ef          	jal	800002d6 <strlen>
    80003b48:	0015069b          	addiw	a3,a0,1
    80003b4c:	864e                	mv	a2,s3
    80003b4e:	85ca                	mv	a1,s2
    80003b50:	855a                	mv	a0,s6
    80003b52:	eb3fc0ef          	jal	80000a04 <copyout>
    80003b56:	10054763          	bltz	a0,80003c64 <exec+0x354>
    ustack[argc] = sp;
    80003b5a:	00349793          	slli	a5,s1,0x3
    80003b5e:	97e6                	add	a5,a5,s9
    80003b60:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffde3d0>
  for(argc = 0; argv[argc]; argc++) {
    80003b64:	0485                	addi	s1,s1,1
    80003b66:	008d8793          	addi	a5,s11,8
    80003b6a:	e0f43023          	sd	a5,-512(s0)
    80003b6e:	008db503          	ld	a0,8(s11)
    80003b72:	c509                	beqz	a0,80003b7c <exec+0x26c>
    if(argc >= MAXARG)
    80003b74:	fb8499e3          	bne	s1,s8,80003b26 <exec+0x216>
  sz = sz1;
    80003b78:	89d2                	mv	s3,s4
    80003b7a:	b7b5                	j	80003ae6 <exec+0x1d6>
  ustack[argc] = 0;
    80003b7c:	00349793          	slli	a5,s1,0x3
    80003b80:	f9078793          	addi	a5,a5,-112
    80003b84:	97a2                	add	a5,a5,s0
    80003b86:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003b8a:	00148693          	addi	a3,s1,1
    80003b8e:	068e                	slli	a3,a3,0x3
    80003b90:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003b94:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003b98:	89d2                	mv	s3,s4
  if(sp < stackbase)
    80003b9a:	f57966e3          	bltu	s2,s7,80003ae6 <exec+0x1d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003b9e:	e9040613          	addi	a2,s0,-368
    80003ba2:	85ca                	mv	a1,s2
    80003ba4:	855a                	mv	a0,s6
    80003ba6:	e5ffc0ef          	jal	80000a04 <copyout>
    80003baa:	f2054ee3          	bltz	a0,80003ae6 <exec+0x1d6>
  p->trapframe->a1 = sp;
    80003bae:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003bb2:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003bb6:	df043783          	ld	a5,-528(s0)
    80003bba:	0007c703          	lbu	a4,0(a5)
    80003bbe:	cf11                	beqz	a4,80003bda <exec+0x2ca>
    80003bc0:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003bc2:	02f00693          	li	a3,47
    80003bc6:	a029                	j	80003bd0 <exec+0x2c0>
  for(last=s=path; *s; s++)
    80003bc8:	0785                	addi	a5,a5,1
    80003bca:	fff7c703          	lbu	a4,-1(a5)
    80003bce:	c711                	beqz	a4,80003bda <exec+0x2ca>
    if(*s == '/')
    80003bd0:	fed71ce3          	bne	a4,a3,80003bc8 <exec+0x2b8>
      last = s+1;
    80003bd4:	def43823          	sd	a5,-528(s0)
    80003bd8:	bfc5                	j	80003bc8 <exec+0x2b8>
  safestrcpy(p->name, last, sizeof(p->name));
    80003bda:	4641                	li	a2,16
    80003bdc:	df043583          	ld	a1,-528(s0)
    80003be0:	158a8513          	addi	a0,s5,344
    80003be4:	ebcfc0ef          	jal	800002a0 <safestrcpy>
  oldpagetable = p->pagetable;
    80003be8:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003bec:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003bf0:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003bf4:	058ab783          	ld	a5,88(s5)
    80003bf8:	e6843703          	ld	a4,-408(s0)
    80003bfc:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003bfe:	058ab783          	ld	a5,88(s5)
    80003c02:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003c06:	85ea                	mv	a1,s10
    80003c08:	a80fd0ef          	jal	80000e88 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003c0c:	0004851b          	sext.w	a0,s1
    80003c10:	79fe                	ld	s3,504(sp)
    80003c12:	7a5e                	ld	s4,496(sp)
    80003c14:	7abe                	ld	s5,488(sp)
    80003c16:	7b1e                	ld	s6,480(sp)
    80003c18:	6bfe                	ld	s7,472(sp)
    80003c1a:	6c5e                	ld	s8,464(sp)
    80003c1c:	6cbe                	ld	s9,456(sp)
    80003c1e:	6d1e                	ld	s10,448(sp)
    80003c20:	7dfa                	ld	s11,440(sp)
    80003c22:	b385                	j	80003982 <exec+0x72>
    80003c24:	7b1e                	ld	s6,480(sp)
    80003c26:	b3b9                	j	80003974 <exec+0x64>
    80003c28:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80003c2c:	df843583          	ld	a1,-520(s0)
    80003c30:	855a                	mv	a0,s6
    80003c32:	a56fd0ef          	jal	80000e88 <proc_freepagetable>
  if(ip){
    80003c36:	79fe                	ld	s3,504(sp)
    80003c38:	7abe                	ld	s5,488(sp)
    80003c3a:	7b1e                	ld	s6,480(sp)
    80003c3c:	6bfe                	ld	s7,472(sp)
    80003c3e:	6c5e                	ld	s8,464(sp)
    80003c40:	6cbe                	ld	s9,456(sp)
    80003c42:	6d1e                	ld	s10,448(sp)
    80003c44:	7dfa                	ld	s11,440(sp)
    80003c46:	b33d                	j	80003974 <exec+0x64>
    80003c48:	df243c23          	sd	s2,-520(s0)
    80003c4c:	b7c5                	j	80003c2c <exec+0x31c>
    80003c4e:	df243c23          	sd	s2,-520(s0)
    80003c52:	bfe9                	j	80003c2c <exec+0x31c>
    80003c54:	df243c23          	sd	s2,-520(s0)
    80003c58:	bfd1                	j	80003c2c <exec+0x31c>
    80003c5a:	df243c23          	sd	s2,-520(s0)
    80003c5e:	b7f9                	j	80003c2c <exec+0x31c>
  sz = sz1;
    80003c60:	89d2                	mv	s3,s4
    80003c62:	b551                	j	80003ae6 <exec+0x1d6>
    80003c64:	89d2                	mv	s3,s4
    80003c66:	b541                	j	80003ae6 <exec+0x1d6>

0000000080003c68 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003c68:	7179                	addi	sp,sp,-48
    80003c6a:	f406                	sd	ra,40(sp)
    80003c6c:	f022                	sd	s0,32(sp)
    80003c6e:	ec26                	sd	s1,24(sp)
    80003c70:	e84a                	sd	s2,16(sp)
    80003c72:	1800                	addi	s0,sp,48
    80003c74:	892e                	mv	s2,a1
    80003c76:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003c78:	fdc40593          	addi	a1,s0,-36
    80003c7c:	f93fd0ef          	jal	80001c0e <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003c80:	fdc42703          	lw	a4,-36(s0)
    80003c84:	47bd                	li	a5,15
    80003c86:	02e7e963          	bltu	a5,a4,80003cb8 <argfd+0x50>
    80003c8a:	8d2fd0ef          	jal	80000d5c <myproc>
    80003c8e:	fdc42703          	lw	a4,-36(s0)
    80003c92:	01a70793          	addi	a5,a4,26
    80003c96:	078e                	slli	a5,a5,0x3
    80003c98:	953e                	add	a0,a0,a5
    80003c9a:	611c                	ld	a5,0(a0)
    80003c9c:	c385                	beqz	a5,80003cbc <argfd+0x54>
    return -1;
  if(pfd)
    80003c9e:	00090463          	beqz	s2,80003ca6 <argfd+0x3e>
    *pfd = fd;
    80003ca2:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003ca6:	4501                	li	a0,0
  if(pf)
    80003ca8:	c091                	beqz	s1,80003cac <argfd+0x44>
    *pf = f;
    80003caa:	e09c                	sd	a5,0(s1)
}
    80003cac:	70a2                	ld	ra,40(sp)
    80003cae:	7402                	ld	s0,32(sp)
    80003cb0:	64e2                	ld	s1,24(sp)
    80003cb2:	6942                	ld	s2,16(sp)
    80003cb4:	6145                	addi	sp,sp,48
    80003cb6:	8082                	ret
    return -1;
    80003cb8:	557d                	li	a0,-1
    80003cba:	bfcd                	j	80003cac <argfd+0x44>
    80003cbc:	557d                	li	a0,-1
    80003cbe:	b7fd                	j	80003cac <argfd+0x44>

0000000080003cc0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003cc0:	1101                	addi	sp,sp,-32
    80003cc2:	ec06                	sd	ra,24(sp)
    80003cc4:	e822                	sd	s0,16(sp)
    80003cc6:	e426                	sd	s1,8(sp)
    80003cc8:	1000                	addi	s0,sp,32
    80003cca:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003ccc:	890fd0ef          	jal	80000d5c <myproc>
    80003cd0:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003cd2:	0d050793          	addi	a5,a0,208
    80003cd6:	4501                	li	a0,0
    80003cd8:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003cda:	6398                	ld	a4,0(a5)
    80003cdc:	cb19                	beqz	a4,80003cf2 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003cde:	2505                	addiw	a0,a0,1
    80003ce0:	07a1                	addi	a5,a5,8
    80003ce2:	fed51ce3          	bne	a0,a3,80003cda <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003ce6:	557d                	li	a0,-1
}
    80003ce8:	60e2                	ld	ra,24(sp)
    80003cea:	6442                	ld	s0,16(sp)
    80003cec:	64a2                	ld	s1,8(sp)
    80003cee:	6105                	addi	sp,sp,32
    80003cf0:	8082                	ret
      p->ofile[fd] = f;
    80003cf2:	01a50793          	addi	a5,a0,26
    80003cf6:	078e                	slli	a5,a5,0x3
    80003cf8:	963e                	add	a2,a2,a5
    80003cfa:	e204                	sd	s1,0(a2)
      return fd;
    80003cfc:	b7f5                	j	80003ce8 <fdalloc+0x28>

0000000080003cfe <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003cfe:	715d                	addi	sp,sp,-80
    80003d00:	e486                	sd	ra,72(sp)
    80003d02:	e0a2                	sd	s0,64(sp)
    80003d04:	fc26                	sd	s1,56(sp)
    80003d06:	f84a                	sd	s2,48(sp)
    80003d08:	f44e                	sd	s3,40(sp)
    80003d0a:	ec56                	sd	s5,24(sp)
    80003d0c:	e85a                	sd	s6,16(sp)
    80003d0e:	0880                	addi	s0,sp,80
    80003d10:	8b2e                	mv	s6,a1
    80003d12:	89b2                	mv	s3,a2
    80003d14:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003d16:	fb040593          	addi	a1,s0,-80
    80003d1a:	ffdfe0ef          	jal	80002d16 <nameiparent>
    80003d1e:	84aa                	mv	s1,a0
    80003d20:	10050a63          	beqz	a0,80003e34 <create+0x136>
    return 0;

  ilock(dp);
    80003d24:	8e9fe0ef          	jal	8000260c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80003d28:	4601                	li	a2,0
    80003d2a:	fb040593          	addi	a1,s0,-80
    80003d2e:	8526                	mv	a0,s1
    80003d30:	d41fe0ef          	jal	80002a70 <dirlookup>
    80003d34:	8aaa                	mv	s5,a0
    80003d36:	c129                	beqz	a0,80003d78 <create+0x7a>
    iunlockput(dp);
    80003d38:	8526                	mv	a0,s1
    80003d3a:	addfe0ef          	jal	80002816 <iunlockput>
    ilock(ip);
    80003d3e:	8556                	mv	a0,s5
    80003d40:	8cdfe0ef          	jal	8000260c <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80003d44:	4789                	li	a5,2
    80003d46:	02fb1463          	bne	s6,a5,80003d6e <create+0x70>
    80003d4a:	044ad783          	lhu	a5,68(s5)
    80003d4e:	37f9                	addiw	a5,a5,-2
    80003d50:	17c2                	slli	a5,a5,0x30
    80003d52:	93c1                	srli	a5,a5,0x30
    80003d54:	4705                	li	a4,1
    80003d56:	00f76c63          	bltu	a4,a5,80003d6e <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80003d5a:	8556                	mv	a0,s5
    80003d5c:	60a6                	ld	ra,72(sp)
    80003d5e:	6406                	ld	s0,64(sp)
    80003d60:	74e2                	ld	s1,56(sp)
    80003d62:	7942                	ld	s2,48(sp)
    80003d64:	79a2                	ld	s3,40(sp)
    80003d66:	6ae2                	ld	s5,24(sp)
    80003d68:	6b42                	ld	s6,16(sp)
    80003d6a:	6161                	addi	sp,sp,80
    80003d6c:	8082                	ret
    iunlockput(ip);
    80003d6e:	8556                	mv	a0,s5
    80003d70:	aa7fe0ef          	jal	80002816 <iunlockput>
    return 0;
    80003d74:	4a81                	li	s5,0
    80003d76:	b7d5                	j	80003d5a <create+0x5c>
    80003d78:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80003d7a:	85da                	mv	a1,s6
    80003d7c:	4088                	lw	a0,0(s1)
    80003d7e:	f1efe0ef          	jal	8000249c <ialloc>
    80003d82:	8a2a                	mv	s4,a0
    80003d84:	cd15                	beqz	a0,80003dc0 <create+0xc2>
  ilock(ip);
    80003d86:	887fe0ef          	jal	8000260c <ilock>
  ip->major = major;
    80003d8a:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80003d8e:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80003d92:	4905                	li	s2,1
    80003d94:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80003d98:	8552                	mv	a0,s4
    80003d9a:	fbefe0ef          	jal	80002558 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80003d9e:	032b0763          	beq	s6,s2,80003dcc <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80003da2:	004a2603          	lw	a2,4(s4)
    80003da6:	fb040593          	addi	a1,s0,-80
    80003daa:	8526                	mv	a0,s1
    80003dac:	ea7fe0ef          	jal	80002c52 <dirlink>
    80003db0:	06054563          	bltz	a0,80003e1a <create+0x11c>
  iunlockput(dp);
    80003db4:	8526                	mv	a0,s1
    80003db6:	a61fe0ef          	jal	80002816 <iunlockput>
  return ip;
    80003dba:	8ad2                	mv	s5,s4
    80003dbc:	7a02                	ld	s4,32(sp)
    80003dbe:	bf71                	j	80003d5a <create+0x5c>
    iunlockput(dp);
    80003dc0:	8526                	mv	a0,s1
    80003dc2:	a55fe0ef          	jal	80002816 <iunlockput>
    return 0;
    80003dc6:	8ad2                	mv	s5,s4
    80003dc8:	7a02                	ld	s4,32(sp)
    80003dca:	bf41                	j	80003d5a <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80003dcc:	004a2603          	lw	a2,4(s4)
    80003dd0:	00003597          	auipc	a1,0x3
    80003dd4:	7f058593          	addi	a1,a1,2032 # 800075c0 <etext+0x5c0>
    80003dd8:	8552                	mv	a0,s4
    80003dda:	e79fe0ef          	jal	80002c52 <dirlink>
    80003dde:	02054e63          	bltz	a0,80003e1a <create+0x11c>
    80003de2:	40d0                	lw	a2,4(s1)
    80003de4:	00003597          	auipc	a1,0x3
    80003de8:	7e458593          	addi	a1,a1,2020 # 800075c8 <etext+0x5c8>
    80003dec:	8552                	mv	a0,s4
    80003dee:	e65fe0ef          	jal	80002c52 <dirlink>
    80003df2:	02054463          	bltz	a0,80003e1a <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80003df6:	004a2603          	lw	a2,4(s4)
    80003dfa:	fb040593          	addi	a1,s0,-80
    80003dfe:	8526                	mv	a0,s1
    80003e00:	e53fe0ef          	jal	80002c52 <dirlink>
    80003e04:	00054b63          	bltz	a0,80003e1a <create+0x11c>
    dp->nlink++;  // for ".."
    80003e08:	04a4d783          	lhu	a5,74(s1)
    80003e0c:	2785                	addiw	a5,a5,1
    80003e0e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80003e12:	8526                	mv	a0,s1
    80003e14:	f44fe0ef          	jal	80002558 <iupdate>
    80003e18:	bf71                	j	80003db4 <create+0xb6>
  ip->nlink = 0;
    80003e1a:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80003e1e:	8552                	mv	a0,s4
    80003e20:	f38fe0ef          	jal	80002558 <iupdate>
  iunlockput(ip);
    80003e24:	8552                	mv	a0,s4
    80003e26:	9f1fe0ef          	jal	80002816 <iunlockput>
  iunlockput(dp);
    80003e2a:	8526                	mv	a0,s1
    80003e2c:	9ebfe0ef          	jal	80002816 <iunlockput>
  return 0;
    80003e30:	7a02                	ld	s4,32(sp)
    80003e32:	b725                	j	80003d5a <create+0x5c>
    return 0;
    80003e34:	8aaa                	mv	s5,a0
    80003e36:	b715                	j	80003d5a <create+0x5c>

0000000080003e38 <sys_dup>:
{
    80003e38:	7179                	addi	sp,sp,-48
    80003e3a:	f406                	sd	ra,40(sp)
    80003e3c:	f022                	sd	s0,32(sp)
    80003e3e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80003e40:	fd840613          	addi	a2,s0,-40
    80003e44:	4581                	li	a1,0
    80003e46:	4501                	li	a0,0
    80003e48:	e21ff0ef          	jal	80003c68 <argfd>
    return -1;
    80003e4c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80003e4e:	02054363          	bltz	a0,80003e74 <sys_dup+0x3c>
    80003e52:	ec26                	sd	s1,24(sp)
    80003e54:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80003e56:	fd843903          	ld	s2,-40(s0)
    80003e5a:	854a                	mv	a0,s2
    80003e5c:	e65ff0ef          	jal	80003cc0 <fdalloc>
    80003e60:	84aa                	mv	s1,a0
    return -1;
    80003e62:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80003e64:	00054d63          	bltz	a0,80003e7e <sys_dup+0x46>
  filedup(f);
    80003e68:	854a                	mv	a0,s2
    80003e6a:	c2eff0ef          	jal	80003298 <filedup>
  return fd;
    80003e6e:	87a6                	mv	a5,s1
    80003e70:	64e2                	ld	s1,24(sp)
    80003e72:	6942                	ld	s2,16(sp)
}
    80003e74:	853e                	mv	a0,a5
    80003e76:	70a2                	ld	ra,40(sp)
    80003e78:	7402                	ld	s0,32(sp)
    80003e7a:	6145                	addi	sp,sp,48
    80003e7c:	8082                	ret
    80003e7e:	64e2                	ld	s1,24(sp)
    80003e80:	6942                	ld	s2,16(sp)
    80003e82:	bfcd                	j	80003e74 <sys_dup+0x3c>

0000000080003e84 <sys_read>:
{
    80003e84:	7179                	addi	sp,sp,-48
    80003e86:	f406                	sd	ra,40(sp)
    80003e88:	f022                	sd	s0,32(sp)
    80003e8a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003e8c:	fd840593          	addi	a1,s0,-40
    80003e90:	4505                	li	a0,1
    80003e92:	d99fd0ef          	jal	80001c2a <argaddr>
  argint(2, &n);
    80003e96:	fe440593          	addi	a1,s0,-28
    80003e9a:	4509                	li	a0,2
    80003e9c:	d73fd0ef          	jal	80001c0e <argint>
  if(argfd(0, 0, &f) < 0)
    80003ea0:	fe840613          	addi	a2,s0,-24
    80003ea4:	4581                	li	a1,0
    80003ea6:	4501                	li	a0,0
    80003ea8:	dc1ff0ef          	jal	80003c68 <argfd>
    80003eac:	87aa                	mv	a5,a0
    return -1;
    80003eae:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003eb0:	0007ca63          	bltz	a5,80003ec4 <sys_read+0x40>
  return fileread(f, p, n);
    80003eb4:	fe442603          	lw	a2,-28(s0)
    80003eb8:	fd843583          	ld	a1,-40(s0)
    80003ebc:	fe843503          	ld	a0,-24(s0)
    80003ec0:	d3eff0ef          	jal	800033fe <fileread>
}
    80003ec4:	70a2                	ld	ra,40(sp)
    80003ec6:	7402                	ld	s0,32(sp)
    80003ec8:	6145                	addi	sp,sp,48
    80003eca:	8082                	ret

0000000080003ecc <sys_write>:
{
    80003ecc:	7179                	addi	sp,sp,-48
    80003ece:	f406                	sd	ra,40(sp)
    80003ed0:	f022                	sd	s0,32(sp)
    80003ed2:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003ed4:	fd840593          	addi	a1,s0,-40
    80003ed8:	4505                	li	a0,1
    80003eda:	d51fd0ef          	jal	80001c2a <argaddr>
  argint(2, &n);
    80003ede:	fe440593          	addi	a1,s0,-28
    80003ee2:	4509                	li	a0,2
    80003ee4:	d2bfd0ef          	jal	80001c0e <argint>
  if(argfd(0, 0, &f) < 0)
    80003ee8:	fe840613          	addi	a2,s0,-24
    80003eec:	4581                	li	a1,0
    80003eee:	4501                	li	a0,0
    80003ef0:	d79ff0ef          	jal	80003c68 <argfd>
    80003ef4:	87aa                	mv	a5,a0
    return -1;
    80003ef6:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003ef8:	0007ca63          	bltz	a5,80003f0c <sys_write+0x40>
  return filewrite(f, p, n);
    80003efc:	fe442603          	lw	a2,-28(s0)
    80003f00:	fd843583          	ld	a1,-40(s0)
    80003f04:	fe843503          	ld	a0,-24(s0)
    80003f08:	db4ff0ef          	jal	800034bc <filewrite>
}
    80003f0c:	70a2                	ld	ra,40(sp)
    80003f0e:	7402                	ld	s0,32(sp)
    80003f10:	6145                	addi	sp,sp,48
    80003f12:	8082                	ret

0000000080003f14 <sys_close>:
{
    80003f14:	1101                	addi	sp,sp,-32
    80003f16:	ec06                	sd	ra,24(sp)
    80003f18:	e822                	sd	s0,16(sp)
    80003f1a:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80003f1c:	fe040613          	addi	a2,s0,-32
    80003f20:	fec40593          	addi	a1,s0,-20
    80003f24:	4501                	li	a0,0
    80003f26:	d43ff0ef          	jal	80003c68 <argfd>
    return -1;
    80003f2a:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80003f2c:	02054063          	bltz	a0,80003f4c <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80003f30:	e2dfc0ef          	jal	80000d5c <myproc>
    80003f34:	fec42783          	lw	a5,-20(s0)
    80003f38:	07e9                	addi	a5,a5,26
    80003f3a:	078e                	slli	a5,a5,0x3
    80003f3c:	953e                	add	a0,a0,a5
    80003f3e:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80003f42:	fe043503          	ld	a0,-32(s0)
    80003f46:	b98ff0ef          	jal	800032de <fileclose>
  return 0;
    80003f4a:	4781                	li	a5,0
}
    80003f4c:	853e                	mv	a0,a5
    80003f4e:	60e2                	ld	ra,24(sp)
    80003f50:	6442                	ld	s0,16(sp)
    80003f52:	6105                	addi	sp,sp,32
    80003f54:	8082                	ret

0000000080003f56 <sys_fstat>:
{
    80003f56:	1101                	addi	sp,sp,-32
    80003f58:	ec06                	sd	ra,24(sp)
    80003f5a:	e822                	sd	s0,16(sp)
    80003f5c:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80003f5e:	fe040593          	addi	a1,s0,-32
    80003f62:	4505                	li	a0,1
    80003f64:	cc7fd0ef          	jal	80001c2a <argaddr>
  if(argfd(0, 0, &f) < 0)
    80003f68:	fe840613          	addi	a2,s0,-24
    80003f6c:	4581                	li	a1,0
    80003f6e:	4501                	li	a0,0
    80003f70:	cf9ff0ef          	jal	80003c68 <argfd>
    80003f74:	87aa                	mv	a5,a0
    return -1;
    80003f76:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003f78:	0007c863          	bltz	a5,80003f88 <sys_fstat+0x32>
  return filestat(f, st);
    80003f7c:	fe043583          	ld	a1,-32(s0)
    80003f80:	fe843503          	ld	a0,-24(s0)
    80003f84:	c18ff0ef          	jal	8000339c <filestat>
}
    80003f88:	60e2                	ld	ra,24(sp)
    80003f8a:	6442                	ld	s0,16(sp)
    80003f8c:	6105                	addi	sp,sp,32
    80003f8e:	8082                	ret

0000000080003f90 <sys_link>:
{
    80003f90:	7169                	addi	sp,sp,-304
    80003f92:	f606                	sd	ra,296(sp)
    80003f94:	f222                	sd	s0,288(sp)
    80003f96:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80003f98:	08000613          	li	a2,128
    80003f9c:	ed040593          	addi	a1,s0,-304
    80003fa0:	4501                	li	a0,0
    80003fa2:	ca5fd0ef          	jal	80001c46 <argstr>
    return -1;
    80003fa6:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80003fa8:	0c054e63          	bltz	a0,80004084 <sys_link+0xf4>
    80003fac:	08000613          	li	a2,128
    80003fb0:	f5040593          	addi	a1,s0,-176
    80003fb4:	4505                	li	a0,1
    80003fb6:	c91fd0ef          	jal	80001c46 <argstr>
    return -1;
    80003fba:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80003fbc:	0c054463          	bltz	a0,80004084 <sys_link+0xf4>
    80003fc0:	ee26                	sd	s1,280(sp)
  begin_op();
    80003fc2:	efdfe0ef          	jal	80002ebe <begin_op>
  if((ip = namei(old)) == 0){
    80003fc6:	ed040513          	addi	a0,s0,-304
    80003fca:	d33fe0ef          	jal	80002cfc <namei>
    80003fce:	84aa                	mv	s1,a0
    80003fd0:	c53d                	beqz	a0,8000403e <sys_link+0xae>
  ilock(ip);
    80003fd2:	e3afe0ef          	jal	8000260c <ilock>
  if(ip->type == T_DIR){
    80003fd6:	04449703          	lh	a4,68(s1)
    80003fda:	4785                	li	a5,1
    80003fdc:	06f70663          	beq	a4,a5,80004048 <sys_link+0xb8>
    80003fe0:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80003fe2:	04a4d783          	lhu	a5,74(s1)
    80003fe6:	2785                	addiw	a5,a5,1
    80003fe8:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80003fec:	8526                	mv	a0,s1
    80003fee:	d6afe0ef          	jal	80002558 <iupdate>
  iunlock(ip);
    80003ff2:	8526                	mv	a0,s1
    80003ff4:	ec6fe0ef          	jal	800026ba <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80003ff8:	fd040593          	addi	a1,s0,-48
    80003ffc:	f5040513          	addi	a0,s0,-176
    80004000:	d17fe0ef          	jal	80002d16 <nameiparent>
    80004004:	892a                	mv	s2,a0
    80004006:	cd21                	beqz	a0,8000405e <sys_link+0xce>
  ilock(dp);
    80004008:	e04fe0ef          	jal	8000260c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000400c:	00092703          	lw	a4,0(s2)
    80004010:	409c                	lw	a5,0(s1)
    80004012:	04f71363          	bne	a4,a5,80004058 <sys_link+0xc8>
    80004016:	40d0                	lw	a2,4(s1)
    80004018:	fd040593          	addi	a1,s0,-48
    8000401c:	854a                	mv	a0,s2
    8000401e:	c35fe0ef          	jal	80002c52 <dirlink>
    80004022:	02054b63          	bltz	a0,80004058 <sys_link+0xc8>
  iunlockput(dp);
    80004026:	854a                	mv	a0,s2
    80004028:	feefe0ef          	jal	80002816 <iunlockput>
  iput(ip);
    8000402c:	8526                	mv	a0,s1
    8000402e:	f60fe0ef          	jal	8000278e <iput>
  end_op();
    80004032:	ef7fe0ef          	jal	80002f28 <end_op>
  return 0;
    80004036:	4781                	li	a5,0
    80004038:	64f2                	ld	s1,280(sp)
    8000403a:	6952                	ld	s2,272(sp)
    8000403c:	a0a1                	j	80004084 <sys_link+0xf4>
    end_op();
    8000403e:	eebfe0ef          	jal	80002f28 <end_op>
    return -1;
    80004042:	57fd                	li	a5,-1
    80004044:	64f2                	ld	s1,280(sp)
    80004046:	a83d                	j	80004084 <sys_link+0xf4>
    iunlockput(ip);
    80004048:	8526                	mv	a0,s1
    8000404a:	fccfe0ef          	jal	80002816 <iunlockput>
    end_op();
    8000404e:	edbfe0ef          	jal	80002f28 <end_op>
    return -1;
    80004052:	57fd                	li	a5,-1
    80004054:	64f2                	ld	s1,280(sp)
    80004056:	a03d                	j	80004084 <sys_link+0xf4>
    iunlockput(dp);
    80004058:	854a                	mv	a0,s2
    8000405a:	fbcfe0ef          	jal	80002816 <iunlockput>
  ilock(ip);
    8000405e:	8526                	mv	a0,s1
    80004060:	dacfe0ef          	jal	8000260c <ilock>
  ip->nlink--;
    80004064:	04a4d783          	lhu	a5,74(s1)
    80004068:	37fd                	addiw	a5,a5,-1
    8000406a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000406e:	8526                	mv	a0,s1
    80004070:	ce8fe0ef          	jal	80002558 <iupdate>
  iunlockput(ip);
    80004074:	8526                	mv	a0,s1
    80004076:	fa0fe0ef          	jal	80002816 <iunlockput>
  end_op();
    8000407a:	eaffe0ef          	jal	80002f28 <end_op>
  return -1;
    8000407e:	57fd                	li	a5,-1
    80004080:	64f2                	ld	s1,280(sp)
    80004082:	6952                	ld	s2,272(sp)
}
    80004084:	853e                	mv	a0,a5
    80004086:	70b2                	ld	ra,296(sp)
    80004088:	7412                	ld	s0,288(sp)
    8000408a:	6155                	addi	sp,sp,304
    8000408c:	8082                	ret

000000008000408e <sys_unlink>:
{
    8000408e:	7111                	addi	sp,sp,-256
    80004090:	fd86                	sd	ra,248(sp)
    80004092:	f9a2                	sd	s0,240(sp)
    80004094:	0200                	addi	s0,sp,256
  if(argstr(0, path, MAXPATH) < 0)
    80004096:	08000613          	li	a2,128
    8000409a:	f2040593          	addi	a1,s0,-224
    8000409e:	4501                	li	a0,0
    800040a0:	ba7fd0ef          	jal	80001c46 <argstr>
    800040a4:	16054663          	bltz	a0,80004210 <sys_unlink+0x182>
    800040a8:	f5a6                	sd	s1,232(sp)
  begin_op();
    800040aa:	e15fe0ef          	jal	80002ebe <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800040ae:	fa040593          	addi	a1,s0,-96
    800040b2:	f2040513          	addi	a0,s0,-224
    800040b6:	c61fe0ef          	jal	80002d16 <nameiparent>
    800040ba:	84aa                	mv	s1,a0
    800040bc:	c955                	beqz	a0,80004170 <sys_unlink+0xe2>
  ilock(dp);
    800040be:	d4efe0ef          	jal	8000260c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800040c2:	00003597          	auipc	a1,0x3
    800040c6:	4fe58593          	addi	a1,a1,1278 # 800075c0 <etext+0x5c0>
    800040ca:	fa040513          	addi	a0,s0,-96
    800040ce:	98dfe0ef          	jal	80002a5a <namecmp>
    800040d2:	12050463          	beqz	a0,800041fa <sys_unlink+0x16c>
    800040d6:	00003597          	auipc	a1,0x3
    800040da:	4f258593          	addi	a1,a1,1266 # 800075c8 <etext+0x5c8>
    800040de:	fa040513          	addi	a0,s0,-96
    800040e2:	979fe0ef          	jal	80002a5a <namecmp>
    800040e6:	10050a63          	beqz	a0,800041fa <sys_unlink+0x16c>
    800040ea:	f1ca                	sd	s2,224(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    800040ec:	f1c40613          	addi	a2,s0,-228
    800040f0:	fa040593          	addi	a1,s0,-96
    800040f4:	8526                	mv	a0,s1
    800040f6:	97bfe0ef          	jal	80002a70 <dirlookup>
    800040fa:	892a                	mv	s2,a0
    800040fc:	0e050e63          	beqz	a0,800041f8 <sys_unlink+0x16a>
    80004100:	edce                	sd	s3,216(sp)
  ilock(ip);
    80004102:	d0afe0ef          	jal	8000260c <ilock>
  if(ip->nlink < 1)
    80004106:	04a91783          	lh	a5,74(s2)
    8000410a:	06f05863          	blez	a5,8000417a <sys_unlink+0xec>
  if(ip->type == T_DIR && !isdirempty(ip)){
    8000410e:	04491703          	lh	a4,68(s2)
    80004112:	4785                	li	a5,1
    80004114:	06f70b63          	beq	a4,a5,8000418a <sys_unlink+0xfc>
  memset(&de, 0, sizeof(de));
    80004118:	fb040993          	addi	s3,s0,-80
    8000411c:	4641                	li	a2,16
    8000411e:	4581                	li	a1,0
    80004120:	854e                	mv	a0,s3
    80004122:	82cfc0ef          	jal	8000014e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004126:	4741                	li	a4,16
    80004128:	f1c42683          	lw	a3,-228(s0)
    8000412c:	864e                	mv	a2,s3
    8000412e:	4581                	li	a1,0
    80004130:	8526                	mv	a0,s1
    80004132:	825fe0ef          	jal	80002956 <writei>
    80004136:	47c1                	li	a5,16
    80004138:	08f51f63          	bne	a0,a5,800041d6 <sys_unlink+0x148>
  if(ip->type == T_DIR){
    8000413c:	04491703          	lh	a4,68(s2)
    80004140:	4785                	li	a5,1
    80004142:	0af70263          	beq	a4,a5,800041e6 <sys_unlink+0x158>
  iunlockput(dp);
    80004146:	8526                	mv	a0,s1
    80004148:	ecefe0ef          	jal	80002816 <iunlockput>
  ip->nlink--;
    8000414c:	04a95783          	lhu	a5,74(s2)
    80004150:	37fd                	addiw	a5,a5,-1
    80004152:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004156:	854a                	mv	a0,s2
    80004158:	c00fe0ef          	jal	80002558 <iupdate>
  iunlockput(ip);
    8000415c:	854a                	mv	a0,s2
    8000415e:	eb8fe0ef          	jal	80002816 <iunlockput>
  end_op();
    80004162:	dc7fe0ef          	jal	80002f28 <end_op>
  return 0;
    80004166:	4501                	li	a0,0
    80004168:	74ae                	ld	s1,232(sp)
    8000416a:	790e                	ld	s2,224(sp)
    8000416c:	69ee                	ld	s3,216(sp)
    8000416e:	a869                	j	80004208 <sys_unlink+0x17a>
    end_op();
    80004170:	db9fe0ef          	jal	80002f28 <end_op>
    return -1;
    80004174:	557d                	li	a0,-1
    80004176:	74ae                	ld	s1,232(sp)
    80004178:	a841                	j	80004208 <sys_unlink+0x17a>
    8000417a:	e9d2                	sd	s4,208(sp)
    8000417c:	e5d6                	sd	s5,200(sp)
    panic("unlink: nlink < 1");
    8000417e:	00003517          	auipc	a0,0x3
    80004182:	45250513          	addi	a0,a0,1106 # 800075d0 <etext+0x5d0>
    80004186:	270010ef          	jal	800053f6 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000418a:	04c92703          	lw	a4,76(s2)
    8000418e:	02000793          	li	a5,32
    80004192:	f8e7f3e3          	bgeu	a5,a4,80004118 <sys_unlink+0x8a>
    80004196:	e9d2                	sd	s4,208(sp)
    80004198:	e5d6                	sd	s5,200(sp)
    8000419a:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000419c:	f0840a93          	addi	s5,s0,-248
    800041a0:	4a41                	li	s4,16
    800041a2:	8752                	mv	a4,s4
    800041a4:	86ce                	mv	a3,s3
    800041a6:	8656                	mv	a2,s5
    800041a8:	4581                	li	a1,0
    800041aa:	854a                	mv	a0,s2
    800041ac:	eb8fe0ef          	jal	80002864 <readi>
    800041b0:	01451d63          	bne	a0,s4,800041ca <sys_unlink+0x13c>
    if(de.inum != 0)
    800041b4:	f0845783          	lhu	a5,-248(s0)
    800041b8:	efb1                	bnez	a5,80004214 <sys_unlink+0x186>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800041ba:	29c1                	addiw	s3,s3,16
    800041bc:	04c92783          	lw	a5,76(s2)
    800041c0:	fef9e1e3          	bltu	s3,a5,800041a2 <sys_unlink+0x114>
    800041c4:	6a4e                	ld	s4,208(sp)
    800041c6:	6aae                	ld	s5,200(sp)
    800041c8:	bf81                	j	80004118 <sys_unlink+0x8a>
      panic("isdirempty: readi");
    800041ca:	00003517          	auipc	a0,0x3
    800041ce:	41e50513          	addi	a0,a0,1054 # 800075e8 <etext+0x5e8>
    800041d2:	224010ef          	jal	800053f6 <panic>
    800041d6:	e9d2                	sd	s4,208(sp)
    800041d8:	e5d6                	sd	s5,200(sp)
    panic("unlink: writei");
    800041da:	00003517          	auipc	a0,0x3
    800041de:	42650513          	addi	a0,a0,1062 # 80007600 <etext+0x600>
    800041e2:	214010ef          	jal	800053f6 <panic>
    dp->nlink--;
    800041e6:	04a4d783          	lhu	a5,74(s1)
    800041ea:	37fd                	addiw	a5,a5,-1
    800041ec:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800041f0:	8526                	mv	a0,s1
    800041f2:	b66fe0ef          	jal	80002558 <iupdate>
    800041f6:	bf81                	j	80004146 <sys_unlink+0xb8>
    800041f8:	790e                	ld	s2,224(sp)
  iunlockput(dp);
    800041fa:	8526                	mv	a0,s1
    800041fc:	e1afe0ef          	jal	80002816 <iunlockput>
  end_op();
    80004200:	d29fe0ef          	jal	80002f28 <end_op>
  return -1;
    80004204:	557d                	li	a0,-1
    80004206:	74ae                	ld	s1,232(sp)
}
    80004208:	70ee                	ld	ra,248(sp)
    8000420a:	744e                	ld	s0,240(sp)
    8000420c:	6111                	addi	sp,sp,256
    8000420e:	8082                	ret
    return -1;
    80004210:	557d                	li	a0,-1
    80004212:	bfdd                	j	80004208 <sys_unlink+0x17a>
    iunlockput(ip);
    80004214:	854a                	mv	a0,s2
    80004216:	e00fe0ef          	jal	80002816 <iunlockput>
    goto bad;
    8000421a:	790e                	ld	s2,224(sp)
    8000421c:	69ee                	ld	s3,216(sp)
    8000421e:	6a4e                	ld	s4,208(sp)
    80004220:	6aae                	ld	s5,200(sp)
    80004222:	bfe1                	j	800041fa <sys_unlink+0x16c>

0000000080004224 <sys_open>:

uint64
sys_open(void)
{
    80004224:	7131                	addi	sp,sp,-192
    80004226:	fd06                	sd	ra,184(sp)
    80004228:	f922                	sd	s0,176(sp)
    8000422a:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    8000422c:	f4c40593          	addi	a1,s0,-180
    80004230:	4505                	li	a0,1
    80004232:	9ddfd0ef          	jal	80001c0e <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004236:	08000613          	li	a2,128
    8000423a:	f5040593          	addi	a1,s0,-176
    8000423e:	4501                	li	a0,0
    80004240:	a07fd0ef          	jal	80001c46 <argstr>
    80004244:	87aa                	mv	a5,a0
    return -1;
    80004246:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004248:	0a07c363          	bltz	a5,800042ee <sys_open+0xca>
    8000424c:	f526                	sd	s1,168(sp)

  begin_op();
    8000424e:	c71fe0ef          	jal	80002ebe <begin_op>

  if(omode & O_CREATE){
    80004252:	f4c42783          	lw	a5,-180(s0)
    80004256:	2007f793          	andi	a5,a5,512
    8000425a:	c3dd                	beqz	a5,80004300 <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    8000425c:	4681                	li	a3,0
    8000425e:	4601                	li	a2,0
    80004260:	4589                	li	a1,2
    80004262:	f5040513          	addi	a0,s0,-176
    80004266:	a99ff0ef          	jal	80003cfe <create>
    8000426a:	84aa                	mv	s1,a0
    if(ip == 0){
    8000426c:	c549                	beqz	a0,800042f6 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000426e:	04449703          	lh	a4,68(s1)
    80004272:	478d                	li	a5,3
    80004274:	00f71763          	bne	a4,a5,80004282 <sys_open+0x5e>
    80004278:	0464d703          	lhu	a4,70(s1)
    8000427c:	47a5                	li	a5,9
    8000427e:	0ae7ee63          	bltu	a5,a4,8000433a <sys_open+0x116>
    80004282:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004284:	fb7fe0ef          	jal	8000323a <filealloc>
    80004288:	892a                	mv	s2,a0
    8000428a:	c561                	beqz	a0,80004352 <sys_open+0x12e>
    8000428c:	ed4e                	sd	s3,152(sp)
    8000428e:	a33ff0ef          	jal	80003cc0 <fdalloc>
    80004292:	89aa                	mv	s3,a0
    80004294:	0a054b63          	bltz	a0,8000434a <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004298:	04449703          	lh	a4,68(s1)
    8000429c:	478d                	li	a5,3
    8000429e:	0cf70363          	beq	a4,a5,80004364 <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800042a2:	4789                	li	a5,2
    800042a4:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    800042a8:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    800042ac:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    800042b0:	f4c42783          	lw	a5,-180(s0)
    800042b4:	0017f713          	andi	a4,a5,1
    800042b8:	00174713          	xori	a4,a4,1
    800042bc:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800042c0:	0037f713          	andi	a4,a5,3
    800042c4:	00e03733          	snez	a4,a4
    800042c8:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800042cc:	4007f793          	andi	a5,a5,1024
    800042d0:	c791                	beqz	a5,800042dc <sys_open+0xb8>
    800042d2:	04449703          	lh	a4,68(s1)
    800042d6:	4789                	li	a5,2
    800042d8:	08f70d63          	beq	a4,a5,80004372 <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    800042dc:	8526                	mv	a0,s1
    800042de:	bdcfe0ef          	jal	800026ba <iunlock>
  end_op();
    800042e2:	c47fe0ef          	jal	80002f28 <end_op>

  return fd;
    800042e6:	854e                	mv	a0,s3
    800042e8:	74aa                	ld	s1,168(sp)
    800042ea:	790a                	ld	s2,160(sp)
    800042ec:	69ea                	ld	s3,152(sp)
}
    800042ee:	70ea                	ld	ra,184(sp)
    800042f0:	744a                	ld	s0,176(sp)
    800042f2:	6129                	addi	sp,sp,192
    800042f4:	8082                	ret
      end_op();
    800042f6:	c33fe0ef          	jal	80002f28 <end_op>
      return -1;
    800042fa:	557d                	li	a0,-1
    800042fc:	74aa                	ld	s1,168(sp)
    800042fe:	bfc5                	j	800042ee <sys_open+0xca>
    if((ip = namei(path)) == 0){
    80004300:	f5040513          	addi	a0,s0,-176
    80004304:	9f9fe0ef          	jal	80002cfc <namei>
    80004308:	84aa                	mv	s1,a0
    8000430a:	c11d                	beqz	a0,80004330 <sys_open+0x10c>
    ilock(ip);
    8000430c:	b00fe0ef          	jal	8000260c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004310:	04449703          	lh	a4,68(s1)
    80004314:	4785                	li	a5,1
    80004316:	f4f71ce3          	bne	a4,a5,8000426e <sys_open+0x4a>
    8000431a:	f4c42783          	lw	a5,-180(s0)
    8000431e:	d3b5                	beqz	a5,80004282 <sys_open+0x5e>
      iunlockput(ip);
    80004320:	8526                	mv	a0,s1
    80004322:	cf4fe0ef          	jal	80002816 <iunlockput>
      end_op();
    80004326:	c03fe0ef          	jal	80002f28 <end_op>
      return -1;
    8000432a:	557d                	li	a0,-1
    8000432c:	74aa                	ld	s1,168(sp)
    8000432e:	b7c1                	j	800042ee <sys_open+0xca>
      end_op();
    80004330:	bf9fe0ef          	jal	80002f28 <end_op>
      return -1;
    80004334:	557d                	li	a0,-1
    80004336:	74aa                	ld	s1,168(sp)
    80004338:	bf5d                	j	800042ee <sys_open+0xca>
    iunlockput(ip);
    8000433a:	8526                	mv	a0,s1
    8000433c:	cdafe0ef          	jal	80002816 <iunlockput>
    end_op();
    80004340:	be9fe0ef          	jal	80002f28 <end_op>
    return -1;
    80004344:	557d                	li	a0,-1
    80004346:	74aa                	ld	s1,168(sp)
    80004348:	b75d                	j	800042ee <sys_open+0xca>
      fileclose(f);
    8000434a:	854a                	mv	a0,s2
    8000434c:	f93fe0ef          	jal	800032de <fileclose>
    80004350:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80004352:	8526                	mv	a0,s1
    80004354:	cc2fe0ef          	jal	80002816 <iunlockput>
    end_op();
    80004358:	bd1fe0ef          	jal	80002f28 <end_op>
    return -1;
    8000435c:	557d                	li	a0,-1
    8000435e:	74aa                	ld	s1,168(sp)
    80004360:	790a                	ld	s2,160(sp)
    80004362:	b771                	j	800042ee <sys_open+0xca>
    f->type = FD_DEVICE;
    80004364:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004368:	04649783          	lh	a5,70(s1)
    8000436c:	02f91223          	sh	a5,36(s2)
    80004370:	bf35                	j	800042ac <sys_open+0x88>
    itrunc(ip);
    80004372:	8526                	mv	a0,s1
    80004374:	b86fe0ef          	jal	800026fa <itrunc>
    80004378:	b795                	j	800042dc <sys_open+0xb8>

000000008000437a <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000437a:	7175                	addi	sp,sp,-144
    8000437c:	e506                	sd	ra,136(sp)
    8000437e:	e122                	sd	s0,128(sp)
    80004380:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004382:	b3dfe0ef          	jal	80002ebe <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004386:	08000613          	li	a2,128
    8000438a:	f7040593          	addi	a1,s0,-144
    8000438e:	4501                	li	a0,0
    80004390:	8b7fd0ef          	jal	80001c46 <argstr>
    80004394:	02054363          	bltz	a0,800043ba <sys_mkdir+0x40>
    80004398:	4681                	li	a3,0
    8000439a:	4601                	li	a2,0
    8000439c:	4585                	li	a1,1
    8000439e:	f7040513          	addi	a0,s0,-144
    800043a2:	95dff0ef          	jal	80003cfe <create>
    800043a6:	c911                	beqz	a0,800043ba <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800043a8:	c6efe0ef          	jal	80002816 <iunlockput>
  end_op();
    800043ac:	b7dfe0ef          	jal	80002f28 <end_op>
  return 0;
    800043b0:	4501                	li	a0,0
}
    800043b2:	60aa                	ld	ra,136(sp)
    800043b4:	640a                	ld	s0,128(sp)
    800043b6:	6149                	addi	sp,sp,144
    800043b8:	8082                	ret
    end_op();
    800043ba:	b6ffe0ef          	jal	80002f28 <end_op>
    return -1;
    800043be:	557d                	li	a0,-1
    800043c0:	bfcd                	j	800043b2 <sys_mkdir+0x38>

00000000800043c2 <sys_mknod>:

uint64
sys_mknod(void)
{
    800043c2:	7135                	addi	sp,sp,-160
    800043c4:	ed06                	sd	ra,152(sp)
    800043c6:	e922                	sd	s0,144(sp)
    800043c8:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800043ca:	af5fe0ef          	jal	80002ebe <begin_op>
  argint(1, &major);
    800043ce:	f6c40593          	addi	a1,s0,-148
    800043d2:	4505                	li	a0,1
    800043d4:	83bfd0ef          	jal	80001c0e <argint>
  argint(2, &minor);
    800043d8:	f6840593          	addi	a1,s0,-152
    800043dc:	4509                	li	a0,2
    800043de:	831fd0ef          	jal	80001c0e <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800043e2:	08000613          	li	a2,128
    800043e6:	f7040593          	addi	a1,s0,-144
    800043ea:	4501                	li	a0,0
    800043ec:	85bfd0ef          	jal	80001c46 <argstr>
    800043f0:	02054563          	bltz	a0,8000441a <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800043f4:	f6841683          	lh	a3,-152(s0)
    800043f8:	f6c41603          	lh	a2,-148(s0)
    800043fc:	458d                	li	a1,3
    800043fe:	f7040513          	addi	a0,s0,-144
    80004402:	8fdff0ef          	jal	80003cfe <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004406:	c911                	beqz	a0,8000441a <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004408:	c0efe0ef          	jal	80002816 <iunlockput>
  end_op();
    8000440c:	b1dfe0ef          	jal	80002f28 <end_op>
  return 0;
    80004410:	4501                	li	a0,0
}
    80004412:	60ea                	ld	ra,152(sp)
    80004414:	644a                	ld	s0,144(sp)
    80004416:	610d                	addi	sp,sp,160
    80004418:	8082                	ret
    end_op();
    8000441a:	b0ffe0ef          	jal	80002f28 <end_op>
    return -1;
    8000441e:	557d                	li	a0,-1
    80004420:	bfcd                	j	80004412 <sys_mknod+0x50>

0000000080004422 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004422:	7135                	addi	sp,sp,-160
    80004424:	ed06                	sd	ra,152(sp)
    80004426:	e922                	sd	s0,144(sp)
    80004428:	e14a                	sd	s2,128(sp)
    8000442a:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000442c:	931fc0ef          	jal	80000d5c <myproc>
    80004430:	892a                	mv	s2,a0
  
  begin_op();
    80004432:	a8dfe0ef          	jal	80002ebe <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004436:	08000613          	li	a2,128
    8000443a:	f6040593          	addi	a1,s0,-160
    8000443e:	4501                	li	a0,0
    80004440:	807fd0ef          	jal	80001c46 <argstr>
    80004444:	04054363          	bltz	a0,8000448a <sys_chdir+0x68>
    80004448:	e526                	sd	s1,136(sp)
    8000444a:	f6040513          	addi	a0,s0,-160
    8000444e:	8affe0ef          	jal	80002cfc <namei>
    80004452:	84aa                	mv	s1,a0
    80004454:	c915                	beqz	a0,80004488 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004456:	9b6fe0ef          	jal	8000260c <ilock>
  if(ip->type != T_DIR){
    8000445a:	04449703          	lh	a4,68(s1)
    8000445e:	4785                	li	a5,1
    80004460:	02f71963          	bne	a4,a5,80004492 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004464:	8526                	mv	a0,s1
    80004466:	a54fe0ef          	jal	800026ba <iunlock>
  iput(p->cwd);
    8000446a:	15093503          	ld	a0,336(s2)
    8000446e:	b20fe0ef          	jal	8000278e <iput>
  end_op();
    80004472:	ab7fe0ef          	jal	80002f28 <end_op>
  p->cwd = ip;
    80004476:	14993823          	sd	s1,336(s2)
  return 0;
    8000447a:	4501                	li	a0,0
    8000447c:	64aa                	ld	s1,136(sp)
}
    8000447e:	60ea                	ld	ra,152(sp)
    80004480:	644a                	ld	s0,144(sp)
    80004482:	690a                	ld	s2,128(sp)
    80004484:	610d                	addi	sp,sp,160
    80004486:	8082                	ret
    80004488:	64aa                	ld	s1,136(sp)
    end_op();
    8000448a:	a9ffe0ef          	jal	80002f28 <end_op>
    return -1;
    8000448e:	557d                	li	a0,-1
    80004490:	b7fd                	j	8000447e <sys_chdir+0x5c>
    iunlockput(ip);
    80004492:	8526                	mv	a0,s1
    80004494:	b82fe0ef          	jal	80002816 <iunlockput>
    end_op();
    80004498:	a91fe0ef          	jal	80002f28 <end_op>
    return -1;
    8000449c:	557d                	li	a0,-1
    8000449e:	64aa                	ld	s1,136(sp)
    800044a0:	bff9                	j	8000447e <sys_chdir+0x5c>

00000000800044a2 <sys_exec>:

uint64
sys_exec(void)
{
    800044a2:	7105                	addi	sp,sp,-480
    800044a4:	ef86                	sd	ra,472(sp)
    800044a6:	eba2                	sd	s0,464(sp)
    800044a8:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800044aa:	e2840593          	addi	a1,s0,-472
    800044ae:	4505                	li	a0,1
    800044b0:	f7afd0ef          	jal	80001c2a <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800044b4:	08000613          	li	a2,128
    800044b8:	f3040593          	addi	a1,s0,-208
    800044bc:	4501                	li	a0,0
    800044be:	f88fd0ef          	jal	80001c46 <argstr>
    800044c2:	87aa                	mv	a5,a0
    return -1;
    800044c4:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800044c6:	0e07c063          	bltz	a5,800045a6 <sys_exec+0x104>
    800044ca:	e7a6                	sd	s1,456(sp)
    800044cc:	e3ca                	sd	s2,448(sp)
    800044ce:	ff4e                	sd	s3,440(sp)
    800044d0:	fb52                	sd	s4,432(sp)
    800044d2:	f756                	sd	s5,424(sp)
    800044d4:	f35a                	sd	s6,416(sp)
    800044d6:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    800044d8:	e3040a13          	addi	s4,s0,-464
    800044dc:	10000613          	li	a2,256
    800044e0:	4581                	li	a1,0
    800044e2:	8552                	mv	a0,s4
    800044e4:	c6bfb0ef          	jal	8000014e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800044e8:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    800044ea:	89d2                	mv	s3,s4
    800044ec:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800044ee:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800044f2:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    800044f4:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800044f8:	00391513          	slli	a0,s2,0x3
    800044fc:	85d6                	mv	a1,s5
    800044fe:	e2843783          	ld	a5,-472(s0)
    80004502:	953e                	add	a0,a0,a5
    80004504:	e80fd0ef          	jal	80001b84 <fetchaddr>
    80004508:	02054663          	bltz	a0,80004534 <sys_exec+0x92>
    if(uarg == 0){
    8000450c:	e2043783          	ld	a5,-480(s0)
    80004510:	c7a1                	beqz	a5,80004558 <sys_exec+0xb6>
    argv[i] = kalloc();
    80004512:	bedfb0ef          	jal	800000fe <kalloc>
    80004516:	85aa                	mv	a1,a0
    80004518:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000451c:	cd01                	beqz	a0,80004534 <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000451e:	865a                	mv	a2,s6
    80004520:	e2043503          	ld	a0,-480(s0)
    80004524:	eaafd0ef          	jal	80001bce <fetchstr>
    80004528:	00054663          	bltz	a0,80004534 <sys_exec+0x92>
    if(i >= NELEM(argv)){
    8000452c:	0905                	addi	s2,s2,1
    8000452e:	09a1                	addi	s3,s3,8
    80004530:	fd7914e3          	bne	s2,s7,800044f8 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004534:	100a0a13          	addi	s4,s4,256
    80004538:	6088                	ld	a0,0(s1)
    8000453a:	cd31                	beqz	a0,80004596 <sys_exec+0xf4>
    kfree(argv[i]);
    8000453c:	ae1fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004540:	04a1                	addi	s1,s1,8
    80004542:	ff449be3          	bne	s1,s4,80004538 <sys_exec+0x96>
  return -1;
    80004546:	557d                	li	a0,-1
    80004548:	64be                	ld	s1,456(sp)
    8000454a:	691e                	ld	s2,448(sp)
    8000454c:	79fa                	ld	s3,440(sp)
    8000454e:	7a5a                	ld	s4,432(sp)
    80004550:	7aba                	ld	s5,424(sp)
    80004552:	7b1a                	ld	s6,416(sp)
    80004554:	6bfa                	ld	s7,408(sp)
    80004556:	a881                	j	800045a6 <sys_exec+0x104>
      argv[i] = 0;
    80004558:	0009079b          	sext.w	a5,s2
    8000455c:	e3040593          	addi	a1,s0,-464
    80004560:	078e                	slli	a5,a5,0x3
    80004562:	97ae                	add	a5,a5,a1
    80004564:	0007b023          	sd	zero,0(a5)
  int ret = exec(path, argv);
    80004568:	f3040513          	addi	a0,s0,-208
    8000456c:	ba4ff0ef          	jal	80003910 <exec>
    80004570:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004572:	100a0a13          	addi	s4,s4,256
    80004576:	6088                	ld	a0,0(s1)
    80004578:	c511                	beqz	a0,80004584 <sys_exec+0xe2>
    kfree(argv[i]);
    8000457a:	aa3fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000457e:	04a1                	addi	s1,s1,8
    80004580:	ff449be3          	bne	s1,s4,80004576 <sys_exec+0xd4>
  return ret;
    80004584:	854a                	mv	a0,s2
    80004586:	64be                	ld	s1,456(sp)
    80004588:	691e                	ld	s2,448(sp)
    8000458a:	79fa                	ld	s3,440(sp)
    8000458c:	7a5a                	ld	s4,432(sp)
    8000458e:	7aba                	ld	s5,424(sp)
    80004590:	7b1a                	ld	s6,416(sp)
    80004592:	6bfa                	ld	s7,408(sp)
    80004594:	a809                	j	800045a6 <sys_exec+0x104>
  return -1;
    80004596:	557d                	li	a0,-1
    80004598:	64be                	ld	s1,456(sp)
    8000459a:	691e                	ld	s2,448(sp)
    8000459c:	79fa                	ld	s3,440(sp)
    8000459e:	7a5a                	ld	s4,432(sp)
    800045a0:	7aba                	ld	s5,424(sp)
    800045a2:	7b1a                	ld	s6,416(sp)
    800045a4:	6bfa                	ld	s7,408(sp)
}
    800045a6:	60fe                	ld	ra,472(sp)
    800045a8:	645e                	ld	s0,464(sp)
    800045aa:	613d                	addi	sp,sp,480
    800045ac:	8082                	ret

00000000800045ae <sys_pipe>:

uint64
sys_pipe(void)
{
    800045ae:	7139                	addi	sp,sp,-64
    800045b0:	fc06                	sd	ra,56(sp)
    800045b2:	f822                	sd	s0,48(sp)
    800045b4:	f426                	sd	s1,40(sp)
    800045b6:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800045b8:	fa4fc0ef          	jal	80000d5c <myproc>
    800045bc:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800045be:	fd840593          	addi	a1,s0,-40
    800045c2:	4501                	li	a0,0
    800045c4:	e66fd0ef          	jal	80001c2a <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800045c8:	fc840593          	addi	a1,s0,-56
    800045cc:	fd040513          	addi	a0,s0,-48
    800045d0:	81eff0ef          	jal	800035ee <pipealloc>
    return -1;
    800045d4:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800045d6:	0a054463          	bltz	a0,8000467e <sys_pipe+0xd0>
  fd0 = -1;
    800045da:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800045de:	fd043503          	ld	a0,-48(s0)
    800045e2:	edeff0ef          	jal	80003cc0 <fdalloc>
    800045e6:	fca42223          	sw	a0,-60(s0)
    800045ea:	08054163          	bltz	a0,8000466c <sys_pipe+0xbe>
    800045ee:	fc843503          	ld	a0,-56(s0)
    800045f2:	eceff0ef          	jal	80003cc0 <fdalloc>
    800045f6:	fca42023          	sw	a0,-64(s0)
    800045fa:	06054063          	bltz	a0,8000465a <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800045fe:	4691                	li	a3,4
    80004600:	fc440613          	addi	a2,s0,-60
    80004604:	fd843583          	ld	a1,-40(s0)
    80004608:	68a8                	ld	a0,80(s1)
    8000460a:	bfafc0ef          	jal	80000a04 <copyout>
    8000460e:	00054e63          	bltz	a0,8000462a <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004612:	4691                	li	a3,4
    80004614:	fc040613          	addi	a2,s0,-64
    80004618:	fd843583          	ld	a1,-40(s0)
    8000461c:	95b6                	add	a1,a1,a3
    8000461e:	68a8                	ld	a0,80(s1)
    80004620:	be4fc0ef          	jal	80000a04 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004624:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004626:	04055c63          	bgez	a0,8000467e <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    8000462a:	fc442783          	lw	a5,-60(s0)
    8000462e:	07e9                	addi	a5,a5,26
    80004630:	078e                	slli	a5,a5,0x3
    80004632:	97a6                	add	a5,a5,s1
    80004634:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004638:	fc042783          	lw	a5,-64(s0)
    8000463c:	07e9                	addi	a5,a5,26
    8000463e:	078e                	slli	a5,a5,0x3
    80004640:	94be                	add	s1,s1,a5
    80004642:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004646:	fd043503          	ld	a0,-48(s0)
    8000464a:	c95fe0ef          	jal	800032de <fileclose>
    fileclose(wf);
    8000464e:	fc843503          	ld	a0,-56(s0)
    80004652:	c8dfe0ef          	jal	800032de <fileclose>
    return -1;
    80004656:	57fd                	li	a5,-1
    80004658:	a01d                	j	8000467e <sys_pipe+0xd0>
    if(fd0 >= 0)
    8000465a:	fc442783          	lw	a5,-60(s0)
    8000465e:	0007c763          	bltz	a5,8000466c <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80004662:	07e9                	addi	a5,a5,26
    80004664:	078e                	slli	a5,a5,0x3
    80004666:	97a6                	add	a5,a5,s1
    80004668:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000466c:	fd043503          	ld	a0,-48(s0)
    80004670:	c6ffe0ef          	jal	800032de <fileclose>
    fileclose(wf);
    80004674:	fc843503          	ld	a0,-56(s0)
    80004678:	c67fe0ef          	jal	800032de <fileclose>
    return -1;
    8000467c:	57fd                	li	a5,-1
}
    8000467e:	853e                	mv	a0,a5
    80004680:	70e2                	ld	ra,56(sp)
    80004682:	7442                	ld	s0,48(sp)
    80004684:	74a2                	ld	s1,40(sp)
    80004686:	6121                	addi	sp,sp,64
    80004688:	8082                	ret
    8000468a:	0000                	unimp
    8000468c:	0000                	unimp
	...

0000000080004690 <kernelvec>:
    80004690:	7111                	addi	sp,sp,-256
    80004692:	e006                	sd	ra,0(sp)
    80004694:	e40a                	sd	sp,8(sp)
    80004696:	e80e                	sd	gp,16(sp)
    80004698:	ec12                	sd	tp,24(sp)
    8000469a:	f016                	sd	t0,32(sp)
    8000469c:	f41a                	sd	t1,40(sp)
    8000469e:	f81e                	sd	t2,48(sp)
    800046a0:	e4aa                	sd	a0,72(sp)
    800046a2:	e8ae                	sd	a1,80(sp)
    800046a4:	ecb2                	sd	a2,88(sp)
    800046a6:	f0b6                	sd	a3,96(sp)
    800046a8:	f4ba                	sd	a4,104(sp)
    800046aa:	f8be                	sd	a5,112(sp)
    800046ac:	fcc2                	sd	a6,120(sp)
    800046ae:	e146                	sd	a7,128(sp)
    800046b0:	edf2                	sd	t3,216(sp)
    800046b2:	f1f6                	sd	t4,224(sp)
    800046b4:	f5fa                	sd	t5,232(sp)
    800046b6:	f9fe                	sd	t6,240(sp)
    800046b8:	bdcfd0ef          	jal	80001a94 <kerneltrap>
    800046bc:	6082                	ld	ra,0(sp)
    800046be:	6122                	ld	sp,8(sp)
    800046c0:	61c2                	ld	gp,16(sp)
    800046c2:	7282                	ld	t0,32(sp)
    800046c4:	7322                	ld	t1,40(sp)
    800046c6:	73c2                	ld	t2,48(sp)
    800046c8:	6526                	ld	a0,72(sp)
    800046ca:	65c6                	ld	a1,80(sp)
    800046cc:	6666                	ld	a2,88(sp)
    800046ce:	7686                	ld	a3,96(sp)
    800046d0:	7726                	ld	a4,104(sp)
    800046d2:	77c6                	ld	a5,112(sp)
    800046d4:	7866                	ld	a6,120(sp)
    800046d6:	688a                	ld	a7,128(sp)
    800046d8:	6e6e                	ld	t3,216(sp)
    800046da:	7e8e                	ld	t4,224(sp)
    800046dc:	7f2e                	ld	t5,232(sp)
    800046de:	7fce                	ld	t6,240(sp)
    800046e0:	6111                	addi	sp,sp,256
    800046e2:	10200073          	sret
	...

00000000800046ee <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800046ee:	1141                	addi	sp,sp,-16
    800046f0:	e406                	sd	ra,8(sp)
    800046f2:	e022                	sd	s0,0(sp)
    800046f4:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800046f6:	0c000737          	lui	a4,0xc000
    800046fa:	4785                	li	a5,1
    800046fc:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800046fe:	c35c                	sw	a5,4(a4)
}
    80004700:	60a2                	ld	ra,8(sp)
    80004702:	6402                	ld	s0,0(sp)
    80004704:	0141                	addi	sp,sp,16
    80004706:	8082                	ret

0000000080004708 <plicinithart>:

void
plicinithart(void)
{
    80004708:	1141                	addi	sp,sp,-16
    8000470a:	e406                	sd	ra,8(sp)
    8000470c:	e022                	sd	s0,0(sp)
    8000470e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004710:	e18fc0ef          	jal	80000d28 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004714:	0085171b          	slliw	a4,a0,0x8
    80004718:	0c0027b7          	lui	a5,0xc002
    8000471c:	97ba                	add	a5,a5,a4
    8000471e:	40200713          	li	a4,1026
    80004722:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80004726:	00d5151b          	slliw	a0,a0,0xd
    8000472a:	0c2017b7          	lui	a5,0xc201
    8000472e:	97aa                	add	a5,a5,a0
    80004730:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80004734:	60a2                	ld	ra,8(sp)
    80004736:	6402                	ld	s0,0(sp)
    80004738:	0141                	addi	sp,sp,16
    8000473a:	8082                	ret

000000008000473c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000473c:	1141                	addi	sp,sp,-16
    8000473e:	e406                	sd	ra,8(sp)
    80004740:	e022                	sd	s0,0(sp)
    80004742:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004744:	de4fc0ef          	jal	80000d28 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80004748:	00d5151b          	slliw	a0,a0,0xd
    8000474c:	0c2017b7          	lui	a5,0xc201
    80004750:	97aa                	add	a5,a5,a0
  return irq;
}
    80004752:	43c8                	lw	a0,4(a5)
    80004754:	60a2                	ld	ra,8(sp)
    80004756:	6402                	ld	s0,0(sp)
    80004758:	0141                	addi	sp,sp,16
    8000475a:	8082                	ret

000000008000475c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000475c:	1101                	addi	sp,sp,-32
    8000475e:	ec06                	sd	ra,24(sp)
    80004760:	e822                	sd	s0,16(sp)
    80004762:	e426                	sd	s1,8(sp)
    80004764:	1000                	addi	s0,sp,32
    80004766:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004768:	dc0fc0ef          	jal	80000d28 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000476c:	00d5179b          	slliw	a5,a0,0xd
    80004770:	0c201737          	lui	a4,0xc201
    80004774:	97ba                	add	a5,a5,a4
    80004776:	c3c4                	sw	s1,4(a5)
}
    80004778:	60e2                	ld	ra,24(sp)
    8000477a:	6442                	ld	s0,16(sp)
    8000477c:	64a2                	ld	s1,8(sp)
    8000477e:	6105                	addi	sp,sp,32
    80004780:	8082                	ret

0000000080004782 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80004782:	1141                	addi	sp,sp,-16
    80004784:	e406                	sd	ra,8(sp)
    80004786:	e022                	sd	s0,0(sp)
    80004788:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000478a:	479d                	li	a5,7
    8000478c:	04a7ca63          	blt	a5,a0,800047e0 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80004790:	00014797          	auipc	a5,0x14
    80004794:	26078793          	addi	a5,a5,608 # 800189f0 <disk>
    80004798:	97aa                	add	a5,a5,a0
    8000479a:	0187c783          	lbu	a5,24(a5)
    8000479e:	e7b9                	bnez	a5,800047ec <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800047a0:	00451693          	slli	a3,a0,0x4
    800047a4:	00014797          	auipc	a5,0x14
    800047a8:	24c78793          	addi	a5,a5,588 # 800189f0 <disk>
    800047ac:	6398                	ld	a4,0(a5)
    800047ae:	9736                	add	a4,a4,a3
    800047b0:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    800047b4:	6398                	ld	a4,0(a5)
    800047b6:	9736                	add	a4,a4,a3
    800047b8:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800047bc:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800047c0:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800047c4:	97aa                	add	a5,a5,a0
    800047c6:	4705                	li	a4,1
    800047c8:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800047cc:	00014517          	auipc	a0,0x14
    800047d0:	23c50513          	addi	a0,a0,572 # 80018a08 <disk+0x18>
    800047d4:	ba3fc0ef          	jal	80001376 <wakeup>
}
    800047d8:	60a2                	ld	ra,8(sp)
    800047da:	6402                	ld	s0,0(sp)
    800047dc:	0141                	addi	sp,sp,16
    800047de:	8082                	ret
    panic("free_desc 1");
    800047e0:	00003517          	auipc	a0,0x3
    800047e4:	e3050513          	addi	a0,a0,-464 # 80007610 <etext+0x610>
    800047e8:	40f000ef          	jal	800053f6 <panic>
    panic("free_desc 2");
    800047ec:	00003517          	auipc	a0,0x3
    800047f0:	e3450513          	addi	a0,a0,-460 # 80007620 <etext+0x620>
    800047f4:	403000ef          	jal	800053f6 <panic>

00000000800047f8 <virtio_disk_init>:
{
    800047f8:	1101                	addi	sp,sp,-32
    800047fa:	ec06                	sd	ra,24(sp)
    800047fc:	e822                	sd	s0,16(sp)
    800047fe:	e426                	sd	s1,8(sp)
    80004800:	e04a                	sd	s2,0(sp)
    80004802:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004804:	00003597          	auipc	a1,0x3
    80004808:	e2c58593          	addi	a1,a1,-468 # 80007630 <etext+0x630>
    8000480c:	00014517          	auipc	a0,0x14
    80004810:	30c50513          	addi	a0,a0,780 # 80018b18 <disk+0x128>
    80004814:	68d000ef          	jal	800056a0 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004818:	100017b7          	lui	a5,0x10001
    8000481c:	4398                	lw	a4,0(a5)
    8000481e:	2701                	sext.w	a4,a4
    80004820:	747277b7          	lui	a5,0x74727
    80004824:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004828:	14f71863          	bne	a4,a5,80004978 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000482c:	100017b7          	lui	a5,0x10001
    80004830:	43dc                	lw	a5,4(a5)
    80004832:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004834:	4709                	li	a4,2
    80004836:	14e79163          	bne	a5,a4,80004978 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000483a:	100017b7          	lui	a5,0x10001
    8000483e:	479c                	lw	a5,8(a5)
    80004840:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004842:	12e79b63          	bne	a5,a4,80004978 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80004846:	100017b7          	lui	a5,0x10001
    8000484a:	47d8                	lw	a4,12(a5)
    8000484c:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000484e:	554d47b7          	lui	a5,0x554d4
    80004852:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80004856:	12f71163          	bne	a4,a5,80004978 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000485a:	100017b7          	lui	a5,0x10001
    8000485e:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004862:	4705                	li	a4,1
    80004864:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004866:	470d                	li	a4,3
    80004868:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000486a:	10001737          	lui	a4,0x10001
    8000486e:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004870:	c7ffe6b7          	lui	a3,0xc7ffe
    80004874:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fddb2f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80004878:	8f75                	and	a4,a4,a3
    8000487a:	100016b7          	lui	a3,0x10001
    8000487e:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004880:	472d                	li	a4,11
    80004882:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004884:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80004888:	439c                	lw	a5,0(a5)
    8000488a:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    8000488e:	8ba1                	andi	a5,a5,8
    80004890:	0e078a63          	beqz	a5,80004984 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004894:	100017b7          	lui	a5,0x10001
    80004898:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    8000489c:	43fc                	lw	a5,68(a5)
    8000489e:	2781                	sext.w	a5,a5
    800048a0:	0e079863          	bnez	a5,80004990 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800048a4:	100017b7          	lui	a5,0x10001
    800048a8:	5bdc                	lw	a5,52(a5)
    800048aa:	2781                	sext.w	a5,a5
  if(max == 0)
    800048ac:	0e078863          	beqz	a5,8000499c <virtio_disk_init+0x1a4>
  if(max < NUM)
    800048b0:	471d                	li	a4,7
    800048b2:	0ef77b63          	bgeu	a4,a5,800049a8 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    800048b6:	849fb0ef          	jal	800000fe <kalloc>
    800048ba:	00014497          	auipc	s1,0x14
    800048be:	13648493          	addi	s1,s1,310 # 800189f0 <disk>
    800048c2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800048c4:	83bfb0ef          	jal	800000fe <kalloc>
    800048c8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800048ca:	835fb0ef          	jal	800000fe <kalloc>
    800048ce:	87aa                	mv	a5,a0
    800048d0:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800048d2:	6088                	ld	a0,0(s1)
    800048d4:	0e050063          	beqz	a0,800049b4 <virtio_disk_init+0x1bc>
    800048d8:	00014717          	auipc	a4,0x14
    800048dc:	12073703          	ld	a4,288(a4) # 800189f8 <disk+0x8>
    800048e0:	cb71                	beqz	a4,800049b4 <virtio_disk_init+0x1bc>
    800048e2:	cbe9                	beqz	a5,800049b4 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    800048e4:	6605                	lui	a2,0x1
    800048e6:	4581                	li	a1,0
    800048e8:	867fb0ef          	jal	8000014e <memset>
  memset(disk.avail, 0, PGSIZE);
    800048ec:	00014497          	auipc	s1,0x14
    800048f0:	10448493          	addi	s1,s1,260 # 800189f0 <disk>
    800048f4:	6605                	lui	a2,0x1
    800048f6:	4581                	li	a1,0
    800048f8:	6488                	ld	a0,8(s1)
    800048fa:	855fb0ef          	jal	8000014e <memset>
  memset(disk.used, 0, PGSIZE);
    800048fe:	6605                	lui	a2,0x1
    80004900:	4581                	li	a1,0
    80004902:	6888                	ld	a0,16(s1)
    80004904:	84bfb0ef          	jal	8000014e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80004908:	100017b7          	lui	a5,0x10001
    8000490c:	4721                	li	a4,8
    8000490e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004910:	4098                	lw	a4,0(s1)
    80004912:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004916:	40d8                	lw	a4,4(s1)
    80004918:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000491c:	649c                	ld	a5,8(s1)
    8000491e:	0007869b          	sext.w	a3,a5
    80004922:	10001737          	lui	a4,0x10001
    80004926:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    8000492a:	9781                	srai	a5,a5,0x20
    8000492c:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004930:	689c                	ld	a5,16(s1)
    80004932:	0007869b          	sext.w	a3,a5
    80004936:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000493a:	9781                	srai	a5,a5,0x20
    8000493c:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004940:	4785                	li	a5,1
    80004942:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004944:	00f48c23          	sb	a5,24(s1)
    80004948:	00f48ca3          	sb	a5,25(s1)
    8000494c:	00f48d23          	sb	a5,26(s1)
    80004950:	00f48da3          	sb	a5,27(s1)
    80004954:	00f48e23          	sb	a5,28(s1)
    80004958:	00f48ea3          	sb	a5,29(s1)
    8000495c:	00f48f23          	sb	a5,30(s1)
    80004960:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004964:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004968:	07272823          	sw	s2,112(a4)
}
    8000496c:	60e2                	ld	ra,24(sp)
    8000496e:	6442                	ld	s0,16(sp)
    80004970:	64a2                	ld	s1,8(sp)
    80004972:	6902                	ld	s2,0(sp)
    80004974:	6105                	addi	sp,sp,32
    80004976:	8082                	ret
    panic("could not find virtio disk");
    80004978:	00003517          	auipc	a0,0x3
    8000497c:	cc850513          	addi	a0,a0,-824 # 80007640 <etext+0x640>
    80004980:	277000ef          	jal	800053f6 <panic>
    panic("virtio disk FEATURES_OK unset");
    80004984:	00003517          	auipc	a0,0x3
    80004988:	cdc50513          	addi	a0,a0,-804 # 80007660 <etext+0x660>
    8000498c:	26b000ef          	jal	800053f6 <panic>
    panic("virtio disk should not be ready");
    80004990:	00003517          	auipc	a0,0x3
    80004994:	cf050513          	addi	a0,a0,-784 # 80007680 <etext+0x680>
    80004998:	25f000ef          	jal	800053f6 <panic>
    panic("virtio disk has no queue 0");
    8000499c:	00003517          	auipc	a0,0x3
    800049a0:	d0450513          	addi	a0,a0,-764 # 800076a0 <etext+0x6a0>
    800049a4:	253000ef          	jal	800053f6 <panic>
    panic("virtio disk max queue too short");
    800049a8:	00003517          	auipc	a0,0x3
    800049ac:	d1850513          	addi	a0,a0,-744 # 800076c0 <etext+0x6c0>
    800049b0:	247000ef          	jal	800053f6 <panic>
    panic("virtio disk kalloc");
    800049b4:	00003517          	auipc	a0,0x3
    800049b8:	d2c50513          	addi	a0,a0,-724 # 800076e0 <etext+0x6e0>
    800049bc:	23b000ef          	jal	800053f6 <panic>

00000000800049c0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800049c0:	711d                	addi	sp,sp,-96
    800049c2:	ec86                	sd	ra,88(sp)
    800049c4:	e8a2                	sd	s0,80(sp)
    800049c6:	e4a6                	sd	s1,72(sp)
    800049c8:	e0ca                	sd	s2,64(sp)
    800049ca:	fc4e                	sd	s3,56(sp)
    800049cc:	f852                	sd	s4,48(sp)
    800049ce:	f456                	sd	s5,40(sp)
    800049d0:	f05a                	sd	s6,32(sp)
    800049d2:	ec5e                	sd	s7,24(sp)
    800049d4:	e862                	sd	s8,16(sp)
    800049d6:	1080                	addi	s0,sp,96
    800049d8:	89aa                	mv	s3,a0
    800049da:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800049dc:	00c52b83          	lw	s7,12(a0)
    800049e0:	001b9b9b          	slliw	s7,s7,0x1
    800049e4:	1b82                	slli	s7,s7,0x20
    800049e6:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    800049ea:	00014517          	auipc	a0,0x14
    800049ee:	12e50513          	addi	a0,a0,302 # 80018b18 <disk+0x128>
    800049f2:	533000ef          	jal	80005724 <acquire>
  for(int i = 0; i < NUM; i++){
    800049f6:	44a1                	li	s1,8
      disk.free[i] = 0;
    800049f8:	00014a97          	auipc	s5,0x14
    800049fc:	ff8a8a93          	addi	s5,s5,-8 # 800189f0 <disk>
  for(int i = 0; i < 3; i++){
    80004a00:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80004a02:	5c7d                	li	s8,-1
    80004a04:	a095                	j	80004a68 <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    80004a06:	00fa8733          	add	a4,s5,a5
    80004a0a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80004a0e:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004a10:	0207c563          	bltz	a5,80004a3a <virtio_disk_rw+0x7a>
  for(int i = 0; i < 3; i++){
    80004a14:	2905                	addiw	s2,s2,1
    80004a16:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004a18:	05490c63          	beq	s2,s4,80004a70 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    80004a1c:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004a1e:	00014717          	auipc	a4,0x14
    80004a22:	fd270713          	addi	a4,a4,-46 # 800189f0 <disk>
    80004a26:	4781                	li	a5,0
    if(disk.free[i]){
    80004a28:	01874683          	lbu	a3,24(a4)
    80004a2c:	fee9                	bnez	a3,80004a06 <virtio_disk_rw+0x46>
  for(int i = 0; i < NUM; i++){
    80004a2e:	2785                	addiw	a5,a5,1
    80004a30:	0705                	addi	a4,a4,1
    80004a32:	fe979be3          	bne	a5,s1,80004a28 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    80004a36:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    80004a3a:	01205d63          	blez	s2,80004a54 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80004a3e:	fa042503          	lw	a0,-96(s0)
    80004a42:	d41ff0ef          	jal	80004782 <free_desc>
      for(int j = 0; j < i; j++)
    80004a46:	4785                	li	a5,1
    80004a48:	0127d663          	bge	a5,s2,80004a54 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80004a4c:	fa442503          	lw	a0,-92(s0)
    80004a50:	d33ff0ef          	jal	80004782 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004a54:	00014597          	auipc	a1,0x14
    80004a58:	0c458593          	addi	a1,a1,196 # 80018b18 <disk+0x128>
    80004a5c:	00014517          	auipc	a0,0x14
    80004a60:	fac50513          	addi	a0,a0,-84 # 80018a08 <disk+0x18>
    80004a64:	8c7fc0ef          	jal	8000132a <sleep>
  for(int i = 0; i < 3; i++){
    80004a68:	fa040613          	addi	a2,s0,-96
    80004a6c:	4901                	li	s2,0
    80004a6e:	b77d                	j	80004a1c <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004a70:	fa042503          	lw	a0,-96(s0)
    80004a74:	00451693          	slli	a3,a0,0x4

  if(write)
    80004a78:	00014797          	auipc	a5,0x14
    80004a7c:	f7878793          	addi	a5,a5,-136 # 800189f0 <disk>
    80004a80:	00a50713          	addi	a4,a0,10
    80004a84:	0712                	slli	a4,a4,0x4
    80004a86:	973e                	add	a4,a4,a5
    80004a88:	01603633          	snez	a2,s6
    80004a8c:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004a8e:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004a92:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004a96:	6398                	ld	a4,0(a5)
    80004a98:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004a9a:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80004a9e:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004aa0:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004aa2:	6390                	ld	a2,0(a5)
    80004aa4:	00d605b3          	add	a1,a2,a3
    80004aa8:	4741                	li	a4,16
    80004aaa:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004aac:	4805                	li	a6,1
    80004aae:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80004ab2:	fa442703          	lw	a4,-92(s0)
    80004ab6:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004aba:	0712                	slli	a4,a4,0x4
    80004abc:	963a                	add	a2,a2,a4
    80004abe:	05898593          	addi	a1,s3,88
    80004ac2:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004ac4:	0007b883          	ld	a7,0(a5)
    80004ac8:	9746                	add	a4,a4,a7
    80004aca:	40000613          	li	a2,1024
    80004ace:	c710                	sw	a2,8(a4)
  if(write)
    80004ad0:	001b3613          	seqz	a2,s6
    80004ad4:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004ad8:	01066633          	or	a2,a2,a6
    80004adc:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004ae0:	fa842583          	lw	a1,-88(s0)
    80004ae4:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004ae8:	00250613          	addi	a2,a0,2
    80004aec:	0612                	slli	a2,a2,0x4
    80004aee:	963e                	add	a2,a2,a5
    80004af0:	577d                	li	a4,-1
    80004af2:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004af6:	0592                	slli	a1,a1,0x4
    80004af8:	98ae                	add	a7,a7,a1
    80004afa:	03068713          	addi	a4,a3,48
    80004afe:	973e                	add	a4,a4,a5
    80004b00:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004b04:	6398                	ld	a4,0(a5)
    80004b06:	972e                	add	a4,a4,a1
    80004b08:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004b0c:	4689                	li	a3,2
    80004b0e:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004b12:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004b16:	0109a223          	sw	a6,4(s3)
  disk.info[idx[0]].b = b;
    80004b1a:	01363423          	sd	s3,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004b1e:	6794                	ld	a3,8(a5)
    80004b20:	0026d703          	lhu	a4,2(a3)
    80004b24:	8b1d                	andi	a4,a4,7
    80004b26:	0706                	slli	a4,a4,0x1
    80004b28:	96ba                	add	a3,a3,a4
    80004b2a:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004b2e:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004b32:	6798                	ld	a4,8(a5)
    80004b34:	00275783          	lhu	a5,2(a4)
    80004b38:	2785                	addiw	a5,a5,1
    80004b3a:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004b3e:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004b42:	100017b7          	lui	a5,0x10001
    80004b46:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004b4a:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80004b4e:	00014917          	auipc	s2,0x14
    80004b52:	fca90913          	addi	s2,s2,-54 # 80018b18 <disk+0x128>
  while(b->disk == 1) {
    80004b56:	84c2                	mv	s1,a6
    80004b58:	01079a63          	bne	a5,a6,80004b6c <virtio_disk_rw+0x1ac>
    sleep(b, &disk.vdisk_lock);
    80004b5c:	85ca                	mv	a1,s2
    80004b5e:	854e                	mv	a0,s3
    80004b60:	fcafc0ef          	jal	8000132a <sleep>
  while(b->disk == 1) {
    80004b64:	0049a783          	lw	a5,4(s3)
    80004b68:	fe978ae3          	beq	a5,s1,80004b5c <virtio_disk_rw+0x19c>
  }

  disk.info[idx[0]].b = 0;
    80004b6c:	fa042903          	lw	s2,-96(s0)
    80004b70:	00290713          	addi	a4,s2,2
    80004b74:	0712                	slli	a4,a4,0x4
    80004b76:	00014797          	auipc	a5,0x14
    80004b7a:	e7a78793          	addi	a5,a5,-390 # 800189f0 <disk>
    80004b7e:	97ba                	add	a5,a5,a4
    80004b80:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004b84:	00014997          	auipc	s3,0x14
    80004b88:	e6c98993          	addi	s3,s3,-404 # 800189f0 <disk>
    80004b8c:	00491713          	slli	a4,s2,0x4
    80004b90:	0009b783          	ld	a5,0(s3)
    80004b94:	97ba                	add	a5,a5,a4
    80004b96:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004b9a:	854a                	mv	a0,s2
    80004b9c:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004ba0:	be3ff0ef          	jal	80004782 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004ba4:	8885                	andi	s1,s1,1
    80004ba6:	f0fd                	bnez	s1,80004b8c <virtio_disk_rw+0x1cc>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004ba8:	00014517          	auipc	a0,0x14
    80004bac:	f7050513          	addi	a0,a0,-144 # 80018b18 <disk+0x128>
    80004bb0:	409000ef          	jal	800057b8 <release>
}
    80004bb4:	60e6                	ld	ra,88(sp)
    80004bb6:	6446                	ld	s0,80(sp)
    80004bb8:	64a6                	ld	s1,72(sp)
    80004bba:	6906                	ld	s2,64(sp)
    80004bbc:	79e2                	ld	s3,56(sp)
    80004bbe:	7a42                	ld	s4,48(sp)
    80004bc0:	7aa2                	ld	s5,40(sp)
    80004bc2:	7b02                	ld	s6,32(sp)
    80004bc4:	6be2                	ld	s7,24(sp)
    80004bc6:	6c42                	ld	s8,16(sp)
    80004bc8:	6125                	addi	sp,sp,96
    80004bca:	8082                	ret

0000000080004bcc <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004bcc:	1101                	addi	sp,sp,-32
    80004bce:	ec06                	sd	ra,24(sp)
    80004bd0:	e822                	sd	s0,16(sp)
    80004bd2:	e426                	sd	s1,8(sp)
    80004bd4:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004bd6:	00014497          	auipc	s1,0x14
    80004bda:	e1a48493          	addi	s1,s1,-486 # 800189f0 <disk>
    80004bde:	00014517          	auipc	a0,0x14
    80004be2:	f3a50513          	addi	a0,a0,-198 # 80018b18 <disk+0x128>
    80004be6:	33f000ef          	jal	80005724 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004bea:	100017b7          	lui	a5,0x10001
    80004bee:	53bc                	lw	a5,96(a5)
    80004bf0:	8b8d                	andi	a5,a5,3
    80004bf2:	10001737          	lui	a4,0x10001
    80004bf6:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80004bf8:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004bfc:	689c                	ld	a5,16(s1)
    80004bfe:	0204d703          	lhu	a4,32(s1)
    80004c02:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80004c06:	04f70663          	beq	a4,a5,80004c52 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80004c0a:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004c0e:	6898                	ld	a4,16(s1)
    80004c10:	0204d783          	lhu	a5,32(s1)
    80004c14:	8b9d                	andi	a5,a5,7
    80004c16:	078e                	slli	a5,a5,0x3
    80004c18:	97ba                	add	a5,a5,a4
    80004c1a:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004c1c:	00278713          	addi	a4,a5,2
    80004c20:	0712                	slli	a4,a4,0x4
    80004c22:	9726                	add	a4,a4,s1
    80004c24:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80004c28:	e321                	bnez	a4,80004c68 <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004c2a:	0789                	addi	a5,a5,2
    80004c2c:	0792                	slli	a5,a5,0x4
    80004c2e:	97a6                	add	a5,a5,s1
    80004c30:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004c32:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004c36:	f40fc0ef          	jal	80001376 <wakeup>

    disk.used_idx += 1;
    80004c3a:	0204d783          	lhu	a5,32(s1)
    80004c3e:	2785                	addiw	a5,a5,1
    80004c40:	17c2                	slli	a5,a5,0x30
    80004c42:	93c1                	srli	a5,a5,0x30
    80004c44:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004c48:	6898                	ld	a4,16(s1)
    80004c4a:	00275703          	lhu	a4,2(a4)
    80004c4e:	faf71ee3          	bne	a4,a5,80004c0a <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80004c52:	00014517          	auipc	a0,0x14
    80004c56:	ec650513          	addi	a0,a0,-314 # 80018b18 <disk+0x128>
    80004c5a:	35f000ef          	jal	800057b8 <release>
}
    80004c5e:	60e2                	ld	ra,24(sp)
    80004c60:	6442                	ld	s0,16(sp)
    80004c62:	64a2                	ld	s1,8(sp)
    80004c64:	6105                	addi	sp,sp,32
    80004c66:	8082                	ret
      panic("virtio_disk_intr status");
    80004c68:	00003517          	auipc	a0,0x3
    80004c6c:	a9050513          	addi	a0,a0,-1392 # 800076f8 <etext+0x6f8>
    80004c70:	786000ef          	jal	800053f6 <panic>

0000000080004c74 <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80004c74:	1141                	addi	sp,sp,-16
    80004c76:	e406                	sd	ra,8(sp)
    80004c78:	e022                	sd	s0,0(sp)
    80004c7a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80004c7c:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80004c80:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80004c84:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80004c88:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80004c8c:	577d                	li	a4,-1
    80004c8e:	177e                	slli	a4,a4,0x3f
    80004c90:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80004c92:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80004c96:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80004c9a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80004c9e:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80004ca2:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80004ca6:	000f4737          	lui	a4,0xf4
    80004caa:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80004cae:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80004cb0:	14d79073          	csrw	stimecmp,a5
}
    80004cb4:	60a2                	ld	ra,8(sp)
    80004cb6:	6402                	ld	s0,0(sp)
    80004cb8:	0141                	addi	sp,sp,16
    80004cba:	8082                	ret

0000000080004cbc <start>:
{
    80004cbc:	1141                	addi	sp,sp,-16
    80004cbe:	e406                	sd	ra,8(sp)
    80004cc0:	e022                	sd	s0,0(sp)
    80004cc2:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80004cc4:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80004cc8:	7779                	lui	a4,0xffffe
    80004cca:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffddbcf>
    80004cce:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80004cd0:	6705                	lui	a4,0x1
    80004cd2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80004cd6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80004cd8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80004cdc:	ffffb797          	auipc	a5,0xffffb
    80004ce0:	62878793          	addi	a5,a5,1576 # 80000304 <main>
    80004ce4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80004ce8:	4781                	li	a5,0
    80004cea:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80004cee:	67c1                	lui	a5,0x10
    80004cf0:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80004cf2:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80004cf6:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80004cfa:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80004cfe:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80004d02:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80004d06:	57fd                	li	a5,-1
    80004d08:	83a9                	srli	a5,a5,0xa
    80004d0a:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80004d0e:	47bd                	li	a5,15
    80004d10:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80004d14:	f61ff0ef          	jal	80004c74 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80004d18:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80004d1c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80004d1e:	823e                	mv	tp,a5
  asm volatile("mret");
    80004d20:	30200073          	mret
}
    80004d24:	60a2                	ld	ra,8(sp)
    80004d26:	6402                	ld	s0,0(sp)
    80004d28:	0141                	addi	sp,sp,16
    80004d2a:	8082                	ret

0000000080004d2c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80004d2c:	711d                	addi	sp,sp,-96
    80004d2e:	ec86                	sd	ra,88(sp)
    80004d30:	e8a2                	sd	s0,80(sp)
    80004d32:	e0ca                	sd	s2,64(sp)
    80004d34:	1080                	addi	s0,sp,96
  int i;

  for(i = 0; i < n; i++){
    80004d36:	04c05863          	blez	a2,80004d86 <consolewrite+0x5a>
    80004d3a:	e4a6                	sd	s1,72(sp)
    80004d3c:	fc4e                	sd	s3,56(sp)
    80004d3e:	f852                	sd	s4,48(sp)
    80004d40:	f456                	sd	s5,40(sp)
    80004d42:	f05a                	sd	s6,32(sp)
    80004d44:	ec5e                	sd	s7,24(sp)
    80004d46:	8a2a                	mv	s4,a0
    80004d48:	84ae                	mv	s1,a1
    80004d4a:	89b2                	mv	s3,a2
    80004d4c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80004d4e:	faf40b93          	addi	s7,s0,-81
    80004d52:	4b05                	li	s6,1
    80004d54:	5afd                	li	s5,-1
    80004d56:	86da                	mv	a3,s6
    80004d58:	8626                	mv	a2,s1
    80004d5a:	85d2                	mv	a1,s4
    80004d5c:	855e                	mv	a0,s7
    80004d5e:	96dfc0ef          	jal	800016ca <either_copyin>
    80004d62:	03550463          	beq	a0,s5,80004d8a <consolewrite+0x5e>
      break;
    uartputc(c);
    80004d66:	faf44503          	lbu	a0,-81(s0)
    80004d6a:	02d000ef          	jal	80005596 <uartputc>
  for(i = 0; i < n; i++){
    80004d6e:	2905                	addiw	s2,s2,1
    80004d70:	0485                	addi	s1,s1,1
    80004d72:	ff2992e3          	bne	s3,s2,80004d56 <consolewrite+0x2a>
    80004d76:	894e                	mv	s2,s3
    80004d78:	64a6                	ld	s1,72(sp)
    80004d7a:	79e2                	ld	s3,56(sp)
    80004d7c:	7a42                	ld	s4,48(sp)
    80004d7e:	7aa2                	ld	s5,40(sp)
    80004d80:	7b02                	ld	s6,32(sp)
    80004d82:	6be2                	ld	s7,24(sp)
    80004d84:	a809                	j	80004d96 <consolewrite+0x6a>
    80004d86:	4901                	li	s2,0
    80004d88:	a039                	j	80004d96 <consolewrite+0x6a>
    80004d8a:	64a6                	ld	s1,72(sp)
    80004d8c:	79e2                	ld	s3,56(sp)
    80004d8e:	7a42                	ld	s4,48(sp)
    80004d90:	7aa2                	ld	s5,40(sp)
    80004d92:	7b02                	ld	s6,32(sp)
    80004d94:	6be2                	ld	s7,24(sp)
  }

  return i;
}
    80004d96:	854a                	mv	a0,s2
    80004d98:	60e6                	ld	ra,88(sp)
    80004d9a:	6446                	ld	s0,80(sp)
    80004d9c:	6906                	ld	s2,64(sp)
    80004d9e:	6125                	addi	sp,sp,96
    80004da0:	8082                	ret

0000000080004da2 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80004da2:	711d                	addi	sp,sp,-96
    80004da4:	ec86                	sd	ra,88(sp)
    80004da6:	e8a2                	sd	s0,80(sp)
    80004da8:	e4a6                	sd	s1,72(sp)
    80004daa:	e0ca                	sd	s2,64(sp)
    80004dac:	fc4e                	sd	s3,56(sp)
    80004dae:	f852                	sd	s4,48(sp)
    80004db0:	f456                	sd	s5,40(sp)
    80004db2:	f05a                	sd	s6,32(sp)
    80004db4:	1080                	addi	s0,sp,96
    80004db6:	8aaa                	mv	s5,a0
    80004db8:	8a2e                	mv	s4,a1
    80004dba:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80004dbc:	8b32                	mv	s6,a2
  acquire(&cons.lock);
    80004dbe:	0001c517          	auipc	a0,0x1c
    80004dc2:	d7250513          	addi	a0,a0,-654 # 80020b30 <cons>
    80004dc6:	15f000ef          	jal	80005724 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80004dca:	0001c497          	auipc	s1,0x1c
    80004dce:	d6648493          	addi	s1,s1,-666 # 80020b30 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80004dd2:	0001c917          	auipc	s2,0x1c
    80004dd6:	df690913          	addi	s2,s2,-522 # 80020bc8 <cons+0x98>
  while(n > 0){
    80004dda:	0b305b63          	blez	s3,80004e90 <consoleread+0xee>
    while(cons.r == cons.w){
    80004dde:	0984a783          	lw	a5,152(s1)
    80004de2:	09c4a703          	lw	a4,156(s1)
    80004de6:	0af71063          	bne	a4,a5,80004e86 <consoleread+0xe4>
      if(killed(myproc())){
    80004dea:	f73fb0ef          	jal	80000d5c <myproc>
    80004dee:	f74fc0ef          	jal	80001562 <killed>
    80004df2:	e12d                	bnez	a0,80004e54 <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    80004df4:	85a6                	mv	a1,s1
    80004df6:	854a                	mv	a0,s2
    80004df8:	d32fc0ef          	jal	8000132a <sleep>
    while(cons.r == cons.w){
    80004dfc:	0984a783          	lw	a5,152(s1)
    80004e00:	09c4a703          	lw	a4,156(s1)
    80004e04:	fef703e3          	beq	a4,a5,80004dea <consoleread+0x48>
    80004e08:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80004e0a:	0001c717          	auipc	a4,0x1c
    80004e0e:	d2670713          	addi	a4,a4,-730 # 80020b30 <cons>
    80004e12:	0017869b          	addiw	a3,a5,1
    80004e16:	08d72c23          	sw	a3,152(a4)
    80004e1a:	07f7f693          	andi	a3,a5,127
    80004e1e:	9736                	add	a4,a4,a3
    80004e20:	01874703          	lbu	a4,24(a4)
    80004e24:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80004e28:	4691                	li	a3,4
    80004e2a:	04db8663          	beq	s7,a3,80004e76 <consoleread+0xd4>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80004e2e:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80004e32:	4685                	li	a3,1
    80004e34:	faf40613          	addi	a2,s0,-81
    80004e38:	85d2                	mv	a1,s4
    80004e3a:	8556                	mv	a0,s5
    80004e3c:	845fc0ef          	jal	80001680 <either_copyout>
    80004e40:	57fd                	li	a5,-1
    80004e42:	04f50663          	beq	a0,a5,80004e8e <consoleread+0xec>
      break;

    dst++;
    80004e46:	0a05                	addi	s4,s4,1
    --n;
    80004e48:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80004e4a:	47a9                	li	a5,10
    80004e4c:	04fb8b63          	beq	s7,a5,80004ea2 <consoleread+0x100>
    80004e50:	6be2                	ld	s7,24(sp)
    80004e52:	b761                	j	80004dda <consoleread+0x38>
        release(&cons.lock);
    80004e54:	0001c517          	auipc	a0,0x1c
    80004e58:	cdc50513          	addi	a0,a0,-804 # 80020b30 <cons>
    80004e5c:	15d000ef          	jal	800057b8 <release>
        return -1;
    80004e60:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80004e62:	60e6                	ld	ra,88(sp)
    80004e64:	6446                	ld	s0,80(sp)
    80004e66:	64a6                	ld	s1,72(sp)
    80004e68:	6906                	ld	s2,64(sp)
    80004e6a:	79e2                	ld	s3,56(sp)
    80004e6c:	7a42                	ld	s4,48(sp)
    80004e6e:	7aa2                	ld	s5,40(sp)
    80004e70:	7b02                	ld	s6,32(sp)
    80004e72:	6125                	addi	sp,sp,96
    80004e74:	8082                	ret
      if(n < target){
    80004e76:	0169fa63          	bgeu	s3,s6,80004e8a <consoleread+0xe8>
        cons.r--;
    80004e7a:	0001c717          	auipc	a4,0x1c
    80004e7e:	d4f72723          	sw	a5,-690(a4) # 80020bc8 <cons+0x98>
    80004e82:	6be2                	ld	s7,24(sp)
    80004e84:	a031                	j	80004e90 <consoleread+0xee>
    80004e86:	ec5e                	sd	s7,24(sp)
    80004e88:	b749                	j	80004e0a <consoleread+0x68>
    80004e8a:	6be2                	ld	s7,24(sp)
    80004e8c:	a011                	j	80004e90 <consoleread+0xee>
    80004e8e:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80004e90:	0001c517          	auipc	a0,0x1c
    80004e94:	ca050513          	addi	a0,a0,-864 # 80020b30 <cons>
    80004e98:	121000ef          	jal	800057b8 <release>
  return target - n;
    80004e9c:	413b053b          	subw	a0,s6,s3
    80004ea0:	b7c9                	j	80004e62 <consoleread+0xc0>
    80004ea2:	6be2                	ld	s7,24(sp)
    80004ea4:	b7f5                	j	80004e90 <consoleread+0xee>

0000000080004ea6 <consputc>:
{
    80004ea6:	1141                	addi	sp,sp,-16
    80004ea8:	e406                	sd	ra,8(sp)
    80004eaa:	e022                	sd	s0,0(sp)
    80004eac:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80004eae:	10000793          	li	a5,256
    80004eb2:	00f50863          	beq	a0,a5,80004ec2 <consputc+0x1c>
    uartputc_sync(c);
    80004eb6:	5fe000ef          	jal	800054b4 <uartputc_sync>
}
    80004eba:	60a2                	ld	ra,8(sp)
    80004ebc:	6402                	ld	s0,0(sp)
    80004ebe:	0141                	addi	sp,sp,16
    80004ec0:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80004ec2:	4521                	li	a0,8
    80004ec4:	5f0000ef          	jal	800054b4 <uartputc_sync>
    80004ec8:	02000513          	li	a0,32
    80004ecc:	5e8000ef          	jal	800054b4 <uartputc_sync>
    80004ed0:	4521                	li	a0,8
    80004ed2:	5e2000ef          	jal	800054b4 <uartputc_sync>
    80004ed6:	b7d5                	j	80004eba <consputc+0x14>

0000000080004ed8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80004ed8:	7179                	addi	sp,sp,-48
    80004eda:	f406                	sd	ra,40(sp)
    80004edc:	f022                	sd	s0,32(sp)
    80004ede:	ec26                	sd	s1,24(sp)
    80004ee0:	1800                	addi	s0,sp,48
    80004ee2:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80004ee4:	0001c517          	auipc	a0,0x1c
    80004ee8:	c4c50513          	addi	a0,a0,-948 # 80020b30 <cons>
    80004eec:	039000ef          	jal	80005724 <acquire>

  switch(c){
    80004ef0:	47d5                	li	a5,21
    80004ef2:	08f48e63          	beq	s1,a5,80004f8e <consoleintr+0xb6>
    80004ef6:	0297c563          	blt	a5,s1,80004f20 <consoleintr+0x48>
    80004efa:	47a1                	li	a5,8
    80004efc:	0ef48863          	beq	s1,a5,80004fec <consoleintr+0x114>
    80004f00:	47c1                	li	a5,16
    80004f02:	10f49963          	bne	s1,a5,80005014 <consoleintr+0x13c>
  case C('P'):  // Print process list.
    procdump();
    80004f06:	80ffc0ef          	jal	80001714 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80004f0a:	0001c517          	auipc	a0,0x1c
    80004f0e:	c2650513          	addi	a0,a0,-986 # 80020b30 <cons>
    80004f12:	0a7000ef          	jal	800057b8 <release>
}
    80004f16:	70a2                	ld	ra,40(sp)
    80004f18:	7402                	ld	s0,32(sp)
    80004f1a:	64e2                	ld	s1,24(sp)
    80004f1c:	6145                	addi	sp,sp,48
    80004f1e:	8082                	ret
  switch(c){
    80004f20:	07f00793          	li	a5,127
    80004f24:	0cf48463          	beq	s1,a5,80004fec <consoleintr+0x114>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80004f28:	0001c717          	auipc	a4,0x1c
    80004f2c:	c0870713          	addi	a4,a4,-1016 # 80020b30 <cons>
    80004f30:	0a072783          	lw	a5,160(a4)
    80004f34:	09872703          	lw	a4,152(a4)
    80004f38:	9f99                	subw	a5,a5,a4
    80004f3a:	07f00713          	li	a4,127
    80004f3e:	fcf766e3          	bltu	a4,a5,80004f0a <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80004f42:	47b5                	li	a5,13
    80004f44:	0cf48b63          	beq	s1,a5,8000501a <consoleintr+0x142>
      consputc(c);
    80004f48:	8526                	mv	a0,s1
    80004f4a:	f5dff0ef          	jal	80004ea6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80004f4e:	0001c797          	auipc	a5,0x1c
    80004f52:	be278793          	addi	a5,a5,-1054 # 80020b30 <cons>
    80004f56:	0a07a683          	lw	a3,160(a5)
    80004f5a:	0016871b          	addiw	a4,a3,1
    80004f5e:	863a                	mv	a2,a4
    80004f60:	0ae7a023          	sw	a4,160(a5)
    80004f64:	07f6f693          	andi	a3,a3,127
    80004f68:	97b6                	add	a5,a5,a3
    80004f6a:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80004f6e:	47a9                	li	a5,10
    80004f70:	0cf48963          	beq	s1,a5,80005042 <consoleintr+0x16a>
    80004f74:	4791                	li	a5,4
    80004f76:	0cf48663          	beq	s1,a5,80005042 <consoleintr+0x16a>
    80004f7a:	0001c797          	auipc	a5,0x1c
    80004f7e:	c4e7a783          	lw	a5,-946(a5) # 80020bc8 <cons+0x98>
    80004f82:	9f1d                	subw	a4,a4,a5
    80004f84:	08000793          	li	a5,128
    80004f88:	f8f711e3          	bne	a4,a5,80004f0a <consoleintr+0x32>
    80004f8c:	a85d                	j	80005042 <consoleintr+0x16a>
    80004f8e:	e84a                	sd	s2,16(sp)
    80004f90:	e44e                	sd	s3,8(sp)
    while(cons.e != cons.w &&
    80004f92:	0001c717          	auipc	a4,0x1c
    80004f96:	b9e70713          	addi	a4,a4,-1122 # 80020b30 <cons>
    80004f9a:	0a072783          	lw	a5,160(a4)
    80004f9e:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80004fa2:	0001c497          	auipc	s1,0x1c
    80004fa6:	b8e48493          	addi	s1,s1,-1138 # 80020b30 <cons>
    while(cons.e != cons.w &&
    80004faa:	4929                	li	s2,10
      consputc(BACKSPACE);
    80004fac:	10000993          	li	s3,256
    while(cons.e != cons.w &&
    80004fb0:	02f70863          	beq	a4,a5,80004fe0 <consoleintr+0x108>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80004fb4:	37fd                	addiw	a5,a5,-1
    80004fb6:	07f7f713          	andi	a4,a5,127
    80004fba:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80004fbc:	01874703          	lbu	a4,24(a4)
    80004fc0:	03270363          	beq	a4,s2,80004fe6 <consoleintr+0x10e>
      cons.e--;
    80004fc4:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80004fc8:	854e                	mv	a0,s3
    80004fca:	eddff0ef          	jal	80004ea6 <consputc>
    while(cons.e != cons.w &&
    80004fce:	0a04a783          	lw	a5,160(s1)
    80004fd2:	09c4a703          	lw	a4,156(s1)
    80004fd6:	fcf71fe3          	bne	a4,a5,80004fb4 <consoleintr+0xdc>
    80004fda:	6942                	ld	s2,16(sp)
    80004fdc:	69a2                	ld	s3,8(sp)
    80004fde:	b735                	j	80004f0a <consoleintr+0x32>
    80004fe0:	6942                	ld	s2,16(sp)
    80004fe2:	69a2                	ld	s3,8(sp)
    80004fe4:	b71d                	j	80004f0a <consoleintr+0x32>
    80004fe6:	6942                	ld	s2,16(sp)
    80004fe8:	69a2                	ld	s3,8(sp)
    80004fea:	b705                	j	80004f0a <consoleintr+0x32>
    if(cons.e != cons.w){
    80004fec:	0001c717          	auipc	a4,0x1c
    80004ff0:	b4470713          	addi	a4,a4,-1212 # 80020b30 <cons>
    80004ff4:	0a072783          	lw	a5,160(a4)
    80004ff8:	09c72703          	lw	a4,156(a4)
    80004ffc:	f0f707e3          	beq	a4,a5,80004f0a <consoleintr+0x32>
      cons.e--;
    80005000:	37fd                	addiw	a5,a5,-1
    80005002:	0001c717          	auipc	a4,0x1c
    80005006:	bcf72723          	sw	a5,-1074(a4) # 80020bd0 <cons+0xa0>
      consputc(BACKSPACE);
    8000500a:	10000513          	li	a0,256
    8000500e:	e99ff0ef          	jal	80004ea6 <consputc>
    80005012:	bde5                	j	80004f0a <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005014:	ee048be3          	beqz	s1,80004f0a <consoleintr+0x32>
    80005018:	bf01                	j	80004f28 <consoleintr+0x50>
      consputc(c);
    8000501a:	4529                	li	a0,10
    8000501c:	e8bff0ef          	jal	80004ea6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005020:	0001c797          	auipc	a5,0x1c
    80005024:	b1078793          	addi	a5,a5,-1264 # 80020b30 <cons>
    80005028:	0a07a703          	lw	a4,160(a5)
    8000502c:	0017069b          	addiw	a3,a4,1
    80005030:	8636                	mv	a2,a3
    80005032:	0ad7a023          	sw	a3,160(a5)
    80005036:	07f77713          	andi	a4,a4,127
    8000503a:	97ba                	add	a5,a5,a4
    8000503c:	4729                	li	a4,10
    8000503e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005042:	0001c797          	auipc	a5,0x1c
    80005046:	b8c7a523          	sw	a2,-1142(a5) # 80020bcc <cons+0x9c>
        wakeup(&cons.r);
    8000504a:	0001c517          	auipc	a0,0x1c
    8000504e:	b7e50513          	addi	a0,a0,-1154 # 80020bc8 <cons+0x98>
    80005052:	b24fc0ef          	jal	80001376 <wakeup>
    80005056:	bd55                	j	80004f0a <consoleintr+0x32>

0000000080005058 <consoleinit>:

void
consoleinit(void)
{
    80005058:	1141                	addi	sp,sp,-16
    8000505a:	e406                	sd	ra,8(sp)
    8000505c:	e022                	sd	s0,0(sp)
    8000505e:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005060:	00002597          	auipc	a1,0x2
    80005064:	6b058593          	addi	a1,a1,1712 # 80007710 <etext+0x710>
    80005068:	0001c517          	auipc	a0,0x1c
    8000506c:	ac850513          	addi	a0,a0,-1336 # 80020b30 <cons>
    80005070:	630000ef          	jal	800056a0 <initlock>

  uartinit();
    80005074:	3ea000ef          	jal	8000545e <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005078:	00013797          	auipc	a5,0x13
    8000507c:	92078793          	addi	a5,a5,-1760 # 80017998 <devsw>
    80005080:	00000717          	auipc	a4,0x0
    80005084:	d2270713          	addi	a4,a4,-734 # 80004da2 <consoleread>
    80005088:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000508a:	00000717          	auipc	a4,0x0
    8000508e:	ca270713          	addi	a4,a4,-862 # 80004d2c <consolewrite>
    80005092:	ef98                	sd	a4,24(a5)
}
    80005094:	60a2                	ld	ra,8(sp)
    80005096:	6402                	ld	s0,0(sp)
    80005098:	0141                	addi	sp,sp,16
    8000509a:	8082                	ret

000000008000509c <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    8000509c:	7179                	addi	sp,sp,-48
    8000509e:	f406                	sd	ra,40(sp)
    800050a0:	f022                	sd	s0,32(sp)
    800050a2:	ec26                	sd	s1,24(sp)
    800050a4:	e84a                	sd	s2,16(sp)
    800050a6:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    800050a8:	c219                	beqz	a2,800050ae <printint+0x12>
    800050aa:	06054a63          	bltz	a0,8000511e <printint+0x82>
    x = -xx;
  else
    x = xx;
    800050ae:	4e01                	li	t3,0

  i = 0;
    800050b0:	fd040313          	addi	t1,s0,-48
    x = xx;
    800050b4:	869a                	mv	a3,t1
  i = 0;
    800050b6:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    800050b8:	00002817          	auipc	a6,0x2
    800050bc:	7b080813          	addi	a6,a6,1968 # 80007868 <digits>
    800050c0:	88be                	mv	a7,a5
    800050c2:	0017861b          	addiw	a2,a5,1
    800050c6:	87b2                	mv	a5,a2
    800050c8:	02b57733          	remu	a4,a0,a1
    800050cc:	9742                	add	a4,a4,a6
    800050ce:	00074703          	lbu	a4,0(a4)
    800050d2:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    800050d6:	872a                	mv	a4,a0
    800050d8:	02b55533          	divu	a0,a0,a1
    800050dc:	0685                	addi	a3,a3,1
    800050de:	feb771e3          	bgeu	a4,a1,800050c0 <printint+0x24>

  if(sign)
    800050e2:	000e0c63          	beqz	t3,800050fa <printint+0x5e>
    buf[i++] = '-';
    800050e6:	fe060793          	addi	a5,a2,-32
    800050ea:	00878633          	add	a2,a5,s0
    800050ee:	02d00793          	li	a5,45
    800050f2:	fef60823          	sb	a5,-16(a2)
    800050f6:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
    800050fa:	fff7891b          	addiw	s2,a5,-1
    800050fe:	006784b3          	add	s1,a5,t1
    consputc(buf[i]);
    80005102:	fff4c503          	lbu	a0,-1(s1)
    80005106:	da1ff0ef          	jal	80004ea6 <consputc>
  while(--i >= 0)
    8000510a:	397d                	addiw	s2,s2,-1
    8000510c:	14fd                	addi	s1,s1,-1
    8000510e:	fe095ae3          	bgez	s2,80005102 <printint+0x66>
}
    80005112:	70a2                	ld	ra,40(sp)
    80005114:	7402                	ld	s0,32(sp)
    80005116:	64e2                	ld	s1,24(sp)
    80005118:	6942                	ld	s2,16(sp)
    8000511a:	6145                	addi	sp,sp,48
    8000511c:	8082                	ret
    x = -xx;
    8000511e:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    80005122:	4e05                	li	t3,1
    x = -xx;
    80005124:	b771                	j	800050b0 <printint+0x14>

0000000080005126 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    80005126:	7155                	addi	sp,sp,-208
    80005128:	e506                	sd	ra,136(sp)
    8000512a:	e122                	sd	s0,128(sp)
    8000512c:	f0d2                	sd	s4,96(sp)
    8000512e:	0900                	addi	s0,sp,144
    80005130:	8a2a                	mv	s4,a0
    80005132:	e40c                	sd	a1,8(s0)
    80005134:	e810                	sd	a2,16(s0)
    80005136:	ec14                	sd	a3,24(s0)
    80005138:	f018                	sd	a4,32(s0)
    8000513a:	f41c                	sd	a5,40(s0)
    8000513c:	03043823          	sd	a6,48(s0)
    80005140:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    80005144:	0001c797          	auipc	a5,0x1c
    80005148:	aac7a783          	lw	a5,-1364(a5) # 80020bf0 <pr+0x18>
    8000514c:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    80005150:	e3a1                	bnez	a5,80005190 <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80005152:	00840793          	addi	a5,s0,8
    80005156:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000515a:	00054503          	lbu	a0,0(a0)
    8000515e:	26050663          	beqz	a0,800053ca <printf+0x2a4>
    80005162:	fca6                	sd	s1,120(sp)
    80005164:	f8ca                	sd	s2,112(sp)
    80005166:	f4ce                	sd	s3,104(sp)
    80005168:	ecd6                	sd	s5,88(sp)
    8000516a:	e8da                	sd	s6,80(sp)
    8000516c:	e0e2                	sd	s8,64(sp)
    8000516e:	fc66                	sd	s9,56(sp)
    80005170:	f86a                	sd	s10,48(sp)
    80005172:	f46e                	sd	s11,40(sp)
    80005174:	4981                	li	s3,0
    if(cx != '%'){
    80005176:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    8000517a:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    8000517e:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    80005182:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80005186:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    8000518a:	07000d93          	li	s11,112
    8000518e:	a80d                	j	800051c0 <printf+0x9a>
    acquire(&pr.lock);
    80005190:	0001c517          	auipc	a0,0x1c
    80005194:	a4850513          	addi	a0,a0,-1464 # 80020bd8 <pr>
    80005198:	58c000ef          	jal	80005724 <acquire>
  va_start(ap, fmt);
    8000519c:	00840793          	addi	a5,s0,8
    800051a0:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800051a4:	000a4503          	lbu	a0,0(s4)
    800051a8:	fd4d                	bnez	a0,80005162 <printf+0x3c>
    800051aa:	ac3d                	j	800053e8 <printf+0x2c2>
      consputc(cx);
    800051ac:	cfbff0ef          	jal	80004ea6 <consputc>
      continue;
    800051b0:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800051b2:	2485                	addiw	s1,s1,1
    800051b4:	89a6                	mv	s3,s1
    800051b6:	94d2                	add	s1,s1,s4
    800051b8:	0004c503          	lbu	a0,0(s1)
    800051bc:	1e050b63          	beqz	a0,800053b2 <printf+0x28c>
    if(cx != '%'){
    800051c0:	ff5516e3          	bne	a0,s5,800051ac <printf+0x86>
    i++;
    800051c4:	0019879b          	addiw	a5,s3,1
    800051c8:	84be                	mv	s1,a5
    c0 = fmt[i+0] & 0xff;
    800051ca:	00fa0733          	add	a4,s4,a5
    800051ce:	00074903          	lbu	s2,0(a4)
    if(c0) c1 = fmt[i+1] & 0xff;
    800051d2:	1e090063          	beqz	s2,800053b2 <printf+0x28c>
    800051d6:	00174703          	lbu	a4,1(a4)
    c1 = c2 = 0;
    800051da:	86ba                	mv	a3,a4
    if(c1) c2 = fmt[i+2] & 0xff;
    800051dc:	c701                	beqz	a4,800051e4 <printf+0xbe>
    800051de:	97d2                	add	a5,a5,s4
    800051e0:	0027c683          	lbu	a3,2(a5)
    if(c0 == 'd'){
    800051e4:	03690763          	beq	s2,s6,80005212 <printf+0xec>
    } else if(c0 == 'l' && c1 == 'd'){
    800051e8:	05890163          	beq	s2,s8,8000522a <printf+0x104>
    } else if(c0 == 'u'){
    800051ec:	0d990b63          	beq	s2,s9,800052c2 <printf+0x19c>
    } else if(c0 == 'x'){
    800051f0:	13a90163          	beq	s2,s10,80005312 <printf+0x1ec>
    } else if(c0 == 'p'){
    800051f4:	13b90b63          	beq	s2,s11,8000532a <printf+0x204>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    800051f8:	07300793          	li	a5,115
    800051fc:	16f90a63          	beq	s2,a5,80005370 <printf+0x24a>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    80005200:	1b590463          	beq	s2,s5,800053a8 <printf+0x282>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    80005204:	8556                	mv	a0,s5
    80005206:	ca1ff0ef          	jal	80004ea6 <consputc>
      consputc(c0);
    8000520a:	854a                	mv	a0,s2
    8000520c:	c9bff0ef          	jal	80004ea6 <consputc>
    80005210:	b74d                	j	800051b2 <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    80005212:	f8843783          	ld	a5,-120(s0)
    80005216:	00878713          	addi	a4,a5,8
    8000521a:	f8e43423          	sd	a4,-120(s0)
    8000521e:	4605                	li	a2,1
    80005220:	45a9                	li	a1,10
    80005222:	4388                	lw	a0,0(a5)
    80005224:	e79ff0ef          	jal	8000509c <printint>
    80005228:	b769                	j	800051b2 <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    8000522a:	03670663          	beq	a4,s6,80005256 <printf+0x130>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000522e:	05870263          	beq	a4,s8,80005272 <printf+0x14c>
    } else if(c0 == 'l' && c1 == 'u'){
    80005232:	0b970463          	beq	a4,s9,800052da <printf+0x1b4>
    } else if(c0 == 'l' && c1 == 'x'){
    80005236:	fda717e3          	bne	a4,s10,80005204 <printf+0xde>
      printint(va_arg(ap, uint64), 16, 0);
    8000523a:	f8843783          	ld	a5,-120(s0)
    8000523e:	00878713          	addi	a4,a5,8
    80005242:	f8e43423          	sd	a4,-120(s0)
    80005246:	4601                	li	a2,0
    80005248:	45c1                	li	a1,16
    8000524a:	6388                	ld	a0,0(a5)
    8000524c:	e51ff0ef          	jal	8000509c <printint>
      i += 1;
    80005250:	0029849b          	addiw	s1,s3,2
    80005254:	bfb9                	j	800051b2 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005256:	f8843783          	ld	a5,-120(s0)
    8000525a:	00878713          	addi	a4,a5,8
    8000525e:	f8e43423          	sd	a4,-120(s0)
    80005262:	4605                	li	a2,1
    80005264:	45a9                	li	a1,10
    80005266:	6388                	ld	a0,0(a5)
    80005268:	e35ff0ef          	jal	8000509c <printint>
      i += 1;
    8000526c:	0029849b          	addiw	s1,s3,2
    80005270:	b789                	j	800051b2 <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80005272:	06400793          	li	a5,100
    80005276:	02f68863          	beq	a3,a5,800052a6 <printf+0x180>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    8000527a:	07500793          	li	a5,117
    8000527e:	06f68c63          	beq	a3,a5,800052f6 <printf+0x1d0>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    80005282:	07800793          	li	a5,120
    80005286:	f6f69fe3          	bne	a3,a5,80005204 <printf+0xde>
      printint(va_arg(ap, uint64), 16, 0);
    8000528a:	f8843783          	ld	a5,-120(s0)
    8000528e:	00878713          	addi	a4,a5,8
    80005292:	f8e43423          	sd	a4,-120(s0)
    80005296:	4601                	li	a2,0
    80005298:	45c1                	li	a1,16
    8000529a:	6388                	ld	a0,0(a5)
    8000529c:	e01ff0ef          	jal	8000509c <printint>
      i += 2;
    800052a0:	0039849b          	addiw	s1,s3,3
    800052a4:	b739                	j	800051b2 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    800052a6:	f8843783          	ld	a5,-120(s0)
    800052aa:	00878713          	addi	a4,a5,8
    800052ae:	f8e43423          	sd	a4,-120(s0)
    800052b2:	4605                	li	a2,1
    800052b4:	45a9                	li	a1,10
    800052b6:	6388                	ld	a0,0(a5)
    800052b8:	de5ff0ef          	jal	8000509c <printint>
      i += 2;
    800052bc:	0039849b          	addiw	s1,s3,3
    800052c0:	bdcd                	j	800051b2 <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    800052c2:	f8843783          	ld	a5,-120(s0)
    800052c6:	00878713          	addi	a4,a5,8
    800052ca:	f8e43423          	sd	a4,-120(s0)
    800052ce:	4601                	li	a2,0
    800052d0:	45a9                	li	a1,10
    800052d2:	4388                	lw	a0,0(a5)
    800052d4:	dc9ff0ef          	jal	8000509c <printint>
    800052d8:	bde9                	j	800051b2 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    800052da:	f8843783          	ld	a5,-120(s0)
    800052de:	00878713          	addi	a4,a5,8
    800052e2:	f8e43423          	sd	a4,-120(s0)
    800052e6:	4601                	li	a2,0
    800052e8:	45a9                	li	a1,10
    800052ea:	6388                	ld	a0,0(a5)
    800052ec:	db1ff0ef          	jal	8000509c <printint>
      i += 1;
    800052f0:	0029849b          	addiw	s1,s3,2
    800052f4:	bd7d                	j	800051b2 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    800052f6:	f8843783          	ld	a5,-120(s0)
    800052fa:	00878713          	addi	a4,a5,8
    800052fe:	f8e43423          	sd	a4,-120(s0)
    80005302:	4601                	li	a2,0
    80005304:	45a9                	li	a1,10
    80005306:	6388                	ld	a0,0(a5)
    80005308:	d95ff0ef          	jal	8000509c <printint>
      i += 2;
    8000530c:	0039849b          	addiw	s1,s3,3
    80005310:	b54d                	j	800051b2 <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    80005312:	f8843783          	ld	a5,-120(s0)
    80005316:	00878713          	addi	a4,a5,8
    8000531a:	f8e43423          	sd	a4,-120(s0)
    8000531e:	4601                	li	a2,0
    80005320:	45c1                	li	a1,16
    80005322:	4388                	lw	a0,0(a5)
    80005324:	d79ff0ef          	jal	8000509c <printint>
    80005328:	b569                	j	800051b2 <printf+0x8c>
    8000532a:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    8000532c:	f8843783          	ld	a5,-120(s0)
    80005330:	00878713          	addi	a4,a5,8
    80005334:	f8e43423          	sd	a4,-120(s0)
    80005338:	0007b983          	ld	s3,0(a5)
  consputc('0');
    8000533c:	03000513          	li	a0,48
    80005340:	b67ff0ef          	jal	80004ea6 <consputc>
  consputc('x');
    80005344:	07800513          	li	a0,120
    80005348:	b5fff0ef          	jal	80004ea6 <consputc>
    8000534c:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000534e:	00002b97          	auipc	s7,0x2
    80005352:	51ab8b93          	addi	s7,s7,1306 # 80007868 <digits>
    80005356:	03c9d793          	srli	a5,s3,0x3c
    8000535a:	97de                	add	a5,a5,s7
    8000535c:	0007c503          	lbu	a0,0(a5)
    80005360:	b47ff0ef          	jal	80004ea6 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005364:	0992                	slli	s3,s3,0x4
    80005366:	397d                	addiw	s2,s2,-1
    80005368:	fe0917e3          	bnez	s2,80005356 <printf+0x230>
    8000536c:	6ba6                	ld	s7,72(sp)
    8000536e:	b591                	j	800051b2 <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    80005370:	f8843783          	ld	a5,-120(s0)
    80005374:	00878713          	addi	a4,a5,8
    80005378:	f8e43423          	sd	a4,-120(s0)
    8000537c:	0007b903          	ld	s2,0(a5)
    80005380:	00090d63          	beqz	s2,8000539a <printf+0x274>
      for(; *s; s++)
    80005384:	00094503          	lbu	a0,0(s2)
    80005388:	e20505e3          	beqz	a0,800051b2 <printf+0x8c>
        consputc(*s);
    8000538c:	b1bff0ef          	jal	80004ea6 <consputc>
      for(; *s; s++)
    80005390:	0905                	addi	s2,s2,1
    80005392:	00094503          	lbu	a0,0(s2)
    80005396:	f97d                	bnez	a0,8000538c <printf+0x266>
    80005398:	bd29                	j	800051b2 <printf+0x8c>
        s = "(null)";
    8000539a:	00002917          	auipc	s2,0x2
    8000539e:	37e90913          	addi	s2,s2,894 # 80007718 <etext+0x718>
      for(; *s; s++)
    800053a2:	02800513          	li	a0,40
    800053a6:	b7dd                	j	8000538c <printf+0x266>
      consputc('%');
    800053a8:	02500513          	li	a0,37
    800053ac:	afbff0ef          	jal	80004ea6 <consputc>
    800053b0:	b509                	j	800051b2 <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    800053b2:	f7843783          	ld	a5,-136(s0)
    800053b6:	e385                	bnez	a5,800053d6 <printf+0x2b0>
    800053b8:	74e6                	ld	s1,120(sp)
    800053ba:	7946                	ld	s2,112(sp)
    800053bc:	79a6                	ld	s3,104(sp)
    800053be:	6ae6                	ld	s5,88(sp)
    800053c0:	6b46                	ld	s6,80(sp)
    800053c2:	6c06                	ld	s8,64(sp)
    800053c4:	7ce2                	ld	s9,56(sp)
    800053c6:	7d42                	ld	s10,48(sp)
    800053c8:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    800053ca:	4501                	li	a0,0
    800053cc:	60aa                	ld	ra,136(sp)
    800053ce:	640a                	ld	s0,128(sp)
    800053d0:	7a06                	ld	s4,96(sp)
    800053d2:	6169                	addi	sp,sp,208
    800053d4:	8082                	ret
    800053d6:	74e6                	ld	s1,120(sp)
    800053d8:	7946                	ld	s2,112(sp)
    800053da:	79a6                	ld	s3,104(sp)
    800053dc:	6ae6                	ld	s5,88(sp)
    800053de:	6b46                	ld	s6,80(sp)
    800053e0:	6c06                	ld	s8,64(sp)
    800053e2:	7ce2                	ld	s9,56(sp)
    800053e4:	7d42                	ld	s10,48(sp)
    800053e6:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    800053e8:	0001b517          	auipc	a0,0x1b
    800053ec:	7f050513          	addi	a0,a0,2032 # 80020bd8 <pr>
    800053f0:	3c8000ef          	jal	800057b8 <release>
    800053f4:	bfd9                	j	800053ca <printf+0x2a4>

00000000800053f6 <panic>:

void
panic(char *s)
{
    800053f6:	1101                	addi	sp,sp,-32
    800053f8:	ec06                	sd	ra,24(sp)
    800053fa:	e822                	sd	s0,16(sp)
    800053fc:	e426                	sd	s1,8(sp)
    800053fe:	1000                	addi	s0,sp,32
    80005400:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005402:	0001b797          	auipc	a5,0x1b
    80005406:	7e07a723          	sw	zero,2030(a5) # 80020bf0 <pr+0x18>
  printf("panic: ");
    8000540a:	00002517          	auipc	a0,0x2
    8000540e:	31650513          	addi	a0,a0,790 # 80007720 <etext+0x720>
    80005412:	d15ff0ef          	jal	80005126 <printf>
  printf("%s\n", s);
    80005416:	85a6                	mv	a1,s1
    80005418:	00002517          	auipc	a0,0x2
    8000541c:	31050513          	addi	a0,a0,784 # 80007728 <etext+0x728>
    80005420:	d07ff0ef          	jal	80005126 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005424:	4785                	li	a5,1
    80005426:	00002717          	auipc	a4,0x2
    8000542a:	4cf72323          	sw	a5,1222(a4) # 800078ec <panicked>
  for(;;)
    8000542e:	a001                	j	8000542e <panic+0x38>

0000000080005430 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005430:	1101                	addi	sp,sp,-32
    80005432:	ec06                	sd	ra,24(sp)
    80005434:	e822                	sd	s0,16(sp)
    80005436:	e426                	sd	s1,8(sp)
    80005438:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000543a:	0001b497          	auipc	s1,0x1b
    8000543e:	79e48493          	addi	s1,s1,1950 # 80020bd8 <pr>
    80005442:	00002597          	auipc	a1,0x2
    80005446:	2ee58593          	addi	a1,a1,750 # 80007730 <etext+0x730>
    8000544a:	8526                	mv	a0,s1
    8000544c:	254000ef          	jal	800056a0 <initlock>
  pr.locking = 1;
    80005450:	4785                	li	a5,1
    80005452:	cc9c                	sw	a5,24(s1)
}
    80005454:	60e2                	ld	ra,24(sp)
    80005456:	6442                	ld	s0,16(sp)
    80005458:	64a2                	ld	s1,8(sp)
    8000545a:	6105                	addi	sp,sp,32
    8000545c:	8082                	ret

000000008000545e <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000545e:	1141                	addi	sp,sp,-16
    80005460:	e406                	sd	ra,8(sp)
    80005462:	e022                	sd	s0,0(sp)
    80005464:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005466:	100007b7          	lui	a5,0x10000
    8000546a:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000546e:	10000737          	lui	a4,0x10000
    80005472:	f8000693          	li	a3,-128
    80005476:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000547a:	468d                	li	a3,3
    8000547c:	10000637          	lui	a2,0x10000
    80005480:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005484:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005488:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000548c:	8732                	mv	a4,a2
    8000548e:	461d                	li	a2,7
    80005490:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005494:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005498:	00002597          	auipc	a1,0x2
    8000549c:	2a058593          	addi	a1,a1,672 # 80007738 <etext+0x738>
    800054a0:	0001b517          	auipc	a0,0x1b
    800054a4:	75850513          	addi	a0,a0,1880 # 80020bf8 <uart_tx_lock>
    800054a8:	1f8000ef          	jal	800056a0 <initlock>
}
    800054ac:	60a2                	ld	ra,8(sp)
    800054ae:	6402                	ld	s0,0(sp)
    800054b0:	0141                	addi	sp,sp,16
    800054b2:	8082                	ret

00000000800054b4 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800054b4:	1101                	addi	sp,sp,-32
    800054b6:	ec06                	sd	ra,24(sp)
    800054b8:	e822                	sd	s0,16(sp)
    800054ba:	e426                	sd	s1,8(sp)
    800054bc:	1000                	addi	s0,sp,32
    800054be:	84aa                	mv	s1,a0
  push_off();
    800054c0:	224000ef          	jal	800056e4 <push_off>

  if(panicked){
    800054c4:	00002797          	auipc	a5,0x2
    800054c8:	4287a783          	lw	a5,1064(a5) # 800078ec <panicked>
    800054cc:	e795                	bnez	a5,800054f8 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800054ce:	10000737          	lui	a4,0x10000
    800054d2:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    800054d4:	00074783          	lbu	a5,0(a4)
    800054d8:	0207f793          	andi	a5,a5,32
    800054dc:	dfe5                	beqz	a5,800054d4 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    800054de:	0ff4f513          	zext.b	a0,s1
    800054e2:	100007b7          	lui	a5,0x10000
    800054e6:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800054ea:	27e000ef          	jal	80005768 <pop_off>
}
    800054ee:	60e2                	ld	ra,24(sp)
    800054f0:	6442                	ld	s0,16(sp)
    800054f2:	64a2                	ld	s1,8(sp)
    800054f4:	6105                	addi	sp,sp,32
    800054f6:	8082                	ret
    for(;;)
    800054f8:	a001                	j	800054f8 <uartputc_sync+0x44>

00000000800054fa <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800054fa:	00002797          	auipc	a5,0x2
    800054fe:	3f67b783          	ld	a5,1014(a5) # 800078f0 <uart_tx_r>
    80005502:	00002717          	auipc	a4,0x2
    80005506:	3f673703          	ld	a4,1014(a4) # 800078f8 <uart_tx_w>
    8000550a:	08f70163          	beq	a4,a5,8000558c <uartstart+0x92>
{
    8000550e:	7139                	addi	sp,sp,-64
    80005510:	fc06                	sd	ra,56(sp)
    80005512:	f822                	sd	s0,48(sp)
    80005514:	f426                	sd	s1,40(sp)
    80005516:	f04a                	sd	s2,32(sp)
    80005518:	ec4e                	sd	s3,24(sp)
    8000551a:	e852                	sd	s4,16(sp)
    8000551c:	e456                	sd	s5,8(sp)
    8000551e:	e05a                	sd	s6,0(sp)
    80005520:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005522:	10000937          	lui	s2,0x10000
    80005526:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005528:	0001ba97          	auipc	s5,0x1b
    8000552c:	6d0a8a93          	addi	s5,s5,1744 # 80020bf8 <uart_tx_lock>
    uart_tx_r += 1;
    80005530:	00002497          	auipc	s1,0x2
    80005534:	3c048493          	addi	s1,s1,960 # 800078f0 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80005538:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    8000553c:	00002997          	auipc	s3,0x2
    80005540:	3bc98993          	addi	s3,s3,956 # 800078f8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005544:	00094703          	lbu	a4,0(s2)
    80005548:	02077713          	andi	a4,a4,32
    8000554c:	c715                	beqz	a4,80005578 <uartstart+0x7e>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000554e:	01f7f713          	andi	a4,a5,31
    80005552:	9756                	add	a4,a4,s5
    80005554:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80005558:	0785                	addi	a5,a5,1
    8000555a:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000555c:	8526                	mv	a0,s1
    8000555e:	e19fb0ef          	jal	80001376 <wakeup>
    WriteReg(THR, c);
    80005562:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80005566:	609c                	ld	a5,0(s1)
    80005568:	0009b703          	ld	a4,0(s3)
    8000556c:	fcf71ce3          	bne	a4,a5,80005544 <uartstart+0x4a>
      ReadReg(ISR);
    80005570:	100007b7          	lui	a5,0x10000
    80005574:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
  }
}
    80005578:	70e2                	ld	ra,56(sp)
    8000557a:	7442                	ld	s0,48(sp)
    8000557c:	74a2                	ld	s1,40(sp)
    8000557e:	7902                	ld	s2,32(sp)
    80005580:	69e2                	ld	s3,24(sp)
    80005582:	6a42                	ld	s4,16(sp)
    80005584:	6aa2                	ld	s5,8(sp)
    80005586:	6b02                	ld	s6,0(sp)
    80005588:	6121                	addi	sp,sp,64
    8000558a:	8082                	ret
      ReadReg(ISR);
    8000558c:	100007b7          	lui	a5,0x10000
    80005590:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
      return;
    80005594:	8082                	ret

0000000080005596 <uartputc>:
{
    80005596:	7179                	addi	sp,sp,-48
    80005598:	f406                	sd	ra,40(sp)
    8000559a:	f022                	sd	s0,32(sp)
    8000559c:	ec26                	sd	s1,24(sp)
    8000559e:	e84a                	sd	s2,16(sp)
    800055a0:	e44e                	sd	s3,8(sp)
    800055a2:	e052                	sd	s4,0(sp)
    800055a4:	1800                	addi	s0,sp,48
    800055a6:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800055a8:	0001b517          	auipc	a0,0x1b
    800055ac:	65050513          	addi	a0,a0,1616 # 80020bf8 <uart_tx_lock>
    800055b0:	174000ef          	jal	80005724 <acquire>
  if(panicked){
    800055b4:	00002797          	auipc	a5,0x2
    800055b8:	3387a783          	lw	a5,824(a5) # 800078ec <panicked>
    800055bc:	efbd                	bnez	a5,8000563a <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800055be:	00002717          	auipc	a4,0x2
    800055c2:	33a73703          	ld	a4,826(a4) # 800078f8 <uart_tx_w>
    800055c6:	00002797          	auipc	a5,0x2
    800055ca:	32a7b783          	ld	a5,810(a5) # 800078f0 <uart_tx_r>
    800055ce:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800055d2:	0001b997          	auipc	s3,0x1b
    800055d6:	62698993          	addi	s3,s3,1574 # 80020bf8 <uart_tx_lock>
    800055da:	00002497          	auipc	s1,0x2
    800055de:	31648493          	addi	s1,s1,790 # 800078f0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800055e2:	00002917          	auipc	s2,0x2
    800055e6:	31690913          	addi	s2,s2,790 # 800078f8 <uart_tx_w>
    800055ea:	00e79d63          	bne	a5,a4,80005604 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    800055ee:	85ce                	mv	a1,s3
    800055f0:	8526                	mv	a0,s1
    800055f2:	d39fb0ef          	jal	8000132a <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800055f6:	00093703          	ld	a4,0(s2)
    800055fa:	609c                	ld	a5,0(s1)
    800055fc:	02078793          	addi	a5,a5,32
    80005600:	fee787e3          	beq	a5,a4,800055ee <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80005604:	0001b497          	auipc	s1,0x1b
    80005608:	5f448493          	addi	s1,s1,1524 # 80020bf8 <uart_tx_lock>
    8000560c:	01f77793          	andi	a5,a4,31
    80005610:	97a6                	add	a5,a5,s1
    80005612:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80005616:	0705                	addi	a4,a4,1
    80005618:	00002797          	auipc	a5,0x2
    8000561c:	2ee7b023          	sd	a4,736(a5) # 800078f8 <uart_tx_w>
  uartstart();
    80005620:	edbff0ef          	jal	800054fa <uartstart>
  release(&uart_tx_lock);
    80005624:	8526                	mv	a0,s1
    80005626:	192000ef          	jal	800057b8 <release>
}
    8000562a:	70a2                	ld	ra,40(sp)
    8000562c:	7402                	ld	s0,32(sp)
    8000562e:	64e2                	ld	s1,24(sp)
    80005630:	6942                	ld	s2,16(sp)
    80005632:	69a2                	ld	s3,8(sp)
    80005634:	6a02                	ld	s4,0(sp)
    80005636:	6145                	addi	sp,sp,48
    80005638:	8082                	ret
    for(;;)
    8000563a:	a001                	j	8000563a <uartputc+0xa4>

000000008000563c <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000563c:	1141                	addi	sp,sp,-16
    8000563e:	e406                	sd	ra,8(sp)
    80005640:	e022                	sd	s0,0(sp)
    80005642:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80005644:	100007b7          	lui	a5,0x10000
    80005648:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000564c:	8b85                	andi	a5,a5,1
    8000564e:	cb89                	beqz	a5,80005660 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80005650:	100007b7          	lui	a5,0x10000
    80005654:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80005658:	60a2                	ld	ra,8(sp)
    8000565a:	6402                	ld	s0,0(sp)
    8000565c:	0141                	addi	sp,sp,16
    8000565e:	8082                	ret
    return -1;
    80005660:	557d                	li	a0,-1
    80005662:	bfdd                	j	80005658 <uartgetc+0x1c>

0000000080005664 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005664:	1101                	addi	sp,sp,-32
    80005666:	ec06                	sd	ra,24(sp)
    80005668:	e822                	sd	s0,16(sp)
    8000566a:	e426                	sd	s1,8(sp)
    8000566c:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000566e:	54fd                	li	s1,-1
    int c = uartgetc();
    80005670:	fcdff0ef          	jal	8000563c <uartgetc>
    if(c == -1)
    80005674:	00950563          	beq	a0,s1,8000567e <uartintr+0x1a>
      break;
    consoleintr(c);
    80005678:	861ff0ef          	jal	80004ed8 <consoleintr>
  while(1){
    8000567c:	bfd5                	j	80005670 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000567e:	0001b497          	auipc	s1,0x1b
    80005682:	57a48493          	addi	s1,s1,1402 # 80020bf8 <uart_tx_lock>
    80005686:	8526                	mv	a0,s1
    80005688:	09c000ef          	jal	80005724 <acquire>
  uartstart();
    8000568c:	e6fff0ef          	jal	800054fa <uartstart>
  release(&uart_tx_lock);
    80005690:	8526                	mv	a0,s1
    80005692:	126000ef          	jal	800057b8 <release>
}
    80005696:	60e2                	ld	ra,24(sp)
    80005698:	6442                	ld	s0,16(sp)
    8000569a:	64a2                	ld	s1,8(sp)
    8000569c:	6105                	addi	sp,sp,32
    8000569e:	8082                	ret

00000000800056a0 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800056a0:	1141                	addi	sp,sp,-16
    800056a2:	e406                	sd	ra,8(sp)
    800056a4:	e022                	sd	s0,0(sp)
    800056a6:	0800                	addi	s0,sp,16
  lk->name = name;
    800056a8:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800056aa:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800056ae:	00053823          	sd	zero,16(a0)
}
    800056b2:	60a2                	ld	ra,8(sp)
    800056b4:	6402                	ld	s0,0(sp)
    800056b6:	0141                	addi	sp,sp,16
    800056b8:	8082                	ret

00000000800056ba <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800056ba:	411c                	lw	a5,0(a0)
    800056bc:	e399                	bnez	a5,800056c2 <holding+0x8>
    800056be:	4501                	li	a0,0
  return r;
}
    800056c0:	8082                	ret
{
    800056c2:	1101                	addi	sp,sp,-32
    800056c4:	ec06                	sd	ra,24(sp)
    800056c6:	e822                	sd	s0,16(sp)
    800056c8:	e426                	sd	s1,8(sp)
    800056ca:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800056cc:	6904                	ld	s1,16(a0)
    800056ce:	e6efb0ef          	jal	80000d3c <mycpu>
    800056d2:	40a48533          	sub	a0,s1,a0
    800056d6:	00153513          	seqz	a0,a0
}
    800056da:	60e2                	ld	ra,24(sp)
    800056dc:	6442                	ld	s0,16(sp)
    800056de:	64a2                	ld	s1,8(sp)
    800056e0:	6105                	addi	sp,sp,32
    800056e2:	8082                	ret

00000000800056e4 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800056e4:	1101                	addi	sp,sp,-32
    800056e6:	ec06                	sd	ra,24(sp)
    800056e8:	e822                	sd	s0,16(sp)
    800056ea:	e426                	sd	s1,8(sp)
    800056ec:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800056ee:	100024f3          	csrr	s1,sstatus
    800056f2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800056f6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800056f8:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800056fc:	e40fb0ef          	jal	80000d3c <mycpu>
    80005700:	5d3c                	lw	a5,120(a0)
    80005702:	cb99                	beqz	a5,80005718 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80005704:	e38fb0ef          	jal	80000d3c <mycpu>
    80005708:	5d3c                	lw	a5,120(a0)
    8000570a:	2785                	addiw	a5,a5,1
    8000570c:	dd3c                	sw	a5,120(a0)
}
    8000570e:	60e2                	ld	ra,24(sp)
    80005710:	6442                	ld	s0,16(sp)
    80005712:	64a2                	ld	s1,8(sp)
    80005714:	6105                	addi	sp,sp,32
    80005716:	8082                	ret
    mycpu()->intena = old;
    80005718:	e24fb0ef          	jal	80000d3c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000571c:	8085                	srli	s1,s1,0x1
    8000571e:	8885                	andi	s1,s1,1
    80005720:	dd64                	sw	s1,124(a0)
    80005722:	b7cd                	j	80005704 <push_off+0x20>

0000000080005724 <acquire>:
{
    80005724:	1101                	addi	sp,sp,-32
    80005726:	ec06                	sd	ra,24(sp)
    80005728:	e822                	sd	s0,16(sp)
    8000572a:	e426                	sd	s1,8(sp)
    8000572c:	1000                	addi	s0,sp,32
    8000572e:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80005730:	fb5ff0ef          	jal	800056e4 <push_off>
  if(holding(lk))
    80005734:	8526                	mv	a0,s1
    80005736:	f85ff0ef          	jal	800056ba <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000573a:	4705                	li	a4,1
  if(holding(lk))
    8000573c:	e105                	bnez	a0,8000575c <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000573e:	87ba                	mv	a5,a4
    80005740:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80005744:	2781                	sext.w	a5,a5
    80005746:	ffe5                	bnez	a5,8000573e <acquire+0x1a>
  __sync_synchronize();
    80005748:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    8000574c:	df0fb0ef          	jal	80000d3c <mycpu>
    80005750:	e888                	sd	a0,16(s1)
}
    80005752:	60e2                	ld	ra,24(sp)
    80005754:	6442                	ld	s0,16(sp)
    80005756:	64a2                	ld	s1,8(sp)
    80005758:	6105                	addi	sp,sp,32
    8000575a:	8082                	ret
    panic("acquire");
    8000575c:	00002517          	auipc	a0,0x2
    80005760:	fe450513          	addi	a0,a0,-28 # 80007740 <etext+0x740>
    80005764:	c93ff0ef          	jal	800053f6 <panic>

0000000080005768 <pop_off>:

void
pop_off(void)
{
    80005768:	1141                	addi	sp,sp,-16
    8000576a:	e406                	sd	ra,8(sp)
    8000576c:	e022                	sd	s0,0(sp)
    8000576e:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80005770:	dccfb0ef          	jal	80000d3c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005774:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005778:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000577a:	e39d                	bnez	a5,800057a0 <pop_off+0x38>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000577c:	5d3c                	lw	a5,120(a0)
    8000577e:	02f05763          	blez	a5,800057ac <pop_off+0x44>
    panic("pop_off");
  c->noff -= 1;
    80005782:	37fd                	addiw	a5,a5,-1
    80005784:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005786:	eb89                	bnez	a5,80005798 <pop_off+0x30>
    80005788:	5d7c                	lw	a5,124(a0)
    8000578a:	c799                	beqz	a5,80005798 <pop_off+0x30>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000578c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80005790:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005794:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005798:	60a2                	ld	ra,8(sp)
    8000579a:	6402                	ld	s0,0(sp)
    8000579c:	0141                	addi	sp,sp,16
    8000579e:	8082                	ret
    panic("pop_off - interruptible");
    800057a0:	00002517          	auipc	a0,0x2
    800057a4:	fa850513          	addi	a0,a0,-88 # 80007748 <etext+0x748>
    800057a8:	c4fff0ef          	jal	800053f6 <panic>
    panic("pop_off");
    800057ac:	00002517          	auipc	a0,0x2
    800057b0:	fb450513          	addi	a0,a0,-76 # 80007760 <etext+0x760>
    800057b4:	c43ff0ef          	jal	800053f6 <panic>

00000000800057b8 <release>:
{
    800057b8:	1101                	addi	sp,sp,-32
    800057ba:	ec06                	sd	ra,24(sp)
    800057bc:	e822                	sd	s0,16(sp)
    800057be:	e426                	sd	s1,8(sp)
    800057c0:	1000                	addi	s0,sp,32
    800057c2:	84aa                	mv	s1,a0
  if(!holding(lk))
    800057c4:	ef7ff0ef          	jal	800056ba <holding>
    800057c8:	c105                	beqz	a0,800057e8 <release+0x30>
  lk->cpu = 0;
    800057ca:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800057ce:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    800057d2:	0310000f          	fence	rw,w
    800057d6:	0004a023          	sw	zero,0(s1)
  pop_off();
    800057da:	f8fff0ef          	jal	80005768 <pop_off>
}
    800057de:	60e2                	ld	ra,24(sp)
    800057e0:	6442                	ld	s0,16(sp)
    800057e2:	64a2                	ld	s1,8(sp)
    800057e4:	6105                	addi	sp,sp,32
    800057e6:	8082                	ret
    panic("release");
    800057e8:	00002517          	auipc	a0,0x2
    800057ec:	f8050513          	addi	a0,a0,-128 # 80007768 <etext+0x768>
    800057f0:	c07ff0ef          	jal	800053f6 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
