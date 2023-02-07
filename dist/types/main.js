var ref$, com, symbols, print, z, l, R, j, deep_freeze, uic, loopError, noop, oxo, internal, custom, define, defset, be, non_map_props, props, base, not_base, undefnull, F, i$, len$, name, type, A, B, C, rf, V, slice$ = [].slice, arrayFrom$ = Array.from || function(x){return slice$.call(x);};
ref$ = require('./print.common'), com = ref$.com, symbols = ref$.symbols, print = ref$.print;
z = com.z, l = com.l, R = com.R, j = com.j, deep_freeze = com.deep_freeze, uic = com.uic, loopError = com.loopError, noop = com.noop;
oxo = require('../guard/main');
internal = require('./internal');
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
rf = function(){
  return false;
};
V = be.arr['try'];
z(V);
V.auth(null);
module.exports = be;