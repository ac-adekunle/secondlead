(function(){
'use strict';

angular
  .module('secondLead')

  .controller('UserCtrl', [
    'Gridster',
    'user',
    function(Gridster,user) {
    var ctrl = this;
    ctrl.profile = user["user"];
  
    ctrl.gridsterOpts = Gridster.getOptions();
  }])

})();