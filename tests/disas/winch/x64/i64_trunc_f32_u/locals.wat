;;! target = "x86_64"
;;! test = "winch"

(module
    (func (result i64)
        (local f32)  

        (local.get 0)
        (i64.trunc_f32_u)
    )
)
;; wasm[0]::function[0]:
;;       pushq   %rbp
;;       movq    %rsp, %rbp
;;       movq    8(%rdi), %r11
;;       movq    0x10(%r11), %r11
;;       addq    $0x20, %r11
;;       cmpq    %rsp, %r11
;;       ja      0x90
;;   1c: movq    %rdi, %r14
;;       subq    $0x20, %rsp
;;       movq    %rdi, 0x18(%rsp)
;;       movq    %rsi, 0x10(%rsp)
;;       movq    $0, 8(%rsp)
;;       movss   0xc(%rsp), %xmm1
;;       movl    $0x5f000000, %r11d
;;       movd    %r11d, %xmm15
;;       ucomiss %xmm15, %xmm1
;;       jae     0x63
;;       jp      0x92
;;   56: cvttss2si %xmm1, %rax
;;       cmpq    $0, %rax
;;       jge     0x87
;;   61: ud2
;;       movaps  %xmm1, %xmm0
;;       subss   %xmm15, %xmm0
;;       cvttss2si %xmm0, %rax
;;       cmpq    $0, %rax
;;       jl      0x94
;;   7a: movabsq $9223372036854775808, %r11
;;       addq    %r11, %rax
;;       addq    $0x20, %rsp
;;       popq    %rbp
;;       retq
;;   90: ud2
;;   92: ud2
;;   94: ud2
