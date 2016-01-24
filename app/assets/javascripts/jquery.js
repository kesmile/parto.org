var params = {};
var _table = {};
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
  _table = $('#datatable').DataTable({
      dom: 'Bfrtip',
      buttons: [
          'copy', 'excel'
      ],
      ajax: 'get_events',
      columns: [
        { data: null,
          render: function(data, type, row){
            if(data['status'] == true){
              return "<span class='label label-danger blink_me'>Emergencia</span>";
            }else{
              return "<span class='label label-success'>Gestionada</span>";
            }
          }
        },
        {data: 'usuario'},
        {data: 'telefono'},
        {data: 'tipo'},
        {data: 'fecha'},
        {data: 'updated_at'},
        { data: null,
          width: '5%',
          render: function(data, type, row){
            if(data['status'] == true){
              return '<input data-id="'+ data['id']+'" class="change-status" type="checkbox">';
            }else{
              return '<input type="checkbox" disabled checked>';
            }
          }
        }
      ]

    });
  //eventos
  $('body').on('change','.change-status',function(){
    if($(this).is(":checked")){
      $('#save-button-confirm').data('id',$(this).data('id'));
      $('#confirmModal').modal('show');
    }
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

  // var timer = setInterval(function(){
  //   loadEvents(params);
  // },10000);
});
//funciones
function loadEvents(params){
  _table.ajax.reload();
}
