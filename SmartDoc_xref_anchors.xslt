<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xpath-default-namespace="http://quark.com/smartcontent/3.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:variable name="process-dita-xrefs" select="true()"/>
	<xsl:variable name="INDEX_TERMS_EXIST_FLAG" select="'indexterms-exist'"/>
	
	<xsl:variable name="cdoc" select="/"/>
	<xsl:variable name="dita-xrefs-ids-and-indexterms-exist">
		<xsl:if test="$process-dita-xrefs = true()">
			<xsl:call-template name="xrefs-dita-ids-tostring">
				<xsl:with-param name="cdoc" select="$cdoc"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:variable>
		
	<xsl:variable name="dita-xrefs-ids">
		<xsl:value-of select="replace($dita-xrefs-ids-and-indexterms-exist, $INDEX_TERMS_EXIST_FLAG, '')"/>
	</xsl:variable>
	<xsl:variable name="INDEX_TERMS_EXIST">
		<xsl:choose>
			<xsl:when test="contains($dita-xrefs-ids-and-indexterms-exist, $INDEX_TERMS_EXIST_FLAG)">
				<xsl:value-of select="'true'"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="'false'"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!-- xrefs list using dita -->
	<xsl:template name="xrefs-dita-ids-tostring">
		<xsl:param name="cdoc"/>
		<xsl:param name="index-found" select="'false'"/>
		<xsl:apply-templates select="$cdoc//xref[@targettype='table' or @targettype='figure' or @targettype='section' or @targettype='region']" mode="xrefs"/>
		
		<xsl:variable name="index-found-including-current-ref">
			<xsl:choose>
				<xsl:when test="$index-found = 'true'">
					<xsl:value-of select="'true'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="$cdoc//meta[./collection/@name='smartcontent.index.entries']">
							<xsl:value-of select="'true'"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="'false'"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:if test="($index-found = 'false') and ($index-found-including-current-ref = 'true')">
			<xsl:value-of select="$INDEX_TERMS_EXIST_FLAG"/>
		</xsl:if>

		<xsl:for-each select="$cdoc//*[@conref and not(name()='video' or name()='audio' or name()='object')]">
			<!-- referedFileNameWithID contains only file name (with or without #id part) without complete file path  -->
			<xsl:variable name="referedFileNameWithID">
				<xsl:call-template name="after-last-char">
					<xsl:with-param name="text">
						<xsl:value-of select="replace(@conref,'\\','/')"/>
					</xsl:with-param>
					<xsl:with-param name="chartext">
						<xsl:text>/</xsl:text>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="cdocname">
				<xsl:choose>
					<xsl:when test="contains($referedFileNameWithID,'#')">
						<xsl:value-of select="concat('file:/', $dependenciesFolder, substring-before($referedFileNameWithID,'#'))"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat('file:/', $dependenciesFolder, $referedFileNameWithID)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<xsl:if test="$cdoc/section/@id != document($cdocname)/section/@id">
				<xsl:call-template name="xrefs-dita-ids-tostring">
					<xsl:with-param name="cdoc" select="document($cdocname)"/>
					<xsl:with-param name="index-found" select="$index-found-including-current-ref"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="*" mode="xrefs">
		<xsl:variable name="refId">
			<xsl:call-template name="getElementId">
				<xsl:with-param name="text" select="@href"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="concat($refId, '&#xA;')"/>
	</xsl:template>
	<xsl:template name="anchor-for-dita-xref">
		<xsl:param name="elmid"/>
		<xsl:if test="$process-dita-xrefs = true()">
			<xsl:if test="string-length($elmid)>0 and contains($dita-xrefs-ids, $elmid)">
				<xsl:element name="RICHTEXT">
					<xsl:attribute name="HLANCHORREF"><xsl:value-of select="$elmid"/></xsl:attribute>
				</xsl:element>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template name="anchor-with-para">
		<xsl:param name="elmid"/>
		<xsl:variable name="resolvedId">
		<xsl:choose>
			<xsl:when test="$elmid">
				<xsl:value-of select="$elmid"></xsl:value-of>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="@id"></xsl:value-of>
			</xsl:otherwise>
		</xsl:choose>
		</xsl:variable>
		<xsl:if test="$process-dita-xrefs = true()">
			<xsl:if test="string-length($resolvedId)>0 and  contains($dita-xrefs-ids, $resolvedId)">
			<PARAGRAPH>
			<xsl:attribute name="PARASTYLE"><xsl:value-of select="$para.style.HyperlinkAnchor"></xsl:value-of> </xsl:attribute>
				<xsl:element name="RICHTEXT">
					<xsl:attribute name="HLANCHORREF"><xsl:value-of select="$resolvedId"/></xsl:attribute>
				</xsl:element>
			</PARAGRAPH>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template name="anchor-with-para-figure">
		<xsl:param name="elmid" />
		<xsl:variable name="resolvedId">
			<xsl:choose>
				<xsl:when test="$elmid">
					<xsl:value-of select="$elmid"></xsl:value-of>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="../@id"></xsl:value-of>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="$process-dita-xrefs = true()">
			<xsl:if test="string-length($resolvedId)>0 and contains($dita-xrefs-ids, $resolvedId)">
			<PARAGRAPH>
			<xsl:attribute name="PARASTYLE"><xsl:value-of select="$para.style.HyperlinkAnchor"></xsl:value-of> </xsl:attribute>
				<xsl:element name="RICHTEXT">
					<xsl:attribute name="HLANCHORREF"><xsl:value-of select="$resolvedId"/></xsl:attribute>
				</xsl:element>
			</PARAGRAPH>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template name="anchor-with-para-region">
		<xsl:param name="elmid" />
		<xsl:variable name="resolvedId">
			<xsl:choose>
				<xsl:when test="$elmid">
					<xsl:value-of select="$elmid"></xsl:value-of>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@id"></xsl:value-of>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="$process-dita-xrefs = true()">
			<xsl:if test="string-length($resolvedId)>0 and contains($dita-xrefs-ids, $resolvedId)">
				<PARAGRAPH>
					<xsl:attribute name="PARASTYLE"><xsl:value-of select="$para.style.HyperlinkAnchor"></xsl:value-of> </xsl:attribute>
					<xsl:element name="RICHTEXT">
						<xsl:attribute name="HLANCHORREF"><xsl:value-of select="$resolvedId" /></xsl:attribute>
					</xsl:element>
				</PARAGRAPH>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	</xsl:stylesheet>
