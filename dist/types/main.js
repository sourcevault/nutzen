var ref$, com, print, z, l, R, j, deep_freeze, uic, loopError, noop, oxo, int, custom, define, cache, be, props, nonmap, base, not_base, undefnull, F, pop, i$, len$, name, type, A, B, C, V;
ref$ = require('./print.common'), com = ref$.com, print = ref$.print;
z = com.z, l = com.l, R = com.R, j = com.j, deep_freeze = com.deep_freeze, uic = com.uic, loopError = com.loopError, noop = com.noop;
oxo = require('../guard/main');
int = require('./internal');
custom = int.custom, define = int.define, cache = int.cache;
be = custom;
props = [['obj', 'Object'], ['arr', 'Array'], ['undef', 'Undefined'], ['null', 'Null'], ['num', 'Number'], ['str', 'String'], ['fun', 'Function'], ['bool', 'Boolean'], ['objerr', 'Error']];
nonmap = R.map(function(arg$){
  var name;
  name = arg$[0];
  return name;
}, R.drop(2, props));
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
cache.def.add(undefnull);
F = base("Arguments");
define.basis('arg', F);
be.arg = F;
pop = function(msg){
  msg.pop();
  return msg;
};
be.not = function(F){
  var V;
  V = be(F);
  return be(function(x){
    return !V.auth(x)['continue'];
  });
};
be.undefnull = be(undefnull);
be.not.undefnull = be.not(undefnull);
be.maybe = function(F){
  return be(F).or(be.undef).err(pop);
};
be.list = function(F){
  return be.arr.map(F);
};
be.not[uic] = print.inner;
be.list[uic] = print.inner;
be.maybe[uic] = print.inner;
be.known = {};
for (i$ = 0, len$ = props.length; i$ < len$; ++i$) {
  ref$ = props[i$], name = ref$[0], type = ref$[1];
  A = base(type);
  base(name, A);
  define.basis(name, A);
  be[name] = A;
  B = not_base(type);
  define.basis(name, B);
  be.not[name] = B;
  C = {};
  define.basis(name, C);
  be.known[name] = C;
}
V = be.arr.and(noop);
be = deep_freeze(be);
module.exports = be;