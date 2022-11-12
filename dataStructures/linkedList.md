Single Linked Tables

In this section, we introduce single-linked tables as data structures.
Introduction

A single-linked table is a linear structure that is logically contiguous and discontinuous in its memory storage location. With a single linked table, the insertion and deletion of known nodes can be done with O(1) time complexity.

A single-linked table consists of a single node, each node containing the current element, as well as information about the location of the next node. Similar to a link on a web page, a page contains not only the current information, but also the link to the next page. By means of a pointer or reference, we can transition to the next node, just like browsing a web page.
Introduction to the Nim language

We implement a series of data structures using the Nim language, an efficient and elegant system-level programming language, which can be found on the Nim website.
The basic structure of a single linked table

First a single node is created, each node holds the current information and the location of the next node. In Nim ref is the equivalent of a pointer or reference, we declare the type using type, and an asterisk indicates that the function can be accessed by other modules. t is a generic type in Nim, which means that the function can support any reasonable type, such as int, float, etc. object is similar to a class in an object-oriented language, and can be inherited.

value is the information about the current element, and next is the next node.

```nim
type
  SinglyNodeObj*[T] = object
    value*: T
    next*: ref SinglyNodeObj[T]
  SinglyNode*[T] = ref SinglyNodeObj[T]
```

Let's define a singly linked table with two attributes, node indicates the information about the nodes held in the singly linked table, and lastNode indicates a reference to the end of the singly linked table. Defining a lastNode property allows us to insert nodes at the end of the single-linked table with O(1) time complexity.

```nim
type
  SinglyList*[T] = ref object
    node*: SinglyNode[T]
    lastNode*: SinglyNode[T]
```

Defining functions

We have just defined the underlying data representation of the singly linked table, so let's define the functions that manipulate this data.

First we want to create an empty node, because result is of type ref, so we need to allocate memory to it first, just by new. nim is automatically initialised, assuming elem is of type int, value is initialised to 0, and next is initialised to nil.

Obviously to create an empty node, we just need to assign a value to the result property.

```nim
proc newSinglyNode*[T](elem: T): SinglyNode[T] = 
  new(result)
  result.value = elem
```

Next, we need to create a single-linked table, similar to the assignment variable. We start by creating a first node, which is somewhat different from the subsequent nodes. Logically, we disregard the value attribute of this node and only keep information about the next node, similar to the lastNode, which acts as a sentinel. After that, we let lastNode point to the head node. At this point, an empty single-linked list is created.

```nim
proc newSinglyList*[T](): SinglyList[T] = 
  new(result)
  result.node = SinglyNode[T](next:nil)
  result.lastNode = result.node
```

Next, we look at the head insert node. We create a new node node, make the next attribute of the node node point to the first node, and then make the next attribute of the head node point to the new node.

```
procpend*[T](list: SinglyList[T], elem: T) = 
  var 
    p = list.node
    node = newSinglyNode(elem=elem)
  node.next = p.next
  p.next = node
```

Then, we insert the node at the tail, which is also relatively easy. Create a new node node, make the next attribute of the tail node point to node, and then make the lastNode node point to node.

```nim
proc insert*[T](list: SinglyList[T], elem: T) =
  var 
  	p = list.lastNode
    node = newSinglyNode(elem=elem)
  p.next = node
  list.lastNode = p.next
```

Insert the specified node into a single linked table. First we find the node corresponding to the specified element, then we insert a new node after that node.


```nim
proc find*[T](list: SinglyList[T], elem: T): SinglyNode[T] =
  result = list.node
  while (result ! = nil) and (result.value ! = elem):
    result = result.next
```

```nim
proc insert*[T](list: SinglyList[T], pos: SinglyNode[T], elem: T) =
  if pos.isLast:
    list.insert(elem)
  var p = new SinglyNode[T]
  p.value = elem
  p.next = pos.next
  pos.next = p
```

Delete the first specified element that appears in the singly linked table.

```nim
proc delete*[T](list: SinglyList[T], elem: T) =
  var p = findPrevious[T](list, elem)
  if p == nil: return
  if p.next.isLast:
    list.lastNode = p
    p.next = nil
  if not p.isLast:
    p.next = p.next.next
```

Print the node information.

```nim
proc `$`[T](list: SinglyList[T]): string = 
  while list.isEmpty:
    return "empty"
  var p = list.node.next
  while p ! = nil:
    result &= $p.value & "->" 
    p = p.next 
  result &= "tail"
```

Iterate over the node elements.

```nim
iterator items*[T](list: SinglyList[T]): T = 
  var p = list.node.next
  while p.next ! = nil:
    yield p.value
    p = p.next
```

```nim
iterator pairs*[T](list: SinglyList[T]): tuple[idx: int, value: T] = 
  var 
    p = list.node.next
    idx = 0
  while p.next ! = nil:
    yield (idx, p.value)
    p = p.next    
```

Example
```nim
when isMainModule:
  let a = newSinglyList[int]()
  a.insert(12)
  a.insert(8)
  a.insert(17)
  a.insert(12)
  a.insert(8)
  a.prepend(9)
  a.insert(17)
  let t1 = a.find(17)
  a.insert(t1, 99)
  a.prepend(87)
  a.delete(8)
  a.delete(12)
  echo a
# output 87->9->17->99->12->8->17->tail
```
