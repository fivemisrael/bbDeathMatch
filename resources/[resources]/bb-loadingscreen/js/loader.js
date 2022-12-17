$(window).on("load", startIntro);
function startIntro() {
    var audio = new Audio("audio/sa.ogg");
    audio.addEventListener('ended', function() {
        this.currentTime = 0;
        this.play();
        this.volume = 0.15;
    }, false);
    audio.play();
    audio.volume = 0.15;
    $("#preloads").css("visibility", "hidden");
    $("#loading").css("visibility", "hidden");
    showIntro(true, "Realistic Life Presents");
    setTimeout(showLoadbar, 0, false);
    setTimeout(showIntro, 7000, false, "");
    setTimeout(showLogo, 9500, true);
    setTimeout(showLogo, 13000, false);
    setTimeout(doMask, 14500, 1);
    setTimeout(doMask, 19400, 2);
    setTimeout(doMask, 24400, 3);
    setTimeout(doMask, 29300, 4);
    setTimeout(showIntro, 34500, true, "Sit tight while things are warming up... Don't worry, you'll get there, yeah?");
    setTimeout(showIntro2, 34500, true, "\"I'll have two number nines, a number nine large. A number six with extra dip. A number seven. Two number forty-fives, one with cheese, and a large soda\" - Big Smoke (BS)");
    setTimeout(showLoadbar, 34500, true);
}


function showLoadbar(status) {
    switch(status) {
        case true:
            $("#loadingbar").show();
            break;
        case false:
            $("#loadingbar").hide();
            break;
    }
}

function showIntro(status, text) {
    switch(status) {
        case true:
            $("#text").css("color", "lightgrey");
            $("#text").text(text);
            break;
        case false:
            $("#text").css("color", "rgba(0,0,0,0)");
            break;
    }
}

function showIntro2(status, text) {
    switch(status) {
        case true:
            $("#text2").text(text);
            $("#text2").css("color", "lightgrey");
            break;
        case false:
            $("#text2").css("color", "rgba(0,0,0,0)");
            break;
    }
}

function showLogo(status) {
    switch(status) {
        case true:
            $("#blackout").css("transition-duration", "0.8s");
            $("#logo").css("background-image", "url('img/logos/casual-rp.png')");
            break;
        case false:
            $("#blackout").css("background-color", "rgba(0,0,0,1)");
            setTimeout(function() {
                $("#logo").css("background-image", "");
                $("first-message").css("visibility", "hidden");
            }, 800);
            break;
    }
}

function doMask(count) {
    switch(count) {
        case 1:
            $("#credit-a").html("<h1>Founders</h1><p>Ricko</p><p>Praise</p>");
            $("#credit-a").css("margin", "-220px 0px 0px 160px");
            $("#credit-a").css("text-align", "left");
            /*
			$("#credit-b").html("<h1>Server Manager</h1><p>barbaroNN</p>");
            $("#credit-b").css("margin", "-450px 0px 0px -100px");
            $("#credit-b").css("text-align", "right");*/
            break;
        case 2:
            $("#credit-a").html("<h1>Community Managment</h1><p>Senor</p><p>barbaroNN</p>");
            $("#credit-a").css("margin", "-450px 0px 0px -100px");
            $("#credit-a").css("text-align", "left");
            $("#credit-b").html("<h1>Community Inspector</h1><p>BM</p>");
            $("#credit-b").css("margin", "170px 0px 0px -360px");
            $("#credit-b").css("text-align", "left");
            break;
        case 3:
            $("#credit-a").html("<h1>Main Developer</h1><p>barbaroNN</p>");
            $("#credit-a").css("margin", "-450px 0px 0px -100px");
            $("#credit-a").css("text-align", "right");
            /*
            $("#credit-b").html("<h1>Public Manager</h1><p>Leibo | Sagi</p>");
            $("#credit-b").css("margin", "210px 0px 0px -70px");
            $("#credit-b").css("text-align", "right");/*
            $("#credit-c").html("<h1>Lua Scripters</h1><p>barbaroNN</p>");
            $("#credit-c").css("margin", "-150px 0px 0px -470px");
            $("#credit-c").css("text-align", "right");*/
            break;
        case 4:
            $("#credit-a").html("<h1>Framework</h1><p>Remade ESX</p>");
            $("#credit-a").css("margin", "-390px 0px 0px 75px");
            $("#credit-a").css("text-align", "left");
            $("#credit-b").html("<h1>Discord</h1><p>https://discord.gg/jaJGj92</p>");
            $("#credit-b").css("margin", "170px 0px 0px -160px");
            $("#credit-b").css("text-align", "left");
            $("#credit-c").html("<h1>Community Site</h1><p>www.Realistic-Life.co.il</p>");
            $("#credit-c").css("margin", "-150px 0px 0px -0px");
            $("#credit-c").css("text-align", "left");
            setTimeout(function() {
                $("#blackout").css("background-color", "rgba(0,0,0,0)");
            }, 800);
            break;
    } 
    $("#background").css("visibility", "visible");
    $("#mask").css("visibility", "visible");
    $("#blackout").css("background-color", "rgba(0,0,0,0)");
    setTimeout(function() {
        $("#blackout").css("transition-duration", "0.8s");
    }, 800);
    $("#mask").css("background-image", "url('img/masks/"+count+"-1.png");
    $("#background").css("background-image", "url('img/backgrounds/"+count+".jpg");
    setTimeout(function() {
        $("#mask").css("background-image", "url('img/masks/"+count+"-2.png");
    }, 300);
    setTimeout(function() {
        $("#mask").css("background-image", "url('img/masks/"+count+"-3.png");
    }, 600);
    setTimeout(function() {
        $("#mask").css("background-image", "url('img/masks/"+count+"-4.png");
    }, 900);
    setTimeout(function() {
        $("#credit-a").css("visibility", "visible");
        $("#credit-b").css("visibility", "visible");
        $("#credit-c").css("visibility", "visible");
    }, 1300);
    setTimeout(function() {
        $("#blackout").css("background-color", "rgba(0,0,0,1)");
        setTimeout(function() {
            $("#blackout").css("transition-duration", "0s");
            $("#credit-a").css("visibility", "hidden");
            $("#credit-b").css("visibility", "hidden");
            $("#credit-c").css("visibility", "hidden");
        }, 800);
    }, 4000);
}