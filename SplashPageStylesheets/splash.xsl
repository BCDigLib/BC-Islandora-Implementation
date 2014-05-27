<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:mods="http://www.loc.gov/mods/v3" xmlns:fo="http://www.w3.org/1999/XSL/Format">

    <xsl:output method="xml" encoding="utf-8" indent="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:key name="contributors-by-role" match="mods:name"
        use="mods:role/mods:roleTerm[@type='text']"/>


    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="mods:mods">

        <!--fo:root establishes the page type and layouts contained in the PDF. To alter basic page apperence 
            such as margins fonts alter the following page-masters.-->
        <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
            <fo:layout-master-set>
                <!-- Page master for Cover Page -->
                <fo:simple-page-master master-name="cover-page" page-width="8.5in"
                    page-height="11in" margin-top="0.2in" margin-bottom="0.5in" margin-left="0.5in"
                    margin-right="0.5in">
                    <fo:region-body margin="0.5in" margin-bottom=".5in"/>
                    <fo:region-before extent="0.2in"/>
                    <fo:region-after extent="1.25in"/>
                </fo:simple-page-master>

            </fo:layout-master-set>
            <!-- The fo:page-sequence establishes headers, footers and the body of the page.-->
            <fo:page-sequence master-reference="cover-page">
                <fo:static-content flow-name="xsl-region-after">
                    <fo:block margin-left=".5in" border-top=".5pt solid #990000" line-height="50pt"/>
                    <fo:block margin-left=".5in" text-align="left" font-size="10pt" line-height="15pt">
                   
                   This publication is posted on eScholarship@BC, Boston College University Libraries. <fo:basic-link external-destination="http://www.bc.edu/escholarship"
                       color="#990000">http://www.bc.edu/escholarship</fo:basic-link>
                    </fo:block>
                    <fo:block  
                        margin-left=".5in" text-align="left" font-size="10pt" line-height="15pt">Persistent link:
                        <fo:basic-link external-destination="http://www.bc.edu/escholarship"
                            color="#990000"><xsl:value-of select="mods:identifier[@type= 'hdl']"/>
                        </fo:basic-link>
                    </fo:block>
                    <fo:block  
                        margin-left=".5in" text-align="left" font-size="10pt" line-height="15pt">
                        <xsl:value-of select="mods:accessCondition[@type='useAndReproduction']"/>
                    </fo:block>
                        
                </fo:static-content>
                <fo:flow flow-name="xsl-region-body">
                    <fo:block font-family="Arial">
                        <xsl:call-template name="splash"/>
                    </fo:block>
                </fo:flow>
            </fo:page-sequence>

        </fo:root>
    </xsl:template>
    <!-- EAD Header, this information populates the cover page -->
    <xsl:template name="splash">
        <fo:block text-align="left" padding-top=".5in" font-weight="normal" line-height="24pt"
            space-after="18pt" padding-bottom="12pt">

                <xsl:call-template name="titleInfo"/>

          


            <xsl:call-template name="contributors"/>
            
            <xsl:call-template name="date"/>
           


            <!-- Adds repositry branding device. 
            <xsl:if test="/ead:ead/ead:eadheader/ead:filedesc/ead:publicationstmt/ead:p/ead:extref">
                <fo:block>
                    <fo:external-graphic src="{/ead:ead/ead:eadheader/ead:filedesc/ead:publicationstmt/ead:p/ead:extref/ns2:href}" content-height="100%" content-width="100%"/>
                </fo:block>    
            </xsl:if>-->

        </fo:block>
        <!--<fo:block margin="1in" space-before="18pt" font-size="12pt" text-align="center"
            font-weight="normal" line-height="24pt">
            <xsl:text>placeholder 1</xsl:text>
        </fo:block>-->
        <!--<fo:block margin="1in" space-before="18pt" font-size="12pt" text-align="center"
            font-weight="normal" line-height="24pt">
            <xsl:text>placeholder 2</xsl:text>
        </fo:block>-->
    </xsl:template>
    
  
    
    <xsl:template name="date">  
        <xsl:choose>
            <xsl:when test="mods:originInfo/mods:publisher">
                <fo:block font-size="12pt" space-before="18">
                    <xsl:value-of select="mods:originInfo/mods:place/mods:placeTerm[@type='text']"/>
                    <xsl:text>: </xsl:text><xsl:value-of select="mods:originInfo/mods:publisher"/>
                    <xsl:text>, </xsl:text><xsl:value-of select="mods:originInfo/mods:dateIssued[not (@type)]"/>
                </fo:block>
                </xsl:when>
        </xsl:choose>
        
        
    </xsl:template>

    <xsl:template name="titleInfo">
        <fo:block font-size="23pt" wrap-option="wrap" space-after="18pt">
        <xsl:value-of select="mods:titleInfo[not (@type)]/mods:title"/>

        <xsl:if test="mods:titleInfo[not (@type)]/mods:subTitle">
            <xsl:text>: </xsl:text>
            <xsl:value-of select="mods:titleInfo[not (@type)]/mods:subTitle"/>

        </xsl:if>
        </fo:block>
        <fo:block font-size="23pt" wrap-option="wrap" space-after="18pt">
        <!--<xsl:if
            test="mods:titleInfo[not (@type)]/mods:partNumber or mods:titleInfo[not (@type)]/mods:partName">
            <xsl:text>. </xsl:text>
        </xsl:if>-->
        <xsl:if test="mods:titleInfo[not (@type)]/mods:partNumber">
            <xsl:value-of select="mods:titleInfo[not (@type)]/mods:partNumber"/>
        </xsl:if>
        <xsl:if
            test="mods:titleInfo[not (@type)]/mods:partName and mods:titleInfo[not (@type)]/mods:partNumber">
            <xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:value-of select="mods:titleInfo[not (@type)]/mods:partName"/>
        </fo:block>
    </xsl:template>

    <xsl:template name="contributors">

        <xsl:for-each
            select="mods:name[count(. | key('contributors-by-role', mods:role/mods:roleTerm[@type='text'])[1]) = 1]">
            <xsl:sort select="mods:role/mods:roleTerm[@type='text']"/>
            <fo:block font-size="16pt">
                <xsl:value-of select="mods:role/mods:roleTerm[@type='text']"/>

                <xsl:for-each
                    select="key('contributors-by-role', mods:role/mods:roleTerm[@type='text'])">

                    <xsl:if test="(position()=1 and position()!=last())">
                        <xsl:text>s</xsl:text>
                    </xsl:if>
                    <xsl:if test="(position()=1)">
                        <xsl:text>: </xsl:text>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="mods:namePart[@type='family']">
                            <xsl:value-of
                                select="concat(mods:namePart[@type='given'],' ',mods:namePart[@type='family'])"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of
                                select="mods:displayForm"/>
                        </xsl:otherwise>
                    </xsl:choose>             
                    <xsl:if test="not(position()=last())">
                        <xsl:text>, </xsl:text>
                    </xsl:if>

                </xsl:for-each>
              
            </fo:block>
            <xsl:text>&#xA;</xsl:text>
        </xsl:for-each>
    </xsl:template>


</xsl:stylesheet>
