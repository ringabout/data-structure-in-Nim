import random


proc quicksort(list: var seq[int], lo: int, hi: int) =
    # 基准条件
    if lo >= hi:
      return 
    # 选取分位点
    let pivot = rand(lo..hi)
    var
      i = lo + 1
      j = hi
    swap(list[lo], list[pivot])
    var running = true
    while running:
      while list[i] <= list[lo] and i < hi:
        i += 1
      while list[j] >= list[lo] and j > lo:
        j -= 1
      if i < j:
        swap(list[i], list[j])
      else:
        running = false
    swap(list[lo], list[j])
    # 递归求解子问题
    quicksort(list, lo, j - 1)
    quicksort(list, j + 1, hi)




proc quicksort*(list: var seq[int]) = 
  quicksort(list, 0, list.high)

proc QuickSort(list: seq[int]): seq[int] =
  if len(list) == 0:
      return @[]
  var pivot = list[0]
  var left: seq[int] = @[]
  var right: seq[int] = @[]
  for i in low(list)..high(list):
      if list[i] < pivot:
          left.add(list[i])
      elif list[i] > pivot:
          right.add(list[i])
  result = QuickSort(left) &
    pivot &
    QuickSort(right)



when isMainModule:
  import algorithm, sequtils, timeit
  randomize()
  # var a0 = newSeqWith(10000, rand(100000))
  var a0 = toSeq(1 .. 10000000)
  a0.shuffle
  echo a0[1 .. 4]
  var a1 = a0
  var a2 = a0
  timeonce("sort"):
    sort(a0)
  assert a0 != a1
  timeOnce("quick sort"):
    quicksort(a1)
  timeOnce("Quick Sort"):
    let a3 = QuickSort(a2)
  echo a0 == a1
  echo a1 == a3
  echo a3.len
