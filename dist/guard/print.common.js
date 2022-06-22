var com, print, modflag, defacto, z, l, R, c, esp, create_stack, lit, version, help, show_stack, pkgname, arrange, show_chain, map_fname_to_ctypes, StrArgLen, StrEType, out$ = typeof exports != 'undefined' && exports || this, slice$ = [].slice, arrayFrom$ = Array.from || function(x){return slice$.call(x);};
com = require("../../dist/utils/main.js");
print = {};
out$.com = com = com;
out$.print = print = print;
out$.modflag = modflag = Symbol("self");
out$.defacto = defacto = Symbol("default");
z = com.z, l = com.l, R = com.R, c = com.c, esp = com.esp, create_stack = com.create_stack, lit = com.lit, version = com.version;
print.log = {};
help = c.grey("[  docs] " + com.homepage + "\n");
show_stack = create_stack(3, [], help);
pkgname = "v" + version + "|hoplon.guard";
print.log.def_fault = function(){
  return c.er2("[error." + pkgname + "]");
};
print.log.proto = function(){
  var state;
  state = this[modflag];
  if (state === undefined) {
    return c.er1("[" + pkgname + "]") + c.er2("[state undefined]");
  }
  return print.log.main(state);
};
print.log.wrap = function(state){
  return function(){
    return print.log.main(state);
  };
};
print.log.prox = function(state){
  var inner, str;
  if (state === null) {
    return null;
  }
  if (state.lock) {
    return c.ok("[Function]");
  }
  if (state.vr.length === 0) {
    inner = "";
  } else {
    inner = "|" + state.vr.join("|");
  }
  str = R.join("", ["[" + pkgname, inner, "]"]);
  return c.warn(str) + " []";
};
arrange = R.pipe(R.groupWith(R.equals), R.map(function(x){
  var name;
  name = x[0];
  switch (x.length) {
  case 1:
    return name;
  default:
    return name + "(" + x.length + ")";
  }
}), function(x){
  return c.ok(x.join(" "));
});
print.log.main = function(state){
  var str, clr, put, arr;
  if (state.fault) {
    return c.er2("[" + pkgname + "|error]");
  }
  str = "";
  if (state.immutable) {
    str += "|immutable";
    clr = c.ok;
  } else {
    str += "|mutable";
    clr = c.warn;
  }
  if (state.apply) {
    str += "| apply";
  }
  put = clr(("[" + pkgname) + str + "]");
  arr = arrange(state.str);
  str = put + " " + "[ " + arr + " ]";
  return str;
};
show_chain = function(inputStr, path, showArgs){
  var str, i$, len$, I;
  path == null && (path = []);
  showArgs == null && (showArgs = true);
  str = "";
  for (i$ = 0, len$ = inputStr.length; i$ < len$; ++i$) {
    I = inputStr[i$];
    str += "." + I + "(~)";
  }
  str = c.ok(str);
  if (showArgs) {
    str += (function(){
      var i$, ref$, len$, results$ = [];
      for (i$ = 0, len$ = (ref$ = path).length; i$ < len$; ++i$) {
        I = ref$[i$];
        results$.push(c.warn("." + I));
      }
      return results$;
    }()).join("");
    str += lit(["(xx)", " <-- error within argument"], [c.er3, c.er1]);
  } else {
    str += c.er2((function(){
      var i$, ref$, len$, results$ = [];
      for (i$ = 0, len$ = (ref$ = path).length; i$ < len$; ++i$) {
        I = ref$[i$];
        results$.push("." + I);
      }
      return results$;
    }()).join(""));
    str += c.er1(" <-- error here.");
  }
  return str;
};
map_fname_to_ctypes = function(fname){
  switch (fname) {
  case 'ma':
    return 'ma';
  case 'ar':
  case 'arn':
    return 'ar';
  case 'wh':
  case 'whn':
    return 'wh';
  case 'arwh':
  case 'arwhn':
  case 'arnwhn':
  case 'arma':
    return 'arwh';
  case 'arpar':
    return 'arpar';
  }
};
StrArgLen = function(fname, ctype, eType){
  var data;
  data = (function(){
    switch (ctype) {
    case 'ma':
      return [1, '(function|[fun....])'];
    case 'wh':
      return [2, '(function,function|any)'];
    case 'ar':
      return [2, '(number|[num...],function|any)'];
    case 'arwh':
      return [3, '(number|[num...],function,function|any)'];
    case 'arpar':
      return [4, '(number|[num...],function,function|any,function)'];
    }
  }());
  switch (eType) {
  case 'many_args':
    return [c.pink("too many arguments"), lit(["only " + data[0] + " arguments ", "\n\n " + fname, " :: " + data[1] + " "], [c.blue, c.ok, c.ok])];
  case 'few_args':
    return [c.pink("too few arguments"), lit(["requires " + data[0] + " arguments ", "\n\n " + fname, " :: " + data[1] + " "], [c.blue, c.ok, c.ok])];
  }
};
StrEType = function(fname, eType){
  var ctype, init;
  ctype = map_fname_to_ctypes(fname);
  switch (eType) {
  case 'many_args':
  case 'few_args':
    return StrArgLen(fname, ctype, eType);
  }
  init = (function(){
    switch (ctype) {
    case 'ma':
      return lit(["function|[fun....],function|any"], [c.er2, c.ok]);
    case 'arma':
      switch (eType) {
      case 'first':
        return lit(["number", "|[num...],[fun....]"], [c.er2, c.ok]);
      case 'array':
        return lit(["number", "|[num..]", ",[fun....]"], [c.ok, c.er2, c.ok]);
      case 'not_function':
        return lit(["number|[num..]", ",[fun....]"], [c.ok, c.er2]);
      }
      break;
    case 'ar':
      switch (eType) {
      case 'first':
        return lit(["number", "|[num...],function|any"], [c.er2, c.ok]);
      case 'array':
        return lit(["number", "|[num..]", ",function|any"], [c.ok, c.er2, c.ok]);
      }
      break;
    case 'wh':
      switch (eType) {
      case 'first':
        return lit(["function", ",function|any"], [c.er2, c.ok]);
      case 'second':
        return lit(["function", "function|any"], [c.ok, c.er2]);
      }
      break;
    case 'arwh':
      switch (eType) {
      case 'num':
        return lit(["number", "|[num..],function,function|any"], [c.er2, c.ok]);
      case 'array':
        return lit(["number|", "[num..]", ",function,function|any"], [c.ok, c.er2, c.ok]);
      case 'second':
        return lit(["number[num..],", "function", ",function|any"], [c.ok, c.er2, c.ok]);
      }
      break;
    case 'arpar':
      switch (eType) {
      case 'num':
        return lit(["number", "|[num..],function,function|any,function"], [c.er2, c.ok]);
      case 'array':
        return lit(["number|", "[num..]", ",function,function|any,function"], [c.ok, c.er2, c.ok]);
      case 'second':
        return lit(["number[num..],", "function", ",function|any,function"], [c.ok, c.er2, c.ok]);
      case 'fourth':
        return lit(["number[num..],function,function|any,", "function"], [c.ok, c.er2]);
      }
    }
  }());
  init = lit(["(", init, ")"], [c.ok, 0, c.ok]);
  return [init, c.pink('One of the argument is of the wrong type.')];
};
print.typeError = function(data){
  var ref$, E, fname, attribute, type_signature, comment;
  ref$ = data, E = ref$[0], fname = ref$[1], attribute = ref$[2], data = ref$[3];
  ref$ = StrEType(fname, attribute), type_signature = ref$[0], comment = ref$[1];
  l(lit(["[" + packageJ.name + "]", "[typeError]", " ." + fname + "(", "...", ")"], [c.er1, c.er2, c.grey, c.er3, c.grey]));
  l('\n', show_chain(data.str, [fname]), '\n\n', type_signature, '\n\n', comment, '\n');
  return show_stack(E);
};
print.unary_not_array = function(arg$){
  var E, data;
  E = arg$[0], data = arg$[1];
  l(lit(["[" + packageJ.name + "]", "[typeError]"], [c.er1, c.er2]));
  l('\n', lit(['unary', show_chain(arrayFrom$(data.str).concat(['def']), [])], [c.warn, 0]), '\n');
  l(lit([" unary namespace requires first argument to be array like.", "\n"], [c.pink, 0]));
  return show_stack(E);
};
print.setting = function(arg$){
  var E, type, vr, key, msg;
  E = arg$[0], type = arg$[1], vr = arg$[2], key = arg$[3];
  msg = (function(){
    switch (type) {
    case 'path_locked':
      return "all settings enabled.";
    case 'already_in_path':
      return "setting already enabled.";
    case 'not_in_opts':
      return "undefined option.";
    }
  }());
  l(lit(["[" + pkgname + "][configError]", " " + msg], [c.er2, c.warn]));
  l('\n', lit([vr.join("."), ".", key], [c.ok, c.ok, c.er]), '\n');
  return show_stack(E);
};
print.state_undef = function(arg$){
  var E, fname;
  E = arg$[0], fname = arg$[1];
  l(lit(["[" + pkgname + "][Error]"], [c.er2]));
  l(lit(["\n  ." + fname], [c.warn]));
  l(lit(["\n  Javascript does not allow referencing of .prototype function.\n"], [c.pink]));
  return show_stack(E);
};
print.arpar_not_array = function(arg$){
  var E, data, type_signature;
  E = arg$[0], data = arg$[1];
  type_signature = StrEType('arpar', "second")[0];
  l(lit(["[" + packageJ.name + "]", "[typeError]", " .arpar(", "...", ")"], [c.er1, c.er2, c.grey, c.er3, c.grey]));
  l('\n', show_chain(data.str, ['arpar']), '\n\n', type_signature, '\n\n', c.pink(".arpar validator function requires return value to be array like."), '\n');
  return show_stack(E);
};
print.route = function(arg$){
  var ECLASS, data;
  ECLASS = arg$[0], data = arg$[1];
  switch (ECLASS) {
  case 'input':
    print.typeError(data);
    break;
  case 'unary_not_array':
    print.unary_not_array(data);
    break;
  case 'setting':
    print.setting(data);
    break;
  case 'arpar_not_array':
    print.arpar_not_array(data);
    break;
  case 'state_undef':
    print.state_undef(data);
    break;
  default:
    l("print.route\n\n", Er, data);
  }
};