<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" indent="yes" encoding="UTF-8"/>

  <xsl:template match="/">
    <html>
      <head>
        <title>CV de <xsl:value-of select="cv/entete/prenom"/> <xsl:value-of select="cv/entete/nom"/></title>
        <style>
          body { font-family: Arial, sans-serif; margin: 40px; background: #f9f9f9; color: #333; }
          h1, h2, h3 { color: #2c3e50; }
          .section { margin-bottom: 25px; padding-bottom: 15px; border-bottom: 1px solid #ccc; }
          .label { font-weight: bold; }
          ul { padding-left: 20px; }
          .photo img { max-width: 150px; border-radius: 8px; }
        </style>
      </head>
      <body>
        <!-- EN-TÊTE -->
        <div class="section photo">
          <h1><xsl:value-of select="cv/entete/prenom"/> <xsl:value-of select="cv/entete/nom"/></h1>
          <p>
            <span class="label">Date de naissance:</span> <xsl:value-of select="cv/entete/dateNaissance"/><br/>
            <span class="label">Adresse:</span> <xsl:value-of select="cv/entete/adresse"/><br/>
            <span class="label">Nationalité:</span> <xsl:value-of select="cv/entete/nationalite"/><br/>
            <xsl:if test="cv/entete/situationMaritale">
              <span class="label">Situation maritale:</span> <xsl:value-of select="cv/entete/situationMaritale"/><br/>
            </xsl:if>
            <xsl:if test="cv/entete/permis">
              <span class="label">Permis:</span> <xsl:value-of select="cv/entete/permis"/><br/>
            </xsl:if>
          </p>
          <xsl:if test="cv/entete/photo">
            <img src="{cv/entete/photo}" alt="Photo de profil"/>
          </xsl:if>
        </div>

        <!-- OBJECTIF -->
        <xsl:if test="cv/objectif">
          <div class="section">
            <h2>Objectif</h2>
            <p><xsl:value-of select="cv/objectif"/></p>
          </div>
        </xsl:if>

        <!-- SITUATION ACTUELLE -->
        <xsl:if test="cv/situationActuelle">
          <div class="section">
            <h2>Situation actuelle</h2>
            <p><xsl:value-of select="cv/situationActuelle"/></p>
          </div>
        </xsl:if>

        <!-- FORMATIONS -->
        <xsl:if test="cv/parcours/formations">
          <div class="section">
            <h2>Formations</h2>
            <ul>
              <xsl:for-each select="cv/parcours/formations/diplome">
                <li>
                  <strong><xsl:value-of select="@type"/></strong> - <xsl:value-of select="@etablissement"/>
                  <xsl:if test="@de or @a"> (<xsl:value-of select="@de"/> - <xsl:value-of select="@a"/>)</xsl:if><br/>
                  <xsl:value-of select="."/>
                </li>
              </xsl:for-each>
            </ul>
          </div>
        </xsl:if>

        <!-- STAGES -->
        <xsl:if test="cv/parcours/stages">
          <div class="section">
            <h2>Stages</h2>
            <ul>
              <xsl:for-each select="cv/parcours/stages/stage">
                <li>
                  <strong><xsl:value-of select="intituleStage"/></strong> (<xsl:value-of select="date"/> <xsl:value-of select="annee"/>): 
                  <xsl:value-of select="descriptionstage"/>
                </li>
              </xsl:for-each>
            </ul>
          </div>
        </xsl:if>

        <!-- EXPÉRIENCES PROFESSIONNELLES -->
        <xsl:if test="cv/parcours/experiencesProfessionnelles">
          <div class="section">
            <h2>Expériences Professionnelles</h2>
            <xsl:for-each select="cv/parcours/experiencesProfessionnelles/experience">
              <div>
                <h3><xsl:value-of select="@poste"/> - <xsl:value-of select="@etablissement"/></h3>
                <p><xsl:value-of select="@de"/> à <xsl:value-of select="@a"/></p>
                <xsl:if test="description">
                  <p><em><xsl:value-of select="description"/></em></p>
                </xsl:if>
                <ul>
                  <xsl:for-each select="achievement">
                    <li><xsl:value-of select="."/></li>
                  </xsl:for-each>
                </ul>
              </div>
            </xsl:for-each>
          </div>
        </xsl:if>

        <!-- COMPÉTENCES -->
        <xsl:if test="cv/competences">
          <div class="section">
            <h2>Compétences</h2>
            <ul>
              <xsl:for-each select="cv/competences/competence">
                <li>
                  <strong><xsl:value-of select="titre"/></strong>
                  <xsl:if test="description">
                    : <xsl:value-of select="description"/>
                  </xsl:if>
                </li>
              </xsl:for-each>
            </ul>
          </div>
        </xsl:if>

        <!-- LANGUES -->
        <xsl:if test="cv/langues">
          <div class="section">
            <h2>Langues</h2>
            <ul>
              <xsl:for-each select="cv/langues/langue">
                <li><xsl:value-of select="intitule"/> - <xsl:value-of select="niveau"/></li>
              </xsl:for-each>
            </ul>
          </div>
        </xsl:if>

        <!-- LOISIRS -->
        <xsl:if test="cv/loisirs">
          <div class="section">
            <h2>Loisirs</h2>
            <ul>
              <xsl:for-each select="cv/loisirs/loisir">
                <li><xsl:value-of select="."/></li>
              </xsl:for-each>
            </ul>
          </div>
        </xsl:if>

        <!-- RÉFÉRENCES -->
        <xsl:if test="cv/references">
          <div class="section">
            <h2>Références</h2>
            <xsl:for-each select="cv/references/contact">
              <p>
                <strong><xsl:value-of select="nom"/></strong><br/>
                <xsl:value-of select="relation"/><br/>
                <xsl:if test="@email">Email : <xsl:value-of select="@email"/><br/></xsl:if>
                <xsl:if test="@telephone">Tél : <xsl:value-of select="@telephone"/><br/></xsl:if>
                <xsl:if test="@web">Web : <a href="{@web}"><xsl:value-of select="@web"/></a></xsl:if>
              </p>
            </xsl:for-each>
          </div>
        </xsl:if>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
