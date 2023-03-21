var proj, name, pkg, internal, types, guard, l, z, c, binapi, print_fail, create_stack, R, be, xop, pf, bothNum, argE, typeE, add2, add, ret;
proj = 'guard';
name = 'test6';
pkg = require('../../dist/types/main');
internal = pkg.internal, types = pkg.types, guard = pkg.guard;
l = internal.l, z = internal.z, c = internal.c, binapi = internal.binapi, print_fail = internal.print_fail, create_stack = internal.create_stack, R = internal.R;
be = types;
xop = guard;
pf = print_fail("test/" + proj + "/" + name + ".js");
bothNum = function(x, y){
  return typeof x === "number" && typeof y === "number";
};
argE = function(){
  return z("only accepts 2 arugument");
};
typeE = function(){
  return z("argument type has to be number");
};
add2 = function(x, y){
  return x + y;
};
add = xop.arwh(2, function(){
  return true;
}, add2).def();
ret = add(1, 2);
if (!(ret === 3)) {
  pf();
}