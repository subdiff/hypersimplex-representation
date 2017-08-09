class Subgroup(GroupWrapper):
    def __init__(self, perm_group, parent_group):
        self.parent = parent_group
        GroupWrapper.__init__(self, perm_group, False)

        # In subgroups we want to still always factor the
        # elements with the generators of the parent group
        self.factor_generators = self.parent.generators

    def create_factored_elements(self):
        if self.factored_elements != []:
            return

        flist = []
        for g in self.group:
            factor_lined_g = self.parent.get_factorization(g)
            flist.append(factor_lined_g)
        self.factored_elements = flist
