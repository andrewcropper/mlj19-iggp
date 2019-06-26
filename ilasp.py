import asp
import config as cfg
import subprocess
import re

class ILASP:
    ilasp=''
    xhail='xhail/xhail_mod.jar'
    name='ilasp'
    clasp='xhail/clasp-3.1.0-x86_64-linux'
    gringo='xhail/gringo3-linux'

    def __init__(self):
        pass


    def parse_train(self,datafile,outpath,game,target):
        for (bk,modes,examples,subtarget) in self.parse(datafile,game,target):
            with open('{}/{}.ilasp'.format(outpath,subtarget),'w') as f:
                f.write(bk + '\n' + modes + '\n' + examples)

    def parse_test(self,datafile,outpath,game,target):
        for (bk,modes,examples,subtarget) in self.parse(datafile,game,target):
            with open('{}/{}.ilasp'.format(outpath,subtarget),'w') as f:
                f.write(bk + '\n' + modes + '\n' + examples)

    # - inpath is the path for the game files (e.g. exp/aleph/train/minimal_decay/)
    # - outfile is the file to which to write the hypothesis (e.g. programs/aleph/minimal_decay/next_value.pl)
    # - target is the sub-target (e.g. next_value)
    def train(self,inpath,outfile,target):
        infile = '{}{}.ilasp'.format(inpath,target)
        with open(outfile,'w') as f:
            cmd="java -jar {} -c {} -g {} {} -i 100".format(self.ilasp,self.clasp,self.gringo,infile)
            print(cmd)
            try:
                subprocess.run(cmd.split(' '),timeout=cfg.learning_timeout,stdout=f)
            except subprocess.TimeoutExpired:
                pass

    # - datapath is the name of the file with the test data (e.g. exp/aleph/test/minimal_decay)
    # - programf is the name of the file with the hypothesis (e.g. programs/aleph/minimal_decay/next_value.pl)
    # - outf is the name of the file to write the results (e.g. results/aleph/minimal_decay/next_value.pl)
    # the results file should be a csv where each line represents an example and is of the form prediction,label
    # for instance, the following 5 lines denote 3 positive examples and 2 negative examples (the second column), the learner misclassified the third example (predicted 0 when it should have been 1)
    # 1,1
    # 1,1
    # 0,1
    # 0,0
    # 0,0


    def do_test(self,dataf,programf,outf):
        pass


    def parse(self,filename,game,target):

        for sub_predicate in asp.get_subpredicate(game,target):

            type_modes = ""
            constant_modes = ""

            modes = ""
            background = ""
            examples = ""

            func_decs = []
            type_decs = []

            types = open('types/' + game + '.typ').read()
            for type_dec in re.finditer('([^\\.\\n]*)\\.', types):
                match = re.search('(.*[^ ]) *:: *([^ ].*)', type_dec.group(1))
                if match:
                    lhs = match.group(1).split(", ")
                    rhs = match.group(2).split(" -> ")
                    if rhs[-1] != "bool":
                        if len(rhs) == 1:
                            for pred in lhs:
                                type_decs.append({ "type": rhs[-1], "name": pred})
                                background += rhs[0] + '(' + pred + ').\n'
                                constant_modes += '#constant(' + rhs[0] + ", " + pred + ').\n'

                            type_modes += '#modeb(' + rhs[0] + '(ph(' + rhs[0] + '))).\n'
                        else:
                            for pred in lhs:
                                func_decs.append({ "type": rhs[-1], "name": pred, "body": rhs[:-1]})

            for type_dec in re.finditer('([^\\.\\n]*)\\.', types):
                match = re.search('(.*[^ ]) *:: *([^ ].*)', type_dec.group(1))
                if match:
                    lhs = match.group(1).split(", ")
                    rhs = match.group(2).split(" -> ")
                    if rhs[-1] == 'bool':
                        for pred in lhs:
                            if len(rhs) == 1:
                                if pred == sub_predicate:
                                    modes += '#modeh(' + modes + pred + ').\n'
                                elif pred not in ["next", "terminal", "goal", "legal"]:
                                    modes += '#modeb(' + modes + pred + ').\n'
                            else:
                                mds = self.fill_in_fns(rhs[:-1], func_decs, type_decs)
                                for md in mds:
                                    m = pred + md["name"] + '(' + md["body"][2:] + ')'

                                    if pred + md["name"] == sub_predicate:
                                        modes += '#modeh(' + m + ').\n'
                                    elif pred not in ["next", "terminal", "goal", "legal"]:
                                        modes += '#modeb(' + m + ').\n'

            modes += type_modes
            modes += constant_modes

            herbrand_domain = []
            sets = open(filename).read().split("---")

            ctx = ""

            for s in sets:
                splt = re.findall('[a-z][a-zA-Z0-9_\\(\\) ,]*', s)
                if splt != []:
                    if splt[0] == 'atoms':
                        herbrand_domain = splt[1:]
                    elif splt[0] == 'background':
                        ctx = ""
                        for a in splt[1:]:
                            split_a = a.split("(")
                            if len(split_a) == 1:
                                ctx += a + '.\n'
                            else:
                                ctx += split_a[0] + '(' + split_a[1] + '.\n'
                    elif splt[0] == 'positives':
                        examples += "#pos({"
                        incs = []
                        excs = []
                        for a in herbrand_domain:
                            split_a = a.split("(")
                            if split_a[0] == sub_predicate:
                                if '()' in a or len(split_a) == 1:
                                    if a not in splt[1:]:
                                        excs.append(split_a[0])
                                    else:
                                        incs.append(split_a[0])
                                else:
                                    if a not in splt[1:]:
                                        excs.append(split_a[0] + '(' + split_a[1])
                                    else:
                                        incs.append(split_a[0] + '(' + split_a[1])
                        examples += ", ".join(incs) + "}, {" + ", ".join(excs) + "}, {\n"
                        examples += ctx + "\n}).\n"
                    elif splt[0] == 'statics':
                        for a in splt[1:]:
                            split_a = a.split("(")
                            if len(split_a) == 1:
                                background += a + '.\n'
                            else:
                                background += split_a[0] + '(' + split_a[1] + '.\n'

            yield (modes,background,examples,sub_predicate)

    def fill_in_fns(self, arg_list, func_decs, type_decs):
        mds = [{"name": "", "body": ""}]
        for arg in arg_list:
            new_mds = []
            if any(td["type"] == arg for td in type_decs):
                for md in mds:
                    new_mds.append({"name": md["name"], "body": (md["body"] + ", ph(" + arg + ")")})
            for fd in func_decs:
                if fd["type"] == arg:
                    fd_proc = self.fill_in_fns(fd["body"], func_decs, type_decs)
                    for md in mds:
                        for body in fd_proc:
                            new_mds.append({"name": md["name"] + "_" + fd["name"] + body["name"], "body": (md["body"] + body["body"])})
            mds = new_mds
        return mds
