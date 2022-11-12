import priorityqueue, sequtils, tables, streams, bitops


type
  TreeObj* = object
    left*: ref TreeObj
    right*: ref TreeObj
    value*: char
    priority*: float
  Tree* = ref TreeObj

  Bit = object
    mark: int
    value: uint8

var wBit = Bit(mark: 0, value: 0)
var rBit = Bit(mark: 0, value: 0)


proc newTree*(left: Tree = nil, right: Tree = nil, value: char = '\0',
    priority: float = 0.0): Tree =
  Tree(left: left, right: right, value: value, priority: priority)

proc `$`(t: Tree): string =
  result = $t.value
  if not t.left.isNil:
    result.add($t.left)
  if not t.right.isNil:
    result.add($t.right)

proc isLeaf*(t: Tree): bool =
  return t.left.isNil and t.right.isNil

proc buildTable*(t: Tree, st: var Table[char, string], s: string) =
  if t.isLeaf:
    st[t.value] = s
    return
  buildTable(t.left, st, s & "0")
  buildTable(t.right, st, s & "1")

proc buildTable*(t: Tree): Table[char, string] =
  var
    st: Table[char, string]
    s: string
  buildTable(t, st, s)
  return st

proc writeBit(s: Stream, value: bool) =
  if wbit.mark < 7:
    if value:
      setBit(wbit.value, 7 - wbit.mark)
    wbit.mark += 1
  else:
    if value:
      setBit(wbit.value, 7 - wbit.mark)
    s.write(wbit.value)
    wbit.mark = 0
    wbit.value = 0

proc writeBit(s: Stream, value: char) = 
  if wbit.mark > 0:
    s.write(wbit.value)
    wbit.mark = 0
    wbit.value = 0
  s.write(value)

proc writeTrie*(s: Stream, t: Tree) =
  if t.isLeaf:
    s.writeBit(true)
    s.writeBit(t.value)
    return
  s.writeBit(false)
  writeTrie(s, t.left)
  writeTrie(s, t.right)

proc writeCode*(s: Stream, text: string, tree: Tree, lookup: Table[char, string]) =
  writeTrie(s, tree)
  if wBit.mark > 0:
    s.write(wBit.value)
    wBit.mark = 0
    wBit.value = 0
  s.write(int32(text.len))
  for item in text:
    let code = lookup[item]
    for c in code:
      if c == '1':
        s.writeBit(true)
      else:
        s.writeBit(false)
  if wBit.mark > 0:
    s.write(wbit.value)
    wBit.value = 0
    wBit.mark = 0

proc readTrie*(s: Stream): Tree =
  if rBit.mark == 0:
    rBit.value = s.readUint8
  if testBit(rBit.value, 7 - rBit.mark):
    rBit.mark = 0
    return newTree(value = s.readChar)
  else:
    rBit.mark += 1
    if rBit.mark == 8:
      rBit.mark = 0
    return newTree(readTrie(s), readTrie(s))

proc readHuffmanBit(s: Stream, node: var Tree, res: var string, root: Tree) =
  for i in 0 .. 7:
    if node.isNil:
      return
    if testBit(rBit.value, 7 - i):
      node = node.right
    else:
      node = node.left
    if node.isLeaf:
      res.add(node.value)
      node = root

proc readHuffman*(s: Stream): string =
  let
    root = s.readTrie
    n = s.readInt32

  var node = root
  result = newStringOfCap(n)
  while not s.atEnd:
    rBit.value = s.readUint8
    readHuffmanBit(s, node, result, root)


proc readHuffman*(s: string = "input.txt"): string =
  var strm = newFileStream(s, fmRead)
  readHuffman(strm)

proc huffman*(text: string, path = "output.txt") =
  if text.len == 0:
    return
  var
    s = newPriorityQueue[Tree](maxQueue = false)
    counter = toCountTable(text)
  for k, v in counter:
    s.push(Tree(value: k, priority: float(v)), float(v))
  while s.len > 1:
    let
      t1 = s.pop
      t2 = s.pop
    s.push(newTree(t1, t2, '\0', t1.priority + t2.priority), t1.priority + t2.priority)
  let tree = s.pop
  let dict = buildTable(tree)
  var output: string
  for c in text:
    output.add(dict[c])
  var strm = newFileStream(path, fmWrite)
  defer: strm.close()
  writeCode(strm, text, tree, dict)


when isMainModule:
  import random, os
  randomize(1024)
  var
    n = 1000
    res: string = newString(n)
    letters = toSeq('a' .. 'z')
  for i in 0 ..< n:
    res[i] = sample(letters)
  res = "ABRACADABRA!"
  var input = newFileStream("input.txt", fmRead)
  let text = input.readAll
  huffman(text)
  input.close()
  var strm = newFileStream("output.txt", fmRead)
  let output = readHuffman(strm)
  echo text == output
  echo os.getFileSize("input.txt")
  echo os.getFileSize("output.txt")
  strm.close()
