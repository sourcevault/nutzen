var proj, name, path, xop, com, l, zj, z, c, binapi, print_fail, create_stack, R, pf, dum1, dum2, V, out;
proj = 'guard';
name = 'test2';
path = function(name){
  return "../../dist/" + name + "/main";
};
xop = require(path('guard'));
com = require(path('utils')).com;
l = com.l, zj = com.zj, z = com.z, c = com.c, binapi = com.binapi, print_fail = com.print_fail, create_stack = com.create_stack, R = com.R;
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