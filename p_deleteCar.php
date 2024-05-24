<?php
include "config.php";

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (isset($_POST['car_plate'])) {
        $carPlate = $_POST['car_plate'];

        if (!empty($conn)) {
            $stmt = $conn->prepare("CALL deleteCar(?)");
            $stmt->bind_param('s', $carPlate);

            try {
                $stmt->execute();
                echo "Car deleted successfully.";
            } catch (mysqli_sql_exception) {
                echo "Error deleting car.";
            }

            $stmt->close();
        } else {
            echo "Database connection failed.";
        }
    } else {
        echo "No car plate provided.";
    }
} else {
    echo "Invalid request method.";
}

$conn->close();
?>