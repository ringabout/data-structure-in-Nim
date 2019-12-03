import hashes
import lists


type 
  KeyPair*[K, V] = tuple
    key: K
    value: V
  KeyPairNode*[K, V] = SinglyLinkedNode[KeyPair[K, V]]
  HashTable*[K, V] = object
    data: seq[KeyPairNode[K, V]]
    tableSize: int


proc initHashTable*[K, V](tableSize: int=997): HashTable[K, V] =
  var data = newSeq[KeyPairNode[K, V]](tableSize)
  for idx in 0 ..< data.len:
    new data[idx]
  result = HashTable[K, V](data: data, tableSize: tableSize)


proc hashString*(x: string, tableSize: int): Hash = 
  for i in 0 ..< x.len:
    result += result shl 5 + ord(x[i])
  result = result mod tableSize

proc hash*[K, V](t: HashTable[K, V], key: K): Hash =
  (hash(key) and 0x7fffffff) mod t.tableSize

proc put*[K, V](t: HashTable[K, V], key: K, value: V) =
  let pos = hash(t, key)
  var 
    header = t.data[pos]
    findNode = header.next
  while findNode != nil:
    if findNode.value[0] == key:
      findNode.value[1] = value
      return
    findNode = findNode.next
  var node = newSinglyLinkedNode[KeyPair[K, V]]((key, value))
  node.next = header.next
  header.next = node

proc get*[K, V](t: HashTable[K, V], key: K): V =
  let pos = hash(t, key)
  var header = t.data[pos]
  var findNode = header.next
  while findNode != nil:
    if findNode.value[0] == key:
      return findNode.value[1]
    findNode = findNode.next
  raise newException(KeyError, "not find")

proc delete*[K, V](t: HashTable[K, V], key: K) =
  let pos = hash(t, key)
  var header = t.data[pos]
  var node = header
  while node.next != nil:
    if node.next.value[0] == key:
      node.next = node.next.next
      return
    node = node.next


when isMainModule:
  var a = initHashTable[int, string]()
  a.put(1, "e")
  a.put(234, "wd")
  a.put(234, "pick")
  a.delete(234)
  a.put(234, "dance")
  echo a.get(234)
  echo a.data[234..237].repr


