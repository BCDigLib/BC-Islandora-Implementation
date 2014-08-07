<?xml version="1.0" encoding="UTF-8"?>
<!--  Basic MODS  -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:foxml="info:fedora/fedora-system:def/foxml#" xmlns:mods="http://www.loc.gov/mods/v3" version="1.0" exclude-result-prefixes="mods">
  <!--
 <xsl:include href="/apps/fedora/tomcat/webapps/fedoragsearch/WEB-INF/classes/config/index/FgsIndex/islandora_transforms/library/xslt-date-template.xslt"/>
-->
  <xsl:include href="/apps/fedora/tomcat/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/islandora_transforms/library/xslt-date-template.xslt"/>
  <xsl:template match="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]" name="index_MODS">
    <xsl:param name="content"/>
    <xsl:param name="prefix"/>
    <xsl:param name="suffix">ms</xsl:param>
    <xsl:apply-templates mode="slurping_MODS" select="$content//mods:mods[1]">
      <xsl:with-param name="prefix" select="$prefix"/>
      <xsl:with-param name="suffix" select="$suffix"/>
      <xsl:with-param name="pid" select="../../@PID"/>
      <xsl:with-param name="datastream" select="../@ID"/>
    </xsl:apply-templates>
  </xsl:template>

  <!--  Handle dates.  -->
  <xsl:template match="mods:*[(@type='date') or (contains(translate(local-name(), 'D', 'd'), 'date'))][normalize-space(text())]" mode="slurping_MODS">
    <xsl:param name="prefix"/>
    <xsl:param name="suffix"/>
    <xsl:param name="pid">not provided</xsl:param>
    <xsl:param name="datastream">not provided</xsl:param>
    <!-- Get date string for display. -->
      <xsl:variable name="textValueDisplay">
          <xsl:value-of select="normalize-space(text())"/>
      </xsl:variable>
      <xsl:if test="$textValueDisplay">
          <xsl:variable name="this_prefix">
              <xsl:value-of select="$prefix"/>
              <xsl:for-each select="@*">
                  <xsl:value-of select="local-name()"/>
                  <xsl:text>_</xsl:text>
                  <xsl:value-of select="."/>
                  <xsl:text>_</xsl:text>
              </xsl:for-each>
          </xsl:variable>
          <field>
              <xsl:attribute name="name">
                  <xsl:value-of select="concat($prefix, local-name(), '_ms')"/>
              </xsl:attribute>
              <xsl:value-of select="$textValueDisplay"/>
          </field>
      </xsl:if>
    <!-- Get ISO8601 date. -->
    <xsl:variable name="textValueISO">
      <xsl:call-template name="get_ISO8601_date">
        <xsl:with-param name="date" select="normalize-space(text())"/>
        <xsl:with-param name="pid" select="$pid"/>
        <xsl:with-param name="datastream" select="$datastream"/>
      </xsl:call-template>
    </xsl:variable>
      <xsl:if test="not(normalize-space($textValueISO)='')">
      <xsl:variable name="this_prefix">
        <xsl:value-of select="$prefix"/>
        <xsl:for-each select="@*">
          <xsl:value-of select="local-name()"/>
          <xsl:text>_</xsl:text>
          <xsl:value-of select="."/>
          <xsl:text>_</xsl:text>
        </xsl:for-each>
      </xsl:variable>
      <field>
        <xsl:attribute name="name">
          <xsl:value-of select="concat($this_prefix, local-name(), '_dt')"/>
        </xsl:attribute>
        <xsl:value-of select="$textValueISO"/>
      </field>
      <field>
        <xsl:attribute name="name">
          <xsl:value-of select="concat($prefix, local-name(), '_mdt')"/>
        </xsl:attribute>
        <xsl:value-of select="$textValueISO"/>
      </field>
    </xsl:if>
  </xsl:template>

  <!--  Avoid using text alone.  -->
  <xsl:template match="text()" mode="slurping_MODS"/>

  <xsl:template match="*" mode="slurping_MODS">
    <xsl:param name="prefix"/>
    <xsl:param name="suffix"/>
    <xsl:param name="pid">not provided</xsl:param>
    <xsl:param name="datastream">not provided</xsl:param>
    <xsl:apply-templates select="mods:name"/>
    <xsl:apply-templates select="mods:name/mods:affiliation"/>

     <!--  Build up the list prefix with the element context.  -->
    <xsl:variable name="this_prefix">
      <xsl:value-of select="concat($prefix, local-name(), '_')"/>
      <xsl:if test="@type">
        <xsl:value-of select="translate(@type, ' ', '')"/>
        <xsl:text>_</xsl:text>
      </xsl:if>
      <xsl:if test="@usage">
        <xsl:value-of select="translate(@usage, ' ', '')"/>
        <xsl:text>_</xsl:text>
      </xsl:if>
      <xsl:if test="@authority='ndltd'">
        <xsl:value-of select="@authority"/>
        <xsl:text>_</xsl:text>
      </xsl:if>
        <xsl:if test="@authority='marcgt' or @authority='local'">
        <xsl:text>marcgtorlocal_</xsl:text>
      </xsl:if>
    </xsl:variable>

    <xsl:variable name="textValue">
      <xsl:value-of select="normalize-space(text())"/>
    </xsl:variable>
    <xsl:if test="$textValue">
      <field>
        <xsl:attribute name="name">
          <xsl:value-of select="concat($this_prefix, $suffix)"/>
        </xsl:attribute>
        <xsl:value-of select="$textValue"/>
      </field>
    </xsl:if>
    <xsl:apply-templates mode="slurping_MODS">
      <xsl:with-param name="prefix" select="$this_prefix"/>
      <xsl:with-param name="suffix" select="$suffix"/>
      <xsl:with-param name="pid" select="$pid"/>
      <xsl:with-param name="datastream" select="$datastream"/>
    </xsl:apply-templates>
  </xsl:template>

    <xsl:template match="mods:name">
        <xsl:param name="prefix"/>
        <xsl:param name="suffix">_ms</xsl:param>
        <xsl:param name="pid">not provided</xsl:param>
        <xsl:param name="datastream">not provided</xsl:param>
        <xsl:variable name="this_prefix">
            <xsl:value-of select="$prefix"/>
            <xsl:value-of select="translate(mods:role/mods:roleTerm[@type='text'], ' ', '_')"/>
        </xsl:variable>
        <xsl:variable name="textValue">
            <xsl:value-of select="normalize-space(mods:displayForm)"/>
        </xsl:variable>
        <xsl:if test="$textValue">
            <field>
                <xsl:attribute name="name">
                    <xsl:value-of select="concat($this_prefix, $suffix)"/>
                </xsl:attribute>
                <xsl:value-of select="$textValue"/>
            </field>
        </xsl:if>
    </xsl:template>

    <xsl:template match="mods:name/mods:affiliation">
        <xsl:param name="prefix"/>
        <xsl:param name="suffix">_ms</xsl:param>
        <xsl:param name="pid">not provided</xsl:param>
        <xsl:param name="datastream">not provided</xsl:param>
        <xsl:variable name="this_prefix">
            <xsl:value-of select="$prefix"/>
            <xsl:if test="contains(., ', Boston College') or contains(., 'Carroll School of Management') or contains(., 'Connell School of Nursing') or contains(., 'Lynch School of Education') or contains(., 'Graduate School of Social Work') or contains(., 'School of Theology and Ministry')">
                <xsl:text>Classification</xsl:text>
            </xsl:if>  
        </xsl:variable>
        <xsl:variable name="textValue">
            <xsl:if test=".='Dept. of Biology, Boston College'">
                <xsl:text>Biology</xsl:text>
            </xsl:if>
            <xsl:if test=".='Dept. of Business Law, Carroll School of Management'">
                <xsl:text>Business Law</xsl:text>
            </xsl:if>
            <xsl:if test=".='Dept. of Chemistry, Boston College'">
                <xsl:text>Chemistry</xsl:text>
            </xsl:if>
            <xsl:if test=".='Dept. of Classical Studies, Boston College'">
                <xsl:text>Classical Studies</xsl:text>
            </xsl:if>
            <xsl:if test=".='Dept. of Economics, Boston College'">
                <xsl:text>Economics</xsl:text>
            </xsl:if>
            <xsl:if test=".='Dept. of Counseling, Developmental, and Educational Psychology, Lynch School of Education'">
                <xsl:text>Education</xsl:text>
            </xsl:if>
            <xsl:if test=".='Dept. of Educational Administration and Higher Education, Lynch School of Education'">
                <xsl:text>Education</xsl:text>
            </xsl:if>
            <xsl:if test=".='Dept. of Educational Research, Measurement and Evaluation, Lynch School of Education'">
                <xsl:text>Education</xsl:text>
            </xsl:if>
            <xsl:if test=".='Dept. of Teacher Education, Special Education, Curriculum and Instruction, Lynch School of Education'">
                <xsl:text>Education</xsl:text>
            </xsl:if>
            <xsl:if test=".='Dept. of English, Boston College'">
                <xsl:text>English</xsl:text>
            </xsl:if>
            <xsl:if test=".='Dept. of Finance, Carroll School of Management'">
                <xsl:text>Finance</xsl:text>
            </xsl:if>
            <xsl:if test=".='Dept. of History, Boston College'">
                <xsl:text>History</xsl:text>
            </xsl:if>
            <xsl:if test=".='Dept. of Marketing, Carroll School of Management'">
                <xsl:text>Marketing</xsl:text>
            </xsl:if>
            <xsl:if test=".='Adult Health, Connell School of Nursing'">
                <xsl:text>Nursing</xsl:text>
            </xsl:if>
            <xsl:if test=".='Maternal/Child Health Nursing, Connell School of Nursing'">
                <xsl:text>Nursing</xsl:text>
            </xsl:if>
            <xsl:if test=".='Dept. of Operations and Strategic Management, Carroll School of Management'">
                <xsl:text>Operations and Strategic Management</xsl:text>
            </xsl:if>
            <xsl:if test=".='Dept. of Organization Studies, Carroll School of Management'">
                <xsl:text>Organization Studies</xsl:text>
            </xsl:if>
            <xsl:if test=".='Dept. of Philosophy, Boston College'">
                <xsl:text>Philosophy</xsl:text>
            </xsl:if>
            <xsl:if test=".='Dept. of Physics, Boston College'">
                <xsl:text>Physics</xsl:text>
            </xsl:if>
            <xsl:if test=".='Dept. of Psychology, Boston College'">
                <xsl:text>Psychology</xsl:text>
            </xsl:if>
            <xsl:if test=".='Dept. of Romance Languages &amp; Literatures, Boston College'">
                <xsl:text>Romance Languages and Literatures</xsl:text>
            </xsl:if>
            <xsl:if test=".='Dept. of Slavic &amp; Eastern Languages and Literature, Boston College'">
                <xsl:text>Slavic and Eastern Language and Literatures</xsl:text>
            </xsl:if>
            <xsl:if test=".='Dept. of Slavic and Eastern Languages, Boston College'">
                <xsl:text>Slavic and Eastern Language and Literatures</xsl:text>
            </xsl:if>
            <xsl:if test=".='Graduate School of Social Work'">
                <xsl:text>Social Work</xsl:text>
            </xsl:if>
            <xsl:if test=".='Graduate School of Social Work, Boston College'">
                <xsl:text>Social Work</xsl:text>
            </xsl:if>
            <xsl:if test=".='Dept. of Sociology, Boston College'">
                <xsl:text>Sociology</xsl:text>
            </xsl:if>
            <xsl:if test=".='Dept. of Theology, Boston College'">
                <xsl:text>Theology</xsl:text>
            </xsl:if>
            <xsl:if test=".='Boston College. School of Theology and Ministry'">
                <xsl:text>Theology and Ministry</xsl:text>
            </xsl:if>
            <xsl:if test=".='School of Theology and Ministry'">
                <xsl:text>Theology and Ministry</xsl:text>
            </xsl:if>
        </xsl:variable>
        <xsl:if test="$textValue">
            <field>
                <xsl:attribute name="name">
                    <xsl:value-of select="concat($this_prefix, $suffix)"/>
                </xsl:attribute>
                <xsl:value-of select="$textValue"/>
            </field>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>