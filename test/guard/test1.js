var proj, name, path, xop, com, l, zj, z, c, binapi, print_fail, create_stack, R, pf, V1, retorn, V2, txt;
proj = 'guard';
name = 'test1';
path = function(name){
  return "../../dist/" + name + "/main";
};
xop = require(path('guard'));
com = require(path('utils'));
l = com.l, zj = com.zj, z = com.z, c = com.c, binapi = com.binapi, print_fail = com.print_fail, create_stack = com.create_stack, R = com.R;
pf = print_fail("test/" + proj + "/" + name + ".js");
V1 = xop.arcap(1, function(){
  return [false, "hello"];
}, function(){
  return "world";
}, function(){}).def("foobar");
retorn = V1(1);
if (!(retorn === "world")) {
  pf(".arcap / normal validator function");
}
V2 = xop.arcap(1, function(){
  return [false];
}, function(){}, function(){
  return [];
}).def('from_def');
txt = V2(1);
if (!(txt === 'from_def')) {
  pf(".arcap error handling not being done correctly");
}
V2 = xop.cap(function(){
  return [true, 5];
}, function(){}, function(){
  return arguments;
}).def(39);
retorn = V2(6);
if (retorn[0] !== 5 || retorn[1] !== 6) {
  pf(".cap error");
}