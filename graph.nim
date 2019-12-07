import streams, strutils, sequtils, strformat


type
  Graph* = object
    data: seq[seq[int]]
    vertex, edge: int
  DepthFirstSearch* = object
    graph: Graph
    marked*: seq[bool]
    count*: int

proc addEdge*(g: var Graph; v, w: int)

proc initGraph*(vertex: int): Graph =
  result.vertex = vertex
  result.data = newSeqWith(vertex, newSeq[int]())

proc initGraph*(file: File): Graph =
  var strm = newFileStream(file)
  let
    vertex = parseInt(strm.readLine)
    edge = parseInt(strm.readLine)
  result = initGraph(vertex)
  for i in 0 ..< edge:
    let
      line = strm.readLine.split
      (v, w) = (line[0].parseInt, line[1].parseInt)
    result.addEdge(v, w)

proc addEdge*(g: var Graph; v, w: int) =
  g.data[v].add(w)
  g.data[w].add(v)
  g.edge += 1

iterator items*(g: Graph; vertex: int): int =
  for item in g.data[vertex]:
    yield item

proc vertex*(g: Graph): int =
  g.vertex

proc edge*(g: Graph): int =
  g.edge

proc degree*(g: Graph; vertex: int): int =
  g.data[vertex].len

proc maxDegree*(g: Graph): int =
  result = g.data[0].len
  for idx in 1 ..< g.vertex:
    result = max(result, g.data[idx].len)

proc avgDegree*(g: Graph): float =
  2.0 * (g.edge / g.vertex)

proc numOfSelfLoops*(g: Graph): int =
  for v in 0 ..< g.vertex:
    for w in g.items(v):
      if v == w: result += 1
  result div 2

proc `$`*(g: Graph): string =
  result.add &"{g.vertex} vertices, {g.edge} edges\n"
  for v in 0 ..< g.vertex:
    result.add &"{v}: "
    for w in g.items(v):
      result.add &"{w} "
    result.add "\n"

proc dfs*(g: var DepthFirstSearch; v: int) =
  g.marked[v] = true
  g.count += 1
  for w in g.graph.items(v):
    if not g.marked[w]: dfs(g, w)

proc marked*(g: DepthFirstSearch; w: int): bool =
  g.marked[w]

proc count*(g: DepthFirstSearch): int =
  g.count

proc initDepthFirstSearch*(g: Graph; s: int): DepthFirstSearch =
  result.graph = g
  result.marked = newSeq[bool](g.vertex)
  dfs(result, s)




var f = open("graph.txt", fmread)
var g = initGraph(f)
echo initDepthFirstSearch(g, 3)
