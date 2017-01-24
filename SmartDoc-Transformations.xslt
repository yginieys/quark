<?xml version="1.0" encoding="UTF-8"?>
<!--
 ============================================================
  SmartDoc to QXPS - Structure Transformer
 ============================================================
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xpath-default-namespace="http://quark.com/smartcontent/3.0">

	<xsl:param name="TRACKED_CHANGES" select="'ACCEPT'"/>
	 
	<xsl:variable name="UnresolvedURICode" select="'ERROR_IN_RESOLVING_URI'"/>
	<xsl:variable name="NoAccessCode" select="'DATA_NOT_ACCESSIBLE'"/>
	
	<!-- this below template ignore the text content of unhandled elements so that the output xml validation passes with Modifier.xsd -->
	<xsl:template match="text()" mode="section"> </xsl:template>
	<xsl:template match="meta" mode="section">
		<!-- Ignore all meta tags -->
	</xsl:template>
	<xsl:template match="meta">
		<!-- Ignore all meta tags -->
	</xsl:template>
	
	<xsl:template match="section" mode="section">
		<xsl:param name="sub-sectiondepth" select="0"/>
		<xsl:param name="anchorid"/>
		<xsl:param name="conref-indent-level" select="0"></xsl:param>	
		
		<xsl:apply-templates select="meta" mode="indexStart"/>
		
		<xsl:apply-templates mode="section">
			<xsl:with-param name="sub-sectiondepth" select="$sub-sectiondepth"/>
			<xsl:with-param name="anchorid" select="$anchorid"/>
			<xsl:with-param name="conref-indent-level" select="$conref-indent-level"/>
		</xsl:apply-templates>
			
		<xsl:apply-templates select="meta" mode="indexEnd"/>
	</xsl:template>
	
	<xsl:template match="section/title" mode="section">
		<xsl:param name="nostyle" select="false()"/>
		<xsl:param name="merge" select="false()"/>
		<xsl:param name="flowcontent" select="true()"/>
		<xsl:param name="anchorid"/>
		
		<xsl:param name="sub-sectiondepth" select="0"/>
		<xsl:variable name="sectiondepth">
			<xsl:value-of select="count(ancestor::section) + $sub-sectiondepth"/>
		</xsl:variable>
		<xsl:element name="PARAGRAPH">
			<xsl:if test="$merge = true()">
				<xsl:attribute name="MERGE" select="'true'"/>
			</xsl:if>
			<xsl:if test="$nostyle = false()">
				<xsl:if test="$sectiondepth = 1">
					<xsl:attribute name="PARASTYLE">
						<xsl:value-of select="$para.style.Document.Title"/>
					</xsl:attribute>
					<xsl:apply-templates mode="section"/>
				</xsl:if>
				<xsl:if test="$sectiondepth = 2">
					<xsl:attribute name="PARASTYLE">
						<xsl:value-of select="$para.style.Topic.Title1"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:if test="$sectiondepth = 3">
					<xsl:attribute name="PARASTYLE">
						<xsl:value-of select="$para.style.Topic.Title2"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:if test="$sectiondepth = 4">
					<xsl:attribute name="PARASTYLE">
						<xsl:value-of select="$para.style.Topic.Title3"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:if test="$sectiondepth > 4">
					<xsl:attribute name="PARASTYLE">
						<xsl:value-of select="$para.style.Topic.Title4"/>
					</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$flowcontent = true()">
				<xsl:call-template name="anchor-for-dita-xref">
					<xsl:with-param name="elmid" select="../@id"/>
				</xsl:call-template>
				<xsl:call-template name="anchor-for-dita-xref">
					<xsl:with-param name="elmid" select="$anchorid"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="$nostyle = false() and $sectiondepth = 1">
					<!-- do nothing template already applied as after creating callout anchor above -->
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates mode="section"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template match="p" mode="section">
		<xsl:param name="parastyle">
			<xsl:call-template name="para.style.Body.Paragraph"></xsl:call-template>
		</xsl:param>
		<xsl:param name="anchorid"/>
		<xsl:if test="ancestor::bodydiv[@type='figure']">
			<xsl:call-template name="anchor-with-para-figure">
				<xsl:with-param name="elmid" select="$anchorid"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="@type='table-title' and ancestor::bodydiv[@type='formaltable']">
			<xsl:call-template name="anchor-with-para-figure">
				<xsl:with-param name="elmid" select="$anchorid"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:apply-templates select="meta" mode="indexStart"/>
		<xsl:element name="PARAGRAPH">
			<xsl:attribute name="PARASTYLE">
				<xsl:value-of select="$parastyle"/>
			</xsl:attribute>
			<xsl:call-template name="AddParaLeftIndent"></xsl:call-template>
			<xsl:if test="ancestor::bodydiv[@type='figure']">
				<xsl:element name="FORMAT">
					<xsl:attribute name="KEEPWITHNEXT" select="'true'"/>
				</xsl:element>
			</xsl:if>
			<xsl:apply-templates mode="section"/>
		</xsl:element>
		<xsl:apply-templates select="meta" mode="indexEnd"/>
	</xsl:template>
	<xsl:template match="p[@type='lq']" mode="section">
		<xsl:apply-templates select="meta" mode="indexStart"/>
		<xsl:element name="PARAGRAPH">
			<xsl:attribute name="PARASTYLE">
				<xsl:call-template name="para.style.Long.Quote"/>
			</xsl:attribute>
			<xsl:call-template name="AddParaLeftIndent"></xsl:call-template>
			<xsl:apply-templates mode="section"/>
		</xsl:element>
		<xsl:apply-templates select="meta" mode="indexEnd"/>
	</xsl:template>
	<xsl:template match="p[@type='heading']" mode="section">
		<xsl:apply-templates select="meta" mode="indexStart"/>
		<xsl:element name="PARAGRAPH">
			<xsl:attribute name="PARASTYLE">
				<xsl:call-template name="para.style.Body.Heading"/>
			</xsl:attribute>
			<xsl:call-template name="AddParaLeftIndent"></xsl:call-template>
			<xsl:apply-templates mode="section"/>
		</xsl:element>
		<xsl:apply-templates select="meta" mode="indexEnd"/>
	</xsl:template>

	<xsl:template match="p[@type='region-title']" mode="section">
		<xsl:apply-templates select="meta" mode="indexStart"/>
		<xsl:element name="PARAGRAPH">
			<xsl:attribute name="PARASTYLE">
				<xsl:call-template name="para.style.Region.Title"></xsl:call-template>
			</xsl:attribute>
			<xsl:apply-templates mode="section"/>
		</xsl:element>
		<xsl:apply-templates select="meta" mode="indexEnd"/>
	</xsl:template>
	<xsl:template match="region//p[not(@type)] | region//p[not(@type='region-title' or @type='heading' or @type='lq' or @type='note' or @type='title' or @type='desc') ] " mode="section">
		<xsl:param name="anchorid"/>
		<xsl:if test="ancestor::bodydiv[@type='figure']">
			<xsl:call-template name="anchor-with-para-figure">
				<xsl:with-param name="elmid" select="$anchorid" />
			</xsl:call-template>
		</xsl:if>
		<xsl:apply-templates select="meta" mode="indexStart"/>
		<xsl:element name="PARAGRAPH">
			<xsl:attribute name="PARASTYLE">
				<xsl:call-template name="para.style.Body.Paragraph"></xsl:call-template>
			</xsl:attribute>
			<xsl:call-template name="AddParaLeftIndent"></xsl:call-template>
			<xsl:apply-templates mode="section"/>
		</xsl:element>
		<xsl:apply-templates select="meta" mode="indexEnd"/>
	</xsl:template>
	
	<xsl:template match="p[@type='note']" mode="section">
		<PARAGRAPH>
			<xsl:attribute name="PARASTYLE">
				<xsl:value-of select="$para.style.InlineBox"/>
			</xsl:attribute>
			<xsl:call-template name="AddParaLeftIndent"></xsl:call-template>
			<INLINEBOX WIDTH="90">
				<BOXATTRIBUTE COLOR="Black" OPACITY="10%"/>
				<TEXTATTRIBUTE>
					<!-- BOTTOM INSET is not working properly due to the defect #172402 in QuarkXPress Server renderer,
								which may result in few additional pt's of space -->
					<INSET MULTIPLEINSETS="true" BOTTOM="2 pt" LEFT="6 pt" RIGHT="6 pt" TOP="6 pt"/>
				</TEXTATTRIBUTE>
				<xsl:apply-templates select="meta" mode="indexStart"/>
				<PARAGRAPH>
					<xsl:attribute name="PARASTYLE">
						<xsl:call-template name="para.style.Body.Note"/>
					</xsl:attribute>
					<xsl:apply-templates mode="section"/>
				</PARAGRAPH>
				<xsl:apply-templates select="meta" mode="indexEnd"/>
			</INLINEBOX>
		</PARAGRAPH>
	</xsl:template>
	<xsl:template match="bodydiv[@type='figure']/p[@type='title']" mode="section">
		<xsl:apply-templates select="meta" mode="indexStart"/>
		<xsl:element name="PARAGRAPH">
			<xsl:attribute name="PARASTYLE">
				<xsl:call-template name="para.style.Picture.Title"/>
			</xsl:attribute>
			<xsl:call-template name="AddParaLeftIndent"></xsl:call-template>
			<xsl:apply-templates mode="section"/>
		</xsl:element>
		<xsl:apply-templates select="meta" mode="indexEnd"/>
	</xsl:template>
	<xsl:template match="bodydiv[@type='figure']/p[@type='desc']" mode="section">
		<xsl:apply-templates select="meta" mode="indexStart"/>
		<xsl:element name="PARAGRAPH">
			<xsl:attribute name="PARASTYLE">
				<xsl:call-template name="para.style.Picture.Description"/>
			</xsl:attribute>
			<xsl:call-template name="AddParaLeftIndent"></xsl:call-template>
			<xsl:apply-templates mode="section"/>
		</xsl:element>
		<xsl:apply-templates select="meta" mode="indexEnd"/>
	</xsl:template>
	<xsl:template match="region[@type=$region.type.callout]" mode="section">
		<xsl:param name="anchorid"/>
		<xsl:call-template name="anchor-with-para-region">
			<xsl:with-param name="elmid" select="$anchorid"/>
		</xsl:call-template>
		<xsl:choose>
		<xsl:when test="ancestor::region[@type=$region.type.callout]">
			<!-- If it is a nested callout, forcefully make it inline box as nesetd callout is a negative case 
			which does not render properly -->
			<xsl:element name="PARAGRAPH">
				<xsl:element name="INLINEBOX">
					<!--xsl:attribute name="WIDTH"  select="'33%'" /-->
					<FRAME COLOR="Black" GAPCOLOR="none" OPACITY="16%" SHADE="100%" STYLE="Solid" WIDTH="1"/>
					<TEXTATTRIBUTE>
						<INSET ALLEDGES="5" MULTIPLEINSETS="false"/>
					</TEXTATTRIBUTE>
					<xsl:apply-templates select="meta" mode="indexStart"/>
					<xsl:apply-templates mode="section"/>
					<xsl:apply-templates select="meta" mode="indexStart"/>
				</xsl:element>
			</xsl:element>
		</xsl:when>
		<xsl:otherwise>
			<!--  If not a nested callout -->
			<xsl:element name="PARAGRAPH">
				<xsl:attribute name="PARASTYLE">
					<xsl:value-of select="$para.style.Callout.Anchor.Holder"/>
				</xsl:attribute>
				<xsl:variable name="calloutwidth" >
					<xsl:choose>
						<xsl:when test="$fixedCalloutWidth">
					 		<xsl:text>23%</xsl:text>
						</xsl:when>
						<xsl:when test="./descendant::image[not(@type)] or ./descendant::image[@type!='matheq'] or ./descendant::table">
							<!-- If callout contains image or table in the content -->
							 <xsl:text>60%</xsl:text>
						 </xsl:when>
						 <!-- Bug #263712 A callout containing an equation is not rendered according to the size of the equation -->
						 <xsl:when test="./descendant::image[@type='matheq' and @cx &lt; 135] and string-length(.)&lt;800">
							<xsl:text>23%</xsl:text>
						 </xsl:when>
						 <xsl:when test="./descendant::image[@type='matheq' and @cx &lt; 135] and string-length(.)&lt;1000">
							<xsl:text>40%</xsl:text>
						 </xsl:when>
						 <xsl:when test="./descendant::image[@type='matheq' and @cx &gt; 134]">
						 	<xsl:text>40%</xsl:text>
						 </xsl:when>
						 <xsl:when test="string-length(.)&lt;800">
						 	<!-- If callout text length is less than 800 chars-->
							<xsl:text>23%</xsl:text>
						 </xsl:when>
						 <xsl:when test="string-length(.)&lt;1000">
						 	<!-- If callout text length is between 800 to 1000 chars-->
							<xsl:text>40%</xsl:text>
						 </xsl:when>
						 <xsl:otherwise>
							<xsl:text>50%</xsl:text>
						 </xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:element name="CALLOUTANCHOR">
					<xsl:attribute name="CALLOUTSTYLE">
						<xsl:value-of select="$callout.style.region"/>
					</xsl:attribute>
					<xsl:attribute name="VERTICALPADDING" select="'2 mm'"/>
					<xsl:element name="INLINEBOX">
						<xsl:attribute name="WIDTH"  select="$calloutwidth" />
							<BOXATTRIBUTE COLOR="bg3" OPACITY="100%" SHADE="100%"/>
							<RUNAROUND BOTTOM="2" LEFT="2" RIGHT="8" TOP="2" TYPE="ITEM"/>
							<TEXTATTRIBUTE>
								<INSET ALLEDGES="5" MULTIPLEINSETS="false"/>
							</TEXTATTRIBUTE>
							<xsl:apply-templates select="meta" mode="indexStart"/>	
							<xsl:apply-templates mode="section"/>
							<xsl:apply-templates select="meta" mode="indexEnd"/>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:otherwise>
	</xsl:choose>
	</xsl:template>
	<xsl:template match="region[@type=$region.type.box]" mode="section">
		<xsl:param name="anchorid"/>
		<xsl:call-template name="anchor-with-para-region">
			<xsl:with-param name="elmid" select="$anchorid"/>
		</xsl:call-template>
		<xsl:element name="PARAGRAPH">
			<xsl:attribute name="PARASTYLE">
				<xsl:value-of select="$para.style.InlineBox"/>
			</xsl:attribute>
			<xsl:call-template name="AddParaLeftIndent"></xsl:call-template>
			<xsl:element name="INLINEBOX">
				<BOXATTRIBUTE BLENDSTYLE="SOLID" COLOR="Black" OPACITY="8%" SHADE="100%"/>
				<FRAME COLOR="Black" GAPCOLOR="none" OPACITY="16%" SHADE="100%" STYLE="Solid" WIDTH="1"/>
				<TEXTATTRIBUTE>
					<INSET ALLEDGES="5" MULTIPLEINSETS="false"/>
				</TEXTATTRIBUTE>
				<xsl:apply-templates select="meta" mode="indexStart"/>	
				<xsl:apply-templates mode="section"/>
				<xsl:apply-templates select="meta" mode="indexEnd"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template match="region" mode="section">
		<xsl:param name="anchorid"/>
		<xsl:call-template name="anchor-with-para-region">
			<xsl:with-param name="elmid" select="$anchorid"/>
		</xsl:call-template>
		<xsl:element name="PARAGRAPH">
			<xsl:attribute name="PARASTYLE">
				<xsl:value-of select="$para.style.InlineBox"/>
			</xsl:attribute>
			<xsl:call-template name="AddParaLeftIndent"></xsl:call-template>
			<xsl:element name="INLINEBOX">
			<BOXATTRIBUTE BLENDSTYLE="SOLID" COLOR="Black" OPACITY="2%" SHADE="100%"/>
				<FRAME COLOR="Black" GAPCOLOR="none" OPACITY="16%" SHADE="100%" STYLE="Solid" WIDTH="1"/>
				<TEXTATTRIBUTE>
					<INSET ALLEDGES="5" MULTIPLEINSETS="false"/>
				</TEXTATTRIBUTE>
				
				<xsl:apply-templates select="meta" mode="indexStart"/>				
				<xsl:apply-templates mode="section"/>
				<xsl:apply-templates select="meta" mode="indexEnd"/> 
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<!--************* HANDLE TABLES ****************-->
	<xsl:template match="table" mode="section">
	 	<xsl:param name="anchorid"/>
	 	<xsl:call-template name="anchor-with-para">
	 		<xsl:with-param name="elmid" select="$anchorid"/>
		</xsl:call-template> 
		<xsl:apply-templates select="meta" mode="indexStart"/>		
		<xsl:apply-templates select="child::title" mode="section"/>
		<xsl:call-template name="insertInlineTable">
			<xsl:with-param name="tablecolspec" select="./tgroup"/>
		</xsl:call-template>
		<xsl:apply-templates select="child::desc" mode="section"/>
		<xsl:apply-templates select="meta" mode="indexEnd"/> 
	</xsl:template>
	<xsl:template match="table/title" mode="section">
		<PARAGRAPH>
			<xsl:attribute name="PARASTYLE">
				<xsl:call-template name="para.style.Table.Title"/>
			</xsl:attribute>
			<xsl:call-template name="AddParaLeftIndent"></xsl:call-template>
			<xsl:apply-templates mode="section"/>
		</PARAGRAPH>
	</xsl:template>
	<xsl:template match="table/desc" mode="section">
		<PARAGRAPH>
			<xsl:attribute name="PARASTYLE">
				<xsl:call-template name="para.style.Table.Description"/>
			</xsl:attribute>
			<xsl:call-template name="AddParaLeftIndent"></xsl:call-template>
			<xsl:apply-templates mode="section"/>
		</PARAGRAPH>
	</xsl:template>
	<xsl:template name="insertInlineTable">
		<xsl:param name="tablecolspec"/>
		<xsl:element name="PARAGRAPH">
			<xsl:attribute name="PARASTYLE" select="$para.style.InlineTable"/>
			<xsl:call-template name="AddParaLeftIndent"></xsl:call-template>
			<xsl:element name="INLINETABLE">
				<xsl:attribute name="WIDTH" select="'100%'"/>
				<xsl:attribute name="TABLESTYLEREF" select="'inline' "/>
				<!--
					The below template is commented so that AUTOFIT can be applied on columns of the table. 
					When the user does not want to use AutoFit feature of QuarkXPress Server, following call-template can be uncommented.  
				-->
				<!--
				<xsl:call-template name="create_colspec_colgroup">
					<xsl:with-param name="table_colspec" select="$tablecolspec"/>
				</xsl:call-template>
				-->
				<xsl:for-each select="$tablecolspec/thead">
					<xsl:element name="THEAD">
						<xsl:call-template name="process_calstable_rows">
							<xsl:with-param name="row" select="row"/>
							<xsl:with-param name="tablecolspec" select="$tablecolspec"/>
						</xsl:call-template>
					</xsl:element>
				</xsl:for-each>
				<xsl:for-each select="$tablecolspec/tbody">
					<xsl:element name="TBODY">
						<xsl:call-template name="process_calstable_rows">
							<xsl:with-param name="row" select="row"/>
							<xsl:with-param name="tablecolspec" select="$tablecolspec"/>
						</xsl:call-template>
					</xsl:element>
				</xsl:for-each>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template name="create_colspec_colgroup">
		<xsl:param name="table_colspec"/>
		<xsl:element name="COLGROUP">
			<xsl:variable name="tblwidth">
				<xsl:for-each select="$table_colspec/colspec">
					<xsl:element name="colwidth">
						<xsl:value-of select="translate(@colwidth,'*%', '  ')"/>
					</xsl:element>
				</xsl:for-each>
			</xsl:variable>
			<xsl:for-each select="$table_colspec/colspec">
				<xsl:variable name="curcolwidth">
					<xsl:value-of select="translate(@colwidth,'*%', '  ')"/>
				</xsl:variable>
				<xsl:variable name="colwidth">
					<xsl:if test="@colwidth and string-length(@colwidth)>0">
						<xsl:choose>
							<xsl:when test="$curcolwidth and contains($curcolwidth, 'px')">
								<xsl:variable name="curColWidthInDouble">
									<xsl:value-of select="translate($curcolwidth,'px', '')"/>
								</xsl:variable>
								<xsl:value-of select="concat($curColWidthInDouble div 96, 'in')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of
								select="concat($curcolwidth div sum($tblwidth/colwidth) * 100, '%')"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:variable>
				<xsl:element name="TCOL">
					<xsl:attribute name="COLINDEX" select="position()"/>
					<xsl:if test="$colwidth and string-length($colwidth)>0">
						<xsl:attribute name="WIDTH" select="$colwidth"/>
					</xsl:if>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:template name="process_calstable_rows">
		<xsl:param name="row"/>
		<xsl:param name="tablecolspec"/>
		<xsl:for-each select="$row">
			<xsl:element name="TROW">
				<xsl:for-each select="entry">
					<xsl:element name="ENTRY">
						<xsl:if test="@background">
							<xsl:attribute name="COLOR" select="@background"/>
							<xsl:attribute name="SHADE" select="100"/>
						</xsl:if>
						<xsl:call-template name="align-content"/>
						<xsl:if test="@morerows">
							<xsl:attribute name="ROWSPAN" select="@morerows + 1"/>
						</xsl:if>
						<xsl:if test="@namest">
							<xsl:variable name="colspanvalue">
								<xsl:value-of
									select="$tablecolspec/colspec[@colname=current()/@nameend]/@colnum - $tablecolspec/colspec[@colname=current()/@namest]/@colnum + 1"
								/>
							</xsl:variable>
							<xsl:attribute name="COLSPAN" select="$colspanvalue"/>
						</xsl:if>
						<xsl:apply-templates select="meta" mode="indexStart"/>
						<xsl:apply-templates mode="section"/>
						<xsl:apply-templates select="meta" mode="indexEnd"/>
					</xsl:element>
				</xsl:for-each>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="align-content">
		<xsl:if test="@align">
			<xsl:choose>
				<xsl:when test="@align = 'center'">
					<xsl:choose>
						<xsl:when test="self::entry">
							<xsl:attribute name="ALIGNMENT" select="'CENTER'"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="ALIGNMENT" select="'CENTERED'"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="@align = 'left'">
					<xsl:attribute name="ALIGNMENT" select="'LEFT'"/>
				</xsl:when>
				<xsl:when test="@align = 'right'">
					<xsl:attribute name="ALIGNMENT" select="'RIGHT'"/>
				</xsl:when>
				<xsl:when test="@align = 'justify'">
					<xsl:attribute name="ALIGNMENT" select="'JUSTIFIED'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="not(@align) and (parent::image or parent::embedimage)">
							<xsl:attribute name="ALIGNMENT">CENTERED</xsl:attribute>
						</xsl:when>
						<!--<xsl:otherwise>
							<xsl:attribute name="ALIGNMENT" select="'LEFT'"/>
						</xsl:otherwise>-->
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<xsl:if test="@valign">
			<xsl:choose>
				<xsl:when test="@valign = 'middle'">
					<xsl:choose>
						<xsl:when test="self::entry">
							<xsl:attribute name="VALIGN" select="'CENTER'"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="VALIGN" select="'CENTERED'"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="@valign = 'bottom'">
					<xsl:attribute name="VALIGN" select="'BOTTOM'"/>
				</xsl:when>
				<xsl:when test="@valign = 'top'">
					<xsl:attribute name="VALIGN" select="'TOP'"/>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<!--************* TABLE HANDLING END ****************-->
	<!--************* Resolve references and apply templates over their contents. ************* -->
	<xsl:template match="*[@conref and not(name()='video' or name()='audio')]" mode="section" priority="10">
		<xsl:variable name="sectiondepth">
			<xsl:value-of select="count(ancestor::section)"/>
		</xsl:variable>
		
		<xsl:variable name="conref-indent-level">
			<xsl:call-template name="getParaIndentLevel" />
		</xsl:variable>
			
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
		<xsl:choose>
			<xsl:when test="contains(referedFileNameWithID, '#')">
				<xsl:variable name="fileName">
					<xsl:value-of select="concat('file:', $dependenciesFolder, substring-before($referedFileNameWithID,'#'))"/>
				</xsl:variable>
				<xsl:variable name="refrencedId">
					<xsl:call-template name="getElementId">
						<xsl:with-param name="text" select="@conref"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:apply-templates select="document($fileName)//*[@id=$refrencedId]" mode="subSection">
					<!-- Pass on current section's depth -->
					<xsl:with-param name="sectiondepth" select="$sectiondepth"/>
					<xsl:with-param name="anchorid" select="@id"/>
					<xsl:with-param name="conref-indent-level" select="$conref-indent-level"/>					
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="fileName">
					<xsl:value-of select="concat('file:', $dependenciesFolder, $referedFileNameWithID)"/>
				</xsl:variable>
				<xsl:apply-templates select="document($fileName)" mode="subSection">
					<!-- Pass on current section's depth -->
					<xsl:with-param name="sectiondepth" select="$sectiondepth"/>
					<xsl:with-param name="anchorid" select="@id"/>
					<xsl:with-param name="conref-indent-level" select="$conref-indent-level"/>	
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="*" mode="subSection">
		<xsl:param name="sectiondepth"/>
		<xsl:param name="anchorid"/>
		<xsl:param name="conref-indent-level" select="0"></xsl:param>	
		<xsl:apply-templates mode="section" select=".">
			<!-- Pass on current section's depth -->
			<xsl:with-param name="sub-sectiondepth" select="$sectiondepth"/>
			<xsl:with-param name="anchorid" select="$anchorid"/>
			<xsl:with-param name="conref-indent-level" select="$conref-indent-level"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template name="getElementId">
		<xsl:param name="text"/>
		<xsl:variable name="idPart">
			<xsl:call-template name="after-last-char">
				<xsl:with-param name="text">
					<xsl:value-of select="$text"/>
				</xsl:with-param>
				<xsl:with-param name="chartext">
					<xsl:text>#</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:call-template name="after-last-char">
			<xsl:with-param name="text">
				<xsl:value-of select="$idPart"/>
			</xsl:with-param>
			<xsl:with-param name="chartext">
				<xsl:text>/</xsl:text>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="after-last-char">
		<xsl:param name="text"/>
		<xsl:param name="chartext"/>
		<xsl:choose>
			<xsl:when test="not(contains($text, $chartext))">
				<xsl:value-of select="$text"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="after-last-char">
					<xsl:with-param name="text" select="substring-after($text, $chartext)"/>
					<xsl:with-param name="chartext" select="$chartext"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!--************* IGNORE DELETED TEXT ************* -->
  <xsl:template match="node()[count(preceding-sibling::deleteStart)!=count(preceding-sibling::deleteEnd)][upper-case($TRACKED_CHANGES)!='REJECT']" priority="30" mode="section">
	  <!-- Ignore deleted text -->
  </xsl:template>
  
  <!--************* IGNORE INSERTED TEXT ************* -->
  <xsl:template match="node()[count(preceding-sibling::insertStart)!=count(preceding-sibling::insertEnd)][upper-case($TRACKED_CHANGES)='REJECT']" priority="30" mode="section">
    <!-- Ignore INSERTED text -->
  </xsl:template>
	
  <!--************* LISTS ************* -->
	<xsl:template match="ul | ol " mode="section">
		<xsl:param name="conref-indent-level" select="0"></xsl:param>
		<xsl:apply-templates select="meta" mode="indexStart"/>
		<xsl:apply-templates>
			<xsl:with-param name="conref-indent-level" select="$conref-indent-level"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="meta" mode="indexEnd"/>
	</xsl:template>

	<xsl:template match="li | sli">
		<xsl:param name="conref-indent-level" select="0"></xsl:param>
		<xsl:apply-templates select="child::p[1]/meta" mode="indexStart"/>
		<xsl:element name="PARAGRAPH">
			<xsl:variable name="indent-level">
				<xsl:call-template name="getParaIndentLevel">
					<xsl:with-param name="conref-indent-level" select="$conref-indent-level"></xsl:with-param>
				</xsl:call-template>
			</xsl:variable>
			<xsl:if test="$indent-level > 0">
				<xsl:attribute name="INDENTLEVEL" select="$indent-level" />
			</xsl:if>
			<xsl:choose>
				<xsl:when test="parent::ol">
					<xsl:attribute name="PARASTYLE">
						<xsl:call-template name="para.style.Numbered_List"/>
					</xsl:attribute>			
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="PARASTYLE">
						<xsl:call-template name="para.style.Bullet_List"/>
					</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="count(preceding-sibling::li) = 0 and parent::ol">
				<xsl:element name="FORMAT">
						<xsl:element name="BNSTYLE">
								<xsl:attribute name="RESTARTNUMBERING" select="'true'"/>
								<xsl:attribute name="STARTAT" select="'1'"/>
						</xsl:element>
				</xsl:element>
			</xsl:if>
			<!-- First para in list item need to be there in this enclosed para-->
			<xsl:apply-templates select="child::p[1]/*" mode="section"/>
		</xsl:element>
		<xsl:apply-templates select="child::p[1]/meta" mode="indexEnd"/>
		<!-- Remaining block elements (non first) in the list item should be handled separately as per the content -->
		<xsl:apply-templates select="./*[position() > 1]" mode="section"/>
	</xsl:template>

	<xsl:template match="tag" mode="section">
		<xsl:apply-templates select="meta" mode="indexStart"/>
		<xsl:apply-templates mode="section"/>
		<xsl:apply-templates select="meta" mode="indexEnd"/>
	</xsl:template>

	<xsl:template match="bodydiv" mode="section">
		<xsl:apply-templates select="meta" mode="indexStart"/>
		<xsl:apply-templates mode="section"/>
		<xsl:apply-templates select="meta" mode="indexEnd"/>
	</xsl:template>
	
	<!--************* HANDLE text of known inline content nodes ****************-->
	<xsl:template match="title/text() | t/text() | b/text() | i/text() | u/text() | sub/text() | sup/text() | tag/text() | title/text() | strike/text() | table/desc/text() | color/text() | xref/text()" mode="section">
		<xsl:if test="not(parent::xref or parent::title)">
			<xsl:if test="../@id">
				<xsl:call-template name="anchor-for-dita-xref">
					<xsl:with-param name="elmid" select="../@id"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
		<xsl:element name="RICHTEXT">
			<xsl:if test="./ancestor-or-self::xref and not(./ancestor-or-self::refnote)" >
				<xsl:attribute name="UNDERLINE">true</xsl:attribute>
				<xsl:attribute name="COLOR">
					<xsl:call-template name="hyperlink.color"></xsl:call-template>
				</xsl:attribute>
				<xsl:if test="ancestor-or-self::xref/@targettype">					
					<xsl:if test="ancestor-or-self::xref/@targettype = 'table' or ancestor-or-self::xref/@targettype = 'section' or ancestor-or-self::xref/@targettype = 'figure' or ancestor-or-self::xref/@targettype = 'region'">
						<xsl:attribute name="HLTYPE" select="'ANCHOR'"/>
						<xsl:variable name="refId">
							<xsl:call-template name="getElementId">
								<xsl:with-param name="text" select="../@href"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:attribute name="HYPERLINKREF" select="concat('#', $refId)"/>
					</xsl:if>
					
					<xsl:if test="ancestor-or-self::xref/@targettype = 'external'">
						<xsl:attribute name="HYPERLINKREF"><xsl:value-of select="ancestor-or-self::xref/@href"/></xsl:attribute>
						<xsl:attribute name="HLTYPE">WWWURL</xsl:attribute>
					</xsl:if>
				</xsl:if>
			</xsl:if>
			<xsl:call-template name="addRichTextAttributes"/>
			<!-- Replace nbsp characters to space characters as in QXPS nbsp charactres 
			are used to prevent the line breaks whereas in HTML(actual source of content) 
			it is used for collapsing of multiple consecutive whitespace characters -->
			<xsl:value-of select="translate(., '&#160;', ' ')"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template name="addRichTextAttributes">
	<xsl:attribute name="MERGE">false</xsl:attribute>
			<xsl:if test="./ancestor-or-self::b">
				<xsl:attribute name="BOLD">true</xsl:attribute>
			</xsl:if>
			<xsl:if test="./ancestor-or-self::i">
				<xsl:attribute name="ITALIC">true</xsl:attribute>
			</xsl:if>
			<xsl:if test="./ancestor-or-self::u">
				<xsl:attribute name="UNDERLINE">true</xsl:attribute>
			</xsl:if>
			<xsl:if test="./ancestor-or-self::sup">
				<xsl:attribute name="SUPERSCRIPT">true</xsl:attribute>
			</xsl:if>
			<xsl:if test="./ancestor-or-self::sub">
				<xsl:attribute name="SUBSCRIPT">true</xsl:attribute>
			</xsl:if>
			<xsl:if test="./ancestor-or-self::strike">
				<xsl:attribute name="STRIKETHRU" select="'true'"/>
			</xsl:if>
			<xsl:if test="./ancestor-or-self::color">
				<xsl:attribute name="COLOR" select="./ancestor-or-self::color/@textforecolor"/>
			</xsl:if>
			<xsl:if test="./ancestor-or-self::tag and not(./ancestor-or-self::refnote)">
				<xsl:if test="ancestor::tag/@type='quote'">
					<xsl:call-template name="char.attributes.q"/>
				</xsl:if>
				<xsl:if test="ancestor::tag/@type='cite'">
					<xsl:call-template name="char.attributes.cite"/>
				</xsl:if>
				<xsl:if test="ancestor::tag/@type='term'">
					<xsl:call-template name="char.attributes.term"/>
				</xsl:if>
				<xsl:if test="ancestor::tag/@type='tm'">
					<xsl:call-template name="char.attributes.tm"/>
				</xsl:if>
				<xsl:if test="ancestor::tag/@type='keyword'">
					<xsl:call-template name="char.attributes.keyword"/>
				</xsl:if>
				<xsl:if test="ancestor::tag/@type='person'">
					<xsl:call-template name="char.attributes.person"/>
				</xsl:if>
				<xsl:if test="ancestor::tag/@type='org'">
					<xsl:call-template name="char.attributes.organisation"/>
				</xsl:if>
				<xsl:if test="ancestor::tag/@type='country'">
					<xsl:call-template name="char.attributes.country"/>
				</xsl:if>
			</xsl:if> 
	</xsl:template>
	
	<xsl:template match="image" mode="section">
		<xsl:if test="@type='matheq'">
			<!-- If it is math equation image, add baseline shift to -3. Otherwise the image is shown a bit above the baseline of the content.
				Adding extra RICHTEXT node with zero-width space to achieve this as there is no direct way to specify BASELINESHIFT in inline box.
				Also inline box cannot be wrapped in the RICHTEXT.
				By defining the RICHETXT before inlinebox, the equation image inherits the rictext properties automatically. 
			-->
		 	<xsl:element name="RICHTEXT">
				<xsl:attribute name="BASELINESHIFT">-3</xsl:attribute>
				<xsl:attribute name="MERGE">true</xsl:attribute>
				<xsl:text>&amp;zeroWidthSpace;</xsl:text>
			</xsl:element>
		</xsl:if>
		<xsl:call-template name="Inlinebox_and_Image"/>
	</xsl:template>
	<xsl:template name="Inlinebox_and_Image">
		<xsl:element name="INLINEBOX">
			<xsl:attribute name="SCALEUP" select="'true'"/>
			<xsl:if test="exists(@cx) and not(contains(@cx,'%')) and string-length(@cx)>0">
				<xsl:attribute name="WIDTH" select="concat(@cx div 96, 'in')"/>
			</xsl:if>
			<xsl:variable name="filename">
				<xsl:call-template name="after-last-char">
					<xsl:with-param name="text">
						<xsl:value-of select="replace(@href,'\\','/')"/>
					</xsl:with-param>
					<xsl:with-param name="chartext">
						<xsl:text>/</xsl:text>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:variable>
			<xsl:if test="@type='matheq'">
				<!-- If it is math equation image, add color of box as none so that it renders appropriately with any color of the parent box.-->
				<xsl:element name="BOXATTRIBUTE">
					<xsl:attribute name="COLOR">NONE</xsl:attribute>			
				</xsl:element>
			</xsl:if>
			<xsl:element name="CONTENT">
				<xsl:value-of select="concat('file:',$filename)"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	<!-- Handle video title -->
	<xsl:template match="bodydiv[@type='video']/p[@type='title']" mode="section" priority="10">
		<!-- Currently using same styles as that of figure title -->
		<xsl:apply-templates select="meta" mode="indexStart"/>
		<xsl:element name="PARAGRAPH">
			<xsl:attribute name="PARASTYLE">
				<xsl:call-template name="para.style.Picture.Title"/>
			</xsl:attribute>
			<xsl:call-template name="AddParaLeftIndent"></xsl:call-template>
			<xsl:apply-templates mode="section"/>
		</xsl:element>
		<xsl:apply-templates select="meta" mode="indexEnd"/>
	</xsl:template>
	
	<!-- Handle video description -->
	<xsl:template match="bodydiv[@type='video']/p[@type='desc']" mode="section" priority="10">
		<xsl:apply-templates select="meta" mode="indexStart"/>
		<!-- Currently using same styles as that of figure description -->
		<xsl:element name="PARAGRAPH">
			<xsl:attribute name="PARASTYLE">
				<xsl:call-template name="para.style.Picture.Description"/>
			</xsl:attribute>
			<xsl:call-template name="AddParaLeftIndent"></xsl:call-template>
			<xsl:apply-templates mode="section"/>
		</xsl:element>
		<xsl:apply-templates select="meta" mode="indexEnd"/>
	</xsl:template>
	
	<xsl:template match="object[@type='video']" mode="section">
		<INLINEBOX>
			<xsl:variable name="previewfilename">
				<xsl:choose>
					<xsl:when test="altImage/@href">
						<xsl:call-template name="after-last-char">
							<xsl:with-param name="text">
									<xsl:value-of select="replace(altImage/@href,'\\','/')" />
							</xsl:with-param>
							<xsl:with-param name="chartext">
								<xsl:text>/</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Default_Video_Preview.jpg</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<CONTENT BOUNDINGBOX="MEDIABOX"><xsl:value-of select="concat('file:',$previewfilename)"/></CONTENT>	
				<INTERACTIVITY AUTHORXTID="1131430225" OWNERXTID="1129333841" TYPE="Video">
					<Settings InitiallyHidden="False">
						<videosettings>
							<autoplay>false</autoplay>
							<fullscreenonly>false</fullscreenonly>
							<loop>false</loop>
							<hidecontroller>false</hidecontroller>
							<sourcesettings>
								<xsl:variable name="hrefValue">
							 		<xsl:value-of select="@href"></xsl:value-of>
								</xsl:variable>
								<xsl:variable name="filename">
									<xsl:choose>
										<xsl:when test="starts-with($hrefValue, 'http:')">
										<xsl:value-of select="$hrefValue"></xsl:value-of>
										</xsl:when>
										<xsl:otherwise>
											<xsl:variable name="filenamewithoutprefix">
												<xsl:call-template name="after-last-char">
													<xsl:with-param name="text">
													<xsl:value-of select="replace($hrefValue,'\\','/')" />
													</xsl:with-param>
													<xsl:with-param name="chartext">
														<xsl:text>/</xsl:text>
													</xsl:with-param>
												</xsl:call-template>
											</xsl:variable>
										
											<xsl:value-of select="concat('file:',$filenamewithoutprefix)"/>
										
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
							
								<xsl:choose>
									<xsl:when test="starts-with($hrefValue, 'http:')">
										<sourcetype>2</sourcetype>
									</xsl:when>
									<xsl:otherwise>
										<sourcetype>1</sourcetype>
									</xsl:otherwise>
								</xsl:choose>
							
								<sourcepath>
									<xsl:value-of select="$filename"/>
								</sourcepath>
								<sourceid>
									<xsl:value-of select="$filename"/>
								</sourceid>
							</sourcesettings>
							<usevideoframe>false</usevideoframe>
							<useofflineimage>false</useofflineimage>
						</videosettings>
					</Settings>
					<DATAPROVIDER DATAPROVIDERXTID="1347965009"/>
				</INTERACTIVITY>
		</INLINEBOX>
	</xsl:template>
	
	<xsl:template match="*[@conref][contains(@conref, $UnresolvedURICode)]" mode="section" priority="20">
		<xsl:call-template name="errorresolvinguri"/>			
	</xsl:template>
	<xsl:template match="*[@conref][contains(@conref, $NoAccessCode)]" mode="section" priority="10">
		<xsl:call-template name="noaccess"/>			
	</xsl:template>
	
	<xsl:template match="image[contains(@href, $UnresolvedURICode)]" mode="section" priority="20">
		<xsl:call-template name="errorresolvinguri"/>
	</xsl:template>
	<xsl:template match="image[contains(@href, $NoAccessCode)]" mode="section" priority="10">
		<xsl:call-template name="noaccess"/>
	</xsl:template>
	
	<!-- Currently showing no access or error if any of the alt image or video is inaccessible or missing   -->
	<xsl:template match="object [@type='video']	[@href[contains(., $NoAccessCode)] or altImage/@href[contains(., $NoAccessCode)] ]"  mode="section">
		<xsl:call-template name="noaccess">			
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="object [@type='video'] [@href[contains(., $UnresolvedURICode)] or altImage/@href[contains(., $UnresolvedURICode)]  ] " mode="section">
		<xsl:call-template name="errorresolvinguri">			
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template name="noaccess">
		<INLINEBOX>
			<BOXATTRIBUTE COLOR="red"/>
			<TEXTATTRIBUTE>
				<INSET ALLEDGES="5"/>
			</TEXTATTRIBUTE>
			<PARAGRAPH>
				<FORMAT ALIGNMENT="CENTERED" HANDJ="No Hyphenation"/>
				<!-- <RICHTEXT FONT="Wingdings" COLOR="white" SIZE="56"></RICHTEXT> -->
				<RICHTEXT COLOR="white" SIZE="16">!! Referred content is not accessible !!</RICHTEXT>
			</PARAGRAPH>
		</INLINEBOX>
	</xsl:template>
	
	<xsl:template name="errorresolvinguri">
		<INLINEBOX>
			<BOXATTRIBUTE COLOR="red"/>
			<TEXTATTRIBUTE>
				<INSET ALLEDGES="5"/>
			</TEXTATTRIBUTE>
			<PARAGRAPH>
				<FORMAT ALIGNMENT="CENTERED" HANDJ="No Hyphenation"/>
				<!-- <RICHTEXT FONT="Wingdings" COLOR="white" SIZE="56"></RICHTEXT> -->
				<RICHTEXT COLOR="white" SIZE="16">!! Error resolving referred content !!</RICHTEXT>
			</PARAGRAPH>	
		</INLINEBOX>
	</xsl:template>
	
	<xsl:template match="refnote" mode="section">
		<xsl:variable name="refNoteStyle">
			<xsl:choose>
				<xsl:when test="@type='endnote'">
					<xsl:value-of select="$note.style.endnote"/>					
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$note.style.footnote"/>
				</xsl:otherwise>				
			</xsl:choose>			
		</xsl:variable>
		
		<xsl:variable name="noteParaStyle">
			<xsl:choose>
				<xsl:when test="@type='endnote'">
					<xsl:value-of select="$para.style.endnote"/>					
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$para.style.footnote"/>
				</xsl:otherwise>				
			</xsl:choose>			
		</xsl:variable>
		
		<xsl:element name="REFNOTE">
			<xsl:attribute name="STYLE">
				<xsl:value-of select="$refNoteStyle"/>
			</xsl:attribute>
			<xsl:element name="REFNOTEBODY">
				<xsl:apply-templates select="p" mode="section">
					<xsl:with-param name="parastyle" select="$noteParaStyle"/>					
				</xsl:apply-templates>				
			</xsl:element>
		</xsl:element>			
	</xsl:template>
	
	<!-- 
	Adds INDENT level to the paragarh based on the nesting of the list. 
	Also adds additional 4mm left indent to the paragarpph as the parstyle "Set1_List Item" being used for list items has 4mm left indent so the paras under list items should also be 4mm more left indented.
	For example:
		List with 4mm additional indent looks like:
			1. AA
			2. AA
			   BB
			3. CC
		List without additoinal indent looks like:
			1. AA
			2. AA
			  BB
			3. CC
	-->
	<xsl:template name="AddParaLeftIndent">
		<xsl:if test="not(parent::refnote)">
			<xsl:variable name="indent-level">
				<xsl:call-template name="getParaIndentLevel" />
			</xsl:variable>
			<xsl:if test="$indent-level > 0">
				<xsl:attribute name="INDENTLEVEL" select="$indent-level" />
				<FORMAT LEFTINDENT="4 mm" />
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="getParaIndentLevel">
		<xsl:param name="conref-indent-level" select="0"></xsl:param>
		<xsl:choose>
			<xsl:when test="count(ancestor::region) > 0">
				<xsl:variable name="no-of-lists-above-region">
					<xsl:value-of select="ancestor::region[1]/count(ancestor::ul) + ancestor::region[1]/count(ancestor::ol) + ancestor::region[1]/count(ancestor::sl)" />
				</xsl:variable>
				<!-- "Total no of ancestor lists" minus "no of lists above region" will equal to "no of ancestor lists below region for the current list"-->
				<xsl:value-of select="number($conref-indent-level) + count(ancestor::ul) + count(ancestor::ol) + count(ancestor::sl) - $no-of-lists-above-region"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="number($conref-indent-level) + count(ancestor::ul) + count(ancestor::ol) + count(ancestor::sl)" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Handles meta tag for indexes. Starts index range -->
	<xsl:template match="meta[./collection/@name='smartcontent.index.entries']" mode="indexStart" priority="10">
		<xsl:if test="$populateIndexTerms">
	    	<xsl:variable name="collectionNode" select="collection[@name='smartcontent.index.entries']"/>
	    	
	    	<xsl:for-each select="$collectionNode/member">   		
	    		<xsl:element name="INDEXTERM"> 
	    			<xsl:attribute name="RANGE" select="'START'"/>
	    			<xsl:attribute name="ID"><xsl:value-of select="ancestor::*[@id][1]/@id"/><xsl:number/></xsl:attribute>
			      	<xsl:attribute name="REFERENCESTYLE" select="$index.page.reference"/>
			      	
			      	<xsl:if test=".//attribute[@name='smartcontent.index.groupingTerm'] and (.//attribute[@name='smartcontent.index.groupingTerm']/value = 'true')">
						<xsl:attribute name="SUPPRESSPAGE" select="'true'"/>
					</xsl:if>
			      	
			      	<xsl:choose>
			      		<xsl:when test=".//attribute[@name='smartcontent.index.parent'] and (.//attribute[@name='smartcontent.index.parent']/value != '')">		    		
				      		<xsl:variable name="parents" select=".//attribute[@name='smartcontent.index.parent']/value" />
				      		<xsl:variable name="depthOfIndex"><xsl:value-of select="count($parents)" /></xsl:variable>
					      	
					      	<xsl:element name="MAINTERM"><xsl:value-of select="$parents[1]"/></xsl:element>
				      		
				      		<xsl:choose>		      			
						      	<xsl:when test="$depthOfIndex = 1">					      		
						      		<xsl:element name="SUBTERM1">
						      			<xsl:if test=".//attribute[@name='smartcontent.index.sortas']">
							      			<xsl:attribute name="SORTAS" select=".//attribute[@name='smartcontent.index.sortas']/value"/>
							      		</xsl:if>
						      			<xsl:value-of select=".//attribute[@name='smartcontent.index.text']/value"/>
						      		</xsl:element>					   
						      	</xsl:when>
						      	<xsl:when test="$depthOfIndex = 2">
						      		<xsl:element name="SUBTERM1"><xsl:value-of select="$parents[2]"/></xsl:element>
						      		<xsl:element name="SUBTERM2">
						      			<xsl:if test=".//attribute[@name='smartcontent.index.sortas']">
							      			<xsl:attribute name="SORTAS" select=".//attribute[@name='smartcontent.index.sortas']/value"/>
							      		</xsl:if>
						      			<xsl:value-of select=".//attribute[@name='smartcontent.index.text']/value"/>
						      		</xsl:element>					      		
						      	</xsl:when>
						      	<xsl:otherwise>
						      		<xsl:element name="SUBTERM1"><xsl:value-of select="$parents[2]"/></xsl:element>
						      		<xsl:element name="SUBTERM2"><xsl:value-of select="$parents[3]"/></xsl:element>
						      		<xsl:element name="SUBTERM3">
						      			<xsl:if test=".//attribute[@name='smartcontent.index.sortas']">
							      			<xsl:attribute name="SORTAS" select=".//attribute[@name='smartcontent.index.sortas']/value"/>
							      		</xsl:if>
						      			<xsl:value-of select=".//attribute[@name='smartcontent.index.text']/value"/>
						      		</xsl:element>					
						      	</xsl:otherwise>
				      		</xsl:choose>
				      	</xsl:when>
				      	<xsl:otherwise>
				      		<xsl:element name="MAINTERM">
				      			<xsl:if test=".//attribute[@name='smartcontent.index.sortas']">
					      			<xsl:attribute name="SORTAS" select=".//attribute[@name='smartcontent.index.sortas']/value"/>
					      		</xsl:if>
				      			<xsl:value-of select=".//attribute[@name='smartcontent.index.text']/value"/>
				      		</xsl:element>
						</xsl:otherwise>
			      	</xsl:choose>
			      	
			      	<xsl:if test=".//attribute[@name='smartcontent.index.refterms']">
			      		<xsl:element name="CROSSREFERENCETOINDEX">
			      			<!-- Replaced hyphen in attribute value with space because hyphen is not working in QuarkXPress Server. 
			      				It can be removed once it starts working in QuarkXPress Server -->
			      			<xsl:attribute name="PREFIX" select="replace(.//attribute[@name='smartcontent.index.reftype']/value, '-', ' ')"/>
			      			<xsl:choose>
			      				<xsl:when test=".//attribute[@name='smartcontent.index.reftype']/value = 'see-also'">
			      					<xsl:value-of select="string-join(.//attribute[@name='smartcontent.index.refterms']/value, ', ')" />
			      				</xsl:when>
			      				<xsl:otherwise>
			      					<xsl:value-of select=".//attribute[@name='smartcontent.index.refterms']/value" />
			      				</xsl:otherwise>
			      			</xsl:choose>
			      		</xsl:element>
			      	</xsl:if>
			      	
	    		</xsl:element>
	    	</xsl:for-each>
    	</xsl:if>
	</xsl:template>

	<!-- Handles meta tag for indexes. Ends index range -->
	<xsl:template match="meta[./collection/@name='smartcontent.index.entries']" mode="indexEnd" priority="10">
		<xsl:if test="$populateIndexTerms">
			<xsl:variable name="collectionNode" select="collection[@name='smartcontent.index.entries']"/>
	    	<xsl:for-each select="$collectionNode/member">
	    		<xsl:sort select="position()" data-type="number" order="descending"/>
				<xsl:element name="INDEXTERM">
					<xsl:attribute name="RANGE" select="'END'"/>
		      		<xsl:attribute name="ID"><xsl:value-of select="ancestor::*[@id][1]/@id"/><xsl:number/></xsl:attribute>               
		      	</xsl:element>
	    	</xsl:for-each>
	    </xsl:if>
	</xsl:template>
	
	<xsl:template match="meta" mode="indexStart indexEnd">
		<!-- Ignore all meta tags in indexStart and indexEnd mode. Otherwise XSL default template copies all text of meta tags -->
	</xsl:template>
	
	
 </xsl:stylesheet>