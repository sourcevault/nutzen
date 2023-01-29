var ref$, com, symbols, print, tightloop, z, l, R, j, uic, deep_freeze, loopError, tupnest, noop, xop, defset, def_or_normal, assort, cato, proto_link, assign_self, x$, wrap, y$, guard, z$, define, z1$, validate, z2$, proto, z3$, props, i$, len$, val, F, p, handleError, custom, slice$ = [].slice, arrayFrom$ = Array.from || function(x){return slice$.call(x);};
ref$ = require('./print.common'), com = ref$.com, symbols = ref$.symbols, print = ref$.print;
tightloop = require('./tightloop');
z = com.z, l = com.l, R = com.R, j = com.j, uic = com.uic, deep_freeze = com.deep_freeze, loopError = com.loopError, tupnest = com.tupnest, noop = com.noop;
xop = require('../guard/main');
defset = new Set();
def_or_normal = function(F){
  return F[com.id_htypes];
};
'd';
'i';
'f';
assort = function(F){
  if (defset.has(F)) {
    return ['d', F];
  } else if (F[com.id_htypes]) {
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
proto_link = function(origin, target){
  return target.prototype = Object.create(origin.prototype);
};
assign_self = function(){
  return function(self){
    this.self = self;
    return this;
  };
};
x$ = wrap = {};
x$.on = null;
x$.rest = null;
x$['catch'] = null;
y$ = guard = {};
y$.on = null;
y$.rest = null;
y$['catch'] = null;
z$ = define = {};
z$.and = null;
z$.or = null;
z$.proto = null;
z$.on = null;
z$.basis = null;
z$.block = null;
z$['catch'] = null;
z1$ = validate = {};
z1$.on = null;
z1$.rest = null;
z2$ = proto = {};
z2$.normal = assign_self();
z2$.functor = assign_self();
z3$ = z2$.core = {};
z3$.normal = assign_self();
z3$.functor = assign_self();
props = ['and', 'cont', 'tap', 'edit', 'err', 'jam', 'fix'];
proto_link(proto.core.normal, proto.core.functor);
proto_link(proto.core.normal, proto.normal);
proto_link(proto.core.functor, proto.functor);
proto.core.normal.prototype.wrap = function(){
  var F;
  F = this;
  return function(){
    return F.auth.apply(F, arguments).value;
  };
};
wrap.rest = function(type){
  return function(){
    return guard.rest(arguments, this.self, type);
  };
};
for (i$ = 0, len$ = props.length; i$ < len$; ++i$) {
  val = props[i$];
  F = wrap.rest(val);
  proto.core.normal.prototype[val] = F;
}
proto.core.normal.prototype.auth = tightloop;
proto.core.normal.prototype[uic] = print.log('core.normal');
proto.core.normal.prototype['catch'] = function(){
  return guard['catch'](arguments, this.self);
};
wrap.on = function(type){
  return function(){
    return guard.on(arguments, this.self, type);
  };
};
p = proto.core.functor.prototype;
p.map = wrap.rest('map');
p.forEach = wrap.rest('forEach');
p.on = wrap.on('on');
p.onor = wrap.on('onor');
p[uic] = print.log('core.functor');
p = proto.normal.prototype;
p.or = wrap.rest('or');
p.alt = wrap.rest('alt');
p[uic] = print.log('normal');
p = proto.functor.prototype;
p.or = wrap.rest('or');
p.alt = wrap.rest('alt');
p[uic] = print.log('functor');
handleError = function(info){
  print.route(info);
  return loopError();
};
custom = xop.arn(1, function(){
  return handleError(tupnest(new Error(), 'input.fault', 'custom', 'arg_count'));
}).whn(function(f){
  return R.type(f) === 'Function' || def_or_normal(f);
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
  return new proto.normal(data);
});
custom.is_instance = def_or_normal;
define.on = function(cat, args, state, ftype){
  var put, props, F, key, ob, fun, val, data;
  put = (function(){
    var res$, ref$;
    switch (cat) {
    case 'array':
      props = args[0], F = args[1];
      return ['array', [R.uniq(props)].concat(arrayFrom$(cato(F)))];
    case 'string':
      key = args[0], F = args[1];
      return ['string', [key].concat(arrayFrom$(cato(F)))];
    case 'object':
      ob = args[0];
      res$ = [];
      for (key in ref$ = ob) {
        val = ref$[key];
        res$.push([key].concat(arrayFrom$(cato(val))));
      }
      fun = res$;
      return ['object', fun];
    }
  }());
  data = {
    type: state.type,
    all: {
      node: [ftype, put],
      back: state.all
    },
    index: state.index + 1,
    str: [ftype, state.str]
  };
  return new proto.functor(data);
};
guard.on = xop.unary.arn([1, 2], function(args, state, type){
  return handleError(tupnest([new Error(), 'input.fault'], 'on', 'arg_count', [state.str, type]));
}).arcap(1, function(args, state, which_on){
  var maybe_object, type, I, val;
  maybe_object = args[0];
  type = R.type(maybe_object);
  if (type === 'Object') {
    for (I in maybe_object) {
      val = maybe_object[I];
      if (!(R.type(val) === 'Function' || def_or_normal(val))) {
        return tupnest(false, [new Error(), 'input.fault'], 'on', 'object', [state.str, which_on]);
      }
    }
    return [true, 'object'];
  } else {
    return tupnest(false, [new Error(), 'input.fault'], 'on', 'typeError', [state.str, which_on]);
  }
}, function(data){
  if (data[1] === 'input.fault') {
    return handleError(data);
  }
  return loopError();
}, define.on).arcap(2, function(arg$, state, type){
  var first, second, i$, len$, I, ref$;
  first = arg$[0], second = arg$[1];
  switch (R.type(first)) {
  case 'Array':
    for (i$ = 0, len$ = first.length; i$ < len$; ++i$) {
      I = first[i$];
      if (!((ref$ = R.type(I)) === 'String' || ref$ === 'Number')) {
        return tupnest(false, [new Error(), 'input.fault'], 'on', 'array', [state.str, type]);
      }
    }
    if (!(R.type(second) === 'Function' || def_or_normal(second))) {
      return tupnest(false, [new Error(), 'input.fault'], 'on', 'array', [state.str, type]);
    }
    return [true, 'array'];
  case 'String':
  case 'Number':
    if (!(R.type(second) === 'Function' || def_or_normal(second))) {
      return tupnest(false, [new Error(), 'input.fault'], 'on', 'string', [state.str, type]);
    }
    return [true, 'string'];
  default:
    return false;
  }
}, function(E_info){
  return handleError(E_info);
}, define.on).def(function(args, state, type){
  var error_obj;
  error_obj = tupnest([new Error(), 'input.fault'], 'on', 'typeError', [state.str, type]);
  return handleError(error_obj);
});
validate.rest = function(funs, state, type){
  var i$, len$, F;
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
      if (!(R.type(F) === 'Function' || def_or_normal(F))) {
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
    F = funs[0];
    if (!(R.type(f) === 'Function' || def_or_normal(F))) {
      print.route(tupnest([new Error(), 'input.fault'], type, 'not_function', [state.str, type]));
      return false;
    }
    return true;
  case 'err':
  case 'fix':
  case 'cont':
  case 'jam':
  case 'edit':
  case 'try':
    return true;
  default:
    return false;
  }
};
define['catch'] = function(arg$, state){
  var F, type, data, put;
  F = arg$[0];
  type = state.type;
  data = {
    type: type,
    all: {
      node: ['catch', F],
      back: state.all
    },
    index: state.index + 1,
    str: ['catch', state.str]
  };
  put = (function(){
    switch (type) {
    case 'obj':
    case 'arr':
    case 'arg':
      return new proto.functor(data);
    default:
      return new proto.normal(data);
    }
  }());
  return put;
};
guard['catch'] = xop.unary.arcap(1, function(arg$, state){
  var F;
  F = arg$[0];
  return R.type(F) === 'Function';
}, function(){
  var state, E;
  state = arguments[arguments.length - 1];
  E = tupnest([new Error(), 'input.fault'], 'catch', 'not_function', [state.str, 'catch']);
  print.route(E);
  return loopError();
}, function(arg$, skate){
  var F;
  F = arg$[0];
  return define['catch'](['f', F], state);
}).ar(0, function(){
  var state;
  state = arguments[arguments.length - 1];
  return define['catch'](['empty'], state);
}).arn([1, 0], function(__, state){
  return handleError(tupnest([new Error(), 'input.fault'], 'catch', 'arg_count', [state.str, 'catch']));
}).def(loopError);
guard.rest = xop.wh(validate.rest, function(args, state, type){
  var F, data;
  switch (type) {
  case 'and':
  case 'map':
  case 'alt':
  case 'or':
  case 'forEach':
  case 'onor':
    F = cato(args[0]);
    break;
  case 'err':
  case 'fix':
  case 'cont':
  case 'jam':
  case 'edit':
  case 'tap':
    F = args[0];
    break;
  case 'try':
    F = void 8;
  }
  data = {
    type: state.type,
    all: {
      node: [type, F],
      back: state.all
    },
    index: state.index + 1,
    str: [type, state.str]
  };
  switch (data.type) {
  case 'obj':
  case 'arr':
  case 'arg':
    switch (type) {
    case 'try':
      return new proto.core.functor(data);
    default:
      return new proto.functor(data);
    }
  default:
    switch (type) {
    case 'try':
      return new proto.core.normal(data);
    default:
      return new proto.normal(data);
    }
  }
}).def(loopError);
define.basis = function(name, F){
  var data;
  data = {
    type: name,
    str: [name],
    all: {
      node: ['and', ['d', F]]
    },
    index: 0
  };
  F.self = data;
  switch (name) {
  case 'obj':
  case 'arr':
  case 'arg':
    Object.setPrototypeOf(F, proto.functor.prototype);
    break;
  default:
    Object.setPrototypeOf(F, proto.normal.prototype);
  }
};
define.basis.empty = function(name){
  var data, inherited;
  data = {
    type: name,
    str: [name],
    index: -1
  };
  inherited = (function(){
    switch (name) {
    case 'obj':
    case 'arr':
    case 'arg':
      return new proto.functor(data);
    default:
      return new proto.normal(data);
    }
  }());
  return inherited;
};
module.exports = {
  custom: custom,
  define: define,
  cache_def: defset
};