# H(4,2) - Octahedron automorphism group
import sys, time, threading
##
# TODO: This means that currently it's necessary that sage is run from the script's location
load("edge.sage")
load("vertex.sage")

load("graph.sage")
load("hypersimplex.sage")
load("group_wrapper.sage")
load("edge_equiv_class.sage")
##

print("####################################")
print("# Vertex configuration             #")
print("####################################\n")

v_list = [Vertex('A'),Vertex('B'), Vertex('C'), Vertex('D'), Vertex('E'), Vertex('F')]
e_non_list = [Edge(Vertex('A'),Vertex('C')), Edge(Vertex('B'),Vertex('D')), Edge(Vertex('E'),Vertex('F'))]
e_list = []

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
print

### calculating vertex transitive subgroups
wait_str = "Calculating vertex transitive subgroups"
trans_calc_done = False
def animate():
    i = 0
    while not trans_calc_done:
        i = (i + 1)%3
        sys.stdout.write("\r" + wait_str + "."*(i+1))
        sys.stdout.write("\033[K")
        time.sleep(0.5)

t = threading.Thread(target=animate)
t.start()

sdpSubsVertTr = []
for sub in sdpSubs:
    if (sub.is_vertex_transitiv(hypers.graph)):
        sdpSubsVertTr.append(sub)
trans_calc_done = True
###

sys.stdout.write("\r\033[K")
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
