# Group invariant matrix with vanishing diagonal
class GIMatrix:

    def __init__(self, hypersimplex, subgroup, class_list):
        self.hypersimplex = hypersimplex
        self.group = subgroup
        self.edge_equiv_classes = class_list
        self.dimension = len(hypersimplex.graph.vertices)

        self.multiplicity_matrix = self.create_multiplicity_matrix()

    def set_eec_vars(self):
        return

    def calculate_eigenvectors(self):
        return

    #
    # private factory
    #
    def create_multiplicity_matrix(self):
        hypers = self.hypersimplex
        matrix = Matrix(QQ,self.dimension)

        def row_worker(i_v, v):
            for i_w, w in enumerate(hypers.graph.vertices):
                if i_v <= i_w:
                    return
                for c in self.edge_equiv_classes:
                    multipl = c.get_multiplicity()
                    if Edge(v,w) in c:
                        matrix[i_v, i_w] = multipl
                        matrix[i_w, i_v] = multipl

        for i_v, v in enumerate(hypers.graph.vertices):
            row_worker(i_v, v)

        return matrix
