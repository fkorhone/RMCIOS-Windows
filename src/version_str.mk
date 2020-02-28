# ******************************************************
# Script to create variables of git revision for sources.
#
# Required environment variables:
# PROJECT_DIR=  RMCIOS implementation root dir
# INTERFACE_DIR = RMCIOS-interface dir
# SRC_DIR = compile source directory
#
# Generated environment variables:
# ISO8601DATETIME
# IREVISION - RMCIOS interface revision
# SREVISION - Source revision (for SRC_DIR)
# REVISION  - Project revision (all sources and scripts)
# *******************************************************

# Variable for build revision id
REVISION_ID:=$(shell git show -s --format=%h)
REVISION:=Rev:$(REVISION_ID)

# Variable for interface revision id
IREVISION_ID= $(shell cd $(INTERFACE_DIR); git show -s --format=%h)
IREVISION=iRev:$(IREVISION_ID)

# Variable for source revision id
SREVISION_ID=$(shell cd $(SRC_DIR); git show -s --format=%h)
SREVISION=sRev:$(SREVISION_ID)

include compile_date.mk

# set version string
VERSION_STR:="$(REVISION)\\,Built:$(COMPILE_DATETIME)\\,$(SREVISION)\\,$(IREVISION)"
export

