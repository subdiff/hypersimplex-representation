###
# Currently limited to the octahedron use case
###

#
# Simple test if 's' is a number.
#
def is_number(s):
    try:
        float(s)
        return True
    except ValueError:
        return False

#
# Returns the GAP generator factorization
# of a group element as string.
#
def factor_str_gap(element):
    return str(sdp_gap.Factorization(gap(element)))

#
# Returns the GAP generator factorization
# of a list of group element as a list of strings.
#
def factor_str_gap_list(list):
    ret = []
    for l in list:
        ret.append(factor_str_gap(l))
    return ret

#
# Returns for a factorized GAP presentation
# the same on but with all factors written down
# explicitly.
#
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
# Returns for an explicitly written down factorization
# the group product of the generators 'generators' identified by
# the GAP string presentation in 'comp_list'.
#
# 'generators[0]' must always be the identity element and the
# identity element in 'factor_string' already identitfiable by
# the first character.
#
def factor_back(factor_string, generators):
    i = 0
    comp_list = factor_str_gap_list(generators)
    
    ret = generators[0]
    
    if (factor_string[1] == comp_list[0][1]):
        return generators[0]

    while (i < len(factor_string)):
        c = factor_string[i]

        if (is_number(c)):
            is_inverse = False
            if ( 1 < i and factor_string[i-2] == '-'):
                is_inverse = True

            for j in range(1, len(comp_list)):
                # compare with comp_list and return element
                # with the same index from generators
                if (comp_list[j][1] == c):
                    e = generators[j].inverse() if is_inverse else generators[j]
                    ret = ret * e
                    break
            #print(ret) # prints every in between element in the group multiplication
        i += 1
    return ret

#
# An explicitly written down factorization 'factor_string' is 
# returned as a list of group elements.
#
# 'generators[0]' must always be the identity element and the
# identity element in 'factor_string' already identitfiable by
# the first character.
#
def factor_list_lining(factor_string, generators):
    i = 0
    ret = []
    comp_list = factor_str_gap_list(generators)
    
    if (factor_string[1] == comp_list[0][1]):
        return [generators[0]]

    while (i < len(factor_string)):
        c = factor_string[i]

        if (is_number(c)):
            is_inverse = False
            if ( 1 < i and factor_string[i-2] == '-'):
                is_inverse = True

            for j in range(1, len(comp_list)):
                # compare with comp_list and return element
                # with the same index from generators
                if (comp_list[j][1] == c):
                    e = generators[j].inverse() if is_inverse else generators[j]
                    ret.append(e)
                    break
            #print(ret) # prints every in between element in the group multiplication
        i += 1
    return ret

#
# Returns for a group element 'g' its generator factorization
# as a list of group elements.
#
# 'generators[0]' must always be the identity element and the
# identity element must be already identitfiable by
# the first character.
#
def factor_list_lining_from_group(g, generators):
    return factor_list_lining(factor_lining(str(sdp_gap.Factorization( gap(g) ))), generators)

#
# Applies to the vertices of the octahedron
# the permutation 'sd_list'
#
def vertex_hom(v_list, sd_list):
    ret = v_list[:]
    if (sd_list[0] == sdp[0]):
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

    for f in sd_list:
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

#
# Applies to the vertices of the octahedron
# the permutation 'g' generated through 'generators'.
#
# Returns the permutated vertex list
#
# 'generators[0]' must always be the identity element and the
# identity element must be already identitfiable by
# the first character.
#
def vertex_hom_from_group(v_list, g, generators):
    return vertex_hom(v_list, factor_list_lining_from_group(g, generators))
