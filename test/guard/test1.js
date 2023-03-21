var proj, name, pkg, internal, types, guard, l, z, c, binapi, print_fail, create_stack, R, be, xop, pf, V1, retorn, V2, txt;
proj = 'guard';
name = 'test1';
pkg = require('../../dist/types/main');
internal = pkg.internal, types = pkg.types, guard = pkg.guard;
l = internal.l, z = internal.z, c = internal.c, binapi = internal.binapi, print_fail = internal.print_fail, create_stack = internal.create_stack, R = internal.R;
be = types;
xop = guard;
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