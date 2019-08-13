XSL transforms that support multiple eScholarship@BC workflows.

* Proquest/Proquest_MODS.xsl: called by processProquest library to transform
ProQuest XML (uses Proquest/degreeLookup.xml and Proquest/languageLookup.xml)
* RePec/RePec-DC_MODS3-4_XSLT1-0.xsl: used to transform RePec submissions to
MODS (this process is done manually, outside of Islandora)

Note: Proquest_MODS.xsl may require modification when ProQuest changes their 
ETD schema. This typically occurs without notification, so look for fatal 
errors when [processProquest](https://github.com/BCDigLib/processProquest) runs
or oddities in the MODS of ETDs ingested by processProquest.
