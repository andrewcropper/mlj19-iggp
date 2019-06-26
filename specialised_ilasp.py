import asp
import config as cfg
import subprocess
import re
import os
import glob
import common
import prolog
import json

class SPECIALISED_ILASP:
    ilasp='./GGP_ILASP'
    name='specialised_ilasp'

    def __init__(self):
        pass


    def parse_train(self,datafile,outpath,game,target):
        for (bk,modes,examples,subtarget) in self.parse(datafile,game,target):
            with open('{}/{}.ilasp'.format(outpath,subtarget),'w') as f:
                f.write(bk + '\n' + modes + '\n' + examples)

    # - inpath is the path for the game files (e.g. exp/aleph/train/minimal_decay/)
    # - outfile is the file to which to write the hypothesis (e.g. programs/aleph/minimal_decay/next_value.pl)
    # - target is the sub-target (e.g. next_value)
    def train(self,inpath,outfile,target):
        game = inpath.split("/")[-2]
        main_target = outfile.split("/")[-1].split(".")[0].split("_")[0]
        infile = '{}{}.ilasp'.format(inpath,target)
        with open(outfile + "_raw", 'w') as f:
            cmd="{} {} ./data/train/{}_{}_train.dat ./types/{}.typ".format(self.ilasp, target, game, main_target, game)
            print(cmd)
            try:
                subprocess.run(cmd.split(' '),timeout=cfg.learning_timeout,stdout=f)
            except subprocess.TimeoutExpired:
                pass

            map(os.remove, glob.glob("out_{}{}*".format(target, game)))
            map(os.remove, glob.glob("task_{}{}*".format(target, game)))

        raw_output = open(outfile + "_raw").read()
        final_hypothesis = ""
        for hyp in raw_output.split("{"):
            if "UNSATISFIABLE" not in hyp:
                final_hypothesis = hyp.split("}")[0]


        with open(outfile, 'w') as f:
            f.write(final_hypothesis)




    def do_test(self,dataf,programf,outf):
        print(outf)
        game = outf.split("/")[-2]
        main_target = outf.split("/")[-1].split(".")[0].split("_")[0]
        sub_target = outf.split("/")[-1].split(".")[0]
        sets = open("./data/test/{}_{}_test.dat".format(game, main_target)).read().split("---")

        herbrand_base = []
        background = []
        examples = []

        for s in sets:
            splt = re.findall('[a-z][a-zA-Z0-9_\\(\\) ,]*', s)
            if len(splt) > 0:
                if splt[0] == "atoms":
                    for a in splt[1:]:
                        herbrand_base.append(a)
                elif splt[0] == "statics":
                    for a in splt[1:]:
                        background.append(a)
                elif splt[0] == "background":
                    examples.append([[], []])
                    for a in splt[1:]:
                        examples[-1][0].append(a)
                elif splt[0] == "positives":
                    for a in splt[1:]:
                        examples[-1][1].append(a)

        results = "\n\n"

        for eg in examples:

            prg = ""

            for a in background:
                prg += a + ".\n"
            prg += "% example\n"
            for a in eg[0]:
                prg += a + ".\n"

            prg += "% types\n"



            types = open('types/' + game + '.typ').read()
            for type_dec in re.finditer('([^\\.]*)\\.', types):
                match = re.search('(.*[^ ]) *:: *([^ ].*)', type_dec.group(1), re.MULTILINE | re.DOTALL)
                if match:
                    lhs = match.group(1).split(",")
                    rhs = match.group(2).split("->")
                    if rhs[-1] != "bool":
                        if len(rhs) == 1:
                            for pred in lhs:
                                prg += rhs[0] + '(' + pred + ').\n'
                else:
                    match = re.search('(.*[^ ]) *:> *([^ ].*)', type_dec.group(1), re.MULTILINE | re.DOTALL)
                    if match:
                        lhs = match.group(1).split(",")
                        for pred in lhs:
                            prg += match.group(2) + '(X) :- ' + pred + '(X).\n'


            prg += "% hypothesis\n"
            prg += "\n\n" + open(programf).read() + "\n\n"

            with open(outf + "_test", 'w') as f:
                f.write(prg)

            with open(outf + "_out", 'w') as f:
                with open(outf + '_err', 'w') as f_err:
                    subprocess.run(["clingo", outf + "_test","--outf=2"], stdout=f, stderr=f_err)

            jsn = json.loads(open(outf + "_out").read())

            try:

                call = jsn['Call']
                first_call = call[0]
                wtness = first_call['Witnesses']
                first_wtness = wtness[0]
                answer_set = first_wtness['Value']

                for a in herbrand_base:
                    if sub_target in a:
                        res = 0
                        label = 0
                        if a.replace(" ", "").replace("()", "") in(answer_set):
                            res = 1
                        if a in(eg[1]):
                            label = 1
                        results += "{},{}\n".format(res,label)

            except:
                print(jsn)
                print(open(outf + "_err").read())

        with open(outf, 'w') as f:
            f.write(results)



    def parse(self,filename,game,target):
        for sub_predicate in asp.get_subpredicate(game,target):

            # return a dummy task, as the ILASP_GGP executable does the real parsing.

            modes = ""
            background = ""
            examples = ""

            yield (modes,background,examples,sub_predicate)

    def parse_test(self,datafile,outpath,game,target):
        for (bk,modes,examples,subtarget) in self.parse(datafile,game,target):
            with open('{}/{}.ilasp'.format(outpath,subtarget),'w') as f:
                f.write(bk + '\n' + modes + '\n' + examples)
