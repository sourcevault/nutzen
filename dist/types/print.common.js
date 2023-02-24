var pkg, print, com, l, z, R, j, flat, pad, alpha_sort, esp, c, lit, create_stack, version, loopError, pkgversion, pkgname, ref$, help, show_stack, type_color, show_chain, show_name, map_str, x$, on_dtype, getprop, includes, sort, same, split, find_len, out$ = typeof exports != 'undefined' && exports || this, slice$ = [].slice, arrayFrom$ = Array.from || function(x){return slice$.call(x);};
pkg = require('../guard/main');
print = {};
com = pkg.com;
l = com.l, z = com.z, R = com.R, j = com.j, flat = com.flat, pad = com.pad, alpha_sort = com.alpha_sort, esp = com.esp, c = com.c, lit = com.lit, create_stack = com.create_stack, version = com.version, loopError = com.loopError;
pkgversion = version;
pkgname = 'hoplon.types';
ref$ = out$;
import$(ref$, pkg);
ref$.print = print;
ref$.pkgname = pkgname;
print.log = {};
help = c.grey("[  docs] " + com.homepage + "\n");
show_stack = create_stack(2, ['internal/modules/cjs', 'node:internal'], help);
type_color = c.ok;
print.resreq = function(arg$){
  var cat, type, methodname, txt;
  cat = arg$[0], type = arg$[1];
  methodname = (function(){
    switch (cat) {
    case 'resreq':
      return ".resreq";
    case 'res':
      return ".restricted";
    case 'req':
      return ".required";
    }
  }());
  show_name(methodname, "[argumentError] ");
  txt = (function(){
    switch (cat) {
    case 'resreq':
      switch (type) {
      case 'prime':
        return "  .resreq only accepts 2 argument of type Array of String / Number.";
      case 'res':
        return "  first argmuent is not a Array of String / Number.";
      case 'req':
        return "  second argmuent is not a Array of String / Number.";
      }
      break;
    case 'res':
    case 'req':
      return "  one of the (inner) argument is not of type of String / Number.";
    }
  }());
  return l(lit(['\n', txt, '\n'], [0, c.warn, 0]));
};
print.input_fault = function(arg$){
  var method_name, data, input_fault;
  method_name = arg$[0], data = arg$[1];
  input_fault = this.input_fault;
  switch (method_name) {
  case 'on':
    return input_fault.on(data);
  case 'map':
    return input_fault.map(data);
  case 'custom':
    return input_fault.custom(data);
  case 'and':
  case 'or':
    return input_fault.andor(data, method_name);
  case 'rest':
    return input_fault.rest(data);
  }
};
show_chain = function(data){
  var chain_data, last, flattened_chain, middle, start_chain;
  chain_data = data[0], last = data[1];
  flattened_chain = chain_data.flat(Infinity).reverse();
  middle = R.tail(flattened_chain);
  if (middle.length) {
    start_chain = R.join("\n")(
    R.map(R.join(""))(
    R.tap(function(x){})(
    R.map(function(line){
      line.unshift(' ');
      return line;
    })(
    function(bulk){
      bulk[0].unshift(flattened_chain[0]);
      return bulk;
    }(
    R.splitEvery(2)(
    R.map(function(each){
      return "." + each + "(..)";
    })(
    middle)))))));
  } else {
    start_chain = ' ' + flattened_chain[0];
  }
  return l(lit([start_chain, "." + last, "(xx)", " <-- error here"], [c.grey, c.er1, c.er3, c.er2]));
};
show_name = function(extra, type){
  type == null && (type = "[inputError] ");
  return l(lit(["[" + pkgname + ":v" + pkgversion + "]", type, extra], [c.er2, c.er2, c.er2]));
};
print.input_fault.rest = function(data){
  var fname, info, etype, loc, txt;
  fname = data[0], info = data[1];
  etype = info[0], loc = info[1];
  show_name("." + fname);
  l("");
  show_chain(loc);
  l("");
  txt = (function(){
    switch (etype) {
    case 'arg_count':
      return " incorrect number of argument provided.";
    case 'not_function':
      return " one of the argument is not a function.";
    case 'undefined_error':
      return " illegal error, please report to original author.";
    }
  }());
  l(c.er3(txt));
  return l("");
};
print.input_fault.andor = function(arg$, method_name){
  var type, info, txt;
  type = arg$[0], info = arg$[1];
  show_name("." + info[1]);
  l("");
  show_chain(info);
  l("");
  txt = (function(){
    switch (type) {
    case 'arg_count':
      return " minimum of 1 argument of function type is needed.";
    case 'not_function':
      return " one of the argument is not a function.";
    }
  }());
  l(c.er3(txt));
  l("");
  l(c.grey(" expected type signature :"));
  l("");
  l(type_color(" " + method_name + " :: (fun,..)"));
  return l("");
};
print.input_fault.custom = function(patt){
  show_name("custom validator");
  l("");
  switch (patt) {
  case 'arg_count':
    l(c.er1(" accepts only 1 argument of type function."));
    break;
  case 'not_function':
    l(c.er1(" first argument has to be a function / hoplon.types object."));
  }
  return l("");
};
map_str = [c.ok(" map/1 :: fun"), c.ok(" map/2 :: [num,num],fun"), c.ok(" map/2 :: [num,num,num],fun")];
print.input_fault.map = function(arg$){
  var ref$, patt, extra, loc, num;
  ref$ = arg$[0], patt = ref$[0], extra = ref$[1], loc = arg$[1];
  show_name(".map");
  l("");
  show_chain(loc);
  l("");
  switch (patt) {
  case 'undefined_error':
    l(c.er3(" unexpected error (please report to author) expected types:\n"));
    l(map_str.join("\n"));
    break;
  case 'num_count':
    l(c.er3(" range values has to be either 1, 2 or 3.\n"));
    l(lit([" map :: (", "[num,..]", ",fun)"], [c.ok, c.er2, c.ok]));
    break;
  case 'range':
    l(c.er2(" first argument (range) has to be an array.\n"));
    l(lit([" map :: (", "[num,..]", ",fun)"], [c.ok, c.er3, c.ok]));
    break;
  case 'arg_count':
    l(c.er3(" only accepts 1 or 2 argument: \n"));
    l(map_str.join("\n"));
    break;
  case 'num':
    num = c.er3(extra) + c.er2(":num");
    l(c.er3(" range values have be all numbers.\n"));
    l(lit([" map :: (", num, ",fun)"], [c.ok, null, c.ok]));
    break;
  case 'fun':
    l(c.er3(" The " + extra + " argument has to a function.\n"));
    switch (extra) {
    case 'first':
      l(lit([" map/1 :: ", "fun"], [c.ok, c.er2]));
      break;
    case 'second':
      l(lit([" map/2 :: [num,...],", "fun"], [c.ok, c.er2]));
    }
  }
  return l("");
};
x$ = on_dtype = {};
x$.string = "(string|number),function";
x$.array = "[(string|number),..],function";
x$.object = "object{*:function}";
print.input_fault.on = function(data){
  var patt, loc, __, fname, lines, key, val, dtype;
  patt = data[0], loc = data[1];
  __ = loc[0], fname = loc[1];
  show_name("." + fname);
  l("");
  show_chain(loc);
  l("");
  switch (patt) {
  case 'typeError':
  case void 8:
  case 'arg_count':
    switch (patt) {
    case 'arg_count':
      l(c.er3(" only accepts 1 or 2 arguments."));
      break;
    case 'typeError':
    case void 8:
      l(c.er3(" unable to pattern match on user input."));
    }
    l("");
    l(c.grey(" types that may match :"));
    l("");
    lines = (function(){
      var ref$, results$ = [];
      for (key in ref$ = on_dtype) {
        val = ref$[key];
        results$.push(type_color(" - " + loc[1] + (" :: " + val)));
      }
      return results$;
    }()).join("\n\n");
    l(lines);
    break;
  case 'string':
  case 'array':
  case 'object':
    l(c.er3(" user input is incorrect.\n"));
    l(c.grey(" expected signature:\n"));
    dtype = on_dtype[patt];
    l(lit([" " + loc[1], " :: ", dtype], [c.ok, c.ok, c.ok]));
  }
  return l("");
};
print.route = function(arg$){
  var E, ECLASS, info;
  E = arg$[0], ECLASS = arg$[1], info = arg$[2];
  switch (ECLASS) {
  case 'resreq':
    print.resreq(info);
    break;
  case 'input.fault':
    print.input_fault(info);
  }
  show_stack(E);
  return loopError();
};
getprop = function(item){
  var fin, I;
  fin = [];
  for (I in item) {
    fin.push(I);
  }
  return fin;
};
includes = R.flip(R.includes);
sort = function(x){
  return x.sort(alpha_sort.ascending);
};
print.log = function(name){
  return function(){
    var str;
    switch (name) {
    case 'functor':
      str = ':m';
      break;
    case 'normal':
      str = '';
      break;
    case 'try.functor':
      str = ':m:try';
      break;
    case 'try.normal':
      str = ':try';
    }
    return lit([pkgname, str], [c.ok, c.ok]);
  };
};
same = includes(['and', 'or', 'cont', 'jam', 'fix', 'err', 'map', 'on', 'alt', 'auth', 'edit', 'tap', 'forEach', 'wrap']);
split = R.groupBy(function(name){
  return /\./.test(name);
});
find_len = R.reduce(function(accum, x){
  if (x.length > accum) {
    return x.length;
  } else {
    return accum;
  }
});
print.inner = function(){
  var ob, len, initTable, table, res$, i$, len$, I, str;
  props.push('tap');
  ob = split(props);
  len = find_len(0, props) + 4;
  if (ob['true'] === undefined && ob['false'] === undefined) {
    initTable = [];
  } else if (ob['true']) {
    initTable = arrayFrom$(ob['true']).concat(arrayFrom$(ob['false']));
  } else {
    initTable = ob['false'];
  }
  res$ = [];
  for (i$ = 0, len$ = initTable.length; i$ < len$; ++i$) {
    I = initTable[i$];
    res$.push(pad.padRight(I, len));
  }
  table = res$;
  table = (function(){
    var i$, ref$, len$, results$ = [];
    for (i$ = 0, len$ = (ref$ = R.splitEvery(2, table)).length; i$ < len$; ++i$) {
      I = ref$[i$];
      results$.push(I.join(" "));
    }
    return results$;
  }()).join("\n");
  str = c.warn("{.*} v" + version + "\n");
  str += table;
  return str;
};
function import$(obj, src){
  var own = {}.hasOwnProperty;
  for (var key in src) if (own.call(src, key)) obj[key] = src[key];
  return obj;
}