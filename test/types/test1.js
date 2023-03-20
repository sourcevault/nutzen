var pkg, internal, types, z, l, R, j, print_fail, be, p, address, V, sample1, von, sample_2;
pkg = require('../../dist/types/main');
internal = pkg.internal, types = pkg.types;
z = internal.z, l = internal.l, R = internal.R, j = internal.j, print_fail = internal.print_fail;
be = types;
p = print_fail("test/types/test1.js");
address = be.required('city').on('city', be.str).on('country', be.str.fix('France'));
V = be.required('name', 'age', 'address').on('address', address).on('name', be.str).on('age', be.num);
sample1 = {
  name: "Fred",
  age: 30,
  address: {
    city: "foocity",
    country: null
  }
};
von = V.auth(sample1);
if (!(von.value.address.country === 'France')) {
  p();
}
sample_2 = {
  name: "Fred",
  age: 30
};
von = V.auth(sample_2);
if (!(von.path[0] === 'address' && von.message[0] === ':req' && von.message[1][2] === 'address')) {
  p("TEST NUMBER 2 - fault in .required error message.");
}