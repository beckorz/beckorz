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
<table cellpadding="0" cellspacing="0" class="receiveframe">
	<tr><td width="100%">
		<table cellpadding="0" cellspacing="0" class="send">
			<tr><td>
				<td class="sendleft"><img src="res/skins/balloon/sendlefttop.png"/></td>
				<td class="sendtext"><div class="sendtexttop"></div><xsl:value-of select="@hn"/>◆<xsl:value-of select="@trip"/>　<xsl:value-of select="@date"/>：<br/><xsl:call-template name="nl2br"><xsl:with-param name="str" select="title"/></xsl:call-template><div class="sendtextbot"></div></td>
				<td class="sendright"><img src="res/skins/balloon/sendrighttop.png"/></td>
			</td></tr>
		</table>
	</td></tr>
</table>
<table cellpadding="0" cellspacing="0" class="spacer"><tr><td></td></tr></table>
		</xsl:when>
		<xsl:otherwise>
<table cellpadding="0" cellspacing="0" class="receiveframe">
	<tr><td width="100%" align="right">
		<table cellpadding="0" cellspacing="0" class="receive">
			<tr><td>
				<td class="receiveleft"><img src="res/skins/balloon/receivelefttop.png"/></td>
				<td class="receivetext"><div class="receivetexttop"></div><xsl:value-of select="@hn"/><xsl:if test="@trip!=''">◆<xsl:value-of select="@trip"/></xsl:if>　<xsl:value-of select="@date"/>：<br/><xsl:call-template name="nl2br"><xsl:with-param name="str" select="title"/></xsl:call-template><div class="receivetextbot"></div></td>
				<td class="receiveright"><img src="res/skins/balloon/receiverighttop.png"/></td>
			</td></tr>
		</table>
	</td><td>　</td><td width="10" style="vertical-align:bottom;"></td></tr>
	<!-- なんじゃこりゃ？ -->
</table>
<table cellpadding="0" cellspacing="0" class="spacer"><tr><td></td></tr></table>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
