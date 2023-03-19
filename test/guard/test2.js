var proj, name, ref$, utils, types, guard, l, z, c, binapi, print_fail, create_stack, R, be, xop, pf, dum1, dum2, V, out;
proj = 'guard';
name = 'test2';
ref$ = require('../../dist/types/main'), utils = ref$.utils, types = ref$.types, guard = ref$.guard;
l = utils.l, z = utils.z, c = utils.c, binapi = utils.binapi, print_fail = utils.print_fail, create_stack = utils.create_stack, R = utils.R;
be = types;
xop = guard;
pf = print_fail("test/" + proj + "/" + name + ".js");
dum1 = function(str){
  switch (str) {
  case 'int':
    return 'intger';
  case 'str':
    return 'string';
  }
};
dum2 = function(str){
  switch (str) {
  case 'obj':
    return 'object';
  case 'map':
    return 'map';
  }
};
V = xop.cap(dum2, 'obj_or_map').def(null);
out = V('obj');
if (out !== 'obj_or_map') {
  pf();
}