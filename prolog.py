import subprocess

def swipl(action,load_files,outfile=None,timeout=None):
    call('swipl',action,load_files,outfile,timeout)

def yap(action,load_files,outfile=None,timeout=None):
    call('yap',action,load_files,outfile,timeout)

def call(prolog_version,action,load_files,outfile=None,timeout=None):
    load_files = map(lambda x: "'{}'".format(x),load_files)
    cmd = "load_files([{}],[silent(true)]). ".format(','.join(load_files))
    cmd+=action

    if outfile == None:
        p = subprocess.Popen([prolog_version,'-q'], stdin=subprocess.PIPE)
        call_p(p,cmd,timeout)
    else:
        with open(outfile, 'w') as outf:
            p = subprocess.Popen([prolog_version,'-q','-G8g'], stdin=subprocess.PIPE, stdout=outf)
            call_p(p,cmd,timeout)

def call_p(p,cmd,timeout):
    try:
        print(cmd)
        p.stdin.write(cmd.encode())
        p.communicate(timeout=timeout)
    except Exception as e:
        print(e)
    finally:
        p.kill()