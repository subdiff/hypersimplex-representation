# H(4,2) - Octahedron automorphism group
import sys, time, threading
##
# TODO: This means that currently it's necessary that sage is run from the script's location
load("edge.sage")
load("vertex.sage")
load("graph.sage")
load("hypersimplex.sage")
load("group_wrapper.sage")
load("subgroup.sage")
load("edge_equiv_class.sage")
load("helpers.sage")
load("gi_matrix.sage")
##

# For development switch off
# release features
DEV_BUILD = True

if DEV_BUILD:
    # wait in between sections for few seconds
    SECTION_WAIT = False
    # skip long computations by using single samples
    QUICK_TEST = False

#################
## MAIN OUTPUT ##
#################
SECTION("Hypersimplex configuration", 0)

hypers = Hypersimplex(4, 2,
            Graph(
            # vertices
            [Vertex('A'),Vertex('B'), Vertex('C'), Vertex('D'), Vertex('E'), Vertex('F')],
            # non-edges
            [Edge(Vertex('A'),Vertex('C')), Edge(Vertex('B'),Vertex('D')), Edge(Vertex('E'),Vertex('F'))],
            True)
            )
print(hypers)

############################## NEXT SECTION ##############################
SECTION_SLEEP(3)
SECTION("Automorphism group")

print(hypers.automorph_group)
print("Finitely presented:"),
print(str(hypers.automorph_group.group.as_finitely_presented_group())[len("Finitely presented group"):])

print("Group size:"),
print(hypers.automorph_group.order())

############################## NEXT SECTION ##############################
SECTION("Group generators as vertex permutations")

# declare permutations
def g_3456_vertex(vl): #input is vertex list
    return [vl[1], vl[2], vl[3], vl[0], vl[4], vl[5]]

def g_34_vertex(vl): #input is vertex list
    return [vl[2], vl[4], vl[0], vl[5], vl[1], vl[3]]

def g_12_34_vertex(vl): #input is vertex list
    return [vl[0], vl[5], vl[2], vl[4], vl[3], vl[1]]

def g_3456_inverse_vertex(vl): #input is vertex list
    return [vl[3], vl[0], vl[1], vl[2], vl[4], vl[5]]

# relate group generators to permutations
def gen_to_perm_fct(generator):
    str_gen = str(generator)

    if str_gen == "(1,2)(3,4)":
        return (g_12_34_vertex, g_12_34_vertex)

    if str_gen == "(3,4,5,6)":
        return (g_3456_vertex, g_3456_inverse_vertex)

    if str_gen == "(3,4)":
        return (g_34_vertex, g_34_vertex)

    print("gen_to_perm_fct ERROR: Couldn't associate generator element.")
    return ()

# define generator permutations on graph
hypers.graph.set_generator_permutations(hypers.automorph_group, gen_to_perm_fct)

print("(1 2)(3 4):"),
print(hypers.graph.generator_permutations[hypers.automorph_group[2]](hypers.graph.vertices))
print("(3 4 5 6):"),
print(hypers.graph.generator_permutations[hypers.automorph_group[1]](hypers.graph.vertices))
print("(3 4):"),
print(hypers.graph.generator_permutations[hypers.automorph_group[3]](hypers.graph.vertices))

############################## NEXT SECTION ##############################
SECTION("Subgroups")

print("There are"),
print(len(hypers.subgroups)),
print("subgroups in total.")

############################## NEXT SECTION ##############################
SECTION("Vertex transitive subgroups")
###
### calculating vertex transitive subgroups
###
animation = WaitAnimation("Calculating vertex transitive subgroups")
animation.start()
hypers.create_vertex_tr_subgroups()
animation.stop()

print("Found"),
print(len(hypers.vertex_tr_subgroups)),
print("vertex transitive subgroups:")
for index_sub, sub in enumerate(hypers.vertex_tr_subgroups):
    print(str(index_sub +1).zfill(2) + ":"),
    print(sub.gens())

############################## NEXT SECTION ##############################
SECTION_SLEEP(2)
SECTION("Edge equivalence classes")

# edge_equiv_classes_for_sub = []

hypers.create_edge_equiv_classes()

for index, sub_edges in enumerate(hypers.edge_equiv_classes):
    if index_sub > 0:
        print
    sub = sub_edges[0]
    class_list = sub_edges[1]

    print("Permutations:")
    for g in sub:
        print(hypers.graph.vertex_permutation(sub.get_factorization(g)))

    len_class_list = len(class_list)
    print(len_class_list),
    if (len_class_list == 1):
        print("edge equivalence class:")
    else:
        print("edge equivalence classes:")

    for i, c in enumerate(class_list):
        print("class"),
        print(str(i + 1) + ":"),
        print(c)

############################## NEXT SECTION ##############################
SECTION_SLEEP(2)
SECTION("Matrix setup")

for sub_eec in hypers.edge_equiv_classes:
    gi_matrix = hypers.get_gi_matrix(sub_eec[0])
    print("Multipl. matrix for " + str(sub_eec[0].gens()) + ":")
    print(gi_matrix.multiplicity_matrix)
    print("Resulting matrix:")
    print(gi_matrix.gi_matrix)

    print("Eigenvectors:")
    gi_matrix.calculate_eigenvectors()
    for ev in gi_matrix.evs:
        print(ev)

    print("Nullspace repr:")
    nspr = gi_matrix.get_nullspace_representation()
    for v in nspr:
        print v

    P = Polyhedron(vertices = nspr)
    print(P)
#     P.show(viewer='tachyon')
