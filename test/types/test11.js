var pkg, internal, types, z, l, R, j, print_fail, p, be, S, N, V, fin_ret, name, val, r1, von, r2, r3, r4, r5;
pkg = require('../../dist/types/main');
internal = pkg.internal, types = pkg.types;
z = internal.z, l = internal.l, R = internal.R, j = internal.j, print_fail = internal.print_fail;
p = print_fail("test/types/test11.js");
be = types;
S = JSON.stringify;
N = be.num.tap(function(x, index, accum){
  return accum.push("a:" + x);
});
V = {};
fin_ret = function(){
  var fin;
  fin = arguments[arguments.length - 1];
  return fin;
};
V[0] = be.arr.forEach([0, 1, 1], N);
V[1] = be.arr.forEach([2, 1, 1], N);
V[2] = be.arr.forEach([0, -1, 1], N);
V[3] = be.arr.forEach([-1, 0, -1], N);
V[4] = be.arr.forEach([-1, 0, 1], N);
for (name in V) {
  val = V[name];
  V[name] = val.cont(fin_ret).wrap;
}
r1 = V[0]([0, 1, 2, 3], []);
von = S(r1);
if (von !== '["a:0","a:1"]') {
  p("TEST NUMBER 1.");
}
r2 = V[1]([0, 1, 2, 3], []);
von = S(r2);
if (von !== '[]') {
  p("TEST NUMBER 2.");
}
r3 = V[2]([0, 1, 2, 3], []);
von = S(r3);
if (von !== '["a:0","a:1","a:2","a:3"]') {
  p("TEST NUMBER 3.");
}
r4 = V[3]([0, 1, 2, 3], []);
von = S(r4);
if (von !== '["a:3","a:2","a:1","a:0"]') {
  p("TEST NUMBER 4.");
}
V = be.arr['try'].on(0, be.num).err(function(arr){
  return 'num';
}).err(function(arr){
  return 'num1';
})['try'].on(0, be.str).err(function(arr){
  return 'str';
}).err(function(arr){
  return 'str1';
});
r5 = V.auth([]);
von = S(r5.message);
if (von !== '["str1","num1"]') {
  p("TEST NUMBER 5.");
}
von = V.auth([1]);
if (!von['continue']) {
  p("TEST NUMBER 6.");
}
von = V.auth(['s']);
if (!von['continue']) {
  p("TEST NUMBER 7.");
}