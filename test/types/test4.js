var reg, ref$, z, noops, print_fail, be, p, inn, main, example, ret;
reg = require("../dist/registry");
ref$ = reg.com, z = ref$.z, noops = ref$.noops, print_fail = ref$.print_fail;
be = require("../dist/main");
p = print_fail("test/test1.js");
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
ret = main.auth(example);