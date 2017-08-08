# H(4,2) - Octahedron automorphism group
import sys
##
# TODO: This means that currently it's necessary that sage is run from the script's location
# load("vertex_automorph_functions.sage")
# load("edge_equiv_classes.sage")
load("edge.sage")
load("vertex.sage")

load("graph.sage")
load("hypersimplex.sage")
load("group_wrapper.sage")
##

print("####################################")
print("# Vertex configuration             #")
print("####################################\n")

v_list = [Vertex('A'),Vertex('B'), Vertex('C'), Vertex('D'), Vertex('E'), Vertex('F')]
e_non_list = [Edge(Vertex('A'),Vertex('C')), Edge(Vertex('B'),Vertex('D')), Edge(Vertex('E'),Vertex('F'))]
e_list = []

# facet_pair_list = [("ABE", "CDF"), ("BCE", "DAF"), ("CDE", "ABF"), ("DAE", "BCF")]
# print("Facet pairs:"),
# print(facet_pair_list)

# calculate edges
v_list_hit = []
for v in v_list:
    v_list_hit.append(v)
    for w in v_list:
        e = Edge(v,w)
        if v == w:
            # no loops
            continue
        if e in e_non_list:
            # not connected
            continue
        if e in e_list:
            # already listed
            continue
        e_list.append(e)


print("Vertices:"),
print(v_list)
print("Edges:"),
print(e_list)

# graph = Graph(v_list, e_list)
# print("Octahedron graph:")
# print(graph)

# group_wrapper = GroupWrapper(SymmetricGroup(4))
# print(group_wrapper)
# print(group_wrapper.gens)
# print(len(group_wrapper))

hypers = Hypersimplex(4, 2, Graph(v_list, e_list))
print(hypers)

print("\n####################################")
print("# Automorphism group               #")
print("####################################\n")

s2Perm = SymmetricGroup(2)
sDimPerm = GroupWrapper(SymmetricGroup(4), True)
print("## Symmetric groups: ##")
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

print("Set size:"),
print(sdp.order())
sdpList = sdp.list()

#print("\n")
#print(sdpList)
#print("\n")

print("\n####################################")
print("# Vertex-Automorphism connection   #")
print("####################################\n")

def g_3456_vertex(vl): #input is vertex list
    return [vl[1], vl[2], vl[3], vl[0], vl[4], vl[5]]

def g_34_vertex(vl): #input is vertex list
    return [vl[2], vl[4], vl[0], vl[5], vl[1], vl[3]]

def g_12_34_vertex(vl): #input is vertex list
    return [vl[0], vl[5], vl[2], vl[4], vl[3], vl[1]]

def g_3456_inverse_vertex(vl): #input is vertex list
    return [vl[3], vl[0], vl[1], vl[2], vl[4], vl[5]]

generator_list = [sdp[0], sdp[1], sdp[2], sdp[3]]

print("On generators:")
print("(3 4 5 6):"),
print(g_3456_vertex(v_list))
print("(3 4):"),
print(g_34_vertex(v_list))
print("(1 2)(3 4):"),
print(g_12_34_vertex(v_list))

print("\n####################################")
print("# Subgroups                        #")
print("####################################\n")
sdpSubs = sdp.subgroups()
for sub in sdpSubs:
    # set factor_generators to toplevel group
    sub.set_factor_generators(sdp.gens())
print("There are"),
print(len(sdpSubs)),
print("subgroups in total.")
#test = sdpSubs[47]
#print(test)
#print(test.list())
# print(sdpSubs)

# def group_is_vertex_transitiv(group):
#     v_list_hit = v_list[:]
#
#     for g in group:
#         img0 = vertex_hom_from_group(v_list, g, generator_list)[0]
#         for v in v_list_hit:
#             if (img0 == v):
#                 v_list_hit.remove(v)
#                 break
#
#         if not v_list_hit:
#             return True
#     return False


# sdp.create_factored_elements()
# for index, fe in enumerate(sdp.factored_elements):
#     print(index),
#     print (fe)



print
print("Calculating vertex transitive subgroups...\r"),

sdpSubsVertTr = []
for sub in sdpSubs:
    print("testing sub"),
    print(sub.gens())
    if (sub.is_vertex_transitiv(hypers.graph)):
        sdpSubsVertTr.append(sub)

sys.stdout.write("\033[K")
print("Found"),
print(len(sdpSubsVertTr)),
print("vertex transitive subgroups:")
for index_sub, sub in enumerate(sdpSubsVertTr):
    print(str(index_sub +1).zfill(2) + ":"),
    print(sub.gens())

print("\n####################################")
print("# Edge equivalence classes         #")
print("####################################")

for index_sub, sub in enumerate(sdpSubsVertTr):
    print
    print("Subgroup " + str(index_sub+1) + ":"),
    print(sub.gens())

    print("Permutations:")
    for g in sub:
        print(vertex_hom_from_group(v_list, g, generator_list))

#     print("XXX")
    class_list = graph.get_edge_classes(sub, generator_list)
    print(len(class_list)),
    print("edge equivalence classes:")

    for i, c in enumerate(class_list):
        print("class"),
        print(str(i + 1) + ":"),
        print(c)
