;;! target = "riscv64"
;;! test = "compile"
;;! flags = " -C cranelift-enable-heap-access-spectre-mitigation -W memory64 -O static-memory-maximum-size=0 -O static-memory-guard-size=0 -O dynamic-memory-guard-size=0"

;; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;; !!! GENERATED BY 'make-load-store-tests.sh' DO NOT EDIT !!!
;; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

(module
  (memory i64 1)

  (func (export "do_store") (param i64 i32)
    local.get 0
    local.get 1
    i32.store8 offset=0xffff0000)

  (func (export "do_load") (param i64) (result i32)
    local.get 0
    i32.load8_u offset=0xffff0000))

;; wasm[0]::function[0]:
;;       addi    sp, sp, -0x10
;;       sd      ra, 8(sp)
;;       sd      s0, 0(sp)
;;       mv      s0, sp
;;       auipc   a4, 0
;;       ld      a4, 0x50(a4)
;;       add     a4, a2, a4
;;       bgeu    a4, a2, 8
;;       .byte   0x00, 0x00, 0x00, 0x00
;;       ld      a5, 0x40(a0)
;;       ld      a0, 0x38(a0)
;;       sltu    a4, a5, a4
;;       add     a5, a0, a2
;;       lui     a0, 0xffff
;;       slli    a0, a0, 4
;;       add     a5, a5, a0
;;       neg     a2, a4
;;       not     a4, a2
;;       and     a0, a5, a4
;;       sb      a3, 0(a0)
;;       ld      ra, 8(sp)
;;       ld      s0, 0(sp)
;;       addi    sp, sp, 0x10
;;       ret
;;       .byte   0x01, 0x00, 0xff, 0xff
;;       .byte   0x00, 0x00, 0x00, 0x00
;;
;; wasm[0]::function[1]:
;;       addi    sp, sp, -0x10
;;       sd      ra, 8(sp)
;;       sd      s0, 0(sp)
;;       mv      s0, sp
;;       auipc   a3, 0
;;       ld      a3, 0x50(a3)
;;       add     a3, a2, a3
;;       bgeu    a3, a2, 8
;;       .byte   0x00, 0x00, 0x00, 0x00
;;       ld      a4, 0x40(a0)
;;       ld      a5, 0x38(a0)
;;       sltu    a4, a4, a3
;;       add     a5, a5, a2
;;       lui     a3, 0xffff
;;       slli    a0, a3, 4
;;       add     a5, a5, a0
;;       neg     a2, a4
;;       not     a4, a2
;;       and     a0, a5, a4
;;       lbu     a0, 0(a0)
;;       ld      ra, 8(sp)
;;       ld      s0, 0(sp)
;;       addi    sp, sp, 0x10
;;       ret
;;       .byte   0x01, 0x00, 0xff, 0xff
;;       .byte   0x00, 0x00, 0x00, 0x00
