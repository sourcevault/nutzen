// Generated by LiveScript 1.6.0
(function(){
  var R, binapi, esp, l, z, noop, util, util_inspect_custom, x$, c, main;
  R = require("ramda");
  binapi = require("binapi");
  esp = require("error-stack-parser");
  l = console.log;
  z = l;
  noop = function(){};
  if (typeof window === "undefined" && typeof module === "object") {
    util = require("util");
    util_inspect_custom = util.inspect.custom;
  } else {
    util_inspect_custom = Symbol['for']("nodejs.util.inspect.custom");
  }
  x$ = c = {};
  x$.ok = function(txt){
    return "\x1B[38;5;2m" + txt + "\x1B[39m";
  };
  x$.er = function(txt){
    return "\x1B[38;5;3m" + txt + "\x1B[39m";
  };
  x$.warn = function(txt){
    return "\x1B[38;5;11m" + txt + "\x1B[39m";
  };
  x$.err = function(txt){
    return "\x1B[38;5;13m" + txt + "\x1B[39m";
  };
  x$.black = function(txt){
    return "\x1B[38;5;8m" + txt + "\x1B[39m";
  };
  main = {
    z: z,
    R: R,
    l: l,
    c: c,
    esp: esp,
    noop: noop,
    binapi: binapi,
    uic: util_inspect_custom
  };
  module.exports = main;
}).call(this);
