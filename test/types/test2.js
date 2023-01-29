var ref$, utils, types, z, l, R, j, print_fail, be, p, G7, valG7, isG7, ret1, ret2;
ref$ = require('../../dist/main'), utils = ref$.utils, types = ref$.types;
z = utils.z, l = utils.l, R = utils.R, j = utils.j, print_fail = utils.print_fail;
be = types;
p = print_fail("test/types/test2.js");
G7 = new Set(["USA", "EU", "UK", "Japan", "Italy", "Germany", "France"]);
valG7 = function(s){
  if (G7.has(s)) {
    return true;
  } else {
    return [false, "not in G7"];
  }
};
isG7 = be.str.and(valG7);
ret1 = isG7.auth("UK");
ret2 = isG7.auth("Spain");
if (!(ret1.value === 'UK')) {
  p();
}
if (!(ret2.message === "not in G7")) {
  p();
}
if (ret2.value === undefined) {
  p(".value has not been passed to {..error:true..}.");
}