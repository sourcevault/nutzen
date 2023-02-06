var ref$, com, symbols, print, tightloop, z, l, R, j, uic, deep_freeze, loopError, tupnest, noop, xop, defset, def_or_normal, assort, cato, proto_link, assign_self, x$, wrap, y$, guard, z$, define, z1$, validate, z2$, proto, z3$, user_wrap, p_core, i$, len$, val, F, create_new_core, get, p, pn, handleError, custom, slice$ = [].slice, arrayFrom$ = Array.from || function(x){return slice$.call(x);};
ref$ = require('./print.common'), com = ref$.com, symbols = ref$.symbols, print = ref$.print;
tightloop = require('./tightloop');
z = com.z, l = com.l, R = com.R, j = com.j, uic = com.uic, deep_freeze = com.deep_freeze, loopError = com.loopError, tupnest = com.tupnest, noop = com.noop;
xop = require('../guard/main');
defset = new Set();
def_or_normal = function(F){
  if (F[symbols.htypes] || defset.has(F)) {
    return true;
  }
  return false;
};
'd';
'i';
'f';
assort = function(F){
  if (F[symbols.htypes]) {
    return ['i', F];
  } else if (defset.has(F)) {
    return ['d', F];
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
  target.prototype = Object.create(origin.prototype);
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
z3$.functor = assign_self();
z3$.normal = assign_self();
proto_link(proto.core.normal, proto.core.functor);
proto_link(proto.core.normal, proto.normal);
proto_link(proto.core.functor, proto.functor);
user_wrap = function(){
  var F;
  F = this;
  return function(){
    return F.auth.apply(F, arguments).value;
  };
};
p_core = proto.core.normal.prototype;
p_core[symbols.htypes] = true;
p_core.auth = tightloop;
p_core.wrap = user_wrap;
wrap.rest = function(type){
  return function(){
    return guard.rest(arguments, this.self, type);
  };
};
for (i$ = 0, len$ = (ref$ = ['and', 'cont', 'tap', 'edit', 'err', 'jam', 'fix']).length; i$ < len$; ++i$) {
  val = ref$[i$];
  F = wrap.rest(val);
  p_core[val] = F;
}
create_new_core = function(data, type){
  type == null && (type = data.type);
  switch (type) {
  case 'obj':
  case 'arr':
    return new proto.core.functor(data);
  default:
    return new proto.core.normal(data);
  }
};
get = {};
get['try'] = function(){
  var state, type, data;
  state = this.self;
  type = state.type;
  data = {
    type: type,
    all: {
      node: ['try'],
      back: state.all
    },
    index: state.index + 1,
    mode: 'try',
    str: ['try', state.str]
  };
  return create_new_core(data);
};
get.end = function(){
  var state, type, data;
  state = this.self;
  type = state.type;
  data = {
    type: type,
    all: {
      node: ['end'],
      back: state.all
    },
    index: state.index + 1,
    mode: 'normal',
    str: ['end', state.str]
  };
  switch (data.type) {
  case 'obj':
  case 'arr':
    return new proto.functor(data);
  default:
    return new proto.normal(data);
  }
};
Object.defineProperty(p_core, 'try', {
  get: get['try']
});
p_core[uic] = print.log('core.normal');
Object.defineProperty(p_core, 'end', {
  get: get.end
});
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
pn = proto.normal.prototype;
pn.or = wrap.rest('or');
pn.alt = wrap.rest('alt');
pn[uic] = print.log('normal');
p = proto.functor.prototype;
p.or = pn.or;
p.alt = pn.alt;
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
    str: ["{..}"],
    mode: 'normal'
  };
  return new proto.normal(data);
});
custom.is_instance = function(x){
  switch (x[symbols.htypes]) {
  case true:
    return true;
  default:
    return false;
  }
};
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
    str: [ftype, state.str],
    mode: state.mode
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
guard.rest = xop.wh(validate.rest, function(args, state, type){
  var list, res$, i$, len$, I, len, F, node, data;
  switch (type) {
  case 'and':
  case 'or':
  case 'alt':
    res$ = [];
    for (i$ = 0, len$ = args.length; i$ < len$; ++i$) {
      I = args[i$];
      res$.push(cato(I));
    }
    list = res$;
    len = list.length;
    switch (len) {
    case 1:
      type = type;
      F = list[0];
      break;
    default:
      type = type + "." + 'multi';
      F = list;
    }
    break;
  case 'map':
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
  switch (type) {
  case 'and':
    node = F;
    break;
  default:
    node = [type, F];
  }
  data = {
    type: state.type,
    all: {
      node: node,
      back: state.all
    },
    index: state.index + 1,
    mode: state.mode,
    str: [type, state.str]
  };
  if (type === 'try' || state.mode === 'try') {
    return create_new_core(data);
  } else {
    switch (data.type) {
    case 'obj':
    case 'arr':
      return new proto.functor(data);
    default:
      return new proto.normal(data);
    }
  }
}).def(loopError);
define.basis = function(name, F, type){
  var data;
  type == null && (type = name);
  data = {
    type: type,
    str: [name],
    all: {
      node: ['d', F]
    },
    index: 0,
    mode: 'normal'
  };
  F.self = data;
  switch (type) {
  case 'obj':
  case 'arr':
    Object.setPrototypeOf(F, proto.functor.prototype);
    break;
  default:
    Object.setPrototypeOf(F, proto.normal.prototype);
  }
};
define.basis.empty = function(name, type){
  var data, inherited;
  type == null && (type = name);
  data = {
    type: type,
    str: [name],
    index: -1,
    mode: 'normal'
  };
  inherited = (function(){
    switch (type) {
    case 'obj':
    case 'arr':
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
  defset: defset
};