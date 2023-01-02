var ext, com, verify, modflag, defacto, print, l, z, R, uic, binapi, resolve, mod_resolve, UNDEC, ob, n, a, core, n_n, n_a, arn, arwhn, arnwh, arnwhn, arma, common_par, arpar, f_arpar, arwh, ar, tightloop, main, looper, handle, genfun, props, cat, getter, topcache, init, entry, pkg, slice$ = [].slice, arrayFrom$ = Array.from || function(x){return slice$.call(x);};
ext = require("./verify.print.common");
com = ext.com, verify = ext.verify, modflag = ext.modflag, defacto = ext.defacto, print = ext.print;
l = com.l, z = com.z, R = com.R, uic = com.uic, binapi = com.binapi;
resolve = function(F, A){
  var ftype, f;
  ftype = F[0], f = F[1];
  switch (ftype) {
  case 'f':
    return f.apply(null, A);
  case 'v':
    return f.auth.apply(f, A);
  case 's':
    return f;
  }
};
mod_resolve = function(F, init, A){
  var ftype, f, modArg;
  ftype = F[0], f = F[1];
  switch (ftype) {
  case 'f':
    switch (A.length) {
    case 1:
      return f(init, A[0]);
    case 2:
      return f(init, A[0], A[1]);
    case 0:
      return f(init);
    case 3:
      return f(init, A[0], A[1], A[2]);
    case 4:
      return f(init, A[0], A[1], A[2], A[3]);
    case 5:
      return f(init, A[0], A[1], A[2], A[3], A[4]);
    default:
      modArg = [init].concat(arrayFrom$(A));
      return f.apply(null, modArg);
    }
  case 'v':
    switch (A.length) {
    case 1:
      return f.auth(init, A[0]);
    case 2:
      return f.auth(init, A[0], A[1]);
    case 0:
      return f.auth(init);
    case 3:
      return f.auth(init, A[0], A[1], A[2]);
    case 4:
      return f.auth(init, A[0], A[1], A[2], A[3]);
    case 5:
      return f.auth(init, A[0], A[1], A[2], A[3], A[4]);
    default:
      modArg = [init].concat(arrayFrom$(A));
      return f.auth.apply(f, modArg);
    }
  case 's':
    return f;
  }
};
UNDEC = Symbol('undecided');
ob = function(fn){
  return function(da, ta){
    var pick, len, I, ka, val;
    pick = ta[da.arglen];
    if (!pick) {
      return UNDEC;
    }
    len = pick.length;
    I = 0;
    do {
      ka = pick[I];
      val = fn(da, ka);
      if (val !== UNDEC) {
        return val;
      }
      I++;
    } while (I < len);
    return UNDEC;
  };
};
n = function(fn){
  return function(da, ta){
    var num, ka;
    num = ta[0], ka = ta[1];
    if (num === da.arglen) {
      return fn(da, ka);
    }
    return UNDEC;
  };
};
a = function(fn){
  return function(da, ta){
    var spans, ka;
    spans = ta[0], ka = ta[1];
    if (spans[da.arglen]) {
      return fn(da, ka);
    }
    return UNDEC;
  };
};
core = {};
core.wh = function(da, ta){
  var ref$, vtype, vF, exec, cont, vd;
  ref$ = ta[0], vtype = ref$[0], vF = ref$[1], exec = ta[1];
  switch (vtype) {
  case 'f':
    cont = vF.apply(null, da.arg);
    if (cont) {
      return resolve(exec, da.arg);
    }
    break;
  case 'v':
    vd = vF.auth(da.arg);
    if (vd['continue']) {
      return resolve(exec, vd.value);
    }
    break;
  case 'b':
    if (vF) {
      return resolve(exec, da.arg);
    }
  }
  return UNDEC;
};
core.whn = function(da, ta){
  var ref$, vtype, vF, exec, cont, vd;
  ref$ = ta[0], vtype = ref$[0], vF = ref$[1], exec = ta[1];
  switch (vtype) {
  case 'f':
    cont = vF.apply(null, da.arg);
    if (!cont) {
      return resolve(exec, da.arg);
    }
    break;
  case 'v':
    vd = vF.auth(da.arg);
    if (vd.error) {
      return resolve(exec, vd.value);
    }
    break;
  case 'b':
    if (!vF) {
      return resolve(exec, da.arg);
    }
  }
  return UNDEC;
};
n_n = function(fn){
  return function(da, ta){
    var num, ka;
    num = ta[0], ka = ta[1];
    if (num === da.arglen) {
      return UNDEC;
    }
    return fn(da, ka);
  };
};
n_a = function(fn){
  return function(da, ta){
    var spans, ka;
    spans = ta[0], ka = ta[1];
    if (spans[da.arglen]) {
      return UNDEC;
    }
    return fn(da, ka);
  };
};
arn = {};
arn.a = function(da, ta){
  var spans, exec;
  spans = ta[0], exec = ta[1];
  if (spans[da.arglen]) {
    return UNDEC;
  }
  return resolve(exec, da.arg);
};
arn.n = function(da, ta){
  var num, exec;
  num = ta[0], exec = ta[1];
  if (da.arglen === num) {
    return UNDEC;
  }
  return resolve(exec, da.arg);
};
core.arn = function(da, ta){
  return arn[ta[0]](da, ta[1]);
};
arwhn = {};
arwhn.ob = ob(core.whn);
arwhn.n = n(core.whn);
arwhn.a = a(core.whn);
core.arwhn = function(da, ta){
  return arwhn[ta[0]](da, ta[1]);
};
arnwh = {};
arnwh.n = n_n(core.wh);
arnwh.a = n_a(core.wh);
core.arnwh = function(da, ta){
  return arnwh[ta[0]](da, ta[1]);
};
arnwhn = {};
arnwhn.n = n_n(core.whn);
arnwhn.a = n_a(core.whn);
core.arnwhn = function(da, ta){
  return arnwhn[ta[0]](da, ta[1]);
};
core.ma = function(da, ta){
  var ref$, vtype, vF, exec, msg, vd;
  ref$ = ta[0], vtype = ref$[0], vF = ref$[1], exec = ta[1];
  switch (vtype) {
  case 'f':
    msg = vF.apply(null, da.arg);
    switch (msg) {
    case false:
      break;
    case null:
      return null;
    default:
      return mod_resolve(exec, msg, da.arg);
    }
    break;
  case 'v':
    vd = vF.auth(da.arg);
    if (vd['continue']) {
      return mod_resolve(exec, vd.value, da.arg);
    }
    break;
  case 'b':
    if (vF !== false) {
      return mod_resolve(exec, vF, da.arg);
    }
  }
  return UNDEC;
};
arma = {};
arma.ob = ob(core.ma);
arma.n = n(core.ma);
arma.a = a(core.ma);
core.arma = function(da, ta){
  return arma[ta[0]](da, ta[1]);
};
common_par = function(fname){
  return function(da, ta){
    var ref$, vtype, vF, lastview, exec, ret, cont, msg, vd;
    ref$ = ta[0], vtype = ref$[0], vF = ref$[1], lastview = ta[1], exec = ta[2];
    switch (vtype) {
    case 'f':
      ret = vF.apply(null, da.arg);
      if (!Array.isArray(ret)) {
        print.route(['validator_return_not_array', [new Error(), [fname, ['validator']], da.state]]);
        return;
      }
      cont = ret[0], msg = ret[1];
      if (cont) {
        return mod_resolve(exec, msg, da.arg);
      } else {
        ret = lastview.apply(null, [msg].concat(arrayFrom$(da.arg)));
        if (ret !== void 8) {
          return ret;
        }
      }
      break;
    case 'v':
      vd = vF.auth(da.arg);
      if (vd['continue']) {
        return mod_resolve(exec, vd.value, da.arg);
      } else {
        ret = lastview.apply(null, [vd.message, vd.path].concat(arrayFrom$(da.arg)));
        if (ret !== void 8) {
          return ret;
        }
      }
      break;
    case 'b':
      if (vF) {
        return mod_resolve(exec, void 8, da.arg);
      } else {
        ret = lastview.apply(null, da.arg);
        if (ret !== void 8) {
          return ret;
        }
      }
    }
    return UNDEC;
  };
};
core.par = common_par('par');
arpar = {};
f_arpar = common_par('arpar');
arpar.ob = ob(f_arpar);
arpar.n = n(f_arpar);
arpar.a = a(f_arpar);
core.arpar = function(da, ta){
  return arpar[ta[0]](da, ta[1]);
};
arwh = {};
arwh.ob = ob(core.wh);
arwh.n = n(core.wh);
arwh.a = a(core.wh);
core.arwh = function(da, ta){
  return arwh[ta[0]](da, ta[1]);
};
ar = {};
ar.ob = function(da, ta){
  var pick;
  pick = ta[da.arglen];
  if (!pick) {
    return UNDEC;
  }
  return resolve(pick, da.arg);
};
ar.n = function(da, ta){
  var num, exec;
  num = ta[0], exec = ta[1];
  if (num === da.arglen) {
    return resolve(exec, da.arg);
  }
  return UNDEC;
};
ar.a = function(da, ta){
  var spans, exec;
  spans = ta[0], exec = ta[1];
  if (spans[da.arglen]) {
    return resolve(exec, da.arg);
  }
  return UNDEC;
};
core.ar = function(da, ta){
  return ar[ta[0]](da, ta[1]);
};
tightloop = function(state){
  return function(){
    var first, arglen, I, fns, terminate, da, elemento, devolver, def;
    if (state.unary) {
      first = arguments[0];
      switch (R.type(first)) {
      case 'Arguments':
      case 'Array':
        arglen = first.length;
        break;
      default:
        print.route(['unary_not_array', [new Error(), state]]);
        return undefined;
      }
    } else {
      arglen = arguments.length;
    }
    I = 0;
    fns = state.fns;
    terminate = fns.length;
    da = {
      arglen: arglen,
      arg: arguments,
      state: state
    };
    while (I < terminate) {
      elemento = fns[I];
      devolver = core[elemento[0]](da, elemento[1]);
      if (devolver !== UNDEC) {
        return devolver;
      }
      I += 1;
    }
    def = state.def;
    if (def) {
      return resolve(def, arguments);
    }
  };
};
main = {};
looper = function(state){
  var instance, frozen;
  instance = Object.create(main);
  instance[modflag] = state;
  frozen = Object.freeze(instance);
  return frozen;
};
handle = {};
handle.fault = function(self, data, fname){
  var state, neo;
  state = self[modflag];
  print.route(['input', [new Error(), fname, data, state]]);
  neo = Object.assign({}, state, {
    fault: ['input', fname, data]
  });
  return looper(neo);
};
main.clone = function(){
  var state, neo;
  state = this[modflag];
  neo = R.mergeRight(state, {
    fns: arrayFrom$(state.fns),
    str: arrayFrom$(state.str)
  });
  return looper(neo);
};
handle.ok = function(self, data, fname){
  var state, neo_data, fns, neo;
  state = self[modflag];
  neo_data = [fname, data];
  if (state.immutable || state.str.length === 0) {
    fns = state.fns.concat([neo_data]);
    neo = R.mergeRight(state, {
      fns: fns,
      str: state.str.concat(fname)
    });
    return looper(neo);
  } else {
    state.fns.push(neo_data);
    state.str.push(fname);
    return self;
  }
};
handle.def = {};
handle.def.fault = function(){
  return null;
};
handle.def.fault[uic] = print.log.def_fault;
handle.def.ok = function(self, data){
  var state, neo, F;
  state = self[modflag];
  neo = R.mergeRight(state, {
    def: data,
    str: state.str
  });
  F = tightloop(neo);
  F[defacto] = data[1];
  if (state.debug) {
    F[uic] = print.log.wrap(neo);
  }
  return F;
};
genfun = function(vfun, fname){
  return function(){
    var state, out, zone, data;
    state = this[modflag];
    if (state === void 8) {
      print.route(['state_undef', [new Error(), fname]]);
      return;
    }
    if (state.fault) {
      return this;
    }
    out = vfun(fname, arguments);
    zone = out[0], data = out[1];
    return handle[zone](this, data, fname);
  };
};
main[uic] = print.log.proto;
main.def = function(){
  var state, ref$, ___, data;
  state = this[modflag];
  if (state === undefined) {
    print.route(['state_undef', [new Error(), 'def']]);
    return undefined;
  }
  if (state.fault) {
    return handle.def.fault;
  }
  ref$ = verify.def(arguments), ___ = ref$[0], data = ref$[1];
  return handle.def.ok(this, data);
};
props = ['ar', 'wh', 'ma', 'arma', 'par', 'arpar', 'whn', 'arn', 'arwh', 'arwhn', 'arnwh', 'arnwhn'];
R.reduce(function(ob, prop){
  var F;
  F = verify.getvfun(prop);
  ob[prop] = genfun(F, prop);
  return ob;
}, main, props);
cat = {};
cat.opt = new Set(['unary', 'immutable', 'debug']);
cat.methods = new Set(props.concat(['def']));
getter = function(data, key){
  var path, lock, str, vr, npath, sorted;
  path = data.path, lock = data.lock, str = data.str, vr = data.vr;
  if (lock) {
    print.route(['setting', [new Error(), 'path_locked', vr, key]]);
    return null;
  }
  if (cat.opt.has(key)) {
    if (R.includes(key, path)) {
      print.route(['setting', [new Error(), 'already_in_path', vr, key]]);
      return null;
    } else {
      npath = path.concat(key);
      sorted = R.clone(npath).sort();
      return [
        true, {
          path: sorted,
          lock: false,
          str: sorted.join("."),
          vr: npath
        }
      ];
    }
  } else if (cat.methods.has(key)) {
    return [
      true, {
        path: path,
        lock: true,
        str: str,
        vr: vr,
        key: key
      }
    ];
  } else if (key === 'symdef') {
    return [false, defacto];
  } else {
    print.route(['setting', [new Error(), 'not_in_opts', vr, key]]);
    return null;
  }
};
topcache = {};
init = {
  str: [],
  fns: [],
  def: null,
  fault: false,
  unary: false,
  immutable: false
};
entry = function(data, args){
  var str, has, path, lock, vr, key, ob, i$, len$, ke, put;
  str = data.str;
  has = topcache[str];
  if (has) {
    return has[data.key].apply(has, args);
  }
  path = data.path, lock = data.lock, vr = data.vr, key = data.key;
  ob = {};
  for (i$ = 0, len$ = path.length; i$ < len$; ++i$) {
    ke = path[i$];
    ob[ke] = true;
  }
  put = looper(Object.assign({}, init, ob));
  topcache[str] = put;
  return put[key].apply(put, args);
};
pkg = binapi(entry, getter, {
  path: [],
  lock: false,
  vr: [],
  str: [],
  key: null
}, print.log.prox);
module.exports = pkg;