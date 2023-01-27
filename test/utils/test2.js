var com, l, zj, z, c, binapi, print_fail, create_stack, fail, main, getter, log, test, tsf;
com = require("../../dist/utils/main.js").com;
l = com.l, zj = com.zj, z = com.z, c = com.c, binapi = com.binapi, print_fail = com.print_fail, create_stack = com.create_stack;
l = com.l, z = com.z, binapi = com.binapi;
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