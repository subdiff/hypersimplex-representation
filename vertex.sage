# A vertex.
class Vertex:

    def __init__(self, label):
        self.label = label
        self.description = "A vertex identified by its label."

    def __repr__(self):
        return repr(self.label)

    def __eq__(self, other):
        # equality test
        if isinstance(other, self.__class__):
            return self.__dict__ == other.__dict__
        return False

    def __ne__(self, other):
        # non-equality test
        return not self.__eq__(other)
