var reg, valleydate, com, print, z, l, hop, R, j, zj, print_fail, p, be, T, F, data;
reg = require("../dist/registry");
valleydate = require("../dist/main");
com = reg.com, print = reg.print;
z = com.z, l = com.l, hop = com.hop, R = com.R, j = com.j, zj = com.zj, print_fail = com.print_fail;
p = print_fail("test/test.js");
be = valleydate;
T = function(x){
  return true;
};
F = function(x){
  return [false, 'foobar'];
};
data = {
  foo: {
    bar: "hello world"
  }
};