<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cars</title>
    <link rel="stylesheet" href="style.css">
    <script src="main.js" defer></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

</head>

<body>

    <div id="tesst" class="table_container">
        <div class="table_head">
            <div>Car Plate</div>
            <div>Make</div>
            <div>Model</div>
            <div>Registration Year</div>
            <div>Engine Capacity</div>
        </div>

        <?php
            include "config.php";
            include "p_addCar.php";

            if (!empty($conn)) {
                $result = $conn->query('CALL getCars()');

                if ($result->num_rows > 0) {

                    while($row = $result->fetch_assoc()) {
                        echo '
                        <div class="table_content_container">
                            <div class="table_content_container__buttons">
                                <button id="deleteBtn" class="delete-btn" data-car_plate="' . $row['car_plate'] . '">Delete</button>
                                <button class="update-btn">Update</button>
                                <button class="cancel-update-btn" style="display:none;">X</button>
                                <button class="send-update-btn" style="display:none;">V</button>
                            </div>

                            <div class="table_content_container__datas">
                                <form id="updateCarFormNew" method="POST" action="p_updateCar.php">
                                    <input type="text" readonly name="car_plate_new" value="' . $row['car_plate'] . '" placeholder="Car Plate ex. AAA 000" pattern="^[A-Z]{3}\s[0-9]{3}$" title="Please enter a valid Car Plate number ex. (AAA 000)" minlength="7" maxlength="7" required>
                                    <input type="text" readonly name="make_new" value="' . $row['make'] . '" minlength="2" maxlength="25" required>
                                    <input type="text" readonly name="model_new" value="' . $row['model'] . '" minlength="2" maxlength="25" required>
                                    <input type="text" readonly name="registration_year_new" value="' . $row['registration_year'] . '" placeholder="Registration Year ex.2002" pattern="^(198\d|199\d|200\d|201\d|202[0-4])$" title="Please enter a valid Registration Year ex. (2020)" maxlength="4" required> 
                                    <input type="text" readonly name="engine_capacity_new" value="' . $row['engine_capacity'] . '" placeholder="Engine Capacity ex. 1.8" pattern="^\d\.\d$" title="Please enter a valid Engine Capacity ex. (1.8)" maxlength="3" required>

                                    <input type="hidden" readonly name="car_plate_old" value="' . $row['car_plate'] . '">
                                    <input type="hidden" readonly name="make_old" value="' . $row['make'] . '">
                                    <input type="hidden" readonly name="model_old" value="' . $row['model'] . '">
                                    <input type="hidden" readonly name="registration_year_old" value="' . $row['registration_year'] . '">
                                    <input type="hidden" readonly name="engine_capacity_old" value="' . $row['engine_capacity'] . '">
                                </form>
                            </div>
                        </div>';
                    }

                    $result->free_result();
                } else {
                    echo 'No cars found.';
                }    
                $conn->next_result();
            }
        ?>
    </div>

    <form id="deleteAllCarsForm" method="POST" action="p_deleteAllData.php">
        <input type="submit" name="deleteAll" id="deleteAllCarsButton" value="Delete All Cars And Data">
    </form>

    <form id="" class="addNewCarForm" action="" method="post">
        <div class="addNewCar">
            <input type="text" name="make" placeholder="Car Make" minlength="2" maxlength="25" required>
            <input type="text" name="model" placeholder="Car Model" minlength="2" maxlength="25" required>
            <input type="text" name="car_plate" placeholder="Car Plate ex. AAA 000" pattern="^[A-Z]{3}\s[0-9]{3}$" title="Please enter a valid Car Plate number ex. (AAA 000)" minlength="7" maxlength="7" required />
            <input type="text" name="registration_year" placeholder="Registration Year ex.2002" pattern="^(198\d|199\d|200\d|201\d|202[0-4])$" title="Please enter a valid Registration Year ex. (2020)" maxlength="4" required />
            <input type="text" name="engine_capacity" placeholder="Engine Capacity ex. 1.8" pattern="^\d\.\d$" title="Please enter a valid Engine Capacity ex. (1.8)" maxlength="3" required />

            <input id="sendCarToDataBase" class="button" name="addCar" type="submit" value="Add Car" />
        </div>
    </form>




</body>

</html>