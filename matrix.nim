import sequtils


type
  RMatrix*[T] = object
    data: seq[seq[T]]
    rows: int
    cols: int
  CMatrix*[T] {.shallow.}= object
    data: seq[T]
    rows: int
    cols: int
  Matrix*[T] = CMatrix[T]


template checkIndex*(cond: untyped, msg = "") =
  when compileOption("boundChecks"):
    {.line.}:
      if not cond:
        raise newException(IndexError, msg)

proc newRMatrix*[T](rows, cols: Positive): RMatrix[T] {.noinit.} =
  result.rows = rows
  result.cols = cols
  result.data = newSeqWith(cols, newSeqUninitialized[T](rows))

proc newMatrix*[T](rows, cols: Positive): Matrix[T] {.noinit.} =
  result.rows = rows
  result.cols = cols
  result.data = newSeqUninitialized[T](rows * cols)


# proc mapIndex[T](m: seq[T], row, col: Positive): T =
#   for row in 0 ..< rows:
#     for col in 0 ..< cols:
#       result.data[row * cols + col] =

proc newMatrix*[T](x: sink seq[T]; rows, cols: Positive): Matrix[T] =
  checkIndex(rows * cols == x.len)
  result.rows = rows
  result.cols = cols
  result.data = x
  
proc newMatrix*[T](x: sink Matrix[T]): Matrix[T] {.noinit.} =
  checkIndex(rows * cols == x.len)
  result = x

echo newMatrix(@[1, 2, 3, 4], 2, 2)