<?php
$servername = "localhost";
$username = "root";
$password = "admin";
$dbname = "unifun_test";

try {
  $conn = new mysqli($servername, $username, $password, $dbname);
} catch (mysqli_sql_exception) {
  echo "Can not connect to Data Base";
}
?>