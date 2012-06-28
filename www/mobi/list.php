<?php
$category	=	$_GET["category"];
$sortby		=	$_GET["sortby"];
$start		=	$_GET["start"];
$count		=	$_GET["count"];

$hostname = 'localhost';
$username = 'root';
$password = 'pass';
$dbname   = 'miui_market';

header("Content-Type: application/json; charset=utf-8");


/*** create a new mysqli object with default database***/
$mysqli = @new mysqli($hostname, $username, $password, $dbname);

/* check connection */ 
if(!mysqli_connect_errno())
    {
    /*** our SELECT query ***/
	$sql = "SELECT *
        	FROM list
        	WHERE moduleType LIKE '".$category."'
        	ORDER BY 'id'
        	LIMIT ".$start.", ".$count."
        	";

    /*** prepare statement ***/
    if($stmt = $mysqli->prepare($sql))
        {
        /*** execute our SQL query ***/
        $stmt->execute();
        /*** bind the results ***/
        $stmt->bind_result($id, $name, $moduleId, $fileSize, $moduleType, $assemblyId, $frontCover, $playTime);
	$json_foo = '{"Compound":[';
        /*** loop over the result set ***/
        while ($stmt->fetch())
            {
            /*** echo our table rows ***/
            $json_foo.='{"assemblyId":"'.$assemblyId.'","downloadUrlRoot":"http://market.s0uthp4rk.eu/mobi/thumbnail/","fileSize":'.$fileSize.',"frontCover":"'.$frontCover.'","moduleId":"'.$moduleId.'","moduleType":"'.$moduleType.'","name":"'.$name.'","playTime":'.$playTime.'},';
            }
        }
    /*** close connection ***/
    $mysqli->close();
    }
else
    {
    /*** if we are unable to connect ***/
    echo 'Unable to connect';
    exit();
    }
$json_foo.= "]}";
$cleaned_json = str_replace("},]}","}]}", $json_foo);
echo $cleaned_json;
?>
