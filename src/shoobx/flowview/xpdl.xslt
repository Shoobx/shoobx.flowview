<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
  xmlns:xpdl="http://www.wfmc.org/2008/XPDL2.1" xmlns="http://www.wfmc.org/2008/XPDL2.1"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" indent="yes" encoding="UTF-8" />

  <!-- Application -->
  <xsl:template name="application">
    <xsl:variable name="app_id" select="xpdl:Implementation/xpdl:Task/xpdl:TaskApplication/@Id" />
    <xsl:variable name="app_def" select="//xpdl:Applications/xpdl:Application[@Id=$app_id]" />

      <h4>Application <xsl:value-of select="$app_id" />
        - [<xsl:value-of select="$app_def/@Name" />]
      </h4>
      <p><xsl:value-of select="$app_def/xpdl:Description" /></p>

      <h5>Parameters</h5>
      <table>
        <xsl:for-each select="xpdl:Implementation/xpdl:Task/xpdl:TaskApplication/xpdl:ActualParameters/xpdl:ActualParameter">
          <xsl:variable name="pos" select="position()" />
          <xsl:variable name="param_def" select="$app_def//xpdl:FormalParameter[$pos]" />
          <tr>
            <td>
              <xsl:value-of select="$param_def/@Name" />
              <tt><xsl:value-of select="$param_def/@Id" /></tt>

              <xsl:if test="$param_def/xpdl:Description">
                <p><pre>
                  <xsl:value-of select="$param_def/xpdl:Description" />
                </pre></p>
              </xsl:if>
            </td>
            <td><pre><xsl:value-of select="." /></pre></td>
          </tr>
        </xsl:for-each>
      </table>
  </xsl:template>


  <xsl:template name="extattrs">
    <h4>Extended Attributes</h4>
    <dl>
      <xsl:for-each select="xpdl:ExtendedAttributes/xpdl:ExtendedAttribute">
        <dt><xsl:value-of select="@Name" /></dt>
        <dd><pre>
          <xsl:value-of select="." />
          <xsl:value-of select="@Value" />
        </pre></dd>
      </xsl:for-each>
    </dl>
  </xsl:template>

  <xsl:template name="activity-link">
    <xsl:param name="target_act_id" />
    <xsl:param name="activities" />
    <a>
      <xsl:attribute name="href">#<xsl:value-of select="$target_act_id" /></xsl:attribute>
      <xsl:value-of select="$activities[@Id=$target_act_id]/@Name" />
    </a>
  </xsl:template>

  <xsl:template name="transitions">
    <xsl:variable name="transitions" select="../../xpdl:Transitions/xpdl:Transition" />
    <xsl:variable name="activities" select="../xpdl:Activity" />
    <xsl:variable name="act_id" select="@Id" />

    <xsl:for-each select="$transitions[@To=$act_id]">
      Previous:
      <xsl:call-template name="activity-link">
        <xsl:with-param name="target_act_id" select="@From" />
        <xsl:with-param name="activities" select="$activities" />
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="$transitions[@From=$act_id]">
      Next:
      <xsl:call-template name="activity-link">
        <xsl:with-param name="target_act_id" select="@To" />
        <xsl:with-param name="activities" select="$activities" />
      </xsl:call-template>
    </xsl:for-each>

  </xsl:template>


  <!-- Activity -->
  <xsl:template name="activity">
    <h3>
      <xsl:attribute name="id"><xsl:value-of select="@Id" /></xsl:attribute>
      <xsl:value-of select="@Name" />
      <xsl:text> </xsl:text>
      <small> <xsl:value-of select="@Id" /></small>
    </h3>

    <xsl:call-template name="transitions" />
    <xsl:call-template name="application" />
    <xsl:call-template name="extattrs" />

  </xsl:template>


  <!-- Process definition -->
  <xsl:template name="process">
    <h2><xsl:value-of select="@Name" />
      <xsl:text> </xsl:text>
      <small> <xsl:value-of select="@Id" /></small>
    </h2>

    <xsl:call-template name="extattrs" />

    <xsl:for-each select="xpdl:Activities/xpdl:Activity">
          <xsl:call-template name="activity" />
    </xsl:for-each>
  </xsl:template>


  <!-- Main rule for whole document -->
  <xsl:template match="/">
    <html>
      <head>
        <!-- Latest compiled and minified CSS -->
        <link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css" />

        <!-- Optional theme -->
        <link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap-theme.min.css" />

        <!-- Latest compiled and minified JavaScript -->
        <script src="http://netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js">;</script>
      </head>
      <body>
        <h1>Test</h1>

        <xsl:for-each select="//xpdl:WorkflowProcesses/xpdl:WorkflowProcess">
          <xsl:call-template name="process" />
        </xsl:for-each>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>