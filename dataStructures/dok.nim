import tables

type
  Matrix* = object
    data*: seq[seq[float]]
    rows*: int
    cols*: int
  Vector* = seq[float]
  SparseMatrix* = object
    data*: Table[(int, int), float]

proc newVector*(size: int): Vector =
  newSeq[float](size)

proc newSparseMatrix*(): SparseMatrix =
  discard

proc newSparseMatrix*(m: Matrix): SparseMatrix =
  for i in 0 ..< m.rows:
    for j in 0 ..< m.cols:
      let value = m.data[i][j]
      if value != 0:
        result.data[(i, j)] = value

proc len*(s: SparseMatrix): int =
  s.data.len

proc `[]`*(s: SparseMatrix, idx: (int, int)): float =
  if idx in s.data:
    s.data[idx]
  else:
    0.0

proc `[]`*(s: SparseMatrix, idx: Slice[int]): float =
  let idx = (idx.a, idx.b)
  if idx in s.data:
    s.data[idx]
  else:
    0.0

proc `*`*(s: SparseMatrix, v: Vector): Vector =
  result = newVector(v.len)
  for idx, value in s.data:
    result[idx[0]] += v[idx[1]] * s[idx]

when isMainModule:
  let m = Matrix(data: @[@[0.0, 0.90, 0.0, 0.0, 0.0], @[0.0, 0.0, 0.36, 0.36, 0.18],
                      @[0.0, 0.0, 0.0, 0.90, 0.0], @[0.90, 0.0, 0.0, 0.0, 0.0],
                          @[0.47, 0.0, 0.47, 0.0, 0.0]], rows: 5, cols: 5)
  let s = newSparseMatrix(m)
  let v: Vector = @[0.05, 0.04, 0.36, 0.37, 0.19]
  echo s * v

