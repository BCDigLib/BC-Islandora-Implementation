<?xml version="1.0" encoding="UTF-8"?>
<!-- RELS-INT 
@todo make the subject of a relationship included in the name of the field-->
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:foxml="info:fedora/fedora-system:def/foxml#"
    xmlns:islandora="http://islandora.ca/ontology/relsint#"
    xmlns:islandora-embargo="info:islandora/islandora-system:def/scholar#" 
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    exclude-result-prefixes="rdf">
    
    <xsl:template match="foxml:datastream[@ID='RELS-INT']/foxml:datastreamVersion[last()]" name='index_RELS-INT'>
        <xsl:param name="content"/>
        <xsl:param name="prefix">RELS_INT_</xsl:param>
        <xsl:param name="suffix">_ms</xsl:param>
        
        <xsl:for-each select="$content//rdf:Description/*[@rdf:resource]">
            <field>
                <xsl:attribute name="name">
                    <xsl:value-of select="concat($prefix, local-name(), '_uri', $suffix)"/>
                </xsl:attribute>
                <xsl:value-of select="@rdf:resource"/>
            </field>
        </xsl:for-each>
        <xsl:for-each select="$content//rdf:Description/*[not(@rdf:resource)][normalize-space(text())]">
            <field>
                <xsl:attribute name="name">
                    <xsl:value-of select="concat($prefix, local-name(), '_literal', $suffix)"/>
                </xsl:attribute>
                <xsl:value-of select="text()"/>
            </field>
        </xsl:for-each>

        <!-- Virtual field for embargo date -->

        <xsl:for-each select="$content//rdf:Description/islandora-embargo:embargo-until[normalize-space(text())]">
            <xsl:choose>
                <xsl:when test=".='indefinite'">
                    <field>
                        <xsl:attribute name="name">
                            <xsl:value-of select="concat('Embargo', $suffix)"/>
                        </xsl:attribute>
                        <xsl:text>The content of this item is unavailable on eScholarship@BC. Please see our Help section for more information.</xsl:text>
                    </field>
                </xsl:when>
                <xsl:otherwise>
                    <field>
                        <xsl:attribute name="name">
                            <xsl:value-of select="concat('Embargo', $suffix)"/>
                        </xsl:attribute>
                        <xsl:text>The content of this item is under embargo and unavailable until: </xsl:text>
                        <xsl:value-of select="substring(text(),1,10)"/>
                    </field>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>

    </xsl:template>
</xsl:stylesheet>
