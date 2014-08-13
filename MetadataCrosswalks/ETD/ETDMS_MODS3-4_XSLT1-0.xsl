<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:etdms="http://www.ndltd.org/standards/metadata/etdms/1.0/"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0">
    <!-- Spring 2014: Brian adapted the DC to MODS 3.4 stylesheet on the LC site to support the 
        conversion of our etd-ms metadata to MODS.  This stylesheet will be called as our 
        digital entities exports are migrated to Islandora by DGI.
        -->
    <!-- June 2014:  Betsy made updates to stylesheet as noted in comments-->
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="thesis">
        <mods:mods version="3.4" xmlns:mods="http://www.loc.gov/mods/v3"
            xmlns:etdms="http://www.ndltd.org/standards/metadata/etdms/1.0/"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-4.xsd http://www.ndltd.org/standards/metadata/etdms/1.0/ http://www.ndltd.org/standards/metadata/etdms/1.0/etdms.xsd">
            <xsl:apply-templates select="title"/>
            <xsl:apply-templates select="creator"/>
            <xsl:apply-templates select="contributor"/>
            <!--All dissertations being migrated are text, Betsy added the required Type of Resource element as a constant value-->
            <xsl:element name="mods:typeOfResource">text</xsl:element>
            <xsl:apply-templates select="type"/>
            <xsl:element name="mods:originInfo">
                <xsl:apply-templates select="publisher"/>
                <xsl:apply-templates select="date"/>
                <!--Betsy added issuance=monographic-->
                <xsl:element name="mods:issuance">monographic</xsl:element>
            </xsl:element>
            <xsl:apply-templates select="language"/>
            <xsl:if test="not(language)">
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
            <xsl:apply-templates select="format"/>
            <xsl:apply-templates select="description"/>
            <xsl:apply-templates select="subject"/>

            <xsl:apply-templates select="identifier"/>
            <xsl:apply-templates select="rights"/>
            <xsl:element name="mods:extension">
                <xsl:apply-templates select="degree"/>
            </xsl:element>
            <xsl:call-template name="recordInfo"/>
        </mods:mods>
    </xsl:template>
    <xsl:template name="recordInfo">
        <xsl:element name="mods:recordInfo">
            <xsl:element name="mods:recordContentSource">
                <xsl:attribute name="authority">marcorg</xsl:attribute>
                <xsl:text>MChB</xsl:text>
            </xsl:element>
            <xsl:element name="mods:recordOrigin"
                >Most grad thesis records are created by transforming ProQuest supplied xml and editing as needed.</xsl:element>

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
    <xsl:template match="degree">
        <xsl:element name="etdms:degree">
            <xsl:apply-templates select="name"/>
            <xsl:apply-templates select="level"/>
            <xsl:apply-templates select="discipline"/>
            <xsl:apply-templates select="grantor"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="title">
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
    <xsl:template match="creator">
        <xsl:element name="mods:name">
            <xsl:attribute name="type">personal</xsl:attribute>
            <xsl:attribute name="usage">primary</xsl:attribute>
            <xsl:element name="mods:namePart">
                <xsl:attribute name="type">given</xsl:attribute>
                <xsl:value-of select="substring-before(.,',')"/>
            </xsl:element>
            <xsl:element name="mods:namePart">
                <xsl:attribute name="type">family</xsl:attribute>
                <xsl:value-of select="substring-after(.,', ')"/>
            </xsl:element>
            <!--Betsy moved mods:displayForm up so it appears before before mods:role-->
            <xsl:element name="mods:displayForm">
                <xsl:value-of select="."/>
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
    <xsl:template match="subject">
        <xsl:element name="mods:subject">
            <xsl:element name="mods:topic">
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="description">
        <xsl:element name="mods:abstract">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="publisher">
        <xsl:element name="mods:publisher">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="contributor">
        <xsl:if test=". !=''">
            <xsl:element name="mods:name">
                <xsl:attribute name="type">personal</xsl:attribute>
                <xsl:element name="mods:namePart">
                    <xsl:attribute name="type">given</xsl:attribute>
                    <xsl:value-of select="substring-before(.,',')"/>
                </xsl:element>
                <xsl:element name="mods:namePart">
                    <xsl:attribute name="type">family</xsl:attribute>
                    <xsl:value-of select="substring-after(.,', ')"/>
                </xsl:element>
                <!-- Betsy moved up display form so it would appear before the relator codes-->
                <xsl:element name="mods:displayForm">
                    <xsl:value-of select="."/>
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
    <xsl:template match="date">
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
    <xsl:template match="type">
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
    <xsl:template match="format">
        <xsl:element name="mods:physicalDescription">
            <!--Betsy added mods:form=electronic-->
            <xsl:element name="mods:form">
                <xsl:attribute name="authority">marcform</xsl:attribute>
                <xsl:text>electronic</xsl:text>
            </xsl:element>
            <xsl:element name="mods:internetMediaType">
                <xsl:text>application/pdf</xsl:text>
            </xsl:element>
            <xsl:variable name="date" select="preceding-sibling::date"/>
            <xsl:choose>
                <xsl:when test="$date > '2008'">
                    <xsl:element name="mods:digitalOrigin">born digital</xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="mods:digitalOrigin">digitized other analog</xsl:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    <xsl:template match="identifier">
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
    <xsl:template match="language">
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
    <xsl:template match="rights">
        <xsl:element name="mods:accessCondition">
            <xsl:attribute name="type">
                <xsl:text>use and reproduction</xsl:text>
            </xsl:attribute>
            <xsl:text>Copyright is held by the author, with all rights reserved, unless otherwise noted.</xsl:text>
        </xsl:element>
    </xsl:template>
    <xsl:template match="name">
        <xsl:element name="etdms:name">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="level">
        <xsl:element name="etdms:level">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="discipline">
        <xsl:if test=". != ''">
            <!--Betsy adds logic to change ampersand in discipline to and-->
            <xsl:element name="etdms:discipline">
                <xsl:choose>
                    <xsl:when test="contains(.,'&amp;')">
                        <xsl:value-of
                            select="concat(substring-before(.,'&amp;'),'and',substring-after(.,'&amp;'))"
                        />
                    </xsl:when>
                    <xsl:when
                        test="(. ='Counseling and Developmental Psychology and Research Methods') or (. ='Counseling, Developmental Psychology and Research Methods')">
                        <xsl:text>Counseling, Developmental Psychology, and Research Methods</xsl:text>
                    </xsl:when>
                    <xsl:when
                        test="(.='Counseling, Development, and Educational Psychology') or (. ='Counseling, Developmental and Educational Psychology') or (. ='Counseling, Developmental and Educational Psychology ')">
                        <xsl:text>Counseling, Developmental, and Educational Psychology</xsl:text>
                    </xsl:when>
                    <xsl:when test=".='Education Administration'">
                        <xsl:text>Educational Administration</xsl:text>
                    </xsl:when>
                    <xsl:when test=".='Education Administration and Higher Education'">
                        <xsl:text>Educational Administration and Higher Education</xsl:text>
                    </xsl:when>
                    <xsl:when test=".='Department of Educational Leadership and Higher Education'">
                        <xsl:text>Educational Leadership and Higher Education</xsl:text>
                    </xsl:when>
                    <xsl:when test=".='Educational Research, Measurement and Evaluation'">
                        <xsl:text>Educational Research, Measurement, and Evaluation</xsl:text>
                    </xsl:when>
                    <xsl:when
                        test="(.='Teacher Education, Special Education, and Curriculum and Instruction') or (.='Teacher Education, Curriculum and Instruction') or (. ='Teacher Education, Special Education and Curriculum and Instruction') or (. ='Teacher Education, Special Education, and Curriculum andInstruction') or (. ='Teacher Education, Special Education, Curriculum and Instruction') or (.='Teacher Education/Special Education, Curriculum and Instruction')">
                        <xsl:text>Teacher Education, Special Education, Curriculum and Instruction</xsl:text>
                    </xsl:when>
                    <xsl:when test=".='Theology and Education'">
                        <xsl:text>Theology</xsl:text>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:value-of select="."/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template match="grantor">
        <!--Betsy adds logic to remove final stop and to translate & to and-->
        <xsl:element name="etdms:grantor">
            <xsl:variable name="length" select="string-length(.)"/>
            <xsl:choose>
                <!--Ends in a period-->
                <xsl:when test="substring(.,$length) = '.'">
                    <xsl:choose>
                        <!-- and includes an ampersand-->
                        <xsl:when test="contains(.,'&amp;')">
                            <xsl:value-of
                                select="concat(substring-before(substring(.,1,string-length(.)-1),'&amp;'),'and',substring-after(substring(.,1,string-length(.)-1),'&amp;'))"
                            />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="substring(.,1,string-length(.)-1)"/>
                        </xsl:otherwise>
                    </xsl:choose>

                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="contains(.,'&amp;')">
                            <xsl:value-of
                                select="concat(substring-before(.,'&amp;'),'and',substring-after(.,'&amp;'))"
                            />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="."/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>

        </xsl:element>
    </xsl:template>
   
</xsl:stylesheet>
