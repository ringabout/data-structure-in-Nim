import std/[random, sequtils, algorithm]

# three
proc shellSort*[T](x: var openArray[T]) =
  let length = len(x)
  var size = 1
  while size < length:
    size *= 3 + 1
  while size >= 1:
    for i in size ..< length:
      let temp = x[i]
      for j in countdown(i, size, size):
        if x[j - size] > temp:
          x[j] = x[j - size]
        else:
          x[j] = temp
          break
    size = size div 3

when isMainModule:
  randomize()
  var x = newSeqWith(1000, rand(0 .. 100000000))
  shellSort(x)
  echo isSorted(x)
