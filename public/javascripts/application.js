// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function ge(element_id) {
  return document.getElementById(element_id);
}

function confirmSubmit(msg) {
  var msg = msg || "Are you sure?";
  var agree = confirm(msg);
  if (agree) {
    return true;
  } else {
    return false;
  }
}

function is_numeric(input){
  return !isNaN(input) && input != "";
}

