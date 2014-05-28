Files to query and extract descriptive metadata from DigiTool
-------------------------------------------------------------


Files needed:

    getMetadata.pl -> Perl script to access API
    query.xml -> XML file containing search parameters
    extractMDfromCDATA.xsl -> Stylesheet to extract descriptive metadata from XML returned by API
    call.xml -> Configuration file for getMetadata.pl. This file should not be modified.
    general.xml -> Configuration file for getMetadata.pl. The value of <owner> needs to be set to whichever DigiTool Admin      unit you are searching.


Usage:
    getMetadata.pl queryfile output metadata
    
    Where
    queryfile is XML file containing DigiTool Query
    output is directory for XML output
    metadata is Metadata type to extract (mods, marc, dc, etdms)
