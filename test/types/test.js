var com, z, l, R, j, zj, print_fail, be, p, T, F, data, V;
com = require('../../dist/utils/main');
z = com.z, l = com.l, R = com.R, j = com.j, zj = com.zj, print_fail = com.print_fail;
be = require('../../dist/types/main');
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
  return [false, 'first'];
}).or(be(function(){
  return [false, 'second'];
}).or(be(function(){
  return [false, 'third'];
}))).or(be.obj).err(be.flatato);
V.auth(1);
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
V = be.required(['remotehost', 'remotefold']).on(['remotehost', 'remotefold'], be.str).or(be.bool.or(be.undef.err(["data"]))).err(function(msg){});