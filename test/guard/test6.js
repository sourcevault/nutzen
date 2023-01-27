var proj, name, path, xop, com, l, zj, z, c, binapi, print_fail, create_stack, R, pf, bothNum, argE, typeE, add2, add, ret;
proj = 'guard';
name = 'test6';
path = function(name){
  return "../../dist/" + name + "/main";
};
xop = require(path('guard'));
com = require(path('utils')).com;
l = com.l, zj = com.zj, z = com.z, c = com.c, binapi = com.binapi, print_fail = com.print_fail, create_stack = com.create_stack, R = com.R;
pf = print_fail("test/" + proj + "/" + name + ".js");
bothNum = function(x, y){
  return typeof x === "number" && typeof y === "number";
};
argE = function(){
  return z("only accepts 2 arugument");
};
typeE = function(){
  return z("argument type has to be number");
};
add2 = function(x, y){
  return x + y;
};
add = xop.arwh(2, function(){
  return true;
}, add2).def();
ret = add(1, 2);
if (!(ret === 3)) {
  pf();
}