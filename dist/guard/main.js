var ext, com, verify, modflag, defacto, print, l, z, R, uic, binapi, init, settle, modSettle, tightloop, main, looper, handle, genfun, props, cat, getter, topcache, entry, pkg, slice$ = [].slice, arrayFrom$ = Array.from || function(x){return slice$.call(x);};
ext = require("./verify.print.common");
com = ext.com, verify = ext.verify, modflag = ext.modflag, defacto = ext.defacto, print = ext.print;
l = com.l, z = com.z, R = com.R, uic = com.uic, binapi = com.binapi;
init = {
  str: [],
  fns: [],
  def: null,
  fault: false,
  unary: false,
  immutable: false
};
settle = function(F, A){
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
modSettle = function(F, init, A){
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
tightloop = function(state){
  return function(){
    var first, arglen, I, fns, terminate, ref$, fname, data, vtype, validatorF, exec, cont, vd, spans, msg, lastview, ret, def;
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
    while (I < terminate) {
      ref$ = fns[I], fname = ref$.fname, data = ref$.data;
      switch (fname) {
      case 'wh':
        ref$ = data[0], vtype = ref$[0], validatorF = ref$[1], exec = data[1];
        switch (vtype) {
        case 'f':
          cont = validatorF.apply(null, arguments);
          if (cont) {
            return settle(exec, arguments);
          }
          break;
        case 'v':
          vd = validatorF.auth(arguments);
          if (vd['continue']) {
            return settle(exec, vd.value);
          }
        }
        break;
      case 'whn':
        ref$ = data[0], vtype = ref$[0], validatorF = ref$[1], exec = data[1];
        switch (vtype) {
        case 'f':
          cont = validatorF.apply(null, arguments);
          if (!cont) {
            return settle(exec, arguments);
          }
          break;
        case 'v':
          vd = validatorF.auth(arguments);
          if (vd.error) {
            return settle(exec, vd.value);
          }
        }
        break;
      case 'ar':
        spans = data[0], exec = data[1];
        if (spans[arglen]) {
          return settle(exec, arguments);
        }
        break;
      case 'arn':
        spans = data[0], exec = data[1];
        if (!spans[arglen]) {
          return settle(exec, arguments);
        }
        break;
      case 'arwh':
        spans = data[0], ref$ = data[1], vtype = ref$[0], validatorF = ref$[1], exec = data[2];
        if (spans[arglen]) {
          switch (vtype) {
          case 'f':
            cont = validatorF.apply(null, arguments);
            if (cont) {
              return settle(exec, arguments);
            }
            break;
          case 'v':
            vd = validatorF.auth(arguments);
            if (vd['continue']) {
              return settle(exec, vd.value);
            }
          }
        }
        break;
      case 'ma':
        ref$ = data[0], vtype = ref$[0], validatorF = ref$[1], exec = data[1];
        switch (vtype) {
        case 'f':
          msg = validatorF.apply(null, arguments);
          if (msg) {
            return modSettle(exec, msg, arguments);
          }
          break;
        case 'v':
          vd = validatorF.auth(arguments);
          if (vd['continue']) {
            return modSettle(exec, vd.value, arguments);
          }
        }
        break;
      case 'arma':
        spans = data[0], ref$ = data[1], vtype = ref$[0], validatorF = ref$[1], exec = data[2];
        if (spans[arglen]) {
          switch (vtype) {
          case 'f':
            msg = validatorF.apply(null, arguments);
            if (msg) {
              return modSettle(exec, msg, arguments);
            }
            break;
          case 'v':
            vd = validatorF.auth(arguments);
            if (vd['continue']) {
              return modSettle(exec, vd.value, arguments);
            }
          }
        }
        break;
      case 'arpar':
        spans = data[0], ref$ = data[1], vtype = ref$[0], validatorF = ref$[1], exec = data[2], lastview = data[3];
        if (!spans[arglen]) {
          break;
        }
        switch (vtype) {
        case 'f':
          ret = validatorF.apply(null, arguments);
          if (!Array.isArray(ret)) {
            print.route(['arpar_not_array', [new Error(), state]]);
            return;
          }
          cont = ret[0], msg = ret[1];
          if (cont) {
            return modSettle(exec, msg, arguments);
          } else {
            msg = (fn$());
            ret = lastview(msg);
            if (!(ret === void 8 || ret === false || ret === null)) {
              return ret;
            }
          }
          break;
        case 'v':
          vd = validatorF.auth(arguments);
          if (vd['continue']) {
            return modSettle(exec, vd.value, arguments);
          } else {
            ret = lastview(vd.message, vd.path);
            if (!(ret === void 8 || ret === false || ret === null)) {
              return ret;
            }
          }
        }
        break;
      case 'arwhn':
        spans = data[0], ref$ = data[1], vtype = ref$[0], validatorF = ref$[1], exec = data[2];
        if (spans[arglen]) {
          switch (vtype) {
          case 'f':
            cont = validatorF.apply(null, arguments);
            if (!cont) {
              return settle(exec, arguments);
            }
            break;
          case 'v':
            vd = validatorF.auth(arguments);
            if (vd.error) {
              return settle(exec, vd.value);
            }
          }
        }
        break;
      case 'arnwh':
        spans = data[0], ref$ = data[1], vtype = ref$[0], validatorF = ref$[1], exec = data[2];
        if (!spans[arglen]) {
          switch (vtype) {
          case 'f':
            cont = validatorF.apply(null, arguments);
            if (cont) {
              return settle(exec, arguments);
            }
            break;
          case 'v':
            vd = validatorF.auth(arguments);
            if (vd['continue']) {
              return settle(exec, vd.value);
            }
          }
        }
        break;
      case 'arnwhn':
        spans = data[0], ref$ = data[1], vtype = ref$[0], validatorF = ref$[1], exec = data[2];
        if (!spans[arglen]) {
          switch (vtype) {
          case 'f':
            cont = validatorF.apply(null, arguments);
            if (!cont) {
              return settle(exec, arguments);
            }
            break;
          case 'v':
            vd = validatorF.auth(arguments);
            if (vd.error) {
              return settle(exec, vd.value);
            }
          }
        }
      }
      I += 1;
    }
    def = state.def;
    if (def) {
      return settle(def, arguments);
    }
    function fn$(){
      switch (R.type(msg)) {
      case 'Array':
        return msg;
      case 'Undefined':
      case 'Null':
        return [];
      default:
        return msg;
      }
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
handle.ok = function(self, data, fname){
  var state, fns, neo;
  state = self[modflag];
  if (state.immutable || state.str.length === 0) {
    fns = state.fns.concat({
      fname: fname,
      data: data
    });
    neo = Object.assign({}, state, {
      fns: fns,
      str: state.str.concat(fname)
    });
    return looper(neo);
  } else {
    state.fns.push({
      fname: fname,
      data: data
    });
    state.str.push(fname);
    neo = state;
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
  neo = Object.assign({}, state, {
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
    var state, ref$, zone, data;
    state = this[modflag];
    if (state === undefined) {
      print.route(['state_undef', [new Error(), fname]]);
      return undefined;
    }
    if (state.fault) {
      return this;
    }
    ref$ = vfun(arguments), zone = ref$[0], data = ref$[1];
    return handle[zone](this, data, fname);
  };
};
main[uic] = print.log.proto;
main.def = function(){
  var state, ref$, zone, data;
  state = this[modflag];
  if (state === undefined) {
    print.route(['state_undef', [new Error(), 'def']]);
    return undefined;
  }
  if (state.fault) {
    return handle.def.fault;
  }
  ref$ = verify.def(arguments), zone = ref$[0], data = ref$[1];
  return handle.def.ok(this, data);
};
props = ['ma', 'arma', 'wh', 'ar', 'whn', 'arn', 'arwh', 'arnwh', 'arwhn', 'arnwhn', 'arpar'];
R.reduce(function(ob, prop){
  ob[prop] = genfun(verify.getvfun(prop), prop);
  return ob;
}, main, props);
cat = {};
cat.opt = new Set(['unary', 'immutable', 'debug']);
cat.methods = new Set(props.concat(["def"]));
getter = function(arg$, key){
  var path, lock, str, vr, npath, sorted;
  path = arg$.path, lock = arg$.lock, str = arg$.str, vr = arg$.vr;
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
  } else if (key === 'getdef') {
    return [false, defacto];
  } else {
    print.route(['setting', [new Error(), 'not_in_opts', vr, key]]);
    return null;
  }
};
topcache = {};
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