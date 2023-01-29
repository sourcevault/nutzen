var ref$, utils, types, z, l, R, j, print_fail, be, p, address, V, sample, sortir;
ref$ = require('../../dist/main'), utils = ref$.utils, types = ref$.types;
z = utils.z, l = utils.l, R = utils.R, j = utils.j, print_fail = utils.print_fail;
be = types;
p = print_fail("test/types/test1.js");
address = be.required('city').on('city', be.str).on('country', be.str.fix('France'));
V = be.required('name', 'age', 'address').on('address', address).on('name', be.str).on('age', be.num);
sample = {
  name: "Fred",
  age: 30,
  address: {
    city: "foocity",
    country: null
  }
};
sortir = V.auth(sample);
if (!(sortir.value.address.country === 'France')) {
  p();
}