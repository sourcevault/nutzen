var pc, com, pkgname, sig, l, z, R, j, flat, pad, alpha_sort, esp, c, lit, create_stack, sanatize, x$, apply, y$, z$, blunder, execKey, execTop, map, forEach, upon, resolve, tightloop, slice$ = [].slice, arrayFrom$ = Array.from || function(x){return slice$.call(x);};
pc = require("./print.common");
com = pc.com, pkgname = pc.pkgname, sig = pc.sig;
l = com.l, z = com.z, R = com.R, j = com.j, flat = com.flat, pad = com.pad, alpha_sort = com.alpha_sort, esp = com.esp, c = com.c, lit = com.lit, create_stack = com.create_stack;
sanatize = function(x, UFO){
  var cont, unknown, path, npath;
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
        value: x,
        message: undefined
      };
    }
  case 'Array':
    cont = UFO[0], unknown = UFO[1], path = UFO[2];
    if (cont) {
      return {
        'continue': true,
        error: false,
        value: x
      };
    } else {
      switch (R.type(path)) {
      case 'Array':
        npath = path;
        break;
      case 'String':
      case 'Number':
        npath = [path];
        break;
      default:
        npath = [];
      }
      return {
        'continue': false,
        error: true,
        value: x,
        message: unknown,
        path: npath
      };
    }
  default:
    return {
      'continue': false,
      error: true,
      value: x,
      message: "[" + pkgname + "][typeError][user-supplied-validator] undefined return value."
    };
  }
};
x$ = apply = {};
y$ = x$.normal = {};
y$.key = null;
y$.top = null;
z$ = x$.auth = {};
z$.key = null;
z$.top = null;
blunder = function(fun, put, args){
  var patt, F, data;
  patt = fun[0], F = fun[1];
  switch (patt) {
  case 'err':
    data = (function(){
      switch (typeof F) {
      case 'function':
        return apply.normal.err(F, args, put);
      default:
        return F;
      }
    }());
    switch (R.type(data)) {
    case 'Array':
    case 'String':
    case 'Number':
      put.message = data;
      break;
    case 'Object':
      if (data.hasOwnProperty('message')) {
        put.message = data.message;
      }
      if (data.hasOwnProperty('path')) {
        switch (R.type(data.path)) {
        case 'Number':
        case 'String':
          put.path = [data.path];
          break;
        case 'Array':
          put.path = data.path;
        }
      }
      break;
    case 'Null':
      put.message = void 8;
    }
    break;
  case 'fix':
    put.value = (function(){
      switch (typeof F) {
      case 'function':
        return apply.normal.key(F, put.value, args, put.path);
      default:
        return F;
      }
    }());
    put['continue'] = true;
    put.error = false;
    put.message = undefined;
    break;
  default:

  }
  return put;
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
execKey = function(type, F, val, args, key){
  switch (type) {
  case 'd':
    return apply.normal.key(F, val, args, key);
  case 'i':
    return apply.auth.key(F, val, args, key);
  case 'f':
    return sanatize(val, apply.normal.key(F, val, args, key));
  }
};
execTop = function(type, F, val, args){
  switch (type) {
  case 'd':
    return apply.normal.top(F, val, args);
  case 'i':
    return apply.auth.top(F, val, args);
  case 'f':
    return sanatize(val, apply.normal.top(F, val, args));
  }
};
map = function(dtype, fun, value, args){
  var type, F, I, In, put, arr, path, ob, key, val;
  type = fun[0], F = fun[1];
  switch (dtype) {
  case 'arr':
    I = 0;
    In = value.length;
    put = null;
    arr = [];
    while (I < In) {
      put = execKey(type, F, value[I], args, I);
      if (put.error) {
        if (put.path) {
          path = put.path;
        } else {
          path = [];
        }
        return {
          'continue': false,
          error: true,
          value: value,
          message: put.message,
          path: [I].concat(arrayFrom$(path))
        };
      }
      arr.push(put.value);
      I += 1;
    }
    return {
      'continue': true,
      error: false,
      value: arr
    };
  case 'obj':
    ob = {};
    put = null;
    for (key in value) {
      val = value[key];
      put = execKey(type, F, val, args, key);
      if (put.error) {
        if (put.path) {
          path = put.path;
        } else {
          path = [];
        }
        return {
          'continue': false,
          error: true,
          value: value,
          message: put.message,
          path: [key].concat(arrayFrom$(path))
        };
      }
      ob[key] = put.value;
    }
    return {
      'continue': true,
      error: false,
      value: ob
    };
  }
};
forEach = function(dtype, fun, value, args){
  var type, F, I, In, key, val;
  type = fun[0], F = fun[1];
  switch (dtype) {
  case 'arr':
    I = 0;
    In = value.length;
    while (I < In) {
      execKey(type, F, value[I], args, I);
      I += 1;
    }
    return {
      'continue': true,
      error: false,
      value: value
    };
  case 'obj':
    for (key in value) {
      val = value[key];
      execKey(type, F, val, args, key);
    }
    return {
      'continue': true,
      error: false,
      value: value
    };
  }
};
upon = function(arg$, value, args){
  var type, fun, key, shape, G, put, path, arr, I, In, ref$;
  type = arg$[0], fun = arg$[1];
  switch (type) {
  case 'string':
    key = fun[0], shape = fun[1], G = fun[2];
    put = execKey(shape, G, value[key], args, key);
    if (put.path) {
      path = put.path;
    } else {
      path = [];
    }
    if (put.error) {
      return {
        'continue': false,
        error: true,
        value: value,
        message: put.message,
        path: [key].concat(arrayFrom$(path))
      };
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
      put = execKey(shape, G, value[key], args, key);
      if (put.path) {
        path = put.path;
      } else {
        path = [];
      }
      if (put.error) {
        return {
          'continue': false,
          error: true,
          value: value,
          message: put.message,
          path: [key].concat(arrayFrom$(path))
        };
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
      execKey(shape, G, value[key], args, key);
      if (put.path) {
        path = put.path;
      } else {
        path = [];
      }
      if (put.error) {
        return {
          'continue': false,
          error: true,
          value: value,
          message: put.message,
          path: [key].concat(arrayFrom$(path))
        };
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
resolve = function(fun, put, dtype, args){
  var type, F, value, I, nI, ref$, G;
  type = fun[0], F = fun[1];
  value = put.value;
  switch (type) {
  case 'd':
    return apply.normal.top(F, value, args);
  case 'i':
    return apply.auth.top(F, value, args);
  case 'f':
    return sanatize(value, apply.normal.top(F, value, args));
  case 'map':
    return map(dtype, F, value, args);
  case 'forEach':
    return forEach(dtype, F, value, args);
  case 'on':
    return upon(F, value, args);
  case 'cont':
  case 'edit':
    put.value = (function(){
      switch (typeof F) {
      case 'function':
        return apply.normal.top(F, value, args);
      default:
        return F;
      }
    }());
    return put;
  case 'tap':
    apply.normal.top(F, value, args);
    return put;
  case 'jam':
    put.message = (function(){
      switch (typeof F) {
      case 'function':
        return apply.normal.top(F, value, args);
      default:
        return F;
      }
    }());
    put['continue'] = false;
    put.error = true;
    return put;
  case 'alt':
    I = 0;
    nI = F.length;
    do {
      ref$ = F[I], type = ref$[0], G = ref$[1];
      put = execTop(type, G, value, args);
      if (put['continue']) {
        return put;
      }
      I += 1;
    } while (I < nI);
    return put;
  default:
    return put;
  }
};
tightloop = function(x){
  var state, all, type, I, put, nI, each, J, nJ, fun, patt, nput;
  state = this[sig];
  all = state.all, type = state.type;
  I = 0;
  put = {
    'continue': true,
    error: false,
    value: x
  };
  nI = all.length;
  while (I < nI) {
    each = all[I];
    switch (I % 2) {
    case 0:
      J = 0;
      nJ = each.length;
      do {
        fun = each[J];
        if (put.error) {
          put = blunder(fun, put, arguments);
        } else {
          put = resolve(fun, put, type, arguments);
        }
        J += 1;
      } while (J < nJ);
      if (put.error) {
        I += 1;
      } else {
        I += 2;
      }
      break;
    case 1:
      J = 0;
      nJ = each.length;
      put.message = [put.message];
      do {
        fun = each[J];
        patt = fun[0];
        nput = resolve(fun, put, type, arguments);
        if (nput['continue'] && patt === 'alt') {
          put = nput;
          J = nJ;
        } else if (nput['continue']) {
          put = nput;
          I = nI;
          J = nJ;
        } else {
          if (!(nput.message === undefined)) {
            put.message.push(nput.message);
          }
          J += 1;
        }
      } while (J < nJ);
      I += 1;
    }
  }
  return put;
};
module.exports = tightloop;