bko = be.known.obj

check_if_remote_not_defined = bko
.on \remote,be.arr.and be.not zero
.and do
  bko.on \remotehost,be.undefnull
  .or do
    bko.on \remotefold,be.undefnull
.cont true
.fix false
.wrap!


bko.or be.known.obj
.on do
  *[\and,\remote,(be.arr.and be.not zero)]
   [\alt,[\remotefold,\remotehost],be.undefnull]

.cont true


bko.or be.known.obj
.on do
  *[\and,\remote,(be.arr.and be.not zero)]
   # [\alt,[\remotefold,\remotehost],be.undefnull]
   [\alt,\remotefold,be.undefnull]

.cont true



bko.or be.known.obj


.on do
  *[\and,\remote,(be.arr.and be.not zero)]
   [\alt,[\remotefold,\remotehost],be.undefnull]

.cont true

