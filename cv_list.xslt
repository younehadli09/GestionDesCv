<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="yes"/>
  
  <xsl:template match="/">
    <html>
      <head>
        <title>CV Database</title>
        <style>
          body { font-family: Arial, sans-serif; margin: 20px; }
          h1 { color: #2c3e50; }
          table { width: 100%; border-collapse: collapse; margin-top: 20px; }
          th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
          th { background-color: #f2f2f2; }
          tr:hover { background-color: #f5f5f5; }
          a { color: #3498db; text-decoration: none; }
          a:hover { text-decoration: underline; }
          .actions { white-space: nowrap; }
        </style>
      </head>
      <body>
        <h1>CV Database</h1>
        <table>
          <thead>
            <tr>
              <th>ID</th>
              <th>Name</th>
              <th>Nationality</th>
              <th>Current Position</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <xsl:for-each select="cv_list/cv">
              <tr>
                <td><xsl:value-of select="@id"/></td>
                <td><xsl:value-of select="entete/prenom"/> <xsl:value-of select="entete/nom"/></td>
                <td><xsl:value-of select="entete/nationalite"/></td>
                <td><xsl:value-of select="situationActuelle"/></td>
                <td class="actions">
                  <a href="/view_cv/{@id}">View Details</a>
                </td>
              </tr>
            </xsl:for-each>
          </tbody>
        </table>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>