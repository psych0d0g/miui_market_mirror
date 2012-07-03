<?php

/*
#    This script gets the items from mysql db and prints them to the client in json syntax
#    Copyright (C) 2012  Lukas W.
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation version 2 of the License.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/



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
