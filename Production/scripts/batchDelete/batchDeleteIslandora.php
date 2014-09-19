<?php

require_once 'RepositoryConnection.php';
require_once 'FedoraApi.php';
require_once 'FedoraApiSerializer.php';
require_once 'Repository.php';
require_once 'Cache.php';
require_once 'HttpConnection.php';

function usage() {
    echo "\nUsage: php batchDeleteIslandora.php queryfile.itql [query|delete]\n\n";
    echo "Where queryfile.itql contains itql query to retrieve set of PIDs\n";
    echo "query will output PID list\n";
    echo "delete will delete PIDs and output list\n";
}

if (count($argv) < 3){
    usage();
    exit(1);
}
    
$file = file_get_contents($argv[1]);

$fedoraUrl = 'http://dlib.bc.edu:8080/fedora/';
$username = '';
$password = '';

$connection = new RepositoryConnection($fedoraUrl, $username, $password);
$api = new FedoraApi($connection);
$cache = new SimpleCache();
$repository = new FedoraRepository($api, $cache);
$ri = $repository->ri;

$query = $file;
    
$objects = $ri->itqlQuery($query);

$count = 0;
foreach ($objects as $object) {
  $pid = $object['object']['value'];
  $count++;
  if ($argv[2] == 'delete') {
    echo "Deleting $pid\n";
    $api->m->purgeObject($pid);
  } else {
  echo "Retrieved $pid\n";
  }
}

echo "$count PIDs matched\n\n";

?>
