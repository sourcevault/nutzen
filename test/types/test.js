var com, z, l, R, j, zj, print_fail, be, V, sample_data;
com = require('../../dist/utils/main');
z = com.z, l = com.l, R = com.R, j = com.j, zj = com.zj, print_fail = com.print_fail;
be = require('../../dist/types/main');
V = be.known.obj.on([['and', 'remote', be.num], ['alt', ['remotefold', 'remotehost'], be.undefnull.cont(45)], ['and', 'foobar', be.num]]);
sample_data = {
  remote: 1,
  remotfold: 3,
  foobar: 4
};