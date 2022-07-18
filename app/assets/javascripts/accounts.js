"use strict";
var KTModalNewTarget=function(){
    var t,e,n,a,o,i;
    return{
        init:function()
        {
            (i=document.querySelector("#kt_modal_new_target"))&&
            (
                o=new bootstrap.Modal(i),
                a=document.querySelector("#kt_modal_new_target_form"),
                t=document.getElementById("kt_modal_new_target_submit"),
                e=document.getElementById("kt_modal_new_target_cancel"),
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
                //$(a.querySelector('[name="due_date"]')).flatpickr({enableTime:!0,dateFormat:"d, M Y, H:i"}),
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
                t.addEventListener("click",(function(e){
                    e.preventDefault(),
                    n&&n.validate().then((function(e){
                        var elements = new FormData($('#kt_modal_new_target_form')[0]);
                        console.log("validated!"),
                        "Valid"==e?(
                            $.ajax({
                                type: "POST",
                                url: "/accounts",
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
                                    if (response !== null && response.hasOwnProperty("Errors")) {
                                        //console.log(response['Errors']);
                                        var obj = response["Errors"];
                                        var stringerror = '';
                                        for (var prop in obj) {
                                            stringerror += '* ' + obj[prop] + '</br>';
                                        }
                                        Swal.fire({
                                            text:stringerror,
                                            icon:"error",buttonsStyling:!1,
                                            confirmButtonText: window.I18n['ok_got_it'],
                                            customClass:{
                                                confirmButton:"btn btn-primary"
                                            }
                                        });
                                    } else if (response !== null && response.hasOwnProperty("Success")) {
                                        var msg = response["result"];
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
                                            window.location= "/accounts"
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
                }))
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
                            console.log(node);
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
KTUtil.onDOMContentLoaded((function(){
    KTModalNewTarget.init()
}));