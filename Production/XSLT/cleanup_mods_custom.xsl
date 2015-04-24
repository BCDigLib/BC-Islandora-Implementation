<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:mods="http://www.loc.gov/mods/v3">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" media-type="application/xml"/>
    <xsl:strip-space elements="*"/>
    <xsl:template match="*[not(node())]"/>
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()[normalize-space()]|@*[normalize-space()]"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="mods:nonSort[.='The' or .='A' or .='An' or .='La']">
        <mods:nonSort><xsl:value-of select="."/><xsl:text> </xsl:text></mods:nonSort>
    </xsl:template>
</xsl:stylesheet>