<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" 
    xmlns:xb="http://com/exlibris/digitool/repository/api/xmlbeans">
    <xsl:output encoding="UTF-8" indent="no" method="xml" omit-xml-declaration="yes" />
    <xsl:param name="mdType"/>
    <xsl:template  match="/xb:digital_entity_result">
        <xsl:for-each select="xb:digital_entity">
            <xsl:value-of select="mds/md[type=$mdType]/value" disable-output-escaping="yes"/>
        </xsl:for-each>        
    </xsl:template>
    <xsl:template match="text()"/>
</xsl:stylesheet>