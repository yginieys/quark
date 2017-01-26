<?xml version="1.0" encoding="UTF-8"?>
<!--
 ============================================================
  SmartDoc to QXPS - Default Template
 ============================================================
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xpath-default-namespace="http://quark.com/smartcontent/3.0" >

	<xsl:import href="./publishing/SPIE2/SmartDoc-StyleSheets.xslt"/>
	<xsl:import href="./publishing/SPIE2/SmartDoc-Transformations.xslt"/>
	<xsl:import href="./publishing/SmartDoc_xref_anchors.xslt"/>

	<xsl:param name="dependenciesFolder"/>
	<xsl:strip-space elements="*"/>
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

	<xsl:variable name="fixedCalloutWidth" select="false()"></xsl:variable>
	<xsl:variable name="populateIndexTerms" select="true()"></xsl:variable>
	
	<xsl:variable name="doctype" select="/section/@type"/>
	<xsl:param name="assetattributes">
		<xsl:element name="dummy"/> 
	</xsl:param>
	<xsl:template match="/">
		<PROJECT>
			<INDEXSPECIFICATIONS>
				<INDEXSTYLE NAME="IndexStyle">
					<SEPARATORS FOLLOWING-ENTRY="		" BEFORE-CROSS-REFERENCE=".	" CROSS-REFERENCE-STYLE="{$index.cross.reference}" BETWEEN-PAGE-RANGE="-" BETWEEN-PAGE-NUMBERS=", " LEVELFORMAT="NESTED"/>
					<LEVELSTYLE FIRSTLEVEL="{$index.term.level.one}" SECONDLEVEL="{$index.term.level.two}" THIRDLEVEL="{$index.term.level.three}" FOURTHLEVEL="{$index.term.level.four}" LETTERHEADSTYLE="{$index.letter.head}"/>
				</INDEXSTYLE>
			</INDEXSPECIFICATIONS>
			
			<TABLESTYLE>
				<ID NAME="inline"/>
			  <HEADTROWSTYLE INSET="2" COLOR="spie_gray">
				 
			  </HEADTROWSTYLE>
			  <TROWSTYLE INSET="2" VALIGN="CENTER">
				 <TOPGRID WIDTH="0.2" COLOR="Black"/>
				 <BOTTOMGRID WIDTH="0.2" COLOR="Black"/>
			  </TROWSTYLE>
			  <TCOLSTYLE>
				 <LEFTGRID WIDTH="0.2" COLOR="Black"/>
				 <RIGHTGRID WIDTH="0.2" COLOR="Black"/>
			  </TCOLSTYLE>
			  <FOOTERTROWSTYLE COLOR="Black">
				 <TOPGRID COLOR="73C167" WIDTH="0.5"/>
				 <BOTTOMGRID COLOR="none"/>
			  </FOOTERTROWSTYLE>
			</TABLESTYLE>

			<TABLESTYLE>
				<ID NAME="nogrid"/>
				<TROWSTYLE PARASTYLE="table_text" INSET="4" ALIGNMENT="CENTER">
					<TOPGRID WIDTH="0" COLOR="Black"/>
				 	<BOTTOMGRID WIDTH="0" COLOR="Black"/>
				</TROWSTYLE>
				<TCOLSTYLE>
					<LEFTGRID WIDTH="0" COLOR="Black"/>
				 	<RIGHTGRID WIDTH="0" COLOR="Black"/>
				</TCOLSTYLE>
			</TABLESTYLE>
				   
			<LAYOUT>
				<ID NAME="Layout 1"/>
				<MASTERPAGESEQUENCE NAME="CoverPage">
					<SINGLEMASTERPAGEREFERENCE NAME="A-Master A"/>
				</MASTERPAGESEQUENCE>
				<MASTERPAGESEQUENCE NAME="securite">
					<SINGLEMASTERPAGEREFERENCE NAME="A-Master A"/>
				</MASTERPAGESEQUENCE>
				<MASTERPAGESEQUENCE NAME="CONTENT">
					<REPEATABLEMASTERPAGEALTERNATIVES>
						<CONDITIONALMASTERPAGEREFERENCE NAME="A-Master A" POSITION="FIRST"/>
						<CONDITIONALMASTERPAGEREFERENCE NAME="A-Master A" POSITION="REST"/>
					</REPEATABLEMASTERPAGEALTERNATIVES>
				</MASTERPAGESEQUENCE>
				
				<xsl:element name="PAGESEQUENCE">
						<xsl:attribute name="MASTERREFERENCE" select="'CoverPage'"/>
						<xsl:element name="SECTIONNUMBERFORMAT">
							<xsl:attribute name="INITIALPAGENUMBER" select="1" />
							<xsl:attribute name="FORMAT" select="'ALPHA'" />
             	    </xsl:element>
					<xsl:element name="STATICCONTENT">
						<xsl:if test="exists($assetattributes/*[local-name() = 'assetInfo'])">
						<xsl:if test="contains(($assetattributes//*[@name = 'Status']), 'Draft')">
							<xsl:element name="BOX">
								<xsl:element name="ID">
									<xsl:attribute name="NAME" select="'watermark*'"/>
								</xsl:element>
								<xsl:element name="TEXT">
									<xsl:element name="STORY">
										<xsl:attribute name="FITTEXTTOBOX" select="'true'"/>
										<xsl:element name="PARAGRAPH">
											<xsl:attribute name="MERGE"><xsl:value-of select="'TRUE'"></xsl:value-of></xsl:attribute>
											<xsl:element name="RICHTEXT">
												<xsl:attribute name="BOLD" select="'true'"/>
												<xsl:value-of select="$assetattributes//*[@name = 'Status']"/>
											</xsl:element>
										</xsl:element>
									</xsl:element>
								</xsl:element>
							</xsl:element>
						</xsl:if>
						</xsl:if>
					<BOX>
							<ID NAME="header_title"/>
							<TEXT>
								<STORY>
									<PARAGRAPH PARASTYLE="Header Title">
										<RICHTEXT><xsl:value-of select="/section/title"/></RICHTEXT>
									</PARAGRAPH>
								</STORY>
							</TEXT>
						</BOX>
						<xsl:if test="exists($assetattributes/*[local-name() = 'assetInfo'])">
								<xsl:element name="BOX">
									<xsl:element name="ID">
										<xsl:attribute name="NAME" select="'metadata'"/>
									</xsl:element>
									<xsl:element name="TEXT">
										<xsl:element name="STORY">
											<xsl:element name="PARAGRAPH">
												<xsl:element name="RICHTEXT">
													<xsl:value-of select="concat('Status: ', $assetattributes//*[@name = 'Status'])"/>
												</xsl:element>
											</xsl:element>
											<xsl:element name="PARAGRAPH">
												<xsl:element name="RICHTEXT">
													<xsl:value-of select="concat('Last modified by: ', $assetattributes//*[@name = 'Last modifier'])"/>
												</xsl:element>
											</xsl:element>
											<xsl:element name="PARAGRAPH">
												<xsl:element name="RICHTEXT">
													<xsl:attribute name="BOLD" select="'TRUE'"/>
													<xsl:value-of select="concat('Version: ', $assetattributes//*[@name = 'Major version'], '.', $assetattributes//*[@name = 'Minor version'] )"/>
												</xsl:element>
											</xsl:element>
										</xsl:element>
									</xsl:element>
								</xsl:element>
						</xsl:if>
					</xsl:element>
					
					<xsl:element name="STORY">
						<PARAGRAPH>
							<INLINETABLE TABLESTYLEREF="inline" BREAKROWACROSSPAGES="TRUE">
							<COLGROUP>
								<TCOL COLINDEX="1" WIDTH="20%"/>
								<TCOL COLINDEX="2" WIDTH="80%"/>
							</COLGROUP>
							<TBODY>
								<TROW>
									<ENTRY COLOR="spie_section_blue" COLSPAN="2">
										<PARAGRAPH PARASTYLE="Table Header">
											<RICHTEXT>IDENTIFICATION EQUIPEMENT</RICHTEXT>
										</PARAGRAPH>
									</ENTRY>
								</TROW>
								<TROW>
									<ENTRY>
										<PARAGRAPH PARASTYLE="Header Title">
											<RICHTEXT><xsl:value-of select="/section/body/p[1]"/></RICHTEXT>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<PARAGRAPH PARASTYLE="Header Title">
											<RICHTEXT><xsl:value-of select="/section/body/p[2]"/></RICHTEXT>
										</PARAGRAPH>
									</ENTRY>
								</TROW>
							</TBODY>
							</INLINETABLE>
						</PARAGRAPH>
						<PARAGRAPH PARASTYLE="coverimage">
							<INLINETABLE>
								<COLGROUP>
									<TCOL COLINDEX="1" WIDTH="60%"/>
								</COLGROUP>
								<TBODY>
									<TROW>
										<ENTRY>
											<xsl:apply-templates select="/section/body/p[3]" mode="section"/>
										</ENTRY>
									</TROW>
								</TBODY>
							</INLINETABLE>
						</PARAGRAPH>
						<PARAGRAPH>
							<INLINETABLE TABLESTYLEREF="inline" BREAKROWACROSSPAGES="TRUE">
							<COLGROUP>
								<TCOL COLINDEX="1" WIDTH="10%"/>
								<TCOL COLINDEX="2" WIDTH="10%"/>
								<TCOL COLINDEX="3" WIDTH="10%"/>
								<TCOL COLINDEX="4" WIDTH="10%"/>
								<TCOL COLINDEX="5" WIDTH="10%"/>
								<TCOL COLINDEX="8" WIDTH="10%"/>
								<TCOL COLINDEX="7" WIDTH="10%"/>
								<TCOL COLINDEX="8" WIDTH="10%"/>
								<TCOL COLINDEX="9" WIDTH="10%"/>
								<TCOL COLINDEX="10" WIDTH="10%"/>
							</COLGROUP>
							<TBODY>
								<TROW>
									<ENTRY COLOR="spie_section_blue" COLSPAN="10">
										<PARAGRAPH PARASTYLE="Table Header">
											<RICHTEXT>TABLEAU DES EVOLUTIONS</RICHTEXT>
										</PARAGRAPH>
									</ENTRY>
								</TROW>
								<TROW>
									<ENTRY>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT BOLD="TRUE">Ind.</RICHTEXT>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT BOLD="TRUE">N°SNCF</RICHTEXT>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT BOLD="TRUE">Date</RICHTEXT>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT BOLD="TRUE">Page</RICHTEXT>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT BOLD="TRUE">Rédacteur</RICHTEXT>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT BOLD="TRUE">Détails</RICHTEXT>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT BOLD="TRUE">Val SPIE</RICHTEXT>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT BOLD="TRUE">Visa</RICHTEXT>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT BOLD="TRUE">Val SNCF</RICHTEXT>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT BOLD="TRUE">Visa</RICHTEXT>
										</PARAGRAPH>
									</ENTRY>
								</TROW>
								<TROW>
									<ENTRY>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT>V0</RICHTEXT>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT></RICHTEXT>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT>05/2011</RICHTEXT>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT></RICHTEXT>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT>C.MEFTAH</RICHTEXT>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT>Création</RICHTEXT>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT></RICHTEXT>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT></RICHTEXT>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT></RICHTEXT>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT></RICHTEXT>
										</PARAGRAPH>
									</ENTRY>
								</TROW>
								<TROW>
									<ENTRY>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT></RICHTEXT>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY COLSPAN="8">
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT>@TODO Renseigner automatiquement avec l'historique QPP du document.</RICHTEXT>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT></RICHTEXT>
										</PARAGRAPH>
									</ENTRY>
								</TROW>
							</TBODY>
							</INLINETABLE>
						</PARAGRAPH>
					</xsl:element>
				</xsl:element>
				
				<PAGESEQUENCE MASTERREFERENCE="securite">
                    <xsl:element name="SECTIONNUMBERFORMAT">
                        <xsl:attribute name="INITIALPAGENUMBER" select="1"/>
                        <xsl:attribute name="FORMAT" select="'NUMERIC'"/>
                    </xsl:element>
					<STATICCONTENT>
						<BOX>
							<ID NAME="header_title"/>
							<TEXT>
								<STORY>
									<PARAGRAPH PARASTYLE="Header Title">
										<RICHTEXT><xsl:value-of select="/section/title"/></RICHTEXT>
									</PARAGRAPH>
								</STORY>
							</TEXT>
						</BOX>
					</STATICCONTENT>
					<STORY>
						<PARAGRAPH PARASTYLE="section_heading">
							<RICHTEXT>Sécurité</RICHTEXT>
						</PARAGRAPH>
					<INLINETABLE TABLESTYLEREF="inline" BREAKROWACROSSPAGES="TRUE">
							<COLGROUP>
								<TCOL COLINDEX="1" WIDTH="12%"/>
								<TCOL COLINDEX="2" WIDTH="12%"/>
								<TCOL COLINDEX="3" WIDTH="12%"/>
								<TCOL COLINDEX="4" WIDTH="12%"/>
								<TCOL COLINDEX="5" WIDTH="12%"/>
								<TCOL COLINDEX="6" WIDTH="12%"/>
								<TCOL COLINDEX="7" WIDTH="12%"/>
								<TCOL COLINDEX="8" WIDTH="12%"/>
							</COLGROUP>
							<TBODY>
								<TROW>
									<ENTRY COLOR="spie_red" COLSPAN="8">
										<PARAGRAPH PARASTYLE="Table Header">
											<RICHTEXT>RISQUES</RICHTEXT>
										</PARAGRAPH>
									</ENTRY>
								</TROW>
								<TROW>
										<xsl:choose>
												<xsl:when test="/section/meta/attribute[@name='spie-risks']/value = 'AMIANTE'">
													<ENTRY COLOR="spie green">
														<PARAGRAPH PARASTYLE="risque_caption">
															<RICHTEXT>AMIANTE</RICHTEXT>
														</PARAGRAPH>
														<PARAGRAPH PARASTYLE="risque_caption">
															<RICHTEXT> </RICHTEXT>
														</PARAGRAPH>
														<PARAGRAPH PARASTYLE="risque_caption">
															<INLINEBOX>
																<CONTENT>file:icon_amiante.png</CONTENT>
															</INLINEBOX>
														</PARAGRAPH>
													</ENTRY>
												</xsl:when>
												<xsl:otherwise>
													<ENTRY COLOR="white">
														<PARAGRAPH PARASTYLE="risque_caption">
															<RICHTEXT>AMIANTE</RICHTEXT>
														</PARAGRAPH>
														<PARAGRAPH PARASTYLE="risque_caption">
															<RICHTEXT> </RICHTEXT>
														</PARAGRAPH>
														<PARAGRAPH PARASTYLE="risque_caption">
															<INLINEBOX>
																<CONTENT>file:icon_amiante.png</CONTENT>
															</INLINEBOX>
														</PARAGRAPH>
													</ENTRY>
												</xsl:otherwise>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="/section/meta/attribute[@name='spie-risks']/value = 'CHIMIQUE'">
											<ENTRY COLOR="spie green">
														<PARAGRAPH PARASTYLE="risque_caption">
															<RICHTEXT>CHIMIQUE</RICHTEXT>
														</PARAGRAPH>
														<PARAGRAPH PARASTYLE="risque_caption">
															<RICHTEXT> </RICHTEXT>
														</PARAGRAPH>
														<PARAGRAPH PARASTYLE="risque_caption">
															<INLINEBOX>
																<CONTENT>file:icon_chimique.png</CONTENT>
															</INLINEBOX>
														</PARAGRAPH>
													</ENTRY>
												</xsl:when>
												<xsl:otherwise>
													<ENTRY COLOR="white">
														<PARAGRAPH PARASTYLE="risque_caption">
															<RICHTEXT>CHIMIQUE</RICHTEXT>
														</PARAGRAPH>
														<PARAGRAPH PARASTYLE="risque_caption">
															<RICHTEXT> </RICHTEXT>
														</PARAGRAPH>
														<PARAGRAPH PARASTYLE="risque_caption">
															<INLINEBOX>
																<CONTENT>file:icon_chimique.png</CONTENT>
															</INLINEBOX>
														</PARAGRAPH>
													</ENTRY>
												</xsl:otherwise>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="/section/meta/attribute[@name='spie-risks']/value = 'ELECTRIQUE'">
											<ENTRY COLOR="spie green">
														<PARAGRAPH PARASTYLE="risque_caption">
															<RICHTEXT>ELECTRIQUE</RICHTEXT>
														</PARAGRAPH>
														<PARAGRAPH PARASTYLE="risque_caption">
															<RICHTEXT> </RICHTEXT>
														</PARAGRAPH>
														<PARAGRAPH PARASTYLE="risque_caption">
															<INLINEBOX>
																<CONTENT>file:icon_electrique.png</CONTENT>
															</INLINEBOX>
														</PARAGRAPH>
													</ENTRY>
												</xsl:when>
												<xsl:otherwise>
													<ENTRY COLOR="white">
														<PARAGRAPH PARASTYLE="risque_caption">
															<RICHTEXT>ELECTRIQUE</RICHTEXT>
														</PARAGRAPH>
														<PARAGRAPH PARASTYLE="risque_caption">
															<RICHTEXT> </RICHTEXT>
														</PARAGRAPH>
														<PARAGRAPH PARASTYLE="risque_caption">
															<INLINEBOX>
																<CONTENT>file:icon_electrique.png</CONTENT>
															</INLINEBOX>
														</PARAGRAPH>
													</ENTRY>
												</xsl:otherwise>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="/section/meta/attribute[@name='spie-risks']/value = 'BASSE TEMPERATURE'">
											<ENTRY COLOR="spie green">
														<PARAGRAPH PARASTYLE="risque_caption">
															<RICHTEXT>BASSE TEMPERATURE</RICHTEXT>
														</PARAGRAPH>
														<PARAGRAPH PARASTYLE="risque_caption">
															<RICHTEXT> </RICHTEXT>
														</PARAGRAPH>
														<PARAGRAPH PARASTYLE="risque_caption">
															<INLINEBOX>
																<CONTENT>file:icon_basse_temperature.png</CONTENT>
															</INLINEBOX>
														</PARAGRAPH>
													</ENTRY>
												</xsl:when>
												<xsl:otherwise>
													<ENTRY COLOR="white">
														<PARAGRAPH PARASTYLE="risque_caption">
															<RICHTEXT>BASSE TEMPERATURE</RICHTEXT>
														</PARAGRAPH>
														<PARAGRAPH PARASTYLE="risque_caption">
															<RICHTEXT> </RICHTEXT>
														</PARAGRAPH>
														<PARAGRAPH PARASTYLE="risque_caption">
															<INLINEBOX>
																<CONTENT>file:icon_basse_temperature.png</CONTENT>
															</INLINEBOX>
														</PARAGRAPH>
													</ENTRY>
												</xsl:otherwise>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="/section/meta/attribute[@name='spie-risks']/value = 'LASER'">
											<ENTRY COLOR="spie green">
														<PARAGRAPH PARASTYLE="risque_caption">
															<RICHTEXT>LASER</RICHTEXT>
														</PARAGRAPH>
														<PARAGRAPH PARASTYLE="risque_caption">
															<RICHTEXT> </RICHTEXT>
														</PARAGRAPH>
														<PARAGRAPH PARASTYLE="risque_caption">
															<INLINEBOX>
																<CONTENT>file:icon_laser.png</CONTENT>
															</INLINEBOX>
														</PARAGRAPH>
													</ENTRY>
												</xsl:when>
												<xsl:otherwise>
													<ENTRY COLOR="white">
														<PARAGRAPH PARASTYLE="risque_caption">
															<RICHTEXT>LASER</RICHTEXT>
														</PARAGRAPH>
														<PARAGRAPH PARASTYLE="risque_caption">
															<RICHTEXT> </RICHTEXT>
														</PARAGRAPH>
														<PARAGRAPH PARASTYLE="risque_caption">
															<INLINEBOX>
																<CONTENT>file:icon_laser.png</CONTENT>
															</INLINEBOX>
														</PARAGRAPH>
													</ENTRY>
												</xsl:otherwise>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="/section/meta/attribute[@name='spie-risks']/value = 'HAUTE TEMPERATURE'">
											<ENTRY COLOR="spie green">
														<PARAGRAPH PARASTYLE="risque_caption">
															<RICHTEXT>HAUTE TEMERATURE</RICHTEXT>
														</PARAGRAPH>
														<PARAGRAPH PARASTYLE="risque_caption">
															<RICHTEXT> </RICHTEXT>
														</PARAGRAPH>
														<PARAGRAPH PARASTYLE="risque_caption">
															<INLINEBOX>
																<CONTENT>file:icon_haute_temperature.png</CONTENT>
															</INLINEBOX>
														</PARAGRAPH>
													</ENTRY>
												</xsl:when>
												<xsl:otherwise>
													<ENTRY COLOR="white">
														<PARAGRAPH PARASTYLE="risque_caption">
															<RICHTEXT>HAUTE TEMERATURE</RICHTEXT>
														</PARAGRAPH>
														<PARAGRAPH PARASTYLE="risque_caption">
															<RICHTEXT> </RICHTEXT>
														</PARAGRAPH>
														<PARAGRAPH PARASTYLE="risque_caption">
															<INLINEBOX>
																<CONTENT>file:icon_haute_temperature.png</CONTENT>
															</INLINEBOX>
														</PARAGRAPH>
													</ENTRY>
												</xsl:otherwise>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="/section/meta/attribute[@name='spie-risks']/value = 'ECRASEMENT'">
											<ENTRY COLOR="spie green">
														<PARAGRAPH PARASTYLE="risque_caption">
															<RICHTEXT>ECRASEMENT</RICHTEXT>
														</PARAGRAPH>
														<PARAGRAPH PARASTYLE="risque_caption">
															<RICHTEXT> </RICHTEXT>
														</PARAGRAPH>
														<PARAGRAPH PARASTYLE="risque_caption">
															<INLINEBOX>
																<CONTENT>file:icon_ecrasement.png</CONTENT>
															</INLINEBOX>
														</PARAGRAPH>
													</ENTRY>
												</xsl:when>
												<xsl:otherwise>
													<ENTRY COLOR="white">
														<PARAGRAPH PARASTYLE="risque_caption">
															<RICHTEXT>ECRASEMENT</RICHTEXT>
														</PARAGRAPH>
														<PARAGRAPH PARASTYLE="risque_caption">
															<RICHTEXT> </RICHTEXT>
														</PARAGRAPH>
														<PARAGRAPH PARASTYLE="risque_caption">
															<INLINEBOX>
																<CONTENT>file:icon_ecrasement.png</CONTENT>
															</INLINEBOX>
														</PARAGRAPH>
													</ENTRY>
												</xsl:otherwise>
									</xsl:choose>
											<xsl:choose>
												<xsl:when test="/section/meta/attribute[@name='spie-risks']/value = 'ECRASEMENT PAR ENGRENAGE'">
													<ENTRY COLOR="spie green">
														<PARAGRAPH PARASTYLE="risque_caption">
															<RICHTEXT>ECRASEMENT PAR ENGRENAGE</RICHTEXT>
														</PARAGRAPH>
														<PARAGRAPH PARASTYLE="risque_caption">
															<RICHTEXT> </RICHTEXT>
														</PARAGRAPH>
														<PARAGRAPH PARASTYLE="risque_caption">
															<INLINEBOX>
																<CONTENT>file:icon_ecrasement_par_engrenage.png</CONTENT>
															</INLINEBOX>
														</PARAGRAPH>
													</ENTRY>
												</xsl:when>
												<xsl:otherwise>
													<ENTRY COLOR="white">
														<PARAGRAPH PARASTYLE="risque_caption">
															<RICHTEXT>ECRASEMENT PAR ENGRENAGE</RICHTEXT>
														</PARAGRAPH>
														<PARAGRAPH PARASTYLE="risque_caption">
															<RICHTEXT> </RICHTEXT>
														</PARAGRAPH>
														<PARAGRAPH PARASTYLE="risque_caption">
															<INLINEBOX>
																<CONTENT>file:icon_ecrasement_par_engrenage.png</CONTENT>
															</INLINEBOX>
														</PARAGRAPH>
													</ENTRY>
												</xsl:otherwise>
											</xsl:choose>
								</TROW>
								<TROW>
									<ENTRY>
										<xsl:if test="/section/meta/attribute[@name='spie-risks']/value = 'PRODUIT NOCIF'">
											<xsl:attribute name="COLOR" select="'spie green'"/>
										</xsl:if>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT>PRODUIT NOCIF</RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT> </RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<INLINEBOX>
												<CONTENT>file:spie-img/icon_produit_nocif.png</CONTENT>
											</INLINEBOX>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<xsl:if test="/section/meta/attribute[@name='spie-risks']/value = 'BRUIT IMPORTANT'">
											<xsl:attribute name="COLOR" select="'spie green'"/>
										</xsl:if>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT>BRUIT IMPORTANT</RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT> </RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<INLINEBOX>
												<CONTENT>file:spie-img/icon_bruit_important.png</CONTENT>
											</INLINEBOX>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<xsl:if test="/section/meta/attribute[@name='spie-risks']/value = 'ENTRAINEMENT MECANIQUE'">
											<xsl:attribute name="COLOR" select="'spie green'"/>
										</xsl:if>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT>ENTRAINEMENT MECANIQUE</RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT> </RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<INLINEBOX>
												<CONTENT>file:spie-img/icon_entrainement_mecanique.png</CONTENT>
											</INLINEBOX>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<xsl:if test="/section/meta/attribute[@name='spie-risks']/value = 'VEHICULES DE MANUTENTION'">
											<xsl:attribute name="COLOR" select="'spie green'"/>
										</xsl:if>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT>VEHICULES DE MANUTENTION</RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT> </RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<INLINEBOX>
												<CONTENT>file:spie-img/icon_vehicules_de_manutention.png</CONTENT>
											</INLINEBOX>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<xsl:if test="/section/meta/attribute[@name='spie-risks']/value = 'LEVAGE'">
											<xsl:attribute name="COLOR" select="'spie green'"/>
										</xsl:if>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT>LEVAGE</RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT> </RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<INLINEBOX>
												<CONTENT>file:spie-img/icon_levage.png</CONTENT>
											</INLINEBOX>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<xsl:if test="/section/meta/attribute[@name='spie-risks']/value = 'BIOLOGIQUE'">
											<xsl:attribute name="COLOR" select="'spie green'"/>
										</xsl:if>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT>BIOLOGIQUE</RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT> </RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<INLINEBOX>
												<CONTENT>file:spie-img/icon_biologique.png</CONTENT>
											</INLINEBOX>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<xsl:if test="/section/meta/attribute[@name='spie-risks']/value = 'CHAMP MAGNETIQUE'">
											<xsl:attribute name="COLOR" select="'spie green'"/>
										</xsl:if>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT>CHAMP MAGNETIQUE</RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT> </RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<INLINEBOX>
												<CONTENT>file:spie-img/icon_champ_magnetique.png</CONTENT>
											</INLINEBOX>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<xsl:if test="/section/meta/attribute[@name='spie-risks']/value = 'INTERDIT AUX PERSONNES PORTANT UN PACEMAKER'">
											<xsl:attribute name="COLOR" select="'spie green'"/>
										</xsl:if>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT>INTERDIT AUX PERSONNES PORTANT UN PACEMAKER</RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT> </RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<INLINEBOX>
												<CONTENT>file:spie-img/icon_interdit_pacemaker.png</CONTENT>
											</INLINEBOX>
										</PARAGRAPH>
									</ENTRY>
								</TROW>
								<TROW>
									<ENTRY>
										<xsl:if test="/section/meta/attribute[@name='spie-risks']/value = 'ATEX'">
											<xsl:attribute name="COLOR" select="'spie green'"/>
										</xsl:if>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT>ATEX</RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT> </RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<INLINEBOX>
												<CONTENT>file:spie-img/icon_atex.png</CONTENT>
											</INLINEBOX>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<xsl:if test="/section/meta/attribute[@name='spie-risks']/value = 'RISQUE DE CHUTES'">
											<xsl:attribute name="COLOR" select="'spie green'"/>
										</xsl:if>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT>RISQUE DE CHUTES</RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT> </RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<INLINEBOX>
												<CONTENT>file:spie-img/icon_risque_de_chutes.png</CONTENT>
											</INLINEBOX>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<xsl:if test="/section/meta/attribute[@name='spie-risks']/value = 'CONSIGNATION'">
											<xsl:attribute name="COLOR" select="'spie green'"/>
										</xsl:if>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT>CONSIGNATION</RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT> </RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<INLINEBOX>
												<CONTENT>file:spie-img/icon_consignation.png</CONTENT>
											</INLINEBOX>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<xsl:if test="/section/meta/attribute[@name='spie-risks']/value = 'DANGEUREUX POUR L ENVIRONNEMENT'">
											<xsl:attribute name="COLOR" select="'spie green'"/>
										</xsl:if>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT>DANGEUREUX POUR L’ENVIRONNEMENT</RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT> </RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<INLINEBOX>
												<CONTENT>file:spie-img/icon_dangereux_environnement.png</CONTENT>
											</INLINEBOX>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<xsl:if test="/section/meta/attribute[@name='spie-risks']/value = 'GAZ SOUS PRESSION'">
											<xsl:attribute name="COLOR" select="'spie green'"/>
										</xsl:if>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT>GAZ SOUS PRESSION</RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT> </RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<INLINEBOX>
												<CONTENT>file:spie-img/icon_gaz_sous_pression.png</CONTENT>
											</INLINEBOX>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<xsl:if test="/section/meta/attribute[@name='spie-risks']/value = 'TOXICITE AIGUE'">
											<xsl:attribute name="COLOR" select="'spie green'"/>
										</xsl:if>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT>TOXICITE AIGUE</RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT> </RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<INLINEBOX>
												<CONTENT>file:spie-img/icon_toxicite_aigue.png</CONTENT>
											</INLINEBOX>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<xsl:if test="/section/meta/attribute[@name='spie-risks']/value = 'PROJECTION DE PARTICULES'">
											<xsl:attribute name="COLOR" select="'spie green'"/>
										</xsl:if>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT>PROJECTION DE PARTICULES</RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT> </RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<INLINEBOX>
												<CONTENT>file:spie-img/icon_protection_de_particules.png</CONTENT>
											</INLINEBOX>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT> </RICHTEXT>
										</PARAGRAPH>
									</ENTRY>
								</TROW>
								<TROW>
									<ENTRY COLOR="spie_red" COLSPAN="8">
										<PARAGRAPH PARASTYLE="Table Header">
											<RICHTEXT>EPI</RICHTEXT>
										</PARAGRAPH>
									</ENTRY>
								</TROW>
								<TROW>
									<ENTRY>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT>GILET ORANGE</RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT> </RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<INLINEBOX>
												<CONTENT>file:spie-img/icon_epi_gilet_orange.png</CONTENT>
											</INLINEBOX>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT>VETEMENT</RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT> </RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<INLINEBOX>
												<CONTENT>file:spie-img/icon_epi_vetement.png</CONTENT>
											</INLINEBOX>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT>CASQUE</RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT> </RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<INLINEBOX>
												<CONTENT>file:spie-img/icon_epi_casque.png</CONTENT>
											</INLINEBOX>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT>CHAUSSURES DE SECURITE ET ESD</RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT> </RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<INLINEBOX>
												<CONTENT>file:spie-img/icon_epi_chaussures_de_securite.png</CONTENT>
											</INLINEBOX>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT>GANTS</RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT> </RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<INLINEBOX>
												<CONTENT>file:spie-img/icon_epi_gants.png</CONTENT>
											</INLINEBOX>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT>AUDITIVE</RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT> </RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<INLINEBOX>
												<CONTENT>file:spie-img/icon_epi_auditive.png</CONTENT>
											</INLINEBOX>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT>LUNETTES</RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT> </RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<INLINEBOX>
												<CONTENT>file:spie-img/icon_epi_lunettes.png</CONTENT>
											</INLINEBOX>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT>HARNAIS LONGE</RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT> </RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<INLINEBOX>
												<CONTENT>file:spie-img/icon_epi_harnais_longe.png</CONTENT>
											</INLINEBOX>
										</PARAGRAPH>
									</ENTRY>
								</TROW>
								<TROW>
									<ENTRY>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT>MASQUE</RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT> </RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<INLINEBOX>
												<CONTENT>file:spie-img/icon_epi_masque.png</CONTENT>
											</INLINEBOX>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT>CASQUE HYDRA</RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT> </RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<INLINEBOX>
												<CONTENT>file:spie-img/icon_epi_casque_hydra.png</CONTENT>
											</INLINEBOX>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT>GANTS ELEC</RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<RICHTEXT> </RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH PARASTYLE="risque_caption">
											<INLINEBOX>
												<CONTENT>file:spie-img/icon_epi_gants_elec.png</CONTENT>
											</INLINEBOX>
										</PARAGRAPH>
									</ENTRY>
								</TROW>
							</TBODY>
						</INLINETABLE>
					</STORY>
				</PAGESEQUENCE>
				
				<PAGESEQUENCE MASTERREFERENCE="CONTENT">
					<xsl:element name="SECTIONNUMBERFORMAT">
						<xsl:attribute name="INITIALPAGENUMBER">1</xsl:attribute>
						<xsl:attribute name="FORMAT">NUMERIC</xsl:attribute>
					</xsl:element>
					<xsl:element name="STATICCONTENT">
						<xsl:element name="BOX">
							<xsl:element name="ID">
								<xsl:attribute name="NAME" select="'pageheader'"/>
							</xsl:element>
							<xsl:element name="TEXT">
								<xsl:element name="STORY">
									<xsl:apply-templates select="/section/title" mode="section">
										<xsl:with-param name="nostyle" select="true()"/>
										<xsl:with-param name="flowcontent" select="false()"/>
										<xsl:with-param name="merge" select="true()"/>										
									</xsl:apply-templates>
								</xsl:element>
							</xsl:element>
						</xsl:element>
						<xsl:if test="exists($assetattributes/*[local-name() = 'assetInfo'])">
						<xsl:if test="contains(($assetattributes//*[@name = 'Status']), 'Draft')">
							<xsl:element name="BOX">
								<xsl:element name="ID">
									<xsl:attribute name="NAME" select="'watermark*'"/>
								</xsl:element>
								<xsl:element name="TEXT">
									<xsl:element name="STORY">
										<xsl:attribute name="FITTEXTTOBOX" select="'true'"/>
										<xsl:element name="PARAGRAPH">
											<xsl:attribute name="MERGE"><xsl:value-of select="'TRUE'"></xsl:value-of></xsl:attribute>
											<xsl:element name="RICHTEXT">
												<xsl:attribute name="BOLD" select="'true'"/>
												<xsl:value-of select="$assetattributes//*[@name = 'Status']"/>
											</xsl:element>
										</xsl:element>
									</xsl:element>
								</xsl:element>
							</xsl:element>
						</xsl:if>
						</xsl:if>
						<BOX>
							<ID NAME="header_title"/>
							<TEXT>
								<STORY>
									<PARAGRAPH PARASTYLE="Header Title">
										<RICHTEXT><xsl:value-of select="/section/title"/></RICHTEXT>
									</PARAGRAPH>
								</STORY>
							</TEXT>
						</BOX>
					</xsl:element>
					<STORY BOXNAME="automatictextbox">
						<xsl:for-each select="/section/section">
							<xsl:variable name="vPos" select="position()"/>
							<xsl:choose>
								<xsl:when test="$vPos = 1">
								</xsl:when>
								<xsl:when test="$vPos &gt; 1">
									<xsl:apply-templates select="." mode="section"/>
								</xsl:when>
							</xsl:choose>
						</xsl:for-each>
						<!--<xsl:apply-templates mode="section"/>-->	
					</STORY>
				</PAGESEQUENCE>
				
			</LAYOUT>
		</PROJECT>
	</xsl:template>

	<xsl:template match="region[@type='box']/ul" mode="section">
		<xsl:variable name="CAT1A" select="li/p='CAT 1A'"/>
                    <xsl:variable name="CAT2A" select="li/p='CAT 2A'"/>
                    <xsl:variable name="CAT3A" select="li/p='CAT 3A'"/>
                    <xsl:variable name="CAT1B" select="li/p='CAT 1B'"/>
                    <xsl:variable name="CAT2B" select="li/p='CAT 2B'"/>
                    <xsl:variable name="CAT3B" select="li/p='CAT 3B'"/>
                    <xsl:variable name="HIGHTLIGH_COLOR" select="'spie green'"/>
                    <xsl:variable name="HIGHTLIGH_SHADE" select="'50'"/>
        <PARAGRAPH>
		<INLINETABLE TABLESTYLEREF="nogrid" BREAKROWACROSSPAGES="TRUE">
							<COLGROUP>
								<TCOL COLINDEX="1" WIDTH="16%"/>
								<TCOL COLINDEX="2" WIDTH="16%"/>
								<TCOL COLINDEX="3" WIDTH="17%">
									<RIGHTGRID WIDTH="0.5" COLOR="Black"/>
								</TCOL>
								<TCOL COLINDEX="4" WIDTH="16%"/>
								<TCOL COLINDEX="5" WIDTH="16%"/>
								<TCOL COLINDEX="6" WIDTH="16%"/>
							</COLGROUP>
							<TBODY>
								<TROW>
									<ENTRY COLSPAN="3">
										<PARAGRAPH PARASTYLE="table_text_title">
											<RICHTEXT>Groupe A : Unidirectionnel</RICHTEXT>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY COLSPAN="3">
										<PARAGRAPH PARASTYLE="table_text_title">
											<RICHTEXT>Groupe B : Multidirectionnel</RICHTEXT>
										</PARAGRAPH>
									</ENTRY>
								</TROW>
								<TROW>
									<ENTRY>
										<xsl:if test="$CAT1A">
											<xsl:attribute name="COLOR" select="$HIGHTLIGH_COLOR" />
											<xsl:attribute name="SHADE" select="$HIGHTLIGH_SHADE" />
										</xsl:if>
										<PARAGRAPH>
											<RICHTEXT>CAT 1A</RICHTEXT>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<xsl:if test="$CAT2A">
											<xsl:attribute name="COLOR" select="$HIGHTLIGH_COLOR" />
											<xsl:attribute name="SHADE" select="$HIGHTLIGH_SHADE" />
										</xsl:if>
										<PARAGRAPH>
											<RICHTEXT>CAT 2A</RICHTEXT>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<xsl:if test="$CAT3A">
											<xsl:attribute name="COLOR" select="$HIGHTLIGH_COLOR" />
											<xsl:attribute name="SHADE" select="$HIGHTLIGH_SHADE" />
										</xsl:if>
										<PARAGRAPH>
											<RICHTEXT>CAT 3A</RICHTEXT>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<xsl:if test="$CAT1B">
											<xsl:attribute name="COLOR" select="$HIGHTLIGH_COLOR" />
											<xsl:attribute name="SHADE" select="$HIGHTLIGH_SHADE" />
										</xsl:if>
										<PARAGRAPH>
											<RICHTEXT>CAT 1B</RICHTEXT>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<xsl:if test="$CAT2B">
											<xsl:attribute name="COLOR" select="$HIGHTLIGH_COLOR" />
											<xsl:attribute name="SHADE" select="$HIGHTLIGH_SHADE" />
										</xsl:if>
										<PARAGRAPH>
											<RICHTEXT>CAT 2B</RICHTEXT>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<xsl:if test="$CAT3B">
											<xsl:attribute name="COLOR" select="$HIGHTLIGH_COLOR" />
											<xsl:attribute name="SHADE" select="$HIGHTLIGH_SHADE" />
										</xsl:if>
										<PARAGRAPH>
											<RICHTEXT>CAT 3B</RICHTEXT>
										</PARAGRAPH>
									</ENTRY>
								</TROW>
								<TROW>
									<ENTRY>
										<xsl:if test="$CAT1A">
											<xsl:attribute name="COLOR" select="$HIGHTLIGH_COLOR" />
											<xsl:attribute name="SHADE" select="$HIGHTLIGH_SHADE" />
										</xsl:if>
										<PARAGRAPH>
											<INLINEBOX>
												<CONTENT>file:nacelle_Cat1A.jpg</CONTENT>
											</INLINEBOX>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<xsl:if test="$CAT2A">
											<xsl:attribute name="COLOR" select="$HIGHTLIGH_COLOR" />
											<xsl:attribute name="SHADE" select="$HIGHTLIGH_SHADE" />
										</xsl:if>
										<PARAGRAPH>
											<INLINEBOX>
												<CONTENT>file:nacelle_Cat2A.jpg</CONTENT>
											</INLINEBOX>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<xsl:if test="$CAT3A">
											<xsl:attribute name="COLOR" select="$HIGHTLIGH_COLOR" />
											<xsl:attribute name="SHADE" select="$HIGHTLIGH_SHADE" />
										</xsl:if>
										<PARAGRAPH>
											<INLINEBOX>
												<CONTENT>file:nacelle_Cat3A.jpg</CONTENT>
											</INLINEBOX>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<xsl:if test="$CAT1B">
											<xsl:attribute name="COLOR" select="$HIGHTLIGH_COLOR" />
											<xsl:attribute name="SHADE" select="$HIGHTLIGH_SHADE" />
										</xsl:if>
										<PARAGRAPH>
											<INLINEBOX>
												<CONTENT>file:nacelle_Cat1B.jpg</CONTENT>
											</INLINEBOX>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<xsl:if test="$CAT2B">
											<xsl:attribute name="COLOR" select="$HIGHTLIGH_COLOR" />
											<xsl:attribute name="SHADE" select="$HIGHTLIGH_SHADE" />
										</xsl:if>
										<PARAGRAPH>
											<INLINEBOX>
												<CONTENT>file:nacelle_Cat2B.jpg</CONTENT>
											</INLINEBOX>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<xsl:if test="$CAT3B">
											<xsl:attribute name="COLOR" select="$HIGHTLIGH_COLOR" />
											<xsl:attribute name="SHADE" select="$HIGHTLIGH_SHADE" />
										</xsl:if>
										<PARAGRAPH>
											<INLINEBOX>
												<CONTENT>file:nacelle_Cat3B.jpg</CONTENT>
											</INLINEBOX>
										</PARAGRAPH>
									</ENTRY>
								</TROW>
								<TROW>
									<ENTRY>
										<xsl:if test="$CAT1A">
											<xsl:attribute name="COLOR" select="$HIGHTLIGH_COLOR" />
											<xsl:attribute name="SHADE" select="$HIGHTLIGH_SHADE" />
										</xsl:if>
										<PARAGRAPH>
											<RICHTEXT>Translation admise</RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH>
											<RICHTEXT>en position repliée</RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH>
											<RICHTEXT>uniquement</RICHTEXT>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<xsl:if test="$CAT2A">
											<xsl:attribute name="COLOR" select="$HIGHTLIGH_COLOR" />
											<xsl:attribute name="SHADE" select="$HIGHTLIGH_SHADE" />
										</xsl:if>
										<PARAGRAPH>
											<RICHTEXT>Translation admise</RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH>
											<RICHTEXT>en position haute,</RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH>
											<RICHTEXT>commandée</RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH>
											<RICHTEXT>depuis le sol</RICHTEXT>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<xsl:if test="$CAT3A">
											<xsl:attribute name="COLOR" select="$HIGHTLIGH_COLOR" />
											<xsl:attribute name="SHADE" select="$HIGHTLIGH_SHADE" />
										</xsl:if>
										<PARAGRAPH>
											<RICHTEXT>Translation admise</RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH>
											<RICHTEXT>en position haute,</RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH>
											<RICHTEXT>commandée depuis</RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH>
											<RICHTEXT>la plateforme</RICHTEXT>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<xsl:if test="$CAT1B">
											<xsl:attribute name="COLOR" select="$HIGHTLIGH_COLOR" />
											<xsl:attribute name="SHADE" select="$HIGHTLIGH_SHADE" />
										</xsl:if>
										<PARAGRAPH>
											<RICHTEXT>Translation admise</RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH>
											<RICHTEXT>en position repliée</RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH>
											<RICHTEXT>uniquement</RICHTEXT>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<xsl:if test="$CAT2B">
											<xsl:attribute name="COLOR" select="$HIGHTLIGH_COLOR" />
											<xsl:attribute name="SHADE" select="$HIGHTLIGH_SHADE" />
										</xsl:if>
										<PARAGRAPH>
											<RICHTEXT>Translation admise</RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH>
											<RICHTEXT>en position haute,</RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH>
											<RICHTEXT>commandée</RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH>
											<RICHTEXT>depuis le sol</RICHTEXT>
										</PARAGRAPH>
									</ENTRY>
									<ENTRY>
										<xsl:if test="$CAT3B">
											<xsl:attribute name="COLOR" select="$HIGHTLIGH_COLOR" />
											<xsl:attribute name="SHADE" select="$HIGHTLIGH_SHADE" />
										</xsl:if>
										<PARAGRAPH>
											<RICHTEXT>Translation admise</RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH>
											<RICHTEXT>en position haute,</RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH>
											<RICHTEXT>commandée depuis</RICHTEXT>
										</PARAGRAPH>
										<PARAGRAPH>
											<RICHTEXT>la plateforme</RICHTEXT>
										</PARAGRAPH>
									</ENTRY>
								</TROW>
							</TBODY>
						</INLINETABLE>
					</PARAGRAPH>
	</xsl:template>
	
</xsl:stylesheet>
