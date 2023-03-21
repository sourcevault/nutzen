var proj, name, pkg, internal, types, guard, l, z, c, binapi, print_fail, create_stack, R, be, xop, pf, V_inner, V_outer, ret;
proj = 'guard';
name = 'test3';
pkg = require('../../dist/types/main');
internal = pkg.internal, types = pkg.types, guard = pkg.guard;
l = internal.l, z = internal.z, c = internal.c, binapi = internal.binapi, print_fail = internal.print_fail, create_stack = internal.create_stack, R = internal.R;
be = types;
xop = guard;
pf = print_fail("test/" + proj + "/" + name + ".js");
xop = guard.debug;
V_inner = xop.wh(function(){
  return true;
}, function(){
  return true;
}).def();
V_outer = xop.wh(function(){
  return true;
}, V_inner).def(null);
ret = V_outer([1, 2, 4], [1, 2, 4]);
if (!ret) {
  pf(".wh not working");
}