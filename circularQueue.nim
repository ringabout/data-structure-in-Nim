type
  CircularQueue*[N: static[int], T] = object
    data: array[N+1, T]
    head, tail: int



proc newFixedQueue*[N: static[int], T](): CircularQueue[N, T] =
  discard

proc deQueue*(q: CircularQueue) =
  discard

proc enQueue*(q: CircularQueue) =
  if (q.tail + 1) mod (q.N + 1):



# proc len*(q: FixedQueue): int {.inline.} =
#   q.len