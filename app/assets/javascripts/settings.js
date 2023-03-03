"use strict";
var KTCreateAccount=function(){
    var e,t,i,o,s,r,a=[];
    return{
        init:function(){
            (e=document.querySelector("#kt_modal_create_account"))&&
            new bootstrap.Modal(e),
            t=document.querySelector("#kt_create_account_stepper"),
            i=t.querySelector("#kt_create_account_form"),
            o=t.querySelector('[data-kt-stepper-action="submit"]'),
            s=t.querySelector('[data-kt-stepper-action="next"]'),
            (r=new KTStepper(t)).on("kt.stepper.changed",(
                function(e){
                    2===r.getCurrentStepIndex()?(
                        o.classList.remove("d-none"),
                        o.classList.add("d-inline-block"),
                        s.classList.add("d-none")
                    )
                    :3===r.getCurrentStepIndex()?(
                        o.classList.add("d-none"),
                        s.classList.add("d-none")
                    )
                    :(
                        o.classList.remove("d-inline-block"),
                        o.classList.remove("d-none"),
                        s.classList.remove("d-none")
                    )
                }
            )),
            r.on("kt.stepper.next",(function(e){
                console.log("stepper.next");
                var t=a[e.getCurrentStepIndex()-1];
                t?t.validate().then((function(t){
                    console.log("validated!"),
                    "Valid"==t?(
                        e.goNext(),
                        KTUtil.scrollTop()
                    )
                    :Swal.fire({
                        text:"عفوا, يبدو أن هناك بعض الأخطاء , حاول مرة أخرى",
                        icon:"error",
                        buttonsStyling:!1,
                        confirmButtonText:"حسنا",
                        customClass:{
                            confirmButton:"btn btn-light"
                        }
                    })
                    .then((function(){
                        KTUtil.scrollTop()
                    }))
                }))
                :(e.goNext(),KTUtil.scrollTop())
            })),
            r.on("kt.stepper.previous",(function(e){
                console.log("stepper.previous"),
                e.goPrevious(),KTUtil.scrollTop()
            })),
            a.push(FormValidation.formValidation(i,{
                fields:{
                    company_name:{
                        validators:{
                            notEmpty:{
                                message:"اسم الشركة مطلوب"
                            }
                        }
                    },
                    // company_logo:{
                    //     validators:{
                    //         notEmpty:{
                    //             message:"اللوجو مطلوب"
                    //         }
                    //     }
                    // },
                    default_language:{
                        validators:{
                            notEmpty:{
                                message:"اللغة الافتراضية مطلوبة"
                            }
                        }
                    },
                    default_currency:{
                        validators:{
                            notEmpty:{
                                message:"العملة الافتراضية مطلوبة"
                            }
                        }
                    },
                    mobile:{
                        validators:{
                            notEmpty:{
                                message:"رقم الجوال مطلوب"
                            },
                            digits:{
                                message:"يجب أن يحتوى على أرقام فقط"
                            },
                            stringLength:{
                                min:10,
                                max:15,
                                message:"لا يقل عن 10 ولا يزيد عن 15"
                            }
                        }
                    },
                    email:{
                        validators:{
                            notEmpty:{
                                message:"البريد الإلكترونى مطلوب"
                            },
                            emailAddress:{
                                message:"The value is not a valid email address"
                            }
                        }
                    }
                },
                plugins:{
                    trigger:new FormValidation.plugins.Trigger,
                    bootstrap:new FormValidation.plugins.Bootstrap5({
                        rowSelector:".fv-row",
                        eleInvalidClass:"",
                        eleValidClass:""
                    })
                }
            })),
            a.push(FormValidation.formValidation(i,{
                fields:{
                    fiscal_year_start:{
                        validators:{
                            notEmpty:{
                                message:"بداية السنة المالية مطلوب"
                            }
                        }
                    },
                    fiscal_year_end:{
                        validators:{
                            notEmpty:{
                                message:"نهاية السنة المالية مطلوب"
                            }
                        }
                    }
                },
                plugins:{
                    trigger:new FormValidation.plugins.Trigger,
                    bootstrap:new FormValidation.plugins.Bootstrap5({
                        rowSelector:".fv-row",
                        eleInvalidClass:"",
                        eleValidClass:""
                    })
                }
            })),
            // a.push(FormValidation.formValidation(i,{
            //     fields:{
            //         business_name:{
            //             validators:{
            //                 notEmpty:{
            //                     message:"Busines name is required"
            //                 }
            //             }
            //         },
            //     },
            //     plugins:{
            //         trigger:new FormValidation.plugins.Trigger,
            //         bootstrap:new FormValidation.plugins.Bootstrap5({
            //             rowSelector:".fv-row",
            //             eleInvalidClass:"",
            //             eleValidClass:""
            //         })
            //     }
            // })),
            // a.push(FormValidation.formValidation(i,{
            //     fields:{
            //         card_number:{
            //             validators:{
            //                 notEmpty:{
            //                     message:"Card member is required"
            //                 },
            //                 creditCard:{
            //                     message:"Card number is not valid"
            //                 }
            //             }
            //         }
            //     },
            //     plugins:{
            //         trigger:new FormValidation.plugins.Trigger,
            //         bootstrap:new FormValidation.plugins.Bootstrap5({
            //             rowSelector:".fv-row",
            //             eleInvalidClass:"",eleValidClass:""
            //         })
            //     }
            // })),
            o.addEventListener("click",(function(e){
                a[1].validate().then((function(t){
                    console.log("validated!");
                    var elements = new FormData($('#kt_create_account_form')[0]);
                    "Valid"==t?(
                        $.ajax({
                            type: 'POST',
                            url: '/settings',
                            data: elements,
                            //async: false,
                            cache: false,
                            contentType: false,
                            processData: false,
                            dataType: "JSON",
                            beforeSend: function (xhr) {
                                e.preventDefault();
                                o.disabled=!0;
                                o.setAttribute("data-kt-indicator","on");
                                xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
                            },
                            complete: function () {
                                o.removeAttribute("data-kt-indicator"),
                                o.disabled=!1,
                                r.goNext()
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
                                    Swal.fire({
                                        text:msg,
                                        icon:"success",
                                        buttonsStyling:!1,
                                        confirmButtonText: window.I18n['ok_got_it'],
                                        customClass:{
                                            confirmButton:"btn btn-primary"
                                        }
                                    }).then((function(e){
                                        window.location= "/settings"
                                    }))
                                }
                            }
                        }) 
                                
                    )
                    :Swal.fire({
                        text:"عفوا, يبدو أن هناك بعض الأخطاء , حاول مرة أخرى",
                        icon:"error",
                        buttonsStyling:!1,
                        confirmButtonText:"حسنا!",
                        customClass:{confirmButton:"btn btn-light"}
                    })
                    .then((function(){
                        KTUtil.scrollTop()
                    }))
                }))
            })),
            $(i.querySelector('[name="fiscal_year_start"]')).flatpickr({enableTime:0,dateFormat:"Y-m-d"}),
            $(i.querySelector('[name="fiscal_year_end"]')).flatpickr({enableTime:0,dateFormat:"Y-m-d"}),

            $(i.querySelector('[name="card_expiry_month"]')).on("change",(function(){
                a[3].revalidateField("card_expiry_month")
            })),
            $(i.querySelector('[name="card_expiry_year"]')).on("change",(function(){
                a[3].revalidateField("card_expiry_year")
            })),
            $(i.querySelector('[name="business_type"]')).on("change",(function(){
                a[2].revalidateField("business_type")
            }))
        }
    }
}();
KTUtil.onDOMContentLoaded((function(){KTCreateAccount.init()}));