class GraphNode {

  var data: String
  var neighboringNodes: [GraphNode]
  
  init(data: String) {
    self.data = data
    neighboringNodes = []
  }
  
  func addNeighbor(_ newNeighbor: GraphNode) {
      neighboringNodes.append(newNeighbor)
  }
  
  func removeNeighbor(_ nodeToRemove: GraphNode) {
    if let index = neighboringNodes.firstIndex(where: { $0 == nodeToRemove }) {
      neighboringNodes.remove(at: index)
    }
  }
}
extension GraphNode: Equatable {
  static func == (lhs: GraphNode, rhs: GraphNode) -> Bool {
      return lhs === rhs
  }
}
extension GraphNode: CustomStringConvertible {
  var description: String {
      return "\(data)"
  }
}

struct GraphEdge {
  let nodeOne: GraphNode
  let nodeTwo: GraphNode
  var weight: Int? = nil
  
  init(nodeOne: GraphNode, nodeTwo: GraphNode, weight: Int?) {
    self.nodeOne = nodeOne
    self.nodeTwo = nodeTwo
    self.weight = weight
  }
}

class Graph {
  var nodes: [GraphNode]
  var edges: [GraphEdge]
    
  init(nodes: [GraphNode]) {
    self.nodes = nodes
    edges = []
  }
  
  func addEdge(from nodeOne: GraphNode, to nodeTwo: GraphNode, isBidirectional: Bool, weight: Int? = nil) {
    edges.append(GraphEdge(nodeOne: nodeOne, nodeTwo: nodeTwo, weight: weight))
    nodeOne.addNeighbor(nodeTwo)
    if isBidirectional {
      nodeTwo.addNeighbor(nodeOne)
    }
  }
  
  func addEdges(from nodeOne: GraphNode, to neighboringNodes: [(node: GraphNode, isBidirectional: Bool, weight: Int?)]) {
    for (node, isBidirectional, weight) in neighboringNodes {
      addEdge(from: nodeOne, to: node, isBidirectional: isBidirectional, weight: weight)
    }
  }
  
  func removeNode(_ node: GraphNode) {
    if let index = nodes.firstIndex(where: { $0 == node }) {
      nodes.remove(at: index)
    }
    
    edges = edges.filter({ $0.nodeOne != node || $0.nodeTwo != node })
    node.neighboringNodes.forEach { $0.removeNeighbor(node) }
  }
  
  func printGraph() {
    for node in nodes {
      Swift.print("\(node): \(node.neighboringNodes)")
    }
  }


  func bfs(startingAt startNode: GraphNode) -> [GraphNode] {
    var queue = Queue<GraphNode>()
    queue.enqueue(startNode)
    var visitedNodes = [GraphNode]()
    while let currentNode = queue.dequeue() {
      if !visitedNodes.contains(currentNode) {
        visitedNodes.append(currentNode)
      }
      // Your code here:
      for neighbor in currentNode.neighboringNodes where !visitedNodes.contains(neighbor){
        queue.enqueue(neighbor)
      }
    }
    return visitedNodes
  }
}

class QueueNode<Element: Equatable> {
  var data: Element
  var next: QueueNode<Element>?
  
  init(data: Element) {
    self.data = data
  }
}

struct Queue<Element: Equatable> {
  var head: QueueNode<Element>?
  var tail: QueueNode<Element>?
  
  func peek() -> Element? {
    return head?.data
  }
  
  mutating func enqueue(_ data: Element) {
    let newNode = QueueNode(data: data)
    
    guard let lastNode = tail else {
      head = newNode
      tail = newNode
      return
    }
    
    lastNode.next = newNode
    tail = newNode
  }
  
  mutating func dequeue() -> Element? {
    var removedNode: Element?
    
    if let firstNode = head {
      removedNode = firstNode.data
    }
    if head === tail {
      tail = nil
    }
    head = head?.next
    return removedNode
  }
}


let node1 = GraphNode(data: "1")
let node11 = GraphNode(data: "11")
let node12 = GraphNode(data: "12")
let node111 = GraphNode(data: "111")
let node112 = GraphNode(data: "112")

let graph = Graph(nodes: [node1, node11, node12, node112, node111])
graph.addEdge(from: node1, to: node11, isBidirectional: true)
graph.addEdge(from: node1, to: node12, isBidirectional: true)
graph.addEdge(from: node11, to: node111, isBidirectional: true)
graph.addEdge(from: node11, to: node112, isBidirectional: true)
graph.addEdge(from: node1, to: node112, isBidirectional: true)
graph.printGraph()

let bfs = graph.bfs(startingAt: node1)
print(bfs)
