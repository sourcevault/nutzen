var proj, name, path, oxo, com, l, zj, z, c, binapi, print_fail, create_stack, R, pf;
proj = 'guard';
name = 'test5';
path = function(name){
  return "../../dist/" + name + "/main";
};
oxo = require(path('guard'));
com = require(path('utils'));
l = com.l, zj = com.zj, z = com.z, c = com.c, binapi = com.binapi, print_fail = com.print_fail, create_stack = com.create_stack, R = com.R;
pf = print_fail("test/" + proj + "/" + name + ".js");