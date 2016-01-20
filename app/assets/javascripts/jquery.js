var params = {};
$(document).ready(function(){
  $.ajaxSetup({
    beforeSend: function(xhr) {
      xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
    }
  });
  $('#search').datetimepicker();
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
  $( '#events' ).load(loadEvents(params));
  //eventos
  $('#search-btn').click(function(e){
    params = {
      nombre: $('#name').val()
    };
    loadEvents(params);
    e.preventDefault();
    console.log('work');
  });
  $('body').on('click','.box-danger',function(){
    $('#save-button-confirm').data('id',$(this).data('id'));
    $('#confirmModal').modal('show');
  });
  $('body').on('click','#save-button-confirm',function(){
    var id = $(this).data('id');
    $.ajax({
        url : 'set_event',
        data : {id: id},
        type : 'POST',
        dataType : 'json',
        success : function(json) {
          if(json.status != true){
            console.log('Error en conexion');
          }else{
            loadEvents()
          }
        },
        error : function(xhr, status) {
            console.log('Error en conexion');
        },
        complete : function(xhr, status) {

        }
    });
    $('#confirmModal').modal('hide');
  });

  var timer = setInterval(function(){
    loadEvents(params);
  },60000);
});
//funciones
function loadEvents(params){
  if($('#events').length >0 ){
    $.ajax({
        url : 'get_events',
        data : params,
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
            console.log('Error en conexion');
        },
        complete : function(xhr, status) {

        }
    });
  }
}
