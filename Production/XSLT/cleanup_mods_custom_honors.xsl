<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:etdms="http://www.ndltd.org/standards/metadata/etdms/1.0/">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" media-type="application/xml"/>
    <xsl:strip-space elements="*"/>
    <xsl:template match="*">
        <xsl:apply-templates select="node()|@*"/>
    </xsl:template>
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()[normalize-space()]|@*[normalize-space()]"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="mods:title">
        <xsl:choose>
            <xsl:when test="starts-with(., 'A ')">
                <xsl:element name="mods:nonSort"><xsl:value-of select="substring(.,1,2)"/></xsl:element>
                <xsl:element name="mods:title"><xsl:value-of select="normalize-space(substring(.,3))"/></xsl:element>
            </xsl:when>
            <xsl:when test="starts-with(., 'An ') or starts-with(.,'La ')">
                <xsl:element name="mods:nonSort"><xsl:value-of select="substring(.,1,3)"/></xsl:element>
                <xsl:element name="mods:title"><xsl:value-of select="normalize-space(substring(.,4))"/></xsl:element>
            </xsl:when>
            <xsl:when test="starts-with(., 'The ')">
                <xsl:element name="mods:nonSort"><xsl:value-of select="substring(.,1,4)"/></xsl:element>
                <xsl:element name="mods:title"><xsl:value-of select="normalize-space(substring(.,5))"/></xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="mods:title"><xsl:value-of select="normalize-space(.)"/></xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="mods:name">
        <xsl:element name="mods:name">
            <xsl:attribute name='type'>personal</xsl:attribute>
            <xsl:if test="@usage='primary'">
                <xsl:attribute name='usage'>primary</xsl:attribute>
            </xsl:if>
            <xsl:element name="mods:namepart">
                <xsl:attribute name='type'>family</xsl:attribute>
                <xsl:value-of select="normalize-space(mods:namePart[@type='family'])"/>
            </xsl:element>
            <xsl:element name="mods:namepart">
                <xsl:attribute name='type'>given</xsl:attribute>
                <xsl:value-of select="normalize-space(mods:namePart[@type='given'])"/>
            </xsl:element> 
            <xsl:element name="mods:displayForm">
                <xsl:value-of select="normalize-space(mods:namePart[@type='family'])"/><xsl:text>, </xsl:text><xsl:value-of select="normalize-space(mods:namePart[@type='given'])"/>
            </xsl:element>
            <xsl:element name="mods:role">
                <xsl:copy-of select="mods:role/mods:roleTerm"/>           
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="mods:originInfo">
        <xsl:element name="mods:originInfo">
            <xsl:copy-of select="mods:publisher"/>
            <xsl:element name="mods:dateIssued"><xsl:value-of select="normalize-space(mods:dateIssued)"/></xsl:element>
            <xsl:element name="mods:dateIssued">
                <xsl:attribute name="encoding">w3cdtf</xsl:attribute>        
                <xsl:attribute name="keyDate">yes</xsl:attribute> 
                <xsl:value-of select="normalize-space(mods:dateIssued)"/>
            </xsl:element>
            <xsl:copy-of select="mods:issuance"/>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>