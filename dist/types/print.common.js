var com, xop, print, l, z, R, j, flat, pad, alpha_sort, esp, c, lit, create_stack, version, pkgversion, pkgname, sig, help, show_stack, type_color, show_chain, show_name, x$, on_dtype, getprop, includes, sort, same, myflat, split, find_len, out$ = typeof exports != 'undefined' && exports || this, slice$ = [].slice, arrayFrom$ = Array.from || function(x){return slice$.call(x);};
com = require('../utils/main');
xop = require('../guard/main');
print = {};
l = com.l, z = com.z, R = com.R, j = com.j, flat = com.flat, pad = com.pad, alpha_sort = com.alpha_sort, esp = com.esp, c = com.c, lit = com.lit, create_stack = com.create_stack, version = com.version;
pkgversion = version;
pkgname = 'hoplon.types';
out$.com = com = com;
out$.print = print = print;
out$.pkgname = pkgname = pkgname;
out$.sig = sig = com.common_symbols.htypes;
print.log = {};
help = c.grey("[  docs] " + com.homepage + "\n");
show_stack = create_stack(1, ['internal/modules/cjs', 'node:internal'], help);
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
  var method_name, data, fi;
  method_name = arg$[0], data = arg$[1];
  fi = this.input_fault;
  switch (method_name) {
  case 'on':
    return fi.on(data);
  case 'map':
    return fi.map(data);
  case 'custom':
    return fi.custom(data);
  case 'and':
  case 'or':
    return fi.andor(data, method_name);
  case 'bt':
    return fi.bt(data);
  }
};
show_chain = function(data){
  var init, last, middle, start_chain;
  init = data[0], last = data[1];
  middle = R.tail(init);
  if (middle.length) {
    start_chain = R.join("\n")(
    R.map(R.join(""))(
    R.tap(function(x){})(
    R.map(function(line){
      line.unshift(' ');
      return line;
    })(
    function(bulk){
      bulk[0].unshift(init[0]);
      return bulk;
    }(
    R.splitEvery(4)(
    R.map(function(each){
      return "." + each + "(..)";
    })(
    middle)))))));
  } else {
    start_chain = ' ' + init[0];
  }
  return l(lit([start_chain, "." + last, "(xx)", " <-- error here"], [c.grey, c.warn, c.er3, c.er3]));
};
show_name = function(extra, type){
  type == null && (type = "[inputError] ");
  return l(lit(["[" + pkgname + ":v" + pkgversion + "]", type, extra], [c.er2, c.er2, c.er2]));
};
print.input_fault.andor = function(arg$, method_name){
  var type, info;
  type = arg$[0], info = arg$[1];
  show_name("." + info[1]);
  l("");
  show_chain(info);
  l("");
  switch (type) {
  case 'arg_count':
    l(c.pink(" no value passed.\n\n", " minimum of 1 argument of function type is needed."));
    break;
  case 'not_function':
    l(c.er1("  one of the argument is not a function."));
  }
  l("");
  l(c.grey(" expected type signature :"));
  l("");
  l(type_color(" " + method_name + " :: ((fun|[fun,..]),..,..)"));
  return l("");
};
print.input_fault.custom = function(arg$){
  var patt, loc;
  patt = arg$[0], loc = arg$[1];
  show_name("custom validator");
  l("");
  switch (patt) {
  case 'arg_count':
    l(c.grey("  no value passed.", "\n\n", " minimum of 1 argument of function type is needed."));
    break;
  case 'not_function':
    l(c.er1("  first argument has to be a function / hoplon.types object ."));
  }
  return l("");
};
print.input_fault.map = function(arg$){
  var patt, loc;
  patt = arg$[0], loc = arg$[1];
  show_name(".map");
  l("");
  show_chain(loc);
  l("");
  switch (patt) {
  case 'arg_count':
    l(c.grey("  only accepts 1 argument required of function type."));
    break;
  case 'not_function':
    l(c.grey("  first argument has to be a function."));
  }
  return l("");
};
print.input_fault.bt = function(arg$){
  var type, info;
  type = arg$[0], info = arg$[1];
  show_name(".bt");
  l("");
  show_chain(info);
  l("");
  l(c.white(" expected type signature :"));
  l("");
  l(type_color(" bt :: (integer|undefined)"));
  return l("");
};
x$ = on_dtype = {};
x$.string = "(string|number,function)";
x$.array = "(string|[number....],function)";
x$.object = "(object{*:function})";
x$.single_array = "(['and'|'alt',string|[string,...],INC{hoplon.type}],...])";
print.input_fault.on = function(arg$){
  var patt, loc, eType, lines, key, val, dtype;
  patt = arg$[0], loc = arg$[1];
  eType = (function(){
    switch (patt) {
    case 'typeError':
      return 'typeError';
    default:
      return 'inputError';
    }
  }());
  show_name(".on", "[" + eType + "] ");
  l("");
  show_chain(loc);
  l("");
  switch (patt) {
  case 'typeError':
  case 'arg_count':
    switch (patt) {
    case 'typeError':
      l(c.er3("  unable to pattern match on user input."));
      break;
    case 'arg_count':
      l(c.er3("  minimum of 2 arguments required."));
    }
    l("");
    l(c.grey(" types that may match :"));
    l("");
    lines = (function(){
      var ref$, results$ = [];
      for (key in ref$ = on_dtype) {
        val = ref$[key];
        results$.push(type_color(" - .on :: " + val));
      }
      return results$;
    }()).join("\n\n");
    l(lines);
    break;
  default:
    dtype = on_dtype[patt];
    l(lit([" .on", " :: ", dtype, " <-- " + patt + " signature."], [c.warn, c.white, c.ok, c.grey]));
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
  return show_stack(E);
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
print.log = function(){
  return lit([pkgname], [c.warn]);
};
same = includes(['and', 'or', 'cont', 'jam', 'fix', 'err', 'map', 'on', 'alt', 'auth', 'edit', 'tap', 'forEach', 'wrap']);
myflat = xop.wh(function(ob){
  switch (R.type(ob)) {
  case 'Function':
  case 'Object':
    return true;
  default:
    return false;
  }
}, function(ob, fin){
  var keys, i$, len$, I, prop;
  fin == null && (fin = {});
  keys = Object.keys(ob);
  for (i$ = 0, len$ = keys.length; i$ < len$; ++i$) {
    I = keys[i$];
    if (!same(I)) {
      prop = myflat(ob[I]);
      fin[I] = prop;
    }
  }
  return fin;
}).def(function(){
  return {};
});
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
  var props, I, ob, len, initTable, table, res$, i$, len$, str;
  props = sort((function(){
    var results$ = [];
    for (I in flat(myflat(this))) {
      results$.push(I);
    }
    return results$;
  }.call(this)));
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