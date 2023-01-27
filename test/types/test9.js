var com, z, l, R, j, zj, print_fail, be, V, V1;
com = require('../../dist/utils/main').com;
z = com.z, l = com.l, R = com.R, j = com.j, zj = com.zj, print_fail = com.print_fail;
be = require('../../dist/types/main');
V = be.arr.err(['hello world']).err(function(msg){
  return z(be.flatro(msg));
});
V1 = be.arr.err([':me', 'frostbite']).err(function(msg){
  return z(be.flatro(msg));
});