import common
import subprocess
import prolog
import string
import config as cfg

class Metagol:
    name='metagol'
    metagol_runner='metagol/runner'

    def __init__(self):
        pass

    def parse_train(self,datafile,outpath,game,target):
        for (subtarget,bk,pos,neg) in common.parse_target(datafile):
            prims=set(map(common.pred,bk))
            (p,a)=subtarget
            fname=outpath + '{}.pl'.format(p)
            with open(fname,'w') as f:
                for atom in bk:
                    f.write('{}.\n'.format(atom))
                for atom in pos:
                    f.write('pos({}).\n'.format(atom))
                for atom in neg:
                    f.write('neg({}).\n'.format(atom))
                for (p,a) in prims:
                    # add negation
                    f.write('not_{0}({1}) :- \+ {0}({1}).\n'.format(p,','.join(string.ascii_uppercase[:a])))
                    f.write('prim({}/{}).\n'.format(p,a))
                    f.write('prim(not_{}/{}).\n'.format(p,a))
            subprocess.call(['sort',fname,'-o',fname])

    def parse_test(self,datafile,outpath,game,target):
        for (subtarget,bk,pos,neg) in common.parse_target(datafile):
            common.parse_test(outpath,subtarget,bk,pos,neg)

    def train(self,inpath,outfile,target):
        trainf=inpath+target
        prolog.swipl(action='learn,halt.',load_files=[self.metagol_runner,trainf],outfile=outfile,timeout=cfg.learning_timeout)

    def do_test(self,dataf,programf,outf):
        prolog.swipl('do_test,halt.',[self.metagol_runner,dataf,programf],outf,timeout=None)