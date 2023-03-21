var pkg, internal, com, print, z, l, R, j, deep_freeze, uic, loopError, noop, xop, custom, define, defset, be, non_map_props, props, base, not_base, undefnull, F, i$, len$, ref$, name, type, A, B, C, resreq, objarr, reqError, resError, resreqError, restricted, integer, boolnum, maybe_boolnum, maybe, list, flatro, is_special_str, rm_not_arrays, slice$ = [].slice, arrayFrom$ = Array.from || function(x){return slice$.call(x);};
pkg = require('./print.common');
internal = require('./internal');
com = pkg.com, print = pkg.print;
z = com.z, l = com.l, R = com.R, j = com.j, deep_freeze = com.deep_freeze, uic = com.uic, loopError = com.loopError, noop = com.noop;
xop = pkg.guard;
custom = internal.custom, define = internal.define, defset = internal.defset;
be = custom;
be.known = {};
non_map_props = [['undef', 'Undefined'], ['null', 'Null'], ['num', 'Number'], ['str', 'String'], ['fun', 'Function'], ['bool', 'Boolean'], ['objerr', 'Error']];
props = [['obj', 'Object'], ['arr', 'Array']].concat(arrayFrom$(non_map_props));
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
defset.add(undefnull);
F = base('Arguments');
define.basis('arg', F, 'arr');
define.basis.empty('arg', 'arr');
be.arg = F;
be.not = function(F, msg){
  var V;
  msg == null && (msg = void 8);
  V = be(F);
  return be(function(x){
    var von;
    von = V.auth(x);
    if (von['continue']) {
      return {
        'continue': false,
        error: true,
        message: msg
      };
    } else {
      return {
        'continue': true,
        error: false,
        value: von.value
      };
    }
  });
};
be.undefnull = be(undefnull);
be.not.undefnull = be.not(undefnull, "is undefined or null");
be.maybe = function(F){
  return be(F).or(be.undef).err(function(msg){
    msg.pop();
    return msg;
  });
};
be.list = function(F){
  return be.arr.map(F);
};
for (i$ = 0, len$ = props.length; i$ < len$; ++i$) {
  ref$ = props[i$], name = ref$[0], type = ref$[1];
  A = base(type);
  base(name, A);
  define.basis(name, A);
  be[name] = A;
  B = not_base(type);
  define.basis(name, B);
  be.not[name] = B;
  C = define.basis.empty(name);
  be.known[name] = C;
}
for (i$ = 0, len$ = non_map_props.length; i$ < len$; ++i$) {
  name = non_map_props[i$][0];
  be.maybe[name] = be.maybe(be[name]);
}
be.maybe.obj = be.obj.or(be.undef);
be.maybe.arr = be.arr.or(be.undef);
resreq = {};
resreq.gen_error = function(data){
  return print.route([new Error(), 'resreq', data]);
};
resreq.not_array_of_str_or_num = function(type){
  return function(){
    var args, i$, len$, key, ref$;
    args = R.flatten(arrayFrom$(arguments));
    for (i$ = 0, len$ = args.length; i$ < len$; ++i$) {
      key = args[i$];
      if (!((ref$ = R.type(key)) === 'String' || ref$ === 'Number')) {
        return [type];
      }
    }
    return false;
  };
};
resreq.both = function(req, res){
  var i$, len$, I, ref$;
  if (!(R.type(req) === 'Array' && R.type(res) === 'Array')) {
    return ['resreq', 'prime'];
  }
  for (i$ = 0, len$ = req.length; i$ < len$; ++i$) {
    I = req[i$];
    if (!((ref$ = R.type(I)) === 'String' || ref$ === 'Number')) {
      return ['resreq', 'res'];
    }
  }
  for (i$ = 0, len$ = res.length; i$ < len$; ++i$) {
    I = res[i$];
    if (!((ref$ = R.type(I)) === 'String' || ref$ === 'Number')) {
      return ['resreq', 'req'];
    }
  }
  return false;
};
objarr = be.obj.alt(be.arr).err("not object or array");
resreq.req = function(){
  var props, F, von;
  props = R.flatten(arrayFrom$(arguments));
  F = be.not.undef.err([':req', props]);
  von = objarr.on(props, F);
  return von;
};
reqError = xop.wh(resreq.not_array_of_str_or_num('req'), resreq.gen_error);
resError = xop.wh(resreq.not_array_of_str_or_num('res'), resreq.gen_error);
resreqError = xop.cap(resreq.both, resreq.gen_error);
be.required = reqError.def(resreq.req);
restricted = function(props, po){
  return function(obj){
    var keys, i$, len$, I;
    keys = Object.keys(obj);
    for (i$ = 0, len$ = keys.length; i$ < len$; ++i$) {
      I = keys[i$];
      if (!po[I]) {
        return [false, [':res', props], I];
      }
    }
    return true;
  };
};
be.restricted = resError.def(function(){
  var props, po, i$, len$, I;
  props = R.flatten(arrayFrom$(arguments));
  po = {};
  for (i$ = 0, len$ = props.length; i$ < len$; ++i$) {
    I = props[i$];
    po[I] = true;
  }
  return objarr.and(restricted(props, po));
});
be.resreq = resreqError.def(function(req, res){
  var po, i$, len$, I;
  po = {};
  for (i$ = 0, len$ = res.length; i$ < len$; ++i$) {
    I = res[i$];
    po[I] = true;
  }
  return objarr.on(req, be.not.undef.err([':req', req])).and(restricted(res, po));
});
integer = function(UFO){
  var residue;
  if (!(R.type(UFO) === 'Number')) {
    return {
      'continue': false,
      error: true,
      message: "not an integer ( or number )",
      value: UFO
    };
  }
  residue = Math.abs(UFO - Math.round(UFO));
  if (residue > 0) {
    return {
      'continue': false,
      error: true,
      message: "not an integer",
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
defset.add(integer);
boolnum = function(UFO){
  var ref$;
  if ((ref$ = R.type(UFO)) === 'Boolean' || ref$ === 'Number') {
    return {
      'continue': true,
      error: false,
      value: UFO
    };
  } else {
    return {
      'continue': false,
      error: true,
      message: "not a number or boolean",
      value: UFO
    };
  }
};
defset.add(boolnum);
maybe_boolnum = function(UFO){
  var ref$;
  if ((ref$ = R.type(UFO)) === 'Undefined' || ref$ === 'Boolean' || ref$ === 'Number') {
    return {
      'continue': true,
      error: false,
      value: UFO
    };
  } else {
    return {
      'continue': false,
      error: true,
      message: "not a number or boolean",
      value: UFO
    };
  }
};
defset.add(maybe_boolnum);
be.int = be(integer);
be.boolnum = be(boolnum);
be.int.neg = be.int.and(function(x){
  if (x <= 0) {
    return true;
  } else {
    return [false, "not a negative integer"];
  }
});
be.int.pos = be.int.and(function(x){
  if (x >= 0) {
    return true;
  } else {
    return [false, "not a positive integer"];
  }
});
maybe = be.maybe;
maybe.int = be.int.or(be.undef);
maybe.int.pos = maybe(be.int.pos);
maybe.int.neg = maybe(be.int.neg);
maybe.boolnum = be(maybe_boolnum);
list = be.list;
list.ofstr = list(be.str).err(function(msg, key){
  switch (R.type(key)) {
  case 'Undefined':
    return "not a list of string.";
  default:
    return [':list', [key[0], "not string type"]];
  }
});
list.ofnum = list(be.num).err(function(msg, key){
  switch (R.type(key)) {
  case 'Undefined':
    return "not a list of number.";
  default:
    return [':list', [key[0], "not number type"]];
  }
});
list.ofint = list(be.int).err(function(msg, key){
  switch (R.type(key)) {
  case 'Undefined':
    return "not a list of integer.";
  default:
    return [':list', [key[0], "not integer type"]];
  }
});
maybe.list = {};
maybe.list.ofstr = maybe(list.ofstr);
maybe.list.ofnum = maybe(list.ofnum);
maybe.list.ofint = maybe(list.ofint);
flatro = {};
flatro.sort = function(arg$, arg1$){
  var txt1, txt2, ref$, __, name1, number1, name2, number2;
  txt1 = arg$[0];
  txt2 = arg1$[0];
  ref$ = txt1.split(":"), __ = ref$[0], name1 = ref$[1], number1 = ref$[2];
  if (number1 === void 8) {
    number1 = 0;
  } else {
    number1 = parseInt(number1);
  }
  ref$ = txt2.split(":"), __ = ref$[0], name2 = ref$[1], number2 = ref$[2];
  if (number2 === void 8) {
    number2 = 0;
  } else {
    number2 = parseInt(number2);
  }
  if (number1 > number2) {
    return -1;
  }
  if (number1 < number2) {
    return 1;
  } else {
    return 0;
  }
};
is_special_str = function(str){
  if (R.type(str) === 'String' && str[0] === ":") {
    return true;
  } else {
    return false;
  }
};
flatro.array = function(msg, fin){
  var i$, len$, I, uno, results$ = [];
  for (i$ = 0, len$ = msg.length; i$ < len$; ++i$) {
    I = msg[i$];
    switch (R.type(I)) {
    case 'String':
    case 'Number':
      results$.push(fin.push(I));
      break;
    case 'Array':
      uno = I[0];
      if (is_special_str(uno)) {
        results$.push(fin.push(I));
      } else {
        results$.push(flatro.array(I, fin));
      }
    }
  }
  return results$;
};
rm_not_arrays = R.filter(function(x){
  return R.type(x) === 'Array';
});
flatro.main = function(msg){
  var out, fin, clean, sorted;
  out = (function(){
    switch (R.type(msg)) {
    case 'String':
      return [msg];
    case 'Array':
      fin = [];
      if (is_special_str(msg[0])) {
        msg = [msg];
      }
      flatro.array(msg, fin);
      return fin;
    default:
      return [];
    }
  }());
  clean = rm_not_arrays(out);
  if (clean.length === 0) {
    return [[void 8, out]];
  } else {
    sorted = clean.sort(flatro.sort);
    return sorted;
  }
};
be.any = be(function(){
  return true;
});
be.tap = function(f){
  return be.any.tap(f);
};
be.flatro = flatro.main;
pkg = {};
pkg.types = be;
pkg.guard = xop;
pkg.internal = com;
pkg = Object.freeze(pkg);
module.exports = pkg;