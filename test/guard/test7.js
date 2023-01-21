var proj, name, path, guard, xop, com, l, zj, z, c, binapi, print_fail, create_stack, R, pf, F, T, binto, ob;
proj = 'guard';
name = 'test7';
path = function(name){
  return "../../dist/" + name + "/main";
};
guard = require(path('guard'));
xop = guard;
com = require(path('utils'));
l = com.l, zj = com.zj, z = com.z, c = com.c, binapi = com.binapi, print_fail = com.print_fail, create_stack = com.create_stack, R = com.R;
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