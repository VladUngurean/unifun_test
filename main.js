//prevent delete car in one click
document.getElementById('deleteAllCarsButton').addEventListener('click', function(event) {
      let confirmation = confirm('Are you sure you want to delete ALL cars and related to them data?');
      if (confirmation) {
      } else {
        event.preventDefault();
      }
})

document.querySelectorAll('.update-btn').forEach(e => {
  e.addEventListener('click', function(event) {
    event.preventDefault();
    let container = e.closest('.table_content_container');
    let form = container.querySelector("#updateCarFormNew");
    let cancelUpdateBtn = e.nextElementSibling;
    let sendUpdateBtn = e.nextElementSibling.nextElementSibling;
    let inputs = form.querySelectorAll('input');
    console.log(form);

    if (!e.dataset.flag) {
      inputs.forEach(input => {
        input.readOnly = false;
        input.style.opacity = "1";
      });

      e.style.display = "none";
      cancelUpdateBtn.style.display = "block";
      sendUpdateBtn.style.display = "block";
      e.dataset.flag = true;


      // add event listener for cancelUpdateBtn
      cancelUpdateBtn.addEventListener("click", () => {
        inputs.forEach(input => {
          input.readOnly = true;
          input.style.opacity = "0.7";
          input.value = input.defaultValue;
        });

        e.style.display = "block";
        cancelUpdateBtn.style.display = "none";
        sendUpdateBtn.style.display = "none";
        delete e.dataset.flag;
      });
      // add event listener for cancelUpdateBtn
      sendUpdateBtn.addEventListener("click", () => {
        form.submit();
      });
    }
  });
});


//Delete car 
$(document).ready(function() {
  $('.delete-btn').click(function() {
      let carPlate = $(this).data('car_plate');
      console.log(carPlate);

      if (confirm('Are you sure you want to delete this car?')) {
          $.ajax({
              url: 'p_deleteCar.php',
              type: 'POST',
              data: {
                  car_plate: carPlate
              },
              success: function(response) {
                  alert(response);
                  location.reload();
              },
              error: function() {
                  alert('Error deleting the car.');
              }
          });
      }
  });
});