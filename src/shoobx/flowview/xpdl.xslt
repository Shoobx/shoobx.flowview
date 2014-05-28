<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
  xmlns:xpdl="http://www.wfmc.org/2008/XPDL2.1" xmlns="http://www.wfmc.org/2008/XPDL2.1"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" indent="yes" encoding="UTF-8" />

  <!-- Application -->
  <xsl:template name="activity_application">
    <xsl:variable name="app_id" select="xpdl:Implementation/xpdl:Task/xpdl:TaskApplication/@Id" />
    <xsl:variable name="app_def" select="//xpdl:Applications/xpdl:Application[@Id=$app_id]" />

      <h4><i class="fa fa-cube"></i>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$app_def/@Name" />
        <xsl:text> </xsl:text>
        <small> <xsl:value-of select="$app_id" /></small>
      </h4>
      <p class="description"><xsl:value-of select="$app_def/xpdl:Description" /></p>

      <h4>Parameters</h4>
      <xsl:for-each select="xpdl:Implementation/xpdl:Task/xpdl:TaskApplication/xpdl:ActualParameters/xpdl:ActualParameter">
        <xsl:variable name="pos" select="position()" />
        <xsl:variable name="param_def" select="$app_def//xpdl:FormalParameter[$pos]" />

        <div class="row">
          <div class="col-lg-4">
            <xsl:call-template name="param_direction">
              <xsl:with-param name="mode" select="$param_def/@Mode" />
            </xsl:call-template>
            <xsl:text> </xsl:text>
            <tt><xsl:value-of select="$param_def/@Id" /></tt>
            <p><xsl:value-of select="$param_def/@Name" /></p>

            <xsl:if test="$param_def/xpdl:Description">
              <p class="description">
                <xsl:value-of select="$param_def/xpdl:Description" />
              </p>
            </xsl:if>
          </div>
          <div class="col-lg-8">
            <pre><xsl:value-of select="." /></pre>
          </div>
        </div>
      </xsl:for-each>
  </xsl:template>

  <xsl:template name="activity_event">
    <h4>
      <xsl:choose>
        <xsl:when test="xpdl:Event/xpdl:StartEvent">
          <i class="fa fa-circle-o"></i>
          Start Event
        </xsl:when>
         <xsl:when test="xpdl:Event/xpdl:EndEvent">
          <i class="fa fa-circle"></i>
          End Event
        </xsl:when>

      </xsl:choose>

    </h4>
  </xsl:template>

  <xsl:template name="activity_route">
    <xsl:variable name="gw_type" select="xpdl:Route/@GatewayType" />
    <h4>
      <xsl:choose>
        <xsl:when test="$gw_type='Parallel'">
          <i class="fa fa-arrows"></i> Parallel Route
        </xsl:when>
        <xsl:when test="$gw_type='Exclusive'">
          <i class="fa fa-arrows-alt"></i> Exclusive Route
        </xsl:when>
      </xsl:choose>
      <xsl:text> </xsl:text>
    </h4>
  </xsl:template>

  <!-- Extra Attributes -->
  <xsl:template name="extattrs">
    <xsl:if test="xpdl:ExtendedAttributes/xpdl:ExtendedAttribute">
      <h4>Extended Attributes</h4>
      <xsl:for-each select="xpdl:ExtendedAttributes/xpdl:ExtendedAttribute">
      <div class="row">
        <div class="col-lg-4">
          <tt><xsl:value-of select="@Name" /></tt>
        </div>
        <div class="col-lg-8">
          <pre>
            <xsl:value-of select="." />
            <xsl:value-of select="@Value" />
          </pre>
        </div>
      </div>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

  <xsl:template name="activity-link">
    <xsl:param name="target_act_id" />
    <xsl:param name="activities" />
    <a>
      <xsl:attribute name="href">#activity-<xsl:value-of select="$target_act_id" /></xsl:attribute>
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
      <xsl:attribute name="id">activity-<xsl:value-of select="@Id" /></xsl:attribute>
      <xsl:value-of select="@Name" />
      <xsl:text> </xsl:text>
      <small> <xsl:value-of select="@Id" /></small>
    </h3>
    <xsl:call-template name="transitions" />

    <div class="activity-info">
      <xsl:if test="xpdl:Implementation">
        <xsl:call-template name="activity_application" />
      </xsl:if>
      <xsl:if test="xpdl:Event">
        <xsl:call-template name="activity_event" />
      </xsl:if>
      <xsl:if test="xpdl:Route">
        <xsl:call-template name="activity_route" />
      </xsl:if>
      <xsl:call-template name="extattrs" />
    </div>

  </xsl:template>

  <xsl:template name="param_direction">
    <xsl:param name="mode" />
    <xsl:choose>
      <xsl:when test="$mode='IN'">
        <i class="fa fa-arrow-right"></i>
      </xsl:when>
      <xsl:when test="$mode='OUT'">
        <i class="fa fa-arrow-left"></i>
      </xsl:when>
      <xsl:when test="$mode='INOUT'">
        <i class="fa fa-arrow-left"></i>
        <i class="fa fa-arrow-right"></i>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- Process formal parameters -->
  <xsl:template name="formal_parameters">
    <h4>Formal parameters</h4>
    <ul>
      <xsl:for-each select="xpdl:FormalParameters/xpdl:FormalParameter">
        <li>
          <xsl:call-template name="param_direction">
            <xsl:with-param name="mode" select="@Mode" />
          </xsl:call-template>
          <xsl:text> </xsl:text>
          <tt>
            <xsl:value-of select="@Id" />
            <xsl:if test="xpdl:InitialValue">=<xsl:value-of select="xpdl:InitialValue" />
            </xsl:if>
          </tt>

          <p><xsl:value-of select="@Name" /></p>
          <xsl:if test="xpdl:Description">
            <p class="description">
              <xsl:value-of select="xpdl:Description" />
            </p>
          </xsl:if>

        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <xsl:template name="workflow_variables">
    <h4>Workflow Variables</h4>
    <ul>
      <xsl:for-each select="xpdl:DataFields/xpdl:DataField">
        <li>
          <tt>
            <xsl:value-of select="@Id" />
            <xsl:if test="xpdl:InitialValue">=<xsl:value-of select="xpdl:InitialValue" />
            </xsl:if>
          </tt>

          <p><xsl:value-of select="@Name" /></p>
          <xsl:if test="xpdl:Description">
            <p class="description">
              <xsl:value-of select="xpdl:Description" /></p>
          </xsl:if>

        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <!-- Process definition -->
  <xsl:template name="process">
    <h2>
      <xsl:attribute name="id">process-<xsl:value-of select="@Id" /></xsl:attribute>
      <xsl:value-of select="@Name" />
      <xsl:text> </xsl:text>
      <small> <xsl:value-of select="@Id" /></small>
    </h2>

    <div class="process-info">
      <div class="row">
        <div class="col-lg-6">
          <xsl:call-template name="formal_parameters" />
        </div>
        <div class="col-lg-6">
          <xsl:call-template name="workflow_variables" />
        </div>
      </div>
      <xsl:call-template name="extattrs" />
    </div>

    <xsl:for-each select="xpdl:Activities/xpdl:Activity">
          <xsl:call-template name="activity" />
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="navigation">
    <ul class="nav nav-list">
      <xsl:for-each select="//xpdl:WorkflowProcesses/xpdl:WorkflowProcess">
        <li>
          <a>
            <xsl:attribute name="href">#process-<xsl:value-of select="@Id" /></xsl:attribute>
            <xsl:value-of select="@Name" />
          </a>
          <ul class="nav nav-list">
            <xsl:for-each select="xpdl:Activities/xpdl:Activity">
              <li>
                <a>
                  <xsl:attribute name="href">#activity-<xsl:value-of select="@Id" /></xsl:attribute>
                  <xsl:value-of select="@Name" />
                </a>
              </li>
            </xsl:for-each>
          </ul>
        </li>
      </xsl:for-each>
    </ul>

  </xsl:template>

  <xsl:include href="flowview:layout.xslt" />

  <xsl:template match="/">
    <xsl:call-template name="layout">
      <xsl:with-param name="title">
        <xsl:value-of select="//xpdl:Package/@Name" />
      </xsl:with-param>

      <xsl:with-param name="contents">

        <h1><xsl:value-of select="//xpdl:Package/@Name" />
        <xsl:text> </xsl:text>
        <small><xsl:value-of select="//xpdl:Package/@Id" /></small>
        </h1>

        <xsl:for-each select="//xpdl:WorkflowProcesses/xpdl:WorkflowProcess">
          <xsl:call-template name="process" />
        </xsl:for-each>
      </xsl:with-param>

      <xsl:with-param name="navigation">
          <xsl:call-template name="navigation" />
      </xsl:with-param>

    </xsl:call-template>
  </xsl:template>

</xsl:stylesheet>