<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="yes"/>
  
  <xsl:template match="/">
    <html>
      <head>
        <title>CV Display</title>
        <style>
          body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
            margin: 20px;
            color: #333;
          }
          .cv-container {
            max-width: 800px;
            margin: 0 auto;
            background: #f9f9f9;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
          }
          .header {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
            border-bottom: 2px solid #ddd;
            padding-bottom: 20px;
          }
          .photo {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            object-fit: cover;
            margin-right: 20px;
          }
          .section {
            margin-bottom: 25px;
          }
          .section-title {
            color: #2c3e50;
            border-bottom: 1px solid #ddd;
            padding-bottom: 5px;
            margin-bottom: 10px;
          }
          .experience, .education {
            margin-bottom: 15px;
            padding-left: 15px;
            border-left: 3px solid #3498db;
          }
          .date {
            color: #7f8c8d;
            font-style: italic;
          }
          .skills {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
          }
          .skill {
            background: #e0e0e0;
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 0.9em;
          }
          ul {
            padding-left: 20px;
          }
          li {
            margin-bottom: 5px;
          }
        </style>
      </head>
      <body>
        <div class="cv-container">
          <xsl:apply-templates select="cv"/>
        </div>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="cv">
    <div class="header">
      <xsl:if test="entete/photo">
        <img class="photo" src="{entete/photo}"/>
      </xsl:if>
      <div>
        <h1><xsl:value-of select="entete/prenom"/> <xsl:value-of select="entete/nom"/></h1>
        <p><xsl:value-of select="objectif"/></p>
      </div>
    </div>
    
    <div class="section">
      <h2 class="section-title">Personal Information</h2>
      <p><strong>Date of Birth:</strong> <xsl:value-of select="entete/dateNaissance"/></p>
      <p><strong>Address:</strong> <xsl:value-of select="entete/adresse"/></p>
      <p><strong>Nationality:</strong> <xsl:value-of select="entete/nationalite"/></p>
      <p><strong>Marital Status:</strong> <xsl:value-of select="entete/situationMaritale"/></p>
      <p><strong>Driving License:</strong> <xsl:value-of select="entete/permis"/></p>
    </div>
    
    <div class="section">
      <h2 class="section-title">Current Situation</h2>
      <p><xsl:value-of select="situationActuelle"/></p>
    </div>
    
    <div class="section">
      <h2 class="section-title">Education</h2>
      <xsl:for-each select="parcours/formations/diplome">
        <div class="education">
          <h3><xsl:value-of select="@type"/>: <xsl:value-of select="."/></h3>
          <p class="date"><xsl:value-of select="@de"/> - <xsl:value-of select="@a"/></p>
          <p><xsl:value-of select="@etablissement"/></p>
        </div>
      </xsl:for-each>
    </div>
    
    <div class="section">
      <h2 class="section-title">Internships</h2>
      <xsl:for-each select="parcours/stages/stage">
        <div class="experience">
          <h3><xsl:value-of select="intituleStage"/></h3>
          <p class="date"><xsl:value-of select="date"/>, <xsl:value-of select="annee"/></p>
          <p><xsl:value-of select="descriptionstage"/></p>
        </div>
      </xsl:for-each>
    </div>
    
    <div class="section">
      <h2 class="section-title">Work Experience</h2>
      <xsl:for-each select="parcours/experiencesProfessionnelles/experience">
        <div class="experience">
          <h3><xsl:value-of select="@poste"/> at <xsl:value-of select="@etablissement"/></h3>
          <p class="date"><xsl:value-of select="@de"/> - <xsl:value-of select="@a"/></p>
          <p><xsl:value-of select="description"/></p>
          <ul>
            <xsl:for-each select="achievement">
              <li><xsl:value-of select="."/></li>
            </xsl:for-each>
          </ul>
        </div>
      </xsl:for-each>
    </div>
    
    <div class="section">
      <h2 class="section-title">Skills</h2>
      <div class="skills">
        <xsl:for-each select="competences/competence">
          <div class="skill">
            <strong><xsl:value-of select="titre"/>: </strong>
            <xsl:value-of select="description"/>
          </div>
        </xsl:for-each>
      </div>
    </div>
    
    <div class="section">
      <h2 class="section-title">Languages</h2>
      <ul>
        <xsl:for-each select="langues/langue">
          <li><strong><xsl:value-of select="intitule"/>: </strong>
          <xsl:value-of select="niveau"/></li>
        </xsl:for-each>
      </ul>
    </div>
    
    <div class="section">
      <h2 class="section-title">Hobbies</h2>
      <ul>
        <xsl:for-each select="loisirs/loisir">
          <li><xsl:value-of select="."/></li>
        </xsl:for-each>
      </ul>
    </div>
    
    <xsl:if test="references/reference">
      <div class="section">
        <h2 class="section-title">References</h2>
        <xsl:for-each select="references/reference">
          <div class="reference">
            <h3><xsl:value-of select="contact/nom"/></h3>
            <p><xsl:value-of select="contact/relation"/></p>
            <p>Email: <a href="mailto:{contact/@email}"><xsl:value-of select="contact/@email"/></a></p>
            <p>Phone: <xsl:value-of select="contact/@telephone"/></p>
            <p>Web: <a href="{contact/@web}" target="_blank"><xsl:value-of select="contact/@web"/></a></p>
          </div>
        </xsl:for-each>
      </div>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>