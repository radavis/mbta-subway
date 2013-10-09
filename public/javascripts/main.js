$(document).ready(function() {

  // colorize rows using bootstrap classes
  statuses = {
    "now boarding": "success",
    "all aboard": "danger",
    "delayed": "warning",
    "cancelled": "danger",
    "info to follow": "warning",
    "late": "warning",
    "arriving": "success",
    "arrived": "success",
    "departed": "danger",
    "hold": "warning",
    "end": "danger"
  };

  for (var status in statuses) {
    var value = statuses[status];
    $('td[status="' + status + '"]').parent('tr').addClass(value);
  };

});
