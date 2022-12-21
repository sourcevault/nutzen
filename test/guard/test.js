var proj, name, path, guard, com, l, zj, z, c, binapi, print_fail, create_stack, fail, bothNum, argE, typeE, add;
proj = 'guard';
name = 'test';
path = function(name){
  return "../../dist/" + name + "/main";
};
guard = require(path('guard'));
com = require(path('utils'));
l = com.l, zj = com.zj, z = com.z, c = com.c, binapi = com.binapi, print_fail = com.print_fail, create_stack = com.create_stack;
fail = print_fail("test/" + proj + "/" + name + ".js");
bothNum = function(x, y){
  return typeof x === "number" && typeof y === "number";
};
argE = function(){
  return z("only accepts 2 arugument");
};
typeE = function(){
  return z("argument type has to be number");
};
add = function(x, y){
  return x + y;
};