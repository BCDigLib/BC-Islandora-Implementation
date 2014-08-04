<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:etdms="http://www.ndltd.org/standards/metadata/etdms/1.1/"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" exclude-result-prefixes="dc dcterms"
    version="1.0">
    <!-- Spring 2014: Brian adapted the DC to MODS 3.4 stylesheet on the LC site to support the 
        conversion of our etd-ms metadata to MODS.  This stylesheet will be called as our 
        digital entities exports are migrated to Islandora by DGI.
        -->
    <!-- June 2014:  Betsy made updates to stylesheet as noted in comments-->
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
            <!--All theses are being migrated are text, Betsy added the required Type of Resource element as a constant value-->
            <xsl:element name="mods:typeOfResource">text</xsl:element>
            <xsl:apply-templates select="dc:type"/>
            <xsl:element name="mods:originInfo">
                <xsl:apply-templates select="dc:publisher"/>
                <xsl:apply-templates select="dc:date"/>
                <!--Betsy added issuance=monographic-->
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
            <xsl:apply-templates select="dc:format"/>
            <xsl:apply-templates select="dcterms:abstract"/>
            <xsl:apply-templates select="dc:subject"/>
            <xsl:call-template name="classification"/>
            <xsl:apply-templates select="dc:identifier"/>
            <xsl:apply-templates select="dcterms:accessRights"/>
            <xsl:element name="mods:extension">
                <xsl:element name="etdms:degree">
                    <xsl:apply-templates select="dcterms:degreename"/>
                    <xsl:apply-templates select="dcterms:degreelevel"/>
                    <xsl:apply-templates select="dcterms:discipline"/>
                    <xsl:apply-templates select="dcterms:grantor"/>
                </xsl:element>
            </xsl:element>
            <xsl:call-template name="bcSchoolOrCenter"/>         
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
                <xsl:when test="starts-with(.,'An ' or 'La ')">
                    <xsl:element name="mods:nonSort">
                        <xsl:value-of select="normalize-space(substring(.,1,3))"/>
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
                        <xsl:value-of select="normalize-space(substring(.,1,4))"/>
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
            <xsl:attribute name="type">personal</xsl:attribute>
            <xsl:attribute name="usage">primary</xsl:attribute>
            <xsl:element name="mods:namePart">
                <xsl:attribute name="type">given</xsl:attribute>
                <xsl:value-of select="normalize-space(substring-before(.,','))"/>
            </xsl:element>
            <xsl:element name="mods:namePart">
                <xsl:attribute name="type">family</xsl:attribute>
                <xsl:value-of select="normalize-space(substring-after(.,', '))"/>
            </xsl:element>
            <!--Betsy moved mods:displayForm up so it appears before before mods:role-->
            <xsl:element name="mods:displayForm">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:element>
            <xsl:element name="mods:role">
                <xsl:element name="mods:roleTerm">
                    <xsl:attribute name="authority">marcrelator</xsl:attribute>
                    <xsl:attribute name="type">text</xsl:attribute>
                    <!--Betsy uppercased the first letter of the marcrelator term author  
                           in order to match the format of the marc relator list.-->
                    <xsl:text>Author</xsl:text>
                </xsl:element>
                <xsl:element name="mods:roleTerm">
                    <xsl:attribute name="authority">marcrelator</xsl:attribute>
                    <xsl:attribute name="type">code</xsl:attribute>
                    <xsl:text>aut</xsl:text>
                </xsl:element>
            </xsl:element>

        </xsl:element>
    </xsl:template>
    <xsl:template match="dc:subject">
        <xsl:element name="mods:subject">
            <xsl:element name="mods:topic">
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="dcterms:abstract">
        <xsl:element name="mods:abstract">
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="dc:publisher">
        <xsl:element name="mods:publisher">
            <xsl:apply-templates/>
        </xsl:element>
        <!--xsl:element name="mods:place">
            <xsl:element name="mods:placeTerm">
                <xsl:attribute name="type">text</xsl:attribute>
                <xsl:text>Chestnut Hill, MA</xsl:text>
            </xsl:element>
        </xsl:element-->
    </xsl:template>
    <xsl:template match="dc:contributor">
        <xsl:if test=". !=''">
            <xsl:element name="mods:name">
                <xsl:attribute name="type">personal</xsl:attribute>
                <xsl:element name="mods:namePart">
                    <xsl:attribute name="type">given</xsl:attribute>
                    <xsl:value-of select="normalize-space(substring-before(.,','))"/>
                </xsl:element>
                <xsl:element name="mods:namePart">
                    <xsl:attribute name="type">family</xsl:attribute>
                    <xsl:value-of select="normalize-space(substring-after(.,', '))"/>
                </xsl:element>
                <!-- Betsy moved up display form so it would appear before the relator codes-->
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
    </xsl:template>
    <xsl:template match="dc:date">
        <!-- Betsy added an attributeless date for MODS display.
            Still need this in Islandora?-->
        <xsl:element name="mods:dateIssued">
            <xsl:apply-templates/>
        </xsl:element>

        <xsl:element name="mods:dateIssued">
            <xsl:attribute name="encoding">w3cdtf</xsl:attribute>
            <xsl:attribute name="keyDate">yes</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>

    </xsl:template>
    <xsl:template match="dc:type">
        <!-- Betsy added an authority attribute with ndltd as the value to the organization's recommended "Electronic Thesis
            or Dissertation" genre element-->
        <!-- Betsy added the type attribute with value work type to each genre element-->
        <xsl:choose>
            <xsl:when test="(.='text') or (.='Text')">

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
            </xsl:when>
            <xsl:when test="starts-with(., 'Electronic')">
                <xsl:element name="mods:genre">
                    <xsl:attribute name="authority">ndltd</xsl:attribute>
                    <xsl:attribute name="type">work type</xsl:attribute>
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="dc:format">
        <xsl:element name="mods:physicalDescription">
            <!--Betsy added mods:form=electronic-->
            <xsl:element name="mods:form">
                <xsl:attribute name="authority">marcform</xsl:attribute>
                <xsl:text>electronic</xsl:text>
            </xsl:element>
            <xsl:element name="mods:internetMediaType">
                <xsl:text>application/pdf</xsl:text>
            </xsl:element>
        </xsl:element>

    </xsl:template>
    <xsl:template match="dc:identifier">
        <!-- Betsy commented out text of identifier template.  DGI will be getting handles
            not from etd-ms xml, but from digital entity xml.-->
        <!-- <xsl:choose>
            <xsl:when test="starts-with(text(), 'http://hdl')">
                <xsl:element name="mods:location">
                    <xsl:element name="mods:url">
                        <xsl:value-of select="."/>
                    </xsl:element>
                </xsl:element>
            </xsl:when>
        </xsl:choose>-->
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
    <xsl:template match="dcterms:accessRights">
        <xsl:element name="mods:accessCondition">
            <xsl:attribute name="type">
                <xsl:text>use and reproduction</xsl:text>
            </xsl:attribute>
            <xsl:text>Copyright is held by the author, with all rights reserved, unless otherwise noted.</xsl:text>
        </xsl:element>
    </xsl:template>
    <xsl:template match="dcterms:degreename">
        <xsl:element name="etdms:name">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="dcterms:degreelevel">
        <xsl:element name="etdms:level">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="dcterms:discipline">
        <xsl:if test=". != ''">
            <xsl:element name="etdms:discipline">
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template match="dcterms:grantor">
        <xsl:element name="etdms:grantor">
            <xsl:value-of
                select="substring(normalize-space(.),1,string-length(normalize-space(.))-1)"/>
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

    <xsl:template name="classification">
        <xsl:for-each select="dcterms:discipline">

            <xsl:if test="contains(.,'Accounting')">
                <xsl:element name="mods:classification"><xsl:attribute name="authority"
                        >local</xsl:attribute>Accounting</xsl:element>
            </xsl:if>
            <xsl:if test="contains(.,'Biology')">
                <xsl:element name="mods:classification"><xsl:attribute name="authority"
                        >local</xsl:attribute>Biology</xsl:element>
            </xsl:if>
            <xsl:if test="contains(.,'Business Law')">
                <xsl:element name="mods:classification"><xsl:attribute name="authority"
                        >local</xsl:attribute>Business Law</xsl:element>
            </xsl:if>
            <xsl:if test="contains(.,'Chemistry')">
                <xsl:element name="mods:classification"><xsl:attribute name="authority"
                        >local</xsl:attribute>Chemistry</xsl:element>
            </xsl:if>
            <xsl:if test="contains(.,'Classical Studies')">
                <xsl:element name="mods:classification"><xsl:attribute name="authority"
                        >local</xsl:attribute>Classical Studies</xsl:element>
            </xsl:if>

            <xsl:if test="contains(.,'Communication')">
                <xsl:element name="mods:classification"><xsl:attribute name="authority"
                        >local</xsl:attribute>Communication</xsl:element>
            </xsl:if>
            <xsl:if test="contains(.,'Computer Science')">
                <xsl:element name="mods:classification"><xsl:attribute name="authority"
                        >local</xsl:attribute>Computer Science</xsl:element>
            </xsl:if>
            <xsl:if test="contains(.,'Earth and Environmental Sciences')">
                <xsl:element name="mods:classification"><xsl:attribute name="authority"
                        >local</xsl:attribute>Earth and Environmental Sciences</xsl:element>
            </xsl:if>
            <xsl:if test="contains(.,'Economics')">
                <xsl:element name="mods:classification"><xsl:attribute name="authority"
                        >local</xsl:attribute>Economics</xsl:element>
            </xsl:if>
            <xsl:if test="contains(.,'Education')">
                <xsl:element name="mods:classification"><xsl:attribute name="authority"
                        >local</xsl:attribute>Education</xsl:element>
            </xsl:if>
            <xsl:if test="contains(.,'English')">
                <xsl:element name="mods:classification"><xsl:attribute name="authority"
                        >local</xsl:attribute>English</xsl:element>
            </xsl:if>
            <xsl:if test="contains(.,'Film Studies')">
                <xsl:element name="mods:classification"><xsl:attribute name="authority"
                        >local</xsl:attribute>Film Studies</xsl:element>
            </xsl:if>
            <xsl:if test="contains(.,'Finance')">
                <xsl:element name="mods:classification"><xsl:attribute name="authority"
                        >local</xsl:attribute>Finance</xsl:element>
            </xsl:if>
            <xsl:if test="contains(.,'Fine Arts')">
                <xsl:element name="mods:classification"><xsl:attribute name="authority"
                        >local</xsl:attribute>Fine Arts</xsl:element>
            </xsl:if>
            <xsl:if test="contains(.,'Geology and Geophysics')">
                <xsl:element name="mods:classification"><xsl:attribute name="authority"
                        >local</xsl:attribute>Geology and Geophysics</xsl:element>
            </xsl:if>
            <xsl:if test="contains(.,'German')">
                <xsl:element name="mods:classification"><xsl:attribute name="authority"
                        >local</xsl:attribute>German Studies</xsl:element>
            </xsl:if>
            <xsl:if test="contains(.,'History')">
                <xsl:element name="mods:classification"><xsl:attribute name="authority"
                        >local</xsl:attribute>History</xsl:element>
            </xsl:if>
            <xsl:if test="contains(.,'International Studies')">
                <xsl:element name="mods:classification"><xsl:attribute name="authority"
                        >local</xsl:attribute>International Studies</xsl:element>
            </xsl:if>
            <xsl:if test="contains(.,'Islamic Civilizations ')">
                <xsl:element name="mods:classification"><xsl:attribute name="authority"
                        >local</xsl:attribute>Islamic Civilizations </xsl:element>
            </xsl:if>
            <xsl:if test="contains(.,'Management')">
                <xsl:element name="mods:classification"><xsl:attribute name="authority"
                    >local</xsl:attribute>Management</xsl:element>
            </xsl:if>
            <xsl:if test="contains(.,'Mathematics')">
                <xsl:element name="mods:classification"><xsl:attribute name="authority"
                        >local</xsl:attribute>Mathematics</xsl:element>
            </xsl:if>
            <xsl:if test="contains(.,'Music')">
                <xsl:element name="mods:classification"><xsl:attribute name="authority"
                        >local</xsl:attribute>Music</xsl:element>
            </xsl:if>
            <xsl:if test="contains(.,'Nursing')">
                <xsl:element name="mods:classification"><xsl:attribute name="authority"
                        >local</xsl:attribute>Nursing</xsl:element>
            </xsl:if>
            <xsl:if test="contains(.,'Philosophy')">
                <xsl:element name="mods:classification"><xsl:attribute name="authority"
                        >local</xsl:attribute>Philosophy</xsl:element>
            </xsl:if>
            <xsl:if test="contains(.,'Physics')">
                <xsl:element name="mods:classification"><xsl:attribute name="authority"
                        >local</xsl:attribute>Physics</xsl:element>
            </xsl:if>
            <xsl:if test="contains(.,'Political Science')">
                <xsl:element name="mods:classification"><xsl:attribute name="authority"
                        >local</xsl:attribute>Political Science</xsl:element>
            </xsl:if>
            <xsl:if test="contains(.,'Psychology')">
                <xsl:element name="mods:classification"><xsl:attribute name="authority"
                        >local</xsl:attribute>Psychology</xsl:element>
            </xsl:if>
            <xsl:if test="contains(.,'Romance Languages and Literature')">
                <xsl:element name="mods:classification"><xsl:attribute name="authority"
                        >local</xsl:attribute>Romance Languages and Literatures</xsl:element>
            </xsl:if>
            <xsl:if test="contains(.,'Slavic and Eastern Languages')">
                <xsl:element name="mods:classification"><xsl:attribute name="authority"
                        >local</xsl:attribute>Slavic and Eastern Languages</xsl:element>
            </xsl:if>
            <xsl:if test="contains(.,'Social Work')">
                <xsl:element name="mods:classification"><xsl:attribute name="authority"
                        >local</xsl:attribute>Social Work</xsl:element>
            </xsl:if>
            <xsl:if test="contains(.,'Sociology')">
                <xsl:element name="mods:classification"><xsl:attribute name="authority"
                        >local</xsl:attribute>Sociology</xsl:element>
            </xsl:if>
            <xsl:if test="contains(.,'Theater')">
                <xsl:element name="mods:classification"><xsl:attribute name="authority"
                        >local</xsl:attribute>Theater</xsl:element>
            </xsl:if>
            <xsl:if test="contains(.,'Theology')">
                <xsl:element name="mods:classification"><xsl:attribute name="authority"
                        >local</xsl:attribute>Theology</xsl:element>
            </xsl:if>
        </xsl:for-each>

    </xsl:template>
    <xsl:template name="bcSchoolOrCenter">
        <xsl:element name="mods:extension">
  
                
                    <xsl:if test="contains(dcterms:grantor,'Arts')">
                        <xsl:element name="bcSchoolOrCenter">
                        <xsl:text>Arts and Sciences</xsl:text>
                        </xsl:element>
                    </xsl:if>

                    <xsl:if test="contains(dcterms:grantor,'Carroll')">
                        <xsl:element name="bcSchoolOrCenter">
                        <xsl:text>Carroll School of Management</xsl:text>
                        </xsl:element>
                    </xsl:if>
            
                    <xsl:if test="contains(dcterms:grantor,'Connell')">
                        <xsl:element name="bcSchoolOrCenter">
                        <xsl:text>Connell School of Nursing</xsl:text>
                        </xsl:element>
                    </xsl:if>

            
      
                <xsl:for-each select="dcterms:discipline">
                    <xsl:if test="contains(.,'College Honors')">
                        <xsl:element name="bcSchoolOrCenter">   
                        <xsl:text>College Honors Program</xsl:text>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="contains(.,'Carroll School of Management Honors Program')">
                        <xsl:element name="bcSchoolOrCenter">                    
                        <xsl:text>Carroll School of Management Honors Program</xsl:text>
                        </xsl:element>
                    </xsl:if>
                </xsl:for-each>
            
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>
