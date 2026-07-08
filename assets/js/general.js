jQuery(window).load(function() {      
  //
  // Add a class so we know JavaScript is supported
  //
  jQuery('html').addClass("js").removeClass("no-js");
  
  
});


jQuery(document).ready(function () {

	//
	// Swap retina logo
	//
	$logo = jQuery('img.logo');
	$logoSrc = $logo.attr("src");
	$logoRetina = $logo.attr("data-fullsrc");
	if( window.devicePixelRatio >= 1.5 ){
	   $logo.attr("src" , $logoRetina);
	}
	
	//
	// Mobile / Tablet menu
	//
	if ( jQuery('html').not("oldie") ) {
		jQuery('header nav').meanmenu({meanScreenWidth: "960", meanMenuOpen: '<span class="mean-title">Menu</span> <span class="bar" /><span class="bar" /><span class="bar" />', meanMenuClose: '<span class="mean-title">Close</span> <span class="bar" /><span class="bar" /><span class="bar" />'});
	}
	
	//
	// Placeholder support
	//
	if ( (jQuery('html').hasClass("oldie")) || (jQuery('html').hasClass("ie9")) ) {
	        jQuery('[placeholder]').focus(function () {
	        var input = jQuery(this);
	        if (input.val() == input.attr('placeholder')) {
	            input.val('');
	            input.removeClass('placeholder');
	        }
	    }).blur(function () {
	        var input = jQuery(this);
	        if (input.val() == '' || input.val() == input.attr('placeholder')) {
	            input.addClass('placeholder');
	            input.val(input.attr('placeholder'));
	        }
	    }).blur().parents('form').submit(function () {
	        jQuery(this).find('[placeholder]').each(function () {
	            var input = $(this);
	            if (input.val() == input.attr('placeholder')) {
	                input.val('');
	            }
	        })
	    });
	}
	
});