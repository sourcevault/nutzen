var ref$, utils, types, z, l, R, j, print_fail, be, p, inn, main, example;
ref$ = require('../../dist/main'), utils = ref$.utils, types = ref$.types;
z = utils.z, l = utils.l, R = utils.R, j = utils.j, print_fail = utils.print_fail;
be = types;
p = print_fail("test/types/test4.js");
inn = be.str.or(be.num.or(be.obj.on("age", be.num)));
main = be.obj.map(inn);
example = {
  'adam': {
    age: null
  },
  'charles': 35,
  'henry': {
    age: 'foobar'
  },
  'joe': 33
};