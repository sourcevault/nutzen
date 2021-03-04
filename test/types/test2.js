var reg, ref$, z, noops, print_fail, be, p, G7, valG7, isG7, ret1, ret2;
reg = require("../dist/registry");
ref$ = reg.com, z = ref$.z, noops = ref$.noops, print_fail = ref$.print_fail;
be = require("../dist/main");
p = print_fail("test/test2.js");
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