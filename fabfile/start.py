from fabric.api import *
from config import *


@roles('chunk')
def start_chunk():
    run(gfs_bin_dir + '/gfs_chunk_server_daemon.sh')


@roles('logger')
def start_logger():
    run(gfs_bin_dir + '/start_logger.sh')


@roles('shadow')
def start_shadow():
    run(gfs_bin_dir + '/daemo_gfs_shadow_master.sh')


@roles('master')
def start_master():
    run(gfs_bin_dir + '/daemo_gfs_master.sh')
