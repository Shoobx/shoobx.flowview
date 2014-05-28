###############################################################################
#
# Copyright 2014 by Shoobx, Inc.
#
###############################################################################
from lxml import etree
import pkg_resources


class ResourceResolver(etree.Resolver):
    prefix = "flowview:"
    def resolve(self, url, pubid, context):
        if url.startswith(self.prefix):
            fn = url[len(self.prefix):]
            print "RESOLVING", fn

            res = pkg_resources.resource_stream("shoobx.flowview", fn)
            return self.resolve_file(res, context)


def transform_to_html(xpdl_filename):
    """Transform given XPDL file to HTML
    """
    parser = etree.XMLParser()
    parser.resolvers.add(ResourceResolver())

    template = pkg_resources.resource_stream("shoobx.flowview", "xpdl.xslt")
    dom = etree.parse(xpdl_filename)
    xslt = etree.parse(template, parser)
    transform = etree.XSLT(xslt)
    htmldom = transform(dom)
    html = etree.tostring(htmldom, pretty_print=True)
    return "<!DOCTYPE html>\n" + html
