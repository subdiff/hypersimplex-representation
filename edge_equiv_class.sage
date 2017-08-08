# Equivalence class of edges for wrapper group.
class EdgeEquivClass:

    def __init__(self, wrapper_group, representative_list = None):
        if representative_list == None:
            self.edges = []
        else:
            self.edges = representative_list

        self.multiplicity = 0
        self.group = wrapper_group
        self.description = "Equivalence class of edges for wrapper group."

    def __repr__(self):
        return str("EEC " + repr(self.edges))

    def __eq__(self, other):
        # equality test
        if isinstance(other, self.__class__):
            for e in self.edges:
                # if self and other already share one edge
                # the equiv classes are the same
                if e in other.edges:
                    return True
            #return self.__dict__ == other.__dict__
        return False

    def __ne__(self, other):
        # non-equality test
        return not self.__eq__(other)


    def __getitem__(self, key):
        return self.edges[key]

    def add_edge(self, edge):
        for e in self.edges:
            if e == edge:
                return
        self.edges.append(edge)
#         self.edges = sorted(self.edges, key=lambda edge: edge.v.label + edge.w.label)
        self.edges.sort(lambda edg: edg.v.label + edg.w.label)

    def add_edges(self, edge_list):
        for e in edge_list:
            self.add_edge(e)

    # TODOX:
    def fill_edges(self):
        if len(self.edges) == 0:
            return False
        repr = self.edges[0]
        img_list = []
        for g in self.group:
            img_list.append(g.edge_img(repr))
