// require datatables/jquery.dataTables.min

"use strict";

// Class definition
var KTDatatablesServerSide = function () {
    // Shared variables
    var t,e,n,a,o,i;
    var table;
    var dt;
    // Private functions
    var initDatatable = function () {
        dt = $("#kt_table_users").DataTable({
            searchDelay: 500,
            processing: true,
            serverSide: true,
            order: [[1, 'asc']],
            stateSave: true,
            ajax: {
                'url': "/draw_currencies",
                "data": function ( d ) {
                   
                }
            },            
            columns: [
                { data: 'currencyCode' },
                { data: 'name' },
                { data: 'rate' },
                { data: 'nameAr' },
                { data: 'updatedDate' },
                { data: 'actions'},
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
    };

    $(document).on("click",".edit_item",function(e) {
        var details =  $(this).data('details');
        console.log(details);
        $('#currency_id').val(details["id"]);
        $('#currency_name_ar').val(details["name_ar"]);
        $('#currency_name_en').val(details["name_en"]);
        $('#currency_code').val(details["code"]);
        $('#currency_rate').val(details["rate"]);
        $('#currency_status').attr('checked', details["status"] );             
    });

    $(document).on("click","#add_item",function(e) {
        document.querySelector("#kt_modal_add_permission_form").reset();
    });

    var handleValidations = function(){
        (i=document.querySelector("#kt_modal_add_permission"))&&
            (
                o=new bootstrap.Modal(i),
                a=document.querySelector("#kt_modal_add_permission_form"),
                t=document.getElementById("kt_modal_add_permission_submit"),
                e=document.getElementById("kt_modal_add_permission_cancel"),
                n=FormValidation.formValidation(a,{
                    fields:{
                        'currency[name_ar]':{
                            validators:{
                                notEmpty:{
                                    message:"الاسم العربى مطلوب"
                                }
                            }
                        },
                        'currency[name_en]':{
                            validators:{
                                notEmpty:{
                                    message:"الاسم اللاتينى مطلوب"
                                }
                            }
                        },
                        'currency[code]':{
                            validators:{
                                notEmpty:{
                                    message:"الرمز مطلوب"
                                }
                            }
                        },
                        'currency[rate]':{
                            validators:{
                                notEmpty:{
                                    message:"المعدل مطلوب"
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
                }),
                t.addEventListener("click",(function(e){
                    e.preventDefault(),
                    n&&n.validate().then((function(e){
                        var elements = new FormData($('#kt_modal_add_permission_form')[0]);
                        var item_id = $("#currency_id").val();
                        var url = "/currencies";
                        var type = "POST";
                        if(item_id != ""){
                            var url = "/currencies/" + item_id;
                            var type = "PUT";
                        }
                        console.log("validated!"),
                        "Valid"==e?(
                            $.ajax({
                                type: type,
                                url: url,
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
                                            //t.isConfirmed&&
                                            a.reset(),
                                            dt.draw(),
                                            o.hide()
                                            //window.location= "/currencies"
                                        }))
                                    }
                                }
                            }) 
                        )
                        :Swal.fire({
                            text:"Sorry, looks like there are some errors detected, please try again.",
                            icon:"error",
                            buttonsStyling:!1,
                            confirmButtonText:"حسنا",
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
    }

    // Search Datatable --- official docs reference: https://datatables.net/reference/api/search()
    var handleSearchDatatable = function () {
        const filterSearch = document.querySelector('[data-kt-user-table-filter="search"]');
        filterSearch.addEventListener('keyup', function (e) {
            dt.search(e.target.value).draw();
        });
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
            handleValidations();
            handleSearchDatatable();
            initToggleToolbar();
            handleDeleteRows();
            handleResetForm();
        }
    }

    

}();

// On document ready
KTUtil.onDOMContentLoaded(function () {
    KTDatatablesServerSide.init();
});