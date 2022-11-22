

// Account Statement
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
            ajax: {
                'url': "/draw_account_statement"
            },            
            columns: [
                { data: 'TranNo' },
                { data: 'description' },
                { data: 'debit' },
                { data: 'credit' },
                { data: 'balance' },
                { data: 'date' },
            ],
            columnDefs: [
                
            ],
            // Add data-filter attribute
            // createdRow: function (row, data, dataIndex) {
            //     $(row).find('td:eq(4)').attr('data-filter', data.CreditCardType);
            // }
        });

        table = dt.$;

        // Re-init functions on every table re-draw -- more info: https://datatables.net/reference/event/draw
        dt.on('draw', function () {
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
    // Public methods
    return {
        init: function () {
            initDatatable();
            handleSearchDatatable();
            handleFilterDatatable();
        }
    }
}();
//account statement

KTUtil.onDOMContentLoaded((function(){
    KTDatatablesServerSide.init();
}));