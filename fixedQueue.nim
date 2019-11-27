import lists


type
  FixedQueue*[T] = object
    data: SinglyLinkedList[T]
    len: int
    size: int

proc newFixedQueue*[T](size: int=10): FixedQueue[T] =
  result.data = initSinglyLinkedList[T]()
  result.size = size
  result.len = 0

proc enQueue*[T](q: var FixedQueue[T], value: T) =
  var node = newSinglyLinkedNode[T](value)
  if q.len >= q.size:
    q.data.head = q.data.head.next
  else:
    q.len += 1 
  q.data.append(node)

proc enQueue*(q: var FixedQueue[string], file: File) =
  for line in file.lines:
    q.enQueue(line)

proc deQueue*[T](q: var FixedQueue[T]): T =
  q.data.head = q.data.head.next
  q.len -= 1


# Interger
var a = newFixedQueue[int]()
for i in 1 .. 35:
  a.enQueue(i)
echo a.data

# File
import os
from strformat import fmt

let file = getTempDir() / "temp.txt"
var f = open(file, fmReadWrite)
for i in 1 .. 100:
  write(f, fmt"line {i}" & "\n")
f.setFilePos(0)

var b = newFixedQueue[string](10)
b.enQueue(f)
echo b
f.close()