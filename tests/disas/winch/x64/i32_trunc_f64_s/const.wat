;;! target = "x86_64"
;;! test = "winch"

(module
    (func (result i32)
        (f64.const 1.0)
        (i32.trunc_f64_s)
    )
)
;; wasm[0]::function[0]:
;;       pushq   %rbp
;;       movq    %rsp, %rbp
;;       movq    8(%rdi), %r11
;;       movq    0x10(%r11), %r11
;;       addq    $0x10, %r11
;;       cmpq    %rsp, %r11
;;       ja      0x7d
;;   1c: movq    %rdi, %r14
;;       subq    $0x10, %rsp
;;       movq    %rdi, 8(%rsp)
;;       movq    %rsi, (%rsp)
;;       movsd   0x51(%rip), %xmm0
;;       cvttsd2si %xmm0, %eax
;;       cmpl    $1, %eax
;;       jno     0x74
;;   40: ucomisd %xmm0, %xmm0
;;       jp      0x7f
;;   4a: movabsq $13970166044105375744, %r11
;;       movq    %r11, %xmm15
;;       ucomisd %xmm15, %xmm0
;;       jbe     0x81
;;   64: xorpd   %xmm15, %xmm15
;;       ucomisd %xmm0, %xmm15
;;       jb      0x83
;;   74: addq    $0x10, %rsp
;;       popq    %rbp
;;       retq
;;   7d: ud2
;;   7f: ud2
;;   81: ud2
;;   83: ud2
;;   85: addb    %al, (%rax)
;;   87: addb    %al, (%rax)
;;   89: addb    %al, (%rax)
;;   8b: addb    %al, (%rax)
;;   8d: addb    %dh, %al
