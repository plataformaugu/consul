(function() {
  "use strict";
  App.RegistrationForm = {
    initialize: function() {
      var clearUsernameMessage, showUsernameMessage, usernameInput, validateUsername, surnamesInput;
      usernameInput = $("form#new_user[action=\"/users\"] input#user_username");
      surnamesInput = $("form#new_user[action=\"/users\"] input#user_surnames");
      clearUsernameMessage = function() {
        $("small").remove();
      };
      showUsernameMessage = function(response) {
        var klass;
        klass = response.available ? "no-error" : "error";
        surnamesInput.after($("<small class=\"" + klass + "\" style=\"margin-top: -16px;\">" + response.message + "</small>"));
      };
      validateUsername = function(username) {
        var request;
        request = $.get("/user/registrations/check_username?username=" + username);
        request.done(function(response) {
          showUsernameMessage(response);
        });
      };
      // surnamesInput.on("focusout", function() {
      //   var username;
      //   var surnames;
      //   clearUsernameMessage();
      //   username = usernameInput.val();
      //   surnames = surnamesInput.val();
      //   if (username !== "" && surnames !== "") {
      //     validateUsername(`${username} ${surnames}`);
      //   }
      // });
    }
  };
}).call(this);
