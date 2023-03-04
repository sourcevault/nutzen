var ref$, utils, types, z, l, R, j, print_fail, be, N, V, fin_ret, name, val, r1, r2, r3, r4, r5, F, augh;
ref$ = require('../../dist/main'), utils = ref$.utils, types = ref$.types;
z = utils.z, l = utils.l, R = utils.R, j = utils.j, print_fail = utils.print_fail;
be = types;
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
r2 = V[1]([0, 1, 2, 3], []);
r3 = V[2]([0, 1, 2, 3], []);
r4 = V[3]([0, 1, 2, 3], []);
r5 = V[4]([0, 1, 2, 3], []);
l(R.equals(r1, ['a:0', 'a:1']));
F = function(data){
  if (data === 2) {
    return true;
  }
  return false;
};
V = be.arr.onor([0, 1], F);
V.auth([1, 2, 3]);
V = be.arr['try'].on(0, be.num).err(function(arr){
  return 'num';
}).err(function(arr){
  return 'num1';
}).fix(function(x){
  return x;
})['try'].on(1, be.str).err(function(arr){
  return 'str';
}).err(function(arr){
  return 'str1';
});
augh = V.auth([]);
l("---- V.auth [] ----");
l(augh);
augh = V.auth([1]);
l("---- V.auth [1] ----");
l(augh);
augh = V.auth(['s']);
l("---- V.auth ['s'] ----");
l(augh);