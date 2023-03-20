var pkg, internal, types, l, z, c, binapi, print_fail, create_stack, be, fail, get, lopo, F6, compute, out, E;
pkg = require('../../dist/types/main');
internal = pkg.internal, types = pkg.types;
l = internal.l, z = internal.z, c = internal.c, binapi = internal.binapi, print_fail = internal.print_fail, create_stack = internal.create_stack;
be = types;
fail = print_fail("test/utils/test1.js");
get = function(arg$, key){
  var old, num;
  old = arg$[0], num = arg$[1];
  return [true, [key, num]];
};
lopo = function(state){
  return binapi(F6, get, state);
};
F6 = function(arg$, args){
  var key, x, y;
  key = arg$[0], x = arg$[1];
  y = args[0];
  switch (key) {
  case null:
    return lopo(["init", y]);
  case "add":
    return lopo(["chain", x + y]);
  case "multiply":
    return lopo(["chain", x * y]);
  case "ret":
    return x;
  default:
    return fail(6);
  }
};
try {
  compute = lopo([null]);
  out = compute(5).add(5).multiply(10).ret();
  if (!(out === 100)) {
    fail(6);
  }
} catch (e$) {
  E = e$;
  l(E);
  fail(6);
}