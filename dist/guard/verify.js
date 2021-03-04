var ext, com, print, modflag, z, R, common_symbols, zj, htypes, V, ref$, customTypeoOf, array2obj, numfunfun, identity, out$ = typeof exports != 'undefined' && exports || this;
ext = require("./print.common");
com = ext.com, print = ext.print, modflag = ext.modflag;
z = com.z, R = com.R, common_symbols = com.common_symbols, zj = com.zj;
htypes = com.common_symbols.htypes;
V = {};
ref$ = out$;
import$(ref$, ext);
ref$.verify = V;
V.def = function(args){
  var f;
  f = args[0];
  switch (R.type(f)) {
  case 'Function':
    return ['ok', ['f', f]];
  default:
    return ['ok', ['s', f]];
  }
};
customTypeoOf = function(unknown){
  var type;
  type = R.type(unknown);
  switch (type) {
  case 'Object':
  case 'Function':
    if (unknown[htypes]) {
      return 'htypes';
    }
    return type;
  default:
    return type;
  }
};
V.num = function(num){
  var i$, len$, v;
  switch (R.type(num)) {
  case 'Number':
    return 'num';
  case 'Array':
    for (i$ = 0, len$ = num.length; i$ < len$; ++i$) {
      v = num[i$];
      if (!(typeof v === 'number')) {
        return 'fault.array';
      }
    }
    return 'array';
  default:
    return 'fault';
  }
};
array2obj = function(arr){
  var ob, i$, len$, I;
  ob = {};
  for (i$ = 0, len$ = arr.length; i$ < len$; ++i$) {
    I = arr[i$];
    ob[I] = true;
  }
  return ob;
};
V.ar = function(args){
  var num, fun, ret;
  if (args.length > 2) {
    return ['fault', 'many_args'];
  }
  if (args.length < 2) {
    return ['fault', 'few_args'];
  }
  num = args[0], fun = args[1];
  ret = [];
  switch (V.num(num)) {
  case 'num':
    ret.push(array2obj([num]));
    break;
  case 'array':
    ret.push(array2obj(num));
    break;
  case 'fault':
    return ['fault', 'first'];
  case 'fault.array':
    return ['fault', 'array'];
  }
  switch (R.type(fun)) {
  case 'Function':
    ret.push(['f', fun]);
    break;
  default:
    ret.push(['s', fun]);
  }
  return ['ok', ret];
};
V.wh = function(args){
  var validator, ap, ret;
  if (args.length > 2) {
    return ['fault', 'many_args'];
  }
  if (args.length < 2) {
    return ['fault', 'few_args'];
  }
  validator = args[0], ap = args[1];
  ret = [];
  switch (customTypeoOf(validator)) {
  case 'Function':
    ret.push(['f', validator]);
    break;
  case 'htypes':
    ret.push(['v', validator]);
    break;
  default:
    return ['fault', 'first'];
  }
  switch (R.type(ap)) {
  case 'Function':
    ret.push(['f', ap]);
    break;
  default:
    ret.push(['s', ap]);
  }
  return ['ok', ret];
};
numfunfun = function(args){
  var num, validator, ap, ret, type;
  num = args[0], validator = args[1], ap = args[2];
  ret = [];
  switch (V.num(num)) {
  case 'num':
    ret.push(array2obj([num]));
    break;
  case 'array':
    ret.push(array2obj(num));
    break;
  case 'fault':
    return ['fault', 'first'];
  case 'fault.array':
    return ['fault', 'array'];
  }
  switch (R.type(validator)) {
  case 'Function':
    ret.push(['f', validator]);
    break;
  case 'htypes':
    ret.push(['v', validator]);
    break;
  default:
    return ['fault', 'second'];
  }
  type = R.type(ap);
  switch (type) {
  case 'Function':
    ret.push(['f', ap]);
    break;
  default:
    ret.push(['s', ap]);
  }
  return ['ok', ret];
};
V.arwh = function(args){
  if (args.length > 3) {
    return ['fault', 'many_args'];
  }
  if (args.length < 3) {
    return ['fault', 'few_args'];
  }
  return numfunfun(args);
};
identity = function(){
  return false;
};
V.arpar = function(args){
  var ref$, cont, data, ret, arg4, fin;
  if (args.length < 3) {
    return ['fault', 'few_args'];
  }
  if (args.length > 4) {
    return ['fault', 'many_args'];
  }
  ref$ = numfunfun(args), cont = ref$[0], data = ref$[1];
  if (cont === 'fault') {
    return ret;
  }
  ret = data;
  arg4 = args[3];
  switch (R.type(arg4)) {
  case 'Function':
    ret.push(arg4);
    break;
  case 'Undefined':
  case 'Null':
    ret.push(identity);
    break;
  default:
    return ['fault', 'fourth'];
  }
  fin = ['ok', ret];
  return fin;
};
V.getvfun = function(fname){
  switch (fname) {
  case 'wh':
  case 'whn':
  case 'ma':
    return V.wh;
  case 'ar':
  case 'arn':
    return V.ar;
  case 'def':
    return V.def;
  case 'arpar':
    return V.arpar;
  case 'arwh':
  case 'arnwh':
  case 'arwhn':
  case 'arnwhn':
  case 'arma':
    return V.arwh;
  }
};
function import$(obj, src){
  var own = {}.hasOwnProperty;
  for (var key in src) if (own.call(src, key)) obj[key] = src[key];
  return obj;
}