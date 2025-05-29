<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    version="1.0"
    xmlns:csv="csv:csv"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:etdms="http://www.ndltd.org/standards/metadata/etdms/1.0/"
    xmlns:mods="http://www.loc.gov/mods/v3">

    <xsl:param name="handle">UPDATE_HANDLE</xsl:param>
    
    <xsl:param name="subject_delimiter" select="'|'" />
    <xsl:param name="delimiter" select="','" />
    <xsl:param name="quote" select="'&quot;'" />
    <xsl:param name="new_line" select="'&#xA;'" />
    <xsl:param name="empty_value" select="''" />
    <xsl:param name="single_space" select="'&#x20;'" />
    
    <xsl:output method="text" version="1.0" encoding="UTF-8" indent="no"/>
    
    <xsl:strip-space elements="*"/>

    <xsl:variable name="degreeLookup" select="document('degreeLookup.xml')"/>

    <xsl:variable name="languageLookup" select="document('languageLookup.xml')"/>
    
    <!-- CSV headers -->
    <csv:columns>
        <column>id</column>
        <column>parent_id</column>
        <column>field_weight</column>
        <column>title</column>
        <column>field_subtitle</column>
        <column>field_full_title</column>
        <column>field_alternative_title</column>
        <column>field_linked_agent</column>
        <column>field_scholarly_profile</column>
        <column>field_publisher</column>
        <column>field_edtf_date</column>
        <column>field_collection</column>
        <column>field_degree_name</column>
        <column>field_degree_level</column>
        <column>field_degree_discipline</column>
        <column>field_degree_grantor</column>
        <column>field_embargo</column>
        <column>field_rights</column>
        <column>field_access_terms</column>
        <column>field_rights_long</column>
        <column>field_description_long</column>
        <column>field_subject</column>
        <column>field_note</column>
        <column>field_genre</column>
        <column>field_language</column>
        <column>field_mode_of_issuance</column>
        <column>field_digital_origin</column>
        <column>field_physical_form</column>
        <column>field_resource_type</column>
        <column>field_model</column>
        <column>field_member_of</column>
        <column>file</column>
        <column>field_display_hints</column>
    </csv:columns>

    <xsl:template match="/DISS_submission">        
        <!-- Output the CSV header -->
        <xsl:for-each select="document('')/*/csv:columns/*">
            <xsl:value-of select="."/>
            <xsl:if test="position() != last()">
                <xsl:value-of select="$delimiter"/>
            </xsl:if>
        </xsl:for-each>

        <xsl:value-of select="$new_line" />

        <!--
             All examples originate from MetadataCrosswalks/Proquest/sample_xml/Foo_D.xml

             01. id
             1
             
             02. parent_id
             -
             
             03. field_weight
             -
             
             04. title
             Primary dissertation title
             
             05. field_subtitle
             secondary title
             
             06. field_full_title
             Primary dissertation title: secondary title
             
             07. field_alternative_title
             -
             
             08. field_linked_agent
             relators:aut:person:Foo, Danny|relators:ths:person:Wang, Jimmy
             
             09. field_scholarly_profile
             https://orcid.org/0000-0002-2222-1111%%Danny Foo
             
             10. field_publisher
             Boston College
             
             11. field_edtf_date
             2024
             
             12. field_collection
             Graduate Theses and Dissertations
             
             13. field_degree_name
             PhD
             
             14. field_degree_level
             Doctoral
             
             15. field_degree_discipline
             Chemistry
             
             16. field_degree_grantor
             Arts and Sciences
             
             17. field_embargo
             2027-04-11T00:00:00Z
             
             18. field_rights
             -
             
             19. field_access_terms
             40
             
             20. field_rights_long
             Copyright is held by the author, with all rights reserved, unless otherwise noted.
             
             21. field_description_long
             This is a sample abstract.
             
             22. field_subject
             Cats|Dogs|Tigers|Horses|Elephants
             
             23. field_note
             -
             
             24. field_genre
             thesis
             
             25. field_language
             English
             
             26. field_mode_of_issuance
             monographic
             
             27. field_digital_origin
             born digital
             
             28. field_physical_form
             electronic
             
             29. field_resource_type
             Text
             
             30. field_model
             Digital Document
             
             31. field_member_of
             1445
             
             32. file
             Foo_bc_0016D_90012867009.pdf
             
             33. field_display_hints
             PDFjs
        -->

        <!-- 1. id -->
        <!-- TODO: automatically increment this value -->
        <xsl:value-of>1</xsl:value-of>
        <xsl:value-of select="$delimiter" />

        <!-- 2. parent_id -->
        <!-- TODO: used for compound objects -->
        <xsl:value-of select="$empty_value" />
        <xsl:value-of select="$delimiter" />

        <!-- 3. field_weight -->
        <!-- TODO: used for compound objects -->
        <xsl:value-of select="$empty_value" />
        <xsl:value-of select="$delimiter" />

        <!-- 
             4. title
             5. field_subtitle
             6. field_full_title
        -->
        <!-- TODO: refactor and separate logic for each field -->
        <xsl:apply-templates select="DISS_description/DISS_title"/>

        <!-- 7. field_alternative_title -->
        <xsl:value-of select="$empty_value" />
        <xsl:value-of select="$delimiter" />

        <!-- 8. field_linked_agent -->
        <!-- wrap in quotes -->
        <xsl:value-of select="$quote" />

        <xsl:choose>
            <xsl:when test="DISS_authorship/DISS_author[@type='primary']">
                <xsl:apply-templates select="DISS_authorship/DISS_author[@type='primary']/DISS_name">
                    <xsl:with-param name="prefix">relators:aut:person:</xsl:with-param>
                </xsl:apply-templates>
            </xsl:when>

            <!-- parse any additional author names -->
            <xsl:when test="DISS_authorship/DISS_author[@type='additional']">
                <xsl:apply-templates select="DISS_authorship/DISS_author[@type='additional']/DISS_name">
                    <xsl:with-param name="prefix">|relators:aut:person:</xsl:with-param>
                </xsl:apply-templates>
            </xsl:when>
        </xsl:choose>

        <!-- Thesis advisor name -->
        <!-- only get first instance -->
        <xsl:apply-templates select="DISS_description/DISS_advisor[1]/DISS_name">
            <xsl:with-param name="prefix">|relators:ths:person:</xsl:with-param>
        </xsl:apply-templates>

        <xsl:value-of select="$quote" />
        <xsl:value-of select="$delimiter" />

        <!-- 9. field_scholarly_profile -->
        <xsl:apply-templates select="DISS_authorship/DISS_author[@type='primary']/DISS_orcid"/>
        <xsl:value-of select="$delimiter" />

        <!-- 10. field_publisher -->
        <xsl:apply-templates select="DISS_description/DISS_institution/DISS_inst_name"/>
        <xsl:value-of select="$delimiter" />

        <!-- 11. Parse: field_edtf_date -->
        <xsl:apply-templates select="DISS_description/DISS_dates/DISS_comp_date"/>
        <xsl:value-of select="$delimiter" />

        <!-- 12. field_collection -->
        <!-- TODO: this is hard-coded for all ETDs? -->
        <xsl:value-of>Graduate Theses and Dissertations</xsl:value-of>
        <xsl:value-of select="$delimiter" />

        <!-- 13. field_degree_name -->
        <xsl:apply-templates select="DISS_description/DISS_degree">
            <xsl:with-param name="lookup_value">name</xsl:with-param>
        </xsl:apply-templates>
        <xsl:value-of select="$delimiter" />

        <!-- 14. Parse: field_degree_level -->
        <xsl:apply-templates select="DISS_description/DISS_degree">
            <xsl:with-param name="lookup_value">level</xsl:with-param>
        </xsl:apply-templates>
        <xsl:value-of select="$delimiter" />

        <!-- 15. field_degree_discipline -->
        <xsl:apply-templates select="DISS_description/DISS_institution">
            <xsl:with-param name="lookup_value">discipline</xsl:with-param>
        </xsl:apply-templates>
        <xsl:value-of select="$delimiter" />

        <!-- 16. field_degree_grantor -->
        <!-- TODO: is it 'Graduate School of Arts and Sciences' or 'Arts and Sciences' ? -->
        <xsl:apply-templates select="DISS_description/DISS_institution">
            <xsl:with-param name="lookup_value">institution</xsl:with-param>
        </xsl:apply-templates>
        <xsl:value-of select="$delimiter" />

        <!-- 17. field_embargo -->
        <xsl:apply-templates select="DISS_repository/DISS_delayed_release"/>
        <xsl:value-of select="$delimiter" />

        <!-- 18. field_rights -->
        <!-- TODO: fill this in when needed -->
        <xsl:value-of select="$empty_value" />
        <xsl:value-of select="$delimiter" />

        <!-- 19. field_access_terms -->
        <!-- TODO: is this a hard-coded ID? -->
        <xsl:value-of>40</xsl:value-of>
        <xsl:value-of select="$delimiter" />

        <!-- 20. Parse: field_rights_long -->
        <xsl:choose>
            <!-- check if the DISS_acceptance value is "1" or any truthy value -->
            <xsl:when test="DISS_repository/DISS_acceptance">
                <!-- select which CC attribution to use -->
                <xsl:apply-templates select="DISS_repository/DISS_acceptance">
                    <xsl:with-param name="ccAttr">
                        <xsl:value-of select="translate(DISS_creative_commons_license/DISS_abbreviation,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
                    </xsl:with-param>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <!-- default attribution -->
                <xsl:text>Copyright is held by the author, with all rights reserved, unless otherwise noted.</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$delimiter" />

        <!-- 21. Parse: field_description_long -->
        <xsl:apply-templates select="DISS_content/DISS_abstract"/>
        <xsl:value-of select="$delimiter" />

        <!-- 22. Parse: field_subject -->
        <xsl:apply-templates select="DISS_description/DISS_categorization/DISS_keyword"/>
        <xsl:value-of select="$delimiter" />

        <!-- 23. field_note -->
        <!-- TODO: fill this in when needed -->
        <xsl:value-of select="$empty_value" />
        <xsl:value-of select="$delimiter" />

        <!-- 24. Parse: field_genre -->
        <!--xsl:call-template name="genre"/-->
        <!-- TODO: is this a hard-coded value? -->
        <xsl:value-of>thesis</xsl:value-of>
        <xsl:value-of select="$delimiter" />

        <!-- 25. Parse: field_language -->
        <xsl:apply-templates select="DISS_description/DISS_categorization/DISS_language">
            <xsl:with-param name="element">field_language</xsl:with-param>
        </xsl:apply-templates>
        <xsl:value-of select="$delimiter" />

        <!-- 26. field_mode_of_issuance -->
        <!-- TODO: is this a hard-coded value? -->
        <xsl:value-of>monographic</xsl:value-of>
        <xsl:value-of select="$delimiter" />

        <!-- 27. field_digital_origin -->
        <!-- TODO: is this a hard-coded value? -->
        <xsl:value-of>born digital</xsl:value-of>
        <xsl:value-of select="$delimiter" />

        <!-- 28. field_physical_form -->
        <!-- TODO: is this a hard-coded value? -->
        <xsl:value-of>electronic</xsl:value-of>
        <xsl:value-of select="$delimiter" />

        <!-- 29. field_resource_type -->
        <xsl:value-of>Text</xsl:value-of>
        <xsl:value-of select="$delimiter" />

        <!-- 30. field_model -->
        <!-- TODO: is this a hard-coded value? -->
        <xsl:value-of>Digital Document</xsl:value-of>
        <xsl:value-of select="$delimiter" />

        <!-- 31. field_member_of -->
        <!-- TODO: map this ID to the collection type; always 1445? -->
        <xsl:value-of>1445</xsl:value-of>
        <xsl:value-of select="$delimiter" />

        <!-- 32. file -->
        <!-- TODO: parse /DISS_content/DISS_binary -->
        <xsl:value-of></xsl:value-of>
        <xsl:value-of select="$delimiter" />

        <!-- 33. field_display_hints -->
        <!-- TODO: is this a hard-coded value? -->
        <xsl:value-of>PDFjs</xsl:value-of>
        <xsl:value-of select="$delimiter" />

        <!-- 34. (NEW FIELD) Parse: field_local_identifier -->
        <!--xsl:element name="mods:identifier">
            <xsl:attribute name="type">hdl</xsl:attribute>
            <xsl:value-of select="concat('http://hdl.handle.net/2345/',$handle)"/>
        </xsl:element-->

        <!-- ??? Parse: record info -->
        <!--xsl:call-template name="recordInfo"/-->
        
        <!-- ??? Parse: physical desciption -->
        <!--xsl:call-template name="physicalDescription"/-->
        
        <xsl:value-of select="$new_line" />
    </xsl:template>

    <!-- 
       Templates
     -->
    
    <!-- TODO: wrap in quotes -->
    <!-- TODO: clear out nonprintable chars -->
    <!-- TODO: replace fancy quotes -->
    <xsl:template match="DISS_title">
        <xsl:choose>
            <!-- split string if ":" char is found -->
            <xsl:when test="contains(., ':')">
                <!-- title -->
                <xsl:value-of select="substring-before(., ':')"/>
                <xsl:value-of select="$delimiter" />
                <!-- field_subtitle -->
                <xsl:value-of select="normalize-space(substring-after(., ':'))"/>
            </xsl:when>
            <xsl:otherwise>
                <!-- title -->
                <xsl:value-of select="."/>
                <xsl:value-of select="$delimiter" />
                <!-- field_subtitle -->
                <xsl:value-of select="$empty_value" />
            </xsl:otherwise>
        </xsl:choose>
        <!-- field_full_title -->
        <xsl:value-of select="$delimiter" />
        <xsl:value-of select="."/>
        <xsl:value-of select="$delimiter" />
    </xsl:template>

    <xsl:template match="DISS_name">
        <xsl:param name="prefix"/>
        <xsl:value-of select="concat($prefix, DISS_surname, ', ', DISS_fname)" />
        <xsl:apply-templates select="DISS_middle"/>
    </xsl:template>

    <xsl:template match="DISS_middle">
        <!-- check if DISS_middle has a value -->
        <xsl:if test="not(. = '')">
            <!-- prepend a single space before DISS_middle -->
            <xsl:value-of select="concat(' ', .)"/>
            <xsl:choose>
                <!-- don't do anything if the last char of DISS_middle is a "." -->
                <xsl:when test="substring(., string-length(.)) = '.'"></xsl:when>

                <!-- append a period char if DISS_middle is a single char -->
                <xsl:when test="string-length(.) = '1'">
                    <xsl:text>.</xsl:text>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template match="DISS_orcid">
        <!-- check if DISS_orcid has a value -->
        <xsl:if test="not(. = '')">
            <!-- get first name -->
            <xsl:variable name="primary_first_name">
                <xsl:apply-templates select="../DISS_name/DISS_fname"/>
            </xsl:variable>

            <!-- get last name -->
            <xsl:variable name="primary_last_name">
                <xsl:apply-templates select="../DISS_name/DISS_surname"/>
            </xsl:variable>

            <!-- construct Orchid URL -->
            <xsl:value-of select="concat($quote, 'https://orcid.org/', ., '%%', $primary_first_name, $single_space, $primary_last_name, $quote)"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="DISS_authorship/DISS_author[@type='primary']/DISS_name/DISS_fname">
        <xsl:value-of select="."/>
    </xsl:template>

    <xsl:template match="DISS_authorship/DISS_author[@type='primary']/DISS_name/DISS_surname">
        <xsl:value-of select="."/>
    </xsl:template>

    <!--xsl:template name="genre">
         <xsl:element name="mods:genre">
            <xsl:attribute name="authority">ndltd</xsl:attribute>
            <xsl:attribute name="type">work type</xsl:attribute>
            <xsl:text>Electronic Thesis or Dissertation</xsl:text>
        </xsl:element>            
        <xsl:element name="mods:genre">
            <xsl:attribute name="authority">dct</xsl:attribute>
            <xsl:attribute name="type">work type</xsl:attribute>
            <xsl:text>Text</xsl:text>
        </xsl:element>
        <xsl:element name="mods:genre">
            <xsl:attribute name="authority">marcgt</xsl:attribute>
            <xsl:attribute name="type">work type</xsl:attribute>
            <xsl:attribute name="usage">primary</xsl:attribute>
            <xsl:text>thesis</xsl:text>
        </xsl:element>
    </xsl:template-->

    <xsl:template match="DISS_inst_name">
        <xsl:value-of select="."/>
    </xsl:template>

    <xsl:template match="DISS_comp_date">
        <xsl:value-of select="."/>
    </xsl:template>

    <xsl:template match="DISS_language">
        <xsl:param name="element"/>
        <xsl:variable name="varCode">
            <xsl:value-of select="translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>
        </xsl:variable>
        <!--xsl:value-of select="$languageLookup/LanguageLookUp/DISS_language[@value=$varCode]/@code"/-->
        <xsl:value-of select="$languageLookup/LanguageLookUp/DISS_language[@value=$varCode]/@language"/>
    </xsl:template>

    <xsl:template name="physicalDescription">
        <xsl:element name="mods:physicalDescription">
           <xsl:element name="mods:form">
                <xsl:attribute name="authority">marcform</xsl:attribute>
                <xsl:text>electronic</xsl:text>
            </xsl:element>
            <xsl:element name="mods:internetMediaType">
                <xsl:text>application/pdf</xsl:text>
            </xsl:element>
            <xsl:element name="mods:digitalOrigin">
                <xsl:text>born digital</xsl:text>
            </xsl:element>            
        </xsl:element>
    </xsl:template>

    <xsl:template match="DISS_abstract">
        <!-- check if DISS_abstract has a value -->
        <xsl:if test="not(. = '')">
            <xsl:value-of select="$quote" />
            <xsl:for-each select="DISS_para">
                <xsl:value-of select="normalize-space(.)"/>
                <xsl:if test="position() != last()">
                    <xsl:value-of select="$new_line" />
                </xsl:if>
            </xsl:for-each>
            <xsl:value-of select="$quote" />
        </xsl:if>
    </xsl:template>

    <xsl:template match="DISS_acceptance">
        <xsl:param name="ccAttr"/>
        <xsl:choose>
            <xsl:when test="$ccAttr = 'NONE' or $ccAttr = ''">
                <xsl:text>Copyright is held by the author, with all rights reserved, unless otherwise noted.</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Copyright is held by the author. </xsl:text>
                <xsl:choose>
                    <xsl:when test="$ccAttr = 'CC BY'">
                        <xsl:text>This work is licensed under a Creative Commons Attribution 4.0 International License (http://creativecommons.org/licenses/by/4.0).</xsl:text>
                    </xsl:when>
                    <xsl:when test="$ccAttr = 'CC BY-ND'">
                        <xsl:text>This work is licensed under a Creative Commons Attribution-NoDerivatives 4.0 International License (http://creativecommons.org/licenses/by-nd/4.0).</xsl:text>
                    </xsl:when>
                    <xsl:when test="$ccAttr = 'CC BY-NC-SA'">
                        <xsl:text>This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License (http://creativecommons.org/licenses/by-nc-sa/4.0).</xsl:text>
                    </xsl:when>
                    <xsl:when test="$ccAttr = 'CC BY-SA'">
                        <xsl:text>This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License (http://creativecommons.org/licenses/by-sa/4.0).</xsl:text>
                    </xsl:when>
                    <xsl:when test="$ccAttr = 'CC BY-NC'">
                        <xsl:text>This work is licensed under a Creative Commons Attribution-NonCommercial 4.0 International License (http://creativecommons.org/licenses/by-nc/4.0).</xsl:text>
                    </xsl:when>
                    <xsl:when test="$ccAttr = 'CC BY-NC-ND'">
                        <xsl:text>This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License (http://creativecommons.org/licenses/by-nc-nd/4.0).</xsl:text>
                    </xsl:when>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="DISS_degree">
        <xsl:param name="lookup_value"/>
        <xsl:variable name="degree" select="translate(translate(., '.', ''), 'abdehmps', 'ABDEHMPST')"/>
        <!-- use $lookup_value to determine which value from DegreeLoopup.xml to return -->
        <xsl:choose>
            <xsl:when test="$lookup_value='name'">
                <xsl:value-of select="$degreeLookup/DegreeLookUp/DISS_degree[@degree=$degree]/@name"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$degreeLookup/DegreeLookUp/DISS_degree[@degree=$degree]/@level"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="DISS_institution">
        <xsl:param name="lookup_value"/>
        <xsl:choose>
            <xsl:when test="starts-with(DISS_inst_contact, 'CSOM')">
                <xsl:choose>
                    <xsl:when test="$lookup_value='discipline'">
                        <xsl:value-of select="normalize-space(substring-after(DISS_inst_contact,'-'))"/>
                    </xsl:when>
                    <xsl:when test="$lookup_value='institution'">
                        <xsl:text>Carroll School of Management</xsl:text>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="starts-with(DISS_inst_contact, 'CSON')">
                <xsl:choose>
                    <xsl:when test="$lookup_value='discipline'">
                        <xsl:text>Nursing</xsl:text>
                    </xsl:when>
                    <xsl:when test="$lookup_value='institution'">
                        <xsl:text>Connell School of Nursing</xsl:text>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="starts-with(DISS_inst_contact, 'GSAS')">
                <xsl:choose>
                    <xsl:when test="$lookup_value='discipline'">
                        <xsl:value-of select="normalize-space(substring-after(DISS_inst_contact,'-'))"/>
                    </xsl:when>
                    <xsl:when test="$lookup_value='institution'">
                        <xsl:text>Graduate School of Arts and Sciences</xsl:text>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="starts-with(DISS_inst_contact, 'GSSW')">
                <xsl:choose>
                    <xsl:when test="$lookup_value='discipline'">
                        <xsl:text>Social Work</xsl:text>
                    </xsl:when>
                    <xsl:when test="$lookup_value='institution'">
                        <xsl:text>Graduate School of Social Work</xsl:text>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>    
            <xsl:when test="starts-with(DISS_inst_contact, 'LSOE')">
                <xsl:choose>
                    <xsl:when test="$lookup_value='discipline'">
                        <xsl:value-of select="normalize-space(substring-after(DISS_inst_contact,'-'))"/>
                    </xsl:when>
                    <xsl:when test="$lookup_value='institution'">
                        <xsl:text>Lynch School of Education</xsl:text>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="starts-with(DISS_inst_contact, 'STM')">
                <xsl:choose>
                    <xsl:when test="$lookup_value='discipline'">
                        <xsl:text>Sacred Theology</xsl:text>
                    </xsl:when>
                    <xsl:when test="$lookup_value='institution'">
                        <xsl:text>School of Theology and Ministry</xsl:text>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>                    
        </xsl:choose>     
    </xsl:template>
    
    <xsl:template match="DISS_delayed_release">
        <!-- check if DISS_delayed_release has a value -->
        <xsl:if test="not(. = '')">
            <!-- convert string into proper date format -->
            <xsl:value-of select="concat(translate(., ' ', 'T'), 'Z')"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="DISS_keyword">
        <!-- check if DISS_keyword has a value -->
        <xsl:if test="not(. = '')">
            <xsl:value-of select="concat($quote, translate(., ', ', $subject_delimiter), $quote)"/>
        </xsl:if>
    </xsl:template>

    <xsl:template name="recordInfo">
        <xsl:element name="mods:recordInfo">
            <xsl:element name="mods:recordContentSource">
                <xsl:attribute name="authority">marcorg</xsl:attribute>
                <xsl:text>MChB</xsl:text>
            </xsl:element>
            <xsl:element name="mods:recordOrigin">Most grad thesis records are created by transforming ProQuest supplied xml and editing as needed.</xsl:element>
            <xsl:apply-templates select="DISS_description/DISS_categorization/DISS_language">
                <xsl:with-param name="element">mods:languageOfCataloging</xsl:with-param>
            </xsl:apply-templates>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
