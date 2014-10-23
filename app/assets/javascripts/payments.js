$(function() {
  var stripeResponseHandler, $cardForm;

  $cardForm = $('#card-details');
  stripeResponseHandler = function(status, response) {
    if (response.error) {
      $cardForm.find('.payment-errors').text(response.error.message);
      $cardForm.find('input[type=submit]').prop('disabled', false);
    } else {
      var token = response.id;

      $cardForm.append($('<input type="hidden" name="stripe_token" />').val(token));
      $cardForm.get(0).submit();
    }
  };

  $cardForm.submit(function() {
    Stripe.card.createToken(this, stripeResponseHandler);

    return false;
  });
});
