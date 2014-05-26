###############################################################################
#
# Copyright 2014 by Shoobx, Inc.
#
###############################################################################
import argparse
import logging
import pkg_resources


log = logging.getLogger(__name__)

parser = argparse.ArgumentParser(
    description='Shoobx Flowview: XPDL Viewer')


def setup_logging(args):
    logging.basicConfig(level=logging.INFO)


def get_version():
    dist = pkg_resources.get_distribution("shoobx.flowview")
    return dist.version


def main():
    args = parser.parse_args()
    setup_logging(args)
    log.info("Shoobx Flowview %s" % get_version())
