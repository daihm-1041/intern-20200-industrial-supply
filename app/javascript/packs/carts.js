'use strict';
var csrf_token = $('meta[name="csrf-token"]').attr('content');
$(".add-cart").click(function(){
    let product_id = $(this).attr("data-product-id");
    $.ajax({
      url: '/carts',
      type: 'POST',
      headers: {
        'X-CSRF-Token': csrf_token,
      },
      data: 'product_id=' + product_id + '&option=inc',
      success: function (data) {
        $('.length-cart').html(data.sessions_length);
        $('.toast').toast('show');
      }
    });
  });

  $(".update-cart .dec").click(function(){
    let product_id = $(this).parent().attr("data-product-id");
    let quantity = parseInt($(this).parent().find("input").val()) - 1;
    $.ajax({
      url: 'carts',
      type: 'POST',
      headers: {
        'X-CSRF-Token': csrf_token,
      },
      data: 'product_id=' + product_id + '&option=dec',
      success: function (data) {
        $("#quantity-product-id-" + product_id).text(data.total_item + ' VNĐ');
        $("#total").text(data.total + ' VNĐ');
        $(".length-cart").text(data.sessions_length);
        if (data.total_item == 0){
          $("#row-product-id-" + product_id).remove();
        }
      }
    });
  });

  $(".delete-cart-item").click(function(){
    let product_id = $(this).attr("data-product-id");
    $.ajax({
      url: 'carts',
      type: 'POST',
      headers: {
        'X-CSRF-Token': csrf_token,
      },
      data: 'product_id=' + product_id + '&option=del',
      success: function (data) {
        $("#total").text(data.total + ' VNĐ');
        $(".length-cart").text(data.sessions_length);
        $("#row-product-id-" + product_id).remove();
        if (!data.total || data.total == 0) {
          $("#checkout-btn").remove();
        }
      }
    });
  });
