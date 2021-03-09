var proj, name, path, guard, com, l, zj, z, c, binapi, print_fail, create_stack, R, pf, oxo, V_inner, V_outer, ret;
proj = 'guard';
name = 'test3';
path = function(name){
  return "../../dist/" + name + "/main";
};
guard = require(path('guard'));
com = require(path('utils'));
l = com.l, zj = com.zj, z = com.z, c = com.c, binapi = com.binapi, print_fail = com.print_fail, create_stack = com.create_stack, R = com.R;
pf = print_fail("test/" + proj + "/" + name + ".js");
oxo = guard.debug;
V_inner = oxo.wh(function(){
  return true;
}, function(){
  return true;
}).def();
V_outer = oxo.wh(function(){
  return true;
}, V_inner).def(null);
ret = V_outer([1, 2, 4], [1, 2, 4]);
if (!ret) {
  p();
}