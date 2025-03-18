<?php
$servername='localhost';
$username='root';
$password='';
$database='Animeverse';

$conn=new mysqli($servername,$username,$password,$database);
if($conn->connect_error){
    die("connection is failed " .$conn->connect_error);
}
else{
    echo "";
}
?>
