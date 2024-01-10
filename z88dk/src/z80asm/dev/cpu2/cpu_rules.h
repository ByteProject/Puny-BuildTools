| label? _TK_ACI expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xCE);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x8F);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x88);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x89);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x8A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x8B);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x8C);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x8E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD8E00); } else { DO_stmt(0xFD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD8E); } else { DO_stmt_idx(0xFD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD8E00); } else { DO_stmt(0xDD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD8E); } else { DO_stmt_idx(0xDD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x8D);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xCE);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x8F);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x88);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x89);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x8A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x8B);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x8C);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_HL _TK_COMMA _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__adc_hl_bc");
break;
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED4A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_HL _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__adc_hl_de");
break;
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED5A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_HL _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__adc_hl_hl");
break;
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED6A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_HL _TK_COMMA _TK_SP _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__adc_hl_sp");
break;
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED7A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x8E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD8E00); } else { DO_stmt(0xFD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD8E); } else { DO_stmt_idx(0xFD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD8E00); } else { DO_stmt(0xDD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD8E); } else { DO_stmt_idx(0xDD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x8D);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_M _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x8E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xCE);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x87);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x80);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x81);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x82);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x83);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x84);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x86);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD8600); } else { DO_stmt(0xFD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD86); } else { DO_stmt_idx(0xFD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD8600); } else { DO_stmt(0xDD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD86); } else { DO_stmt_idx(0xDD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x85);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xC6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x87);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x80);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x81);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x82);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x83);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x84);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_HL _TK_COMMA _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x09);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_HL _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x19);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_HL _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x29);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_HL _TK_COMMA _TK_SP _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x39);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x86);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD8600); } else { DO_stmt(0xFD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD86); } else { DO_stmt_idx(0xFD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD8600); } else { DO_stmt(0xDD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD86); } else { DO_stmt_idx(0xDD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_IX _TK_COMMA _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD09); } else { DO_stmt(0xFD09); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_IX _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD19); } else { DO_stmt(0xFD19); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_IX _TK_COMMA _TK_IX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD29); } else { DO_stmt(0xFD29); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_IX _TK_COMMA _TK_SP _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD39); } else { DO_stmt(0xFD39); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_IY _TK_COMMA _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD09); } else { DO_stmt(0xDD09); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_IY _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD19); } else { DO_stmt(0xDD19); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_IY _TK_COMMA _TK_IY _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD29); } else { DO_stmt(0xDD29); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_IY _TK_COMMA _TK_SP _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD39); } else { DO_stmt(0xDD39); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x85);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_M _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x86);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_SP _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_d(0xE8);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xC6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADI _TK_HL _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x28);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADI _TK_SP _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x38);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADI expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xC6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ANA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xA7);
break;
default: error_illegal_ident(); }
}

| label? _TK_ANA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xA0);
break;
default: error_illegal_ident(); }
}

| label? _TK_ANA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xA1);
break;
default: error_illegal_ident(); }
}

| label? _TK_ANA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xA2);
break;
default: error_illegal_ident(); }
}

| label? _TK_ANA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xA3);
break;
default: error_illegal_ident(); }
}

| label? _TK_ANA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xA4);
break;
default: error_illegal_ident(); }
}

| label? _TK_ANA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xA5);
break;
default: error_illegal_ident(); }
}

| label? _TK_ANA _TK_M _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xA6);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xA7);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xA0);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xA1);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xA2);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xA3);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xA4);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xA6);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDA600); } else { DO_stmt(0xFDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDA6); } else { DO_stmt_idx(0xFDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDA600); } else { DO_stmt(0xDDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDA6); } else { DO_stmt_idx(0xDDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xA5);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xE6);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xA7);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xA0);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xA1);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xA2);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xA3);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xA4);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xA6);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDA600); } else { DO_stmt(0xFDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDA6); } else { DO_stmt_idx(0xFDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDA600); } else { DO_stmt(0xDDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDA6); } else { DO_stmt_idx(0xDDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xA5);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xE6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ANI expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xE6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ARHL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__sra_hl");
break;
case CPU_8085: 
DO_stmt(0x10);
break;
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB2C);
DO_stmt(0xCB1D);
break;
default: error_illegal_ident(); }
}

| label? _TK_BIT const_expr _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_STMT_LABEL();
if (expr_error) { error_expected_const_expr(); expr_value = 0; }
else if (expr_value < 0 || expr_value > 7) { error_int_range(expr_value); expr_value = 0; }
DO_stmt(0xCB47+((expr_value*8)));
break;
default: error_illegal_ident(); }
}

| label? _TK_BIT const_expr _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_STMT_LABEL();
if (expr_error) { error_expected_const_expr(); expr_value = 0; }
else if (expr_value < 0 || expr_value > 7) { error_int_range(expr_value); expr_value = 0; }
DO_stmt(0xCB40+((expr_value*8)));
break;
default: error_illegal_ident(); }
}

| label? _TK_BIT const_expr _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_STMT_LABEL();
if (expr_error) { error_expected_const_expr(); expr_value = 0; }
else if (expr_value < 0 || expr_value > 7) { error_int_range(expr_value); expr_value = 0; }
DO_stmt(0xCB41+((expr_value*8)));
break;
default: error_illegal_ident(); }
}

| label? _TK_BIT const_expr _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_STMT_LABEL();
if (expr_error) { error_expected_const_expr(); expr_value = 0; }
else if (expr_value < 0 || expr_value > 7) { error_int_range(expr_value); expr_value = 0; }
DO_stmt(0xCB42+((expr_value*8)));
break;
default: error_illegal_ident(); }
}

| label? _TK_BIT const_expr _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_STMT_LABEL();
if (expr_error) { error_expected_const_expr(); expr_value = 0; }
else if (expr_value < 0 || expr_value > 7) { error_int_range(expr_value); expr_value = 0; }
DO_stmt(0xCB43+((expr_value*8)));
break;
default: error_illegal_ident(); }
}

| label? _TK_BIT const_expr _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_STMT_LABEL();
if (expr_error) { error_expected_const_expr(); expr_value = 0; }
else if (expr_value < 0 || expr_value > 7) { error_int_range(expr_value); expr_value = 0; }
DO_stmt(0xCB44+((expr_value*8)));
break;
default: error_illegal_ident(); }
}

| label? _TK_BIT const_expr _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_STMT_LABEL();
if (expr_error) { error_expected_const_expr(); expr_value = 0; }
else if (expr_value < 0 || expr_value > 7) { error_int_range(expr_value); expr_value = 0; }
DO_stmt(0xCB46+((expr_value*8)));
break;
default: error_illegal_ident(); }
}

| label? _TK_BIT const_expr _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_STMT_LABEL();
if (expr_error) { error_expected_const_expr(); expr_value = 0; }
else if (expr_value < 0 || expr_value > 7) { error_int_range(expr_value); expr_value = 0; }
DO_stmt(0xCB45+((expr_value*8)));
break;
default: error_illegal_ident(); }
}

| label? _TK_CALL _TK_C _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xDC);
break;
default: error_illegal_ident(); }
}

| label? _TK_CALL _TK_M _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xFC);
break;
default: error_illegal_ident(); }
}

| label? _TK_CALL _TK_NC _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xD4);
break;
default: error_illegal_ident(); }
}

| label? _TK_CALL _TK_NV _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xE4);
break;
default: error_illegal_ident(); }
}

| label? _TK_CALL _TK_NZ _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xC4);
break;
default: error_illegal_ident(); }
}

| label? _TK_CALL _TK_P _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xF4);
break;
default: error_illegal_ident(); }
}

| label? _TK_CALL _TK_PE _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xEC);
break;
default: error_illegal_ident(); }
}

| label? _TK_CALL _TK_PO _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xE4);
break;
default: error_illegal_ident(); }
}

| label? _TK_CALL _TK_V _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xEC);
break;
default: error_illegal_ident(); }
}

| label? _TK_CALL _TK_Z _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xCC);
break;
default: error_illegal_ident(); }
}

| label? _TK_CALL expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xCD);
break;
default: error_illegal_ident(); }
}

| label? _TK_CC expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xDC);
break;
default: error_illegal_ident(); }
}

| label? _TK_CCF _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x3F);
break;
default: error_illegal_ident(); }
}

| label? _TK_CM expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xFC);
break;
default: error_illegal_ident(); }
}

| label? _TK_CMA _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x2F);
break;
default: error_illegal_ident(); }
}

| label? _TK_CMC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x3F);
break;
default: error_illegal_ident(); }
}

| label? _TK_CMP _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xBF);
break;
default: error_illegal_ident(); }
}

| label? _TK_CMP _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xB8);
break;
default: error_illegal_ident(); }
}

| label? _TK_CMP _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xB9);
break;
default: error_illegal_ident(); }
}

| label? _TK_CMP _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xBA);
break;
default: error_illegal_ident(); }
}

| label? _TK_CMP _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xBB);
break;
default: error_illegal_ident(); }
}

| label? _TK_CMP _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xBC);
break;
default: error_illegal_ident(); }
}

| label? _TK_CMP _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xBE);
break;
default: error_illegal_ident(); }
}

| label? _TK_CMP _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDBE00); } else { DO_stmt(0xFDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_CMP _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDBE); } else { DO_stmt_idx(0xFDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_CMP _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDBE00); } else { DO_stmt(0xDDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_CMP _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDBE); } else { DO_stmt_idx(0xDDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_CMP _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xBD);
break;
default: error_illegal_ident(); }
}

| label? _TK_CMP _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xFE);
break;
default: error_illegal_ident(); }
}

| label? _TK_CMP _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xBF);
break;
default: error_illegal_ident(); }
}

| label? _TK_CMP _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xB8);
break;
default: error_illegal_ident(); }
}

| label? _TK_CMP _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xB9);
break;
default: error_illegal_ident(); }
}

| label? _TK_CMP _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xBA);
break;
default: error_illegal_ident(); }
}

| label? _TK_CMP _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xBB);
break;
default: error_illegal_ident(); }
}

| label? _TK_CMP _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xBC);
break;
default: error_illegal_ident(); }
}

| label? _TK_CMP _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xBE);
break;
default: error_illegal_ident(); }
}

| label? _TK_CMP _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDBE00); } else { DO_stmt(0xFDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_CMP _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDBE); } else { DO_stmt_idx(0xFDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_CMP _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDBE00); } else { DO_stmt(0xDDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_CMP _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDBE); } else { DO_stmt_idx(0xDDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_CMP _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xBD);
break;
default: error_illegal_ident(); }
}

| label? _TK_CMP _TK_M _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xBE);
break;
default: error_illegal_ident(); }
}

| label? _TK_CMP expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xFE);
break;
default: error_illegal_ident(); }
}

| label? _TK_CNC expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xD4);
break;
default: error_illegal_ident(); }
}

| label? _TK_CNV expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xE4);
break;
default: error_illegal_ident(); }
}

| label? _TK_CNZ expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xC4);
break;
default: error_illegal_ident(); }
}

| label? _TK_CP _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xBF);
break;
default: error_illegal_ident(); }
}

| label? _TK_CP _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xB8);
break;
default: error_illegal_ident(); }
}

| label? _TK_CP _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xB9);
break;
default: error_illegal_ident(); }
}

| label? _TK_CP _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xBA);
break;
default: error_illegal_ident(); }
}

| label? _TK_CP _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xBB);
break;
default: error_illegal_ident(); }
}

| label? _TK_CP _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xBC);
break;
default: error_illegal_ident(); }
}

| label? _TK_CP _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xBE);
break;
default: error_illegal_ident(); }
}

| label? _TK_CP _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDBE00); } else { DO_stmt(0xFDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_CP _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDBE); } else { DO_stmt_idx(0xFDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_CP _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDBE00); } else { DO_stmt(0xDDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_CP _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDBE); } else { DO_stmt_idx(0xDDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_CP _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xBD);
break;
default: error_illegal_ident(); }
}

| label? _TK_CP _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xFE);
break;
default: error_illegal_ident(); }
}

| label? _TK_CP _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xBF);
break;
default: error_illegal_ident(); }
}

| label? _TK_CP _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xB8);
break;
default: error_illegal_ident(); }
}

| label? _TK_CP _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xB9);
break;
default: error_illegal_ident(); }
}

| label? _TK_CP _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xBA);
break;
default: error_illegal_ident(); }
}

| label? _TK_CP _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xBB);
break;
default: error_illegal_ident(); }
}

| label? _TK_CP _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xBC);
break;
default: error_illegal_ident(); }
}

| label? _TK_CP _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xBE);
break;
default: error_illegal_ident(); }
}

| label? _TK_CP _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDBE00); } else { DO_stmt(0xFDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_CP _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDBE); } else { DO_stmt_idx(0xFDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_CP _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDBE00); } else { DO_stmt(0xDDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_CP _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDBE); } else { DO_stmt_idx(0xDDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_CP _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xBD);
break;
default: error_illegal_ident(); }
}

| label? _TK_CP expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xFE);
break;
default: error_illegal_ident(); }
}

| label? _TK_CPD _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__cpd");
break;
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xEDA9);
break;
default: error_illegal_ident(); }
}

| label? _TK_CPDR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__cpdr");
break;
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xEDB9);
break;
default: error_illegal_ident(); }
}

| label? _TK_CPE expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xEC);
break;
default: error_illegal_ident(); }
}

| label? _TK_CPI _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__cpi");
break;
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xEDA1);
break;
default: error_illegal_ident(); }
}

| label? _TK_CPI expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xFE);
break;
default: error_illegal_ident(); }
}

| label? _TK_CPIR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__cpir");
break;
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xEDB1);
break;
default: error_illegal_ident(); }
}

| label? _TK_CPL _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x2F);
break;
default: error_illegal_ident(); }
}

| label? _TK_CPL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x2F);
break;
default: error_illegal_ident(); }
}

| label? _TK_CPO expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xE4);
break;
default: error_illegal_ident(); }
}

| label? _TK_CV expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xEC);
break;
default: error_illegal_ident(); }
}

| label? _TK_CZ expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xCC);
break;
default: error_illegal_ident(); }
}

| label? _TK_DAA _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x27);
break;
default: error_illegal_ident(); }
}

| label? _TK_DAD _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x09);
break;
default: error_illegal_ident(); }
}

| label? _TK_DAD _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x09);
break;
default: error_illegal_ident(); }
}

| label? _TK_DAD _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x19);
break;
default: error_illegal_ident(); }
}

| label? _TK_DAD _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x19);
break;
default: error_illegal_ident(); }
}

| label? _TK_DAD _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x29);
break;
default: error_illegal_ident(); }
}

| label? _TK_DAD _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x29);
break;
default: error_illegal_ident(); }
}

| label? _TK_DAD _TK_SP _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x39);
break;
default: error_illegal_ident(); }
}

| label? _TK_DCR _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x3D);
break;
default: error_illegal_ident(); }
}

| label? _TK_DCR _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x05);
break;
default: error_illegal_ident(); }
}

| label? _TK_DCR _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x0D);
break;
default: error_illegal_ident(); }
}

| label? _TK_DCR _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x15);
break;
default: error_illegal_ident(); }
}

| label? _TK_DCR _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x1D);
break;
default: error_illegal_ident(); }
}

| label? _TK_DCR _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x25);
break;
default: error_illegal_ident(); }
}

| label? _TK_DCR _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x2D);
break;
default: error_illegal_ident(); }
}

| label? _TK_DCR _TK_M _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x35);
break;
default: error_illegal_ident(); }
}

| label? _TK_DCX _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x0B);
break;
default: error_illegal_ident(); }
}

| label? _TK_DCX _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x0B);
break;
default: error_illegal_ident(); }
}

| label? _TK_DCX _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x1B);
break;
default: error_illegal_ident(); }
}

| label? _TK_DCX _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x1B);
break;
default: error_illegal_ident(); }
}

| label? _TK_DCX _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x2B);
break;
default: error_illegal_ident(); }
}

| label? _TK_DCX _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x2B);
break;
default: error_illegal_ident(); }
}

| label? _TK_DCX _TK_SP _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x3B);
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x3D);
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x05);
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x0B);
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x0D);
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x15);
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x1B);
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x1D);
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x25);
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x2B);
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x35);
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD3500); } else { DO_stmt(0xFD3500); }
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD35); } else { DO_stmt_idx(0xFD35); }
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD3500); } else { DO_stmt(0xDD3500); }
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD35); } else { DO_stmt_idx(0xDD35); }
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_IX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD2B); } else { DO_stmt(0xFD2B); }
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_IY _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD2B); } else { DO_stmt(0xDD2B); }
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x2D);
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_SP _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x3B);
break;
default: error_illegal_ident(); }
}

| label? _TK_DI _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xF3);
break;
default: error_illegal_ident(); }
}

| label? _TK_DJNZ _TK_B _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x05);
DO_stmt_jr(0x20);
break;
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x05);
DO_stmt_nn(0xC2);
break;
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_jr(0x10);
break;
default: error_illegal_ident(); }
}

| label? _TK_DJNZ expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x05);
DO_stmt_jr(0x20);
break;
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x05);
DO_stmt_nn(0xC2);
break;
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_jr(0x10);
break;
default: error_illegal_ident(); }
}

| label? _TK_DSUB _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__sub_hl_bc");
break;
case CPU_8085: 
DO_stmt(0x08);
break;
default: error_illegal_ident(); }
}

| label? _TK_EI _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xFB);
break;
default: error_illegal_ident(); }
}

| label? _TK_EX _TK_AF _TK_COMMA _TK_AF _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x08);
break;
default: error_illegal_ident(); }
}

| label? _TK_EX _TK_AF _TK_COMMA _TK_AF1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x08);
break;
default: error_illegal_ident(); }
}

| label? _TK_EX _TK_DE _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
DO_stmt(0xE5);
DO_stmt(0xD5);
DO_stmt(0xE1);
DO_stmt(0xD1);
break;
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xEB);
break;
default: error_illegal_ident(); }
}

| label? _TK_EX _TK_IND_SP _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__ex_sp_hl");
break;
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xE3);
break;
default: error_illegal_ident(); }
}

| label? _TK_EX _TK_IND_SP _TK_RPAREN _TK_COMMA _TK_IX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDE3); } else { DO_stmt(0xFDE3); }
break;
default: error_illegal_ident(); }
}

| label? _TK_EX _TK_IND_SP _TK_RPAREN _TK_COMMA _TK_IY _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDE3); } else { DO_stmt(0xDDE3); }
break;
default: error_illegal_ident(); }
}

| label? _TK_EXX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xD9);
break;
default: error_illegal_ident(); }
}

| label? _TK_HALT _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x76);
break;
default: error_illegal_ident(); }
}

| label? _TK_HLT _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x76);
break;
default: error_illegal_ident(); }
}

| label? _TK_IM const_expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_STMT_LABEL();
if (expr_error) { error_expected_const_expr(); expr_value = 0; }
else if (expr_value < 0 || expr_value > 2) { error_int_range(expr_value); expr_value = 0; }
DO_stmt(0xED00+((expr_value==0?0x46:expr_value==1?0x56:0x5e)));
break;
default: error_illegal_ident(); }
}

| label? _TK_IN _TK_A _TK_COMMA _TK_IND_C _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED78);
break;
default: error_illegal_ident(); }
}

| label? _TK_IN _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
if (!expr_in_parens) return false;
DO_stmt_n(0xDB);
break;
default: error_illegal_ident(); }
}

| label? _TK_IN _TK_B _TK_COMMA _TK_IND_C _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED40);
break;
default: error_illegal_ident(); }
}

| label? _TK_IN _TK_C _TK_COMMA _TK_IND_C _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED48);
break;
default: error_illegal_ident(); }
}

| label? _TK_IN _TK_D _TK_COMMA _TK_IND_C _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED50);
break;
default: error_illegal_ident(); }
}

| label? _TK_IN _TK_E _TK_COMMA _TK_IND_C _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED58);
break;
default: error_illegal_ident(); }
}

| label? _TK_IN _TK_F _TK_COMMA _TK_IND_C _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED70);
break;
default: error_illegal_ident(); }
}

| label? _TK_IN _TK_H _TK_COMMA _TK_IND_C _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED60);
break;
default: error_illegal_ident(); }
}

| label? _TK_IN _TK_IND_C _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED70);
break;
default: error_illegal_ident(); }
}

| label? _TK_IN _TK_L _TK_COMMA _TK_IND_C _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED68);
break;
default: error_illegal_ident(); }
}

| label? _TK_IN expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xDB);
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x3C);
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x04);
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x03);
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x0C);
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x14);
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x13);
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x1C);
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x24);
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x23);
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x34);
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD3400); } else { DO_stmt(0xFD3400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD34); } else { DO_stmt_idx(0xFD34); }
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD3400); } else { DO_stmt(0xDD3400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD34); } else { DO_stmt_idx(0xDD34); }
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_IX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD23); } else { DO_stmt(0xFD23); }
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_IY _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD23); } else { DO_stmt(0xDD23); }
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x2C);
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_SP _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x33);
break;
default: error_illegal_ident(); }
}

| label? _TK_IND _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xEDAA);
break;
default: error_illegal_ident(); }
}

| label? _TK_INDR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xEDBA);
break;
default: error_illegal_ident(); }
}

| label? _TK_INI _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xEDA2);
break;
default: error_illegal_ident(); }
}

| label? _TK_INIR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xEDB2);
break;
default: error_illegal_ident(); }
}

| label? _TK_INR _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x3C);
break;
default: error_illegal_ident(); }
}

| label? _TK_INR _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x04);
break;
default: error_illegal_ident(); }
}

| label? _TK_INR _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x0C);
break;
default: error_illegal_ident(); }
}

| label? _TK_INR _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x14);
break;
default: error_illegal_ident(); }
}

| label? _TK_INR _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x1C);
break;
default: error_illegal_ident(); }
}

| label? _TK_INR _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x24);
break;
default: error_illegal_ident(); }
}

| label? _TK_INR _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x2C);
break;
default: error_illegal_ident(); }
}

| label? _TK_INR _TK_M _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x34);
break;
default: error_illegal_ident(); }
}

| label? _TK_INX _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x03);
break;
default: error_illegal_ident(); }
}

| label? _TK_INX _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x03);
break;
default: error_illegal_ident(); }
}

| label? _TK_INX _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x13);
break;
default: error_illegal_ident(); }
}

| label? _TK_INX _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x13);
break;
default: error_illegal_ident(); }
}

| label? _TK_INX _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x23);
break;
default: error_illegal_ident(); }
}

| label? _TK_INX _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x23);
break;
default: error_illegal_ident(); }
}

| label? _TK_INX _TK_SP _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x33);
break;
default: error_illegal_ident(); }
}

| label? _TK_JC expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xDA);
break;
default: error_illegal_ident(); }
}

| label? _TK_JK expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xFD);
break;
default: error_illegal_ident(); }
}

| label? _TK_JM expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xFA);
break;
default: error_illegal_ident(); }
}

| label? _TK_JMP expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xC3);
break;
default: error_illegal_ident(); }
}

| label? _TK_JNC expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xD2);
break;
default: error_illegal_ident(); }
}

| label? _TK_JNK expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xDD);
break;
default: error_illegal_ident(); }
}

| label? _TK_JNV expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xE2);
break;
default: error_illegal_ident(); }
}

| label? _TK_JNX5 expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xDD);
break;
default: error_illegal_ident(); }
}

| label? _TK_JNZ expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xC2);
break;
default: error_illegal_ident(); }
}

| label? _TK_JP _TK_C _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xDA);
break;
default: error_illegal_ident(); }
}

| label? _TK_JP _TK_IND_BC _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xC5);
DO_stmt(0xC9);
break;
default: error_illegal_ident(); }
}

| label? _TK_JP _TK_IND_DE _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xD5);
DO_stmt(0xC9);
break;
default: error_illegal_ident(); }
}

| label? _TK_JP _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xE9);
break;
default: error_illegal_ident(); }
}

| label? _TK_JP _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDE9); } else { DO_stmt(0xFDE9); }
break;
default: error_illegal_ident(); }
}

| label? _TK_JP _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDE9); } else { DO_stmt(0xDDE9); }
break;
default: error_illegal_ident(); }
}

| label? _TK_JP _TK_M _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xFA);
break;
default: error_illegal_ident(); }
}

| label? _TK_JP _TK_NC _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xD2);
break;
default: error_illegal_ident(); }
}

| label? _TK_JP _TK_NV _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xE2);
break;
default: error_illegal_ident(); }
}

| label? _TK_JP _TK_NZ _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xC2);
break;
default: error_illegal_ident(); }
}

| label? _TK_JP _TK_P _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xF2);
break;
default: error_illegal_ident(); }
}

| label? _TK_JP _TK_PE _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xEA);
break;
default: error_illegal_ident(); }
}

| label? _TK_JP _TK_PO _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xE2);
break;
default: error_illegal_ident(); }
}

| label? _TK_JP _TK_V _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xEA);
break;
default: error_illegal_ident(); }
}

| label? _TK_JP _TK_Z _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xCA);
break;
default: error_illegal_ident(); }
}

| label? _TK_JP expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xC3);
break;
default: error_illegal_ident(); }
}

| label? _TK_JPE expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xEA);
break;
default: error_illegal_ident(); }
}

| label? _TK_JPO expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xE2);
break;
default: error_illegal_ident(); }
}

| label? _TK_JR _TK_C _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_jr(0x38);
break;
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xDA);
break;
default: error_illegal_ident(); }
}

| label? _TK_JR _TK_NC _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_jr(0x30);
break;
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xD2);
break;
default: error_illegal_ident(); }
}

| label? _TK_JR _TK_NZ _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_jr(0x20);
break;
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xC2);
break;
default: error_illegal_ident(); }
}

| label? _TK_JR _TK_Z _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_jr(0x28);
break;
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xCA);
break;
default: error_illegal_ident(); }
}

| label? _TK_JR expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_jr(0x18);
break;
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xC3);
break;
default: error_illegal_ident(); }
}

| label? _TK_JV expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xEA);
break;
default: error_illegal_ident(); }
}

| label? _TK_JX5 expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xFD);
break;
default: error_illegal_ident(); }
}

| label? _TK_JZ expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xCA);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x7F);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x78);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x79);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x7A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x7B);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x7C);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_I _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED57);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IND_BC _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x0A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IND_C _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
DO_stmt(0xF2);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IND_DE _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x1A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IND_HL _TK_MINUS _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
DO_stmt(0x3A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IND_HL _TK_PLUS _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
DO_stmt(0x2A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x7E);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IND_HLD _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
DO_stmt(0x3A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IND_HLI _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
DO_stmt(0x2A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7E00); } else { DO_stmt(0xFD7E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD7E); } else { DO_stmt_idx(0xFD7E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7E00); } else { DO_stmt(0xDD7E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD7E); } else { DO_stmt_idx(0xDD7E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7C); } else { DO_stmt(0xFD7C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7D); } else { DO_stmt(0xFD7D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7C); } else { DO_stmt(0xDD7C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7D); } else { DO_stmt(0xDD7D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x7D);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_R _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED5F);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) { DO_stmt_nn(0x3A); } else { DO_stmt_n(0x3E); }
break;
case CPU_GBZ80: 
if (expr_in_parens) { DO_stmt_nn(0xFA); } else { DO_stmt_n(0x3E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x47);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x40);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x41);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x42);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x43);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x44);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x46);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD4600); } else { DO_stmt(0xFD4600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD46); } else { DO_stmt_idx(0xFD46); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD4600); } else { DO_stmt(0xDD4600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD46); } else { DO_stmt_idx(0xDD46); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD44); } else { DO_stmt(0xFD44); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD45); } else { DO_stmt(0xFD45); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD44); } else { DO_stmt(0xDD44); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD45); } else { DO_stmt(0xDD45); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x45);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x06);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_BC _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x42);
DO_stmt(0x4B);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_BC _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x44);
DO_stmt(0x4D);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_BC _TK_COMMA _TK_IX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD44);
DO_stmt(0xDD4D); } else { DO_stmt(0xFD44);
DO_stmt(0xFD4D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_BC _TK_COMMA _TK_IY _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD44);
DO_stmt(0xFD4D); } else { DO_stmt(0xDD44);
DO_stmt(0xDD4D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_BC _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_R2K: case CPU_R3K: case CPU_Z180: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x01);
break;
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) { DO_stmt_nn(0xED4B); } else { DO_stmt_nn(0x01); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x4F);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x48);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x49);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x4A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x4B);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x4C);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x4E);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD4E00); } else { DO_stmt(0xFD4E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD4E); } else { DO_stmt_idx(0xFD4E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD4E00); } else { DO_stmt(0xDD4E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD4E); } else { DO_stmt_idx(0xDD4E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD4C); } else { DO_stmt(0xFD4C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD4D); } else { DO_stmt(0xFD4D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD4C); } else { DO_stmt(0xDD4C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD4D); } else { DO_stmt(0xDD4D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x4D);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x0E);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x57);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x50);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x51);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x52);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x53);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x54);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x56);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD5600); } else { DO_stmt(0xFD5600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD56); } else { DO_stmt_idx(0xFD56); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD5600); } else { DO_stmt(0xDD5600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD56); } else { DO_stmt_idx(0xDD56); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD54); } else { DO_stmt(0xFD54); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD55); } else { DO_stmt(0xFD55); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD54); } else { DO_stmt(0xDD54); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD55); } else { DO_stmt(0xDD55); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x55);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x16);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_DE _TK_COMMA _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x50);
DO_stmt(0x59);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_DE _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x54);
DO_stmt(0x5D);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_DE _TK_COMMA _TK_HL _TK_PLUS expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x28);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_DE _TK_COMMA _TK_IX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD54);
DO_stmt(0xDD5D); } else { DO_stmt(0xFD54);
DO_stmt(0xFD5D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_DE _TK_COMMA _TK_IY _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD54);
DO_stmt(0xFD5D); } else { DO_stmt(0xDD54);
DO_stmt(0xDD5D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_DE _TK_COMMA _TK_SP _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
DO_stmt(0x3800);
break;
case CPU_GBZ80: 
DO_stmt(0xE5);
DO_stmt(0xD5);
DO_stmt(0xE1);
DO_stmt(0xD1);
DO_stmt(0x210000);
DO_stmt(0x39);
DO_stmt(0xE5);
DO_stmt(0xD5);
DO_stmt(0xE1);
DO_stmt(0xD1);
break;
case CPU_8080: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xEB);
DO_stmt(0x210000);
DO_stmt(0x39);
DO_stmt(0xEB);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_DE _TK_COMMA _TK_SP _TK_PLUS expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xE5);
DO_stmt(0xD5);
DO_stmt(0xE1);
DO_stmt(0xD1);
DO_stmt_n_0(0x21);
DO_stmt(0x39);
DO_stmt(0xE5);
DO_stmt(0xD5);
DO_stmt(0xE1);
DO_stmt(0xD1);
break;
case CPU_8080: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xEB);
DO_stmt_n_0(0x21);
DO_stmt(0x39);
DO_stmt(0xEB);
break;
case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x38);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_DE _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_R2K: case CPU_R3K: case CPU_Z180: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x11);
break;
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) { DO_stmt_nn(0xED5B); } else { DO_stmt_nn(0x11); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x5F);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x58);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x59);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x5A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x5B);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x5C);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x5E);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD5E00); } else { DO_stmt(0xFD5E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD5E); } else { DO_stmt_idx(0xFD5E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD5E00); } else { DO_stmt(0xDD5E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD5E); } else { DO_stmt_idx(0xDD5E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD5C); } else { DO_stmt(0xFD5C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD5D); } else { DO_stmt(0xFD5D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD5C); } else { DO_stmt(0xDD5C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD5D); } else { DO_stmt(0xDD5D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x5D);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x1E);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x67);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x60);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x61);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x62);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x63);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x64);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x66);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD6600); } else { DO_stmt(0xFD6600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD66); } else { DO_stmt_idx(0xFD66); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD6600); } else { DO_stmt(0xDD6600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD66); } else { DO_stmt_idx(0xDD66); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x65);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x26);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL _TK_COMMA _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x60);
DO_stmt(0x69);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x62);
DO_stmt(0x6B);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL _TK_COMMA _TK_IND_DE _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
DO_stmt(0xED);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL _TK_COMMA _TK_IX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDE5);
DO_stmt(0xE1); } else { DO_stmt(0xFDE5);
DO_stmt(0xE1); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL _TK_COMMA _TK_IY _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDE5);
DO_stmt(0xE1); } else { DO_stmt(0xDDE5);
DO_stmt(0xE1); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL _TK_COMMA _TK_SP _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x210000);
DO_stmt(0x39);
break;
case CPU_GBZ80: 
DO_stmt(0xF800);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL _TK_COMMA _TK_SP expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_d(0xF8);
break;
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_s_0(0x21);
DO_stmt(0x39);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_R2K: case CPU_R3K: case CPU_Z180: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x21);
break;
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) { DO_stmt_nn(0x2A); } else { DO_stmt_nn(0x21); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_I _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED47);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_BC _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x02);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_C _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
DO_stmt(0xE2);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_DE _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x12);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_DE _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
DO_stmt(0xD9);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_HL _TK_MINUS _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
DO_stmt(0x32);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_HL _TK_PLUS _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
DO_stmt(0x22);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x77);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x70);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x71);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x72);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x73);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x74);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x75);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x36);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_HLD _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
DO_stmt(0x32);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_HLI _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
DO_stmt(0x22);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7700); } else { DO_stmt(0xFD7700); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7000); } else { DO_stmt(0xFD7000); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7100); } else { DO_stmt(0xFD7100); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7200); } else { DO_stmt(0xFD7200); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7300); } else { DO_stmt(0xFD7300); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7400); } else { DO_stmt(0xFD7400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7500); } else { DO_stmt(0xFD7500); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_n(0xDD3600); } else { DO_stmt_n(0xFD3600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD77); } else { DO_stmt_idx(0xFD77); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD70); } else { DO_stmt_idx(0xFD70); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD71); } else { DO_stmt_idx(0xFD71); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD72); } else { DO_stmt_idx(0xFD72); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD73); } else { DO_stmt_idx(0xFD73); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD74); } else { DO_stmt_idx(0xFD74); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD75); } else { DO_stmt_idx(0xFD75); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx_n(0xDD36); } else { DO_stmt_idx_n(0xFD36); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7700); } else { DO_stmt(0xDD7700); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7000); } else { DO_stmt(0xDD7000); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7100); } else { DO_stmt(0xDD7100); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7200); } else { DO_stmt(0xDD7200); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7300); } else { DO_stmt(0xDD7300); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7400); } else { DO_stmt(0xDD7400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7500); } else { DO_stmt(0xDD7500); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_n(0xFD3600); } else { DO_stmt_n(0xDD3600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD77); } else { DO_stmt_idx(0xDD77); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD70); } else { DO_stmt_idx(0xDD70); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD71); } else { DO_stmt_idx(0xDD71); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD72); } else { DO_stmt_idx(0xDD72); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD73); } else { DO_stmt_idx(0xDD73); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD74); } else { DO_stmt_idx(0xDD74); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD75); } else { DO_stmt_idx(0xDD75); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx_n(0xFD36); } else { DO_stmt_idx_n(0xDD36); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IX _TK_COMMA _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD60);
DO_stmt(0xDD69); } else { DO_stmt(0xFD60);
DO_stmt(0xFD69); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IX _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD62);
DO_stmt(0xDD6B); } else { DO_stmt(0xFD62);
DO_stmt(0xFD6B); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IX _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xE5);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDE1); } else { 
DO_stmt(0xFDE1); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IX _TK_COMMA _TK_IY _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDE5);
DO_stmt(0xDDE1); } else { DO_stmt(0xDDE5);
DO_stmt(0xFDE1); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IX _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) { if (!opts.swap_ix_iy) { DO_stmt_nn(0xDD2A); } else { DO_stmt_nn(0xFD2A); } } else { if (!opts.swap_ix_iy) { DO_stmt_nn(0xDD21); } else { DO_stmt_nn(0xFD21); } }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXH _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD67); } else { DO_stmt(0xFD67); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXH _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD60); } else { DO_stmt(0xFD60); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXH _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD61); } else { DO_stmt(0xFD61); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXH _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD62); } else { DO_stmt(0xFD62); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXH _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD63); } else { DO_stmt(0xFD63); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXH _TK_COMMA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD64); } else { DO_stmt(0xFD64); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXH _TK_COMMA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD65); } else { DO_stmt(0xFD65); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXH _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_n(0xDD26); } else { DO_stmt_n(0xFD26); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXL _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD6F); } else { DO_stmt(0xFD6F); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXL _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD68); } else { DO_stmt(0xFD68); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXL _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD69); } else { DO_stmt(0xFD69); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXL _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD6A); } else { DO_stmt(0xFD6A); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXL _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD6B); } else { DO_stmt(0xFD6B); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXL _TK_COMMA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD6C); } else { DO_stmt(0xFD6C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXL _TK_COMMA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD6D); } else { DO_stmt(0xFD6D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXL _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_n(0xDD2E); } else { DO_stmt_n(0xFD2E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IY _TK_COMMA _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD60);
DO_stmt(0xFD69); } else { DO_stmt(0xDD60);
DO_stmt(0xDD69); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IY _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD62);
DO_stmt(0xFD6B); } else { DO_stmt(0xDD62);
DO_stmt(0xDD6B); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IY _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xE5);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDE1); } else { 
DO_stmt(0xDDE1); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IY _TK_COMMA _TK_IX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDE5);
DO_stmt(0xFDE1); } else { DO_stmt(0xFDE5);
DO_stmt(0xDDE1); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IY _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) { if (!opts.swap_ix_iy) { DO_stmt_nn(0xFD2A); } else { DO_stmt_nn(0xDD2A); } } else { if (!opts.swap_ix_iy) { DO_stmt_nn(0xFD21); } else { DO_stmt_nn(0xDD21); } }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYH _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD67); } else { DO_stmt(0xDD67); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYH _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD60); } else { DO_stmt(0xDD60); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYH _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD61); } else { DO_stmt(0xDD61); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYH _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD62); } else { DO_stmt(0xDD62); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYH _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD63); } else { DO_stmt(0xDD63); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYH _TK_COMMA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD64); } else { DO_stmt(0xDD64); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYH _TK_COMMA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD65); } else { DO_stmt(0xDD65); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYH _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_n(0xFD26); } else { DO_stmt_n(0xDD26); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYL _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD6F); } else { DO_stmt(0xDD6F); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYL _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD68); } else { DO_stmt(0xDD68); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYL _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD69); } else { DO_stmt(0xDD69); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYL _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD6A); } else { DO_stmt(0xDD6A); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYL _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD6B); } else { DO_stmt(0xDD6B); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYL _TK_COMMA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD6C); } else { DO_stmt(0xDD6C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYL _TK_COMMA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD6D); } else { DO_stmt(0xDD6D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYL _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_n(0xFD2E); } else { DO_stmt_n(0xDD2E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x6F);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x68);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x69);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x6A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x6B);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x6C);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x6E);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD6E00); } else { DO_stmt(0xFD6E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD6E); } else { DO_stmt_idx(0xFD6E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD6E00); } else { DO_stmt(0xDD6E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD6E); } else { DO_stmt_idx(0xDD6E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x6D);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x2E);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_R _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED4F);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_SP _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xF9);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_SP _TK_COMMA _TK_IX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDF9); } else { DO_stmt(0xFDF9); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_SP _TK_COMMA _TK_IY _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDF9); } else { DO_stmt(0xDDF9); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_SP _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_R2K: case CPU_R3K: case CPU_Z180: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x31);
break;
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) { DO_stmt_nn(0xED7B); } else { DO_stmt_nn(0x31); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD expr _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
if (!expr_in_parens) return false;
DO_stmt_nn(0x32);
break;
case CPU_GBZ80: 
if (!expr_in_parens) return false;
DO_stmt_nn(0xEA);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD expr _TK_COMMA _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!expr_in_parens) return false;
DO_stmt_nn(0xED43);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD expr _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!expr_in_parens) return false;
DO_stmt_nn(0xED53);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD expr _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
if (!expr_in_parens) return false;
DO_stmt_nn(0x22);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD expr _TK_COMMA _TK_IX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!expr_in_parens) return false;
if (!opts.swap_ix_iy) { DO_stmt_nn(0xDD22); } else { DO_stmt_nn(0xFD22); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD expr _TK_COMMA _TK_IY _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!expr_in_parens) return false;
if (!opts.swap_ix_iy) { DO_stmt_nn(0xFD22); } else { DO_stmt_nn(0xDD22); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD expr _TK_COMMA _TK_SP _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
if (!expr_in_parens) return false;
DO_stmt_nn(0x08);
break;
case CPU_Z80: case CPU_Z80N: 
if (!expr_in_parens) return false;
DO_stmt_nn(0xED73);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x3A);
break;
case CPU_GBZ80: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xFA);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDAX _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x0A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDAX _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x0A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDAX _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x1A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDAX _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x1A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
DO_stmt(0x3A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
DO_stmt(0x32);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDD _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__ldd");
break;
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xEDA8);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDDR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__lddr");
break;
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xEDB8);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDH _TK_A _TK_COMMA _TK_IND_C _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
DO_stmt(0xF2);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDH _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
if (!expr_in_parens) return false;
DO_stmt_n(0xF0);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDH _TK_IND_C _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
DO_stmt(0xE2);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDH expr _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
if (!expr_in_parens) return false;
DO_stmt_n(0xE0);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDHI expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x28);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDHL _TK_SP _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_d(0xF8);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDI _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
DO_stmt(0x2A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDI _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
DO_stmt(0x22);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDI _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__ldi");
break;
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xEDA0);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDIR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__ldir");
break;
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xEDB0);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDSI expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x38);
break;
default: error_illegal_ident(); }
}

| label? _TK_LHLD expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x2A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LHLDE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
DO_stmt(0xED);
break;
default: error_illegal_ident(); }
}

| label? _TK_LHLX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
DO_stmt(0xED);
break;
default: error_illegal_ident(); }
}

| label? _TK_LXI _TK_B _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x01);
break;
default: error_illegal_ident(); }
}

| label? _TK_LXI _TK_BC _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x01);
break;
default: error_illegal_ident(); }
}

| label? _TK_LXI _TK_D _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x11);
break;
default: error_illegal_ident(); }
}

| label? _TK_LXI _TK_DE _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x11);
break;
default: error_illegal_ident(); }
}

| label? _TK_LXI _TK_H _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x21);
break;
default: error_illegal_ident(); }
}

| label? _TK_LXI _TK_HL _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x21);
break;
default: error_illegal_ident(); }
}

| label? _TK_LXI _TK_SP _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x31);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x7F);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x78);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x79);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x7A);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x7B);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x7C);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x7D);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_A _TK_COMMA _TK_M _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x7E);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_B _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x47);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_B _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x40);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_B _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x41);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_B _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x42);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_B _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x43);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_B _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x44);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_B _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x45);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_B _TK_COMMA _TK_M _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x46);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_C _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x4F);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_C _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x48);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_C _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x49);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_C _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x4A);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_C _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x4B);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_C _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x4C);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_C _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x4D);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_C _TK_COMMA _TK_M _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x4E);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_D _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x57);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_D _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x50);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_D _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x51);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_D _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x52);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_D _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x53);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_D _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x54);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_D _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x55);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_D _TK_COMMA _TK_M _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x56);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_E _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x5F);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_E _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x58);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_E _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x59);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_E _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x5A);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_E _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x5B);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_E _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x5C);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_E _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x5D);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_E _TK_COMMA _TK_M _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x5E);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_H _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x67);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_H _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x60);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_H _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x61);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_H _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x62);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_H _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x63);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_H _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x64);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_H _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x65);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_H _TK_COMMA _TK_M _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x66);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_L _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x6F);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_L _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x68);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_L _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x69);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_L _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x6A);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_L _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x6B);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_L _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x6C);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_L _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x6D);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_L _TK_COMMA _TK_M _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x6E);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_M _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x77);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_M _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x70);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_M _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x71);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_M _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x72);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_M _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x73);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_M _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x74);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_M _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x75);
break;
default: error_illegal_ident(); }
}

| label? _TK_MVI _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x3E);
break;
default: error_illegal_ident(); }
}

| label? _TK_MVI _TK_B _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x06);
break;
default: error_illegal_ident(); }
}

| label? _TK_MVI _TK_C _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x0E);
break;
default: error_illegal_ident(); }
}

| label? _TK_MVI _TK_D _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x16);
break;
default: error_illegal_ident(); }
}

| label? _TK_MVI _TK_E _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x1E);
break;
default: error_illegal_ident(); }
}

| label? _TK_MVI _TK_H _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x26);
break;
default: error_illegal_ident(); }
}

| label? _TK_MVI _TK_L _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x2E);
break;
default: error_illegal_ident(); }
}

| label? _TK_MVI _TK_M _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x36);
break;
default: error_illegal_ident(); }
}

| label? _TK_NEG _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: 
DO_stmt(0x2F);
DO_stmt(0x3C);
break;
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED44);
break;
default: error_illegal_ident(); }
}

| label? _TK_NEG _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: 
DO_stmt(0x2F);
DO_stmt(0x3C);
break;
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED44);
break;
default: error_illegal_ident(); }
}

| label? _TK_NOP _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x00);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xB7);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xB0);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xB1);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xB2);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xB3);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xB4);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xB6);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDB600); } else { DO_stmt(0xFDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDB6); } else { DO_stmt_idx(0xFDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDB600); } else { DO_stmt(0xDDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDB6); } else { DO_stmt_idx(0xDDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xB5);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xF6);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xB7);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xB0);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xB1);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xB2);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xB3);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xB4);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xB6);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDB600); } else { DO_stmt(0xFDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDB6); } else { DO_stmt_idx(0xFDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDB600); } else { DO_stmt(0xDDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDB6); } else { DO_stmt_idx(0xDDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xB5);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xF6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ORA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xB7);
break;
default: error_illegal_ident(); }
}

| label? _TK_ORA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xB0);
break;
default: error_illegal_ident(); }
}

| label? _TK_ORA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xB1);
break;
default: error_illegal_ident(); }
}

| label? _TK_ORA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xB2);
break;
default: error_illegal_ident(); }
}

| label? _TK_ORA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xB3);
break;
default: error_illegal_ident(); }
}

| label? _TK_ORA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xB4);
break;
default: error_illegal_ident(); }
}

| label? _TK_ORA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xB5);
break;
default: error_illegal_ident(); }
}

| label? _TK_ORA _TK_M _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xB6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ORI expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xF6);
break;
default: error_illegal_ident(); }
}

| label? _TK_OTDR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xEDBB);
break;
default: error_illegal_ident(); }
}

| label? _TK_OTIR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xEDB3);
break;
default: error_illegal_ident(); }
}

| label? _TK_OUT _TK_IND_C _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED79);
break;
default: error_illegal_ident(); }
}

| label? _TK_OUT _TK_IND_C _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED41);
break;
default: error_illegal_ident(); }
}

| label? _TK_OUT _TK_IND_C _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED49);
break;
default: error_illegal_ident(); }
}

| label? _TK_OUT _TK_IND_C _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED51);
break;
default: error_illegal_ident(); }
}

| label? _TK_OUT _TK_IND_C _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED59);
break;
default: error_illegal_ident(); }
}

| label? _TK_OUT _TK_IND_C _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED61);
break;
default: error_illegal_ident(); }
}

| label? _TK_OUT _TK_IND_C _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED69);
break;
default: error_illegal_ident(); }
}

| label? _TK_OUT _TK_IND_C _TK_RPAREN _TK_COMMA const_expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xED71);
break;
default: error_illegal_ident(); }
}

| label? _TK_OUT expr _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
if (!expr_in_parens) return false;
DO_stmt_n(0xD3);
break;
default: error_illegal_ident(); }
}

| label? _TK_OUT expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xD3);
break;
default: error_illegal_ident(); }
}

| label? _TK_OUTD _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xEDAB);
break;
default: error_illegal_ident(); }
}

| label? _TK_OUTI _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xEDA3);
break;
default: error_illegal_ident(); }
}

| label? _TK_OVRST8 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
DO_stmt(0xCB);
break;
default: error_illegal_ident(); }
}

| label? _TK_PCHL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xE9);
break;
default: error_illegal_ident(); }
}

| label? _TK_POP _TK_AF _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xF1);
break;
default: error_illegal_ident(); }
}

| label? _TK_POP _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xC1);
break;
default: error_illegal_ident(); }
}

| label? _TK_POP _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xC1);
break;
default: error_illegal_ident(); }
}

| label? _TK_POP _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xD1);
break;
default: error_illegal_ident(); }
}

| label? _TK_POP _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xD1);
break;
default: error_illegal_ident(); }
}

| label? _TK_POP _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xE1);
break;
default: error_illegal_ident(); }
}

| label? _TK_POP _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xE1);
break;
default: error_illegal_ident(); }
}

| label? _TK_POP _TK_IX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDE1); } else { DO_stmt(0xFDE1); }
break;
default: error_illegal_ident(); }
}

| label? _TK_POP _TK_IY _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDE1); } else { DO_stmt(0xDDE1); }
break;
default: error_illegal_ident(); }
}

| label? _TK_POP _TK_PSW _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xF1);
break;
default: error_illegal_ident(); }
}

| label? _TK_PUSH _TK_AF _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xF5);
break;
default: error_illegal_ident(); }
}

| label? _TK_PUSH _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xC5);
break;
default: error_illegal_ident(); }
}

| label? _TK_PUSH _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xC5);
break;
default: error_illegal_ident(); }
}

| label? _TK_PUSH _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xD5);
break;
default: error_illegal_ident(); }
}

| label? _TK_PUSH _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xD5);
break;
default: error_illegal_ident(); }
}

| label? _TK_PUSH _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xE5);
break;
default: error_illegal_ident(); }
}

| label? _TK_PUSH _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xE5);
break;
default: error_illegal_ident(); }
}

| label? _TK_PUSH _TK_IX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDE5); } else { DO_stmt(0xFDE5); }
break;
default: error_illegal_ident(); }
}

| label? _TK_PUSH _TK_IY _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDE5); } else { DO_stmt(0xDDE5); }
break;
default: error_illegal_ident(); }
}

| label? _TK_PUSH _TK_PSW _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xF5);
break;
default: error_illegal_ident(); }
}

| label? _TK_RAL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x17);
break;
default: error_illegal_ident(); }
}

| label? _TK_RAR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x1F);
break;
default: error_illegal_ident(); }
}

| label? _TK_RC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xD8);
break;
default: error_illegal_ident(); }
}

| label? _TK_RDEL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__rl_de");
break;
case CPU_8085: 
DO_stmt(0x18);
break;
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB13);
DO_stmt(0xCB12);
break;
default: error_illegal_ident(); }
}

| label? _TK_RES const_expr _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_STMT_LABEL();
if (expr_error) { error_expected_const_expr(); expr_value = 0; }
else if (expr_value < 0 || expr_value > 7) { error_int_range(expr_value); expr_value = 0; }
DO_stmt(0xCB87+((expr_value*8)));
break;
default: error_illegal_ident(); }
}

| label? _TK_RES const_expr _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_STMT_LABEL();
if (expr_error) { error_expected_const_expr(); expr_value = 0; }
else if (expr_value < 0 || expr_value > 7) { error_int_range(expr_value); expr_value = 0; }
DO_stmt(0xCB80+((expr_value*8)));
break;
default: error_illegal_ident(); }
}

| label? _TK_RES const_expr _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_STMT_LABEL();
if (expr_error) { error_expected_const_expr(); expr_value = 0; }
else if (expr_value < 0 || expr_value > 7) { error_int_range(expr_value); expr_value = 0; }
DO_stmt(0xCB81+((expr_value*8)));
break;
default: error_illegal_ident(); }
}

| label? _TK_RES const_expr _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_STMT_LABEL();
if (expr_error) { error_expected_const_expr(); expr_value = 0; }
else if (expr_value < 0 || expr_value > 7) { error_int_range(expr_value); expr_value = 0; }
DO_stmt(0xCB82+((expr_value*8)));
break;
default: error_illegal_ident(); }
}

| label? _TK_RES const_expr _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_STMT_LABEL();
if (expr_error) { error_expected_const_expr(); expr_value = 0; }
else if (expr_value < 0 || expr_value > 7) { error_int_range(expr_value); expr_value = 0; }
DO_stmt(0xCB83+((expr_value*8)));
break;
default: error_illegal_ident(); }
}

| label? _TK_RES const_expr _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_STMT_LABEL();
if (expr_error) { error_expected_const_expr(); expr_value = 0; }
else if (expr_value < 0 || expr_value > 7) { error_int_range(expr_value); expr_value = 0; }
DO_stmt(0xCB84+((expr_value*8)));
break;
default: error_illegal_ident(); }
}

| label? _TK_RES const_expr _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_STMT_LABEL();
if (expr_error) { error_expected_const_expr(); expr_value = 0; }
else if (expr_value < 0 || expr_value > 7) { error_int_range(expr_value); expr_value = 0; }
DO_stmt(0xCB86+((expr_value*8)));
break;
default: error_illegal_ident(); }
}

| label? _TK_RES const_expr _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_STMT_LABEL();
if (expr_error) { error_expected_const_expr(); expr_value = 0; }
else if (expr_value < 0 || expr_value > 7) { error_int_range(expr_value); expr_value = 0; }
DO_stmt(0xCB85+((expr_value*8)));
break;
default: error_illegal_ident(); }
}

| label? _TK_RET _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xD8);
break;
default: error_illegal_ident(); }
}

| label? _TK_RET _TK_M _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xF8);
break;
default: error_illegal_ident(); }
}

| label? _TK_RET _TK_NC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xD0);
break;
default: error_illegal_ident(); }
}

| label? _TK_RET _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xC9);
break;
default: error_illegal_ident(); }
}

| label? _TK_RET _TK_NV _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xE0);
break;
default: error_illegal_ident(); }
}

| label? _TK_RET _TK_NZ _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xC0);
break;
default: error_illegal_ident(); }
}

| label? _TK_RET _TK_P _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xF0);
break;
default: error_illegal_ident(); }
}

| label? _TK_RET _TK_PE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xE8);
break;
default: error_illegal_ident(); }
}

| label? _TK_RET _TK_PO _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xE0);
break;
default: error_illegal_ident(); }
}

| label? _TK_RET _TK_V _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xE8);
break;
default: error_illegal_ident(); }
}

| label? _TK_RET _TK_Z _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xC8);
break;
default: error_illegal_ident(); }
}

| label? _TK_RETI _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
DO_stmt(0xD9);
break;
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED4D);
break;
default: error_illegal_ident(); }
}

| label? _TK_RETN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED45);
break;
default: error_illegal_ident(); }
}

| label? _TK_RIM _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
DO_stmt(0x20);
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB17);
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB10);
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__rl_bc");
break;
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB11);
DO_stmt(0xCB10);
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB11);
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB12);
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__rl_de");
break;
case CPU_8085: 
DO_stmt(0x18);
break;
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB13);
DO_stmt(0xCB12);
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB13);
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB14);
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__rl_hl");
break;
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB15);
DO_stmt(0xCB14);
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB16);
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0016); } else { DO_stmt(0xFDCB0016); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB16); } else { DO_stmt_idx(0xFDCB16); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0016); } else { DO_stmt(0xDDCB0016); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB16); } else { DO_stmt_idx(0xDDCB16); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB15);
break;
default: error_illegal_ident(); }
}

| label? _TK_RLA _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x17);
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB07);
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB00);
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB01);
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB02);
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB03);
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB04);
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB06);
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0006); } else { DO_stmt(0xFDCB0006); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB06); } else { DO_stmt_idx(0xFDCB06); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0006); } else { DO_stmt(0xDDCB0006); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB06); } else { DO_stmt_idx(0xDDCB06); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB05);
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x07);
break;
default: error_illegal_ident(); }
}

| label? _TK_RLCA _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x07);
break;
default: error_illegal_ident(); }
}

| label? _TK_RLD _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__rld");
break;
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED6F);
break;
default: error_illegal_ident(); }
}

| label? _TK_RLDE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__rl_de");
break;
case CPU_8085: 
DO_stmt(0x18);
break;
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB13);
DO_stmt(0xCB12);
break;
default: error_illegal_ident(); }
}

| label? _TK_RM _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xF8);
break;
default: error_illegal_ident(); }
}

| label? _TK_RNC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xD0);
break;
default: error_illegal_ident(); }
}

| label? _TK_RNV _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xE0);
break;
default: error_illegal_ident(); }
}

| label? _TK_RNZ _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xC0);
break;
default: error_illegal_ident(); }
}

| label? _TK_RP _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xF0);
break;
default: error_illegal_ident(); }
}

| label? _TK_RPE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xE8);
break;
default: error_illegal_ident(); }
}

| label? _TK_RPO _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xE0);
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB1F);
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB18);
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__rr_bc");
break;
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB18);
DO_stmt(0xCB19);
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB19);
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB1A);
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__rr_de");
break;
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB1A);
DO_stmt(0xCB1B);
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB1B);
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB1C);
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__rr_hl");
break;
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB1C);
DO_stmt(0xCB1D);
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB1E);
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB001E); } else { DO_stmt(0xFDCB001E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB1E); } else { DO_stmt_idx(0xFDCB1E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB001E); } else { DO_stmt(0xDDCB001E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB1E); } else { DO_stmt_idx(0xDDCB1E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB1D);
break;
default: error_illegal_ident(); }
}

| label? _TK_RRA _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x1F);
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB0F);
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB08);
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB09);
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB0A);
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB0B);
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB0C);
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB0E);
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB000E); } else { DO_stmt(0xFDCB000E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB0E); } else { DO_stmt_idx(0xFDCB0E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB000E); } else { DO_stmt(0xDDCB000E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB0E); } else { DO_stmt_idx(0xDDCB0E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB0D);
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x0F);
break;
default: error_illegal_ident(); }
}

| label? _TK_RRCA _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x0F);
break;
default: error_illegal_ident(); }
}

| label? _TK_RRD _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__rrd");
break;
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED67);
break;
default: error_illegal_ident(); }
}

| label? _TK_RRHL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__sra_hl");
break;
case CPU_8085: 
DO_stmt(0x10);
break;
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB2C);
DO_stmt(0xCB1D);
break;
default: error_illegal_ident(); }
}

| label? _TK_RST const_expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_STMT_LABEL();
if (expr_error) { error_expected_const_expr(); } else {
if (expr_value > 0 && expr_value < 8) expr_value *= 8;
switch (expr_value) {
case 0x00: case 0x08: case 0x30:
  if (opts.cpu & CPU_RABBIT)
    DO_stmt(0xcd0000 + (expr_value << 8));
  else
    DO_stmt(0xc7 + expr_value);
  break;
case 0x10: case 0x18: case 0x20: case 0x28: case 0x38:
  DO_stmt(0xc7 + expr_value); break;
default: error_int_range(expr_value);
}}
break;
default: error_illegal_ident(); }
}

| label? _TK_RSTV _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
DO_stmt(0xCB);
break;
default: error_illegal_ident(); }
}

| label? _TK_RV _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xE8);
break;
default: error_illegal_ident(); }
}

| label? _TK_RZ _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xC8);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBB _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x9F);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBB _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x98);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBB _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x99);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBB _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x9A);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBB _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x9B);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBB _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x9C);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBB _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x9D);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBB _TK_M _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x9E);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x9F);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x98);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x99);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x9A);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x9B);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x9C);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x9E);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD9E00); } else { DO_stmt(0xFD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD9E); } else { DO_stmt_idx(0xFD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD9E00); } else { DO_stmt(0xDD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD9E); } else { DO_stmt_idx(0xDD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x9D);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xDE);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x9F);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x98);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x99);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x9A);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x9B);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x9C);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_HL _TK_COMMA _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__sbc_hl_bc");
break;
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED42);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_HL _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__sbc_hl_de");
break;
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED52);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_HL _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__sbc_hl_hl");
break;
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED62);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_HL _TK_COMMA _TK_SP _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__sbc_hl_sp");
break;
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED72);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x9E);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD9E00); } else { DO_stmt(0xFD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD9E); } else { DO_stmt_idx(0xFD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD9E00); } else { DO_stmt(0xDD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD9E); } else { DO_stmt_idx(0xDD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x9D);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xDE);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBI expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xDE);
break;
default: error_illegal_ident(); }
}

| label? _TK_SCF _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x37);
break;
default: error_illegal_ident(); }
}

| label? _TK_SET const_expr _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_STMT_LABEL();
if (expr_error) { error_expected_const_expr(); expr_value = 0; }
else if (expr_value < 0 || expr_value > 7) { error_int_range(expr_value); expr_value = 0; }
DO_stmt(0xCBC7+((expr_value*8)));
break;
default: error_illegal_ident(); }
}

| label? _TK_SET const_expr _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_STMT_LABEL();
if (expr_error) { error_expected_const_expr(); expr_value = 0; }
else if (expr_value < 0 || expr_value > 7) { error_int_range(expr_value); expr_value = 0; }
DO_stmt(0xCBC0+((expr_value*8)));
break;
default: error_illegal_ident(); }
}

| label? _TK_SET const_expr _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_STMT_LABEL();
if (expr_error) { error_expected_const_expr(); expr_value = 0; }
else if (expr_value < 0 || expr_value > 7) { error_int_range(expr_value); expr_value = 0; }
DO_stmt(0xCBC1+((expr_value*8)));
break;
default: error_illegal_ident(); }
}

| label? _TK_SET const_expr _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_STMT_LABEL();
if (expr_error) { error_expected_const_expr(); expr_value = 0; }
else if (expr_value < 0 || expr_value > 7) { error_int_range(expr_value); expr_value = 0; }
DO_stmt(0xCBC2+((expr_value*8)));
break;
default: error_illegal_ident(); }
}

| label? _TK_SET const_expr _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_STMT_LABEL();
if (expr_error) { error_expected_const_expr(); expr_value = 0; }
else if (expr_value < 0 || expr_value > 7) { error_int_range(expr_value); expr_value = 0; }
DO_stmt(0xCBC3+((expr_value*8)));
break;
default: error_illegal_ident(); }
}

| label? _TK_SET const_expr _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_STMT_LABEL();
if (expr_error) { error_expected_const_expr(); expr_value = 0; }
else if (expr_value < 0 || expr_value > 7) { error_int_range(expr_value); expr_value = 0; }
DO_stmt(0xCBC4+((expr_value*8)));
break;
default: error_illegal_ident(); }
}

| label? _TK_SET const_expr _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_STMT_LABEL();
if (expr_error) { error_expected_const_expr(); expr_value = 0; }
else if (expr_value < 0 || expr_value > 7) { error_int_range(expr_value); expr_value = 0; }
DO_stmt(0xCBC6+((expr_value*8)));
break;
default: error_illegal_ident(); }
}

| label? _TK_SET const_expr _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_STMT_LABEL();
if (expr_error) { error_expected_const_expr(); expr_value = 0; }
else if (expr_value < 0 || expr_value > 7) { error_int_range(expr_value); expr_value = 0; }
DO_stmt(0xCBC5+((expr_value*8)));
break;
default: error_illegal_ident(); }
}

| label? _TK_SHLD expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x22);
break;
default: error_illegal_ident(); }
}

| label? _TK_SHLDE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
DO_stmt(0xD9);
break;
default: error_illegal_ident(); }
}

| label? _TK_SHLX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
DO_stmt(0xD9);
break;
default: error_illegal_ident(); }
}

| label? _TK_SIM _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
DO_stmt(0x30);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB27);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB20);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB21);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB22);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB23);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB24);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB26);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0026); } else { DO_stmt(0xFDCB0026); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB26); } else { DO_stmt_idx(0xFDCB26); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0026); } else { DO_stmt(0xDDCB0026); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB26); } else { DO_stmt_idx(0xDDCB26); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB25);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB37);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB30);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB31);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB32);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB33);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB34);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB36);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0036); } else { DO_stmt(0xFDCB0036); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB36); } else { DO_stmt_idx(0xFDCB36); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0036); } else { DO_stmt(0xDDCB0036); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB36); } else { DO_stmt_idx(0xDDCB36); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB35);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB37);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB30);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB31);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB32);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB33);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB34);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB36);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0036); } else { DO_stmt(0xFDCB0036); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB36); } else { DO_stmt_idx(0xFDCB36); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0036); } else { DO_stmt(0xDDCB0036); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB36); } else { DO_stmt_idx(0xDDCB36); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB35);
break;
default: error_illegal_ident(); }
}

| label? _TK_SPHL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xF9);
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB2F);
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB28);
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__sra_bc");
break;
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB28);
DO_stmt(0xCB19);
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB29);
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB2A);
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__sra_de");
break;
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB2A);
DO_stmt(0xCB1B);
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB2B);
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB2C);
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__sra_hl");
break;
case CPU_8085: 
DO_stmt(0x10);
break;
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB2C);
DO_stmt(0xCB1D);
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB2E);
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB002E); } else { DO_stmt(0xFDCB002E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB2E); } else { DO_stmt_idx(0xFDCB2E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB002E); } else { DO_stmt(0xDDCB002E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB2E); } else { DO_stmt_idx(0xDDCB2E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB2D);
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB3F);
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB38);
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB39);
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB3A);
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB3B);
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB3C);
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB3E);
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB003E); } else { DO_stmt(0xFDCB003E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB3E); } else { DO_stmt_idx(0xFDCB3E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB003E); } else { DO_stmt(0xDDCB003E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB3E); } else { DO_stmt_idx(0xDDCB3E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB3D);
break;
default: error_illegal_ident(); }
}

| label? _TK_STA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x32);
break;
case CPU_GBZ80: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xEA);
break;
default: error_illegal_ident(); }
}

| label? _TK_STAX _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x02);
break;
default: error_illegal_ident(); }
}

| label? _TK_STAX _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x02);
break;
default: error_illegal_ident(); }
}

| label? _TK_STAX _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x12);
break;
default: error_illegal_ident(); }
}

| label? _TK_STAX _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x12);
break;
default: error_illegal_ident(); }
}

| label? _TK_STC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x37);
break;
default: error_illegal_ident(); }
}

| label? _TK_STOP _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
DO_stmt(0x1000);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x97);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x90);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x91);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x92);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x93);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x94);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x96);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD9600); } else { DO_stmt(0xFD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD96); } else { DO_stmt_idx(0xFD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD9600); } else { DO_stmt(0xDD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD96); } else { DO_stmt_idx(0xDD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x95);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xD6);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x97);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x90);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x91);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x92);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x93);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x94);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_HL _TK_COMMA _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__sub_hl_bc");
break;
case CPU_8085: 
DO_stmt(0x08);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_HL _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__sub_hl_de");
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_HL _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__sub_hl_hl");
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_HL _TK_COMMA _TK_SP _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__sub_hl_sp");
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x96);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD9600); } else { DO_stmt(0xFD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD96); } else { DO_stmt_idx(0xFD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD9600); } else { DO_stmt(0xDD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD96); } else { DO_stmt_idx(0xDD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x95);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_M _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x96);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xD6);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUI expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xD6);
break;
default: error_illegal_ident(); }
}

| label? _TK_SWAP _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
DO_stmt(0xCB37);
break;
default: error_illegal_ident(); }
}

| label? _TK_SWAP _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
DO_stmt(0xCB30);
break;
default: error_illegal_ident(); }
}

| label? _TK_SWAP _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
DO_stmt(0xCB31);
break;
default: error_illegal_ident(); }
}

| label? _TK_SWAP _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
DO_stmt(0xCB32);
break;
default: error_illegal_ident(); }
}

| label? _TK_SWAP _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
DO_stmt(0xCB33);
break;
default: error_illegal_ident(); }
}

| label? _TK_SWAP _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
DO_stmt(0xCB34);
break;
default: error_illegal_ident(); }
}

| label? _TK_SWAP _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
DO_stmt(0xCB36);
break;
default: error_illegal_ident(); }
}

| label? _TK_SWAP _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
DO_stmt(0xCB35);
break;
default: error_illegal_ident(); }
}

| label? _TK_XCHG _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
DO_stmt(0xE5);
DO_stmt(0xD5);
DO_stmt(0xE1);
DO_stmt(0xD1);
break;
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xEB);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xAF);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xA8);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xA9);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xAA);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xAB);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xAC);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xAE);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDAE00); } else { DO_stmt(0xFDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDAE); } else { DO_stmt_idx(0xFDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDAE00); } else { DO_stmt(0xDDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDAE); } else { DO_stmt_idx(0xDDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xAD);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xEE);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xAF);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xA8);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xA9);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xAA);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xAB);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xAC);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xAE);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDAE00); } else { DO_stmt(0xFDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDAE); } else { DO_stmt_idx(0xFDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDAE00); } else { DO_stmt(0xDDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDAE); } else { DO_stmt_idx(0xDDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xAD);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xEE);
break;
default: error_illegal_ident(); }
}

| label? _TK_XRA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xAF);
break;
default: error_illegal_ident(); }
}

| label? _TK_XRA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xA8);
break;
default: error_illegal_ident(); }
}

| label? _TK_XRA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xA9);
break;
default: error_illegal_ident(); }
}

| label? _TK_XRA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xAA);
break;
default: error_illegal_ident(); }
}

| label? _TK_XRA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xAB);
break;
default: error_illegal_ident(); }
}

| label? _TK_XRA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xAC);
break;
default: error_illegal_ident(); }
}

| label? _TK_XRA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xAD);
break;
default: error_illegal_ident(); }
}

| label? _TK_XRA _TK_M _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xAE);
break;
default: error_illegal_ident(); }
}

| label? _TK_XRI expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xEE);
break;
default: error_illegal_ident(); }
}

| label? _TK_XTHL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xE3);
break;
default: error_illegal_ident(); }
}

