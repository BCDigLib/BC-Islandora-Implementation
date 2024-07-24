<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:etdms="http://www.ndltd.org/standards/metadata/etdms/1.0/"
    xmlns:mods="http://www.loc.gov/mods/v3">
    <xsl:param name="handle"/>
    <xsl:variable name="degreeLookup" select="document('degreeLookup.xml')"/>
    <xsl:variable name="languageLookup" select="document('languageLookup.xml')"/>
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
    <xsl:template match="/DISS_submission">
        <mods:mods xmlns:mods="http://www.loc.gov/mods/v3" xmlns:etdms="http://www.ndltd.org/standards/metadata/etdms/1.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xlink="http://www.w3.org/1999/xlink" version="3.6" xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-6.xsd http://www.ndltd.org/standards/metadata/etdms/1-0/ http://www.ndltd.org/standards/metadata/etdms/1-0/etdms.xsd">
            <xsl:apply-templates select="DISS_description/DISS_title"/>
            <xsl:apply-templates select="DISS_authorship/DISS_author[@type='primary']/DISS_name">
                <xsl:with-param name="text">Author</xsl:with-param>
                <xsl:with-param name="code">aut</xsl:with-param>
            </xsl:apply-templates>
            <xsl:apply-templates select="DISS_description/DISS_advisor/DISS_name">
                <xsl:with-param name="text">Thesis advisor</xsl:with-param>
                <xsl:with-param name="code">ths</xsl:with-param>
            </xsl:apply-templates>
            <xsl:element name="mods:typeOfResource">text</xsl:element>
            <xsl:call-template name="genre"/>
            <xsl:apply-templates select="DISS_description/DISS_dates/DISS_comp_date"/>
            <xsl:apply-templates select="DISS_description/DISS_categorization/DISS_language">
                <xsl:with-param name="element">mods:language</xsl:with-param>
            </xsl:apply-templates>
            <xsl:call-template name="physicalDescription"/>
            <xsl:apply-templates select="DISS_content/DISS_abstract"/>
            <xsl:call-template name="processKW">
                <xsl:with-param name="keywords" select="DISS_description/DISS_categorization/DISS_keyword"/>
            </xsl:call-template>
            <xsl:choose>
                <xsl:when test="DISS_repository/DISS_acceptance">
                    <xsl:apply-templates select="DISS_repository/DISS_acceptance">
                        <xsl:with-param name="ccAttr">
                            <xsl:value-of select="translate(DISS_creative_commons_license/DISS_abbreviation,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
                        </xsl:with-param>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="mods:accessCondition">
                        <xsl:attribute name="type">
                            <xsl:text>use and reproduction</xsl:text>
                        </xsl:attribute>
                        <xsl:text>Copyright is held by the author, with all rights reserved, unless otherwise noted.</xsl:text>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:element name="mods:extension">
                <xsl:element name="etdms:degree">
                    <xsl:apply-templates select="DISS_description/DISS_degree"/>
                    <xsl:apply-templates select="DISS_description/DISS_institution"/>
                </xsl:element>
            </xsl:element>
            <xsl:call-template name="recordInfo"/>
            <xsl:element name="mods:identifier">
                <xsl:attribute name="type">hdl</xsl:attribute>
                <xsl:value-of select="concat('http://hdl.handle.net/2345/',$handle)"/>
            </xsl:element>
        </mods:mods>
    </xsl:template>
    <xsl:template match="DISS_title">
        <xsl:element name="mods:titleInfo">
        <xsl:attribute name="usage">primary</xsl:attribute>
        <xsl:choose>
            <xsl:when test="starts-with(.,'A ')">
                <xsl:element name="mods:nonSort">
                    <xsl:value-of select="substring(.,1,2)"/>
                </xsl:element>
                <xsl:choose>
                    <xsl:when test="contains(.,':')">
                        <xsl:element name="mods:title">
                            <xsl:value-of select="substring(substring-before(., ':'),3)"/>
                        </xsl:element>
                        <xsl:element name="mods:subTitle">
                            <xsl:value-of select="normalize-space(substring-after(., ':'))"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="mods:title">
                            <xsl:value-of select="substring(.,3)"/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="starts-with(.,'An ' or 'La ')">
                <xsl:element name="mods:nonSort">
                    <xsl:value-of select="substring(.,1,3)"/>
                </xsl:element>
                <xsl:choose>
                    <xsl:when test="contains(.,':')">
                        <xsl:element name="mods:title">
                            <xsl:value-of select="substring(substring-before(., ':'),4)"/>
                        </xsl:element>
                        <xsl:element name="mods:subTitle">
                            <xsl:value-of select="normalize-space(substring-after(., ':'))"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="mods:title">
                            <xsl:value-of select="substring(.,4)"/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="starts-with(.,'The ')">
                <xsl:element name="mods:nonSort">
                    <xsl:value-of select="substring(.,1,4)"/>
                </xsl:element>
                <xsl:choose>
                    <xsl:when test="contains(.,':')">
                        <xsl:element name="mods:title">
                            <xsl:value-of select="substring(substring-before(., ':'),5)"/>
                        </xsl:element>
                        <xsl:element name="mods:subTitle">
                            <xsl:value-of select="normalize-space(substring-after(., ':'))"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="mods:title">
                            <xsl:value-of select="substring(.,5)"/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="contains(.,':')">
                        <xsl:element name="mods:title">
                            <xsl:value-of select="substring-before(., ':')"/>
                        </xsl:element>
                        <xsl:element name="mods:subTitle">
                            <xsl:value-of select="normalize-space(substring-after(., ':'))"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="mods:title">
                            <xsl:value-of select="."/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:element>
    </xsl:template>
    <xsl:template match="DISS_name">
        <xsl:param name="text"/>
        <xsl:param name="code"/>
        <xsl:element name="mods:name">
            <xsl:attribute name="type">personal</xsl:attribute>
            <xsl:if test="$code = 'aut'">
                <xsl:attribute name="usage">primary</xsl:attribute>
            </xsl:if>
            <xsl:element name="mods:namePart">
                <xsl:attribute name="type">family</xsl:attribute>
                <xsl:value-of select="DISS_surname"/>
            </xsl:element>
            <xsl:element name="mods:namePart">
                <xsl:attribute name="type">given</xsl:attribute>
                <xsl:value-of select="DISS_fname"/>
                <xsl:apply-templates select="DISS_middle"/>
            </xsl:element>
            <xsl:element name="mods:displayForm">
                <xsl:value-of select="concat(DISS_surname,', ',DISS_fname)"/>
                <xsl:apply-templates select="DISS_middle"/>
            </xsl:element>
            <xsl:element name="mods:role">
                <xsl:element name="mods:roleTerm">
                    <xsl:attribute name="authority">marcrelator</xsl:attribute>
                    <xsl:attribute name="type">text</xsl:attribute>
                    <xsl:value-of select="$text"/>
                </xsl:element>
                <xsl:element name="mods:roleTerm">
                    <xsl:attribute name="authority">marcrelator</xsl:attribute>
                    <xsl:attribute name="type">code</xsl:attribute>
                    <xsl:value-of select="$code"/>
                </xsl:element>
            </xsl:element>
            <xsl:for-each select="../DISS_orcid">
                <xsl:choose>
                    <xsl:when test="not(. = '')">
                        <xsl:element name="mods:nameIdentifier">
                            <xsl:attribute name="type">orcid</xsl:attribute>
                            <xsl:value-of select="."/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    <xsl:template match="DISS_middle">
        <xsl:if test="not(. = '')">
            <xsl:value-of select="concat(' ',.)"/>
            <xsl:choose>
                <xsl:when test="substring(.,string-length(.)) = '.'"> </xsl:when>
                <xsl:when test="string-length(.)='1'">
                    <xsl:text>.</xsl:text>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    <xsl:template name="genre">
         <xsl:element name="mods:genre">
            <xsl:attribute name="authority">ndltd</xsl:attribute>
            <xsl:attribute name="type">work type</xsl:attribute>
            <xsl:text>Electronic Thesis or Dissertation</xsl:text>
        </xsl:element>
        <xsl:element name="mods:genre">
            <xsl:attribute name="authority">dct</xsl:attribute>
            <xsl:attribute name="type">work type</xsl:attribute>
            <xsl:text>Text</xsl:text>
        </xsl:element>
        <xsl:element name="mods:genre">
            <xsl:attribute name="authority">marcgt</xsl:attribute>
            <xsl:attribute name="type">work type</xsl:attribute>
            <xsl:attribute name="usage">primary</xsl:attribute>
            <xsl:text>thesis</xsl:text>
        </xsl:element>
    </xsl:template>
    <xsl:template match="DISS_comp_date">
        <xsl:element name="mods:originInfo">
            <xsl:element name="mods:publisher">Boston College</xsl:element>
            <xsl:element name="mods:dateIssued">
                <xsl:value-of select="."/>
            </xsl:element>
            <xsl:element name="mods:dateIssued">
                <xsl:attribute name="encoding">w3cdtf</xsl:attribute>
                <xsl:attribute name="keyDate">yes</xsl:attribute>
                <xsl:value-of select="."/>
            </xsl:element>
            <xsl:element name="mods:issuance">monographic</xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="DISS_language">
        <xsl:param name="element"/>
        <xsl:variable name="varCode">
            <xsl:value-of select="translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>
        </xsl:variable>
        <xsl:element name="{$element}">
            <xsl:element name="mods:languageTerm">
                <xsl:attribute name="type">
                    <xsl:text>code</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="authority">iso639-2b</xsl:attribute>
                <xsl:value-of select="$languageLookup/LanguageLookUp/DISS_language[@value=$varCode]/@code"/>
            </xsl:element>
            <xsl:element name="mods:languageTerm">
                <xsl:attribute name="type">
                    <xsl:text>text</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="authority">iso639-2b</xsl:attribute>
                <xsl:value-of select="$languageLookup/LanguageLookUp/DISS_language[@value=$varCode]/@language"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template name="physicalDescription">
        <xsl:element name="mods:physicalDescription">
           <xsl:element name="mods:form">
                <xsl:attribute name="authority">marcform</xsl:attribute>
                <xsl:text>electronic</xsl:text>
            </xsl:element>
            <xsl:element name="mods:internetMediaType">
                <xsl:text>application/pdf</xsl:text>
            </xsl:element>
            <xsl:element name="mods:digitalOrigin">
                <xsl:text>born digital</xsl:text>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="DISS_abstract">
        <xsl:element name="mods:abstract">
            <xsl:for-each select="DISS_para">
                <xsl:value-of select="."/>
                <xsl:if test="position() != last()"><xsl:text> </xsl:text></xsl:if>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    <xsl:template match="DISS_acceptance">
        <xsl:param name="ccAttr"/>
        <xsl:element name="mods:accessCondition">
            <xsl:attribute name="type">
                <xsl:text>use and reproduction</xsl:text>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="$ccAttr = 'NONE' or $ccAttr = ''">
                    <xsl:text>Copyright is held by the author, with all rights reserved, unless otherwise noted.</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>Copyright is held by the author. </xsl:text>
                    <xsl:choose>
                        <xsl:when test="$ccAttr = 'CC BY'">
                            <xsl:text>This work is licensed under a Creative Commons Attribution 4.0 International License (http://creativecommons.org/licenses/by/4.0).</xsl:text>
                        </xsl:when>
                        <xsl:when test="$ccAttr = 'CC BY-ND'">
                            <xsl:text>This work is licensed under a Creative Commons Attribution-NoDerivatives 4.0 International License (http://creativecommons.org/licenses/by-nd/4.0).</xsl:text>
                        </xsl:when>
                        <xsl:when test="$ccAttr = 'CC BY-NC-SA'">
                            <xsl:text>This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License (http://creativecommons.org/licenses/by-nc-sa/4.0).</xsl:text>
                        </xsl:when>
                        <xsl:when test="$ccAttr = 'CC BY-SA'">
                            <xsl:text>This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License (http://creativecommons.org/licenses/by-sa/4.0).</xsl:text>
                        </xsl:when>
                        <xsl:when test="$ccAttr = 'CC BY-NC'">
                            <xsl:text>This work is licensed under a Creative Commons Attribution-NonCommercial 4.0 International License (http://creativecommons.org/licenses/by-nc/4.0).</xsl:text>
                        </xsl:when>
                        <xsl:when test="$ccAttr = 'CC BY-NC-ND'">
                            <xsl:text>This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License (http://creativecommons.org/licenses/by-nc-nd/4.0).</xsl:text>
                        </xsl:when>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    <xsl:template match="DISS_degree">
        <xsl:variable name="degree" select="translate(translate(.,'.',''),'abdehmps','ABDEHMPST')"/>
        <xsl:element name="etdms:name">
            <xsl:value-of select="$degreeLookup/DegreeLookUp/DISS_degree[@degree=$degree]/@name"/>
        </xsl:element>
        <xsl:element name="etdms:level">
            <xsl:value-of select="$degreeLookup/DegreeLookUp/DISS_degree[@degree=$degree]/@level"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="DISS_institution">
        <xsl:choose>
            <xsl:when test="starts-with(DISS_inst_contact, 'CSOM')">
                <xsl:element name="etdms:discipline">
                    <xsl:value-of select="normalize-space(substring-after(DISS_inst_contact,'-'))"/>
                </xsl:element>
                <xsl:element name="etdms:grantor">
                    <xsl:text>Boston College. Carroll School of Management</xsl:text>
                </xsl:element>
            </xsl:when>
            <xsl:when test="starts-with(DISS_inst_contact, 'CSON')">
                <xsl:element name="etdms:discipline">
                    <xsl:text>Nursing</xsl:text>
                </xsl:element>
                <xsl:element name="etdms:grantor">
                    <xsl:text>Boston College. Connell School of Nursing</xsl:text>
                </xsl:element>
            </xsl:when>
            <xsl:when test="starts-with(DISS_inst_contact, 'GSAS')">
                <xsl:element name="etdms:discipline">
                    <xsl:value-of select="normalize-space(substring-after(DISS_inst_contact,'-'))"/>
                </xsl:element>
                <xsl:element name="etdms:grantor">Boston College. Graduate School of Arts and Sciences</xsl:element>
            </xsl:when>
            <xsl:when test="starts-with(DISS_inst_contact, 'GSSW')">
                <xsl:element name="etdms:discipline">
                    <xsl:text>Social Work</xsl:text>
                </xsl:element>
                <xsl:element name="etdms:grantor">
                    <xsl:text>Boston College. Graduate School of Social Work</xsl:text>
                </xsl:element>
            </xsl:when>
            <xsl:when test="starts-with(DISS_inst_contact, 'LSOE')">
                <xsl:element name="etdms:discipline">
                    <xsl:value-of select="normalize-space(substring-after(DISS_inst_contact,'-'))"/>
                </xsl:element>
                <xsl:element name="etdms:grantor">
                    <xsl:text>Boston College. Lynch School of Education</xsl:text>
                </xsl:element>
            </xsl:when>
            <xsl:when test="starts-with(DISS_inst_contact, 'STM')">
                <xsl:element name="etdms:discipline">
                    <xsl:text>Sacred Theology</xsl:text>
                </xsl:element>
                <xsl:element name="etdms:grantor">
                    <xsl:text>Boston College. School of Theology and Ministry</xsl:text>
                </xsl:element>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="processKW">
        <xsl:param name="keywords"/>
        <xsl:choose>
            <xsl:when test="contains($keywords,',')">
                <xsl:element name="mods:subject">
                    <xsl:element name="mods:topic">
                        <xsl:value-of select="normalize-space(substring-before($keywords,','))"/>
                    </xsl:element>
                </xsl:element>
                <xsl:call-template name="processKW">
                    <xsl:with-param name="keywords" select="substring-after($keywords,',')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="mods:subject">
                    <xsl:element name="mods:topic">
                        <xsl:value-of select="normalize-space($keywords)"/>
                    </xsl:element>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="recordInfo">
        <xsl:element name="mods:recordInfo">
            <xsl:element name="mods:recordContentSource">
                <xsl:attribute name="authority">marcorg</xsl:attribute>
                <xsl:text>MChB</xsl:text>
            </xsl:element>
            <xsl:element name="mods:recordOrigin">Most grad thesis records are created by transforming ProQuest supplied xml and editing as needed.</xsl:element>
            <xsl:apply-templates select="DISS_description/DISS_categorization/DISS_language">
                <xsl:with-param name="element">mods:languageOfCataloging</xsl:with-param>
            </xsl:apply-templates>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
