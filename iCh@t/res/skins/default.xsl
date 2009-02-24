<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="nl2br.xsl"/>
<xsl:param name="trip"/>

<xsl:template match="/">
	<xsl:apply-templates select="rss"/>
</xsl:template>

<xsl:template match="channel">
	<xsl:apply-templates select="item"/>
</xsl:template>

<xsl:template match="item">
	<xsl:choose>
		<xsl:when test="@trip=$trip">
			<font color="blue">
			<xsl:value-of select="@hn"/>◆<xsl:value-of select="@trip"/>
			</font>
			　<xsl:value-of select="@date"/>：<br/>
			<xsl:call-template name="nl2br">
				<xsl:with-param name="str" select="title"/>
			</xsl:call-template>
			<hr/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="@hn"/><xsl:if test="@trip!=''">◆<xsl:value-of select="@trip"/></xsl:if>
			　<xsl:value-of select="@date"/>：<br/>
			<xsl:call-template name="nl2br">
				<xsl:with-param name="str" select="title"/>
			</xsl:call-template>
			<hr/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
