var proj, name, pkg, internal, types, guard, l, z, c, binapi, print_fail, create_stack, be, fail, bothNum, argE, typeE, add;
proj = 'guard';
name = 'test';
pkg = require('../../dist/types/main');
internal = pkg.internal, types = pkg.types, guard = pkg.guard;
l = internal.l, z = internal.z, c = internal.c, binapi = internal.binapi, print_fail = internal.print_fail, create_stack = internal.create_stack;
be = types;
fail = print_fail("test/" + proj + "/" + name + ".js");
bothNum = function(x, y){
  return typeof x === "number" && typeof y === "number";
};
argE = function(){
  return z("only accepts 2 arugument");
};
typeE = function(){
  return z("argument type has to be number");
};
add = function(x, y){
  return x + y;
};