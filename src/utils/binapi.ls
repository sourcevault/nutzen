{uic,noop,R,z} = require "./common"


generic_log = (state) -> state

veri = (arglen,fun,uget,state,ulog) ->

  switch arglen
  | 0 =>
    l "[argument.error] top level function did not recieve any argument."
    return null

  switch typeof fun
  | \function => 0
  | otherwise =>
    l "[argument.type.error] second argument can only be a function"
    return null

  switch typeof uget
  | \function => 0
  | otherwise =>
    l "[argument.type.error] third argument can only be a function"
    return null

  switch typeof ulog
  | \function => ulog
  | otherwise => generic_log

# -----------------------------------------------

ap = (__,___,args) ->

  @fun @state,args

isA = Array.isArray

get = (__,ukey,___) ->

  switch ukey
  | uic       => return @log @state

  ret = @cache[ukey]

  if ret then return ret

  sortir = @uget @state,ukey

  if isA sortir

    [cont,state] = sortir

    if not cont
      return state
  else

    state = sortir

  data =
   *cache:{}
    log:@log
    fun:@fun
    state:state
    apply:ap
    get:get
    uget:@uget

  P = new Proxy(noop,data)

  @cache[ukey] = P

  return P

pub = (fun,uget,state,ulog) ->

  log = veri arguments.length,fun,uget,state,ulog

  switch log
  | null => return

  data =
    log:log
    fun:fun
    state:state
    uget:uget
    cache:{}
    apply:ap
    get:get

  P = new Proxy(noop,data)

  P

module.exports = pub
