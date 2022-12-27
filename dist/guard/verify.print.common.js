var ext, com, print, modflag, z, R, common_symbols, zj, version, htypes, V, ref$, customTypeoOf, array2obj, multi_object, fun2map, ret_void, numfunfun, out$ = typeof exports != 'undefined' && exports || this;
ext = require("./print.common");
com = ext.com, print = ext.print, modflag = ext.modflag;
z = com.z, R = com.R, common_symbols = com.common_symbols, zj = com.zj, version = com.version;
htypes = com.common_symbols.htypes;
V = {};
ref$ = out$;
import$(ref$, ext);
ref$.verify = V;
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
V.def = function(args){
  var f;
  f = args[0];
  switch (customTypeoOf(f)) {
  case 'Function':
    return ['ok', ['f', f]];
  case 'htypes':
    return ['ok', ['v', f]];
  default:
    return ['ok', ['s', f]];
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
multi_object = function(fun2map, ob){
  var ret, index, item, a_item, clean, tup, i$, to$, k, item_inner, id;
  if (!(customTypeoOf(ob) === 'Object')) {
    return ['fault', ['ob_not_object']];
  }
  ret = {};
  for (index in ob) {
    item = ob[index];
    if (!Number.isInteger(Number(index))) {
      continue;
    }
    switch (R.type(item)) {
    case 'Array':
      a_item = item;
      break;
    case 'Function':
      a_item = [item];
      break;
    default:
      return ['fault', ['ob_inner_array', index]];
    }
    if (Array.isArray(a_item[0])) {
      clean = a_item;
    } else {
      clean = [a_item];
    }
    tup = [];
    for (i$ = 0, to$ = clean.length; i$ < to$; ++i$) {
      k = i$;
      item_inner = clean[k];
      id = fun2map(item_inner);
      if (id[0] === 'fault') {
        return ['fault', [id[1], index + '.' + k]];
      }
      tup.push(id);
    }
    ret[index] = tup;
  }
  return ['ok', ['ob', ret]];
};
fun2map = {};
fun2map.arwh_ob = function(item_inner){
  var whatdo, validator, tup;
  if (!Array.isArray(item_inner)) {
    return ['fault', 'ob_inner_not_array'];
  }
  switch (item_inner.length) {
  case 1:
    whatdo = item_inner[0];
    validator = void 8;
    break;
  default:
    validator = item_inner[0], whatdo = item_inner[1];
  }
  tup = [];
  switch (customTypeoOf(validator)) {
  case 'Function':
    tup.push(['f', validator]);
    break;
  case 'htypes':
    tup.push(['v', validator]);
    break;
  case 'Undefined':
    tup.push(['b', true]);
    break;
  case 'Boolean':
    tup.push(['b', validator]);
    break;
  default:
    return ['fault', 'ob_inner_array_validator'];
  }
  switch (customTypeoOf(whatdo)) {
  case 'Function':
    tup.push(['f', whatdo]);
    break;
  case 'htypes':
    tup.push(['v', whatdo]);
    break;
  default:
    tup.push(['s', whatdo]);
  }
  return tup;
};
ret_void = function(){};
fun2map.arpar_ob = function(item_inner){
  var whatdo, lastview, validator, tup;
  if (!Array.isArray(item_inner)) {
    return ['fault', 'ob_inner_not_array'];
  }
  switch (item_inner.length) {
  case 2:
    whatdo = item_inner[0], lastview = item_inner[1];
    validator = true;
    break;
  default:
    validator = item_inner[0], whatdo = item_inner[1], lastview = item_inner[2];
  }
  tup = [];
  switch (customTypeoOf(validator)) {
  case 'Function':
    tup.push(['f', validator]);
    break;
  case 'htypes':
    tup.push(['v', validator]);
    break;
  case 'Undefined':
    tup.push(['b', true]);
    break;
  case 'Boolean':
    tup.push(['b', validator]);
    break;
  default:
    return ['fault', 'ob_inner_array_validator'];
  }
  switch (customTypeoOf(whatdo)) {
  case 'Function':
    tup.push(['f', whatdo]);
    break;
  case 'htypes':
    tup.push(['v', whatdo]);
    break;
  default:
    tup.push(['s', whatdo]);
  }
  switch (R.type(lastview)) {
  case 'Function':
    tup.push(lastview);
    break;
  case 'Undefined':
    tup.push(ret_void);
    break;
  default:
    return ['fault', 'ob_inner_lastview'];
  }
  return tup;
};
V.arwh_ob = function(ob){
  return multi_object(fun2map.arwh_ob, ob);
};
V.ar_ob = function(ob){
  var ret, index, item, to_add;
  if (!(customTypeoOf(ob) === 'Object')) {
    return ['fault', ['ar_ob_not_object']];
  }
  ret = {};
  for (index in ob) {
    item = ob[index];
    if (!Number.isInteger(Number(index))) {
      continue;
    }
    to_add = (fn$());
    ret[index] = to_add;
  }
  return ['ok', ['ob', ret]];
  function fn$(){
    switch (customTypeoOf(item)) {
    case 'Function':
      return ['f', item];
    case 'htypes':
      return ['v', item];
    default:
      return ['s', item];
    }
  }
};
V.ar = function(fname, args){
  var num, fun, ret, type;
  if (args.length === 1 && fname === 'ar') {
    return V.ar_ob(args[0]);
  }
  if (args.length > 2) {
    return ['fault', ['many_args']];
  }
  if (args.length < 2) {
    return ['fault', ['few_args']];
  }
  num = args[0], fun = args[1];
  ret = [];
  type = 'n';
  switch (V.num(num)) {
  case 'num':
    ret.push(num);
    break;
  case 'array':
    type = 'a';
    ret.push(array2obj(num));
    break;
  case 'fault':
    return ['fault', ['first']];
  case 'fault.array':
    return ['fault', ['array']];
  }
  switch (customTypeoOf(fun)) {
  case 'Function':
    ret.push(['f', fun]);
    break;
  case 'htypes':
    ret.push(['v', fun]);
    break;
  default:
    ret.push(['s', fun]);
  }
  return ['ok', [type, ret]];
};
V.wh = function(fname, args){
  var validator, ap, ret;
  if (args.length > 2) {
    return ['fault', ['many_args']];
  }
  if (args.length < 2) {
    return ['fault', ['few_args']];
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
    return ['fault', ['first']];
  }
  switch (customTypeoOf(ap)) {
  case 'Function':
    ret.push(['f', ap]);
    break;
  case 'htypes':
    ret.push(['v', ap]);
    break;
  default:
    ret.push(['s', ap]);
  }
  return ['ok', ret];
};
numfunfun = function(args){
  var num, validator, ap, type, val, ret;
  num = args[0], validator = args[1], ap = args[2];
  switch (V.num(num)) {
  case 'num':
    type = 'n';
    val = num;
    break;
  case 'array':
    type = 'a';
    val = array2obj(num);
    break;
  case 'fault':
    return ['fault', ['first']];
  case 'fault.array':
    return ['fault', ['array']];
  }
  ret = [];
  switch (customTypeoOf(validator)) {
  case 'Function':
    ret.push(['f', validator]);
    break;
  case 'htypes':
    ret.push(['v', validator]);
    break;
  default:
    return ['fault', ['second']];
  }
  switch (customTypeoOf(ap)) {
  case 'Function':
    ret.push(['f', ap]);
    break;
  default:
    ret.push(['s', ap]);
  }
  return ['ok', [type, [val, ret]]];
};
V.arwh = function(fname, args){
  if (args.length === 1 && (fname === 'arwh' || fname === 'arwhn' || fname === 'arma')) {
    return V.arwh_ob(args[0]);
  }
  if (args.length < 3) {
    return ['fault', ['few_args']];
  }
  if (args.length > 3) {
    return ['fault', ['many_args']];
  }
  return numfunfun(args);
};
V.arpar_ob = function(ob){
  return multi_object(fun2map.arpar_ob, ob);
};
V.arpar = function(fname, args){
  var ref$, cont, data, arg4, ret;
  if (args.length === 1) {
    return V.arpar_ob(args[0]);
  }
  if (args.length < 3) {
    return ['fault', ['few_args']];
  }
  if (args.length > 4) {
    return ['fault', ['many_args']];
  }
  ref$ = numfunfun(args), cont = ref$[0], data = ref$[1];
  if (cont === 'fault') {
    return ret;
  }
  arg4 = args[3];
  ret = data[1][1];
  z("hello woloo");
  switch (R.type(arg4)) {
  case 'Function':
    ret.push(arg4);
    break;
  case 'Undefined':
    ret.push(ret_void);
    break;
  default:
    return ['fault', ['fourth']];
  }
  return ['ok', data];
};
V.par = function(fname, args){
  var validator, ap, lastview, ret, type;
  if (args.length < 3) {
    return ['fault', ['few_args']];
  }
  if (args.length > 3) {
    return ['fault', ['many_args']];
  }
  validator = args[0], ap = args[1], lastview = args[2];
  ret = [];
  switch (customTypeoOf(validator)) {
  case 'Function':
    ret.push(['f', validator]);
    break;
  case 'htypes':
    ret.push(['v', validator]);
    break;
  default:
    return ['fault', ['validator']];
  }
  type = customTypeoOf(ap);
  switch (type) {
  case 'Function':
    ret.push(['f', ap]);
    break;
  default:
    ret.push(['s', ap]);
  }
  switch (customTypeoOf(lastview)) {
  case 'Function':
    ret.push(lastview);
    break;
  default:
    return ['fault', ['lastview']];
  }
  return ['ok', ret];
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
  case 'par':
    return V.par;
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