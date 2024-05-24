<?php
include "config.php";

if (isset($_POST['car_plate_new'])) {  
    $carPlateNew = $_POST["car_plate_new"];  
    $makeNew = $_POST["make_new"];  
    $modelNew = $_POST["model_new"];  
    $registrationYearNew = $_POST["registration_year_new"];  
    $engineCapacityNew = $_POST["engine_capacity_new"];

    $carPlateOld = $_POST["car_plate_old"];  
    $makeOld = $_POST["make_old"];  
    $modelOld = $_POST["model_old"];  
    $registrationYearOld = $_POST["registration_year_old"];  
    $engineCapacityOld = $_POST["engine_capacity_old"];  

    if($carPlateNew == $carPlateOld &&
        $makeNew == $makeOld &&
        $modelNew == $modelOld &&
        $registrationYearNew == $registrationYearOld &&
        $engineCapacityNew == $engineCapacityOld)
    {
        echo '<script>alert("No changes applied, operation failed")</script>'; 
        echo '<script> window.location.href = "/un_test";</script>';
    } 
    else {

        if ($stmt = $conn->prepare("CALL updateCar(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)")) {
            $stmt->bind_param("ssssssssss", $carPlateOld, $registrationYearOld, $engineCapacityOld, $makeOld, $modelOld, $carPlateNew, $registrationYearNew, $engineCapacityNew, $makeNew, $modelNew);

            try {
                $stmt->execute();
                echo '<script>alert("Car successfully updated")</script>'; 
                echo '<script> window.location.href = "/un_test";</script>';
            } 
            catch (mysqli_sql_exception) {
                echo '<script>alert("Car update failed")</script>'; 
                echo '<script> window.location.href = "/un_test";</script>';
                echo $stmt->affected_rows;
            }
            $stmt->close();
        } else {
            echo "Error preparing statement: " . $conn->error . "<br>";
        }
    }
}
?>