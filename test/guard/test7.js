var proj, name, pkg, internal, types, guard, l, z, c, binapi, print_fail, create_stack, R, be, xop, pf, F, T, binto, ob;
proj = 'guard';
name = 'test7';
pkg = require('../../dist/types/main');
internal = pkg.internal, types = pkg.types, guard = pkg.guard;
l = internal.l, z = internal.z, c = internal.c, binapi = internal.binapi, print_fail = internal.print_fail, create_stack = internal.create_stack, R = internal.R;
be = types;
xop = guard;
pf = print_fail("test/" + proj + "/" + name + ".js");
F = function(){
  return false;
};
T = function(){
  return true;
};
binto = {};
binto[1] = function(){
  return z('binto_1');
};
binto[2] = function(){
  return z('binto_2');
};
ob = {
  1: [[F, binto[1]], [T, binto[2]]]
};