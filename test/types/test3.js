var pkg, internal, types, z, l, R, j, print_fail, be, p, inner, SA, main, ret, e;
pkg = require('../../dist/types/main');
internal = pkg.internal, types = pkg.types;
z = internal.z, l = internal.l, R = internal.R, j = internal.j, print_fail = internal.print_fail;
be = types;
p = print_fail("test/types/test3.js");
inner = be.arr.or(be.num);
SA = be.str.or(inner);
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