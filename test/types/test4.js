var com, z, l, R, j, zj, print_fail, be, p, inn, main, example, V;
com = require('../../dist/utils/main');
z = com.z, l = com.l, R = com.R, j = com.j, zj = com.zj, print_fail = com.print_fail;
be = require('../../dist/types/main');
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
V = be.str.fix(function(val){
  return val;
});