var com, z, l, R, j, zj, print_fail, be, p, SA, main, ret, e;
com = require('../../dist/utils/main').com;
z = com.z, l = com.l, R = com.R, j = com.j, zj = com.zj, print_fail = com.print_fail;
be = require('../../dist/types/main');
p = print_fail("test/types/test3.js");
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