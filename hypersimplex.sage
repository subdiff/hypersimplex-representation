# A Hypersimplex H(dim,par)
#
# For now directly defined by its graph.
#
class Hypersimplex:

    def __init__(self, dim, par, graph):
        self.dim = dim
        self.par = par
        self.graph = graph
        self.automorph_group = self.create_automorph_group(dim, par)
        self.subgroups = self.automorph_group.subgroups()
        self.vertex_tr_subgroups = None

        self.edge_equiv_classes = [] #TODOX: as dictionary?

        self.description = "A Hypersimplex defined by its graph."

    def __repr__(self):
        return "|||-------------------------|||\n" + "||| Hypersimplex with graph |||\n" + repr(self.graph) + "\n" + "|||-------------------------|||\n" + "|||-------------------------|||"

    def __eq__(self, other):
        # equality test
        if isinstance(other, self.__class__):
            return self.__dict__ == other.__dict__
        return False

    def __ne__(self, other):
        # non-equality test
        return not self.__eq__(other)

    #
    # TODOX
    #
    def get_multiplicity_matrix(self, equiv_classes):
        ret = Matrix(QQ,len(self.graph.vertices))

        def row_worker(i_v, v):
            for i_w, w in enumerate(self.graph.vertices):
                if i_v <= i_w:
                    return
                for c in equiv_classes:
                    multipl = c.get_multiplicity()
                    if Edge(v,w) in c:
                        ret[i_v, i_w] = multipl
                        ret[i_w, i_v] = multipl

        for i_v, v in enumerate(self.graph.vertices):
            row_worker(i_v, v)

        return ret

    #
    # private factory
    #
    def create_edge_equiv_classes(self):
        if self.vertex_tr_subgroups == None:
            print("create_edge_equiv_classes ERROR: First need to calculate vertex transitive subgroups.")
            return
        if self.edge_equiv_classes != []:
            return

        for sub in self.vertex_tr_subgroups:
            classes = self.graph.get_edge_equivalence_classes(sub)
            self.edge_equiv_classes.append((sub, classes))

    #
    # TODOX
    #
    def get_vertex_tr_subgroups(self):
        self.create_vertex_tr_subgroups()
        return self.vertex_tr_subgroups

    #
    # private factory
    #
    def create_vertex_tr_subgroups(self):
        if self.vertex_tr_subgroups != None:
            return

        self.vertex_tr_subgroups = []
        for sub in self.subgroups:
            if QUICK_TEST and sub != hypers.subgroups[62]: # good values for the octahedron are 58, 62
                continue
            if (sub.is_vertex_transitiv(self.graph)):
                self.vertex_tr_subgroups.append(sub)

    #
    # private factory
    #
    def create_automorph_group(self, dim, par):
        sym_group = GroupWrapper(SymmetricGroup(dim))
        if dim != 2 * par:
            return sym_group

        return sym_group.semidirect_product_with_s2()

    def get_edge_classes(sub):
        return self.graph.get_edge_classes(sub)
