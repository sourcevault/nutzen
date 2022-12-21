var com, print, modflag, defacto, z, zj, j, l, R, c, esp, create_stack, lit, version, help, show_stack, object_name, pkgname, arrange, show_chain, map_fname_to_ctypes, StrArgLen, StrEType, out$ = typeof exports != 'undefined' && exports || this, slice$ = [].slice, arrayFrom$ = Array.from || function(x){return slice$.call(x);};
com = require("../../dist/utils/main.js");
print = {};
out$.com = com = com;
out$.print = print = print;
out$.modflag = modflag = Symbol("self");
out$.defacto = defacto = Symbol("default");
z = com.z, zj = com.zj, j = com.j, l = com.l, R = com.R, c = com.c, esp = com.esp, create_stack = com.create_stack, lit = com.lit, version = com.version;
print.log = {};
help = c.grey("[  docs] " + com.homepage + "\n");
show_stack = create_stack(1, ['internal/modules/cjs', 'node:internal'], help);
object_name = "hoplon.guard";
pkgname = object_name + "#v" + version + "}";
print.log.def_fault = function(){
  return c.er2("[error." + pkgname + "]");
};
print.log.proto = function(){
  var state;
  state = this[modflag];
  if (state === undefined) {
    return c.pink("[" + pkgname + "]") + c.er2("[state undefined]");
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
    return c.pink("[" + object_name + "|error]");
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
  put = clr(("[" + object_name) + str + "]");
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
    str += lit(["(xx)", " <-- type error in argument"], [c.er3, c.er1]);
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
  case 'ar':
  case 'arn':
    return 'ar';
  case 'wh':
  case 'whn':
  case 'ma':
    return 'wh';
  case 'arwh':
  case 'arwhn':
  case 'arnwhn':
  case 'arma':
    return 'arwh';
  default:
    return fname;
  }
};
StrArgLen = function(fname, ctype, eType){
  var data;
  data = (function(){
    switch (ctype) {
    case 'wh':
      return [2, 'FT,FA'];
    case 'ar':
      return [2, '(number|[num...]),FA'];
    case 'arwh':
      return [3, '(number|[num...]),FT,FA'];
    case 'par':
      return [3, 'FT,FA,FT'];
    case 'arpar':
      return [4, '(number|[num...]),FT,FA,F'];
    }
  }());
  switch (eType) {
  case 'many_args':
    return [c.er3("too many arguments"), lit(["only " + data[0] + " arguments ", "\n\n " + fname, " :: (" + data[1] + ") "], [c.blue, c.ok, c.ok])];
  case 'few_args':
    return [c.er3("too few arguments"), lit(["requires " + data[0] + " arguments ", "\n\n " + fname, " :: (" + data[1] + ") "], [c.blue, c.ok, c.ok])];
  }
};
StrEType = function(fname, data){
  var eType, extra, ctype, init;
  eType = data[0], extra = data[1];
  ctype = map_fname_to_ctypes(fname);
  switch (eType) {
  case 'many_args':
  case 'few_args':
    return StrArgLen(fname, ctype, eType);
  }
  init = (function(){
    switch (ctype) {
    case 'ar':
      switch (eType) {
      case 'first':
        return lit(["(", "number", "|[num...]),FA"], [c.ok, c.er2, c.ok]);
      case 'array':
        return lit(["(number", "|[num..]", "),FA"], [c.ok, c.er2, c.ok]);
      case 'ob_not_object':
        return lit(["(", "object", ")|((number|[num..]),FA)"], [c.ok, c.er2, c.ok]);
      }
      break;
    case 'wh':
      switch (eType) {
      case 'first':
        return lit(["FT", ",FA"], [c.er2, c.ok]);
      case 'second':
        return lit(["FT", "FA"], [c.ok, c.er2]);
      }
      break;
    case 'arwh':
      switch (eType) {
      case 'num':
        return lit(["(", "number", "|[num..]),FT,FA"], [c.ok, c.er2, c.ok]);
      case 'array':
        return lit(["(number|", "[num..]", "),FT,FA"], [c.ok, c.er2, c.ok]);
      case 'second':
        return lit(["(number|[num..]),", "FT", ",FA"], [c.ok, c.er2, c.ok]);
      case 'ob_not_object':
        return lit(["(", "object", ")|((number|[num..]),FT,FA)"], [c.ok, c.er2, c.ok]);
      case 'ob_inner_array':
        return lit(["(object(", extra + ":...", "))"], [c.ok, c.er2, c.ok]);
      case 'ob_inner_array_validator':
        return lit(["(object(", extra + ":", "(", "FT", ",FA)))"], [c.ok, c.er2, c.ok, c.er2, c.ok]);
      case 'ob_inner_not_array':
        return lit(["(object(", extra + ":[..]", "))"], [c.ok, c.er2, c.ok]);
      }
      break;
    case 'arpar':
      switch (eType) {
      case 'num':
        return lit(["(", "number", "|[num..]),FT,FA,F"], [c.ok, c.er2, c.ok]);
      case 'num_array':
        return lit(["(number|", "[num..]", "),FT,FA,F"], [c.ok, c.er2, c.ok]);
      case 'validator':
        return lit(["(number|[num..]),", "FT", ",FA,F"], [c.ok, c.er2, c.ok]);
      case 'lastview':
        return lit(["(number|[num..]),F,FA,", "F"], [c.ok, c.er2]);
      case 'ob_not_object':
        return lit(["(", "object", ")|((number|[num..]),FT,FA,F)"], [c.ok, c.er2, c.ok]);
      case 'ob_inner_not_array':
        return lit(["(object(", extra + ":[..]", "))"], [c.ok, c.er2, c.ok]);
      case 'ob_inner_array':
        return lit(["(object(", extra + "", "))"], [c.ok, c.er2, c.ok]);
      case 'ob_inner_array_validator':
        return lit(["(object(", extra + ":", "(", "FT", ",FA,F)))"], [c.ok, c.er2, c.ok, c.er2, c.ok]);
      case 'ob_inner_lastview':
        return lit(["(object(", extra + ":", "(FT,FA,", "F", ")))"], [c.ok, c.er2, c.ok, c.er2, c.ok]);
      }
      break;
    case 'par':
      switch (eType) {
      case 'validator':
        return lit(["FT", ",FA,F"], [c.er2, c.ok]);
      case 'lastview':
        return lit(["FT,FA", ",F"], [c.ok, c.er2]);
      }
    }
  }());
  init = lit([fname + " :: ", init], [c.grey, 0]);
  return [init, c.pink('one of the argument is of the wrong type.')];
};
print.typeError = function(ta){
  var E, fname, attribute, data, ref$, type_signature, comment, legend, I;
  E = ta[0], fname = ta[1], attribute = ta[2], data = ta[3];
  ref$ = StrEType(fname, attribute), type_signature = ref$[0], comment = ref$[1];
  legend = ["  F = function", "  FA = function|any", "  FT = function|hoplon.types"];
  legend = (function(){
    var i$, ref$, len$, results$ = [];
    for (i$ = 0, len$ = (ref$ = legend).length; i$ < len$; ++i$) {
      I = ref$[i$];
      results$.push(c.blue(I));
    }
    return results$;
  }()).join("\n");
  l(lit(["[" + pkgname + "]", "[typeError]", " ." + fname + "(...)"], [c.pink, c.er2, c.er2]));
  l('\n', show_chain(data.str, [fname]), '\n\n', legend, '\n\n', type_signature, '\n\n', comment, '\n');
  return show_stack(E);
};
print.unary_not_array = function(arg$){
  var E, data;
  E = arg$[0], data = arg$[1];
  l(lit(["[" + pkgname + "]", "[typeError]"], [c.pink, c.er2]));
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
      return "option not defined.";
    }
  }());
  l(lit(["[" + pkgname + "]", "[configError]", " " + msg], [c.pink, c.er2, c.er1]));
  l('\n', lit([vr.join("."), "." + key], [c.ok, c.er3]), '\n');
  return show_stack(E);
};
print.state_undef = function(arg$){
  var E, fname;
  E = arg$[0], fname = arg$[1];
  l(lit(["[" + pkgname + "]", "[Error]"], [c.pink, c.er1]));
  l(lit(["\n  ." + fname], [c.warn]));
  l(lit(["\n  Javascript does not allow referencing of .prototype function.\n"], [c.pink]));
  return show_stack(E);
};
print.validator_return_not_array = function(ta){
  var E, ref$, type, loc, data, type_signature;
  E = ta[0], ref$ = ta[1], type = ref$[0], loc = ref$[1], data = ta[2];
  type_signature = StrEType(type, loc)[0];
  l(lit(["[" + pkgname + "]", "[typeError]", " ." + type + "(", "...", ")"], [c.pink, c.er2, c.er2, c.er3, c.er2]));
  l('\n', show_chain(R.init(data.str), [type]), '\n\n', type_signature, '\n\n', c.pink("validator function requires return value to be array like."), '\n');
  return show_stack(E);
};
print.route = function(ta){
  var ECLASS, data;
  ECLASS = ta[0], data = ta[1];
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
  case 'validator_return_not_array':
    print.validator_return_not_array(data);
    break;
  case 'state_undef':
    print.state_undef(data);
    break;
  default:
    l("print.route\n\n", Er, data);
  }
};