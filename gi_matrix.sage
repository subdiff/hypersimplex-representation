# Group invariant matrix with vanishing diagonal
class GIMatrix:

    def __init__(self, hypersimplex, subgroup, class_list):
        self.hypersimplex = hypersimplex
        self.group = subgroup
        self.edge_equiv_classes = class_list
        self.dimension = len(hypersimplex.graph.vertices)

        self.variables = self.set_variables_defaults()

        self.multiplicity_matrix = self.create_multiplicity_matrix()

    #
    # TODOX
    #
    def set_variables(self, values):
        # error codes:
        # 0 value count error
        # 1 value summation error
        def report_error(code):
            if code == 0:
                print("set_eec_vars ERROR: Wrong count of values submitted on " + str(values) + ".")
            elif code == 1:
                print("set_eec_vars ERROR: Values " + str(values) + " with multiplicities don't sum up to one.")

        len_target = len(self.edge_equiv_classes)
        if len_target == 1:
            # There is only one possible value, which was already set on construction.
            return

        if len(values) != len_target - 1:
            report_error(0)
            return

        vals = []
        vals_sum = 0
        for index, eec in enumerate(self.edge_equiv_classes):
            multipl = eec.get_multiplicity()
            val = None
            if index < len(values):
                val = values[index]
            else:
                val = (1 - vals_sum) / (multipl ** 2)

            if val <= 0:
                report_error(1)
                return

            vals.append(val)
            vals_sum += val * (multipl ** 2)

        self.variables = vals

    #
    # TODOX
    #
    def set_variables_defaults(self):
        vals = []
        for eec in self.edge_equiv_classes:
            multipl = eec.get_multiplicity()
            vals.append(1 / multipl / self.hypersimplex.graph.degree)
        self.variables = vals
        return self.variables

    #
    # TODOX
    #
    def calculate_eigenvectors(self):
        return


    #
    # private factory
    #
    def create_multiplicity_matrix(self):
        hypers = self.hypersimplex
        matrix = Matrix(RDF,self.dimension)

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
