var proj, name, pkg, internal, types, guard, l, z, c, binapi, print_fail, create_stack, R, be, xop, pf, dum1, dum2, V, out;
proj = 'guard';
name = 'test2';
pkg = require('../../dist/types/main');
internal = pkg.internal, types = pkg.types, guard = pkg.guard;
l = internal.l, z = internal.z, c = internal.c, binapi = internal.binapi, print_fail = internal.print_fail, create_stack = internal.create_stack, R = internal.R;
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