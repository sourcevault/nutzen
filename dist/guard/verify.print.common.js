var ext, com, print, symbols, z, R, version, tupnest, l, V, ref$, NumIsInt, customTypeoOf, array2obj, isA, multi_object, fun2map, numfunfun, out$ = typeof exports != 'undefined' && exports || this;
ext = require("./print.common");
com = ext.com, print = ext.print, symbols = ext.symbols;
z = com.z, R = com.R, version = com.version, tupnest = com.tupnest, l = com.l;
V = {};
ref$ = out$;
import$(ref$, ext);
ref$.verify = V;
NumIsInt = Number.isInteger;
customTypeoOf = function(unknown){
  var type;
  type = R.type(unknown);
  switch (type) {
  case 'Object':
  case 'Function':
    if (unknown[symbols.htypes]) {
      return 'htypes';
    }
    return type;
  case 'Number':
    if (NumIsInt(unknown)) {
      if (unknown > -1) {
        return 'pos_int';
      }
      return 'int';
    }
    return 'Number';
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
  switch (customTypeoOf(num)) {
  case 'pos_int':
    return 'num';
  case 'int':
  case 'number':
    return 'fault.num';
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
isA = Array.isArray;
multi_object = function(fun2map, ob){
  var ret, index, item, a_item, clean, tup, i$, to$, k, item_inner, id, status, capsule;
  if (!(customTypeoOf(ob) === 'Object')) {
    return ['fault', ['ob_not_object']];
  }
  ret = {};
  for (index in ob) {
    item = ob[index];
    if (!NumIsInt(Number(index))) {
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
      return ['fault', ['ob.key_value_not_array', index]];
    }
    if (isA(a_item[0])) {
      clean = a_item;
    } else {
      clean = [a_item];
    }
    tup = [];
    for (i$ = 0, to$ = clean.length; i$ < to$; ++i$) {
      k = i$;
      item_inner = clean[k];
      id = fun2map(item_inner);
      status = id[0];
      if (status === 'fault') {
        capsule = tupnest.concat(id, [index, k]);
        return capsule;
      }
      tup.push(id);
    }
    ret[index] = tup;
  }
  return ['ok', ['ob', ret]];
};
fun2map = {};
fun2map.arwh_ob = function(item_inner){
  var cat, whatdo, validator, tup;
  if (!isA(item_inner)) {
    return tupnest('fault', ['ob.inner_not_array']);
  }
  if (item_inner.length < 1) {
    return tupnest('fault', ['ob.few_args']);
  }
  if (item_inner.length > 2) {
    return tupnest('fault', ['ob.many_args']);
  }
  cat = item_inner.length;
  switch (cat) {
  case 1:
    whatdo = item_inner[0];
    break;
  case 2:
    validator = item_inner[0], whatdo = item_inner[1];
  }
  tup = [];
  if (cat === 2) {
    switch (customTypeoOf(validator)) {
    case 'Function':
      tup.push(['f', validator]);
      break;
    case 'htypes':
      tup.push(['v', validator]);
      break;
    default:
      return tupnest('fault', ['ob.inner_array_validator']);
    }
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
fun2map.arcap_ob = function(item_inner){
  var whatdo, cat, validator, lastview, tup;
  if (!isA(item_inner)) {
    return tupnest('fault', ['ob.inner_not_array']);
  }
  if (item_inner.length < 1) {
    return tupnest('fault', ['ob.few_args']);
  }
  if (item_inner.length > 3) {
    return tupnest('fault', ['ob.many_args']);
  }
  switch (item_inner.length) {
  case 1:
    whatdo = item_inner[0];
    cat = 1;
    break;
  case 2:
    validator = item_inner[0], whatdo = item_inner[1];
    cat = 2;
    break;
  case 3:
    validator = item_inner[0], lastview = item_inner[1], whatdo = item_inner[2];
    cat = 3;
  }
  tup = [];
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
  if (cat !== 1) {
    switch (customTypeoOf(validator)) {
    case 'Function':
      tup.push(['f', validator]);
      break;
    case 'htypes':
      tup.push(['v', validator]);
      break;
    default:
      return tupnest('fault', 'ob.inner_array_validator', [cat]);
    }
  }
  if (cat === 3) {
    switch (R.type(lastview)) {
    case 'Function':
      tup.push(lastview);
      break;
    default:
      return tupnest('fault', ['ob.inner_lastview']);
    }
  }
  return tup;
};
V.arwh_ob = function(ob){
  var da;
  da = multi_object(fun2map.arwh_ob, ob);
  return da;
};
V.ar_ob = function(ob){
  var ret, index, item, to_add;
  if (!(customTypeoOf(ob) === 'Object')) {
    return tupnest('fault', ['ob_not_object']);
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
  case 'fault.num':
    return ['fault', ['pos_int']];
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
  case 'fault.num':
    return ['fault', ['pos_int']];
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
  if (args.length === 1 && (fname === 'arwh' || fname === 'arwhn' || fname === 'arcap')) {
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
V.arcap_ob = function(ob){
  var fin;
  fin = multi_object(fun2map.arcap_ob, ob);
  return fin;
};
V.arcap = function(fname, args){
  var raw_num, whatdo, cat, validator, lastview, type, num, ret, send;
  if (args.length === 1) {
    return V.arcap_ob(args[0]);
  }
  if (args.length < 2) {
    return ['fault', ['few_args']];
  }
  if (args.length > 4) {
    return ['fault', ['many_args']];
  }
  switch (args.length) {
  case 2:
    raw_num = args[0], whatdo = args[1];
    cat = 2;
    break;
  case 3:
    raw_num = args[0], validator = args[1], whatdo = args[2];
    cat = 3;
    break;
  case 4:
    raw_num = args[0], validator = args[1], lastview = args[2], whatdo = args[3];
    cat = 4;
  }
  switch (V.num(raw_num)) {
  case 'num':
    type = 'n';
    num = raw_num;
    break;
  case 'array':
    type = 'a';
    num = array2obj(raw_num);
    break;
  case 'fault':
    return ['fault', ['num', cat]];
  case 'fault.array':
    return ['fault', ['num_array', cat]];
  }
  ret = [];
  switch (customTypeoOf(whatdo)) {
  case 'Function':
    ret.push(['f', whatdo]);
    break;
  default:
    ret.push(['s', whatdo]);
  }
  if (cat !== 2) {
    switch (customTypeoOf(validator)) {
    case 'Function':
      ret.push(['f', validator]);
      break;
    case 'htypes':
      ret.push(['v', validator]);
      break;
    default:
      return ['fault', ['validator', cat]];
    }
  }
  if (cat === 4) {
    switch (customTypeoOf(lastview)) {
    case 'Function':
      ret.push(lastview);
      break;
    default:
      return ['fault', ['lastview', cat]];
    }
  }
  send = tupnest('ok', type, num, ret);
  return send;
};
V.cap = function(fname, args){
  var validator, exec, cat, lastview, ret, type;
  if (args.length < 2) {
    return ['fault', ['few_args']];
  }
  if (args.length > 3) {
    return ['fault', ['many_args']];
  }
  switch (args.length) {
  case 2:
    validator = args[0], exec = args[1];
    cat = 2;
    break;
  case 3:
    validator = args[0], lastview = args[1], exec = args[2];
    cat = 3;
  }
  ret = [];
  type = customTypeoOf(exec);
  switch (type) {
  case 'Function':
    ret.push(['f', exec]);
    break;
  default:
    ret.push(['s', exec]);
  }
  switch (customTypeoOf(validator)) {
  case 'Function':
    ret.push(['f', validator]);
    break;
  case 'htypes':
    ret.push(['v', validator]);
    break;
  default:
    return ['fault', ['validator', cat]];
  }
  if (cat === 3) {
    switch (customTypeoOf(lastview)) {
    case 'Function':
      ret.push(lastview);
      break;
    default:
      return ['fault', ['lastview']];
    }
  }
  return ['ok', ret];
};
V.getvfun = function(fname){
  switch (fname) {
  case 'wh':
  case 'whn':
    return V.wh;
  case 'ar':
  case 'arn':
    return V.ar;
  case 'def':
    return V.def;
  case 'arcap':
    return V.arcap;
  case 'cap':
    return V.cap;
  case 'arwh':
  case 'arnwh':
  case 'arwhn':
  case 'arnwhn':
  case 'arcap':
    return V.arwh;
  }
};
function import$(obj, src){
  var own = {}.hasOwnProperty;
  for (var key in src) if (own.call(src, key)) obj[key] = src[key];
  return obj;
}