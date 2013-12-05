from fabric.api import *
from config import *


@roles('tester')
def start_func_test():
    with settings(warn_only=True):
        run(gfs_test_dir + '/bin/start_func_tester.sh')
