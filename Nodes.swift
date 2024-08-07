class Node {
  var data: String
  var next: Node?

  init(data: String) {
    self.data = data
  }
}

extension Node: CustomStringConvertible {
  var description: String {
    return data + " -> " + (next?.description ?? "nil")
  }
}

class LinkedList {
  var head: Node?
  var tail: Node?

  func append(_ data: String) {
    let newNode = Node(data: data)
    if let lastNode = tail {
      lastNode.next = newNode
    } else {
      head = newNode
    }
    tail = newNode
  }

  func getNode(at index: Int) -> Node? {
    guard index >= 0 else { return nil }
    var current = head

    for _ in 0..<index {
      guard let next = current?.next else { return nil }
      current = next
    }
    return current
  }

  // Add your function here
  func removeNode(from index: Int) -> Node? {
    var removedNode: Node?
    guard index >= 0 else{return nil}
    if index == 0 {
      removedNode = head
      head = head?.next
      if head == nil {
        tail = nil
      }
      return removedNode
    }
    guard let previous = getNode(at: index - 1) else{return nil}
    removedNode = previous.next
    if removedNode?.next == nil {
      tail = previous
    }
    previous.next = removedNode?.next
    return removedNode
  }
}

extension LinkedList: CustomStringConvertible {
  var description: String {
    return head?.description ?? "nil"
  }
}

let germanCars = LinkedList()
germanCars.append("Volkswagen")
germanCars.append("Porsche")
germanCars.append("Audi")
print(germanCars)
// Add your call to your function here
let removedNode = germanCars.removeNode(from: 2)
// Add your print statement here
print(germanCars)
    
