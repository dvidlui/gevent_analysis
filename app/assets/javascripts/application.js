// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require jquery.remotipart
//= require bootstrap
//= require bootstrap-datepicker

//= require parsley
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
//= require dataTables/extras/dataTables.responsive

//= require spin

//= require trialplace/footable
//= require trialplace/main.min
//= require trialplace/theme.main.min
//= require trialplace/header

window.MyApp = {}

var spin_it = function(target) {
  var opts = {
    lines: 13,              // The number of lines to draw
    length: 7,              // The length of each line
    width: 4,               // The line thickness
    radius: 10,             // The radius of the inner circle
    corners: 1,             // Corner roundness (0..1)
    rotate: 0,              // The rotation offset
    color: "#000",          // #rgb or #rrggbb
    speed: 1,               // Rounds per second
    trail: 60,              // Afterglow percentage
    shadow: false,          // Whether to render a shadow
    hwaccel: false,         // Whether to use hardware acceleration
    className: "spinner",   // The CSS class to assign to the spinner
    zIndex: 2e9,            // The z-index (defaults to 2000000000)
    top: "10%",             // Top position relative to parent in px
    left: "50%"             // Left position relative to parent in px
  }

  var spinner = new Spinner(opts)
  spinner.spin(target[0])
}

MyApp.spinner = function(target, event_target, evt) {
  target = $(target)
  event_target = $(event_target)

  event_target.on(evt, function(e) {
    spin_it(target)
  })
}

// Add custom exists function to jQuery for checking an element exists
jQuery.fn.exists = function() {return this.length>0;}

// Login part
var ready
ready = (function() {

  // Spinner settup
  new MyApp.spinner($("#right_main_content"), $(".event-button"), "click")
  
  // add spinner to dialog box
  $("body").on("click", "#data_modal .btn-primary", function() {
    if ($(".parsley-form").is("form") && $(".parsley-form").parsley().isValid()) {
      spin_it($("#data_modal"))
    }
  })

  // left side clicking
  $("body").on("click", ".event-button", function() {
    ul = $(".event-button").parent().parent()
    ul.find("li").removeClass("active")
    if ($(this).attr("id") == "back") { // for back buttons
      $(this).parent().addClass("active")
      return
    }
    url = $(this).data("url")
    label = $(this).html().replace($(this).find("i").clone().wrap('<div>').parent().html(), "")
    $.ajax({
      type: "GET",
      url: url
    }).success(function(data) {
      if ($("div.left-side input#trial_id").length) {
        if (label == "Trial Details") org_text = $("div.left-side input#trial_id").val()
        else org_text = $("div.left-side input#site_id").val()
      } else {
        org_text = $("#breadcrumbs li").last().data("root-label")
      }
      $("#breadcrumbs li").last().html(org_text + ":" + label)
      $("#breadcrumbs_xs label.caption").html(org_text + ":" + label)
      $("#right_main_content").html(data)
      
      positionFooter()
    }).fail(function(data) {
      location.href = "/authorization"
    })
    $(this).parent().addClass("active")
  })
  
  $("body").on("click", ".profile-buttn", function() {
    url = $(this).data("url")
    label = $(this).html()
    $.ajax({
      type: "GET",
      url: url
    }).success(function( data ) {
      org_text = $("#breadcrumbs li").last().data("root-label")
      $("#breadcrumbs li").last().html("Dashboard: Profile")
      $("#right_main_content").html(data)
    }).fail(function(data) {
      location.href = "/authorization"
    })
    $(this).parent().addClass("active")
  })

  $("#dropdown_login_form").submit(function(data){
    $("#dropdown_login_title").text("Attempting login...")
    $.ajax({
      url: $("#dropdown_login_form").attr("action"),
      type: "post",
      dataType: "json",
      data: $("#dropdown_login_form").serialize()
    }).success(function() {
        location.href = "/dashboard"
        return true
      }).fail(function(data){
        results = data.responseJSON
        if(results.failure){
          $("#dropdown_login_title").text(results.failure)
        } else {
          $("#dropdown_login_title").text("Bad Email or Password")
        }
      })
    return false
  })
  
  // home page sigin form event  
  $("#sign_in_user").submit(function(data) {
    $("#form_login_status").removeClass("hidden")
    $("#form_login_status").html("Attempting login...")
    $.ajax({
      url: $("#sign_in_user").attr("action"),
      type: "post",
      dataType: "json",
      data: $("#sign_in_user").serialize()
    }).success(function() {
        location.href = "/dashboard"
        return true
      }).fail(function(data) {
        results = data.responseJSON
        if(results !== undefined && results.failure){
          $("#form_login_status").html(results.failure)
        }else{
          $("#form_login_status").html("Bad Email or Password")
        }
      })
    return false
  })
  
  $(".mobile_burger").click(function(){
    $("#nav__menu .nav-tabs").slideToggle()
  })
})

// footer and left side management
$(document).ready(ready)
$(document).on("page:load", ready)

function positionFooter() {
  var $body = $("html,body")
  $body.css({
    height: "inherit"
  })
  if (($(document.body).height()) < $(window).height()) {
    $body.css({
      height: "100%"
    })
  }else {
    $body.css({
      height: "inherit"
    })
  }
}

$(window).bind("load", function() {
  // complete back button url
  if ($("div#nav__menu a#back").exists()) {
    $("div#nav__menu a#back").attr("href", $("#breadcrumbs li a").last().attr("href"))
  }

  positionFooter()
  $(window).scroll(positionFooter).resize(positionFooter)               
})

// Updates yes/no switches
$(document).ready(function () {
  $("body").on("click", ".btn-toggle", function() {
    $(this).find(".btn").toggleClass("active")
    if ($(this).find(".btn-warning").size()>0) {
      $(this).find(".btn").toggleClass("btn-warning")
      $(this).find(".btn-warning").addClass("btn-success").removeClass("btn-warning")
    } else {
      $(this).find(".btn").toggleClass("btn-success")
      $(this).find(".btn-success").addClass("btn-warning").removeClass("btn-success")
    }
    
    active      = $(this).find(".active")
    status_id   = active.data("id")
    status      = active.data("status")
    object      = active.data("type")
    url         = $(this).data("update-url")
    $.ajax({
      type: "POST",
      url: url,
      data: { status_id:status_id, status:status, object:object }
    }).done(function( data ) {
      console.log(data)
    })

    $(this).find(".btn").toggleClass("btn-default")
  })
})