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

    def __len__(self):
        return len(self.edges)

    def __getitem__(self, key):
        return self.edges[key]

    def __lt__(self, other):
        if len(self.edges) == 0 or len(other.edges) == 0:
            if len(self.edges) == 0 and len(other.edges) != 0:
                return True
            return False

        return self.edges[0].v.label < self.edges[0].w.label

    def sort_edges(self):
        self.edges.sort(key = lambda edg: edg.v.label + edg.w.label)

    def add_edge(self, edge, do_sort=None):
        if do_sort == None:
            do_sort = True
        do_append = True
        for e in self.edges:
            if e == edge:
                do_append = False
                break

        if do_append:
            self.edges.append(edge)
        if do_sort:
            self.sort_edges()

    def add_edges(self, edge_list):
        for e in edge_list:
            self.add_edge(e, False)
        self.sort_edges()

    # TODOX:
    def fill_edges(self):
        if len(self.edges) == 0:
            return False
        repr = self.edges[0]
        img_list = []
        for g in self.group:
            img_list.append(g.edge_img(repr))

    #
    # TODOX
    #
    def calculate_multiplicity(self):
        mult = 0
        v = self[0].v
        for e in self:
            if v in e:
                mult = mult +1
        self.multiplicity = mult
        return mult

    #
    # TODOX
    #
    def get_multiplicity(self, force_recalc = None):
        if self.multiplicity == 0 or force_recalc == True:
            self.calculate_multiplicity()
        return self.multiplicity
