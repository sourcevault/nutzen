var proj, name, ref$, utils, types, guard, l, z, c, binapi, print_fail, create_stack, R, be, xop, pf, V_inner, V_outer, ret;
proj = 'guard';
name = 'test3';
ref$ = require('../../dist/main'), utils = ref$.utils, types = ref$.types, guard = ref$.guard;
l = utils.l, z = utils.z, c = utils.c, binapi = utils.binapi, print_fail = utils.print_fail, create_stack = utils.create_stack, R = utils.R;
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