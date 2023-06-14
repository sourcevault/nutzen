var pkg, internal, types, l, z, c, binapi, print_fail, create_stack, be, hop, fail, classe, ins, von;
pkg = require('../../dist/types/main');
internal = pkg.internal, types = pkg.types;
l = internal.l, z = internal.z, c = internal.c, binapi = internal.binapi, print_fail = internal.print_fail, create_stack = internal.create_stack;
be = types;
hop = pkg.guard;
fail = print_fail("test/utils/test3.js");
classe = {};
classe.test = hop.ar({
  1: function(){
    return this;
  }
}).def();
ins = Object.create(classe);
ins = Object.assign(ins, {
  color: 'blue'
});
von = ins.test(1);
if (!(von.color === 'blue')) {
  fail(1);
}