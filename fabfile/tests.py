from fabric.api import *
from config import *


@roles('tester')
def start_func_test():
    with settings(warn_only=True):
        run(gfs_test_dir + '/bin/start_func_tester.sh')


@roles('tester')
def save_test_log():
    get('/home/root1/gfstest/result/*', '../out/test/tmp/')
    get('/usr/local/gfs/log/running.log', '../out/test/tmp/gfs_running_log')
