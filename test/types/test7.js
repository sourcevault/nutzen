var com, z, l, R, j, zj, print_fail, zn, be, p, V;
com = require('../../dist/utils/main');
z = com.z, l = com.l, R = com.R, j = com.j, zj = com.zj, print_fail = com.print_fail, zn = com.zn;
be = require('../../dist/types/main');
p = print_fail("test/types/test7.js");
V = be.arr.err(["first error"]).or(be(function(){
  return [false, 'initial'];
}).err(function(stuff){
  return ["second error"];
})).err(function(msg, path){
  z(msg, path);
  return {
    message: 'ac_input',
    path: []
  };
});