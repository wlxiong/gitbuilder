#!/usr/bin/env python
import os
import sys
import time
import config
from nodepool import NodePool

gfs_test_dir = '/home/root1/gfstest'

master = NodePool.get()
shadow1 = NodePool.get()
shadow2 = NodePool.get()
shadows = [shadow1, shadow2]
chunk1 = NodePool.get()
chunk2 = NodePool.get()
chunk3 = NodePool.get()
chunks = [chunk1, chunk2, chunk3]
tester = master


def setup_domain_names():
    NodePool.setup_domain_names(
        {master.ip: 'master.gfs.gdrive logserver.gfs.gdrive',
         shadow1.ip: 'shadow-master.gfs.gdrive logserver.gfs.gdrive',
         shadow2.ip: 'shadow-master.gfs.gdrive logserver.gfs.gdrive'},
        [master, shadow1] + chunks)


def deploy_gfs():
    NodePool.batch_clean([master] + shadows + chunks)
    NodePool.batch_deploy('chunk', [master] + shadows + chunks)
    NodePool.batch_deploy('logger', [master] + shadows)
    NodePool.batch_deploy('shadow', shadows)
    master.deploy('master')
    master.deploy('shell')


def start_gfs():
    NodePool.batch_start('chunk', [master] + shadows + chunks)
    NodePool.batch_start('logger', [master] + shadows)
    NodePool.batch_start('shadow', shadows)
    master.start('master')


def stop_gfs():
    master.kill('master')
    NodePool.batch_kill('shadow', shadows)
    NodePool.batch_kill('logger', [master] + shadows)
    NodePool.batch_kill('chunk', [master] + shadows + chunks)


def deploy_tester():
    text_files = ['testcases/auto/start_func_tester.sh',
                  'testcases/perf/start_perf_tester.sh',
                  'testcases/perf/crontab.txt',
                  'testcases/FsShell/start_shell_tester.sh']
    tester.run('rm -rf ' + gfs_test_dir)
    tester.run('mkdir -p ' + gfs_test_dir + '/bin')
    tester.run('mkdir -p ' + gfs_test_dir + '/log')
    tester.run('mkdir -p ' + gfs_test_dir + '/conf')
    tester.run('mkdir -p ' + gfs_test_dir + '/result')
    tester.run('touch /home/root1/gfstest/result/info')

    gfs_build_dir = config.config_parser.get('DEFAULT', 'gfs_path')
    for f in text_files:
        basename = os.path.basename(f)
        tester.put(os.path.join(gfs_build_dir, f), gfs_test_dir + '/bin/' + basename, mode=0755)
    tester.put('conf/log4cplus.client.test.properties',
               os.path.join(gfs_test_dir, 'conf/log4cplus.client.properties'), mode=0644)

    suffix = time.strftime('%Y%m%d', time.localtime(time.time()))
    tester.put(gfs_build_dir + '/testcases/auto/tester',
               os.path.join(gfs_test_dir, 'bin/' + 'func_tester.' + suffix), mode=0755)
    tester.put(gfs_build_dir + '/testcases/perf/tester',
               os.path.join(gfs_test_dir, 'bin/' + 'perf_tester.' + suffix), mode=0755)
    tester.put(gfs_build_dir + '/testcases/FsShell/FsShell_tester.py',
               os.path.join(gfs_test_dir, 'bin/' + 'FsShell_tester_' + suffix + '.py'), mode=0755)


def start_tester(timeout):
    tester.run('ulimit -c unlimited')
    tester.run(os.path.join(gfs_test_dir, 'bin/start_func_tester.sh'), warn_only=False, timeout=timeout)


def save_test_log():
    tester.get('/home/root1/gfstest/result/*', '../out/test/tmp/')
    tester.get('/usr/local/gfs/log/running.log', '../out/test/tmp/gfs_running_log')


def main():
    try:
        timeout = int(sys.argv[1])
    except (IndexError, ValueError):
        print "Usage: %s timeout" % sys.argv[0]
        sys.exit(2)

    setup_domain_names()
    deploy_gfs()
    deploy_tester()
    try:
        start_gfs()
        start_tester(timeout)
    except:
        sys.exit(1)
    finally:
        save_test_log()
        stop_gfs()


if __name__ == '__main__':
    main()
