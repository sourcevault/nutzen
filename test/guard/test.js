var proj, name, pkg, utils, types, guard, l, z, c, binapi, print_fail, create_stack, be, fail, bothNum, argE, typeE, add;
proj = 'guard';
name = 'test';
pkg = require('../../dist/types/main');
utils = pkg.utils, types = pkg.types, guard = pkg.guard;
l = utils.l, z = utils.z, c = utils.c, binapi = utils.binapi, print_fail = utils.print_fail, create_stack = utils.create_stack;
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