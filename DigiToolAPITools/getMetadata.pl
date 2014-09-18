#!/usr/bin/perl -w
   
use strict;
use SOAP::Lite;
use FileHandle;
use LWP::Simple;
use XML::XPath;
use XML::LibXSLT;
use XML::LibXML;

main();

#-----------------------------------------------------------------------------
sub main {
    		
    showUsage()
	if scalar(@ARGV) != 3;
	
    my ($query, $deOutput, $mdType) =  @ARGV;
    
    $mdType = lc $mdType;
    
    my $xslStylesheet = 'extractMDfromCDATA.xsl';
    my $general = readXML('general.xml');
    my $deQuery = readXML($query);
    my $deCall = readXML('call.xml');    
    
    my $dxproxy = 'http://dcollections.bc.edu/de_repository_web/services/DigitalEntityExplorer';
    my $dmproxy = 'http://dcollections.bc.edu/de_repository_web/services/DigitalEntityManager';
    
    #mkdir ("$deOutput");
    
    my $result = SOAP::Lite
	-> uri('DigitalEntityExplorer')
        -> proxy($dxproxy)
	-> digitalEntitySearch($general, $deQuery)
        -> result;
    
    while ( $result =~ /pid>(\d+)\</g) {
	
	my $pid = $1;
	
	my $newdeCall;
	($newdeCall = $deCall) =~ s/#####/$pid/;
	
        my $digitalEntity = SOAP::Lite
          -> uri('DigitalEntityManager')
          -> proxy($dmproxy)
          -> encoding('UTF-8')         
          -> digitalEntityCall($general, $newdeCall)
          -> result;   

	#my $parser = XML::LibXML->new();
	#my $xslt = XML::LibXSLT->new();
	#
	#my $source = $parser->load_xml(string => $digitalEntity);
	#my $xsltDoc = $parser->load_xml(location => $xslStylesheet);
	#
	#my $xsltStyle = $xslt->parse_stylesheet($xsltDoc);
	#my $result = $xsltStyle->transform($source, XML::LibXSLT::xpath_to_string(mdType => $mdType));     
	#
	my $file = $deOutput . '\\' . $pid . '.xml';   
	#
	my $deFH = new FileHandle();
	#
	$deFH->open("> $file");
	$deFH->binmode(':utf8');
	#
	#print $deFH $xsltStyle->output_as_chars($result);
	
	print $deFH $digitalEntity;
	
	# Get Object
	my $url = 'http://dcollections.bc.edu/webclient/DeliveryManager?pid=' . $pid;
	my $digitalObject = get $url;
	
	my $xp = XML::XPath->new( xml => $digitalEntity );
	my $extension = $xp->findvalue('/xb:digital_entity_result/xb:digital_entity/stream_ref/file_extension');
	
	my $xpFile = XML::XPath->new( xml => $digitalEntity );
	my $filename = $xpFile->findvalue('/xb:digital_entity_result/xb:digital_entity/stream_ref/file_name');
	

	if ($extension ne 'undefined') {
	    #my $objFile = $deOutput . '\\' . $pid . '.' . $extension;
	    my $objFile = $deOutput . '\\' . $filename;	
		
	    my $objFH = new FileHandle();
	
	    $objFH->open("> $objFile");
	    $objFH->binmode();	

	    print $objFH $digitalObject;
	}
    }
}
#-----------------------------------------------------------------------------
sub readXML
{
    my $file = shift;
    my $fh = new FileHandle();
    $fh->open($file);
    return join "", $fh->getlines();

}

#-----------------------------------------------------------------------------
sub showUsage
{
    print "\nUsage:\n\n";
    print "getMetadata.pl queryfile output metadata\n\n";
    print "Where\nqueryfile is XML file containing DigiTool Query\noutput is directory for output\nmetadata is Metadata type to extract (mods, marc, dc, etdms)\n";
    exit 1;
}
