var vendor, l, flat, advanced_pad, deep_freeze, alpha_sort, R, esp, _jspc, util, util_inspect_custom, uic, noop, jspc_def, jspc, z, loopfault, ansi_wrap, x$, cc, c, aj, name, func, lit, rm_paths, create_stack, print_fail, wait, tupnest_recurse, tupnest, generic_log, veri, ap, isA, get, pub, com, slice$ = [].slice, arrayFrom$ = Array.from || function(x){return slice$.call(x);};
vendor = require("./vendor");
l = console.log;
flat = vendor.flat;
advanced_pad = vendor.pad;
deep_freeze = vendor.deepFreeze;
alpha_sort = vendor.alpha_sort;
R = require("ramda");
esp = require("error-stack-parser");
_jspc = vendor.stringify;
if (typeof window === "undefined" && typeof module === "object") {
  util = require('util');
  util_inspect_custom = util.inspect.custom;
} else {
  util_inspect_custom = Symbol['for']('nodejs.util.inspect.custom');
}
uic = util_inspect_custom;
noop = function(){};
noop[util_inspect_custom] = function(){
  return this[util_inspect_custom];
};
jspc_def = {
  maxLength: 30,
  margins: true
};
jspc = function(obj, opt){
  if (opt === undefined) {
    opt = jspc_def;
  } else {
    opt = R.mergeRight(jspc_def, opt);
  }
  return _jspc(obj, opt);
};
z = function(){
  return console.log.apply(console, arguments);
};
jspc.r = R.curry(function(opt, obj){
  return jspc(obj, opt);
});
z.j = function(obj){
  return console.log(jspc(obj));
};
z.n = function(){
  var args;
  args = ['\n'].concat(arrayFrom$(arguments), ['\n']);
  return console.log.apply(console, args);
};
z.p = function(obj){
  var cont, disp, current, cp;
  cont = true;
  disp = [];
  current = obj;
  while (cont) {
    disp.push(obj);
    cp = obj.__proto__;
    if (cp === null) {
      cont = false;
    }
    obj = cp;
  }
  disp.pop();
  return console.dir(disp);
};
loopfault = function(){
  var loopError, apply, get;
  loopError = function(){};
  apply = function(){
    return new Proxy(loopError, {
      apply: apply,
      get: get
    });
  };
  get = function(){
    return new Proxy(loopError, {
      apply: apply,
      get: get
    });
  };
  return new Proxy(loopError, {
    apply: apply,
    get: get
  });
};
ansi_wrap = function(a, b){
  return function(msg){
    return '\u001b[' + a + 'm' + msg + '\u001b[' + b + 'm';
  };
};
x$ = cc = {};
x$.ok = function(txt){
  return "\x1B[38;5;2m" + txt + "\x1B[39m";
};
x$.er1 = function(txt){
  return "\x1B[38;5;3m" + txt + "\x1B[39m";
};
x$.er2 = function(txt){
  return "\x1B[38;5;13m" + txt + "\x1B[39m";
};
x$.er3 = function(txt){
  return "\x1B[38;5;1m" + txt + "\x1B[39m";
};
x$.warn = function(txt){
  return "\x1B[38;5;11m" + txt + "\x1B[39m";
};
x$.pink = function(txt){
  return "\u001b[35m" + txt + "\u001b[39m";
};
x$.blue = function(txt){
  return "\x1B[38;5;12m" + txt + "\x1B[39m";
};
x$.white = function(txt){
  return "\x1B[37m" + txt + "\x1B[39m";
};
x$.grey = function(txt){
  return "\x1B[38;5;8m" + txt + "\x1B[39m";
};
c = {};
aj = function(func){
  return function(){
    return func(arrayFrom$(arguments).join(""));
  };
};
for (name in cc) {
  func = cc[name];
  c[name] = aj(func);
}
lit = R.pipe(R.zipWith(function(x, f){
  switch (R.type(f)) {
  case 'Function':
    return f(x);
  default:
    return x;
  }
}), R.join(""));
rm_paths = function(ignore){
  return R.unless(R.find(function(x){
    return x === 'node_modules' || in$(x, ignore);
  }), function(path){
    return in$(path[0] + "/" + path[1], ["internal/modules", "internal/main"]);
  });
};
create_stack = function(take_only, paths, init_txt){
  var EMP;
  paths == null && (paths = []);
  EMP = rm_paths(paths);
  return function(E){
    var disp, cc, i$, len$, data, lineNumber, fileName, functionName, columnNumber, path, item, c_item;
    if (!E) {
      l("Error: cannot show Error stack without Error object.");
      return;
    }
    E = esp.parse(E);
    if (init_txt) {
      l(init_txt);
    }
    disp = [];
    cc = [c.blue, c.grey];
    cc = [c.grey, c.grey];
    for (i$ = 0, len$ = E.length; i$ < len$; ++i$) {
      data = E[i$];
      lineNumber = data.lineNumber, fileName = data.fileName, functionName = data.functionName, columnNumber = data.columnNumber;
      path = fileName.split("/");
      if (EMP(path)) {
        continue;
      }
      if (functionName === 'Object.<anonymous>') {
        functionName = "";
      }
      item = ["  - ", R.last(path), ":", lineNumber, " ", functionName, "\n    ", fileName + ":", lineNumber, ":" + columnNumber + "\n"];
      c_item = R.join("", item);
      disp.push(c_item);
    }
    if (disp.length === 0) {
      return;
    }
    return l(
    R.join("\n")(
    function(x){
      var fin, i$, to$, I;
      fin = [];
      for (i$ = 0, to$ = x.length; i$ < to$; ++i$) {
        I = i$;
        fin.push(cc[I % 2](x[I]));
      }
      return fin;
    }(
    R.take(take_only)(
    R.reverse(
    disp)))));
  };
};
print_fail = function(filename){
  return function(message){
    var txt;
    message == null && (message = "");
    l("[TEST ERROR] " + filename + ":");
    txt = (function(){
      switch (typeof message) {
      case 'number':
        return "\n    failed at TEST NUMBER " + message + "\n";
      case 'string':
        return "\n    " + message + "\n";
      default:
        return "";
      }
    }());
    l(txt);
    process.exitCode = 1;
  };
};
wait = function(t, f){
  return setTimeout(f, t);
};
tupnest_recurse = function(a, index){
  var ot;
  index == null && (index = 0);
  if (index === a.length - 1) {
    return a[index];
  }
  ot = a[index];
  if (R.type(a[index]) === 'Array') {
    return arrayFrom$(ot).concat([tupnest_recurse(a, index + 1)]);
  } else {
    return [ot, tupnest_recurse(a, index + 1)];
  }
};
tupnest = function(){
  return tupnest_recurse(arguments, 0);
};
tupnest.push = function(da, ta){
  var current, cont, last_index;
  current = da;
  cont = true;
  while (cont) {
    last_index = current.length - 1;
    if (Array.isArray(current[last_index])) {
      current = current[last_index];
    } else {
      current.push(ta);
      cont = false;
    }
  }
  return da;
};
tupnest.concat = function(da, ta){
  var cda;
  cda = R.clone(da);
  return tupnest.push(cda, ta);
};
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
com = {
  z: z,
  l: l,
  c: c,
  R: R,
  esp: esp,
  lit: lit,
  flat: flat,
  noop: noop,
  wait: wait,
  jspc: jspc,
  binapi: pub,
  tupnest: tupnest,
  pad: advanced_pad,
  loopError: loopfault,
  print_fail: print_fail,
  alpha_sort: alpha_sort,
  uic: util_inspect_custom,
  deep_freeze: deep_freeze,
  create_stack: create_stack
};
com.version = '2.0.0';
com.homepage = 'https://github.com/sourcevault/hoplon#readme.md';
com.id_htypes = Symbol('hoplon.types');
com = Object.freeze(com);
module.exports = com;
function in$(x, xs){
  var i = -1, l = xs.length >>> 0;
  while (++i < l) if (x === xs[i]) return true;
  return false;
}