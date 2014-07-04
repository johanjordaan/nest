define [], () ->
  login_controller = ($scope,$location,backend,auth) ->  
      $scope.login = () ->
        backend.login $scope,
          email : $scope.$$childHead.email
          password : $scope.$$childHead.password
        ,(authenticated) ->
          if authenticated 
            $location.path '/main'

      $scope.pre_register = () ->       
        $location.path '/pre_registration'

  return login_controller
