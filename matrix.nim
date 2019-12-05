import sequtils


type
  RMatrix*[T] = object
    data: seq[seq[T]]
    rows: int
    cols: int
  CMatrix*[T] = object
    data: seq[T]
    rows: int
    cols: int

proc newRMatrix*[T](rows, cols: int): RMatrix[T] {.noinit.} =
  result.rows = rows
  result.cols = cols
  result.data = newSeqWith(cols, newSeqUninitialized[T](rows))

proc newCMatrix*[T](rows, cols: int): CMatrix[T] {.noinit.} =
  result.rows = rows
  result.cols = cols
  result.data = newSeqUninitialized[T](rows * cols)

