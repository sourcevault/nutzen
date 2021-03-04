var reg, ref$, z, noops, print_fail, be, p, SA, main, ret, e;
reg = require("../dist/registry");
ref$ = reg.com, z = ref$.z, noops = ref$.noops, print_fail = ref$.print_fail;
be = require("../dist/main");
p = print_fail("test/test3.js");
SA = be.str.or(be.arr.or(be.num));
main = be.obj.on("chokidar", be.obj.on("path", SA));
ret = main.auth({
  chokidar: {}
});
try {
  if (!(ret.path.join(".") === "chokidar.path")) {
    p(".path is mangled");
  }
} catch (e$) {
  e = e$;
  p("something has gone wrong with .path");
}