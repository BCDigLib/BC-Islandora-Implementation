<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:etdms="http://www.ndltd.org/standards/metadata/etdms/1.1/"
    xmlns:xlink="http://www.w3.org/1999/xlink" 
    xmlns:mods="http://www.loc.gov/mods/v3" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" exclude-result-prefixes="dc dcterms" 
    version="1.0">
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
            <xsl:apply-templates select="dc:type"/>
            <xsl:element name="mods:originInfo">
                <xsl:apply-templates select="dc:publisher"/>
                <xsl:apply-templates select="dc:date"/>                
            </xsl:element>  
            <xsl:apply-templates select="dcterms:abstract"/>
            <xsl:apply-templates select="dc:subject"/>
            <xsl:apply-templates select="dc:format"/>
            <xsl:apply-templates select="dc:identifier"/>
            <xsl:apply-templates select="dc:language"/>
            <xsl:apply-templates select="dcterms:accessRights"/>
            <xsl:element name="mods:extension">
                <xsl:element name="etdms:degree">
                    <xsl:apply-templates select="dcterms:degreename"/>
                    <xsl:apply-templates select="dcterms:degreelevel"/>
                    <xsl:apply-templates select="dcterms:discipline"/>
                    <xsl:apply-templates select="dcterms:grantor"/>
                </xsl:element>
            </xsl:element>
        </mods:mods>
    </xsl:template>
    <xsl:template match="dc:title">
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
    <xsl:template match="dc:creator">
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
    <xsl:template match="dc:subject">
        <xsl:element name="mods:subject">
            <xsl:element name="mods:topic">
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="dcterms:abstract">
        <xsl:element name="mods:abstract">
            <xsl:apply-templates/>
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
    <xsl:template match="dc:date">
        <xsl:element name="mods:dateIssued">
            <xsl:attribute name="keyDate">yes</xsl:attribute>
        <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="dc:type">
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
            </xsl:when>
        </xsl:choose>        
    </xsl:template>   
    <xsl:template match="dc:format">
        <xsl:element name="mods:physicalDescription">
            <xsl:element name="mods:internetMediaType">
                <xsl:text>application/pdf</xsl:text>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="dc:identifier">  
        <xsl:if test="starts-with(text(), 'http://')">
            <xsl:element name="mods:location">
                <xsl:element name="mods:url">
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:element>
        </xsl:if>            
    </xsl:template>
    <xsl:template match="dc:language">
        <xsl:element name="mods:language">
            <xsl:choose>
                <xsl:when test=". = 'English'">
                    <xsl:element name="mods:languageTerm">
                        <xsl:attribute name="type">code</xsl:attribute>
                        <xsl:text>eng</xsl:text>        
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="mods:languageTerm">
                        <xsl:attribute name="type">text</xsl:attribute>
                        <xsl:apply-templates/>  
                    </xsl:element>
                </xsl:otherwise>    
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
            <xsl:apply-templates/>
        </xsl:element> 
    </xsl:template>    
    
</xsl:stylesheet>
