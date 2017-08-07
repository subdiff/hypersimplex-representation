# An edge between two vertices.
class Edge:

    def __init__(self, v, w):
        if (v.label <= w.label):
            self.v = v
            self.w = w
        else:
            self.v = w
            self.w = v
        self.description = "An edge between two vertices."

    def __repr__(self):
        return repr(self.v) + "--" + repr(self.w)

    def __eq__(self, other):
        # equality test
        if isinstance(other, self.__class__):
            return self.__dict__ == other.__dict__
        return False

    def __ne__(self, other):
        # non-equality test
        return not self.__eq__(other)

    def __contains__(self, vertex):
        return vertex == self.v or vertex == self.w
