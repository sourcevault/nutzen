var proj, name, ref$, internal, types, guard, l, z, c, binapi, print_fail, create_stack, R, be, xop, pf, type_num, type_str, V, out;
proj = 'guard';
name = 'test4';
ref$ = require('../../dist/types/main'), internal = ref$.internal, types = ref$.types, guard = ref$.guard;
l = internal.l, z = internal.z, c = internal.c, binapi = internal.binapi, print_fail = internal.print_fail, create_stack = internal.create_stack, R = internal.R;
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