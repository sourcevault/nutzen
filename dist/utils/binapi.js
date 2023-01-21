var ref$, uic, noop, R, z, generic_log, veri, ap, isA, get, pub;
ref$ = require("./common"), uic = ref$.uic, noop = ref$.noop, R = ref$.R, z = ref$.z;
generic_log = function(state){
  return state;
};
veri = function(arglen, fun, uget, state, ulog){
  switch (arglen) {
  case 0:
    l("[argument.error] top level function did not recieve any argument.");
    return null;
  }
  switch (typeof fun) {
  case 'function':
    0;
    break;
  default:
    l("[argument.type.error] second argument can only be a function");
    return null;
  }
  switch (typeof uget) {
  case 'function':
    0;
    break;
  default:
    l("[argument.type.error] third argument can only be a function");
    return null;
  }
  switch (typeof ulog) {
  case 'function':
    return ulog;
  default:
    return generic_log;
  }
};
ap = function(__, ___, args){
  return this.fun(this.state, args);
};
isA = Array.isArray;
get = function(__, ukey, ___){
  var ret, sortir, cont, state, data, P;
  switch (ukey) {
  case uic:
    return this.log(this.state);
  }
  ret = this.cache[ukey];
  if (ret) {
    return ret;
  }
  sortir = this.uget(this.state, ukey);
  if (isA(sortir)) {
    cont = sortir[0], state = sortir[1];
    if (!cont) {
      return state;
    }
  } else {
    state = sortir;
  }
  data = {
    cache: {},
    log: this.log,
    fun: this.fun,
    state: state,
    apply: ap,
    get: get,
    uget: this.uget
  };
  P = new Proxy(noop, data);
  this.cache[ukey] = P;
  return P;
};
pub = function(fun, uget, state, ulog){
  var log, data, P;
  log = veri(arguments.length, fun, uget, state, ulog);
  switch (log) {
  case null:
    return;
  }
  data = {
    log: log,
    fun: fun,
    state: state,
    uget: uget,
    cache: {},
    apply: ap,
    get: get
  };
  P = new Proxy(noop, data);
  return P;
};
module.exports = pub;