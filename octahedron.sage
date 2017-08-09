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
##

# For development switch off
# release features
DEV_BUILD = True

if DEV_BUILD:
    SECTION_WAIT = False

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

s2Perm = SymmetricGroup(2)
sDimPerm = GroupWrapper(SymmetricGroup(4), True)
print("## Factors ##")
print(u"S\u2082:"),
print(s2Perm)
print(u"S\u2084:"),
print(sDimPerm)
print

print("## Semidirect product ##")
sdp = sDimPerm.semidirect_product_with_s2()
sdp_gap = sdp.as_gap_group() # needed for functions in vertex_automorph_functions.sage
print(sdp)
print("Finitely presented:"),
print(str(sdp.group.as_finitely_presented_group())[len("Finitely presented group"):])

print("Group size:"),
print(sdp.order())

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
print(hypers.graph.generator_permutations[sdp[2]](hypers.graph.vertices))
print("(3 4 5 6):"),
print(hypers.graph.generator_permutations[sdp[1]](hypers.graph.vertices))
print("(3 4):"),
print(hypers.graph.generator_permutations[sdp[3]](hypers.graph.vertices))

############################## NEXT SECTION ##############################
SECTION("Subgroups")

sdp_subs = sdp.subgroups()

print("There are"),
print(len(sdp_subs)),
print("subgroups in total.")

############################## NEXT SECTION ##############################
SECTION("Vertex transitive subgroups")
###
### calculating vertex transitive subgroups
###
animation = WaitAnimation("Calculating vertex transitive subgroups")
animation.start()
sdp_vert_trans_subs = []
for sub in sdp_subs:
    if (sub.is_vertex_transitiv(hypers.graph)):
        sdp_vert_trans_subs.append(sub)
animation.stop()

print("Found"),
print(len(sdp_vert_trans_subs)),
print("vertex transitive subgroups:")
for index_sub, sub in enumerate(sdp_vert_trans_subs):
    print(str(index_sub +1).zfill(2) + ":"),
    print(sub.gens())

############################## NEXT SECTION ##############################
SECTION_SLEEP(2)
SECTION("Edge equivalence classes")

for index_sub, sub in enumerate(sdp_vert_trans_subs):
    if index_sub > 0:
        print
    print("Subgroup " + str(index_sub+1) + ":"),
    print(sub.gens())

    print("Permutations:")
    for g in sub:
        print(hypers.graph.vertex_permutation(sub.get_factorization(g)))

    class_list = hypers.graph.get_edge_classes(sub)
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
