var ref$, utils, types, z, l, R, j, print_fail, be, p, T, F, data, V;
ref$ = require('../../dist/types/main'), utils = ref$.utils, types = ref$.types;
z = utils.z, l = utils.l, R = utils.R, j = utils.j, print_fail = utils.print_fail;
be = types;
p = print_fail("test/types/test.js");
T = function(x){
  return true;
};
F = function(x){
  return [false, 'foobar'];
};
data = {
  foo: {
    bar: "hello world"
  }
};
V = be(function(){
  return false;
}).or(be.arr.map(be.str));
V = be.obj.on('foo', be.obj.on('bar', be.num.cont(function(x, a, b, c, d){
  return x;
})).on('bar', be.str.and(function(x, j, k){
  z("second: ", j, k);
  return true;
}))).on(['foo', 'bar'], function(val, j, k){
  z(j, k);
  return true;
});
V.auth({
  foo: {
    bar: 1
  }
}, ['data'], ['file']);