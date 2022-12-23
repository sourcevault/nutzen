var proj, name, path, xop, com, l, zj, z, c, binapi, print_fail, create_stack, R, pf, V, A, tuo;
proj = 'guard';
name = 'test5';
path = function(name){
  return "../../dist/" + name + "/main";
};
xop = require(path('guard'));
com = require(path('utils'));
l = com.l, zj = com.zj, z = com.z, c = com.c, binapi = com.binapi, print_fail = com.print_fail, create_stack = com.create_stack, R = com.R;
pf = print_fail("test/" + proj + "/" + name + ".js");
V = xop.arnwhn(1, function(){
  return false;
}, function(){
  return 'arnwhn';
}).def();
if (V() !== 'arnwhn') {
  pf("normal 3 argument .arnwhn doesn't work");
}
A = {
  0: [
    true, function(){
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
V = xop.arnwh(1, function(){
  return true;
}, 34).def('central');
if (V() !== 34) {
  pf(".arnwh normie function not working");
}
V = xop.ma(function(){
  return [null];
}, function(){
  return arguments[0][0];
}).def();
if (V() !== null) {
  pf(".ma normie function not working");
}
A = {
  0: function(){
    return 1;
  }
};
V = xop.arma(A).def();
if (V() !== 1) {
  pf(".arma object notation, single function not working.");
}
A = {
  0: [
    false, function(){
      return arguments;
    }
  ]
};
V = xop.arma(A).def(53);
if (V() !== 53) {
  pf(".arma object notation, not rejection ( 2 arg ).");
}
A = {
  2: [
    true, function(){
      return arguments[2];
    }
  ]
};
V = xop.arma(A).def(53);
tuo = V(56, 8);
if (tuo !== 8) {
  pf(".arma object notation, second argument not moved ( 2 arg ).");
}