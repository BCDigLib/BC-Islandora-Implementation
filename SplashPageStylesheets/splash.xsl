<?xml version="1.0" encoding="UTF-8"?>
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




            <!-- Page master for Cover Page -->

            <fo:layout-master-set>
                <fo:simple-page-master master-name="cover-page" page-width="8.5in"
                    page-height="11in" margin-top="0.5in" margin-bottom="0.5in" margin-left="0.5in"
                    margin-right="0.5in">
                    <fo:region-body margin="0.5in" margin-top=".5in" margin-bottom=".5in"/>
                    <fo:region-before extent=".5in"/>
                    <fo:region-after extent="4.0in"/>
                </fo:simple-page-master>
            </fo:layout-master-set>

            <!--Adding PDF document properties -->
            <fo:declarations>
                <x:xmpmeta xmlns:x="adobe:ns:meta/">
                    <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
                        <rdf:Description rdf:about="" xmlns:dc="http://purl.org/dc/elements/1.1/">

                            <dc:title>
                                <xsl:value-of select="/mods:mods/mods:titleInfo/mods:title"/>
                            </dc:title>

                                <xsl:if test="mods:name/mods:role/mods:roleTerm='aut'">
                            <dc:creator>
                                <xsl:value-of
                                    select="/mods:mods/mods:name/mods:namePart[@type='given']"/>
                                <xsl:text> </xsl:text>
                                <xsl:value-of
                                    select="/mods:mods/mods:name/mods:namePart[@type='family']"/>
                            </dc:creator>
                                </xsl:if>

                            <xsl:for-each select="/mods:mods/mods:name[not(position()='1')]">
                               <dc:contributor>
                                   <xsl:value-of
                                       select="mods:namePart[@type='given']"/>
                                   <xsl:text> </xsl:text>
                                   <xsl:value-of
                                       select="mods:namePart[@type='family']"/>
                               </dc:contributor>

                            </xsl:for-each>
                            <xsl:text/>

                            <xsl:for-each select="/mods:mods/mods:subject">
                                <dc:subject>
                                    <xsl:value-of select="."/>
                                </dc:subject>
                            </xsl:for-each>

                        </rdf:Description>

                    </rdf:RDF>
                </x:xmpmeta>
            </fo:declarations>

            <!-- The fo:page-sequence establishes headers, footers and the body of the page.-->

            <fo:page-sequence master-reference="cover-page">
                <fo:static-content flow-name="xsl-region-after">
                    <fo:block font-family="FreeSans" margin-left=".5in" margin-right=".5in"
                        margin-bottom=".25in" text-align="left">
                        <xsl:call-template name="handle"/>
                    </fo:block>
                    <fo:block font-family="FreeSans" margin-left=".5in" text-align="left"
                        font-size="16pt" line-height="20pt"> This work is posted on <fo:basic-link
                            external-destination="http://escholarship.bc.edu" color="#990000"
                            >eScholarship@BC</fo:basic-link>, </fo:block>
                    <fo:block font-family="FreeSans" margin-bottom=".25in" margin-left=".5in"
                        text-align="left" font-size="16pt" line-height="20pt">Boston College
                        University Libraries.</fo:block>
                    <fo:block font-family="FreeSans" margin-left=".5in" margin-right=".5in"
                        border-top=".5pt solid #990000" line-height="50pt"/>
                    <fo:block font-family="FreeSans" margin-top=".25in" margin-left=".5in"
                        margin-right=".5in" text-align="left" font-size="12pt" line-height="15pt">
                        <xsl:call-template name="version"/>
                    </fo:block>
                    <fo:block font-family="FreeSans" margin-left=".5in" margin-right=".5in"
                        text-align="left" font-size="12pt" line-height="15pt" space-before="22">
                        <xsl:value-of select="mods:accessCondition[@type='use and reproduction']"/>
                    </fo:block>
                </fo:static-content>
                <fo:flow flow-name="xsl-region-body">
                    <fo:block font-family="FreeSans">
                        <xsl:call-template name="article"/>
                    </fo:block>
                </fo:flow>
            </fo:page-sequence>

        </fo:root>
    </xsl:template>

    <xsl:template name="article">
        <fo:block text-align="left" padding-top=".25in" font-weight="normal" line-height="24pt"
            space-after="18pt" padding-bottom="12pt">
            <xsl:call-template name="titleInfo"/>
            <xsl:call-template name="contributors"/>
        </fo:block>
    </xsl:template>

    <xsl:template name="titleInfo">
        <fo:block font-size="26pt" line-height="32pt" wrap-option="wrap" space-after="18pt">
            <xsl:if test="mods:titleInfo[not (@type)]/mods:nonSort">
                <xsl:value-of select="mods:titleInfo[not (@type)]/mods:nonSort"/>
            </xsl:if>
            <xsl:value-of select="mods:titleInfo[not (@type)]/mods:title"/>
            <xsl:if test="mods:titleInfo[not (@type)]/mods:subTitle">
                <xsl:text>: </xsl:text>
                <xsl:value-of select="mods:titleInfo[not (@type)]/mods:subTitle"/>
            </xsl:if>
        </fo:block>
        <fo:block font-size="26pt" wrap-option="wrap" space-after="18pt">
            <xsl:if
                test="mods:titleInfo[not (@type)]/mods:partNumber or mods:titleInfo[not (@type)]/mods:partName">
                <xsl:text>. </xsl:text>
            </xsl:if>
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
            <fo:block font-size="18pt">

                <!-- Currently set up just to handle authors. xsl:if field can be removed to apply to all mods:roleTerm fields -->

                <xsl:if test="mods:role/mods:roleTerm='Author'">
                    <xsl:value-of select="mods:role/mods:roleTerm[@type='text']"/>
                    <xsl:for-each
                        select="key('contributors-by-role', mods:role/mods:roleTerm[@type='text'])">
                        <xsl:if test="(position()=1 and position()!=last())">
                            <xsl:text>s</xsl:text>
                        </xsl:if>
                        <xsl:if test="(position()=1)">
                            <xsl:text>: </xsl:text>
                        </xsl:if>
                        <xsl:if test="(position()&lt;=25)">
                            <xsl:choose>
                                <xsl:when test="mods:namePart[@type='family']">
                                    <xsl:value-of
                                        select="concat(mods:namePart[@type='given'],' ',mods:namePart[@type='family'])"
                                    />
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="mods:displayForm"/>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:if test="not(position()=last()) and not(position()=25)">
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                        </xsl:if>
                        <xsl:if test="(position()=25)">
                            <xsl:text>...</xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:if>
            </fo:block>
            <xsl:text>&#xA;</xsl:text>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="handle">
        <xsl:if test="mods:identifier[@type= 'hdl']">
            <fo:block font-size="16pt" space-before="22">Persistent link: <fo:basic-link
                    color="#990000">
                    <xsl:attribute name="external-destination"><xsl:value-of
                            select="mods:identifier[@type= 'hdl']"/></xsl:attribute>
                    <xsl:value-of select="mods:identifier[@type= 'hdl']"/>
                </fo:basic-link>
            </fo:block>
        </xsl:if>
    </xsl:template>

    <xsl:template name="version">
        <xsl:choose>
            <xsl:when
                test="mods:genre[@authority='ndltd']='Electronic Thesis or Dissertation' and mods:originInfo/mods:publisher='Boston College'">
                <fo:block font-size="12pt" space-before="22">
                    <xsl:text>Boston College Electronic Thesis or Dissertation, </xsl:text>
                    <xsl:value-of select="mods:originInfo/mods:dateIssued[not (@encoding)]"/>
                </fo:block>
            </xsl:when>
            <xsl:when test="mods:identifier[@type='repec']">
                <fo:block font-size="12pt" space-before="22">
                    <xsl:text>Boston College Working Papers in Economics, </xsl:text>
                    <xsl:value-of select="mods:originInfo/mods:dateIssued[not (@encoding)]"/>
                </fo:block>
                <fo:block font-size="12pt" space-before="22">
                    <xsl:value-of select="mods:note"/>
                </fo:block>
            </xsl:when>
            <xsl:when test="mods:note[@type='version identification'] = 'Version of record.'">
                <xsl:call-template name="publisher"/>
            </xsl:when>
            <xsl:when
                test="mods:note[@type='version identification'] = mods:note[starts-with(.,'Post-print')]">
                <fo:block font-size="12pt" space-before="22">
                    <xsl:value-of select="mods:note[@type='version identification']"/>
                </fo:block>
            </xsl:when>
            <xsl:when
                test="mods:note[@type='version identification'] = mods:note[starts-with(.,'Pre-print')]">
                <fo:block font-size="12pt" space-before="22">
                    <xsl:value-of select="mods:note[@type='version identification']"/>
                </fo:block>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="publisher"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="publisher">
        <xsl:choose>
            <xsl:when test="mods:relatedItem[@type='host']">
                <fo:block font-size="12pt" space-before="22">
                    <xsl:text>Published in </xsl:text>
                    <fo:inline font-style="italic">
                        <xsl:value-of select="mods:relatedItem/mods:titleInfo/mods:title"/>
                    </fo:inline>
                    <xsl:if test="mods:relatedItem/mods:part/mods:detail[@type='volume']">
                        <xsl:text>, vol. </xsl:text>
                        <xsl:value-of
                            select="mods:relatedItem/mods:part/mods:detail[@type='volume']/mods:number"
                        />
                    </xsl:if>
                    <xsl:if test="mods:relatedItem/mods:part/mods:detail[@type='issue']">
                        <xsl:text>, no. </xsl:text>
                        <xsl:value-of
                            select="mods:relatedItem/mods:part/mods:detail[@type='issue']/mods:number"
                        />
                    </xsl:if>
                    <xsl:if test="mods:relatedItem/mods:part/mods:extent/mods:list">
                        <xsl:text>, </xsl:text>
                        <xsl:value-of select="mods:relatedItem/mods:part/mods:extent/mods:list"/>
                    </xsl:if>
                    <xsl:if test="mods:relatedItem/mods:part/mods:date">
                        <xsl:text>, </xsl:text>
                        <xsl:value-of select="mods:relatedItem/mods:part/mods:date"/>
                    </xsl:if>
                </fo:block>
            </xsl:when>
            <xsl:when test="mods:originInfo/mods:publisher">
                <fo:block font-size="12pt" space-before="22">
                    <xsl:value-of select="mods:originInfo/mods:place/mods:placeTerm[@type='text']"/>
                    <xsl:text>: </xsl:text>
                    <xsl:value-of select="mods:originInfo/mods:publisher"/>
                    <xsl:if test="mods:originInfo/mods:dateIssued">
                        <xsl:text>, </xsl:text>
                        <xsl:value-of select="mods:originInfo/mods:dateIssued[not (@encoding)]"/>
                    </xsl:if>
                    <xsl:if test="mods:originInfo/mods:dateCreated">
                        <xsl:text>, </xsl:text>
                        <xsl:value-of select="mods:originInfo/mods:dateCreated[not (@encoding)]"/>
                    </xsl:if>
                </fo:block>
            </xsl:when>
            <xsl:otherwise>
                <fo:block font-size="12pt" space-before="22">
                    <xsl:if test="mods:originInfo/mods:dateIssued">
                        <xsl:value-of select="mods:originInfo/mods:dateIssued[not (@encoding)]"/>
                    </xsl:if>
                    <xsl:if test="mods:originInfo/mods:dateCreated">
                        <xsl:value-of select="mods:originInfo/mods:dateCreated[not (@encoding)]"/>
                    </xsl:if>
                </fo:block>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


</xsl:stylesheet>
