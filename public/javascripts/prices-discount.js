
function chkfield(field) {
  var str = field.value;
  var re = /[^0-9^\.]/g;
  str = str.replace (",", ".");
  var newstr = str.replace (re, "");
  field.value = newstr;
}

function calcDiscount() {
  var retail_price = ge('item_retail_price').value;
  var price = ge('item_price').value;
  if (is_numeric(retail_price) && is_numeric(price)) {
    var discount = 0;
    // discount = 100 - round_decimals((Math.round((price*100/retail_price)*100)/100), 0);
    discount = 100 - Math.round(price*100/retail_price);
    ge('item_discount').value = discount;
  } else {
    ge('item_discount').value = "";
  }
}
    
function calcPrice() {
  var retail_price = ge('item_retail_price').value;
  var discount = ge('item_discount').value;
  if (is_numeric(retail_price) && is_numeric(discount)) {
    var percent = 0;
    // price = retail_price - round_decimals((Math.round((discount*retail_price/100)*100)/100), 0);
    price = retail_price - Math.round(discount*retail_price/100);
    ge('item_price').value = price;
  } else {
    if (is_numeric(retail_price)) {
      ge('item_price').value = retail_price;
    } else {
      ge('item_price').value = "";
    }
  }
}


function resetPrices() {
  ge('item_price').value = ge('item_retail_price').value;
  ge('item_discount').value = '';
}

    
// function round_decimals(original_number, decimals){
//   var result1 = original_number * Math.pow(10, decimals);
//   var result2 = Math.round(result1);
//   var result3 = result2 / Math.pow(10, decimals);
//   return pad_with_zeros(result3, decimals);
// }

// function pad_with_zeros(rounded_value, decimal_places)
// {
//   // Convert the number to a string
//   var value_string = rounded_value.toString();
// 
//   // Locate the decimal point
//   var decimal_location = value_string.indexOf(".");
// 
//   // Is there a decimal point?
//   if (decimal_location == -1) {
//     // If no, then all decimal places will be padded with 0s
//     decimal_part_length = 0
// 
//     // If decimal_places is greater than zero, tack on a decimal point
//     value_string += decimal_places > 0 ? "." : "";
//   }
//   else {
//     // If yes, then only the extra decimal places will be padded with 0s
//     decimal_part_length = value_string.length - decimal_location - 1;
//   }
// 
//   // Calculate the number of decimal places that need to be padded with 0s
//   var pad_total = decimal_places - decimal_part_length;
// 
//   if (pad_total > 0) {
//     // Pad the string with 0s
//     for ( var counter = 1; counter <= pad_total; counter++ ) {
//       value_string += "0";
//     }
//   }
// 
//   return value_string;
// }
