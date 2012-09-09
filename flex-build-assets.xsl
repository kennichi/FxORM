<?xml version="1.0" encoding="UTF-8"?> 
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    version="1.0"> 
    <xsl:param name="src_dir"/>
    <xsl:output method="xml" omit-xml-declaration="yes"/> 
    
    <xsl:template match="/">
		<flex-config>
			<xsl:apply-templates select="node()|@*" />
		</flex-config>
	</xsl:template>
	
	<xsl:template match="node()|@*">
		<xsl:apply-templates select="node()|@*" />
	</xsl:template>

    <xsl:template match="resourceEntry"> 
        <include-file> 
            <name><xsl:value-of select="@destPath"/></name><path>$src_dir<xsl:value-of select="@sourcePath"/></path> 
        </include-file> 
    </xsl:template> 
    
</xsl:stylesheet>