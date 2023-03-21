var pkg, internal, types, l, z, c, binapi, print_fail, create_stack, be, fail, main, getter, log, test, tsf;
pkg = require('../../dist/types/main');
internal = pkg.internal, types = pkg.types;
l = internal.l, z = internal.z, c = internal.c, binapi = internal.binapi, print_fail = internal.print_fail, create_stack = internal.create_stack;
be = types;
fail = print_fail("test/utils/test2.js");
main = function(){};
getter = function(state, key){
  return [true, state.concat(key)];
};
log = function(state){
  var chain;
  chain = state.join(' | ');
  return "( " + chain + " )";
};
test = binapi(main, getter, [], log);
tsf = test.sync.flip;