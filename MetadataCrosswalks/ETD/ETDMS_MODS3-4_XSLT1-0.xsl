<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:etd="http://www.ndltd.org/standards/metadata/etdms/1.1/"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0">
    <!--
        Version 1.1 2012-08-12 WS  
        Upgraded to MODS 3.4
        
        Version 1.0 2006-11-01 cred@loc.gov
        
        This stylesheet will transform simple Dublin Core (DC) expressed in either OAI DC [1] or SRU DC [2] schemata to MODS 
        version 3.2.
        
        Reasonable attempts have been made to automatically detect and process the textual content of DC elements for the purposes 
        of outputting to MODS.  Because MODS is more granular and expressive than simple DC, transforming a given DC element to the 
        proper MODS element(s) is difficult and may result in imprecise or incorrect tagging.  Undoubtedly local customizations will 
        have to be made by those who utilize this stylesheet in order to achieve deisred results.  No attempt has been made to 
        ignore empty DC elements.  If your DC contains empty elements, they should either be removed, or local customization to 
        detect the existence of text for each element will have to be added to this stylesheet.
        
        MODS also often encourages content adhering to various data value standards.  The contents of some of the more widely used value 
        standards, such as IANA MIME types, ISO 3166-1, ISO 639-2, etc., have been added into the stylesheet to facilitate proper 
        mapping of simple DC to the proper MODS elements.  A crude attempt at detecting the contents of DC identifiers and outputting them
        to the proper MODS elements has been made as well.  Common persistent identifier schemes, standard numbers, etc., have been included.
        To truly detect these efficiently, XSL/XPath 2.0 or XQuery may be needed in order to utilize regular expressions.
        
        [1] http://www.openarchives.org/OAI/openarchivesprotocol.html#MetadataNamespaces
        [2] http://www.loc.gov/standards/sru/record-schemas.html
        
    -->
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    <xsl:include href="inc/dcmiType.xsl"/>
    <xsl:include href="inc/mimeType.xsl"/>
    <xsl:include href="inc/csdgm.xsl"/>
    <xsl:include href="inc/forms.xsl"/>
    <xsl:include href="inc/iso3166-1.xsl"/>
    <xsl:include href="inc/iso639-2.xsl"/>
    <!-- Do you have a Handle server?  If so, specify the base URI below including the trailing slash a la: http://hdl.loc.gov/ -->
    <xsl:variable name="handleServer">
        <xsl:text>http://hdl.loc.gov/</xsl:text>
    </xsl:variable>
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="thesis">
        <mods:mods version="3.4" xmlns:mods="http://www.loc.gov/mods/v3"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-4.xsd">
            <xsl:apply-templates select="title"/>
            <xsl:apply-templates select="creator"/>
            <xsl:apply-templates select="contributor"/>
            <xsl:apply-templates select="type"/>
            <xsl:element name="mods:originInfo">
                <xsl:apply-templates select="publisher"/>
                <xsl:apply-templates select="date"/>
            </xsl:element>
            <xsl:apply-templates select="description"/>
            <xsl:apply-templates select="subject"/>
            <xsl:apply-templates select="format"/>
            <xsl:apply-templates select="identifier"/>
            <xsl:apply-templates select="language"/>
            <xsl:apply-templates select="accessRights"/>
            <xsl:element name="mods:extension">
                <xsl:apply-templates select="degree"/>
            </xsl:element>
        </mods:mods>
    </xsl:template>
    <xsl:template match="degree">
        <xsl:element name="etd:degree">
            <xsl:apply-templates select="name"/>
            <xsl:apply-templates select="level"/>
            <xsl:apply-templates select="discipline"/>
            <xsl:apply-templates select="grantor"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="title">
        <xsl:element name="mods:titleInfo">
            <xsl:choose>
                <xsl:when test="starts-with(.,'A ')">
                    <xsl:element name="mods:nonSort">
                        <xsl:value-of select="substring(.,1,2)"/>
                    </xsl:element>
                    <xsl:choose>
                        <xsl:when test="contains(.,':')">
                            <xsl:element name="mods:title">
                                <xsl:value-of select="substring-before(., ':')"/>
                            </xsl:element>
                            <xsl:element name="mods:subTitle">
                                <xsl:value-of select="substring-after(., ': ')"/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:element name="mods:title">
                                <xsl:value-of select="substring(.,3)"/>
                            </xsl:element>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="starts-with(.,'An ')">
                    <xsl:element name="mods:nonSort">
                        <xsl:value-of select="substring(.,1,3)"/>
                    </xsl:element>
                    <xsl:choose>
                        <xsl:when test="contains(.,':')">
                            <xsl:element name="mods:title">
                                <xsl:value-of select="substring-before(., ':')"/>
                            </xsl:element>
                            <xsl:element name="mods:subTitle">
                                <xsl:value-of select="substring-after(., ': ')"/>
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
                                <xsl:value-of select="substring-before(., ':')"/>
                            </xsl:element>
                            <xsl:element name="mods:subTitle">
                                <xsl:value-of select="substring-after(., ': ')"/>
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
                                <xsl:value-of select="substring-after(., ': ')"/>
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
            <xsl:element name="mods:namePart">
                <xsl:attribute name="type">given</xsl:attribute>
                <xsl:value-of select="substring-before(.,',')"/>
            </xsl:element>
            <xsl:element name="mods:namePart">
                <xsl:attribute name="type">family</xsl:attribute>
                <xsl:value-of select="substring-after(.,', ')"/>
            </xsl:element>
            <xsl:element name="mods:role">
                <xsl:element name="mods:roleTerm">
                    <xsl:attribute name="authority">marcrelator</xsl:attribute>
                    <xsl:attribute name="type">text</xsl:attribute>
                    <xsl:text>author</xsl:text>
                </xsl:element>
                <xsl:element name="mods:roleTerm">
                    <xsl:attribute name="authority">marcrelator</xsl:attribute>
                    <xsl:attribute name="type">code</xsl:attribute>
                    <xsl:text>aut</xsl:text>
                </xsl:element>
            </xsl:element>
            <xsl:element name="mods:displayForm">
                <xsl:value-of select="."/>
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
                <xsl:element name="mods:displayForm">
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template match="date">
        <xsl:element name="mods:dateIssued">
            <xsl:attribute name="encoding">w3cdtf</xsl:attribute>
            <xsl:attribute name="keyDate">yes</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="type">
        <xsl:choose>
            <xsl:when test="starts-with(., 'Electronic')">
                <xsl:element name="mods:genre">
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:when>
            <xsl:when test=".='text'">
                <xsl:element name="mods:typeOfResource">
                    <xsl:value-of select="."/>
                </xsl:element>
                <xsl:element name="mods:genre">
                    <xsl:attribute name="authority">dct</xsl:attribute>
                    <xsl:value-of select="."/>
                </xsl:element>
                <xsl:element name="mods:genre">
                    <xsl:attribute name="authority">marcgt</xsl:attribute>
                    <xsl:text>thesis</xsl:text>
                </xsl:element>                
            </xsl:when>
        </xsl:choose>        
    </xsl:template>  
    <xsl:template match="format">
        <xsl:element name="mods:physicalDescription">
            <xsl:element name="mods:internetMediaType">
                <xsl:text>application/pdf</xsl:text>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="identifier">
        <xsl:choose>
            <xsl:when test="starts-with(text(), 'http://hdl')">
                <xsl:element name="mods:location">
                    <xsl:element name="mods:url">
                        <xsl:value-of select="."/>
                    </xsl:element>
                </xsl:element>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="language">
        <xsl:element name="mods:language">
            <xsl:choose>
                <xsl:when test=". = 'English'">
                    <xsl:element name="mods:languageTerm">
                        <xsl:attribute name="type">
                            <xsl:text>code</xsl:text>
                        </xsl:attribute>
                        <xsl:text>eng</xsl:text>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="mods:languageTerm">
                        <xsl:attribute name="type">
                            <xsl:text>text</xsl:text>
                        </xsl:attribute>
                        <xsl:apply-templates/>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    <xsl:template match="accessRights">
        <xsl:element name="mods:accessCondition">
            <xsl:attribute name="type">
                <xsl:text>use and reproduction</xsl:text>
            </xsl:attribute>
            <xsl:text>Copyright is held by the author, with all rights reserved, unless otherwise noted.</xsl:text>
        </xsl:element>
    </xsl:template>
    <xsl:template match="name">
        <xsl:element name="etd:name">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="level">
        <xsl:element name="etd:level">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="discipline">
        <xsl:if test=". != ''">
            <xsl:element name="etd:discipline">
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template match="grantor">
        <xsl:element name="etd:grantor">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
