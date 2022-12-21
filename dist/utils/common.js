var vendor, z, l, flat, advanced_pad, jspc, deep_freeze, alpha_sort, R, esp, util, util_inspect_custom, noop, jdef, j, zj, loopfault, x$, c, lit, rm_paths, create_stack, print_fail, wait, ext, slice$ = [].slice, arrayFrom$ = Array.from || function(x){return slice$.call(x);};
vendor = require("./vendor");
z = console.log;
l = console.log;
flat = vendor.flat;
advanced_pad = vendor.pad;
jspc = vendor.stringify;
deep_freeze = vendor.deepFreeze;
alpha_sort = vendor.alpha_sort;
R = require("ramda");
esp = require("error-stack-parser");
if (typeof window === "undefined" && typeof module === "object") {
  util = require('util');
  util_inspect_custom = util.inspect.custom;
} else {
  util_inspect_custom = Symbol['for']('nodejs.util.inspect.custom');
}
noop = function(){};
noop[util_inspect_custom] = function(){
  return this[util_inspect_custom];
};
jdef = {
  maxLength: 30,
  margins: true
};
j = function(obj){
  return jspc(obj, jdef);
};
j.o = R.curry(function(opt, obj){
  if (opt === undefined) {
    opt = jdef;
  } else {
    opt = R.mergeRight(jdef, opt);
  }
  return jspc(obj, opt);
});
zj = function(obj, y){
  if (y) {
    return z(y, j(obj));
  } else {
    return z(j(obj));
  }
};
z.n = function(){
  var args;
  args = ['\n--\n'].concat(arrayFrom$(arguments), ['\n--\n']);
  return console.log.apply(console, args);
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
x$ = c = {};
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
  return "\x1B[38;5;17m" + txt + "\x1B[39m";
};
x$.grey = function(txt){
  return "\x1B[38;5;8m" + txt + "\x1B[39m";
};
x$.blue = function(txt){
  return "\x1B[38;5;12m" + txt + "\x1B[39m";
};
x$.white = function(txt){
  return "\x1B[37m" + txt + "\x1B[39m";
};
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
ext = {
  z: z,
  j: j,
  l: l,
  c: c,
  zj: zj,
  esp: esp,
  lit: lit,
  flat: flat,
  noop: noop,
  wait: wait,
  jspc: jspc,
  pad: advanced_pad,
  R: Object.freeze(R),
  loopError: loopfault,
  print_fail: print_fail,
  alpha_sort: alpha_sort,
  uic: util_inspect_custom,
  deep_freeze: deep_freeze,
  create_stack: create_stack
};
module.exports = ext;
function in$(x, xs){
  var i = -1, l = xs.length >>> 0;
  while (++i < l) if (x === xs[i]) return true;
  return false;
}