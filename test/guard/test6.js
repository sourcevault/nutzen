var proj, name, ref$, utils, types, guard, l, z, c, binapi, print_fail, create_stack, R, be, xop, pf, bothNum, argE, typeE, add2, add, ret;
proj = 'guard';
name = 'test6';
ref$ = require('../../dist/main'), utils = ref$.utils, types = ref$.types, guard = ref$.guard;
l = utils.l, z = utils.z, c = utils.c, binapi = utils.binapi, print_fail = utils.print_fail, create_stack = utils.create_stack, R = utils.R;
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