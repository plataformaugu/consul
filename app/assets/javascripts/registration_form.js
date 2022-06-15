(function () {
  "use strict";
  App.RegistrationForm = {
    initialize: function () {
      var clearUsernameMessage,
        showUsernameMessage,
        usernameInput,
        validateUsername;
      usernameInput = $('form#new_user[action="/users"] input#user_username');
      clearUsernameMessage = function () {
        $("small").remove();
      };
      showUsernameMessage = function (response) {
        var klass;
        klass = response.available ? "no-error" : "error";
        usernameInput.after(
          $(
            '<small class="' +
              klass +
              '" style="margin-top: -16px;">' +
              response.message +
              "</small>"
          )
        );
      };
      validateUsername = function (username) {
        var request;
        request = $.get(
          "/user/registrations/check_username?username=" + username
        );
        request.done(function (response) {
          showUsernameMessage(response);
        });
      };
      usernameInput.on("focusout", function () {
        var username;
        clearUsernameMessage();
        username = usernameInput.val();
        if (username !== "") {
          validateUsername(username);
        }
      });

      var sBrowser, sUsrAg = navigator.userAgent;
      var notFoundAddressMessage = "No se ha encontrado tu dirección"

      if(sUsrAg.indexOf("Chrome") > -1) {
          sBrowser = "Google Chrome";
      } else if (sUsrAg.indexOf("Safari") > -1) {
          sBrowser = "Apple Safari";
      } else if (sUsrAg.indexOf("Opera") > -1) {
          sBrowser = "Opera";
      } else if (sUsrAg.indexOf("Firefox") > -1) {
          sBrowser = "Mozilla Firefox";
      } else if (sUsrAg.indexOf("MSIE") > -1) {
          sBrowser = "Microsoft Internet Explorer";
      }

      $('#user_web_browser').val(sBrowser);

      var streets = [];
      var streetsRequest = $.get("/las-condes/streets");
      streetsRequest.done(function (response) {
        streets = response;
      });

      $("#user_phone_number").on("keyup", function (e) {
        if (this.value.length !== 9) {
          this.setCustomValidity("Deben ser 9 dígitos.");

          if (this.value.length > 9) {
            this.value = this.value.substring(0, 9);
            this.setCustomValidity("");
          }
        } else {
          this.setCustomValidity("");
        }
      });

      $("#alternative-address").hide();
      $('a[href="/condiciones"]').attr("target", "_blank");

      function showAltAddress() {
        $("#user_address").val(notFoundAddressMessage);
        $("#alternative-address").show();
        $("#alt-street").attr("required", true);
        $("#alt-number").attr("required", true);
        $("#alt-street").autocomplete({
          source: function (request, response) {
            var results = $.ui.autocomplete.filter(streets, request.term);
            response(results.slice(0, 10));
          },
          change: function (event, ui) {
            if (!ui.item) {
              $("#alt-street").val("");
            }
          },
        });
      }

      function hideAltAddress() {
        $("#alternative-address").hide();
        $("#alt-street").attr("required", false);
        $("#alt-street").val("");
        $("#alt-number").attr("required", false);
        $("#alt-number").val("");

        try {
          $("#alt-street").autocomplete("destroy");
        } catch (error) {}
      }

      $("#user_gender").on("change", function () {
        if (this.value == "Otro") {
          $("#custom_gender").val("");
          $("#custom_gender").css("display", "block");
          $("#custom_gender").attr("required", true);
        } else {
          $("#custom_gender").val(this.value);
          $("#custom_gender").css("display", "none");
          $("#custom_gender").attr("required", false);
        }
      });

      $("#email_verification").on("keyup", function () {
        if (this.value !== $("#user_email").val()) {
          this.setCustomValidity("Los email no coinciden.");
          $("#email_verification").addClass("error-input");
          $("#email-verification-message").show();
        } else {
          this.setCustomValidity("");
          $("#email_verification").removeClass("error-input");
          $("#email-verification-message").hide();
        }
      });

      $("#user_email").on("change", function () {
        var request = $.get(
          "/user/registrations/check_email?email=" + this.value
        );
        request.done(function (response) {
          if (!response.available) {
            $("#user_email")[0].setCustomValidity(
              "El email ya está registrado."
            );
            $("#user_email").addClass("error-input");
            $("#email-exists-message").show();
          } else {
            $("#user_email")[0].setCustomValidity("");
            $("#user_email").removeClass("error-input");
            $("#email-exists-message").hide();
          }
        });
      });

      $("#user_address").on("keydown", function () {
        if ($("#user_address").val() === notFoundAddressMessage) {
          $("#user_address").val('')
        }
      });

      $("#user_comuna").on("change", function () {
        if (this.value === "Las Condes") {
          if ($("#user_address").val()) {
            $("#user_address").val("");
          }

          $("#user_address").autocomplete({
            source: function (request, response) {
              $.ajax({
                dataType: "json",
                type: "get",
                url: `/user/registrations/search?search=${request.term}`,
                success: function (data) {
                  response(
                    data
                      .map(function (record) {
                        return {
                          label: record.nm_direccion,
                          value: record.nm_direccion,
                          sector: record.cod_unidadvecinal,
                          lat: record.str_latitud,
                          long: record.str_longitud,
                        };
                      })
                      .slice(0, 10)
                  );
                },
              });
            },
            response: function (event, ui) {
              if (!ui.content.length) {
                showAltAddress();
              } else {
                hideAltAddress();
              }
            },
            change: function (event, ui) {
              if (!ui.item) {
                $("#sector").val("");
                $("#user_lat").val("");
                $("#user_long").val("");
                showAltAddress();
              } else {
                $("#sector").val(ui.item.sector);
                $("#user_lat").val(parseFloat(ui.item.lat.replace(",", ".")));
                $("#user_long").val(parseFloat(ui.item.long.replace(",", ".")));
                hideAltAddress();
              }
            },
            search: function (event, ui) {
              var value = $("#user_address").val();

              if (value.length < 3) {
                event.preventDefault();
              }
            },
          });
        } else {
          try {
            $("#user_address").autocomplete("destroy");
          } catch (error) {}
          hideAltAddress();
        }
      });
    },
  };
}.call(this));
