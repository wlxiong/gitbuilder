#!/bin/sh

export GFS_HOME=/usr/local/gfs


FILEPATH=${GFS_HOME}/bin
cd ${FILEPATH}

${FILEPATH}/gfs_master_logger -d &> gfs_master_logger_log.out


