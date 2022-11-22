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
                        code:{
                            validators:{
                                notEmpty:{
                                    message:"رقم المركز مطلوب"
                                }
                            }
                        },
                        name_ar:{
                            validators:{
                                notEmpty:{
                                    message:"اسم المركز مطلوب"
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
                                url: "/cost_centers",
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
                                            window.location= "/cost_centers"
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
                            return '/cost_centers.json'; // Demo API endpoint -- Replace this URL with your set endpoint
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

var KTDatatablesServerSide = function () {
    // Shared variables
    var table;
    var dt;
    var filterPayment;

    // Private functions
    var initDatatable = function () {
        dt = $("#kt_table_users").DataTable({
            searchDelay: 500,
            processing: true,
            serverSide: true,
            order: [[1, 'asc']],
            stateSave: true,
          
            ajax: {
                'url': "/cost_centers/get_datatable",
                "data": function ( d ) {
                    d.account_id = $('[data-kt-user-table-filter="account_id"]').val();
                    d.level = $('[data-kt-user-table-filter="level"]').val();
                    d.from_date = $('[data-kt-user-table-filter="from_date"]').val();
                    d.to_date = $('[data-kt-user-table-filter="to_date"]').val();
                    d.main_accounts = $('[data-kt-user-table-filter="main_accounts"]').is(":checked");
                }
            },            
            columns: [
                { data: 'accountNumber' },
                { data: 'nameAr' },
                { data: 'debit' },
                { data: 'credit' },
                { data: 'total_debit' },
                { data: 'total_credit' },
                { data: 'debit_balance' },
                { data: 'credit_balance' },
            ],
            columnDefs: [
               
            ],
            // Add data-filter attribute
            createdRow: function (row, data, dataIndex) {
                $(row).find('td:eq(4)').attr('data-filter', data.CreditCardType);
            }
        });

        table = dt.$;

        // Re-init functions on every table re-draw -- more info: https://datatables.net/reference/event/draw
        dt.on('draw', function () {
            initToggleToolbar();
            toggleToolbars();
            handleDeleteRows();
            KTMenu.createInstances();
        });
    }

    // Search Datatable --- official docs reference: https://datatables.net/reference/api/search()
    var handleSearchDatatable = function () {
        const filterSearch = document.querySelector('[data-kt-user-table-filter="search"]');
        filterSearch.addEventListener('keyup', function (e) {
            dt.search(e.target.value).draw();
        });
    }

    // Filter Datatable
    var handleFilterDatatable = () => {

        const t=document.getElementById("kt_modal_new_target"),
        n=new bootstrap.Modal(t);
        // // Select filter options
        var DisplayNumber = $('[data-kt-user-table-filter="display_number"]'); 
        var DisplayName = $('[data-kt-user-table-filter="display_name"]'); 

        const filterButton = document.querySelector('[data-kt-user-table-filter="filter"]');

        // // Filter datatable on submit
        filterButton.addEventListener('click', function () {

            if(DisplayNumber.is(":checked")){
                dt.column(0).visible(true);
            }else{
                dt.column(0).visible(false);
            }
            if(DisplayName.is(":checked")){
                dt.column(1).visible(true);
            }else{
                dt.column(1).visible(false);
            }
            dt.draw();
            n.hide();
            

        });

        document.querySelector('[data-kt-user-table-filter="reset"]').addEventListener("click",(function(){
            document.querySelector('[data-kt-user-table-filter="form"]').querySelectorAll("select").forEach((e=>{$(e).val("").trigger("change")})),
            dt.search("").draw();
            n.hide();
        }));
    }

    // Delete customer
    var handleDeleteRows = () => {
        // Select all delete buttons
        const deleteButtons = document.querySelectorAll('[data-kt-user-table-filter="delete_row"]');

        deleteButtons.forEach(d => {
            // Delete button on click
            d.addEventListener('click', function (e) {
                e.preventDefault();

                // Select parent row
                const parent = e.target.closest('tr');

                // Get customer name
                const customerName = parent.querySelectorAll('td')[1].innerText;

                // SweetAlert2 pop up --- official docs reference: https://sweetalert2.github.io/
                Swal.fire({
                    text: "Are you sure you want to delete " + customerName + "?",
                    icon: "warning",
                    showCancelButton: true,
                    buttonsStyling: false,
                    confirmButtonText: "Yes, delete!",
                    cancelButtonText: "No, cancel",
                    customClass: {
                        confirmButton: "btn fw-bold btn-danger",
                        cancelButton: "btn fw-bold btn-active-light-primary"
                    }
                }).then(function (result) {
                    if (result.value) {
                        // Simulate delete request -- for demo purpose only
                        Swal.fire({
                            text: "Deleting " + customerName,
                            icon: "info",
                            buttonsStyling: false,
                            showConfirmButton: false,
                            timer: 2000
                        }).then(function () {
                            Swal.fire({
                                text: "You have deleted " + customerName + "!.",
                                icon: "success",
                                buttonsStyling: false,
                                confirmButtonText: "Ok, got it!",
                                customClass: {
                                    confirmButton: "btn fw-bold btn-primary",
                                }
                            }).then(function () {
                                // delete row data from server and re-draw datatable
                                dt.draw();
                            });
                        });
                    } else if (result.dismiss === 'cancel') {
                        Swal.fire({
                            text: customerName + " was not deleted.",
                            icon: "error",
                            buttonsStyling: false,
                            confirmButtonText: "Ok, got it!",
                            customClass: {
                                confirmButton: "btn fw-bold btn-primary",
                            }
                        });
                    }
                });
            })
        });
    }

    // Reset Filter
    var handleResetForm = () => {
       
    }

    // Init toggle toolbar
    var initToggleToolbar = function () {
        // Toggle selected action toolbar
        // Select all checkboxes
        const container = document.querySelector('#draw_trial_balance');
        //const checkboxes = container.querySelectorAll('[type="checkbox"]');

        // Select elements
        const deleteSelected = document.querySelector('[data-kt-user-table-select="delete_selected"]');

        // Deleted selected rows
        deleteSelected.addEventListener('click', function () {
            // SweetAlert2 pop up --- official docs reference: https://sweetalert2.github.io/
            Swal.fire({
                text: "Are you sure you want to delete selected customers?",
                icon: "warning",
                showCancelButton: true,
                buttonsStyling: false,
                showLoaderOnConfirm: true,
                confirmButtonText: "Yes, delete!",
                cancelButtonText: "No, cancel",
                customClass: {
                    confirmButton: "btn fw-bold btn-danger",
                    cancelButton: "btn fw-bold btn-active-light-primary"
                },
            }).then(function (result) {
                if (result.value) {
                    // Simulate delete request -- for demo purpose only
                    Swal.fire({
                        text: "Deleting selected customers",
                        icon: "info",
                        buttonsStyling: false,
                        showConfirmButton: false,
                        timer: 2000
                    }).then(function () {
                        Swal.fire({
                            text: "You have deleted all selected customers!.",
                            icon: "success",
                            buttonsStyling: false,
                            confirmButtonText: "Ok, got it!",
                            customClass: {
                                confirmButton: "btn fw-bold btn-primary",
                            }
                        }).then(function () {
                            // delete row data from server and re-draw datatable
                            dt.draw();
                        });

                        // Remove header checked box
                        const headerCheckbox = container.querySelectorAll('[type="checkbox"]')[0];
                        headerCheckbox.checked = false;
                    });
                } else if (result.dismiss === 'cancel') {
                    Swal.fire({
                        text: "Selected customers was not deleted.",
                        icon: "error",
                        buttonsStyling: false,
                        confirmButtonText: "Ok, got it!",
                        customClass: {
                            confirmButton: "btn fw-bold btn-primary",
                        }
                    });
                }
            });
        });
    }

    // Toggle toolbars
    var toggleToolbars = function () {
        // Define variables
        const container = document.querySelector('#draw_trial_balance');
        const toolbarBase = document.querySelector('[data-kt-user-table-toolbar="base"]');
        const toolbarSelected = document.querySelector('[data-kt-user-table-toolbar="selected"]');
        const selectedCount = document.querySelector('[data-kt-user-table-select="selected_count"]');
    }

    // Public methods
    return {
        init: function () {
            initDatatable();
            handleSearchDatatable();
            initToggleToolbar();
            handleFilterDatatable();
            handleDeleteRows();
            handleResetForm();
        }
    }
}();
KTUtil.onDOMContentLoaded((function(){
    if(window.location.href == "http://localhost:3000/cost_centers/trial_balance"){
        KTDatatablesServerSide.init()
    }else{
        KTModalNewTarget.init()
    }
}));