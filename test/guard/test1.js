var proj, name, path, guard, com, l, zj, z, c, binapi, print_fail, create_stack, R, pf, V1, retorn, V2, empty_array;
proj = 'guard';
name = 'test1';
path = function(name){
  return "../../dist/" + name + "/main";
};
guard = require(path('guard'));
com = require(path('utils'));
l = com.l, zj = com.zj, z = com.z, c = com.c, binapi = com.binapi, print_fail = com.print_fail, create_stack = com.create_stack, R = com.R;
pf = print_fail("test/" + proj + "/" + name + ".js");
V1 = guard.arpar(1, function(){
  return [false, "hello"];
}, function(){
  return "world";
}, function(){
  return false;
}).def("foobar");
retorn = V1(1);
if (!(retorn === "foobar")) {
  pf(".arpar / normal validator function");
}
V2 = guard.arpar(1, function(){
  return [false];
}, function(){}, function(){
  return arguments[0];
}).def();
empty_array = V2(1);
if (!(R.type(empty_array) === 'Array')) {
  pf(".arpar error handling not being done correctly");
}