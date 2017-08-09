# Wrapper class for a permutation group.
class GroupWrapper:

    def __init__(self, perm_group, create_sdp = None):
        if create_sdp == None:
            create_sdp = False

        self.group = perm_group
        self.generators = perm_group.gens()
        self.factor_generators = self.generators

        self.factored_elements = []

        self.description = "Wrapper for GAP permutation group defined by its generators."
        self.sdp_with_s2 = None

        if create_sdp:
            self.create_semidirect_product()

    def __repr__(self):
        return repr(self.group)

    def __len__(self):
        # non-equality test
        return int(len(self.group))

    def __eq__(self, other):
        # equality test
        if isinstance(other, self.__class__):
            return self.__dict__ == other.__dict__
        return False

    def __ne__(self, other):
        # non-equality test
        return not self.__eq__(other)

    def __getitem__(self, key):
        return self.group.list()[key]

    def as_gap_group(self):
        return gap(self.group)

    def gens(self):
        return self.generators

    def order(self):
        return len(self)

    def list(self):
        return self.group.list()

    def semidirect_product_with_s2(self):
        if self.sdp_with_s2 == None:
            self.create_semidirect_product()
        return self.sdp_with_s2

    def subgroups(self):
        ret = []
        for sub in self.group.subgroups():
            ret.append(Subgroup(sub, self))
        return ret

    def is_vertex_transitiv(self, graph):
        v_list_hit = graph.vertices[:]

        for factored_g in self.get_factorizations():
            img0 = graph.vertex_permutation(factored_g)[0]
            for v in v_list_hit:
                if (img0 == v):
                    v_list_hit.remove(v)
                    break

            if not v_list_hit:
                return True
        return False

    #
    # Returns the GAP generator factorization
    # of a group element as string.
    #
    def factor_str_gap(self, element):
        gap_el = gap(element)
        gap_group = self.as_gap_group()
        return str(gap_group.Factorization( gap_el ))

    #
    # Returns the GAP generator factorization
    # of a list of group element as a list of strings.
    #
    def factor_str_gap_list(self, list):
        ret = []
        for l in list:
            ret.append(self.factor_str_gap(l))
        return ret

    #
    # Returns for a factorized GAP presentation
    # the same on but with all factors written down
    # explicitly.
    #
    @staticmethod
    def factor_lining(fac):
        ret = ""

        if fac[0] == '<': # identity element (only)
            return fac

        i = -1
        while (i < len(fac) - 1) :
            i += 1

            if fac[i] == 'x':
                continue
            if fac[i] == '*':
                continue

            if fac[i] == '^': # read in super script, index i is at '^'
                is_super = False
                i0 = i
                i += 1

                is_inverse = False

                if fac[i] == '-':
                    i += 1
                    is_inverse = True

                str = ""

                while ( i < len(fac) and is_number(fac[i])):
                    str = str + fac[i]
                    i += 1
                num = int(float(str))

                ele = ""

                if is_inverse:
                    ele = "-" + fac[i0 - 2] + fac[i0 - 1]
                else:
                    ele = fac[i0 -2] + fac[i0-1]

                is_inverse = False
                ret = ret + (ele * num)

            else:
                if i < len(fac) - 1 and fac[i+1] == '^':
                    continue
                # char is digit j in xj
                ret = ret + fac[i -1] + fac[i]
            #print(ret) # prints every new element
        return ret

    #
    # An explicitly written down factorization 'factor_string' is
    # returned as a list of group elements.
    #
    # 'generators[0]' must always be the identity element and the
    # identity element in 'factor_string' already identitfiable by
    # the first character.
    #
    def factor_list_lining(self, factor_string):
        i = 0
        ret = []
        gens = self.factor_generators
        comp_list = self.factor_str_gap_list(gens)

        def is_identity():
            c = factor_string[0]
            if c == '-' or c == 'x':
                return False
            return True

        if is_identity():
            return []

        while (i < len(factor_string)):
            c = factor_string[i]

            if (is_number(c)):
                is_inverse = False
                if ( 1 < i and factor_string[i-2] == '-'):
                    is_inverse = True

                for j in range(len(comp_list)):
                    # compare with comp_list and return element
                    # with the same index from gens
                    if (comp_list[j][1] == c):
                        e = gens[j].inverse() if is_inverse else gens[j]
                        ret.append(e)
                        break
                #print(ret) # prints every in between element in the group multiplication
            i += 1
        return ret

    #
    # TODOX
    #
    def factor_lining_for_element(self, g):
        # GAP factor string
        gap_factor_string = self.factor_str_gap(g)
        # as purified text string
        factor_string = self.factor_lining(gap_factor_string)
        # as list of its factors
        factor_list = self.factor_list_lining(factor_string)

        return factor_list
    #
    # TODOX
    #
    def create_factored_elements(self):

        if self.factored_elements != []:
            return

        flist = []
        for g in self.group:
            factor_lined_g = self.factor_lining_for_element(g)
            flist.append(factor_lined_g)
        self.factored_elements = flist

    #
    # TODOX
    #
    def get_factorization(self, g):
        self.create_factored_elements()
        for i_gg, gg in enumerate(self.group):
            if gg == g:
                break
        return self.factored_elements[i_gg]
    #
    # TODOX
    #
    def get_factorizations(self):
        self.create_factored_elements()
        return self.factored_elements

    #
    # private factory
    #
    def create_semidirect_product(self):
        if self.sdp_with_s2 != None:
            return

        def s4automor(g): # returns (1,2)^-1 * g * (1,2)
            return self.group("(1,2)") * g * self.group("(1,2)")

        s2Perm = SymmetricGroup(2)

#         print("Semi-direct product for groups...")
#         print(self),
#         print("and")
#         print(s2Perm)
#         print("with " + u"\u03D5" + "(1 2):"),
#         print(self.gens()),
#         print(u"\u2192"),
#         print(str(map(s4automor, self.gens())) + " is:")

        hom = PermutationGroupMorphism_im_gens(self.group, self.group, map(s4automor, self.generators))
        self.sdp_with_s2 = GroupWrapper(s2Perm.semidirect_product(self.group, [ [s2Perm("(1,2)")], [hom] ]))

#         print(str(self.sdp_with_s2))
#         print
