var proj, name, path, guard, com, l, zj, z, c, binapi, print_fail, create_stack, R, pf, dum1, dum2, V, out;
proj = 'guard';
name = 'test2';
path = function(name){
  return "../../dist/" + name + "/main";
};
guard = require(path('guard'));
com = require(path('utils'));
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
V = guard.ma(dum2, 'obj_or_map').def(null);
out = V('obj');
if (!(out === 'obj_or_map')) {
  p();
}