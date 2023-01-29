var proj, name, ref$, utils, types, guard, l, z, c, binapi, print_fail, create_stack, R, be, xop, pf, F, T, binto, ob;
proj = 'guard';
name = 'test7';
ref$ = require('../../dist/main'), utils = ref$.utils, types = ref$.types, guard = ref$.guard;
l = utils.l, z = utils.z, c = utils.c, binapi = utils.binapi, print_fail = utils.print_fail, create_stack = utils.create_stack, R = utils.R;
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