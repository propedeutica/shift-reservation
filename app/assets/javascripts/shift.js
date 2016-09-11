// Shift provides the javascript code for shift views.
$(function () {
  $('.timepicker').datetimepicker({
    format: 'HH:mm',
    useCurrent: false,
    stepping: 5,
    keyBinds: {
      enter: function () {
        $('.timepicker').find('input').trigger('change');
        this.hide();
      }
    }
  });
  $("#time_start").on("dp.change", function (e) {
        $('#time_end').data("DateTimePicker").minDate(e.date);
  });
  $("#time_end").on("dp.change", function (e) {
        $('.time_start').data("DateTimePicker").maxDate(e.date);
  });
});
