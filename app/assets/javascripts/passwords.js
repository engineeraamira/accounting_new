"use strict";

// Class Definition
var KTAuthResetPassword = function() {
    // Elements
    var form,email;
    var submitButton;
	var validator;

    var handleForm = function(e) {
        // Init form validation rules. For more info check the FormValidation plugin's official documentation:https://formvalidation.io/
        validator = FormValidation.formValidation(
			form,
			{
				fields: {					
					'email': {
                        validators: {
                            regexp: {
                                regexp: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
                                message: 'البريد الإلكتروني غير مقبول',
                            },
							notEmpty: {
								message: 'البريد الإلكتروني مطلوب'
							}
						}
					} 
				},
				plugins: {
					trigger: new FormValidation.plugins.Trigger(),
					bootstrap: new FormValidation.plugins.Bootstrap5({
                        rowSelector: '.fv-row',
						eleInvalidClass: '',  // comment to enable invalid state icons
                        eleValidClass: '' // comment to enable valid state icons
                    })
				}
			}
		);		

        submitButton.addEventListener('click', function (e) {
            e.preventDefault();

            // Validate form
            validator.validate().then(function (status) {
                if (status == 'Valid') {
                    email =  form.querySelector('[name="email"]').value,
                    $.ajax({
                        type:'POST',
                        url: '/passwords',
                        data:JSON.stringify({email:email}),
                        contentType: "application/json",
                        dataType: "JSON",
                        beforeSend: function(xhr) {
                            xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')),
                            // Hide loading indication
                            submitButton.setAttribute('data-kt-indicator', 'on');
                            // Enable button
                            submitButton.disabled = true;
                        },
                        complete: function () {
                            // Hide loading indication
                            submitButton.removeAttribute('data-kt-indicator');
                            // Enable button
                            submitButton.disabled = false;
                        },
                        success: function(data){
                            if(data.status == null || data.status == false ){                   
                                swal.fire({
                                    text: data.msg,
                                    icon: "error",
                                    buttonsStyling: false,
                                    confirmButtonText: "Ok, got it!",
                                    customClass: {
                                        confirmButton: "btn font-weight-bold btn-light-primary"
                                    }
                                }) 
                            }else{
                                swal.fire({
                                    text: data.msg,
                                    icon: "success",
                                    buttonsStyling: false,
                                    confirmButtonText: "Ok, got it!",
                                    customClass: {
                                        confirmButton: "btn font-weight-bold btn-light-primary"
                                    }
                                }).then(function(e) {
                                    if (e.isConfirmed) { 
                                        // form.querySelector('[name="email"]').value="";
                                        // const redirectUrl = form.getAttribute('data-kt-redirect-url');
                                        // if (redirectUrl) {
                                        //     location.href = redirectUrl;
                                        // }
                                    }
                                });
                            }
                        }
                    })                     						
                } else {
                    // Show error popup. For more info check the plugin's official documentation: https://sweetalert2.github.io/
                    Swal.fire({
                        text: "Sorry, looks like there are some errors detected, please try again.",
                        icon: "error",
                        buttonsStyling: false,
                        confirmButtonText: "Ok, got it!",
                        customClass: {
                            confirmButton: "btn btn-primary"
                        }
                    });
                }
            });  
		});
    }

    // Public Functions
    return {
        // public functions
        init: function() {
            form = document.querySelector('#kt_password_reset_form');
            submitButton = document.querySelector('#kt_password_reset_submit');

            handleForm();
        }
    };
}();

// On document ready
KTUtil.onDOMContentLoaded(function() {
    KTAuthResetPassword.init();
});
