from fabric.api import *
from config import *


@roles('master')
def stop_master():
    run(gfs_bin_dir + '/kill_master.sh')


@roles('shadow')
def stop_shadow():
    run(gfs_bin_dir + '/kill_shadow.sh')


@roles('logger')
def stop_logger():
    run(gfs_bin_dir + '/kill_logger.sh')


@roles('chunk')
def stop_chunk():
    run(gfs_bin_dir + '/kill_chunk.sh')
