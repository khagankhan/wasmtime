;;! target = "riscv64"
;;! test = "compile"
;;! flags = " -C cranelift-enable-heap-access-spectre-mitigation -O static-memory-maximum-size=0 -O static-memory-guard-size=4294967295 -O dynamic-memory-guard-size=4294967295"

;; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;; !!! GENERATED BY 'make-load-store-tests.sh' DO NOT EDIT !!!
;; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

(module
  (memory i32 1)

  (func (export "do_store") (param i32 i32)
    local.get 0
    local.get 1
    i32.store8 offset=0x1000)

  (func (export "do_load") (param i32) (result i32)
    local.get 0
    i32.load8_u offset=0x1000))

;; wasm[0]::function[0]:
;;       addi    sp, sp, -0x10
;;       sd      ra, 8(sp)
;;       sd      s0, 0(sp)
;;       mv      s0, sp
;;       ld      a5, 0x40(a0)
;;       ld      a4, 0x38(a0)
;;       slli    a1, a2, 0x20
;;       srli    a0, a1, 0x20
;;       sltu    a2, a5, a0
;;       add     a4, a4, a0
;;       lui     a5, 1
;;       add     a4, a4, a5
;;       neg     a0, a2
;;       not     a2, a0
;;       and     a4, a4, a2
;;       sb      a3, 0(a4)
;;       ld      ra, 8(sp)
;;       ld      s0, 0(sp)
;;       addi    sp, sp, 0x10
;;       ret
;;
;; wasm[0]::function[1]:
;;       addi    sp, sp, -0x10
;;       sd      ra, 8(sp)
;;       sd      s0, 0(sp)
;;       mv      s0, sp
;;       ld      a4, 0x40(a0)
;;       ld      a3, 0x38(a0)
;;       slli    a1, a2, 0x20
;;       srli    a5, a1, 0x20
;;       sltu    a2, a4, a5
;;       add     a3, a3, a5
;;       lui     a4, 1
;;       add     a3, a3, a4
;;       neg     a0, a2
;;       not     a2, a0
;;       and     a4, a3, a2
;;       lbu     a0, 0(a4)
;;       ld      ra, 8(sp)
;;       ld      s0, 0(sp)
;;       addi    sp, sp, 0x10
;;       ret
