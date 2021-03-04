var com, l, zj, z, c, binapi, print_fail, create_stack, fail, lopo, get, fun, P, K, subtract, sub;
com = require("../../dist/utils/main.js");
l = com.l, zj = com.zj, z = com.z, c = com.c, binapi = com.binapi, print_fail = com.print_fail, create_stack = com.create_stack;
fail = print_fail("test/utils/test.js");
lopo = function(state){
  return binapi(fun, get, state);
};
get = function(state, key){
  state[key] = true;
  return state;
};
fun = function(state, args){
  return lopo(state);
};
P = binapi(fun, get, {});
K = P.flip.callback();
if (!(K.flip || K.callback)) {
  fail(1);
}
subtract = function(state, args){
  var a, b, temporary, output;
  a = args[0], b = args[1];
  if (state.flip) {
    temporary = a;
    a = b;
    b = temporary;
  }
  output = a - b;
  if (state.abs) {
    return Math.abs(output);
  }
  return output;
};
sub = binapi(subtract, get, {});
if (!(sub(10, 5) === 5)) {
  fail(2);
}
if (!(sub.flip.subtract(10, 5) === -5)) {
  fail(3);
}
if (!(sub.flip.abs(10, 5) === 5)) {
  fail(4);
}