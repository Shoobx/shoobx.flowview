###############################################################################
#
# Copyright 2014 by Shoobx, Inc.
#
###############################################################################
from lxml import etree
import pkg_resources


def transform_to_html(xpdl_filename):
    """Transform given XPDL file to HTML
    """
    template = pkg_resources.resource_stream("shoobx.flowview", "xpdl.xslt")
    dom = etree.parse(xpdl_filename)
    xslt = etree.parse(template)
    transform = etree.XSLT(xslt)
    htmldom = transform(dom)
    html = etree.tostring(htmldom, pretty_print=True)
    return "<!DOCTYPE html>\n" + html
