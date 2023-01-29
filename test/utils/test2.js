var ref$, utils, types, l, z, c, binapi, print_fail, create_stack, be, fail, main, getter, log, test, tsf;
ref$ = require('../../dist/main'), utils = ref$.utils, types = ref$.types;
l = utils.l, z = utils.z, c = utils.c, binapi = utils.binapi, print_fail = utils.print_fail, create_stack = utils.create_stack;
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