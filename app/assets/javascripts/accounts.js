"use strict";
var KTModalNewTarget=function(){
    var t,e,n,a,o,i;

    function ShowTree(){
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

            ShowTree();

            var for_modal = document.querySelector("#kt_modal_upload");
            var upload_modal = new bootstrap.Modal(for_modal);


            (()=>{
                const e="#kt_modal_upload_dropzone",
                t=document.querySelector(e);
                var o=t.querySelector(".dropzone-item");
                o.id="";
                var n=o.parentNode.innerHTML;
                o.parentNode.removeChild(o);
                var r=new Dropzone(e,{
                    url:"/accounts/import",
                    parallelUploads:10,
                    previewTemplate:n,
                    maxFilesize:400,
                    timeout: 600000,
                    maxFiles: 1,
                    acceptedFiles: ".xls,.xlsx",
                    //autoProcessQueue:!1,
                    //autoQueue:!1,
                    previewsContainer:e+" .dropzone-items",
                    clickable:e+" .dropzone-select",
                    headers: {
                        'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                    },
                    init: function () {                       
                        this.on("error", function (file) {
                            if (file.size > 400*1024*1024) {
                                this.removeFile(file);
                                Swal.fire({
                                    text:"exeed_max_file_size",
                                    icon:"warning",
                                    showCancelButton:!0,
                                    buttonsStyling:!1,
                                    confirmButtonText:"Yes, cancel it!",
                                    cancelButtonText:"No, return",
                                    customClass:{
                                        confirmButton:"btn btn-primary",
                                        cancelButton:"btn btn-active-light"
                                    }
                                })
                            }  else{
                                var type = file.type;
                                //alert(type);
                                switch(type)  {
                                    case 'application/xlsx':
                                    case 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet':
                                    break;
                                    default:
                                        Swal.fire({
                                            text:"not_allowed_extension",
                                            icon:"warning",
                                            showCancelButton:!0,
                                            buttonsStyling:!1,
                                            confirmButtonText:"Yes, cancel it!",
                                            cancelButtonText:"No, return",
                                            customClass:{
                                                confirmButton:"btn btn-primary",
                                                cancelButton:"btn btn-active-light"
                                            }
                                        })
                                    this.removeFile(file);
                                    break;
                                } 
                            }                             
                        });
                        // this.on("complete", function(file) {
                        //     ShowTree();
                        //     this.removeFile(file);
                        // });
                        this.on("removedfile", function(file) {
                            //console.log(file); 
                        });
                    },
                });
                r.on("addedfile",(function(o){o.previewElement.querySelector(e+" .dropzone-start").onclick=function(){
                    const e=o.previewElement.querySelector(".progress-bar");
                    e.style.opacity="1";
                    var t=1,
                    n=setInterval((function(){
                        t>=100?(r.emit("success",o),r.emit("complete",o),clearInterval(n)):
                        (t++,e.style.width=t+"%")
                    }),20)
                },
                t.querySelectorAll(".dropzone-item").forEach((e=>{e.style.display=""})),
                t.querySelector(".dropzone-upload").style.display="inline-block",
                t.querySelector(".dropzone-remove-all").style.display="inline-block"})),
                r.on("complete",(function(e){
                    ShowTree();
                    upload_modal.hide();
                    //this.removeFile(file);
                    const o=t.querySelectorAll(".dz-complete");
                    setTimeout((function(){o.forEach((e=>{
                        e.querySelector(".progress-bar").style.opacity="0",
                        e.querySelector(".progress").style.opacity="0",
                        e.querySelector(".dropzone-start").style.opacity="0"
                    }))}),300)
                })),
                t.querySelector(".dropzone-upload").addEventListener("click",(function(){
                    r.files.forEach((e=>{
                        const t=e.previewElement.querySelector(".progress-bar");
                        t.style.opacity="1";
                        var o=1,
                        n=setInterval((function(){
                            o>=100?(
                                r.emit("success",e),
                                r.emit("complete",e),
                                clearInterval(n)
                            ):
                            (o++,t.style.width=o+"%")
                        }),20)
                    }))
                })),
                t.querySelector(".dropzone-remove-all").addEventListener("click",
                    (function(){
                        Swal.fire({
                            text:"Are you sure you would like to remove all files?",
                            icon:"warning",showCancelButton:!0,
                            buttonsStyling:!1,
                            confirmButtonText:"Yes, remove it!",
                            cancelButtonText:"No, return",
                            customClass:{
                                confirmButton:"btn btn-primary",
                                cancelButton:"btn btn-active-light"
                            }
                        })
                        .then((
                            function(e){
                                e.value?(t.querySelector(".dropzone-upload").style.display="none",
                                t.querySelector(".dropzone-remove-all").style.display="none",
                                r.removeAllFiles(!0)):"cancel"===e.dismiss&&Swal.fire({
                                    text:"Your files was not removed!.",
                                    icon:"error",
                                    buttonsStyling:!1,
                                    confirmButtonText:"Ok, got it!",
                                    customClass:{
                                        confirmButton:"btn btn-primary"
                                    }
                                })
                            }
                        ))
                    })
                ),
                r.on("queuecomplete",(function(e){t.querySelectorAll(".dropzone-upload").forEach((e=>{e.style.display="none"}))})),
                r.on("removedfile",(function(e){r.files.length<1&&(t.querySelector(".dropzone-upload").style.display="none",
                t.querySelector(".dropzone-remove-all").style.display="none")}))
            })()
        }
    }
}();
KTUtil.onDOMContentLoaded((function(){
    KTModalNewTarget.init()
}));