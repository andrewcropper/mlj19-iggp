import common
import prolog
import config as cfg
from os.path import isfile

class Aleph:
    name='aleph'
    aleph_path='aleph/aleph'
    aleph_runner='aleph/runner'

    def __init__(self):
        pass

    def parse_train(self,datafile,outpath,game,target):
        for (subtarget,bk,pos,neg) in common.parse_target(datafile):
            prims=set(map(common.pred,bk))
            (p,a)=subtarget
            subtarget='{}/{}'.format(p,a)
            prims=list(map(lambda x: '{}/{}'.format(x[0],x[1]),prims))
            fname=outpath+p

            with open(fname+'.b','w') as f:
                for prim in prims:
                    f.write(':- determination({},{}).\n'.format(subtarget,prim))
                for atom in bk:
                    f.write('{}.\n'.format(atom))
            with open(fname+'.f','w') as f:
                for atom in pos:
                    f.write('{}.\n'.format(atom))
            with open(fname+'.n','w') as f:
                for atom in neg:
                    f.write('{}.\n'.format(atom))

    def parse_test(self,datafile,outpath,game,target):
        for (subtarget,bk,pos,neg) in common.parse_target(datafile):
            common.parse_test(outpath,subtarget,bk,pos,neg)

    def train(self,inpath,outfile,target):
        infile=inpath+target
        cmd="set(verbose,0),read_all('{}'),induce_modes,induce,write_rules('{}'),halt.".format(infile,outfile)
        prolog.yap(cmd,[self.aleph_path],outfile=None,timeout=cfg.learning_timeout)

    def do_test(self,dataf,programf,outf):
        if isfile(programf):
            prolog.swipl('do_test,halt.',[dataf,programf,self.aleph_runner],outf,timeout=None)
        else:
            prolog.swipl('do_test,halt.',[dataf,self.aleph_runner],outf,timeout=None)