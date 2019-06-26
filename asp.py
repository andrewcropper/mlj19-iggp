import re

def fill_in_fns(arg_list, func_decs, type_decs):
    mds = [{"name": "", "body": ""}]
    for arg in arg_list:
        new_mds = []
        if any(td["type"] == arg for td in type_decs):
            for md in mds:
                new_mds.append({"name": md["name"], "body": (md["body"] + ", +" + arg)})
        for fd in func_decs:
            if fd["type"] == arg:
                fd_proc = fill_in_fns(fd["body"], func_decs, type_decs)
                for md in mds:
                    for body in fd_proc:
                        new_mds.append({"name": md["name"] + "_" + fd["name"] + body["name"], "body": (md["body"] + body["body"])})
        mds = new_mds
    return mds

def get_subpredicate(game,target):

    func_decs = []
    type_decs = []

    types = open('types/' + game + '.typ').read().replace(" ", "")
    for type_dec in re.finditer('([^\\.\\n]*)\\.', types):
        match = re.search('(.*[^ ]) *:: *([^ ].*)', type_dec.group(1))
        if match:
            lhs = match.group(1).split(",")
            rhs = match.group(2).split("->")
            if rhs[-1] != "bool":
                if len(rhs) != 1:
                    for pred in lhs:
                        func_decs.append({ "type": rhs[-1], "name": pred, "body": rhs[:-1]})

    for type_dec in re.finditer('([^\\.\\n]*)\\.', types):
        match = re.search('(.*[^ ]) *:: *([^ ].*)', type_dec.group(1))
        if match:
            lhs = match.group(1).split(",")
            rhs = match.group(2).split("->")
            if rhs[-1] == 'bool':
                for pred in lhs:
                    if pred == target:
                        preds = [pred]
                        for arg in rhs:
                            found = False
                            new_preds = []
                            for f in func_decs:
                                if f["type"] == arg:
                                    found = True
                                    for p in preds:
                                        new_preds.append(p + "_" + f["name"])

                            if found:
                               preds = new_preds

                        for p in preds:
                            yield(p)


def parse(filename,game,target):

    for sub_predicate in get_subpredicate(game,target):

        modes = ""
        background = ""
        examples = ""

        func_decs = []
        type_decs = []

        types = open('types/' + game + '.typ').read().replace(" ", "")
        for type_dec in re.finditer('([^\\.\\n]*)\\.', types):
            match = re.search('(.*[^ ]) *:: *([^ ].*)', type_dec.group(1))
            if match:
                lhs = match.group(1).split(",")
                rhs = match.group(2).split("->")
                if rhs[-1] != "bool":
                    if len(rhs) == 1:
                        for pred in lhs:
                            type_decs.append({ "type": rhs[-1], "name": pred})
                            background += rhs[0] + '(' + pred + ', EG_ID) :- eg_id(EG_ID).\n'
                            background += rhs[0] + '(' + pred + ').\n'
                            background += 'eq(' + pred + ', ' + pred + ').\n'
                        modes += 'modeb(eq(+' + rhs[0] + ', #' + rhs[0] + ')).\n'
                        modes += 'modeb(' + rhs[0] + '(-' + rhs[0] + ', +eg_id)).\n'
                    else:
                        for pred in lhs:
                            func_decs.append({ "type": rhs[-1], "name": pred, "body": rhs[:-1]})
            else:
                match = re.search('(.*[^ ]) *:> *([^ ].*)', type_dec.group(1), re.MULTILINE | re.DOTALL)
                if match:
                    lhs = match.group(1).split(",")
                    for pred in lhs:
                        background += match.group(2) + '(X) :- ' + pred + '(X).\n'

        arity = 0

        for type_dec in re.finditer('([^\\.\\n]*)\\.', types):
            match = re.search('(.*[^ ]) *:: *([^ ].*)', type_dec.group(1))
            if match:
                lhs = match.group(1).split(",")
                rhs = match.group(2).split("->")
                if rhs[-1] == 'bool':
                    for pred in lhs:
                        if len(rhs) == 1:
                            if pred == sub_predicate:
                                modes += 'modeh(' + pred + '(+eg_id)).\n'
                                arity = 0
                            elif not pred.startswith("legal") and not pred.startswith("terminal") and not pred.startswith("next") and not pred.startswith("goal"):
                                modes += 'modeb(' + pred + '(+eg_id)).\n'
                        else:
                            mds = fill_in_fns(rhs[:-1], func_decs, type_decs)
                            for md in mds:
                                m = pred + md["name"] + '(+eg_id' + md["body"] + ')'

                                if pred + md["name"] == sub_predicate:
                                    modes += 'modeh(' + m + ').\n'
                                    arity = len(md["body"].split(",")) - 1
                                elif not pred.startswith("legal") and not pred.startswith("terminal") and not pred.startswith("next") and not pred.startswith("goal"):
                                    modes += 'modeb(' + m + ').\n'

        herbrand_domain = []
        sets = open(filename).read().split("---")

        eg_id = 0

        i = 0

        for s in sets:
            i = i + 1
            splt = re.findall('[a-z][a-zA-Z0-9_\\(\\) ,]*', s)
            if splt != []:
                if splt[0] == 'atoms':
                    herbrand_domain = splt[1:]
                elif splt[0] == 'background':
                    eg_id += 1
                    for a in splt[1:]:
                        split_a = a.split("(")
                        if len(split_a) == 1:
                            background += a + '(' + str(eg_id) + ').\n'
                        else:
                            background += split_a[0] + '(' + str(eg_id) + ', ' + split_a[1] + '.\n'

                    background += ":- " + sub_predicate + "(" + str(eg_id)
                    for var_i in range(arity):
                        background += ", V" + str(var_i)
                    background += "), not eg(" + sub_predicate + "(" + str(eg_id)
                    for var_i in range(arity):
                        background += ", V" + str(var_i)
                    background += ")).\n"


                elif splt[0] == 'positives':
                    for a in herbrand_domain:
                        split_a = a.split("(")
                        if a in splt[1:] and split_a[0] == sub_predicate:
                            examples += "example("
                            if '()' in a or len(split_a) == 1:
                                examples += split_a[0] + '(' + str(eg_id) + ')'
                            else:
                                examples += split_a[0] + '(' + str(eg_id) + ', ' + split_a[1]
                            examples += ", 1"
                            examples += ").\n"
                            examples += "eg("
                            if '()' in a or len(split_a) == 1:
                                examples += split_a[0] + '(' + str(eg_id) + ')'
                            else:
                                examples += split_a[0] + '(' + str(eg_id) + ', ' + split_a[1]
                            examples += ").\n"
                elif splt[0] == 'statics':
                    for a in splt[1:]:
                        split_a = a.split("(")
                        if len(split_a) == 1:
                            background += a + '(EG_ID) :- eg_id(EG_ID).\n'
                        else:
                            background += split_a[0] + '(EG_ID, ' + split_a[1] + ' :- eg_id(EG_ID).\n'


        background += 'eg_id(1..' + str(eg_id) + ').\n'
        #print(background)
        # print examples
        yield (modes,background,examples,sub_predicate)

