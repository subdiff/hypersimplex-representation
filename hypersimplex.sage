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
    # private factory
    #
    def create_automorph_group(self, dim, par):
        sym_group = GroupWrapper(SymmetricGroup(dim))
        if dim != 2 * par:
            return sym_group

        return sym_group.semidirect_product_with_s2()
