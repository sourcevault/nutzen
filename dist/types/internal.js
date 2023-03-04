var pkg, com, symbols, print, tightloop, z, l, R, j, uic, deep_freeze, loopError, tupnest, noop, link, xop, defset, def_or_normal, assort, cato, assign_self, x$, wrap, y$, guard, z$, define, z1$, validate, z2$, proto, z3$, user_wrap, p_core, main, i$, ref$, len$, val, create_new_try, get, ge, link_from_main, custom, ha, functor, core, slice$ = [].slice, arrayFrom$ = Array.from || function(x){return slice$.call(x);};
pkg = require('./print.common');
com = pkg.com, symbols = pkg.symbols, print = pkg.print;
tightloop = require('./tightloop');
z = com.z, l = com.l, R = com.R, j = com.j, uic = com.uic, deep_freeze = com.deep_freeze, loopError = com.loopError, tupnest = com.tupnest, noop = com.noop, link = com.link;
xop = pkg.guard;
defset = new Set();
def_or_normal = function(F){
  switch (R.type(F)) {
  case 'Function':
    return true;
  case 'Object':
    if (F[symbols.htypes] || defset.has(F)) {
      return true;
    }
    return false;
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
assign_self = function(){
  return function(self){
    this.self = self;
    return this;
  };
};
x$ = wrap = {};
x$.on = null;
x$.functor = null;
x$.core = null;
y$ = guard = {};
y$.on = null;
y$.rest = null;
z$ = define = {};
z$.and = null;
z$.or = null;
z$.proto = null;
z$.on = null;
z$.basis = null;
z$.block = null;
z$.functor = null;
z$.rest = null;
z1$ = validate = {};
z1$.on = null;
z1$.rest = null;
z2$ = proto = {};
z2$.normal = assign_self();
z2$.functor = assign_self();
z2$.core = assign_self();
z3$ = z2$['try'] = {};
z3$.functor = assign_self();
z3$.normal = assign_self();
link.proto(proto.core, proto['try'].functor, proto['try'].normal, proto.normal, proto.functor);
user_wrap = function(){
  var F;
  F = this;
  return function(){
    return F.auth.apply(F, arguments).value;
  };
};
p_core = proto.core.prototype;
p_core[symbols.htypes] = true;
p_core.auth = tightloop;
Object.defineProperty(p_core, 'wrap', {
  get: user_wrap,
  enumerable: true
});
wrap.core = function(type){
  return function(){
    return guard.core(arguments, this.self, type);
  };
};
wrap.on = function(type){
  return function(){
    return guard.on(arguments, this.self, type);
  };
};
wrap.functor = function(type){
  return function(){
    return define.functor(arguments, this.self, type);
  };
};
wrap.misc = function(type){
  return function(){
    return define.rest(arguments, this.self, type);
  };
};
main = {};
for (i$ = 0, len$ = (ref$ = ['and', 'tap', 'or', 'alt']).length; i$ < len$; ++i$) {
  val = ref$[i$];
  main[val] = wrap.core(val);
}
for (i$ = 0, len$ = (ref$ = ['on', 'onor']).length; i$ < len$; ++i$) {
  val = ref$[i$];
  main[val] = wrap.on(val);
}
for (i$ = 0, len$ = (ref$ = ['map', 'forEach']).length; i$ < len$; ++i$) {
  val = ref$[i$];
  main[val] = wrap.functor(val);
}
for (i$ = 0, len$ = (ref$ = ['cont', 'edit', 'err', 'jam', 'fix']).length; i$ < len$; ++i$) {
  val = ref$[i$];
  main[val] = wrap.misc(val);
}
create_new_try = function(data, type){
  type == null && (type = data.type);
  switch (type) {
  case 'obj':
  case 'arr':
    return new proto['try'].functor(data);
  default:
    return new proto['try'].normal(data);
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
  return create_new_try(data);
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
ge = {
  get: get.end,
  enumerable: true
};
Object.defineProperty(proto['try'].functor.prototype, 'end', ge);
Object.defineProperty(proto['try'].normal.prototype, 'end', ge);
link_from_main = link.proto_fn(main);
link_from_main(['and', 'cont', 'tap', 'edit', 'err', 'jam', 'fix'], proto.core);
link_from_main(['or', 'alt'], proto.normal, proto.functor);
link_from_main(['map', 'forEach', 'on', 'onor'], proto.functor);
link_from_main(['map', 'forEach', 'on', 'onor'], proto['try'].functor);
p_core[uic] = print.log('core.normal');
proto['try'].functor.prototype[uic] = print.log('try.functor');
proto['try'].normal.prototype[uic] = print.log('try.normal');
proto.normal.prototype[uic] = print.log('normal');
proto.functor.prototype[uic] = print.log('functor');
custom = {};
custom.main = function(F){
  var G, data;
  G = cato(F);
  data = {
    type: 'custom',
    all: {
      node: G
    },
    index: 0,
    str: ["{..}"],
    mode: 'normal'
  };
  return new proto.normal(data);
};
custom.err = function(type){
  return function(){
    var edata;
    edata = tupnest([new Error(), 'input.fault'], 'custom', type);
    return print.route(edata);
  };
};
custom.is_fun = function(F){
  return R.type(F) === 'Function';
};
custom.exp = xop.arn(1, custom.err('arg_count')).whn(custom.is_fun, custom.err('not_function')).def(custom.main);
custom.exp.is_instance = function(x){
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
    case 'onor.array':
      props = args[0], F = args[1];
      return [R.uniq(props)].concat(arrayFrom$(cato(F)));
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
ha = {};
ha.err = function(err_type, args, state, type){
  var edata;
  edata = tupnest([new Error(), 'input.fault'], 'on', [err_type], [state.str, type]);
  return print.route(edata);
};
ha.err_static = function(type){
  return function(){
    return ha.err.apply(ha, [type].concat(arrayFrom$(arguments)));
  };
};
ha.validate_obj = function(args, state, which_on){
  var maybe_object, type, I, val;
  maybe_object = args[0];
  type = R.type(maybe_object);
  if (type === 'Object') {
    for (I in maybe_object) {
      val = maybe_object[I];
      if (R.type(val) !== 'Function') {
        return [false, 'object'];
      }
    }
    return [true, 'object'];
  } else {
    return [false, 'typeError'];
  }
};
ha.validate_rest = function(arg$, state, which_on){
  var first, second, type, i$, len$, index, I, ref$;
  first = arg$[0], second = arg$[1];
  type = R.type(first);
  if (which_on === 'onor' && type !== 'Array') {
    return [false, 'onor_type'];
  }
  switch (type) {
  case 'Array':
    for (i$ = 0, len$ = first.length; i$ < len$; ++i$) {
      index = i$;
      I = first[i$];
      if (!((ref$ = R.type(I)) === 'String' || ref$ === 'Number')) {
        return [false, 'array'];
      }
    }
    if (!def_or_normal(second)) {
      return [false, 'array'];
    }
    if (which_on === 'onor') {
      return [true, 'onor.array'];
    } else {
      return [true, 'array'];
    }
  case 'String':
  case 'Number':
    if (!def_or_normal(second)) {
      return [false, 'string'];
    }
    return [true, 'string'];
  default:
    return [false];
  }
};
ha[1] = [ha.validate_obj, ha.err, define.on];
ha[2] = [ha.validate_rest, ha.err, define.on];
guard.on = xop.unary.arn([1, 2], ha.err_static('arg_count')).arcap(ha).def(ha.err_static('typeError'));
functor = {};
functor.main = function(args, state, ftype){
  var range, mod_range, data;
  if (state.type === 'arr') {
    range = args[0];
    mod_range = (function(){
      switch (range.length) {
      case 1:
        return [range[0], Infinity, 1];
      case 2:
        return [range[0], range[1], 1];
      default:
        return range;
      }
    }());
    args[0] = mod_range;
    args[1] = cato(args[1]);
  } else {
    args[0] = cato(args[0]);
  }
  data = {
    type: state.type,
    all: {
      node: [ftype, args],
      back: state.all
    },
    index: state.index + 1,
    str: [ftype, state.str],
    mode: state.mode
  };
  return new proto.functor(data);
};
functor.validate_range = function(arg$, state, type){
  var range, F, i$, len$, index, item, step;
  range = arg$[0], F = arg$[1];
  if (state.type === 'obj') {
    return [false, ['range.obj']];
  }
  if (R.type(range) !== 'Array') {
    return [false, ['range']];
  }
  for (i$ = 0, len$ = range.length; i$ < len$; ++i$) {
    index = i$;
    item = range[i$];
    if (R.type(item) !== 'Number') {
      return [false, ['num', index]];
    }
  }
  switch (range.length) {
  case 1:
  case 2:
    break;
  case 3:
    step = range[2];
    return [false, ['inf_step']];
  default:
    return [false, ['num_count']];
  }
  if (!def_or_normal(F)) {
    return [false, ['fun', 'second']];
  }
  return true;
};
functor.validate = function(arg$, state){
  var F;
  F = arg$[0];
  if (!def_or_normal(F)) {
    return [false, ['fun', 'first']];
  }
  return true;
};
functor.err_static = function(val){
  return function(){
    return functor.err.apply(functor, [[val]].concat(arrayFrom$(arguments)));
  };
};
functor.err = function(err_type, args, state, type){
  var edata;
  edata = tupnest([new Error(), 'input.fault'], type, [err_type], [state.str, type]);
  return print.route(edata);
};
functor[1] = [
  functor.validate, functor.err, function(arg$, state, fname){
    var F, arg;
    F = arg$[0];
    if (state.type === 'arr') {
      arg = [[0, Infinity, 1], F];
    } else {
      arg = [F];
    }
    return functor.main(arg, state, fname);
  }
];
functor[2] = [functor.validate_range, functor.err, functor.main];
functor.def = functor.err_static('undefined_error');
define.functor = xop.unary.arcap(functor).arn([1, 2], functor.err_static('arg_count')).def(functor.def);
define.rest = function(args, state, type){
  var fname, list, res$, i$, len$, I, len, F, node, data;
  fname = type;
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
    if (len !== 1) {
      fname = type + "." + 'multi';
      F = list;
    } else {
      F = list[0];
    }
    break;
  case 'edit':
    fname = 'cont';
    // fallthrough
  case 'err':
  case 'fix':
  case 'cont':
  case 'jam':
  case 'edit':
  case 'tap':
    F = args[0];
  }
  switch (type) {
  case 'and':
    node = F;
    break;
  case 'try':
    node = [fname];
    break;
  default:
    node = [fname, F];
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
    return create_new_try(data);
  } else {
    switch (data.type) {
    case 'obj':
    case 'arr':
      return new proto.functor(data);
    default:
      return new proto.normal(data);
    }
  }
};
core = {};
core.err_static = function(type){
  return function(){
    return core.err.apply(core, [type].concat(arrayFrom$(arguments)));
  };
};
core.err = function(err_type, args, state, type){
  var edata;
  edata = tupnest([new Error(), 'input.fault'], 'rest', type, [err_type], [state.str, type]);
  return print.route(edata);
};
core.validate = function(funs, state, type){
  var i$, len$, F;
  switch (type) {
  case 'and':
  case 'or':
  case 'alt':
    if (funs.length === 0) {
      return [false, 'arg_count'];
    }
    for (i$ = 0, len$ = funs.length; i$ < len$; ++i$) {
      F = funs[i$];
      if (R.type(F) !== 'Function') {
        return [false, 'not_function'];
      }
    }
    return true;
  case 'tap':
    if (!(funs.length === 1)) {
      return [false, 'arg_count'];
    }
    F = funs[0];
    if (R.type(F) !== 'Function') {
      return [false, 'not_function'];
    }
    return true;
  default:
    return false;
  }
};
guard.core = xop.cap(core.validate, core.err, define.rest).def(core.err_static('undefined_error'));
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
  custom: custom.exp,
  define: define,
  defset: defset
};