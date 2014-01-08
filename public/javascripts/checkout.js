// function setShipping(form, box)
// {
//   if(box.checked == true)
//   {
//     form.shipping_address_first_name.value    = form.billing_address_first_name.value;
//     form.shipping_address_last_name.value     = form.billing_address_last_name.value;
//     form.shipping_address_company.value       = form.billing_address_company.value;
//     form.shipping_address_address1.value      = form.billing_address_address1.value;
//     form.shipping_address_address2.value      = form.billing_address_address2.value;
//     form.shipping_address_city.value          = form.billing_address_city.value;    
//     form.shipping_address_state.selectedIndex = form.billing_address_state.selectedIndex;
//     form.shipping_address_zip.value           = form.billing_address_zip.value;
//     form.shipping_address_phone.value         = form.billing_address_phone.value;
//     form.shipping_address_fax.value           = form.billing_address_fax.value;
//   }
//   else
//   {
//     form.shipping_address_first_name.value    = '';
//     form.shipping_address_last_name.value     = '';
//     form.shipping_address_company.value       = '';
//     form.shipping_address_address1.value      = '';
//     form.shipping_address_address2.value      = '';
//     form.shipping_address_city.value          = '';    
//     form.shipping_address_state.selectedIndex = 0;
//     form.shipping_address_zip.value           = '';
//     form.shipping_address_phone.value         = '';
//     form.shipping_address_fax.value           = '';
//   }
// }

function changePaymentMethod(value)
{
  if (value == "credit_card") {
    jQuery('#credit_card_info').slideDown();
  }
  else {
    jQuery('#credit_card_info').slideUp();
  }
  jQuery.get("/checkout/update_payment_method", { payment_method: value }, null, "script");
}

function toggleShippingAddressTable(checked)
{
  if (checked) {
    jQuery('#shipping_info_data').slideUp();
  }
  else {
    jQuery('#shipping_info_data').slideDown();
  }
}














