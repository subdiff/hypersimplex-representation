# A graph without loops.
class Graph:

    def __init__(self, vertex_list, edge_list, edges_are_missing_links = None):
        # vertices
        self.vertices = vertex_list[:]

        if edges_are_missing_links == None:
            edges_are_missing_links = False

        # calculate edges
        if edges_are_missing_links:
            self.edges = []
            for v in self.vertices:
                for w in self.vertices:
                    e = Edge(v,w)
                    if v == w:
                        # no loops
                        continue
                    if e in edge_list:
                        # not connected
                        continue
                    if e in self.edges:
                        # already listed
                        continue
                    self.edges.append(e)
        else:
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

    #
    # Returns the vertex 'v' got mapped to
    # under the permutation 'img'.
    #
    def img_of_vertex(self, v, img):
        ret = v
        for i, w in enumerate(img):
            if (w == v):
                return self.vertices[i]
        return ret

    #
    # Returns the edge 'e' got mapped to
    # under the permutation 'img'.
    #
    def img_of_edge(self, e, img):
        img_v = self.img_of_vertex(e.v, img)
        img_w = self.img_of_vertex(e.w, img)

        return Edge(img_v, img_w)

    #
    # Returns list of all edges
    # connected with vertex 'v'.
    #
    def get_edges_to_vertex(self, v):
        v_e_list = []
        for e in self.edges:
            if (v in e):
                v_e_list.append(e)

        return v_e_list

    #
    # Returns list of edge classes of this graph
    #
    def get_edge_classes(self, group):
        # every class is an object of type EdgeEquivClass
        class_list = []

        img_list = []
        for g in group:
            img = self.vertex_permutation(group.get_factorization(g))
            img_list.append(img)

        v_hit_list = []

        for v in self.vertices:
            def test_on_hit(v):
                for w in v_hit_list:
                    if Edge(v,w) in self.edges:
                        return True
                return False

            if test_on_hit(v):
                # we don't need to test vertices which have an edge
                # to a vertex whose edges already have been tested
                continue

            v_hit_list.append(v)

            v_e_list = self.get_edges_to_vertex(v)

            def set_to_class(img_list):
                for c in class_list:
                    for e in c:
                        if e in img_list:
                            c.add_edges(img_list)
                            return
                # class is not yet listed in class_list:
                class_list.append(EdgeEquivClass(group))
                class_list[-1].add_edges(img_list)

            for v_e in v_e_list:
                e_img_list = []
                for g_i, g in enumerate(group):
                    img = img_list[g_i]
                    edge_img = self.img_of_edge(v_e, img)
                    e_img_list.append(edge_img)

                set_to_class(e_img_list)

        for i, c in enumerate(class_list):
            class_list[i] = sorted(c, key=lambda edge: edge.v.label + edge.w.label)

        return class_list

    #
    # Applies to the vertices of the octahedron
    # the permutation 'factorized_g' of GroupWrapper 'group_wrapper'
    #
    # 'factorized_g' needs to be in factorized form according to the
    # generator-permutation connection declared above
    #
    # Returns the permutated vertex list of the graph.
    #
    def vertex_permutation(self, factorized_g):
        ret = self.vertices[:]
        if (len(factorized_g) == 0 or factorized_g[0] == sdp[0]):
            return ret

        g_12_34 = sdp[0]
        g_3456 = sdp[0]
        g_34 = sdp[0]

        g_3456_inv = sdp[0]

        class nonlocal:
            g_3456 = sdp[0]
            g_34 = sdp[0]

        def find_rest(x,y):
            str_x = str(x)

            if (str_x[len(str_x) - 2] == '6'):
                nonlocal.g_3456 = x
                nonlocal.g_34 = y
            else:
                nonlocal.g_3456 = y
                nonlocal.g_34 = x

        if (str(sdp[1])[1] == '1'):
            g_12_34 = sdp[1]
            find_rest(sdp[2], sdp[3])
        elif (str(sdp[2])[1] == '1'):
            g_12_34 = sdp[2]
            find_rest(sdp[1], sdp[3])
        elif (str(sdp[3])[1] == '1'):
            g_12_34 = sdp[3]
            find_rest(sdp[1], sdp[2])
        else:
            print("vertex_homo ERROR: Didn't find first sdp element")

        g_3456 = nonlocal.g_3456
        g_34 = nonlocal.g_34

        g_3456_inverse = g_3456.inverse()

        for f in factorized_g:
            if (f == g_12_34):
                ret = g_12_34_vertex(ret)
            elif (f == g_3456):
                ret = g_3456_vertex(ret)
            elif (f == g_34):
                ret = g_34_vertex(ret)
            elif (f == g_3456_inverse):
                ret = g_3456_inverse_vertex(ret)
            else:
                print("vertex_homo ERROR: Couldn't associate vertex mapping.")
        return ret

