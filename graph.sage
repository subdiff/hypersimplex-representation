# A graph without loops.
class Graph:

    def __init__(self, vertex_list, edge_list):
        self.vertices = vertex_list[:]
        self.edges = edge_list[:]
        self.description = "A graph defined by vertices and edges."

    def __repr__(self):
        return "|-- Graph --" + "\n|-----------\n" + "| Vertices: " + repr(self.vertices) + "\n| Edges:    " + repr(self.edges) + "\n|-----------"

    def __eq__(self, other):
        # equality test
        if isinstance(other, self.__class__):
            return self.__dict__ == other.__dict__
        return False

    def __ne__(self, other):
        # non-equality test
        return not self.__eq__(other)
