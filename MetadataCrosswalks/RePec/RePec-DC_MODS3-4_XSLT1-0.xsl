<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" exclude-result-prefixes="dc dcterms"
    version="1.0">
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="record">
        <mods:mods version="3.4" xmlns:mods="http://www.loc.gov/mods/v3"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-4.xsd">
            <xsl:apply-templates select="dc:title"/>
            <xsl:apply-templates select="dc:creator"/>
            <xsl:apply-templates select="dc:contributor"/>
            <xsl:element name="mods:typeOfResource">text</xsl:element>
            <xsl:call-template name="genre"/>
            <xsl:element name="mods:originInfo">
                <xsl:apply-templates select="dc:publisher"/>
                <xsl:apply-templates select="dc:date"/>
                <xsl:element name="mods:issuance">monographic</xsl:element>
            </xsl:element>
            <xsl:apply-templates select="dc:language"/>
            <xsl:if test="not(dc:language)">
                <xsl:element name="mods:language">
                    <xsl:element name="mods:languageTerm">
                        <xsl:attribute name="type">
                            <xsl:text>code</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="authority">iso639-2b</xsl:attribute>
                        <xsl:text>eng</xsl:text>
                    </xsl:element>
                    <xsl:element name="mods:languageTerm">
                        <xsl:attribute name="type">
                            <xsl:text>text</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="authority">iso639-2b</xsl:attribute>
                        <xsl:text>English</xsl:text>
                    </xsl:element>
                </xsl:element>
            </xsl:if>
            <xsl:call-template name="format"/>
            <xsl:apply-templates select="dcterms:abstract"/>
            <xsl:call-template name="note"/>
            <xsl:apply-templates select="dc:subject"/>
            <xsl:apply-templates select="dcterms:keyword"/>
            <xsl:call-template name="relatedItem"/>
            <xsl:apply-templates select="dc:identifier"/>
            <xsl:apply-templates select="dcterms:URI"/>
            <xsl:call-template name="localCollecion"/>
            <xsl:call-template name="recordInfo"/>
        </mods:mods>
    </xsl:template>
    <xsl:template match="dc:title">
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
                                <xsl:value-of
                                    select="normalize-space(substring(substring-before(., ':'),3))"
                                />
                            </xsl:element>
                            <xsl:element name="mods:subTitle">
                                <xsl:value-of select="normalize-space(substring-after(., ':'))"/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:element name="mods:title">
                                <xsl:value-of select="normalize-space(substring(.,3))"/>
                            </xsl:element>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="starts-with(.,'An ') or starts-with(.,'La ')">
                    <xsl:element name="mods:nonSort">
                        <xsl:value-of select="substring(.,1,3)"/>
                    </xsl:element>
                    <xsl:choose>
                        <xsl:when test="contains(.,':')">
                            <xsl:element name="mods:title">
                                <xsl:value-of
                                    select="normalize-space(substring(substring-before(., ':'),4))"
                                />
                            </xsl:element>
                            <xsl:element name="mods:subTitle">
                                <xsl:value-of select="normalize-space(substring-after(., ':'))"/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:element name="mods:title">
                                <xsl:value-of select="normalize-space(substring(.,4))"/>
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
                                <xsl:value-of
                                    select="normalize-space(substring(substring-before(., ':'),5))"
                                />
                            </xsl:element>
                            <xsl:element name="mods:subTitle">
                                <xsl:value-of select="normalize-space(substring-after(., ':'))"/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:element name="mods:title">
                                <xsl:value-of select="normalize-space(substring(.,5))"/>
                            </xsl:element>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="contains(.,':')">
                            <xsl:element name="mods:title">
                                <xsl:value-of select="normalize-space(substring-before(., ':'))"/>
                            </xsl:element>
                            <xsl:element name="mods:subTitle">
                                <xsl:value-of select="normalize-space(substring-after(., ':'))"/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:element name="mods:title">
                                <xsl:value-of select="normalize-space(.)"/>
                            </xsl:element>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    <xsl:template match="dc:creator">
        <xsl:element name="mods:name">
            <xsl:choose>
                <xsl:when test="contains(.,',')">
                    <xsl:attribute name="type">personal</xsl:attribute>
                    <xsl:attribute name="usage">primary</xsl:attribute>
                    <xsl:element name="mods:namePart">
                        <xsl:attribute name="type">family</xsl:attribute>
                        <xsl:value-of select="normalize-space(substring-before(.,','))"/>
                    </xsl:element>
                    <xsl:element name="mods:namePart">
                        <xsl:attribute name="type">given</xsl:attribute>
                        <xsl:value-of select="normalize-space(substring-after(.,', '))"/>
                    </xsl:element>
                    <xsl:element name="mods:displayForm">
                        <xsl:value-of select="normalize-space(.)"/>
                    </xsl:element>
                    <xsl:call-template name="nameRole"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="varGiven">
                        <xsl:call-template name="parsename">
                            <xsl:with-param name="varName" select="."/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:attribute name="type">personal</xsl:attribute>
                    <xsl:attribute name="usage">primary</xsl:attribute>
                    <xsl:element name="mods:namePart">
                        <xsl:attribute name="type">family</xsl:attribute>
                        <xsl:value-of select="normalize-space(substring-after(., $varGiven))"/>
                    </xsl:element>
                    <xsl:element name="mods:namePart">
                        <xsl:attribute name="type">given</xsl:attribute>
                        <xsl:value-of select="$varGiven"/>
                    </xsl:element>
                    <xsl:element name="mods:displayForm">
                        <xsl:value-of select="normalize-space(concat(substring-after(., $varGiven), ', ', $varGiven))"/>
                    </xsl:element>
                    <xsl:call-template name="nameRole"/>                                    
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    <xsl:template name="parsename">
        <xsl:param name="varName"/>
        <xsl:value-of select="substring-before($varName,' ')"/>
        <xsl:if test="contains(substring-after($varName,' '),' ')">
            <xsl:text> </xsl:text>
            <xsl:call-template name="parsename">
                <xsl:with-param name="varName" select="substring-after($varName,' ')"/>
              </xsl:call-template>
        </xsl:if>        
    </xsl:template>
    <xsl:template name="nameRole">
        <xsl:element name="mods:role">
            <xsl:element name="mods:roleTerm">
                <xsl:attribute name="authority">marcrelator</xsl:attribute>
                <xsl:attribute name="type">text</xsl:attribute>
                <xsl:text>Author</xsl:text>
            </xsl:element>
            <xsl:element name="mods:roleTerm">
                <xsl:attribute name="authority">marcrelator</xsl:attribute>
                <xsl:attribute name="type">code</xsl:attribute>
                <xsl:text>aut</xsl:text>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="dc:subject">
        <xsl:if test=". !=''">
        <xsl:element name="mods:subject">
            <xsl:element name="mods:topic">
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template match="dcterms:keyword">
        <xsl:if test=". !=''">
            <xsl:element name="mods:subject">
                <xsl:element name="mods:topic">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template match="dcterms:abstract">
        <xsl:element name="mods:abstract">
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
    </xsl:template>

    <xsl:template name="note">
        <xsl:if test="starts-with(dc:identifier, 'RePEc:boc:bocoec')">
            <xsl:element name="mods:note">           
                <xsl:text>Originally posted on: http://ideas.repec.org/p/boc/bocoec/</xsl:text><xsl:value-of select="substring-after(dc:identifier, 'RePEc:boc:bocoec:')"/><xsl:text>.html</xsl:text>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <xsl:template match="dc:publisher">
        <xsl:element name="mods:publisher">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="dc:contributor">
        <xsl:if test="(. !='') and contains(.,',')">
            <xsl:element name="mods:name">
                <xsl:attribute name="type">personal</xsl:attribute>
                <xsl:element name="mods:namePart">
                    <xsl:attribute name="type">family</xsl:attribute>
                    <xsl:value-of select="normalize-space(substring-before(.,','))"/>
                </xsl:element>
                <xsl:element name="mods:namePart">
                    <xsl:attribute name="type">given</xsl:attribute>
                    <xsl:value-of select="normalize-space(substring-after(.,', '))"/>
                </xsl:element>
                <xsl:element name="mods:displayForm">
                    <xsl:value-of select="normalize-space(.)"/>
                </xsl:element>
                <xsl:element name="mods:role">
                    <xsl:element name="mods:roleTerm">
                        <xsl:attribute name="authority">marcrelator</xsl:attribute>
                        <xsl:attribute name="type">text</xsl:attribute>
                        <xsl:text>Thesis advisor</xsl:text>
                    </xsl:element>
                    <xsl:element name="mods:roleTerm">
                        <xsl:attribute name="authority">marcrelator</xsl:attribute>
                        <xsl:attribute name="type">code</xsl:attribute>
                        <xsl:text>ths</xsl:text>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:if>
        <xsl:if test="(. !='') and not( contains(.,','))">
            <xsl:element name="mods:name">
                <xsl:attribute name="type">personal</xsl:attribute>
                <xsl:element name="mods:namePart">
                    <xsl:attribute name="type">family</xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="contains(.,'.')">
                            <xsl:value-of select="normalize-space(substring-after(.,'.'))"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="normalize-space(substring-after(.,' '))"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
                <xsl:element name="mods:namePart">
                    <xsl:attribute name="type">given</xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="contains(.,'.')">
                            <xsl:value-of select="normalize-space(substring-before(.,'.'))"/>
                            <xsl:text>.</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="normalize-space(substring-before(.,' '))"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
                <xsl:element name="mods:displayForm">
                    <xsl:choose>
                        <xsl:when test="contains(.,'.')">
                            <xsl:value-of select="normalize-space(substring-after(.,'.'))"/>
                            <xsl:text>, </xsl:text>
                            <xsl:value-of select="normalize-space(substring-before(.,'.'))"/>
                            <xsl:text>.</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="normalize-space(substring-after(.,' '))"/>
                            <xsl:text>, </xsl:text>
                            <xsl:value-of select="normalize-space(substring-before(.,' '))"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>

                <xsl:element name="mods:role">
                    <xsl:element name="mods:roleTerm">
                        <xsl:attribute name="authority">marcrelator</xsl:attribute>
                        <xsl:attribute name="type">text</xsl:attribute>
                        <xsl:text>Thesis advisor</xsl:text>
                    </xsl:element>
                    <xsl:element name="mods:roleTerm">
                        <xsl:attribute name="authority">marcrelator</xsl:attribute>
                        <xsl:attribute name="type">code</xsl:attribute>
                        <xsl:text>ths</xsl:text>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template match="dc:date">
        <xsl:element name="mods:dateIssued">
            <xsl:apply-templates/>
        </xsl:element>
        <xsl:element name="mods:dateIssued">
            <xsl:attribute name="encoding">w3cdtf</xsl:attribute>
            <xsl:attribute name="keyDate">yes</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template name="genre">
        <xsl:element name="mods:genre">
            <xsl:attribute name="authority">local</xsl:attribute>
            <xsl:attribute name="type">work type</xsl:attribute>
            <xsl:attribute name="usage">primary</xsl:attribute>
            <xsl:text>working paper</xsl:text>
        </xsl:element>
    </xsl:template>
    <xsl:template name="format">
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

    <xsl:template name="relatedItem">
        <xsl:element name="mods:relatedItem">
            <xsl:attribute name="type">series</xsl:attribute>
            <xsl:element name="mods:titleInfo">
                <xsl:attribute name="usage">primary</xsl:attribute>
                <xsl:element name="mods:title">
                    <xsl:text>Boston College Working Papers in Economics</xsl:text>
                </xsl:element>              
                <xsl:if test="dc:identifier !=''">
                    <xsl:element name="mods:partNumber">
                        <xsl:value-of select="substring-after(dc:identifier, 'RePEc:boc:bocoec:')"/>
                    </xsl:element>
                </xsl:if>
               
            </xsl:element>
            
        </xsl:element>
    </xsl:template>

    <xsl:template match="dc:identifier">
        <xsl:if test=". !=''">
            <xsl:element name="mods:identifier">
                <xsl:attribute name="type">
                    <xsl:text>repec</xsl:text>
                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <xsl:template match="dcterms:URI">
        <xsl:if test=". !=''">
            <xsl:element name="mods:identifier">
                <xsl:attribute name="type">
                    <xsl:text>uri</xsl:text>
                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <xsl:template match="dc:language">
        <!--Betsy added iso authority for language code-->
        <xsl:element name="mods:language">
            <xsl:choose>
                <xsl:when test=". = 'English'">
                    <xsl:element name="mods:languageTerm">
                        <xsl:attribute name="type">
                            <xsl:text>code</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="authority">iso639-2b</xsl:attribute>
                        <xsl:text>eng</xsl:text>
                    </xsl:element>
                    <xsl:element name="mods:languageTerm">
                        <xsl:attribute name="type">
                            <xsl:text>text</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="authority">iso639-2b</xsl:attribute>
                        <xsl:text>English</xsl:text>
                    </xsl:element>
                </xsl:when>
                <xsl:when test=". = 'French'">
                    <xsl:element name="mods:languageTerm">
                        <xsl:attribute name="type">
                            <xsl:text>code</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="authority">iso639-2b</xsl:attribute>
                        <xsl:text>fre</xsl:text>
                    </xsl:element>
                    <xsl:element name="mods:languageTerm">
                        <xsl:attribute name="type">
                            <xsl:text>text</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="authority">iso639-2b</xsl:attribute>
                        <xsl:text>French</xsl:text>
                    </xsl:element>
                </xsl:when>
                <xsl:when test=". = 'Spanish'">
                    <xsl:element name="mods:languageTerm">
                        <xsl:attribute name="type">
                            <xsl:text>code</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="authority">iso639-2b</xsl:attribute>
                        <xsl:text>spa</xsl:text>
                    </xsl:element>
                    <xsl:element name="mods:languageTerm">
                        <xsl:attribute name="type">
                            <xsl:text>text</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="authority">iso639-2b</xsl:attribute>
                        <xsl:text>Spanish</xsl:text>
                    </xsl:element>
                </xsl:when>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    <xsl:template name="localCollecion">
        <xsl:element name="mods:extension">
            <xsl:element name="localCollectionName">        
                <xsl:text>repec</xsl:text>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template name="recordInfo">
        <xsl:element name="mods:recordInfo">
            <xsl:element name="mods:recordContentSource">
                <xsl:attribute name="authority">marcorg</xsl:attribute>
                <xsl:text>MChB</xsl:text>
            </xsl:element>
            <xsl:element name="mods:languageOfCataloging">
                <xsl:element name="mods:languageTerm">
                    <xsl:attribute name="type">text</xsl:attribute>
                    <xsl:attribute name="authority">iso639-2b</xsl:attribute>
                    <xsl:text>English</xsl:text>
                </xsl:element>
                <xsl:element name="mods:languageTerm">
                    <xsl:attribute name="type">code</xsl:attribute>
                    <xsl:attribute name="authority">iso639-2b</xsl:attribute>
                    <xsl:text>eng</xsl:text>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>