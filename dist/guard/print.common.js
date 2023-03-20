var ext, print, ref$, com, z, j, l, R, c, esp, create_stack, lit, version, help, show_stack, object_name, pkgname, arrange, show_chain, map_fname_to_ctypes, txt, arcap_txt, cap_txt, StrArgLen, defc, StrEType, out$ = typeof exports != 'undefined' && exports || this, slice$ = [].slice, arrayFrom$ = Array.from || function(x){return slice$.call(x);};
ext = require('../utils/main');
print = {};
ref$ = out$;
import$(ref$, ext);
ref$.print = print;
com = ext.com;
z = com.z, j = com.j, l = com.l, R = com.R, c = com.c, esp = com.esp, create_stack = com.create_stack, lit = com.lit, version = com.version;
print.log = {};
help = c.grey("[  docs] " + com.homepage);
show_stack = create_stack(2, ['internal/modules/cjs', 'node:internal'], help + '\n');
object_name = 'utilitat.guard';
pkgname = object_name + "#v" + version;
print.log.def_fault = function(){
  return c.er2("[error." + pkgname + "]");
};
print.log.proto = function(){
  var state;
  state = this.self;
  if (state === undefined) {
    return c.pink("[" + pkgname + "]") + c.er2("[state is undefined]");
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
    return c.er2("[error." + pkgname + "]");
  }
  if (state.lock) {
    return c.ok("[Function]");
  }
  if (state.sorted_path.length === 0) {
    inner = "";
  } else {
    inner = "/" + state.sorted_path.join(".");
  }
  str = R.join("", ["[" + pkgname, inner, "]"]);
  return c.pink(str) + " []";
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
  var str, put, arr, arr_str;
  if (state.fault) {
    return c.pink("[" + object_name + "|error]");
  }
  str = "";
  put = c.pink(("[" + object_name) + str + "]");
  if (state.debug) {
    if (state.str.length) {
      arr = arrange(state.str);
      arr_str = " [ " + arr + " ]";
    } else {
      arr_str = " []";
    }
  } else {
    arr_str = "";
  }
  str = put + arr_str;
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
    str += lit(["(xx)", " <--", " type error in argument"], [c.er3, c.er3, c.er3]);
  } else {
    str += c.er2((function(){
      var i$, ref$, len$, results$ = [];
      for (i$ = 0, len$ = (ref$ = path).length; i$ < len$; ++i$) {
        I = ref$[i$];
        results$.push("." + I);
      }
      return results$;
    }()).join(""));
    str += c.er3(" <-- error here.");
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
    return 'wh';
  case 'arwh':
  case 'arnwh':
  case 'arwhn':
  case 'arnwhn':
    return 'arwh';
  default:
    return fname;
  }
};
txt = {};
arcap_txt = [c.er2(".arcap only accepts 1,2,3 or 4 arguments :\n"), c.ok(" arcap/1 :: object"), c.ok(" arcap/2 :: PI,F"), c.ok(" arcap/3 :: PI,FT,F"), c.ok(" arcap/4 :: PI,FT,F,FA")];
txt.arcap = arcap_txt.join("\n");
cap_txt = [c.er2(".cap only accepts 2 or 3 arguments :\n"), c.ok(" cap/2 :: FT,FA"), c.ok(" cap/3 :: FT,F,FA")];
txt.cap = cap_txt.join("\n");
StrArgLen = function(fname, ctype, eType, extra){
  var data;
  switch (ctype + "." + eType) {
  case 'cap.few_args':
    return [c.er3(" too few arguments"), txt.cap];
  case 'cap.many_args':
    return [c.er3(" too many arguments"), txt.cap];
  case 'arcap.many_args':
    return [c.er3(" too many arguments"), txt.arcap];
  case 'arcap.few_args':
    return [c.er3(" too few arguments"), txt.arcap];
  }
  data = (function(){
    switch (ctype) {
    case 'wh':
      return [2, 'FT,FA'];
    case 'ar':
      return [2, '(pos_int|[pos_int,...]),FA'];
    case 'arwh':
      return [3, '(pos_int|[pos_int,...]),FT,FA'];
    }
  }());
  switch (eType) {
  case 'many_args':
    return [c.er3("too many arguments"), lit(["expects " + data[0] + " arguments ", "\n\n " + fname, " :: " + data[1] + " "], [c.er2, c.ok, c.ok])];
  case 'few_args':
    return [c.er3("too few arguments"), lit(["expects " + data[0] + " arguments ", "\n\n " + fname, " :: " + data[1] + " "], [c.er2, c.ok, c.ok])];
  }
};
defc = c.er1('one of the argument is of the wrong type.');
StrEType = function(fname, data){
  var eType, extra, ctype, init, str, col, inner, comment, cat, index, si;
  eType = data[0], extra = data[1];
  ctype = map_fname_to_ctypes(fname);
  switch (eType) {
  case 'many_args':
  case 'few_args':
    return StrArgLen(fname, ctype, eType, extra);
  }
  switch (ctype) {
  case 'ar':
    init = (function(){
      switch (eType) {
      case 'first':
        return lit(["(", "pos_int", "|[pos_int,...]),FA"], [c.ok, c.er3, c.ok]);
      case 'array':
        return lit(["(pos_int|", "[pos_int,..]", "),FA"], [c.ok, c.er3, c.ok]);
      case 'ob_not_object':
        return lit(["(", "object", ")|(PI,FA)"], [c.ok, c.er3, c.ok]);
      }
    }());
    break;
  case 'wh':
    init = (function(){
      switch (eType) {
      case 'first':
        return lit(["FT", ",FA"], [c.er3, c.ok]);
      }
    }());
    break;
  case 'arwh':
    init = (function(){
      switch (eType) {
      case 'first':
        return lit(["PI", ",FT,FA"], [c.er3, c.ok]);
      case 'pos_int':
        return lit(["(", "pos_int", "|[pos_int,..]),FT,FA"], [c.ok, c.er3, c.ok]);
      case 'array':
        return lit(["(pos_int|", "[pos_int,..]", "),FT,FA"], [c.ok, c.er3, c.ok]);
      case 'second':
        return lit(["(pos_int|[pos_int,..]),", "FT", ",FA"], [c.ok, c.er3, c.ok]);
      case 'ob_not_object':
        return lit(["(", "object", ")|((pos_int|[pos_int,..]),FT,FA)"], [c.ok, c.er3, c.ok]);
      case 'ob.inner_not_array':
        return lit(["object(", extra.join(":") + ":[..xx..]", ")"], [c.er1, c.er3, c.er1]);
      case 'ob.key_value_not_array':
        return lit(["object(", extra + ":xx", ")"], [c.er1, c.er3, c.er1]);
      case 'ob.inner_array_validator':
        return lit(["object(", extra.join(":") + ":", "", "(FT", ",FA", ")", ")"], [c.er1, c.er3, c.er1, c.er3, c.ok, c.er3, c.er1]);
      case 'ob.few_args':
        str = ["object", "(", extra.join(":"), ")"];
        col = [c.er2, c.er2, c.er3, c.er2];
        inner = lit(str, col);
        return lit(["arwh/1 :: ", inner], [c.ok, null]);
      case 'ob.many_args':
        str = ["object", "(", extra.join(":"), ")"];
        col = [c.er2, c.er2, c.er3, c.er2];
        inner = lit(str, col);
        return lit(["arwh/1 :: ", inner], [c.ok, null]);
      }
    }());
    comment = (function(){
      switch (eType) {
      case 'ob.few_args':
        return c.er1("minimum of 1 value needed.");
      case 'ob.many_args':
        return c.er1("only accepts 1 or 2 value(s).");
      default:
        return defc;
      }
    }());
    break;
  case 'arcap':
    init = (function(){
      switch (eType) {
      case 'num':
        switch (extra) {
        case 4:
          return lit(["arcap/4 :: (", "pos_int", "|[pos_int,..]),FT,F,FA"], [c.ok, c.er3, c.ok]);
        case 3:
          return lit(["arcap/3 :: (", "pos_int", "|[pos_int,..]),FT,FA"], [c.ok, c.er3, c.ok]);
        }
        break;
      case 'num_array':
        switch (extra) {
        case 4:
          return lit(["arcap/4 :: ", "(pos_int|", "[pos_int,..]", "),FT,F,FA"], [c.ok, c.ok, c.er3, c.ok]);
        case 3:
          return lit(["arcap/3 :: ", "(pos_int|", "[pos_int,..]", "),FT,FA"], [c.ok, c.ok, c.er3, c.ok]);
        }
        break;
      case 'validator':
        switch (extra) {
        case 4:
          return lit(["arcap/4 :: PI,", "FT", ",F,FA"], [c.ok, c.er3, c.ok]);
        case 3:
          return lit(["arcap/3 :: PI,", "FT", ",FA"], [c.ok, c.er3, c.ok]);
        }
        break;
      case 'lastview':
        return lit(["arcap/4 :: PI,FT,", "F", ",FA"], [c.ok, c.er3, c.ok]);
      case 'ob_not_object':
        return lit(["arcap/1 :: (", "object", ")"], [c.ok, c.er3, c.ok]);
      case 'ob.few_args':
        str = ["object", "(", extra[0] + ":" + extra[1], ")"];
        col = [c.er2, c.er2, c.er3, c.er2];
        inner = lit(str, col);
        return lit(["arcap/1 :: ", inner], [c.ok, null]);
      case 'ob.many_args':
        str = ["object", "(", extra[0] + ":" + extra[1], ")"];
        col = [c.er2, c.er2, c.er3, c.er2];
        inner = lit(str, col);
        return lit(["arcap/1 :: ", inner], [c.ok, null]);
      case 'ob.key_value_not_array':
        return lit(["arcap/1 :: (", "object(", extra + ":xx", ")", ")"], [c.ok, c.er1, c.er3, c.er1, c.ok]);
      case 'ob.inner_not_array':
        return lit(["arcap/1 :: ", "object(", extra.join(":") + ":[..xx..]", ")"], [c.ok, c.er1, c.er3, c.er1]);
      case 'ob.inner_array_validator':
        cat = extra[0], index = extra[1];
        switch (cat) {
        case 2:
          str = [c.er3("FT"), c.ok(",FA")].join("");
          return lit(["object(", index.join(":") + ":", "[", str, "])"], [c.er1, c.er3, c.er1, null, c.er1]);
        case 3:
          str = [c.er3("FT"), c.ok(",F,FA")].join("");
          return lit(["object(", index.join(":") + ":", "[", str, "])"], [c.er1, c.er3, c.er1, null, c.er1]);
        }
        break;
      case 'ob.inner_lastview':
        return lit(["object(", extra.join(":") + ":", "[", "FT,", "F", ",FA", "]", ")"], [c.er1, c.er3, c.er2, c.ok, c.er3, c.ok, c.er2, c.er1]);
      }
    }());
    comment = (function(){
      switch (eType) {
      case 'ob.few_args':
        return c.er1("minimum 1 argument needed.");
      case 'ob.many_args':
        return c.er1("only accepts 1, 2 and 3 arguments.");
      default:
        return defc;
      }
    }());
    break;
  case 'cap':
    init = (function(){
      switch (eType) {
      case 'validator':
        si = (function(){
          switch (extra) {
          case 2:
            return ",FA";
          case 3:
            return ",F,FA";
          }
        }());
        str = "cap/" + extra + " :: ";
        return lit([str, "FT", si], [c.ok, c.er3, c.ok]);
      case 'lastview':
        return lit(["cap/3 :: FT,", "F", ",FA"], [c.ok, c.er3, c.ok]);
      }
    }());
    comment = defc;
  }
  switch (fname) {
  case 'arcap':
  case 'cap':
  case 'arwh':
    return [init, comment];
  default:
    init = lit([fname + " :: ", init], [c.ok, 0]);
    return [init, defc];
  }
};
print.typeError = function(ta){
  var E, fname, attribute, data, ref$, type_signature, comment, legend, I;
  E = ta[0], fname = ta[1], attribute = ta[2], data = ta[3];
  ref$ = StrEType(fname, attribute), type_signature = ref$[0], comment = ref$[1];
  legend = [" F = function", " PI =  pos_int|[pos_int,...]", " FA = function|any", " FT = function|utilitat.types"];
  legend = (function(){
    var i$, ref$, len$, results$ = [];
    for (i$ = 0, len$ = (ref$ = legend).length; i$ < len$; ++i$) {
      I = ref$[i$];
      results$.push(c.grey(I));
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
  var E, ref$, type, loc, data, type_signature, I;
  E = ta[0], ref$ = ta[1], type = ref$[0], loc = ref$[1], data = ta[2];
  type_signature = StrEType(type, loc)[0];
  l(lit(["[" + pkgname + "]", "[typeError]", " ." + type + "(", "...", ")"], [c.pink, c.er2, c.er2, c.er3, c.er2]));
  l('\n', c.er1((function(){
    var i$, ref$, len$, results$ = [];
    for (i$ = 0, len$ = (ref$ = data.str).length; i$ < len$; ++i$) {
      I = ref$[i$];
      results$.push("." + I + "(~)");
    }
    return results$;
  }()).join("")), '\n\n', type_signature, '\n\n', c.pink("validator function requires return value to be array like."), '\n');
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
print.docstring = "" + c.pink(pkgname) + "\n" + c.grey(help);
function import$(obj, src){
  var own = {}.hasOwnProperty;
  for (var key in src) if (own.call(src, key)) obj[key] = src[key];
  return obj;
}