var proj, name, pkg, internal, types, guard, l, z, c, binapi, print_fail, create_stack, R, be, xop, pf, A, V, V1, tuo;
proj = 'guard';
name = 'test5';
pkg = require('../../dist/types/main');
internal = pkg.internal, types = pkg.types, guard = pkg.guard;
l = internal.l, z = internal.z, c = internal.c, binapi = internal.binapi, print_fail = internal.print_fail, create_stack = internal.create_stack, R = internal.R;
be = types;
xop = guard;
pf = print_fail("test/" + proj + "/" + name + ".js");
A = {
  0: [
    function(){
      return true;
    }, function(){
      return 'A:0';
    }
  ],
  1: function(){
    return 'A:1';
  }
};
V = xop.arwh(A).def('central');
if (V() !== 'A:0') {
  pf(".arwh object notation error ");
}
if (V(1) !== 'A:1') {
  pf(".arwh object notation error - direct value");
}
V1 = xop.arwhn(A).def('binto');
if (V1(4) !== 'A:1') {
  pf(".arwhn object function not working");
}
V = xop.arnwh(1, function(){
  return true;
}, 34).def('central');
if (V() !== 34) {
  pf(".arnwh normal function not working");
}
V = xop.cap(function(){
  return [null];
}, function(){
  return arguments[0][0];
}).def();
if (V() !== null) {
  pf(".cap normie function not working");
}
A = {
  0: function(){
    return 1;
  }
};
V = xop.arcap(A).def();
if (V() !== 1) {
  pf(".arcap object notation, single function not working.");
}
A = {
  0: [
    function(){
      return false;
    }, function(){
      return arguments;
    }
  ]
};
V = xop.arcap(A).def(53);
if (V() !== 53) {
  pf(".arcap object notation, not rejection ( 2 arg ).");
}
A = {
  2: [
    function(){
      return true;
    }, function(){
      return arguments[2];
    }
  ]
};
V = xop.arcap(A).def(53);
tuo = V(56, 8);
if (tuo !== 8) {
  pf(".arcap object notation, second argument not moved ( 2 arg ).");
}