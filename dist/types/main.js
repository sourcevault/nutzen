var ref$, com, print, z, l, R, j, deep_freeze, uic, loopError, oxo, int, custom, define, cache, be, props, nonmap, base, not_base, undefnull, F, pop, i$, len$, name, type, A, B, C, V, notArrayofStrOrNum, reqError, resError, reqresError, objarr, restricted, integer, boolnum, maybe_boolnum, maybe, list, handleE, is_special_str, rmObj, slice$ = [].slice, arrayFrom$ = Array.from || function(x){return slice$.call(x);};
ref$ = require('./print.common'), com = ref$.com, print = ref$.print;
z = com.z, l = com.l, R = com.R, j = com.j, deep_freeze = com.deep_freeze, uic = com.uic, loopError = com.loopError;
oxo = require('../guard/main');
int = require('./internal');
custom = int.custom, define = int.define, cache = int.cache;
be = custom;
props = [['obj', 'Object'], ['arr', 'Array'], ['undef', 'Undefined'], ['null', 'Null'], ['num', 'Number'], ['str', 'String'], ['fun', 'Function'], ['bool', 'Boolean']];
nonmap = R.map(function(arg$){
  var name;
  name = arg$[0];
  return name;
}, R.drop(2, props));
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
cache.def.add(undefnull);
be.undefnull = be(undefnull);
F = base("Arguments");
define.basis("arg", F);
be.arg = F;
pop = function(msg){
  msg.pop();
  return msg;
};
be.not = function(F){
  return be(function(x){
    return !F(x)['continue'];
  });
};
be.maybe = function(F){
  return be(F).or(be.undef).err(pop);
};
be.list = function(F){
  return be.arr.map(F);
};
be.not[uic] = print.inner;
be.list[uic] = print.inner;
be.maybe[uic] = print.inner;
be.known = {};
for (i$ = 0, len$ = props.length; i$ < len$; ++i$) {
  ref$ = props[i$], name = ref$[0], type = ref$[1];
  A = base(type);
  base(name, A);
  define.basis(name, A);
  be[name] = A;
  B = not_base(type);
  define.basis(name, B);
  be.not[name] = B;
  C = {};
  define.basis(name, C);
  be.known[name] = C;
}
V = be.known.arr;
z(V.auth(1));
for (i$ = 0, len$ = nonmap.length; i$ < len$; ++i$) {
  name = nonmap[i$];
  be.maybe[name] = be.maybe(be[name]);
}
be.maybe.obj = be.obj.or(be.undef);
be.maybe.arr = be.arr.or(be.undef);
notArrayofStrOrNum = function(type){
  return function(){
    var args, i$, len$, key, ref$;
    args = R.flatten(arrayFrom$(arguments));
    for (i$ = 0, len$ = args.length; i$ < len$; ++i$) {
      key = args[i$];
      if (!((ref$ = R.type(key)) === 'String' || ref$ === 'Number')) {
        print.route([new Error(), 'resreq', [type]]);
        return true;
      }
    }
    return false;
  };
};
reqError = oxo.wh(notArrayofStrOrNum('req'), loopError);
resError = oxo.wh(notArrayofStrOrNum('res'), loopError);
reqresError = oxo.wh(function(req, res){
  var i$, len$, I, ref$;
  if (!(R.type(req) === "Array" && R.type(res) === "Array")) {
    print.route([new Error(), 'resreq', ['resreq', 'prime']]);
    return true;
  }
  for (i$ = 0, len$ = req.length; i$ < len$; ++i$) {
    I = req[i$];
    if (!((ref$ = R.type(I)) === 'String' || ref$ === 'Number')) {
      print.route([new Error(), 'resreq', ['resreq', 'res']]);
      return true;
    }
  }
  for (i$ = 0, len$ = res.length; i$ < len$; ++i$) {
    I = res[i$];
    if (!((ref$ = R.type(I)) === 'String' || ref$ === 'Number')) {
      print.route([new Error(), 'resreq', ['resreq', 'req']]);
      return true;
    }
  }
}, loopError);
objarr = be.obj.alt(be.arr).err("not object or array");
be.required = reqError.def(function(){
  var props, ret;
  props = R.flatten(arrayFrom$(arguments));
  ret = objarr.on(props, be.not.undef.err([':req', props]));
  return ret;
});
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
be.reqres = reqresError.def(function(req, res){
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
cache.def.add(integer);
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
cache.def.add(boolnum);
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
cache.def.add(maybe_boolnum);
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
handleE = {};
handleE.rm_num = function(arg$){
  var txt, msg, name;
  txt = arg$[0], msg = arg$[1];
  name = txt.split(":")[1];
  if (msg === void 8) {
    return [name];
  } else {
    return [name, msg];
  }
};
handleE.sort = function(arg$, arg1$){
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
handleE.array = function(msg, fin){
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
        results$.push(handleE.array(I, fin));
      }
    }
  }
  return results$;
};
rmObj = R.filter(function(x){
  return typeof x === 'object';
});
handleE.entry = function(msg){
  var out, fin, onlyob, sorted;
  out = (function(){
    switch (R.type(msg)) {
    case 'String':
      return [msg];
    case 'Array':
      fin = [];
      if (is_special_str(msg[0])) {
        msg = [msg];
      }
      handleE.array(msg, fin);
      return fin;
    }
  }());
  onlyob = rmObj(out);
  if (onlyob.length === 0) {
    return out;
  } else {
    sorted = onlyob.sort(handleE.sort);
    return sorted;
  }
};
be.flatato = handleE.entry;
be = deep_freeze(be);
module.exports = be;