
##
## Returns the vertex 'v' got mapped to
## under the permutation 'img'.
##
#def img_of_vertex(v, img):
    #ret = v
    #for i, w in enumerate(img):
        #if (w == v):
            #return v_list[i]
    #return ret

##
## Returns the edge 'e' got mapped to
## under the permutation 'img'.
##
#def img_of_edge(e, img):
    #img_v = img_of_vertex(e.v, img)
    #img_w = img_of_vertex(e.w, img)

    #return Edge(img_v, img_w)

##
## Returns list of all edges
## connected with 'v'.
##
#def get_edges_to_vertex(v):
    #v_e_list = []
    #for e in e_list:
        ##print("Y"),
        ##print(e)
        #if (v in e):
            #v_e_list.append(e)

    ##print("Edges to"),
    ##print(v),
    ##print(":"),
    ##print(v_e_list)
    #return v_e_list

##
## Returns list of edge classes for graph
##
#def get_edge_classes(group, generators):
    ## every class is a list of edges
    #class_list = []

    #img_list = []
    #for g in group:
        #img = vertex_hom_from_group(v_list, g, generators)
        #img_list.append(img)

    #v_hit_list = []

    #for v in v_list:
        #def test_on_hit(v):
            #for w in v_hit_list:
                #if Edge(v,w) in e_list:
                    #return True
            #return False

        #if test_on_hit(v):
            ## we don't need to test vertices which have an edge
            ## to a vertex whose edges already have been tested
            #continue

        #v_hit_list.append(v)

        #v_e_list = get_edges_to_vertex(v)

        #def merge_lists(target, merge):
            #for e in merge:
                #if e in target:
                    #continue
                #target.append(e)

        #def set_to_class(img_list):
            #for c in class_list:
                #for e in c:
                    #if e in img_list:
                        #merge_lists(c, img_list)
                        #return
            #class_list.append([])
            #merge_lists(class_list[-1], img_list)

        #for v_e in v_e_list:
            ##print("v_e"),
            ##print(v_e)
            #e_img_list = []
            ##print("e_img_list START:"),
            ##print(e_img_list)
            #for g_i, g in enumerate(group):
                #img = img_list[g_i]
                ##print("img"),
                ##print(img)
                #edge_img = img_of_edge(v_e, img)
                ##print("edge_img"),
                ##print(edge_img)
                #e_img_list.append(edge_img)
                ##print("e_img_list:"),
                ##print(e_img_list)

            ##print("e_img_list:"),
            ##print(e_img_list)
            ##print(class_list)
            #set_to_class(e_img_list)
            ##print(class_list)


    #for i, c in enumerate(class_list):
        #class_list[i] = sorted(c, key=lambda edge: edge.v.label + edge.w.label)

    #return class_list
