<?php
    if(isset($_POST['addCar'])) {  
        $carPlate = $_POST["car_plate"];  
        $make = $_POST["make"];  
        $model = $_POST["model"];  
        $registrationYear = $_POST["registration_year"];  
        $engineCapacity = $_POST["engine_capacity"];  
        $stmt = $conn->prepare("CALL addCar(?, ?, ?, ?, ?)");
        
        try {
            $stmt->execute([$carPlate, $registrationYear, $engineCapacity, $make, $model]);
            echo '<script>alert("New car successfully added to DB")</script>'; 
            echo '<script> window.location.href = "/un_test";</script>';
        } catch (mysqli_sql_exception) {
            echo '<script>alert("New car add failed")</script>'; 
            echo '<script> window.location.href = "/un_test";</script>';
        }
        $stmt->close();
    };
?>