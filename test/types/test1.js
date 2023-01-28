var com, z, l, R, j, zj, print_fail, be, p, address, V, sample, sortir;
com = require("./utils/main");
z = com.z, l = com.l, R = com.R, j = com.j, zj = com.zj, print_fail = com.print_fail;
be = require('../../dist/types/main');
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