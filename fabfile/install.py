import os
import time
from fabric.api import *
from config import *


def create_install_dir():
    run('rm -rf ' + gfs_install_dir)
    run('mkdir -p ' + gfs_install_dir)
    run('mkdir ' + gfs_bin_dir)
    run('mkdir ' + gfs_conf_dir)


def install_bin():
    put('bin/*', gfs_bin_dir, mode=755)


def install_conf():
    current_host = env.host_string
    old_conf = open('conf/chunk_server.conf', 'r')
    new_conf = open("conf/chunk_server_%s.conf" % current_host, 'w')
    for line in old_conf:
        line = line.strip()
        pair = line.split('=')
        if len(pair) == 2:
            key, value = pair
            if key.strip().lower() == 'ip' and value.strip():
                value = current_host
            new_conf.write("%s=%s\n" % (key, value))
        else:
            new_conf.write("%s\n" % line)
    old_conf.close()
    new_conf.close()
    os.rename("conf/chunk_server_%s.conf" % current_host, 'conf/chunk_server.conf')
    put('conf/*', gfs_conf_dir, mode=644)


@roles('master')
def install_master():
    put(gfs_build_dir + '/x_master/gfs_master', gfs_bin_dir, mode=755)


@roles('shadow')
def install_shadow():
    put(gfs_build_dir + '/x_shadow_master/gfs_shadow_master', gfs_bin_dir, mode=755)


@roles('logger')
def install_logger():
    put(gfs_build_dir + '/log_server/gfs_master_logger', gfs_bin_dir, mode=755)


@roles('chunk')
def install_chunk():
    put(gfs_build_dir + '/chunk_server/chunk_server', gfs_bin_dir, mode=755)


@roles('client')
def install_client():
    put(gfs_build_dir + '/sclient/FsShell', gfs_bin_dir, mode=755)


@roles('tester')
def install_tester():
    text_files = ['/testcases/auto/start_func_tester.sh',
                  '/testcases/perf/start_perf_tester.sh',
                  '/testcases/perf/crontab.txt',
                  '/testcases/compat/start_compat_tester.sh',
                  '/testcases/FsShell/start_shell_tester.sh']

    run('mkdir -p ' + gfs_test_dir + '/bin')
    for f in text_files:
        basename = os.path.basename(f)
        put(gfs_build_dir + f, gfs_test_dir + '/bin/' + basename, mode=755)

    suffix = time.strftime('%Y%m%d', time.localtime(time.time()))
    put(gfs_build_dir + '/testcases/auto/tester',
        gfs_test_dir + '/bin/' + 'func_tester.' + suffix, mode=755)
    put(gfs_build_dir + '/testcases/perf/tester',
        gfs_test_dir + '/bin/' + 'perf_tester.' + suffix, mode=755)
    put(gfs_build_dir + '/testcases/compat/tester',
        gfs_test_dir + '/bin/' + 'compat_tester.' + suffix, mode=755)
    put(gfs_build_dir + '/testcases/FsShell/FsShell_tester.py',
        gfs_test_dir + '/bin/' + 'FsShell_tester_' + suffix + '.py', mode=755)
