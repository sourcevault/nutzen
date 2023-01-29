var ref$, utils, types, z, l, R, j, print_fail, be, V, sample_data;
ref$ = require('../../dist/main'), utils = ref$.utils, types = ref$.types;
z = utils.z, l = utils.l, R = utils.R, j = utils.j, print_fail = utils.print_fail;
be = types;
V = be.known.obj.on([['and', 'remote', be.num], ['alt', ['remotefold', 'remotehost'], be.undefnull.cont(45)], ['and', 'foobar', be.num]]);
sample_data = {
  remote: 1,
  remotfold: 3,
  foobar: 4
};