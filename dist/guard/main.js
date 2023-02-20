var ext, com, verify, print, l, z, R, uic, binapi, loopError, resolve, unshift_resolve, UNDEC, ob, n, a, core, n_n, n_a, arn, arwhn, arnwh, arnwhn, arcap, isArray, arwh, ar, tightloop, main, handle, genfun, props, cat, getter, topcache, init, entry, proto_log, guard, link, proto, proto_fn, pkg, slice$ = [].slice, arrayFrom$ = Array.from || function(x){return slice$.call(x);};
ext = require("./verify.print.common");
com = ext.com, verify = ext.verify, print = ext.print;
l = com.l, z = com.z, R = com.R, uic = com.uic, binapi = com.binapi, loopError = com.loopError;
resolve = function(F, A){
  var ftype, f;
  ftype = F[0], f = F[1];
  switch (ftype) {
  case 'f':
    return f.apply(void 8, A);
  case 'v':
    return f.auth.apply(void 8, A);
  case 's':
    return f;
  }
};
unshift_resolve = function(F, init, A){
  var ftype, f, modArg;
  ftype = F[0], f = F[1];
  switch (ftype) {
  case 'f':
    switch (A.length) {
    case 1:
      return f(init, A[0]);
    case 2:
      return f(init, A[0], A[1]);
    case 3:
      return f(init, A[0], A[1], A[2]);
    case 0:
      return f(init);
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
    case 3:
      return f.auth(init, A[0], A[1], A[2]);
    case 0:
      return f.auth(init);
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
  var exec, ref$, vtype, vF, cont, vd;
  if (ta.length === 1) {
    exec = ta[0];
    return resolve(exec, da.arg);
  }
  ref$ = ta[0], vtype = ref$[0], vF = ref$[1], exec = ta[1];
  switch (vtype) {
  case 'f':
    cont = vF.apply(void 8, da.arg);
    if (cont) {
      return resolve(exec, da.arg);
    }
    break;
  case 'v':
    vd = vF.auth(da.arg);
    if (vd['continue']) {
      return resolve(exec, vd.value);
    }
  }
  return UNDEC;
};
core.whn = function(da, ta){
  var exec, ref$, vtype, vF, cont, vd;
  if (ta.length === 1) {
    exec = ta[0];
    return resolve(exec, da.arg);
  }
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
core.cap = function(da, ta){
  switch (ta.length) {
  case 3:
    return core.cap[3](da, ta);
  case 2:
    return core.cap[2](da, ta);
  case 1:
    return resolve(ta[0], da.arg);
  }
};
core.cap[2] = function(da, ta){
  var exec, ref$, vtype, vF, ret, vd, as_obj, narg;
  exec = ta[0], ref$ = ta[1], vtype = ref$[0], vF = ref$[1];
  switch (vtype) {
  case 'f':
    ret = vF.apply(void 8, da.arg);
    if (ret !== false) {
      return unshift_resolve(exec, ret, da.arg);
    }
    break;
  case 'v':
    vd = vF.auth(da.arg);
    if (vd['continue']) {
      return unshift_resolve(exec, vd.value, da.arg);
    } else {
      as_obj = {
        message: vd.message,
        path: vd.path
      };
      narg = [as_obj].concat(arrayFrom$(da.arg));
      ret = lastview.apply(void 8, narg);
      if (ret !== void 8) {
        return ret;
      }
    }
    break;
  case 'b':
    if (vF) {
      return resolve(exec, da.arg);
    }
  }
  return UNDEC;
};
core.cap[3] = function(da, ta){
  var exec, ref$, vtype, vF, lastview, ret, cont, msg, narg, lvret, vd, as_obj;
  exec = ta[0], ref$ = ta[1], vtype = ref$[0], vF = ref$[1], lastview = ta[2];
  switch (vtype) {
  case 'f':
    ret = vF.apply(void 8, da.arg);
    if (isArray(ret)) {
      cont = ret[0], msg = ret[1];
      if (cont) {
        return unshift_resolve(exec, msg, da.arg);
      } else {
        narg = [msg].concat(arrayFrom$(da.arg));
        lvret = lastview.apply(void 8, narg);
      }
    } else {
      if (ret) {
        return resolve(exec, da.arg);
      } else {
        lvret = lastview.apply(void 8, da.arg);
      }
    }
    if (lvret !== void 8) {
      return lvret;
    }
    break;
  case 'v':
    vd = vF.auth(da.arg);
    if (vd['continue']) {
      return unshift_resolve(exec, vd.value, da.arg);
    } else {
      as_obj = {
        message: vd.message,
        path: vd.path
      };
      narg = [as_obj].concat(arrayFrom$(da.arg));
      ret = lastview.apply(void 8, narg);
      if (ret !== void 8) {
        return ret;
      }
    }
    break;
  case 'b':
    if (vF) {
      return resolve(exec, da.arg);
    } else {
      ret = lastview.apply(void 8, da.arg);
      if (ret !== void 8) {
        return ret;
      }
    }
  }
  return UNDEC;
};
arcap = {};
arcap.ob = ob(core.cap);
arcap.n = n(core.cap);
arcap.a = a(core.cap);
core.arcap = function(da, ta){
  return arcap[ta[0]](da, ta[1]);
};
isArray = Array.isArray;
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
main = function(self){
  this.self = self;
  return this;
};
main.prototype.clone = function(){
  var state, neo;
  state = this.self;
  neo = R.mergeRight(state, {
    fns: arrayFrom$(state.fns),
    str: arrayFrom$(state.str)
  });
  return new main(neo);
};
main.prototype[uic] = print.log.proto;
handle = {
  def: {
    fault: void 8,
    ok: void 8
  },
  fault: void 8,
  ok: void 8
};
handle.fault = function(state, data, fname){
  var neo;
  print.route(['input', [new Error(), fname, data, state]]);
  neo = Object.assign({}, state, {
    fault: ['input', fname, data]
  });
  return new main(neo);
};
genfun = function(vfun, fname){
  return function(){
    var state, out, status, data;
    state = this.self;
    if (state === void 8) {
      print.route(['state_undef', [new Error(), fname]]);
      return;
    }
    if (state.fault) {
      return this;
    }
    out = vfun(fname, arguments);
    status = out[0], data = out[1];
    return handle[status](state, data, fname);
  };
};
handle.ok = function(state, data, fname){
  var neo_data, fns, neo;
  neo_data = [fname, data];
  if (state.str.length === 0) {
    fns = state.fns.concat([neo_data]);
    neo = R.mergeRight(state, {
      fns: fns,
      str: state.str.concat(fname)
    });
    return new main(neo);
  } else {
    state.fns.push(neo_data);
    state.str.push(fname);
    return new main(state);
  }
};
handle.def.fault = function(){
  return null;
};
handle.def.fault[uic] = print.log.def_fault;
handle.def.ok = function(state, data){
  var neo, F;
  neo = R.mergeRight(state, {
    def: data,
    str: state.str
  });
  F = tightloop(neo);
  if (state.debug) {
    F[uic] = print.log.wrap(neo);
  }
  return F;
};
main.prototype.def = function(){
  var state, ref$, ___, data;
  state = this.self;
  if (state === undefined) {
    print.route(['state_undef', [new Error(), 'def']]);
    return undefined;
  }
  if (state.fault) {
    return handle.def.fault;
  }
  ref$ = verify.def(arguments), ___ = ref$[0], data = ref$[1];
  return handle.def.ok(state, data);
};
props = ['ar', 'wh', 'whn', 'arn', 'cap', 'arwh', 'arcap', 'arwhn', 'arnwh', 'arnwhn'];
R.reduce(function(ob, prop){
  var F;
  F = verify.getvfun(prop);
  ob.prototype[prop] = genfun(F, prop);
  return ob;
}, main, props);
cat = {};
cat.opt = new Set(['unary', 'debug']);
cat.methods = new Set(props.concat(['def']));
getter = function(data, key){
  var path, lock, str, sorted_path, npath, copypath, sorted, ndata;
  path = data.path, lock = data.lock, str = data.str, sorted_path = data.sorted_path;
  if (lock) {
    print.route(['setting', [new Error(), 'path_locked', sorted_path, key]]);
    return null;
  }
  if (cat.opt.has(key)) {
    if (R.includes(key, path)) {
      print.route(['setting', [new Error(), 'already_in_path', sorted_path, key]]);
      return null;
    } else {
      npath = path.concat(key);
      copypath = npath.concat();
      sorted = copypath.sort();
      ndata = {
        path: sorted,
        lock: false,
        str: sorted.join("."),
        sorted_path: npath
      };
      return [true, ndata];
    }
  } else if (cat.methods.has(key)) {
    ndata = {
      path: path,
      lock: true,
      str: str,
      sorted_path: sorted_path,
      key: key
    };
    return [true, ndata];
  } else if (key === 'doc') {
    return print.docstring;
  } else {
    print.route(['setting', [new Error(), 'not_in_opts', sorted_path, key]]);
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
  debug: false
};
entry = function(data, args){
  var str, has, path, lock, key, ob, i$, len$, ke, put;
  if (data === null) {
    return loopError();
  }
  str = data.str;
  has = topcache[str];
  if (has) {
    return has[data.key].apply(has, args);
  }
  path = data.path, lock = data.lock, key = data.key;
  ob = {};
  for (i$ = 0, len$ = path.length; i$ < len$; ++i$) {
    ke = path[i$];
    ob[ke] = true;
  }
  data = Object.assign({}, init, ob);
  put = new main(data);
  topcache[str] = put;
  return put[key].apply(put, args);
};
proto_log = function(state){
  var diff, keys;
  diff = R.difference(['unary', 'debug', 'def'], state.path);
  keys = arrayFrom$(props).concat(arrayFrom$(diff));
  return keys;
};
guard = binapi(entry, getter, {
  path: [],
  lock: false,
  sorted_path: [],
  str: "",
  key: null
}, print.log.prox, {
  __proto__: proto_log
});
link = {};
proto = {
  1: function(origin){
    return function(){
      return proto.def.apply(proto, [origin].concat(arrayFrom$(arguments)));
    };
  },
  def: function(){
    var args, targets, res$, i$, to$, I, origin, len$, prop;
    args = arguments;
    res$ = [];
    for (i$ = 1, to$ = args.length; i$ < to$; ++i$) {
      I = i$;
      res$.push(args[I]);
    }
    targets = res$;
    origin = args[0];
    for (i$ = 0, len$ = targets.length; i$ < len$; ++i$) {
      prop = targets[i$];
      prop.prototype = Object.create(origin.prototype);
    }
  }
};
link.proto = guard.ar(proto).def(proto.def);
proto_fn = {
  1: function(origin){
    return function(){
      var args, targets, res$, i$, to$, I;
      args = arguments;
      res$ = [];
      for (i$ = 1, to$ = args.length; i$ < to$; ++i$) {
        I = i$;
        res$.push(args[I]);
      }
      targets = res$;
      return proto_fn.main(origin, [args[0], targets]);
    };
  },
  2: function(origin, fnames){
    return function(){
      var targets;
      targets = arguments;
      return proto_fn.main(origin, [fnames, targets]);
    };
  },
  def: function(){
    var args, origin, fnames, targets, res$, i$, to$, I;
    args = arguments;
    origin = args[0], fnames = args[1];
    res$ = [];
    for (i$ = 2, to$ = args.length; i$ < to$; ++i$) {
      I = i$;
      res$.push(args[I]);
    }
    targets = res$;
    return proto_fn.main(origin, [fnames, targets]);
  },
  main: function(origin, arg$){
    var fnames, targets, i$, len$, N, j$, len1$, T;
    fnames = arg$[0], targets = arg$[1];
    for (i$ = 0, len$ = fnames.length; i$ < len$; ++i$) {
      N = fnames[i$];
      for (j$ = 0, len1$ = targets.length; j$ < len1$; ++j$) {
        T = targets[j$];
        T.prototype[N] = origin[N];
      }
    }
  }
};
link.proto_fn = guard.ar(proto_fn).def(proto_fn.def);
pkg = {};
ext.com.link = Object.freeze(link);
ext.com = Object.freeze(ext.com);
pkg.guard = guard;
pkg.com = ext.com;
pkg.symbols = ext.symbols;
module.exports = pkg;