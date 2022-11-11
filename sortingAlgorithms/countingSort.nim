proc countingSort*[T](x: seq[T]): seq[T] =
  let
    length = x.len
    smax = max(x) 
  var aid = newSeq[T](smax + 1)
  result = newSeq[T](length)
  for i in 0 ..< length:
    aid[x[i]] += 1
  
  aid[0] -= 1
  for i in 1 .. smax:
    aid[i] += aid[i-1]

  for i in countdown(x.high, 0, 1):
    result[aid[x[i]]] = x[i]
    aid[x[i]] -= 1


when isMainModule:
  var x = @[2, 5, 3, 0, 2, 3, 0, 3]
  echo countingSort(x)