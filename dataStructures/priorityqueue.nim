import heapqueue


type
  PriorityItem*[T] = tuple
    priority: float
    idx: int
    item: T
  PriorityQueue*[T] = ref object
    data*: HeapQueue[PriorityItem[T]]
    idx: int
    maxQueue: bool

proc `<`*[T](self, other: PriorityItem[T]): bool =
  return (self.priority, self.idx) < (other.priority, other.idx)

proc newPriorityQueue*[T](maxQueue: bool = true): PriorityQueue[T] =
  new result
  result.maxQueue = maxQueue

proc push*[T](p: PriorityQueue[T], item: T, priority: float) =
  if likely(p.maxQueue):
    p.data.push((-priority, p.idx, item))
  else:
    p.data.push((priority, p.idx, item))
  p.idx += 1

proc pop*[T](p: PriorityQueue[T]): T =
  p.data.pop().item

proc len*[T](p: PriorityQueue[T]): int = 
  p.data.len

proc `$`*[T](q: PriorityQueue[T]): string =
  $q.data


when isMainModule:
  type
    Student* = object
      id: int
      name: string
  var s = newPriorityQueue[Student]()
  s.push(Student(id: 12, name: "小张"), 3)
  s.push(Student(id: 12, name: "小李"), 4)
  s.push(Student(id: 12, name: "小王"), 5)
  s.push(Student(id: 12, name: "小周"), 1)
  echo s.pop
  echo s.pop
