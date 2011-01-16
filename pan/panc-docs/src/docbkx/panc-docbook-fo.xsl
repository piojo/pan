<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format" 
                version="1.0">
  
  <xsl:import href="urn:docbkx:stylesheet" />
  
  <xsl:param name="body.font.size">12pt</xsl:param>

  <!-- Only label the chapters, appendices, etc. -->
  <xsl:param name="section.autolabel">0</xsl:param>

  <!-- Use unicode characters for callouts. -->
  <xsl:param name="callout.graphics">0</xsl:param>
  <xsl:param name="callout.unicode">1</xsl:param>

  <!-- Do not hypenate the text (for now). -->
  <xsl:param name="hyphenate">false</xsl:param>

  <!-- Share various verbatim sections to make them standout. -->
  <xsl:param name="shade.verbatim">true</xsl:param>

  <!-- Change to put figure captions after the figure. -->
  <xsl:param name="formal.title.placement">
figure after
example before
equation before
table before
procedure before
task before
  </xsl:param>

  <!-- Make body flush with left margin. -->
  <xsl:param name="body.start.indent">0pt</xsl:param>

  <!-- Captions should be centered with italic, sans-serif font. --> 
  <xsl:attribute-set name="formal.title.properties" use-attribute-sets="normal.para.spacing">
    <xsl:attribute name="font-family">sans-serif</xsl:attribute>
    <xsl:attribute name="font-weight">normal</xsl:attribute>
    <xsl:attribute name="font-style">italic</xsl:attribute>
    <xsl:attribute name="text-align">center</xsl:attribute>
  </xsl:attribute-set>

  <!-- Put TOC entries for main divisions in bold. -->
  <xsl:attribute-set name="toc.line.properties">
    <xsl:attribute name="font-weight">
      <xsl:choose>
        <xsl:when test="name(.)='preface'">bold</xsl:when>
        <xsl:when test="name(.)='chapter'">bold</xsl:when>
        <xsl:when test="name(.)='appendix'">bold</xsl:when>
        <xsl:otherwise>normal</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="space-before">
      <xsl:choose>
        <xsl:when test="name(.)='preface'">12pt</xsl:when>
        <xsl:when test="name(.)='chapter'">12pt</xsl:when>
        <xsl:when test="name(.)='appendix'">12pt</xsl:when>
        <xsl:otherwise>0pt</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="space-after">
      <xsl:choose>
        <xsl:when test="name(.)='preface'">4pt</xsl:when>
        <xsl:when test="name(.)='chapter'">4pt</xsl:when>
        <xsl:when test="name(.)='appendix'">4pt</xsl:when>
        <xsl:otherwise>0pt</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="border-bottom">
      <xsl:choose>
        <xsl:when test="name(.)='preface'">0.5pt solid black</xsl:when>
        <xsl:when test="name(.)='chapter'">0.5pt solid black</xsl:when>
        <xsl:when test="name(.)='appendix'">0.5pt solid black</xsl:when>
        <xsl:otherwise>none</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:attribute-set>

  <!-- Turn off header rules. -->
  <xsl:param name="header.rule" select="0"/>

  <!-- Header properties -->
  <xsl:attribute-set name="header.table.properties">
    <xsl:attribute name="font-family">sans-serif</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
  </xsl:attribute-set>

  <!-- Header content: Nothing at all! -->
  <xsl:template name="header.content"/>

  <!-- Footer properties -->
  <xsl:attribute-set name="footer.table.properties">
    <xsl:attribute name="font-family">sans-serif</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
  </xsl:attribute-set>

  <xsl:param name="footer.column.widths">1 1 8</xsl:param>

  <xsl:template name="footer.content">
    <xsl:param name="pageclass" select="''"/>
    <xsl:param name="sequence" select="''"/>
    <xsl:param name="position" select="''"/>
    <xsl:param name="gentext-key" select="''"/>

    <xsl:variable name="footer.running.marker">
      <fo:retrieve-marker retrieve-class-name="section.head.marker"
                          retrieve-position="first-including-carryover"
                          retrieve-boundary="page-sequence"/>
    </xsl:variable>

    <fo:block>
      <!-- pageclass can be front, body, back -->
      <!-- sequence can be odd, even, first, blank -->
      <!-- position can be left, center, right -->
      <xsl:choose>
        <xsl:when test="$pageclass = 'titlepage'">
          <!-- nop; no footer on title pages -->
        </xsl:when>
        
        <xsl:when test="$double.sided != 0 and $sequence = 'even'
                        and $position='left'">
          <fo:page-number/>
          <xsl:text> | </xsl:text>
          <fo:retrieve-marker retrieve-class-name="section.head.marker"
                              retrieve-position="first-including-carryover"
                              retrieve-boundary="page-sequence"/>
        </xsl:when>
        
        <xsl:when test="$double.sided != 0 and ($sequence = 'odd' or $sequence = 'first')
                        and $position='right'">
          <fo:retrieve-marker retrieve-class-name="section.head.marker"
                              retrieve-position="first-including-carryover"
                              retrieve-boundary="page-sequence"/>
          <xsl:text> | </xsl:text>
          <fo:page-number/>
        </xsl:when>
        
        <xsl:when test="$double.sided = 0 and $position='right'">
          <fo:retrieve-marker retrieve-class-name="section.head.marker"
                              retrieve-position="first-including-carryover"
                              retrieve-boundary="page-sequence"/>
          <xsl:text> | </xsl:text>
          <fo:page-number/>
        </xsl:when>
        
        <xsl:when test="$sequence='blank'">
          <xsl:choose>
            <xsl:when test="$double.sided != 0 and $position = 'left'">
              <fo:page-number/>
              <xsl:text> | </xsl:text>
              <fo:retrieve-marker retrieve-class-name="section.head.marker"
                                  retrieve-position="first-including-carryover"
                                  retrieve-boundary="page-sequence"/>
            </xsl:when>
            <xsl:when test="$double.sided = 0 and $position = 'right'">
              <fo:retrieve-marker retrieve-class-name="section.head.marker"
                                  retrieve-position="first-including-carryover"
                                  retrieve-boundary="page-sequence"/>
              <xsl:text> | </xsl:text>
              <fo:page-number/>
            </xsl:when>
            <xsl:otherwise>
              <!-- nop -->
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        
        
        <xsl:otherwise>
          <!-- nop -->
        </xsl:otherwise>
      </xsl:choose>
    </fo:block>
  </xsl:template>

  <!-- Change the generation of section headings. --> 
  <xsl:template name="component.title">

    <xsl:param name="node" select="."/>
    <xsl:param name="pagewide" select="0"/>

    <xsl:variable name="component.label">
      <xsl:call-template name="gentext">
        <xsl:with-param name="key">
          <xsl:value-of select="name($node)"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="uppercase.component.label">
      <xsl:value-of select="translate($component.label,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
    </xsl:variable>

    <fo:block font-size="14pt"
              text-align="start"
              space-before="0pt"
              space-after="0pt">

      <xsl:value-of select="$uppercase.component.label"/>
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="$node" mode="label.markup"/>
    </fo:block>

    <fo:block xsl:use-attribute-sets="component.title.properties"
              space-before="0pt"
              space-after="0pt">
      <xsl:apply-templates select="$node" mode="title.markup"/>
    </fo:block>

    <fo:block space-before="0pt"
              space-before.conditionality="retain"
              space-after="2in"
              space-after.conditionality="retain"/>
    
  </xsl:template>

</xsl:stylesheet>
