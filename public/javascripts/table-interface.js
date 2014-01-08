


  function initTableInterface(tableId)
  {
    jQuery(document).ready(function() {
    
      //init click "check all"
      jQuery("#"+tableId+" :checkbox.checkAll").click (function() {
        if (jQuery("#"+tableId+" :checkbox.checkAll").attr("checked") == true)
          jQuery("#"+tableId+" tbody :checkbox").attr({ checked: true});
        else
          jQuery("#"+tableId+" tbody :checkbox").attr({ checked: false});
      })
      //init click other checkbox
      jQuery("#"+tableId+" :checkbox").not(".checkAll").click(function() {
        if (jQuery("#"+tableId+" tbody :checkbox:checked").length == jQuery("#"+tableId+" tbody :checkbox").length)
          jQuery("#"+tableId+" :checkbox.checkAll").attr({ checked: true});
        else
          jQuery("#"+tableId+" :checkbox.checkAll").attr({ checked: false});
      })
      
      //init remote ordering
      jQuery("#"+tableId+" th a").click (function() {
        jQuery.get(this.href, null, null, "script");
        return false;
      })
      
      //init remote deleting
      jQuery("#"+tableId+" .action-link.delete").click (function() {
        if (confirmSubmit()) {
          jQuery.get(this.href, null, null, "script");
        }
        return false;
      })
      
      //init remote pagination
      jQuery(".pagination a").click (function() {
        jQuery.get(this.href, null, null, "script");
        return false;
      })    
      
    });
  }
  
  function initProductFormFieldsForm() {
    jQuery(document).ready(function() {
      var control = "";
      var field_select = ge("form_field_field_id");
      
      jQuery("#form_div :radio").click (function() {
      
        if (this.value == "group" || this.value == "text_field" || this.value == "text_area") {
          control = this.value;
          jQuery("#tr_source").hide();
          field_select.options.length = 1;
          field_select.options[0].selected = true;
        }
        else if (this.value == "select" || this.value == "radio" || this.value == "multiple") {
          control = this.value;
          jQuery("#tr_source").show();
          field_select.options.length = 1;
          field_select.options[0].selected = true;
          
          for (var i=0; i<source_fields_json[control].length; i++) {
            var obj = source_fields_json[control][i].field;
            
            field_select.options[i+1] = new Option(obj['name'], obj['fid']);
            field_select.options[i+1].setAttribute('title', obj['name']);
            
          }
          selected_option_index = selected_option_index || 0;
          field_select.options[selected_option_index].selected = true;
          
        }
      });
      
      jQuery("#form_field_field_id").change (function() {
        if (control == "select" || control == "radio" || control == "multiple") {
          if (this[this.selectedIndex].value) {
            ge("form_field_name").value = this[this.selectedIndex].innerHTML;
          }
        }
      });

    });
  }
  
  
  //remote changing items per page
  function changePerPage(href, per_page)
  {
    jQuery.get(href, { per_page: per_page }, null, "script");
  }
  
  //remote searching by param
  function searchByParam(param_name, param_value, order_param_id)
  {
    data = {};
    data[param_name] = param_value
    
    order_param = jQuery("#"+order_param_id)[0];
    if (order_param)
      data[order_param.name] = order_param.value;
      
    jQuery.get(document.location.href, data, null, "script");
  }



