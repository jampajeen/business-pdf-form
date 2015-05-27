<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.1"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xsi:schemaLocation="http://www.w3.org/1999/XSL/Format
                http://svn.apache.org/repos/asf/xmlgraphics/fop/trunk/src/foschema/fop.xsd"
                exclude-result-prefixes="fo">
    <xsl:output method="xml" version="1.0" omit-xml-declaration="no" indent="yes"/>

    <xsl:template match="Invoice">
        <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" font-family="Garuda" font-size="10">
            <fo:layout-master-set>
                <fo:simple-page-master master-name="all"
                                       page-height="11in" page-width="8.5in" margin-top="0.25in"
                                       margin-bottom="0.25in" margin-left="1in" margin-right="1in">
                    <fo:region-body margin-top="2in" margin-bottom="1in" />
                    <fo:region-before extent="2in" />
                    <fo:region-after extent="1in" />
                </fo:simple-page-master>
            </fo:layout-master-set>
            <fo:page-sequence master-reference="all">
                <!-- header -->
                <fo:static-content flow-name="xsl-region-before">
                    <xsl:apply-templates select="CompanyAddress" />
                    <fo:block font-size="16pt"
                              line-height="1.5em" background-color="#ededed" color="black" padding="2.5pt"
                              text-align="center">ใบแจ้งหนี้/Invoice</fo:block>
                </fo:static-content>
                <fo:static-content flow-name="xsl-region-after">
                    <fo:block text-align="end" font-size="10pt">
                        Page <fo:page-number />
                    </fo:block>
                </fo:static-content>
                <fo:flow flow-name="xsl-region-body">
                    <xsl:call-template name="DisplayOrderInformation" />
                    <xsl:apply-templates select="CustomerAddress" />
                    <xsl:apply-templates select="Items" />
                </fo:flow>
            </fo:page-sequence>
        </fo:root>
    </xsl:template>
    <xsl:template name="DisplayOrderInformation">
        <fo:block text-align="right" space-after="2.5pt" >
            <fo:inline font-weight="bold">Id: </fo:inline> 
            <xsl:value-of select="./@OrderId" />
        </fo:block>
        <fo:block text-align="right" space-after="2.5pt">
            <fo:inline font-weight="bold">Order Date: </fo:inline>
            <xsl:value-of select="./OrderDate" />
        </fo:block>
    </xsl:template>
    <xsl:template match="CustomerAddress">
        <fo:block font-weight="bold" background-color="#ededed" color="black" border="solid #cccccc 0.5pt" border-bottom-style="none"
                  padding="2.5pt" margin="0pt">CUSTOMER</fo:block>
        <fo:block color="black" space-after="2em" border="solid #cccccc 0.5pt" padding="2.5pt" margin="0pt"> 
            <xsl:apply-templates />
        </fo:block>
    </xsl:template>
    
    <xsl:template match="CompanyAddress">
        <fo:table width="100%">
            <fo:table-column column-width="40%" />
            <fo:table-column column-width="60%" />
            <fo:table-body  font-size="8pt"> 
                <fo:table-row>
                    <fo:table-cell>
                        <fo:block>
                            <!--<fo:external-graphic src="url(http://localhost:8080/business-pdf-form-1.0-SNAPSHOT/images/logo.png)" />-->
                            <fo:external-graphic content-height="1.0cm" src="">
                                <xsl:attribute name="src">
                                    <xsl:value-of select="./HeaderLogo"/>
                                </xsl:attribute>
                            </fo:external-graphic>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                        <fo:block>
                            <fo:block text-align="right">
                                <xsl:value-of select="./CompanyName" />
                            </fo:block>
                            <fo:block text-align="right">
                                <xsl:value-of select="./StreetAddress" />
                            </fo:block>
                            <fo:block text-align="right">
                                <xsl:value-of select="concat(./City, ' ', ./State, ' ', ./ZipCode)" />
                            </fo:block>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>
    </xsl:template>
    
    <xsl:template match="CompanyName">
        <fo:block>
            <fo:inline font-weight="bold">Company Name:</fo:inline>
            <xsl:value-of select="." />
        </fo:block>
    </xsl:template>
    <xsl:template match="StreetAddress">
        <fo:block>
            <fo:inline font-weight="bold">Street Address:</fo:inline>
            <xsl:value-of select="." />
        </fo:block>
    </xsl:template>
    <xsl:template match="City">
        <fo:block>
            <fo:inline font-weight="bold">City:</fo:inline>
            <xsl:value-of select="." />
        </fo:block>
    </xsl:template>
    <xsl:template match="State">
        <fo:block>
            <fo:inline font-weight="bold">State:</fo:inline>
            <xsl:value-of select="." />
        </fo:block>
    </xsl:template>
    <xsl:template match="ZipCode">
        <fo:block>
            <fo:inline font-weight="bold">Zip Code:</fo:inline>
            <xsl:value-of select="." />
        </fo:block>
    </xsl:template>
    
    <xsl:template match="Items">
        <fo:block font-weight="bold" background-color="#ededed" color="black" border="solid #cccccc 0.5pt" border-bottom-style="none"
                  padding="2.5pt" margin="0pt">Items</fo:block>
            
        <fo:table width="100%"> 
            <fo:table-column column-width="10%" />
            <fo:table-column column-width="15%" />
            <fo:table-column column-width="30%" />
            <fo:table-column column-width="15%" />
            <fo:table-column column-width="15%" />
            <fo:table-column column-width="15%" />
            <fo:table-header>
                <fo:table-row>
                    <fo:table-cell border="solid #cccccc 0.5pt" padding="2.5pt">
                        <fo:block font-weight="bold">#</fo:block>
                    </fo:table-cell>
                    <fo:table-cell border="solid #cccccc 0.5pt" padding="2.5pt">
                        <fo:block font-weight="bold">Item ID</fo:block>
                    </fo:table-cell>
                    <fo:table-cell border="solid #cccccc 0.5pt" padding="2.5pt">
                        <fo:block font-weight="bold">Description</fo:block>
                    </fo:table-cell>
                    <fo:table-cell border="solid #cccccc 0.5pt" padding="2.5pt">
                        <fo:block font-weight="bold">Quantity</fo:block>
                    </fo:table-cell>
                    <fo:table-cell border="solid #cccccc 0.5pt" padding="2.5pt">
                        <fo:block font-weight="bold">Item Cost</fo:block>
                    </fo:table-cell>
                    <fo:table-cell border="solid #cccccc 0.5pt" padding="2.5pt">
                        <fo:block font-weight="bold">Total Cost</fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-header>
            <fo:table-body>
                <xsl:apply-templates />
                <fo:table-row>
                    <fo:table-cell border="solid #cccccc 0.5pt" padding="2.5pt"
                                   number-columns-spanned="5">
                        <fo:block font-weight="bold" text-align="right">Total
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell border="solid #cccccc 0.5pt" padding="2.5pt">
                        <fo:block font-weight="bold">
                            <xsl:variable name="total">
                                <!-- <xsl:apply-templates select="Item[1]" mode="calculateTotal" />-->
  							
                                <xsl:call-template name="calculateTotal">
                                    <xsl:with-param name="nodes" select="Item" />
                                </xsl:call-template>  							
                            </xsl:variable>
  							
                            <xsl:value-of select="format-number($total, '$#,##0.00')"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>
        
    </xsl:template>
	
    <xsl:template name="calculateTotal">
        <xsl:param name="nodes" select="/.." />
        <xsl:param name="subtotal" select="0" />
        <xsl:variable name="total" select="$subtotal + ($nodes[1]/@ItemCost * $nodes[1]/@Quantity)" />
        <xsl:choose>
            <xsl:when test="not($nodes[2])">
                <xsl:value-of select="$total" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="calculateTotal">
                    <xsl:with-param name="nodes" select="$nodes[position() > 1]" />
                    <xsl:with-param name="subtotal" select="$total" />
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
	
    <xsl:template match="Item" mode="calculateTotal">
        <xsl:param name="subtotal" select="0" />
        <xsl:variable name="total" select="$subtotal + (@ItemCost * @Quantity)" />
        <xsl:choose>
            <xsl:when test="not(following-sibling::Item)">
                <xsl:value-of select="$total" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="following-sibling::Item[1]"
                                     mode="calculateTotal">
                    <xsl:with-param name="subtotal" select="$total" />
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="Item">
        <fo:table-row>
            <fo:table-cell border="solid #cccccc 0.5pt" padding="2.5pt">
                <fo:block>
                    <xsl:number/>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell border="solid #cccccc 0.5pt" padding="2.5pt">
                <fo:block>
                    <xsl:value-of select="@ItemId" />
                </fo:block>
            </fo:table-cell>
            <fo:table-cell border="solid #cccccc 0.5pt" padding="2.5pt">
                <fo:block>
                    <xsl:value-of select="@ItemName" />
                </fo:block>
            </fo:table-cell>
            <fo:table-cell border="solid #cccccc 0.5pt" padding="2.5pt">
                <fo:block>
                    <xsl:value-of select="@Quantity" />
                </fo:block>
            </fo:table-cell>
            <fo:table-cell border="solid #cccccc 0.5pt" padding="2.5pt">
                <fo:block>
                    <xsl:value-of select="format-number(@ItemCost, '$#,##0.00')" />
                </fo:block>
            </fo:table-cell>
            <fo:table-cell border="solid #cccccc 0.5pt" padding="2.5pt">
                <xsl:variable name="total" select="@Quantity * @ItemCost" />
                <fo:block>
                    <xsl:value-of select="format-number($total, '$#,##0.00')" />
                </fo:block>
            </fo:table-cell>
        </fo:table-row>
    </xsl:template>

</xsl:stylesheet>
