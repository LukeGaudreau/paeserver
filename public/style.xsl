<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html" />
    <xsl:template match="/">
        <html>

                <xsl:apply-templates select="/pae" />
        </html>
    </xsl:template>
    
    <xsl:template match="pae">
        <head>       
        <link charset='utf-8' href='/style.css' media='screen' rel='stylesheet' type='text/css' /> 
            <title><xsl:value-of select="title"/></title>
         </head>
          <body>
        <section class="pae">
            <xsl:attribute name="class">
                <xsl:value-of select="@classified"/>
            </xsl:attribute>
            <article class="pae">
                <xsl:attribute name="id">
                    <xsl:value-of select="@idno"/>
                </xsl:attribute>
            <h1 class="title">
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="url"/>
                    </xsl:attribute>
                    <xsl:attribute name="title">
                        <xsl:value-of select="title"/>
                    </xsl:attribute>
                    <xsl:value-of select="title"/></a>
            </h1>
            <h2 class="authors">written by
                <xsl:apply-templates select="authors/author" />
            </h2>
            <p>
                submitted to 
                <xsl:apply-templates select="advisors/advisor" />
                prepared for
                <xsl:apply-templates select="clients/client" />
                on
                <span class="date"><xsl:value-of select="date"/></span>.
            </p>
            </article>
        </section>
       </body>
    </xsl:template>
    <xsl:template match="advisor">
        <xsl:for-each select=".">
            <span class="advisor">
                <xsl:value-of select="name/fname"/>
                <xsl:text>&#x20;</xsl:text>
                <xsl:value-of select="name/lname"/>
            </span>
        </xsl:for-each>
        <xsl:if test="position() != last()">
            <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:if test="position() = last()-1">
            <xsl:text>and </xsl:text>
        </xsl:if>
    </xsl:template>     
    <xsl:template match="author">
        <xsl:for-each select=".">
            <span class="author">
                <xsl:value-of select="name/fname"/>
                <xsl:text>&#x20;</xsl:text>
                <xsl:value-of select="name/lname"/>
            </span>
        </xsl:for-each>
        <xsl:if test="position() != last()">
            <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:if test="position() = last()-1">
            <xsl:text>and </xsl:text>
        </xsl:if>
    </xsl:template> 
    
    <xsl:template match="client">
        <xsl:for-each select=".">
            <span class="client">
                <xsl:value-of select="org_name"/>
            </span>
        </xsl:for-each>
    </xsl:template>    
    
</xsl:stylesheet>