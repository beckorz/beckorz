<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
	<xsl:apply-templates select="rss" />
</xsl:template>

<xsl:template match="channel">
<html lang="ja">

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Content-Style-Type" content="text/css" />
<meta http-equiv="Content-Script-Type" content="text/javascript" />
<title><xsl:value-of select="title" /></title>
<link rel="stylesheet" type="text/css" href="res/default.css" />
<link rel="shortcut icon" href="res/favicon.ico" />
<link rel="icon" href="res/anim_favicon.gif" type="image/gif" />
</head>

<body>
<table class="ranking" summary="ランキング">
	<caption>
		<a>
			<xsl:attribute name="href"><xsl:value-of select="link" /></xsl:attribute>
			<xsl:value-of select="description" />
		</a>
	</caption>
	<tr>
		<th class="header" rowspan="2">No</th>
		<th class="header">名前</th>
		<th class="header">点数</th>
		<th class="header">日時</th>
	</tr>
	<tr>
		<th class="header" colspan="3" style="text-align:left">コメント</th>
	</tr>
	<xsl:apply-templates select="item" />
</table>
</body>

</html>
</xsl:template>

<xsl:template match="item">
	<tr>
		<xsl:choose>
			<xsl:when test="(position() mod 2) = 1">
				<xsl:attribute name="class">odd</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="class">even</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
		<th rowspan="2" style="text-align:right">
			<xsl:value-of select="@rank" />
		</th>
		<td>
			<xsl:value-of select="@user" />
		</td>
		<td align="right">
			<xsl:value-of select="@point" />
		</td>
		<td align="center">
			<xsl:value-of select="pubDate" />
		</td>
	</tr>
	<tr>
		<xsl:choose>
			<xsl:when test="(position() mod 2) = 1">
				<xsl:attribute name="class">odd</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="class">even</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
		<td colspan="3">
			<xsl:value-of select="description" />　
		</td>
	</tr>
</xsl:template>

</xsl:stylesheet>
