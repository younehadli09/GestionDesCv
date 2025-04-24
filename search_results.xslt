<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html" encoding="UTF-8" indent="yes" />

    <!-- Main template to display the CV -->
    <xsl:template match="/">
        <html>
            <head>
                <title>Curriculum Vitae</title>
                <style>
                    body { font-family: Arial, sans-serif; margin: 20px; line-height: 1.6; }
                    h1, h2 { color: #4CAF50; }
                    table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
                    th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
                    th { background-color: #f4f4f4; }
                    ul { list-style-type: none; padding: 0; }
                    li { margin: 5px 0; }
                </style>
            </head>
            <body>
                <h1>Curriculum Vitae</h1>

                <!-- Personal Information -->
                <h2>Personal Information</h2>
                <p><strong>Name:</strong> <xsl:value-of select="cv/entete/nom" /> <xsl:value-of select="cv/entete/prenom" /></p>
                <p><strong>Date of Birth:</strong> <xsl:value-of select="cv/entete/dateNaissance" /></p>
                <p><strong>Address:</strong> <xsl:value-of select="cv/entete/adresse" /></p>
                <p><strong>Nationality:</strong> <xsl:value-of select="cv/entete/nationalite" /></p>
                <p><strong>Marital Status:</strong> <xsl:value-of select="cv/entete/situationMaritale" /></p>
                <p><strong>Driving License:</strong> <xsl:value-of select="cv/entete/permis" /></p>

                <!-- Objective -->
                <h2>Objective</h2>
                <p><xsl:value-of select="cv/objectif" /></p>

                <!-- Current Situation -->
                <h2>Current Situation</h2>
                <p><xsl:value-of select="cv/situationActuelle" /></p>

                <!-- Education -->
                <h2>Education</h2>
                <table>
                    <tr>
                        <th>Institution</th>
                        <th>Type</th>
                        <th>From</th>
                        <th>To</th>
                        <th>Description</th>
                    </tr>
                    <xsl:for-each select="cv/parcours/formations/diplome">
                        <tr>
                            <td><xsl:value-of select="@etablissement" /></td>
                            <td><xsl:value-of select="@type" /></td>
                            <td><xsl:value-of select="@de" /></td>
                            <td><xsl:value-of select="@a" /></td>
                            <td><xsl:value-of select="." /></td>
                        </tr>
                    </xsl:for-each>
                </table>

                <!-- Internships -->
                <h2>Internships</h2>
                <ul>
                    <xsl:for-each select="cv/parcours/stages/stage">
                        <li>
                            <strong><xsl:value-of select="intituleStage" /></strong> (<xsl:value-of select="date" /> - <xsl:value-of select="annee" />)
                            <p><xsl:value-of select="descriptionstage" /></p>
                        </li>
                    </xsl:for-each>
                </ul>

                <!-- Professional Experiences -->
                <h2>Professional Experiences</h2>
                <table>
                    <tr>
                        <th>Institution</th>
                        <th>Position</th>
                        <th>From</th>
                        <th>To</th>
                        <th>Description</th>
                        <th>Achievements</th>
                    </tr>
                    <xsl:for-each select="cv/parcours/experiencesProfessionnelles/experience">
                        <tr>
                            <td><xsl:value-of select="@etablissement" /></td>
                            <td><xsl:value-of select="@poste" /></td>
                            <td><xsl:value-of select="@de" /></td>
                            <td><xsl:value-of select="@a" /></td>
                            <td><xsl:value-of select="description" /></td>
                            <td>
                                <ul>
                                    <xsl:for-each select="achievement">
                                        <li><xsl:value-of select="." /></li>
                                    </xsl:for-each>
                                </ul>
                            </td>
                        </tr>
                    </xsl:for-each>
                </table>

                <!-- Skills -->
                <h2>Skills</h2>
                <ul>
                    <xsl:for-each select="cv/competences/competence">
                        <li>
                            <strong><xsl:value-of select="titre" /></strong>
                            <p><xsl:value-of select="description" /></p>
                        </li>
                    </xsl:for-each>
                </ul>

                <!-- Languages -->
                <h2>Languages</h2>
                <table>
                    <tr>
                        <th>Language</th>
                        <th>Level</th>
                    </tr>
                    <xsl:for-each select="cv/langues/langue">
                        <tr>
                            <td><xsl:value-of select="intitule" /></td>
                            <td><xsl:value-of select="niveau" /></td>
                        </tr>
                    </xsl:for-each>
                </table>

                <!-- Hobbies -->
                <h2>Hobbies</h2>
                <ul>
                    <xsl:for-each select="cv/loisirs/loisir">
                        <li><xsl:value-of select="." /></li>
                    </xsl:for-each>
                </ul>

                <!-- References -->
                <h2>References</h2>
                <ul>
                    <xsl:for-each select="cv/references/contact">
                        <li>
                            <strong><xsl:value-of select="nom" /></strong> (<xsl:value-of select="relation" />)
                            <p>Email: <xsl:value-of select="@email" /></p>
                            <p>Phone: <xsl:value-of select="@telephone" /></p>
                            <p>Website: <a href="{@web}"><xsl:value-of select="@web" /></a></p>
                        </li>
                    </xsl:for-each>
                </ul>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
