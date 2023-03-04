var pkg, internal, com, print, z, l, R, j, deep_freeze, uic, loopError, noop, xop, custom, define, defset, be, non_map_props, props, base, not_base, undefnull, F, i$, len$, ref$, name, type, A, B, C, V, slice$ = [].slice, arrayFrom$ = Array.from || function(x){return slice$.call(x);};
pkg = require('./print.common');
internal = require('./internal');
com = pkg.com, print = pkg.print;
z = com.z, l = com.l, R = com.R, j = com.j, deep_freeze = com.deep_freeze, uic = com.uic, loopError = com.loopError, noop = com.noop;
xop = pkg.guard;
custom = internal.custom, define = internal.define, defset = internal.defset;
be = custom;
be.known = {};
non_map_props = [['undef', 'Undefined'], ['null', 'Null'], ['num', 'Number'], ['str', 'String'], ['fun', 'Function'], ['bool', 'Boolean'], ['objerr', 'Error']];
props = [['obj', 'Object'], ['arr', 'Array']].concat(arrayFrom$(non_map_props));
base = function(type){
  return function(UFO){
    var str;
    if (R.type(UFO) === type) {
      return {
        'continue': true,
        error: false,
        value: UFO
      };
    } else {
      str = R.toLower("not " + type);
      return {
        error: true,
        'continue': false,
        message: str,
        value: UFO
      };
    }
  };
};
not_base = function(type){
  return function(UFO){
    var str;
    if (R.type(UFO) === type) {
      str = R.toLower("is " + type);
      return {
        error: true,
        'continue': false,
        message: str,
        value: UFO
      };
    } else {
      return {
        'continue': true,
        error: false,
        value: UFO
      };
    }
  };
};
undefnull = function(UFO){
  var ref$;
  if ((ref$ = R.type(UFO)) === 'Undefined' || ref$ === 'Null') {
    return {
      'continue': true,
      error: false,
      value: UFO
    };
  } else {
    return {
      'continue': false,
      error: true,
      message: "not undefined or null",
      value: UFO
    };
  }
};
defset.add(undefnull);
F = base('Arguments');
define.basis('arg', F, 'arr');
define.basis.empty('arg', 'arr');
be.arg = F;
be.not = function(F){
  var V;
  V = be(F);
  return be(function(x){
    return !V.auth(x)['continue'];
  });
};
be.undefnull = be(undefnull);
be.not.undefnull = be.not(undefnull);
for (i$ = 0, len$ = props.length; i$ < len$; ++i$) {
  ref$ = props[i$], name = ref$[0], type = ref$[1];
  A = base(type);
  base(name, A);
  define.basis(name, A);
  be[name] = A;
  B = not_base(type);
  define.basis(name, B);
  be.not[name] = B;
  C = define.basis.empty(name);
  be.known[name] = C;
}
V = be.obj['try'].on('remote', be.arr).end;
l(V);
pkg = {};
pkg.types = be;
pkg.guard = xop;
pkg.utils = com;
pkg = Object.freeze(pkg);
module.exports = pkg;