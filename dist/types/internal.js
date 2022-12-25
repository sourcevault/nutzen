var ref$, com, print, sig, tightloop, z, l, R, j, uic, deep_freeze, loopError, xop, x$, cache, assort, cato, y$, wrap, z$, guard, z1$, define, z2$, validate, props, init_state, z3$, proto, i$, len$, val, F, handleError, custom, slice$ = [].slice, arrayFrom$ = Array.from || function(x){return slice$.call(x);};
ref$ = require('./print.common'), com = ref$.com, print = ref$.print, sig = ref$.sig;
tightloop = require('./tightloop');
z = com.z, l = com.l, R = com.R, j = com.j, uic = com.uic, deep_freeze = com.deep_freeze, loopError = com.loopError;
xop = require('../guard/main');
x$ = cache = {};
x$.def = new Set();
x$.ins = new Set();
'd';
'i';
'f';
assort = function(F){
  if (cache.def.has(F)) {
    return ['d', F];
  } else if (cache.ins.has(F)) {
    return ['i', F];
  } else {
    return ['f', F];
  }
};
cato = function(arg){
  var fun, i$, to$, I, F, block;
  switch (R.type(arg)) {
  case 'Function':
  case 'Object':
    return assort(arg);
  case 'Arguments':
    fun = [];
    for (i$ = 0, to$ = arg.length; i$ < to$; ++i$) {
      I = i$;
      F = arg[I];
      block = assort(F);
      fun.push(block);
    }
    return fun;
  }
};
y$ = wrap = {};
y$.on = null;
y$.rest = null;
y$.bt = null;
z$ = guard = {};
z$.on = null;
z$.rest = null;
z$.bt = null;
z1$ = define = {};
z1$.and = null;
z1$.or = null;
z1$.proto = null;
z1$.on = null;
z1$.basis = null;
z2$ = validate = {};
z2$.on = null;
z2$.rest = null;
props = ['and', 'or', 'alt', 'cont', 'tap', 'edit', 'err', 'jam', 'fix'];
init_state = {
  all: [],
  type: null,
  str: [],
  and_size: 0,
  and_view: []
};
wrap.bt = function(){
  return guard.bt(arguments, this[sig], 'bt');
};
wrap.rest = function(type){
  return function(){
    return guard.rest(arguments, this[sig], type);
  };
};
wrap.on = function(){
  return guard.on(arguments, this[sig]);
};
z3$ = proto = {};
z3$.normal = {};
z3$.functor = null;
proto.normal.wrap = function(){
  var F;
  F = this;
  return function(){
    return F.auth.apply(F, arguments).value;
  };
};
for (i$ = 0, len$ = props.length; i$ < len$; ++i$) {
  val = props[i$];
  F = wrap.rest(val);
  proto.normal[val] = F;
}
proto.normal.auth = tightloop;
proto.normal[uic] = print.log;
proto.normal.bt = wrap.bt;
proto.functor = (import$({}, proto.normal));
proto.functor.map = wrap.rest('map');
proto.functor.forEach = wrap.rest('forEach');
proto.functor.on = wrap.on;
proto.functor[uic] = print.log;
handleError = function(info){
  print.route(info);
  return loopError();
};
custom = xop.arn(1, function(){
  return handleError([new Error(), 'input.fault', ['custom', ['arg_count']]]);
}).whn(function(f){
  return R.type(f) === 'Function' || f[sig];
}, function(){
  return handleError([new Error(), 'input.fault', ['custom', ['not_function']]]);
}).def(function(F){
  var G, data;
  G = cato(F);
  data = {
    type: 'custom',
    all: [[G]],
    str: ["{..}"],
    and_size: 1,
    and_view: [1]
  };
  return define.proto(data);
});
custom[uic] = print.inner;
define.on = function(type, args, state){
  var props, F, put, key, ob, fun, res$, val, array, ref$, block, av, data;
  switch (type[0]) {
  case 'array':
    props = args[0], F = args[1];
    put = ['on', ['array', [R.uniq(props)].concat(arrayFrom$(cato(F)))]];
    break;
  case 'string':
    key = args[0], F = args[1];
    put = ['on', ['string', [key].concat(arrayFrom$(cato(F)))]];
    put;
    break;
  case 'object':
    ob = args[0];
    res$ = [];
    for (key in ob) {
      val = ob[key];
      res$.push([key].concat(arrayFrom$(cato(val))));
    }
    fun = res$;
    put = ['on', ['object', fun]];
    break;
  case 'single_array':
    array = type[1];
    put = ['on', ['single_array', array]];
  }
  ref$ = define.and(state, [put]), block = ref$[0], av = ref$[1];
  av[av.length - 1] = R.last(av) + 1;
  data = {
    type: state.type,
    all: block,
    str: state.str.concat('on'),
    and_size: state.and_size + 1,
    and_view: av
  };
  return define.proto(data);
};
guard.on = xop.unary.arn([1, 2], function(args, state){
  return handleError([new Error(), 'input.fault', ['on', ['arg_count', [state.str, 'on']]]]);
}).arpar(1, function(args, state){
  var maybe_object, type, I, val, ok, clean, error_msg, i$, len$, each, fields, F, field_type, j$, len1$, ref$, wF, inner_error;
  maybe_object = args[0];
  type = R.type(maybe_object);
  if (type === 'Object') {
    for (I in maybe_object) {
      val = maybe_object[I];
      if (!(R.type(val) === 'Function' || cache.ins.has(val))) {
        return [false, [new Error(), 'input.fault', ['on', ['object', [state.str, 'on']]]]];
      }
    }
    return [true, ['object']];
  } else if (type === 'Array') {
    ok = true;
    clean = [];
    error_msg = null;
    for (i$ = 0, len$ = maybe_object.length; i$ < len$; ++i$) {
      each = maybe_object[i$];
      if (!(each.length === 3)) {
        ok = false;
        error_msg = 'length_less_then_3';
        break;
      }
      type = each[0], fields = each[1], F = each[2];
      field_type = R.type(fields);
      if (type === 'and') {
        if (field_type === 'String') {
          field_type = 'S';
        } else if (field_type === 'Array') {
          field_type = 'A';
        } else {
          error_msg = 'alt_wrong_field_type';
          ok = false;
          break;
        }
      } else if (type === 'alt') {
        if (field_type === 'Array') {
          for (j$ = 0, len1$ = fields.length; j$ < len1$; ++j$) {
            I = fields[j$];
            if (!((ref$ = R.type(I)) === 'String' || ref$ === 'Number')) {
              ok = false;
              break;
            }
          }
          if (!ok) {
            error_msg = 'alt_wrong_field_type';
            break;
          }
          field_type = 'A';
        } else if (field_type === 'String') {
          field_type = 'S';
        } else {
          ok = false;
          break;
        }
      } else {
        ok = false;
        error_msg = 'not_and_alt';
        break;
      }
      wF = assort(F);
      if (wF[0] === 'f') {
        ok = false;
        break;
      }
      clean.push([type, [field_type, fields], wF[0], wF[1]]);
    }
    if (ok) {
      return [true, ['single_array', clean]];
    } else {
      inner_error = ['on', ['single_array', [state.str, 'on'], error_msg]];
      return [false, [new Error(), 'input.fault', inner_error]];
    }
  } else {
    return [false];
  }
}, define.on, function(data){
  if (data[1] === 'input.fault') {
    return handleError(data);
  }
  return null;
}).arma(2, function(arg$, state){
  var first, second, i$, len$, I;
  first = arg$[0], second = arg$[1];
  switch (R.type(first)) {
  case 'Array':
    for (i$ = 0, len$ = first.length; i$ < len$; ++i$) {
      I = first[i$];
      if (!(R.type(I) === 'String')) {
        return [new Error(), 'input.fault', ['on', ['array', [state.str, 'on']]]];
      }
    }
    if (!(R.type(second) === 'Function' || cache.ins.has(second))) {
      return [new Error(), 'input.fault', ['on', ['array', [state.str, 'on']]]];
    }
    return ['array'];
  case 'String':
  case 'Number':
    if (!(R.type(second) === 'Function' || cache.ins.has(second))) {
      return [new Error(), 'input.fault', ['on', ['string', [state.str, 'on']]]];
    }
    return ['string'];
  default:
    return false;
  }
}, define.on).def(function(args, state){
  return handleError([new Error(), 'input.fault', ['on', ['typeError', [state.str, 'on']]]]);
});
validate.rest = function(funs, state, type){
  var i$, len$, F, f;
  switch (type) {
  case 'and':
  case 'or':
  case 'alt':
    if (funs.length === 0) {
      print.route([new Error(), 'input.fault', [type, ['arg_count', [state.str, type]]]]);
      return false;
    }
    for (i$ = 0, len$ = funs.length; i$ < len$; ++i$) {
      F = funs[i$];
      if (!(R.type(F) === 'Function' || cache.ins.has(F))) {
        print.route([new Error(), 'input.fault', [type, ['not_function', [state.str, type]]]]);
        return false;
      }
    }
    return true;
  case 'map':
  case 'tap':
  case 'forEach':
    if (!(funs.length === 1)) {
      print.route([new Error(), 'input.fault', [type, ['arg_count', [state.str, type]]]]);
      return false;
    }
    return true;
    f = funs[0];
    if (!(R.type(f) === 'Function' || cache.ins.has(F))) {
      print.route([new Error(), 'input.fault', [type, ['not_function', [state.str, type]]]]);
      return false;
    }
    return true;
  case 'err':
  case 'fix':
  case 'cont':
  case 'jam':
  case 'edit':
    return true;
  default:
    return false;
  }
};
guard.bt = xop.ma(function(args, state, type){
  var first, A;
  first = args[0];
  switch (R.type(first)) {
  case 'Undefined':
    return 0;
  case 'Number':
    switch (first) {
    case Infinity:
      return state.and_size;
    case -Infinity:
      return 0;
    default:
      if (first < 0) {
        return state.and_size + first;
      } else {
        return first;
      }
    }
  default:
    A = [new Error(), 'input.fault', [type, ['not_function', [state.str, type]]]];
    print.route(A);
    return false;
  }
}, function(raw_pos, o_arg, state){
  var current, i$, ref$, len$, K, item, short_y_index, short_x_index, y_index, all, line, x_index, I, type, init, res$, final, to$, fini, out, neo_all;
  current = raw_pos;
  for (i$ = 0, len$ = (ref$ = state.and_view).length; i$ < len$; ++i$) {
    K = i$;
    item = ref$[i$];
    current = current - item;
    if (current < 0) {
      short_y_index = K;
      short_x_index = item + current;
      break;
    }
  }
  y_index = short_y_index * 2;
  all = state.all;
  line = all[y_index];
  current = short_x_index;
  x_index = 0;
  I = 0;
  while (current) {
    type = line[I][0];
    switch (type) {
    case 'i':
    case 'd':
    case 'f':
    case 'on':
    case 'map':
    case 'and':
      --current;
    }
    ++x_index;
    ++I;
  }
  res$ = [];
  for (i$ = 0; i$ < y_index; ++i$) {
    I = i$;
    res$.push(all[I]);
  }
  init = res$;
  res$ = [];
  for (i$ = y_index + 1, to$ = all.length; i$ < to$; ++i$) {
    K = i$;
    res$.push(all[K]);
  }
  final = res$;
  fini = all.length - 1;
  out = R.insert(x_index, ['bt', [fini, all[fini].length - 1]], line);
  neo_all = arrayFrom$(init).concat([out], arrayFrom$(final));
  return z.j(neo_all);
}).def(loopError);
guard.rest = xop.wh(validate.rest, function(args, state, type){
  var funs, ref$, block, av, as, data;
  funs = cato(args);
  ref$ = (function(){
    switch (type) {
    case 'and':
      return define.and(state, funs);
    case 'or':
      return define.or(state, funs);
    case 'alt':
      return define.or(state, [['alt', funs]]);
    case 'map':
    case 'forEach':
      return define.and(state, [[type, funs[0]]]);
    case 'err':
    case 'fix':
    case 'cont':
    case 'jam':
    case 'edit':
    case 'tap':
      return define.and(state, [[type, args[0]]]);
    }
  }()), block = ref$[0], av = ref$[1];
  switch (type) {
  case 'and':
  case 'map':
    av[av.length - 1] = R.last(av) + 1;
    as = state.and_size + 1;
    break;
  default:
    as = state.and_size;
  }
  data = {
    type: state.type,
    all: block,
    str: state.str.concat(type),
    and_size: as,
    and_view: av
  };
  return define.proto(data);
}).def(loopError);
define.copy = function(F, data, type){
  type == null && (type = data.type);
  switch (type) {
  case 'obj':
  case 'arr':
  case 'arg':
    Object.assign(F, proto.functor);
    break;
  default:
    Object.assign(F, proto.normal);
  }
  F[sig] = data;
  return cache.ins.add(F);
};
define.proto = function(data, type){
  var put;
  type == null && (type = data.type);
  switch (type) {
  case 'obj':
  case 'arr':
  case 'arg':
    put = Object.create(proto.functor);
    break;
  default:
    put = Object.create(proto.normal);
  }
  put[sig] = data;
  cache.ins.add(put);
  return put;
};
define.basis = function(name, F){
  var inner, data;
  if (typeof F === 'object') {
    inner = [];
  } else {
    inner = [[['d', F]]];
  }
  cache.def.add(F);
  data = {
    type: name,
    str: [name],
    all: inner,
    and_size: 1,
    and_view: [1]
  };
  define.copy(F, data);
};
define.and = function(state, funs){
  var all, init, last, nlast, block;
  all = state.all;
  switch (all.length % 2) {
  case 0:
    return [all.concat([funs]), state.and_view.concat(0)];
  case 1:
    init = R.init(all);
    last = R.last(all);
    nlast = arrayFrom$(last).concat(arrayFrom$(funs));
    block = arrayFrom$(init).concat([nlast]);
    return [block, state.and_view];
  }
};
define.or = function(state, funs){
  var all, init, last, nlast, block;
  all = state.all;
  switch (all.length % 2) {
  case 0:
    init = R.init(all);
    last = R.last(all);
    nlast = arrayFrom$(last).concat(arrayFrom$(funs));
    block = arrayFrom$(init).concat([nlast]);
    return [block, state.and_view];
  case 1:
    return [all.concat([funs]), state.and_view];
  }
};
module.exports = {
  custom: custom,
  define: define,
  cache: cache
};
function import$(obj, src){
  var own = {}.hasOwnProperty;
  for (var key in src) if (own.call(src, key)) obj[key] = src[key];
  return obj;
}