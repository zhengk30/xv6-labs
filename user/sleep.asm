
user/_sleep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char** argv) {
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    if (argc < 2) {
   8:	4785                	li	a5,1
   a:	00a7de63          	bge	a5,a0,26 <main+0x26>
        fprintf(2, "error: missing nticks\n");
        exit(1);
    }
    int nticks = atoi(argv[1]);
   e:	6588                	ld	a0,8(a1)
  10:	1ee000ef          	jal	1fe <atoi>
    if (nticks < 0) {
  14:	02054363          	bltz	a0,3a <main+0x3a>
        fprintf(2, "error: invalid nticks, should be nonnegative\n");
        exit(1);
    }
    if (sleep(nticks) < 0) {
  18:	378000ef          	jal	390 <sleep>
  1c:	02054963          	bltz	a0,4e <main+0x4e>
        fprintf(2, "error: sleep failed\n");
        exit(1);
    }
    exit(0);
  20:	4501                	li	a0,0
  22:	2de000ef          	jal	300 <exit>
        fprintf(2, "error: missing nticks\n");
  26:	00001597          	auipc	a1,0x1
  2a:	88a58593          	addi	a1,a1,-1910 # 8b0 <malloc+0xf6>
  2e:	4509                	li	a0,2
  30:	6a8000ef          	jal	6d8 <fprintf>
        exit(1);
  34:	4505                	li	a0,1
  36:	2ca000ef          	jal	300 <exit>
        fprintf(2, "error: invalid nticks, should be nonnegative\n");
  3a:	00001597          	auipc	a1,0x1
  3e:	88e58593          	addi	a1,a1,-1906 # 8c8 <malloc+0x10e>
  42:	4509                	li	a0,2
  44:	694000ef          	jal	6d8 <fprintf>
        exit(1);
  48:	4505                	li	a0,1
  4a:	2b6000ef          	jal	300 <exit>
        fprintf(2, "error: sleep failed\n");
  4e:	00001597          	auipc	a1,0x1
  52:	8aa58593          	addi	a1,a1,-1878 # 8f8 <malloc+0x13e>
  56:	4509                	li	a0,2
  58:	680000ef          	jal	6d8 <fprintf>
        exit(1);
  5c:	4505                	li	a0,1
  5e:	2a2000ef          	jal	300 <exit>

0000000000000062 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  62:	1141                	addi	sp,sp,-16
  64:	e406                	sd	ra,8(sp)
  66:	e022                	sd	s0,0(sp)
  68:	0800                	addi	s0,sp,16
  extern int main();
  main();
  6a:	f97ff0ef          	jal	0 <main>
  exit(0);
  6e:	4501                	li	a0,0
  70:	290000ef          	jal	300 <exit>

0000000000000074 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  74:	1141                	addi	sp,sp,-16
  76:	e406                	sd	ra,8(sp)
  78:	e022                	sd	s0,0(sp)
  7a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  7c:	87aa                	mv	a5,a0
  7e:	0585                	addi	a1,a1,1
  80:	0785                	addi	a5,a5,1
  82:	fff5c703          	lbu	a4,-1(a1)
  86:	fee78fa3          	sb	a4,-1(a5)
  8a:	fb75                	bnez	a4,7e <strcpy+0xa>
    ;
  return os;
}
  8c:	60a2                	ld	ra,8(sp)
  8e:	6402                	ld	s0,0(sp)
  90:	0141                	addi	sp,sp,16
  92:	8082                	ret

0000000000000094 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  94:	1141                	addi	sp,sp,-16
  96:	e406                	sd	ra,8(sp)
  98:	e022                	sd	s0,0(sp)
  9a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  9c:	00054783          	lbu	a5,0(a0)
  a0:	cb91                	beqz	a5,b4 <strcmp+0x20>
  a2:	0005c703          	lbu	a4,0(a1)
  a6:	00f71763          	bne	a4,a5,b4 <strcmp+0x20>
    p++, q++;
  aa:	0505                	addi	a0,a0,1
  ac:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  ae:	00054783          	lbu	a5,0(a0)
  b2:	fbe5                	bnez	a5,a2 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  b4:	0005c503          	lbu	a0,0(a1)
}
  b8:	40a7853b          	subw	a0,a5,a0
  bc:	60a2                	ld	ra,8(sp)
  be:	6402                	ld	s0,0(sp)
  c0:	0141                	addi	sp,sp,16
  c2:	8082                	ret

00000000000000c4 <strlen>:

uint
strlen(const char *s)
{
  c4:	1141                	addi	sp,sp,-16
  c6:	e406                	sd	ra,8(sp)
  c8:	e022                	sd	s0,0(sp)
  ca:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  cc:	00054783          	lbu	a5,0(a0)
  d0:	cf99                	beqz	a5,ee <strlen+0x2a>
  d2:	0505                	addi	a0,a0,1
  d4:	87aa                	mv	a5,a0
  d6:	86be                	mv	a3,a5
  d8:	0785                	addi	a5,a5,1
  da:	fff7c703          	lbu	a4,-1(a5)
  de:	ff65                	bnez	a4,d6 <strlen+0x12>
  e0:	40a6853b          	subw	a0,a3,a0
  e4:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  e6:	60a2                	ld	ra,8(sp)
  e8:	6402                	ld	s0,0(sp)
  ea:	0141                	addi	sp,sp,16
  ec:	8082                	ret
  for(n = 0; s[n]; n++)
  ee:	4501                	li	a0,0
  f0:	bfdd                	j	e6 <strlen+0x22>

00000000000000f2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f2:	1141                	addi	sp,sp,-16
  f4:	e406                	sd	ra,8(sp)
  f6:	e022                	sd	s0,0(sp)
  f8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  fa:	ca19                	beqz	a2,110 <memset+0x1e>
  fc:	87aa                	mv	a5,a0
  fe:	1602                	slli	a2,a2,0x20
 100:	9201                	srli	a2,a2,0x20
 102:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 106:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 10a:	0785                	addi	a5,a5,1
 10c:	fee79de3          	bne	a5,a4,106 <memset+0x14>
  }
  return dst;
}
 110:	60a2                	ld	ra,8(sp)
 112:	6402                	ld	s0,0(sp)
 114:	0141                	addi	sp,sp,16
 116:	8082                	ret

0000000000000118 <strchr>:

char*
strchr(const char *s, char c)
{
 118:	1141                	addi	sp,sp,-16
 11a:	e406                	sd	ra,8(sp)
 11c:	e022                	sd	s0,0(sp)
 11e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 120:	00054783          	lbu	a5,0(a0)
 124:	cf81                	beqz	a5,13c <strchr+0x24>
    if(*s == c)
 126:	00f58763          	beq	a1,a5,134 <strchr+0x1c>
  for(; *s; s++)
 12a:	0505                	addi	a0,a0,1
 12c:	00054783          	lbu	a5,0(a0)
 130:	fbfd                	bnez	a5,126 <strchr+0xe>
      return (char*)s;
  return 0;
 132:	4501                	li	a0,0
}
 134:	60a2                	ld	ra,8(sp)
 136:	6402                	ld	s0,0(sp)
 138:	0141                	addi	sp,sp,16
 13a:	8082                	ret
  return 0;
 13c:	4501                	li	a0,0
 13e:	bfdd                	j	134 <strchr+0x1c>

0000000000000140 <gets>:

char*
gets(char *buf, int max)
{
 140:	7159                	addi	sp,sp,-112
 142:	f486                	sd	ra,104(sp)
 144:	f0a2                	sd	s0,96(sp)
 146:	eca6                	sd	s1,88(sp)
 148:	e8ca                	sd	s2,80(sp)
 14a:	e4ce                	sd	s3,72(sp)
 14c:	e0d2                	sd	s4,64(sp)
 14e:	fc56                	sd	s5,56(sp)
 150:	f85a                	sd	s6,48(sp)
 152:	f45e                	sd	s7,40(sp)
 154:	f062                	sd	s8,32(sp)
 156:	ec66                	sd	s9,24(sp)
 158:	e86a                	sd	s10,16(sp)
 15a:	1880                	addi	s0,sp,112
 15c:	8caa                	mv	s9,a0
 15e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 160:	892a                	mv	s2,a0
 162:	4481                	li	s1,0
    cc = read(0, &c, 1);
 164:	f9f40b13          	addi	s6,s0,-97
 168:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 16a:	4ba9                	li	s7,10
 16c:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 16e:	8d26                	mv	s10,s1
 170:	0014899b          	addiw	s3,s1,1
 174:	84ce                	mv	s1,s3
 176:	0349d563          	bge	s3,s4,1a0 <gets+0x60>
    cc = read(0, &c, 1);
 17a:	8656                	mv	a2,s5
 17c:	85da                	mv	a1,s6
 17e:	4501                	li	a0,0
 180:	198000ef          	jal	318 <read>
    if(cc < 1)
 184:	00a05e63          	blez	a0,1a0 <gets+0x60>
    buf[i++] = c;
 188:	f9f44783          	lbu	a5,-97(s0)
 18c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 190:	01778763          	beq	a5,s7,19e <gets+0x5e>
 194:	0905                	addi	s2,s2,1
 196:	fd879ce3          	bne	a5,s8,16e <gets+0x2e>
    buf[i++] = c;
 19a:	8d4e                	mv	s10,s3
 19c:	a011                	j	1a0 <gets+0x60>
 19e:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 1a0:	9d66                	add	s10,s10,s9
 1a2:	000d0023          	sb	zero,0(s10)
  return buf;
}
 1a6:	8566                	mv	a0,s9
 1a8:	70a6                	ld	ra,104(sp)
 1aa:	7406                	ld	s0,96(sp)
 1ac:	64e6                	ld	s1,88(sp)
 1ae:	6946                	ld	s2,80(sp)
 1b0:	69a6                	ld	s3,72(sp)
 1b2:	6a06                	ld	s4,64(sp)
 1b4:	7ae2                	ld	s5,56(sp)
 1b6:	7b42                	ld	s6,48(sp)
 1b8:	7ba2                	ld	s7,40(sp)
 1ba:	7c02                	ld	s8,32(sp)
 1bc:	6ce2                	ld	s9,24(sp)
 1be:	6d42                	ld	s10,16(sp)
 1c0:	6165                	addi	sp,sp,112
 1c2:	8082                	ret

00000000000001c4 <stat>:

int
stat(const char *n, struct stat *st)
{
 1c4:	1101                	addi	sp,sp,-32
 1c6:	ec06                	sd	ra,24(sp)
 1c8:	e822                	sd	s0,16(sp)
 1ca:	e04a                	sd	s2,0(sp)
 1cc:	1000                	addi	s0,sp,32
 1ce:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d0:	4581                	li	a1,0
 1d2:	16e000ef          	jal	340 <open>
  if(fd < 0)
 1d6:	02054263          	bltz	a0,1fa <stat+0x36>
 1da:	e426                	sd	s1,8(sp)
 1dc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1de:	85ca                	mv	a1,s2
 1e0:	178000ef          	jal	358 <fstat>
 1e4:	892a                	mv	s2,a0
  close(fd);
 1e6:	8526                	mv	a0,s1
 1e8:	140000ef          	jal	328 <close>
  return r;
 1ec:	64a2                	ld	s1,8(sp)
}
 1ee:	854a                	mv	a0,s2
 1f0:	60e2                	ld	ra,24(sp)
 1f2:	6442                	ld	s0,16(sp)
 1f4:	6902                	ld	s2,0(sp)
 1f6:	6105                	addi	sp,sp,32
 1f8:	8082                	ret
    return -1;
 1fa:	597d                	li	s2,-1
 1fc:	bfcd                	j	1ee <stat+0x2a>

00000000000001fe <atoi>:

int
atoi(const char *s)
{
 1fe:	1141                	addi	sp,sp,-16
 200:	e406                	sd	ra,8(sp)
 202:	e022                	sd	s0,0(sp)
 204:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 206:	00054683          	lbu	a3,0(a0)
 20a:	fd06879b          	addiw	a5,a3,-48
 20e:	0ff7f793          	zext.b	a5,a5
 212:	4625                	li	a2,9
 214:	02f66963          	bltu	a2,a5,246 <atoi+0x48>
 218:	872a                	mv	a4,a0
  n = 0;
 21a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 21c:	0705                	addi	a4,a4,1
 21e:	0025179b          	slliw	a5,a0,0x2
 222:	9fa9                	addw	a5,a5,a0
 224:	0017979b          	slliw	a5,a5,0x1
 228:	9fb5                	addw	a5,a5,a3
 22a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 22e:	00074683          	lbu	a3,0(a4)
 232:	fd06879b          	addiw	a5,a3,-48
 236:	0ff7f793          	zext.b	a5,a5
 23a:	fef671e3          	bgeu	a2,a5,21c <atoi+0x1e>
  return n;
}
 23e:	60a2                	ld	ra,8(sp)
 240:	6402                	ld	s0,0(sp)
 242:	0141                	addi	sp,sp,16
 244:	8082                	ret
  n = 0;
 246:	4501                	li	a0,0
 248:	bfdd                	j	23e <atoi+0x40>

000000000000024a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 24a:	1141                	addi	sp,sp,-16
 24c:	e406                	sd	ra,8(sp)
 24e:	e022                	sd	s0,0(sp)
 250:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 252:	02b57563          	bgeu	a0,a1,27c <memmove+0x32>
    while(n-- > 0)
 256:	00c05f63          	blez	a2,274 <memmove+0x2a>
 25a:	1602                	slli	a2,a2,0x20
 25c:	9201                	srli	a2,a2,0x20
 25e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 262:	872a                	mv	a4,a0
      *dst++ = *src++;
 264:	0585                	addi	a1,a1,1
 266:	0705                	addi	a4,a4,1
 268:	fff5c683          	lbu	a3,-1(a1)
 26c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 270:	fee79ae3          	bne	a5,a4,264 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 274:	60a2                	ld	ra,8(sp)
 276:	6402                	ld	s0,0(sp)
 278:	0141                	addi	sp,sp,16
 27a:	8082                	ret
    dst += n;
 27c:	00c50733          	add	a4,a0,a2
    src += n;
 280:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 282:	fec059e3          	blez	a2,274 <memmove+0x2a>
 286:	fff6079b          	addiw	a5,a2,-1
 28a:	1782                	slli	a5,a5,0x20
 28c:	9381                	srli	a5,a5,0x20
 28e:	fff7c793          	not	a5,a5
 292:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 294:	15fd                	addi	a1,a1,-1
 296:	177d                	addi	a4,a4,-1
 298:	0005c683          	lbu	a3,0(a1)
 29c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2a0:	fef71ae3          	bne	a4,a5,294 <memmove+0x4a>
 2a4:	bfc1                	j	274 <memmove+0x2a>

00000000000002a6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2a6:	1141                	addi	sp,sp,-16
 2a8:	e406                	sd	ra,8(sp)
 2aa:	e022                	sd	s0,0(sp)
 2ac:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2ae:	ca0d                	beqz	a2,2e0 <memcmp+0x3a>
 2b0:	fff6069b          	addiw	a3,a2,-1
 2b4:	1682                	slli	a3,a3,0x20
 2b6:	9281                	srli	a3,a3,0x20
 2b8:	0685                	addi	a3,a3,1
 2ba:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2bc:	00054783          	lbu	a5,0(a0)
 2c0:	0005c703          	lbu	a4,0(a1)
 2c4:	00e79863          	bne	a5,a4,2d4 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 2c8:	0505                	addi	a0,a0,1
    p2++;
 2ca:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2cc:	fed518e3          	bne	a0,a3,2bc <memcmp+0x16>
  }
  return 0;
 2d0:	4501                	li	a0,0
 2d2:	a019                	j	2d8 <memcmp+0x32>
      return *p1 - *p2;
 2d4:	40e7853b          	subw	a0,a5,a4
}
 2d8:	60a2                	ld	ra,8(sp)
 2da:	6402                	ld	s0,0(sp)
 2dc:	0141                	addi	sp,sp,16
 2de:	8082                	ret
  return 0;
 2e0:	4501                	li	a0,0
 2e2:	bfdd                	j	2d8 <memcmp+0x32>

00000000000002e4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2e4:	1141                	addi	sp,sp,-16
 2e6:	e406                	sd	ra,8(sp)
 2e8:	e022                	sd	s0,0(sp)
 2ea:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2ec:	f5fff0ef          	jal	24a <memmove>
}
 2f0:	60a2                	ld	ra,8(sp)
 2f2:	6402                	ld	s0,0(sp)
 2f4:	0141                	addi	sp,sp,16
 2f6:	8082                	ret

00000000000002f8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2f8:	4885                	li	a7,1
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <exit>:
.global exit
exit:
 li a7, SYS_exit
 300:	4889                	li	a7,2
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <wait>:
.global wait
wait:
 li a7, SYS_wait
 308:	488d                	li	a7,3
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 310:	4891                	li	a7,4
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <read>:
.global read
read:
 li a7, SYS_read
 318:	4895                	li	a7,5
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <write>:
.global write
write:
 li a7, SYS_write
 320:	48c1                	li	a7,16
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <close>:
.global close
close:
 li a7, SYS_close
 328:	48d5                	li	a7,21
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <kill>:
.global kill
kill:
 li a7, SYS_kill
 330:	4899                	li	a7,6
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <exec>:
.global exec
exec:
 li a7, SYS_exec
 338:	489d                	li	a7,7
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <open>:
.global open
open:
 li a7, SYS_open
 340:	48bd                	li	a7,15
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 348:	48c5                	li	a7,17
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 350:	48c9                	li	a7,18
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 358:	48a1                	li	a7,8
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <link>:
.global link
link:
 li a7, SYS_link
 360:	48cd                	li	a7,19
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 368:	48d1                	li	a7,20
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 370:	48a5                	li	a7,9
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <dup>:
.global dup
dup:
 li a7, SYS_dup
 378:	48a9                	li	a7,10
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 380:	48ad                	li	a7,11
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 388:	48b1                	li	a7,12
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 390:	48b5                	li	a7,13
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 398:	48b9                	li	a7,14
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3a0:	1101                	addi	sp,sp,-32
 3a2:	ec06                	sd	ra,24(sp)
 3a4:	e822                	sd	s0,16(sp)
 3a6:	1000                	addi	s0,sp,32
 3a8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3ac:	4605                	li	a2,1
 3ae:	fef40593          	addi	a1,s0,-17
 3b2:	f6fff0ef          	jal	320 <write>
}
 3b6:	60e2                	ld	ra,24(sp)
 3b8:	6442                	ld	s0,16(sp)
 3ba:	6105                	addi	sp,sp,32
 3bc:	8082                	ret

00000000000003be <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3be:	7139                	addi	sp,sp,-64
 3c0:	fc06                	sd	ra,56(sp)
 3c2:	f822                	sd	s0,48(sp)
 3c4:	f426                	sd	s1,40(sp)
 3c6:	f04a                	sd	s2,32(sp)
 3c8:	ec4e                	sd	s3,24(sp)
 3ca:	0080                	addi	s0,sp,64
 3cc:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3ce:	c299                	beqz	a3,3d4 <printint+0x16>
 3d0:	0605ce63          	bltz	a1,44c <printint+0x8e>
  neg = 0;
 3d4:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 3d6:	fc040313          	addi	t1,s0,-64
  neg = 0;
 3da:	869a                	mv	a3,t1
  i = 0;
 3dc:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 3de:	00000817          	auipc	a6,0x0
 3e2:	53a80813          	addi	a6,a6,1338 # 918 <digits>
 3e6:	88be                	mv	a7,a5
 3e8:	0017851b          	addiw	a0,a5,1
 3ec:	87aa                	mv	a5,a0
 3ee:	02c5f73b          	remuw	a4,a1,a2
 3f2:	1702                	slli	a4,a4,0x20
 3f4:	9301                	srli	a4,a4,0x20
 3f6:	9742                	add	a4,a4,a6
 3f8:	00074703          	lbu	a4,0(a4)
 3fc:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 400:	872e                	mv	a4,a1
 402:	02c5d5bb          	divuw	a1,a1,a2
 406:	0685                	addi	a3,a3,1
 408:	fcc77fe3          	bgeu	a4,a2,3e6 <printint+0x28>
  if(neg)
 40c:	000e0c63          	beqz	t3,424 <printint+0x66>
    buf[i++] = '-';
 410:	fd050793          	addi	a5,a0,-48
 414:	00878533          	add	a0,a5,s0
 418:	02d00793          	li	a5,45
 41c:	fef50823          	sb	a5,-16(a0)
 420:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 424:	fff7899b          	addiw	s3,a5,-1
 428:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 42c:	fff4c583          	lbu	a1,-1(s1)
 430:	854a                	mv	a0,s2
 432:	f6fff0ef          	jal	3a0 <putc>
  while(--i >= 0)
 436:	39fd                	addiw	s3,s3,-1
 438:	14fd                	addi	s1,s1,-1
 43a:	fe09d9e3          	bgez	s3,42c <printint+0x6e>
}
 43e:	70e2                	ld	ra,56(sp)
 440:	7442                	ld	s0,48(sp)
 442:	74a2                	ld	s1,40(sp)
 444:	7902                	ld	s2,32(sp)
 446:	69e2                	ld	s3,24(sp)
 448:	6121                	addi	sp,sp,64
 44a:	8082                	ret
    x = -xx;
 44c:	40b005bb          	negw	a1,a1
    neg = 1;
 450:	4e05                	li	t3,1
    x = -xx;
 452:	b751                	j	3d6 <printint+0x18>

0000000000000454 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 454:	711d                	addi	sp,sp,-96
 456:	ec86                	sd	ra,88(sp)
 458:	e8a2                	sd	s0,80(sp)
 45a:	e4a6                	sd	s1,72(sp)
 45c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 45e:	0005c483          	lbu	s1,0(a1)
 462:	26048663          	beqz	s1,6ce <vprintf+0x27a>
 466:	e0ca                	sd	s2,64(sp)
 468:	fc4e                	sd	s3,56(sp)
 46a:	f852                	sd	s4,48(sp)
 46c:	f456                	sd	s5,40(sp)
 46e:	f05a                	sd	s6,32(sp)
 470:	ec5e                	sd	s7,24(sp)
 472:	e862                	sd	s8,16(sp)
 474:	e466                	sd	s9,8(sp)
 476:	8b2a                	mv	s6,a0
 478:	8a2e                	mv	s4,a1
 47a:	8bb2                	mv	s7,a2
  state = 0;
 47c:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 47e:	4901                	li	s2,0
 480:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 482:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 486:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 48a:	06c00c93          	li	s9,108
 48e:	a00d                	j	4b0 <vprintf+0x5c>
        putc(fd, c0);
 490:	85a6                	mv	a1,s1
 492:	855a                	mv	a0,s6
 494:	f0dff0ef          	jal	3a0 <putc>
 498:	a019                	j	49e <vprintf+0x4a>
    } else if(state == '%'){
 49a:	03598363          	beq	s3,s5,4c0 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 49e:	0019079b          	addiw	a5,s2,1
 4a2:	893e                	mv	s2,a5
 4a4:	873e                	mv	a4,a5
 4a6:	97d2                	add	a5,a5,s4
 4a8:	0007c483          	lbu	s1,0(a5)
 4ac:	20048963          	beqz	s1,6be <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 4b0:	0004879b          	sext.w	a5,s1
    if(state == 0){
 4b4:	fe0993e3          	bnez	s3,49a <vprintf+0x46>
      if(c0 == '%'){
 4b8:	fd579ce3          	bne	a5,s5,490 <vprintf+0x3c>
        state = '%';
 4bc:	89be                	mv	s3,a5
 4be:	b7c5                	j	49e <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4c0:	00ea06b3          	add	a3,s4,a4
 4c4:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4c8:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4ca:	c681                	beqz	a3,4d2 <vprintf+0x7e>
 4cc:	9752                	add	a4,a4,s4
 4ce:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4d2:	03878e63          	beq	a5,s8,50e <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 4d6:	05978863          	beq	a5,s9,526 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4da:	07500713          	li	a4,117
 4de:	0ee78263          	beq	a5,a4,5c2 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4e2:	07800713          	li	a4,120
 4e6:	12e78463          	beq	a5,a4,60e <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4ea:	07000713          	li	a4,112
 4ee:	14e78963          	beq	a5,a4,640 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 4f2:	07300713          	li	a4,115
 4f6:	18e78863          	beq	a5,a4,686 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4fa:	02500713          	li	a4,37
 4fe:	04e79463          	bne	a5,a4,546 <vprintf+0xf2>
        putc(fd, '%');
 502:	85ba                	mv	a1,a4
 504:	855a                	mv	a0,s6
 506:	e9bff0ef          	jal	3a0 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 50a:	4981                	li	s3,0
 50c:	bf49                	j	49e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 50e:	008b8493          	addi	s1,s7,8
 512:	4685                	li	a3,1
 514:	4629                	li	a2,10
 516:	000ba583          	lw	a1,0(s7)
 51a:	855a                	mv	a0,s6
 51c:	ea3ff0ef          	jal	3be <printint>
 520:	8ba6                	mv	s7,s1
      state = 0;
 522:	4981                	li	s3,0
 524:	bfad                	j	49e <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 526:	06400793          	li	a5,100
 52a:	02f68963          	beq	a3,a5,55c <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 52e:	06c00793          	li	a5,108
 532:	04f68263          	beq	a3,a5,576 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 536:	07500793          	li	a5,117
 53a:	0af68063          	beq	a3,a5,5da <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 53e:	07800793          	li	a5,120
 542:	0ef68263          	beq	a3,a5,626 <vprintf+0x1d2>
        putc(fd, '%');
 546:	02500593          	li	a1,37
 54a:	855a                	mv	a0,s6
 54c:	e55ff0ef          	jal	3a0 <putc>
        putc(fd, c0);
 550:	85a6                	mv	a1,s1
 552:	855a                	mv	a0,s6
 554:	e4dff0ef          	jal	3a0 <putc>
      state = 0;
 558:	4981                	li	s3,0
 55a:	b791                	j	49e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 55c:	008b8493          	addi	s1,s7,8
 560:	4685                	li	a3,1
 562:	4629                	li	a2,10
 564:	000ba583          	lw	a1,0(s7)
 568:	855a                	mv	a0,s6
 56a:	e55ff0ef          	jal	3be <printint>
        i += 1;
 56e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 570:	8ba6                	mv	s7,s1
      state = 0;
 572:	4981                	li	s3,0
        i += 1;
 574:	b72d                	j	49e <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 576:	06400793          	li	a5,100
 57a:	02f60763          	beq	a2,a5,5a8 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 57e:	07500793          	li	a5,117
 582:	06f60963          	beq	a2,a5,5f4 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 586:	07800793          	li	a5,120
 58a:	faf61ee3          	bne	a2,a5,546 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 58e:	008b8493          	addi	s1,s7,8
 592:	4681                	li	a3,0
 594:	4641                	li	a2,16
 596:	000ba583          	lw	a1,0(s7)
 59a:	855a                	mv	a0,s6
 59c:	e23ff0ef          	jal	3be <printint>
        i += 2;
 5a0:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5a2:	8ba6                	mv	s7,s1
      state = 0;
 5a4:	4981                	li	s3,0
        i += 2;
 5a6:	bde5                	j	49e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5a8:	008b8493          	addi	s1,s7,8
 5ac:	4685                	li	a3,1
 5ae:	4629                	li	a2,10
 5b0:	000ba583          	lw	a1,0(s7)
 5b4:	855a                	mv	a0,s6
 5b6:	e09ff0ef          	jal	3be <printint>
        i += 2;
 5ba:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5bc:	8ba6                	mv	s7,s1
      state = 0;
 5be:	4981                	li	s3,0
        i += 2;
 5c0:	bdf9                	j	49e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 5c2:	008b8493          	addi	s1,s7,8
 5c6:	4681                	li	a3,0
 5c8:	4629                	li	a2,10
 5ca:	000ba583          	lw	a1,0(s7)
 5ce:	855a                	mv	a0,s6
 5d0:	defff0ef          	jal	3be <printint>
 5d4:	8ba6                	mv	s7,s1
      state = 0;
 5d6:	4981                	li	s3,0
 5d8:	b5d9                	j	49e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5da:	008b8493          	addi	s1,s7,8
 5de:	4681                	li	a3,0
 5e0:	4629                	li	a2,10
 5e2:	000ba583          	lw	a1,0(s7)
 5e6:	855a                	mv	a0,s6
 5e8:	dd7ff0ef          	jal	3be <printint>
        i += 1;
 5ec:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ee:	8ba6                	mv	s7,s1
      state = 0;
 5f0:	4981                	li	s3,0
        i += 1;
 5f2:	b575                	j	49e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5f4:	008b8493          	addi	s1,s7,8
 5f8:	4681                	li	a3,0
 5fa:	4629                	li	a2,10
 5fc:	000ba583          	lw	a1,0(s7)
 600:	855a                	mv	a0,s6
 602:	dbdff0ef          	jal	3be <printint>
        i += 2;
 606:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 608:	8ba6                	mv	s7,s1
      state = 0;
 60a:	4981                	li	s3,0
        i += 2;
 60c:	bd49                	j	49e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 60e:	008b8493          	addi	s1,s7,8
 612:	4681                	li	a3,0
 614:	4641                	li	a2,16
 616:	000ba583          	lw	a1,0(s7)
 61a:	855a                	mv	a0,s6
 61c:	da3ff0ef          	jal	3be <printint>
 620:	8ba6                	mv	s7,s1
      state = 0;
 622:	4981                	li	s3,0
 624:	bdad                	j	49e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 626:	008b8493          	addi	s1,s7,8
 62a:	4681                	li	a3,0
 62c:	4641                	li	a2,16
 62e:	000ba583          	lw	a1,0(s7)
 632:	855a                	mv	a0,s6
 634:	d8bff0ef          	jal	3be <printint>
        i += 1;
 638:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 63a:	8ba6                	mv	s7,s1
      state = 0;
 63c:	4981                	li	s3,0
        i += 1;
 63e:	b585                	j	49e <vprintf+0x4a>
 640:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 642:	008b8d13          	addi	s10,s7,8
 646:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 64a:	03000593          	li	a1,48
 64e:	855a                	mv	a0,s6
 650:	d51ff0ef          	jal	3a0 <putc>
  putc(fd, 'x');
 654:	07800593          	li	a1,120
 658:	855a                	mv	a0,s6
 65a:	d47ff0ef          	jal	3a0 <putc>
 65e:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 660:	00000b97          	auipc	s7,0x0
 664:	2b8b8b93          	addi	s7,s7,696 # 918 <digits>
 668:	03c9d793          	srli	a5,s3,0x3c
 66c:	97de                	add	a5,a5,s7
 66e:	0007c583          	lbu	a1,0(a5)
 672:	855a                	mv	a0,s6
 674:	d2dff0ef          	jal	3a0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 678:	0992                	slli	s3,s3,0x4
 67a:	34fd                	addiw	s1,s1,-1
 67c:	f4f5                	bnez	s1,668 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 67e:	8bea                	mv	s7,s10
      state = 0;
 680:	4981                	li	s3,0
 682:	6d02                	ld	s10,0(sp)
 684:	bd29                	j	49e <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 686:	008b8993          	addi	s3,s7,8
 68a:	000bb483          	ld	s1,0(s7)
 68e:	cc91                	beqz	s1,6aa <vprintf+0x256>
        for(; *s; s++)
 690:	0004c583          	lbu	a1,0(s1)
 694:	c195                	beqz	a1,6b8 <vprintf+0x264>
          putc(fd, *s);
 696:	855a                	mv	a0,s6
 698:	d09ff0ef          	jal	3a0 <putc>
        for(; *s; s++)
 69c:	0485                	addi	s1,s1,1
 69e:	0004c583          	lbu	a1,0(s1)
 6a2:	f9f5                	bnez	a1,696 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 6a4:	8bce                	mv	s7,s3
      state = 0;
 6a6:	4981                	li	s3,0
 6a8:	bbdd                	j	49e <vprintf+0x4a>
          s = "(null)";
 6aa:	00000497          	auipc	s1,0x0
 6ae:	26648493          	addi	s1,s1,614 # 910 <malloc+0x156>
        for(; *s; s++)
 6b2:	02800593          	li	a1,40
 6b6:	b7c5                	j	696 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 6b8:	8bce                	mv	s7,s3
      state = 0;
 6ba:	4981                	li	s3,0
 6bc:	b3cd                	j	49e <vprintf+0x4a>
 6be:	6906                	ld	s2,64(sp)
 6c0:	79e2                	ld	s3,56(sp)
 6c2:	7a42                	ld	s4,48(sp)
 6c4:	7aa2                	ld	s5,40(sp)
 6c6:	7b02                	ld	s6,32(sp)
 6c8:	6be2                	ld	s7,24(sp)
 6ca:	6c42                	ld	s8,16(sp)
 6cc:	6ca2                	ld	s9,8(sp)
    }
  }
}
 6ce:	60e6                	ld	ra,88(sp)
 6d0:	6446                	ld	s0,80(sp)
 6d2:	64a6                	ld	s1,72(sp)
 6d4:	6125                	addi	sp,sp,96
 6d6:	8082                	ret

00000000000006d8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6d8:	715d                	addi	sp,sp,-80
 6da:	ec06                	sd	ra,24(sp)
 6dc:	e822                	sd	s0,16(sp)
 6de:	1000                	addi	s0,sp,32
 6e0:	e010                	sd	a2,0(s0)
 6e2:	e414                	sd	a3,8(s0)
 6e4:	e818                	sd	a4,16(s0)
 6e6:	ec1c                	sd	a5,24(s0)
 6e8:	03043023          	sd	a6,32(s0)
 6ec:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6f0:	8622                	mv	a2,s0
 6f2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6f6:	d5fff0ef          	jal	454 <vprintf>
}
 6fa:	60e2                	ld	ra,24(sp)
 6fc:	6442                	ld	s0,16(sp)
 6fe:	6161                	addi	sp,sp,80
 700:	8082                	ret

0000000000000702 <printf>:

void
printf(const char *fmt, ...)
{
 702:	711d                	addi	sp,sp,-96
 704:	ec06                	sd	ra,24(sp)
 706:	e822                	sd	s0,16(sp)
 708:	1000                	addi	s0,sp,32
 70a:	e40c                	sd	a1,8(s0)
 70c:	e810                	sd	a2,16(s0)
 70e:	ec14                	sd	a3,24(s0)
 710:	f018                	sd	a4,32(s0)
 712:	f41c                	sd	a5,40(s0)
 714:	03043823          	sd	a6,48(s0)
 718:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 71c:	00840613          	addi	a2,s0,8
 720:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 724:	85aa                	mv	a1,a0
 726:	4505                	li	a0,1
 728:	d2dff0ef          	jal	454 <vprintf>
}
 72c:	60e2                	ld	ra,24(sp)
 72e:	6442                	ld	s0,16(sp)
 730:	6125                	addi	sp,sp,96
 732:	8082                	ret

0000000000000734 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 734:	1141                	addi	sp,sp,-16
 736:	e406                	sd	ra,8(sp)
 738:	e022                	sd	s0,0(sp)
 73a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 73c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 740:	00001797          	auipc	a5,0x1
 744:	8c07b783          	ld	a5,-1856(a5) # 1000 <freep>
 748:	a02d                	j	772 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 74a:	4618                	lw	a4,8(a2)
 74c:	9f2d                	addw	a4,a4,a1
 74e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 752:	6398                	ld	a4,0(a5)
 754:	6310                	ld	a2,0(a4)
 756:	a83d                	j	794 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 758:	ff852703          	lw	a4,-8(a0)
 75c:	9f31                	addw	a4,a4,a2
 75e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 760:	ff053683          	ld	a3,-16(a0)
 764:	a091                	j	7a8 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 766:	6398                	ld	a4,0(a5)
 768:	00e7e463          	bltu	a5,a4,770 <free+0x3c>
 76c:	00e6ea63          	bltu	a3,a4,780 <free+0x4c>
{
 770:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 772:	fed7fae3          	bgeu	a5,a3,766 <free+0x32>
 776:	6398                	ld	a4,0(a5)
 778:	00e6e463          	bltu	a3,a4,780 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 77c:	fee7eae3          	bltu	a5,a4,770 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 780:	ff852583          	lw	a1,-8(a0)
 784:	6390                	ld	a2,0(a5)
 786:	02059813          	slli	a6,a1,0x20
 78a:	01c85713          	srli	a4,a6,0x1c
 78e:	9736                	add	a4,a4,a3
 790:	fae60de3          	beq	a2,a4,74a <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 794:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 798:	4790                	lw	a2,8(a5)
 79a:	02061593          	slli	a1,a2,0x20
 79e:	01c5d713          	srli	a4,a1,0x1c
 7a2:	973e                	add	a4,a4,a5
 7a4:	fae68ae3          	beq	a3,a4,758 <free+0x24>
    p->s.ptr = bp->s.ptr;
 7a8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7aa:	00001717          	auipc	a4,0x1
 7ae:	84f73b23          	sd	a5,-1962(a4) # 1000 <freep>
}
 7b2:	60a2                	ld	ra,8(sp)
 7b4:	6402                	ld	s0,0(sp)
 7b6:	0141                	addi	sp,sp,16
 7b8:	8082                	ret

00000000000007ba <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7ba:	7139                	addi	sp,sp,-64
 7bc:	fc06                	sd	ra,56(sp)
 7be:	f822                	sd	s0,48(sp)
 7c0:	f04a                	sd	s2,32(sp)
 7c2:	ec4e                	sd	s3,24(sp)
 7c4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7c6:	02051993          	slli	s3,a0,0x20
 7ca:	0209d993          	srli	s3,s3,0x20
 7ce:	09bd                	addi	s3,s3,15
 7d0:	0049d993          	srli	s3,s3,0x4
 7d4:	2985                	addiw	s3,s3,1
 7d6:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 7d8:	00001517          	auipc	a0,0x1
 7dc:	82853503          	ld	a0,-2008(a0) # 1000 <freep>
 7e0:	c905                	beqz	a0,810 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7e4:	4798                	lw	a4,8(a5)
 7e6:	09377663          	bgeu	a4,s3,872 <malloc+0xb8>
 7ea:	f426                	sd	s1,40(sp)
 7ec:	e852                	sd	s4,16(sp)
 7ee:	e456                	sd	s5,8(sp)
 7f0:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7f2:	8a4e                	mv	s4,s3
 7f4:	6705                	lui	a4,0x1
 7f6:	00e9f363          	bgeu	s3,a4,7fc <malloc+0x42>
 7fa:	6a05                	lui	s4,0x1
 7fc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 800:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 804:	00000497          	auipc	s1,0x0
 808:	7fc48493          	addi	s1,s1,2044 # 1000 <freep>
  if(p == (char*)-1)
 80c:	5afd                	li	s5,-1
 80e:	a83d                	j	84c <malloc+0x92>
 810:	f426                	sd	s1,40(sp)
 812:	e852                	sd	s4,16(sp)
 814:	e456                	sd	s5,8(sp)
 816:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 818:	00000797          	auipc	a5,0x0
 81c:	7f878793          	addi	a5,a5,2040 # 1010 <base>
 820:	00000717          	auipc	a4,0x0
 824:	7ef73023          	sd	a5,2016(a4) # 1000 <freep>
 828:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 82a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 82e:	b7d1                	j	7f2 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 830:	6398                	ld	a4,0(a5)
 832:	e118                	sd	a4,0(a0)
 834:	a899                	j	88a <malloc+0xd0>
  hp->s.size = nu;
 836:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 83a:	0541                	addi	a0,a0,16
 83c:	ef9ff0ef          	jal	734 <free>
  return freep;
 840:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 842:	c125                	beqz	a0,8a2 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 844:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 846:	4798                	lw	a4,8(a5)
 848:	03277163          	bgeu	a4,s2,86a <malloc+0xb0>
    if(p == freep)
 84c:	6098                	ld	a4,0(s1)
 84e:	853e                	mv	a0,a5
 850:	fef71ae3          	bne	a4,a5,844 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 854:	8552                	mv	a0,s4
 856:	b33ff0ef          	jal	388 <sbrk>
  if(p == (char*)-1)
 85a:	fd551ee3          	bne	a0,s5,836 <malloc+0x7c>
        return 0;
 85e:	4501                	li	a0,0
 860:	74a2                	ld	s1,40(sp)
 862:	6a42                	ld	s4,16(sp)
 864:	6aa2                	ld	s5,8(sp)
 866:	6b02                	ld	s6,0(sp)
 868:	a03d                	j	896 <malloc+0xdc>
 86a:	74a2                	ld	s1,40(sp)
 86c:	6a42                	ld	s4,16(sp)
 86e:	6aa2                	ld	s5,8(sp)
 870:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 872:	fae90fe3          	beq	s2,a4,830 <malloc+0x76>
        p->s.size -= nunits;
 876:	4137073b          	subw	a4,a4,s3
 87a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 87c:	02071693          	slli	a3,a4,0x20
 880:	01c6d713          	srli	a4,a3,0x1c
 884:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 886:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 88a:	00000717          	auipc	a4,0x0
 88e:	76a73b23          	sd	a0,1910(a4) # 1000 <freep>
      return (void*)(p + 1);
 892:	01078513          	addi	a0,a5,16
  }
}
 896:	70e2                	ld	ra,56(sp)
 898:	7442                	ld	s0,48(sp)
 89a:	7902                	ld	s2,32(sp)
 89c:	69e2                	ld	s3,24(sp)
 89e:	6121                	addi	sp,sp,64
 8a0:	8082                	ret
 8a2:	74a2                	ld	s1,40(sp)
 8a4:	6a42                	ld	s4,16(sp)
 8a6:	6aa2                	ld	s5,8(sp)
 8a8:	6b02                	ld	s6,0(sp)
 8aa:	b7f5                	j	896 <malloc+0xdc>
