// Generated by LiveScript 1.6.0
(function(){
  var reg, Benchmark, suite, wait, com, print, hoplon, z, l, binapi, R, betterTypeof, p, hop, type_num, type_str, V, A, W;
  reg = require("../dist/registry");
  require("../dist/main");
  Benchmark = require("benchmark");
  suite = new Benchmark.Suite;
  wait = function(t, f){
    return setTimeout(f, t);
  };
  com = reg.com, print = reg.print, hoplon = reg.hoplon;
  z = com.z, l = com.l, binapi = com.binapi, R = com.R;
  betterTypeof = reg.betterTypeof;
  p = print.fail('test5.js');
  hop = hoplon;
  type_num = function(x){
    switch (x) {
    case 'integer':
      return 0;
    case 'boolean':
      return 1;
    default:
      return false;
    }
  };
  type_str = function(x){
    switch (x) {
    case 'string':
      return 3;
    default:
      return false;
    }
  };
  V = hop.ar(1, hop.ma(type_str, type_num).def(4));
  A = ['integer', 'boolean', 'bill', 'string', 'obama', 'arena'];
  W = V.wrap();
  wait(500, function(){
    return suite.add('pipe', function(){
      var I, i$, K, results$ = [];
      I = 0;
      for (i$ = 0; i$ <= 100; ++i$) {
        K = i$;
        results$.push(I += V.pipe(A[Math.round((A.length - 1) * Math.random())]));
      }
      return results$;
    }).add('wrap', function(){
      var I, i$, K, results$ = [];
      I = 0;
      for (i$ = 0; i$ <= 100; ++i$) {
        K = i$;
        results$.push(I += W(A[Math.round((A.length - 1) * Math.random())]));
      }
      return results$;
    }).on('cycle', function(e){
      return l(String(e.target));
    });
  });
}).call(this);
