$(document).ready(function() {
  colors = {
    "blue": "primary",
    "orange": "warning",
    "red": "danger",
  };

  for (var color in colors) {
    $('tr[color="' + color + '"]').children('td').addClass('btn-' + colors[color]);
  };

  $('tr').on('click', function() {
    window.location = window.location + $(this).attr('color') + "/" + $(this).children('td').html().split('/')[0] ;
  });

});
