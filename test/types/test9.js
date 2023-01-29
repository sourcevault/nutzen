var ref$, utils, types, z, l, R, j, print_fail, be, V, V1;
ref$ = require('../../dist/main'), utils = ref$.utils, types = ref$.types;
z = utils.z, l = utils.l, R = utils.R, j = utils.j, print_fail = utils.print_fail;
be = types;
V = be.arr.err(['hello world']).err(function(msg){
  return z(be.flatro(msg));
});
V1 = be.arr.err([':me', 'frostbite']).err(function(msg){
  return z(be.flatro(msg));
});