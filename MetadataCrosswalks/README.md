XSL transforms that support multiple eScholarship@BC workflows.

* MARCXML/MODS3-4_MARC21slim_XSLT2-0-bc.xsl: used by islandora_oai to generate
Primo feed
* Proquest/Proquest_MODS.xsl: called by processProquest library to transform
ProQuest XML (uses Proquest/degreeLookup.xml and Proquest/languageLookup.xml)
* RePec/RePec-DC_MODS3-4_XSLT1-0.xsl: used to transform RePec submissions to
MODS (this process is done manually, outside of Islandora)
