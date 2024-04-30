(function() {
  "use strict";
  App.RegistrationForm = {
    initialize: function() {
      var clearUsernameMessage,
        showUsernameMessage,
        usernameInput,
        validateUsername,
        addressInput,
        addressValidateButton,
        toggleIsLoadingAddressValidation,
        allowAddressSearch,
        streetNameInput,
        houseNumberInput;

      allowAddressSearch = false

      usernameInput = $("form#new_user[action=\"/users\"] input#user_username");
      addressInput = $("form#new_user[action=\"/users\"] input#manual_address")
      addressValidateButton = $("form#new_user[action=\"/users\"] button#validate_address")
      streetNameInput = $("form#new_user[action=\"/users\"] input#user_street_name")
      houseNumberInput = $("form#new_user[action=\"/users\"] input#user_house_number")

      clearUsernameMessage = function() {
        $("small").remove();
      };
      showUsernameMessage = function(response) {
        var klass;
        klass = response.available ? "no-error" : "error";
        usernameInput.after($("<small class=\"" + klass + "\" style=\"margin-top: -16px;\">" + response.message + "</small>"));
      };
      validateUsername = function(username) {
        var request;
        request = $.get("/user/registrations/check_username?username=" + username);
        request.done(function(response) {
          showUsernameMessage(response);
        });
      };

      usernameInput.on("focusout", function() {
        var username;
        clearUsernameMessage();
        username = usernameInput.val();
        if (username !== "") {
          validateUsername(username);
        }
      });

      toggleIsLoadingAddressValidation = function(value) {
        if (value) {
          document.getElementById('manual_address').setAttribute('disabled', '')
          document.getElementById('validate_address').setAttribute('disabled', '')
        } else {
          document.getElementById('manual_address').removeAttribute('disabled')
          document.getElementById('validate_address').removeAttribute('disabled')
        }
      }

      addressInput.autocomplete({
        source: function (request, response) {
          if (allowAddressSearch) {
            toggleIsLoadingAddressValidation(true)
            $.ajax({
              url: "/geo/check_address?q=" + request.term,
              success: function(data) {
                response(data.map(
                  (record) => ({
                    label: `${record[0]} ${record[1]}`,
                    street_name: record[0],
                    house_number: record[1],
                  }))
                )
              },
              complete: function() {
                toggleIsLoadingAddressValidation(false)
              },
            })
          }
        },
        change: function (event, ui) {
          if (ui.item !== null) {
            streetNameInput.val(ui.item.street_name).change()
            houseNumberInput.val(ui.item.house_number).change()
          } else {
            streetNameInput.val('').change()
            houseNumberInput.val('').change()
          }
        },
      })

      addressValidateButton.on("click", function() {
        if (addressInput.val().length > 4) {
          allowAddressSearch = true;
          $("#manual_address").autocomplete('search')
          allowAddressSearch = false;
        }
      })

      streetNameInput.on('change', function() {
        if (!!streetNameInput.val() && !!houseNumberInput.val()) {
          $('#street_validation_message').attr('class', 'no-error')
          $('#street_validation_message').text('La dirección es válida.')
        } else {
          $('#street_validation_message').attr('class', 'error')
          $('#street_validation_message').text('Debes ingresar una dirección válida.')
        }
      })

      houseNumberInput.on('change', function() {
        if (!!streetNameInput.val() && !!houseNumberInput.val()) {
          $('#street_validation_message').attr('class', 'no-error')
          $('#street_validation_message').text('La dirección es válida.')
        } else {
          $('#street_validation_message').attr('class', 'error')
          $('#street_validation_message').text('Debes ingresar una dirección válida.')
        }
      })
    }
  };
}).call(this);
