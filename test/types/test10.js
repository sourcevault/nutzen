var pkg, internal, types, z, l, R, j, print_fail, xop, be, V;
pkg = require('../../dist/types/main');
internal = pkg.internal, types = pkg.types;
z = internal.z, l = internal.l, R = internal.R, j = internal.j, print_fail = internal.print_fail;
xop = pkg.guard;
be = pkg.types;
V = be.num.cont(function(){
  return 'n';
}).alt(be.objerr).wrap;
V(1, 2);