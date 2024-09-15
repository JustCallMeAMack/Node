class GraphNode {
    
  var data: String
  var neighboringNodes: [GraphNode]
  
  init(data: String) {
      self.data = data
      self.neighboringNodes = []
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
  
  init(nodeOne: GraphNode, nodeTwo: GraphNode, weight: Int? = nil) {
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

  func addEdge(from nodeOne: GraphNode, 
               to nodeTwo: GraphNode, 
               isBidirectional: Bool = true,
               weight: Int? = nil) {
    edges.append(GraphEdge(nodeOne: nodeOne, nodeTwo: nodeTwo, weight: weight))
    nodeOne.addNeighbor(nodeTwo)
    if(isBidirectional==true) {
      edges.append(GraphEdge(nodeOne: nodeTwo, nodeTwo: nodeOne, weight: weight))
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
    
    edges = edges.filter { $0.nodeOne != node || $0.nodeTwo != node }
    nodes.forEach { $0.removeNeighbor(node) }
  }
  
  func printGraph() {
    for node in nodes {
      Swift.print("\(node): \(node.neighboringNodes)")
    }
  }
}

// Your code here:
let atlanta = GraphNode(data: "Atlanta")
let newYork = GraphNode(data: "New York")
let chicago = GraphNode(data: "Chicago")
let orlando = GraphNode(data: "Orlando")
let losAngeles = GraphNode(data: "Los Angeles")
let graph = Graph(nodes: [atlanta, newYork, chicago, orlando, losAngeles])
graph.addEdges(from: atlanta, to: [(node: newYork, isBidirectional: false, weight: 250), (node: orlando, isBidirectional: false, weight: 80)])
graph.addEdges(from: orlando, to: [(node: atlanta, isBidirectional: false, weight: 100), (node: newYork, isBidirectional: false, weight: 400), (node: chicago, isBidirectional: false, weight: 200)])
graph.addEdges(from: losAngeles, to: [(node: chicago, isBidirectional: false, weight: 125), (node: atlanta, isBidirectional: false, weight: 250)])
graph.addEdges(from: chicago, to: [(node: newYork, isBidirectional: false, weight: 190)])
graph.addEdges(from: newYork, to: [(node: losAngeles, isBidirectional: false, weight: 400), (node: atlanta, isBidirectional: false, weight: 200)])
graph.printGraph()
