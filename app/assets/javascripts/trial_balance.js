// require datatables/jquery.dataTables.min

// $(document).ready(function () {
//     if(window.location.href == "http://localhost:3000/trial_balance"){
//         $('#kt_table_users').DataTable({
//             ajax: '/draw_trial_balance',
//             paging: false,
//             ordering: false,
//             info: false,
//             searching: false,
//         });
//     }
// });


"use strict";

// Class definition
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
            // select: {
            //     style: 'multi',
            //     selector: 'td:first-child input[type="checkbox"]',
            //     className: 'row-selected'
            // },
            language: {
                "sInfo": "عرض" + " _START_ " + "إلي" + " _END_ " + "من" + " _TOTAL_ " ,
            },
            ajax: {
                'url': "/draw_trial_balance",
                "data": function ( d ) {
                    d.account_id = $('[data-kt-user-table-filter="account_id"]').val();
                    d.currency_id = $('[data-kt-user-table-filter="currency_id"]').val();
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
                // {
                //     targets: 0,
                //     orderable: false,
                //     render: function (data) {
                //         return `
                //             <div class="form-check form-check-sm form-check-custom form-check-solid">
                //                 <input class="form-check-input" type="checkbox" value="${data}" />
                //             </div>`;
                //     }
                // },
                // {
                //     targets: 4,
                //     render: function (data, type, row) {
                //         return `<img src="${hostUrl}media/svg/card-logos/${row.CreditCardType}.svg" class="w-35px me-3" alt="${row.CreditCardType}">` + data;
                //     }
                // },
                // {
                //     targets: -1,
                //     data: null,
                //     orderable: false,
                //     className: 'text-end',
                //     render: function (data, type, row) {
                //         return `
                //             <a href="#" class="btn btn-light btn-active-light-primary btn-sm" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end" data-kt-menu-flip="top-end">
                //                 Actions
                //                 <span class="svg-icon svg-icon-5 m-0">
                //                     <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="24px" height="24px" viewBox="0 0 24 24" version="1.1">
                //                         <g stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                //                             <polygon points="0 0 24 0 24 24 0 24"></polygon>
                //                             <path d="M6.70710678,15.7071068 C6.31658249,16.0976311 5.68341751,16.0976311 5.29289322,15.7071068 C4.90236893,15.3165825 4.90236893,14.6834175 5.29289322,14.2928932 L11.2928932,8.29289322 C11.6714722,7.91431428 12.2810586,7.90106866 12.6757246,8.26284586 L18.6757246,13.7628459 C19.0828436,14.1360383 19.1103465,14.7686056 18.7371541,15.1757246 C18.3639617,15.5828436 17.7313944,15.6103465 17.3242754,15.2371541 L12.0300757,10.3841378 L6.70710678,15.7071068 Z" fill="currentColor" fill-rule="nonzero" transform="translate(12.000003, 11.999999) rotate(-180.000000) translate(-12.000003, -11.999999)"></path>
                //                         </g>
                //                     </svg>
                //                 </span>
                //             </a>
                //             <!--begin::Menu-->
                //             <div class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-bold fs-7 w-125px py-4" data-kt-menu="true">
                //                 <!--begin::Menu item-->
                //                 <div class="menu-item px-3">
                //                     <a href="#" class="menu-link px-3" data-kt-docs-table-filter="edit_row">
                //                         Edit
                //                     </a>
                //                 </div>
                //                 <!--end::Menu item-->

                //                 <!--begin::Menu item-->
                //                 <div class="menu-item px-3">
                //                     <a href="#" class="menu-link px-3" data-kt-docs-table-filter="delete_row">
                //                         Delete
                //                     </a>
                //                 </div>
                //                 <!--end::Menu item-->
                //             </div>
                //             <!--end::Menu-->
                //         `;
                //     },
                // },
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
        // var filterAccount = $('[data-kt-user-table-filter="account_id"]');
        // var filterLevel = $('[data-kt-user-table-filter="level"]');
        // var DisplayNumber = document.querySelectorAll('[data-kt-user-table-filter="display_number"] [name="display_number"]');
        var DisplayNumber = $('[data-kt-user-table-filter="display_number"]'); 
        var DisplayName = $('[data-kt-user-table-filter="display_name"]'); 

        const filterButton = document.querySelector('[data-kt-user-table-filter="filter"]');

        // // Filter datatable on submit
        filterButton.addEventListener('click', function () {

            // const account= filterAccount.val();
            // const level= filterLevel.val();

            // let c="";
            // if(account != ""){
            //     c = c + "account=" + account + "&"
            // }
            // if(level != ""){
            //     c = c + "level=" + level + "&"
            // }
            // // DisplayNumber.checked
            // // o.forEach((t=>{t.checked&&(c=t.value),"all"===c&&(c="")}));
            // //const r=  account + level +" "+c;
            //dt.search(c).draw();
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
            

        //     // Get filter values
        //     let paymentValue = '';

        //     // Get payment value
        //     filterPayment.forEach(r => {
        //         if (r.checked) {
        //             paymentValue = r.value;
        //         }

        //         // Reset payment value if "All" is selected
        //         if (paymentValue === 'all') {
        //             paymentValue = '';
        //         }
        //     });

        //     // Filter datatable --- official docs reference: https://datatables.net/reference/api/search()
        //     dt.search(paymentValue).draw();
        });

        document.querySelector('[data-kt-user-table-filter="reset"]').addEventListener("click",(function(){
            document.querySelector('[data-kt-user-table-filter="form"]').querySelectorAll("select").forEach((e=>{$(e).val("").trigger("change")})),
            dt.search("").draw();
            n.hide();
        }));
    }
    // Reset Filter
    var handleResetForm = () => {
        // // Select reset button
        // const resetButton = document.querySelector('[data-kt-user-table-filter="reset"]');

        // // Reset datatable
        // resetButton.addEventListener('click', function () {
        //     // Reset payment type
        //     filterPayment[0].checked = true;

        //     // Reset datatable --- official docs reference: https://datatables.net/reference/api/search()
        //     dt.search('').draw();
        // });
    }

    // Init toggle toolbar
    var initToggleToolbar = function () {
        // Toggle selected action toolbar
        // Select all checkboxes
        const container = document.querySelector('#draw_trial_balance');
        //const checkboxes = container.querySelectorAll('[type="checkbox"]');
    }

    // Toggle toolbars
    var toggleToolbars = function () {
        // Define variables
        const container = document.querySelector('#draw_trial_balance');
        const toolbarBase = document.querySelector('[data-kt-user-table-toolbar="base"]');
        const toolbarSelected = document.querySelector('[data-kt-user-table-toolbar="selected"]');
        const selectedCount = document.querySelector('[data-kt-user-table-select="selected_count"]');

        // // Select refreshed checkbox DOM elements
        // const allCheckboxes = container.querySelectorAll('tbody [type="checkbox"]');

        // // Detect checkboxes state & count
        // let checkedState = false;
        // let count = 0;

        // // Count checked boxes
        // allCheckboxes.forEach(c => {
        //     if (c.checked) {
        //         checkedState = true;
        //         count++;
        //     }
        // });

        // // Toggle toolbars
        // if (checkedState) {
        //     selectedCount.innerHTML = count;
        //     toolbarBase.classList.add('d-none');
        //     toolbarSelected.classList.remove('d-none');
        // } else {
        //     toolbarBase.classList.remove('d-none');
        //     toolbarSelected.classList.add('d-none');
        // }
    }


    // Filter Datatable
    var handleExportDatatable = () => {
        var i,o,a,t,e,n;
        (i=document.querySelector("#kt_modal_export"))&&
            (
                o=new bootstrap.Modal(i),
                a=document.querySelector("#kt_modal_export_form"),
                t=document.getElementById("kt_modal_export_submit"),
                e=document.getElementById("kt_modal_export_cancel"),
                n=FormValidation.formValidation(a,{
                    fields:{
                        file_format:{
                            validators:{
                                notEmpty:{
                                    message:"نوع الملف مطلوب"
                                }
                            }
                        },
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
                        var elements = new FormData($('#kt_modal_export_form')[0]);
                        
                        var export_form = $('#kt_modal_export_form');
                        export_form.append('<input type="hidden" name="account_id" value="'+$('[data-kt-user-table-filter="account_id"]').val()+'" />');
                        export_form.append('<input type="hidden" name="currency_id" value="'+$('[data-kt-user-table-filter="currency_id"]').val()+'" />');
                        export_form.append('<input type="hidden" name="level" value="'+$('[data-kt-user-table-filter="level"]').val()+'" />');
                        export_form.append('<input type="hidden" name="from_date" value="'+$('[data-kt-user-table-filter="from_date"]').val()+'" />');
                        export_form.append('<input type="hidden" name="to_date" value="'+$('[data-kt-user-table-filter="to_date"]').val()+'" />');
                        export_form.append('<input type="hidden" name="main_accounts" value="'+$('[data-kt-user-table-filter="main_accounts"]').is(":checked")+'" />');

                        // elements.append('account_id', $('[data-kt-user-table-filter="account_id"]').val());
                        // elements.append('currency_id', $('[data-kt-user-table-filter="currency_id"]').val());
                        // elements.append('level', $('[data-kt-user-table-filter="level"]').val());
                        // elements.append('from_date', $('[data-kt-user-table-filter="from_date"]').val());
                        // elements.append('to_date', $('[data-kt-user-table-filter="to_date"]').val());
                        // elements.append('main_accounts', $('[data-kt-user-table-filter="main_accounts"]').is(":checked"));
                        // console.log("validated!"),
                        "Valid"==e?(
                            $('#kt_modal_export_form').submit()
                            // $.ajax({
                            //     type: "POST",
                            //     url: "/export_trial_balance",
                            //     data: elements,
                            //     //async: false,
                            //     cache: false,
                            //     contentType: false,
                            //     processData: false,
                            //     dataType: "JSON",
                            //     beforeSend: function (xhr) {
                            //         xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
                            //         t.setAttribute("data-kt-indicator","on");
                            //         t.disabled=!0;
                            //     },
                            //     complete: function () {
                                    
                            //     },
                            //     success: function (response)
                            //     {
                            //         if (response !== null && response.hasOwnProperty("Errors")) {
                            //             //console.log(response['Errors']);
                            //             var obj = response["Errors"];
                            //             var stringerror = '';
                            //             for (var prop in obj) {
                            //                 stringerror += '* ' + obj[prop] + '</br>';
                            //             }
                            //             Swal.fire({
                            //                 text:stringerror,
                            //                 icon:"error",buttonsStyling:!1,
                            //                 confirmButtonText: window.I18n['ok_got_it'],
                            //                 customClass:{
                            //                     confirmButton:"btn btn-primary"
                            //                 }
                            //             });
                            //         } else if (response !== null && response.hasOwnProperty("Success")) {
                            //             var msg = response["result"];
                            //             t.removeAttribute("data-kt-indicator"),
                            //             t.disabled=!1,
                            //             Swal.fire({
                            //                 text:"Done",
                            //                 icon:"success",
                            //                 buttonsStyling:!1,
                            //                 confirmButtonText: window.I18n['ok_got_it'],
                            //                 customClass:{
                            //                     confirmButton:"btn btn-primary"
                            //                 }
                            //             }).then((function(e){
                            //                 t.isConfirmed&&
                            //                 o.hide(),
                            //                 url_redirect({url: "/export_pdf",
                            //                     method: "get",
                            //                     data: {"accounts":msg}
                            //                 });
                            //             }))
                            //         }
                            //     }
                            // }) 
                        )
                        :Swal.fire({
                            text:"حذث خطأ ما",
                            icon:"error",
                            buttonsStyling:!1,
                            confirmButtonText:"حسنا",
                            customClass:{
                                confirmButton:"btn btn-primary"
                            }
                        })
                    }))
                }))
            )

    }

    // Public methods
    return {
        init: function () {
            initDatatable();
            handleSearchDatatable();
            initToggleToolbar();
            handleFilterDatatable();
            handleResetForm();
            handleExportDatatable();
        }
    }
}();

// On document ready
KTUtil.onDOMContentLoaded(function () {
    KTDatatablesServerSide.init();
});