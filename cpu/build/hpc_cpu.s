	.file	"hpc_cpu.cpp"
	.text
	.p2align 4
	.type	_ZN12_GLOBAL__N_117dense_scalar_rowsEPKfRKNS_5LayerEPfiiiib, @function
_ZN12_GLOBAL__N_117dense_scalar_rowsEPKfRKNS_5LayerEPfiiiib:
.LFB8308:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	movslq	%r9d, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movl	56(%rsp), %r9d
	movzbl	64(%rsp), %r13d
	movl	%r8d, -4(%rsp)
	cmpl	%r8d, %ecx
	jge	.L16
	cmpl	%r9d, %ebp
	jge	.L16
	movq	%rdx, %r12
	movslq	(%rsi), %rdx
	movq	%rsi, %rax
	movslq	4(%rsi), %r14
	movslq	%ecx, %rsi
	movl	%ecx, %r11d
	movq	24(%rax), %r10
	movq	8(%rax), %rax
	movq	%rsi, %rbx
	leaq	0(,%rdx,4), %rcx
	vxorps	%xmm3, %xmm3, %xmm3
	movq	%rdx, %r8
	imulq	%rdx, %rsi
	vmovaps	%xmm3, %xmm2
	imulq	%rbp, %rdx
	imulq	%r14, %rbx
	leaq	(%rdi,%rsi,4), %rsi
	leaq	(%rax,%rdx,4), %rax
	movq	%rax, -16(%rsp)
	.p2align 4,,10
	.p2align 3
.L3:
	movq	-16(%rsp), %rdx
	leaq	(%r12,%rbx,4), %r15
	movq	%rbp, %rdi
	.p2align 4,,10
	.p2align 3
.L8:
	testl	%r8d, %r8d
	jle	.L9
	xorl	%eax, %eax
	vxorps	%xmm1, %xmm1, %xmm1
	.p2align 4,,10
	.p2align 3
.L5:
	vmovss	(%rsi,%rax), %xmm0
	vmulss	(%rdx,%rax), %xmm0, %xmm0
	addq	$4, %rax
	vaddss	%xmm0, %xmm1, %xmm1
	cmpq	%rax, %rcx
	jne	.L5
.L4:
	vaddss	(%r10,%rdi,4), %xmm1, %xmm1
	testb	%r13b, %r13b
	je	.L6
	vcmpnltss	%xmm3, %xmm1, %xmm0
	vblendvps	%xmm0, %xmm1, %xmm2, %xmm1
.L6:
	vmovss	%xmm1, (%r15,%rdi,4)
	incq	%rdi
	addq	%rcx, %rdx
	cmpl	%edi, %r9d
	jg	.L8
	incl	%r11d
	addq	%r14, %rbx
	addq	%rcx, %rsi
	cmpl	%r11d, -4(%rsp)
	jne	.L3
.L16:
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L9:
	.cfi_restore_state
	vxorps	%xmm1, %xmm1, %xmm1
	jmp	.L4
	.cfi_endproc
.LFE8308:
	.size	_ZN12_GLOBAL__N_117dense_scalar_rowsEPKfRKNS_5LayerEPfiiiib, .-_ZN12_GLOBAL__N_117dense_scalar_rowsEPKfRKNS_5LayerEPfiiiib
	.p2align 4
	.type	_ZN12_GLOBAL__N_18dot_simdEPKfS1_i, @function
_ZN12_GLOBAL__N_18dot_simdEPKfS1_i:
.LFB8309:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	vpxor	%xmm0, %xmm0, %xmm0
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	andq	$-32, %rsp
	subq	$64, %rsp
	movq	%fs:40, %rax
	movq	%rax, 56(%rsp)
	xorl	%eax, %eax
	vmovdqa	%ymm0, (%rsp)
	testl	%edx, %edx
	jle	.L20
	movq	%rdi, %rcx
	cmpl	$7, %edx
	jle	.L26
	movl	%edx, %edi
	vxorps	%xmm1, %xmm1, %xmm1
	shrl	$3, %edi
	salq	$5, %rdi
	.p2align 4,,10
	.p2align 3
.L22:
	vmovups	(%rcx,%rax), %ymm2
	vmulps	(%rsi,%rax), %ymm2, %ymm0
	addq	$32, %rax
	vaddps	%ymm0, %ymm1, %ymm1
	cmpq	%rax, %rdi
	jne	.L22
	movl	%edx, %edi
	vmovaps	%ymm1, (%rsp)
	andl	$-8, %edi
	testb	$7, %dl
	je	.L20
.L21:
	movslq	%edi, %r8
	vmovss	(%rsp), %xmm3
	vmovss	(%rcx,%r8,4), %xmm0
	leaq	0(,%r8,4), %rax
	vfmadd132ss	(%rsi,%r8,4), %xmm3, %xmm0
	leal	1(%rdi), %r8d
	vmovss	%xmm0, (%rsp)
	cmpl	%r8d, %edx
	jle	.L20
	vmovss	4(%rcx,%rax), %xmm4
	leal	2(%rdi), %r8d
	vfmadd231ss	4(%rsi,%rax), %xmm4, %xmm0
	vmovss	%xmm0, (%rsp)
	cmpl	%r8d, %edx
	jle	.L20
	vmovss	8(%rcx,%rax), %xmm5
	leal	3(%rdi), %r8d
	vfmadd231ss	8(%rsi,%rax), %xmm5, %xmm0
	vmovss	%xmm0, (%rsp)
	cmpl	%r8d, %edx
	jle	.L20
	vmovss	12(%rcx,%rax), %xmm6
	leal	4(%rdi), %r8d
	vfmadd231ss	12(%rsi,%rax), %xmm6, %xmm0
	vmovss	%xmm0, (%rsp)
	cmpl	%r8d, %edx
	jle	.L20
	vmovss	16(%rcx,%rax), %xmm7
	leal	5(%rdi), %r8d
	vfmadd231ss	16(%rsi,%rax), %xmm7, %xmm0
	vmovss	%xmm0, (%rsp)
	cmpl	%r8d, %edx
	jle	.L20
	vmovss	20(%rcx,%rax), %xmm7
	addl	$6, %edi
	vfmadd231ss	20(%rsi,%rax), %xmm7, %xmm0
	vmovss	%xmm0, (%rsp)
	cmpl	%edi, %edx
	jle	.L20
	vmovss	24(%rcx,%rax), %xmm6
	vfmadd231ss	24(%rsi,%rax), %xmm6, %xmm0
	vmovss	%xmm0, (%rsp)
.L20:
	vxorps	%xmm0, %xmm0, %xmm0
	vaddss	(%rsp), %xmm0, %xmm0
	vaddss	4(%rsp), %xmm0, %xmm0
	vaddss	8(%rsp), %xmm0, %xmm0
	vaddss	12(%rsp), %xmm0, %xmm0
	vaddss	16(%rsp), %xmm0, %xmm0
	vaddss	20(%rsp), %xmm0, %xmm0
	vaddss	24(%rsp), %xmm0, %xmm0
	vaddss	28(%rsp), %xmm0, %xmm0
	movq	56(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L30
	vzeroupper
	leave
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
.L26:
	.cfi_restore_state
	xorl	%edi, %edi
	jmp	.L21
.L30:
	vzeroupper
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE8309:
	.size	_ZN12_GLOBAL__N_18dot_simdEPKfS1_i, .-_ZN12_GLOBAL__N_18dot_simdEPKfS1_i
	.p2align 4
	.type	_ZN12_GLOBAL__N_115dense_simd_rowsEPKfRKNS_5LayerEPfiiiibb, @function
_ZN12_GLOBAL__N_115dense_simd_rowsEPKfRKNS_5LayerEPfiiiibb:
.LFB8311:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movl	%ecx, %eax
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	.cfi_offset 3, -56
	movq	%rdx, %rbx
	andq	$-64, %rsp
	addq	$-128, %rsp
	movzbl	24(%rbp), %ecx
	movl	16(%rbp), %edx
	movzbl	32(%rbp), %r14d
	movl	(%rsi), %r15d
	movb	%cl, 111(%rsp)
	cmpl	%r8d, %eax
	jge	.L55
	movslq	%r15d, %rcx
	cmpl	%edx, %r9d
	jge	.L55
	movslq	4(%rsi), %r11
	subl	%r9d, %edx
	movl	%r8d, 56(%rsp)
	movl	%r15d, %r13d
	leaq	0(,%r11,4), %r10
	movq	%r10, 48(%rsp)
	movslq	%eax, %r10
	salq	$2, %r10
	imulq	%r10, %r11
	imulq	%rcx, %r10
	addq	%r11, %rbx
	leaq	(%rdi,%r10), %r12
	movslq	%r9d, %r10
	movq	%rbx, 112(%rsp)
	leaq	0(,%rcx,4), %rbx
	leaq	0(,%r10,4), %rdi
	addq	%r10, %rdx
	movq	%rbx, 120(%rsp)
	imulq	%rdi, %rcx
	movq	%rdi, 32(%rsp)
	movq	%rcx, 40(%rsp)
	leaq	0(,%rdx,4), %rcx
	leal	-64(%r15), %edx
	shrl	$6, %edx
	movq	%rcx, 96(%rsp)
	incl	%edx
	movl	%edx, %ecx
	salq	$8, %rdx
	sall	$6, %ecx
	movq	%rdx, 64(%rsp)
	leal	15(%rcx), %ebx
	movl	%ecx, 72(%rsp)
	movl	%ebx, 104(%rsp)
	movq	8(%rsi), %rbx
	movq	%rbx, 88(%rsp)
	movq	24(%rsi), %rbx
	movq	%rbx, 80(%rsp)
	leal	-16(%r15), %ebx
	movq	%r12, %r15
	movl	%ebx, 76(%rsp)
	.p2align 4,,10
	.p2align 3
.L34:
	movq	32(%rsp), %r12
	movq	40(%rsp), %rdi
	movq	%r15, %rbx
	movl	%eax, 60(%rsp)
	movq	%r12, %r15
	movq	%rdi, %r12
	jmp	.L44
	.p2align 4,,10
	.p2align 3
.L35:
	movl	%r13d, %edx
	movq	%rbx, %rdi
	vzeroupper
	call	_ZN12_GLOBAL__N_18dot_simdEPKfS1_i
.L41:
	movq	80(%rsp), %rax
	cmpb	$0, 111(%rsp)
	vaddss	(%rax,%r15), %xmm0, %xmm0
	je	.L42
	vxorps	%xmm6, %xmm6, %xmm6
	vcmpnltss	%xmm6, %xmm0, %xmm1
	vblendvps	%xmm1, %xmm0, %xmm6, %xmm0
.L42:
	movq	112(%rsp), %rax
	vmovss	%xmm0, (%rax,%r15)
	movq	120(%rsp), %rax
	addq	$4, %r15
	addq	%rax, %r12
	cmpq	%r15, 96(%rsp)
	je	.L57
.L44:
	movq	88(%rsp), %rax
	leaq	(%rax,%r12), %rsi
	testb	%r14b, %r14b
	je	.L35
	cmpl	$63, %r13d
	jle	.L45
	movq	64(%rsp), %rcx
	vxorps	%xmm3, %xmm3, %xmm3
	movq	%rsi, %rax
	movq	%rbx, %rdx
	vmovaps	%zmm3, %zmm1
	vmovaps	%zmm3, %zmm2
	vmovaps	%zmm3, %zmm0
	leaq	(%rcx,%rsi), %r10
	.p2align 4,,10
	.p2align 3
.L37:
	vmovups	(%rdx), %zmm4
	vmovups	64(%rdx), %zmm5
	addq	$256, %rax
	addq	$256, %rdx
	vmovups	-128(%rdx), %zmm6
	vmovups	-64(%rdx), %zmm7
	vfmadd231ps	-256(%rax), %zmm4, %zmm0
	vfmadd231ps	-192(%rax), %zmm5, %zmm2
	vfmadd231ps	-128(%rax), %zmm6, %zmm1
	vfmadd231ps	-64(%rax), %zmm7, %zmm3
	cmpq	%r10, %rax
	jne	.L37
	movl	104(%rsp), %eax
	movl	72(%rsp), %r10d
.L36:
	cmpl	%eax, %r13d
	jle	.L38
	movslq	%r10d, %rax
	.p2align 4,,10
	.p2align 3
.L39:
	vmovups	(%rbx,%rax,4), %zmm4
	vfmadd231ps	(%rsi,%rax,4), %zmm4, %zmm0
	addq	$16, %rax
	leal	15(%rax), %edx
	cmpl	%edx, %r13d
	jg	.L39
	movl	76(%rsp), %eax
	leal	15(%r10), %edx
	xorl	%ecx, %ecx
	subl	%r10d, %eax
	andl	$-16, %eax
	cmpl	%edx, %r13d
	cmovle	%ecx, %eax
	leal	16(%r10,%rax), %r10d
.L38:
	cmpl	%r10d, %r13d
	jle	.L40
	movl	%r13d, %eax
	movslq	%r10d, %rdx
	movl	$1, %edi
	subl	%r10d, %eax
	salq	$2, %rdx
	shlx	%eax, %edi, %eax
	decl	%eax
	kmovw	%eax, %k1
	vmovups	(%rsi,%rdx), %zmm4{%k1}{z}
	vmovups	(%rbx,%rdx), %zmm5{%k1}{z}
	vfmadd231ps	%zmm4, %zmm5, %zmm2
.L40:
	vaddps	%zmm0, %zmm2, %zmm2
	vaddps	%zmm3, %zmm1, %zmm1
	vaddps	%zmm2, %zmm1, %zmm1
	vextractf64x4	$0x1, %zmm1, %ymm0
	vaddps	%ymm1, %ymm0, %ymm0
	vextractf128	$0x1, %ymm0, %xmm1
	vaddps	%xmm0, %xmm1, %xmm0
	vpermilps	$78, %xmm0, %xmm1
	vaddps	%xmm0, %xmm1, %xmm1
	vmovaps	%xmm1, %xmm0
	vshufps	$85, %xmm1, %xmm1, %xmm1
	vaddss	%xmm1, %xmm0, %xmm0
	jmp	.L41
	.p2align 4,,10
	.p2align 3
.L57:
	movq	%rax, %rdi
	movl	60(%rsp), %eax
	movq	48(%rsp), %rcx
	movq	%rbx, %r15
	addq	%rdi, %r15
	incl	%eax
	addq	%rcx, 112(%rsp)
	cmpl	%eax, 56(%rsp)
	jne	.L34
	vzeroupper
.L55:
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
	.p2align 4,,10
	.p2align 3
.L45:
	.cfi_restore_state
	vxorps	%xmm3, %xmm3, %xmm3
	movl	$15, %eax
	xorl	%r10d, %r10d
	vmovaps	%zmm3, %zmm1
	vmovaps	%zmm3, %zmm2
	vmovaps	%zmm3, %zmm0
	jmp	.L36
	.cfi_endproc
.LFE8311:
	.size	_ZN12_GLOBAL__N_115dense_simd_rowsEPKfRKNS_5LayerEPfiiiibb, .-_ZN12_GLOBAL__N_115dense_simd_rowsEPKfRKNS_5LayerEPfiiiibb
	.p2align 4
	.type	_ZN12_GLOBAL__N_15microILi1ELi2ELi2EEEvPKfiS2_iS2_Pfiiib, @function
_ZN12_GLOBAL__N_15microILi1ELi2ELi2EEEvPKfiS2_iS2_Pfiiib:
.LFB8524:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	vxorps	%xmm0, %xmm0, %xmm0
	movq	%rdi, %r10
	movq	%rdx, %r11
	movq	%r9, %rdi
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	.cfi_offset 3, -56
	movl	%esi, %ebx
	andq	$-64, %rsp
	subq	$384, %rsp
	movq	%fs:40, %rdx
	movq	%rdx, 376(%rsp)
	xorl	%edx, %edx
	movl	32(%rbp), %eax
	kmovd	40(%rbp), %k0
	vmovaps	%zmm0, 64(%rsp)
	vmovaps	%zmm0, 128(%rsp)
	vmovaps	%zmm0, 192(%rsp)
	vmovaps	%zmm0, 256(%rsp)
	cmpl	$15, %eax
	jg	.L59
	testl	%eax, %eax
	jle	.L70
	movl	$1, %edx
	kxord	%k1, %k1, %k1
	shlx	%eax, %edx, %eax
	decl	%eax
	movzwl	%ax, %eax
	kmovd	%eax, %k2
.L60:
	movslq	16(%rbp), %r14
	movslq	%ebx, %rax
	movslq	24(%rbp), %r15
	movslq	%ecx, %rcx
	imulq	%r14, %rax
	leaq	0(,%r15,4), %r12
	addq	%r12, %r11
	leaq	(%r10,%rax,4), %r13
	cmpl	$1, %ebx
	jle	.L78
	leal	-2(%rbx), %esi
	movq	%r15, 48(%rsp)
	vmovaps	64(%rsp), %zmm7
	movq	%r11, %rdx
	shrl	%esi
	movq	%r12, 40(%rsp)
	vmovaps	128(%rsp), %zmm6
	movq	%r13, %rax
	leaq	0(%r13,%rsi,8), %r10
	vmovaps	192(%rsp), %zmm5
	vmovaps	256(%rsp), %zmm4
	movl	%esi, 60(%rsp)
	leaq	0(,%rcx,4), %rsi
	leaq	64(%rsi), %r9
	.p2align 4,,10
	.p2align 3
.L63:
	vmovups	64(%rdx), %zmm0{%k1}{z}
	vmovups	(%rdx), %zmm3{%k2}{z}
	leaq	(%rdx,%rsi), %r12
	movq	%rax, %r15
	vbroadcastss	(%rax), %zmm1
	addq	$8, %rax
	vfmadd132ps	%zmm1, %zmm7, %zmm3
	vfmadd132ps	%zmm0, %zmm6, %zmm1
	vbroadcastss	-4(%rax), %zmm0
	vmovaps	%zmm3, 64(%rsp)
	vmovaps	%zmm3, %zmm7
	vmovaps	%zmm1, %zmm6
	vmovaps	%zmm1, 128(%rsp)
	vmovups	(%r9,%rdx), %zmm8{%k1}{z}
	vmovups	(%r12), %zmm2{%k2}{z}
	leaq	(%r12,%rsi), %rdx
	vfmadd132ps	%zmm0, %zmm5, %zmm2
	vfmadd132ps	%zmm8, %zmm4, %zmm0
	vmovaps	%zmm2, %zmm5
	vmovaps	%zmm2, 192(%rsp)
	vmovaps	%zmm0, %zmm4
	vmovaps	%zmm0, 256(%rsp)
	cmpq	%r15, %r10
	jne	.L63
	movl	60(%rsp), %eax
	movq	48(%rsp), %r15
	movq	40(%rsp), %r12
	leal	2(%rax,%rax), %eax
.L62:
	cmpl	%eax, %ebx
	jle	.L65
	movslq	%eax, %rsi
	movq	%rcx, %rdx
	incl	%eax
	imulq	%rsi, %rdx
	vbroadcastss	0(%r13,%rsi,4), %zmm4
	leaq	0(,%rsi,4), %r9
	leaq	0(,%rdx,4), %rsi
	vmovups	(%r11,%rsi), %zmm5{%k2}{z}
	vfmadd231ps	%zmm5, %zmm4, %zmm3
	vmovups	64(%r11,%rsi), %zmm5{%k1}{z}
	vfmadd231ps	%zmm5, %zmm4, %zmm1
	cmpl	%eax, %ebx
	jle	.L65
	leaq	(%rcx,%rdx), %rax
	vbroadcastss	4(%r13,%r9), %zmm4
	salq	$2, %rax
	vmovups	(%r11,%rax), %zmm5{%k2}{z}
	vfmadd231ps	%zmm5, %zmm4, %zmm3
	vmovups	64(%r11,%rax), %zmm5{%k1}{z}
	vfmadd231ps	%zmm5, %zmm4, %zmm1
.L65:
	imulq	%r14, %rcx
	vaddps	%zmm3, %zmm2, %zmm2
	vmovups	(%r8,%r12), %zmm5{%k2}{z}
	vxorps	%xmm4, %xmm4, %xmm4
	leaq	64(%r8,%r12), %rsi
	leaq	(%rcx,%r15), %rax
	vaddps	%zmm5, %zmm2, %zmm2
	salq	$2, %rax
	kortestb	%k0, %k0
	leaq	(%rdi,%rax), %rdx
	je	.L67
	vmaxps	%zmm4, %zmm2, %zmm2
	vaddps	%zmm1, %zmm0, %zmm0
	vmovups	%zmm2, (%rdx){%k2}
	vmovups	(%rsi), %zmm2{%k1}{z}
	vaddps	%zmm2, %zmm0, %zmm0
	vmaxps	%zmm4, %zmm0, %zmm0
.L68:
	vmovups	%zmm0, 64(%rdi,%rax){%k1}
	movq	376(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L79
	vzeroupper
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
	.p2align 4,,10
	.p2align 3
.L59:
	.cfi_restore_state
	subl	$16, %eax
	kmovd	%eax, %k1
	cmpl	$15, %eax
	jg	.L71
	kortestd	%k1, %k1
	je	.L72
	movl	$1, %eax
	kmovb	%k1, %esi
	shlx	%esi, %eax, %eax
	decl	%eax
	movzwl	%ax, %eax
	kmovd	%eax, %k1
	movl	$65535, %eax
	kmovd	%eax, %k2
	jmp	.L60
.L71:
	movl	$65535, %eax
	kmovd	%eax, %k1
	kmovd	%eax, %k2
	jmp	.L60
.L70:
	kxord	%k1, %k1, %k1
	kxord	%k2, %k2, %k2
	jmp	.L60
	.p2align 4,,10
	.p2align 3
.L67:
	vaddps	%zmm1, %zmm0, %zmm0
	vmovups	%zmm2, (%rdx){%k2}
	vmovups	(%rsi), %zmm2{%k1}{z}
	vaddps	%zmm2, %zmm0, %zmm0
	jmp	.L68
.L78:
	vxorps	%xmm1, %xmm1, %xmm1
	xorl	%eax, %eax
	vmovaps	%zmm1, %zmm3
	vmovaps	%zmm1, %zmm2
	vmovaps	%zmm1, %zmm0
	jmp	.L62
.L72:
	movl	$65535, %eax
	kmovd	%eax, %k2
	jmp	.L60
.L79:
	vzeroupper
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE8524:
	.size	_ZN12_GLOBAL__N_15microILi1ELi2ELi2EEEvPKfiS2_iS2_Pfiiib, .-_ZN12_GLOBAL__N_15microILi1ELi2ELi2EEEvPKfiS2_iS2_Pfiiib
	.p2align 4
	.type	_ZN12_GLOBAL__N_15microILi1ELi3ELi1EEEvPKfiS2_iS2_Pfiiib, @function
_ZN12_GLOBAL__N_15microILi1ELi3ELi1EEEvPKfiS2_iS2_Pfiiib:
.LFB8525:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rdx, %rax
	movslq	%ecx, %rdx
	movq	%rdi, %r11
	movl	%esi, %r10d
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	movl	32(%rbp), %ecx
	kmovd	40(%rbp), %k0
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	.cfi_offset 3, -56
	cmpl	$15, %ecx
	jg	.L81
	testl	%ecx, %ecx
	jle	.L90
	movl	$1, %esi
	shlx	%ecx, %esi, %ecx
	decl	%ecx
.L83:
	xorl	%edi, %edi
	xorl	%esi, %esi
	jmp	.L85
	.p2align 4,,10
	.p2align 3
.L81:
	leal	-16(%rcx), %esi
	cmpl	$15, %esi
	jle	.L100
	subl	$32, %ecx
	cmpl	$15, %ecx
	jle	.L101
	movl	$-1, %edi
	movl	$-1, %ecx
	movl	$-1, %esi
.L85:
	movslq	16(%rbp), %r14
	movslq	24(%rbp), %r13
	movzwl	%di, %edi
	movslq	%r10d, %r15
	movzwl	%cx, %ecx
	kmovd	%edi, %k2
	movzwl	%si, %edi
	movq	%r14, %r12
	leaq	0(,%r13,4), %rbx
	kmovd	%ecx, %k3
	kmovd	%edi, %k1
	imulq	%r15, %r12
	addq	%rbx, %rax
	testl	%r10d, %r10d
	jle	.L94
	vxorps	%xmm1, %xmm1, %xmm1
	leaq	(%r11,%r12,4), %r10
	leaq	0(,%rdx,4), %rsi
	addq	%r15, %r12
	leaq	(%r11,%r12,4), %rcx
	vmovaps	%zmm1, %zmm2
	vmovaps	%zmm1, %zmm3
	.p2align 4,,10
	.p2align 3
.L87:
	vbroadcastss	(%r10), %zmm0
	vmovups	(%rax), %zmm6{%k3}{z}
	addq	$4, %r10
	vmovups	64(%rax), %zmm5{%k2}{z}
	vmovups	128(%rax), %zmm4{%k1}{z}
	addq	%rsi, %rax
	vfmadd231ps	%zmm6, %zmm0, %zmm3
	vfmadd231ps	%zmm5, %zmm0, %zmm2
	vfmadd231ps	%zmm4, %zmm0, %zmm1
	cmpq	%rcx, %r10
	jne	.L87
.L86:
	imulq	%r14, %rdx
	vmovups	(%r8,%rbx), %zmm0{%k3}{z}
	vxorps	%xmm4, %xmm4, %xmm4
	leaq	64(%r8,%rbx), %rcx
	leaq	128(%r8,%rbx), %rdi
	vaddps	%zmm3, %zmm0, %zmm0
	leaq	(%rdx,%r13), %rax
	salq	$2, %rax
	kortestb	%k0, %k0
	leaq	(%r9,%rax), %rsi
	leaq	64(%r9,%rax), %rdx
	je	.L88
	vmaxps	%zmm4, %zmm0, %zmm0
	vmovups	%zmm0, (%rsi){%k3}
	vmovups	(%rcx), %zmm0{%k2}{z}
	vaddps	%zmm2, %zmm0, %zmm0
	vmaxps	%zmm4, %zmm0, %zmm0
	vmovups	%zmm0, (%rdx){%k2}
	vmovups	(%rdi), %zmm0{%k1}{z}
	vaddps	%zmm1, %zmm0, %zmm0
	vmaxps	%zmm4, %zmm0, %zmm1
.L89:
	vmovups	%zmm1, 128(%r9,%rax){%k1}
	vzeroupper
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
	.p2align 4,,10
	.p2align 3
.L88:
	.cfi_restore_state
	vmovups	%zmm0, (%rsi){%k3}
	vmovups	(%rcx), %zmm0{%k2}{z}
	vaddps	%zmm2, %zmm0, %zmm0
	vmovups	%zmm0, (%rdx){%k2}
	vmovups	(%rdi), %zmm0{%k1}{z}
	vaddps	%zmm0, %zmm1, %zmm1
	jmp	.L89
.L90:
	xorl	%edi, %edi
	xorl	%ecx, %ecx
	xorl	%esi, %esi
	jmp	.L85
.L100:
	testl	%esi, %esi
	je	.L91
	movl	$1, %edi
	movl	$-1, %ecx
	shlx	%esi, %edi, %edi
	xorl	%esi, %esi
	decl	%edi
	jmp	.L85
.L101:
	testl	%ecx, %ecx
	je	.L93
	movl	$1, %esi
	movl	$-1, %edi
	shlx	%ecx, %esi, %esi
	movl	$-1, %ecx
	decl	%esi
	jmp	.L85
.L94:
	vxorps	%xmm1, %xmm1, %xmm1
	vmovaps	%zmm1, %zmm2
	vmovaps	%zmm1, %zmm3
	jmp	.L86
.L91:
	orl	$-1, %ecx
	jmp	.L83
.L93:
	orl	$-1, %edi
	orl	$-1, %ecx
	xorl	%esi, %esi
	jmp	.L85
	.cfi_endproc
.LFE8525:
	.size	_ZN12_GLOBAL__N_15microILi1ELi3ELi1EEEvPKfiS2_iS2_Pfiiib, .-_ZN12_GLOBAL__N_15microILi1ELi3ELi1EEEvPKfiS2_iS2_Pfiiib
	.p2align 4
	.type	_ZN12_GLOBAL__N_15microILi1ELi4ELi1EEEvPKfiS2_iS2_Pfiiib, @function
_ZN12_GLOBAL__N_15microILi1ELi4ELi1EEEvPKfiS2_iS2_Pfiiib:
.LFB8526:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movslq	%ecx, %rax
	movl	%esi, %r11d
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	movq	%rdx, %r12
	pushq	%rbx
	andq	$-64, %rsp
	.cfi_offset 3, -56
	movl	32(%rbp), %ecx
	kmovd	40(%rbp), %k0
	cmpl	$15, %ecx
	jg	.L103
	testl	%ecx, %ecx
	jle	.L114
	movl	$1, %edx
	shlx	%ecx, %edx, %edx
	decl	%edx
.L105:
	xorl	%r10d, %r10d
	subl	$48, %ecx
	xorl	%esi, %esi
	movw	%r10w, -2(%rsp)
.L113:
	testl	%ecx, %ecx
	jle	.L118
	movl	$1, %r10d
	shlx	%ecx, %r10d, %ecx
	decl	%ecx
	jmp	.L108
	.p2align 4,,10
	.p2align 3
.L103:
	leal	-16(%rcx), %edx
	cmpl	$15, %edx
	jle	.L124
	leal	-32(%rcx), %edx
	cmpl	$15, %edx
	jle	.L125
	movl	$-1, %r13d
	subl	$48, %ecx
	movl	$-1, %esi
	movl	$-1, %edx
	movw	%r13w, -2(%rsp)
	cmpl	$15, %ecx
	jle	.L113
	movl	$-1, %ecx
.L108:
	movslq	16(%rbp), %r14
	movslq	24(%rbp), %r13
	movzwl	%si, %esi
	movslq	%r11d, %r15
	kmovw	-2(%rsp), %k3
	movzwl	%dx, %edx
	kmovd	%esi, %k2
	movzwl	%cx, %esi
	movq	%r14, %rbx
	leaq	0(,%r13,4), %r10
	kmovd	%edx, %k4
	kmovd	%esi, %k1
	imulq	%r15, %rbx
	addq	%r10, %r12
	testl	%r11d, %r11d
	jle	.L119
	vxorps	%xmm1, %xmm1, %xmm1
	movq	%r12, %r11
	leaq	(%rdi,%rbx,4), %r12
	addq	%r15, %rbx
	leaq	0(,%rax,4), %rcx
	leaq	(%rdi,%rbx,4), %rdx
	vmovaps	%zmm1, %zmm2
	vmovaps	%zmm1, %zmm3
	vmovaps	%zmm1, %zmm4
	.p2align 4,,10
	.p2align 3
.L110:
	vbroadcastss	(%r12), %zmm0
	vmovups	(%r11), %zmm8{%k4}{z}
	addq	$4, %r12
	vmovups	64(%r11), %zmm7{%k3}{z}
	vmovups	128(%r11), %zmm6{%k2}{z}
	vmovups	192(%r11), %zmm5{%k1}{z}
	vfmadd231ps	%zmm8, %zmm0, %zmm4
	addq	%rcx, %r11
	vfmadd231ps	%zmm7, %zmm0, %zmm3
	vfmadd231ps	%zmm6, %zmm0, %zmm2
	vfmadd231ps	%zmm5, %zmm0, %zmm1
	cmpq	%rdx, %r12
	jne	.L110
.L109:
	imulq	%r14, %rax
	vmovups	(%r8,%r10), %zmm0{%k4}{z}
	leaq	128(%r8,%r10), %r11
	vxorps	%xmm5, %xmm5, %xmm5
	leaq	192(%r8,%r10), %rdi
	leaq	64(%r8,%r10), %r8
	vaddps	%zmm4, %zmm0, %zmm0
	addq	%r13, %rax
	salq	$2, %rax
	kortestb	%k0, %k0
	leaq	(%r9,%rax), %rsi
	leaq	64(%r9,%rax), %rcx
	leaq	128(%r9,%rax), %rdx
	je	.L111
	vmaxps	%zmm5, %zmm0, %zmm0
	vmovups	%zmm0, (%rsi){%k4}
	vmovups	(%r8), %zmm0{%k3}{z}
	vaddps	%zmm3, %zmm0, %zmm0
	vmaxps	%zmm5, %zmm0, %zmm0
	vmovups	%zmm0, (%rcx){%k3}
	vmovups	(%r11), %zmm0{%k2}{z}
	vaddps	%zmm0, %zmm2, %zmm2
	vmaxps	%zmm5, %zmm2, %zmm2
	vmovups	%zmm2, (%rdx){%k2}
	vmovups	(%rdi), %zmm0{%k1}{z}
	vaddps	%zmm0, %zmm1, %zmm1
	vmaxps	%zmm5, %zmm1, %zmm1
.L112:
	vmovups	%zmm1, 192(%r9,%rax){%k1}
	vzeroupper
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
	.p2align 4,,10
	.p2align 3
.L111:
	.cfi_restore_state
	vmovups	%zmm0, (%rsi){%k4}
	vmovups	(%r8), %zmm0{%k3}{z}
	vaddps	%zmm0, %zmm3, %zmm3
	vmovups	%zmm3, (%rcx){%k3}
	vmovups	(%r11), %zmm0{%k2}{z}
	vaddps	%zmm2, %zmm0, %zmm0
	vmovups	%zmm0, (%rdx){%k2}
	vmovups	(%rdi), %zmm0{%k1}{z}
	vaddps	%zmm0, %zmm1, %zmm1
	jmp	.L112
.L114:
	xorl	%ebx, %ebx
	xorl	%edx, %edx
	movw	%bx, -2(%rsp)
.L104:
	xorl	%esi, %esi
	xorl	%ecx, %ecx
	jmp	.L108
.L124:
	testl	%edx, %edx
	je	.L115
	movl	$1, %ecx
	shlx	%edx, %ecx, %edx
	leal	-1(%rdx), %ebx
	movl	$-1, %edx
	movw	%bx, -2(%rsp)
	jmp	.L104
.L125:
	testl	%edx, %edx
	je	.L116
	movl	$1, %esi
	movl	$-1, %r14d
	xorl	%ecx, %ecx
	shlx	%edx, %esi, %esi
	movw	%r14w, -2(%rsp)
	decl	%esi
	movl	$-1, %edx
	jmp	.L108
.L119:
	vxorps	%xmm1, %xmm1, %xmm1
	vmovaps	%zmm1, %zmm2
	vmovaps	%zmm1, %zmm3
	vmovaps	%zmm1, %zmm4
	jmp	.L109
.L118:
	xorl	%ecx, %ecx
	jmp	.L108
.L116:
	movw	$-1, -2(%rsp)
	xorl	%esi, %esi
	orl	$-1, %edx
	xorl	%ecx, %ecx
	jmp	.L108
.L115:
	orl	$-1, %edx
	jmp	.L105
	.cfi_endproc
.LFE8526:
	.size	_ZN12_GLOBAL__N_15microILi1ELi4ELi1EEEvPKfiS2_iS2_Pfiiib, .-_ZN12_GLOBAL__N_15microILi1ELi4ELi1EEEvPKfiS2_iS2_Pfiiib
	.p2align 4
	.type	_ZN12_GLOBAL__N_15microILi2ELi2ELi1EEEvPKfiS2_iS2_Pfiiib, @function
_ZN12_GLOBAL__N_15microILi2ELi2ELi1EEEvPKfiS2_iS2_Pfiiib:
.LFB8528:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	vxorps	%xmm0, %xmm0, %xmm0
	movslq	%ecx, %r10
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r14
	pushq	%r13
	pushq	%r12
	.cfi_offset 14, -24
	.cfi_offset 13, -32
	.cfi_offset 12, -40
	movl	%esi, %r12d
	pushq	%rbx
	andq	$-64, %rsp
	subq	$320, %rsp
	.cfi_offset 3, -48
	movq	%fs:40, %rcx
	movq	%rcx, 312(%rsp)
	xorl	%ecx, %ecx
	movl	32(%rbp), %eax
	movl	40(%rbp), %r14d
	vmovaps	%zmm0, (%rsp)
	vmovaps	%zmm0, 64(%rsp)
	vmovaps	%zmm0, 128(%rsp)
	vmovaps	%zmm0, 192(%rsp)
	cmpl	$15, %eax
	jg	.L127
	testl	%eax, %eax
	jle	.L135
	movl	$1, %ecx
	kxord	%k1, %k1, %k1
	shlx	%eax, %ecx, %eax
	decl	%eax
	movzwl	%ax, %eax
	kmovd	%eax, %k2
.L128:
	movslq	16(%rbp), %rcx
	movslq	%r12d, %rsi
	movslq	24(%rbp), %r13
	movq	%rcx, %rbx
	leaq	0(,%r13,4), %r11
	imulq	%rsi, %rbx
	addq	%r11, %rdx
	leaq	0(,%rbx,4), %rax
	addq	%rsi, %rbx
	salq	$2, %rbx
	testl	%r12d, %r12d
	jle	.L133
	vxorps	%xmm3, %xmm3, %xmm3
	addq	%rdi, %rax
	leaq	0(,%r10,4), %r12
	addq	%rbx, %rdi
	vmovaps	%zmm3, %zmm2
	vmovaps	%zmm3, %zmm1
	vmovaps	%zmm3, %zmm0
	.p2align 4,,10
	.p2align 3
.L132:
	vmovups	(%rdx), %zmm6{%k2}{z}
	vmovups	64(%rdx), %zmm4{%k1}{z}
	addq	%r12, %rdx
	vbroadcastss	(%rax), %zmm5
	vfmadd231ps	%zmm6, %zmm5, %zmm0
	vfmadd231ps	%zmm4, %zmm5, %zmm1
	vbroadcastss	(%rax,%rsi,4), %zmm5
	addq	$4, %rax
	vfmadd231ps	%zmm6, %zmm5, %zmm2
	vfmadd231ps	%zmm4, %zmm5, %zmm3
	vmovaps	%zmm0, (%rsp)
	vmovaps	%zmm1, 64(%rsp)
	vmovaps	%zmm2, 128(%rsp)
	vmovaps	%zmm3, 192(%rsp)
	cmpq	%rdi, %rax
	jne	.L132
.L133:
	imulq	%r10, %rcx
	leaq	64(%r8,%r11), %rdx
	vxorps	%xmm1, %xmm1, %xmm1
	addq	%r8, %r11
	vmovups	(%r11), %zmm0{%k2}{z}
	leaq	0(%r13,%rcx), %rax
	vaddps	(%rsp), %zmm0, %zmm0
	salq	$2, %rax
	leaq	(%r9,%rax), %rsi
	testb	%r14b, %r14b
	jne	.L130
	vmovups	%zmm0, (%rsi){%k2}
	vmovups	(%rdx), %zmm0{%k1}{z}
	vaddps	64(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 64(%r9,%rax){%k1}
	leaq	(%rcx,%r10), %rax
	vmovups	(%r11), %zmm0{%k2}{z}
	addq	%r13, %rax
	salq	$2, %rax
	vaddps	128(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, (%r9,%rax){%k2}
	vmovups	(%rdx), %zmm0{%k1}{z}
	vaddps	192(%rsp), %zmm0, %zmm0
.L131:
	vmovups	%zmm0, 64(%r9,%rax){%k1}
	movq	312(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L141
	vzeroupper
	leaq	-32(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
	.p2align 4,,10
	.p2align 3
.L127:
	.cfi_restore_state
	subl	$16, %eax
	kmovd	%eax, %k1
	cmpl	$15, %eax
	jg	.L136
	kortestd	%k1, %k1
	je	.L137
	movl	$1, %eax
	kmovb	%k1, %ebx
	shlx	%ebx, %eax, %eax
	decl	%eax
	movzwl	%ax, %eax
	kmovd	%eax, %k1
	movl	$65535, %eax
	kmovd	%eax, %k2
	jmp	.L128
.L136:
	movl	$65535, %eax
	kmovd	%eax, %k1
	kmovd	%eax, %k2
	jmp	.L128
.L135:
	kxord	%k1, %k1, %k1
	kxord	%k2, %k2, %k2
	jmp	.L128
	.p2align 4,,10
	.p2align 3
.L130:
	vmaxps	%zmm1, %zmm0, %zmm0
	vmovups	%zmm0, (%rsi){%k2}
	vmovups	(%rdx), %zmm0{%k1}{z}
	vaddps	64(%rsp), %zmm0, %zmm0
	vmaxps	%zmm1, %zmm0, %zmm0
	vmovups	%zmm0, 64(%r9,%rax){%k1}
	leaq	(%rcx,%r10), %rax
	vmovups	(%r11), %zmm0{%k2}{z}
	addq	%r13, %rax
	salq	$2, %rax
	vaddps	128(%rsp), %zmm0, %zmm0
	vmaxps	%zmm1, %zmm0, %zmm0
	vmovups	%zmm0, (%r9,%rax){%k2}
	vmovups	(%rdx), %zmm0{%k1}{z}
	vaddps	192(%rsp), %zmm0, %zmm0
	vmaxps	%zmm1, %zmm0, %zmm0
	jmp	.L131
.L137:
	movl	$65535, %eax
	kmovd	%eax, %k2
	jmp	.L128
.L141:
	vzeroupper
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE8528:
	.size	_ZN12_GLOBAL__N_15microILi2ELi2ELi1EEEvPKfiS2_iS2_Pfiiib, .-_ZN12_GLOBAL__N_15microILi2ELi2ELi1EEEvPKfiS2_iS2_Pfiiib
	.p2align 4
	.type	_ZN12_GLOBAL__N_15microILi2ELi3ELi1EEEvPKfiS2_iS2_Pfiiib, @function
_ZN12_GLOBAL__N_15microILi2ELi3ELi1EEEvPKfiS2_iS2_Pfiiib:
.LFB8529:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rdx, %rax
	movq	%rdi, %r11
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	pushq	%r14
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	movq	%r8, %r14
	pushq	%r13
	.cfi_offset 13, -40
	movslq	%ecx, %r13
	pushq	%r12
	pushq	%rbx
	.cfi_offset 12, -48
	.cfi_offset 3, -56
	movl	%esi, %ebx
	andq	$-64, %rsp
	subq	$512, %rsp
	movq	%fs:40, %rcx
	movq	%rcx, 504(%rsp)
	xorl	%ecx, %ecx
	movl	32(%rbp), %edx
	kmovd	40(%rbp), %k0
	cmpl	$15, %edx
	jg	.L143
	testl	%edx, %edx
	jle	.L154
	movl	$1, %esi
	shlx	%edx, %esi, %esi
	decl	%esi
.L145:
	xorl	%r10d, %r10d
	xorl	%edi, %edi
	jmp	.L147
.L143:
	leal	-16(%rdx), %ecx
	cmpl	$15, %ecx
	jle	.L163
	subl	$32, %edx
	cmpl	$15, %edx
	jle	.L164
	movl	$-1, %r10d
	movl	$-1, %esi
	movl	$-1, %edi
.L147:
	movslq	16(%rbp), %rcx
	movslq	%ebx, %r8
	movzwl	%si, %esi
	vxorps	%xmm0, %xmm0, %xmm0
	movzwl	%di, %edi
	kmovd	%esi, %k2
	movzwl	%r10w, %esi
	vmovaps	%zmm0, 64(%rsp)
	movq	%rcx, %r12
	vmovaps	%zmm0, 128(%rsp)
	kmovd	%esi, %k3
	kmovd	%edi, %k1
	imulq	%r8, %r12
	vmovaps	%zmm0, 192(%rsp)
	vmovaps	%zmm0, 256(%rsp)
	vmovaps	%zmm0, 320(%rsp)
	leaq	0(,%r12,4), %rdx
	addq	%r8, %r12
	vmovaps	%zmm0, 384(%rsp)
	leaq	0(,%r12,4), %r15
	movq	%r15, 56(%rsp)
	movslq	24(%rbp), %r15
	leaq	0(,%r15,4), %r12
	addq	%r12, %rax
	testl	%ebx, %ebx
	jle	.L152
	movq	56(%rsp), %rdi
	vxorps	%xmm6, %xmm6, %xmm6
	addq	%r11, %rdx
	leaq	0(,%r13,4), %rbx
	vmovaps	%zmm6, %zmm5
	vmovaps	%zmm6, %zmm4
	vmovaps	%zmm6, %zmm3
	addq	%rdi, %r11
	vmovaps	%zmm6, %zmm2
	vmovaps	%zmm6, %zmm1
	.p2align 4,,10
	.p2align 3
.L151:
	vmovups	(%rax), %zmm9{%k2}{z}
	vmovups	64(%rax), %zmm8{%k3}{z}
	vmovups	128(%rax), %zmm7{%k1}{z}
	vbroadcastss	(%rdx), %zmm0
	addq	%rbx, %rax
	vfmadd231ps	%zmm9, %zmm0, %zmm1
	vfmadd231ps	%zmm8, %zmm0, %zmm2
	vfmadd231ps	%zmm7, %zmm0, %zmm3
	vbroadcastss	(%rdx,%r8,4), %zmm0
	addq	$4, %rdx
	vfmadd231ps	%zmm9, %zmm0, %zmm4
	vfmadd231ps	%zmm8, %zmm0, %zmm5
	vfmadd231ps	%zmm7, %zmm0, %zmm6
	vmovaps	%zmm1, 64(%rsp)
	vmovaps	%zmm2, 128(%rsp)
	vmovaps	%zmm3, 192(%rsp)
	vmovaps	%zmm4, 256(%rsp)
	vmovaps	%zmm5, 320(%rsp)
	vmovaps	%zmm6, 384(%rsp)
	cmpq	%rdx, %r11
	jne	.L151
.L152:
	leaq	64(%r14,%r12), %r8
	leaq	128(%r14,%r12), %rdx
	vxorps	%xmm1, %xmm1, %xmm1
	addq	%r14, %r12
	kortestb	%k0, %k0
	vmovups	(%r12), %zmm0{%k2}{z}
	vaddps	64(%rsp), %zmm0, %zmm0
	je	.L149
	imulq	%r13, %rcx
	vmaxps	%zmm1, %zmm0, %zmm0
	leaq	(%r15,%rcx), %rax
	salq	$2, %rax
	vmovups	%zmm0, (%r9,%rax){%k2}
	vmovups	(%r8), %zmm0{%k3}{z}
	vaddps	128(%rsp), %zmm0, %zmm0
	vmaxps	%zmm1, %zmm0, %zmm0
	vmovups	%zmm0, 64(%r9,%rax){%k3}
	vmovups	(%rdx), %zmm0{%k1}{z}
	vaddps	192(%rsp), %zmm0, %zmm0
	vmaxps	%zmm1, %zmm0, %zmm0
	vmovups	%zmm0, 128(%r9,%rax){%k1}
	leaq	(%rcx,%r13), %rax
	vmovups	(%r12), %zmm0{%k2}{z}
	addq	%r15, %rax
	salq	$2, %rax
	vaddps	256(%rsp), %zmm0, %zmm0
	vmaxps	%zmm1, %zmm0, %zmm0
	vmovups	%zmm0, (%r9,%rax){%k2}
	addq	$64, %rax
	vmovups	(%r8), %zmm0{%k3}{z}
	vaddps	320(%rsp), %zmm0, %zmm0
	vmaxps	%zmm1, %zmm0, %zmm0
	vmovups	%zmm0, (%r9,%rax){%k3}
	vmovups	(%rdx), %zmm0{%k1}{z}
	vaddps	384(%rsp), %zmm0, %zmm0
	vmaxps	%zmm1, %zmm0, %zmm0
.L150:
	vmovups	%zmm0, 64(%r9,%rax){%k1}
	movq	504(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L165
	vzeroupper
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
.L149:
	.cfi_restore_state
	imulq	%r13, %rcx
	leaq	(%r15,%rcx), %rax
	salq	$2, %rax
	vmovups	%zmm0, (%r9,%rax){%k2}
	vmovups	(%r8), %zmm0{%k3}{z}
	vaddps	128(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 64(%r9,%rax){%k3}
	vmovups	(%rdx), %zmm0{%k1}{z}
	vaddps	192(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 128(%r9,%rax){%k1}
	leaq	(%rcx,%r13), %rax
	vmovups	(%r12), %zmm0{%k2}{z}
	addq	%r15, %rax
	salq	$2, %rax
	vaddps	256(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, (%r9,%rax){%k2}
	addq	$64, %rax
	vmovups	(%r8), %zmm0{%k3}{z}
	vaddps	320(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, (%r9,%rax){%k3}
	vmovups	(%rdx), %zmm0{%k1}{z}
	vaddps	384(%rsp), %zmm0, %zmm0
	jmp	.L150
.L154:
	xorl	%r10d, %r10d
	xorl	%esi, %esi
	xorl	%edi, %edi
	jmp	.L147
.L163:
	testl	%ecx, %ecx
	je	.L155
	movl	$1, %r10d
	movl	$-1, %esi
	xorl	%edi, %edi
	shlx	%ecx, %r10d, %r10d
	decl	%r10d
	jmp	.L147
.L164:
	testl	%edx, %edx
	je	.L157
	movl	$1, %edi
	movl	$-1, %r10d
	movl	$-1, %esi
	shlx	%edx, %edi, %edi
	decl	%edi
	jmp	.L147
.L155:
	orl	$-1, %esi
	jmp	.L145
.L165:
	vzeroupper
	call	__stack_chk_fail@PLT
.L157:
	orl	$-1, %r10d
	orl	$-1, %esi
	xorl	%edi, %edi
	jmp	.L147
	.cfi_endproc
.LFE8529:
	.size	_ZN12_GLOBAL__N_15microILi2ELi3ELi1EEEvPKfiS2_iS2_Pfiiib, .-_ZN12_GLOBAL__N_15microILi2ELi3ELi1EEEvPKfiS2_iS2_Pfiiib
	.p2align 4
	.type	_ZN12_GLOBAL__N_15microILi2ELi4ELi1EEEvPKfiS2_iS2_Pfiiib, @function
_ZN12_GLOBAL__N_15microILi2ELi4ELi1EEEvPKfiS2_iS2_Pfiiib:
.LFB8530:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rdx, %rax
	vxorps	%xmm0, %xmm0, %xmm0
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	pushq	%r14
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	movq	%r8, %r14
	pushq	%r13
	.cfi_offset 13, -40
	movslq	%ecx, %r13
	pushq	%r12
	.cfi_offset 12, -48
	movl	%esi, %r12d
	pushq	%rbx
	andq	$-64, %rsp
	subq	$640, %rsp
	.cfi_offset 3, -56
	movl	32(%rbp), %edx
	movl	40(%rbp), %ebx
	movq	%rdi, 48(%rsp)
	movq	%fs:40, %rcx
	movq	%rcx, 632(%rsp)
	xorl	%ecx, %ecx
	vmovaps	%zmm0, 64(%rsp)
	vmovaps	%zmm0, 128(%rsp)
	vmovaps	%zmm0, 192(%rsp)
	vmovaps	%zmm0, 256(%rsp)
	vmovaps	%zmm0, 320(%rsp)
	vmovaps	%zmm0, 384(%rsp)
	vmovaps	%zmm0, 448(%rsp)
	vmovaps	%zmm0, 512(%rsp)
	cmpl	$15, %edx
	jg	.L167
	testl	%edx, %edx
	jle	.L180
	movl	$1, %ecx
	shlx	%edx, %ecx, %ecx
	decl	%ecx
.L169:
	xorl	%esi, %esi
	xorl	%edi, %edi
	subl	$48, %edx
	movw	%si, 62(%rsp)
	movw	%di, 60(%rsp)
.L178:
	testl	%edx, %edx
	jle	.L184
	movl	$1, %esi
	shlx	%edx, %esi, %esi
	decl	%esi
	jmp	.L172
.L167:
	leal	-16(%rdx), %ecx
	cmpl	$15, %ecx
	jle	.L189
	leal	-32(%rdx), %ecx
	cmpl	$15, %ecx
	jle	.L190
	movl	$-1, %r11d
	movl	$-1, %r15d
	subl	$48, %edx
	movl	$-1, %ecx
	movw	%r11w, 62(%rsp)
	movw	%r15w, 60(%rsp)
	cmpl	$15, %edx
	jle	.L178
	movl	$-1, %esi
.L172:
	movslq	16(%rbp), %rdi
	movslq	%r12d, %r8
	movslq	24(%rbp), %r11
	movzwl	%cx, %ecx
	kmovw	62(%rsp), %k3
	kmovw	60(%rsp), %k2
	kmovd	%ecx, %k4
	movzwl	%si, %ecx
	movq	%rdi, %r10
	leaq	0(,%r11,4), %r15
	kmovd	%ecx, %k1
	imulq	%r8, %r10
	addq	%r15, %rax
	leaq	0(,%r10,4), %rdx
	addq	%r8, %r10
	salq	$2, %r10
	testl	%r12d, %r12d
	jle	.L177
	movq	48(%rsp), %rsi
	vxorps	%xmm8, %xmm8, %xmm8
	leaq	0(,%r13,4), %r12
	vmovaps	%zmm8, %zmm7
	vmovaps	%zmm8, %zmm6
	vmovaps	%zmm8, %zmm5
	addq	%rsi, %rdx
	vmovaps	%zmm8, %zmm4
	vmovaps	%zmm8, %zmm3
	addq	%rsi, %r10
	vmovaps	%zmm8, %zmm2
	vmovaps	%zmm8, %zmm1
	.p2align 4,,10
	.p2align 3
.L176:
	vmovups	(%rax), %zmm12{%k4}{z}
	vmovups	64(%rax), %zmm11{%k3}{z}
	vmovups	128(%rax), %zmm10{%k2}{z}
	vmovups	192(%rax), %zmm9{%k1}{z}
	addq	%r12, %rax
	vbroadcastss	(%rdx), %zmm0
	vfmadd231ps	%zmm12, %zmm0, %zmm1
	vfmadd231ps	%zmm11, %zmm0, %zmm2
	vfmadd231ps	%zmm10, %zmm0, %zmm3
	vfmadd231ps	%zmm9, %zmm0, %zmm4
	vbroadcastss	(%rdx,%r8,4), %zmm0
	addq	$4, %rdx
	vfmadd231ps	%zmm12, %zmm0, %zmm5
	vfmadd231ps	%zmm11, %zmm0, %zmm6
	vfmadd231ps	%zmm10, %zmm0, %zmm7
	vfmadd231ps	%zmm9, %zmm0, %zmm8
	vmovaps	%zmm1, 64(%rsp)
	vmovaps	%zmm2, 128(%rsp)
	vmovaps	%zmm3, 192(%rsp)
	vmovaps	%zmm4, 256(%rsp)
	vmovaps	%zmm5, 320(%rsp)
	vmovaps	%zmm6, 384(%rsp)
	vmovaps	%zmm7, 448(%rsp)
	vmovaps	%zmm8, 512(%rsp)
	cmpq	%rdx, %r10
	jne	.L176
.L177:
	leaq	64(%r14,%r15), %rsi
	leaq	128(%r14,%r15), %rcx
	vxorps	%xmm1, %xmm1, %xmm1
	leaq	192(%r14,%r15), %rdx
	addq	%r14, %r15
	vmovups	(%r15), %zmm0{%k4}{z}
	vaddps	64(%rsp), %zmm0, %zmm0
	testb	%bl, %bl
	je	.L174
	movq	%rdi, %rax
	vmaxps	%zmm1, %zmm0, %zmm0
	imulq	%r13, %rax
	leaq	(%r11,%rax), %rdi
	addq	%r13, %rax
	salq	$2, %rdi
	addq	%r11, %rax
	vmovups	%zmm0, (%r9,%rdi){%k4}
	salq	$2, %rax
	vmovups	(%rsi), %zmm0{%k3}{z}
	vaddps	128(%rsp), %zmm0, %zmm0
	vmaxps	%zmm1, %zmm0, %zmm0
	vmovups	%zmm0, 64(%r9,%rdi){%k3}
	vmovups	(%rcx), %zmm0{%k2}{z}
	vaddps	192(%rsp), %zmm0, %zmm0
	vmaxps	%zmm1, %zmm0, %zmm0
	vmovups	%zmm0, 128(%r9,%rdi){%k2}
	vmovups	(%rdx), %zmm0{%k1}{z}
	vaddps	256(%rsp), %zmm0, %zmm0
	vmaxps	%zmm1, %zmm0, %zmm0
	vmovups	%zmm0, 192(%r9,%rdi){%k1}
	vmovups	(%r15), %zmm0{%k4}{z}
	vaddps	320(%rsp), %zmm0, %zmm0
	vmaxps	%zmm1, %zmm0, %zmm0
	vmovups	%zmm0, (%r9,%rax){%k4}
	vmovups	(%rsi), %zmm0{%k3}{z}
	leaq	64(%rax), %rsi
	vaddps	384(%rsp), %zmm0, %zmm0
	vmaxps	%zmm1, %zmm0, %zmm0
	vmovups	%zmm0, (%r9,%rsi){%k3}
	vmovups	(%rcx), %zmm0{%k2}{z}
	vaddps	448(%rsp), %zmm0, %zmm0
	vmaxps	%zmm1, %zmm0, %zmm0
	vmovups	%zmm0, 128(%r9,%rax){%k2}
	vmovups	(%rdx), %zmm0{%k1}{z}
	vaddps	512(%rsp), %zmm0, %zmm0
	vmaxps	%zmm1, %zmm0, %zmm0
.L175:
	vmovups	%zmm0, 128(%r9,%rsi){%k1}
	movq	632(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L191
	vzeroupper
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
.L174:
	.cfi_restore_state
	imulq	%r13, %rdi
	leaq	(%r11,%rdi), %rax
	salq	$2, %rax
	vmovups	%zmm0, (%r9,%rax){%k4}
	vmovups	(%rsi), %zmm0{%k3}{z}
	vaddps	128(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 64(%r9,%rax){%k3}
	vmovups	(%rcx), %zmm0{%k2}{z}
	vaddps	192(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 128(%r9,%rax){%k2}
	vmovups	(%rdx), %zmm0{%k1}{z}
	vaddps	256(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 192(%r9,%rax){%k1}
	leaq	0(%r13,%rdi), %rax
	vmovups	(%r15), %zmm0{%k4}{z}
	addq	%r11, %rax
	salq	$2, %rax
	vaddps	320(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, (%r9,%rax){%k4}
	vmovups	(%rsi), %zmm0{%k3}{z}
	leaq	64(%rax), %rsi
	vaddps	384(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, (%r9,%rsi){%k3}
	vmovups	(%rcx), %zmm0{%k2}{z}
	vaddps	448(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 128(%r9,%rax){%k2}
	vmovups	(%rdx), %zmm0{%k1}{z}
	vaddps	512(%rsp), %zmm0, %zmm0
	jmp	.L175
.L180:
	xorl	%r10d, %r10d
	xorl	%ecx, %ecx
	movw	%r10w, 62(%rsp)
.L168:
	xorl	%r8d, %r8d
	xorl	%esi, %esi
	movw	%r8w, 60(%rsp)
	jmp	.L172
.L189:
	testl	%ecx, %ecx
	je	.L181
	movl	$1, %r11d
	shlx	%ecx, %r11d, %r11d
	leal	-1(%r11), %edi
	movl	$-1, %ecx
	movw	%di, 62(%rsp)
	jmp	.L168
.L190:
	testl	%ecx, %ecx
	je	.L182
	movl	$1, %edi
	movl	$-1, %edx
	xorl	%esi, %esi
	shlx	%ecx, %edi, %edi
	decl	%edi
	movw	%dx, 62(%rsp)
	movl	$-1, %ecx
	movw	%di, 60(%rsp)
	jmp	.L172
.L184:
	xorl	%esi, %esi
	jmp	.L172
.L191:
	vzeroupper
	call	__stack_chk_fail@PLT
.L182:
	movw	$-1, 62(%rsp)
	orl	$-1, %ecx
	xorl	%esi, %esi
	movw	$0, 60(%rsp)
	jmp	.L172
.L181:
	orl	$-1, %ecx
	jmp	.L169
	.cfi_endproc
.LFE8530:
	.size	_ZN12_GLOBAL__N_15microILi2ELi4ELi1EEEvPKfiS2_iS2_Pfiiib, .-_ZN12_GLOBAL__N_15microILi2ELi4ELi1EEEvPKfiS2_iS2_Pfiiib
	.p2align 4
	.type	_ZN12_GLOBAL__N_15microILi3ELi2ELi1EEEvPKfiS2_iS2_Pfiiib, @function
_ZN12_GLOBAL__N_15microILi3ELi2ELi1EEEvPKfiS2_iS2_Pfiiib:
.LFB8532:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rdx, %rax
	vxorps	%xmm0, %xmm0, %xmm0
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	pushq	%r14
	pushq	%r13
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	movl	%esi, %r13d
	pushq	%r12
	.cfi_offset 12, -48
	movq	%rdi, %r12
	pushq	%rbx
	.cfi_offset 3, -56
	movslq	%ecx, %rbx
	andq	$-64, %rsp
	subq	$448, %rsp
	movq	%fs:40, %rcx
	movq	%rcx, 440(%rsp)
	xorl	%ecx, %ecx
	movl	32(%rbp), %edx
	movl	40(%rbp), %r15d
	vmovaps	%zmm0, (%rsp)
	vmovaps	%zmm0, 64(%rsp)
	vmovaps	%zmm0, 128(%rsp)
	vmovaps	%zmm0, 192(%rsp)
	vmovaps	%zmm0, 256(%rsp)
	vmovaps	%zmm0, 320(%rsp)
	cmpl	$15, %edx
	jg	.L193
	testl	%edx, %edx
	jle	.L201
	movl	$1, %ecx
	kxord	%k1, %k1, %k1
	shlx	%edx, %ecx, %edx
	decl	%edx
	movzwl	%dx, %esi
	kmovd	%esi, %k2
.L194:
	movslq	16(%rbp), %rsi
	movslq	%r13d, %rdi
	movslq	24(%rbp), %r14
	movq	%rdi, %r11
	leaq	0(,%rsi,4), %rdx
	imulq	%rdx, %r11
	leaq	4(%rdx), %r10
	addq	$8, %rdx
	imulq	%rdi, %rdx
	imulq	%rdi, %r10
	addq	%r12, %r11
	leaq	(%r12,%rdx), %rcx
	addq	%r12, %r10
	leaq	0(,%r14,4), %r12
	leaq	(%rax,%r12), %rdx
	testl	%r13d, %r13d
	jle	.L199
	vxorps	%xmm7, %xmm7, %xmm7
	leaq	0(,%rbx,4), %r13
	salq	$2, %rdi
	xorl	%eax, %eax
	vmovaps	%zmm7, %zmm6
	vmovaps	%zmm7, %zmm5
	vmovaps	%zmm7, %zmm4
	vmovaps	%zmm7, %zmm3
	vmovaps	%zmm7, %zmm2
	.p2align 4,,10
	.p2align 3
.L198:
	vmovups	(%rdx), %zmm1{%k2}{z}
	vmovups	64(%rdx), %zmm0{%k1}{z}
	addq	%r13, %rdx
	vbroadcastss	(%r11,%rax), %zmm8
	vfmadd231ps	%zmm1, %zmm8, %zmm2
	vfmadd231ps	%zmm0, %zmm8, %zmm3
	vbroadcastss	(%r10,%rax), %zmm8
	vfmadd231ps	%zmm1, %zmm8, %zmm4
	vfmadd231ps	%zmm0, %zmm8, %zmm5
	vbroadcastss	(%rcx,%rax), %zmm8
	addq	$4, %rax
	vfmadd231ps	%zmm1, %zmm8, %zmm6
	vfmadd231ps	%zmm0, %zmm8, %zmm7
	vmovaps	%zmm2, (%rsp)
	vmovaps	%zmm3, 64(%rsp)
	vmovaps	%zmm4, 128(%rsp)
	vmovaps	%zmm5, 192(%rsp)
	vmovaps	%zmm6, 256(%rsp)
	vmovaps	%zmm7, 320(%rsp)
	cmpq	%rdi, %rax
	jne	.L198
.L199:
	leaq	64(%r8,%r12), %rdx
	addq	%r8, %r12
	testb	%r15b, %r15b
	je	.L196
	vmovups	(%r12), %zmm1{%k2}{z}
	imulq	%rbx, %rsi
	vxorps	%xmm0, %xmm0, %xmm0
	vaddps	(%rsp), %zmm1, %zmm1
	leaq	(%r14,%rsi), %rax
	salq	$2, %rax
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, (%r9,%rax){%k2}
	vmovups	(%rdx), %zmm1{%k1}{z}
	vaddps	64(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, 64(%r9,%rax){%k1}
	leaq	(%rsi,%rbx), %rax
	vmovups	(%r12), %zmm1{%k2}{z}
	leaq	(%r14,%rax), %rcx
	addq	%rbx, %rax
	salq	$2, %rcx
	addq	%r14, %rax
	vaddps	128(%rsp), %zmm1, %zmm1
	salq	$2, %rax
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, (%r9,%rcx){%k2}
	vmovups	(%rdx), %zmm1{%k1}{z}
	vaddps	192(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, 64(%r9,%rcx){%k1}
	vmovups	(%r12), %zmm1{%k2}{z}
	vaddps	256(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, (%r9,%rax){%k2}
	vmovups	(%rdx), %zmm1{%k1}{z}
	vaddps	320(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm0
	vmovups	%zmm0, 64(%r9,%rax){%k1}
.L192:
	movq	440(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L207
	vzeroupper
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
.L193:
	.cfi_restore_state
	leal	-16(%rdx), %esi
	kmovd	%esi, %k1
	cmpl	$15, %esi
	jg	.L202
	kortestd	%k1, %k1
	je	.L203
	movl	$1, %edx
	shlx	%esi, %edx, %edx
	decl	%edx
	movzwl	%dx, %esi
	kmovd	%esi, %k1
	movl	$65535, %esi
	kmovd	%esi, %k2
	jmp	.L194
.L202:
	movl	$65535, %esi
	kmovd	%esi, %k1
	kmovd	%esi, %k2
	jmp	.L194
.L201:
	kxord	%k1, %k1, %k1
	kxord	%k2, %k2, %k2
	jmp	.L194
.L196:
	vmovups	(%r12), %zmm0{%k2}{z}
	imulq	%rbx, %rsi
	vaddps	(%rsp), %zmm0, %zmm0
	leaq	(%r14,%rsi), %rax
	salq	$2, %rax
	vmovups	%zmm0, (%r9,%rax){%k2}
	vmovups	(%rdx), %zmm0{%k1}{z}
	vaddps	64(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 64(%r9,%rax){%k1}
	leaq	(%rsi,%rbx), %rax
	vmovups	(%r12), %zmm0{%k2}{z}
	leaq	(%r14,%rax), %rcx
	addq	%rbx, %rax
	salq	$2, %rcx
	addq	%r14, %rax
	vaddps	128(%rsp), %zmm0, %zmm0
	salq	$2, %rax
	vmovups	%zmm0, (%r9,%rcx){%k2}
	vmovups	(%rdx), %zmm0{%k1}{z}
	vaddps	192(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 64(%r9,%rcx){%k1}
	vmovups	(%r12), %zmm0{%k2}{z}
	vaddps	256(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, (%r9,%rax){%k2}
	vmovups	(%rdx), %zmm0{%k1}{z}
	vaddps	320(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 64(%r9,%rax){%k1}
	jmp	.L192
.L203:
	movl	$65535, %esi
	kmovd	%esi, %k2
	jmp	.L194
.L207:
	vzeroupper
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE8532:
	.size	_ZN12_GLOBAL__N_15microILi3ELi2ELi1EEEvPKfiS2_iS2_Pfiiib, .-_ZN12_GLOBAL__N_15microILi3ELi2ELi1EEEvPKfiS2_iS2_Pfiiib
	.p2align 4
	.type	_ZN12_GLOBAL__N_15microILi3ELi3ELi1EEEvPKfiS2_iS2_Pfiiib, @function
_ZN12_GLOBAL__N_15microILi3ELi3ELi1EEEvPKfiS2_iS2_Pfiiib:
.LFB8533:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rdx, %rax
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	pushq	%r14
	pushq	%r13
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	movq	%r8, %r13
	pushq	%r12
	.cfi_offset 12, -48
	movslq	%ecx, %r12
	pushq	%rbx
	.cfi_offset 3, -56
	movl	%esi, %ebx
	andq	$-64, %rsp
	subq	$704, %rsp
	movq	%fs:40, %rcx
	movq	%rcx, 696(%rsp)
	xorl	%ecx, %ecx
	movl	32(%rbp), %edx
	kmovd	40(%rbp), %k0
	cmpl	$15, %edx
	jg	.L209
	testl	%edx, %edx
	jle	.L220
	movl	$1, %ecx
	shlx	%edx, %ecx, %edx
	decl	%edx
.L211:
	xorl	%ecx, %ecx
	movw	%cx, 62(%rsp)
	xorl	%ecx, %ecx
	jmp	.L213
.L209:
	leal	-16(%rdx), %ecx
	cmpl	$15, %ecx
	jle	.L228
	subl	$32, %edx
	cmpl	$15, %edx
	jle	.L229
	movl	$-1, %r8d
	movl	$-1, %edx
	movl	$-1, %ecx
	movw	%r8w, 62(%rsp)
.L213:
	movslq	16(%rbp), %rsi
	movslq	%ebx, %r10
	movslq	24(%rbp), %r15
	vxorps	%xmm0, %xmm0, %xmm0
	kmovw	62(%rsp), %k2
	movq	%r10, %r8
	movzwl	%dx, %edx
	movzwl	%cx, %ecx
	vmovaps	%zmm0, 64(%rsp)
	leaq	0(,%rsi,4), %r14
	vmovaps	%zmm0, 128(%rsp)
	kmovd	%edx, %k1
	kmovd	%ecx, %k3
	imulq	%r14, %r8
	leaq	4(%r14), %r11
	addq	$8, %r14
	vmovaps	%zmm0, 192(%rsp)
	imulq	%r10, %r14
	vmovaps	%zmm0, 256(%rsp)
	imulq	%r10, %r11
	vmovaps	%zmm0, 320(%rsp)
	addq	%rdi, %r8
	vmovaps	%zmm0, 384(%rsp)
	vmovaps	%zmm0, 448(%rsp)
	addq	%rdi, %r11
	addq	%r14, %rdi
	leaq	0(,%r15,4), %r14
	vmovaps	%zmm0, 512(%rsp)
	vmovaps	%zmm0, 576(%rsp)
	addq	%r14, %rax
	testl	%ebx, %ebx
	jle	.L218
	vxorps	%xmm12, %xmm12, %xmm12
	leaq	0(,%r12,4), %rdx
	salq	$2, %r10
	xorl	%ebx, %ebx
	vmovaps	%zmm12, %zmm11
	vmovaps	%zmm12, %zmm10
	vmovaps	%zmm12, %zmm9
	vmovaps	%zmm12, %zmm8
	vmovaps	%zmm12, %zmm7
	vmovaps	%zmm12, %zmm6
	vmovaps	%zmm12, %zmm5
	vmovaps	%zmm12, %zmm4
	.p2align 4,,10
	.p2align 3
.L217:
	vmovups	(%rax), %zmm3{%k1}{z}
	vmovups	64(%rax), %zmm2{%k2}{z}
	vmovups	128(%rax), %zmm0{%k3}{z}
	vbroadcastss	(%r8,%rbx), %zmm1
	addq	%rdx, %rax
	vfmadd231ps	%zmm3, %zmm1, %zmm4
	vfmadd231ps	%zmm2, %zmm1, %zmm5
	vfmadd231ps	%zmm0, %zmm1, %zmm6
	vbroadcastss	(%r11,%rbx), %zmm1
	vfmadd231ps	%zmm3, %zmm1, %zmm7
	vfmadd231ps	%zmm2, %zmm1, %zmm8
	vfmadd231ps	%zmm0, %zmm1, %zmm9
	vbroadcastss	(%rdi,%rbx), %zmm1
	addq	$4, %rbx
	vmovaps	%zmm4, 64(%rsp)
	vfmadd231ps	%zmm3, %zmm1, %zmm10
	vfmadd231ps	%zmm2, %zmm1, %zmm11
	vmovaps	%zmm5, 128(%rsp)
	vfmadd231ps	%zmm0, %zmm1, %zmm12
	vmovaps	%zmm6, 192(%rsp)
	vmovaps	%zmm7, 256(%rsp)
	vmovaps	%zmm8, 320(%rsp)
	vmovaps	%zmm9, 384(%rsp)
	vmovaps	%zmm10, 448(%rsp)
	vmovaps	%zmm11, 512(%rsp)
	vmovaps	%zmm12, 576(%rsp)
	cmpq	%r10, %rbx
	jne	.L217
.L218:
	leaq	64(%r13,%r14), %rcx
	leaq	128(%r13,%r14), %rdx
	addq	%r13, %r14
	kortestb	%k0, %k0
	je	.L215
	vmovups	(%r14), %zmm1{%k1}{z}
	movq	%rsi, %rax
	vxorps	%xmm0, %xmm0, %xmm0
	imulq	%r12, %rax
	vaddps	64(%rsp), %zmm1, %zmm1
	leaq	(%r15,%rax), %rsi
	addq	%r12, %rax
	vmaxps	%zmm0, %zmm1, %zmm1
	salq	$2, %rsi
	vmovups	%zmm1, (%r9,%rsi){%k1}
	vmovups	(%rcx), %zmm1{%k2}{z}
	vaddps	128(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, 64(%r9,%rsi){%k2}
	vmovups	(%rdx), %zmm1{%k3}{z}
	vaddps	192(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, 128(%r9,%rsi){%k3}
	leaq	(%r15,%rax), %rsi
	addq	%r12, %rax
	vmovups	(%r14), %zmm1{%k1}{z}
	salq	$2, %rsi
	addq	%r15, %rax
	salq	$2, %rax
	vaddps	256(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, (%r9,%rsi){%k1}
	vmovups	(%rcx), %zmm1{%k2}{z}
	vaddps	320(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, 64(%r9,%rsi){%k2}
	vmovups	(%rdx), %zmm1{%k3}{z}
	vaddps	384(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, 128(%r9,%rsi){%k3}
	vmovups	(%r14), %zmm1{%k1}{z}
	vaddps	448(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, (%r9,%rax){%k1}
	vmovups	(%rcx), %zmm1{%k2}{z}
	vaddps	512(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, 64(%r9,%rax){%k2}
	vmovups	(%rdx), %zmm1{%k3}{z}
	vaddps	576(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm0
	vmovups	%zmm0, 128(%r9,%rax){%k3}
.L208:
	movq	696(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L230
	vzeroupper
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
.L215:
	.cfi_restore_state
	movq	%rsi, %rax
	vmovups	(%r14), %zmm0{%k1}{z}
	imulq	%r12, %rax
	vaddps	64(%rsp), %zmm0, %zmm0
	leaq	(%r15,%rax), %rsi
	addq	%r12, %rax
	salq	$2, %rsi
	vmovups	%zmm0, (%r9,%rsi){%k1}
	vmovups	(%rcx), %zmm0{%k2}{z}
	vaddps	128(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 64(%r9,%rsi){%k2}
	vmovups	(%rdx), %zmm0{%k3}{z}
	vaddps	192(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 128(%r9,%rsi){%k3}
	leaq	(%r15,%rax), %rsi
	addq	%r12, %rax
	vmovups	(%r14), %zmm0{%k1}{z}
	salq	$2, %rsi
	addq	%r15, %rax
	salq	$2, %rax
	vaddps	256(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, (%r9,%rsi){%k1}
	vmovups	(%rcx), %zmm0{%k2}{z}
	vaddps	320(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 64(%r9,%rsi){%k2}
	vmovups	(%rdx), %zmm0{%k3}{z}
	vaddps	384(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 128(%r9,%rsi){%k3}
	vmovups	(%r14), %zmm0{%k1}{z}
	vaddps	448(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, (%r9,%rax){%k1}
	vmovups	(%rcx), %zmm0{%k2}{z}
	vaddps	512(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 64(%r9,%rax){%k2}
	vmovups	(%rdx), %zmm0{%k3}{z}
	vaddps	576(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 128(%r9,%rax){%k3}
	jmp	.L208
.L220:
	xorl	%esi, %esi
	xorl	%edx, %edx
	xorl	%ecx, %ecx
	movw	%si, 62(%rsp)
	jmp	.L213
.L228:
	testl	%ecx, %ecx
	je	.L221
	movl	$1, %edx
	shlx	%ecx, %edx, %edx
	leal	-1(%rdx), %ecx
	movl	$-1, %edx
	movw	%cx, 62(%rsp)
	xorl	%ecx, %ecx
	jmp	.L213
.L229:
	testl	%edx, %edx
	je	.L223
	movl	$1, %ecx
	movl	$-1, %r10d
	shlx	%edx, %ecx, %ecx
	movw	%r10w, 62(%rsp)
	decl	%ecx
	movl	$-1, %edx
	jmp	.L213
.L221:
	orl	$-1, %edx
	jmp	.L211
.L230:
	vzeroupper
	call	__stack_chk_fail@PLT
.L223:
	movw	$-1, 62(%rsp)
	orl	$-1, %edx
	xorl	%ecx, %ecx
	jmp	.L213
	.cfi_endproc
.LFE8533:
	.size	_ZN12_GLOBAL__N_15microILi3ELi3ELi1EEEvPKfiS2_iS2_Pfiiib, .-_ZN12_GLOBAL__N_15microILi3ELi3ELi1EEEvPKfiS2_iS2_Pfiiib
	.p2align 4
	.type	_ZN12_GLOBAL__N_15microILi3ELi4ELi1EEEvPKfiS2_iS2_Pfiiib, @function
_ZN12_GLOBAL__N_15microILi3ELi4ELi1EEEvPKfiS2_iS2_Pfiiib:
.LFB8534:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	vxorps	%xmm0, %xmm0, %xmm0
	movq	%rdi, %r11
	movq	%rdx, %rax
	movq	%r8, %rdi
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	pushq	%r14
	pushq	%r13
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	movslq	%ecx, %r13
	pushq	%r12
	pushq	%rbx
	.cfi_offset 12, -48
	.cfi_offset 3, -56
	movl	%esi, %ebx
	andq	$-64, %rsp
	subq	$896, %rsp
	movq	%fs:40, %rdx
	movq	%rdx, 888(%rsp)
	xorl	%edx, %edx
	movl	32(%rbp), %ecx
	kmovd	40(%rbp), %k0
	vmovaps	%zmm0, 64(%rsp)
	vmovaps	%zmm0, 128(%rsp)
	vmovaps	%zmm0, 192(%rsp)
	vmovaps	%zmm0, 256(%rsp)
	vmovaps	%zmm0, 320(%rsp)
	vmovaps	%zmm0, 384(%rsp)
	vmovaps	%zmm0, 448(%rsp)
	vmovaps	%zmm0, 512(%rsp)
	vmovaps	%zmm0, 576(%rsp)
	vmovaps	%zmm0, 640(%rsp)
	vmovaps	%zmm0, 704(%rsp)
	vmovaps	%zmm0, 768(%rsp)
	cmpl	$15, %ecx
	jg	.L232
	testl	%ecx, %ecx
	jle	.L245
	movl	$1, %edx
	shlx	%ecx, %edx, %edx
	decl	%edx
.L234:
	xorl	%r8d, %r8d
	subl	$48, %ecx
	xorl	%esi, %esi
	movw	%r8w, 62(%rsp)
.L243:
	testl	%ecx, %ecx
	jle	.L249
	movl	$1, %r8d
	shlx	%ecx, %r8d, %ecx
	decl	%ecx
	jmp	.L237
.L245:
	xorl	%r10d, %r10d
	xorl	%edx, %edx
	movw	%r10w, 62(%rsp)
.L233:
	xorl	%esi, %esi
	xorl	%ecx, %ecx
	.p2align 4,,10
	.p2align 3
.L237:
	movslq	16(%rbp), %r15
	movslq	%ebx, %r10
	movzwl	%si, %esi
	movzwl	%dx, %edx
	kmovw	62(%rsp), %k2
	movq	%r10, %r14
	kmovd	%esi, %k3
	movzwl	%cx, %esi
	kmovd	%edx, %k1
	leaq	0(,%r15,4), %r8
	movq	%r15, 48(%rsp)
	movslq	24(%rbp), %r15
	kmovd	%esi, %k4
	imulq	%r8, %r14
	leaq	4(%r8), %r12
	addq	$8, %r8
	imulq	%r10, %r12
	imulq	%r10, %r8
	addq	%r11, %r14
	addq	%r11, %r12
	addq	%r11, %r8
	leaq	0(,%r15,4), %r11
	addq	%r11, %rax
	testl	%ebx, %ebx
	jle	.L242
	vxorps	%xmm16, %xmm16, %xmm16
	leaq	0(,%r13,4), %rdx
	salq	$2, %r10
	xorl	%ebx, %ebx
	vmovaps	%zmm16, %zmm15
	vmovaps	%zmm16, %zmm14
	vmovaps	%zmm16, %zmm13
	vmovaps	%zmm16, %zmm12
	vmovaps	%zmm16, %zmm11
	vmovaps	%zmm16, %zmm10
	vmovaps	%zmm16, %zmm9
	vmovaps	%zmm16, %zmm8
	vmovaps	%zmm16, %zmm7
	vmovaps	%zmm16, %zmm6
	vmovaps	%zmm16, %zmm5
	.p2align 4,,10
	.p2align 3
.L241:
	vmovups	(%rax), %zmm4{%k1}{z}
	vmovups	64(%rax), %zmm3{%k2}{z}
	vmovups	128(%rax), %zmm2{%k3}{z}
	vmovups	192(%rax), %zmm1{%k4}{z}
	addq	%rdx, %rax
	vbroadcastss	(%r14,%rbx), %zmm0
	vfmadd231ps	%zmm4, %zmm0, %zmm5
	vfmadd231ps	%zmm3, %zmm0, %zmm6
	vfmadd231ps	%zmm2, %zmm0, %zmm7
	vfmadd231ps	%zmm1, %zmm0, %zmm8
	vbroadcastss	(%r12,%rbx), %zmm0
	vfmadd231ps	%zmm4, %zmm0, %zmm9
	vfmadd231ps	%zmm3, %zmm0, %zmm10
	vfmadd231ps	%zmm2, %zmm0, %zmm11
	vfmadd231ps	%zmm1, %zmm0, %zmm12
	vbroadcastss	(%r8,%rbx), %zmm0
	addq	$4, %rbx
	vmovaps	%zmm5, 64(%rsp)
	vfmadd231ps	%zmm4, %zmm0, %zmm13
	vfmadd231ps	%zmm3, %zmm0, %zmm14
	vmovaps	%zmm6, 128(%rsp)
	vfmadd231ps	%zmm2, %zmm0, %zmm15
	vfmadd231ps	%zmm1, %zmm0, %zmm16
	vmovaps	%zmm7, 192(%rsp)
	vmovaps	%zmm8, 256(%rsp)
	vmovaps	%zmm9, 320(%rsp)
	vmovaps	%zmm10, 384(%rsp)
	vmovaps	%zmm11, 448(%rsp)
	vmovaps	%zmm12, 512(%rsp)
	vmovaps	%zmm13, 576(%rsp)
	vmovaps	%zmm14, 640(%rsp)
	vmovaps	%zmm15, 704(%rsp)
	vmovaps	%zmm16, 768(%rsp)
	cmpq	%r10, %rbx
	jne	.L241
.L242:
	leaq	64(%rdi,%r11), %rsi
	leaq	128(%rdi,%r11), %rcx
	leaq	192(%rdi,%r11), %rdx
	addq	%rdi, %r11
	kortestb	%k0, %k0
	je	.L239
	vmovups	(%r11), %zmm1{%k1}{z}
	movq	48(%rsp), %rax
	vxorps	%xmm0, %xmm0, %xmm0
	imulq	%r13, %rax
	vaddps	64(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	leaq	(%r15,%rax), %rdi
	addq	%r13, %rax
	salq	$2, %rdi
	vmovups	%zmm1, (%r9,%rdi){%k1}
	vmovups	(%rsi), %zmm1{%k2}{z}
	vaddps	128(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, 64(%r9,%rdi){%k2}
	vmovups	(%rcx), %zmm1{%k3}{z}
	vaddps	192(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, 128(%r9,%rdi){%k3}
	vmovups	(%rdx), %zmm1{%k4}{z}
	vaddps	256(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, 192(%r9,%rdi){%k4}
	leaq	(%r15,%rax), %rdi
	addq	%r13, %rax
	vmovups	(%r11), %zmm1{%k1}{z}
	salq	$2, %rdi
	addq	%r15, %rax
	salq	$2, %rax
	vaddps	320(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, (%r9,%rdi){%k1}
	vmovups	(%rsi), %zmm1{%k2}{z}
	vaddps	384(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, 64(%r9,%rdi){%k2}
	vmovups	(%rcx), %zmm1{%k3}{z}
	vaddps	448(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, 128(%r9,%rdi){%k3}
	vmovups	(%rdx), %zmm1{%k4}{z}
	vaddps	512(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, 192(%r9,%rdi){%k4}
	vmovups	(%r11), %zmm1{%k1}{z}
	vaddps	576(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, (%r9,%rax){%k1}
	vmovups	(%rsi), %zmm1{%k2}{z}
	vaddps	640(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, 64(%r9,%rax){%k2}
	vmovups	(%rcx), %zmm1{%k3}{z}
	vaddps	704(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, 128(%r9,%rax){%k3}
	vmovups	(%rdx), %zmm1{%k4}{z}
	vaddps	768(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm0
	vmovups	%zmm0, 192(%r9,%rax){%k4}
.L231:
	movq	888(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L253
	vzeroupper
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
.L232:
	.cfi_restore_state
	leal	-16(%rcx), %edx
	cmpl	$15, %edx
	jle	.L254
	leal	-32(%rcx), %edx
	cmpl	$15, %edx
	jle	.L255
	movl	$-1, %r12d
	subl	$48, %ecx
	movl	$-1, %esi
	movl	$-1, %edx
	movw	%r12w, 62(%rsp)
	cmpl	$15, %ecx
	jle	.L243
	movl	$-1, %ecx
	jmp	.L237
.L239:
	movq	48(%rsp), %rax
	vmovups	(%r11), %zmm0{%k1}{z}
	imulq	%r13, %rax
	vaddps	64(%rsp), %zmm0, %zmm0
	leaq	(%r15,%rax), %rdi
	addq	%r13, %rax
	salq	$2, %rdi
	vmovups	%zmm0, (%r9,%rdi){%k1}
	vmovups	(%rsi), %zmm0{%k2}{z}
	vaddps	128(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 64(%r9,%rdi){%k2}
	vmovups	(%rcx), %zmm0{%k3}{z}
	vaddps	192(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 128(%r9,%rdi){%k3}
	vmovups	(%rdx), %zmm0{%k4}{z}
	vaddps	256(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 192(%r9,%rdi){%k4}
	leaq	(%r15,%rax), %rdi
	addq	%r13, %rax
	vmovups	(%r11), %zmm0{%k1}{z}
	salq	$2, %rdi
	addq	%r15, %rax
	salq	$2, %rax
	vaddps	320(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, (%r9,%rdi){%k1}
	vmovups	(%rsi), %zmm0{%k2}{z}
	vaddps	384(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 64(%r9,%rdi){%k2}
	vmovups	(%rcx), %zmm0{%k3}{z}
	vaddps	448(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 128(%r9,%rdi){%k3}
	vmovups	(%rdx), %zmm0{%k4}{z}
	vaddps	512(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 192(%r9,%rdi){%k4}
	vmovups	(%r11), %zmm0{%k1}{z}
	vaddps	576(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, (%r9,%rax){%k1}
	vmovups	(%rsi), %zmm0{%k2}{z}
	vaddps	640(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 64(%r9,%rax){%k2}
	vmovups	(%rcx), %zmm0{%k3}{z}
	vaddps	704(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 128(%r9,%rax){%k3}
	vmovups	(%rdx), %zmm0{%k4}{z}
	vaddps	768(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 192(%r9,%rax){%k4}
	jmp	.L231
.L255:
	testl	%edx, %edx
	je	.L247
	movl	$1, %esi
	movl	$-1, %r14d
	xorl	%ecx, %ecx
	shlx	%edx, %esi, %esi
	movw	%r14w, 62(%rsp)
	decl	%esi
	movl	$-1, %edx
	jmp	.L237
.L254:
	testl	%edx, %edx
	je	.L246
	movl	$1, %ecx
	shlx	%edx, %ecx, %edx
	leal	-1(%rdx), %esi
	movl	$-1, %edx
	movw	%si, 62(%rsp)
	jmp	.L233
.L249:
	xorl	%ecx, %ecx
	jmp	.L237
.L253:
	vzeroupper
	call	__stack_chk_fail@PLT
.L246:
	orl	$-1, %edx
	jmp	.L234
.L247:
	movw	$-1, 62(%rsp)
	xorl	%esi, %esi
	orl	$-1, %edx
	xorl	%ecx, %ecx
	jmp	.L237
	.cfi_endproc
.LFE8534:
	.size	_ZN12_GLOBAL__N_15microILi3ELi4ELi1EEEvPKfiS2_iS2_Pfiiib, .-_ZN12_GLOBAL__N_15microILi3ELi4ELi1EEEvPKfiS2_iS2_Pfiiib
	.p2align 4
	.type	_ZN12_GLOBAL__N_15microILi4ELi1ELi1EEEvPKfiS2_iS2_Pfiiib, @function
_ZN12_GLOBAL__N_15microILi4ELi1ELi1EEEvPKfiS2_iS2_Pfiiib:
.LFB8535:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	vxorps	%xmm0, %xmm0, %xmm0
	movq	%rdx, %rax
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	pushq	%r14
	pushq	%r13
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	movslq	%ecx, %r13
	pushq	%r12
	.cfi_offset 12, -48
	movl	%esi, %r12d
	pushq	%rbx
	.cfi_offset 3, -56
	movq	%rdi, %rbx
	andq	$-64, %rsp
	subq	$384, %rsp
	movl	32(%rbp), %ecx
	movl	40(%rbp), %r14d
	movq	%r8, 56(%rsp)
	movq	%fs:40, %rdx
	movq	%rdx, 376(%rsp)
	xorl	%edx, %edx
	vmovaps	%zmm0, 64(%rsp)
	movl	$-1, %edx
	vmovaps	%zmm0, 128(%rsp)
	vmovaps	%zmm0, 192(%rsp)
	vmovaps	%zmm0, 256(%rsp)
	cmpl	$15, %ecx
	jg	.L257
	movl	$1, %edx
	shlx	%ecx, %edx, %edx
	decl	%edx
	testl	%ecx, %ecx
	movl	$0, %ecx
	cmovle	%ecx, %edx
.L257:
	movslq	16(%rbp), %rsi
	movslq	%r12d, %rdi
	movslq	24(%rbp), %r15
	movzwl	%dx, %edx
	movq	%rdi, %r8
	kmovd	%edx, %k1
	leaq	0(,%rsi,4), %rcx
	imulq	%rcx, %r8
	leaq	4(%rcx), %r10
	imulq	%rdi, %r10
	leaq	8(%rcx), %r11
	addq	$12, %rcx
	imulq	%rdi, %r11
	imulq	%rdi, %rcx
	addq	%rbx, %r8
	addq	%rbx, %r10
	addq	%rbx, %r11
	addq	%rbx, %rcx
	leaq	0(,%r15,4), %rbx
	testl	%r12d, %r12d
	jle	.L262
	vxorps	%xmm4, %xmm4, %xmm4
	leaq	0(,%r13,4), %rdx
	addq	%rbx, %rax
	salq	$2, %rdi
	vmovaps	%zmm4, %zmm3
	vmovaps	%zmm4, %zmm2
	vmovaps	%zmm4, %zmm1
	xorl	%r12d, %r12d
	.p2align 4,,10
	.p2align 3
.L261:
	vmovups	(%rax), %zmm0{%k1}{z}
	addq	%rdx, %rax
	vfmadd231ps	(%r8,%r12){1to16}, %zmm0, %zmm1
	vfmadd231ps	(%r10,%r12){1to16}, %zmm0, %zmm2
	vfmadd231ps	(%r11,%r12){1to16}, %zmm0, %zmm3
	vfmadd231ps	(%rcx,%r12){1to16}, %zmm0, %zmm4
	addq	$4, %r12
	vmovaps	%zmm1, 64(%rsp)
	vmovaps	%zmm2, 128(%rsp)
	vmovaps	%zmm3, 192(%rsp)
	vmovaps	%zmm4, 256(%rsp)
	cmpq	%r12, %rdi
	jne	.L261
.L262:
	movq	56(%rsp), %rax
	addq	%rbx, %rax
	movq	%rax, %rbx
	testb	%r14b, %r14b
	je	.L259
	vmovups	(%rax), %zmm0{%k1}{z}
	vxorps	%xmm1, %xmm1, %xmm1
	imulq	%r13, %rsi
	vaddps	64(%rsp), %zmm0, %zmm0
	leaq	(%r15,%rsi), %rax
	vmaxps	%zmm1, %zmm0, %zmm0
	vmovups	%zmm0, (%r9,%rax,4){%k1}
	leaq	0(%r13,%rsi), %rax
	vmovups	(%rbx), %zmm0{%k1}{z}
	leaq	(%r15,%rax), %rdx
	addq	%r13, %rax
	vaddps	128(%rsp), %zmm0, %zmm0
	vmaxps	%zmm1, %zmm0, %zmm0
	vmovups	%zmm0, (%r9,%rdx,4){%k1}
	leaq	(%r15,%rax), %rdx
	addq	%r13, %rax
	vmovups	(%rbx), %zmm0{%k1}{z}
	addq	%r15, %rax
	vaddps	192(%rsp), %zmm0, %zmm0
	vmaxps	%zmm1, %zmm0, %zmm0
	vmovups	%zmm0, (%r9,%rdx,4){%k1}
	vmovups	(%rbx), %zmm0{%k1}{z}
	vaddps	256(%rsp), %zmm0, %zmm0
	vmaxps	%zmm1, %zmm0, %zmm0
	vmovups	%zmm0, (%r9,%rax,4){%k1}
.L256:
	movq	376(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L269
	vzeroupper
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
.L259:
	.cfi_restore_state
	vmovups	(%rax), %zmm0{%k1}{z}
	imulq	%r13, %rsi
	vaddps	64(%rsp), %zmm0, %zmm0
	leaq	(%r15,%rsi), %rax
	vmovups	%zmm0, (%r9,%rax,4){%k1}
	leaq	0(%r13,%rsi), %rax
	vmovups	(%rbx), %zmm0{%k1}{z}
	leaq	(%r15,%rax), %rdx
	addq	%r13, %rax
	vaddps	128(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, (%r9,%rdx,4){%k1}
	leaq	(%r15,%rax), %rdx
	addq	%r13, %rax
	vmovups	(%rbx), %zmm0{%k1}{z}
	addq	%r15, %rax
	vaddps	192(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, (%r9,%rdx,4){%k1}
	vmovups	(%rbx), %zmm0{%k1}{z}
	vaddps	256(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, (%r9,%rax,4){%k1}
	jmp	.L256
.L269:
	vzeroupper
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE8535:
	.size	_ZN12_GLOBAL__N_15microILi4ELi1ELi1EEEvPKfiS2_iS2_Pfiiib, .-_ZN12_GLOBAL__N_15microILi4ELi1ELi1EEEvPKfiS2_iS2_Pfiiib
	.p2align 4
	.type	_ZN12_GLOBAL__N_15microILi4ELi2ELi1EEEvPKfiS2_iS2_Pfiiib, @function
_ZN12_GLOBAL__N_15microILi4ELi2ELi1EEEvPKfiS2_iS2_Pfiiib:
.LFB8536:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rdx, %rax
	vxorps	%xmm0, %xmm0, %xmm0
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	pushq	%r14
	pushq	%r13
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	movslq	%ecx, %r13
	pushq	%r12
	.cfi_offset 12, -48
	movl	%esi, %r12d
	pushq	%rbx
	.cfi_offset 3, -56
	movq	%rdi, %rbx
	andq	$-64, %rsp
	subq	$576, %rsp
	movq	%fs:40, %rcx
	movq	%rcx, 568(%rsp)
	xorl	%ecx, %ecx
	movl	32(%rbp), %edx
	kmovd	40(%rbp), %k0
	vmovaps	%zmm0, (%rsp)
	vmovaps	%zmm0, 64(%rsp)
	vmovaps	%zmm0, 128(%rsp)
	vmovaps	%zmm0, 192(%rsp)
	vmovaps	%zmm0, 256(%rsp)
	vmovaps	%zmm0, 320(%rsp)
	vmovaps	%zmm0, 384(%rsp)
	vmovaps	%zmm0, 448(%rsp)
	cmpl	$15, %edx
	jg	.L271
	testl	%edx, %edx
	jle	.L279
	movl	$1, %ecx
	kxord	%k1, %k1, %k1
	shlx	%edx, %ecx, %edx
	decl	%edx
	movzwl	%dx, %esi
	kmovd	%esi, %k2
.L272:
	movslq	16(%rbp), %rdx
	movslq	%r12d, %rsi
	movslq	24(%rbp), %r14
	movq	%rsi, %r11
	leaq	0(,%rdx,4), %rcx
	imulq	%rcx, %r11
	leaq	4(%rcx), %rdi
	imulq	%rsi, %rdi
	leaq	8(%rcx), %r10
	addq	$12, %rcx
	imulq	%rsi, %r10
	imulq	%rsi, %rcx
	addq	%rbx, %r11
	addq	%rbx, %rdi
	addq	%rbx, %r10
	addq	%rbx, %rcx
	leaq	0(,%r14,4), %rbx
	addq	%rbx, %rax
	testl	%r12d, %r12d
	jle	.L277
	vxorps	%xmm9, %xmm9, %xmm9
	movq	%rax, %r15
	leaq	0(,%r13,4), %r12
	salq	$2, %rsi
	vmovaps	%zmm9, %zmm8
	vmovaps	%zmm9, %zmm7
	vmovaps	%zmm9, %zmm6
	xorl	%eax, %eax
	vmovaps	%zmm9, %zmm5
	vmovaps	%zmm9, %zmm4
	vmovaps	%zmm9, %zmm3
	vmovaps	%zmm9, %zmm2
	.p2align 4,,10
	.p2align 3
.L276:
	vmovups	(%r15), %zmm1{%k2}{z}
	vmovups	64(%r15), %zmm0{%k1}{z}
	addq	%r12, %r15
	vbroadcastss	(%r11,%rax), %zmm10
	vfmadd231ps	%zmm1, %zmm10, %zmm2
	vfmadd231ps	%zmm0, %zmm10, %zmm3
	vbroadcastss	(%rdi,%rax), %zmm10
	vfmadd231ps	%zmm1, %zmm10, %zmm4
	vfmadd231ps	%zmm0, %zmm10, %zmm5
	vbroadcastss	(%r10,%rax), %zmm10
	vfmadd231ps	%zmm1, %zmm10, %zmm6
	vfmadd231ps	%zmm0, %zmm10, %zmm7
	vbroadcastss	(%rcx,%rax), %zmm10
	addq	$4, %rax
	vmovaps	%zmm2, (%rsp)
	vfmadd231ps	%zmm1, %zmm10, %zmm8
	vfmadd231ps	%zmm0, %zmm10, %zmm9
	vmovaps	%zmm3, 64(%rsp)
	vmovaps	%zmm4, 128(%rsp)
	vmovaps	%zmm5, 192(%rsp)
	vmovaps	%zmm6, 256(%rsp)
	vmovaps	%zmm7, 320(%rsp)
	vmovaps	%zmm8, 384(%rsp)
	vmovaps	%zmm9, 448(%rsp)
	cmpq	%rax, %rsi
	jne	.L276
.L277:
	leaq	64(%r8,%rbx), %rcx
	addq	%r8, %rbx
	kortestb	%k0, %k0
	je	.L274
	vmovups	(%rbx), %zmm1{%k2}{z}
	imulq	%r13, %rdx
	vxorps	%xmm0, %xmm0, %xmm0
	vaddps	(%rsp), %zmm1, %zmm1
	leaq	(%r14,%rdx), %rax
	salq	$2, %rax
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, (%r9,%rax){%k2}
	vmovups	(%rcx), %zmm1{%k1}{z}
	vaddps	64(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, 64(%r9,%rax){%k1}
	leaq	(%rdx,%r13), %rax
	vmovups	(%rbx), %zmm1{%k2}{z}
	leaq	(%r14,%rax), %rdx
	addq	%r13, %rax
	salq	$2, %rdx
	vaddps	128(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, (%r9,%rdx){%k2}
	vmovups	(%rcx), %zmm1{%k1}{z}
	vaddps	192(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, 64(%r9,%rdx){%k1}
	leaq	(%r14,%rax), %rdx
	addq	%r13, %rax
	vmovups	(%rbx), %zmm1{%k2}{z}
	salq	$2, %rdx
	addq	%r14, %rax
	salq	$2, %rax
	vaddps	256(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, (%r9,%rdx){%k2}
	vmovups	(%rcx), %zmm1{%k1}{z}
	vaddps	320(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, 64(%r9,%rdx){%k1}
	vmovups	(%rbx), %zmm1{%k2}{z}
	vaddps	384(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, (%r9,%rax){%k2}
	vmovups	(%rcx), %zmm1{%k1}{z}
	vaddps	448(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm0
	vmovups	%zmm0, 64(%r9,%rax){%k1}
.L270:
	movq	568(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L285
	vzeroupper
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
.L279:
	.cfi_restore_state
	kxord	%k1, %k1, %k1
	kxord	%k2, %k2, %k2
	jmp	.L272
.L271:
	leal	-16(%rdx), %edi
	kmovd	%edi, %k1
	cmpl	$15, %edi
	jg	.L280
	kortestd	%k1, %k1
	je	.L281
	movl	$1, %edx
	shlx	%edi, %edx, %edx
	decl	%edx
	movl	$65535, %edi
	movzwl	%dx, %esi
	kmovd	%edi, %k2
	kmovd	%esi, %k1
	jmp	.L272
.L274:
	vmovups	(%rbx), %zmm0{%k2}{z}
	imulq	%r13, %rdx
	vaddps	(%rsp), %zmm0, %zmm0
	leaq	(%r14,%rdx), %rax
	salq	$2, %rax
	vmovups	%zmm0, (%r9,%rax){%k2}
	vmovups	(%rcx), %zmm0{%k1}{z}
	vaddps	64(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 64(%r9,%rax){%k1}
	leaq	(%rdx,%r13), %rax
	vmovups	(%rbx), %zmm0{%k2}{z}
	leaq	(%r14,%rax), %rdx
	addq	%r13, %rax
	salq	$2, %rdx
	vaddps	128(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, (%r9,%rdx){%k2}
	vmovups	(%rcx), %zmm0{%k1}{z}
	vaddps	192(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 64(%r9,%rdx){%k1}
	leaq	(%r14,%rax), %rdx
	addq	%r13, %rax
	vmovups	(%rbx), %zmm0{%k2}{z}
	salq	$2, %rdx
	addq	%r14, %rax
	salq	$2, %rax
	vaddps	256(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, (%r9,%rdx){%k2}
	vmovups	(%rcx), %zmm0{%k1}{z}
	vaddps	320(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 64(%r9,%rdx){%k1}
	vmovups	(%rbx), %zmm0{%k2}{z}
	vaddps	384(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, (%r9,%rax){%k2}
	vmovups	(%rcx), %zmm0{%k1}{z}
	vaddps	448(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 64(%r9,%rax){%k1}
	jmp	.L270
.L280:
	movl	$65535, %esi
	movl	$65535, %edi
	kmovd	%esi, %k1
	kmovd	%edi, %k2
	jmp	.L272
.L281:
	movl	$65535, %esi
	kmovd	%esi, %k2
	jmp	.L272
.L285:
	vzeroupper
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE8536:
	.size	_ZN12_GLOBAL__N_15microILi4ELi2ELi1EEEvPKfiS2_iS2_Pfiiib, .-_ZN12_GLOBAL__N_15microILi4ELi2ELi1EEEvPKfiS2_iS2_Pfiiib
	.p2align 4
	.type	_ZN12_GLOBAL__N_15microILi4ELi3ELi1EEEvPKfiS2_iS2_Pfiiib, @function
_ZN12_GLOBAL__N_15microILi4ELi3ELi1EEEvPKfiS2_iS2_Pfiiib:
.LFB8537:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rdx, %rax
	movq	%rdi, %r11
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	pushq	%r14
	pushq	%r13
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	movslq	%ecx, %r13
	pushq	%r12
	pushq	%rbx
	.cfi_offset 12, -48
	.cfi_offset 3, -56
	movl	%esi, %ebx
	movq	%r8, %rsi
	andq	$-64, %rsp
	subq	$896, %rsp
	movq	%fs:40, %rcx
	movq	%rcx, 888(%rsp)
	xorl	%ecx, %ecx
	movl	32(%rbp), %edx
	kmovd	40(%rbp), %k0
	cmpl	$15, %edx
	jg	.L287
	testl	%edx, %edx
	jle	.L298
	movl	$1, %ecx
	shlx	%edx, %ecx, %edx
	decl	%edx
.L289:
	xorl	%ecx, %ecx
	movw	%cx, 62(%rsp)
	xorl	%ecx, %ecx
	jmp	.L291
.L287:
	leal	-16(%rdx), %ecx
	cmpl	$15, %ecx
	jle	.L306
	subl	$32, %edx
	cmpl	$15, %edx
	jle	.L307
	movl	$-1, %r8d
	movl	$-1, %edx
	movl	$-1, %ecx
	movw	%r8w, 62(%rsp)
.L291:
	movslq	16(%rbp), %rdi
	movslq	%ebx, %r8
	movslq	24(%rbp), %r15
	vxorps	%xmm0, %xmm0, %xmm0
	kmovw	62(%rsp), %k3
	movq	%r8, %r14
	movzwl	%dx, %edx
	movzwl	%cx, %ecx
	vmovaps	%zmm0, 64(%rsp)
	movq	%rdi, 48(%rsp)
	salq	$2, %rdi
	kmovd	%edx, %k1
	kmovd	%ecx, %k2
	imulq	%rdi, %r14
	leaq	4(%rdi), %r10
	vmovaps	%zmm0, 128(%rsp)
	imulq	%r8, %r10
	leaq	8(%rdi), %r12
	addq	$12, %rdi
	vmovaps	%zmm0, 192(%rsp)
	imulq	%r8, %r12
	vmovaps	%zmm0, 256(%rsp)
	imulq	%r8, %rdi
	addq	%r11, %r14
	vmovaps	%zmm0, 320(%rsp)
	addq	%r11, %r10
	vmovaps	%zmm0, 384(%rsp)
	addq	%r11, %r12
	vmovaps	%zmm0, 448(%rsp)
	addq	%r11, %rdi
	leaq	0(,%r15,4), %r11
	vmovaps	%zmm0, 512(%rsp)
	vmovaps	%zmm0, 576(%rsp)
	addq	%r11, %rax
	vmovaps	%zmm0, 640(%rsp)
	vmovaps	%zmm0, 704(%rsp)
	vmovaps	%zmm0, 768(%rsp)
	testl	%ebx, %ebx
	jle	.L296
	vxorps	%xmm15, %xmm15, %xmm15
	leaq	0(,%r13,4), %rdx
	salq	$2, %r8
	xorl	%ebx, %ebx
	vmovaps	%zmm15, %zmm14
	vmovaps	%zmm15, %zmm13
	vmovaps	%zmm15, %zmm12
	vmovaps	%zmm15, %zmm11
	vmovaps	%zmm15, %zmm10
	vmovaps	%zmm15, %zmm9
	vmovaps	%zmm15, %zmm8
	vmovaps	%zmm15, %zmm7
	vmovaps	%zmm15, %zmm6
	vmovaps	%zmm15, %zmm5
	vmovaps	%zmm15, %zmm4
	.p2align 4,,10
	.p2align 3
.L295:
	vmovups	(%rax), %zmm2{%k1}{z}
	vmovups	64(%rax), %zmm1{%k3}{z}
	vmovups	128(%rax), %zmm0{%k2}{z}
	vbroadcastss	(%r14,%rbx), %zmm3
	addq	%rdx, %rax
	vfmadd231ps	%zmm2, %zmm3, %zmm4
	vfmadd231ps	%zmm1, %zmm3, %zmm5
	vfmadd231ps	%zmm0, %zmm3, %zmm6
	vbroadcastss	(%r10,%rbx), %zmm3
	vfmadd231ps	%zmm2, %zmm3, %zmm7
	vfmadd231ps	%zmm1, %zmm3, %zmm8
	vfmadd231ps	%zmm0, %zmm3, %zmm9
	vbroadcastss	(%r12,%rbx), %zmm3
	vmovaps	%zmm4, 64(%rsp)
	vfmadd231ps	%zmm2, %zmm3, %zmm10
	vfmadd231ps	%zmm1, %zmm3, %zmm11
	vmovaps	%zmm5, 128(%rsp)
	vfmadd231ps	%zmm0, %zmm3, %zmm12
	vbroadcastss	(%rdi,%rbx), %zmm3
	addq	$4, %rbx
	vmovaps	%zmm6, 192(%rsp)
	vmovaps	%zmm7, 256(%rsp)
	vfmadd231ps	%zmm2, %zmm3, %zmm13
	vfmadd231ps	%zmm1, %zmm3, %zmm14
	vmovaps	%zmm8, 320(%rsp)
	vfmadd231ps	%zmm0, %zmm3, %zmm15
	vmovaps	%zmm9, 384(%rsp)
	vmovaps	%zmm10, 448(%rsp)
	vmovaps	%zmm11, 512(%rsp)
	vmovaps	%zmm12, 576(%rsp)
	vmovaps	%zmm13, 640(%rsp)
	vmovaps	%zmm14, 704(%rsp)
	vmovaps	%zmm15, 768(%rsp)
	cmpq	%r8, %rbx
	jne	.L295
.L296:
	leaq	64(%rsi,%r11), %rcx
	leaq	128(%rsi,%r11), %rdx
	addq	%rsi, %r11
	kortestb	%k0, %k0
	je	.L293
	vmovups	(%r11), %zmm1{%k1}{z}
	movq	48(%rsp), %rax
	vxorps	%xmm0, %xmm0, %xmm0
	imulq	%r13, %rax
	vaddps	64(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	leaq	(%r15,%rax), %rsi
	addq	%r13, %rax
	salq	$2, %rsi
	vmovups	%zmm1, (%r9,%rsi){%k1}
	vmovups	(%rcx), %zmm1{%k3}{z}
	vaddps	128(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, 64(%r9,%rsi){%k3}
	vmovups	(%rdx), %zmm1{%k2}{z}
	vaddps	192(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, 128(%r9,%rsi){%k2}
	leaq	(%r15,%rax), %rsi
	addq	%r13, %rax
	vmovups	(%r11), %zmm1{%k1}{z}
	salq	$2, %rsi
	vaddps	256(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, (%r9,%rsi){%k1}
	vmovups	(%rcx), %zmm1{%k3}{z}
	vaddps	320(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, 64(%r9,%rsi){%k3}
	vmovups	(%rdx), %zmm1{%k2}{z}
	vaddps	384(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, 128(%r9,%rsi){%k2}
	leaq	(%r15,%rax), %rsi
	addq	%r13, %rax
	vmovups	(%r11), %zmm1{%k1}{z}
	salq	$2, %rsi
	addq	%r15, %rax
	salq	$2, %rax
	vaddps	448(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, (%r9,%rsi){%k1}
	vmovups	(%rcx), %zmm1{%k3}{z}
	vaddps	512(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, 64(%r9,%rsi){%k3}
	vmovups	(%rdx), %zmm1{%k2}{z}
	vaddps	576(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, 128(%r9,%rsi){%k2}
	vmovups	(%r11), %zmm1{%k1}{z}
	vaddps	640(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, (%r9,%rax){%k1}
	vmovups	(%rcx), %zmm1{%k3}{z}
	vaddps	704(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, 64(%r9,%rax){%k3}
	vmovups	(%rdx), %zmm1{%k2}{z}
	vaddps	768(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm0
	vmovups	%zmm0, 128(%r9,%rax){%k2}
.L286:
	movq	888(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L308
	vzeroupper
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
.L293:
	.cfi_restore_state
	movq	48(%rsp), %rax
	vmovups	(%r11), %zmm0{%k1}{z}
	imulq	%r13, %rax
	vaddps	64(%rsp), %zmm0, %zmm0
	leaq	(%r15,%rax), %rsi
	addq	%r13, %rax
	salq	$2, %rsi
	vmovups	%zmm0, (%r9,%rsi){%k1}
	vmovups	(%rcx), %zmm0{%k3}{z}
	vaddps	128(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 64(%r9,%rsi){%k3}
	vmovups	(%rdx), %zmm0{%k2}{z}
	vaddps	192(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 128(%r9,%rsi){%k2}
	leaq	(%r15,%rax), %rsi
	addq	%r13, %rax
	vmovups	(%r11), %zmm0{%k1}{z}
	salq	$2, %rsi
	vaddps	256(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, (%r9,%rsi){%k1}
	vmovups	(%rcx), %zmm0{%k3}{z}
	vaddps	320(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 64(%r9,%rsi){%k3}
	vmovups	(%rdx), %zmm0{%k2}{z}
	vaddps	384(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 128(%r9,%rsi){%k2}
	leaq	(%r15,%rax), %rsi
	addq	%r13, %rax
	vmovups	(%r11), %zmm0{%k1}{z}
	salq	$2, %rsi
	addq	%r15, %rax
	salq	$2, %rax
	vaddps	448(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, (%r9,%rsi){%k1}
	vmovups	(%rcx), %zmm0{%k3}{z}
	vaddps	512(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 64(%r9,%rsi){%k3}
	vmovups	(%rdx), %zmm0{%k2}{z}
	vaddps	576(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 128(%r9,%rsi){%k2}
	vmovups	(%r11), %zmm0{%k1}{z}
	vaddps	640(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, (%r9,%rax){%k1}
	vmovups	(%rcx), %zmm0{%k3}{z}
	vaddps	704(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 64(%r9,%rax){%k3}
	vmovups	(%rdx), %zmm0{%k2}{z}
	vaddps	768(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 128(%r9,%rax){%k2}
	jmp	.L286
.L298:
	xorl	%edi, %edi
	xorl	%edx, %edx
	xorl	%ecx, %ecx
	movw	%di, 62(%rsp)
	jmp	.L291
.L306:
	testl	%ecx, %ecx
	je	.L299
	movl	$1, %edx
	shlx	%ecx, %edx, %edx
	leal	-1(%rdx), %ecx
	movl	$-1, %edx
	movw	%cx, 62(%rsp)
	xorl	%ecx, %ecx
	jmp	.L291
.L307:
	testl	%edx, %edx
	je	.L301
	movl	$1, %ecx
	movl	$-1, %r10d
	shlx	%edx, %ecx, %ecx
	movw	%r10w, 62(%rsp)
	decl	%ecx
	movl	$-1, %edx
	jmp	.L291
.L299:
	orl	$-1, %edx
	jmp	.L289
.L308:
	vzeroupper
	call	__stack_chk_fail@PLT
.L301:
	movw	$-1, 62(%rsp)
	orl	$-1, %edx
	xorl	%ecx, %ecx
	jmp	.L291
	.cfi_endproc
.LFE8537:
	.size	_ZN12_GLOBAL__N_15microILi4ELi3ELi1EEEvPKfiS2_iS2_Pfiiib, .-_ZN12_GLOBAL__N_15microILi4ELi3ELi1EEEvPKfiS2_iS2_Pfiiib
	.p2align 4
	.type	_ZN12_GLOBAL__N_15microILi4ELi4ELi1EEEvPKfiS2_iS2_Pfiiib, @function
_ZN12_GLOBAL__N_15microILi4ELi4ELi1EEEvPKfiS2_iS2_Pfiiib:
.LFB8538:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rdx, %rax
	vxorps	%xmm0, %xmm0, %xmm0
	movq	%rdi, %r11
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	pushq	%r14
	pushq	%r13
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	movslq	%ecx, %r13
	pushq	%r12
	.cfi_offset 12, -48
	movq	%r8, %r12
	pushq	%rbx
	.cfi_offset 3, -56
	movl	%esi, %ebx
	andq	$-64, %rsp
	subq	$1152, %rsp
	movq	%fs:40, %rcx
	movq	%rcx, 1144(%rsp)
	xorl	%ecx, %ecx
	movl	32(%rbp), %edx
	kmovd	40(%rbp), %k0
	vmovaps	%zmm0, 64(%rsp)
	vmovaps	%zmm0, 128(%rsp)
	vmovaps	%zmm0, 192(%rsp)
	vmovaps	%zmm0, 256(%rsp)
	vmovaps	%zmm0, 320(%rsp)
	vmovaps	%zmm0, 384(%rsp)
	vmovaps	%zmm0, 448(%rsp)
	vmovaps	%zmm0, 512(%rsp)
	vmovaps	%zmm0, 576(%rsp)
	vmovaps	%zmm0, 640(%rsp)
	vmovaps	%zmm0, 704(%rsp)
	vmovaps	%zmm0, 768(%rsp)
	vmovaps	%zmm0, 832(%rsp)
	vmovaps	%zmm0, 896(%rsp)
	vmovaps	%zmm0, 960(%rsp)
	vmovaps	%zmm0, 1024(%rsp)
	cmpl	$15, %edx
	jg	.L310
	testl	%edx, %edx
	jle	.L323
	movl	$1, %r8d
	shlx	%edx, %r8d, %r8d
	decl	%r8d
.L312:
	xorl	%ecx, %ecx
	xorl	%esi, %esi
	subl	$48, %edx
	movw	%cx, 58(%rsp)
	movw	%si, 62(%rsp)
.L321:
	testl	%edx, %edx
	jle	.L327
	movl	$1, %r14d
	shlx	%edx, %r14d, %r14d
	leal	-1(%r14), %esi
	movw	%si, 60(%rsp)
	jmp	.L315
.L310:
	leal	-16(%rdx), %ecx
	cmpl	$15, %ecx
	jle	.L331
	leal	-32(%rdx), %ecx
	cmpl	$15, %ecx
	jle	.L332
	movl	$-1, %ecx
	movl	$-1, %esi
	subl	$48, %edx
	movl	$-1, %r8d
	movw	%cx, 58(%rsp)
	movw	%si, 62(%rsp)
	cmpl	$15, %edx
	jle	.L321
	movl	$-1, %r15d
	movw	%r15w, 60(%rsp)
.L315:
	movslq	16(%rbp), %r10
	movslq	%ebx, %r15
	movslq	24(%rbp), %r14
	movzwl	%r8w, %r8d
	kmovw	62(%rsp), %k2
	kmovw	58(%rsp), %k3
	movq	%r15, %rdx
	kmovd	%r8d, %k1
	kmovw	60(%rsp), %k4
	leaq	0(,%r10,4), %rcx
	imulq	%rcx, %rdx
	leaq	4(%rcx), %rdi
	imulq	%r15, %rdi
	leaq	8(%rcx), %rsi
	addq	$12, %rcx
	imulq	%r15, %rsi
	imulq	%r15, %rcx
	addq	%r11, %rdx
	addq	%r11, %rdi
	addq	%r11, %rsi
	addq	%r11, %rcx
	leaq	0(,%r14,4), %r11
	addq	%r11, %rax
	testl	%ebx, %ebx
	jle	.L320
	vxorps	%xmm20, %xmm20, %xmm20
	leaq	0(,%r13,4), %rbx
	leaq	(%rdx,%r15,4), %r8
	vmovaps	%zmm20, %zmm19
	vmovaps	%zmm20, %zmm18
	vmovaps	%zmm20, %zmm17
	vmovaps	%zmm20, %zmm16
	vmovaps	%zmm20, %zmm15
	vmovaps	%zmm20, %zmm14
	vmovaps	%zmm20, %zmm13
	vmovaps	%zmm20, %zmm12
	vmovaps	%zmm20, %zmm11
	vmovaps	%zmm20, %zmm10
	vmovaps	%zmm20, %zmm9
	vmovaps	%zmm20, %zmm8
	vmovaps	%zmm20, %zmm7
	vmovaps	%zmm20, %zmm6
	vmovaps	%zmm20, %zmm5
	.p2align 4,,10
	.p2align 3
.L319:
	vmovups	(%rax), %zmm4{%k1}{z}
	vmovups	64(%rax), %zmm3{%k2}{z}
	addq	$4, %rdx
	addq	$4, %rdi
	vmovups	128(%rax), %zmm2{%k3}{z}
	vmovups	192(%rax), %zmm0{%k4}{z}
	addq	$4, %rsi
	addq	%rbx, %rax
	vbroadcastss	-4(%rdx), %zmm1
	addq	$4, %rcx
	vfmadd231ps	%zmm4, %zmm1, %zmm5
	vfmadd231ps	%zmm3, %zmm1, %zmm6
	vfmadd231ps	%zmm2, %zmm1, %zmm7
	vfmadd231ps	%zmm0, %zmm1, %zmm8
	vbroadcastss	-4(%rdi), %zmm1
	vfmadd231ps	%zmm4, %zmm1, %zmm9
	vfmadd231ps	%zmm3, %zmm1, %zmm10
	vfmadd231ps	%zmm2, %zmm1, %zmm11
	vfmadd231ps	%zmm0, %zmm1, %zmm12
	vbroadcastss	-4(%rsi), %zmm1
	vmovaps	%zmm5, 64(%rsp)
	vfmadd231ps	%zmm4, %zmm1, %zmm13
	vfmadd231ps	%zmm3, %zmm1, %zmm14
	vmovaps	%zmm6, 128(%rsp)
	vfmadd231ps	%zmm2, %zmm1, %zmm15
	vfmadd231ps	%zmm0, %zmm1, %zmm16
	vbroadcastss	-4(%rcx), %zmm1
	vmovaps	%zmm7, 192(%rsp)
	vmovaps	%zmm8, 256(%rsp)
	vfmadd231ps	%zmm4, %zmm1, %zmm17
	vfmadd231ps	%zmm3, %zmm1, %zmm18
	vmovaps	%zmm9, 320(%rsp)
	vfmadd231ps	%zmm2, %zmm1, %zmm19
	vfmadd231ps	%zmm0, %zmm1, %zmm20
	vmovaps	%zmm10, 384(%rsp)
	vmovaps	%zmm11, 448(%rsp)
	vmovaps	%zmm12, 512(%rsp)
	vmovaps	%zmm13, 576(%rsp)
	vmovaps	%zmm14, 640(%rsp)
	vmovaps	%zmm15, 704(%rsp)
	vmovaps	%zmm16, 768(%rsp)
	vmovaps	%zmm17, 832(%rsp)
	vmovaps	%zmm18, 896(%rsp)
	vmovaps	%zmm19, 960(%rsp)
	vmovaps	%zmm20, 1024(%rsp)
	cmpq	%rdx, %r8
	jne	.L319
.L320:
	leaq	64(%r12,%r11), %rsi
	leaq	128(%r12,%r11), %rcx
	leaq	192(%r12,%r11), %rdx
	addq	%r12, %r11
	kortestb	%k0, %k0
	je	.L317
	vmovups	(%r11), %zmm1{%k1}{z}
	movq	%r10, %rax
	vxorps	%xmm0, %xmm0, %xmm0
	imulq	%r13, %rax
	vaddps	64(%rsp), %zmm1, %zmm1
	leaq	(%r14,%rax), %rdi
	addq	%r13, %rax
	vmaxps	%zmm0, %zmm1, %zmm1
	salq	$2, %rdi
	vmovups	%zmm1, (%r9,%rdi){%k1}
	vmovups	(%rsi), %zmm1{%k2}{z}
	vaddps	128(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, 64(%r9,%rdi){%k2}
	vmovups	(%rcx), %zmm1{%k3}{z}
	vaddps	192(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, 128(%r9,%rdi){%k3}
	vmovups	(%rdx), %zmm1{%k4}{z}
	vaddps	256(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, 192(%r9,%rdi){%k4}
	leaq	(%r14,%rax), %rdi
	addq	%r13, %rax
	vmovups	(%r11), %zmm1{%k1}{z}
	salq	$2, %rdi
	vaddps	320(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, (%r9,%rdi){%k1}
	vmovups	(%rsi), %zmm1{%k2}{z}
	vaddps	384(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, 64(%r9,%rdi){%k2}
	vmovups	(%rcx), %zmm1{%k3}{z}
	vaddps	448(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, 128(%r9,%rdi){%k3}
	vmovups	(%rdx), %zmm1{%k4}{z}
	vaddps	512(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, 192(%r9,%rdi){%k4}
	leaq	(%r14,%rax), %rdi
	addq	%r13, %rax
	vmovups	(%r11), %zmm1{%k1}{z}
	salq	$2, %rdi
	addq	%r14, %rax
	salq	$2, %rax
	vaddps	576(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, (%r9,%rdi){%k1}
	vmovups	(%rsi), %zmm1{%k2}{z}
	vaddps	640(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, 64(%r9,%rdi){%k2}
	vmovups	(%rcx), %zmm1{%k3}{z}
	vaddps	704(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, 128(%r9,%rdi){%k3}
	vmovups	(%rdx), %zmm1{%k4}{z}
	vaddps	768(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, 192(%r9,%rdi){%k4}
	vmovups	(%r11), %zmm1{%k1}{z}
	vaddps	832(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, (%r9,%rax){%k1}
	vmovups	(%rsi), %zmm1{%k2}{z}
	vaddps	896(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, 64(%r9,%rax){%k2}
	vmovups	(%rcx), %zmm1{%k3}{z}
	vaddps	960(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm1
	vmovups	%zmm1, 128(%r9,%rax){%k3}
	vmovups	(%rdx), %zmm1{%k4}{z}
	vaddps	1024(%rsp), %zmm1, %zmm1
	vmaxps	%zmm0, %zmm1, %zmm0
	vmovups	%zmm0, 192(%r9,%rax){%k4}
.L309:
	movq	1144(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L333
	vzeroupper
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
.L317:
	.cfi_restore_state
	movq	%r10, %rax
	vmovups	(%r11), %zmm0{%k1}{z}
	imulq	%r13, %rax
	vaddps	64(%rsp), %zmm0, %zmm0
	leaq	(%r14,%rax), %rdi
	addq	%r13, %rax
	salq	$2, %rdi
	vmovups	%zmm0, (%r9,%rdi){%k1}
	vmovups	(%rsi), %zmm0{%k2}{z}
	vaddps	128(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 64(%r9,%rdi){%k2}
	vmovups	(%rcx), %zmm0{%k3}{z}
	vaddps	192(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 128(%r9,%rdi){%k3}
	vmovups	(%rdx), %zmm0{%k4}{z}
	vaddps	256(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 192(%r9,%rdi){%k4}
	leaq	(%r14,%rax), %rdi
	addq	%r13, %rax
	vmovups	(%r11), %zmm0{%k1}{z}
	salq	$2, %rdi
	vaddps	320(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, (%r9,%rdi){%k1}
	vmovups	(%rsi), %zmm0{%k2}{z}
	vaddps	384(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 64(%r9,%rdi){%k2}
	vmovups	(%rcx), %zmm0{%k3}{z}
	vaddps	448(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 128(%r9,%rdi){%k3}
	vmovups	(%rdx), %zmm0{%k4}{z}
	vaddps	512(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 192(%r9,%rdi){%k4}
	leaq	(%r14,%rax), %rdi
	addq	%r13, %rax
	vmovups	(%r11), %zmm0{%k1}{z}
	salq	$2, %rdi
	addq	%r14, %rax
	salq	$2, %rax
	vaddps	576(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, (%r9,%rdi){%k1}
	vmovups	(%rsi), %zmm0{%k2}{z}
	vaddps	640(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 64(%r9,%rdi){%k2}
	vmovups	(%rcx), %zmm0{%k3}{z}
	vaddps	704(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 128(%r9,%rdi){%k3}
	vmovups	(%rdx), %zmm0{%k4}{z}
	vaddps	768(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 192(%r9,%rdi){%k4}
	vmovups	(%r11), %zmm0{%k1}{z}
	vaddps	832(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, (%r9,%rax){%k1}
	vmovups	(%rsi), %zmm0{%k2}{z}
	vaddps	896(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 64(%r9,%rax){%k2}
	vmovups	(%rcx), %zmm0{%k3}{z}
	vaddps	960(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 128(%r9,%rax){%k3}
	vmovups	(%rdx), %zmm0{%k4}{z}
	vaddps	1024(%rsp), %zmm0, %zmm0
	vmovups	%zmm0, 192(%r9,%rax){%k4}
	jmp	.L309
.L323:
	xorl	%r14d, %r14d
	xorl	%r8d, %r8d
	movw	%r14w, 62(%rsp)
.L311:
	xorl	%edi, %edi
	xorl	%r10d, %r10d
	movw	%di, 58(%rsp)
	movw	%r10w, 60(%rsp)
	jmp	.L315
.L331:
	testl	%ecx, %ecx
	je	.L324
	movl	$1, %r10d
	movl	$-1, %r8d
	shlx	%ecx, %r10d, %r10d
	leal	-1(%r10), %esi
	movw	%si, 62(%rsp)
	jmp	.L311
.L332:
	testl	%ecx, %ecx
	je	.L325
	movl	$1, %edx
	movl	$-1, %edi
	xorl	%r10d, %r10d
	movl	$-1, %r8d
	shlx	%ecx, %edx, %edx
	leal	-1(%rdx), %esi
	movw	%di, 62(%rsp)
	movw	%si, 58(%rsp)
	movw	%r10w, 60(%rsp)
	jmp	.L315
.L327:
	movw	$0, 60(%rsp)
	jmp	.L315
.L333:
	vzeroupper
	call	__stack_chk_fail@PLT
.L325:
	movw	$0, 58(%rsp)
	orl	$-1, %r8d
	movw	$-1, 62(%rsp)
	movw	$0, 60(%rsp)
	jmp	.L315
.L324:
	orl	$-1, %r8d
	jmp	.L312
	.cfi_endproc
.LFE8538:
	.size	_ZN12_GLOBAL__N_15microILi4ELi4ELi1EEEvPKfiS2_iS2_Pfiiib, .-_ZN12_GLOBAL__N_15microILi4ELi4ELi1EEEvPKfiS2_iS2_Pfiiib
	.p2align 4
	.type	_ZN12_GLOBAL__N_112blocked_tileEPKfRKNS_5LayerEPfiiiib, @function
_ZN12_GLOBAL__N_112blocked_tileEPKfRKNS_5LayerEPfiiiib:
.LFB8314:
	.cfi_startproc
	leaq	8(%rsp), %r10
	.cfi_def_cfa 10, 0
	andq	$-64, %rsp
	movq	%rsi, %r11
	movq	%rdx, %rsi
	pushq	-8(%r10)
	movslq	%ecx, %rax
	pushq	%rbp
	movq	%rsp, %rbp
	.cfi_escape 0x10,0x6,0x2,0x76,0
	pushq	%r15
	pushq	%r14
	pushq	%r13
	.cfi_escape 0x10,0xf,0x2,0x76,0x78
	.cfi_escape 0x10,0xe,0x2,0x76,0x70
	.cfi_escape 0x10,0xd,0x2,0x76,0x68
	movl	%r8d, %r13d
	pushq	%r12
	.cfi_escape 0x10,0xc,0x2,0x76,0x60
	movq	%rdi, %r12
	pushq	%r10
	.cfi_escape 0xf,0x3,0x76,0x58,0x6
	pushq	%rbx
	subq	$384, %rsp
	.cfi_escape 0x10,0x3,0x2,0x76,0x50
	movq	%fs:40, %rcx
	movq	%rcx, -56(%rbp)
	xorl	%ecx, %ecx
	movl	(%r10), %edx
	movq	24(%r11), %r8
	movslq	4(%r11), %rbx
	movl	8(%r10), %r10d
	movl	%edx, %edi
	leal	30(%rdx), %ecx
	addl	$15, %edi
	cmovns	%edi, %ecx
	movq	16(%r11), %rdi
	movl	(%r11), %r11d
	sarl	$4, %ecx
	cmpl	$2, %r13d
	je	.L335
	cmpl	$3, %r13d
	je	.L336
	cmpl	$1, %r13d
	jne	.L337
	cmpl	$2, %ecx
	je	.L338
	cmpl	$3, %ecx
	je	.L339
	cmpl	$1, %ecx
	jne	.L340
	vpxor	%xmm0, %xmm0, %xmm0
	shlx	%edx, %ecx, %ecx
	leal	-1(%rcx), %r13d
	vmovdqa64	%zmm0, -368(%rbp)
	vmovdqa64	%zmm0, -304(%rbp)
	vmovdqa64	%zmm0, -240(%rbp)
	vmovdqa64	%zmm0, -176(%rbp)
	cmpl	$15, %edx
	jg	.L386
	testl	%edx, %edx
	movl	$0, %edx
	cmovle	%edx, %r13d
.L371:
	movslq	%eax, %rdx
	movslq	%r11d, %rax
	imulq	%rdx, %rax
	leaq	(%r12,%rax,4), %r14
	movslq	%r9d, %rax
	movslq	%ebx, %r9
	leaq	0(,%rax,4), %r15
	movq	%rax, -376(%rbp)
	movzwl	%r13w, %eax
	leaq	(%rdi,%r15), %rcx
	kmovd	%eax, %k1
	cmpl	$3, %r11d
	jle	.L375
	leal	-4(%r11), %ebx
	movq	%r15, -384(%rbp)
	vmovaps	-368(%rbp), %zmm0
	movq	%rcx, %rax
	shrl	$2, %ebx
	movq	%r14, %rdi
	movl	%ebx, %r12d
	salq	$4, %rbx
	leaq	(%rbx,%r14), %r13
	leaq	0(,%r9,4), %rbx
	.p2align 4,,10
	.p2align 3
.L343:
	vmovups	(%rax), %zmm1{%k1}{z}
	addq	%rbx, %rax
	vmovaps	-304(%rbp), %zmm4
	movq	%rdi, %r15
	vmovaps	-240(%rbp), %zmm5
	vmovaps	-176(%rbp), %zmm6
	addq	$16, %rdi
	vfmadd231ps	-16(%rdi){1to16}, %zmm1, %zmm0
	vmovaps	%zmm0, -368(%rbp)
	vmovups	(%rax), %zmm1{%k1}{z}
	addq	%rbx, %rax
	vfmadd132ps	-12(%rdi){1to16}, %zmm4, %zmm1
	vmovaps	%zmm1, -304(%rbp)
	vmovups	(%rax), %zmm1{%k1}{z}
	addq	%rbx, %rax
	vfmadd132ps	-8(%rdi){1to16}, %zmm5, %zmm1
	vmovaps	%zmm1, -240(%rbp)
	vmovups	(%rax), %zmm1{%k1}{z}
	addq	%rbx, %rax
	vfmadd132ps	-4(%rdi){1to16}, %zmm6, %zmm1
	vmovaps	%zmm1, -176(%rbp)
	cmpq	%r15, %r13
	jne	.L343
	movq	-384(%rbp), %r15
	leal	4(,%r12,4), %eax
.L342:
	cmpl	%r11d, %eax
	jge	.L344
	leaq	0(,%r9,4), %rbx
	movslq	%eax, %rdi
	movq	%rbx, %r13
	leaq	0(,%rdi,4), %r12
	imulq	%rdi, %r13
	vmovups	(%rcx,%r13), %zmm1{%k1}{z}
	vfmadd231ps	(%r14,%rdi,4){1to16}, %zmm1, %zmm0
	leal	1(%rax), %edi
	cmpl	%edi, %r11d
	jle	.L344
	movslq	%edi, %rdi
	imulq	%rbx, %rdi
	vmovups	(%rcx,%rdi), %zmm1{%k1}{z}
	leal	2(%rax), %edi
	vfmadd231ps	4(%r14,%r12){1to16}, %zmm1, %zmm0
	cmpl	%edi, %r11d
	jle	.L344
	movslq	%edi, %rdi
	addl	$3, %eax
	imulq	%rbx, %rdi
	vmovups	(%rcx,%rdi), %zmm1{%k1}{z}
	vfmadd231ps	8(%r14,%r12){1to16}, %zmm1, %zmm0
	cmpl	%r11d, %eax
	jge	.L344
	cltq
	imulq	%rbx, %rax
	vmovups	(%rcx,%rax), %zmm1{%k1}{z}
	vfmadd231ps	12(%r14,%r12){1to16}, %zmm1, %zmm0
.L344:
	vaddps	-304(%rbp), %zmm0, %zmm0
	vmovups	(%r8,%r15), %zmm1{%k1}{z}
	vaddps	-240(%rbp), %zmm0, %zmm0
	vaddps	-176(%rbp), %zmm0, %zmm0
	vaddps	%zmm0, %zmm1, %zmm0
	testb	%r10b, %r10b
	je	.L346
	vxorps	%xmm1, %xmm1, %xmm1
	vmaxps	%zmm1, %zmm0, %zmm0
.L346:
	imulq	%r9, %rdx
	movq	-376(%rbp), %rax
	addq	%rdx, %rax
	vmovups	%zmm0, (%rsi,%rax,4){%k1}
	vzeroupper
	jmp	.L334
	.p2align 4,,10
	.p2align 3
.L336:
	cmpl	$2, %ecx
	je	.L359
	cmpl	$3, %ecx
	je	.L360
	cmpl	$1, %ecx
	jne	.L361
	vxorps	%xmm0, %xmm0, %xmm0
	shlx	%edx, %ecx, %ecx
	decl	%ecx
	vmovaps	%zmm0, -368(%rbp)
	vmovaps	%zmm0, -304(%rbp)
	vmovaps	%zmm0, -240(%rbp)
	cmpl	$15, %edx
	jg	.L387
	testl	%edx, %edx
	movl	$0, %edx
	cmovle	%edx, %ecx
.L372:
	movslq	%r11d, %r13
	leaq	0(,%rax,4), %r15
	movslq	%r9d, %r9
	movq	%r13, %rdx
	leaq	4(%r15), %r14
	movzwl	%cx, %ecx
	imulq	%r15, %rdx
	addq	$8, %r15
	kmovd	%ecx, %k1
	imulq	%r13, %r15
	imulq	%r13, %r14
	addq	%r12, %rdx
	addq	%r12, %r14
	addq	%r15, %r12
	leaq	0(,%r9,4), %r15
	testl	%r11d, %r11d
	jle	.L367
	vxorps	%xmm3, %xmm3, %xmm3
	leaq	0(,%rbx,4), %rcx
	addq	%r15, %rdi
	salq	$2, %r13
	xorl	%r11d, %r11d
	vmovaps	%zmm3, %zmm2
	vmovaps	%zmm3, %zmm1
	.p2align 4,,10
	.p2align 3
.L366:
	vmovups	(%rdi), %zmm0{%k1}{z}
	addq	%rcx, %rdi
	vfmadd231ps	(%rdx,%r11){1to16}, %zmm0, %zmm1
	vfmadd231ps	(%r14,%r11){1to16}, %zmm0, %zmm2
	vfmadd231ps	(%r12,%r11){1to16}, %zmm0, %zmm3
	addq	$4, %r11
	vmovaps	%zmm1, -368(%rbp)
	vmovaps	%zmm2, -304(%rbp)
	vmovaps	%zmm3, -240(%rbp)
	cmpq	%r11, %r13
	jne	.L366
.L367:
	addq	%r8, %r15
	testb	%r10b, %r10b
	je	.L364
	vmovups	(%r15), %zmm0{%k1}{z}
	vxorps	%xmm1, %xmm1, %xmm1
	imulq	%rbx, %rax
	vaddps	-368(%rbp), %zmm0, %zmm0
	leaq	(%r9,%rax), %rdx
	addq	%rbx, %rax
	vmaxps	%zmm1, %zmm0, %zmm0
	vmovups	%zmm0, (%rsi,%rdx,4){%k1}
	leaq	(%r9,%rax), %rdx
	vmovups	(%r15), %zmm0{%k1}{z}
	vaddps	-304(%rbp), %zmm0, %zmm0
	vmaxps	%zmm1, %zmm0, %zmm0
	vmovups	%zmm0, (%rsi,%rdx,4){%k1}
	vmovups	(%r15), %zmm0{%k1}{z}
	vaddps	-240(%rbp), %zmm0, %zmm0
	vmaxps	%zmm1, %zmm0, %zmm0
.L385:
	addq	%rbx, %rax
	addq	%r9, %rax
	vmovups	%zmm0, (%rsi,%rax,4){%k1}
	vzeroupper
	jmp	.L334
	.p2align 4,,10
	.p2align 3
.L335:
	cmpl	$2, %ecx
	je	.L348
	cmpl	$3, %ecx
	je	.L349
	cmpl	$1, %ecx
	jne	.L350
	vxorps	%xmm0, %xmm0, %xmm0
	shlx	%edx, %ecx, %ecx
	decl	%ecx
	vmovaps	%zmm0, -368(%rbp)
	vmovaps	%zmm0, -304(%rbp)
	vmovaps	%zmm0, -240(%rbp)
	vmovaps	%zmm0, -176(%rbp)
	cmpl	$15, %edx
	jg	.L388
	testl	%edx, %edx
	movl	$0, %edx
	cmovle	%edx, %ecx
.L373:
	leaq	0(,%rax,4), %rdx
	movslq	%r11d, %r14
	movslq	%r9d, %r9
	movq	%rdx, %r13
	addq	$4, %rdx
	imulq	%r14, %rdx
	imulq	%r14, %r13
	addq	%r12, %r13
	addq	%rdx, %r12
	leaq	0(,%r9,4), %rdx
	movq	%rdx, -376(%rbp)
	addq	%rdi, %rdx
	movzwl	%cx, %edi
	movq	%rdx, -384(%rbp)
	kmovd	%edi, %k1
	cmpl	$1, %r11d
	jle	.L376
	leal	-2(%r11), %r15d
	movq	%rdx, %rcx
	leaq	0(,%rbx,4), %rdi
	xorl	%edx, %edx
	shrl	%r15d
	leal	1(%r15), %r14d
	movq	%r14, %r15
	salq	$3, %r14
	.p2align 4,,10
	.p2align 3
.L353:
	vmovups	(%rcx), %zmm0{%k1}{z}
	vbroadcastss	0(%r13,%rdx), %zmm1
	addq	%rdi, %rcx
	vmovaps	-304(%rbp), %zmm7
	vmovaps	-176(%rbp), %zmm4
	vfmadd213ps	-368(%rbp), %zmm0, %zmm1
	vfmadd132ps	(%r12,%rdx){1to16}, %zmm7, %zmm0
	vmovaps	%zmm1, -368(%rbp)
	vbroadcastss	4(%r13,%rdx), %zmm1
	vmovaps	%zmm0, -304(%rbp)
	vmovups	(%rcx), %zmm0{%k1}{z}
	addq	%rdi, %rcx
	vfmadd213ps	-240(%rbp), %zmm0, %zmm1
	vfmadd132ps	4(%r12,%rdx){1to16}, %zmm4, %zmm0
	addq	$8, %rdx
	vmovaps	%zmm1, -240(%rbp)
	vmovaps	%zmm0, -176(%rbp)
	cmpq	%rdx, %r14
	jne	.L353
	addl	%r15d, %r15d
.L352:
	cmpl	%r11d, %r15d
	jge	.L358
	movslq	%r15d, %rdx
	leaq	0(,%rbx,4), %rdi
	movq	-384(%rbp), %r14
	vmovaps	-368(%rbp), %zmm7
	leaq	0(,%rdx,4), %rcx
	vmovaps	-304(%rbp), %zmm3
	incl	%r15d
	movq	%rcx, -392(%rbp)
	movq	%rdi, %rcx
	imulq	%rdx, %rcx
	addq	%r14, %rcx
	vmovups	(%rcx), %zmm1{%k1}{z}
	vfmadd132ps	0(%r13,%rdx,4){1to16}, %zmm7, %zmm1
	vmovaps	%zmm1, -368(%rbp)
	vmovups	(%rcx), %zmm0{%k1}{z}
	vfmadd132ps	(%r12,%rdx,4){1to16}, %zmm3, %zmm0
	vmovaps	%zmm0, -304(%rbp)
	cmpl	%r15d, %r11d
	jle	.L358
	movslq	%r15d, %r15
	movq	%r14, %rdx
	imulq	%rdi, %r15
	movq	-392(%rbp), %rdi
	addq	%r15, %rdx
	vmovups	(%rdx), %zmm2{%k1}{z}
	vfmadd231ps	4(%r13,%rdi){1to16}, %zmm2, %zmm1
	vmovaps	%zmm1, -368(%rbp)
	vmovups	(%rdx), %zmm1{%k1}{z}
	vfmadd231ps	4(%r12,%rdi){1to16}, %zmm1, %zmm0
	vmovaps	%zmm0, -304(%rbp)
.L358:
	movq	-376(%rbp), %rdx
	vmovaps	-240(%rbp), %zmm5
	vxorps	%xmm2, %xmm2, %xmm2
	vaddps	-368(%rbp), %zmm5, %zmm1
	addq	%r8, %rdx
	vmovups	(%rdx), %zmm0{%k1}{z}
	vaddps	%zmm1, %zmm0, %zmm0
	testb	%r10b, %r10b
	je	.L355
	imulq	%rbx, %rax
	vmaxps	%zmm2, %zmm0, %zmm0
	leaq	(%r9,%rax), %rcx
	vmovups	%zmm0, (%rsi,%rcx,4){%k1}
	vmovaps	-176(%rbp), %zmm6
	vmovups	(%rdx), %zmm0{%k1}{z}
	vaddps	-304(%rbp), %zmm6, %zmm1
	vaddps	%zmm1, %zmm0, %zmm0
	vmaxps	%zmm2, %zmm0, %zmm0
	jmp	.L385
	.p2align 4,,10
	.p2align 3
.L337:
	movzbl	%r10b, %r10d
	cmpl	$2, %ecx
	je	.L368
	cmpl	$3, %ecx
	je	.L369
	cmpl	$1, %ecx
	jne	.L370
	pushq	%r10
	movl	%ebx, %ecx
	pushq	%rdx
	movq	%rdi, %rdx
	movq	%r12, %rdi
	pushq	%r9
	movq	%rsi, %r9
	movl	%r11d, %esi
	pushq	%rax
	call	_ZN12_GLOBAL__N_15microILi4ELi1ELi1EEEvPKfiS2_iS2_Pfiiib
	addq	$32, %rsp
	.p2align 4,,10
	.p2align 3
.L334:
	movq	-56(%rbp), %rax
	subq	%fs:40, %rax
	jne	.L389
	leaq	-48(%rbp), %rsp
	popq	%rbx
	popq	%r10
	.cfi_remember_state
	.cfi_def_cfa 10, 0
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	leaq	-8(%r10), %rsp
	.cfi_def_cfa 7, 8
	ret
	.p2align 4,,10
	.p2align 3
.L338:
	.cfi_restore_state
	movzbl	%r10b, %r10d
	movl	%ebx, %ecx
	pushq	%r10
	pushq	%rdx
	movq	%rdi, %rdx
	movq	%r12, %rdi
	pushq	%r9
	movq	%rsi, %r9
	movl	%r11d, %esi
	pushq	%rax
	call	_ZN12_GLOBAL__N_15microILi1ELi2ELi2EEEvPKfiS2_iS2_Pfiiib
	addq	$32, %rsp
	jmp	.L334
	.p2align 4,,10
	.p2align 3
.L368:
	pushq	%r10
	movl	%ebx, %ecx
	pushq	%rdx
	movq	%rdi, %rdx
	movq	%r12, %rdi
	pushq	%r9
	movq	%rsi, %r9
	movl	%r11d, %esi
	pushq	%rax
	call	_ZN12_GLOBAL__N_15microILi4ELi2ELi1EEEvPKfiS2_iS2_Pfiiib
	addq	$32, %rsp
	jmp	.L334
	.p2align 4,,10
	.p2align 3
.L348:
	movzbl	%r10b, %r10d
	movl	%ebx, %ecx
	pushq	%r10
	pushq	%rdx
	movq	%rdi, %rdx
	movq	%r12, %rdi
	pushq	%r9
	movq	%rsi, %r9
	movl	%r11d, %esi
	pushq	%rax
	call	_ZN12_GLOBAL__N_15microILi2ELi2ELi1EEEvPKfiS2_iS2_Pfiiib
	addq	$32, %rsp
	jmp	.L334
	.p2align 4,,10
	.p2align 3
.L359:
	movzbl	%r10b, %r10d
	movl	%ebx, %ecx
	pushq	%r10
	pushq	%rdx
	movq	%rdi, %rdx
	movq	%r12, %rdi
	pushq	%r9
	movq	%rsi, %r9
	movl	%r11d, %esi
	pushq	%rax
	call	_ZN12_GLOBAL__N_15microILi3ELi2ELi1EEEvPKfiS2_iS2_Pfiiib
	addq	$32, %rsp
	jmp	.L334
	.p2align 4,,10
	.p2align 3
.L340:
	movzbl	%r10b, %r10d
	movl	%ebx, %ecx
	pushq	%r10
	pushq	%rdx
	movq	%rdi, %rdx
	movq	%r12, %rdi
	pushq	%r9
	movq	%rsi, %r9
	movl	%r11d, %esi
	pushq	%rax
	call	_ZN12_GLOBAL__N_15microILi1ELi4ELi1EEEvPKfiS2_iS2_Pfiiib
	addq	$32, %rsp
	jmp	.L334
	.p2align 4,,10
	.p2align 3
.L339:
	movzbl	%r10b, %r10d
	movl	%ebx, %ecx
	pushq	%r10
	pushq	%rdx
	movq	%rdi, %rdx
	movq	%r12, %rdi
	pushq	%r9
	movq	%rsi, %r9
	movl	%r11d, %esi
	pushq	%rax
	call	_ZN12_GLOBAL__N_15microILi1ELi3ELi1EEEvPKfiS2_iS2_Pfiiib
	addq	$32, %rsp
	jmp	.L334
	.p2align 4,,10
	.p2align 3
.L370:
	pushq	%r10
	movl	%ebx, %ecx
	pushq	%rdx
	movq	%rdi, %rdx
	movq	%r12, %rdi
	pushq	%r9
	movq	%rsi, %r9
	movl	%r11d, %esi
	pushq	%rax
	call	_ZN12_GLOBAL__N_15microILi4ELi4ELi1EEEvPKfiS2_iS2_Pfiiib
	addq	$32, %rsp
	jmp	.L334
	.p2align 4,,10
	.p2align 3
.L369:
	pushq	%r10
	movl	%ebx, %ecx
	pushq	%rdx
	movq	%rdi, %rdx
	movq	%r12, %rdi
	pushq	%r9
	movq	%rsi, %r9
	movl	%r11d, %esi
	pushq	%rax
	call	_ZN12_GLOBAL__N_15microILi4ELi3ELi1EEEvPKfiS2_iS2_Pfiiib
	addq	$32, %rsp
	jmp	.L334
	.p2align 4,,10
	.p2align 3
.L350:
	movzbl	%r10b, %r10d
	movl	%ebx, %ecx
	pushq	%r10
	pushq	%rdx
	movq	%rdi, %rdx
	movq	%r12, %rdi
	pushq	%r9
	movq	%rsi, %r9
	movl	%r11d, %esi
	pushq	%rax
	call	_ZN12_GLOBAL__N_15microILi2ELi4ELi1EEEvPKfiS2_iS2_Pfiiib
	addq	$32, %rsp
	jmp	.L334
	.p2align 4,,10
	.p2align 3
.L349:
	movzbl	%r10b, %r10d
	movl	%ebx, %ecx
	pushq	%r10
	pushq	%rdx
	movq	%rdi, %rdx
	movq	%r12, %rdi
	pushq	%r9
	movq	%rsi, %r9
	movl	%r11d, %esi
	pushq	%rax
	call	_ZN12_GLOBAL__N_15microILi2ELi3ELi1EEEvPKfiS2_iS2_Pfiiib
	addq	$32, %rsp
	jmp	.L334
	.p2align 4,,10
	.p2align 3
.L361:
	movzbl	%r10b, %r10d
	movl	%ebx, %ecx
	pushq	%r10
	pushq	%rdx
	movq	%rdi, %rdx
	movq	%r12, %rdi
	pushq	%r9
	movq	%rsi, %r9
	movl	%r11d, %esi
	pushq	%rax
	call	_ZN12_GLOBAL__N_15microILi3ELi4ELi1EEEvPKfiS2_iS2_Pfiiib
	addq	$32, %rsp
	jmp	.L334
	.p2align 4,,10
	.p2align 3
.L360:
	movzbl	%r10b, %r10d
	movl	%ebx, %ecx
	pushq	%r10
	pushq	%rdx
	movq	%rdi, %rdx
	movq	%r12, %rdi
	pushq	%r9
	movq	%rsi, %r9
	movl	%r11d, %esi
	pushq	%rax
	call	_ZN12_GLOBAL__N_15microILi3ELi3ELi1EEEvPKfiS2_iS2_Pfiiib
	addq	$32, %rsp
	jmp	.L334
.L386:
	movl	$-1, %r13d
	jmp	.L371
.L388:
	movl	$-1, %ecx
	jmp	.L373
.L387:
	movl	$-1, %ecx
	jmp	.L372
.L364:
	vmovups	(%r15), %zmm0{%k1}{z}
	imulq	%rbx, %rax
	vaddps	-368(%rbp), %zmm0, %zmm0
	leaq	(%rax,%r9), %rdx
	addq	%rbx, %rax
	vmovups	%zmm0, (%rsi,%rdx,4){%k1}
	leaq	(%r9,%rax), %rdx
	addq	%rbx, %rax
	vmovups	(%r15), %zmm0{%k1}{z}
	addq	%r9, %rax
	vaddps	-304(%rbp), %zmm0, %zmm0
	vmovups	%zmm0, (%rsi,%rdx,4){%k1}
	vmovups	(%r15), %zmm0{%k1}{z}
	vaddps	-240(%rbp), %zmm0, %zmm0
	vmovups	%zmm0, (%rsi,%rax,4){%k1}
	vzeroupper
	jmp	.L334
.L355:
	imulq	%rbx, %rax
	leaq	(%rax,%r9), %rcx
	vmovups	%zmm0, (%rsi,%rcx,4){%k1}
	vmovaps	-176(%rbp), %zmm6
	vmovups	(%rdx), %zmm1{%k1}{z}
	vaddps	-304(%rbp), %zmm6, %zmm0
	vaddps	%zmm1, %zmm0, %zmm0
	jmp	.L385
.L375:
	vmovaps	-368(%rbp), %zmm0
	xorl	%eax, %eax
	jmp	.L342
.L376:
	xorl	%r15d, %r15d
	jmp	.L352
.L389:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE8314:
	.size	_ZN12_GLOBAL__N_112blocked_tileEPKfRKNS_5LayerEPfiiiib, .-_ZN12_GLOBAL__N_112blocked_tileEPKfRKNS_5LayerEPfiiiib
	.p2align 4
	.type	_ZN12_GLOBAL__N_120dense_layer_inregionEPKfRKNS_5LayerEPfibi, @function
_ZN12_GLOBAL__N_120dense_layer_inregionEPKfRKNS_5LayerEPfibi:
.LFB8315:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$56, %rsp
	.cfi_def_cfa_offset 112
	movq	%rdi, 8(%rsp)
	testl	%ecx, %ecx
	jle	.L412
	movl	4(%rsi), %r12d
	movq	%rsi, %rbx
	movq	%rdx, %r13
	movl	%r8d, %ebp
	movl	%r9d, %r15d
	testl	%r9d, %r9d
	je	.L414
	leal	-1(%r9), %eax
	movl	%ecx, 20(%rsp)
	cmpl	$1, %eax
	jbe	.L415
	call	omp_get_num_threads@PLT
	movl	20(%rsp), %ecx
	movl	%r12d, %r8d
	leal	126(%r12), %edi
	movl	%eax, %edx
	leal	3(%rcx), %eax
	sarl	$2, %eax
	addl	$63, %r8d
	cmovns	%r8d, %edi
	movl	%eax, %r10d
	sarl	$6, %edi
	imull	%edi, %r10d
	cmpl	%r10d, %edx
	jle	.L409
	movl	%r12d, %r8d
	leal	62(%r12), %edi
	addl	$31, %r8d
	cmovns	%r8d, %edi
	sarl	$5, %edi
	movl	%edi, %r10d
	imull	%eax, %r10d
	cmpl	%edx, %r10d
	jge	.L410
	movl	%r12d, %edx
	leal	30(%r12), %edi
	movl	$16, %r15d
	addl	$15, %edx
	cmovns	%edx, %edi
	sarl	$4, %edi
	imull	%edi, %eax
	movl	%eax, %r10d
.L404:
	movl	%ecx, 32(%rsp)
	movl	%r10d, 24(%rsp)
	movl	%edi, 20(%rsp)
	call	omp_get_num_threads@PLT
	movl	%eax, %r14d
	call	omp_get_thread_num@PLT
	movl	20(%rsp), %edi
	movl	32(%rsp), %ecx
	movl	%eax, %r8d
	movl	24(%rsp), %eax
	cltd
	idivl	%r14d
	cmpl	%edx, %r8d
	movl	%eax, %r10d
	jl	.L416
.L405:
	imull	%r10d, %r8d
	leal	(%r8,%rdx), %r14d
	addl	%r14d, %r10d
	cmpl	%r10d, %r14d
	jge	.L408
	movl	%edi, 20(%rsp)
	movzbl	%bpl, %ebp
	movq	%rbx, 24(%rsp)
	movl	%r14d, %ebx
	movl	%r15d, %r14d
	movl	%ecx, %r15d
	movq	%r13, 32(%rsp)
	movl	%ebp, %r13d
	movl	%r10d, %ebp
	.p2align 4,,10
	.p2align 3
.L407:
	movl	%ebx, %eax
	movl	%r15d, %r8d
	cltd
	idivl	20(%rsp)
	pushq	%r13
	.cfi_def_cfa_offset 120
	imull	%r14d, %edx
	leal	0(,%rax,4), %ecx
	movl	%r12d, %eax
	subl	%ecx, %r8d
	subl	%edx, %eax
	movl	%edx, %r9d
	cmpl	%r14d, %eax
	cmovg	%r14d, %eax
	pushq	%rax
	.cfi_def_cfa_offset 128
	movl	$4, %eax
	cmpl	%eax, %r8d
	cmovg	%eax, %r8d
	incl	%ebx
	movq	48(%rsp), %rdx
	movq	40(%rsp), %rsi
	movq	24(%rsp), %rdi
	call	_ZN12_GLOBAL__N_112blocked_tileEPKfRKNS_5LayerEPfiiiib
	popq	%rax
	.cfi_def_cfa_offset 120
	popq	%rdx
	.cfi_def_cfa_offset 112
	cmpl	%ebx, %ebp
	jne	.L407
.L408:
	addq	$56, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	jmp	GOMP_barrier@PLT
	.p2align 4,,10
	.p2align 3
.L414:
	.cfi_restore_state
	movl	%ecx, 20(%rsp)
	testl	%r12d, %r12d
	jle	.L408
	call	omp_get_num_threads@PLT
	movl	%eax, %r15d
	call	omp_get_thread_num@PLT
	movl	20(%rsp), %ecx
	xorl	%edx, %edx
	movl	%eax, %edi
	imull	%r12d, %ecx
	movl	%ecx, %eax
	divl	%r15d
	movl	%eax, %ecx
	cmpl	%edx, %edi
	jb	.L417
.L394:
	imull	%ecx, %edi
	leal	(%rdi,%rdx), %eax
	leal	(%rcx,%rax), %edx
	cmpl	%edx, %eax
	jnb	.L408
	xorl	%edx, %edx
	xorl	%r14d, %r14d
	movq	%r13, 32(%rsp)
	divl	%r12d
	movq	%rbx, 24(%rsp)
	movl	%r14d, %r13d
	movl	%r12d, %r14d
	movl	%eax, %r15d
	movzbl	%bpl, %eax
	leal	-1(%rcx), %ebp
	movl	%edx, %r9d
	leal	1(%r15), %esi
	movl	%eax, %r12d
	movl	%esi, 20(%rsp)
	jmp	.L395
	.p2align 4,,10
	.p2align 3
.L397:
	incl	%r13d
.L395:
	pushq	%r12
	.cfi_def_cfa_offset 120
	leal	1(%r9), %ebx
	movl	%r15d, %ecx
	pushq	%rbx
	.cfi_def_cfa_offset 128
	movl	36(%rsp), %r8d
	movq	48(%rsp), %rdx
	movq	40(%rsp), %rsi
	movq	24(%rsp), %rdi
	call	_ZN12_GLOBAL__N_117dense_scalar_rowsEPKfRKNS_5LayerEPfiiiib
	popq	%rcx
	.cfi_def_cfa_offset 120
	popq	%rsi
	.cfi_def_cfa_offset 112
	cmpl	%ebp, %r13d
	je	.L408
	movl	%ebx, %r9d
	cmpl	%r14d, %ebx
	jl	.L397
	movl	20(%rsp), %eax
	xorl	%r9d, %r9d
	movl	%eax, %r15d
	incl	%eax
	movl	%eax, 20(%rsp)
	jmp	.L397
	.p2align 4,,10
	.p2align 3
.L412:
	addq	$56, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L415:
	.cfi_restore_state
	testl	%r12d, %r12d
	jle	.L408
	call	omp_get_num_threads@PLT
	movl	%eax, %r14d
	call	omp_get_thread_num@PLT
	movl	20(%rsp), %ecx
	xorl	%edx, %edx
	movl	%eax, %edi
	imull	%r12d, %ecx
	movl	%ecx, %eax
	divl	%r14d
	movl	%eax, %ecx
	cmpl	%edx, %edi
	jb	.L418
.L399:
	movl	%edi, %eax
	imull	%ecx, %eax
	addl	%edx, %eax
	leal	(%rcx,%rax), %edx
	cmpl	%edx, %eax
	jnb	.L408
	xorl	%edx, %edx
	movzbl	%bpl, %esi
	movq	%rbx, 32(%rsp)
	leal	-1(%rcx), %ebp
	divl	%r12d
	movq	%r13, 40(%rsp)
	movl	%eax, %r14d
	xorl	%eax, %eax
	cmpl	$2, %r15d
	movl	%edx, %r9d
	leal	1(%r14), %edi
	movl	%r14d, 24(%rsp)
	sete	%al
	xorl	%r15d, %r15d
	movl	%edi, 20(%rsp)
	movl	%r15d, %ebx
	movl	%eax, %r13d
	movl	%r12d, %r15d
	movl	%esi, %r12d
	.p2align 4,,10
	.p2align 3
.L400:
	subq	$8, %rsp
	.cfi_def_cfa_offset 120
	leal	1(%r9), %r14d
	pushq	%r13
	.cfi_def_cfa_offset 128
	pushq	%r12
	.cfi_def_cfa_offset 136
	pushq	%r14
	.cfi_def_cfa_offset 144
	movl	52(%rsp), %r8d
	movl	56(%rsp), %ecx
	movq	72(%rsp), %rdx
	movq	64(%rsp), %rsi
	movq	40(%rsp), %rdi
	call	_ZN12_GLOBAL__N_115dense_simd_rowsEPKfRKNS_5LayerEPfiiiibb
	addq	$32, %rsp
	.cfi_def_cfa_offset 112
	cmpl	%ebp, %ebx
	je	.L408
	movl	%r14d, %r9d
	cmpl	%r15d, %r14d
	jge	.L419
	incl	%ebx
	jmp	.L400
	.p2align 4,,10
	.p2align 3
.L419:
	movl	20(%rsp), %eax
	xorl	%r9d, %r9d
	incl	%ebx
	movl	%eax, 24(%rsp)
	incl	%eax
	movl	%eax, 20(%rsp)
	jmp	.L400
	.p2align 4,,10
	.p2align 3
.L417:
	incl	%ecx
	xorl	%edx, %edx
	jmp	.L394
	.p2align 4,,10
	.p2align 3
.L418:
	incl	%ecx
	xorl	%edx, %edx
	jmp	.L399
	.p2align 4,,10
	.p2align 3
.L416:
	incl	%r10d
	xorl	%edx, %edx
	jmp	.L405
.L409:
	movl	$64, %r15d
	jmp	.L404
.L410:
	movl	$32, %r15d
	jmp	.L404
	.cfi_endproc
.LFE8315:
	.size	_ZN12_GLOBAL__N_120dense_layer_inregionEPKfRKNS_5LayerEPfibi, .-_ZN12_GLOBAL__N_120dense_layer_inregionEPKfRKNS_5LayerEPfibi
	.p2align 4
	.type	pfi_logits._omp_fn.0, @function
pfi_logits._omp_fn.0:
.LFB8940:
	.cfi_startproc
	endbr64
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	movq	%rdi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	xorl	%ebx, %ebx
	subq	$8, %rsp
	.cfi_def_cfa_offset 48
	movq	24(%r12), %rax
	movl	32(%rdi), %ebp
	movq	80+_ZN12_GLOBAL__N_11HE(%rip), %r13
	movq	(%rdi), %rdi
	movq	(%rax), %rdx
	cmpq	%rdx, 8(%rax)
	jne	.L421
	jmp	.L431
	.p2align 4,,10
	.p2align 3
.L425:
	movq	24(%r12), %rax
	movq	(%rax), %rdx
	movq	8(%rax), %rax
	subq	%rdx, %rax
	sarq	$5, %rax
	cmpq	%rax, %rbx
	jnb	.L422
	movq	%r13, %rdi
	movq	%rcx, %r13
.L421:
	movq	8(%r12), %rcx
	incq	%rbx
	movl	_ZN12_GLOBAL__N_18g_kernelE(%rip), %r9d
	movq	8(%rcx), %rax
	subq	(%rcx), %rax
	movl	%ebp, %ecx
	sarq	$5, %rax
	cmpq	%rax, %rbx
	movq	%rbx, %rax
	setb	%r8b
	salq	$5, %rax
	leaq	-32(%rdx,%rax), %rsi
	movzbl	%r8b, %r8d
	movq	%r13, %rdx
	call	_ZN12_GLOBAL__N_120dense_layer_inregionEPKfRKNS_5LayerEPfibi
	movq	80+_ZN12_GLOBAL__N_11HE(%rip), %rcx
	cmpq	%r13, %rcx
	jne	.L425
	movq	88+_ZN12_GLOBAL__N_11HE(%rip), %rcx
	jmp	.L425
	.p2align 4,,10
	.p2align 3
.L431:
	movq	%rdi, %r13
	.p2align 4,,10
	.p2align 3
.L422:
	call	GOMP_single_start@PLT
	testb	%al, %al
	je	.L424
	movq	%r13, 16(%r12)
.L424:
	addq	$8, %rsp
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	jmp	GOMP_barrier@PLT
	.cfi_endproc
.LFE8940:
	.size	pfi_logits._omp_fn.0, .-pfi_logits._omp_fn.0
	.p2align 4
	.type	pfi_bench_dense._omp_fn.0, @function
pfi_bench_dense._omp_fn.0:
.LFB8945:
	.cfi_startproc
	endbr64
	movq	(%rdi), %rax
	movl	28(%rdi), %ecx
	movl	$1, %r8d
	movq	8(%rdi), %rdx
	movq	16(%rdi), %rsi
	movl	24(%rdi), %r9d
	movq	%rax, %rdi
	jmp	_ZN12_GLOBAL__N_120dense_layer_inregionEPKfRKNS_5LayerEPfibi
	.cfi_endproc
.LFE8945:
	.size	pfi_bench_dense._omp_fn.0, .-pfi_bench_dense._omp_fn.0
	.align 2
	.p2align 4
	.type	_ZNSt6vectorIN12_GLOBAL__N_15LayerESaIS1_EED2Ev, @function
_ZNSt6vectorIN12_GLOBAL__N_15LayerESaIS1_EED2Ev:
.LFB8468:
	.cfi_startproc
	movq	(%rdi), %rax
	testq	%rax, %rax
	je	.L435
	movq	16(%rdi), %rsi
	movq	%rax, %rdi
	subq	%rax, %rsi
	jmp	_ZdlPvm@PLT
	.p2align 4,,10
	.p2align 3
.L435:
	ret
	.cfi_endproc
.LFE8468:
	.size	_ZNSt6vectorIN12_GLOBAL__N_15LayerESaIS1_EED2Ev, .-_ZNSt6vectorIN12_GLOBAL__N_15LayerESaIS1_EED2Ev
	.set	_ZNSt6vectorIN12_GLOBAL__N_15LayerESaIS1_EED1Ev,_ZNSt6vectorIN12_GLOBAL__N_15LayerESaIS1_EED2Ev
	.align 2
	.p2align 4
	.type	_ZNSt6vectorIN12_GLOBAL__N_15ModelESaIS1_EED2Ev, @function
_ZNSt6vectorIN12_GLOBAL__N_15ModelESaIS1_EED2Ev:
.LFB8936:
	.cfi_startproc
	endbr64
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	movq	%rdi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	movq	8(%rdi), %rbp
	movq	(%rdi), %rbx
	cmpq	%rbx, %rbp
	je	.L437
	.p2align 4,,10
	.p2align 3
.L441:
	movq	(%rbx), %rdi
	testq	%rdi, %rdi
	je	.L438
	movq	16(%rbx), %rsi
	addq	$32, %rbx
	subq	%rdi, %rsi
	call	_ZdlPvm@PLT
	cmpq	%rbx, %rbp
	jne	.L441
.L440:
	movq	(%r12), %rbx
.L437:
	testq	%rbx, %rbx
	je	.L443
	movq	16(%r12), %rsi
	movq	%rbx, %rdi
	subq	%rbx, %rsi
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	jmp	_ZdlPvm@PLT
	.p2align 4,,10
	.p2align 3
.L438:
	.cfi_restore_state
	addq	$32, %rbx
	cmpq	%rbx, %rbp
	jne	.L441
	jmp	.L440
	.p2align 4,,10
	.p2align 3
.L443:
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE8936:
	.size	_ZNSt6vectorIN12_GLOBAL__N_15ModelESaIS1_EED2Ev, .-_ZNSt6vectorIN12_GLOBAL__N_15ModelESaIS1_EED2Ev
	.set	_ZNSt6vectorIN12_GLOBAL__N_15ModelESaIS1_EED1Ev,_ZNSt6vectorIN12_GLOBAL__N_15ModelESaIS1_EED2Ev
	.p2align 4
	.type	pfi_preprocess._omp_fn.0, @function
pfi_preprocess._omp_fn.0:
.LFB8939:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r12
	.cfi_offset 12, -24
	movq	%rdi, %r12
	pushq	%rbx
	andq	$-32, %rsp
	.cfi_offset 3, -32
	call	omp_get_num_threads@PLT
	movl	%eax, %ebx
	call	omp_get_thread_num@PLT
	movslq	%ebx, %rsi
	movslq	%eax, %rcx
	movslq	16(%r12), %rax
	imulq	$784, %rax, %rax
	cqto
	idivq	%rsi
	cmpq	%rdx, %rcx
	jl	.L460
.L446:
	imulq	%rax, %rcx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rdi
	cmpq	%rdi, %rdx
	jge	.L447
	leaq	-1(%rax), %rcx
	movq	8(%r12), %r8
	movq	(%r12), %r9
	movq	%rdx, %r10
	vmovss	56+_ZN12_GLOBAL__N_11HE(%rip), %xmm5
	vmovss	60+_ZN12_GLOBAL__N_11HE(%rip), %xmm4
	cmpq	$30, %rcx
	jbe	.L453
	movq	%rax, %r11
	leaq	(%r9,%rdx), %rsi
	vbroadcastss	.LC3(%rip), %ymm6
	vbroadcastss	%xmm5, %ymm8
	andq	$-32, %r11
	vbroadcastss	%xmm4, %ymm7
	leaq	(%r8,%rdx,4), %rcx
	leaq	(%r11,%rsi), %rbx
	.p2align 4,,10
	.p2align 3
.L449:
	vmovdqu8	(%rsi), %ymm0
	addq	$32, %rsi
	subq	$-128, %rcx
	vpmovzxbw	%xmm0, %ymm1
	vextracti128	$0x1, %ymm0, %xmm0
	vextracti128	$0x1, %ymm1, %xmm3
	vpmovsxwd	%xmm1, %ymm1
	vpmovzxbw	%xmm0, %ymm0
	vcvtdq2ps	%ymm1, %ymm1
	vfmsub132ps	%ymm6, %ymm8, %ymm1
	vpmovsxwd	%xmm3, %ymm3
	vpmovsxwd	%xmm0, %ymm2
	vcvtdq2ps	%ymm3, %ymm3
	vfmsub132ps	%ymm6, %ymm8, %ymm3
	vextracti128	$0x1, %ymm0, %xmm0
	vcvtdq2ps	%ymm2, %ymm2
	vpmovsxwd	%xmm0, %ymm0
	vfmsub132ps	%ymm6, %ymm8, %ymm2
	vcvtdq2ps	%ymm0, %ymm0
	vfmsub132ps	%ymm6, %ymm8, %ymm0
	vmulps	%ymm7, %ymm1, %ymm1
	vmulps	%ymm7, %ymm0, %ymm0
	vmovups	%ymm1, -128(%rcx)
	vmulps	%ymm7, %ymm3, %ymm1
	vmovups	%ymm0, -32(%rcx)
	vmovups	%ymm1, -96(%rcx)
	vmulps	%ymm7, %ymm2, %ymm1
	vmovups	%ymm1, -64(%rcx)
	cmpq	%rsi, %rbx
	jne	.L449
	addq	%r11, %rdx
	cmpq	%rax, %r11
	je	.L461
	vzeroupper
.L448:
	subq	%r11, %rax
	leaq	-1(%rax), %rcx
	cmpq	$14, %rcx
	jbe	.L451
	leaq	(%r10,%r11), %rsi
	vbroadcastss	.LC3(%rip), %xmm8
	vbroadcastss	%xmm5, %xmm7
	vbroadcastss	%xmm4, %xmm6
	vmovdqu8	(%r9,%rsi), %xmm0
	leaq	(%r8,%rsi,4), %rcx
	vpmovzxbw	%xmm0, %xmm1
	vpsrldq	$8, %xmm0, %xmm0
	vpsrldq	$8, %xmm1, %xmm2
	vpmovsxwd	%xmm1, %xmm1
	vpmovzxbw	%xmm0, %xmm0
	vcvtdq2ps	%xmm1, %xmm1
	vfmsub132ps	%xmm8, %xmm7, %xmm1
	vpmovsxwd	%xmm2, %xmm2
	vpmovsxwd	%xmm0, %xmm3
	vcvtdq2ps	%xmm2, %xmm2
	vfmsub132ps	%xmm8, %xmm7, %xmm2
	vpsrldq	$8, %xmm0, %xmm0
	vcvtdq2ps	%xmm3, %xmm3
	vpmovsxwd	%xmm0, %xmm0
	vfmsub132ps	%xmm8, %xmm7, %xmm3
	vcvtdq2ps	%xmm0, %xmm0
	vfmsub132ps	%xmm8, %xmm7, %xmm0
	vmulps	%xmm6, %xmm1, %xmm1
	vmulps	%xmm6, %xmm0, %xmm0
	vmovups	%xmm1, (%rcx)
	vmulps	%xmm6, %xmm2, %xmm1
	vmovups	%xmm0, 48(%rcx)
	vmovups	%xmm1, 16(%rcx)
	vmulps	%xmm6, %xmm3, %xmm1
	vmovups	%xmm1, 32(%rcx)
	movq	%rax, %rcx
	andq	$-16, %rcx
	addq	%rcx, %rdx
	testb	$15, %al
	je	.L447
.L451:
	movzbl	(%r9,%rdx), %eax
	vxorps	%xmm0, %xmm0, %xmm0
	vmovss	.LC3(%rip), %xmm2
	leaq	1(%rdx), %rcx
	vcvtusi2ssl	%eax, %xmm0, %xmm1
	leaq	0(,%rdx,4), %rax
	vfmsub132ss	%xmm2, %xmm5, %xmm1
	vmulss	%xmm1, %xmm4, %xmm1
	vmovss	%xmm1, (%r8,%rdx,4)
	cmpq	%rcx, %rdi
	jle	.L447
	movzbl	1(%r9,%rdx), %ecx
	vcvtusi2ssl	%ecx, %xmm0, %xmm1
	leaq	2(%rdx), %rcx
	vfmsub132ss	%xmm2, %xmm5, %xmm1
	vmulss	%xmm1, %xmm4, %xmm1
	vmovss	%xmm1, 4(%r8,%rax)
	cmpq	%rcx, %rdi
	jle	.L447
	movzbl	2(%r9,%rdx), %ecx
	vcvtusi2ssl	%ecx, %xmm0, %xmm1
	leaq	3(%rdx), %rcx
	vfmsub132ss	%xmm2, %xmm5, %xmm1
	vmulss	%xmm1, %xmm4, %xmm1
	vmovss	%xmm1, 8(%r8,%rax)
	cmpq	%rcx, %rdi
	jle	.L447
	movzbl	3(%r9,%rdx), %ecx
	vcvtusi2ssl	%ecx, %xmm0, %xmm1
	leaq	4(%rdx), %rcx
	vfmsub132ss	%xmm2, %xmm5, %xmm1
	vmulss	%xmm1, %xmm4, %xmm1
	vmovss	%xmm1, 12(%r8,%rax)
	cmpq	%rcx, %rdi
	jle	.L447
	movzbl	4(%r9,%rdx), %ecx
	vcvtusi2ssl	%ecx, %xmm0, %xmm1
	leaq	5(%rdx), %rcx
	vfmsub132ss	%xmm2, %xmm5, %xmm1
	vmulss	%xmm1, %xmm4, %xmm1
	vmovss	%xmm1, 16(%r8,%rax)
	cmpq	%rcx, %rdi
	jle	.L447
	movzbl	5(%r9,%rdx), %ecx
	vcvtusi2ssl	%ecx, %xmm0, %xmm1
	leaq	6(%rdx), %rcx
	vfmsub132ss	%xmm2, %xmm5, %xmm1
	vmulss	%xmm1, %xmm4, %xmm1
	vmovss	%xmm1, 20(%r8,%rax)
	cmpq	%rcx, %rdi
	jle	.L447
	movzbl	6(%r9,%rdx), %ecx
	vcvtusi2ssl	%ecx, %xmm0, %xmm1
	leaq	7(%rdx), %rcx
	vfmsub132ss	%xmm2, %xmm5, %xmm1
	vmulss	%xmm1, %xmm4, %xmm1
	vmovss	%xmm1, 24(%r8,%rax)
	cmpq	%rcx, %rdi
	jle	.L447
	movzbl	7(%r9,%rdx), %ecx
	vcvtusi2ssl	%ecx, %xmm0, %xmm1
	leaq	8(%rdx), %rcx
	vfmsub132ss	%xmm2, %xmm5, %xmm1
	vmulss	%xmm1, %xmm4, %xmm1
	vmovss	%xmm1, 28(%r8,%rax)
	cmpq	%rcx, %rdi
	jle	.L447
	movzbl	8(%r9,%rdx), %ecx
	vcvtusi2ssl	%ecx, %xmm0, %xmm1
	leaq	9(%rdx), %rcx
	vfmsub132ss	%xmm2, %xmm5, %xmm1
	vmulss	%xmm1, %xmm4, %xmm1
	vmovss	%xmm1, 32(%r8,%rax)
	cmpq	%rcx, %rdi
	jle	.L447
	movzbl	9(%r9,%rdx), %ecx
	vcvtusi2ssl	%ecx, %xmm0, %xmm1
	leaq	10(%rdx), %rcx
	vfmsub132ss	%xmm2, %xmm5, %xmm1
	vmulss	%xmm1, %xmm4, %xmm1
	vmovss	%xmm1, 36(%r8,%rax)
	cmpq	%rcx, %rdi
	jle	.L447
	movzbl	10(%r9,%rdx), %ecx
	vcvtusi2ssl	%ecx, %xmm0, %xmm1
	leaq	11(%rdx), %rcx
	vfmsub132ss	%xmm2, %xmm5, %xmm1
	vmulss	%xmm1, %xmm4, %xmm1
	vmovss	%xmm1, 40(%r8,%rax)
	cmpq	%rcx, %rdi
	jle	.L447
	movzbl	11(%r9,%rdx), %ecx
	vcvtusi2ssl	%ecx, %xmm0, %xmm1
	leaq	12(%rdx), %rcx
	vfmsub132ss	%xmm2, %xmm5, %xmm1
	vmulss	%xmm1, %xmm4, %xmm1
	vmovss	%xmm1, 44(%r8,%rax)
	cmpq	%rcx, %rdi
	jle	.L447
	movzbl	12(%r9,%rdx), %ecx
	vcvtusi2ssl	%ecx, %xmm0, %xmm1
	leaq	13(%rdx), %rcx
	vfmsub132ss	%xmm2, %xmm5, %xmm1
	vmulss	%xmm1, %xmm4, %xmm1
	vmovss	%xmm1, 48(%r8,%rax)
	cmpq	%rcx, %rdi
	jle	.L447
	movzbl	13(%r9,%rdx), %ecx
	vcvtusi2ssl	%ecx, %xmm0, %xmm1
	leaq	14(%rdx), %rcx
	vfmsub132ss	%xmm2, %xmm5, %xmm1
	vmulss	%xmm1, %xmm4, %xmm1
	vmovss	%xmm1, 52(%r8,%rax)
	cmpq	%rcx, %rdi
	jle	.L447
	movzbl	14(%r9,%rdx), %edx
	vcvtusi2ssl	%edx, %xmm0, %xmm0
	vfmsub132ss	%xmm2, %xmm5, %xmm0
	vmulss	%xmm0, %xmm4, %xmm4
	vmovss	%xmm4, 56(%r8,%rax)
.L447:
	leaq	-16(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	jmp	GOMP_barrier@PLT
	.p2align 4,,10
	.p2align 3
.L460:
	.cfi_restore_state
	incq	%rax
	xorl	%edx, %edx
	jmp	.L446
	.p2align 4,,10
	.p2align 3
.L453:
	xorl	%r11d, %r11d
	jmp	.L448
.L461:
	vzeroupper
	jmp	.L447
	.cfi_endproc
.LFE8939:
	.size	pfi_preprocess._omp_fn.0, .-pfi_preprocess._omp_fn.0
	.p2align 4
	.type	pfi_route._omp_fn.0, @function
pfi_route._omp_fn.0:
.LFB8943:
	.cfi_startproc
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	movq	%rdi, %rax
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$40, %rsp
	.cfi_def_cfa_offset 96
	movq	16(%rax), %r13
	movl	_ZN12_GLOBAL__N_18g_kernelE(%rip), %esi
	movq	8(%rdi), %rbx
	movl	28(%rdi), %r12d
	movq	8(%r13), %rax
	movq	0(%r13), %rcx
	movl	%esi, 12(%rsp)
	movq	88+_ZN12_GLOBAL__N_11HE(%rip), %rsi
	movq	80+_ZN12_GLOBAL__N_11HE(%rip), %rbp
	movq	%rbx, 24(%rsp)
	movq	%rax, %rdx
	movl	24(%rdi), %ebx
	movq	(%rdi), %rdi
	subq	%rcx, %rdx
	movq	%rsi, 16(%rsp)
	sarq	$5, %rdx
	cmpq	%rcx, %rax
	je	.L476
	movq	%rbp, %r15
	xorl	%r14d, %r14d
	jmp	.L466
	.p2align 4,,10
	.p2align 3
.L464:
	cmpq	%rdx, %r14
	jnb	.L463
	movq	%rbp, %rsi
.L465:
	movq	%r15, %rdi
	movq	%rsi, %r15
.L466:
	incq	%r14
	movl	12(%rsp), %r9d
	cmpq	%rdx, %r14
	movq	%r14, %rdx
	setne	%r8b
	salq	$5, %rdx
	leaq	-32(%rcx,%rdx), %rsi
	movzbl	%r8b, %r8d
	movl	%ebx, %ecx
	movq	%r15, %rdx
	call	_ZN12_GLOBAL__N_120dense_layer_inregionEPKfRKNS_5LayerEPfibi
	movq	0(%r13), %rcx
	movq	8(%r13), %rdx
	subq	%rcx, %rdx
	sarq	$5, %rdx
	cmpq	%r15, %rbp
	jne	.L464
	cmpq	%rdx, %r14
	jnb	.L463
	movq	16(%rsp), %rsi
	jmp	.L465
.L476:
	movq	%rdi, %r15
	.p2align 4,,10
	.p2align 3
.L463:
	call	omp_get_num_threads@PLT
	movl	%eax, %ebp
	call	omp_get_thread_num@PLT
	movl	%eax, %ecx
	movl	%ebx, %eax
	cltd
	idivl	%ebp
	cmpl	%edx, %ecx
	jl	.L467
.L475:
	imull	%eax, %ecx
	addl	%ecx, %edx
	leal	(%rax,%rdx), %ecx
	cmpl	%ecx, %edx
	jge	.L482
	movslq	%r12d, %r8
	movslq	%edx, %rdx
	movq	24(%rsp), %rbx
	movl	%eax, %eax
	salq	$2, %r8
	addq	%rdx, %rax
	movl	%r12d, %esi
	movq	%r8, %rcx
	leaq	(%rbx,%rdx,4), %rdi
	leaq	(%rbx,%rax,4), %r9
	imulq	%rdx, %rcx
	addq	%r15, %rcx
	.p2align 4,,10
	.p2align 3
.L473:
	cmpl	$1, %r12d
	jle	.L478
	vmovss	(%rcx), %xmm0
	movl	$1, %eax
	xorl	%edx, %edx
	.p2align 4,,10
	.p2align 3
.L472:
	vmovss	(%rcx,%rax,4), %xmm1
	vcomiss	%xmm0, %xmm1
	vmaxss	%xmm0, %xmm1, %xmm0
	cmova	%eax, %edx
	incq	%rax
	cmpq	%rax, %rsi
	jne	.L472
	movl	%edx, (%rdi)
	addq	$4, %rdi
	addq	%r8, %rcx
	cmpq	%r9, %rdi
	jne	.L473
.L482:
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L478:
	.cfi_restore_state
	xorl	%edx, %edx
	addq	$4, %rdi
	addq	%r8, %rcx
	movl	%edx, -4(%rdi)
	cmpq	%r9, %rdi
	jne	.L473
	jmp	.L482
.L467:
	incl	%eax
	xorl	%edx, %edx
	jmp	.L475
	.cfi_endproc
.LFE8943:
	.size	pfi_route._omp_fn.0, .-pfi_route._omp_fn.0
	.p2align 4
	.type	pfi_spec_predict._omp_fn.0, @function
pfi_spec_predict._omp_fn.0:
.LFB8944:
	.cfi_startproc
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$40, %rsp
	.cfi_def_cfa_offset 96
	movq	8(%rdi), %rax
	movq	16(%rdi), %r13
	movl	32(%rdi), %r15d
	movl	28(%rdi), %ebp
	movq	(%rdi), %r11
	movq	0(%r13), %rcx
	movq	%rax, 16(%rsp)
	movl	24(%rdi), %eax
	movq	8(%r13), %rdi
	movq	88+_ZN12_GLOBAL__N_11HE(%rip), %r10
	movq	80+_ZN12_GLOBAL__N_11HE(%rip), %r12
	movq	%rdi, %rdx
	movl	%eax, 28(%rsp)
	movl	_ZN12_GLOBAL__N_18g_kernelE(%rip), %eax
	subq	%rcx, %rdx
	sarq	$5, %rdx
	cmpq	%rcx, %rdi
	je	.L499
	xorl	%ebx, %ebx
	movl	%r15d, 24(%rsp)
	movq	%r11, %rdi
	movq	%r13, %r15
	movq	%rbx, %r14
	movq	%r10, 8(%rsp)
	movq	%r12, %r13
	movl	%eax, %ebx
	jmp	.L488
	.p2align 4,,10
	.p2align 3
.L486:
	cmpq	%rdx, %r14
	jnb	.L506
	movq	%r12, %rsi
.L487:
	movq	%r13, %rdi
	movq	%rsi, %r13
.L488:
	incq	%r14
	movl	%ebx, %r9d
	cmpq	%rdx, %r14
	movq	%r14, %rdx
	setne	%r8b
	salq	$5, %rdx
	leaq	-32(%rcx,%rdx), %rsi
	movzbl	%r8b, %r8d
	movl	%ebp, %ecx
	movq	%r13, %rdx
	call	_ZN12_GLOBAL__N_120dense_layer_inregionEPKfRKNS_5LayerEPfibi
	movq	(%r15), %rcx
	movq	8(%r15), %rdx
	subq	%rcx, %rdx
	sarq	$5, %rdx
	cmpq	%r13, %r12
	jne	.L486
	cmpq	%rdx, %r14
	jnb	.L506
	movq	8(%rsp), %rsi
	jmp	.L487
	.p2align 4,,10
	.p2align 3
.L506:
	movl	24(%rsp), %r15d
	movq	%r13, %r14
.L485:
	call	omp_get_num_threads@PLT
	movl	%eax, %ebx
	call	omp_get_thread_num@PLT
	movl	%eax, %ecx
	movl	%ebp, %eax
	cltd
	idivl	%ebx
	cmpl	%edx, %ecx
	jl	.L489
.L498:
	imull	%eax, %ecx
	addl	%ecx, %edx
	leal	(%rax,%rdx), %ecx
	cmpl	%ecx, %edx
	jge	.L507
	movslq	28(%rsp), %r12
	movq	32+_ZN12_GLOBAL__N_11HE(%rip), %rsi
	movslq	%edx, %rdx
	movslq	%r15d, %r10
	salq	$2, %r10
	movq	16(%rsp), %rbx
	movl	%eax, %eax
	movl	%r15d, %edi
	leaq	(%r12,%r12,2), %rcx
	addq	%rdx, %rax
	leaq	(%rsi,%rcx,8), %rcx
	leaq	(%rbx,%rdx,4), %r8
	movq	(%rcx), %r9
	movq	%rdx, %rcx
	leaq	(%rbx,%rax,4), %r11
	imulq	%r10, %rcx
	addq	%r14, %rcx
	.p2align 4,,10
	.p2align 3
.L496:
	cmpl	$1, %r15d
	jle	.L501
	vmovss	(%rcx), %xmm1
	movl	$1, %eax
	xorl	%esi, %esi
	jmp	.L495
	.p2align 4,,10
	.p2align 3
.L510:
	movl	%eax, %esi
	leaq	0(,%rax,4), %rdx
	vmovaps	%xmm0, %xmm1
	incq	%rax
	cmpq	%rax, %rdi
	je	.L509
.L495:
	vmovss	(%rcx,%rax,4), %xmm0
	vcomiss	%xmm1, %xmm0
	ja	.L510
	movslq	%esi, %rdx
	incq	%rax
	salq	$2, %rdx
	cmpq	%rax, %rdi
	jne	.L495
.L509:
	addq	%r9, %rdx
.L491:
	movl	(%rdx), %eax
	addq	$4, %r8
	addq	%r10, %rcx
	movl	%eax, -4(%r8)
	cmpq	%r8, %r11
	jne	.L496
.L507:
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L501:
	.cfi_restore_state
	movq	%r9, %rdx
	jmp	.L491
.L489:
	incl	%eax
	xorl	%edx, %edx
	jmp	.L498
.L499:
	movq	%r11, %r14
	jmp	.L485
	.cfi_endproc
.LFE8944:
	.size	pfi_spec_predict._omp_fn.0, .-pfi_spec_predict._omp_fn.0
	.p2align 4
	.type	pfi_flat_predict._omp_fn.0, @function
pfi_flat_predict._omp_fn.0:
.LFB8941:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	.cfi_offset 15, -24
	movq	%rdi, %r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	andq	$-32, %rsp
	subq	$32, %rsp
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	.cfi_offset 3, -56
	movl	36(%rdi), %eax
	movl	32(%rdi), %ebx
	movl	%eax, 8(%rsp)
	movq	8(%rdi), %rax
	movq	%rax, (%rsp)
	call	omp_get_num_threads@PLT
	movl	%eax, %r14d
	movl	%eax, 12(%rsp)
	call	omp_get_thread_num@PLT
	movslq	%r14d, %rsi
	movslq	%eax, %rcx
	movslq	%ebx, %rax
	imulq	$784, %rax, %rax
	movl	%ecx, 24(%rsp)
	cqto
	idivq	%rsi
	cmpq	%rdx, %rcx
	jl	.L551
.L512:
	imulq	%rax, %rcx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %r8
	cmpq	%r8, %rdx
	jge	.L519
	leaq	-1(%rax), %rcx
	movq	(%r15), %r10
	movq	72+_ZN12_GLOBAL__N_11HE(%rip), %r9
	movq	%rdx, %r12
	vmovss	56+_ZN12_GLOBAL__N_11HE(%rip), %xmm2
	vmovss	60+_ZN12_GLOBAL__N_11HE(%rip), %xmm1
	cmpq	$30, %rcx
	jbe	.L536
	movq	%rax, %rdi
	leaq	(%r10,%rdx), %rsi
	vbroadcastss	.LC3(%rip), %ymm4
	vbroadcastss	%xmm2, %ymm6
	andq	$-32, %rdi
	vbroadcastss	%xmm1, %ymm5
	leaq	(%r9,%rdx,4), %rcx
	leaq	(%rsi,%rdi), %r11
	.p2align 4,,10
	.p2align 3
.L517:
	vmovdqu8	(%rsi), %ymm0
	addq	$32, %rsi
	subq	$-128, %rcx
	vpmovzxbw	%xmm0, %ymm7
	vextracti128	$0x1, %ymm0, %xmm0
	vextracti128	$0x1, %ymm7, %xmm3
	vpmovzxbw	%xmm0, %ymm0
	vpmovsxwd	%xmm7, %ymm7
	vpmovsxwd	%xmm3, %ymm3
	vpmovsxwd	%xmm0, %ymm11
	vextracti128	$0x1, %ymm0, %xmm0
	vcvtdq2ps	%ymm7, %ymm7
	vcvtdq2ps	%ymm3, %ymm3
	vfmsub132ps	%ymm4, %ymm6, %ymm3
	vcvtdq2ps	%ymm11, %ymm10
	vpmovsxwd	%xmm0, %ymm0
	vmovaps	%ymm10, %ymm9
	vfmsub132ps	%ymm4, %ymm6, %ymm7
	vfmsub132ps	%ymm4, %ymm6, %ymm9
	vcvtdq2ps	%ymm0, %ymm0
	vfmsub132ps	%ymm4, %ymm6, %ymm0
	vmulps	%ymm5, %ymm3, %ymm3
	vmulps	%ymm5, %ymm7, %ymm7
	vmulps	%ymm5, %ymm0, %ymm0
	vmovups	%ymm3, -96(%rcx)
	vmulps	%ymm5, %ymm9, %ymm3
	vmovups	%ymm7, -128(%rcx)
	vmovups	%ymm0, -32(%rcx)
	vmovups	%ymm3, -64(%rcx)
	cmpq	%r11, %rsi
	jne	.L517
	addq	%rdi, %rdx
	cmpq	%rdi, %rax
	je	.L552
	vzeroupper
.L516:
	subq	%rdi, %rax
	leaq	-1(%rax), %rcx
	cmpq	$14, %rcx
	jbe	.L521
	addq	%r12, %rdi
	vbroadcastss	.LC3(%rip), %xmm8
	vbroadcastss	%xmm2, %xmm7
	vbroadcastss	%xmm1, %xmm6
	vmovdqu8	(%r10,%rdi), %xmm0
	leaq	(%r9,%rdi,4), %rcx
	vpmovzxbw	%xmm0, %xmm3
	vpsrldq	$8, %xmm0, %xmm0
	vpsrldq	$8, %xmm3, %xmm4
	vpmovsxwd	%xmm3, %xmm3
	vpmovzxbw	%xmm0, %xmm0
	vcvtdq2ps	%xmm3, %xmm3
	vfmsub132ps	%xmm8, %xmm7, %xmm3
	vpmovsxwd	%xmm4, %xmm4
	vpmovsxwd	%xmm0, %xmm5
	vcvtdq2ps	%xmm4, %xmm4
	vfmsub132ps	%xmm8, %xmm7, %xmm4
	vpsrldq	$8, %xmm0, %xmm0
	vcvtdq2ps	%xmm5, %xmm5
	vpmovsxwd	%xmm0, %xmm0
	vfmsub132ps	%xmm8, %xmm7, %xmm5
	vcvtdq2ps	%xmm0, %xmm0
	vfmsub132ps	%xmm8, %xmm7, %xmm0
	vmulps	%xmm6, %xmm3, %xmm3
	vmulps	%xmm6, %xmm0, %xmm0
	vmovups	%xmm3, (%rcx)
	vmulps	%xmm6, %xmm4, %xmm3
	vmovups	%xmm0, 48(%rcx)
	vmovups	%xmm3, 16(%rcx)
	vmulps	%xmm6, %xmm5, %xmm3
	vmovups	%xmm3, 32(%rcx)
	movq	%rax, %rcx
	andq	$-16, %rcx
	addq	%rcx, %rdx
	testb	$15, %al
	je	.L519
.L521:
	movzbl	(%r10,%rdx), %eax
	vxorps	%xmm3, %xmm3, %xmm3
	vmovss	.LC3(%rip), %xmm4
	leaq	1(%rdx), %rcx
	vcvtusi2ssl	%eax, %xmm3, %xmm0
	leaq	0(,%rdx,4), %rax
	vfmsub132ss	%xmm4, %xmm2, %xmm0
	vmulss	%xmm0, %xmm1, %xmm0
	vmovss	%xmm0, (%r9,%rdx,4)
	cmpq	%rcx, %r8
	jle	.L519
	movzbl	1(%r10,%rdx), %ecx
	vcvtusi2ssl	%ecx, %xmm3, %xmm0
	leaq	2(%rdx), %rcx
	vfmsub132ss	%xmm4, %xmm2, %xmm0
	vmulss	%xmm0, %xmm1, %xmm0
	vmovss	%xmm0, 4(%r9,%rax)
	cmpq	%rcx, %r8
	jle	.L519
	movzbl	2(%r10,%rdx), %ecx
	vcvtusi2ssl	%ecx, %xmm3, %xmm0
	leaq	3(%rdx), %rcx
	vfmsub132ss	%xmm4, %xmm2, %xmm0
	vmulss	%xmm1, %xmm0, %xmm0
	vmovss	%xmm0, 8(%r9,%rax)
	cmpq	%rcx, %r8
	jle	.L519
	movzbl	3(%r10,%rdx), %ecx
	vcvtusi2ssl	%ecx, %xmm3, %xmm0
	leaq	4(%rdx), %rcx
	vfmsub132ss	%xmm4, %xmm2, %xmm0
	vmulss	%xmm0, %xmm1, %xmm0
	vmovss	%xmm0, 12(%r9,%rax)
	cmpq	%rcx, %r8
	jle	.L519
	movzbl	4(%r10,%rdx), %ecx
	vcvtusi2ssl	%ecx, %xmm3, %xmm0
	leaq	5(%rdx), %rcx
	vfmsub132ss	%xmm4, %xmm2, %xmm0
	vmulss	%xmm0, %xmm1, %xmm0
	vmovss	%xmm0, 16(%r9,%rax)
	cmpq	%rcx, %r8
	jle	.L519
	movzbl	5(%r10,%rdx), %ecx
	vcvtusi2ssl	%ecx, %xmm3, %xmm0
	leaq	6(%rdx), %rcx
	vfmsub132ss	%xmm4, %xmm2, %xmm0
	vmulss	%xmm0, %xmm1, %xmm0
	vmovss	%xmm0, 20(%r9,%rax)
	cmpq	%rcx, %r8
	jle	.L519
	movzbl	6(%r10,%rdx), %ecx
	vcvtusi2ssl	%ecx, %xmm3, %xmm0
	leaq	7(%rdx), %rcx
	vfmsub132ss	%xmm4, %xmm2, %xmm0
	vmulss	%xmm0, %xmm1, %xmm0
	vmovss	%xmm0, 24(%r9,%rax)
	cmpq	%rcx, %r8
	jle	.L519
	movzbl	7(%r10,%rdx), %ecx
	vcvtusi2ssl	%ecx, %xmm3, %xmm0
	leaq	8(%rdx), %rcx
	vfmsub132ss	%xmm4, %xmm2, %xmm0
	vmulss	%xmm0, %xmm1, %xmm0
	vmovss	%xmm0, 28(%r9,%rax)
	cmpq	%rcx, %r8
	jle	.L519
	movzbl	8(%r10,%rdx), %ecx
	vcvtusi2ssl	%ecx, %xmm3, %xmm0
	leaq	9(%rdx), %rcx
	vfmsub132ss	%xmm4, %xmm2, %xmm0
	vmulss	%xmm0, %xmm1, %xmm0
	vmovss	%xmm0, 32(%r9,%rax)
	cmpq	%rcx, %r8
	jle	.L519
	movzbl	9(%r10,%rdx), %ecx
	vcvtusi2ssl	%ecx, %xmm3, %xmm0
	leaq	10(%rdx), %rcx
	vfmsub132ss	%xmm4, %xmm2, %xmm0
	vmulss	%xmm0, %xmm1, %xmm0
	vmovss	%xmm0, 36(%r9,%rax)
	cmpq	%rcx, %r8
	jle	.L519
	movzbl	10(%r10,%rdx), %ecx
	vcvtusi2ssl	%ecx, %xmm3, %xmm0
	leaq	11(%rdx), %rcx
	vfmsub132ss	%xmm4, %xmm2, %xmm0
	vmulss	%xmm0, %xmm1, %xmm0
	vmovss	%xmm0, 40(%r9,%rax)
	cmpq	%rcx, %r8
	jle	.L519
	movzbl	11(%r10,%rdx), %ecx
	vcvtusi2ssl	%ecx, %xmm3, %xmm0
	leaq	12(%rdx), %rcx
	vfmsub132ss	%xmm4, %xmm2, %xmm0
	vmulss	%xmm0, %xmm1, %xmm0
	vmovss	%xmm0, 44(%r9,%rax)
	cmpq	%rcx, %r8
	jle	.L519
	movzbl	12(%r10,%rdx), %ecx
	vcvtusi2ssl	%ecx, %xmm3, %xmm0
	leaq	13(%rdx), %rcx
	vfmsub132ss	%xmm4, %xmm2, %xmm0
	vmulss	%xmm0, %xmm1, %xmm0
	vmovss	%xmm0, 48(%r9,%rax)
	cmpq	%rcx, %r8
	jle	.L519
	movzbl	13(%r10,%rdx), %ecx
	vcvtusi2ssl	%ecx, %xmm3, %xmm0
	leaq	14(%rdx), %rcx
	vfmsub132ss	%xmm4, %xmm2, %xmm0
	vmulss	%xmm0, %xmm1, %xmm0
	vmovss	%xmm0, 52(%r9,%rax)
	cmpq	%rcx, %r8
	jle	.L519
	movzbl	14(%r10,%rdx), %edx
	vcvtusi2ssl	%edx, %xmm3, %xmm3
	vfmsub132ss	%xmm4, %xmm2, %xmm3
	vmulss	%xmm3, %xmm1, %xmm1
	vmovss	%xmm1, 56(%r9,%rax)
	.p2align 4,,10
	.p2align 3
.L519:
	call	GOMP_barrier@PLT
	movl	24(%rsp), %eax
	testl	%eax, %eax
	je	.L553
.L515:
	movq	16(%r15), %r13
	movl	_ZN12_GLOBAL__N_18g_kernelE(%rip), %r9d
	movq	88+_ZN12_GLOBAL__N_11HE(%rip), %r11
	movq	80+_ZN12_GLOBAL__N_11HE(%rip), %r12
	movq	8(%r13), %r8
	movq	0(%r13), %rsi
	movq	72+_ZN12_GLOBAL__N_11HE(%rip), %rdi
	movq	%r8, %rdx
	subq	%rsi, %rdx
	sarq	$5, %rdx
	cmpq	%rsi, %r8
	je	.L537
	xorl	%r15d, %r15d
	movl	%r9d, 28(%rsp)
	movq	%r15, %r14
	movq	%r11, 16(%rsp)
	movq	%r13, %r15
	movq	%r12, %r13
	jmp	.L526
	.p2align 4,,10
	.p2align 3
.L524:
	cmpq	%rdx, %r14
	jnb	.L547
	movq	%r12, %rcx
.L525:
	movq	%r13, %rdi
	movq	%rcx, %r13
.L526:
	incq	%r14
	movl	28(%rsp), %r9d
	movl	%ebx, %ecx
	cmpq	%rdx, %r14
	movq	%r14, %rdx
	setne	%r8b
	salq	$5, %rdx
	leaq	-32(%rsi,%rdx), %rsi
	movzbl	%r8b, %r8d
	movq	%r13, %rdx
	call	_ZN12_GLOBAL__N_120dense_layer_inregionEPKfRKNS_5LayerEPfibi
	movq	(%r15), %rsi
	movq	8(%r15), %rdx
	subq	%rsi, %rdx
	sarq	$5, %rdx
	cmpq	%r13, %r12
	jne	.L524
	cmpq	%rdx, %r14
	jnb	.L547
	movq	16(%rsp), %rcx
	jmp	.L525
	.p2align 4,,10
	.p2align 3
.L547:
	movq	%r13, %r14
.L523:
	movl	%ebx, %eax
	movl	24(%rsp), %ebx
	cltd
	idivl	12(%rsp)
	cmpl	%ebx, %edx
	jg	.L527
.L535:
	movl	24(%rsp), %r12d
	imull	%eax, %r12d
	addl	%edx, %r12d
	leal	(%rax,%r12), %edx
	cmpl	%edx, %r12d
	jge	.L549
	movslq	8(%rsp), %r8
	movslq	%r12d, %r12
	movq	(%rsp), %rsi
	movl	%eax, %eax
	addq	%r12, %rax
	movq	%r8, %rbx
	salq	$2, %r8
	leaq	(%rsi,%r12,4), %rdi
	leaq	(%rsi,%rax,4), %r9
	movq	%r8, %rcx
	movl	%ebx, %esi
	movl	%ebx, %r10d
	imulq	%r12, %rcx
	addq	%r14, %rcx
	.p2align 4,,10
	.p2align 3
.L533:
	cmpl	$1, %r10d
	jle	.L539
	vmovss	(%rcx), %xmm0
	movl	$1, %eax
	xorl	%edx, %edx
	.p2align 4,,10
	.p2align 3
.L532:
	vmovss	(%rcx,%rax,4), %xmm1
	vcomiss	%xmm0, %xmm1
	vmaxss	%xmm0, %xmm1, %xmm0
	cmova	%eax, %edx
	incq	%rax
	cmpq	%rax, %rsi
	jne	.L532
	movl	%edx, (%rdi)
	addq	$4, %rdi
	addq	%r8, %rcx
	cmpq	%rdi, %r9
	jne	.L533
.L549:
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
	.p2align 4,,10
	.p2align 3
.L539:
	.cfi_restore_state
	xorl	%edx, %edx
	addq	$4, %rdi
	addq	%r8, %rcx
	movl	%edx, -4(%rdi)
	cmpq	%rdi, %r9
	jne	.L533
	jmp	.L549
.L553:
	call	_ZNSt6chrono3_V212steady_clock3nowEv@PLT
	movq	%rax, 24(%r15)
	jmp	.L515
.L551:
	incq	%rax
	xorl	%edx, %edx
	jmp	.L512
.L527:
	incl	%eax
	xorl	%edx, %edx
	jmp	.L535
.L536:
	xorl	%edi, %edi
	jmp	.L516
.L537:
	movq	%rdi, %r14
	jmp	.L523
.L552:
	vzeroupper
	jmp	.L519
	.cfi_endproc
.LFE8941:
	.size	pfi_flat_predict._omp_fn.0, .-pfi_flat_predict._omp_fn.0
	.align 2
	.p2align 4
	.type	_ZN12_GLOBAL__N_14HierD2Ev, @function
_ZN12_GLOBAL__N_14HierD2Ev:
.LFB8933:
	.cfi_startproc
	endbr64
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	movq	%rdi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	movq	176(%rdi), %rdi
	testq	%rdi, %rdi
	je	.L555
	movq	192(%rbp), %rsi
	subq	%rdi, %rsi
	call	_ZdlPvm@PLT
.L555:
	movq	152(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L556
	movq	168(%rbp), %rsi
	subq	%rdi, %rsi
	call	_ZdlPvm@PLT
.L556:
	movq	128(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L557
	movq	144(%rbp), %rsi
	subq	%rdi, %rsi
	call	_ZdlPvm@PLT
.L557:
	movq	104(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L558
	movq	120(%rbp), %rsi
	subq	%rdi, %rsi
	call	_ZdlPvm@PLT
.L558:
	movq	40(%rbp), %r12
	movq	32(%rbp), %rbx
	cmpq	%rbx, %r12
	je	.L559
	.p2align 4,,10
	.p2align 3
.L563:
	movq	(%rbx), %rdi
	testq	%rdi, %rdi
	je	.L560
	movq	16(%rbx), %rsi
	addq	$24, %rbx
	subq	%rdi, %rsi
	call	_ZdlPvm@PLT
	cmpq	%rbx, %r12
	jne	.L563
.L562:
	movq	32(%rbp), %rbx
.L559:
	testq	%rbx, %rbx
	je	.L564
	movq	48(%rbp), %rsi
	movq	%rbx, %rdi
	subq	%rbx, %rsi
	call	_ZdlPvm@PLT
.L564:
	movq	8(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L581
	movq	24(%rbp), %rsi
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	subq	%rdi, %rsi
	popq	%r12
	.cfi_def_cfa_offset 8
	jmp	_ZdlPvm@PLT
	.p2align 4,,10
	.p2align 3
.L560:
	.cfi_restore_state
	addq	$24, %rbx
	cmpq	%rbx, %r12
	jne	.L563
	jmp	.L562
	.p2align 4,,10
	.p2align 3
.L581:
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE8933:
	.size	_ZN12_GLOBAL__N_14HierD2Ev, .-_ZN12_GLOBAL__N_14HierD2Ev
	.set	_ZN12_GLOBAL__N_14HierD1Ev,_ZN12_GLOBAL__N_14HierD2Ev
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC5:
	.string	"cannot create std::vector larger than max_size()"
	.text
	.p2align 4
	.type	pfi_hier_predict._omp_fn.0, @function
pfi_hier_predict._omp_fn.0:
.LFB8942:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA8942
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	andq	$-32, %rsp
	subq	$96, %rsp
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	.cfi_offset 3, -56
	movl	56(%rdi), %ebx
	movq	%rdi, 64(%rsp)
	movl	%ebx, 52(%rsp)
	movl	52(%rdi), %ebx
	movl	%ebx, 72(%rsp)
	movq	8(%rdi), %rbx
	movq	%rbx, 16(%rsp)
	movl	48(%rdi), %ebx
	call	omp_get_num_threads@PLT
	movl	%eax, %r15d
	movl	%eax, 80(%rsp)
	call	omp_get_thread_num@PLT
	movslq	%ebx, %rdi
	movslq	%r15d, %rsi
	movslq	%eax, %rcx
	imulq	$784, %rdi, %rax
	movq	%rdi, 40(%rsp)
	movl	%ecx, 84(%rsp)
	cqto
	idivq	%rsi
	cmpq	%rdx, %rcx
	jl	.L700
.L584:
	imulq	%rax, %rcx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdi
	cmpq	%rdi, %rcx
	jge	.L591
	movq	64(%rsp), %rsi
	leaq	-1(%rax), %rdx
	movq	72+_ZN12_GLOBAL__N_11HE(%rip), %r8
	movq	%rcx, %r10
	vmovss	56+_ZN12_GLOBAL__N_11HE(%rip), %xmm2
	vmovss	60+_ZN12_GLOBAL__N_11HE(%rip), %xmm1
	movq	(%rsi), %r9
	cmpq	$30, %rdx
	jbe	.L661
	movq	%rax, %r11
	leaq	(%r8,%rcx,4), %rdx
	vbroadcastss	.LC3(%rip), %ymm4
	vbroadcastss	%xmm2, %ymm6
	shrq	$5, %r11
	vbroadcastss	%xmm1, %ymm5
	leaq	(%r9,%rcx), %rsi
	salq	$7, %r11
	addq	%rdx, %r11
	.p2align 4,,10
	.p2align 3
.L589:
	vmovdqu8	(%rsi), %ymm0
	subq	$-128, %rdx
	addq	$32, %rsi
	vpmovzxbw	%xmm0, %ymm7
	vextracti128	$0x1, %ymm0, %xmm0
	vextracti128	$0x1, %ymm7, %xmm3
	vpmovsxwd	%xmm7, %ymm7
	vpmovzxbw	%xmm0, %ymm0
	vcvtdq2ps	%ymm7, %ymm7
	vfmsub132ps	%ymm4, %ymm6, %ymm7
	vpmovsxwd	%xmm0, %ymm11
	vextracti128	$0x1, %ymm0, %xmm0
	vpmovsxwd	%xmm3, %ymm3
	vpmovsxwd	%xmm0, %ymm0
	vcvtdq2ps	%ymm11, %ymm10
	vcvtdq2ps	%ymm3, %ymm3
	vcvtdq2ps	%ymm0, %ymm0
	vfmsub132ps	%ymm4, %ymm6, %ymm3
	vfmsub132ps	%ymm4, %ymm6, %ymm0
	vmovaps	%ymm7, %ymm9
	vmovaps	%ymm10, %ymm7
	vmulps	%ymm9, %ymm5, %ymm13
	vfmsub132ps	%ymm4, %ymm6, %ymm7
	vmulps	%ymm3, %ymm5, %ymm3
	vmulps	%ymm0, %ymm5, %ymm0
	vmulps	%ymm7, %ymm5, %ymm7
	vmovups	%ymm13, -128(%rdx)
	vmovups	%ymm3, -96(%rdx)
	vmovups	%ymm0, -32(%rdx)
	vmovups	%ymm7, -64(%rdx)
	cmpq	%r11, %rdx
	jne	.L589
	movq	%rax, %rdx
	andq	$-32, %rdx
	addq	%rdx, %rcx
	cmpq	%rax, %rdx
	je	.L701
	vzeroupper
.L588:
	subq	%rdx, %rax
	leaq	-1(%rax), %rsi
	cmpq	$14, %rsi
	jbe	.L593
	addq	%r10, %rdx
	vbroadcastss	.LC3(%rip), %xmm8
	vbroadcastss	%xmm2, %xmm7
	vbroadcastss	%xmm1, %xmm5
	vmovdqu8	(%r9,%rdx), %xmm0
	leaq	(%r8,%rdx,4), %rsi
	movq	%rax, %rdx
	andq	$-16, %rdx
	vpmovzxbw	%xmm0, %xmm3
	vpsrldq	$8, %xmm0, %xmm0
	addq	%rdx, %rcx
	vpsrldq	$8, %xmm3, %xmm4
	vpmovsxwd	%xmm3, %xmm3
	vpmovzxbw	%xmm0, %xmm0
	vcvtdq2ps	%xmm3, %xmm3
	vfmsub132ps	%xmm8, %xmm7, %xmm3
	vpmovsxwd	%xmm4, %xmm4
	vpmovsxwd	%xmm0, %xmm6
	vcvtdq2ps	%xmm4, %xmm4
	vfmsub132ps	%xmm8, %xmm7, %xmm4
	vpsrldq	$8, %xmm0, %xmm0
	vcvtdq2ps	%xmm6, %xmm6
	vpmovsxwd	%xmm0, %xmm0
	vfmsub132ps	%xmm8, %xmm7, %xmm6
	vcvtdq2ps	%xmm0, %xmm0
	vfmsub132ps	%xmm8, %xmm7, %xmm0
	vmulps	%xmm3, %xmm5, %xmm3
	vmovups	%xmm3, (%rsi)
	vmulps	%xmm4, %xmm5, %xmm3
	vmovups	%xmm3, 16(%rsi)
	vmulps	%xmm6, %xmm5, %xmm3
	vmulps	%xmm0, %xmm5, %xmm5
	vmovups	%xmm3, 32(%rsi)
	vmovups	%xmm5, 48(%rsi)
	testb	$15, %al
	je	.L591
.L593:
	movzbl	(%r9,%rcx), %eax
	vxorps	%xmm0, %xmm0, %xmm0
	vmovss	.LC3(%rip), %xmm4
	leaq	1(%rcx), %rdx
	vcvtusi2ssl	%eax, %xmm0, %xmm3
	leaq	0(,%rcx,4), %rax
	vfmsub132ss	%xmm4, %xmm2, %xmm3
	vmulss	%xmm3, %xmm1, %xmm3
	vmovss	%xmm3, (%r8,%rcx,4)
	cmpq	%rdx, %rdi
	jle	.L591
	movzbl	1(%r9,%rcx), %edx
	vcvtusi2ssl	%edx, %xmm0, %xmm3
	leaq	2(%rcx), %rdx
	vfmsub132ss	%xmm4, %xmm2, %xmm3
	vmulss	%xmm3, %xmm1, %xmm3
	vmovss	%xmm3, 4(%r8,%rax)
	cmpq	%rdi, %rdx
	jge	.L591
	movzbl	2(%r9,%rcx), %edx
	vcvtusi2ssl	%edx, %xmm0, %xmm3
	leaq	3(%rcx), %rdx
	vfmsub132ss	%xmm4, %xmm2, %xmm3
	vmulss	%xmm1, %xmm3, %xmm3
	vmovss	%xmm3, 8(%r8,%rax)
	cmpq	%rdx, %rdi
	jle	.L591
	movzbl	3(%r9,%rcx), %edx
	vcvtusi2ssl	%edx, %xmm0, %xmm3
	leaq	4(%rcx), %rdx
	vfmsub132ss	%xmm4, %xmm2, %xmm3
	vmulss	%xmm3, %xmm1, %xmm3
	vmovss	%xmm3, 12(%r8,%rax)
	cmpq	%rdx, %rdi
	jle	.L591
	movzbl	4(%r9,%rcx), %edx
	vcvtusi2ssl	%edx, %xmm0, %xmm3
	leaq	5(%rcx), %rdx
	vfmsub132ss	%xmm4, %xmm2, %xmm3
	vmulss	%xmm3, %xmm1, %xmm3
	vmovss	%xmm3, 16(%r8,%rax)
	cmpq	%rdx, %rdi
	jle	.L591
	movzbl	5(%r9,%rcx), %edx
	vcvtusi2ssl	%edx, %xmm0, %xmm3
	leaq	6(%rcx), %rdx
	vfmsub132ss	%xmm4, %xmm2, %xmm3
	vmulss	%xmm3, %xmm1, %xmm3
	vmovss	%xmm3, 20(%r8,%rax)
	cmpq	%rdx, %rdi
	jle	.L591
	movzbl	6(%r9,%rcx), %edx
	vcvtusi2ssl	%edx, %xmm0, %xmm3
	leaq	7(%rcx), %rdx
	vfmsub132ss	%xmm4, %xmm2, %xmm3
	vmulss	%xmm3, %xmm1, %xmm3
	vmovss	%xmm3, 24(%r8,%rax)
	cmpq	%rdx, %rdi
	jle	.L591
	movzbl	7(%r9,%rcx), %edx
	vcvtusi2ssl	%edx, %xmm0, %xmm3
	leaq	8(%rcx), %rdx
	vfmsub132ss	%xmm4, %xmm2, %xmm3
	vmulss	%xmm3, %xmm1, %xmm3
	vmovss	%xmm3, 28(%r8,%rax)
	cmpq	%rdx, %rdi
	jle	.L591
	movzbl	8(%r9,%rcx), %edx
	vcvtusi2ssl	%edx, %xmm0, %xmm3
	leaq	9(%rcx), %rdx
	vfmsub132ss	%xmm4, %xmm2, %xmm3
	vmulss	%xmm3, %xmm1, %xmm3
	vmovss	%xmm3, 32(%r8,%rax)
	cmpq	%rdx, %rdi
	jle	.L591
	movzbl	9(%r9,%rcx), %edx
	vcvtusi2ssl	%edx, %xmm0, %xmm3
	leaq	10(%rcx), %rdx
	vfmsub132ss	%xmm4, %xmm2, %xmm3
	vmulss	%xmm3, %xmm1, %xmm3
	vmovss	%xmm3, 36(%r8,%rax)
	cmpq	%rdx, %rdi
	jle	.L591
	movzbl	10(%r9,%rcx), %edx
	vcvtusi2ssl	%edx, %xmm0, %xmm3
	leaq	11(%rcx), %rdx
	vfmsub132ss	%xmm4, %xmm2, %xmm3
	vmulss	%xmm3, %xmm1, %xmm3
	vmovss	%xmm3, 40(%r8,%rax)
	cmpq	%rdx, %rdi
	jle	.L591
	movzbl	11(%r9,%rcx), %edx
	vcvtusi2ssl	%edx, %xmm0, %xmm3
	leaq	12(%rcx), %rdx
	vfmsub132ss	%xmm4, %xmm2, %xmm3
	vmulss	%xmm3, %xmm1, %xmm3
	vmovss	%xmm3, 44(%r8,%rax)
	cmpq	%rdx, %rdi
	jle	.L591
	movzbl	12(%r9,%rcx), %edx
	vcvtusi2ssl	%edx, %xmm0, %xmm3
	leaq	13(%rcx), %rdx
	vfmsub132ss	%xmm4, %xmm2, %xmm3
	vmulss	%xmm3, %xmm1, %xmm3
	vmovss	%xmm3, 48(%r8,%rax)
	cmpq	%rdx, %rdi
	jle	.L591
	movzbl	13(%r9,%rcx), %edx
	vcvtusi2ssl	%edx, %xmm0, %xmm3
	leaq	14(%rcx), %rdx
	vfmsub132ss	%xmm4, %xmm2, %xmm3
	vmulss	%xmm3, %xmm1, %xmm3
	vmovss	%xmm3, 52(%r8,%rax)
	cmpq	%rdx, %rdi
	jle	.L591
	movzbl	14(%r9,%rcx), %edx
	vcvtusi2ssl	%edx, %xmm0, %xmm0
	vfmsub132ss	%xmm4, %xmm2, %xmm0
	vmulss	%xmm0, %xmm1, %xmm1
	vmovss	%xmm1, 56(%r8,%rax)
	.p2align 4,,10
	.p2align 3
.L591:
	call	GOMP_barrier@PLT
	movl	84(%rsp), %esi
	testl	%esi, %esi
	je	.L702
.L587:
	movq	64(%rsp), %rax
	movl	_ZN12_GLOBAL__N_18g_kernelE(%rip), %edx
	movq	88+_ZN12_GLOBAL__N_11HE(%rip), %rcx
	movq	80+_ZN12_GLOBAL__N_11HE(%rip), %r15
	movq	16(%rax), %r13
	movq	72+_ZN12_GLOBAL__N_11HE(%rip), %rdi
	movq	8(%r13), %r8
	movq	0(%r13), %rsi
	movq	%r8, %rax
	subq	%rsi, %rax
	sarq	$5, %rax
	cmpq	%r8, %rsi
	je	.L662
	xorl	%r12d, %r12d
	movl	%edx, 88(%rsp)
	movq	%r12, %r14
	movq	%rcx, 56(%rsp)
	movq	%r15, %r12
	jmp	.L598
	.p2align 4,,10
	.p2align 3
.L596:
	cmpq	%rax, %r14
	jnb	.L693
	movq	%r15, %rcx
.L597:
	movq	%r12, %rdi
	movq	%rcx, %r12
.L598:
	incq	%r14
	movl	88(%rsp), %r9d
	movl	%ebx, %ecx
	movq	%r12, %rdx
	cmpq	%r14, %rax
	movq	%r14, %rax
	setne	%r8b
	salq	$5, %rax
	leaq	-32(%rsi,%rax), %rsi
	movzbl	%r8b, %r8d
	call	_ZN12_GLOBAL__N_120dense_layer_inregionEPKfRKNS_5LayerEPfibi
	movq	0(%r13), %rsi
	movq	8(%r13), %rax
	subq	%rsi, %rax
	sarq	$5, %rax
	cmpq	%r12, %r15
	jne	.L596
	cmpq	%rax, %r14
	jnb	.L693
	movq	56(%rsp), %rcx
	jmp	.L597
	.p2align 4,,10
	.p2align 3
.L693:
	movq	%r12, %r14
.L595:
	movl	%ebx, %eax
	cltd
	idivl	80(%rsp)
	movl	%eax, %r12d
	movl	84(%rsp), %eax
	cmpl	%eax, %edx
	jg	.L599
.L659:
	movl	84(%rsp), %r13d
	imull	%r12d, %r13d
	addl	%edx, %r13d
	leal	(%r12,%r13), %r15d
	cmpl	%r15d, %r13d
	jge	.L608
	movslq	52(%rsp), %r8
	movslq	%r13d, %rdx
	movq	104+_ZN12_GLOBAL__N_11HE(%rip), %rsi
	movl	%r12d, %eax
	addq	%rdx, %rax
	movq	%r8, %r11
	salq	$2, %r8
	leaq	(%rsi,%rdx,4), %rdi
	leaq	(%rsi,%rax,4), %r9
	movq	%r8, %rcx
	movl	%r11d, %esi
	movl	%r11d, %r10d
	imulq	%rdx, %rcx
	addq	%r14, %rcx
	.p2align 4,,10
	.p2align 3
.L607:
	cmpl	$1, %r10d
	jle	.L664
	vmovss	(%rcx), %xmm0
	movl	$1, %eax
	xorl	%edx, %edx
	.p2align 4,,10
	.p2align 3
.L606:
	vmovss	(%rcx,%rax,4), %xmm1
	vcomiss	%xmm0, %xmm1
	vmaxss	%xmm0, %xmm1, %xmm0
	cmova	%eax, %edx
	incq	%rax
	cmpq	%rax, %rsi
	jne	.L606
	movl	%edx, (%rdi)
	addq	$4, %rdi
	addq	%r8, %rcx
	cmpq	%r9, %rdi
	jne	.L607
.L608:
	call	GOMP_barrier@PLT
	call	GOMP_single_start@PLT
	testb	%al, %al
	jne	.L703
	call	GOMP_barrier@PLT
	testl	%ebx, %ebx
	jg	.L609
.L652:
	cmpl	%r15d, %r13d
	jl	.L636
.L639:
	call	GOMP_barrier@PLT
	movq	96+_ZN12_GLOBAL__N_11HE(%rip), %rax
	movl	84(%rsp), %ecx
	movq	%rax, 24(%rsp)
	testl	%ecx, %ecx
	je	.L704
.L612:
	movl	72(%rsp), %edx
	testl	%edx, %edx
	jle	.L696
.L635:
	movslq	72(%rsp), %rax
	movq	$0, 72(%rsp)
	xorl	%r14d, %r14d
	salq	$2, %rax
	movq	%rax, 56(%rsp)
	.p2align 4,,10
	.p2align 3
.L614:
	movq	152+_ZN12_GLOBAL__N_11HE(%rip), %rax
	movl	(%rax,%r14), %r15d
	testl	%r15d, %r15d
	je	.L623
	movq	176+_ZN12_GLOBAL__N_11HE(%rip), %rax
	movslq	(%rax,%r14), %r11
	movq	8+_ZN12_GLOBAL__N_11HE(%rip), %rax
	movl	(%rax,%r14), %eax
	testl	%eax, %eax
	js	.L616
	movslq	%eax, %r13
	imulq	$3136, %r11, %rdi
	movq	24(%rsp), %rcx
	movl	_ZN12_GLOBAL__N_18g_kernelE(%rip), %r9d
	salq	$5, %r13
	movq	88+_ZN12_GLOBAL__N_11HE(%rip), %r10
	movq	80+_ZN12_GLOBAL__N_11HE(%rip), %rax
	addq	_ZN12_GLOBAL__N_18g_modelsE(%rip), %r13
	movq	8(%r13), %rbx
	movq	0(%r13), %rsi
	addq	%rcx, %rdi
	movq	%rbx, %rdx
	movl	-28(%rbx), %r8d
	subq	%rsi, %rdx
	sarq	$5, %rdx
	cmpq	%rsi, %rbx
	je	.L665
	xorl	%ebx, %ebx
	movq	%r14, 32(%rsp)
	movq	%rax, %r12
	movq	%r13, %r14
	movl	%r8d, 52(%rsp)
	movq	%rbx, %r13
	movq	%rax, %rbx
	movl	%r9d, 88(%rsp)
	movq	%r10, 64(%rsp)
	movq	%r11, 40(%rsp)
	jmp	.L620
	.p2align 4,,10
	.p2align 3
.L618:
	cmpq	%rdx, %r13
	jnb	.L694
	movq	%rbx, %rcx
.L619:
	movq	%r12, %rdi
	movq	%rcx, %r12
.L620:
	incq	%r13
	movl	88(%rsp), %r9d
	movl	%r15d, %ecx
	cmpq	%rdx, %r13
	movq	%r13, %rdx
	setne	%r8b
	salq	$5, %rdx
	leaq	-32(%rsi,%rdx), %rsi
	movzbl	%r8b, %r8d
	movq	%r12, %rdx
	call	_ZN12_GLOBAL__N_120dense_layer_inregionEPKfRKNS_5LayerEPfibi
	movq	(%r14), %rsi
	movq	8(%r14), %rdx
	subq	%rsi, %rdx
	sarq	$5, %rdx
	cmpq	%r12, %rbx
	jne	.L618
	cmpq	%rdx, %r13
	jnb	.L694
	movq	64(%rsp), %rcx
	jmp	.L619
.L703:
	call	_ZNSt6chrono3_V212steady_clock3nowEv@PLT
	movq	64(%rsp), %rcx
	movq	160+_ZN12_GLOBAL__N_11HE(%rip), %rdx
	movq	%rax, 32(%rcx)
	movq	152+_ZN12_GLOBAL__N_11HE(%rip), %rcx
	cmpq	%rdx, %rcx
	je	.L644
	subq	%rcx, %rdx
	movq	%rcx, %rdi
	xorl	%esi, %esi
	call	memset@PLT
	movq	%rax, %rcx
.L644:
	testl	%ebx, %ebx
	jle	.L643
	movq	104+_ZN12_GLOBAL__N_11HE(%rip), %rax
	movq	40(%rsp), %rdi
	leaq	(%rax,%rdi,4), %rsi
	.p2align 4,,10
	.p2align 3
.L658:
	movslq	(%rax), %rdx
	addq	$4, %rax
	incl	(%rcx,%rdx,4)
	cmpq	%rsi, %rax
	jne	.L658
.L643:
	movq	176+_ZN12_GLOBAL__N_11HE(%rip), %r14
	movl	72(%rsp), %eax
	movl	$0, (%r14)
	testl	%eax, %eax
	jle	.L657
	movslq	72(%rsp), %rdi
	xorl	%eax, %eax
	xorl	%edx, %edx
	salq	$2, %rdi
	.p2align 4,,10
	.p2align 3
.L656:
	addl	(%rcx,%rax), %edx
	movl	%edx, 4(%r14,%rax)
	addq	$4, %rax
	cmpq	%rax, %rdi
	jne	.L656
.L657:
	movq	184+_ZN12_GLOBAL__N_11HE(%rip), %rax
	leaq	-4(%rax), %rcx
	movabsq	$9223372036854775804, %rax
	subq	%r14, %rcx
	cmpq	%rcx, %rax
	jb	.L705
	testq	%rcx, %rcx
	je	.L647
	movq	%rcx, %rdi
	movq	%rcx, 88(%rsp)
	call	_Znwm@PLT
	movq	88(%rsp), %rcx
	movq	%rax, %rdi
	cmpq	$4, %rcx
	jle	.L648
	movq	%rcx, %rdx
	movq	%r14, %rsi
	call	memmove@PLT
	movq	88(%rsp), %rcx
	movq	%rax, %rdi
.L649:
	testl	%ebx, %ebx
	jle	.L706
.L650:
	movq	104+_ZN12_GLOBAL__N_11HE(%rip), %r9
	movq	128+_ZN12_GLOBAL__N_11HE(%rip), %r8
	xorl	%eax, %eax
	.p2align 4,,10
	.p2align 3
.L654:
	movslq	(%r9,%rax,4), %rdx
	leaq	(%rdi,%rdx,4), %rsi
	movslq	(%rsi), %rdx
	leal	1(%rdx), %r10d
	movl	%r10d, (%rsi)
	movl	%eax, (%r8,%rdx,4)
	incq	%rax
	cmpl	%eax, %ebx
	jg	.L654
	testq	%rdi, %rdi
	je	.L653
	movq	%rcx, %rsi
	call	_ZdlPvm@PLT
.L653:
	call	GOMP_barrier@PLT
.L609:
	movq	104+_ZN12_GLOBAL__N_11HE(%rip), %rax
	movslq	(%rax), %rdx
	movq	152+_ZN12_GLOBAL__N_11HE(%rip), %rax
	cmpl	(%rax,%rdx,4), %ebx
	jne	.L652
	movq	72+_ZN12_GLOBAL__N_11HE(%rip), %rax
	movl	84(%rsp), %ecx
	movq	%rax, 24(%rsp)
	testl	%ecx, %ecx
	jne	.L612
.L704:
	call	_ZNSt6chrono3_V212steady_clock3nowEv@PLT
	movq	64(%rsp), %rbx
	movl	72(%rsp), %edx
	subq	32(%rbx), %rax
	movq	%rax, 40(%rbx)
	testl	%edx, %edx
	jg	.L635
.L696:
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
	.p2align 4,,10
	.p2align 3
.L694:
	.cfi_restore_state
	movl	52(%rsp), %r8d
	movq	40(%rsp), %r11
	movq	32(%rsp), %r14
.L617:
	movl	%r15d, %eax
	movl	84(%rsp), %ebx
	cltd
	idivl	80(%rsp)
	cmpl	%ebx, %edx
	jg	.L621
.L631:
	movl	84(%rsp), %esi
	imull	%eax, %esi
	addl	%esi, %edx
	leal	(%rax,%rdx), %esi
	cmpl	%esi, %edx
	jl	.L622
.L630:
	call	GOMP_barrier@PLT
.L623:
	addq	$4, %r14
	addq	$24, 72(%rsp)
	cmpq	%r14, 56(%rsp)
	jne	.L614
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
	.p2align 4,,10
	.p2align 3
.L616:
	.cfi_restore_state
	movl	%r15d, %eax
	movl	84(%rsp), %ebx
	cltd
	idivl	80(%rsp)
	cmpl	%ebx, %edx
	jg	.L632
.L634:
	movl	84(%rsp), %esi
	imull	%eax, %esi
	addl	%esi, %edx
	leal	(%rax,%rdx), %esi
	cmpl	%esi, %edx
	jge	.L630
	movq	32+_ZN12_GLOBAL__N_11HE(%rip), %rsi
	movq	72(%rsp), %rbx
	movslq	%edx, %rdx
	movl	%eax, %eax
	movq	128+_ZN12_GLOBAL__N_11HE(%rip), %r8
	movq	(%rsi,%rbx), %rdi
	leaq	(%r11,%rdx), %rsi
	leaq	(%r8,%rsi,4), %rdx
	addq	%rsi, %rax
	movq	16(%rsp), %rsi
	leaq	(%r8,%rax,4), %r8
	.p2align 4,,10
	.p2align 3
.L633:
	movslq	(%rdx), %rax
	movl	(%rdi), %ecx
	addq	$4, %rdx
	movl	%ecx, (%rsi,%rax,4)
	cmpq	%r8, %rdx
	jne	.L633
	jmp	.L630
	.p2align 4,,10
	.p2align 3
.L622:
	movq	32+_ZN12_GLOBAL__N_11HE(%rip), %rsi
	movq	72(%rsp), %rbx
	movl	%eax, %eax
	movl	%r8d, %r9d
	movq	128+_ZN12_GLOBAL__N_11HE(%rip), %rdi
	movq	16(%rsp), %rcx
	movq	(%rsi,%rbx), %rbx
	movslq	%edx, %rsi
	leaq	(%r11,%rsi), %rdx
	movslq	%r8d, %r11
	salq	$2, %r11
	addq	%rdx, %rax
	leaq	(%rdi,%rdx,4), %r10
	imulq	%r11, %rsi
	addq	%r12, %rsi
	leaq	(%rdi,%rax,4), %r12
	cmpl	$1, %r8d
	jle	.L667
	.p2align 4,,10
	.p2align 3
.L709:
	vmovss	(%rsi), %xmm1
	movl	$1, %eax
	xorl	%edi, %edi
	jmp	.L628
	.p2align 4,,10
	.p2align 3
.L708:
	movl	%eax, %edi
	leaq	0(,%rax,4), %rdx
	vmovaps	%xmm0, %xmm1
	incq	%rax
	cmpq	%rax, %r9
	je	.L707
.L628:
	vmovss	(%rsi,%rax,4), %xmm0
	vcomiss	%xmm1, %xmm0
	ja	.L708
	movslq	%edi, %rdx
	incq	%rax
	salq	$2, %rdx
	cmpq	%rax, %r9
	jne	.L628
.L707:
	addq	%rbx, %rdx
.L624:
	movslq	(%r10), %rax
	movl	(%rdx), %edx
	addq	$4, %r10
	addq	%r11, %rsi
	movl	%edx, (%rcx,%rax,4)
	cmpq	%r10, %r12
	je	.L630
	cmpl	$1, %r8d
	jg	.L709
.L667:
	movq	%rbx, %rdx
	jmp	.L624
	.p2align 4,,10
	.p2align 3
.L621:
	incl	%eax
	xorl	%edx, %edx
	jmp	.L631
.L632:
	incl	%eax
	xorl	%edx, %edx
	jmp	.L634
.L664:
	xorl	%edx, %edx
	addq	$4, %rdi
	addq	%r8, %rcx
	movl	%edx, -4(%rdi)
	cmpq	%r9, %rdi
	jne	.L607
	jmp	.L608
.L636:
	movslq	%r13d, %r13
	movl	%r12d, %ebx
	addq	%r13, %rbx
	leaq	0(,%r13,4), %r15
	salq	$2, %rbx
	.p2align 4,,10
	.p2align 3
.L638:
	movq	128+_ZN12_GLOBAL__N_11HE(%rip), %rax
	imulq	$784, %r15, %rdi
	movl	$3136, %edx
	movslq	(%rax,%r15), %rsi
	addq	$4, %r15
	addq	96+_ZN12_GLOBAL__N_11HE(%rip), %rdi
	imulq	$3136, %rsi, %rsi
	addq	72+_ZN12_GLOBAL__N_11HE(%rip), %rsi
	call	memcpy@PLT
	cmpq	%r15, %rbx
	jne	.L638
	jmp	.L639
.L665:
	movq	%rdi, %r12
	jmp	.L617
.L702:
	call	_ZNSt6chrono3_V212steady_clock3nowEv@PLT
	movq	64(%rsp), %rcx
	movq	%rax, 24(%rcx)
	jmp	.L587
.L700:
	incq	%rax
	xorl	%edx, %edx
	jmp	.L584
.L599:
	incl	%r12d
	xorl	%edx, %edx
	jmp	.L659
.L647:
	xorl	%edi, %edi
	testl	%ebx, %ebx
	jg	.L650
.L698:
	call	GOMP_barrier@PLT
	jmp	.L652
.L661:
	xorl	%edx, %edx
	jmp	.L588
.L662:
	movq	%rdi, %r14
	jmp	.L595
.L706:
	movq	%rcx, %rsi
	call	_ZdlPvm@PLT
	jmp	.L698
.L648:
	movl	(%r14), %eax
	movl	%eax, (%rdi)
	jmp	.L649
.L701:
	vzeroupper
	jmp	.L591
.L705:
	leaq	.LC5(%rip), %rdi
	call	_ZSt20__throw_length_errorPKc@PLT
	.cfi_endproc
.LFE8942:
	.globl	__gxx_personality_v0
	.section	.gcc_except_table,"a",@progbits
.LLSDA8942:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8942-.LLSDACSB8942
.LLSDACSB8942:
.LLSDACSE8942:
	.text
	.size	pfi_hier_predict._omp_fn.0, .-pfi_hier_predict._omp_fn.0
	.p2align 4
	.globl	pfi_set_threads
	.type	pfi_set_threads, @function
pfi_set_threads:
.LFB8343:
	.cfi_startproc
	endbr64
	jmp	omp_set_num_threads@PLT
	.cfi_endproc
.LFE8343:
	.size	pfi_set_threads, .-pfi_set_threads
	.p2align 4
	.globl	pfi_get_threads
	.type	pfi_get_threads, @function
pfi_get_threads:
.LFB8344:
	.cfi_startproc
	endbr64
	jmp	omp_get_max_threads@PLT
	.cfi_endproc
.LFE8344:
	.size	pfi_get_threads, .-pfi_get_threads
	.p2align 4
	.globl	pfi_set_kernel
	.type	pfi_set_kernel, @function
pfi_set_kernel:
.LFB8345:
	.cfi_startproc
	endbr64
	movl	%edi, _ZN12_GLOBAL__N_18g_kernelE(%rip)
	ret
	.cfi_endproc
.LFE8345:
	.size	pfi_set_kernel, .-pfi_set_kernel
	.p2align 4
	.globl	pfi_has_avx512
	.type	pfi_has_avx512, @function
pfi_has_avx512:
.LFB8346:
	.cfi_startproc
	endbr64
	movl	$1, %eax
	ret
	.cfi_endproc
.LFE8346:
	.size	pfi_has_avx512, .-pfi_has_avx512
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC6:
	.string	"rb"
.LC7:
	.string	"vector::_M_realloc_insert"
	.section	.text.unlikely,"ax",@progbits
.LCOLDB8:
	.text
.LHOTB8:
	.p2align 4
	.globl	pfi_load_model
	.type	pfi_load_model, @function
pfi_load_model:
.LFB8347:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA8347
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	movq	%rsi, %r12
	leaq	.LC6(%rip), %rsi
	pushq	%rbx
	.cfi_offset 3, -56
	movl	%edx, %ebx
	subq	$152, %rsp
	movq	%fs:40, %rax
	movq	%rax, 136(%rsp)
	xorl	%eax, %eax
.LEHB0:
	call	fopen@PLT
.LEHE0:
	movq	%rax, 24(%rsp)
	testq	%rax, %rax
	je	.L768
	vpxor	%xmm0, %xmm0, %xmm0
	movq	$0, 112(%rsp)
	movl	$0, 120(%rsp)
	vmovdqa	%xmm0, 96(%rsp)
	cmpl	$1, %ebx
	jle	.L769
	leal	-2(%rbx), %eax
	movq	%r12, 88(%rsp)
	leaq	4(%r12,%rax,4), %rax
	movq	$0, 16(%rsp)
	movq	%rax, (%rsp)
	.p2align 4,,10
	.p2align 3
.L737:
	movq	88(%rsp), %rax
	movl	$64, %ebx
	movl	(%rax), %edi
	movslq	4(%rax), %r14
	movslq	%edi, %rax
	movl	%edi, 36(%rsp)
	movq	%rax, %rdi
	movl	%r14d, 64(%rsp)
	imulq	%r14, %rdi
	movq	%rax, 8(%rsp)
	leaq	63(,%rdi,4), %r13
	movq	%rdi, 48(%rsp)
	movl	$64, %edi
	andq	$-64, %r13
	cmove	%rbx, %r13
	leaq	0(,%r14,4), %rbx
	leaq	63(%rbx), %r15
	movq	%r13, %rsi
	call	aligned_alloc@PLT
	movq	%r13, %rcx
	movq	%r13, %rdx
	xorl	%esi, %esi
	movq	%rax, %rdi
	movq	%rax, 40(%rsp)
	call	__memset_chk@PLT
	movq	%r13, %rsi
	movl	$64, %edi
	call	aligned_alloc@PLT
	movq	%r13, %rdx
	movq	%r13, %rcx
	xorl	%esi, %esi
	movq	%rax, %rdi
	movq	%rax, %r12
	call	__memset_chk@PLT
	andq	$-64, %r15
	movl	$64, %ecx
	movl	$64, %edi
	cmove	%rcx, %r15
	movq	%r15, %rsi
	call	aligned_alloc@PLT
	movq	%r15, %rcx
	movq	%r15, %rdx
	xorl	%esi, %esi
	movq	%rax, %rdi
	movq	%rax, 80(%rsp)
	call	__memset_chk@PLT
	movq	%r13, %rsi
	movq	40(%rsp), %r13
	movq	24(%rsp), %r8
	movq	48(%rsp), %rcx
	movl	$4, %edx
	movq	%r13, %rdi
.LEHB1:
	call	__fread_chk@PLT
	cmpq	%rax, 48(%rsp)
	jne	.L719
	movq	24(%rsp), %r8
	movq	80(%rsp), %rdi
	movq	%r14, %rcx
	movl	$4, %edx
	movq	%r15, %rsi
	call	__fread_chk@PLT
	cmpq	%rax, %r14
	jne	.L719
	movl	64(%rsp), %edx
	testl	%edx, %edx
	jle	.L720
	movl	36(%rsp), %eax
	testl	%eax, %eax
	jle	.L720
	movq	8(%rsp), %rax
	xorl	%esi, %esi
	salq	$2, %rax
	movq	%rax, %rdi
	leaq	0(%r13,%rax), %rcx
	.p2align 4,,10
	.p2align 3
.L722:
	movq	%rcx, %rax
	leaq	(%r12,%rsi,4), %rdx
	subq	%rdi, %rax
	.p2align 4,,10
	.p2align 3
.L723:
	vmovss	(%rax), %xmm0
	addq	$4, %rax
	vmovss	%xmm0, (%rdx)
	addq	%rbx, %rdx
	cmpq	%rcx, %rax
	jne	.L723
	incq	%rsi
	addq	%rdi, %rcx
	cmpq	%rsi, %r14
	jne	.L722
.L720:
	movq	104(%rsp), %rbx
	movq	16(%rsp), %rax
	cmpq	%rax, %rbx
	je	.L724
	vmovd	36(%rsp), %xmm1
	vmovq	40(%rsp), %xmm2
	addq	$32, %rbx
	movq	80(%rsp), %rax
	vpinsrd	$1, 64(%rsp), %xmm1, %xmm0
	movq	%rax, -8(%rbx)
	vmovq	%xmm0, -32(%rbx)
	vpinsrq	$1, %r12, %xmm2, %xmm0
	vmovdqu	%xmm0, -24(%rbx)
	movq	%rbx, 104(%rsp)
.L725:
	movl	120(%rsp), %r12d
	movl	64(%rsp), %eax
	cmpl	%r12d, %eax
	cmovge	%eax, %r12d
	addq	$4, 88(%rsp)
	movl	%r12d, 120(%rsp)
	movq	88(%rsp), %rax
	cmpq	%rax, (%rsp)
	jne	.L737
.L716:
	movq	24(%rsp), %rdi
	call	fclose@PLT
	movq	8+_ZN12_GLOBAL__N_18g_modelsE(%rip), %r13
	cmpq	16+_ZN12_GLOBAL__N_18g_modelsE(%rip), %r13
	je	.L739
	movq	96(%rsp), %r14
	vpxor	%xmm0, %xmm0, %xmm0
	movq	%rbx, %r15
	movq	$0, 16(%r13)
	vmovdqu	%xmm0, 0(%r13)
	subq	%r14, %r15
	je	.L774
	movabsq	$9223372036854775776, %rax
	cmpq	%r15, %rax
	jb	.L803
	movq	%r15, %rdi
	call	_Znwm@PLT
	movq	8+_ZN12_GLOBAL__N_18g_modelsE(%rip), %r8
	movq	%rax, %rcx
	jmp	.L740
	.p2align 4,,10
	.p2align 3
.L724:
	movq	96(%rsp), %r13
	movq	%rax, %r14
	movabsq	$288230376151711743, %rdi
	subq	%r13, %r14
	movq	%r14, %rax
	sarq	$5, %rax
	cmpq	%rdi, %rax
	je	.L804
	movq	16(%rsp), %rdi
	cmpq	%rdi, %r13
	je	.L805
	leaq	(%rax,%rax), %rdx
	cmpq	%rax, %rdx
	jb	.L773
	testq	%rdx, %rdx
	jne	.L806
	vmovd	36(%rsp), %xmm7
	movq	80(%rsp), %rax
	xorl	%r15d, %r15d
	xorl	%esi, %esi
	vmovq	40(%rsp), %xmm4
	vpinsrd	$1, 64(%rsp), %xmm7, %xmm0
	movq	%rax, 24(%r14)
	vmovq	%xmm0, (%r14)
	vpinsrq	$1, %r12, %xmm4, %xmm0
	vmovdqu	%xmm0, 8(%r14)
.L733:
	movq	16(%rsp), %rcx
	movq	%r13, %rdx
	movq	%rsi, %rax
	subq	%r13, %rcx
	addq	%rsi, %rcx
	.p2align 4,,10
	.p2align 3
.L735:
	vmovdqu	(%rdx), %ymm5
	addq	$32, %rax
	addq	$32, %rdx
	vmovdqu	%ymm5, -32(%rax)
	cmpq	%rcx, %rax
	jne	.L735
	movq	%r15, 16(%rsp)
	leaq	32(%rax), %rbx
	vzeroupper
.L734:
	vmovq	%rsi, %xmm3
	vpinsrq	$1, %rbx, %xmm3, %xmm0
	testq	%r13, %r13
	je	.L736
	movq	%r14, %rsi
	movq	%r13, %rdi
	vmovdqa	%xmm0, 48(%rsp)
	call	_ZdlPvm@PLT
	vmovdqa	48(%rsp), %xmm0
.L736:
	movq	%r15, 112(%rsp)
	vmovdqa	%xmm0, 96(%rsp)
	jmp	.L725
.L719:
	movq	96(%rsp), %r14
	movl	$-2, %ebx
.L738:
	testq	%r14, %r14
	je	.L714
	movq	16(%rsp), %rsi
	movq	%r14, %rdi
	subq	%r14, %rsi
	call	_ZdlPvm@PLT
.L714:
	movq	136(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L801
	addq	$152, %rsp
	movl	%ebx, %eax
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
.L805:
	.cfi_restore_state
	addq	$1, %rax
	jc	.L773
	movabsq	$288230376151711743, %rdx
	cmpq	%rdx, %rax
	cmova	%rdx, %rax
	salq	$5, %rax
	movq	%rax, %r15
.L731:
	movq	%r15, %rdi
	call	_Znwm@PLT
.LEHE1:
	vmovd	36(%rsp), %xmm4
	vmovq	40(%rsp), %xmm5
	movq	%rax, %rsi
	addq	%rax, %r15
	movq	80(%rsp), %rdi
	leaq	(%rax,%r14), %rax
	vpinsrd	$1, 64(%rsp), %xmm4, %xmm0
	movq	%rdi, 24(%rax)
	vmovq	%xmm0, (%rax)
	vpinsrq	$1, %r12, %xmm5, %xmm0
	vmovdqu	%xmm0, 8(%rax)
	movq	16(%rsp), %rax
	cmpq	%rax, %r13
	jne	.L733
	movq	%r15, 16(%rsp)
	leaq	32(%rsi), %rbx
	jmp	.L734
.L773:
	movabsq	$9223372036854775776, %r15
	jmp	.L731
.L774:
	movq	%r13, %r8
	xorl	%ecx, %ecx
.L740:
	addq	%rcx, %r15
	movq	%rcx, 0(%r13)
	movq	%r15, 16(%r13)
	cmpq	%rbx, %r14
	je	.L743
	subq	%r14, %rbx
	movq	%rcx, %rdi
	movq	%r14, %rsi
	movq	%r8, 88(%rsp)
	movq	%rbx, %rdx
	call	memcpy@PLT
	movq	88(%rsp), %r8
	movq	%rax, %rcx
	addq	%rbx, %rcx
.L743:
	movq	_ZN12_GLOBAL__N_18g_modelsE(%rip), %rax
	leaq	32(%r8), %rbx
	movq	%rcx, 8(%r13)
	movl	%r12d, 24(%r13)
	movq	%rbx, 8+_ZN12_GLOBAL__N_18g_modelsE(%rip)
	movq	%rax, 88(%rsp)
.L744:
	subq	%rax, %rbx
	sarq	$5, %rbx
	decl	%ebx
	jmp	.L738
.L739:
	movq	_ZN12_GLOBAL__N_18g_modelsE(%rip), %rax
	movq	%r13, %r14
	movabsq	$288230376151711743, %rdx
	subq	%rax, %r14
	movq	%rax, 48(%rsp)
	movq	%r14, %rax
	sarq	$5, %rax
	cmpq	%rdx, %rax
	je	.L807
	movq	48(%rsp), %rdi
	cmpq	%rdi, %r13
	je	.L808
	leaq	(%rax,%rax), %r15
	cmpq	%rax, %r15
	jb	.L776
	movq	$0, 88(%rsp)
	testq	%r15, %r15
	jne	.L809
.L751:
	movq	88(%rsp), %rax
	movq	%rbx, %rdi
	vpxor	%xmm0, %xmm0, %xmm0
	addq	%r14, %rax
	movq	96(%rsp), %r14
	movq	%rax, 64(%rsp)
	subq	%r14, %rdi
	movq	$0, 16(%rax)
	movq	%rdi, 80(%rsp)
	vmovdqu	%xmm0, (%rax)
	je	.L778
	movabsq	$9223372036854775776, %rax
	cmpq	%rdi, %rax
	jb	.L810
.LEHB2:
	call	_Znwm@PLT
.LEHE2:
	movq	%rax, %rcx
.L752:
	movq	80(%rsp), %rax
	movq	64(%rsp), %rdi
	addq	%rcx, %rax
	movq	%rcx, (%rdi)
	movq	%rax, 16(%rdi)
	cmpq	%rbx, %r14
	je	.L755
	subq	%r14, %rbx
	movq	%rcx, %rdi
	movq	%r14, %rsi
	movq	%rbx, %rdx
	call	memcpy@PLT
	movq	%rax, %rcx
	addq	%rbx, %rcx
.L755:
	movq	64(%rsp), %rax
	movq	48(%rsp), %rdx
	movq	%rcx, 8(%rax)
	movl	%r12d, 24(%rax)
	cmpq	%rdx, %r13
	je	.L779
	movq	88(%rsp), %rax
	movq	%r13, %rbx
	subq	%rdx, %rbx
	addq	%rax, %rbx
.L757:
	movq	16(%rdx), %rcx
	vmovdqu	(%rdx), %xmm6
	addq	$32, %rax
	addq	$32, %rdx
	movq	%rcx, -16(%rax)
	movl	-8(%rdx), %ecx
	vmovdqu	%xmm6, -32(%rax)
	movl	%ecx, -8(%rax)
	cmpq	%rbx, %rax
	jne	.L757
.L756:
	vmovq	88(%rsp), %xmm6
	movq	48(%rsp), %rdi
	addq	$32, %rbx
	vpinsrq	$1, %rbx, %xmm6, %xmm0
	testq	%rdi, %rdi
	je	.L758
	movq	16+_ZN12_GLOBAL__N_18g_modelsE(%rip), %rsi
	vmovdqa	%xmm0, 64(%rsp)
	subq	%rdi, %rsi
	call	_ZdlPvm@PLT
	vmovdqa	64(%rsp), %xmm0
.L758:
	movq	88(%rsp), %rax
	vmovdqa	%xmm0, _ZN12_GLOBAL__N_18g_modelsE(%rip)
	addq	%rax, %r15
	movq	%r15, 16+_ZN12_GLOBAL__N_18g_modelsE(%rip)
	jmp	.L744
.L778:
	xorl	%ecx, %ecx
	jmp	.L752
.L808:
	addq	$1, %rax
	jc	.L776
	movabsq	$288230376151711743, %rdx
	cmpq	%rdx, %rax
	cmova	%rdx, %rax
	salq	$5, %rax
	movq	%rax, %r15
.L750:
	movq	%r15, %rdi
.LEHB3:
	call	_Znwm@PLT
.LEHE3:
	movq	%rax, 88(%rsp)
	jmp	.L751
.L769:
	movq	$0, 16(%rsp)
	xorl	%r12d, %r12d
	xorl	%ebx, %ebx
	jmp	.L716
.L810:
	movq	136(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L801
.LEHB4:
	call	_ZSt28__throw_bad_array_new_lengthv@PLT
.LEHE4:
.L779:
	movq	88(%rsp), %rbx
	jmp	.L756
.L809:
	movabsq	$288230376151711743, %rax
	cmpq	%rax, %r15
	cmovbe	%r15, %rax
	salq	$5, %rax
	movq	%rax, %r15
	jmp	.L750
	.p2align 4,,10
	.p2align 3
.L776:
	movabsq	$9223372036854775776, %r15
	jmp	.L750
.L806:
	movabsq	$288230376151711743, %rax
	cmpq	%rax, %rdx
	cmova	%rax, %rdx
	salq	$5, %rdx
	movq	%rdx, %r15
	jmp	.L731
.L768:
	orl	$-1, %ebx
	jmp	.L714
.L801:
	call	__stack_chk_fail@PLT
.L807:
	movq	136(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L801
	leaq	.LC7(%rip), %rdi
.LEHB5:
	call	_ZSt20__throw_length_errorPKc@PLT
	.p2align 4,,10
	.p2align 3
.L803:
	movq	136(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L801
	call	_ZSt28__throw_bad_array_new_lengthv@PLT
.L804:
	movq	136(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L801
	leaq	.LC7(%rip), %rdi
	call	_ZSt20__throw_length_errorPKc@PLT
.LEHE5:
.L781:
	endbr64
	movq	%rax, %rdi
	jmp	.L759
.L780:
	endbr64
	movq	%rax, %rbx
	vzeroupper
	jmp	.L764
	.section	.gcc_except_table
	.align 4
.LLSDA8347:
	.byte	0xff
	.byte	0x9b
	.uleb128 .LLSDATT8347-.LLSDATTD8347
.LLSDATTD8347:
	.byte	0x1
	.uleb128 .LLSDACSE8347-.LLSDACSB8347
.LLSDACSB8347:
	.uleb128 .LEHB0-.LFB8347
	.uleb128 .LEHE0-.LEHB0
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB1-.LFB8347
	.uleb128 .LEHE1-.LEHB1
	.uleb128 .L780-.LFB8347
	.uleb128 0
	.uleb128 .LEHB2-.LFB8347
	.uleb128 .LEHE2-.LEHB2
	.uleb128 .L781-.LFB8347
	.uleb128 0x1
	.uleb128 .LEHB3-.LFB8347
	.uleb128 .LEHE3-.LEHB3
	.uleb128 .L780-.LFB8347
	.uleb128 0
	.uleb128 .LEHB4-.LFB8347
	.uleb128 .LEHE4-.LEHB4
	.uleb128 .L781-.LFB8347
	.uleb128 0x1
	.uleb128 .LEHB5-.LFB8347
	.uleb128 .LEHE5-.LEHB5
	.uleb128 .L780-.LFB8347
	.uleb128 0
.LLSDACSE8347:
	.byte	0x1
	.byte	0
	.align 4
	.long	0

.LLSDATT8347:
	.text
	.cfi_endproc
	.section	.text.unlikely
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDAC8347
	.type	pfi_load_model.cold, @function
pfi_load_model.cold:
.LFSB8347:
.L759:
	.cfi_def_cfa 6, 16
	.cfi_offset 3, -56
	.cfi_offset 6, -16
	.cfi_offset 12, -48
	.cfi_offset 13, -40
	.cfi_offset 14, -32
	.cfi_offset 15, -24
	vzeroupper
	call	__cxa_begin_catch@PLT
	cmpq	$0, 88(%rsp)
	je	.L811
	movq	88(%rsp), %rdi
	movq	%r15, %rsi
	call	_ZdlPvm@PLT
.L761:
	movq	136(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L802
.LEHB6:
	call	__cxa_rethrow@PLT
.LEHE6:
.L782:
	endbr64
	movq	%rax, %rbx
	vzeroupper
	call	__cxa_end_catch@PLT
.L764:
	leaq	96(%rsp), %rdi
	call	_ZNSt6vectorIN12_GLOBAL__N_15LayerESaIS1_EED1Ev
	movq	136(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L802
	movq	%rbx, %rdi
.LEHB7:
	call	_Unwind_Resume@PLT
.LEHE7:
.L811:
	movq	64(%rsp), %rdi
	call	_ZNSt6vectorIN12_GLOBAL__N_15LayerESaIS1_EED1Ev
	jmp	.L761
.L802:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE8347:
	.section	.gcc_except_table
	.align 4
.LLSDAC8347:
	.byte	0xff
	.byte	0x9b
	.uleb128 .LLSDATTC8347-.LLSDATTDC8347
.LLSDATTDC8347:
	.byte	0x1
	.uleb128 .LLSDACSEC8347-.LLSDACSBC8347
.LLSDACSBC8347:
	.uleb128 .LEHB6-.LCOLDB8
	.uleb128 .LEHE6-.LEHB6
	.uleb128 .L782-.LCOLDB8
	.uleb128 0
	.uleb128 .LEHB7-.LCOLDB8
	.uleb128 .LEHE7-.LEHB7
	.uleb128 0
	.uleb128 0
.LLSDACSEC8347:
	.byte	0x1
	.byte	0
	.align 4
	.long	0

.LLSDATTC8347:
	.section	.text.unlikely
	.text
	.size	pfi_load_model, .-pfi_load_model
	.section	.text.unlikely
	.size	pfi_load_model.cold, .-pfi_load_model.cold
.LCOLDE8:
	.text
.LHOTE8:
	.p2align 4
	.globl	pfi_preprocess
	.type	pfi_preprocess, @function
pfi_preprocess:
.LFB8369:
	.cfi_startproc
	endbr64
	subq	$40, %rsp
	.cfi_def_cfa_offset 48
	vmovq	%rdi, %xmm1
	leaq	pfi_preprocess._omp_fn.0(%rip), %rdi
	xorl	%ecx, %ecx
	movq	%fs:40, %rax
	movq	%rax, 24(%rsp)
	xorl	%eax, %eax
	vpinsrq	$1, %rdx, %xmm1, %xmm0
	movl	%esi, 16(%rsp)
	xorl	%edx, %edx
	movq	%rsp, %rsi
	vmovdqa	%xmm0, (%rsp)
	call	GOMP_parallel@PLT
	movq	24(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L816
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L816:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE8369:
	.size	pfi_preprocess, .-pfi_preprocess
	.p2align 4
	.globl	pfi_bench_dense
	.type	pfi_bench_dense, @function
pfi_bench_dense:
.LFB8378:
	.cfi_startproc
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	movslq	%ecx, %rcx
	salq	$5, %rcx
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	movl	%esi, %r13d
	movq	%rdx, %rsi
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	movslq	%r8d, %rbp
	salq	$5, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$88, %rsp
	.cfi_def_cfa_offset 144
	movslq	152(%rsp), %rax
	addq	_ZN12_GLOBAL__N_18g_modelsE(%rip), %rcx
	movq	%rdx, 8(%rsp)
	movq	160(%rsp), %r10
	addq	(%rcx), %rbp
	movq	%fs:40, %rdx
	movq	%rdx, 72(%rsp)
	xorl	%edx, %edx
	testl	%eax, %eax
	jle	.L817
	movl	%edi, %r14d
	movq	%r9, %r15
	testl	%r13d, %r13d
	je	.L819
	vmovd	%edi, %xmm3
	vmovq	%rsi, %xmm1
	leaq	(%r10,%rax,8), %r15
	movq	%r10, %r12
	vpinsrd	$1, 144(%rsp), %xmm3, %xmm2
	vpinsrq	$1, %r9, %xmm1, %xmm0
	leaq	32(%rsp), %r14
	vmovdqa	%xmm0, 16(%rsp)
	vmovq	%xmm2, 8(%rsp)
	.p2align 4,,10
	.p2align 3
.L820:
	call	_ZNSt6chrono3_V212steady_clock3nowEv@PLT
	vmovdqa	16(%rsp), %xmm4
	xorl	%ecx, %ecx
	movl	%r13d, %edx
	movq	%rax, %rbx
	movq	8(%rsp), %rax
	movq	%r14, %rsi
	leaq	pfi_bench_dense._omp_fn.0(%rip), %rdi
	vmovdqa	%xmm4, 32(%rsp)
	addq	$8, %r12
	movq	%rax, 56(%rsp)
	movq	%rbp, 48(%rsp)
	call	GOMP_parallel@PLT
	call	_ZNSt6chrono3_V212steady_clock3nowEv@PLT
	subq	%rbx, %rax
	movq	%rax, -8(%r12)
	cmpq	%r15, %r12
	jne	.L820
.L817:
	movq	72(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L827
	addq	$88, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L819:
	.cfi_restore_state
	movq	%r10, %r12
	leaq	(%r10,%rax,8), %r13
	.p2align 4,,10
	.p2align 3
.L821:
	call	_ZNSt6chrono3_V212steady_clock3nowEv@PLT
	movl	144(%rsp), %ecx
	movq	8(%rsp), %rdi
	movl	%r14d, %r9d
	movl	$1, %r8d
	movq	%r15, %rdx
	movq	%rbp, %rsi
	movq	%rax, %rbx
	call	_ZN12_GLOBAL__N_120dense_layer_inregionEPKfRKNS_5LayerEPfibi
	addq	$8, %r12
	call	_ZNSt6chrono3_V212steady_clock3nowEv@PLT
	subq	%rbx, %rax
	movq	%rax, -8(%r12)
	cmpq	%r13, %r12
	jne	.L821
	jmp	.L817
.L827:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE8378:
	.size	pfi_bench_dense, .-pfi_bench_dense
	.p2align 4
	.globl	pfi_scratch_bytes
	.type	pfi_scratch_bytes, @function
pfi_scratch_bytes:
.LFB8379:
	.cfi_startproc
	endbr64
	movq	_ZN12_GLOBAL__N_18g_modelsE(%rip), %rdx
	movq	8+_ZN12_GLOBAL__N_18g_modelsE(%rip), %rdi
	cmpq	%rdx, %rdi
	je	.L833
	leaq	-32(%rdi), %rsi
	movq	%rdx, %rax
	subq	%rdx, %rsi
	movq	%rsi, %r8
	shrq	$5, %r8
	cmpq	$224, %rsi
	jbe	.L834
	xorb	%sil, %sil
	movl	$784, %ecx
	vmovdqa	.LC10(%rip), %ymm1
	addq	%rdx, %rsi
	vpbroadcastd	%ecx, %ymm4
	.p2align 4,,10
	.p2align 3
.L831:
	vmovdqu	24(%rax), %ymm0
	vmovdqu	88(%rax), %ymm2
	addq	$256, %rax
	vmovdqu	-40(%rax), %ymm3
	vpermt2d	-136(%rax), %ymm1, %ymm2
	vpermt2d	-200(%rax), %ymm1, %ymm0
	vpermt2d	%ymm2, %ymm1, %ymm0
	vmovdqu	-104(%rax), %ymm2
	vpermt2d	-8(%rax), %ymm1, %ymm3
	vpermt2d	-72(%rax), %ymm1, %ymm2
	vpermt2d	%ymm3, %ymm1, %ymm2
	vpermt2d	%ymm2, %ymm1, %ymm0
	vpmaxsd	%ymm0, %ymm4, %ymm4
	cmpq	%rsi, %rax
	jne	.L831
	vextracti128	$0x1, %ymm4, %xmm0
	andq	$-8, %r8
	vpmaxsd	%xmm4, %xmm0, %xmm0
	salq	$5, %r8
	vpsrldq	$8, %xmm0, %xmm1
	addq	%r8, %rdx
	vpmaxsd	%xmm1, %xmm0, %xmm0
	vpsrldq	$4, %xmm0, %xmm1
	vpmaxsd	%xmm1, %xmm0, %xmm0
	vzeroupper
.L830:
	vmovd	24(%rdx), %xmm1
	leaq	32(%rdx), %rcx
	vpmaxsd	%xmm1, %xmm0, %xmm0
	vmovd	%xmm0, %eax
	cmpq	%rcx, %rdi
	je	.L832
	vmovd	56(%rdx), %xmm1
	leaq	64(%rdx), %rcx
	vpmaxsd	%xmm1, %xmm0, %xmm0
	vmovd	%xmm0, %eax
	cmpq	%rcx, %rdi
	je	.L832
	vmovd	88(%rdx), %xmm1
	leaq	96(%rdx), %rcx
	vpmaxsd	%xmm1, %xmm0, %xmm0
	vmovd	%xmm0, %eax
	cmpq	%rcx, %rdi
	je	.L832
	vmovd	120(%rdx), %xmm1
	leaq	128(%rdx), %rcx
	vpmaxsd	%xmm1, %xmm0, %xmm0
	vmovd	%xmm0, %eax
	cmpq	%rcx, %rdi
	je	.L832
	vmovd	152(%rdx), %xmm1
	leaq	160(%rdx), %rcx
	vpmaxsd	%xmm1, %xmm0, %xmm0
	vmovd	%xmm0, %eax
	cmpq	%rcx, %rdi
	je	.L832
	vmovd	184(%rdx), %xmm1
	leaq	192(%rdx), %rcx
	vpmaxsd	%xmm1, %xmm0, %xmm0
	vmovd	%xmm0, %eax
	cmpq	%rcx, %rdi
	je	.L832
	vmovd	216(%rdx), %xmm1
	leaq	224(%rdx), %rcx
	vpmaxsd	%xmm1, %xmm0, %xmm0
	vmovd	%xmm0, %eax
	cmpq	%rcx, %rdi
	je	.L832
	vmovd	248(%rdx), %xmm1
	vpmaxsd	%xmm1, %xmm0, %xmm0
	vmovd	%xmm0, %eax
.L832:
	cltq
	leaq	784(%rax), %rdx
	movslq	64+_ZN12_GLOBAL__N_11HE(%rip), %rax
	imulq	%rdx, %rax
	salq	$3, %rax
	ret
	.p2align 4,,10
	.p2align 3
.L833:
	movslq	64+_ZN12_GLOBAL__N_11HE(%rip), %rax
	movl	$1568, %edx
	imulq	%rdx, %rax
	salq	$3, %rax
	ret
.L834:
	vmovdqa	.LC11(%rip), %xmm0
	jmp	.L830
	.cfi_endproc
.LFE8379:
	.size	pfi_scratch_bytes, .-pfi_scratch_bytes
	.section	.text._ZNSt6vectorIiSaIiEED2Ev,"axG",@progbits,_ZNSt6vectorIiSaIiEED5Ev,comdat
	.align 2
	.p2align 4
	.weak	_ZNSt6vectorIiSaIiEED2Ev
	.type	_ZNSt6vectorIiSaIiEED2Ev, @function
_ZNSt6vectorIiSaIiEED2Ev:
.LFB8438:
	.cfi_startproc
	endbr64
	movq	(%rdi), %rax
	testq	%rax, %rax
	je	.L838
	movq	16(%rdi), %rsi
	movq	%rax, %rdi
	subq	%rax, %rsi
	jmp	_ZdlPvm@PLT
	.p2align 4,,10
	.p2align 3
.L838:
	ret
	.cfi_endproc
.LFE8438:
	.size	_ZNSt6vectorIiSaIiEED2Ev, .-_ZNSt6vectorIiSaIiEED2Ev
	.weak	_ZNSt6vectorIiSaIiEED1Ev
	.set	_ZNSt6vectorIiSaIiEED1Ev,_ZNSt6vectorIiSaIiEED2Ev
	.section	.rodata._ZNSt6vectorIiSaIiEE17_M_default_appendEm.str1.1,"aMS",@progbits,1
.LC12:
	.string	"vector::_M_default_append"
	.section	.text._ZNSt6vectorIiSaIiEE17_M_default_appendEm,"axG",@progbits,_ZNSt6vectorIiSaIiEE17_M_default_appendEm,comdat
	.align 2
	.p2align 4
	.weak	_ZNSt6vectorIiSaIiEE17_M_default_appendEm
	.type	_ZNSt6vectorIiSaIiEE17_M_default_appendEm, @function
_ZNSt6vectorIiSaIiEE17_M_default_appendEm:
.LFB8564:
	.cfi_startproc
	endbr64
	testq	%rsi, %rsi
	je	.L868
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	movq	%rdi, %r14
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%rsi, %rbx
	subq	$24, %rsp
	.cfi_def_cfa_offset 80
	movq	8(%rdi), %r12
	movq	16(%rdi), %rax
	movq	(%rdi), %r13
	subq	%r12, %rax
	sarq	$2, %rax
	cmpq	%rsi, %rax
	jnb	.L872
	subq	%r13, %r12
	movabsq	$2305843009213693951, %rax
	movq	%r12, %rbp
	sarq	$2, %rbp
	subq	%rbp, %rax
	cmpq	%rsi, %rax
	jb	.L873
	leaq	-1(%rsi), %rax
	leaq	(%rsi,%rbp), %r15
	movq	%rax, 8(%rsp)
	cmpq	%rsi, %rbp
	jb	.L844
	movabsq	$2305843009213693951, %rax
	addq	%rbp, %rbp
	cmpq	%rax, %rbp
	cmova	%rax, %rbp
	leaq	0(,%rbp,4), %rax
	movq	%rax, %rdi
	movq	%rax, (%rsp)
	call	_Znwm@PLT
	leaq	(%rax,%r12), %rdi
	movq	%rax, %rbp
	movl	$0, (%rdi)
	cmpq	$1, %rbx
	je	.L845
.L871:
	movq	8(%rsp), %rdx
	addq	$4, %rdi
	xorl	%esi, %esi
	salq	$2, %rdx
	call	memset@PLT
.L847:
	testq	%r12, %r12
	jne	.L845
	testq	%r13, %r13
	jne	.L874
.L850:
	movq	(%rsp), %r8
	leaq	0(%rbp,%r15,4), %rax
	vmovq	%rbp, %xmm1
	vpinsrq	$1, %rax, %xmm1, %xmm0
	addq	%rbp, %r8
	vmovdqu	%xmm0, (%r14)
	movq	%r8, 16(%r14)
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L872:
	.cfi_restore_state
	movl	$0, (%r12)
	leaq	4(%r12), %rdi
	decq	%rbx
	je	.L842
	leaq	(%rdi,%rbx,4), %rax
	xorl	%esi, %esi
	subq	%r12, %rax
	leaq	-4(%rax), %rbx
	movq	%rbx, %rdx
	call	memset@PLT
	movq	%rax, %rdi
	addq	%rbx, %rdi
.L842:
	movq	%rdi, 8(%r14)
	addq	$24, %rsp
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L868:
	.cfi_restore 3
	.cfi_restore 6
	.cfi_restore 12
	.cfi_restore 13
	.cfi_restore 14
	.cfi_restore 15
	ret
	.p2align 4,,10
	.p2align 3
.L844:
	.cfi_def_cfa_offset 80
	.cfi_offset 3, -56
	.cfi_offset 6, -48
	.cfi_offset 12, -40
	.cfi_offset 13, -32
	.cfi_offset 14, -24
	.cfi_offset 15, -16
	movabsq	$2305843009213693951, %rbp
	cmpq	%rbp, %r15
	cmovbe	%r15, %rbp
	leaq	0(,%rbp,4), %rax
	movq	%rax, %rdi
	movq	%rax, (%rsp)
	call	_Znwm@PLT
	cmpq	$0, 8(%rsp)
	leaq	(%rax,%r12), %rdi
	movq	%rax, %rbp
	movl	$0, (%rdi)
	jne	.L871
	jmp	.L847
	.p2align 4,,10
	.p2align 3
.L845:
	movq	%r13, %rsi
	movq	%r12, %rdx
	movq	%rbp, %rdi
	call	memmove@PLT
	movq	16(%r14), %rsi
	subq	%r13, %rsi
.L849:
	movq	%r13, %rdi
	call	_ZdlPvm@PLT
	jmp	.L850
	.p2align 4,,10
	.p2align 3
.L874:
	movq	16(%r14), %rsi
	subq	%r13, %rsi
	jmp	.L849
.L873:
	leaq	.LC12(%rip), %rdi
	call	_ZSt20__throw_length_errorPKc@PLT
	.cfi_endproc
.LFE8564:
	.size	_ZNSt6vectorIiSaIiEE17_M_default_appendEm, .-_ZNSt6vectorIiSaIiEE17_M_default_appendEm
	.text
	.p2align 4
	.type	_ZN12_GLOBAL__N_114ensure_scratchEi.part.0, @function
_ZN12_GLOBAL__N_114ensure_scratchEi.part.0:
.LFB8948:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	movl	%edi, %r12d
	pushq	%rbx
	movq	_ZN12_GLOBAL__N_18g_modelsE(%rip), %rdx
	movq	8+_ZN12_GLOBAL__N_18g_modelsE(%rip), %rdi
	andq	$-32, %rsp
	.cfi_offset 3, -56
	cmpq	%rdi, %rdx
	je	.L886
	leaq	-32(%rdi), %rsi
	movq	%rdx, %rax
	subq	%rdx, %rsi
	movq	%rsi, %r8
	shrq	$5, %r8
	cmpq	$224, %rsi
	jbe	.L887
	xorb	%sil, %sil
	movl	$784, %ecx
	vmovdqa	.LC10(%rip), %ymm1
	addq	%rdx, %rsi
	vpbroadcastd	%ecx, %ymm4
	.p2align 4,,10
	.p2align 3
.L878:
	vmovdqu	24(%rax), %ymm0
	vmovdqu	88(%rax), %ymm2
	addq	$256, %rax
	vmovdqu	-40(%rax), %ymm3
	vpermt2d	-136(%rax), %ymm1, %ymm2
	vpermt2d	-200(%rax), %ymm1, %ymm0
	vpermt2d	%ymm2, %ymm1, %ymm0
	vmovdqu	-104(%rax), %ymm2
	vpermt2d	-8(%rax), %ymm1, %ymm3
	vpermt2d	-72(%rax), %ymm1, %ymm2
	vpermt2d	%ymm3, %ymm1, %ymm2
	vpermt2d	%ymm2, %ymm1, %ymm0
	vpmaxsd	%ymm0, %ymm4, %ymm4
	cmpq	%rsi, %rax
	jne	.L878
	vextracti128	$0x1, %ymm4, %xmm0
	andq	$-8, %r8
	vpmaxsd	%xmm4, %xmm0, %xmm0
	salq	$5, %r8
	vpsrldq	$8, %xmm0, %xmm1
	addq	%r8, %rdx
	vpmaxsd	%xmm1, %xmm0, %xmm0
	vpsrldq	$4, %xmm0, %xmm1
	vpmaxsd	%xmm1, %xmm0, %xmm0
	vzeroupper
.L877:
	vmovd	24(%rdx), %xmm1
	leaq	32(%rdx), %rax
	vpmaxsd	%xmm1, %xmm0, %xmm0
	vmovd	%xmm0, %ebx
	cmpq	%rax, %rdi
	je	.L879
	vmovd	56(%rdx), %xmm1
	leaq	64(%rdx), %rax
	vpmaxsd	%xmm1, %xmm0, %xmm0
	vmovd	%xmm0, %ebx
	cmpq	%rax, %rdi
	je	.L879
	vmovd	88(%rdx), %xmm1
	leaq	96(%rdx), %rax
	vpmaxsd	%xmm1, %xmm0, %xmm0
	vmovd	%xmm0, %ebx
	cmpq	%rax, %rdi
	je	.L879
	vmovd	120(%rdx), %xmm1
	leaq	128(%rdx), %rax
	vpmaxsd	%xmm1, %xmm0, %xmm0
	vmovd	%xmm0, %ebx
	cmpq	%rax, %rdi
	je	.L879
	vmovd	152(%rdx), %xmm1
	leaq	160(%rdx), %rax
	vpmaxsd	%xmm1, %xmm0, %xmm0
	vmovd	%xmm0, %ebx
	cmpq	%rax, %rdi
	je	.L879
	vmovd	184(%rdx), %xmm1
	leaq	192(%rdx), %rax
	vpmaxsd	%xmm1, %xmm0, %xmm0
	vmovd	%xmm0, %ebx
	cmpq	%rax, %rdi
	je	.L879
	vmovd	216(%rdx), %xmm1
	leaq	224(%rdx), %rax
	vpmaxsd	%xmm1, %xmm0, %xmm0
	vmovd	%xmm0, %ebx
	cmpq	%rax, %rdi
	je	.L879
	vmovd	248(%rdx), %xmm1
	vpmaxsd	%xmm1, %xmm0, %xmm0
	vmovd	%xmm0, %ebx
.L879:
	movslq	%ebx, %rbx
.L876:
	movq	72+_ZN12_GLOBAL__N_11HE(%rip), %rdi
	movslq	%r12d, %r15
	imulq	$3136, %r15, %r14
	leaq	0(,%r15,4), %r13
	call	free@PLT
	movq	80+_ZN12_GLOBAL__N_11HE(%rip), %rdi
	call	free@PLT
	movq	88+_ZN12_GLOBAL__N_11HE(%rip), %rdi
	call	free@PLT
	movq	96+_ZN12_GLOBAL__N_11HE(%rip), %rdi
	call	free@PLT
	testq	%r14, %r14
	movl	$64, %r8d
	movl	$64, %edi
	cmove	%r8, %r14
	imulq	%r13, %rbx
	movq	%r14, %rsi
	call	aligned_alloc@PLT
	addq	$63, %rbx
	movq	%r14, %rcx
	movq	%r14, %rdx
	xorl	%esi, %esi
	movq	%rax, %rdi
	call	__memset_chk@PLT
	andq	$-64, %rbx
	movl	$64, %r8d
	movl	$64, %edi
	cmove	%r8, %rbx
	movq	%rax, 72+_ZN12_GLOBAL__N_11HE(%rip)
	movq	%rbx, %rsi
	call	aligned_alloc@PLT
	movq	%rbx, %rcx
	movq	%rbx, %rdx
	xorl	%esi, %esi
	movq	%rax, %rdi
	call	__memset_chk@PLT
	movq	%rbx, %rsi
	movl	$64, %edi
	movq	%rax, 80+_ZN12_GLOBAL__N_11HE(%rip)
	call	aligned_alloc@PLT
	movq	%rbx, %rcx
	movq	%rbx, %rdx
	xorl	%esi, %esi
	movq	%rax, %rdi
	call	__memset_chk@PLT
	movq	%r14, %rsi
	movl	$64, %edi
	movq	%rax, 88+_ZN12_GLOBAL__N_11HE(%rip)
	call	aligned_alloc@PLT
	movq	%r14, %rcx
	movq	%r14, %rdx
	xorl	%esi, %esi
	movq	%rax, %rdi
	call	__memset_chk@PLT
	movq	112+_ZN12_GLOBAL__N_11HE(%rip), %rcx
	movq	104+_ZN12_GLOBAL__N_11HE(%rip), %rdx
	movq	%rax, 96+_ZN12_GLOBAL__N_11HE(%rip)
	movq	%rcx, %rax
	subq	%rdx, %rax
	sarq	$2, %rax
	cmpq	%r15, %rax
	jb	.L892
	cmpq	%rax, %r15
	jb	.L893
.L883:
	movq	136+_ZN12_GLOBAL__N_11HE(%rip), %rcx
	movq	128+_ZN12_GLOBAL__N_11HE(%rip), %rdx
	movq	%rcx, %rax
	subq	%rdx, %rax
	sarq	$2, %rax
	cmpq	%r15, %rax
	jb	.L894
	cmpq	%rax, %r15
	jnb	.L885
	addq	%r13, %rdx
	cmpq	%rdx, %rcx
	je	.L885
	movq	%rdx, 136+_ZN12_GLOBAL__N_11HE(%rip)
.L885:
	movl	%r12d, 64+_ZN12_GLOBAL__N_11HE(%rip)
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
	.p2align 4,,10
	.p2align 3
.L893:
	.cfi_restore_state
	addq	%r13, %rdx
	cmpq	%rdx, %rcx
	je	.L883
	movq	%rdx, 112+_ZN12_GLOBAL__N_11HE(%rip)
	jmp	.L883
	.p2align 4,,10
	.p2align 3
.L894:
	movq	%r15, %rsi
	leaq	128+_ZN12_GLOBAL__N_11HE(%rip), %rdi
	subq	%rax, %rsi
	call	_ZNSt6vectorIiSaIiEE17_M_default_appendEm@PLT
	jmp	.L885
	.p2align 4,,10
	.p2align 3
.L892:
	movq	%r15, %rsi
	leaq	104+_ZN12_GLOBAL__N_11HE(%rip), %rdi
	subq	%rax, %rsi
	call	_ZNSt6vectorIiSaIiEE17_M_default_appendEm@PLT
	jmp	.L883
	.p2align 4,,10
	.p2align 3
.L886:
	movl	$784, %ebx
	jmp	.L876
.L887:
	vmovdqa	.LC11(%rip), %xmm0
	jmp	.L877
	.cfi_endproc
.LFE8948:
	.size	_ZN12_GLOBAL__N_114ensure_scratchEi.part.0, .-_ZN12_GLOBAL__N_114ensure_scratchEi.part.0
	.section	.text.unlikely
.LCOLDB13:
	.text
.LHOTB13:
	.p2align 4
	.globl	pfi_logits
	.type	pfi_logits, @function
pfi_logits:
.LFB8370:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA8370
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	.cfi_offset 15, -24
	movl	%r8d, %r15d
	pushq	%r14
	.cfi_offset 14, -32
	movl	%edx, %r14d
	pushq	%r13
	pushq	%r12
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	movslq	%edi, %r12
	salq	$5, %r12
	pushq	%rbx
	subq	$136, %rsp
	.cfi_offset 3, -56
	movq	%rsi, 40(%rsp)
	addq	_ZN12_GLOBAL__N_18g_modelsE(%rip), %r12
	movq	%rcx, 32(%rsp)
	movq	%fs:40, %rax
	movq	%rax, 120(%rsp)
	xorl	%eax, %eax
	cmpl	64+_ZN12_GLOBAL__N_11HE(%rip), %edx
	jle	.L896
	movl	%edx, %edi
.LEHB8:
	call	_ZN12_GLOBAL__N_114ensure_scratchEi.part.0
.L896:
	movq	8(%r12), %rax
	vpxor	%xmm0, %xmm0, %xmm0
	movslq	-28(%rax), %rcx
	subq	(%r12), %rax
	movq	$0, 64(%rsp)
	vmovdqa	%xmm0, 48(%rsp)
	je	.L926
	movq	%rax, %rbx
	movabsq	$9223372036854775776, %rax
	cmpq	%rbx, %rax
	jb	.L968
	movq	%rbx, %rdi
	movl	%ecx, 24(%rsp)
	call	_Znwm@PLT
	movslq	24(%rsp), %rcx
	movq	%rax, %r13
.L897:
	leaq	0(%r13,%rbx), %rsi
	vpbroadcastq	%r13, %xmm0
	movq	%rsi, 64(%rsp)
	vmovdqa	%xmm0, 48(%rsp)
	movq	8(%r12), %rax
	movq	(%r12), %rdx
	cmpq	%rdx, %rax
	je	.L927
	subq	%rdx, %rax
	xorl	%ebx, %ebx
	.p2align 4,,10
	.p2align 3
.L901:
	vmovdqu	(%rdx,%rbx), %ymm3
	vmovdqu	%ymm3, 0(%r13,%rbx)
	addq	$32, %rbx
	cmpq	%rax, %rbx
	jne	.L901
	addq	%r13, %rbx
	vzeroupper
.L900:
	movl	24(%r12), %eax
	movq	%rbx, 56(%rsp)
	movl	%eax, 72(%rsp)
	testl	%r15d, %r15d
	jle	.L965
	movq	8(%r12), %rax
	subq	%rdx, %rax
	sarq	$5, %rax
	cmpl	%eax, %r15d
	jl	.L904
.L965:
	movslq	%r14d, %rbx
	imulq	%rcx, %rbx
	salq	$2, %rbx
.L903:
	vmovq	40(%rsp), %xmm1
	leaq	48(%rsp), %rax
	leaq	80(%rsp), %rsi
	xorl	%ecx, %ecx
	xorl	%edx, %edx
	leaq	pfi_logits._omp_fn.0(%rip), %rdi
	movq	%rax, 104(%rsp)
	vpinsrq	$1, %r12, %xmm1, %xmm0
	movl	%r14d, 112(%rsp)
	vmovdqa	%xmm0, 80(%rsp)
	movq	$0, 96(%rsp)
	call	GOMP_parallel@PLT
	movq	32(%rsp), %rdi
	movq	96(%rsp), %rsi
	movq	%rbx, %rdx
	call	memcpy@PLT
	movq	48(%rsp), %rdi
	testq	%rdi, %rdi
	je	.L895
	movq	64(%rsp), %rsi
	subq	%rdi, %rsi
	call	_ZdlPvm@PLT
.L895:
	movq	120(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L967
	addq	$136, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
	.p2align 4,,10
	.p2align 3
.L926:
	.cfi_restore_state
	xorl	%ebx, %ebx
	xorl	%r13d, %r13d
	jmp	.L897
	.p2align 4,,10
	.p2align 3
.L904:
	movq	%rbx, %rax
	movslq	%r15d, %rcx
	subq	%r13, %rax
	movq	%rcx, 24(%rsp)
	movq	%rax, 16(%rsp)
	sarq	$5, %rax
	cmpq	%rcx, %rax
	jb	.L969
	movslq	%r14d, %rdx
	cmpq	%rax, 24(%rsp)
	jnb	.L964
	movq	%rcx, %rax
	salq	$5, %rax
	addq	%rax, %r13
	cmpq	%r13, %rbx
	je	.L964
	movslq	-28(%r13), %rbx
	movq	%r13, 56(%rsp)
	imulq	%rdx, %rbx
	salq	$2, %rbx
	jmp	.L903
.L969:
	subq	%rbx, %rsi
	subq	%rax, %rcx
	sarq	$5, %rsi
	movq	%rcx, 8(%rsp)
	cmpq	%rcx, %rsi
	jb	.L906
	leaq	-1(%rcx), %rax
	cmpq	$3, %rax
	jbe	.L928
	shrq	$2, %rcx
	movq	%rbx, %rax
	vpxor	%xmm0, %xmm0, %xmm0
	movq	%rcx, %rdx
	salq	$7, %rdx
	addq	%rbx, %rdx
	.p2align 4,,10
	.p2align 3
.L908:
	movq	$0, (%rax)
	subq	$-128, %rax
	movq	$0, -96(%rax)
	movq	$0, -64(%rax)
	movq	$0, -32(%rax)
	vmovdqu	%xmm0, -120(%rax)
	movq	$0, -104(%rax)
	vmovdqu	%xmm0, -88(%rax)
	movq	$0, -72(%rax)
	vmovdqu	%xmm0, -56(%rax)
	movq	$0, -40(%rax)
	vmovdqu	%xmm0, -24(%rax)
	movq	$0, -8(%rax)
	cmpq	%rax, %rdx
	jne	.L908
	movq	8(%rsp), %rdi
	testb	$3, %dil
	je	.L909
	movq	%rdi, %rcx
	andq	$-4, %rcx
	movq	%rcx, %rax
	subq	%rcx, %rdi
	salq	$5, %rax
	movq	%rdi, %rdx
	addq	%rbx, %rax
.L907:
	vpxor	%xmm0, %xmm0, %xmm0
	movq	$0, (%rax)
	movq	$0, 24(%rax)
	vmovdqu	%xmm0, 8(%rax)
	cmpq	$1, %rdx
	je	.L909
	movq	$0, 32(%rax)
	movq	$0, 56(%rax)
	vmovdqu	%xmm0, 40(%rax)
	cmpq	$2, %rdx
	je	.L909
	movq	$0, 64(%rax)
	movq	$0, 88(%rax)
	vmovdqu	%xmm0, 72(%rax)
	cmpq	$3, %rdx
	je	.L909
	movq	$0, 96(%rax)
	movq	$0, 120(%rax)
	vmovdqu	%xmm0, 104(%rax)
.L909:
	movq	8(%rsp), %rax
	salq	$5, %rax
	addq	%rbx, %rax
	xorl	%ebx, %ebx
	movq	%rax, 56(%rsp)
	jmp	.L903
	.p2align 4,,10
	.p2align 3
.L964:
	movslq	-28(%rbx), %rbx
	imulq	%rdx, %rbx
	salq	$2, %rbx
	jmp	.L903
	.p2align 4,,10
	.p2align 3
.L927:
	movq	%r13, %rbx
	jmp	.L900
.L968:
	movq	120(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L967
	call	_ZSt28__throw_bad_array_new_lengthv@PLT
.LEHE8:
.L928:
	movq	%rcx, %rdx
	movq	%rbx, %rax
	jmp	.L907
.L906:
	movabsq	$288230376151711743, %rdx
	subq	%rax, %rdx
	cmpq	%rcx, %rdx
	jb	.L970
	leaq	(%rax,%rax), %rdx
	cmpq	%rcx, %rax
	movq	%rcx, %r15
	movq	%rdx, %rax
	cmovb	24(%rsp), %rax
	salq	$5, %rax
	movq	%rax, %rdi
	movq	%rax, (%rsp)
.LEHB9:
	call	_Znwm@PLT
	movq	16(%rsp), %rdi
	movq	%rax, %r8
	leaq	(%rax,%rdi), %rcx
	leaq	-1(%r15), %rax
	cmpq	$3, %rax
	jbe	.L930
	shrq	$2, %r15
	leaq	8(%r8,%rdi), %rax
	vpxor	%xmm0, %xmm0, %xmm0
	movq	%rcx, %rdx
	movq	%r15, %rsi
	salq	$7, %rsi
	addq	%rcx, %rsi
.L915:
	movq	$0, (%rdx)
	subq	$-128, %rdx
	subq	$-128, %rax
	movq	$0, -96(%rdx)
	movq	$0, -64(%rdx)
	movq	$0, -32(%rdx)
	vmovdqu	%xmm0, -128(%rax)
	movq	$0, -112(%rax)
	vmovdqu	%xmm0, -96(%rax)
	movq	$0, -80(%rax)
	vmovdqu	%xmm0, -64(%rax)
	movq	$0, -48(%rax)
	vmovdqu	%xmm0, -32(%rax)
	movq	$0, -16(%rax)
	cmpq	%rdx, %rsi
	jne	.L915
	movq	8(%rsp), %rdi
	movq	%rdi, %rdx
	andq	$-4, %rdx
	movq	%rdx, %rax
	salq	$5, %rax
	addq	%rax, %rcx
	movq	%rdi, %rax
	subq	%rdx, %rax
	andl	$3, %edi
	je	.L916
.L914:
	vpxor	%xmm0, %xmm0, %xmm0
	movq	$0, (%rcx)
	movq	$0, 24(%rcx)
	vmovdqu	%xmm0, 8(%rcx)
	cmpq	$1, %rax
	je	.L916
	movq	$0, 32(%rcx)
	movq	$0, 56(%rcx)
	vmovdqu	%xmm0, 40(%rcx)
	cmpq	$2, %rax
	je	.L916
	movq	$0, 64(%rcx)
	movq	$0, 88(%rcx)
	vmovdqu	%xmm0, 72(%rcx)
	cmpq	$3, %rax
	je	.L916
	movq	$0, 96(%rcx)
	movq	$0, 120(%rcx)
	vmovdqu	%xmm0, 104(%rcx)
.L916:
	cmpq	%r13, %rbx
	je	.L971
	movq	%rbx, %rdx
	movq	%r8, %rdi
	movq	%r13, %rsi
	subq	%r13, %rdx
	call	memcpy@PLT
	movq	%rax, %r8
.L918:
	movq	64(%rsp), %rsi
	movq	%r13, %rdi
	movq	%r8, 16(%rsp)
	subq	%r13, %rsi
	call	_ZdlPvm@PLT
	movq	16(%rsp), %r8
.L919:
	movq	24(%rsp), %rax
	vmovq	%r8, %xmm2
	movq	(%rsp), %rcx
	salq	$5, %rax
	addq	%r8, %rax
	addq	%rcx, %r8
	movslq	-28(%rax), %rbx
	vpinsrq	$1, %rax, %xmm2, %xmm0
	movslq	%r14d, %rax
	movq	%r8, 64(%rsp)
	vmovdqa	%xmm0, 48(%rsp)
	imulq	%rax, %rbx
	salq	$2, %rbx
	jmp	.L903
.L971:
	testq	%r13, %r13
	je	.L919
	jmp	.L918
.L930:
	movq	8(%rsp), %rax
	jmp	.L914
.L970:
	movq	120(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L967
	leaq	.LC12(%rip), %rdi
	call	_ZSt20__throw_length_errorPKc@PLT
.LEHE9:
.L967:
	call	__stack_chk_fail@PLT
.L931:
	endbr64
	movq	%rax, %rbx
	jmp	.L923
	.section	.gcc_except_table
.LLSDA8370:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8370-.LLSDACSB8370
.LLSDACSB8370:
	.uleb128 .LEHB8-.LFB8370
	.uleb128 .LEHE8-.LEHB8
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB9-.LFB8370
	.uleb128 .LEHE9-.LEHB9
	.uleb128 .L931-.LFB8370
	.uleb128 0
.LLSDACSE8370:
	.text
	.cfi_endproc
	.section	.text.unlikely
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDAC8370
	.type	pfi_logits.cold, @function
pfi_logits.cold:
.LFSB8370:
.L923:
	.cfi_def_cfa 6, 16
	.cfi_offset 3, -56
	.cfi_offset 6, -16
	.cfi_offset 12, -48
	.cfi_offset 13, -40
	.cfi_offset 14, -32
	.cfi_offset 15, -24
	leaq	48(%rsp), %rdi
	vzeroupper
	call	_ZNSt6vectorIN12_GLOBAL__N_15LayerESaIS1_EED1Ev
	movq	120(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L972
	movq	%rbx, %rdi
.LEHB10:
	call	_Unwind_Resume@PLT
.LEHE10:
.L972:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE8370:
	.section	.gcc_except_table
.LLSDAC8370:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC8370-.LLSDACSBC8370
.LLSDACSBC8370:
	.uleb128 .LEHB10-.LCOLDB13
	.uleb128 .LEHE10-.LEHB10
	.uleb128 0
	.uleb128 0
.LLSDACSEC8370:
	.section	.text.unlikely
	.text
	.size	pfi_logits, .-pfi_logits
	.section	.text.unlikely
	.size	pfi_logits.cold, .-pfi_logits.cold
.LCOLDE13:
	.text
.LHOTE13:
	.p2align 4
	.globl	pfi_flat_predict
	.type	pfi_flat_predict, @function
pfi_flat_predict:
.LFB8374:
	.cfi_startproc
	endbr64
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	vmovq	%rdi, %xmm2
	vpinsrq	$1, %rdx, %xmm2, %xmm1
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	movq	%rcx, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	movl	%esi, %ebx
	subq	$72, %rsp
	.cfi_def_cfa_offset 112
	movq	%fs:40, %rax
	movq	%rax, 56(%rsp)
	xorl	%eax, %eax
	cmpl	64+_ZN12_GLOBAL__N_11HE(%rip), %esi
	vmovdqa	%xmm1, (%rsp)
	jle	.L974
	movl	%esi, %edi
	call	_ZN12_GLOBAL__N_114ensure_scratchEi.part.0
.L974:
	movslq	200+_ZN12_GLOBAL__N_11HE(%rip), %rbp
	vmovd	%ebx, %xmm4
	salq	$5, %rbp
	addq	_ZN12_GLOBAL__N_18g_modelsE(%rip), %rbp
	movq	8(%rbp), %rax
	vpinsrd	$1, -28(%rax), %xmm4, %xmm3
	vmovq	%xmm3, %rbx
	call	_ZNSt6chrono3_V212steady_clock3nowEv@PLT
	vmovdqa	(%rsp), %xmm5
	xorl	%ecx, %ecx
	xorl	%edx, %edx
	leaq	16(%rsp), %rsi
	leaq	pfi_flat_predict._omp_fn.0(%rip), %rdi
	movq	%rbx, 48(%rsp)
	movq	%rax, %r13
	movq	%rbp, 32(%rsp)
	movq	$0, 40(%rsp)
	vmovdqa	%xmm5, 16(%rsp)
	call	GOMP_parallel@PLT
	movq	40(%rsp), %rbx
	call	_ZNSt6chrono3_V212steady_clock3nowEv@PLT
	testq	%r12, %r12
	je	.L973
	movq	%rbx, %rdx
	subq	%rbx, %rax
	subq	%r13, %rdx
	vmovq	%rdx, %xmm0
	vpinsrq	$1, %rax, %xmm0, %xmm0
	vmovdqu	%xmm0, (%r12)
	vpxor	%xmm0, %xmm0, %xmm0
	vmovdqu	%xmm0, 16(%r12)
.L973:
	movq	56(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L982
	addq	$72, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
.L982:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE8374:
	.size	pfi_flat_predict, .-pfi_flat_predict
	.p2align 4
	.globl	pfi_hier_predict
	.type	pfi_hier_predict, @function
pfi_hier_predict:
.LFB8375:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	vmovq	%rdi, %xmm3
	vpinsrq	$1, %rdx, %xmm3, %xmm2
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	movq	%r8, %r12
	pushq	%rbx
	.cfi_offset 3, -56
	movl	%esi, %ebx
	andq	$-32, %rsp
	addq	$-128, %rsp
	movq	%rcx, 24(%rsp)
	movq	%fs:40, %rax
	movq	%rax, 120(%rsp)
	xorl	%eax, %eax
	cmpl	64+_ZN12_GLOBAL__N_11HE(%rip), %esi
	vmovdqa	%xmm2, 32(%rsp)
	jle	.L984
	movl	%esi, %edi
	call	_ZN12_GLOBAL__N_114ensure_scratchEi.part.0
.L984:
	movq	16+_ZN12_GLOBAL__N_11HE(%rip), %rax
	movslq	_ZN12_GLOBAL__N_11HE(%rip), %r14
	vmovd	%ebx, %xmm5
	subq	8+_ZN12_GLOBAL__N_11HE(%rip), %rax
	salq	$5, %r14
	addq	_ZN12_GLOBAL__N_18g_modelsE(%rip), %r14
	sarq	$2, %rax
	vpinsrd	$1, %eax, %xmm5, %xmm4
	movq	8(%r14), %rax
	vmovq	%xmm4, %r13
	movl	-28(%rax), %r15d
	call	_ZNSt6chrono3_V212steady_clock3nowEv@PLT
	vmovdqa	32(%rsp), %xmm7
	vpxor	%xmm0, %xmm0, %xmm0
	xorl	%ecx, %ecx
	leaq	pfi_hier_predict._omp_fn.0(%rip), %rdi
	leaq	48(%rsp), %rsi
	xorl	%edx, %edx
	movq	%rax, 16(%rsp)
	movl	%r15d, 104(%rsp)
	movq	%r13, 96(%rsp)
	movq	%r14, 64(%rsp)
	vmovdqa	%xmm7, 48(%rsp)
	vmovdqu	%xmm0, 72(%rsp)
	movq	$0, 88(%rsp)
	call	GOMP_parallel@PLT
	movq	72(%rsp), %r15
	movq	80(%rsp), %r14
	movq	88(%rsp), %r13
	call	_ZNSt6chrono3_V212steady_clock3nowEv@PLT
	movq	24(%rsp), %rdi
	movq	%rax, %rcx
	testq	%rdi, %rdi
	je	.L985
	movq	104+_ZN12_GLOBAL__N_11HE(%rip), %rsi
	movslq	%ebx, %rdx
	movq	%rax, 32(%rsp)
	salq	$2, %rdx
	call	memcpy@PLT
	movq	32(%rsp), %rcx
.L985:
	testq	%r12, %r12
	je	.L983
	movq	16(%rsp), %rbx
	movq	%r15, %rax
	movq	%r14, %rdx
	subq	%r15, %rdx
	subq	%rbx, %rax
	vmovq	%rax, %xmm1
	movq	%rcx, %rax
	subq	%r14, %rax
	vpinsrq	$1, %rdx, %xmm1, %xmm1
	subq	%r13, %rax
	vmovq	%rax, %xmm6
	vpinsrq	$1, %r13, %xmm6, %xmm0
	vinserti128	$0x1, %xmm0, %ymm1, %ymm0
	vmovdqu	%ymm0, (%r12)
	vzeroupper
.L983:
	movq	120(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L996
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
.L996:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE8375:
	.size	pfi_hier_predict, .-pfi_hier_predict
	.p2align 4
	.globl	pfi_route
	.type	pfi_route, @function
pfi_route:
.LFB8376:
	.cfi_startproc
	endbr64
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	vmovq	%rdi, %xmm2
	movl	%esi, %ebx
	vpinsrq	$1, %rdx, %xmm2, %xmm1
	subq	$64, %rsp
	.cfi_def_cfa_offset 80
	movq	%fs:40, %rax
	movq	%rax, 56(%rsp)
	xorl	%eax, %eax
	cmpl	64+_ZN12_GLOBAL__N_11HE(%rip), %esi
	jle	.L998
	movl	%esi, %edi
	vmovdqa	%xmm1, (%rsp)
	call	_ZN12_GLOBAL__N_114ensure_scratchEi.part.0
	vmovdqa	(%rsp), %xmm1
.L998:
	movslq	_ZN12_GLOBAL__N_11HE(%rip), %rax
	vmovd	%ebx, %xmm3
	xorl	%ecx, %ecx
	leaq	16(%rsp), %rsi
	leaq	pfi_route._omp_fn.0(%rip), %rdi
	salq	$5, %rax
	addq	_ZN12_GLOBAL__N_18g_modelsE(%rip), %rax
	movq	8(%rax), %rdx
	vpinsrd	$1, -28(%rdx), %xmm3, %xmm0
	xorl	%edx, %edx
	movq	%rax, 32(%rsp)
	vmovdqa	%xmm1, 16(%rsp)
	vmovq	%xmm0, 40(%rsp)
	call	GOMP_parallel@PLT
	movq	56(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L1002
	addq	$64, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
.L1002:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE8376:
	.size	pfi_route, .-pfi_route
	.p2align 4
	.globl	pfi_spec_predict
	.type	pfi_spec_predict, @function
pfi_spec_predict:
.LFB8377:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	andq	$-32, %rsp
	subq	$64, %rsp
	.cfi_offset 14, -24
	.cfi_offset 13, -32
	.cfi_offset 12, -40
	.cfi_offset 3, -48
	movq	%fs:40, %rax
	movq	%rax, 56(%rsp)
	xorl	%eax, %eax
	testl	%edx, %edx
	jle	.L1003
	cmpl	64+_ZN12_GLOBAL__N_11HE(%rip), %edx
	movl	%edi, %r13d
	movq	%rsi, %r12
	movl	%edx, %r14d
	movq	%rcx, %rbx
	jle	.L1006
	movl	%edx, %edi
	call	_ZN12_GLOBAL__N_114ensure_scratchEi.part.0
.L1006:
	movq	8+_ZN12_GLOBAL__N_11HE(%rip), %rax
	movslq	%r13d, %rdx
	movslq	(%rax,%rdx,4), %rax
	testl	%eax, %eax
	js	.L1042
	salq	$5, %rax
	vmovq	%r12, %xmm1
	vmovd	%r13d, %xmm2
	xorl	%ecx, %ecx
	vpinsrq	$1, %rbx, %xmm1, %xmm0
	leaq	16(%rsp), %rsi
	leaq	pfi_spec_predict._omp_fn.0(%rip), %rdi
	addq	_ZN12_GLOBAL__N_18g_modelsE(%rip), %rax
	movq	8(%rax), %rdx
	movl	-28(%rdx), %edx
	vmovdqa	%xmm0, 16(%rsp)
	vpinsrd	$1, %r14d, %xmm2, %xmm0
	movq	%rax, 32(%rsp)
	movl	%edx, 48(%rsp)
	xorl	%edx, %edx
	vmovq	%xmm0, 40(%rsp)
	call	GOMP_parallel@PLT
.L1003:
	movq	56(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L1043
	leaq	-32(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
	.p2align 4,,10
	.p2align 3
.L1042:
	.cfi_restore_state
	leaq	(%rdx,%rdx,2), %rax
	movq	32+_ZN12_GLOBAL__N_11HE(%rip), %rdx
	movslq	%r14d, %rsi
	leaq	(%rdx,%rax,8), %rax
	movl	%r14d, %edx
	movq	(%rax), %rcx
	leal	-1(%r14), %eax
	cmpl	$2, %eax
	jbe	.L1008
	leaq	(%rbx,%rsi,4), %rdi
	cmpq	%rdi, %rcx
	jnb	.L1021
	leaq	4(%rcx), %rdi
	cmpq	%rdi, %rbx
	jnb	.L1021
.L1008:
	movq	%rbx, %rax
	leaq	(%rbx,%rsi,4), %rsi
	.p2align 4,,10
	.p2align 3
.L1017:
	movl	(%rcx), %edx
	addq	$4, %rax
	movl	%edx, -4(%rax)
	cmpq	%rsi, %rax
	jne	.L1017
	jmp	.L1003
	.p2align 4,,10
	.p2align 3
.L1021:
	cmpl	$6, %eax
	jbe	.L1020
	movl	%r14d, %edx
	vpbroadcastd	(%rcx), %ymm0
	movq	%rbx, %rax
	shrl	$3, %edx
	salq	$5, %rdx
	leaq	(%rdx,%rbx), %rsi
	andl	$32, %edx
	je	.L1011
	leaq	32(%rbx), %rax
	vmovdqu	%ymm0, (%rbx)
	cmpq	%rsi, %rax
	je	.L1037
	.p2align 4,,10
	.p2align 3
.L1011:
	vmovdqu	%ymm0, (%rax)
	addq	$64, %rax
	vmovdqu	%ymm0, -32(%rax)
	cmpq	%rsi, %rax
	jne	.L1011
.L1037:
	movl	%r14d, %eax
	andl	$-8, %eax
	movl	%eax, %esi
	cmpl	%eax, %r14d
	je	.L1038
	movl	%r14d, %edx
	subl	%eax, %edx
	leal	-1(%rdx), %edi
	cmpl	$2, %edi
	jbe	.L1044
	vzeroupper
.L1010:
	vpbroadcastd	(%rcx), %xmm0
	vmovdqu	%xmm0, (%rbx,%rsi,4)
	testb	$3, %dl
	je	.L1003
	andl	$-4, %edx
	addl	%edx, %eax
.L1015:
	movl	(%rcx), %esi
	movslq	%eax, %rdx
	leaq	0(,%rdx,4), %rdi
	movl	%esi, (%rbx,%rdx,4)
	leal	1(%rax), %edx
	cmpl	%edx, %r14d
	jle	.L1003
	addl	$2, %eax
	movl	%esi, 4(%rbx,%rdi)
	cmpl	%eax, %r14d
	jle	.L1003
	movl	(%rcx), %eax
	movl	%eax, 8(%rbx,%rdi)
	jmp	.L1003
.L1038:
	vzeroupper
	jmp	.L1003
.L1020:
	xorl	%esi, %esi
	xorl	%eax, %eax
	jmp	.L1010
.L1044:
	vzeroupper
	jmp	.L1015
.L1043:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE8377:
	.size	pfi_spec_predict, .-pfi_spec_predict
	.section	.text._ZNSt6vectorIiSaIiEE14_M_fill_assignEmRKi,"axG",@progbits,_ZNSt6vectorIiSaIiEE14_M_fill_assignEmRKi,comdat
	.align 2
	.p2align 4
	.weak	_ZNSt6vectorIiSaIiEE14_M_fill_assignEmRKi
	.type	_ZNSt6vectorIiSaIiEE14_M_fill_assignEmRKi, @function
_ZNSt6vectorIiSaIiEE14_M_fill_assignEmRKi:
.LFB8596:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsi, %rax
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r13
	.cfi_offset 13, -24
	movq	%rdx, %r13
	pushq	%r12
	pushq	%rbx
	.cfi_offset 12, -32
	.cfi_offset 3, -40
	movq	%rdi, %rbx
	movq	(%rdi), %rdx
	movq	16(%rdi), %rcx
	andq	$-32, %rsp
	subq	%rdx, %rcx
	sarq	$2, %rcx
	cmpq	%rsi, %rcx
	jb	.L1141
	movq	8(%rdi), %rdi
	movq	%rdi, %rsi
	subq	%rdx, %rsi
	sarq	$2, %rsi
	cmpq	%rax, %rsi
	jnb	.L1055
	movl	0(%r13), %r8d
	cmpq	%rdi, %rdx
	je	.L1056
	leaq	-4(%rdi), %r10
	movq	%rdx, %rcx
	subq	%rdx, %r10
	movq	%r10, %r9
	shrq	$2, %r9
	leaq	1(%r9), %r11
	cmpq	$24, %r10
	jbe	.L1079
	movq	%r11, %r10
	vpbroadcastd	%r8d, %ymm0
	shrq	$3, %r10
	salq	$5, %r10
	leaq	(%r10,%rdx), %r12
	andl	$32, %r10d
	je	.L1058
	leaq	32(%rdx), %rcx
	vmovdqu	%ymm0, (%rdx)
	cmpq	%r12, %rcx
	je	.L1135
	.p2align 4,,10
	.p2align 3
.L1058:
	vmovdqu	%ymm0, (%rcx)
	addq	$64, %rcx
	vmovdqu	%ymm0, -32(%rcx)
	cmpq	%r12, %rcx
	jne	.L1058
.L1135:
	movq	%r11, %r10
	andq	$-8, %r10
	andl	$7, %r11d
	leaq	(%rdx,%r10,4), %rcx
	je	.L1059
.L1057:
	subq	%r10, %r9
	leaq	1(%r9), %r11
	cmpq	$2, %r9
	jbe	.L1060
	vpbroadcastd	%r8d, %xmm0
	vmovdqu	%xmm0, (%rdx,%r10,4)
	movq	%r11, %rdx
	andq	$-4, %rdx
	andl	$3, %r11d
	leaq	(%rcx,%rdx,4), %rcx
	je	.L1059
.L1060:
	leaq	4(%rcx), %rdx
	movl	%r8d, (%rcx)
	cmpq	%rdx, %rdi
	je	.L1059
	leaq	8(%rcx), %rdx
	movl	%r8d, 4(%rcx)
	cmpq	%rdx, %rdi
	je	.L1059
	movl	%r8d, 8(%rcx)
.L1059:
	movl	0(%r13), %r8d
.L1056:
	subq	%rsi, %rax
	salq	$2, %rax
	leaq	(%rdi,%rax), %rcx
	cmpq	%rcx, %rdi
	je	.L1066
	subq	$4, %rax
	movq	%rax, %rdx
	shrq	$2, %rdx
	leaq	1(%rdx), %r9
	cmpq	$24, %rax
	jbe	.L1080
	movq	%r9, %rsi
	vpbroadcastd	%r8d, %ymm0
	movq	%rdi, %rax
	shrq	$3, %rsi
	salq	$5, %rsi
	leaq	(%rsi,%rdi), %r10
	andl	$32, %esi
	je	.L1064
	leaq	32(%rdi), %rax
	vmovdqu	%ymm0, (%rdi)
	cmpq	%r10, %rax
	je	.L1134
	.p2align 4,,10
	.p2align 3
.L1064:
	vmovdqu	%ymm0, (%rax)
	addq	$64, %rax
	vmovdqu	%ymm0, -32(%rax)
	cmpq	%r10, %rax
	jne	.L1064
.L1134:
	movq	%r9, %rsi
	andq	$-8, %rsi
	andl	$7, %r9d
	leaq	(%rdi,%rsi,4), %rax
	je	.L1066
.L1063:
	subq	%rsi, %rdx
	leaq	1(%rdx), %r9
	cmpq	$2, %rdx
	jbe	.L1068
	movq	%r9, %rdx
	vpbroadcastd	%r8d, %xmm0
	andq	$-4, %rdx
	andl	$3, %r9d
	vmovdqu	%xmm0, (%rdi,%rsi,4)
	leaq	(%rax,%rdx,4), %rax
	je	.L1066
.L1068:
	leaq	4(%rax), %rdx
	movl	%r8d, (%rax)
	cmpq	%rdx, %rcx
	je	.L1066
	leaq	8(%rax), %rdx
	movl	%r8d, 4(%rax)
	cmpq	%rdx, %rcx
	je	.L1066
	movl	%r8d, 8(%rax)
.L1066:
	movq	%rcx, 8(%rbx)
	vzeroupper
.L1139:
	leaq	-24(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
	.p2align 4,,10
	.p2align 3
.L1055:
	.cfi_restore_state
	testq	%rax, %rax
	je	.L1070
	salq	$2, %rax
	movl	0(%r13), %r8d
	leaq	(%rdx,%rax), %r9
	cmpq	%r9, %rdx
	je	.L1071
	subq	$4, %rax
	movq	%rax, %rcx
	shrq	$2, %rcx
	leaq	1(%rcx), %r11
	cmpq	$24, %rax
	jbe	.L1081
	movq	%r11, %rsi
	vpbroadcastd	%r8d, %ymm0
	movq	%rdx, %rax
	shrq	$3, %rsi
	salq	$5, %rsi
	leaq	(%rsi,%rdx), %r10
	andl	$32, %esi
	je	.L1073
	leaq	32(%rdx), %rax
	vmovdqu	%ymm0, (%rdx)
	cmpq	%r10, %rax
	je	.L1136
	.p2align 4,,10
	.p2align 3
.L1073:
	vmovdqu	%ymm0, (%rax)
	addq	$64, %rax
	vmovdqu	%ymm0, -32(%rax)
	cmpq	%r10, %rax
	jne	.L1073
.L1136:
	movq	%r11, %r10
	andq	$-8, %r10
	andl	$7, %r11d
	leaq	(%rdx,%r10,4), %rax
	je	.L1142
	vzeroupper
.L1072:
	movq	%rcx, %rsi
	subq	%r10, %rsi
	leaq	1(%rsi), %rcx
	cmpq	$2, %rsi
	jbe	.L1075
	vpbroadcastd	%r8d, %xmm0
	vmovdqu	%xmm0, (%rdx,%r10,4)
	testb	$3, %cl
	je	.L1071
	andq	$-4, %rcx
	leaq	(%rax,%rcx,4), %rax
.L1075:
	leaq	4(%rax), %rdx
	movl	%r8d, (%rax)
	cmpq	%rdx, %r9
	je	.L1071
	leaq	8(%rax), %rdx
	movl	%r8d, 4(%rax)
	cmpq	%rdx, %r9
	je	.L1071
	movl	%r8d, 8(%rax)
.L1071:
	movq	%r9, %rdx
.L1070:
	cmpq	%rdx, %rdi
	je	.L1139
	movq	%rdx, 8(%rbx)
	leaq	-24(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
	.p2align 4,,10
	.p2align 3
.L1141:
	.cfi_restore_state
	movq	%rsi, %rdi
	shrq	$61, %rdi
	jne	.L1143
	leaq	0(,%rsi,4), %r12
	movq	%r12, %rdi
	call	_Znwm@PLT
	movl	0(%r13), %esi
	leaq	(%rax,%r12), %r8
	vmovq	%rax, %xmm2
	movq	%rax, %rdx
	leaq	-4(%r12), %rax
	vpinsrq	$1, %r8, %xmm2, %xmm1
	movq	%rax, %rcx
	shrq	$2, %rcx
	leaq	1(%rcx), %r9
	cmpq	$24, %rax
	jbe	.L1078
	movq	%r9, %rdi
	vpbroadcastd	%esi, %ymm0
	movq	%rdx, %rax
	shrq	$3, %rdi
	salq	$5, %rdi
	leaq	(%rdi,%rdx), %r10
	andl	$32, %edi
	je	.L1049
	leaq	32(%rdx), %rax
	vmovdqu	%ymm0, (%rdx)
	cmpq	%rax, %r10
	je	.L1133
	.p2align 4,,10
	.p2align 3
.L1049:
	vmovdqu	%ymm0, (%rax)
	addq	$64, %rax
	vmovdqu	%ymm0, -32(%rax)
	cmpq	%rax, %r10
	jne	.L1049
.L1133:
	movq	%r9, %rdi
	andq	$-8, %rdi
	andl	$7, %r9d
	leaq	(%rdx,%rdi,4), %rax
	je	.L1144
	vzeroupper
.L1048:
	subq	%rdi, %rcx
	leaq	1(%rcx), %r9
	cmpq	$2, %rcx
	jbe	.L1051
	vpbroadcastd	%esi, %xmm0
	vmovdqu	%xmm0, (%rdx,%rdi,4)
	movq	%r9, %rdx
	andq	$-4, %rdx
	andl	$3, %r9d
	leaq	(%rax,%rdx,4), %rax
	je	.L1050
.L1051:
	leaq	4(%rax), %rdx
	movl	%esi, (%rax)
	cmpq	%rdx, %r8
	je	.L1050
	leaq	8(%rax), %rdx
	movl	%esi, 4(%rax)
	cmpq	%rdx, %r8
	je	.L1050
	movl	%esi, 8(%rax)
.L1050:
	movq	(%rbx), %rdi
	movq	16(%rbx), %rsi
	vmovdqu	%xmm1, (%rbx)
	movq	%r8, 16(%rbx)
	testq	%rdi, %rdi
	je	.L1139
	leaq	-24(%rbp), %rsp
	subq	%rdi, %rsi
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	jmp	_ZdlPvm@PLT
	.p2align 4,,10
	.p2align 3
.L1144:
	.cfi_restore_state
	vzeroupper
	jmp	.L1050
	.p2align 4,,10
	.p2align 3
.L1078:
	movq	%rdx, %rax
	xorl	%edi, %edi
	jmp	.L1048
.L1079:
	xorl	%r10d, %r10d
	jmp	.L1057
.L1080:
	movq	%rdi, %rax
	xorl	%esi, %esi
	jmp	.L1063
.L1142:
	vzeroupper
	jmp	.L1071
.L1081:
	movq	%rdx, %rax
	xorl	%r10d, %r10d
	jmp	.L1072
.L1143:
	leaq	.LC5(%rip), %rdi
	call	_ZSt20__throw_length_errorPKc@PLT
	.cfi_endproc
.LFE8596:
	.size	_ZNSt6vectorIiSaIiEE14_M_fill_assignEmRKi, .-_ZNSt6vectorIiSaIiEE14_M_fill_assignEmRKi
	.section	.text._ZSt18__do_uninit_fill_nIPSt6vectorIiSaIiEEmS2_ET_S4_T0_RKT1_,"axG",@progbits,_ZSt18__do_uninit_fill_nIPSt6vectorIiSaIiEEmS2_ET_S4_T0_RKT1_,comdat
	.p2align 4
	.weak	_ZSt18__do_uninit_fill_nIPSt6vectorIiSaIiEEmS2_ET_S4_T0_RKT1_
	.type	_ZSt18__do_uninit_fill_nIPSt6vectorIiSaIiEEmS2_ET_S4_T0_RKT1_, @function
_ZSt18__do_uninit_fill_nIPSt6vectorIiSaIiEEmS2_ET_S4_T0_RKT1_:
.LFB8844:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA8844
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$24, %rsp
	.cfi_def_cfa_offset 80
	movq	%rdi, 8(%rsp)
	testq	%rsi, %rsi
	je	.L1159
	movq	(%rdx), %r14
	movq	%rsi, %r13
	movq	%rdx, %r12
	movq	%rdi, %rbp
	movabsq	$9223372036854775804, %r15
	jmp	.L1154
	.p2align 4,,10
	.p2align 3
.L1166:
	cmpq	%rbx, %r15
	jb	.L1165
	movq	%rbx, %rdi
.LEHB11:
	call	_Znwm@PLT
	movq	%rax, %rcx
.L1147:
	addq	%rcx, %rbx
	vpbroadcastq	%rcx, %xmm0
	movq	%rbx, 16(%rbp)
	vmovdqu	%xmm0, 0(%rbp)
	movq	(%r12), %r14
	movq	8(%r12), %rbx
	subq	%r14, %rbx
	cmpq	$4, %rbx
	jle	.L1150
	movq	%rcx, %rdi
	movq	%rbx, %rdx
	movq	%r14, %rsi
	call	memmove@PLT
	movq	%rax, %rcx
.L1151:
	addq	%rbx, %rcx
	addq	$24, %rbp
	movq	%rcx, -16(%rbp)
	decq	%r13
	je	.L1145
.L1154:
	movq	8(%r12), %rbx
	vpxor	%xmm0, %xmm0, %xmm0
	movq	$0, 16(%rbp)
	vmovdqu	%xmm0, 0(%rbp)
	subq	%r14, %rbx
	jne	.L1166
	xorl	%ecx, %ecx
	jmp	.L1147
	.p2align 4,,10
	.p2align 3
.L1159:
	movq	%rdi, %rbp
.L1145:
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	movq	%rbp, %rax
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L1150:
	.cfi_restore_state
	jne	.L1151
	movl	(%r14), %eax
	movl	%eax, (%rcx)
	jmp	.L1151
	.p2align 4,,10
	.p2align 3
.L1165:
	testq	%rbx, %rbx
	jns	.L1149
	call	_ZSt28__throw_bad_array_new_lengthv@PLT
	.p2align 4,,10
	.p2align 3
.L1149:
	call	_ZSt17__throw_bad_allocv@PLT
.LEHE11:
.L1161:
	endbr64
	movq	%rax, %rdi
.L1155:
	vzeroupper
	call	__cxa_begin_catch@PLT
.L1156:
	cmpq	%rbp, 8(%rsp)
	je	.L1167
	movq	8(%rsp), %rbx
	movq	%rbx, %rdi
	call	_ZNSt6vectorIiSaIiEED1Ev@PLT
	movq	%rbx, %rax
	addq	$24, %rax
	movq	%rax, 8(%rsp)
	jmp	.L1156
.L1167:
.LEHB12:
	call	__cxa_rethrow@PLT
.LEHE12:
.L1162:
	endbr64
	movq	%rax, %rbx
.L1158:
	vzeroupper
	call	__cxa_end_catch@PLT
	movq	%rbx, %rdi
.LEHB13:
	call	_Unwind_Resume@PLT
.LEHE13:
	.cfi_endproc
.LFE8844:
	.section	.gcc_except_table
	.align 4
.LLSDA8844:
	.byte	0xff
	.byte	0x9b
	.uleb128 .LLSDATT8844-.LLSDATTD8844
.LLSDATTD8844:
	.byte	0x1
	.uleb128 .LLSDACSE8844-.LLSDACSB8844
.LLSDACSB8844:
	.uleb128 .LEHB11-.LFB8844
	.uleb128 .LEHE11-.LEHB11
	.uleb128 .L1161-.LFB8844
	.uleb128 0x1
	.uleb128 .LEHB12-.LFB8844
	.uleb128 .LEHE12-.LEHB12
	.uleb128 .L1162-.LFB8844
	.uleb128 0
	.uleb128 .LEHB13-.LFB8844
	.uleb128 .LEHE13-.LEHB13
	.uleb128 0
	.uleb128 0
.LLSDACSE8844:
	.byte	0x1
	.byte	0
	.align 4
	.long	0

.LLSDATT8844:
	.section	.text._ZSt18__do_uninit_fill_nIPSt6vectorIiSaIiEEmS2_ET_S4_T0_RKT1_,"axG",@progbits,_ZSt18__do_uninit_fill_nIPSt6vectorIiSaIiEEmS2_ET_S4_T0_RKT1_,comdat
	.size	_ZSt18__do_uninit_fill_nIPSt6vectorIiSaIiEEmS2_ET_S4_T0_RKT1_, .-_ZSt18__do_uninit_fill_nIPSt6vectorIiSaIiEEmS2_ET_S4_T0_RKT1_
	.section	.text._ZNSt6vectorIS_IiSaIiEESaIS1_EE14_M_fill_assignEmRKS1_,"axG",@progbits,_ZNSt6vectorIS_IiSaIiEESaIS1_EE14_M_fill_assignEmRKS1_,comdat
	.align 2
	.p2align 4
	.weak	_ZNSt6vectorIS_IiSaIiEESaIS1_EE14_M_fill_assignEmRKS1_
	.type	_ZNSt6vectorIS_IiSaIiEESaIS1_EE14_M_fill_assignEmRKS1_, @function
_ZNSt6vectorIS_IiSaIiEESaIS1_EE14_M_fill_assignEmRKS1_:
.LFB8595:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA8595
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	movq	%rsi, %r15
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movq	%rdi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%rdx, %rbx
	movabsq	$-6148914691236517205, %rdx
	subq	$24, %rsp
	.cfi_def_cfa_offset 80
	movq	(%rdi), %r13
	movq	16(%rdi), %rax
	subq	%r13, %rax
	sarq	$3, %rax
	imulq	%rdx, %rax
	cmpq	%rsi, %rax
	jb	.L1241
	movq	8(%rdi), %r14
	movq	%r14, %rax
	subq	%r13, %rax
	sarq	$3, %rax
	imulq	%rdx, %rax
	cmpq	%rsi, %rax
	jnb	.L1179
	cmpq	%r14, %r13
	jne	.L1199
	jmp	.L1180
	.p2align 4,,10
	.p2align 3
.L1182:
	movq	8(%r13), %rax
	movq	%rax, %rdx
	subq	%rdi, %rdx
	cmpq	%rbp, %rdx
	jnb	.L1242
	cmpq	$4, %rdx
	jle	.L1192
	call	memmove@PLT
	movq	8(%r13), %rax
	movq	0(%r13), %rdi
	movq	8(%rbx), %r9
	movq	(%rbx), %rsi
	movq	%rax, %rdx
	subq	%rdi, %rdx
.L1193:
	addq	%rdx, %rsi
	movq	%r9, %rdx
	subq	%rsi, %rdx
	cmpq	$4, %rdx
	jle	.L1196
	movq	%rax, %rdi
	call	memmove@PLT
	addq	0(%r13), %rbp
.L1188:
	movq	%rbp, 8(%r13)
.L1181:
	addq	$24, %r13
	cmpq	%r13, %r14
	je	.L1243
.L1199:
	cmpq	%r13, %rbx
	je	.L1181
	movq	8(%rbx), %r9
	movq	(%rbx), %rsi
	movq	0(%r13), %rdi
	movq	16(%r13), %rax
	movq	%r9, %rbp
	subq	%rsi, %rbp
	subq	%rdi, %rax
	cmpq	%rbp, %rax
	jnb	.L1182
	movabsq	$9223372036854775804, %rax
	cmpq	%rbp, %rax
	jb	.L1244
	movq	%rbp, %rdi
	movq	%rsi, 8(%rsp)
.LEHB14:
	call	_Znwm@PLT
	cmpq	$4, %rbp
	movq	8(%rsp), %rsi
	movq	%rax, (%rsp)
	jle	.L1185
	movq	%rbp, %rdx
	movq	%rax, %rdi
	call	memmove@PLT
.L1186:
	movq	0(%r13), %rdi
	testq	%rdi, %rdi
	je	.L1187
	movq	16(%r13), %rsi
	subq	%rdi, %rsi
	call	_ZdlPvm@PLT
.L1187:
	movq	(%rsp), %rax
	addq	%rax, %rbp
	movq	%rax, 0(%r13)
	movq	%rbp, 16(%r13)
	jmp	.L1188
	.p2align 4,,10
	.p2align 3
.L1179:
	testq	%rsi, %rsi
	je	.L1200
	leaq	(%rsi,%rsi,2), %rax
	leaq	0(%r13,%rax,8), %rbp
	cmpq	%rbp, %r13
	jne	.L1219
	.p2align 4,,10
	.p2align 3
.L1200:
	cmpq	%r14, %r13
	je	.L1239
.L1249:
	movq	%r13, %rbx
	.p2align 4,,10
	.p2align 3
.L1223:
	movq	(%rbx), %rdi
	testq	%rdi, %rdi
	je	.L1220
	movq	16(%rbx), %rsi
	addq	$24, %rbx
	subq	%rdi, %rsi
	call	_ZdlPvm@PLT
	cmpq	%rbx, %r14
	jne	.L1223
.L1222:
	movq	%r13, 8(%r12)
.L1239:
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L1202:
	.cfi_restore_state
	movq	8(%r13), %r8
	movq	%r8, %rdx
	subq	%rdi, %rdx
	cmpq	%r15, %rdx
	jnb	.L1245
	cmpq	$4, %rdx
	jle	.L1212
	call	memmove@PLT
	movq	8(%r13), %r8
	movq	0(%r13), %rdi
	movq	8(%rbx), %rax
	movq	(%rbx), %rsi
	movq	%r8, %rdx
	subq	%rdi, %rdx
.L1213:
	addq	%rdx, %rsi
	subq	%rsi, %rax
	movq	%rax, %rdx
	cmpq	$4, %rax
	jle	.L1216
	movq	%r8, %rdi
	call	memmove@PLT
	movq	0(%r13), %rdi
	addq	%r15, %rdi
.L1208:
	movq	%rdi, 8(%r13)
.L1201:
	addq	$24, %r13
	cmpq	%r13, %rbp
	je	.L1246
.L1219:
	cmpq	%r13, %rbx
	je	.L1201
	movq	8(%rbx), %rax
	movq	(%rbx), %rsi
	movq	0(%r13), %rdi
	movq	16(%r13), %rdx
	movq	%rax, %r15
	subq	%rsi, %r15
	subq	%rdi, %rdx
	cmpq	%r15, %rdx
	jnb	.L1202
	movabsq	$9223372036854775804, %rax
	cmpq	%r15, %rax
	jb	.L1247
	movq	%r15, %rdi
	movq	%rsi, (%rsp)
	call	_Znwm@PLT
	cmpq	$4, %r15
	movq	(%rsp), %rsi
	movq	%rax, %r14
	jle	.L1205
	movq	%r15, %rdx
	movq	%rax, %rdi
	call	memmove@PLT
.L1206:
	movq	0(%r13), %rdi
	testq	%rdi, %rdi
	je	.L1207
	movq	16(%r13), %rsi
	subq	%rdi, %rsi
	call	_ZdlPvm@PLT
.L1207:
	leaq	(%r14,%r15), %rdi
	movq	%r14, 0(%r13)
	movq	%rdi, 16(%r13)
	jmp	.L1208
	.p2align 4,,10
	.p2align 3
.L1242:
	cmpq	$4, %rbp
	jle	.L1190
	movq	%rbp, %rdx
	call	memmove@PLT
	addq	0(%r13), %rbp
	jmp	.L1188
	.p2align 4,,10
	.p2align 3
.L1241:
	movabsq	$384307168202282325, %rax
	cmpq	%rsi, %rax
	jb	.L1248
	leaq	(%rsi,%rsi,2), %rax
	leaq	0(,%rax,8), %r13
	movq	%r13, %rdi
	call	_Znwm@PLT
.LEHE14:
	movq	%rbx, %rdx
	movq	%r15, %rsi
	movq	%rax, %rdi
	movq	%rax, %rbp
	leaq	(%rax,%r13), %r14
.LEHB15:
	call	_ZSt18__do_uninit_fill_nIPSt6vectorIiSaIiEEmS2_ET_S4_T0_RKT1_@PLT
.LEHE15:
	movq	(%r12), %r13
	vmovq	%rbp, %xmm1
	movq	8(%r12), %rbx
	vpinsrq	$1, %rax, %xmm1, %xmm0
	movq	16(%r12), %r15
	movq	%r14, 16(%r12)
	vmovdqu	%xmm0, (%r12)
	movq	%r13, %rbp
	cmpq	%rbx, %r13
	je	.L1177
	.p2align 4,,10
	.p2align 3
.L1171:
	movq	0(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L1175
	movq	16(%rbp), %rsi
	addq	$24, %rbp
	subq	%rdi, %rsi
	call	_ZdlPvm@PLT
	cmpq	%rbp, %rbx
	jne	.L1171
.L1177:
	testq	%r13, %r13
	je	.L1239
.L1172:
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	movq	%r15, %rsi
	movq	%r13, %rdi
	popq	%rbx
	.cfi_def_cfa_offset 48
	subq	%r13, %rsi
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	jmp	_ZdlPvm@PLT
	.p2align 4,,10
	.p2align 3
.L1175:
	.cfi_restore_state
	addq	$24, %rbp
	cmpq	%rbp, %rbx
	jne	.L1171
	testq	%r13, %r13
	jne	.L1172
	jmp	.L1239
	.p2align 4,,10
	.p2align 3
.L1243:
	movq	8(%r12), %r14
	movabsq	$-6148914691236517205, %rdx
	movq	%r14, %rax
	subq	(%r12), %rax
	sarq	$3, %rax
	imulq	%rdx, %rax
.L1180:
	movq	%r15, %rsi
	movq	%rbx, %rdx
	movq	%r14, %rdi
	subq	%rax, %rsi
.LEHB16:
	call	_ZSt18__do_uninit_fill_nIPSt6vectorIiSaIiEEmS2_ET_S4_T0_RKT1_@PLT
	movq	%rax, 8(%r12)
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L1245:
	.cfi_restore_state
	cmpq	$4, %r15
	jle	.L1210
	movq	%r15, %rdx
	call	memmove@PLT
	movq	0(%r13), %rdi
	addq	%r15, %rdi
	jmp	.L1208
	.p2align 4,,10
	.p2align 3
.L1220:
	addq	$24, %rbx
	cmpq	%rbx, %r14
	jne	.L1223
	jmp	.L1222
	.p2align 4,,10
	.p2align 3
.L1246:
	movq	8(%r12), %r14
	cmpq	%r14, %r13
	jne	.L1249
	jmp	.L1239
	.p2align 4,,10
	.p2align 3
.L1196:
	jne	.L1191
	movl	(%rsi), %edx
	movl	%edx, (%rax)
.L1191:
	addq	%rdi, %rbp
	jmp	.L1188
	.p2align 4,,10
	.p2align 3
.L1192:
	jne	.L1193
	movl	(%rsi), %r10d
	movl	%r10d, (%rdi)
	jmp	.L1193
	.p2align 4,,10
	.p2align 3
.L1216:
	je	.L1217
.L1211:
	addq	%r15, %rdi
	jmp	.L1208
	.p2align 4,,10
	.p2align 3
.L1212:
	jne	.L1213
	movl	(%rsi), %r9d
	movl	%r9d, (%rdi)
	jmp	.L1213
.L1247:
	testq	%r15, %r15
	jns	.L1184
.L1204:
	call	_ZSt28__throw_bad_array_new_lengthv@PLT
.L1217:
	movl	(%rsi), %eax
	movl	%eax, (%r8)
	jmp	.L1211
	.p2align 4,,10
	.p2align 3
.L1190:
	jne	.L1191
	movl	(%rsi), %eax
	movl	%eax, (%rdi)
	jmp	.L1191
	.p2align 4,,10
	.p2align 3
.L1244:
	testq	%rbp, %rbp
	js	.L1204
.L1184:
	call	_ZSt17__throw_bad_allocv@PLT
.L1210:
	jne	.L1211
	movl	(%rsi), %eax
	movl	%eax, (%rdi)
	jmp	.L1211
	.p2align 4,,10
	.p2align 3
.L1185:
	movq	%rax, %rcx
	movl	(%rsi), %eax
	movl	%eax, (%rcx)
	jmp	.L1186
.L1205:
	movl	(%rsi), %eax
	movl	%eax, (%r14)
	jmp	.L1206
.L1248:
	leaq	.LC5(%rip), %rdi
	call	_ZSt20__throw_length_errorPKc@PLT
.L1226:
	endbr64
	movq	%rax, %rbx
.L1174:
	movq	%rbp, %rdi
	movq	%r13, %rsi
	vzeroupper
	call	_ZdlPvm@PLT
	movq	%rbx, %rdi
	call	_Unwind_Resume@PLT
.LEHE16:
	.cfi_endproc
.LFE8595:
	.section	.gcc_except_table
.LLSDA8595:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8595-.LLSDACSB8595
.LLSDACSB8595:
	.uleb128 .LEHB14-.LFB8595
	.uleb128 .LEHE14-.LEHB14
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB15-.LFB8595
	.uleb128 .LEHE15-.LEHB15
	.uleb128 .L1226-.LFB8595
	.uleb128 0
	.uleb128 .LEHB16-.LFB8595
	.uleb128 .LEHE16-.LEHB16
	.uleb128 0
	.uleb128 0
.LLSDACSE8595:
	.section	.text._ZNSt6vectorIS_IiSaIiEESaIS1_EE14_M_fill_assignEmRKS1_,"axG",@progbits,_ZNSt6vectorIS_IiSaIiEESaIS1_EE14_M_fill_assignEmRKS1_,comdat
	.size	_ZNSt6vectorIS_IiSaIiEESaIS1_EE14_M_fill_assignEmRKS1_, .-_ZNSt6vectorIS_IiSaIiEESaIS1_EE14_M_fill_assignEmRKS1_
	.section	.text.unlikely
.LCOLDB16:
	.text
.LHOTB16:
	.p2align 4
	.globl	pfi_setup
	.type	pfi_setup, @function
pfi_setup:
.LFB8368:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA8368
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	movl	%esi, %eax
	movq	%rdx, %rsi
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	movq	%rcx, %r13
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	movslq	%r9d, %rbp
	leaq	0(,%rbp,4), %r12
	movq	%rbp, %r14
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%r8, %rbx
	subq	$88, %rsp
	.cfi_def_cfa_offset 144
	movl	144(%rsp), %ecx
	vmovss	%xmm0, 20(%rsp)
	vmovss	%xmm1, 40(%rsp)
	movl	%ecx, 16(%rsp)
	movq	%fs:40, %rdx
	movq	%rdx, 72(%rsp)
	xorl	%edx, %edx
	movl	%edi, 200+_ZN12_GLOBAL__N_11HE(%rip)
	movq	8+_ZN12_GLOBAL__N_11HE(%rip), %rdi
	movl	%eax, _ZN12_GLOBAL__N_11HE(%rip)
	movq	24+_ZN12_GLOBAL__N_11HE(%rip), %rax
	subq	%rdi, %rax
	cmpq	%r12, %rax
	jnb	.L1251
	movabsq	$9223372036854775804, %rax
	cmpq	%r12, %rax
	jb	.L1273
	movq	%r12, %rdi
	movq	%rsi, (%rsp)
.LEHB17:
	call	_Znwm@PLT
.LEHE17:
	cmpq	$4, %r12
	movq	(%rsp), %rsi
	movq	%rax, %r15
	jle	.L1254
	movq	%r12, %rdx
	movq	%rax, %rdi
	call	memcpy@PLT
.L1255:
	movq	8+_ZN12_GLOBAL__N_11HE(%rip), %rdi
	testq	%rdi, %rdi
	je	.L1256
	movq	24+_ZN12_GLOBAL__N_11HE(%rip), %rsi
	subq	%rdi, %rsi
	call	_ZdlPvm@PLT
.L1256:
	leaq	(%r15,%r12), %rax
	vmovq	%r15, %xmm3
	movq	%rax, 24+_ZN12_GLOBAL__N_11HE(%rip)
	vpinsrq	$1, %rax, %xmm3, %xmm0
	vmovdqu	%xmm0, 8+_ZN12_GLOBAL__N_11HE(%rip)
.L1257:
	vpxor	%xmm0, %xmm0, %xmm0
	leaq	48(%rsp), %rdx
	movq	%rbp, %rsi
	movq	$0, 64(%rsp)
	leaq	32+_ZN12_GLOBAL__N_11HE(%rip), %rdi
	movq	%rdx, 24(%rsp)
	vmovdqa	%xmm0, 48(%rsp)
.LEHB18:
	call	_ZNSt6vectorIS_IiSaIiEESaIS1_EE14_M_fill_assignEmRKS1_@PLT
.LEHE18:
	leaq	(%rbx,%r12), %rax
	movq	%rbx, %r15
	xorl	%ebx, %ebx
	movq	%rax, (%rsp)
	testl	%r14d, %r14d
	jle	.L1290
	movq	%rbp, 32(%rsp)
	movq	%r15, %rbp
	movl	%r14d, 44(%rsp)
	jmp	.L1289
	.p2align 4,,10
	.p2align 3
.L1311:
	movabsq	$9223372036854775804, %rax
	movq	%rsi, 8(%rsp)
	cmpq	%r15, %rax
	jb	.L1273
	movq	%r15, %rdi
.LEHB19:
	call	_Znwm@PLT
	cmpq	$4, %r15
	movq	8(%rsp), %rsi
	movq	%rax, %r12
	jle	.L1274
	movq	%r15, %rdx
	movq	%rax, %rdi
	call	memcpy@PLT
.L1275:
	movq	(%r14), %rdi
	testq	%rdi, %rdi
	je	.L1276
	movq	16(%r14), %rsi
	subq	%rdi, %rsi
	call	_ZdlPvm@PLT
.L1276:
	leaq	(%r12,%r15), %rdx
	vmovq	%r12, %xmm2
	movq	%rdx, 16(%r14)
	vpinsrq	$1, %rdx, %xmm2, %xmm0
	vmovdqu	%xmm0, (%r14)
.L1277:
	movq	(%rsp), %rax
	addq	$4, %rbp
	addq	$24, %rbx
	cmpq	%rax, %rbp
	je	.L1310
.L1289:
	movslq	4(%rbp), %r12
	movq	32+_ZN12_GLOBAL__N_11HE(%rip), %r14
	movslq	0(%rbp), %rax
	salq	$2, %r12
	addq	%rbx, %r14
	salq	$2, %rax
	movq	%r12, %r15
	movq	(%r14), %rdi
	leaq	0(%r13,%rax), %rsi
	subq	%rax, %r15
	movq	16(%r14), %rax
	subq	%rdi, %rax
	cmpq	%r15, %rax
	jb	.L1311
	movq	8(%r14), %r9
	movq	%r9, %rax
	subq	%rdi, %rax
	cmpq	%r15, %rax
	jb	.L1278
	cmpq	$4, %r15
	jle	.L1279
	movq	%r15, %rdx
	call	memmove@PLT
	movq	8(%r14), %r9
	movq	%rax, %rdi
.L1280:
	leaq	(%rdi,%r15), %rdx
	cmpq	%rdx, %r9
	je	.L1277
	movq	%rdx, 8(%r14)
	jmp	.L1277
	.p2align 4,,10
	.p2align 3
.L1251:
	movq	16+_ZN12_GLOBAL__N_11HE(%rip), %r8
	movq	%r8, %rdx
	subq	%rdi, %rdx
	cmpq	%r12, %rdx
	jnb	.L1312
	leaq	(%rsi,%rdx), %rax
	movq	%rax, (%rsp)
	cmpq	$4, %rdx
	jle	.L1263
	movq	%rdx, 8(%rsp)
	call	memmove@PLT
	movq	16+_ZN12_GLOBAL__N_11HE(%rip), %r8
	movq	8(%rsp), %rdx
.L1264:
	movq	%r12, %r15
	subq	%rdx, %r15
	cmpq	$4, %r15
	jle	.L1267
	movq	(%rsp), %rsi
	movq	%r8, %rdi
	movq	%r15, %rdx
	call	memmove@PLT
	movq	%rax, %r8
.L1268:
	leaq	(%r8,%r15), %rax
	movq	%rax, 16+_ZN12_GLOBAL__N_11HE(%rip)
	jmp	.L1257
	.p2align 4,,10
	.p2align 3
.L1312:
	cmpq	$4, %r12
	jle	.L1259
	movq	%r12, %rdx
	call	memmove@PLT
	movq	16+_ZN12_GLOBAL__N_11HE(%rip), %r8
	movq	%rax, %rdi
.L1260:
	addq	%r12, %rdi
	cmpq	%r8, %rdi
	je	.L1257
	movq	%rdi, 16+_ZN12_GLOBAL__N_11HE(%rip)
	jmp	.L1257
	.p2align 4,,10
	.p2align 3
.L1278:
	leaq	(%rsi,%rax), %r10
	cmpq	$4, %rax
	jle	.L1283
	movq	%rax, %rdx
	movq	%r10, 8(%rsp)
	call	memmove@PLT
	movq	8(%r14), %r9
	movq	8(%rsp), %r10
.L1284:
	addq	%r13, %r12
	subq	%r10, %r12
	cmpq	$4, %r12
	jle	.L1287
	movq	%r9, %rdi
	movq	%r12, %rdx
	movq	%r10, %rsi
	call	memmove@PLT
	movq	%rax, %r9
.L1288:
	addq	%r12, %r9
	movq	%r9, 8(%r14)
	jmp	.L1277
	.p2align 4,,10
	.p2align 3
.L1310:
	movq	32(%rsp), %rbp
	movl	44(%rsp), %r14d
.L1290:
	vmovss	20(%rsp), %xmm5
	movq	24(%rsp), %rbx
	movq	%rbp, %rsi
	leaq	152+_ZN12_GLOBAL__N_11HE(%rip), %rdi
	vmovss	.LC14(%rip), %xmm0
	movl	$0, 48(%rsp)
	movq	%rbx, %rdx
	vdivss	40(%rsp), %xmm0, %xmm0
	vunpcklps	%xmm0, %xmm5, %xmm0
	vmovlps	%xmm0, 56+_ZN12_GLOBAL__N_11HE(%rip)
	call	_ZNSt6vectorIiSaIiEE14_M_fill_assignEmRKi@PLT
	leal	1(%r14), %esi
	movq	%rbx, %rdx
	leaq	176+_ZN12_GLOBAL__N_11HE(%rip), %rdi
	movslq	%esi, %rsi
	movl	$0, 48(%rsp)
	call	_ZNSt6vectorIiSaIiEE14_M_fill_assignEmRKi@PLT
	movl	16(%rsp), %eax
	cmpl	64+_ZN12_GLOBAL__N_11HE(%rip), %eax
	jle	.L1313
	movq	72(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L1309
	movl	16(%rsp), %edi
	addq	$88, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	jmp	_ZN12_GLOBAL__N_114ensure_scratchEi.part.0
	.p2align 4,,10
	.p2align 3
.L1313:
	.cfi_restore_state
	movq	72(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L1309
	addq	$88, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L1279:
	.cfi_restore_state
	jne	.L1280
	movl	(%rsi), %eax
	movl	%eax, (%rdi)
	jmp	.L1280
	.p2align 4,,10
	.p2align 3
.L1287:
	jne	.L1288
	movl	(%r10), %eax
	movl	%eax, (%r9)
	jmp	.L1288
	.p2align 4,,10
	.p2align 3
.L1283:
	jne	.L1284
	movl	(%rsi), %eax
	movl	%eax, (%rdi)
	jmp	.L1284
.L1274:
	movl	(%rsi), %eax
	movl	%eax, (%r12)
	jmp	.L1275
.L1259:
	jne	.L1260
	movl	(%rsi), %eax
	movl	%eax, (%rdi)
	jmp	.L1260
.L1263:
	jne	.L1264
	movl	(%rsi), %eax
	movl	%eax, (%rdi)
	jmp	.L1264
.L1267:
	jne	.L1268
	movq	(%rsp), %rax
	movl	(%rax), %eax
	movl	%eax, (%r8)
	jmp	.L1268
.L1254:
	movl	(%rsi), %eax
	movl	%eax, (%r15)
	jmp	.L1255
.L1273:
	movq	72(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L1309
	leaq	.LC5(%rip), %rdi
	call	_ZSt20__throw_length_errorPKc@PLT
.LEHE19:
.L1309:
	call	__stack_chk_fail@PLT
.L1295:
	endbr64
	movq	%rax, %rbx
	jmp	.L1292
	.section	.gcc_except_table
.LLSDA8368:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8368-.LLSDACSB8368
.LLSDACSB8368:
	.uleb128 .LEHB17-.LFB8368
	.uleb128 .LEHE17-.LEHB17
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB18-.LFB8368
	.uleb128 .LEHE18-.LEHB18
	.uleb128 .L1295-.LFB8368
	.uleb128 0
	.uleb128 .LEHB19-.LFB8368
	.uleb128 .LEHE19-.LEHB19
	.uleb128 0
	.uleb128 0
.LLSDACSE8368:
	.text
	.cfi_endproc
	.section	.text.unlikely
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDAC8368
	.type	pfi_setup.cold, @function
pfi_setup.cold:
.LFSB8368:
.L1292:
	.cfi_def_cfa_offset 144
	.cfi_offset 3, -56
	.cfi_offset 6, -48
	.cfi_offset 12, -40
	.cfi_offset 13, -32
	.cfi_offset 14, -24
	.cfi_offset 15, -16
	movq	24(%rsp), %rdi
	vzeroupper
	call	_ZNSt6vectorIiSaIiEED1Ev@PLT
	movq	72(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L1314
	movq	%rbx, %rdi
.LEHB20:
	call	_Unwind_Resume@PLT
.LEHE20:
.L1314:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE8368:
	.section	.gcc_except_table
.LLSDAC8368:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC8368-.LLSDACSBC8368
.LLSDACSBC8368:
	.uleb128 .LEHB20-.LCOLDB16
	.uleb128 .LEHE20-.LEHB20
	.uleb128 0
	.uleb128 0
.LLSDACSEC8368:
	.section	.text.unlikely
	.text
	.size	pfi_setup, .-pfi_setup
	.section	.text.unlikely
	.size	pfi_setup.cold, .-pfi_setup.cold
.LCOLDE16:
	.text
.LHOTE16:
	.section	.text.startup,"ax",@progbits
	.p2align 4
	.type	_GLOBAL__sub_I_hpc_cpu.cpp, @function
_GLOBAL__sub_I_hpc_cpu.cpp:
.LFB8938:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	vpxor	%xmm1, %xmm1, %xmm1
	leaq	_ZN12_GLOBAL__N_18g_modelsE(%rip), %rsi
	leaq	_ZNSt6vectorIN12_GLOBAL__N_15ModelESaIS1_EED1Ev(%rip), %rdi
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	.cfi_offset 3, -24
	leaq	__dso_handle(%rip), %rbx
	movq	%rbx, %rdx
	subq	$8, %rsp
	vmovdqa	%xmm1, _ZN12_GLOBAL__N_18g_modelsE(%rip)
	movq	$0, 16+_ZN12_GLOBAL__N_18g_modelsE(%rip)
	call	__cxa_atexit@PLT
	movl	$-1, _ZN12_GLOBAL__N_11HE(%rip)
	movq	.LC17(%rip), %rax
	vpxor	%xmm0, %xmm0, %xmm0
	vpxor	%xmm1, %xmm1, %xmm1
	movl	$0, 64+_ZN12_GLOBAL__N_11HE(%rip)
	movq	%rbx, %rdx
	leaq	_ZN12_GLOBAL__N_11HE(%rip), %rsi
	movq	%rax, 56+_ZN12_GLOBAL__N_11HE(%rip)
	leaq	_ZN12_GLOBAL__N_14HierD1Ev(%rip), %rdi
	movl	$-1, 200+_ZN12_GLOBAL__N_11HE(%rip)
	vmovdqu	%ymm0, 8+_ZN12_GLOBAL__N_11HE(%rip)
	vmovdqu	%xmm1, 40+_ZN12_GLOBAL__N_11HE(%rip)
	vmovdqu	%ymm0, 72+_ZN12_GLOBAL__N_11HE(%rip)
	vmovdqu	%ymm0, 104+_ZN12_GLOBAL__N_11HE(%rip)
	vmovdqu	%ymm0, 136+_ZN12_GLOBAL__N_11HE(%rip)
	vmovdqu	%ymm0, 168+_ZN12_GLOBAL__N_11HE(%rip)
	vzeroupper
	addq	$8, %rsp
	popq	%rbx
	popq	%rbp
	.cfi_def_cfa 7, 8
	jmp	__cxa_atexit@PLT
	.cfi_endproc
.LFE8938:
	.size	_GLOBAL__sub_I_hpc_cpu.cpp, .-_GLOBAL__sub_I_hpc_cpu.cpp
	.section	.init_array,"aw"
	.align 8
	.quad	_GLOBAL__sub_I_hpc_cpu.cpp
	.local	_ZN12_GLOBAL__N_11HE
	.comm	_ZN12_GLOBAL__N_11HE,208,32
	.data
	.align 4
	.type	_ZN12_GLOBAL__N_18g_kernelE, @object
	.size	_ZN12_GLOBAL__N_18g_kernelE, 4
_ZN12_GLOBAL__N_18g_kernelE:
	.long	3
	.local	_ZN12_GLOBAL__N_18g_modelsE
	.comm	_ZN12_GLOBAL__N_18g_modelsE,24,16
	.section	.rodata.cst4,"aM",@progbits,4
	.align 4
.LC3:
	.long	998277249
	.section	.rodata.cst32,"aM",@progbits,32
	.align 32
.LC10:
	.long	0
	.long	2
	.long	4
	.long	6
	.long	8
	.long	10
	.long	12
	.long	14
	.section	.rodata.cst16,"aM",@progbits,16
	.align 16
.LC11:
	.long	784
	.long	0
	.long	0
	.long	0
	.set	.LC14,.LC17+4
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC17:
	.long	0
	.long	1065353216
	.hidden	DW.ref.__gxx_personality_v0
	.weak	DW.ref.__gxx_personality_v0
	.section	.data.rel.local.DW.ref.__gxx_personality_v0,"awG",@progbits,DW.ref.__gxx_personality_v0,comdat
	.align 8
	.type	DW.ref.__gxx_personality_v0, @object
	.size	DW.ref.__gxx_personality_v0, 8
DW.ref.__gxx_personality_v0:
	.quad	__gxx_personality_v0
	.hidden	__dso_handle
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
