import os
import time
from fabric.api import *
from config import *


def setup_install_dir():
    run('rm -rf ' + gfs_install_dir)
    run('mkdir -p' + gfs_bin_dir)
    run('mkdir -p' + gfs_conf_dir)
    # install bin/
    put('bin/*', gfs_bin_dir, mode=755)
    # install conf/
    current_host = env.host_string
    old_conf = open('conf/chunk_server1.conf', 'r')
    new_conf = open("conf/chunk_server.conf", 'w')
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
    put('conf/*', gfs_conf_dir, mode=644)


def install_log4cplus():
    run('mkdir -p ~/src')
    run('rm -rf ~/src/log4cplus-1.0.2')
    with cd('~/src'):
        run("wget 'http://10.10.15.20/3rd_src/log4cplus-1.0.2.tar.gz'")
        with hide('output'):
            run('tar xvzf log4cplus-1.0.2.tar.gz')
    with cd('~/src/log4cplus-1.0.2'):
        with hide('output'):
            run('./configure CXXFLAGS="$CXXFLAGS -include stdlib.h -include string.h -include stdio.h"')
            run('make install')


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
    run('rm -rf ' + gfs_test_dir)
    run('mkdir -p ' + gfs_test_dir + '/bin')
    run('mkdir -p ' + gfs_test_dir + '/conf')

    for f in text_files:
        basename = os.path.basename(f)
        put(gfs_build_dir + f, gfs_test_dir + '/bin/' + basename, mode=755)
    put('conf/log4cplus.client.test.properties', gfs_test_dir + '/conf/log4cplus.client.properties', mode=644)

    suffix = time.strftime('%Y%m%d', time.localtime(time.time()))
    put(gfs_build_dir + '/testcases/auto/tester',
        gfs_test_dir + '/bin/' + 'func_tester.' + suffix, mode=755)
    put(gfs_build_dir + '/testcases/perf/tester',
        gfs_test_dir + '/bin/' + 'perf_tester.' + suffix, mode=755)
    put(gfs_build_dir + '/testcases/compat/tester',
        gfs_test_dir + '/bin/' + 'compat_tester.' + suffix, mode=755)
    put(gfs_build_dir + '/testcases/FsShell/FsShell_tester.py',
        gfs_test_dir + '/bin/' + 'FsShell_tester_' + suffix + '.py', mode=755)
