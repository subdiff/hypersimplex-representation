# Wrapper class for a permutation group.
class GroupWrapper:

    def __init__(self, perm_group, create_sdp = None):
        if create_sdp == None:
            create_sdp = False

        self.group = perm_group
        self.gap_group = None
        self.generators = perm_group.gens()

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
        return self.group[key]

    def as_gap_group(self):
        if self.gap_group == None:
            self.gap_group = gap(self.group)
        return self.gap_group

    def gens(self):
        return self.generators

    def order(self):
        return len(self)

    def list(self):
        return self.group.list()

    def semidirect_product(self):
        if self.sdp_with_s2 == None:
            create_semidirect_product(self)
        return self.sdp_with_s2

    def subgroups(self):
        return self.group.subgroups()

    #
    # factory
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


