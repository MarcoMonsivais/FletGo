<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="driver.aspx.cs" Inherits="FletGoWeb.driver" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" />
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	
	<title>FletGo - Socios</title>
	
	<link href='https://fonts.googleapis.com/css?family=Open+Sans:300,400,800,600|Raleway:300,600,900' rel='stylesheet' type='text/css'>

	<link rel='stylesheet' id='default'  href='files/css/style.css' type='text/css' media='all' />
	<link rel='stylesheet' id='flexslider'  href='files/css/flexslider.css' type='text/css' media='all' />
	<link rel='stylesheet' id='easyopener'  href='files/css/easy-opener.css' type='text/css' media='all' />
	<link rel='stylesheet' id='jplayer'  href='files/jplayer/jplayer.css' type='text/css' media='all' />
	<link rel='stylesheet' id='isotope'  href='files/css/isotope.css' type='text/css' media='all' />
	<link rel="stylesheet" id='rsplugin' href="files/rs-plugin/css/settings.css" type="text/css" media="all" />
	<link rel="stylesheet" id='fontawesome' href="files/css/font-awesome.min.css" type="text/css" media="all" />
	<link rel='stylesheet' id='retina'  href='files/css/retina.css' type='text/css' media='all' />
	<link rel='stylesheet' id='mqueries'  href='files/css/mqueries.css' type='text/css' media='all' />
	<link rel="shortcut icon" href="files/images/logo.png"/>
	<link rel="stylesheet" type="text/css" href="css/normalize.min.css" media="screen, print" />
	<link rel="stylesheet" type="text/css" href="css/smartslider.min.css" media="screen, print" />
	
	<script type="text/javascript" src="js/n2-j.min.js"></script>
	<script type="text/javascript" src="js/smartslider-frontend.min.js"></script>
	<script type="text/javascript" src="js/smartslider-simple-type-frontend.min.js"></script>
	<script src="files/js/jquery-1.9.1.min.js"></script>
	<script src='files/js/jquery.modernizr.min.js'></script>

	<script src="firebase/firebase-app.js"></script>
	<script src="firebase/firebase-database.js"></script>
<!--	
	<script src="https://www.gstatic.com/firebasejs/5.0.1/firebase-app.js"></script>
	<script src="https://www.gstatic.com/firebasejs/5.0.1/firebase-database.js"></script>
	<script src="https://www.gstatic.com/firebasejs/8.0.1/firebase-analytics.js"></script>-->

	<script type="text/javascript" src="js/firebase_cnn.js"></script>
	<script type="text/javascript" scr="js/df_conf.js"></script>

	<script type="text/javascript">(function () { var N = this; N.N2_ = N.N2_ || { r: [], d: [] }, N.N2R = N.N2R || function () { N.N2_.r.push(arguments) }, N.N2D = N.N2D || function () { N.N2_.d.push(arguments) } }).call(window); if (!window.n2jQuery) { window.n2jQuery = { ready: function (cb) { console.error('n2jQuery will be deprecated!'); N2R(['$'], cb); } } } window.nextend = { localization: {}, ready: function (cb) { console.error('nextend.ready will be deprecated!'); N2R('documentReady', function ($) { cb.call(window, $) }) } };</script>
	
</head>
<body>
    <%--<form id="form1" runat="server">
        <div>
        </div>
    </form>--%>

    <div id="page-loader">
	<div class="page-loader-inner">
    	<div class="loader-logo"><img src="files/images/logo.png" alt="Logo"/></div>
		<div class="loader-icon"><span class="spinner"></span><span></span></div>
	</div>
</div>
<div id="page-content" class="fixed-header">
	<header id="header">        
		<div class="header-inner wrapper clearfix">
                            
			<div id="logo" class="left-float">
				<a id="defaut-logo" class="logotype" href="index.html"><img src="files/logo/FLETGO_LOGO_negro1.png" alt="Logo"></a>
			</div>    
            
			<div class="menu right-float clearfix">
           		<nav id="main-nav">
            		<ul>
                  	<li class="current-menu-item"><a href="index.html#home" class="scroll-to">Inicio</a></li>
                  	<li><a href="index.html#about" class="scroll-to">Acerca</a></li>
                  	<li><a href="index.html#service" class="scroll-to">Ventajas</a></li>
                  	<li><a href="index.html#team" class="scroll-to">Tu Destino</a></li>
                  	<li><a href="#" class="scroll-to">Hazte Socio</a></li>
					</ul>
				</nav>
              	<nav id="menu-controls">
            		<ul>
                  	<li class="current-menu-item"><a href="#home" class="scroll-to"><span class="c-dot"></span><span class="c-name">Inicio</span></a></li>
                  	<li><a href="#about" class="scroll-to"><span class="c-dot"></span><span class="c-name">Acerca</span></a></li>
                  	<li><a href="#service" class="scroll-to"><span class="c-dot"></span><span class="c-name">Ventajas</span></a></li>
                  	<li><a href="#team" class="scroll-to"><span class="c-dot"></span><span class="c-name">Tu Destino</span></a></li>
                  	<li><a href="#" class="scroll-to"><span class="c-dot"></span><span class="c-name">Hazte Socio</span></a></li>
					</ul>
				</nav>  
			</div>
		</div> 
	</header>
       <section id="contact">
            <div class="section-inner wrapper" style="padding: 110px 0 20px 0">
             	
            	<div class="column-section clearfix">
                	                  
                	<div class="column one-half sr-animation sr-animation-fromleft" data-delay="200">
						<img src="files/images/imagen_flete.png" alt="IMAGENAME" style="display: block;margin-left: auto;margin-right: auto;width: 70%;" />
					</div>
					
					<div class="column one-half last-col"> 
						<h3 class="subtitle">Conviertete en un <br>socio <span style="color:#FF2400;"><b>FletGo</b></span></h3>
                 		<form id="contact-form" class="checkform" method="post" >
                      	
                        	<div class="form-row clearfix">
                            	<div class="form-value"><input type="text" name="name" class="name" id="name" placeholder="Nombre Completo" /></div>
                        	</div>
                                                        
							<div class="form-row clearfix">
                               	<div class="form-value"><input type="text" name="tel" class="tel" id="tel" placeholder="Número Telefónico"/></div>
                        	</div>
							
							<div class="form-row clearfix">
                            	<div class="form-value"><input type="text" name="email" class="email" id="email" placeholder="Correo Electrónico*" /></div>
                        	</div>
							
							<small>*Campos obligatorios</small>
							
							<p style="font-size:12px">Al continuar, acepto los <a href="" style="text-decoration: underline">Términos de uso</a> de <b>FletGo</b> y reconozco que leí la <a href="" style="text-decoration: underline">Política de privacidad</a>.<br>

							Acepto que <b>FletGo</b> o sus representantes pueden ponerse en contacto conmigo vía correo electrónico, teléfono o SMS a la dirección de correo electrónico o al número que yo indique, incluso, para fines de privacidad.</p>
                        	
							<div id="form-note">
								<div class="alert alert-error">
									<h6><strong>Error</strong>: Please check your entries!</h6>
								</div>
							</div>
                            
                        	<div class="form-row form-submit">
                            	<input type="submit" name="submit_form" id="submit_form" class="submit" value="Enviar" onclick="enviar()" />
                        	</div>
                        
                   	</form> 
				  
                	</div>	
            	</div>
				
			<div class="spacerxspacer-big"></div>
			
			</div>       
        
 	</div> 
	
</div> 

<script type='text/javascript' src='files/js/retina.js'></script>
<script type='text/javascript' src='files/js/jquery.easing.1.3.js'></script>
<script type='text/javascript' src='files/js/jquery.easing.compatibility.js'></script>
<script type='text/javascript' src='files/js/jquery.visible.min.js'></script>
<script type='text/javascript' src='files/js/jquery.easy-opener.min.js'></script>
<script type='text/javascript' src='files/js/jquery.flexslider.min.js'></script>
<script type='text/javascript' src='files/js/jquery.isotope.min.js'></script>
<script type='text/javascript' src='files/js/jquery.bgvideo.min.js'></script>
<script type='text/javascript' src='files/js/jquery.fitvids.min.js'></script>
<script type='text/javascript' src='files/jplayer/jquery.jplayer.min.js'></script>
<script type="text/javascript" src="files/rs-plugin/js/jquery.themepunch.plugins.min.js"></script>
<script type="text/javascript" src="files/rs-plugin/js/jquery.themepunch.revolution.min.js"></script>
<script type='text/javascript' src='files/js/jquery.parallax.min.js'></script>
<script type='text/javascript' src='files/js/jquery.counter.min.js'></script>
<script type='text/javascript' src='files/js/jquery.scroll.min.js'></script>
<script type='text/javascript' src='files/js/xone-header.js'></script>
<script type='text/javascript' src='files/js/xone-loader.js'></script>
<script type='text/javascript' src='files/js/xone-form.js'></script>
<script type='text/javascript' src='files/js/script.js'></script>


</body>
</html>
