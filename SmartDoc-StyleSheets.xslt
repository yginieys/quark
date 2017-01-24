<!--
 ============================================================
  BusDoc to QXPS - StylesheetsMapping
 ============================================================
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xpath-default-namespace="http://quark.com/smartcontent/3.0">
	<xsl:strip-space elements="*"/>
	
	<xsl:variable name="region.type.callout">callout</xsl:variable>
	<xsl:variable name="region.type.box">box</xsl:variable>
	
	
	<!-- Paragraph StyleSheets Mapping (Char styles are referenced in XPress Project template Para styles)-->
	<!-- Set 1 Styles -->
	<xsl:variable name="para.style.Document.Title">Document Title</xsl:variable>
	<xsl:variable name="para.style.Topic.Title1">section_heading</xsl:variable>
	<xsl:variable name="para.style.Topic.Title2">section_heading</xsl:variable>
	<xsl:variable name="para.style.Topic.Title3">section_heading</xsl:variable>
	<xsl:variable name="para.style.Topic.Title4">section_heading</xsl:variable>
	<xsl:variable name="para.style.Body.Paragraph">body_text</xsl:variable>
	<xsl:variable name="para.style.Body.Paragraph_inverse">Inverse_Body Paragraph</xsl:variable>
	<xsl:variable name="para.style.Body.Heading">Body Heading</xsl:variable>
	<xsl:variable name="para.style.Body.Heading_inverse">Inverse_Body Heading</xsl:variable>
	<xsl:variable name="para.style.Bullet_list">Bullet_List Item</xsl:variable>
	<xsl:variable name="para.style.Bullet_list_inverse">Inverse_Bullet_List Item</xsl:variable>
	<xsl:variable name="para.style.Numbered_list">Numbered_List Item</xsl:variable>
	<xsl:variable name="para.style.Numbered_list_inverse">Inverse_Numbered_List Item</xsl:variable>
	<xsl:variable name="para.style.Body.Note">Body Note</xsl:variable>
	<xsl:variable name="para.style.Body.Note_inverse">Inverse_Body Note</xsl:variable>
	<xsl:variable name="para.style.Long.Quote">Body Long Quote</xsl:variable>
	<xsl:variable name="para.style.Long.Quote_inverse">Inverse_Body Long Quote</xsl:variable>
	<xsl:variable name="para.style.Table.Title">Table Title</xsl:variable>
	<xsl:variable name="para.style.Table.Title_inverse">Inverse_Table Title</xsl:variable>
	<xsl:variable name="para.style.Table.Description">Table Description</xsl:variable>
	<xsl:variable name="para.style.Table.Description_inverse">Inverse_Table Description</xsl:variable>
	<xsl:variable name="para.style.Table.Body">body_text</xsl:variable>
	<xsl:variable name="para.style.Table.Header">Table Header Title</xsl:variable>
	<xsl:variable name="para.style.Picture.Description">Picture Description</xsl:variable>
	<xsl:variable name="para.style.Picture.Description_inverse">Inverse_Picture Description</xsl:variable>
	<xsl:variable name="para.style.Picture.Title">Picture Title</xsl:variable>
	<xsl:variable name="para.style.Picture.Title_inverse">Inverse_Picture Title</xsl:variable>
	<xsl:variable name="para.style.InlineBox">InlineBox</xsl:variable>
	<xsl:variable name="para.style.InlineTable">InlineTable</xsl:variable>
	<xsl:variable name="para.style.Callout.Anchor.Holder">Callout Anchor Holder</xsl:variable>
	<xsl:variable name="para.style.HyperlinkAnchor">HyperlinkAnchor</xsl:variable>
	
	<xsl:variable name="note.style.footnote">footnote</xsl:variable>
	<xsl:variable name="note.style.endnote">endnote</xsl:variable>

	<xsl:variable name="para.style.footnote">Footnote</xsl:variable>
	<xsl:variable name="para.style.endnote">Endnote</xsl:variable>

	<xsl:variable name="para.style.Region.Title">Region Title</xsl:variable>
	<xsl:variable name="para.style.Region.Title_inverse">Inverse_Region Title</xsl:variable>
	
	<xsl:variable name="callout.style.title">DocumentTitle</xsl:variable>
	<xsl:variable name="callout.style.region">Region</xsl:variable>
	
	<xsl:variable name="index.term.level.one">Index Term Level 1</xsl:variable>
	<xsl:variable name="index.term.level.two">Index Term Level 2</xsl:variable>
	<xsl:variable name="index.term.level.three">Index Term Level 3</xsl:variable>
	<xsl:variable name="index.term.level.four">Index Term Level 4</xsl:variable>
	<xsl:variable name="index.letter.head">Index Letter Head</xsl:variable>
	<xsl:variable name="index.page.reference">Index Page Reference</xsl:variable>
	<xsl:variable name="index.cross.reference">Index Cross Reference</xsl:variable>

	<xsl:template name="para.style.Bullet_List">
		<xsl:variable name="firstAncestor">
			<xsl:call-template name="firstImmediateAncestorAmongTableAndRegion"/>
		</xsl:variable>	
		<xsl:choose>
			<xsl:when test="$firstAncestor='table'"> <!-- This is because the table background color is white even if it is inside some region  -->
				<xsl:value-of select="$para.style.Bullet_list"/>
			</xsl:when>
			<xsl:when test= "ancestor::region[1][@type=$region.type.box]">
				<xsl:value-of select="$para.style.Bullet_list"/>
			</xsl:when>
			<xsl:when test="ancestor::region[1][@type=$region.type.callout]">
				<xsl:value-of select="$para.style.Bullet_list_inverse"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$para.style.Bullet_list"/>
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:template>
	
	<xsl:template name="para.style.Numbered_List">
		<xsl:variable name="firstAncestor">
			<xsl:call-template name="firstImmediateAncestorAmongTableAndRegion"/>
		</xsl:variable>	
		<xsl:choose>
			<xsl:when test="$firstAncestor='table'"> <!-- This is because the table background color is white even if it is inside some region  -->
				<xsl:value-of select="$para.style.Numbered_list"/>
			</xsl:when>
			<xsl:when test= "ancestor::region[1][@type=$region.type.box]">
				<xsl:value-of select="$para.style.Numbered_list"/>
			</xsl:when>
			<xsl:when test="ancestor::region[1][@type=$region.type.callout]">
				<xsl:value-of select="$para.style.Numbered_list_inverse"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$para.style.Numbered_list"/>
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:template>
			
	<xsl:template name="para.style.Region.Title">
		<xsl:choose>
			<xsl:when test= "ancestor::region[1][@type=$region.type.box]">
				<xsl:value-of select="$para.style.Region.Title"/>
			</xsl:when>
			<xsl:when test= "ancestor::region[1][@type=$region.type.callout]">
				<xsl:value-of select="$para.style.Region.Title_inverse"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$para.style.Region.Title"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
				
	<xsl:template name="para.style.Table.Description">
		<xsl:choose>
			<xsl:when test= "ancestor::region[1][@type=$region.type.callout]">
				<xsl:value-of select="$para.style.Table.Description_inverse"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$para.style.Table.Description"/>
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:template>

	<xsl:template name="para.style.Table.Title">
		<xsl:choose>
			<xsl:when test= "ancestor::region[1][@type=$region.type.callout]">
				<xsl:value-of select="$para.style.Table.Title_inverse"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$para.style.Table.Title"/>
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:template>


	<xsl:template name="para.style.Picture.Description">
		<xsl:variable name="firstAncestor">
			<xsl:call-template name="firstImmediateAncestorAmongTableAndRegion"/>
		</xsl:variable>	
		<xsl:choose>
			<xsl:when test="$firstAncestor='table'">
				<xsl:value-of select="$para.style.Picture.Description"/><!-- This is because the table background color is white even if it is inside some region  -->
			</xsl:when>
			<xsl:when test= "ancestor::region[1][@type=$region.type.callout]">
				<xsl:value-of select="$para.style.Picture.Description_inverse"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$para.style.Picture.Description"/>
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:template>

	<xsl:template name="para.style.Picture.Title">
		<xsl:variable name="firstAncestor">
			<xsl:call-template name="firstImmediateAncestorAmongTableAndRegion"/>
		</xsl:variable>	
		<xsl:choose>
			<xsl:when test="$firstAncestor='table'">
				<xsl:value-of select="$para.style.Picture.Title"/><!-- This is because the table background color is white even if it is inside some region  -->
			</xsl:when>
			<xsl:when test= "ancestor::region[1][@type=$region.type.callout]">
				<xsl:value-of select="$para.style.Picture.Title_inverse"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$para.style.Picture.Title"/>
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:template>

	<xsl:template name="para.style.Body.Paragraph">
		<xsl:variable name="firstAncestor">
			<xsl:call-template name="firstImmediateAncestorAmongTableAndRegion"/>
		</xsl:variable>	
		<xsl:choose>
			<xsl:when test="$firstAncestor='table'">
				<xsl:value-of select="$para.style.Body.Paragraph"/>
			</xsl:when>
			<xsl:when test= "ancestor::region[1][@type=$region.type.callout]">
				<xsl:value-of select="$para.style.Body.Paragraph_inverse"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$para.style.Body.Paragraph"/>
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:template>
	
	<xsl:template name="para.style.Body.Note">
		<xsl:variable name="firstAncestor">
			<xsl:call-template name="firstImmediateAncestorAmongTableAndRegion"/>
		</xsl:variable>	
		<xsl:choose>
			<xsl:when test="$firstAncestor='table'">
				<xsl:value-of select="$para.style.Body.Note"/><!-- This is because the table background color is white even if it is inside some region  -->
			</xsl:when>
			<xsl:when test= "ancestor::region[1][@type=$region.type.callout]">
				<xsl:value-of select="$para.style.Body.Note_inverse"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$para.style.Body.Note"/>
			</xsl:otherwise>			
		</xsl:choose>	
	</xsl:template>
	<xsl:template name="para.style.Body.Heading">
		<xsl:variable name="firstAncestor">
			<xsl:call-template name="firstImmediateAncestorAmongTableAndRegion"/>
		</xsl:variable>	
		<xsl:choose>
			<xsl:when test="$firstAncestor='table'">
				<xsl:value-of select="$para.style.Body.Heading"/><!-- This is because the table background color is white even if it is inside some region  -->
			</xsl:when>
			<xsl:when test="ancestor::region[1][@type=$region.type.callout]">
				<xsl:value-of select="$para.style.Body.Heading_inverse"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$para.style.Body.Heading"/>
			</xsl:otherwise>			
		</xsl:choose>	
	</xsl:template>	
	<xsl:template name="para.style.Long.Quote">
		<xsl:variable name="firstAncestor">
			<xsl:call-template name="firstImmediateAncestorAmongTableAndRegion"/>
		</xsl:variable>	
		<xsl:choose>
			<xsl:when test="$firstAncestor='table'">
				<xsl:value-of select="$para.style.Long.Quote"/><!-- This is because the table background color is white even if it is inside some region  -->
			</xsl:when>
			<xsl:when test= "ancestor::region[1][@type=$region.type.callout]">
				<xsl:value-of select="$para.style.Long.Quote_inverse"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$para.style.Long.Quote"/>
			</xsl:otherwise>			
		</xsl:choose>	
	</xsl:template>	
	
	<xsl:template name="hyperlink.color">
		<xsl:text>blue</xsl:text>		
	</xsl:template>
	
	<!-- Default Emphasis attributes applied on text irrespective to the variable 'UseProjectTemplateStyleSheets' value. -->
	<xsl:template name="char.attributes.cite">
		<xsl:attribute name="ITALIC">true</xsl:attribute>
	</xsl:template>
	<xsl:template name="char.attributes.keyword">
		<xsl:attribute name="COLOR">Turquoise</xsl:attribute>	
		<xsl:attribute name="BOLD">true</xsl:attribute>
		<xsl:attribute name="UNDERLINE">true</xsl:attribute>
	</xsl:template>
	<xsl:template name="char.attributes.q">
		<xsl:attribute name="COLOR">Goldenrod</xsl:attribute>
		<xsl:attribute name="ITALIC">true</xsl:attribute>
	</xsl:template>
	<xsl:template name="char.attributes.term">
		<xsl:attribute name="COLOR">red</xsl:attribute>
		<xsl:attribute name="BOLD">true</xsl:attribute>
		<xsl:attribute name="UNDERLINE">true</xsl:attribute>
	</xsl:template>
	<xsl:template name="char.attributes.tm">
		<xsl:attribute name="UNDERLINE">true</xsl:attribute>
	</xsl:template>
	<xsl:template name="char.attributes.person">
		<xsl:attribute name="COLOR">Tomato</xsl:attribute>		
	</xsl:template>
	<xsl:template name="char.attributes.country">
		<xsl:attribute name="ITALIC">true</xsl:attribute>
		<xsl:attribute name="COLOR">Orange</xsl:attribute>		
	</xsl:template>
	<xsl:template name="char.attributes.organisation">
		<xsl:attribute name="COLOR">gray</xsl:attribute>
		<xsl:attribute name="ITALIC">true</xsl:attribute>
		<xsl:attribute name="BOLD">true</xsl:attribute>
	</xsl:template>
	
	<xsl:template name="firstImmediateAncestorAmongTableAndRegion">
		<xsl:variable name="firstNode">
			<xsl:value-of select="name(ancestor::*[name()='table' or local-name() ='region'][1])">
		</xsl:value-of>
		</xsl:variable> 
		<xsl:if test="exists($firstNode)">
			<xsl:choose>
				<xsl:when test="$firstNode ='table'">
					<xsl:text>table</xsl:text>
				</xsl:when>
				<xsl:when test="$firstNode ='region'">
					<xsl:text>region</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>none</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>		
	</xsl:template>
	
</xsl:stylesheet>
