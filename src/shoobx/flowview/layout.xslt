<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
  xmlns:xpdl="http://www.wfmc.org/2008/XPDL2.1" xmlns="http://www.wfmc.org/2008/XPDL2.1"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="layout">
    <xsl:param name="title" />
    <xsl:param name="contents" />
    <xsl:param name="navigation" />

    <html>
      <head>
        <!-- Latest compiled and minified CSS -->
        <link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css" />

        <!-- Optional theme -->
        <link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap-theme.min.css" />

        <link href="http://netdna.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css" rel="stylesheet" />

        <title>FlowView: <xsl:value-of select="$title" /></title>

        <style>
          <xsl:value-of select="document('flowview:flowview.css')/style"
            disable-output-escaping="yes"/>
        </style>
      </head>
      <body data-spy="scroll" data-target=".sidenav">
        <div class="navbar navbar-inverse" role="navigation">
          <div class="container">
            <div class="navbar-header">
              <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
              </button>
              <a class="navbar-brand" href="#">FlowView</a>
            </div>
            <div class="collapse navbar-collapse">
              <ul class="nav navbar-nav">
                <li class="active"><a href="#">Processes</a></li>
              </ul>
            </div><!--/.nav-collapse -->
          </div>
        </div>

        <div class="container">
          <div class="row">
            <div class="col-lg-10">
              <xsl:copy-of select="$contents" />
            </div>
            <div class="col-lg-2">
              <div class="sidenav " data-spy="affix" data-offset-top="0" data-offset-bottom="200">
                <xsl:copy-of select="$navigation" />
              </div>
            </div>

          </div>
        </div>

        <!-- Latest compiled and minified JavaScript -->
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js">;</script>
        <script src="http://netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js">;</script>
      </body>
    </html>


  </xsl:template>

</xsl:stylesheet>