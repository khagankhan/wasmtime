;;! target = "x86_64"
;;! test = "clif"
;;! flags = " -C cranelift-enable-heap-access-spectre-mitigation -O static-memory-maximum-size=0 -O static-memory-guard-size=0 -O dynamic-memory-guard-size=0"

;; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;; !!! GENERATED BY 'make-load-store-tests.sh' DO NOT EDIT !!!
;; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

(module
  (memory i32 1)

  (func (export "do_store") (param i32 i32)
    local.get 0
    local.get 1
    i32.store offset=0)

  (func (export "do_load") (param i32) (result i32)
    local.get 0
    i32.load offset=0))

;; function u0:0(i64 vmctx, i64, i32, i32) tail {
;;     gv0 = vmctx
;;     gv1 = load.i64 notrap aligned readonly gv0+8
;;     gv2 = load.i64 notrap aligned gv1+16
;;     gv3 = vmctx
;;     gv4 = load.i64 notrap aligned gv3+64
;;     gv5 = load.i64 notrap aligned can_move checked gv3+56
;;     stack_limit = gv2
;;
;;                                 block0(v0: i64, v1: i64, v2: i32, v3: i32):
;; @0040                               v4 = uextend.i64 v2
;; @0040                               v5 = load.i64 notrap aligned v0+64
;; @0040                               v6 = iconst.i64 4
;; @0040                               v7 = isub v5, v6  ; v6 = 4
;; @0040                               v8 = icmp ugt v4, v7
;; @0040                               v9 = load.i64 notrap aligned can_move checked v0+56
;; @0040                               v10 = iadd v9, v4
;; @0040                               v11 = iconst.i64 0
;; @0040                               v12 = select_spectre_guard v8, v11, v10  ; v11 = 0
;; @0040                               store little heap v3, v12
;; @0043                               jump block1
;;
;;                                 block1:
;; @0043                               return
;; }
;;
;; function u0:1(i64 vmctx, i64, i32) -> i32 tail {
;;     gv0 = vmctx
;;     gv1 = load.i64 notrap aligned readonly gv0+8
;;     gv2 = load.i64 notrap aligned gv1+16
;;     gv3 = vmctx
;;     gv4 = load.i64 notrap aligned gv3+64
;;     gv5 = load.i64 notrap aligned can_move checked gv3+56
;;     stack_limit = gv2
;;
;;                                 block0(v0: i64, v1: i64, v2: i32):
;; @0048                               v4 = uextend.i64 v2
;; @0048                               v5 = load.i64 notrap aligned v0+64
;; @0048                               v6 = iconst.i64 4
;; @0048                               v7 = isub v5, v6  ; v6 = 4
;; @0048                               v8 = icmp ugt v4, v7
;; @0048                               v9 = load.i64 notrap aligned can_move checked v0+56
;; @0048                               v10 = iadd v9, v4
;; @0048                               v11 = iconst.i64 0
;; @0048                               v12 = select_spectre_guard v8, v11, v10  ; v11 = 0
;; @0048                               v13 = load.i32 little heap v12
;; @004b                               jump block1
;;
;;                                 block1:
;; @004b                               return v13
;; }
