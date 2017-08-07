# A Hypersimplex defined by its graph.
class Hypersimplex:

    def __init__(self, graph):
        self.graph = graph

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
