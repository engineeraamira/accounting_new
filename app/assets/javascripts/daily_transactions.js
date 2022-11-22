"use strict";
var KTModalNewTarget=function(){
    var t,e,n,a,o,i;
    var dateFields = document.getElementsByClassName("select_date");
    var accountFields = document.getElementsByClassName("select-account");
    
    function TotalDebitCredit(){
        var total_debit = 0;
        var total_credit = 0;
        for (var j = 0; j < 100; j++) {
            var accountInput = $(accountFields[j]);
            if (accountInput.val() != ""){
                var rowId = accountInput.attr('row-id');
                var total_debit_input =  $('[name="details[debit_' + rowId + ']"]');
                if (total_debit_input.val() != ""){
                    total_debit += parseFloat(total_debit_input.val());
                }
                var total_credit_input =  $('[name="details[credit_' + rowId + ']"]');
                if (total_credit_input.val() != ""){
                    total_credit += parseFloat(total_credit_input.val());
                }
            }
        };
        $("#total_debit").val(total_debit);
        $("#total_credit").val(total_credit);
        if(total_debit > total_credit){
            $("#debit_diff").val(total_debit - total_credit);
        }else{
            $("#debit_diff").val(0);
        }
        if(total_credit > total_debit){
            $("#credit_diff").val(total_credit - total_debit);
        }else{
            $("#credit_diff").val(0);
        }
    }

    function setFormDetails(current_trans,type){
        $.ajax({
            type: "POST",
            url: "/transaction_details",
            data: {current_trans_id: current_trans, type: type},
            dataType: "JSON",
            beforeSend: function (xhr) {
                xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
            },
            complete: function () {
                
            },
            success: function (response)
            {
                //console.log(response);
                if (response !== null && response["status"] == false) {
                    //console.log(response['Errors']);
                    var obj = response["message"];
                    
                    
                } else if (response !== null && response["status"] == true) {
                    var details = response["result"];
                    var items = details.items;
                    $(':input','#kt_modal_upgrade_plan_form').not(':button, :submit, :reset').val('').prop('checked', false).prop('selected', false).trigger("change");
                    //$(':input','#kt_modal_upgrade_plan_form').not(':button, :submit, :reset').removeAttr('selected').not('select').val('');
                    //$('#kt_modal_upgrade_plan_form')[0].reset();
                    $("#id").val(details.id);
                    $("#trans_date").val(details.trans_date);
                    $("#posted_date").val(details.posted_date);
                    $("#description").val(details.description);
                    $("#total_debit").val(details.total_debit);
                    $("#total_credit").val(details.total_credit);
                    if(details.difference > 0){
                        $("#debit_diff").val(details.difference);
                        $("#credit_diff").val(0);
                    }else{
                        $("#debit_diff").val(0);
                        $("#credit_diff").val(Math.abs(details.difference));
                    }
                    
                    for (i = 0; i < items.length; ++i) {
                        $('[name="details[id_' + items[i][0] + ']"]').val(items[i][1]);
                        $('[name="details[accountname_' + items[i][0] + ']"]').val(items[i][3]);
                        $('[name="details[account_id_' + items[i][0] + ']"]').val(items[i][2]);
                        $('[name="details[description_' + items[i][0] + ']"]').val(items[i][5]);
                        $('[name="details[debit_' + items[i][0] + ']"]').val(items[i][6]);
                        $('[name="details[credit_' + items[i][0] + ']"]').val(items[i][7]);
                        $('[name="details[item_date_' + items[i][0] + ']"]').val(items[i][8]);
                        //$('[name="details[cost_center_id_' + items[i][0] + ']"]').val(items[i][9]);
                        $('[name="details[cost_center_id_' + items[i][0] + ']"]').val(items[i][9]).change();
                        $('[name="details[currency_id_' + items[i][0] + ']"]').val(items[i][4]).change();
                    }                  
                }
            }
        })
    }

    return{
        init:function()
        {
           
            for (var i = 0; i < 100; i++) {
                dateFields.item(i).flatpickr({
                    enableTime:0,
                    dateFormat:"Y-m-d"
                });
            };
            $(".debit").change(function(){
                TotalDebitCredit();
            });
            $(".credit").change(function(){
                TotalDebitCredit();
            });
            $(".select-account").change(function(){
                TotalDebitCredit();
            });
            (i=document.querySelector("#kt_modal_upgrade_plan"))&&
            (
                o=new bootstrap.Modal(i),
                a=document.querySelector("#kt_modal_upgrade_plan_form"),
                t=document.getElementById("kt_modal_upgrade_plan_submit"),
                e=document.getElementById("kt_modal_upgrade_plan_cancel"),
                // new Tagify(a.querySelector('[name="tags"]'),{
                //     whitelist:["Important","Urgent","High","Medium","Low"],
                //     maxTags:5,
                //     dropdown:{
                //         maxItems:10,
                //         enabled:0,
                //         closeOnSelect:!1
                //     }
                // }).on("change",(function(){
                //     n.revalidateField("tags")
                // })),
                // $(a.querySelector('[name="trans_date"]')).flatpickr({
                //     enableTime:0,
                //     dateFormat:"Y-m-d"
                // }),
                
                // $(a.querySelector('.select_date')).flatpickr({
                //     enableTime:0,
                //     dateFormat:"Y-m-d"
                // }),
                
                //$(a.querySelector('[name="team_assign"]')).on("change",(function(){n.revalidateField("team_assign")})),
                n=FormValidation.formValidation(a,{
                    fields:{
                        account_number:{
                            validators:{
                                notEmpty:{
                                    message:"رقم الحساب مطلوب"
                                }
                            }
                        },
                        account_type:{
                            validators:{
                                notEmpty:{
                                    message:"نوع الحساب مطلوب"
                                }
                            }
                        },
                        name_ar:{
                            validators:{
                                notEmpty:{
                                    message:"اسم الحساب مطلوب"
                                }
                            }
                        },
                        name_en:{
                            validators:{
                                notEmpty:{
                                    message:"الاسم اللاتينى مطلوب"
                                }
                            }
                        }
                        // "targets_notifications[]":{
                        //     validators:{
                        //         notEmpty:{
                        //             message:"Please select at least one communication method"
                        //         }
                        //     }
                        // }
                    },
                    plugins:{
                        trigger:new FormValidation.plugins.Trigger,
                        bootstrap:new FormValidation.plugins.Bootstrap5({
                            rowSelector:".fv-row",
                            eleInvalidClass:"",
                            eleValidClass:""
                        })
                    }
                }),
                document.getElementById("kt_modal_users_search_submit").addEventListener("click",(function(e){
                    e.preventDefault();
                    var checked_Account = $("input:radio[name='suggestion_accounts']:checked");
                    var checked_account_id = checked_Account.val();
                    var checked_account_name = checked_Account.attr('account-name');

                    //console.log(checked_Account),
                    checked_Account!=''?(
                        $("input:text[name='" + account_input + "']").val(checked_account_name),
                        $("input:hidden[name='details[account_id_" + row_id + "]']").val(checked_account_id),
                        $("#kt_modal_users_search").modal('hide'),
                        TotalDebitCredit()
                    )
                    :Swal.fire({
                        text:"Sorry, looks like there are some errors detected, please try again.",
                        icon:"error",
                        buttonsStyling:!1,
                        confirmButtonText:"Ok, got it!",
                        customClass:{
                            confirmButton:"btn btn-primary"
                        }
                    })
                    
                })),
                e.addEventListener("click",(function(t){
                    t.preventDefault(),
                    Swal.fire({
                        text:"Are you sure you would like to cancel?",
                        icon:"warning",
                        showCancelButton:!0,
                        buttonsStyling:!1,
                        confirmButtonText:"Yes, cancel it!",
                        cancelButtonText:"No, return",
                        customClass:{
                            confirmButton:"btn btn-primary",
                            cancelButton:"btn btn-active-light"
                        }
                    }).then((function(t){
                        t.value?(a.reset(),o.hide()):
                        "cancel"===t.dismiss&&Swal.fire({
                            text:"Your form has not been cancelled!.",
                            icon:"error",
                            buttonsStyling:!1,
                            confirmButtonText:"Ok, got it!",
                            customClass:{
                                confirmButton:"btn btn-primary"
                            }
                        })
                    }))
                })),
                t.addEventListener("click",(function(e){
                    e.preventDefault(),
                    n&&n.validate().then((function(e){
                        var elements = new FormData($('#kt_modal_upgrade_plan_form')[0]);
                        //console.log("validated!"),
                        "Valid"==e?(
                            $.ajax({
                                type: "POST",
                                url: "/daily_transactions",
                                data: elements,
                                //async: false,
                                cache: false,
                                contentType: false,
                                processData: false,
                                dataType: "JSON",
                                beforeSend: function (xhr) {
                                    xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
                                    t.setAttribute("data-kt-indicator","on");
                                    t.disabled=!0;
                                },
                                complete: function () {
                                    
                                },
                                success: function (response)
                                {
                                    console.log(response);
                                    if (response !== null && response["status"] == false) {
                                        //console.log(response['Errors']);
                                        var obj = response["message"];
                                        // var stringerror = '';
                                        // for (var prop in obj) {
                                        //     stringerror += '* ' + obj[prop] + '</br>';
                                        // }
                                        t.removeAttribute("data-kt-indicator"),
                                        t.disabled=!1,
                                        Swal.fire({
                                            text:obj,
                                            icon:"error",
                                            buttonsStyling:!1,
                                            confirmButtonText: window.I18n['ok_got_it'],
                                            customClass:{
                                                confirmButton:"btn btn-primary"
                                            }
                                        });
                                    } else if (response !== null && response["status"] == true) {
                                        var msg = response["message"];
                                        t.removeAttribute("data-kt-indicator"),
                                        t.disabled=!1,
                                        Swal.fire({
                                            text:msg,
                                            icon:"success",
                                            buttonsStyling:!1,
                                            confirmButtonText: window.I18n['ok_got_it'],
                                            customClass:{
                                                confirmButton:"btn btn-primary"
                                            }
                                        }).then((function(e){
                                            t.isConfirmed&&
                                            o.hide(),
                                            window.location= "/daily_transactions"
                                        }))
                                    }
                                }
                            }) 
                        )
                        :Swal.fire({
                            text:"Sorry, looks like there are some errors detected, please try again.",
                            icon:"error",
                            buttonsStyling:!1,
                            confirmButtonText:"Ok, got it!",
                            customClass:{
                                confirmButton:"btn btn-primary"
                            }
                        })
                    }))
                })),
                document.getElementById("prev_trans").addEventListener("click",(function(e){
                    e.preventDefault();
                    var current_trans = $("#id").val();
                    setFormDetails(current_trans,"previous");
                })),
                document.getElementById("next_trans").addEventListener("click",(function(e){
                    e.preventDefault();
                    var current_trans = $("#id").val();
                    setFormDetails(current_trans,"next");
                })),

                $('#prev_trans , #next_trans').hover(function() {
                    $(this).css('cursor','pointer');
                })
            )

            //tree
            $("#kt_docs_jstree_ajax").jstree({
                "core": {
                    "themes": {
                        "responsive": false
                    },
                    // so that create works
                    "check_callback": true,
                    'data': {
                        'url': function(node) {
                            return '/accounts_tree'; // Demo API endpoint -- Replace this URL with your set endpoint
                        },
                        'data': function(node) {
                            //console.log(node);
                            return {
                                'parent': node.id
                            };
                        }
                    }
                },
                "types": {
                    "default": {
                        "icon": "fa fa-folder text-primary"
                    },
                    "file": {
                        "icon": "fa fa-file  text-primary"
                    }
                },
                "state": {
                    "key": "demo3"
                },
                "plugins": ["dnd", "state", "types"]
            });
        }
    }
}();
var KTModalUserSearch=function(){
    var e,t,n,s,a,r=function(e){
        var search_input = $("#search_input").val();
        setTimeout((function(){
            var a=KTUtil.getRandomInt(1,1);
            $.ajax({
                type: "POST",
                url: "/search_accounts",
                data: {search: search_input},
                dataType: "JSON",
                beforeSend: function (xhr) {
                    xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
                    
                },
                complete: function () {
                    
                },
                success: function (response)
                {
                    if (response !== null && response["status"] == true) {
                        var suggested_accounts = response["result"];
                        //console.log(suggested_accounts);                        
                        if(suggested_accounts == ""){
                            n.classList.add("d-none"),
                            s.classList.remove("d-none")
                        }else{
                            $("#suggestions_area").html(suggested_accounts);
                            n.classList.remove("d-none"),
                            s.classList.add("d-none")
                        }
                    }
                }
            }) 


            //t.classList.add("d-none"),
            // 3===a?(
            //     n.classList.add("d-none"),
            //     s.classList.remove("d-none")
            // ):
            // (
            //     n.classList.remove("d-none"),
            //     s.classList.add("d-none")
            // ),
            e.complete()
        }),100)
    },
    o=function(e){
        //t.classList.remove("d-none"),
        n.classList.remove("d-none"),
        s.classList.add("d-none")
    };
    return{
        init:function(){
            $(".select-account").dblclick(function(){
                account_input = $(this).attr("name");
                row_id = $(this).attr("row-id");
                //console.log($(this).attr("name"));
                $("#kt_modal_users_search").modal('show');
            });
            (e=document.querySelector("#kt_modal_users_search_handler"))&&
            (
                e.querySelector('[data-kt-search-element="wrapper"]'),
                t=e.querySelector('[data-kt-search-element="suggestions"]'),
                n=e.querySelector('[data-kt-search-element="results"]'),
                s=e.querySelector('[data-kt-search-element="empty"]'),
                (a=new KTSearch(e)).on("kt.search.process",r),
                a.on("kt.search.clear",o)
            )
        }
    }
}();
KTUtil.onDOMContentLoaded((function(){
    KTModalNewTarget.init()
    KTModalUserSearch.init()
}));