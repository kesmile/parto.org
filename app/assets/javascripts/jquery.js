
$(function(){
    _.templateSettings = {
        interpolate: /\{\{\=(.+?)\}\}/g,
        evaluate: /\{\{(.+?)\}\}/g
      };
    $('body').on('click','#save-button',function(){
      if($(this).data('status') == 'save'){
        $.ajax({
            url : 'add_comadrona',
            data : $('#modalForm').serialize(),
            type : 'POST',
            dataType : 'json',
            success : function(json) {
                $('#status-save-info').html(json.message);
                if(json.status == 'ok'){
                  $('#status-save')
                    .removeClass('alert-danger')
                    .addClass('alert-info')
                    .show();
                    $('.input-dashboard').prop('disabled', true);
                    $('#save-button').data('status','close').html('Aceptar');
                }else{
                  $('#status-save')
                    .removeClass('alert-info')
                    .addClass('alert-danger')
                    .show();
                }
            },
            error : function(xhr, status) {
                alert('Error en conexion');
            },
            complete : function(xhr, status) {

            }
        });
      }else{
        $('.input-dashboard').val('').prop('disabled', false);
        $('#save-button').data('status','save').html('Guardar');
        $('#status-save').hide();
        $('#myModal').modal('hide');
        location.reload();
      }
    });
    $( window ).load(loadEvents());
    function loadEvents(){
      $.ajax({
          url : 'get_events',
          data : {},
          type : 'GET',
          dataType : 'json',
          success : function(json) {
            var template = _.template(
              $('#template-events').html()
              );
            $('#events').html(
              template({ listItems: json})
            );
          },
          error : function(xhr, status) {
              alert('Error en conexion');
          },
          complete : function(xhr, status) {

          }
      });
    }
})
