#!/usr/bin/env bash

################################################################################
# $Id: check_hold_files.sh 2343 2013-07-12 01:33:04Z millig $
# $Rev: 2343 $
################################################################################
#
# File Name:  check_hold_files.sh
#
# Description:  This script checks for the existence of unprocessed MAS files
#               in filemgr.
#
# Shell Arguments:  None.
#
# Script Arguments:  None.
#
# Output:  None.
#
# Return:   0 = Success
#          !0 = Exit with errors
#
################################################################################

echo -e '/clearing/filemgr/MAS/INST_101/MAS_FILES'
ls -ltcr /clearing/filemgr/MAS/INST_101/MAS_FILES

echo -e '/clearing/filemgr/MAS/INST_105/MAS_FILES'
ls -ltcr /clearing/filemgr/MAS/INST_105/MAS_FILES

echo -e '/clearing/filemgr/MAS/INST_107/MAS_FILES'
ls -ltcr /clearing/filemgr/MAS/INST_107/MAS_FILES

echo -e '/clearing/filemgr/MAS/INST_121/MAS_FILES'
ls -ltcr /clearing/filemgr/MAS/INST_121/MAS_FILES

echo -e '/clearing/filemgr/MAS/INST_811/MAS_FILES'
ls -ltcr /clearing/filemgr/MAS/INST_811/MAS_FILES

echo -e '/clearing/filemgr/MAS/INST_101/HOLD_FILES'
ls -ltcr /clearing/filemgr/MAS/INST_101/HOLD_FILES

echo -e '/clearing/filemgr/MAS/ON_HOLD_FILES'
ls -ltcr /clearing/filemgr/MAS/ON_HOLD_FILES

echo -e '/clearing/filemgr/MAS/EOM_HOLD'
ls -ltcr /clearing/filemgr/MAS/EOM_HOLD

echo -e '/clearing/filemgr/MAS/MAS_FILES'
ls -ltcr /clearing/filemgr/MAS/MAS_FILES
