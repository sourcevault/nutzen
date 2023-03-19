var proj, name, ref$, utils, types, guard, l, z, c, binapi, print_fail, create_stack, R, be, xop, pf, type_num, type_str, V, out;
proj = 'guard';
name = 'test4';
ref$ = require('../../dist/types/main'), utils = ref$.utils, types = ref$.types, guard = ref$.guard;
l = utils.l, z = utils.z, c = utils.c, binapi = utils.binapi, print_fail = utils.print_fail, create_stack = utils.create_stack, R = utils.R;
be = types;
xop = guard;
pf = print_fail("test/" + proj + "/" + name + ".js");
type_num = function(x){
  switch (x) {
  case 'integer':
    return 'int';
  case 'boolean':
    return 'bool';
  default:
    return false;
  }
};
type_str = function(x){
  switch (x) {
  case 'string':
    return 'str';
  default:
    return false;
  }
};
V = xop.ar(1, xop.cap(type_num, function(x){
  return x;
}).def(["FROM UDEF"])).def(null);
out = V('integer');
if (!(out === 'int')) {
  pf();
}
out = V(null);
if (R.type(out) !== 'Array') {
  pf(".ar not working");
}
if (out[0] !== "FROM UDEF") {
  pf();
}