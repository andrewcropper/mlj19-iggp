import aleph
import metagol
import specialised_ilasp
import os
import multiprocessing
import signal
import numpy as np
from os import listdir
from os.path import isfile, join
from multiprocessing import Pool
import config as cfg
import sys

def game_names(path):
    # return ['minimal_decay']
   return sorted(set('_'.join(f.split('_')[:-2]) for f in listdir(path) if isfile(join(path, f)) and f.endswith('.dat')))

def mkdir(path):
    if not os.path.exists(path):
        os.makedirs(path)

def pred(atom):
    xs=atom.split('(')
    return (xs[0],xs[1].count(',')+1)

def targets(inpath):
    return set(f.split('.')[0] for f in listdir(inpath) if isfile(join(inpath, f)))

def parmap(func,jobs):
    p=Pool(cfg.map_size)
    return p.map(func,jobs)

def parse_(args):
    (system,game) = args
    for stage in ['train','test']:
        outpath='exp/{}/{}/{}/'.format(system.name,stage,game)
        mkdir(outpath)
        for target in ['next','goal','legal','terminal']:
            datafile='data/{0}/{1}_{2}_{0}.dat'.format(stage,game,target)
            if stage == 'train':
                system.parse_train(datafile,outpath,game,target)
            else:
                system.parse_test(datafile,outpath,game,target)

def parse(system):
    parmap(parse_,list((system,game) for game in game_names('data/train')))

def train_(args):
    (system,game,target) = args
    inpath='exp/{}/train/{}/'.format(system.name,game)
    outpath='programs/{}/{}/'.format(system.name,game)
    mkdir(outpath)
    system.train(inpath,outpath+'{}.pl'.format(target),target)


def train(system):
    jobs=[]
    for game in game_names('data/train'):
        inpath='exp/{}/train/{}/'.format(system.name,game)
        outpath='programs/{}/{}/'.format(system.name,game)
        mkdir(outpath)
        for target in targets(inpath):
            jobs += [(system,game,target)]
    parmap(train_,jobs)

def do_test_(args):
    (system,game)=args
    inpath='exp/{}/test/{}/'.format(system.name,game)
    outpath='results/{}/{}/'.format(system.name,game)
    mkdir(outpath)
    for target in targets(inpath):
        dataf='exp/{}/test/{}/{}.pl'.format(system.name,game,target)
        programf='programs/{}/{}/{}.pl'.format(system.name,game,target)
        resultsf=outpath+'{}.pl'.format(target)
        system.do_test(dataf,programf,resultsf)

def do_test(system):
    parmap(do_test_,list((system,game) for game in sorted(game_names('data/train'))))

# results is a list of (predication,label) pairs
# seems a bit cumbersome
def balanced_acc(results):
    tp,tn,num_p,num_n=0.0,0.0,0.0,0.0

    for prediction,label in results:
        if label == 1:
            num_p+=1
        if label == 0:
            num_n +=1
        if prediction == 1 and label == 1:
            tp+=1
        if prediction == 0 and label == 0:
            tn+=1

    if num_p == 0 and num_n == 0:
        return -1
    elif num_p > 0 and num_n > 0:
        return ((tp / num_p) + (tn / num_n))/2
    elif num_p == 0:
        return (tn / num_n)
    elif num_n == 0:
        return (tp / num_p)

def res_parser(resultsf):
    with open(resultsf) as f:
        for line in f:
            xs=line.strip().split(',')
            if len(xs)>1:
                yield (int(xs[0]),int(xs[1]))

def perfectly_correct(xs):
    return sum(1 for x in xs if int(x) == 1)

def print_results_(args):
    (system, game) = args
    inpath='exp/{}/test/{}/'.format(system.name, game)
    sub_targets=targets(inpath)
    scores = []
    for target in ['next','goal','legal','terminal']:
        target_scores=[]
        for sub_target in sub_targets:
            if sub_target.startswith(target):
                resultsf='results/{}/{}/{}.pl'.format(system.name,game,sub_target)
                target_scores += res_parser(resultsf)
        print(game,target,int(balanced_acc(target_scores)*100))
        scores.append(balanced_acc(target_scores))
    return scores

def print_results(system):
    args = [(system, game) for game in game_names('data/test')]
    scores = [score for scores in parmap(print_results_, args) for score in scores]
    print(system.name, int(np.mean(scores)*100), perfectly_correct(scores))


systems = [metagol.Metagol(),aleph.Aleph(),specialised_ilasp.SPECIALISED_ILASP()]

arg = sys.argv[1]
if arg == 'parse':
    list(map(parse,systems))
if arg == 'train':
    list(map(train,systems))
if arg == 'test':
    list(map(do_test,systems))
if arg == 'results':
    list(map(print_results,systems))
