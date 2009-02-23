<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template name="nl2br">
	<xsl:param name="str"/>
	<xsl:choose>
		<xsl:when test="contains($str,'&#xA;')">
			<xsl:value-of select="substring-before($str,'&#xA;')"/>
			<br/>
			<xsl:call-template name="nl2br">
				<xsl:with-param name="str" select="substring-after($str,'&#xA;')"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$str"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
