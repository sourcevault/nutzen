var proj, name, path, oxo, com, l, zj, z, c, binapi, print_fail, create_stack, R, pf, type_num, type_str, V, out;
proj = 'guard';
name = 'test4';
path = function(name){
  return "../../dist/" + name + "/main";
};
oxo = require(path('guard'));
com = require(path('utils'));
l = com.l, zj = com.zj, z = com.z, c = com.c, binapi = com.binapi, print_fail = com.print_fail, create_stack = com.create_stack, R = com.R;
pf = print_fail("test/" + proj + "/" + name + ".js");
type_num = function(x){
  switch (x) {
  case 'integer':
    return 'int';
  case 'boolean':
    return 'bool';
  default:
    return false;
  }
};
type_str = function(x){
  switch (x) {
  case 'string':
    return 'str';
  default:
    return false;
  }
};
V = oxo.ar(1, oxo.ma(type_num, function(x){
  return x;
}).def(["FROM UDEF"])).def(null);
out = V('integer');
if (!(out === 'int')) {
  p();
}
out = V(null);
if (!(R.type(out) === 'Array')) {
  p();
}
if (!(out[0] === "FROM UDEF")) {
  p();
}