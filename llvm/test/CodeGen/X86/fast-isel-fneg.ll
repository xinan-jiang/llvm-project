; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -fast-isel -fast-isel-abort=1 -mtriple=x86_64-apple-darwin10 | FileCheck %s
; RUN: llc < %s -fast-isel -mtriple=i686-- -mattr=+sse2 | FileCheck --check-prefix=SSE2 %s

define double @doo(double %x) nounwind {
; CHECK-LABEL: doo:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; CHECK-NEXT:    subsd %xmm0, %xmm1
; CHECK-NEXT:    movapd %xmm1, %xmm0
; CHECK-NEXT:    retq
;
; SSE2-LABEL: doo:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pushl %ebp
; SSE2-NEXT:    movl %esp, %ebp
; SSE2-NEXT:    andl $-8, %esp
; SSE2-NEXT:    subl $8, %esp
; SSE2-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE2-NEXT:    xorps {{\.LCPI.*}}, %xmm0
; SSE2-NEXT:    movlps %xmm0, (%esp)
; SSE2-NEXT:    fldl (%esp)
; SSE2-NEXT:    movl %ebp, %esp
; SSE2-NEXT:    popl %ebp
; SSE2-NEXT:    retl
  %y = fsub double -0.0, %x
  ret double %y
}

define float @foo(float %x) nounwind {
; CHECK-LABEL: foo:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; CHECK-NEXT:    subss %xmm0, %xmm1
; CHECK-NEXT:    movaps %xmm1, %xmm0
; CHECK-NEXT:    retq
;
; SSE2-LABEL: foo:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pushl %eax
; SSE2-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; SSE2-NEXT:    xorps {{\.LCPI.*}}, %xmm0
; SSE2-NEXT:    movss %xmm0, (%esp)
; SSE2-NEXT:    flds (%esp)
; SSE2-NEXT:    popl %eax
; SSE2-NEXT:    retl
  %y = fsub float -0.0, %x
  ret float %y
}
