var proj, name, pkg, internal, types, guard, l, z, c, binapi, print_fail, create_stack, R, be, xop, pf;
proj = 'guard';
name = 'test7';
pkg = require('../../dist/types/main');
internal = pkg.internal, types = pkg.types, guard = pkg.guard;
l = internal.l, z = internal.z, c = internal.c, binapi = internal.binapi, print_fail = internal.print_fail, create_stack = internal.create_stack, R = internal.R;
be = types;
xop = guard;
pf = print_fail("test/" + proj + "/" + name + ".js");