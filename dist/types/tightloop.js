var pc, com, pkgname, print, l, z, R, j, flat, pad, alpha_sort, esp, c, lit, create_stack, sanatize, x$, apply, y$, z$, red, exec_key, lopy, functor_EMsg, map, forEach, upon, green, split_on_value_list, split_on, i$, len$, I, self_amorty, tightloop;
pc = require('./print.common');
com = pc.com, pkgname = pc.pkgname, print = pc.print;
l = com.l, z = com.z, R = com.R, j = com.j, flat = com.flat, pad = com.pad, alpha_sort = com.alpha_sort, esp = com.esp, c = com.c, lit = com.lit, create_stack = com.create_stack;
sanatize = function(x, UFO){
  var unknown, path, von, priority, msg;
  switch (R.type(UFO)) {
  case 'Boolean':
  case 'Null':
  case 'Undefined':
  case 'Number':
    if (UFO) {
      return {
        'continue': true,
        error: false,
        value: x
      };
    } else {
      return {
        'continue': false,
        error: true,
        value: x
      };
    }
  case 'Array':
    if (UFO[0]) {
      return {
        'continue': true,
        error: false,
        value: x
      };
    } else {
      unknown = UFO[1];
      path = UFO[2];
      von = {
        'continue': false,
        error: true,
        value: x,
        message: unknown
      };
      switch (R.type(path)) {
      case 'Array':
        von.path = path;
        break;
      case 'String':
      case 'Number':
        von.path = [path];
      }
      return von;
    }
  case 'Object':
    if (UFO.hasOwnProperty('error')) {
      priority = 'error';
    } else {
      if (UFO.hasOwnProperty('continue')) {
        priority = 'continue';
      } else {
        priority = 'undecided';
      }
    }
    switch (priority) {
    case 'error':
      if (UFO.error) {
        UFO['continue'] = false;
      } else {
        UFO['continue'] = true;
      }
      break;
    case 'continue':
      if (UFO['continue']) {
        UFO.error = false;
      } else {
        UFO.error = true;
      }
      break;
    case 'undecided':
      UFO.error = true;
      msg = "[" + pkgname + "][typeError][user-supplied-validator] return object missing field values (.continue or .error).";
      UFO.message = msg;
    }
    return UFO;
  default:
    msg = "[" + pkgname + "][typeError][user-supplied-validator] undefined return value.";
    von = {
      'continue': false,
      error: true,
      value: x,
      message: msg
    };
    return von;
  }
};
x$ = apply = {};
y$ = x$.normal = {};
y$.key = null;
y$.top = null;
z$ = x$.auth = {};
z$.key = null;
z$.top = null;
red = function(fun, cond, args){
  var patt, F, von, nput;
  patt = fun[0], F = fun[1];
  switch (patt) {
  case 'err':
    von = (import$({}, cond));
    switch (typeof F) {
    case 'function':
      nput = apply.normal.err(F, args, cond);
      switch (R.type(nput)) {
      case 'Array':
      case 'String':
      case 'Number':
        von.message = nput;
        break;
      case 'Object':
        if (nput.hasOwnProperty('message')) {
          von.message = nput.message;
        }
        if (nput.hasOwnProperty('path')) {
          switch (R.type(nput.path)) {
          case 'Number':
          case 'String':
            von.path = [nput.path];
            break;
          case 'Array':
            von.path = nput.path;
          }
        }
        break;
      case 'Null':
        von.message = void 8;
      }
      break;
    default:
      von.message = F;
    }
    break;
  case 'fix':
    von = {
      'continue': true,
      error: false
    };
    von.value = (function(){
      switch (typeof F) {
      case 'function':
        return apply.normal.key(F, cond.value, args, cond.path);
      default:
        return F;
      }
    }());
    break;
  default:
    von = cond;
  }
  return von;
};
apply.normal.key = function(F, val, args, path){
  var list;
  switch (args.length) {
  case 1:
    return F(val, path);
  case 2:
    return F(val, path, args[1]);
  case 3:
    return F(val, path, args[1], args[2]);
  case 4:
    return F(val, path, args[1], args[2], args[3]);
  case 5:
    return F(val, path, args[1], args[2], args[3], args[4]);
  case 6:
    return F(val, path, args[1], args[2], args[3], args[4], args[5]);
  case 7:
    return F(val, path, args[1], args[2], args[3], args[4], args[5], args[6]);
  default:
    list = Array.prototype.slice.call(args);
    list.splice(1, 0, path);
    return F.apply(null, list);
  }
};
apply.normal.err = function(F, args, put){
  var message, path, list;
  message = put.message, path = put.path;
  switch (args.length) {
  case 0:
    return F(message, path);
  case 1:
    return F(message, path, args[0]);
  case 2:
    return F(message, path, args[0], args[1]);
  case 3:
    return F(message, path, args[0], args[1], args[2]);
  case 4:
    return F(message, path, args[0], args[1], args[2], args[3]);
  case 5:
    return F(message, path, args[0], args[1], args[2], args[3], args[4]);
  case 6:
    return F(message, path, args[0], args[1], args[2], args[3], args[4], args[5]);
  case 7:
    return F(message, path, args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
  default:
    list = Array.prototype.slice.call(args);
    list.unshift(message, path);
    return F.apply(null, list);
  }
};
apply.normal.top = function(F, val, args){
  var A;
  switch (args.length) {
  case 1:
    return F(val);
  case 2:
    return F(val, args[1]);
  case 3:
    return F(val, args[1], args[2]);
  case 4:
    return F(val, args[1], args[2], args[3]);
  case 5:
    return F(val, args[1], args[2], args[3], args[4]);
  case 6:
    return F(val, args[1], args[2], args[3], args[4], args[5]);
  case 7:
    return F(val, args[1], args[2], args[3], args[4], args[5], args[6]);
  default:
    A = Array.prototype.slice.call(args);
    A.shift();
    A.unshift(val);
    return F.apply(null, A);
  }
};
apply.auth.top = function(F, val, args){
  var A;
  switch (args.length) {
  case 1:
    return F.auth(val);
  case 2:
    return F.auth(val, args[1]);
  case 3:
    return F.auth(val, args[1], args[2]);
  case 4:
    return F.auth(val, args[1], args[2], args[3]);
  case 5:
    return F.auth(val, args[1], args[2], args[3], args[4]);
  case 6:
    return F.auth(val, args[1], args[2], args[3], args[4], args[5]);
  case 7:
    return F.auth(val, args[1], args[2], args[3], args[4], args[5], args[6]);
  default:
    A = Array.prototype.slice.call(args);
    A.shift();
    A.unshift(val);
    return F.auth.apply(F, A);
  }
};
apply.auth.key = function(F, val, args, key){
  var list, A;
  switch (args.length) {
  case 1:
    return F.auth(val, key);
  case 2:
    return F.auth(val, key, args[1]);
  case 3:
    return F.auth(val, key, args[1], args[2]);
  case 4:
    return F.auth(val, key, args[1], args[2], args[3]);
  case 5:
    return F.auth(val, key, args[1], args[2], args[3], args[4]);
  case 6:
    return F.auth(val, key, args[1], args[2], args[3], args[4], args[5]);
  case 7:
    return F.auth(val, key, args[1], args[2], args[3], args[4], args[5], args[6]);
  default:
    list = Array.prototype.slice.call(args);
    A = list.splice(1, 0, key);
    return F.auth.apply(F, A);
  }
};
'd';
'i';
'f';
exec_key = function(type, F, val, args, key){
  var cond;
  cond = (function(){
    switch (type) {
    case 'd':
      return apply.normal.key(F, val, args, key);
    case 'i':
      return apply.auth.key(F, val, args, key);
    case 'f':
      return sanatize(val, apply.normal.key(F, val, args, key));
    }
  }());
  if (cond.error) {
    if (cond.path) {
      cond.path = [key].concat(cond.path);
    } else {
      cond.path = [key];
    }
    cond.value = val;
  }
  return cond;
};
lopy = {};
lopy.fix_num = function(A, num){
  var value, len, mid;
  value = void 8;
  len = A.length;
  if (num === -Infinity) {
    value = 0;
  } else if (num === Infinity) {
    value = len;
  } else if (num < 0) {
    mid = len + num;
    value = mid;
    if (mid < 0) {
      value = 0;
    }
  } else {
    value = num;
  }
  return value;
};
lopy.reverse = function(to_add, user_array, start, end, step, arg$, args){
  var type, F, I, len, arr, cond;
  type = arg$[0], F = arg$[1];
  I = start;
  len = end - 1;
  arr = (function(func, args, ctor) {
    ctor.prototype = func.prototype;
    var child = new ctor, result = func.apply(child, args), t;
    return (t = typeof result)  == "object" || t == "function" ? result || child : child;
  })(Array, user_array, function(){});
  while (I > len) {
    cond = exec_key(type, F, user_array[I], args, I);
    if (to_add) {
      if (cond.error) {
        cond.value = user_array;
        return cond;
      }
      arr[I] = cond.value;
    }
    I -= step;
  }
  return {
    'continue': true,
    error: false,
    value: arr
  };
};
lopy.forward = function(to_add, user_array, start, end, step, arg$, args){
  var type, F, I, arr, len, cond;
  type = arg$[0], F = arg$[1];
  I = start;
  arr = (function(func, args, ctor) {
    ctor.prototype = func.prototype;
    var child = new ctor, result = func.apply(child, args), t;
    return (t = typeof result)  == "object" || t == "function" ? result || child : child;
  })(Array, user_array, function(){});
  len = end + 1;
  while (I < len) {
    cond = exec_key(type, F, user_array[I], args, I);
    if (to_add) {
      if (cond.error) {
        cond.value = user_array;
        return cond;
      }
      arr[I] = cond.value;
    }
    I += step;
  }
  return {
    'continue': true,
    error: false,
    value: arr
  };
};
lopy.main = function(to_add, fun, user_array, args){
  var ref$, u_start, u_end, step, F, start, end, cond;
  ref$ = fun[0], u_start = ref$[0], u_end = ref$[1], step = ref$[2], F = fun[1];
  start = this.fix_num(user_array, u_start);
  end = this.fix_num(user_array, u_end);
  if (step < 0) {
    step = Math.abs(step);
    cond = this.reverse(to_add, user_array, start, end, step, F, args);
  } else {
    cond = this.forward(to_add, user_array, start, end, step, F, args);
  }
  return cond;
};
functor_EMsg = "[" + pkgname + "][runtimeError] most likely due to changing mappable object to non-mappable.";
map = function(dtype, fun, udata, args){
  var ref$, type, F, ob, cond, key, val;
  if (typeof udata !== 'object') {
    return {
      'continue': false,
      error: true,
      message: functor_EMsg
    };
  }
  switch (dtype) {
  case 'arr':
    return lopy.main(true, fun, udata, args);
  case 'obj':
    ref$ = fun[0], type = ref$[0], F = ref$[1];
    ob = {};
    cond = null;
    for (key in udata) {
      val = udata[key];
      cond = exec_key(type, F, val, args, key);
      if (cond.error) {
        return cond;
      }
      ob[key] = cond.value;
    }
    return {
      'continue': true,
      error: false,
      value: ob
    };
  }
};
forEach = function(dtype, fun, udata, args){
  var cond, ref$, type, F, key, val;
  if (typeof udata !== 'object') {
    return {
      'continue': false,
      error: true,
      message: functor_EMsg
    };
  }
  cond = {
    'continue': true,
    error: false,
    value: udata
  };
  switch (dtype) {
  case 'arr':
    lopy.main(false, fun, udata, args);
    break;
  case 'obj':
    ref$ = fun[0], type = ref$[0], F = ref$[1];
    for (key in ref$ = value) {
      val = ref$[key];
      exec_key(type, F, val, args, key);
    }
  }
  return cond;
};
upon = function(arg$, value, args){
  var type, fun, key, shape, G, put, arr, I, In, ref$;
  type = arg$[0], fun = arg$[1];
  switch (type) {
  case 'string':
    key = fun[0], shape = fun[1], G = fun[2];
    put = exec_key(shape, G, value[key], args, key);
    if (put.error) {
      return put;
    }
    value[key] = put.value;
    return {
      'continue': true,
      error: false,
      value: value
    };
  case 'array':
    arr = fun[0], shape = fun[1], G = fun[2];
    I = 0;
    In = arr.length;
    while (I < In) {
      key = arr[I];
      put = exec_key(shape, G, value[key], args, key);
      if (put.error) {
        return put;
      }
      value[key] = put.value;
      I += 1;
    }
    return {
      'continue': true,
      error: false,
      value: value
    };
  case 'object':
    I = 0;
    In = fun.length;
    while (I < In) {
      ref$ = fun[I], key = ref$[0], shape = ref$[1], G = ref$[2];
      put = exec_key(shape, G, value[key], args, key);
      if (put.error) {
        return put;
      }
      value[key] = put.value;
      I += 1;
    }
    return {
      'continue': true,
      error: false,
      value: value
    };
  }
};
green = function(fun, cond, dtype, args){
  var type, F, value, ncond, vixod, put;
  type = fun[0], F = fun[1];
  value = cond.value;
  ncond = (function(){
    switch (type) {
    case 'd':
      return apply.normal.top(F, value, args);
    case 'i':
      return apply.auth.top(F, value, args);
    case 'f':
      vixod = apply.normal.top(F, value, args);
      return sanatize(value, vixod);
    case 'map':
      return map(dtype, F, value, args);
    case 'forEach':
      return forEach(dtype, F, value, args);
    case 'on':
      return upon(F, value, args);
    case 'cont':
      cond.value = (function(){
        switch (typeof F) {
        case 'function':
          return apply.normal.top(F, value, args);
        default:
          return F;
        }
      }());
      return cond;
    case 'tap':
      apply.normal.top(F, value, args);
      return cond;
    case 'jam':
      put = {
        'continue': false,
        error: true
      };
      put.message = (function(){
        switch (typeof F) {
        case 'function':
          return apply.normal.top(F, value, args);
        default:
          return F;
        }
      }());
      return put;
    default:
      return cond;
    }
  }());
  if (ncond.error) {
    ncond.value = value;
  }
  return ncond;
};
split_on_value_list = ['or', 'alt', 'try', 'or.multi', 'alt.multi'];
split_on = {};
for (i$ = 0, len$ = split_on_value_list.length; i$ < len$; ++i$) {
  I = split_on_value_list[i$];
  split_on[I] = true;
}
self_amorty = function(self){
  var flaty, current, I, fin, bucket, each, type, data, tbuck, item_inner, new_I, i$, to$, K, eachi, len$;
  flaty = new Array(self.index + 1);
  current = self.all;
  I = self.index;
  while (-1 < I) {
    flaty[I] = current.node;
    current = current.back;
    --I;
  }
  fin = [];
  bucket = {
    type: 'and',
    item: []
  };
  I = 0;
  oloop: while (I < flaty.length) {
    each = flaty[I];
    type = each[0], data = each[1];
    if (split_on[type]) {
      if (bucket.item.length) {
        fin.push(bucket);
        bucket = {
          type: 'and',
          item: []
        };
      }
      switch (type) {
      case 'try':
        tbuck = {
          type: 'try',
          end: false,
          item: []
        };
        item_inner = [];
        new_I = I + 1;
        for (i$ = new_I, to$ = flaty.length; i$ < to$; ++i$) {
          K = i$;
          eachi = flaty[K];
          switch (eachi[0]) {
          case 'try':
            tbuck.item.push(item_inner);
            item_inner = [];
            break;
          case 'end':
            new_I = K + 1;
            tbuck.item.push(item_inner);
            fin.push(tbuck);
            I = new_I;
            tbuck.end = true;
            continue oloop;
          default:
            item_inner.push(eachi);
          }
          new_I++;
        }
        I = new_I;
        tbuck.item.push(item_inner);
        fin.push(tbuck);
        break;
      case 'or':
      case 'alt':
      case 'or.multi':
      case 'alt.multi':
        fin.push({
          type: type,
          item: data
        });
      }
    } else {
      bucket.item.push(each);
    }
    I++;
  }
  if (bucket.item.length) {
    fin.push(bucket);
  }
  for (i$ = 0, len$ = fin.length; i$ < len$; ++i$) {
    I = fin[i$];
    if (I.type !== 'and') {
      continue;
    }
    if (I.item.length === 1) {
      I.item = I.item[0];
    } else {
      I.type = 'and.multi';
    }
  }
  fin.type = self.type;
  return fin;
};
tightloop = function(x){
  var self, von, data, dtype, I, olen, cond, cd, type, item, K, ilen, fun, ncond, J, end, start_cond, klen, el, eachTry, jlen;
  if (!this.data) {
    self = this.self;
    von = self_amorty(self);
    this.data = von;
  }
  data = this.data;
  dtype = data.type;
  I = 0;
  olen = data.length;
  cond = {
    'continue': true,
    error: false,
    value: x
  };
  oloop: do {
    cd = data[I];
    type = cd.type, item = cd.item;
    I += 1;
    switch (cd.type) {
    case 'and':
      if (cond.error) {
        cond = red(item, cond, arguments);
      } else {
        cond = green(item, cond, dtype, arguments);
      }
      break;
    case 'and.multi':
      K = 0;
      ilen = item.length;
      do {
        fun = item[K];
        if (cond.error) {
          cond = red(fun, cond, arguments);
        } else {
          cond = green(fun, cond, dtype, arguments);
        }
        K += 1;
      } while (K < ilen);
      break;
    case 'or':
    case 'alt':
      if (!cond.error) {
        continue oloop;
      }
      ncond = green(item, cond, dtype, arguments);
      if (ncond.error) {
        if (ncond.message !== void 8) {
          if (cond.message === void 8) {
            cond.message = ncond.message;
          } else {
            cond.message = [cond.message];
            cond.message.push(ncond.message);
          }
        }
      } else {
        cond = ncond;
        if (type === 'or') {
          break oloop;
        }
      }
      break;
    case 'or.multi':
    case 'alt.multi':
      if (!cond.error) {
        continue oloop;
      }
      J = 0;
      ilen = item.length;
      do {
        fun = item[J];
        ncond = green(fun, cond, dtype, arguments);
        if (ncond.error) {
          if (ncond.message !== void 8) {
            cond.message = [cond.message];
            cond.message.push(ncond.message);
          }
          J += 1;
        } else {
          cond = ncond;
          if (type === 'or') {
            break oloop;
          }
        }
      } while (J < ilen);
      break;
    case 'try':
      if (cond.error) {
        continue oloop;
      }
      end = cd.end;
      start_cond = cond;
      K = 0;
      klen = item.length;
      el = [];
      kloop: do {
        eachTry = item[K];
        K += 1;
        jlen = eachTry.length;
        J = 0;
        jloop: do {
          fun = eachTry[J];
          J += 1;
          if (cond.error) {
            cond = red(fun, cond, arguments);
          } else {
            cond = green(fun, cond, dtype, arguments);
          }
        } while (J < jlen);
        if (cond['continue']) {
          break kloop;
        }
        el.push(cond.message);
        if (K < klen) {
          cond = start_cond;
        }
      } while (K < klen);
      if (cond.error) {
        cond.message = el.reverse();
        cond.value = start_cond.value;
      }
    }
  } while (I < olen);
  return cond;
};
module.exports = tightloop;
function import$(obj, src){
  var own = {}.hasOwnProperty;
  for (var key in src) if (own.call(src, key)) obj[key] = src[key];
  return obj;
}