$.extend(
{
	redirectPost: function(location, args)
	{
		var form = '';
		$.each( args, function( key, value ) {
			form += '<input type="hidden" name="'+key+'" value="'+value+'">';
		});
		$('<form action="'+location+'" method="POST">'+form+'</form>').submit();
	}
});

$(document).ready(function() {
	
	 if( $(document).width() <=768 ) 
	 	$(".home").removeClass("nav-open");
	
	 $("#dropLogin").click(function(e) {
   	if( $(".dd-bar__navigation .dropdown").hasClass("open") ) {
			$(".dd-bar__navigation .dropdown").removeClass("open");
			$("li.dropdown").removeClass("open");
		} else {
			$(".dd-bar__navigation .dropdown").addClass("open");
			$("li.dropdown").addClass("open");
		}
   }); 
	
	 $('.dropdown_login_field').focus(function() {
		$('#dropdown_login_title').html('Bunch Account');
		$('#dropdown_login_title').removeClass( "red" ).removeClass( "green" );
	 });
	 
	 $('#dropdown_login').click(function() {
		var pattern =/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
		if(!pattern.test($('#dropdown_login_email').val()) )  //Invalid Email Address
		{
			alert ( "Invalid Email address");
			return;
		}
		
		$('#dropdown_login_title').html('Attempting login...');
		$.ajax({
		   dataType: "json",
		   url: baseURL+"api/login.php",
		   data: $('#dropdown_login_form').serialize(),
		   type: 'POST',
		}).done(function ( data ) {

			if( data["response"] == "error" ){ // Login Failure
				$('#dropdown_login_title').html('Bad Email/Password');
			} else if( data["response"] == "success" ) { // Login Success					
				location.href = baseURL + "documents";
			} else if( data["response"] == "inactivated" )
				location.href = baseURL + "register/update/" + data["url"];
			else
				location.href = baseURL + "register/verify";
		});
	 });

	 //$("#dashboard_menu").before('<span class="mobile_burger fa fa-navicon" onclick="toggleMenu();"></span>');
	 if( $(".container .clearfix .pull-right ol li").length)
		 $(".container .clearfix .pull-right ol li").append('<span class="mobile_burger fa fa-navicon" onclick="toggleMenu();"></span>');	
	 else
	  	 $(".container .clearfix .pull-right ol").append('<li><span class="mobile_burger fa fa-navicon" onclick="toggleMenu();"></span></li>');
		 
	$('.footable').footable({
		breakpoints: {
			phone: 320,
			tablet: 650
		}
	});
	
	//Drop Down Menu
});

function toggleMenu()
{
	cnt = 0;
	$('#dashboard_menu').closest('div').children("ul").slideToggle(200,"", function(){		
		if( cnt == 1) fitToWindowSize();
		cnt++;
	});
	
	if( $("#document_menu").length ){
		$('#document_menu').closest('div').children("ul").slideToggle(200,"", function(){		
			if( cnt == 1) fitToWindowSize();
			cnt++;
		});
	}
}


function alert(msg, fn){
	$('#alert-info').html(msg);								
	$('#alert_modal').modal("show");

	$('#alert_modal_dismiss').click( function(e){
		$('#alert_modal').modal("hide");
		if(fn) fn();
	});			
}
		
function forgotPassword(type){
	if( type == 0 ) //Header login
		email = $('#dropdown_login_email').val();
	else //Body login
		email = $('#Email').val();
	
	var pattern =/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
	if(!pattern.test(email) )  //Invalid Email Address
	{
		alert ( "Invalid Email address");
		return;
	}

	$.post( baseURL + "api/forgot.php", {email: email}, function(data){
		console.log(data);
		data = eval( '(' + data + ')' );
		if( data.response == "success" ){
			alert( "Password reset link has been sent to your email" );
		} else {
			alert( "Error occured, please try again" );
		}
	});
}

function logout()
{
	$.post( baseURL + "api/logout.php", null, function(data){
		location.href = baseURL;
	});
}