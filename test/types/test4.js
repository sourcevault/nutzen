var pkg, internal, types, z, l, R, j, print_fail, be, p, inn, main, example, von;
pkg = require('../../dist/types/main');
internal = pkg.internal, types = pkg.types;
z = internal.z, l = internal.l, R = internal.R, j = internal.j, print_fail = internal.print_fail;
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
von = main.auth(example);