import subprocess

def gen_atom(index,x):
    syms = ['succ','input','between','true','number','index']
    x=x.replace(' ','')[:-1]
    (p,args)=x.split('(')
    args=list(filter(lambda x: x!='',args.split(',')))
    args=[str(index)]+args
    for sym in syms:
        if sym in p:
            p=p.replace(sym,'my_{}'.format(sym))
            break
    return '{}({})'.format(p,','.join(args))


def pred(atom):
    xs=atom.split('(')
    return (xs[0],xs[1].count(',')+1)

def filter_by_targ(targ,xs):
    return filter(lambda x: x.startswith(targ[0]),xs)

def parse_test(outpath,target,bk,pos,neg):
    (p,a)=target
    fname=outpath + '{}.pl'.format(p)
    with open(fname,'w') as f:
        for atom in bk:
            f.write('{}.\n'.format(atom))
        for atom in pos:
            f.write('pos({}).\n'.format(atom))
        for atom in neg:
            f.write('neg({}).\n'.format(atom))
    subprocess.call(['sort',fname,'-o',fname])

def parse_target(datafile):
    with open(datafile,'r') as f:
        episode=0
        atoms = set()
        bk,statics,pos,neg=[],[],[],[]

        for x in f.read().split('---'):
            xs=list(map(lambda x: x.strip(), x.strip().split('\n')))
            h,t=xs[0],xs[1:]
            if h == 'atoms:':
                atoms.update(set(t))
            elif h == 'statics:':
                statics.extend(t)
            elif h == 'background:':
                episode+=1
                bk.extend([gen_atom(episode,atom) for atom in t + statics])
            elif h == 'positives:':
                e_pos=set(t)
                pos.extend([gen_atom(episode,atom) for atom in e_pos])
                neg.extend([gen_atom(episode,atom) for atom in atoms if atom not in e_pos])

        for targ in set(map(pred,pos+neg)):
            yield (targ,bk,filter_by_targ(targ,pos),filter_by_targ(targ,neg))