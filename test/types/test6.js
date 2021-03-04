var reg, be, com, print, z, l, hop, print_fail, p, T, F, V, ret;
reg = require("../dist/registry");
be = require("../dist/main");
com = reg.com, print = reg.print;
z = com.z, l = com.l, hop = com.hop, print_fail = com.print_fail;
p = print_fail("test/test6.js");
T = function(x){
  return true;
};
F = function(x){
  return [false, 'foobar'];
};
V = be.restricted([0, 1]);
ret = V.auth(['a', 'b', 'c']);
if (!(ret.message[0] === ':res')) {
  p(".restricted message is not accurate.");
}