<?xml version="1.0" encoding="UTF-8"?>
<!--  Basic MODS  -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:foxml="info:fedora/fedora-system:def/foxml#" xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:etdms="http://www.ndltd.org/standards/metadata/etdms/1.0/" version="1.0"
    exclude-result-prefixes="mods etdms">
    <xsl:include
        href="/apps/fedora/tomcat/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/islandora_transforms/library/xslt-date-template.xslt"/>
    <xsl:template match="foxml:datastream[@ID = 'MODS']/foxml:datastreamVersion[last()]"
        name="index_MODS">
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
    <xsl:template
        match="mods:*[(@type = 'date') or (contains(translate(local-name(), 'D', 'd'), 'date'))][normalize-space(text())]"
        mode="slurping_MODS">
        <xsl:param name="prefix"/>
        <xsl:param name="suffix"/>
        <xsl:param name="pid">not provided</xsl:param>
        <xsl:param name="datastream">not provided</xsl:param>
        <!-- Get date string for display. -->
        <xsl:if test="not(@encoding)">
            <xsl:variable name="textValueDisplay">
                <xsl:value-of select="normalize-space(text())"/>
            </xsl:variable>
            <xsl:if test="not(normalize-space($textValueDisplay) = '')">
                <field>
                    <xsl:attribute name="name">
                        <xsl:value-of select="concat($prefix, local-name(), '_ms')"/>
                    </xsl:attribute>
                    <xsl:value-of select="$textValueDisplay"/>
                </field>
            </xsl:if>
        </xsl:if>
        <!-- Get ISO8601 date. -->
        <xsl:variable name="textValueISO">
            <xsl:call-template name="get_ISO8601_date">
                <xsl:with-param name="date" select="normalize-space(text())"/>
                <xsl:with-param name="pid" select="$pid"/>
                <xsl:with-param name="datastream" select="$datastream"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:if test="not(normalize-space($textValueISO) = '')">
            <xsl:variable name="this_prefix">
                <xsl:value-of select="$prefix"/>
                <xsl:for-each select="@*">
                    <xsl:value-of select="local-name()"/>
                    <xsl:text>_</xsl:text>
                    <xsl:value-of select="."/>
                    <xsl:text>_</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="ancestor::mods:relatedItem"/>
                <xsl:otherwise>
                    <field>
                        <xsl:attribute name="name">
                            <xsl:value-of select="concat($this_prefix, local-name(), '_dt')"/>
                        </xsl:attribute>
                        <xsl:value-of select="$textValueISO"/>
                    </field>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="@keyDate = 'yes'">
                <xsl:choose>
                    <xsl:when test="ancestor::mods:relatedItem"/>
                    <xsl:otherwise>
                        <field>
                            <xsl:attribute name="name">
                                <xsl:text>mods_originInfo_dateIssued_and_dateCreated_mdt</xsl:text>
                            </xsl:attribute>
                            <xsl:value-of select="$textValueISO"/>
                        </field>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <xsl:if
                test="concat($this_prefix, local-name()) = 'mods_originInfo_dateIssued' or concat($this_prefix, local-name()) = 'mods_originInfo_dateCreated'">
                <field>
                    <xsl:attribute name="name">
                        <xsl:text>mods_originInfo_dateIssued_and_dateCreated_dt</xsl:text>
                    </xsl:attribute>
                    <xsl:value-of select="$textValueISO"/>
                </field>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <!--  Avoid using text alone.  -->
    <xsl:template match="text()" mode="slurping_MODS"/>

    <xsl:template match="*" mode="slurping_MODS">
        <xsl:param name="prefix"/>
        <xsl:param name="suffix"/>
        <xsl:param name="pid">not provided</xsl:param>
        <xsl:param name="datastream">not provided</xsl:param>

        <xsl:call-template name="genre"/>
        <xsl:call-template name="role"/>
        <xsl:call-template name="collection"/>
        <xsl:call-template name="discipline"/>
        <xsl:call-template name="school"/>
        <xsl:call-template name="center"/>
        <xsl:call-template name="name"/>

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
            <xsl:if test="@authority = 'ndltd'">
                <xsl:value-of select="@authority"/>
                <xsl:text>_</xsl:text>
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

    <xsl:template name="genre">
        <xsl:param name="prefix"/>
        <xsl:param name="suffix">_ms</xsl:param>
        <xsl:param name="pid">not provided</xsl:param>
        <xsl:param name="datastream">not provided</xsl:param>
        <xsl:for-each select="mods:genre[not(parent::mods:relatedItem)]">
            <xsl:if test="@authority = 'marcgt' or @authority = 'local'">
                <xsl:variable name="this_prefix">
                    <xsl:value-of select="concat($prefix, 'mods_genre_marcgtorlocal')"/>
                </xsl:variable>
                <xsl:variable name="textValue">
                    <xsl:value-of select="normalize-space(text())"/>
                </xsl:variable>
                <field>
                    <xsl:attribute name="name">
                        <xsl:value-of select="concat($this_prefix, $suffix)"/>
                    </xsl:attribute>
                    <xsl:value-of select="$textValue"/>
                </field>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="role">
        <!-- Role term facet -->
        <xsl:param name="prefix"/>
        <xsl:param name="suffix">_ms</xsl:param>
        <xsl:param name="pid">not provided</xsl:param>
        <xsl:param name="datastream">not provided</xsl:param>
        <xsl:for-each select="mods:name[not(parent::mods:relatedItem)]">
            <xsl:variable name="this_prefix">
                <xsl:value-of select="$prefix"/>
                <xsl:value-of select="translate(mods:role/mods:roleTerm[@type = 'text'], ' ', '_')"
                />
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
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="collection">
        <xsl:param name="prefix"/>
        <xsl:param name="suffix">_ms</xsl:param>
        <xsl:param name="pid">not provided</xsl:param>
        <xsl:param name="datastream">not provided</xsl:param>
        <xsl:for-each select="mods:name/mods:description">
            <xsl:if test="not(preceding::mods:description != 'nonfaculty')">
                <xsl:variable name="this_prefix">
                    <xsl:value-of select="concat($prefix, 'local_collection')"/>
                </xsl:variable>
                <xsl:variable name="textValue">
                    <xsl:choose>
                        <xsl:when test=". != 'nonfaculty' and . != ''">
                            <xsl:text>Faculty Works</xsl:text>
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>
                </xsl:variable>
                <xsl:if test="not(normalize-space($textValue) = '')">
                    <field>
                        <xsl:attribute name="name">
                            <xsl:value-of select="concat($this_prefix, $suffix)"/>
                        </xsl:attribute>
                        <xsl:value-of select="$textValue"/>
                    </field>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="mods:extension/localCollectionName">
            <xsl:if test=". = 'repec'">
                <xsl:variable name="this_prefix">
                    <xsl:value-of select="concat($prefix, 'local_collection')"/>
                </xsl:variable>
                <xsl:variable name="textValue">
                    <xsl:text>Faculty Works</xsl:text>
                </xsl:variable>
                <field>
                    <xsl:attribute name="name">
                        <xsl:value-of select="concat($this_prefix, $suffix)"/>
                    </xsl:attribute>
                    <xsl:value-of select="$textValue"/>
                </field>
            </xsl:if>
            <xsl:if
                test=". = 'c21' or . = 'chrij' or . = 'crr' or . = 'cwp' or . = 'scaw' or . = 'timss-pirls' or . = 'wfrn'">
                <xsl:variable name="this_prefix">
                    <xsl:value-of select="concat($prefix, 'local_collection')"/>
                </xsl:variable>
                <xsl:variable name="textValue">
                    <xsl:text>Research Centers</xsl:text>
                </xsl:variable>
                <field>
                    <xsl:attribute name="name">
                        <xsl:value-of select="concat($this_prefix, $suffix)"/>
                    </xsl:attribute>
                    <xsl:value-of select="$textValue"/>
                </field>
            </xsl:if>
            <xsl:if test=". = 'dataset'">
                <xsl:variable name="this_prefix">
                    <xsl:value-of select="concat($prefix, 'local_collection')"/>
                </xsl:variable>
                <xsl:variable name="textValue">
                    <xsl:text>Data Archive</xsl:text>
                </xsl:variable>
                <field>
                    <xsl:attribute name="name">
                        <xsl:value-of select="concat($this_prefix, $suffix)"/>
                    </xsl:attribute>
                    <xsl:value-of select="$textValue"/>
                </field>
            </xsl:if>
            <xsl:if test=". = 'GISCONTEST'">
                <xsl:variable name="this_prefix">
                    <xsl:value-of select="concat($prefix, 'local_collection')"/>
                </xsl:variable>
                <xsl:variable name="textValue">
                    <xsl:text>Juried Student Work</xsl:text>
                </xsl:variable>
                <field>
                    <xsl:attribute name="name">
                        <xsl:value-of select="concat($this_prefix, $suffix)"/>
                    </xsl:attribute>
                    <xsl:value-of select="$textValue"/>
                </field>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="mods:extension/etdms:degree">
            <xsl:choose>
                <xsl:when test="etdms:level = 'Bachelors'">
                    <xsl:variable name="this_prefix">
                        <xsl:value-of select="concat($prefix, 'local_collection')"/>
                    </xsl:variable>
                    <xsl:variable name="textValue">
                        <xsl:text>Undergraduate Honors Theses</xsl:text>
                    </xsl:variable>
                    <field>
                        <xsl:attribute name="name">
                            <xsl:value-of select="concat($this_prefix, $suffix)"/>
                        </xsl:attribute>
                        <xsl:value-of select="$textValue"/>
                    </field>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="this_prefix">
                        <xsl:value-of select="concat($prefix, 'local_collection')"/>
                    </xsl:variable>
                    <xsl:variable name="textValue">
                        <xsl:text>Graduate Theses and Dissertations</xsl:text>
                    </xsl:variable>
                    <field>
                        <xsl:attribute name="name">
                            <xsl:value-of select="concat($this_prefix, $suffix)"/>
                        </xsl:attribute>
                        <xsl:value-of select="$textValue"/>
                    </field>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="discipline">
        <xsl:param name="prefix"/>
        <xsl:param name="suffix">_ms</xsl:param>
        <xsl:param name="pid">not provided</xsl:param>
        <xsl:param name="datastream">not provided</xsl:param>

        <!-- Discipline facet for non-ETD MODS. -->
        <xsl:for-each select="mods:name/mods:affiliation">
            <xsl:variable name="this_prefix">
                <xsl:value-of select="$prefix"/>
                <xsl:if
                    test="contains(., ', Boston College') or contains(., 'Carroll School of Management') or contains(., 'Connell School of Nursing') or contains(., 'Lynch School of Education') or contains(., 'Graduate School of Social Work') or contains(., 'School of Theology and Ministry')">
                    <xsl:text>discipline</xsl:text>
                </xsl:if>
            </xsl:variable>
            <xsl:variable name="textValue">
                <xsl:choose>
                    <xsl:when test=". = 'Dept. of Biology, Boston College'">
                        <xsl:text>Biology</xsl:text>
                    </xsl:when>
                    <xsl:when test=". = 'Dept. of Business Law, Carroll School of Management'">
                        <xsl:text>Business Law</xsl:text>
                    </xsl:when>
                    <xsl:when test=". = 'Dept. of Chemistry, Boston College'">
                        <xsl:text>Chemistry</xsl:text>
                    </xsl:when>
                    <xsl:when test=". = 'Dept. of Classical Studies, Boston College'">
                        <xsl:text>Classical Studies</xsl:text>
                    </xsl:when>
                    <xsl:when test=". = 'Dept. of Earth and Environmental Sciences, Boston College'">
                        <xsl:text>Earth and Environmental Sciences</xsl:text>
                    </xsl:when>
                    <xsl:when test=". = 'Dept. of Economics, Boston College'">
                        <xsl:text>Economics</xsl:text>
                    </xsl:when>
                    <xsl:when
                        test=". = 'Dept. of Counseling, Developmental, and Educational Psychology, Lynch School of Education'">
                        <xsl:text>Education</xsl:text>
                    </xsl:when>
                    <xsl:when
                        test=". = 'Dept. of Educational Administration and Higher Education, Lynch School of Education'">
                        <xsl:text>Education</xsl:text>
                    </xsl:when>
                    <xsl:when
                        test=". = 'Dept. of Educational Research, Measurement and Evaluation, Lynch School of Education'">
                        <xsl:text>Education</xsl:text>
                    </xsl:when>
                    <xsl:when
                        test=". = 'Dept. of Teacher Education, Special Education, Curriculum and Instruction, Lynch School of Education'">
                        <xsl:text>Education</xsl:text>
                    </xsl:when>
                    <xsl:when test=". = 'Dept. of English, Boston College'">
                        <xsl:text>English</xsl:text>
                    </xsl:when>
                    <xsl:when test=". = 'Dept. of Finance, Carroll School of Management'">
                        <xsl:text>Finance</xsl:text>
                    </xsl:when>
                    <xsl:when test=". = 'Dept. of Fine Arts, Boston College'">
                        <xsl:text>Fine Arts</xsl:text>
                    </xsl:when>
                    <xsl:when test=". = 'Dept. of History, Boston College'">
                        <xsl:text>History</xsl:text>
                    </xsl:when>
                    <xsl:when test=". = 'Dept. of Marketing, Carroll School of Management'">
                        <xsl:text>Marketing</xsl:text>
                    </xsl:when>
                    <xsl:when test=". = 'Connell School of Nursing'">
                        <xsl:text>Nursing</xsl:text>
                    </xsl:when>
                    <xsl:when test=". = 'Adult Health, Connell School of Nursing'">
                        <xsl:text>Nursing</xsl:text>
                    </xsl:when>
                    <xsl:when test=". = 'Maternal/Child Health Nursing, Connell School of Nursing'">
                        <xsl:text>Nursing</xsl:text>
                    </xsl:when>
                    <xsl:when
                        test=". = 'Dept. of Operations and Strategic Management, Carroll School of Management'">
                        <xsl:text>Operations and Strategic Management</xsl:text>
                    </xsl:when>
                    <xsl:when
                        test=". = 'Dept. of Organization Studies, Carroll School of Management'">
                        <xsl:text>Organization Studies</xsl:text>
                    </xsl:when>
                    <xsl:when test=". = 'Dept. of Philosophy, Boston College'">
                        <xsl:text>Philosophy</xsl:text>
                    </xsl:when>
                    <xsl:when test=". = 'Dept. of Physics, Boston College'">
                        <xsl:text>Physics</xsl:text>
                    </xsl:when>
                    <xsl:when test=". = 'Dept. of Political Science, Boston College'">
                        <xsl:text>Political Science</xsl:text>
                    </xsl:when>
                    <xsl:when test=". = 'Dept. of Psychology, Boston College'">
                        <xsl:text>Psychology</xsl:text>
                    </xsl:when>
                    <xsl:when
                        test=".='Dept. of Romance Languages &amp; Literatures, Boston College'">
                        <xsl:text>Romance Languages and Literatures</xsl:text>
                    </xsl:when>
                    <xsl:when
                        test=".='Dept. of Slavic &amp; Eastern Languages and Literature, Boston College'">
                        <xsl:text>Slavic and Eastern Languages and Literatures</xsl:text>
                    </xsl:when>
                    <xsl:when
                        test=".='Dept. of Slavic &amp; Eastern Languages and Literatures, Boston College'">
                        <xsl:text>Slavic and Eastern Languages and Literatures</xsl:text>
                    </xsl:when>
                    <xsl:when test=". = 'Dept. of Slavic and Eastern Languages, Boston College'">
                        <xsl:text>Slavic and Eastern Languages and Literatures</xsl:text>
                    </xsl:when>
                    <xsl:when test=". = 'School of Social Work, Boston College'">
                        <xsl:text>Social Work</xsl:text>
                    </xsl:when>
                    <xsl:when test=". = 'Graduate School of Social Work'">
                        <xsl:text>Social Work</xsl:text>
                    </xsl:when>
                    <xsl:when test=". = 'Graduate School of Social Work, Boston College'">
                        <xsl:text>Social Work</xsl:text>
                    </xsl:when>
                    <xsl:when test=". = 'Dept. of Sociology, Boston College'">
                        <xsl:text>Sociology</xsl:text>
                    </xsl:when>
                    <xsl:when test=". = 'Dept. of Theology, Boston College'">
                        <xsl:text>Theology</xsl:text>
                    </xsl:when>
                    <xsl:when test=". = 'Boston College. School of Theology and Ministry'">
                        <xsl:text>Theology and Ministry</xsl:text>
                    </xsl:when>
                    <xsl:when test=". = 'School of Theology and Ministry'">
                        <xsl:text>Theology and Ministry</xsl:text>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:variable>
            <xsl:if test="not(normalize-space($textValue) = '')">
                <field>
                    <xsl:attribute name="name">
                        <xsl:value-of select="concat($this_prefix, $suffix)"/>
                    </xsl:attribute>
                    <xsl:value-of select="$textValue"/>
                </field>
            </xsl:if>
        </xsl:for-each>

        <!-- Discipline facet for RePec MODS. -->
        <xsl:for-each select="mods:extension/localCollectionName[. = 'repec']">
            <xsl:variable name="this_prefix">
                <xsl:value-of select="concat($prefix, 'discipline')"/>
            </xsl:variable>
            <xsl:variable name="textValue">
                <xsl:text>Economics</xsl:text>
            </xsl:variable>
            <field>
                <xsl:attribute name="name">
                    <xsl:value-of select="concat($this_prefix, $suffix)"/>
                </xsl:attribute>
                <xsl:value-of select="$textValue"/>
            </field>
        </xsl:for-each>

        <!-- Discipline facet for ETD MODS. -->
        <xsl:for-each select="mods:extension/etdms:degree/etdms:discipline">
            <xsl:variable name="this_prefix">
                <xsl:value-of select="concat($prefix, 'discipline')"/>
            </xsl:variable>
            <xsl:variable name="textValue">
                <xsl:choose>
                    <xsl:when test="contains(., 'Accounting')">
                        <xsl:text>Accounting</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'Applied Developmental')">
                        <xsl:text>Education</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'Biology')">
                        <xsl:text>Biology</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'Business Law')">
                        <xsl:text>Business Law</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'Chemistry')">
                        <xsl:text>Chemistry</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'Classical Studies')">
                        <xsl:text>Classical Studies</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'Communication')">
                        <xsl:text>Communication</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'Counseling')">
                        <xsl:text>Education</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'Curriculum')">
                        <xsl:text>Education</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'Computer Science')">
                        <xsl:text>Computer Science</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'Earth')">
                        <xsl:text>Earth and Environmental Sciences</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'Economics')">
                        <xsl:text>Economics</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'Religious Education and Pastoral Ministry')">
                        <xsl:text>Religious Education and Pastoral Ministry</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'Theology and Education')">
                        <xsl:text>Theology and Education</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'Educational')">
                        <xsl:text>Education</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'Education')">
                        <xsl:text>Education</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'English')">
                        <xsl:text>English</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'Film')">
                        <xsl:text>Film Studies</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'Finance')">
                        <xsl:text>Finance</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'Fine Arts')">
                        <xsl:text>Fine Arts</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'Geology')">
                        <xsl:text>Geology and Geophysics</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'German')">
                        <xsl:text>German Studies</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'History')">
                        <xsl:text>History</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'International Studies')">
                        <xsl:text>International Studies</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'Islamic Civilizations')">
                        <xsl:text>Islamic Civilizations</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'Management and Organization')">
                        <xsl:text>Management and Organization</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'Management')">
                        <xsl:text>Management</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'Mathematics')">
                        <xsl:text>Mathematics</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'Music')">
                        <xsl:text>Music</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'Nursing')">
                        <xsl:text>Nursing</xsl:text>
                    </xsl:when>
                    <xsl:when
                        test="contains(., 'Organization Studies and Corporate Responsibility')">
                        <xsl:text>Corporate Responsibility</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'Organization Studies')">
                        <xsl:text>Organization Studies</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'Philosophy')">
                        <xsl:text>Philosophy</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'Physics')">
                        <xsl:text>Physics</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'Political Science')">
                        <xsl:text>Political Science</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'Psychology')">
                        <xsl:text>Psychology</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'Romance Languages')">
                        <xsl:text>Romance Languages and Literatures</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'Sacred Theology')">
                        <xsl:text>Sacred Theology</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'Slavic and Eastern Languages')">
                        <xsl:text>Slavic and Eastern Languages and Literatures</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'Social Work')">
                        <xsl:text>Social Work</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'Sociology')">
                        <xsl:text>Sociology</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'Theater')">
                        <xsl:text>Theater</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'Theology')">
                        <xsl:text>Theology</xsl:text>
                    </xsl:when>
                    <!--  
                    <xsl:when test="contains(., 'College Honors')">
                        <xsl:text>College Honors Program</xsl:text>
                    </xsl:when>
-->
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:variable>
            <xsl:if test="not(normalize-space($textValue) = '')">
                <field>
                    <xsl:attribute name="name">
                        <xsl:value-of select="concat($this_prefix, $suffix)"/>
                    </xsl:attribute>
                    <xsl:value-of select="$textValue"/>
                </field>
            </xsl:if>
        </xsl:for-each>

    </xsl:template>

    <xsl:template name="school">
        <xsl:param name="prefix"/>
        <xsl:param name="suffix">_ms</xsl:param>
        <xsl:param name="pid">not provided</xsl:param>
        <xsl:param name="datastream">not provided</xsl:param>

        <!-- School facet for non-ETD MODS. -->
        <xsl:for-each select="mods:name/mods:affiliation">
            <xsl:variable name="this_prefix">
                <xsl:value-of select="$prefix"/>
                <xsl:if
                    test="contains(., ', Boston College') or contains(., 'Carroll School of Management') or contains(., 'Connell School of Nursing') or contains(., 'Lynch School of Education') or contains(., 'Graduate School of Social Work') or contains(., 'School of Theology and Ministry')">
                    <xsl:text>school</xsl:text>
                </xsl:if>
            </xsl:variable>
            <xsl:variable name="textValue">
                <xsl:choose>
                    <xsl:when test="contains(., ', Boston College') and starts-with(., 'Dept.')">
                        <xsl:text>Arts and Sciences</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'Carroll School of Management')">
                        <xsl:text>Carroll School of Management</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'Connell School of Nursing')">
                        <xsl:text>Connell School of Nursing</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'Lynch School of Education')">
                        <xsl:text>Lynch School of Education</xsl:text>
                    </xsl:when>
                    <xsl:when
                        test="contains(., 'Graduate School of Social Work') or contains(., 'School of Social Work')">
                        <xsl:text>School of Social Work</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'School of Theology and Ministry')">
                        <xsl:text>School of Theology and Ministry</xsl:text>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:variable>
            <xsl:if test="not(normalize-space($textValue) = '')">
                <field>
                    <xsl:attribute name="name">
                        <xsl:value-of select="concat($this_prefix, $suffix)"/>
                    </xsl:attribute>
                    <xsl:value-of select="$textValue"/>
                </field>
            </xsl:if>
        </xsl:for-each>

        <!-- School facet for RePec MODS. -->

        <xsl:for-each select="mods:extension/localCollectionName[. = 'repec']">
            <xsl:variable name="this_prefix">
                <xsl:value-of select="concat($prefix, 'school')"/>
            </xsl:variable>
            <xsl:variable name="textValue">
                <xsl:text>Arts and Sciences</xsl:text>
            </xsl:variable>
            <field>
                <xsl:attribute name="name">
                    <xsl:value-of select="concat($this_prefix, $suffix)"/>
                </xsl:attribute>
                <xsl:value-of select="$textValue"/>
            </field>
        </xsl:for-each>



        <!-- School facet for ETD MODS. -->
        <xsl:for-each select="mods:extension/etdms:degree/etdms:grantor">
            <xsl:variable name="this_prefix">
                <xsl:if test=".">
                    <xsl:value-of select="$prefix"/>
                    <xsl:text>school</xsl:text>
                </xsl:if>
            </xsl:variable>
            <xsl:variable name="textValue">
                <xsl:choose>
                    <xsl:when test="contains(., 'Arts and Sciences')">
                        <xsl:text>Arts and Sciences</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'Carroll School of Management')">
                        <xsl:text>Carroll School of Management</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'Connell School of Nursing')">
                        <xsl:text>Connell School of Nursing</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'Lynch School of Education')">
                        <xsl:text>Lynch School of Education</xsl:text>
                    </xsl:when>
                    <xsl:when
                        test="contains(., 'Graduate School of Social Work') or contains(., 'School of Social Work')">
                        <xsl:text>School of Social Work</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'School of Theology and Ministry')">
                        <xsl:text>School of Theology and Ministry</xsl:text>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:variable>
            <xsl:if test="not(normalize-space($textValue) = '')">
                <field>
                    <xsl:attribute name="name">
                        <xsl:value-of select="concat($this_prefix, $suffix)"/>
                    </xsl:attribute>
                    <xsl:value-of select="$textValue"/>
                </field>
            </xsl:if>
        </xsl:for-each>

    </xsl:template>

    <xsl:template name="center">
        <xsl:param name="prefix"/>
        <xsl:param name="suffix">_ms</xsl:param>
        <xsl:param name="pid">not provided</xsl:param>
        <xsl:param name="datastream">not provided</xsl:param>

        <!-- Center facet for non-ETD MODS. -->
        <xsl:for-each select="mods:extension/localCollectionName">
            <xsl:variable name="this_prefix">
                <xsl:if
                    test=". = 'c21' or . = 'chrij' or . = 'crr' or . = 'cwp' or . = 'scaw' or . = 'timss-pirls' or . = 'wfrn'">
                    <xsl:value-of select="$prefix"/>
                    <xsl:text>center</xsl:text>
                </xsl:if>
            </xsl:variable>
            <xsl:variable name="textValue">
                <xsl:choose>
                    <xsl:when test=". = 'c21'">
                        <xsl:text>Church in the 21st Century Center</xsl:text>
                    </xsl:when>
                    <xsl:when test=". = 'chrij'">
                        <xsl:text>Center for Human Rights and International Justice</xsl:text>
                    </xsl:when>
                    <xsl:when test=". = 'crr'">
                        <xsl:text>Center for Retirement Research</xsl:text>
                    </xsl:when>
                    <xsl:when test=". = 'cwp'">
                        <xsl:text>Center on Wealth and Philanthropy</xsl:text>
                    </xsl:when>
                    <xsl:when test=". = 'scaw'">
                        <xsl:text>Center on Aging and Work</xsl:text>
                    </xsl:when>
                    <xsl:when test=". = 'timss-pirls'">
                        <xsl:text>TIMSS and PIRLS International Study Center</xsl:text>
                    </xsl:when>
                    <xsl:when test=". = 'wfrn'">
                        <xsl:text>Work and Family Research Network</xsl:text>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:variable>
            <xsl:if test="not(normalize-space($textValue) = '')">
                <field>
                    <xsl:attribute name="name">
                        <xsl:value-of select="concat($this_prefix, $suffix)"/>
                    </xsl:attribute>
                    <xsl:value-of select="$textValue"/>
                </field>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>


    <xsl:template name="name">
        <xsl:param name="prefix"/>
        <xsl:param name="suffix">_ms</xsl:param>
        <xsl:param name="pid">not provided</xsl:param>
        <xsl:param name="datastream">not provided</xsl:param>

        <!-- Virtual field to idenitfy faculty/non-faculty. -->
        <xsl:for-each select="mods:name/mods:description">
            <xsl:variable name="this_prefix">
                <xsl:value-of select="concat($prefix, 'bc_affiliate')"/>
            </xsl:variable>
            <xsl:variable name="textValue">
                <xsl:choose>
                    <xsl:when test=". != 'nonfaculty' and . != ''">
                        <xsl:text>faculty</xsl:text>
                    </xsl:when>
                    <xsl:when test=". = 'nonfaculty'">
                        <xsl:text>non-faculty</xsl:text>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:variable>
            <xsl:if test="not(normalize-space($textValue) = '')">
                <field>
                    <xsl:attribute name="name">
                        <xsl:value-of select="concat($this_prefix, $suffix)"/>
                    </xsl:attribute>
                    <xsl:value-of select="$textValue"/>
                </field>
            </xsl:if>
        </xsl:for-each>

        <!-- Virtual field to transform ORCID into url. -->
        <xsl:for-each select="mods:name/mods:nameIdentifier[@type = 'orcid']">
            <xsl:choose>
                <xsl:when test="not(. = '')">
                    <xsl:variable name="this_prefix">
                        <xsl:value-of select="concat($prefix, 'orcid')"/>
                    </xsl:variable>
                    <xsl:variable name="textValue">
                        <xsl:text>https://orcid.org/</xsl:text>
                        <xsl:value-of select="."/>
                    </xsl:variable>
                    <field>
                        <xsl:attribute name="name">
                            <xsl:value-of select="concat($this_prefix, $suffix)"/>
                        </xsl:attribute>
                        <!-- Need to use xsl:text here because xsl:element breaks Solr -->
                        <xsl:text>&#60;a href="</xsl:text><xsl:value-of select="$textValue"/><xsl:text>" target="_blank"&#62;</xsl:text>
                            <xsl:if test="preceding-sibling::mods:namePart[@type='given']">
                                <xsl:value-of select="preceding-sibling::mods:namePart[@type='given']/text()"/>
                                <xsl:text>&#160;</xsl:text>
                                <xsl:value-of select="preceding-sibling::mods:namePart[@type='family']/text()"/>
                                <xsl:text>'s</xsl:text>
                                <xsl:text>&#160;</xsl:text>
                            </xsl:if>
                            <xsl:if test="following-sibling::mods:namePart[@type='given']">
                                <xsl:value-of select="following-sibling::mods:namePart[@type='given']/text()"/>
                                <xsl:text>&#160;</xsl:text>
                                <xsl:value-of select="following-sibling::mods:namePart[@type='family']/text()"/>
                                <xsl:text>'s</xsl:text>
                                <xsl:text>&#160;</xsl:text>
                            </xsl:if>
                            <xsl:text>ORCID:</xsl:text>
                            <xsl:text>&#160;</xsl:text>
                            <xsl:text>&#60;img style="border:none;padding:0;background:none;" src="/sites/default/files/orcid_16x16.gif"&#62;</xsl:text>
                            <xsl:text>&#160;</xsl:text>
                            <xsl:value-of select="$textValue"/>
                        <xsl:text>&#60;/a&#62;</xsl:text>
                    </field>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:for-each>

    </xsl:template>


</xsl:stylesheet>
