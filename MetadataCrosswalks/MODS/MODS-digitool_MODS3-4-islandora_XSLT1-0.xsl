<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0">

    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

    <xsl:key name="distinctAffiliations" match="mods:name/mods:affiliation" use="."/>

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="mods:mods">
        <mods:mods version="3.4" xmlns:mods="http://www.loc.gov/mods/v3"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-4.xsd">
            <xsl:apply-templates select="mods:titleInfo"/>
            <xsl:apply-templates select="mods:name"/>
            <xsl:copy-of select="mods:typeOfResource"/>
            <xsl:apply-templates select="mods:genre"/>
            <xsl:apply-templates select="mods:originInfo"/>
            <xsl:apply-templates select="mods:language"/>
            <xsl:apply-templates select="mods:physicalDescription"/>
            <xsl:apply-templates select="mods:abstract"/>
            <xsl:apply-templates select="mods:tableOfContents"/>
            <!--mods:targetAudience not used in IR-->
            <xsl:apply-templates select="mods:note"/>
            <xsl:apply-templates select="mods:subject"/>
            
            <xsl:apply-templates select="mods:classification"/>
            <xsl:apply-templates select="mods:relatedItem"/>
            <xsl:apply-templates select="mods:identifier"/>
            <xsl:apply-templates select="mods:location"/>
            <xsl:apply-templates select="mods:accessCondition"/>
            <xsl:apply-templates select="mods:part"/>
            <xsl:apply-templates select="mods:extension"/>
            <xsl:if test="contains(mods:relatedItem[@type='series']/mods:titleInfo/mods:title,'CRR')">
                <xsl:element name="mods:extension">
                <xsl:element name="localCollectionName">
                    <xsl:text>crr</xsl:text>
                </xsl:element>
                </xsl:element>
            </xsl:if>
            <xsl:apply-templates select="mods:recordInfo"/>
        </mods:mods>
    </xsl:template>

    <xsl:template name="enhanceLocalCollections">
        <xsl:if test="contains(preceding-sibling::mods:relatedItem/mods:name/mods:displayForm,'Church in the 21st')">
        <xsl:element name="localCollectionName">
            <xsl:text>c21</xsl:text>
        </xsl:element>
        </xsl:if>

        <xsl:if test="contains(preceding-sibling::mods:relatedItem/mods:titleInfo/mods:title,'Berkeley Center') or contains(preceding-sibling::mods:relatedItem/mods:titleInfo/mods:title,'Workplace Flexibility Case Study')">
            <xsl:element name="localCollectionName">
                <xsl:text>wfrn</xsl:text>
            </xsl:element>
        </xsl:if>
                
    </xsl:template>
   
    <xsl:template match="mods:relatedItem">
        <xsl:if test="attribute::node()">
        <xsl:element name="mods:relatedItem">
            <xsl:copy-of select="attribute::node()"/>
            <xsl:apply-templates select="mods:titleInfo"/>
            <xsl:apply-templates select="mods:name"/>
            <xsl:copy-of select="mods:typeOfResource"/>
            <xsl:apply-templates select="mods:genre"/>
            <xsl:apply-templates select="mods:originInfo"/>
            <xsl:apply-templates select="mods:language"/>
            <xsl:apply-templates select="mods:physicalDescription"/>
            <xsl:apply-templates select="mods:abstract"/>
            <xsl:apply-templates select="mods:tableOfContents"/>
            <!--mods:targetAudience not used in IR-->
            <xsl:apply-templates select="mods:note"/>
            <xsl:apply-templates select="mods:subject"/>
            <xsl:apply-templates select="mods:classification"/>
            <xsl:apply-templates select="mods:relatedItem"/>
            <xsl:apply-templates select="mods:identifier"/>
            <xsl:apply-templates select="mods:location"/>
            <!--mods:accessCondition not used in relatedItem-->
            <xsl:apply-templates select="mods:part"/>
            <!--mods:extension not used in relatedItem-->
            <xsl:apply-templates select="mods:recordInfo"/>

        </xsl:element>
        </xsl:if>

    </xsl:template>

    <xsl:template match="mods:recordInfo">
        <xsl:element name="mods:recordInfo">
            <xsl:element name="mods:recordContentSource">
                <xsl:attribute name="authority">marcorg</xsl:attribute>
                <xsl:choose>
                    <xsl:when test="mods:recordContentSource='BXM'">
                        <xsl:text>MChB</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="normalize-space(mods:recordContentSource)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
            <xsl:if test="mods:recordOrigin">
                <xsl:element name="mods:recordContentSource">
                    <xsl:attribute name="authority">naf</xsl:attribute>
                    <xsl:value-of select="normalize-space(mods:recordOrigin)"/>
                </xsl:element>
            </xsl:if>
            <xsl:copy-of select="mods:recordCreationDate"/>
            <xsl:copy-of select="mods:recordChangeDate"/>
            <xsl:copy-of select="mods:recordIdentifier"/>
            <xsl:copy-of select="mods:languageOfCataloging"/>

        </xsl:element>

    </xsl:template>



    <xsl:template match="mods:extension">
        <xsl:element name="mods:extension">
            <xsl:for-each select="mods:localCollectionName">
                <xsl:element name="localCollectionName">
                    <xsl:value-of select="normalize-space(.)"/>
                </xsl:element>
                <xsl:if test="contains(.,'C21')">
                    <xsl:element name="localCollectionName">
                        <xsl:text>c21</xsl:text>
                    </xsl:element>
                </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="localCollectionName">
                <xsl:element name="localCollectionName">
                    <xsl:value-of select="normalize-space(.)"/>
                </xsl:element>
                <xsl:if test="contains(.,'C21')">
                    <xsl:element name="localCollectionName">
                        <xsl:text>c21</xsl:text>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="contains(.,'CWP')">
                    <xsl:element name="localCollectionName">
                        <xsl:text>cwp</xsl:text>
                    </xsl:element>
                    
                </xsl:if>
                <xsl:if test="contains(.,'sloanagingwork')">
                    <xsl:element name="localCollectionName">
                        <xsl:text>scaw</xsl:text>
                    </xsl:element>
                    
                </xsl:if>
            </xsl:for-each>
                    
            <xsl:call-template name="enhanceLocalCollections"/> 
            <xsl:copy-of select="ingestFile"/>
        </xsl:element>

    </xsl:template>

    <xsl:template match="mods:part">
        <xsl:copy-of select="."/>

    </xsl:template>
    <xsl:template match="mods:accessCondition">
        <xsl:element name="mods:accessCondition">
            <xsl:attribute name="type">use and reproduction</xsl:attribute>
            <xsl:value-of select="normalize-space(translate(., '“”', '&quot;&quot;'))"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="mods:location">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="mods:identifier">
        <xsl:copy-of select="."/>
    </xsl:template>

    <xsl:template match="mods:classification">
        <xsl:copy-of select="."/>
    </xsl:template>

    <xsl:template match="mods:subject">
        <xsl:copy-of select="."/>
    </xsl:template>

    <xsl:template match="mods:note">
        <xsl:copy-of select="."/>
    </xsl:template>

    <xsl:template match="mods:tableOfContents">
        <xsl:copy-of select="."/>
    </xsl:template>

    <xsl:template match="mods:abstract">
        <xsl:element name="mods:abstract">
            <xsl:value-of select="normalize-space(translate(., '“”', '&quot;&quot;'))"/>
    
        </xsl:element>
        
    </xsl:template>

    <xsl:template match="mods:physicalDescription">
        <xsl:element name="mods:physicalDescription">
            <xsl:element name="mods:form">
                <xsl:attribute name="authority">marcform</xsl:attribute>
                <xsl:text>electronic</xsl:text>
            </xsl:element>
            <xsl:choose>
                <xsl:when test="mods:internetMediaType">
                    <xsl:copy-of select="mods:internetMediaType"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="mods:internetMediaType">
                        <xsl:text>application/pdf</xsl:text>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:copy-of select="mods:extent"/>
            <xsl:choose>
                <xsl:when test="mods:digitalOrigin">
                    <xsl:element name="mods:digitalOrigin">
                        <xsl:value-of select="mods:digitalOrigin"/>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="mods:digitalOrigin">
                        <xsl:text>reformatted digital</xsl:text>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>


        </xsl:element>

    </xsl:template>
    <xsl:template match="mods:language">
        <xsl:element name="mods:language">
            <xsl:copy-of select="mods:languageTerm[@type='code']"/>
            <xsl:element name="mods:languageTerm">
                <xsl:attribute name="authority">iso639-2b</xsl:attribute>
                <xsl:attribute name="type">text</xsl:attribute>
                <xsl:if test="mods:languageTerm[@type='code']='ara'">Arabic</xsl:if>
                <xsl:if test="mods:languageTerm[@type='code']='eng'">English</xsl:if>
                <xsl:if test="mods:languageTerm[@type='code']='fre'">French</xsl:if>
                <xsl:if test="mods:languageTerm[@type='code']='ger'">German</xsl:if>
                <xsl:if test="mods:languageTerm[@type='code']='ita'">Italian</xsl:if>
                <xsl:if test="mods:languageTerm[@type='code']='lat'">Latin</xsl:if>
                <xsl:if test="mods:languageTerm[@type='code']='spa'">Spanish</xsl:if>
                <xsl:if test="mods:languageTerm[@type='code']='tur'">Turkish</xsl:if>

            </xsl:element>
        </xsl:element>


    </xsl:template>

    <xsl:template match="mods:originInfo">
        <xsl:element name="mods:originInfo">
            <xsl:if test="mods:place">
                <xsl:element name="mods:place">
                    <xsl:choose>
                        <xsl:when test="(mods:place[1]/@supplied) or (mods:place[2]/@supplied)">
                            <xsl:attribute name="supplied">yes</xsl:attribute>
                        </xsl:when>
                        <xsl:when
                            test="starts-with(mods:place[1]/mods:placeTerm[*], '[') or starts-with(mods:place[2]/mods:placeTerm[*], '[')">
                            <xsl:attribute name="supplied">yes</xsl:attribute>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:for-each select="mods:place/mods:placeTerm">
                        <xsl:element name="mods:placeTerm">
                            <xsl:attribute name="type">
                                <xsl:choose>
                                    <xsl:when test="not(@type='code')">
                                        <xsl:text>text</xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>code</xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                            <xsl:if test="@authority">
                                <xsl:attribute name="authority">
                                    <xsl:value-of select="@authority"/>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:value-of select="normalize-space(translate(., '[]', ''))"/>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:if>
            <xsl:copy-of select="mods:publisher"/>
            <xsl:copy-of select="mods:dateIssued"/>
            <xsl:copy-of select="mods:dateCreated"/>
            <xsl:copy-of select="mods:copyrightDate"/>
            <xsl:copy-of select="mods:edition"/>
            <xsl:copy-of select="mods:issuance"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="mods:genre">
        <xsl:element name="mods:genre">
            <xsl:choose>
                <xsl:when
                    test="(.='Book part') or (.='book part') or (.='blog entry') or (.='case study') or (.='encyclopedia entry') or (.='occasional paper') or (.='report') or (.='working paper')">
                    <xsl:attribute name="authority">local</xsl:attribute>
                </xsl:when>
                <xsl:when test="@authority='rasuqam'">
                    <xsl:attribute name="authority">rasuqam</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="authority">marcgt</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:attribute name="type">work type</xsl:attribute>
            <xsl:if test="position()=1">
                <xsl:attribute name="usage">primary</xsl:attribute>
            </xsl:if>
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="mods:titleInfo">
        <xsl:choose>
            <xsl:when test="(starts-with(child::mods:title, '['))">
                <xsl:element name="mods:titleInfo">
                    <xsl:attribute name="supplied">yes</xsl:attribute>
                    <xsl:attribute name="usage">primary</xsl:attribute>
                    <xsl:element name="mods:title">
                        <xsl:value-of select="normalize-space(translate(mods:title,'[]', ''))"/>
                    </xsl:element>
                    <xsl:copy-of select="mods:subTitle"/>
                    <xsl:copy-of select="mods:partNumber"/>
                    <xsl:copy-of select="mods:partName"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="not(@*)">
                <xsl:element name="mods:titleInfo">
                    <xsl:attribute name="usage">primary</xsl:attribute>
                    <xsl:copy-of select="child::node()"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="@nameTitleGroup">
                <xsl:element name="mods:titleInfo">
                    <xsl:attribute name="usage">primary</xsl:attribute>
                    <xsl:attribute name="nameTitleGroup">
                        <xsl:value-of select="@nameTitleGroup"/>
                    </xsl:attribute>
                    <xsl:copy-of select="child::node()"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="@supplied">
                <xsl:element name="mods:titleInfo">
                    <xsl:attribute name="usage">primary</xsl:attribute>
                    <xsl:attribute name="supplied">yes</xsl:attribute>
                    <xsl:copy-of select="child::node()"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="@displayLabel='columnTitle'">
                <xsl:element name="mods:titleInfo">
                    <xsl:attribute name="type">alternative</xsl:attribute>
                    <xsl:attribute name="displayLabel">Column title</xsl:attribute>
                    <xsl:copy-of select="child::node()"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="mods:titleInfo">
                    <xsl:attribute name="type">
                        <xsl:value-of select="@type"/>
                    </xsl:attribute>
                    <xsl:if test="@displayLabel">
                        <xsl:attribute name="displayLabel">
                            <xsl:value-of select="@displayLabel"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:copy-of select="child::node()"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>
    <xsl:template match="mods:name">
        <xsl:choose>
            <xsl:when
                test="(mods:role/mods:roleTerm[@type='text']='Author') or (mods:role/mods:roleTerm[@type='text']='Creator')or (mods:role/mods:roleTerm[@type='text']='Interviewee')or (mods:role/mods:roleTerm[@type='text']='Speaker')">
                <xsl:element name="mods:name">
                    <xsl:attribute name="type">
                        <xsl:value-of select="@type"/>
                    </xsl:attribute>
                    <xsl:if test="@authority">
                        <xsl:attribute name="authority">
                            <xsl:value-of select="@authority"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:attribute name="usage">primary</xsl:attribute>
                    <xsl:if test="@nameTitleGroup">
                        <xsl:attribute name="nameTitleGroup">
                            <xsl:value-of select="@nameTitleGroup"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:copy-of select="mods:namePart"/>
                    <xsl:copy-of select="mods:displayForm"/>
                    <xsl:copy-of select="mods:affiliation"/>
                    <xsl:choose>

                        <xsl:when test="count(mods:role[1]/mods:roleTerm)=2">
                            <xsl:copy-of select="mods:role"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:for-each select="mods:role">
                                <xsl:element name="mods:role">
                                    <xsl:element name="mods:roleTerm">
                                        <xsl:attribute name="type">text</xsl:attribute>
                                        <xsl:attribute name="authority">marcrelator</xsl:attribute>
                                        <xsl:value-of select="mods:roleTerm"/>
                                    </xsl:element>
                                    <xsl:element name="mods:roleTerm">
                                        <xsl:attribute name="type">code</xsl:attribute>
                                        <xsl:attribute name="authority">marcrelator</xsl:attribute>
                                        <xsl:if test="mods:roleTerm='Associated name'">asn</xsl:if>
                                        <xsl:if test="mods:roleTerm='Author'">aut</xsl:if>
                                        <xsl:if test="mods:roleTerm='Contributor'">ctb</xsl:if>
                                        <xsl:if test="mods:roleTerm='Creator'">cre</xsl:if>
                                        <xsl:if test="mods:roleTerm='Editor'">edt</xsl:if>
                                        <xsl:if test="mods:roleTerm='Funder'">fnd</xsl:if>
                                        <xsl:if test="mods:roleTerm='Honoree'">hnr</xsl:if>
                                        <xsl:if test="mods:roleTerm='Interviewee'">ive</xsl:if>
                                        <xsl:if test="mods:roleTerm='Interviewer'">ivr</xsl:if>
                                        <xsl:if test="mods:roleTerm='Issuing body'">isb</xsl:if>
                                        <xsl:if test="mods:roleTerm='Moderator'">mod</xsl:if>
                                        <xsl:if test="mods:roleTerm='Organizer'">org</xsl:if>
                                        <xsl:if test="mods:roleTerm='Other'">oth</xsl:if>
                                        <xsl:if test="mods:roleTerm='Project director'">pdr</xsl:if>
                                        <xsl:if test="mods:roleTerm='Publisher'">pbl</xsl:if>
                                        <xsl:if test="mods:roleTerm='Publishing Director'"
                                            >pbd</xsl:if>
                                        <xsl:if test="mods:roleTerm='Researcher'">res</xsl:if>
                                        <xsl:if test="mods:roleTerm='Speaker'">spk</xsl:if>
                                        <xsl:if test="mods:roleTerm='Sponsor'">spn</xsl:if>
                                        <xsl:if test="mods:roleTerm='Transcriber'">trc</xsl:if>
                                        <xsl:if test="mods:roleTerm='Translator'">trl</xsl:if>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:copy-of select="mods:description"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="mods:name">
                    <xsl:attribute name="type">
                        <xsl:value-of select="@type"/>
                    </xsl:attribute>
                    <xsl:if test="@authority">
                        <xsl:attribute name="authority">
                            <xsl:value-of select="@authority"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@nameTitleGroup">
                        <xsl:attribute name="nameTitleGroup">
                            <xsl:value-of select="@nameTitleGroup"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:copy-of select="mods:namePart"/>
                    <xsl:copy-of select="mods:displayForm"/>
                    <xsl:copy-of select="mods:affiliation"/>
                    <xsl:choose>

                        <xsl:when test="count(mods:role[1]/mods:roleTerm)=2">
                            <xsl:copy-of select="mods:role"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:for-each select="mods:role">
                                <xsl:element name="mods:role">
                                    <xsl:element name="mods:roleTerm">
                                        <xsl:attribute name="type">text</xsl:attribute>
                                        <xsl:attribute name="authority">marcrelator</xsl:attribute>
                                        <xsl:value-of select="mods:roleTerm"/>
                                    </xsl:element>
                                    <xsl:element name="mods:roleTerm">
                                        <xsl:attribute name="type">code</xsl:attribute>
                                        <xsl:attribute name="authority">marcrelator</xsl:attribute>
                                        <xsl:if test="mods:roleTerm='Associated name'">asn</xsl:if>
                                        <xsl:if test="mods:roleTerm='Author'">aut</xsl:if>
                                        <xsl:if test="mods:roleTerm='Contributor'">ctb</xsl:if>
                                        <xsl:if test="mods:roleTerm='Creator'">cre</xsl:if>
                                        <xsl:if test="mods:roleTerm='Editor'">edt</xsl:if>
                                        <xsl:if test="mods:roleTerm='Funder'">fnd</xsl:if>
                                        <xsl:if test="mods:roleTerm='Honoree'">hnr</xsl:if>
                                        <xsl:if test="mods:roleTerm='Interviewee'">ive</xsl:if>
                                        <xsl:if test="mods:roleTerm='Interviewer'">ivr</xsl:if>
                                        <xsl:if test="mods:roleTerm='Issuing body'">isb</xsl:if>
                                        <xsl:if test="mods:roleTerm='Moderator'">mod</xsl:if>
                                        <xsl:if test="mods:roleTerm='Organizer'">org</xsl:if>
                                        <xsl:if test="mods:roleTerm='Other'">oth</xsl:if>
                                        <xsl:if test="mods:roleTerm='Project director'">pdr</xsl:if>
                                        <xsl:if test="mods:roleTerm='Publisher'">pbl</xsl:if>
                                        <xsl:if test="mods:roleTerm='Publishing Director'"
                                            >pbd</xsl:if>
                                        <xsl:if test="mods:roleTerm='Researcher'">res</xsl:if>
                                        <xsl:if test="mods:roleTerm='Speaker'">spk</xsl:if>
                                        <xsl:if test="mods:roleTerm='Sponsor'">spn</xsl:if>
                                        <xsl:if test="mods:roleTerm='Transcriber'">trc</xsl:if>
                                        <xsl:if test="mods:roleTerm='Translator'">trl</xsl:if>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:otherwise>

                    </xsl:choose>
                    <xsl:copy-of select="mods:description"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>





</xsl:stylesheet>
