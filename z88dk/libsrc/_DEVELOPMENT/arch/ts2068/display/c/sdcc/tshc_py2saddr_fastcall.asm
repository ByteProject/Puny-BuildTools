; void *tshc_py2saddr(uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_py2saddr_fastcall

EXTERN _zx_py2saddr_fastcall

defc _tshc_py2saddr_fastcall = _zx_py2saddr_fastcall
