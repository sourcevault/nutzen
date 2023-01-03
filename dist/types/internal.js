var ref$, com, print, sig, tightloop, z, l, R, j, uic, deep_freeze, loopError, tupnest, noop, xop, x$, cache, assort, cato, assign_try, assign_self, y$, wrap, z$, guard, z1$, define, z2$, validate, z3$, proto, z4$, props, i$, len$, val, F, N, handleError, custom, slice$ = [].slice, arrayFrom$ = Array.from || function(x){return slice$.call(x);};
ref$ = require('./print.common'), com = ref$.com, print = ref$.print, sig = ref$.sig;
tightloop = require('./tightloop');
z = com.z, l = com.l, R = com.R, j = com.j, uic = com.uic, deep_freeze = com.deep_freeze, loopError = com.loopError, tupnest = com.tupnest, noop = com.noop;
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
  } else if (F instanceof normal) {
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
assign_try = function(){
  return function(data){
    this['try'] = new proto['try'].normal(data);
    return this;
  };
};
assign_self = function(){
  return function(data){
    this['try'] = data;
    return this;
  };
};
y$ = wrap = {};
y$.on = null;
y$.rest = null;
y$['catch'] = null;
z$ = guard = {};
z$.on = null;
z$.rest = null;
z$['catch'] = null;
z1$ = define = {};
z1$.and = null;
z1$.or = null;
z1$.proto = null;
z1$.on = null;
z1$.basis = null;
z1$.block = null;
z2$ = validate = {};
z2$.on = null;
z2$.rest = null;
z3$ = proto = {};
z3$.normal = function(data){
  this['try'] = new proto['try'].normal(data);
  return this;
};
z4$ = z3$['try'] = {};
z4$.normal = function(data){
  this['try'] = data;
  return this;
};
props = ['and', 'or', 'alt', 'cont', 'tap', 'edit', 'err', 'jam', 'fix'];
wrap.rest = function(type){
  return function(){
    z(this instanceof normal);
    z(this instanceof functor);
    return z(this instanceof proto['try'].normal);
  };
};
wrap['catch'] = function(){
  return guard['catch'](arguments, this[sig]);
};
wrap.on = function(){
  return guard.on(arguments, this[sig]);
};
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
  proto.normal.prototype[val] = F;
}
proto.normal.prototype.auth = tightloop;
proto.normal.prototype['catch'] = wrap['catch'];
proto['try'].normal.prototype = Object.create(proto.normal.prototype);
N = new proto.normal('h');
z(N['try'].and);
handleError = function(info){
  print.route(info);
  return loopError();
};
custom = xop.arn(1, function(){
  return handleError(tupnest(new Error(), 'input.fault', 'custom', 'arg_count'));
}).whn(function(f){
  return R.type(f) === 'Function' || f instanceof normal;
}, function(){
  return handleError(tupnest(new Error(), 'input.fault', 'custom', 'not_function'));
}).def(function(F){
  var G, data;
  G = cato(F);
  data = {
    type: 'custom',
    all: ['and', G],
    index: 0,
    str: ["{..}"]
  };
  return define.proto(data);
});
define.on = function(type, args, state){
  var props, F, put, key, ob, fun, res$, val, array, block, data;
  switch (type[0]) {
  case 'array':
    props = args[0], F = args[1];
    put = ['array', [R.uniq(props)].concat(arrayFrom$(cato(F)))];
    break;
  case 'string':
    key = args[0], F = args[1];
    put = ['string', [key].concat(arrayFrom$(cato(F)))];
    break;
  case 'object':
    ob = args[0];
    res$ = [];
    for (key in ob) {
      val = ob[key];
      res$.push([key].concat(arrayFrom$(cato(val))));
    }
    fun = res$;
    put = ['object', fun];
    break;
  case 'single_array':
    array = type[1];
    put = ['single_array', array];
  }
  block = define.block(state, 'on', [put]);
  data = {
    type: state.type,
    all: block,
    str: state.str.concat('on')
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
}, function(data){
  if (data[1] === 'input.fault') {
    return handleError(data);
  }
  return loopError();
}, define.on).arma(2, function(arg$, state){
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
      print.route(tupnest([new Error(), 'input.fault'], type, 'arg_count', [state.str, type]));
      return false;
    }
    for (i$ = 0, len$ = funs.length; i$ < len$; ++i$) {
      F = funs[i$];
      if (!(R.type(F) === 'Function' || cache.ins.has(F))) {
        print.route(tupnest([new Error(), 'input.fault'], type, 'not_function', [state.str, type]));
        return false;
      }
    }
    return true;
  case 'map':
  case 'tap':
  case 'forEach':
    if (!(funs.length === 1)) {
      print.route(tupnest([new Error(), 'input.fault'], type, 'arg_count', [state.str, type]));
      return false;
    }
    return true;
    f = funs[0];
    if (!(R.type(f) === 'Function' || cache.ins.has(F))) {
      print.route(tupnest([new Error(), 'input.fault'], type, 'not_function', [state.str, type]));
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
guard['catch'] = xop.unary.arpar(1, function(arg$){
  var F;
  F = arg$[0];
  return [R.type(F) === 'Function'];
}, function(){
  var state, E;
  state = arguments[arguments.length - 1];
  E = tupnest([new Error(), 'input.fault'], 'catch', 'not_function', [state.str, 'catch']);
  print.route(E);
  return loopError();
}, function(arg$, state){
  var F, neo_all, neo_state;
  F = arg$[0];
  neo_all = state.all.concat(['catch']);
  neo_state = {
    type: state.type,
    all: neo_state,
    str: state.str.concat('catch')
  };
  return define.proto(neo_state);
}).def(loopError);
guard.rest = xop.wh(validate.rest, function(args, state, type){}).def(loopError);
define.copy = function(F, data, type){
  type == null && (type = data.type);
  switch (type) {
  case 'obj':
  case 'arr':
  case 'arg':
    Object.setPrototypeOf(F, proto.functor);
    break;
  default:
    Object.setPrototypeOf(F, proto.normal);
  }
  F[sig] = data;
  return cache.ins.add(F);
};
define.proto = function(data, type){
  var put;
  type == null && (type = data.type);
  put = (function(){
    switch (data.type) {
    case 'obj':
    case 'arr':
    case 'arg':
      return new functor(data);
    default:
      return new normal(data);
    }
  }());
  return put;
};
define.basis = function(name, F){
  var data;
  data = {
    type: name,
    str: [name],
    all: [{
      0: 'and',
      1: ['d', F]
    }]
  };
  switch (name) {
  case 'obj':
  case 'arr':
  case 'arg':
    Object.setPrototypeOf(F, proto.functor);
    break;
  default:
    Object.setPrototypeOf(F, proto.normal);
  }
  F[sig] = data;
  cache.ins.add(F);
  cache.def.add(F);
};
define.basis.empty = function(name){
  var data, inherited;
  data = {
    type: name,
    str: [name],
    all: []
  };
  inherited = (function(){
    switch (name) {
    case 'obj':
    case 'arr':
    case 'arg':
      return Object.create(proto.functor);
    default:
      return Object.create(proto.normal);
    }
  }());
  return inherited;
};
define.block = function(state, type, args){
  var all, neo_all, F, inn, funs, I;
  all = state.all;
  neo_all = (function(){
    var i$, ref$, len$;
    switch (type) {
    case 'map':
    case 'forEach':
      F = cato(args[0]);
      return all.concat([type, F]);
    case 'err':
    case 'fix':
    case 'cont':
    case 'jam':
    case 'edit':
    case 'tap':
      return all.concat([type, args[0]]);
    case 'and':
    case 'alt':
    case 'or':
      inn = all.concat();
      funs = cato(args);
      for (i$ = 0, len$ = (ref$ = funs).length; i$ < len$; ++i$) {
        I = ref$[i$];
        inn.push(type, I);
      }
      return inn;
    case 'on':
      return all.concat('on', args);
    case 'on_or':
      return all.concat('on_or', args);
    }
  }());
  return neo_all;
};
module.exports = {
  custom: custom,
  define: define,
  cache: cache
};