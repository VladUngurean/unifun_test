<?php
    include "config.php";

    if (isset($_POST['deleteAll'])) {
        if (!empty($conn)) {
            try {
                $conn->query('CALL deleteAllCars()');
                echo '<script>alert("All cars and related data have been deleted successfully")</script>'; 
                echo '<script> window.location.href = "/un_test"; </script>';
            } catch (mysqli_sql_exception) {
            echo '<script>alert("Something is wrong!")</script>';
            echo '<script> window.location.href = "/un_test"; </script>';
            }
            $conn->close();
        }
    }
?>