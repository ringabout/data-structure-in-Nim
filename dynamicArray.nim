type
  ArrayList*[T] = object
    len, cap: int
    data: ptr UncheckedArray[T]

template checkIndex*(cond: untyped, msg = "") =
  when compileOption("boundChecks"):
    {.line.}:
      if not cond:
        raise newException(IndexError, msg)

proc newArrayList*[T](elems: seq[T]): ArrayList[T] =
  result.cap = elems.len * 2
  result.len = elems.len
  result.data = cast[type(result.data)](alloc(result.cap * sizeof(T)))
  for i in 0 ..< result.len:
    result.data[i] = elems[i]

proc newArrayList*[T](initSize: int = 10): ArrayList[T] =
  result.cap = initSize
  result.len = 0
  result.data = cast[type(result.data)](alloc(result.cap * sizeof(T)))


proc `[]`*[T](x: ArrayList[T], i: Natural): lent T =
  checkIndex(i < x.len)
  x.data[i]

proc `[]=`*[T](x: var ArrayList[T], i: Natural, value: sink T) =
  checkIndex(i < x.len)
  x.data[i] = value

proc `=destroy`*[T](x: var ArrayList[T]) =
  if x.data != nil:
    for i in 0 ..< x.len:
      `=destroy`(x.data[i])
    dealloc(x.data)
    x.data = nil

proc `=`*[T](x: var ArrayList[T], y: ArrayList[T]) =
  # 自身赋值，直接返回
  if x.data == y.data: return
  `=destroy`(x)
  x.len = y.len
  x.cap = y.cap
  if y.data != nil:
    x.data = cast[type(x.data)](alloc(x.cap * sizeof(T)))
    for i in 0 ..< x.len:
      x.data[i] = y.data[i]

proc `=sink`*[T](x: var ArrayList[T], y: ArrayList[T]) =
  # 移动语义
  `=destroy`(x)
  x.len = y.len
  x.cap = y.cap
  x.data = y.data



proc resize*[T](x: var ArrayList[T]) =
  var temp = newArrayList(initSize = x.cap * 2)
  temp.len = x.len
  for i in 0 ..< temp.len:
    temp.data[i] = x.data[i]
  x = temp

proc add*[T](x: var ArrayList[T], value: T) =
  if x.len >= x.cap: resize(x)
  x.data[x.len] = T
  inc(x.len)

proc `$`*[T](x: ArrayList[T]): string =
  result = "ArrayList(["
  if x.len > 0:
    for i in 0 ..< x.len - 1:
      result.add($x.data[i] & ", ")
    result.add($x.data[x.len - 1])
  result.add("])")


proc len*[T](x: ArrayList[T]): int {.inline.} = x.len

when isMainModule:
  var a = newArrayList[int](@[6])
  var b = newArrayList[int](@[1, 2, 3, 4, 5])
  a = b
  echo a.len