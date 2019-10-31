
type
  SinglyNodeObj*[T] = object
    value*: T
    next*: ref SinglyNodeObj[T]
  SinglyNode*[T] = ref SinglyNodeObj[T]
  SinglyList*[T] = ref object
    node*: SinglyNode[T]
    lastNode*: ref SinglyNodeObj[T]


proc makeEmpty*[T](list: SinglyList[T]) 
proc isEmpty*[T](list: SinglyList[T]): bool
proc isLast*[T](list: SinglyNode[T]): bool
proc insert*[T](list: SinglyList[T], elem: T) 
proc findPrevious*[T](list: SinglyList[T], elem: T): SinglyNode[T]
proc insert*[T](list: SinglyList[T], pos: SinglyNode[T], elem: T) 
proc delete*[T](list: SinglyList[T], elem: T) 
proc newSinglyNode*[T](elem: T): SinglyNode[T] 
proc newSinglyList*[T](): SinglyList[T]
proc `$`[T](list: SinglyList[T]): string

proc newSinglyNode*[T](elem: T): SinglyNode[T] = 
  new(result)
  result.value = elem

proc newSinglyList*[T](): SinglyList[T] = 
  new(result)
  result.node = SinglyNode[T](next:nil)
  result.lastNode = result.node



proc makeEmpty*[T](list: SinglyList[T]) = 
  if not list.isEmpty:
    list.node.next = nil
    list.lastNode = list.node
  

proc isEmpty*[T](list: SinglyList[T]): bool = 
  return list.node.next == nil

proc isLast*[T](list: SinglyNode[T]): bool =
  return list.next == nil

proc insert*[T](list: SinglyList[T], elem: T) =
  var p = list.lastNode
  var node = newSinglyNode(elem=elem)
  p.next = node
  list.lastNode = p.next



proc find*[T](list: SinglyList[T], elem: T): bool = 
  result = list.node
  while result != nil & result.value != elem:
    result = result.next

proc delete*[T](list: SinglyList[T], elem: T) = 
  var p = findPrevious[T](list, elem)
  if p.next.isLast:
    list.lastNode = p
    p.next = nil

  if not p.isLast:
    p.next = p.next.next

proc findPrevious*[T](list: SinglyList[T], elem: T): SinglyNode[T] = 
  result = list.node
  while result.next != nil and result.next.value != elem:
    result = result.next
  

proc insert*[T](list: SinglyList[T], pos: SinglyNode[T], elem: T) =
  if pos.isLast:
    list.insert(elem)
  var p = new SinglyNode[T]
  p.value = elem
  p.next = pos.next
  pos.next = p

iterator items*[T](list: SinglyList[T]): T = 
  var p = list.node.next
  while p.next != nil:
    yield p.value
    p = p.next

iterator pairs*[T](list: SinglyList[T]): tuple[idx: int, value: T] = 
  var 
    p = list.node.next
    idx = 0
  while p.next != nil:
    yield (idx, p.value)
    p = p.next


proc `$`[T](list: SinglyList[T]): string = 
  while list.isEmpty:
    return "empty"
  var p = list.node.next
  while p != nil:
    result &=  $p.value & "->" 
    p = p.next 
  result &= "tail"


when isMainModule:
  let a = newSinglyList[int]()
  a.insert(12)
  a.insert(8)
  a.insert(17)
  a.insert(12)
  a.insert(8)
  a.insert(17)
  a.delete(8)
  a.delete(12)
  for idx, i in a:
    echo idx, "->", i
  # echo a