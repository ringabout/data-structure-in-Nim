type
  CircularQueue*[N: static[int], T] = object
    data: array[N, T]
    head, tail: int

proc newCircularQueue*[N: static[int], T](): CircularQueue[N, T] =
  discard

func isFull*(q: CircularQueue): bool {.inline.} =
  abs(q.tail-q.head) == q.N

func isEmpty*(q: CircularQueue): bool {.inline.} =
  q.tail == q.head

proc deQueue*[N: static[int], T](q:var CircularQueue[N, T]):owned T =
  if q.isEmpty:
    echo "队列已空"
    return
  if q.head < q.N:
    result = move q.data[q.head]
  else:
    result = move q.data[q.head-q.N]
  q.head += 1
  if q.head == 2 * q.N:
    q.head = 0

proc peekQueue*[N: static[int], T](q:var CircularQueue[N, T]):lent T =
  if q.isEmpty:
    echo "队列已空"
    return
  if q.head < q.N:
    result = q.data[q.head]
  else:
    result = q.data[q.head-q.N]

proc enQueue*[N: static[int], T](q: var CircularQueue[N, T], v: sink T) =
  if q.isFull:
    echo "队列已满"
    return
  if q.tail < q.N:
    q.data[q.tail] = v
  else:
    q.data[q.tail-q.N] = v
  q.tail += 1
  if q.tail == 2 * q.N:
    q.tail = 0


proc len*(q: CircularQueue): int {.inline.} =
  result = q.tail - q.head
  while result < 0:
    result += q.N


var c = newCircularQueue[10, int]()
for i in 1 .. 10:
  c.enQueue(i)
  echo c
for i in 1 .. 10:
  discard c.deQueue
  echo c
for i in 1 .. 10:
  c.enQueue(i)
  echo c
for i in 1 .. 8:
  discard c.deQueue
  echo c

echo c.peekQueue
echo c.deQueue
echo c.data
echo c.len
