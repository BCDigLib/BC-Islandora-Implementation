<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    version="1.0"
    xmlns:csv="csv:csv"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:bc="http://library.bc.edu/bc">

    <!-- Placeholder text for handle URL -->
    <xsl:param name="handle">UPDATE_HANDLE</xsl:param>
    
    <!-- Common characters -->
    <!-- A mix of Unicode hex  character codes, and HTML encoded entities. -->
    <xsl:param name="subject_delimiter" select="'|'" />
    <xsl:param name="delimiter" select="','" />
    <xsl:param name="quote" select="'&quot;'" />
    <xsl:param name="new_line" select="'&#xA;'" />
    <xsl:param name="empty_value" select="''" />
    <xsl:param name="single_space" select="'&#x20;'" />
    
    <!-- Default strings -->
    <xsl:param name="default_attribution_string" select='"""Copyright is held by the author, with all rights reserved, unless otherwise noted."""'/>
    <xsl:param name="default_field_collection" select="'Graduate Theses and Dissertations'"/>
    <xsl:param name="default_field_genre" select="'thesis'"/>
    <xsl:param name="default_field_mode_of_issuance" select="'monographic'"/>
    <xsl:param name="default_field_digital_origin" select="'born digital'"/>
    <xsl:param name="default_field_physical_form" select="'electronic'"/>
    <xsl:param name="default_field_resource_type" select="'Text'"/>
    <xsl:param name="default_field_model" select="'Digital Document'"/>
    <xsl:param name="default_field_member_of" select="1445"/>

    <xsl:output method="text" version="1.0" encoding="UTF-8" indent="no"/>

    <xsl:strip-space elements="*"/>

    <!-- Lookup tables -->
    <xsl:variable name="degreeLookup" select="document('degreeLookup.xml')"/>
    <xsl:variable name="languageLookup" select="document('languageLookup.xml')"/>
    <xsl:variable name="displayHintLookup" select="document('displayHintLookup.xml')"/>
    <xsl:variable name="ccAttributionLookup" select="document('ccAttributionLookup.xml')"/>
    
    <!-- CSV headers -->
    <!-- The column order in this structure determines the CSV columns output order. -->
    <csv:columns>
        <column>id</column>
        <column>parent_id</column>
        <column>field_weight</column>
        <column>title</column>
        <column>field_subtitle</column>             <!-- 5 -->
        <column>field_full_title</column>
        <column>field_alternative_title</column>
        <column>field_linked_agent</column>
        <column>field_scholarly_profile</column>
        <column>field_publisher</column>            <!-- 10 -->
        <column>field_edtf_date</column>
        <column>field_collection</column>
        <column>field_degree_name</column>
        <column>field_degree_level</column>
        <column>field_degree_discipline</column>    <!-- 15 -->
        <column>field_degree_grantor</column>
        <column>field_embargo</column>
        <column>field_rights</column>
        <column>field_access_terms</column>
        <column>field_rights_long</column>          <!-- 20 -->
        <column>field_description_long</column>
        <column>field_subject</column>
        <column>field_note</column>
        <column>field_genre</column>
        <column>field_language</column>             <!-- 25 -->
        <column>field_mode_of_issuance</column>
        <column>field_digital_origin</column>
        <column>field_physical_form</column>
        <column>field_resource_type</column>
        <column>field_model</column>                <!-- 30 -->
        <column>field_member_of</column>
        <column>file</column>
        <column>field_display_hints</column>
    </csv:columns>

    <xsl:template match="/DISS_submission">
        <!-- HACK: We keep track of this current context node since we change context when reading the CSV header block. -->
        <!--       This is necessary for applying various apply-templates instructions throughout the xsl:choose function. -->
        <xsl:variable name="DISS_root" select="."/>

        <!-- Output the CSV header -->
        <!-- This for-each instruction loops through the csv:columns structure and prints out each value once. -->
        <xsl:for-each select="document('')/*/csv:columns/*">
            <xsl:value-of select="."/>
            <xsl:if test="position() != last()">
                <xsl:value-of select="$delimiter"/>
            </xsl:if>
        </xsl:for-each>

        <xsl:value-of select="$new_line" />

        <!-- Parse through xml document based on order of csv:columns -->
        <!-- This code uses a large xsl:choose instruction block to match against the csv:column value. -->
        <!-- There is a mix of hard-coded values, empty values (where appropriate), and xsl instructions. -->
        <!-- The apply-templates instructions call on separate templates to parse and transform values. -->
        <xsl:for-each select="document('')/*/csv:columns/*">
            <xsl:variable name="col_name" select="."/>
            <xsl:choose>
                <xsl:when test="$col_name = 'id'">
                    <!-- Hardcoded value -->
                    <xsl:value-of>1</xsl:value-of>
                </xsl:when>

                <xsl:when test="$col_name = 'parent_id'">
                    <!-- TODO: fill this in when needed -->
                    <xsl:value-of select="$empty_value" />
                </xsl:when>

                <xsl:when test="$col_name = 'field_weight'">
                    <!-- TODO: fill this in when needed -->
                    <xsl:value-of select="$empty_value" />
                </xsl:when>

                <xsl:when test="$col_name = 'title'">
                    <xsl:apply-templates select="$DISS_root/DISS_description/DISS_title">
                        <xsl:with-param name="lookup_value">title</xsl:with-param>
                    </xsl:apply-templates>
                </xsl:when>

                <!-- 05 -->
                <xsl:when test="$col_name = 'field_subtitle'">
                    <xsl:apply-templates select="$DISS_root/DISS_description/DISS_title">
                        <xsl:with-param name="lookup_value">field_subtitle</xsl:with-param>
                    </xsl:apply-templates>
                </xsl:when>

                <xsl:when test="$col_name = 'field_full_title'">
                    <xsl:apply-templates select="$DISS_root/DISS_description/DISS_title">
                        <xsl:with-param name="lookup_value">field_full_title</xsl:with-param>
                    </xsl:apply-templates>
                </xsl:when>

                <xsl:when test="$col_name = 'field_alternative_title'">
                    <!-- TODO: fill this in when needed -->
                    <xsl:value-of select="$empty_value" />
                </xsl:when>

                <xsl:when test="$col_name = 'field_linked_agent'">
                    <xsl:apply-templates select="$DISS_root/DISS_authorship/DISS_author"/>
                </xsl:when>

                <xsl:when test="$col_name = 'field_scholarly_profile'">
                    <xsl:apply-templates select="$DISS_root/DISS_authorship/DISS_author[@type='primary']/DISS_orcid"/>
                </xsl:when>

                <!-- 10 -->
                <xsl:when test="$col_name = 'field_publisher'">
                    <xsl:apply-templates select="$DISS_root/DISS_description/DISS_institution/DISS_inst_name"/>
                </xsl:when>

                <xsl:when test="$col_name = 'field_edtf_date'">
                    <xsl:apply-templates select="$DISS_root/DISS_description/DISS_dates/DISS_comp_date"/>
                </xsl:when>

                <xsl:when test="$col_name = 'field_collection'">
                    <!-- TODO: is this a hard-coded value? -->
                    <!--xsl:value-of>Graduate Theses and Dissertations</xsl:value-of-->
                    <xsl:value-of select="$default_field_collection" />
                </xsl:when>

                <xsl:when test="$col_name = 'field_degree_name'">
                     <xsl:apply-templates select="$DISS_root/DISS_description/DISS_degree">
                        <xsl:with-param name="lookup_value">name</xsl:with-param>
                    </xsl:apply-templates>
                </xsl:when>

                <xsl:when test="$col_name = 'field_degree_level'">
                    <xsl:apply-templates select="$DISS_root/DISS_description/DISS_degree">
                        <xsl:with-param name="lookup_value">level</xsl:with-param>
                    </xsl:apply-templates>
                </xsl:when>

                <!-- 15 -->
                <xsl:when test="$col_name = 'field_degree_discipline'">
                    <xsl:apply-templates select="$DISS_root/DISS_description/DISS_institution">
                        <xsl:with-param name="lookup_value">discipline</xsl:with-param>
                    </xsl:apply-templates>
                </xsl:when>

                <xsl:when test="$col_name = 'field_degree_grantor'">
                    <!-- TODO: is it 'Graduate School of Arts and Sciences' or 'Arts and Sciences' ? -->
                    <xsl:apply-templates select="$DISS_root/DISS_description/DISS_institution">
                        <xsl:with-param name="lookup_value">institution</xsl:with-param>
                    </xsl:apply-templates>
                </xsl:when>

                <xsl:when test="$col_name = 'field_embargo'">
                    <xsl:apply-templates select="$DISS_root/DISS_repository/DISS_delayed_release">
                        <xsl:with-param name="lookup_value">date</xsl:with-param>
                    </xsl:apply-templates>
                </xsl:when>

                <xsl:when test="$col_name = 'field_rights'">
                    <!-- TODO: fill this in when needed -->
                    <xsl:value-of select="$empty_value" />
                </xsl:when>

                <xsl:when test="$col_name = 'field_access_terms'">
                    <xsl:apply-templates select="$DISS_root/DISS_repository/DISS_delayed_release">
                        <xsl:with-param name="lookup_value">code</xsl:with-param>
                    </xsl:apply-templates>
                </xsl:when>

                <!-- 20 -->
                <xsl:when test="$col_name = 'field_rights_long'">
                    <xsl:apply-templates select="$DISS_root/DISS_repository/DISS_acceptance"/>
                </xsl:when>

                <xsl:when test="$col_name = 'field_description_long'">
                    <xsl:apply-templates select="$DISS_root/DISS_content/DISS_abstract"/>
                </xsl:when>

                <xsl:when test="$col_name = 'field_subject'">
                    <xsl:apply-templates select="$DISS_root/DISS_description/DISS_categorization/DISS_keyword"/>
                </xsl:when>

                <xsl:when test="$col_name = 'field_note'">
                    <xsl:apply-templates select="$DISS_root/DISS_description/DISS_advisor[1]"/>
                </xsl:when>

                <xsl:when test="$col_name = 'field_genre'">
                    <!-- TODO: is this a hard-coded value? -->
                    <!--xsl:value-of>thesis</xsl:value-of-->
                    <xsl:value-of select="$default_field_genre" />
                </xsl:when>

                <!-- 25 -->
                <xsl:when test="$col_name = 'field_language'">
                    <xsl:apply-templates select="$DISS_root/DISS_description/DISS_categorization/DISS_language"/>
                </xsl:when>

                <xsl:when test="$col_name = 'field_mode_of_issuance'">
                    <!-- TODO: is this a hard-coded value? -->
                    <!--xsl:value-of>monographic</xsl:value-of-->
                    <xsl:value-of select="$default_field_mode_of_issuance" />
                </xsl:when>

                <xsl:when test="$col_name = 'field_digital_origin'">
                    <!-- TODO: is this a hard-coded value? -->
                    <!--xsl:value-of>born digital</xsl:value-of-->
                    <xsl:value-of select="$default_field_digital_origin" />
                </xsl:when>

                <xsl:when test="$col_name = 'field_physical_form'">
                    <!-- TODO: is this a hard-coded value? -->
                    <!--xsl:value-of>electronic</xsl:value-of-->
                    <xsl:value-of select="$default_field_physical_form" />
                </xsl:when>

                <xsl:when test="$col_name = 'field_resource_type'">
                    <!-- TODO: is this a hard-coded value? -->
                    <!--xsl:value-of>Text</xsl:value-of-->
                    <xsl:value-of select="$default_field_resource_type" />
                </xsl:when>

                <!-- 30 -->
                <xsl:when test="$col_name = 'field_model'">
                    <!-- TODO: is this a hard-coded value? -->
                    <!--xsl:value-of>Digital Document</xsl:value-of-->
                    <xsl:value-of select="$default_field_model" />
                </xsl:when>

                <xsl:when test="$col_name = 'field_member_of'">
                    <!-- TODO: map this ID to the collection type; always 1445? -->
                    <!--xsl:value-of>1445</xsl:value-of-->
                    <xsl:value-of select="$default_field_member_of" />
                </xsl:when>

                <xsl:when test="$col_name = 'file'">
                    <xsl:apply-templates select="$DISS_root/DISS_content/DISS_binary">
                        <xsl:with-param name="lookup_value">file_name</xsl:with-param>
                    </xsl:apply-templates>
                </xsl:when>

                <xsl:when test="$col_name = 'field_display_hints'">
                    <xsl:apply-templates select="$DISS_root/DISS_content/DISS_binary">
                        <xsl:with-param name="lookup_value">file_type</xsl:with-param>
                    </xsl:apply-templates>
                </xsl:when>

                <!-- (NEW UNUSED FIELD) -->
                <xsl:when test="$col_name = 'field_local_identifier'">
                    <xsl:value-of select="concat('http://hdl.handle.net/2345/',$handle)"/>
                </xsl:when>
            </xsl:choose>

            <xsl:if test="position() != last()">
                <xsl:value-of select="$delimiter"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <!-- 
       Custom functions
     -->
    
    <!-- Custom function to wrap a string in literal quotes -->
    <xsl:function name="bc:wrapInQuotes">
        <xsl:param name="inputString"/>
        <xsl:value-of select="concat($quote, $inputString, $quote)"/>
    </xsl:function>

    <!-- Custom function to clean up problematic encoded html entities. -->
    <xsl:function name="bc:cleanupString">
        <xsl:param name="input"/>

        <!-- 
        # Replace the following chars (https://www.compart.com/en/unicode)
        #       [\u00a0] [&#160;]  No-Break Space with > <
        #       [\u00ad] [&#173;]  Soft Hyphen with >-<
        #       [\u2013] [&#8211;] En Dash >–< with >-<
        #       [\u2018] [&#8216;] Left Single Quotation Mark >‘< with >'<
        #       [\u2019] [&#8217;] Right Single Quotation Mark >’< with >'<
        #       [\u2028] [&#8232;] Line Separator with ><
        #       [\u2029] [&#8233;] Paragraph Separator with ><
        #       [\u201c] [&#8220;] Left Double Quotation Mark >“< with >\"<
        #       [\u201d] [&#8221;] Right Double Quotation Mark >”<  with >\"<
        -->

        <xsl:variable name="hypen" select="'-'"/>
        <xsl:variable name="apos" select="''''"/>
        <xsl:variable name="escapedDoubleQuotes" select='bc:wrapInQuotes($empty_value)'/>

        <xsl:variable name="removeNoBreakSpace">
            <xsl:value-of select="translate($input, '&#160;', ' ')"/>
        </xsl:variable>

        <xsl:variable name="removeSoftHypen">
            <xsl:value-of select="translate($removeNoBreakSpace, '&#173;', $hypen)"/>
        </xsl:variable>

        <xsl:variable name="removeEnDash">
            <xsl:value-of select="translate($removeSoftHypen, '&#8211;', $hypen)"/>
        </xsl:variable>

        <xsl:variable name="removeLeftSingleQuote">
            <xsl:value-of select="translate($removeEnDash, '&#8216;', $apos)"/>
        </xsl:variable>

        <xsl:variable name="removeRightSingleQuote">
            <xsl:value-of select="translate($removeLeftSingleQuote, '&#8217;', $apos)"/>
        </xsl:variable>

        <xsl:variable name="removeLineSeperator">
            <xsl:value-of select="translate($removeRightSingleQuote, '&#8233;', $empty_value)"/>
        </xsl:variable>

        <xsl:variable name="removeParaSeperator">
            <xsl:value-of select="translate($removeLineSeperator, '&#8232;', $empty_value)"/>
        </xsl:variable>

        <xsl:variable name="removeLeftDoubleQuote">
            <xsl:value-of select="translate($removeParaSeperator, '&#8220;', $quote)"/>
        </xsl:variable>

        <xsl:variable name="removeRightDoubleQuote">
            <xsl:value-of select="translate($removeLeftDoubleQuote, '&#8221;', $quote)"/>
        </xsl:variable>

        <!-- INFO: double quotes don't appear in the output, but still produces valid CSV values. -->
        <xsl:variable name="escapeDoubleQuotes">
            <xsl:value-of select="translate($removeRightDoubleQuote, $quote, $escapedDoubleQuotes)"/>
        </xsl:variable>

        <xsl:value-of select="$escapeDoubleQuotes"/>
    </xsl:function>
    
    <!-- 
        Templates
    -->

    <xsl:template match="DISS_title">
        <xsl:param name="lookup_value"/>

        <!-- Clean title string using custom bc:cleanupString() function -->
        <xsl:variable name="title_clean" select="normalize-space(bc:cleanupString(.))"/>
        <xsl:choose>
            <!-- Split string if ":" char is found -->
            <xsl:when test="contains($title_clean, ':')">
                <xsl:choose>
                    <!-- title -->
                    <xsl:when test="$lookup_value='title'">
                        <xsl:value-of select="bc:wrapInQuotes(substring-before($title_clean, ':'))"/>
                    </xsl:when>

                    <!-- field_subtitle -->
                    <xsl:when test="$lookup_value='field_subtitle'">
                        <xsl:value-of select="bc:wrapInQuotes(normalize-space(substring-after($title_clean, ':')))"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <!-- title -->
                    <xsl:when test="$lookup_value='title'">
                        <xsl:value-of select="bc:wrapInQuotes($title_clean)"/>
                    </xsl:when>

                    <!-- field_subtitle; this is an empty value -->
                    <xsl:when test="$lookup_value='field_subtitle'">
                        <xsl:value-of select="$empty_value" />
                    </xsl:when>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
            <!-- field_full_title -->
            <xsl:when test="$lookup_value='field_full_title'">
                <xsl:value-of select="bc:wrapInQuotes($title_clean)"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="DISS_authorship/DISS_author">
        <xsl:value-of select="$quote" />
        <xsl:choose>
            <xsl:when test=".[@type='primary']">
                <xsl:apply-templates select=".[@type='primary']/DISS_name">
                    <xsl:with-param name="lookup_value">LastFirst</xsl:with-param>
                    <xsl:with-param name="prefix">relators:aut:person:</xsl:with-param>
                </xsl:apply-templates>
            </xsl:when>

            <!-- Parse any additional author's names -->
            <xsl:when test=".[@type='additional']">
                <xsl:apply-templates select=".[@type='additional']/DISS_name">
                    <xsl:with-param name="lookup_value">LastFirst</xsl:with-param>
                    <xsl:with-param name="prefix">|relators:aut:person:</xsl:with-param>
                </xsl:apply-templates>
            </xsl:when>
        </xsl:choose>

        <!-- Thesis advisor name -->
        <!-- Only get the first instance -->
        <!--xsl:apply-templates select="../../DISS_description/DISS_advisor[1]/DISS_name">
            <xsl:with-param name="prefix">|relators:ths:person:</xsl:with-param>
        </xsl:apply-templates-->
        <xsl:value-of select="$quote" />
    </xsl:template>

    <xsl:template match="DISS_description/DISS_advisor[1]">
        <xsl:value-of select="$quote" />
        <xsl:apply-templates select="./DISS_name">
            <xsl:with-param name="lookup_value">FirstLast</xsl:with-param>
            <xsl:with-param name="prefix">Thesis Advisor: </xsl:with-param>
        </xsl:apply-templates>
        <xsl:value-of select="$quote" />
    </xsl:template>

    <xsl:template match="DISS_name">
        <xsl:param name="lookup_value"/>
        <xsl:param name="prefix"/>
        <!-- Check if DISS_delayed_release has a value -->
        <xsl:choose>
            <xsl:when test="$lookup_value='LastFirst'">
                <!-- Construct name string -->
                <xsl:value-of select="concat($prefix, DISS_surname, ', ', DISS_fname)" />

                <!-- Append middle name is present -->
                <xsl:apply-templates select="DISS_middle"/>
            </xsl:when>
            <xsl:when test="$lookup_value='FirstLast'">
                <!-- Construct name string -->
                <!-- TODO: call DISS_MIDDLE template and save as local variable -->
                <xsl:value-of select="concat($prefix, DISS_fname, ' ', DISS_surname)" />
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="DISS_middle">
        <!-- Check if DISS_middle has a value -->
        <xsl:if test="not(. = '')">
            <!-- Prepend a single space before DISS_middle -->
            <xsl:value-of select="concat(' ', .)"/>
            <xsl:choose>
                <!-- Don't do anything if the last char of DISS_middle is a "." -->
                <xsl:when test="substring(., string-length(.)) = '.'"></xsl:when>

                <!-- Append a period char if DISS_middle is a single char -->
                <xsl:when test="string-length(.) = '1'">
                    <xsl:text>.</xsl:text>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template match="DISS_orcid">
        <!-- Check if DISS_orcid has a value -->
        <xsl:if test="not(. = '')">
            <!-- Get author's first name -->
            <xsl:variable name="primary_first_name">
                <xsl:apply-templates select="../DISS_name/DISS_fname"/>
            </xsl:variable>

            <!-- Get author's last name -->
            <xsl:variable name="primary_last_name">
                <xsl:apply-templates select="../DISS_name/DISS_surname"/>
            </xsl:variable>

            <!-- Construct Orchid URL -->
            <xsl:value-of select="concat($quote, 'https://orcid.org/', ., '%%', $primary_first_name, $single_space, $primary_last_name, $quote)"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="DISS_authorship/DISS_author[@type='primary']/DISS_name/DISS_fname">
        <xsl:value-of select="."/>
    </xsl:template>

    <xsl:template match="DISS_authorship/DISS_author[@type='primary']/DISS_name/DISS_surname">
        <xsl:value-of select="."/>
    </xsl:template>

    <xsl:template match="DISS_inst_name">
        <xsl:value-of select="."/>
    </xsl:template>

    <xsl:template match="DISS_comp_date">
        <xsl:value-of select="."/>
    </xsl:template>

    <xsl:template match="DISS_language">
        <xsl:variable name="varCode">
            <xsl:value-of select="translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>
        </xsl:variable>
        <!--xsl:value-of select="$languageLookup/LanguageLookUp/DISS_language[@value=$varCode]/@code"/-->
        <xsl:value-of select="$languageLookup/LanguageLookUp/DISS_language[@value=$varCode]/@language"/>
    </xsl:template>

    <xsl:template match="DISS_abstract">
        <!-- Check if DISS_abstract has a value -->
        <xsl:if test="not(. = '')">
            <xsl:value-of select="$quote" />
            <xsl:for-each select="DISS_para">
                <!-- Call on our custom bc:cleanupString() function. -->
                <xsl:value-of select="normalize-space(bc:cleanupString(.))"/>

                <!-- Add a new line char in between every DISS_para value. -->
                <xsl:if test="position() != last()">
                    <xsl:value-of select="$new_line" />
                </xsl:if>
            </xsl:for-each>
            <xsl:value-of select="$quote" />
        </xsl:if>
    </xsl:template>

    <xsl:template match="DISS_acceptance">
        <!-- Parse DISS_abbreviation relative node. -->
        <xsl:variable name="ccAttributeAbbreviation" select="../../DISS_creative_commons_license/DISS_abbreviation"/>
        <xsl:variable name="ccAttributeAbbreviationLower">
            <xsl:value-of select="translate($ccAttributeAbbreviation,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>
        </xsl:variable>

        <xsl:choose>
            <!-- Check if DISS_acceptance is an empty value, or if the CC attribution is 'NONE' or empty. -->
            <xsl:when test=". = '' or $ccAttributeAbbreviationLower = 'none' or $ccAttributeAbbreviationLower = ''">
                <!-- Use the default attribution string if there isn't a defined CC attribution present. -->
                <xsl:value-of select="$default_attribution_string"/>
            </xsl:when>
            <xsl:otherwise>
                <!-- Fetch CC attribution string from lookup file. -->
                <xsl:value-of select="bc:wrapInQuotes($ccAttributionLookup/CCAttribution/DISS_acceptance[@attr=$ccAttributeAbbreviation]/@value)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="DISS_degree">
        <xsl:param name="lookup_value"/>
        <xsl:variable name="degree" select="translate(translate(., '.', ''), 'abdehmps', 'ABDEHMPST')"/>
        <!-- Use $lookup_value to determine which value from DegreeLoopup.xml to return -->
        <xsl:choose>
            <xsl:when test="$lookup_value='name'">
                <xsl:value-of select="$degreeLookup/DegreeLookUp/DISS_degree[@degree=$degree]/@name"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$degreeLookup/DegreeLookUp/DISS_degree[@degree=$degree]/@level"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- TODO: move strings to lookup file -->
    <xsl:template match="DISS_institution">
        <xsl:param name="lookup_value"/>
        <xsl:value-of select="$quote" />
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
                        <xsl:text>Morrissey College of Arts and Sciences</xsl:text>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="starts-with(DISS_inst_contact, 'GSSW')">
                <xsl:choose>
                    <xsl:when test="$lookup_value='discipline'">
                        <xsl:text>Social Work</xsl:text>
                    </xsl:when>
                    <xsl:when test="$lookup_value='institution'">
                        <xsl:text>School of Social Work</xsl:text>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>    
            <xsl:when test="starts-with(DISS_inst_contact, 'LSOE')">
                <xsl:choose>
                    <xsl:when test="$lookup_value='discipline'">
                        <xsl:value-of select="normalize-space(substring-after(DISS_inst_contact,'-'))"/>
                    </xsl:when>
                    <xsl:when test="$lookup_value='institution'">
                        <xsl:text>Lynch School of Education and Human Development</xsl:text>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="starts-with(DISS_inst_contact, 'STM')">
                <xsl:choose>
                    <xsl:when test="$lookup_value='discipline'">
                        <xsl:text>Sacred Theology</xsl:text>
                    </xsl:when>
                    <xsl:when test="$lookup_value='institution'">
                        <xsl:text>Clough School of Theology and Ministry</xsl:text>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>                    
        </xsl:choose>
        <xsl:value-of select="$quote" />
    </xsl:template>
    
    <xsl:template match="DISS_delayed_release">
        <xsl:param name="lookup_value"/>
        <!-- Check if DISS_delayed_release has a value -->
        <xsl:choose>
            <xsl:when test="$lookup_value='date'">
                <xsl:if test="not(. = '')">
                    <!-- Convert string into proper date format -->
                    <!-- From "2015-11-19 09:50:44" to "2015-11-19T09:50:44Z" -->
                    <xsl:value-of select="concat(translate(., ' ', 'T'), 'Z')"/>
                </xsl:if>
            </xsl:when>
            <xsl:when test="$lookup_value='code'">
                <xsl:if test="not(. = '')">
                    <xsl:value-of select="40"/>
                </xsl:if>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="DISS_keyword">
        <!-- Check if DISS_keyword has a value -->
        <xsl:if test="not(. = '')">
            <!-- Replace ", " string with "|" delimiter -->
            <xsl:value-of select="bc:wrapInQuotes(normalize-space(replace(., ',\s', $subject_delimiter)))"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="DISS_binary">
        <xsl:param name="lookup_value"/>
        <!-- Check if DISS_binary has a value -->
        <xsl:if test="not(. = '')">
            <xsl:choose>
                <xsl:when test="$lookup_value='file_name'">
                    <xsl:value-of select="."/>
                </xsl:when>
                <xsl:when test="$lookup_value='file_type'">
                    <!-- Convert value to lowercase -->
                    <xsl:variable name="fileTypeCode">
                        <xsl:value-of select="translate(./@type,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>
                    </xsl:variable>
                    <!-- Use lookup table to get display hint value -->
                    <xsl:value-of select="$displayHintLookup/DisplayHintLookUp/DISS_binary[@value=$fileTypeCode]/@hint"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
