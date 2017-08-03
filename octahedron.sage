# H(4,2) - Octahedron automorphism group

##
# TODO: This means that currently it's necessary that sage is run from the script's location
load("vertex_automorph_functions.sage")
##

print("########################")
print("# Vertex configuration #")
print("########################\n")

v_list = ['A','B', 'C', 'D', 'E', 'F']
print("Vertices:"),
print(v_list)

facet_pair_list = [("ABE", "CDF"), ("BCE", "DAF"), ("CDE", "ABF"), ("DAE", "BCF")]
print("Facet pairs:"),
print(facet_pair_list)

print("\n########################")
print("# Automorphism group   #")
print("########################\n")

s2Perm = SymmetricGroup(2)
sDimPerm = SymmetricGroup(4)
print("Symmetric groups:")
print(u"S\u2082:"),
print(s2Perm)
print(u"S\u2084:"),
print(sDimPerm)

def s4automor(g): # returns (1,2)^-1 * g * (1,2)
    return sDimPerm("(1,2)") * g * sDimPerm("(1,2)")

print("\n")

print("Twist homomorphism:"),
print("with mapping"),
print(sDimPerm.gens()),
print(u"\u2192"),
print(map(s4automor, sDimPerm.gens()))
hom = PermutationGroupMorphism_im_gens(sDimPerm, sDimPerm, map(s4automor, sDimPerm.gens()))
print(hom)

print("\n## Semidirect product ##")
sdp = s2Perm.semidirect_product(sDimPerm, [ [s2Perm("(1,2)")], [hom] ])
sdp_gap = gap(sdp) # needed for functions in vertex_automorph_functions.sage
print(sdp)
print("Finitely presented:"),
print(sdp.as_finitely_presented_group())

print("Set size:"),
print(sdp.order())
sdpList = sdp.list()

#print("\n")
#print(sdpList)
#print("\n")

print("\n########################")
print("# Vertex-Automorphism connection   #")
print("########################\n")

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

#test = sdp[2] * sdp[3]
#test = sdp[14]
#print("test:"),
#print(test)

    
#test_gap_factor = str(sdp_gap.Factorization( gap(test) ))
#test_str = factor_lining(test_gap_factor)
#print(test_str)

#print(factor_back(test_str, generator_list))

#factor_list = factor_list_lining(test_str, generator_list)
#factor_list = factor_list_lining(factor_lining(str(sdp_gap.Factorization( gap(test) ))), generator_list)
#factor_list = factor_list_lining_from_group(test, generator_list)

#print(factor_list)

#print("VERTEX")
#print(vertex_hom(v_list, factor_list))
#print(vertex_hom_from_group(v_list, test, generator_list))

print("\n########################")
print("# Subgroups   #")
print("########################\n")
sdpSubs = sdp.subgroups()
print("Count:"),
print(len(sdpSubs))
#test = sdpSubs[47]
#print(test)
#print(test.list())
#print(sdpSubs)

def group_is_vertex_transitiv(group):
    v_list_hit = v_list[:]
    
    for g in group:
     #   print("Groupelement:"),
     #   print(g)
        img0 = vertex_hom_from_group(v_list, g, generator_list)[0]
     #   print("Test A:"),
     #   print(img0)
        for v in v_list_hit:
            if (img0 == v):
                v_list_hit.remove(v)
                break
     #   print("")
     #   print("List is still:"),
     #   print(v_list_hit)
        
        if not v_list_hit:
     #       print("FOUND VERTEX TR SUBGROUP")
            return True
    return False
    

#print(vertexTransitivTest(test))

sdpSubsVertTr = []
for sub in sdpSubs:
   # print("### Subgroup:"),
   # print(sub)
    if (group_is_vertex_transitiv(sub)):
        sdpSubsVertTr.append(sub)

print("Found"), 
print(len(sdpSubsVertTr)),
print("vertex transitive subgroups:")
print(sdpSubsVertTr)
